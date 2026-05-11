"""
Vanguard V21 — Sentinel Report Card Engine
FastAPI Router: /api/sentinel/

Motor de retenção semanal: agrega delta de intenção por tenant,
formata narrativa com Claude Haiku e envia via SendGrid toda segunda-feira.
Custo: ~$0.04/relatório (Haiku) + $0.001/email (SendGrid free tier).
"""

import json
import logging
import os
from datetime import datetime, timedelta, timezone
from typing import Optional

import anthropic
import httpx
from fastapi import APIRouter, BackgroundTasks, Header, HTTPException, Request
from pydantic import BaseModel

log = logging.getLogger('vanguard-sentinel-report')

router = APIRouter(prefix='/api/sentinel', tags=['Sentinel Report Card'])

SENDGRID_API_KEY  = os.getenv('SENDGRID_API_KEY', '')
SENDGRID_FROM     = os.getenv('SENDGRID_FROM_EMAIL', 'relatorios@vanguard.tech')
SENDGRID_FROM_NAME = 'Vanguard Intelligence'
SUPABASE_URL      = os.getenv('SUPABASE_URL', '')
SUPABASE_KEY      = os.getenv('SUPABASE_SERVICE_KEY', os.getenv('SUPABASE_ANON_KEY', ''))
ANTHROPIC_KEY     = os.getenv('ANTHROPIC_API_KEY', '')

_sb_hdrs = lambda: {
    'apikey':        SUPABASE_KEY,
    'Authorization': f'Bearer {SUPABASE_KEY}',
    'Content-Type':  'application/json',
}


async def _sb_get(table: str, params: dict) -> list:
    async with httpx.AsyncClient(timeout=15) as c:
        r = await c.get(f'{SUPABASE_URL}/rest/v1/{table}', params=params, headers=_sb_hdrs())
        r.raise_for_status()
        return r.json()


async def _sb_post(table: str, data: dict) -> dict:
    async with httpx.AsyncClient(timeout=15) as c:
        r = await c.post(f'{SUPABASE_URL}/rest/v1/{table}', json=data, headers=_sb_hdrs())
        r.raise_for_status()
        result = r.json()
        return result[0] if isinstance(result, list) and result else result


def _intent_html_bar(label: str, count: int, max_count: int) -> str:
    colors = {'FIRE': '#FF4444', 'HOT': '#FF8C00', 'WARM': '#C5A028', 'COLD': '#555'}
    pct = int(count / max(max_count, 1) * 100)
    color = colors.get(label, '#555')
    return (
        f'<div style="margin:6px 0;">'
        f'<span style="font-size:11px;color:#888;width:40px;display:inline-block">{label}</span>'
        f'<div style="display:inline-block;background:{color};width:{pct}%;height:8px;'
        f'border-radius:4px;vertical-align:middle;min-width:4px"></div>'
        f'<span style="font-size:11px;color:#ccc;margin-left:8px">{count}</span>'
        f'</div>'
    )


def _build_html_email(
    tenant_nome: str,
    semana: str,
    stats_atual: dict,
    stats_anterior: dict,
    narrativa: str,
    revenue_risk: int,
    tenant_id: str,
) -> str:
    fire_delta  = stats_atual.get('FIRE', 0) - stats_anterior.get('FIRE', 0)
    delta_sign  = '+' if fire_delta >= 0 else ''
    delta_color = '#00F0FF' if fire_delta >= 0 else '#FF4444'
    max_count   = max(stats_atual.values() or [1])

    bars = ''.join(
        _intent_html_bar(lbl, stats_atual.get(lbl, 0), max_count)
        for lbl in ['FIRE', 'HOT', 'WARM', 'COLD']
    )

    return f"""<!DOCTYPE html>
<html lang="pt-BR">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Sentinel Report — {tenant_nome}</title></head>
<body style="margin:0;padding:0;background:#0A0802;font-family:Inter,Arial,sans-serif;">
<table width="100%" cellpadding="0" cellspacing="0">
<tr><td align="center" style="padding:32px 16px;">
<table width="600" cellpadding="0" cellspacing="0"
  style="background:#111;border-radius:12px;overflow:hidden;border:1px solid #1e1e1e;">

  <!-- Header -->
  <tr><td style="background:linear-gradient(135deg,#0A0802,#1A0B2E);padding:32px;text-align:center;">
    <div style="color:#C5A028;font-size:11px;letter-spacing:3px;text-transform:uppercase">Neural Sentinel</div>
    <h1 style="color:#fff;font-size:24px;margin:8px 0 4px">{tenant_nome}</h1>
    <div style="color:#888;font-size:13px">Relatório de Inteligência — Semana de {semana}</div>
  </td></tr>

  <!-- Delta FIRE -->
  <tr><td style="padding:24px 32px;">
    <table width="100%"><tr>
      <td style="text-align:center;padding:16px;background:#0A0802;border-radius:8px;border:1px solid #222;">
        <div style="color:#888;font-size:11px;letter-spacing:2px;text-transform:uppercase">Delta FIRE esta semana</div>
        <div style="color:{delta_color};font-size:40px;font-weight:700;margin:8px 0">{delta_sign}{fire_delta}</div>
        <div style="color:#555;font-size:11px">sessões de alta intenção vs semana anterior</div>
      </td>
      <td width="16"></td>
      <td style="text-align:center;padding:16px;background:#0A0802;border-radius:8px;border:1px solid #222;">
        <div style="color:#888;font-size:11px;letter-spacing:2px;text-transform:uppercase">Receita em Risco</div>
        <div style="color:#FF4444;font-size:40px;font-weight:700;margin:8px 0">R${revenue_risk:,}</div>
        <div style="color:#555;font-size:11px">leads FIRE sem conversão activa</div>
      </td>
    </tr></table>
  </td></tr>

  <!-- Barras de Intenção -->
  <tr><td style="padding:0 32px 24px;">
    <div style="color:#888;font-size:11px;letter-spacing:2px;text-transform:uppercase;margin-bottom:12px">
      Distribuição de Intenção — 7 dias
    </div>
    {bars}
  </td></tr>

  <!-- Narrativa -->
  <tr><td style="padding:0 32px 24px;">
    <div style="background:#0A0802;border-left:3px solid #C5A028;padding:16px 20px;border-radius:0 8px 8px 0;">
      <div style="color:#C5A028;font-size:11px;letter-spacing:2px;text-transform:uppercase;margin-bottom:8px">
        Análise do Conselheiro
      </div>
      <div style="color:#ccc;font-size:14px;line-height:1.6">{narrativa}</div>
    </div>
  </td></tr>

  <!-- CTA IAH -->
  <tr><td style="padding:0 32px 32px;text-align:center;">
    <div style="color:#555;font-size:12px;margin-bottom:16px">
      Quer transformar estes leads em receita? O Projecto IAH converte intenção em contrato.
    </div>
    <a href="https://vanguard.tech/cockpit?tenant={tenant_id}&utm_source=sentinel_report&utm_medium=email"
       style="background:#C5A028;color:#0A0802;padding:14px 32px;border-radius:6px;
              font-weight:700;font-size:13px;text-decoration:none;letter-spacing:1px;
              display:inline-block">
      INTERVIR AGORA →
    </a>
  </td></tr>

  <!-- Footer -->
  <tr><td style="padding:16px 32px;border-top:1px solid #1e1e1e;text-align:center;">
    <div style="color:#444;font-size:11px">
      Vanguard Intelligence · Neural Sentinel R$97/mês ·
      <a href="https://vanguard.tech/cancelar?tenant={tenant_id}"
         style="color:#444;text-decoration:underline">Cancelar subscrição</a>
    </div>
  </td></tr>

</table>
</td></tr>
</table>
</body>
</html>"""


async def _gerar_narrativa(
    tenant_nome: str,
    stats_atual: dict,
    stats_anterior: dict,
    revenue_risk: int,
) -> str:
    if not ANTHROPIC_KEY:
        fire = stats_atual.get('FIRE', 0)
        return (
            f"Esta semana, {tenant_nome} registou {fire} sessões FIRE — "
            f"leads com intenção máxima de compra. "
            f"Há R${revenue_risk:,} em receita potencial sem acção activa. "
            f"Use o botão 'Intervir Agora' para activar uma oferta directa no site."
        )

    claude = anthropic.Anthropic(api_key=ANTHROPIC_KEY)
    fire_d  = stats_atual.get('FIRE', 0) - stats_anterior.get('FIRE', 0)
    prompt  = f"""És o conselheiro de inteligência de mercado da {tenant_nome}.
Escreve em 2-3 frases (português de Portugal, tom directo e executivo) o resumo semanal.

Dados desta semana vs anterior:
- FIRE: {stats_atual.get("FIRE",0)} (delta {fire_d:+d})
- HOT: {stats_atual.get("HOT",0)}
- WARM: {stats_atual.get("WARM",0)}
- Receita em risco estimada: R${revenue_risk:,}

Menciona o dado mais crítico. Termina com uma frase de urgência discreta."""

    try:
        msg = claude.messages.create(
            model='claude-haiku-4-5-20251001',
            max_tokens=200,
            messages=[{'role': 'user', 'content': prompt}]
        )
        return msg.content[0].text.strip()
    except Exception as e:
        log.warning(f'Haiku narrativa error: {e}')
        return (
            f"Esta semana registámos {stats_atual.get('FIRE',0)} sessões FIRE. "
            f"Há R${revenue_risk:,} em receita potencial sem acção. Intervir agora."
        )


async def _send_via_sendgrid(to_email: str, to_name: str, subject: str, html: str) -> bool:
    if not SENDGRID_API_KEY:
        log.warning('SENDGRID_API_KEY não configurado — email não enviado.')
        return False

    payload = {
        'personalizations': [{'to': [{'email': to_email, 'name': to_name}]}],
        'from':             {'email': SENDGRID_FROM, 'name': SENDGRID_FROM_NAME},
        'subject':          subject,
        'content':          [{'type': 'text/html', 'value': html}],
    }

    async with httpx.AsyncClient(timeout=20) as c:
        r = await c.post(
            'https://api.sendgrid.com/v3/mail/send',
            json=payload,
            headers={
                'Authorization': f'Bearer {SENDGRID_API_KEY}',
                'Content-Type':  'application/json',
            },
        )
        success = r.status_code in (200, 202)
        if not success:
            log.error(f'SendGrid error {r.status_code}: {r.text[:200]}')
        return success


async def _processar_tenant_report(tenant: dict) -> dict:
    """Gera e envia o Report Card para um tenant com subscrição activa."""
    tenant_id   = tenant['id']
    tenant_nome = tenant.get('nome', 'Empresa')
    email       = tenant.get('email', '')

    if not email:
        return {'tenant_id': tenant_id, 'status': 'sem_email'}

    agora    = datetime.now(timezone.utc)
    semana_a = agora - timedelta(days=7)
    semana_b = agora - timedelta(days=14)
    semana_str = semana_a.strftime('%d/%m/%Y')

    # Agregar intenção 0-7 dias e 7-14 dias
    async def _intent_count(label: str, desde: datetime, ate: datetime) -> int:
        try:
            rows = await _sb_get('pixel_events_staging', {
                'tenant_id':   f'eq.{tenant_id}',
                'intent_label': f'eq.{label}',
                'fired_at':    f'gte.{desde.isoformat()}',
                'fired_at.lte': ate.isoformat(),
                'select':      'id',
                'limit':       '1000',
            })
            return len(rows)
        except Exception:
            return 0

    # Paralelo: 4 labels × 2 semanas = 8 queries
    import asyncio
    labels = ['FIRE', 'HOT', 'WARM', 'COLD']
    tasks_atual     = [_intent_count(l, semana_a, agora)  for l in labels]
    tasks_anterior  = [_intent_count(l, semana_b, semana_a) for l in labels]
    counts_atual    = await asyncio.gather(*tasks_atual)
    counts_anterior = await asyncio.gather(*tasks_anterior)

    stats_atual    = dict(zip(labels, counts_atual))
    stats_anterior = dict(zip(labels, counts_anterior))

    # Receita em risco: leads FIRE × ticket médio estimado (R$300 por lead)
    revenue_risk = stats_atual.get('FIRE', 0) * 300

    narrativa = await _gerar_narrativa(tenant_nome, stats_atual, stats_anterior, revenue_risk)
    html      = _build_html_email(tenant_nome, semana_str, stats_atual, stats_anterior, narrativa, revenue_risk, tenant_id)

    subject  = f'🔥 {stats_atual.get("FIRE",0)} leads FIRE esta semana — {tenant_nome} | Sentinel'
    enviado  = await _send_via_sendgrid(email, tenant_nome, subject, html)

    # Log do relatório enviado
    try:
        await _sb_post('sentinel_report_log', {
            'tenant_id':       tenant_id,
            'semana_inicio':   semana_a.date().isoformat(),
            'fire_count':      stats_atual.get('FIRE', 0),
            'hot_count':       stats_atual.get('HOT', 0),
            'warm_count':      stats_atual.get('WARM', 0),
            'revenue_risk':    revenue_risk,
            'email_enviado':   enviado,
            'email_destino':   email,
        })
    except Exception as e:
        log.warning(f'Log report error (não-fatal): {e}')

    log.info(f'Report Card: tenant {tenant_id[:8]} — FIRE={stats_atual["FIRE"]} enviado={enviado}')
    return {
        'tenant_id':    tenant_id,
        'tenant_nome':  tenant_nome,
        'email':        email,
        'stats_atual':  stats_atual,
        'revenue_risk': revenue_risk,
        'enviado':      enviado,
    }


# ─── Endpoints ────────────────────────────────────────────────────────────────

@router.post('/report/generate/{tenant_id}')
async def gerar_report_tenant(tenant_id: str, background_tasks: BackgroundTasks):
    """
    Gera e envia o Sentinel Report Card para um tenant específico.
    Útil para testar antes do envio semanal automático.
    """
    tenants = await _sb_get('tenants', {'id': f'eq.{tenant_id}', 'status': 'eq.active'})
    if not tenants:
        raise HTTPException(404, 'Tenant não encontrado ou inactivo.')

    tenant = tenants[0]
    result = await _processar_tenant_report(tenant)
    return result


@router.post('/report/send-weekly')
async def enviar_reports_semanais(
    background_tasks: BackgroundTasks,
    authorization: Optional[str] = Header(None),
):
    """
    Envia Sentinel Report Card para TODOS os tenants com subscrição activa.
    Chamado pelo pg_cron toda segunda-feira às 08:00 BRT via webhook.
    Protegido por CRON_SECRET.
    """
    cron_secret = os.getenv('CRON_SECRET', '')
    if cron_secret and authorization != f'Bearer {cron_secret}':
        raise HTTPException(401, 'Não autorizado.')

    # Tenants com subscrição activa
    subs = await _sb_get('tenant_subscriptions', {
        'status': 'eq.active',
        'select': 'tenant_id',
    })
    tenant_ids = list({s['tenant_id'] for s in subs})

    if not tenant_ids:
        return {'enviados': 0, 'mensagem': 'Sem subscrições activas.'}

    # Buscar dados dos tenants
    tenants_raw = await _sb_get('tenants', {
        'id':    f'in.({",".join(tenant_ids)})',
        'status': 'eq.active',
    })

    import asyncio
    resultados = await asyncio.gather(
        *[_processar_tenant_report(t) for t in tenants_raw],
        return_exceptions=True
    )

    enviados  = sum(1 for r in resultados if isinstance(r, dict) and r.get('enviado'))
    erros     = sum(1 for r in resultados if isinstance(r, Exception))

    log.info(f'Weekly Report: {enviados}/{len(tenants_raw)} enviados, {erros} erros')
    return {
        'total_tenants': len(tenants_raw),
        'enviados':      enviados,
        'erros':         erros,
        'resultados':    [r for r in resultados if isinstance(r, dict)],
    }


@router.get('/report/preview/{tenant_id}')
async def preview_report(tenant_id: str):
    """
    Retorna os dados que seriam incluídos no próximo Report Card.
    Útil para o Cockpit mostrar uma pré-visualização sem enviar email.
    """
    tenants = await _sb_get('tenants', {'id': f'eq.{tenant_id}'})
    if not tenants:
        raise HTTPException(404, 'Tenant não encontrado.')

    tenant  = tenants[0]
    agora   = datetime.now(timezone.utc)
    semana_a = agora - timedelta(days=7)
    semana_b = agora - timedelta(days=14)

    async def _count(label: str, desde: datetime, ate: datetime) -> int:
        try:
            rows = await _sb_get('pixel_events_staging', {
                'tenant_id':   f'eq.{tenant_id}',
                'intent_label': f'eq.{label}',
                'fired_at':    f'gte.{desde.isoformat()}',
                'select':      'id', 'limit': '1000',
            })
            return len(rows)
        except Exception:
            return 0

    import asyncio
    labels = ['FIRE', 'HOT', 'WARM', 'COLD']
    c_atual     = await asyncio.gather(*[_count(l, semana_a, agora)    for l in labels])
    c_anterior  = await asyncio.gather(*[_count(l, semana_b, semana_a) for l in labels])

    stats_atual    = dict(zip(labels, c_atual))
    stats_anterior = dict(zip(labels, c_anterior))
    revenue_risk   = stats_atual.get('FIRE', 0) * 300

    return {
        'tenant_id':       tenant_id,
        'tenant_nome':     tenant.get('nome'),
        'semana_inicio':   semana_a.date().isoformat(),
        'stats_atual':     stats_atual,
        'stats_anterior':  stats_anterior,
        'delta_fire':      stats_atual.get('FIRE', 0) - stats_anterior.get('FIRE', 0),
        'revenue_risk':    revenue_risk,
        'email_destino':   tenant.get('email'),
    }
