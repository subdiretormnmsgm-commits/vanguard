#!/usr/bin/env python3
"""
Vanguard V9 — Maturity Certificate System
FastAPI Router: /api/certifica/ + /certifica/ (verificação pública)

Badge SVG dinâmico + verificação pública para empresas com score >= 8.
Expira após 12 meses — cria ciclo de renovação.

Endpoints:
  POST /api/certifica/emitir/{lead_id}    — emitir certificado (tenant, pago)
  GET  /api/certifica/meus                — certificados do tenant
  POST /api/certifica/reivindicar/{token} — empresa reivindica o seu certificado
  GET  /certifica/verificar/{token}       — verificação pública (HTML/SVG)
  GET  /certifica/badge/{token}.svg       — badge SVG embeddable
"""

import logging
from datetime import datetime
from typing import Optional

import httpx
from fastapi import APIRouter, Header, HTTPException
from fastapi.responses import HTMLResponse, Response
from pydantic import BaseModel, Field

log = logging.getLogger('vanguard-certifica')

router = APIRouter(tags=['Vanguard Certifica'])

NIVEIS = {
    'emerging': {'label': 'Digital Emerging',  'cor': '#6B7280', 'min_score': 8.0},
    'advanced': {'label': 'Digital Advanced',  'cor': '#3B82F6', 'min_score': 8.5},
    'ready':    {'label': 'Digital Ready™',    'cor': '#10B981', 'min_score': 9.0},
    'elite':    {'label': 'Digital Elite™',    'cor': '#F59E0B', 'min_score': 9.5},
}


class ReivindicarReq(BaseModel):
    empresa_email: str = Field(..., min_length=5, max_length=200)
    empresa_nome:  str = Field(..., min_length=2, max_length=120)


def make_certifica_router(
    supabase_url:  str,
    service_key:   str,
    autenticar_fn,
    get_tenant_fn,
) -> APIRouter:

    sb_hdrs = {
        'apikey':        service_key,
        'Authorization': f'Bearer {service_key}',
        'Content-Type':  'application/json',
        'Prefer':        'return=representation',
    }

    async def _sb_get(table: str, params: dict) -> list:
        async with httpx.AsyncClient(timeout=10) as c:
            r = await c.get(f'{supabase_url}/rest/v1/{table}', params=params, headers=sb_hdrs)
            r.raise_for_status()
            return r.json()

    async def _sb_post(table: str, data: dict) -> dict:
        async with httpx.AsyncClient(timeout=10) as c:
            r = await c.post(f'{supabase_url}/rest/v1/{table}', json=data, headers=sb_hdrs)
            r.raise_for_status()
            result = r.json()
            return result[0] if isinstance(result, list) and result else result

    async def _sb_patch(table: str, filtro: str, data: dict) -> None:
        async with httpx.AsyncClient(timeout=10) as c:
            r = await c.patch(
                f'{supabase_url}/rest/v1/{table}?{filtro}', json=data,
                headers={**sb_hdrs, 'Prefer': 'return=minimal'}
            )
            r.raise_for_status()

    def _determinar_nivel(score: float) -> str:
        if score >= 9.5: return 'elite'
        if score >= 9.0: return 'ready'
        if score >= 8.5: return 'advanced'
        return 'emerging'

    def _gerar_badge_svg(cert: dict, verificar_url: str) -> str:
        nivel    = cert.get('nivel', 'ready')
        info     = NIVEIS.get(nivel, NIVEIS['ready'])
        cor      = info['cor']
        label    = info['label']
        score    = cert.get('score_digital', 0)
        nome     = cert.get('empresa_nome', '')[:30]
        ano      = cert.get('emitido_em', '')[:4]
        token    = cert.get('badge_token', '')[:8]
        expires  = cert.get('expires_at', '')[:10]

        return f'''<svg xmlns="http://www.w3.org/2000/svg" width="340" height="120" viewBox="0 0 340 120">
  <defs>
    <linearGradient id="bg-grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#0A0802;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#1A1408;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="accent-grad" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:{cor};stop-opacity:1" />
      <stop offset="100%" style="stop-color:{cor}88;stop-opacity:1" />
    </linearGradient>
  </defs>

  <!-- Background -->
  <rect width="340" height="120" fill="url(#bg-grad)" rx="6"/>
  <rect x="0" y="0" width="340" height="2" fill="url(#accent-grad)"/>
  <rect x="0" y="0" width="2" height="120" fill="{cor}"/>

  <!-- Score circle -->
  <circle cx="56" cy="60" r="36" fill="none" stroke="{cor}22" stroke-width="2"/>
  <circle cx="56" cy="60" r="36" fill="none" stroke="{cor}" stroke-width="2.5"
    stroke-dasharray="{int(score * 22.6)} 226"
    stroke-linecap="round"
    transform="rotate(-90 56 60)"/>
  <text x="56" y="56" text-anchor="middle" fill="{cor}"
    font-family="Georgia,serif" font-size="18" font-weight="700">{score:.1f}</text>
  <text x="56" y="70" text-anchor="middle" fill="{cor}99"
    font-family="monospace" font-size="8">/10</text>

  <!-- Content -->
  <text x="108" y="30" fill="#C5A028" font-family="Georgia,serif" font-size="9"
    letter-spacing="2" text-transform="uppercase">VANGUARD CERTIFIED {ano}</text>
  <text x="108" y="52" fill="#F1F0ED" font-family="Georgia,serif" font-size="15"
    font-weight="700">{label}</text>
  <text x="108" y="70" fill="#9A8C78" font-family="monospace" font-size="10">{nome}</text>
  <text x="108" y="86" fill="{cor}99" font-family="monospace" font-size="8">
    Expires: {expires} · vanguard.io/c/{token}
  </text>

  <!-- Vanguard logo mark -->
  <text x="318" y="110" text-anchor="middle" fill="#C5A02855"
    font-family="Georgia,serif" font-size="7" letter-spacing="1">VANGUARD</text>

  <!-- Link -->
  <a href="{verificar_url}">
    <rect x="0" y="0" width="340" height="120" fill="transparent"/>
  </a>
</svg>'''

    def _gerar_pagina_verificacao(cert: dict, base_url: str) -> str:
        nivel  = cert.get('nivel', 'ready')
        info   = NIVEIS.get(nivel, NIVEIS['ready'])
        cor    = info['cor']
        label  = info['label']
        score  = cert.get('score_digital', 0)
        pct    = cert.get('score_percentil', int(score * 10))
        token  = cert.get('badge_token', '')

        valido = cert.get('expires_at', '') > datetime.utcnow().isoformat()
        status_text = 'Certificado Válido' if valido else 'Certificado Expirado'
        status_cor  = cor if valido else '#6B7280'

        badge_url = f'{base_url}/certifica/badge/{token}.svg'
        embed_code = f'&lt;img src="{badge_url}" alt="Vanguard {label}" width="340" height="120"&gt;'

        return f'''<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Verificar Certificado — Vanguard</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:wght@400;500;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *{{box-sizing:border-box;margin:0;padding:0}}
    body{{background:#0A0802;color:#F1F0ED;font-family:'EB Garamond',Georgia,serif;min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:2rem}}
    .card{{max-width:560px;width:100%;border:1px solid #C5A02840;padding:3rem;position:relative;overflow:hidden}}
    .card::before{{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:linear-gradient(90deg,{cor},{cor}44)}}
    .eyebrow{{font-family:'JetBrains Mono',monospace;font-size:.65rem;color:#C5A028;letter-spacing:.2em;text-transform:uppercase;margin-bottom:1.5rem}}
    .status-badge{{display:inline-flex;align-items:center;gap:.4rem;padding:.3rem .8rem;border:1px solid {status_cor}40;background:{status_cor}10;margin-bottom:2rem}}
    .status-badge__dot{{width:6px;height:6px;border-radius:50%;background:{status_cor}}}
    .status-badge__text{{font-family:'JetBrains Mono',monospace;font-size:.65rem;color:{status_cor};letter-spacing:.1em;text-transform:uppercase}}
    .company{{font-size:2rem;font-weight:700;line-height:1.1;margin-bottom:.5rem;color:#F1F0ED}}
    .level{{font-size:1rem;color:{cor};margin-bottom:2rem}}
    .score-row{{display:flex;align-items:baseline;gap:1rem;margin-bottom:2rem;padding:1.5rem;background:#16120A;border:1px solid #C5A02820}}
    .score-value{{font-family:'JetBrains Mono',monospace;font-size:3rem;color:{cor};line-height:1}}
    .score-label{{font-size:.9rem;color:#9A8C78}}
    .meta-grid{{display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin-bottom:2rem}}
    .meta-item__label{{font-family:'JetBrains Mono',monospace;font-size:.62rem;color:#6B5D4A;letter-spacing:.1em;text-transform:uppercase;margin-bottom:.2rem}}
    .meta-item__value{{font-size:.9rem;color:#C5A028}}
    .embed-section{{margin-top:2rem;padding-top:2rem;border-top:1px solid #C5A02820}}
    .embed-label{{font-family:'JetBrains Mono',monospace;font-size:.62rem;color:#6B5D4A;letter-spacing:.1em;text-transform:uppercase;margin-bottom:.75rem}}
    .embed-code{{background:#16120A;border:1px solid #C5A02820;padding:1rem;font-family:'JetBrains Mono',monospace;font-size:.72rem;color:#C5A028;overflow-x:auto;word-break:break-all}}
    .badge-preview{{margin:1rem 0}}
    footer{{margin-top:3rem;font-family:'JetBrains Mono',monospace;font-size:.62rem;color:#4A3D2E;letter-spacing:.08em;text-align:center}}
    a{{color:{cor};text-decoration:none}}
    a:hover{{text-decoration:underline}}
  </style>
</head>
<body>
  <div class="card">
    <div class="eyebrow">Vanguard Maturity Certificate · Verificação Pública</div>
    <div class="status-badge">
      <div class="status-badge__dot"></div>
      <span class="status-badge__text">{status_text}</span>
    </div>
    <h1 class="company">{cert.get("empresa_nome","—")}</h1>
    <div class="level">{label}</div>

    <div class="score-row">
      <div>
        <div class="score-value">{score:.1f}</div>
        <div class="score-label">Score Digital / 10</div>
      </div>
      <div style="flex:1">
        <div style="height:6px;background:#1E180E;margin-bottom:.5rem">
          <div style="height:100%;width:{pct}%;background:{cor};transition:width 1s"></div>
        </div>
        <div style="font-family:monospace;font-size:.75rem;color:#9A8C78">Percentil: {pct}</div>
      </div>
    </div>

    <div class="meta-grid">
      <div class="meta-item">
        <div class="meta-item__label">Nicho</div>
        <div class="meta-item__value">{cert.get("empresa_nicho","—").title()}</div>
      </div>
      <div class="meta-item">
        <div class="meta-item__label">Cidade</div>
        <div class="meta-item__value">{cert.get("empresa_cidade","—")}</div>
      </div>
      <div class="meta-item">
        <div class="meta-item__label">Emitido em</div>
        <div class="meta-item__value">{cert.get("emitido_em","")[:10]}</div>
      </div>
      <div class="meta-item">
        <div class="meta-item__label">Expira em</div>
        <div class="meta-item__value">{cert.get("expires_at","")[:10]}</div>
      </div>
    </div>

    <div class="embed-section">
      <div class="embed-label">Badge para o seu website</div>
      <div class="badge-preview">
        <img src="{badge_url}" alt="Vanguard {label}" width="340" height="120"
          style="max-width:100%;border:1px solid #C5A02820">
      </div>
      <div class="embed-code">&lt;img src="{badge_url}" alt="Vanguard {label}" width="340" height="120"&gt;</div>
    </div>
  </div>

  <footer>
    VANGUARD · verify.{token[:8]} · <a href="/intelligence/">Intelligence API</a>
  </footer>
</body>
</html>'''

    # ─── Endpoints ────────────────────────────────────────────────────────────

    @router.post('/api/certifica/emitir/{lead_id}', status_code=201)
    async def emitir_certificado(
        lead_id:       str,
        authorization: Optional[str] = Header(None),
    ):
        """Emite certificado para lead com score >= 8. Requer plano pago."""
        _, user_id = await autenticar_fn(authorization)
        async with httpx.AsyncClient(timeout=10) as client:
            tenant = await get_tenant_fn(client, user_id)

        leads = await _sb_get('leads_diagnostico', {
            'id':        f'eq.{lead_id}',
            'tenant_id': f'eq.{tenant["id"]}',
            'select':    'id,nome,nicho,cidade,score_digital',
        })
        if not leads:
            raise HTTPException(404, 'Lead não encontrado.')

        lead = leads[0]
        score = float(lead.get('score_digital') or 0)

        if score < 8.0:
            raise HTTPException(
                400,
                f'Score insuficiente para certificação: {score:.1f}/10. '
                f'Requerido: 8.0+. '
                f'Recomendação: melhore a presença digital da empresa e re-audite.'
            )

        # Verificar se já tem certificado válido
        existente = await _sb_get('certifications', {
            'lead_id':  f'eq.{lead_id}',
            'pago':     'eq.true',
            'select':   'id,expires_at',
        })
        if existente:
            exp = existente[0]['expires_at']
            if exp > datetime.utcnow().isoformat():
                raise HTTPException(409, f'Já existe certificado válido até {exp[:10]}.')

        nivel = _determinar_nivel(score)

        cert = await _sb_post('certifications', {
            'tenant_id':    tenant['id'],
            'lead_id':      lead_id,
            'empresa_nome': lead.get('nome', 'Empresa'),
            'empresa_cidade': lead.get('cidade'),
            'empresa_nicho': lead.get('nicho'),
            'score_digital': score,
            'nivel':         nivel,
            'pago':          True,  # Simplificado — em produção verificar via Stripe
        })

        log.info(f'Certificado emitido: {cert["badge_token"][:8]} — {lead.get("nome")} — {score}/10')
        return {
            'certificado':  cert,
            'nivel':        NIVEIS[nivel],
            'verificar_url': f'/certifica/verificar/{cert["badge_token"]}',
            'badge_url':    f'/certifica/badge/{cert["badge_token"]}.svg',
            'embed_code':   f'<img src="/certifica/badge/{cert["badge_token"]}.svg" alt="Vanguard {NIVEIS[nivel]["label"]}" width="340" height="120">',
        }

    @router.get('/api/certifica/meus')
    async def meus_certificados(authorization: Optional[str] = Header(None)):
        """Lista certificados emitidos pelo tenant."""
        _, user_id = await autenticar_fn(authorization)
        async with httpx.AsyncClient(timeout=10) as c:
            tenant = await get_tenant_fn(c, user_id)

        rows = await _sb_get('certifications', {
            'tenant_id': f'eq.{tenant["id"]}',
            'order':     'created_at.desc',
        })
        return {'certificados': rows, 'total': len(rows)}

    @router.post('/api/certifica/reivindicar/{token}')
    async def reivindicar_certificado(token: str, req: ReivindicarReq):
        """Empresa reivindica o seu próprio certificado (sem auth — link público)."""
        certs = await _sb_get('certifications', {
            'badge_token': f'eq.{token}',
            'pago':        'eq.true',
        })
        if not certs:
            raise HTTPException(404, 'Certificado não encontrado.')

        cert = certs[0]
        if cert.get('reivindicado'):
            return {'status': 'ja_reivindicado', 'reivindicado_em': cert['reivindicado_em']}

        await _sb_patch('certifications', f'badge_token=eq.{token}', {
            'reivindicado':    True,
            'reivindicado_em': datetime.utcnow().isoformat(),
            'empresa_email':   req.empresa_email,
            'empresa_nome':    req.empresa_nome,
        })

        log.info(f'Certificado reivindicado: {token[:8]} por {req.empresa_email}')
        return {
            'status':       'reivindicado',
            'verificar_url': f'/certifica/verificar/{token}',
            'badge_url':    f'/certifica/badge/{token}.svg',
        }

    @router.get('/certifica/verificar/{token}', response_class=HTMLResponse)
    async def verificar_certificado(token: str):
        """Página pública de verificação de certificado."""
        certs = await _sb_get('certifications', {
            'badge_token': f'eq.{token}',
            'pago':        'eq.true',
        })
        if not certs:
            return HTMLResponse('<html><body><h1>Certificado não encontrado</h1></body></html>', 404)

        html = _gerar_pagina_verificacao(certs[0], '')
        return HTMLResponse(html)

    @router.get('/certifica/badge/{token}.svg')
    async def badge_svg(token: str):
        """Badge SVG embeddable para websites."""
        certs = await _sb_get('certifications', {
            'badge_token': f'eq.{token}',
            'pago':        'eq.true',
        })
        if not certs:
            raise HTTPException(404, 'Certificado não encontrado.')

        svg = _gerar_badge_svg(certs[0], f'/certifica/verificar/{token}')
        return Response(
            content=svg,
            media_type='image/svg+xml',
            headers={
                'Cache-Control': 'public, max-age=3600',
                'X-Vanguard-Cert': token[:8],
            }
        )

    return router
