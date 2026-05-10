"""
Burn Rate Shield V15 — Guardião de Orçamento de IA
FastAPI middleware que impõe tecto de combustão (hard cap) nos custos de IA.

Regra §21.3 da Constituição Vanguard:
  Se Custo por Lead (Tokens + WABA) exceder o limite → graceful degradation
  para templates estáticos. O caixa da empresa está protegido.

Uso:
  from infra.burn_rate_shield import BurnRateShield, check_budget

  shield = BurnRateShield()
  shield.attach(app)  # Middleware FastAPI
"""

import os
import logging
from datetime import date, datetime
from typing import Optional
from dataclasses import dataclass, field

# ─── Configuração via variáveis de ambiente ───────────────────────────────────
DAILY_BUDGET_EUR    = float(os.getenv('DAILY_AI_BUDGET_EUR',  '8.00'))   # tecto diário total
MAX_CPL_EUR         = float(os.getenv('MAX_COST_PER_LEAD_EUR', '0.30'))  # custo máx por lead
ALERT_THRESHOLD_PCT = float(os.getenv('BUDGET_ALERT_PCT',      '0.75'))  # alerta a 75% do orçamento
FALLBACK_MODE       = os.getenv('BUDGET_FALLBACK_MODE', 'static')        # 'static' | 'haiku' | 'error'

# ─── Preços dos modelos (USD/M tokens → convertido para EUR) ──────────────────
MODEL_COSTS = {
    'claude-opus-4-7':         {'input': 15.00, 'output': 75.00},
    'claude-sonnet-4-6':       {'input':  3.00, 'output': 15.00},
    'claude-haiku-4-5':        {'input':  0.25, 'output':  1.25},
    'gpt-4o':                  {'input':  2.50, 'output': 10.00},
    'gpt-3.5-turbo':           {'input':  0.50, 'output':  1.50},
}
USD_TO_EUR = 0.93

# ─── Tracker de Custos ────────────────────────────────────────────────────────
@dataclass
class DailyCostTracker:
    date_str:      str   = field(default_factory=lambda: str(date.today()))
    total_eur:     float = 0.0
    leads_count:   int   = 0
    claude_eur:    float = 0.0
    waba_eur:      float = 0.0
    vapi_eur:      float = 0.0
    degraded_count: int  = 0  # vezes que activou fallback

    def reset_if_new_day(self):
        today = str(date.today())
        if self.date_str != today:
            logging.info(f'[BurnRateShield] Novo dia — reset de orçamento. Ontem: €{self.total_eur:.4f}')
            self.date_str       = today
            self.total_eur      = 0.0
            self.leads_count    = 0
            self.claude_eur     = 0.0
            self.waba_eur       = 0.0
            self.vapi_eur       = 0.0
            self.degraded_count = 0

    def add_claude(self, input_tokens: int, output_tokens: int, model: str = 'claude-sonnet-4-6'):
        self.reset_if_new_day()
        rates = MODEL_COSTS.get(model, MODEL_COSTS['claude-sonnet-4-6'])
        cost_usd = (input_tokens / 1_000_000 * rates['input']) + (output_tokens / 1_000_000 * rates['output'])
        cost_eur = cost_usd * USD_TO_EUR
        self.claude_eur += cost_eur
        self.total_eur  += cost_eur
        self.leads_count += 1
        return cost_eur

    def add_waba(self, messages: int = 1, price_per_msg_eur: float = 0.0588):
        self.reset_if_new_day()
        cost = messages * price_per_msg_eur * USD_TO_EUR
        self.waba_eur  += cost
        self.total_eur += cost
        return cost

    def add_vapi(self, minutes: float = 4.0, price_per_min_usd: float = 0.05):
        self.reset_if_new_day()
        cost = minutes * price_per_min_usd * USD_TO_EUR
        self.vapi_eur  += cost
        self.total_eur += cost
        return cost

    def avg_cost_per_lead(self) -> float:
        return self.total_eur / max(1, self.leads_count)

    def budget_remaining(self) -> float:
        self.reset_if_new_day()
        return max(0.0, DAILY_BUDGET_EUR - self.total_eur)

    def is_budget_exceeded(self) -> bool:
        self.reset_if_new_day()
        return self.total_eur >= DAILY_BUDGET_EUR

    def is_cpl_exceeded(self) -> bool:
        return self.avg_cost_per_lead() >= MAX_CPL_EUR

    def is_alert_zone(self) -> bool:
        self.reset_if_new_day()
        return self.total_eur >= DAILY_BUDGET_EUR * ALERT_THRESHOLD_PCT

    def to_dict(self) -> dict:
        self.reset_if_new_day()
        return {
            'date':             self.date_str,
            'total_eur':        round(self.total_eur, 4),
            'daily_budget_eur': DAILY_BUDGET_EUR,
            'remaining_eur':    round(self.budget_remaining(), 4),
            'pct_used':         round(self.total_eur / DAILY_BUDGET_EUR * 100, 1),
            'leads_count':      self.leads_count,
            'avg_cpl_eur':      round(self.avg_cost_per_lead(), 4),
            'max_cpl_eur':      MAX_CPL_EUR,
            'claude_eur':       round(self.claude_eur, 4),
            'waba_eur':         round(self.waba_eur, 4),
            'vapi_eur':         round(self.vapi_eur, 4),
            'status':           'EXCEEDED' if self.is_budget_exceeded()
                                else 'ALERT' if self.is_alert_zone()
                                else 'OK',
            'degraded_count':   self.degraded_count,
            'fallback_mode':    FALLBACK_MODE,
        }


# Singleton do tracker
_tracker = DailyCostTracker()


# ─── Funções de Verificação ────────────────────────────────────────────────────
def check_budget(lead_id: Optional[str] = None) -> dict:
    """
    Verifica se o orçamento permite continuar.
    Retorna: {'allowed': bool, 'mode': str, 'reason': str, 'tracker': dict}
    """
    _tracker.reset_if_new_day()

    if _tracker.is_budget_exceeded():
        _tracker.degraded_count += 1
        reason = f'Orçamento diário excedido: €{_tracker.total_eur:.4f} / €{DAILY_BUDGET_EUR}'
        logging.warning(f'[BurnRateShield] HARD CAP ACTIVADO — {reason} | lead_id={lead_id}')
        return {
            'allowed': False,
            'mode':    'degraded',
            'fallback': FALLBACK_MODE,
            'reason':  reason,
            'tracker': _tracker.to_dict(),
        }

    if _tracker.is_cpl_exceeded():
        _tracker.degraded_count += 1
        reason = f'CPL médio excedido: €{_tracker.avg_cost_per_lead():.4f} / €{MAX_CPL_EUR}'
        logging.warning(f'[BurnRateShield] CPL CAP ACTIVADO — {reason}')
        return {
            'allowed': False,
            'mode':    'degraded',
            'fallback': FALLBACK_MODE,
            'reason':  reason,
            'tracker': _tracker.to_dict(),
        }

    if _tracker.is_alert_zone():
        logging.warning(f'[BurnRateShield] ZONA DE ALERTA — {_tracker.pct_used():.0f}% do orçamento usado')

    return {'allowed': True, 'mode': 'full', 'reason': 'OK', 'tracker': _tracker.to_dict()}


def get_claude_model(preferred: str = 'claude-sonnet-4-6') -> str:
    """
    Retorna o modelo a usar baseado no estado do orçamento.
    Graceful degradation: Opus → Sonnet → Haiku → static
    """
    _tracker.reset_if_new_day()
    pct = _tracker.total_eur / DAILY_BUDGET_EUR

    if _tracker.is_budget_exceeded():
        return 'static'  # sem IA
    if pct > 0.85:
        return 'claude-haiku-4-5'  # fallback económico
    if pct > 0.65 and preferred == 'claude-opus-4-7':
        return 'claude-sonnet-4-6'  # degradação de Opus para Sonnet
    return preferred


def record_usage(
    input_tokens:  int   = 0,
    output_tokens: int   = 0,
    model:         str   = 'claude-sonnet-4-6',
    waba_messages: int   = 0,
    vapi_minutes:  float = 0.0,
    lead_id: Optional[str] = None,
) -> dict:
    """Regista o custo real de uma operação."""
    cost = 0.0
    if input_tokens or output_tokens:
        cost += _tracker.add_claude(input_tokens, output_tokens, model)
    if waba_messages:
        cost += _tracker.add_waba(waba_messages)
    if vapi_minutes:
        cost += _tracker.add_vapi(vapi_minutes)

    logging.debug(f'[BurnRateShield] lead={lead_id} cost=€{cost:.4f} total=€{_tracker.total_eur:.4f}')
    return {'cost_eur': round(cost, 4), 'tracker': _tracker.to_dict()}


def get_status() -> dict:
    """Endpoint de status completo para o dashboard."""
    _tracker.reset_if_new_day()
    return _tracker.to_dict()


# ─── Middleware FastAPI ────────────────────────────────────────────────────────
try:
    from fastapi import FastAPI, Request, Response
    from fastapi.responses import JSONResponse

    class BurnRateShield:
        """
        Middleware FastAPI que intercepta chamadas de IA e aplica o tecto de orçamento.

        Uso:
            app = FastAPI()
            shield = BurnRateShield()
            shield.attach(app)
        """

        def attach(self, app: FastAPI):
            app.add_middleware(self._middleware_factory())
            app.add_api_route('/admin/burn-rate', self._status_endpoint, methods=['GET'])
            app.add_api_route('/admin/burn-rate/reset', self._reset_endpoint, methods=['POST'])
            return app

        def _middleware_factory(self):
            from starlette.middleware.base import BaseHTTPMiddleware

            class ShieldMiddleware(BaseHTTPMiddleware):
                async def dispatch(_, request: Request, call_next) -> Response:
                    # Apenas intercepta rotas de IA
                    ai_routes = ['/api/hermes', '/api/audit', '/api/claude', '/api/scanner/ai']
                    if not any(request.url.path.startswith(r) for r in ai_routes):
                        return await call_next(request)

                    budget = check_budget(lead_id=request.headers.get('X-Lead-Id'))

                    if not budget['allowed']:
                        return JSONResponse(
                            status_code=402,
                            content={
                                'error':   'budget_exceeded',
                                'message': budget['reason'],
                                'fallback': budget['fallback'],
                                'tracker': budget['tracker'],
                            },
                            headers={'X-BurnRate-Status': 'EXCEEDED'},
                        )

                    # Adicionar cabeçalho com modelo recomendado
                    response = await call_next(request)
                    response.headers['X-AI-Model-Recommended'] = get_claude_model()
                    response.headers['X-BurnRate-Remaining']   = str(round(_tracker.budget_remaining(), 4))
                    return response

            return ShieldMiddleware

        async def _status_endpoint(self):
            return JSONResponse(get_status())

        async def _reset_endpoint(self):
            global _tracker
            _tracker = DailyCostTracker()
            return JSONResponse({'reset': True, 'message': 'Orçamento diário reposto manualmente'})

except ImportError:
    class BurnRateShield:
        def attach(self, *args, **kwargs):
            logging.warning('[BurnRateShield] FastAPI não disponível — middleware não instalado')


# ─── Templates Estáticos de Fallback ─────────────────────────────────────────
# Quando o orçamento de IA é excedido, o Hermes usa estes templates sem Claude
STATIC_TEMPLATES = {
    'default': (
        "Olá {nome}! 👋\n\n"
        "Analisámos o perfil digital do seu negócio em *{nicho}* e identificámos oportunidades "
        "de melhoria que estão a impactar directamente os seus resultados.\n\n"
        "A Vanguard Tech tem um programa específico para o sector de {nicho}. "
        "Posso mostrar-lhe os resultados em 30 minutos?\n\n"
        "— Hermes · Vanguard Tech 🚀"
    ),
    'Saúde': (
        "Olá {nome}! 👋\n\n"
        "Clínicas e consultórios em *{nicho}* estão a perder pacientes online por falhas "
        "digitais evitáveis. A Vanguard resolveeu isto em menos de 30 dias para outros "
        "profissionais de saúde em Portugal.\n\n"
        "Quer uma análise gratuita? — Hermes · Vanguard Tech 🚀"
    ),
}

def get_static_template(nicho: str, nome: str = 'empresário') -> str:
    template = STATIC_TEMPLATES.get(nicho, STATIC_TEMPLATES['default'])
    return template.format(nome=nome, nicho=nicho)


# ─── Diagnóstico CLI ──────────────────────────────────────────────────────────
if __name__ == '__main__':
    import json
    print('=== Burn Rate Shield — Diagnóstico ===')
    print(json.dumps(get_status(), indent=2, ensure_ascii=False))
    print(f'\nModelo recomendado: {get_claude_model("claude-opus-4-7")}')
    print(f'Orçamento permitido: {check_budget("test-lead-001")["allowed"]}')
