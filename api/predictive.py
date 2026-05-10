#!/usr/bin/env python3
"""
Vanguard V11 — Predictive Lead Routing (Match Score MVP)

Endpoint: GET /api/arbitrage/suggest/{lead_id}
Calcula match score entre um lead e os tenants activos.

Formula de Match Score (100 pontos):
  40% — nicho_match    : niche do tenant = niche do lead
  35% — taxa_conversao : taxa histórica de conversão no nicho
  15% — score_tenant   : qualidade geral do tenant (quota usada / leads activos)
  10% — quota_livre    : percentagem de quota disponível

Retorna top-3 tenants ordenados por score descendente.
"""

import logging
from datetime import datetime
from typing import Optional

import httpx
from fastapi import APIRouter, Header, HTTPException
from pydantic import BaseModel

log = logging.getLogger('vanguard-predictive')

router = APIRouter(tags=['Predictive Routing V11'])


class MatchResult(BaseModel):
    tenant_id: str
    empresa: str
    match_score: float
    nicho_match: bool
    taxa_conversao: float
    quota_livre_pct: float
    motivo: str


def make_predictive_router(
    supabase_url: str,
    service_key: str,
    autenticar_fn,
) -> APIRouter:

    sb_hdrs = {
        'apikey':        service_key,
        'Authorization': f'Bearer {service_key}',
        'Content-Type':  'application/json',
    }

    async def _sb_get(table: str, params: dict) -> list:
        async with httpx.AsyncClient(timeout=10) as c:
            r = await c.get(f'{supabase_url}/rest/v1/{table}', params=params, headers=sb_hdrs)
            r.raise_for_status()
            return r.json()

    async def _sb_post(table: str, data: dict) -> dict:
        hdrs = {**sb_hdrs, 'Prefer': 'return=representation'}
        async with httpx.AsyncClient(timeout=10) as c:
            r = await c.post(f'{supabase_url}/rest/v1/{table}', json=data, headers=hdrs)
            r.raise_for_status()
            result = r.json()
            return result[0] if isinstance(result, list) and result else result

    def _calcular_match_score(lead: dict, tenant: dict, historico: list) -> dict:
        lead_nicho   = (lead.get('nicho') or '').lower().strip()
        tenant_nicho = (tenant.get('nicho') or '').lower().strip()
        nicho_match  = lead_nicho == tenant_nicho and bool(lead_nicho)

        conversoes_nicho = [h for h in historico if h.get('tenant_id') == tenant.get('id')]
        taxa_conversao = 0.0
        if conversoes_nicho:
            total   = len(conversoes_nicho)
            fechados = sum(1 for h in conversoes_nicho if h.get('estado') == 'fechado')
            taxa_conversao = round(fechados / total * 100, 1) if total > 0 else 0.0

        quota_total = tenant.get('quota_limite', 100) or 100
        quota_usada = tenant.get('quota_usada', 0)  or 0
        quota_livre_pct = max(0.0, round((quota_total - quota_usada) / quota_total * 100, 1))

        score_base = min(100.0, max(0.0, (
            quota_livre_pct / 100 * 10 +
            len([l for l in historico if l.get('tenant_id') == tenant.get('id')]) * 0.5
        )))
        score_tenant = round(min(100.0, score_base), 1)

        match_score = round(
            (40.0 if nicho_match else 0.0)         +
            (taxa_conversao * 0.35)                  +
            (score_tenant   * 0.15)                  +
            (quota_livre_pct * 0.10),
            2,
        )

        motivo_parts = []
        if nicho_match:
            motivo_parts.append(f'Nicho {lead_nicho} ✓')
        if taxa_conversao > 50:
            motivo_parts.append(f'{taxa_conversao}% conversão neste nicho')
        if quota_livre_pct > 70:
            motivo_parts.append(f'{quota_livre_pct}% quota disponível')
        motivo = ' · '.join(motivo_parts) if motivo_parts else 'Tenant disponível'

        return {
            'match_score':    match_score,
            'nicho_match':    nicho_match,
            'taxa_conversao': taxa_conversao,
            'quota_livre_pct': quota_livre_pct,
            'motivo':         motivo,
        }

    @router.get('/api/arbitrage/suggest/{lead_id}', response_model=list[MatchResult])
    async def sugerir_tenant(
        lead_id:       str,
        authorization: Optional[str] = Header(None),
    ):
        tenant_req = autenticar_fn(authorization)

        leads = await _sb_get('leads', {'id': f'eq.{lead_id}', 'select': 'id,nicho,score_digital,cidade'})
        if not leads:
            raise HTTPException(404, 'Lead não encontrado')
        lead = leads[0]

        tenants = await _sb_get('tenants', {
            'select': 'id,empresa,nicho,quota_limite,quota_usada,plano',
            'ativo':  'eq.true',
        })

        historico = await _sb_get('leads', {
            'select': 'tenant_id,estado',
            'estado': 'in.(fechado,perdido)',
        })

        resultados = []
        for t in tenants:
            if t.get('id') == tenant_req.get('id'):
                continue
            calc = _calcular_match_score(lead, t, historico)
            resultados.append(MatchResult(
                tenant_id=t['id'],
                empresa=t.get('empresa', 'Tenant'),
                **calc,
            ))

        resultados.sort(key=lambda x: x.match_score, reverse=True)
        top3 = resultados[:3]

        for r in top3:
            try:
                await _sb_post('predictive_matches', {
                    'lead_id':        lead_id,
                    'tenant_id':      r.tenant_id,
                    'match_score':    r.match_score,
                    'nicho_match':    r.nicho_match,
                    'taxa_conversao': r.taxa_conversao,
                    'criado_em':      datetime.utcnow().isoformat(),
                })
            except Exception:
                pass

        return top3

    @router.get('/api/arbitrage/suggest/{lead_id}/explain')
    async def explicar_match(
        lead_id:       str,
        authorization: Optional[str] = Header(None),
    ):
        autenticar_fn(authorization)
        matches = await _sb_get('predictive_matches', {
            'lead_id': f'eq.{lead_id}',
            'select':  'tenant_id,match_score,nicho_match,taxa_conversao,criado_em',
            'order':   'match_score.desc',
            'limit':   '10',
        })
        return {'lead_id': lead_id, 'historico_matches': matches}

    return router
