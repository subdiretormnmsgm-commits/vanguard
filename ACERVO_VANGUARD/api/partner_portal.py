"""
Vanguard V23 — Partner Portal Alpha
FastAPI Router: /api/partners/

Canal de vendas via parceiros: agências de marketing indicam clientes e
recebem comissão automática (20% do 1.º mês Sentinel + R$600 por IAH).

LGPD: a agência só vê dados de clientes que consentiram no signup.
"""

import hashlib
import logging
import os
import secrets
from datetime import datetime, timezone
from typing import Optional

import httpx
from fastapi import APIRouter, Header, HTTPException
from pydantic import BaseModel

log = logging.getLogger('vanguard-partner-portal')

router = APIRouter(prefix='/api/partners', tags=['Partner Portal'])

SUPABASE_URL = os.getenv('SUPABASE_URL', '')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY', os.getenv('SUPABASE_ANON_KEY', ''))
BASE_URL     = os.getenv('VANGUARD_BASE_URL', 'https://vanguard.tech')

# Comissões
COMISSAO_SENTINEL_PCT  = 0.20   # 20% do 1.º mês (R$97) = R$19,40
COMISSAO_IAH_VALOR     = 600.0  # R$600 por Projecto IAH convertido

_sb_hdrs = lambda: {
    'apikey':        SUPABASE_KEY,
    'Authorization': f'Bearer {SUPABASE_KEY}',
    'Content-Type':  'application/json',
    'Prefer':        'return=representation',
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


async def _sb_patch(table: str, filters: dict, data: dict) -> list:
    params = {k: v for k, v in filters.items()}
    async with httpx.AsyncClient(timeout=15) as c:
        r = await c.patch(
            f'{SUPABASE_URL}/rest/v1/{table}',
            params=params,
            json=data,
            headers=_sb_hdrs(),
        )
        r.raise_for_status()
        return r.json()


def _gerar_partner_key() -> tuple[str, str]:
    """Retorna (raw_key, key_hash). raw_key é mostrado uma vez."""
    raw  = f"vg-partner-{secrets.token_urlsafe(20)}"
    hashed = hashlib.sha256(raw.encode()).hexdigest()
    return raw, hashed


async def _validar_partner(api_key: Optional[str]) -> dict:
    if not api_key:
        raise HTTPException(401, 'X-Partner-Key obrigatório.')
    key_hash = hashlib.sha256(api_key.encode()).hexdigest()
    rows = await _sb_get('partner_agencies', {
        'key_hash': f'eq.{key_hash}',
        'status':   'eq.active',
    })
    if not rows:
        raise HTTPException(403, 'Chave de parceiro inválida ou inactiva.')
    return rows[0]


# ─── Models ───────────────────────────────────────────────────────────────────

class PartnerRegisterRequest(BaseModel):
    nome_agencia:  str
    email_contato: str
    responsavel:   str
    telefone:      Optional[str] = None
    site:          Optional[str] = None


class CommissionRecordRequest(BaseModel):
    referral_id: str
    tipo:        str   # 'sentinel' | 'iah'
    tenant_id:   str


# ─── Endpoints ────────────────────────────────────────────────────────────────

@router.post('/register')
async def registar_parceiro(body: PartnerRegisterRequest):
    """
    Regista uma nova agência parceira e retorna a API key (mostrada apenas uma vez).
    """
    raw_key, key_hash = _gerar_partner_key()
    partner_code = f"VGP-{secrets.token_hex(4).upper()}"

    partner = await _sb_post('partner_agencies', {
        'nome_agencia':  body.nome_agencia,
        'email_contato': body.email_contato,
        'responsavel':   body.responsavel,
        'telefone':      body.telefone,
        'site':          body.site,
        'key_hash':      key_hash,
        'partner_code':  partner_code,
        'status':        'active',
        'criado_em':     datetime.now(timezone.utc).isoformat(),
    })

    return {
        'partner_id':   partner.get('id'),
        'partner_code': partner_code,
        'api_key':      raw_key,
        'aviso':        'Guarde esta chave — não será exibida novamente.',
        'link_afiliado': f'{BASE_URL}/?ref={partner_code}',
        'comissoes': {
            'sentinel': f'R${97 * COMISSAO_SENTINEL_PCT:.2f} por activação Neural Sentinel',
            'iah':      f'R${COMISSAO_IAH_VALOR:.0f} por Projecto IAH convertido',
        },
    }


@router.get('/link')
async def obter_link_afiliado(x_partner_key: Optional[str] = Header(None)):
    """Retorna o link de afiliado da agência parceira."""
    partner = await _validar_partner(x_partner_key)
    code    = partner['partner_code']
    return {
        'partner_id':    partner['id'],
        'nome_agencia':  partner['nome_agencia'],
        'link_afiliado': f'{BASE_URL}/?ref={code}',
        'link_diagnostic': f'{BASE_URL}/#quiz?ref={code}',
        'instrucoes': (
            'Partilhe este link com os seus clientes. '
            'Quando activarem o Neural Sentinel, receberá a comissão automaticamente.'
        ),
    }


@router.get('/dashboard')
async def dashboard_parceiro(x_partner_key: Optional[str] = Header(None)):
    """
    Dashboard de performance da agência:
    - Referrals activos (com consentimento do cliente)
    - Comissões ganhas
    - Pipeline de leads
    """
    partner = await _validar_partner(x_partner_key)
    pid     = partner['id']

    # Referrals activos
    try:
        referrals = await _sb_get('partner_referrals', {
            'partner_id': f'eq.{pid}',
            'select':     '*',
        })
    except Exception:
        referrals = []

    # Comissões
    try:
        comissoes = await _sb_get('partner_commissions', {
            'partner_id': f'eq.{pid}',
            'select':     '*',
        })
    except Exception:
        comissoes = []

    total_sentinel = sum(c.get('valor', 0) for c in comissoes if c.get('tipo') == 'sentinel')
    total_iah      = sum(c.get('valor', 0) for c in comissoes if c.get('tipo') == 'iah')
    total_ganho    = total_sentinel + total_iah

    activos = [r for r in referrals if r.get('status') == 'active']

    return {
        'partner_id':   pid,
        'nome_agencia': partner['nome_agencia'],
        'referrals': {
            'total':   len(referrals),
            'activos': len(activos),
            'pendentes': len([r for r in referrals if r.get('status') == 'pending']),
        },
        'comissoes': {
            'total_ganho':     f'R${total_ganho:.2f}',
            'sentinel':        f'R${total_sentinel:.2f}',
            'iah':             f'R${total_iah:.2f}',
            'pendente_pagamento': f'R${sum(c.get("valor", 0) for c in comissoes if c.get("pago") is False):.2f}',
        },
        'link_afiliado': f'{BASE_URL}/?ref={partner["partner_code"]}',
    }


@router.get('/clients')
async def clientes_da_agencia(x_partner_key: Optional[str] = Header(None)):
    """
    Lista os clientes que a agência indicou E que consentiram em partilhar dados.
    LGPD: só retorna dados de tenants com metadata.partner_consent = True.

    Inclui Maturity Score para a agência usar como argumento de venda
    ("o seu score caiu — precisam de mais serviço").
    """
    partner = await _validar_partner(x_partner_key)
    pid     = partner['id']

    # Referrals activos desta agência
    try:
        referrals = await _sb_get('partner_referrals', {
            'partner_id': f'eq.{pid}',
            'status':     'eq.active',
            'select':     'tenant_id,criado_em',
        })
    except Exception:
        referrals = []

    if not referrals:
        return {'clientes': [], 'total': 0}

    tenant_ids = [r['tenant_id'] for r in referrals]
    tenant_id_filter = f'in.({",".join(tenant_ids)})'

    # Tenants com consentimento (LGPD)
    try:
        tenants = await _sb_get('tenants', {
            'id':     tenant_id_filter,
            'select': 'id,nome,email,metadata,criado_em',
        })
    except Exception:
        tenants = []

    # Filtrar apenas os que deram consentimento
    consented = [
        t for t in tenants
        if (t.get('metadata') or {}).get('partner_consent') is True
    ]

    # Buscar último score de cada tenant
    result = []
    for t in consented:
        tid = t['id']
        score = None
        trend = 'sem_dados'
        try:
            scores = await _sb_get('maturity_scores', {
                'tenant_id': f'eq.{tid}',
                'select':    'score,calculado_em',
                'order':     'calculado_em.desc',
                'limit':     '2',
            })
            if scores:
                score = scores[0].get('score')
                if len(scores) == 2:
                    delta = score - scores[1].get('score', score)
                    trend = 'subindo' if delta > 0.5 else 'caindo' if delta < -0.5 else 'estável'
        except Exception:
            pass

        result.append({
            'tenant_id':   tid,
            'nome':        t.get('nome'),
            'maturity_score': score,
            'tendencia':   trend,
            'alerta':      trend == 'caindo',
            'desde':       t.get('criado_em'),
        })

    return {
        'clientes': result,
        'total':    len(result),
        'nota_lgpd': f'{len(consented)} de {len(tenants)} clientes autorizaram a partilha de dados.',
    }


@router.post('/commission/record')
async def registar_comissao(
    body: CommissionRecordRequest,
    x_partner_key: Optional[str] = Header(None),
):
    """
    Regista uma comissão quando um referral converte (Sentinel ou IAH).
    Chamado internamente pelo webhook do Stripe.
    """
    partner = await _validar_partner(x_partner_key)
    pid     = partner['id']

    valor = 97 * COMISSAO_SENTINEL_PCT if body.tipo == 'sentinel' else COMISSAO_IAH_VALOR

    comissao = await _sb_post('partner_commissions', {
        'partner_id':  pid,
        'referral_id': body.referral_id,
        'tenant_id':   body.tenant_id,
        'tipo':        body.tipo,
        'valor':       valor,
        'pago':        False,
        'registado_em': datetime.now(timezone.utc).isoformat(),
    })

    log.info(f'Comissão registada: parceiro {pid[:8]} tipo={body.tipo} valor=R${valor}')
    return {
        'comissao_id': comissao.get('id'),
        'valor':       f'R${valor:.2f}',
        'status':      'pendente_pagamento',
    }


@router.post('/referral/register')
async def registar_referral(
    tenant_id: str,
    partner_code: str,
):
    """
    Chamado quando um novo tenant se regista via link de afiliado (?ref=VGP-XXXX).
    Cria o registo de referral e pede consentimento.
    """
    parceiros = await _sb_get('partner_agencies', {
        'partner_code': f'eq.{partner_code}',
        'status':       'eq.active',
    })
    if not parceiros:
        return {'registado': False, 'motivo': 'Código de parceiro inválido.'}

    pid = parceiros[0]['id']

    referral = await _sb_post('partner_referrals', {
        'partner_id': pid,
        'tenant_id':  tenant_id,
        'status':     'pending',
        'criado_em':  datetime.now(timezone.utc).isoformat(),
    })

    # Actualizar metadata do tenant para registar a referência
    try:
        await _sb_patch(
            'tenants',
            {'id': f'eq.{tenant_id}'},
            {'metadata': {'referred_by': pid, 'partner_code': partner_code}},
        )
    except Exception as e:
        log.warning(f'Referral metadata update error (não-fatal): {e}')

    return {
        'referral_id': referral.get('id'),
        'partner_id':  pid,
        'status':      'pending',
        'nota':        (
            'O tenant deve consentir a partilha de dados com a agência '
            'para activar o dashboard de scores.'
        ),
    }
