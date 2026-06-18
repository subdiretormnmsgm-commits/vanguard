#!/usr/bin/env python3
"""
Vanguard V8 — Fractal White-Label Engine
FastAPI Router: /api/fractal/

Lógica de Sub-Tenants: Tenant Pro pode criar sub-tenants com brand própria.
Quota partilhada do parent — cada lead do sub-tenant debita o parent.

Endpoints (JWT obrigatório, plano >= pro):
  POST   /api/fractal/sub-tenants           — criar sub-tenant
  GET    /api/fractal/sub-tenants           — listar sub-tenants do parent
  GET    /api/fractal/sub-tenants/{id}      — detalhe do sub-tenant
  PATCH  /api/fractal/sub-tenants/{id}      — actualizar (quota, email, nome)
  PATCH  /api/fractal/sub-tenants/{id}/brand — actualizar brand_config
  DELETE /api/fractal/sub-tenants/{id}      — desactivar (soft delete)
  GET    /api/fractal/dashboard             — KPIs do sistema Fractal
"""

import logging
from typing import Optional

import httpx
from fastapi import APIRouter, Header, HTTPException
from pydantic import BaseModel, Field, field_validator

log = logging.getLogger('vanguard-fractal')

router = APIRouter(prefix='/api/fractal', tags=['Fractal White-Label'])

PLANOS_FRACTAL = ('pro', 'enterprise')  # planos que podem ter sub-tenants


# ─── Modelos Pydantic ─────────────────────────────────────────────────────────

class BrandConfig(BaseModel):
    nome:      str   = Field('Agência', min_length=2, max_length=80)
    primary:   str   = Field('#00F0FF', pattern=r'^#[0-9A-Fa-f]{6}$')
    secondary: str   = Field('#1A0B2E', pattern=r'^#[0-9A-Fa-f]{6}$')
    accent:    str   = Field('#7B2FFF', pattern=r'^#[0-9A-Fa-f]{6}$')
    bg:        str   = Field('#0A0A0A', pattern=r'^#[0-9A-Fa-f]{6}$')
    logo_url:  str   = Field('', max_length=500)


class CriarSubTenantReq(BaseModel):
    nome:         str         = Field(..., min_length=2, max_length=120)
    email:        str         = Field(..., min_length=5, max_length=200)
    leads_quota:  int         = Field(50, ge=5, le=500)
    brand_config: BrandConfig = Field(default_factory=BrandConfig)
    preco_cobrado: float      = Field(0.0, ge=0, le=9999)

    @field_validator('email')
    @classmethod
    def validar_email(cls, v: str) -> str:
        if '@' not in v or '.' not in v.split('@')[-1]:
            raise ValueError('Email inválido')
        return v.lower().strip()


class UpdateSubTenantReq(BaseModel):
    nome:         Optional[str]   = Field(None, min_length=2, max_length=120)
    email:        Optional[str]   = None
    leads_quota:  Optional[int]   = Field(None, ge=5, le=500)
    preco_cobrado: Optional[float]= Field(None, ge=0, le=9999)
    ativo:        Optional[bool]  = None


# ─── Factory para injectar deps do main ───────────────────────────────────────

def make_fractal_router(
    supabase_url: str,
    service_key: str,
    autenticar_fn,
    get_tenant_fn,
) -> APIRouter:
    """Cria o router com as deps injectadas (evita import circular)."""

    sb_headers_base = {
        'apikey':        service_key,
        'Authorization': f'Bearer {service_key}',
        'Content-Type':  'application/json',
        'Prefer':        'return=representation',
    }

    async def _sb_get(table: str, params: dict) -> list:
        async with httpx.AsyncClient(timeout=10) as c:
            r = await c.get(
                f'{supabase_url}/rest/v1/{table}',
                params=params,
                headers=sb_headers_base,
            )
            r.raise_for_status()
            return r.json()

    async def _sb_post(table: str, data: dict) -> dict:
        async with httpx.AsyncClient(timeout=10) as c:
            r = await c.post(
                f'{supabase_url}/rest/v1/{table}',
                json=data,
                headers=sb_headers_base,
            )
            r.raise_for_status()
            result = r.json()
            return result[0] if isinstance(result, list) and result else result

    async def _sb_patch(table: str, filtro: str, data: dict) -> None:
        async with httpx.AsyncClient(timeout=10) as c:
            r = await c.patch(
                f'{supabase_url}/rest/v1/{table}?{filtro}',
                json=data,
                headers={**sb_headers_base, 'Prefer': 'return=minimal'},
            )
            r.raise_for_status()

    async def _get_parent_tenant(authorization: Optional[str]) -> dict:
        """Valida JWT e verifica que o tenant tem plano Pro/Enterprise."""
        _, user_id = await autenticar_fn(authorization)
        async with httpx.AsyncClient(timeout=10) as client:
            tenant = await get_tenant_fn(client, user_id)
        if tenant.get('plano') not in PLANOS_FRACTAL:
            raise HTTPException(
                403,
                f'Sistema Fractal requer plano Pro ou Enterprise. '
                f'Plano actual: {tenant.get("plano", "trial")}.',
            )
        return tenant

    async def _get_sub_tenant(sub_id: str, parent_id: str) -> dict:
        """Busca sub-tenant e verifica que pertence ao parent."""
        rows = await _sb_get('sub_tenants', {
            'id':               f'eq.{sub_id}',
            'parent_tenant_id': f'eq.{parent_id}',
        })
        if not rows:
            raise HTTPException(404, 'Sub-tenant não encontrado.')
        return rows[0]

    # ─────────────────────────────────────────────────────────────────────────

    @router.post('/sub-tenants', status_code=201)
    async def criar_sub_tenant(
        req:           CriarSubTenantReq,
        authorization: Optional[str] = Header(None),
    ):
        """Cria um novo sub-tenant com brand_config própria."""
        parent = await _get_parent_tenant(authorization)

        # Verificar se a quota do parent comporta o sub-tenant
        quota_restante = parent['leads_quota'] - parent['leads_usados']
        if req.leads_quota > quota_restante:
            raise HTTPException(
                400,
                f'Quota insuficiente no parent: {quota_restante} leads restantes. '
                f'Pedido: {req.leads_quota} leads para o sub-tenant.',
            )

        # Verificar email único
        existente = await _sb_get('sub_tenants', {
            'email':            f'eq.{req.email}',
            'parent_tenant_id': f'eq.{parent["id"]}',
            'ativo':            'eq.true',
        })
        if existente:
            raise HTTPException(409, 'Já existe um sub-tenant activo com este email.')

        sub = await _sb_post('sub_tenants', {
            'parent_tenant_id': parent['id'],
            'nome':             req.nome,
            'email':            req.email,
            'leads_quota':      req.leads_quota,
            'leads_usados':     0,
            'brand_config':     req.brand_config.model_dump(),
            'preco_cobrado':    req.preco_cobrado,
            'ativo':            True,
        })

        log.info(f'Sub-tenant criado: {sub["id"][:8]} — parent {parent["id"][:8]}')
        return sub

    @router.get('/sub-tenants')
    async def listar_sub_tenants(
        ativo:         Optional[bool] = None,
        authorization: Optional[str]  = Header(None),
    ):
        """Lista todos os sub-tenants do parent autenticado."""
        parent = await _get_parent_tenant(authorization)

        params: dict = {
            'parent_tenant_id': f'eq.{parent["id"]}',
            'order':            'created_at.desc',
        }
        if ativo is not None:
            params['ativo'] = f'eq.{str(ativo).lower()}'

        rows = await _sb_get('sub_tenants', params)

        # KPIs agregados
        total_quota  = sum(r['leads_quota']  for r in rows)
        total_usados = sum(r['leads_usados'] for r in rows)
        receita_total= sum(float(r.get('preco_cobrado', 0)) for r in rows if r.get('ativo'))

        return {
            'sub_tenants':    rows,
            'total':          len(rows),
            'kpis': {
                'quota_cedida':    total_quota,
                'leads_gerados':   total_usados,
                'receita_mensal':  round(receita_total, 2),
                'quota_parent_restante': parent['leads_quota'] - parent['leads_usados'],
            },
        }

    @router.get('/sub-tenants/{sub_id}')
    async def detalhe_sub_tenant(
        sub_id:        str,
        authorization: Optional[str] = Header(None),
    ):
        """Detalhe de um sub-tenant específico."""
        parent = await _get_parent_tenant(authorization)
        return await _get_sub_tenant(sub_id, parent['id'])

    @router.patch('/sub-tenants/{sub_id}')
    async def actualizar_sub_tenant(
        sub_id:        str,
        req:           UpdateSubTenantReq,
        authorization: Optional[str] = Header(None),
    ):
        """Actualiza nome, email, quota ou status do sub-tenant."""
        parent = await _get_parent_tenant(authorization)
        sub    = await _get_sub_tenant(sub_id, parent['id'])

        # Validar nova quota
        if req.leads_quota is not None:
            delta = req.leads_quota - sub['leads_quota']
            if delta > 0:
                quota_restante = parent['leads_quota'] - parent['leads_usados']
                if delta > quota_restante:
                    raise HTTPException(
                        400,
                        f'Não há quota suficiente no parent para este aumento '
                        f'(+{delta} pedidos, {quota_restante} disponíveis).',
                    )

        updates = {k: v for k, v in req.model_dump().items() if v is not None}
        if not updates:
            return sub

        updates['updated_at'] = 'now()'
        await _sb_patch('sub_tenants', f'id=eq.{sub_id}', updates)

        log.info(f'Sub-tenant {sub_id[:8]} actualizado por parent {parent["id"][:8]}')
        return {**sub, **updates}

    @router.patch('/sub-tenants/{sub_id}/brand')
    async def actualizar_brand(
        sub_id:        str,
        brand:         BrandConfig,
        authorization: Optional[str] = Header(None),
    ):
        """Actualiza o brand_config (logo, cores) do sub-tenant."""
        parent = await _get_parent_tenant(authorization)
        await _get_sub_tenant(sub_id, parent['id'])

        await _sb_patch('sub_tenants', f'id=eq.{sub_id}', {
            'brand_config': brand.model_dump(),
            'updated_at':   'now()',
        })

        log.info(f'Brand config actualizada: sub-tenant {sub_id[:8]}')
        return {'status': 'ok', 'brand_config': brand.model_dump()}

    @router.delete('/sub-tenants/{sub_id}')
    async def desactivar_sub_tenant(
        sub_id:        str,
        authorization: Optional[str] = Header(None),
    ):
        """Soft delete — desactiva o sub-tenant (dados preservados)."""
        parent = await _get_parent_tenant(authorization)
        await _get_sub_tenant(sub_id, parent['id'])

        await _sb_patch('sub_tenants', f'id=eq.{sub_id}', {
            'ativo':      False,
            'updated_at': 'now()',
        })

        log.info(f'Sub-tenant {sub_id[:8]} desactivado por parent {parent["id"][:8]}')
        return {'status': 'desactivado', 'id': sub_id}

    @router.get('/dashboard')
    async def fractal_dashboard(authorization: Optional[str] = Header(None)):
        """KPIs globais do sistema Fractal para o parent autenticado."""
        parent = await _get_parent_tenant(authorization)

        rows = await _sb_get('sub_tenants', {
            'parent_tenant_id': f'eq.{parent["id"]}',
        })

        ativos    = [r for r in rows if r.get('ativo')]
        inativos  = [r for r in rows if not r.get('ativo')]
        receita   = sum(float(r.get('preco_cobrado', 0)) for r in ativos)
        quota_cedida  = sum(r['leads_quota']  for r in ativos)
        leads_gerados = sum(r['leads_usados'] for r in rows)

        return {
            'parent_id':        parent['id'],
            'parent_plano':     parent['plano'],
            'sub_tenants': {
                'total':    len(rows),
                'ativos':   len(ativos),
                'inativos': len(inativos),
            },
            'quota': {
                'total_parent':  parent['leads_quota'],
                'usado_parent':  parent['leads_usados'],
                'cedido_subs':   quota_cedida,
                'disponivel':    parent['leads_quota'] - parent['leads_usados'],
            },
            'receita_mensal_mrr': round(receita, 2),
            'leads_gerados_total': leads_gerados,
            'sub_tenants_lista': ativos,
        }

    return router
