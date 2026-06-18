#!/usr/bin/env python3
"""
Vanguard V10 — Fortress Router
Health Monitor · IA Firefighter (Claude Haiku) · Incident Webhook · Stress Simulator
"""

import asyncio
import json
import os
import time
from datetime import datetime, timedelta
from typing import Callable, Optional

import httpx
from fastapi import APIRouter, Header, HTTPException
from pydantic import BaseModel


DIRECTOR_WEBHOOK_URL = os.getenv('DIRECTOR_WEBHOOK_URL', '')


class IncidentReq(BaseModel):
    severidade:  str
    servico:     str
    titulo:      str
    descricao:   Optional[str] = None
    stack_trace: Optional[str] = None


class DiagnoseReq(BaseModel):
    logs:     str
    contexto: Optional[str] = None


def make_fortress_router(
    supabase_url:  str,
    supabase_key:  str,
    anthropic_key: str,
    stripe_key:    str,
    vapi_key:      str,
    autenticar:    Callable,
) -> APIRouter:

    router = APIRouter(prefix='/api/fortress', tags=['fortress'])

    def _sb_headers() -> dict:
        return {
            'apikey':        supabase_key,
            'Authorization': f'Bearer {supabase_key}',
            'Content-Type':  'application/json',
            'Prefer':        'return=representation',
        }

    async def _check_svc(
        client:  httpx.AsyncClient,
        name:    str,
        url:     str,
        headers: dict = None,
        timeout: float = 6.0,
    ) -> dict:
        t0 = time.monotonic()
        try:
            r = await client.get(url, headers=headers or {}, timeout=timeout)
            ms = round((time.monotonic() - t0) * 1000)
            ok = r.status_code < 400
            return {'servico': name, 'status': 'healthy' if ok else 'degraded',
                    'latencia_ms': ms, 'http_code': r.status_code}
        except Exception as e:
            ms = round((time.monotonic() - t0) * 1000)
            return {'servico': name, 'status': 'down', 'latencia_ms': ms, 'erro': str(e)[:100]}

    async def _fire_webhook(incident: dict) -> None:
        if not DIRECTOR_WEBHOOK_URL:
            return
        emoji = '🚨' if incident.get('severidade') == 'critical' else '⚠️'
        payload = {
            'type':    'vanguard_incident',
            'text':    f"{emoji} [Vanguard Fortress] {incident['severidade'].upper()} — "
                       f"{incident['servico']}: {incident['titulo']}",
            'incident': incident,
            'ts':      datetime.utcnow().isoformat(),
        }
        try:
            async with httpx.AsyncClient(timeout=8) as c:
                await c.post(DIRECTOR_WEBHOOK_URL, json=payload)
        except Exception:
            pass  # Webhook failure must never crash the API

    # ── GET /api/fortress/health ──────────────────────────────────────────

    @router.get('/health')
    async def system_health():
        """Verifica todos os serviços críticos do ecossistema."""
        checks = []
        async with httpx.AsyncClient(timeout=8) as client:
            tasks = [
                _check_svc(client, 'api',      'http://localhost:9000/health'),
                _check_svc(client, 'supabase', f'{supabase_url}/rest/v1/',
                           {'apikey': supabase_key}),
                _check_svc(client, 'anthropic', 'https://api.anthropic.com/v1/models',
                           {'x-api-key': anthropic_key,
                            'anthropic-version': '2023-06-01'}),
            ]
            if stripe_key:
                tasks.append(_check_svc(
                    client, 'stripe', 'https://api.stripe.com/v1/balance',
                    {'Authorization': f'Bearer {stripe_key}'}
                ))
            if vapi_key:
                tasks.append(_check_svc(
                    client, 'vapi', 'https://api.vapi.ai/phone-number',
                    {'Authorization': f'Bearer {vapi_key}'}
                ))

            results = await asyncio.gather(*tasks, return_exceptions=True)
            for r in results:
                checks.append(r if isinstance(r, dict) else
                               {'servico': 'unknown', 'status': 'down', 'erro': str(r)})

        overall = 'healthy'
        for c in checks:
            if c.get('status') == 'down':
                overall = 'critical'; break
            elif c.get('status') == 'degraded':
                overall = 'degraded'

        # Auto-create incident if critical
        if overall == 'critical':
            down = [c['servico'] for c in checks if c.get('status') == 'down']
            asyncio.create_task(_fire_webhook({
                'severidade': 'critical',
                'servico':    ','.join(down),
                'titulo':     f'Serviço(s) em DOWN: {", ".join(down)}',
                'descricao':  f'Health check detectou falha — {datetime.utcnow().isoformat()}',
            }))

        return {'overall': overall, 'servicos': checks, 'ts': datetime.utcnow().isoformat()}

    # ── GET /api/fortress/incidents ───────────────────────────────────────

    @router.get('/incidents')
    async def listar_incidents(
        horas: int = 24,
        authorization: Optional[str] = Header(None),
    ):
        await autenticar(authorization)
        since = (datetime.utcnow() - timedelta(hours=horas)).isoformat()
        async with httpx.AsyncClient(timeout=10) as client:
            r = await client.get(
                f'{supabase_url}/rest/v1/system_incidents',
                params={
                    'detectado_em': f'gte.{since}',
                    'order':        'detectado_em.desc',
                    'limit':        '50',
                },
                headers=_sb_headers(),
            )
            r.raise_for_status()
            return {'incidents': r.json(), 'horas': horas}

    # ── POST /api/fortress/incidents ──────────────────────────────────────

    @router.post('/incidents')
    async def criar_incident(
        req: IncidentReq,
        authorization: Optional[str] = Header(None),
    ):
        await autenticar(authorization)
        if req.severidade not in ('critical', 'high', 'medium', 'low'):
            raise HTTPException(400, 'severidade inválida — use: critical/high/medium/low')
        if req.servico not in ('api', 'supabase', 'stripe', 'anthropic', 'vapi', 'n8n', 'nginx', 'outro'):
            raise HTTPException(400, 'servico inválido')

        data = {
            'severidade':  req.severidade,
            'servico':     req.servico,
            'titulo':      req.titulo,
            'descricao':   req.descricao,
            'stack_trace': req.stack_trace,
            'status':      'open',
        }
        async with httpx.AsyncClient(timeout=10) as client:
            r = await client.post(
                f'{supabase_url}/rest/v1/system_incidents',
                json=data, headers=_sb_headers(),
            )
            r.raise_for_status()
            incident = r.json()
            incident = incident[0] if isinstance(incident, list) else incident

        asyncio.create_task(_fire_webhook(data))
        return incident

    # ── GET /api/fortress/metrics ─────────────────────────────────────────

    @router.get('/metrics')
    async def get_metrics(authorization: Optional[str] = Header(None)):
        """KPIs agregados do ecossistema."""
        await autenticar(authorization)

        async with httpx.AsyncClient(timeout=15) as client:
            # Tenants por plano
            r_t = await client.get(
                f'{supabase_url}/rest/v1/tenants',
                params={'select': 'plano', 'limit': '2000'},
                headers=_sb_headers(),
            )
            tenants = r_t.json() if r_t.status_code == 200 else []

            # Total leads
            r_l = await client.get(
                f'{supabase_url}/rest/v1/leads_diagnostico',
                params={'select': 'id', 'limit': '1'},
                headers={**_sb_headers(), 'Prefer': 'count=exact'},
            )
            cr = r_l.headers.get('content-range', '0/0')
            total_leads = int(cr.split('/')[-1]) if '/' in cr else 0

            # Incidentes abertos
            r_i = await client.get(
                f'{supabase_url}/rest/v1/system_incidents',
                params={'status': 'eq.open', 'select': 'id', 'limit': '1'},
                headers={**_sb_headers(), 'Prefer': 'count=exact'},
            )
            cr_i = r_i.headers.get('content-range', '0/0')
            open_incidents = int(cr_i.split('/')[-1]) if '/' in cr_i else 0

        planos: dict = {}
        for t in tenants:
            p = t.get('plano', 'trial')
            planos[p] = planos.get(p, 0) + 1

        return {
            'tenants_total':     len(tenants),
            'tenants_por_plano': planos,
            'leads_total':       total_leads,
            'incidents_open':    open_incidents,
            'ts':                datetime.utcnow().isoformat(),
        }

    # ── POST /api/fortress/diagnose — IA FIREFIGHTER ─────────────────────

    @router.post('/diagnose')
    async def ia_firefighter(
        req: DiagnoseReq,
        authorization: Optional[str] = Header(None),
    ):
        """IA Firefighter: Claude Haiku analisa logs e gera plano de resolução."""
        await autenticar(authorization)
        if not anthropic_key:
            raise HTTPException(503, 'ANTHROPIC_API_KEY não configurada.')

        import anthropic as ant
        client_ai = ant.Anthropic(api_key=anthropic_key)

        system = (
            "És o Vanguard Fortress AI — engenheiro sénior especialista em FastAPI, "
            "Supabase, Docker e n8n. Ao receber logs de erro, responde SEMPRE em JSON "
            "com esta estrutura exacta:\n"
            '{"causa_raiz": "...", "severidade": "critical|high|medium|low", '
            '"servico_afectado": "api|supabase|stripe|vapi|n8n|nginx", '
            '"passos_resolucao": ["passo 1", "passo 2"], '
            '"tempo_estimado_min": 5, '
            '"acoes_preventivas": ["acção 1"]}'
        )
        prompt = (
            f"CONTEXTO: {req.contexto or 'Vanguard SaaS em produção'}\n\n"
            f"LOGS:\n{req.logs[:4000]}"
        )

        msg = client_ai.messages.create(
            model='claude-haiku-4-5-20251001',
            max_tokens=1024,
            system=system,
            messages=[{'role': 'user', 'content': prompt}],
        )
        raw = msg.content[0].text if msg.content else '{}'

        try:
            diagnostico = json.loads(raw)
        except Exception:
            diagnostico = {'raw': raw, 'causa_raiz': 'JSON parse falhou — ver campo raw'}

        return {
            'diagnostico':   diagnostico,
            'tokens_usados': msg.usage.input_tokens + msg.usage.output_tokens,
            'ts':            datetime.utcnow().isoformat(),
        }

    # ── POST /api/fortress/stress-test ────────────────────────────────────

    @router.post('/stress-test')
    async def run_stress_test(
        n: int = 100,
        authorization: Optional[str] = Header(None),
    ):
        """Simula N requests simultâneos e retorna métricas de resiliência (max 1000)."""
        await autenticar(authorization)
        if n > 1000:
            raise HTTPException(400, 'Máximo 1000 requests por teste.')

        HEALTH_URL = 'http://localhost:9000/health'
        latencias: list[float] = []
        erros = 0
        t0_all = time.monotonic()

        async def _ping(c: httpx.AsyncClient) -> bool:
            nonlocal erros
            t0 = time.monotonic()
            try:
                r = await c.get(HEALTH_URL, timeout=10)
                latencias.append((time.monotonic() - t0) * 1000)
                return r.status_code < 400
            except Exception:
                latencias.append((time.monotonic() - t0) * 1000)
                erros += 1
                return False

        sucesso = 0
        BATCH = 100
        async with httpx.AsyncClient() as c:
            for i in range(0, n, BATCH):
                b = min(BATCH, n - i)
                results = await asyncio.gather(*[_ping(c) for _ in range(b)])
                sucesso += sum(1 for r in results if r)

        total_ms = round((time.monotonic() - t0_all) * 1000)
        s = sorted(latencias)

        def pct(lst, p):
            if not lst: return 0
            return round(lst[max(0, round(p / 100 * len(lst)) - 1)], 1)

        result = {
            'n_requests':     n,
            'sucesso':        sucesso,
            'erros':          erros,
            'taxa_sucesso':   round(sucesso / n * 100, 1),
            'tempo_total_ms': total_ms,
            'latencia_p50':   pct(s, 50),
            'latencia_p95':   pct(s, 95),
            'latencia_p99':   pct(s, 99),
            'latencia_max':   round(max(s), 1) if s else 0,
            'ts':             datetime.utcnow().isoformat(),
        }

        # Persistir no Supabase (non-fatal)
        try:
            async with httpx.AsyncClient(timeout=8) as c2:
                await c2.post(
                    f'{supabase_url}/rest/v1/stress_test_results',
                    json={
                        'total_requests': n,
                        'success_count':  sucesso,
                        'error_count':    erros,
                        'p50_ms':         result['latencia_p50'],
                        'p95_ms':         result['latencia_p95'],
                        'p99_ms':         result['latencia_p99'],
                    },
                    headers=_sb_headers(),
                )
        except Exception:
            pass

        return result

    # ── GET /api/fortress/stress-test/results ─────────────────────────────

    @router.get('/stress-test/results')
    async def get_stress_results(authorization: Optional[str] = Header(None)):
        await autenticar(authorization)
        async with httpx.AsyncClient(timeout=10) as client:
            r = await client.get(
                f'{supabase_url}/rest/v1/stress_test_results',
                params={'order': 'ran_at.desc', 'limit': '10'},
                headers=_sb_headers(),
            )
            r.raise_for_status()
            return {'resultados': r.json()}

    return router
