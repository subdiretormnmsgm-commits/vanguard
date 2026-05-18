"""
INTELLIGENCE LEDGER — Motor de Estado do Quadrilateral IAH
Substitui o arquivo .md estático por estado vivo em memória + persistência JSON.

Por que isso resolve o problema central:
- O Músculo não lê um arquivo que pode estar desatualizado
- Todo evento de fricção é registrado atomicamente
- Hard Vetos são verificáveis via endpoint, não via disciplina manual
- O LEDGER cresce a cada sessão sem intervenção do Diretor
"""

import json
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Literal

from pydantic import BaseModel, Field


# ── Tipos ─────────────────────────────────────────────────────────────────────

FricaoTipo = Literal[
    "ALUCINACAO_TECNICA",
    "ESCOPO_INDEVIDO",
    "COMPLEXIDADE_PREMATURA",
    "DADOS_FALSOS",
    "OVERRIDE_DIRETOR",
    "DERIVA_FORMATO",
    "VETO_ATIVADO",
]

Severidade = Literal["CRITICAL", "HIGH", "MEDIUM", "LOW"]

VetoTipo = Literal[
    "HV-1",  # Credencial hardcoded
    "HV-2",  # PII sem consentimento LGPD
    "HV-3",  # Custo acima do burn rate sem aprovação
    "HV-4",  # Dívida P0 ativa sem plano de resolução
    "HV-5",  # Breaking change sem kill-switch
    "SV-1",  # Stack nova sem inventário existente
    "SV-2",  # Feature contradiz princípio ativo
    "SV-3",  # Acumulação >3 dívidas P1 no mesmo componente
    "SV-4",  # DIRETRIZ com >5 prioridades
    "SV-5",  # Claude Code proposto como daemon
]


class Principio(BaseModel):
    id: str                        # P-001, P-002, ...
    descricao: str
    origem: str                    # sessão ou projeto que gerou o princípio
    data: str
    ativo: bool = True
    overrides: list[str] = []      # IDs de princípios que este supera


class FricaoEvento(BaseModel):
    id: str                        # F-001, F-002, ...
    timestamp: str
    sessao: str
    tipo: FricaoTipo
    fonte: str                     # quem emitiu a instrução problemática
    instrucao_original: str
    problema_detectado: str
    acao_tomada: str
    principio_gerado: str | None = None
    severidade: Severidade


class VetoAtivo(BaseModel):
    tipo: VetoTipo
    projeto: str
    motivo: str
    timestamp: str
    override_diretor: str | None = None   # se None, veto está BLOQUEANDO


class LedgerState(BaseModel):
    principios: list[Principio] = []
    fricoes: list[FricaoEvento] = []
    vetos_ativos: list[VetoAtivo] = []
    sessoes_count: int = 0
    ultima_sessao: str = ""
    versao: str = "V24"


# ── Persistência ──────────────────────────────────────────────────────────────

LEDGER_PATH = Path(os.getenv("LEDGER_PATH", "ledger_state.json"))


def _carregar() -> LedgerState:
    if LEDGER_PATH.exists():
        try:
            return LedgerState.model_validate_json(LEDGER_PATH.read_text())
        except Exception:
            pass
    # Estado inicial com os 5 princípios da V24
    return LedgerState(
        principios=[
            Principio(
                id="P-001",
                descricao="Claude Code ≠ daemon. Execução autônoma requer Claude API via n8n/FastAPI.",
                origem="V24-Meta-Intelligence",
                data="2026-05-12",
            ),
            Principio(
                id="P-002",
                descricao="VEREDITO BINÁRIO só em divergência real — não como decoração de processo.",
                origem="V24-Meta-Intelligence",
                data="2026-05-12",
            ),
            Principio(
                id="P-003",
                descricao="Scraping é dependência, não ativo. Todo dado scrapeado pode ser bloqueado.",
                origem="V24-Meta-Intelligence",
                data="2026-05-12",
            ),
            Principio(
                id="P-004",
                descricao="Primeiro cliente vem de uma ligação, não do site. Relação > funil automatizado.",
                origem="V24-Meta-Intelligence",
                data="2026-05-12",
            ),
            Principio(
                id="P-005",
                descricao="Inteligência acumula por sessão, não por versão. Sessão sem ritual = memória perdida.",
                origem="V24-Meta-Intelligence",
                data="2026-05-12",
            ),
            Principio(
                id="P-006",
                descricao="Scanner frontend-only é demo, não produto. Dados reais exigem backend HTTP.",
                origem="V12-PDCA-Audit",
                data="2026-05-10",
            ),
            Principio(
                id="P-007",
                descricao="Skill genérica é pior que Skill incompleta. Sem dado real no bloco → 'dados insuficientes'.",
                origem="PASSO5-Template",
                data="2026-05-14",
            ),
            Principio(
                id="P-008",
                descricao="Billing antes de features core em SaaS B2B. Multi-tenant sem billing = refatoração garantida.",
                origem="AVISO_ARQUITETO-AP1",
                data="2026-05-12",
            ),
            Principio(
                id="P-009",
                descricao="Marketplace com split de receita exige Stripe Connect desde Fase 0.",
                origem="AVISO_ARQUITETO-AP4",
                data="2026-05-12",
            ),
            Principio(
                id="P-010",
                descricao="Gate declarado sem evidência real (CLI, log, teste) = gate inválido.",
                origem="PASSO6-Template",
                data="2026-05-14",
            ),
        ]
    )


def _salvar(state: LedgerState) -> None:
    LEDGER_PATH.write_text(state.model_dump_json(indent=2))


# ── Singleton em memória ───────────────────────────────────────────────────────

_state: LedgerState | None = None


def get_state() -> LedgerState:
    global _state
    if _state is None:
        _state = _carregar()
    return _state


def _persist() -> None:
    if _state is not None:
        _salvar(_state)


# ── Operações ─────────────────────────────────────────────────────────────────

def listar_principios_ativos() -> list[Principio]:
    return [p for p in get_state().principios if p.ativo]


def registrar_fricao(evento: FricaoEvento) -> FricaoEvento:
    state = get_state()
    # Auto-incrementa ID se não informado
    if not evento.id:
        n = len(state.fricoes) + 1
        evento.id = f"F-{n:03d}"
    state.fricoes.append(evento)
    _persist()
    return evento


def adicionar_principio(p: Principio) -> Principio:
    state = get_state()
    # Verifica duplicata por ID
    ids_existentes = {x.id for x in state.principios}
    if p.id in ids_existentes:
        p.id = f"P-{len(state.principios) + 1:03d}"
    state.principios.append(p)
    _persist()
    return p


def ativar_veto(veto: VetoAtivo) -> VetoAtivo:
    state = get_state()
    state.vetos_ativos.append(veto)
    _persist()
    return veto


def resolver_veto(tipo: VetoTipo, projeto: str, override_diretor: str) -> bool:
    """Resolve um veto ativo com override documentado do Diretor."""
    state = get_state()
    for v in state.vetos_ativos:
        if v.tipo == tipo and v.projeto == projeto and v.override_diretor is None:
            v.override_diretor = override_diretor
            _persist()
            return True
    return False


def verificar_bloqueio_deploy(projeto: str) -> dict:
    """
    Verifica se existe Hard Veto ativo sem override para o projeto.
    Retorna dict com 'bloqueado': bool e 'motivos': list[str].
    Usado pelo CI/CD hook do GitHub Actions.
    """
    state = get_state()
    hard_vetos = [
        v for v in state.vetos_ativos
        if v.projeto == projeto
        and v.tipo.startswith("HV-")
        and v.override_diretor is None
    ]
    return {
        "bloqueado": len(hard_vetos) > 0,
        "motivos": [f"{v.tipo}: {v.motivo}" for v in hard_vetos],
        "projeto": projeto,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }


def incrementar_sessao(nome: str) -> int:
    state = get_state()
    state.sessoes_count += 1
    state.ultima_sessao = nome
    _persist()
    return state.sessoes_count


def exportar_para_markdown() -> str:
    """
    Gera o INTELLIGENCE_LEDGER.md a partir do estado vivo.
    Substitui a atualização manual do arquivo.
    """
    state = get_state()
    ativos = [p for p in state.principios if p.ativo]
    linhas = [
        "# INTELLIGENCE LEDGER — Estado Vivo do Quadrilateral IAH",
        f"> **Sessões acumuladas:** {state.sessoes_count}  ",
        f"> **Última sessão:** {state.ultima_sessao}  ",
        f"> **Versão do sistema:** {state.versao}  ",
        f"> **Gerado em:** {datetime.now(timezone.utc).isoformat()}",
        "",
        "---",
        "",
        "## PRINCÍPIOS ATIVOS",
        "",
    ]
    for p in ativos:
        linhas.append(f"### {p.id}")
        linhas.append(f"**{p.descricao}**")
        linhas.append(f"*Origem: {p.origem} · {p.data}*")
        if p.overrides:
            linhas.append(f"*Supera: {', '.join(p.overrides)}*")
        linhas.append("")

    linhas += [
        "---",
        "",
        f"## FRICÇÕES REGISTRADAS ({len(state.fricoes)} total)",
        "",
    ]
    for f in state.fricoes[-10:]:  # últimas 10
        linhas.append(f"### {f.id} · {f.tipo} · {f.severidade}")
        linhas.append(f"**Sessão:** {f.sessao}  ")
        linhas.append(f"**Problema:** {f.problema_detectado}  ")
        linhas.append(f"**Ação:** {f.acao_tomada}  ")
        if f.principio_gerado:
            linhas.append(f"**Princípio gerado:** {f.principio_gerado}")
        linhas.append("")

    vetos_abertos = [v for v in state.vetos_ativos if v.override_diretor is None]
    if vetos_abertos:
        linhas += ["---", "", "## ⛔ VETOS ATIVOS (SEM OVERRIDE)", ""]
        for v in vetos_abertos:
            linhas.append(f"- **{v.tipo}** · {v.projeto}: {v.motivo}")
        linhas.append("")

    return "\n".join(linhas)
