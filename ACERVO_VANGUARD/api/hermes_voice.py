#!/usr/bin/env python3
"""
Vanguard V9 — Hermes Voz & Persona
FastAPI Router: /api/hermes/

Multimodal Hermes: Transita de WhatsApp para chamadas de voz (Vapi/ElevenLabs).
Claude analisa histórico WA e aprende a persona comunicativa do tenant.

Endpoints (JWT obrigatório):
  GET    /api/hermes/persona              — persona do tenant (ou criar default)
  POST   /api/hermes/persona/analisar     — Claude analisa histórico WA → aprende persona
  GET    /api/hermes/variantes            — variantes A/B com performance
  POST   /api/hermes/variantes            — criar variante
  DELETE /api/hermes/variantes/{id}       — desactivar variante
  POST   /api/hermes/variantes/selecionar — Claude escolhe melhor variante para lead
  POST   /api/hermes/voice/iniciar        — iniciar chamada de voz (Vapi/ElevenLabs)
  POST   /api/hermes/voice/webhook        — receber eventos de chamada
  GET    /api/hermes/voice/historico      — histórico de chamadas
  GET    /api/hermes/performance          — KPIs globais do Hermes
"""

import json
import logging
import os
from typing import Optional

import anthropic
import httpx
from fastapi import APIRouter, Header, HTTPException, Request, Response
from pydantic import BaseModel, Field

log = logging.getLogger('vanguard-hermes-voice')

router = APIRouter(prefix='/api/hermes', tags=['Hermes Voz & Persona'])


class CriarVarianteReq(BaseModel):
    nome:     str  = Field(..., min_length=2, max_length=80)
    template: str  = Field(..., min_length=20, max_length=1000,
                           description='Use {nome}, {cidade}, {gargalo}, {ai_hook}')
    nicho:    Optional[str] = None
    canal:    str  = Field('whatsapp', pattern=r'^(whatsapp|voice|email)$')


class IniciarChamadaReq(BaseModel):
    lead_id:       str
    variante_id:   Optional[str] = None
    provider:      str = Field('vapi', pattern=r'^(vapi|elevenlabs)$')
    numero_destino: Optional[str] = None


def make_hermes_voice_router(
    supabase_url:   str,
    service_key:    str,
    anthropic_key:  str,
    vapi_key:       str,
    autenticar_fn,
    get_tenant_fn,
) -> APIRouter:

    claude  = anthropic.Anthropic(api_key=anthropic_key)

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

    async def _get_tenant_auth(authorization: Optional[str]) -> dict:
        _, user_id = await autenticar_fn(authorization)
        async with httpx.AsyncClient(timeout=10) as c:
            return await get_tenant_fn(c, user_id)

    # ─── Persona ──────────────────────────────────────────────────────────────

    @router.get('/persona')
    async def get_persona(authorization: Optional[str] = Header(None)):
        """Retorna a persona aprendida do Hermes para este tenant."""
        tenant = await _get_tenant_auth(authorization)

        rows = await _sb_get('hermes_personas', {
            'tenant_id': f'eq.{tenant["id"]}',
        })

        if rows:
            return rows[0]

        # Criar persona default se não existe
        persona = await _sb_post('hermes_personas', {
            'tenant_id': tenant['id'],
            'tom':       'neutro',
            'tamanho_msg': 'medio',
            'usa_emoji': False,
        })
        return persona

    @router.post('/persona/analisar')
    async def analisar_persona(authorization: Optional[str] = Header(None)):
        """
        Claude Sonnet analisa o histórico WA do tenant e extrai a persona
        comunicativa que mais converte: tom, tamanho, CTA, abertura.
        """
        tenant = await _get_tenant_auth(authorization)

        # Buscar histórico de leads com informação de resposta
        leads = await _sb_get('leads_diagnostico', {
            'tenant_id': f'eq.{tenant["id"]}',
            'select':    'nome,nicho,ai_hook,score_digital',
            'limit':     '30',
            'order':     'created_at.desc',
        })

        # Buscar chamadas com outcome para análise
        calls = await _sb_get('hermes_voice_calls', {
            'tenant_id': f'eq.{tenant["id"]}',
            'select':    'transcricao,outcome,duracao_seg',
            'limit':     '10',
            'order':     'created_at.desc',
        })

        if not leads:
            raise HTTPException(
                400, 'Sem leads suficientes para análise. Execute pelo menos 1 scraper primeiro.'
            )

        # Prompt de análise de persona
        leads_sample = json.dumps([{
            'nicho':       l.get('nicho'),
            'ai_hook':     (l.get('ai_hook') or '')[:150],
            'score':       l.get('score_digital'),
        } for l in leads[:15]], ensure_ascii=False)

        calls_sample = json.dumps([{
            'outcome':    c.get('outcome'),
            'duracao':    c.get('duracao_seg'),
            'transcricao':(c.get('transcricao') or '')[:300],
        } for c in calls[:5]], ensure_ascii=False) if calls else '[]'

        prompt = f"""Analisa os seguintes dados de prospecção do tenant e define a PERSONA HERMES óptima.

LEADS RECENTES (amostra):
{leads_sample}

CHAMADAS COM OUTCOME (amostra):
{calls_sample}

Com base nestes dados, determina:
1. Tom de comunicação ideal (formal/neutro/casual/urgente)
2. Tamanho da mensagem ideal (curto/medio/longo)
3. Uso de emoji (true/false)
4. Frase de abertura que deve usar (curta, específica ao nicho)
5. CTA mais efectivo para o nicho dominante
6. Insights sobre o que funciona melhor nestes dados

Responde APENAS em JSON válido com este schema:
{{
  "tom": "neutro",
  "tamanho_msg": "medio",
  "usa_emoji": false,
  "abertura_padrao": "frase de abertura específica",
  "cta_padrao": "call-to-action específico",
  "insight_geral": "observação sobre o padrão identificado"
}}"""

        try:
            msg = claude.messages.create(
                model='claude-haiku-4-5-20251001',
                max_tokens=512,
                messages=[{'role': 'user', 'content': prompt}]
            )
            raw_text = msg.content[0].text.strip()

            # Extrair JSON da resposta
            import re
            json_match = re.search(r'\{.*\}', raw_text, re.DOTALL)
            if not json_match:
                raise ValueError('Claude não retornou JSON válido')

            analise = json.loads(json_match.group())

            # Actualizar persona
            await _sb_patch('hermes_personas', f'tenant_id=eq.{tenant["id"]}', {
                'tom':             analise.get('tom', 'neutro'),
                'tamanho_msg':     analise.get('tamanho_msg', 'medio'),
                'usa_emoji':       analise.get('usa_emoji', False),
                'abertura_padrao': analise.get('abertura_padrao'),
                'cta_padrao':      analise.get('cta_padrao'),
                'total_analisados': len(leads),
                'analisado_em':    'now()',
                'updated_at':      'now()',
            })

            log.info(f'Persona analisada: tenant {tenant["id"][:8]} — tom={analise.get("tom")}')
            return {
                'persona_actualizada': True,
                'analise':             analise,
                'leads_analisados':    len(leads),
            }

        except (json.JSONDecodeError, ValueError, anthropic.APIError) as e:
            raise HTTPException(502, f'Erro na análise: {str(e)}')

    # ─── Variantes A/B ────────────────────────────────────────────────────────

    @router.get('/variantes')
    async def listar_variantes(authorization: Optional[str] = Header(None)):
        """Lista variantes A/B com taxa de resposta."""
        tenant = await _get_tenant_auth(authorization)
        rows = await _sb_get('hermes_variants', {
            'tenant_id': f'eq.{tenant["id"]}',
            'ativo':     'eq.true',
            'order':     'taxa_resposta.desc',
        })
        winner = next((r for r in rows if r.get('is_winner')), None)
        return {'variantes': rows, 'total': len(rows), 'winner': winner}

    @router.post('/variantes', status_code=201)
    async def criar_variante(
        req:           CriarVarianteReq,
        authorization: Optional[str] = Header(None),
    ):
        """Cria uma nova variante de mensagem para A/B testing."""
        tenant = await _get_tenant_auth(authorization)
        variante = await _sb_post('hermes_variants', {
            'tenant_id': tenant['id'],
            'nome':      req.nome,
            'template':  req.template,
            'nicho':     req.nicho,
            'canal':     req.canal,
        })
        return variante

    @router.post('/variantes/selecionar')
    async def selecionar_variante(
        lead_id:       str,
        authorization: Optional[str] = Header(None),
    ):
        """Claude escolhe a melhor variante para este lead com base no nicho e persona."""
        tenant = await _get_tenant_auth(authorization)

        leads = await _sb_get('leads_diagnostico', {
            'id':        f'eq.{lead_id}',
            'tenant_id': f'eq.{tenant["id"]}',
            'select':    'nicho,cidade,score_digital,gargalo,ai_hook',
        })
        if not leads:
            raise HTTPException(404, 'Lead não encontrado.')

        lead     = leads[0]
        variantes = await _sb_get('hermes_variants', {
            'tenant_id': f'eq.{tenant["id"]}',
            'ativo':     'eq.true',
        })

        if not variantes:
            raise HTTPException(400, 'Sem variantes criadas. Crie pelo menos uma variante.')

        variantes_info = json.dumps([{
            'id':            v['id'],
            'nome':          v['nome'],
            'template':      v['template'][:200],
            'nicho':         v.get('nicho'),
            'taxa_resposta': v.get('taxa_resposta', 0),
            'total_enviados':v.get('total_enviados', 0),
        } for v in variantes], ensure_ascii=False)

        prompt = f"""Escolhe a variante mais adequada para este lead.

LEAD:
- Nicho: {lead.get('nicho')}
- Cidade: {lead.get('cidade')}
- Score digital: {lead.get('score_digital')}
- Gargalo: {lead.get('gargalo')}
- AI Hook: {(lead.get('ai_hook') or '')[:150]}

VARIANTES DISPONÍVEIS:
{variantes_info}

Considerando o nicho, o gargalo e as taxas de resposta históricas, qual variante é mais adequada?
Responde APENAS com o UUID da variante seleccionada (sem mais texto)."""

        try:
            msg = claude.messages.create(
                model='claude-haiku-4-5-20251001',
                max_tokens=64,
                messages=[{'role': 'user', 'content': prompt}]
            )
            variante_id = msg.content[0].text.strip().strip('"\'')

            # Validar que o UUID existe
            var_escolhida = next((v for v in variantes if v['id'] == variante_id), None)
            if not var_escolhida:
                var_escolhida = max(variantes, key=lambda v: v.get('taxa_resposta', 0))

            # Renderizar template
            template = var_escolhida['template']
            msg_final = template.format(
                nome=lead.get('nome', 'empresário(a)'),
                cidade=lead.get('cidade', ''),
                gargalo=lead.get('gargalo', 'presença digital'),
                ai_hook=lead.get('ai_hook', ''),
            )

            return {
                'variante_id':    var_escolhida['id'],
                'variante_nome':  var_escolhida['nome'],
                'mensagem_final': msg_final,
                'seleccionado_por': 'claude-haiku',
            }

        except (anthropic.APIError, Exception) as e:
            # Fallback: variante com maior taxa de resposta
            fallback = max(variantes, key=lambda v: v.get('taxa_resposta', 0))
            return {'variante_id': fallback['id'], 'variante_nome': fallback['nome'], 'seleccionado_por': 'fallback'}

    @router.delete('/variantes/{variante_id}')
    async def desactivar_variante(
        variante_id:   str,
        authorization: Optional[str] = Header(None),
    ):
        tenant = await _get_tenant_auth(authorization)
        await _sb_patch('hermes_variants', f'id=eq.{variante_id}&tenant_id=eq.{tenant["id"]}',
                        {'ativo': False})
        return {'status': 'desactivada', 'id': variante_id}

    # ─── Voice Calls (Vapi) ───────────────────────────────────────────────────

    @router.post('/voice/iniciar')
    async def iniciar_chamada(
        req:           IniciarChamadaReq,
        authorization: Optional[str] = Header(None),
    ):
        """
        Inicia chamada de voz via Vapi para o lead.
        Usa a persona do tenant e a variante seleccionada.
        """
        tenant = await _get_tenant_auth(authorization)

        leads = await _sb_get('leads_diagnostico', {
            'id':        f'eq.{req.lead_id}',
            'tenant_id': f'eq.{tenant["id"]}',
            'select':    'nome,nicho,cidade,telefone,score_digital,gargalo,ai_hook',
        })
        if not leads:
            raise HTTPException(404, 'Lead não encontrado.')

        lead = leads[0]
        telefone = req.numero_destino or lead.get('telefone', '').replace(' ', '')

        if not telefone:
            raise HTTPException(400, 'Lead sem número de telefone para chamada.')

        # Buscar persona do tenant
        personas = await _sb_get('hermes_personas', {'tenant_id': f'eq.{tenant["id"]}'})
        persona  = personas[0] if personas else {}

        # Script da chamada (gerado por Claude)
        tom        = persona.get('tom', 'neutro')
        abertura   = persona.get('abertura_padrao', f'Bom dia, falo com {lead.get("nome", "")}?')
        cta        = persona.get('cta_padrao', 'Podemos agendar uma demonstração de 15 minutos?')
        ai_hook    = (lead.get('ai_hook') or '')[:200]

        call_script = f"""{abertura}

Identificámos que {lead.get("nome", "a sua empresa")} tem uma oportunidade significativa
de crescimento digital no sector de {lead.get("nicho", "")}.

{ai_hook}

{cta}"""

        # Criar registo da chamada
        call_record = await _sb_post('hermes_voice_calls', {
            'tenant_id':      tenant['id'],
            'lead_id':        req.lead_id,
            'provider':       req.provider,
            'numero_destino': telefone,
            'status':         'iniciada',
        })

        # Integração Vapi (se key disponível)
        call_id = None
        if vapi_key and req.provider == 'vapi':
            try:
                async with httpx.AsyncClient(timeout=15) as c:
                    r = await c.post(
                        'https://api.vapi.ai/call',
                        headers={
                            'Authorization': f'Bearer {vapi_key}',
                            'Content-Type':  'application/json',
                        },
                        json={
                            'phoneNumberId': os.getenv('VAPI_PHONE_NUMBER_ID', ''),
                            'customer':      {'number': telefone},
                            'assistant': {
                                'firstMessage': abertura,
                                'model': {
                                    'provider': 'anthropic',
                                    'model':    'claude-haiku-4-5-20251001',
                                    'systemPrompt': f"""És o Hermes, SDR da Vanguard Tech.
Tom de comunicação: {tom}.
Script: {call_script}
Responde sempre de forma concisa e profissional em português.
Objectivo: agendar uma demonstração de 15 minutos.""",
                                },
                                'voice': {'provider': 'elevenlabs', 'voiceId': persona.get('voz_id', 'rachel')},
                            },
                            'metadata': {'call_record_id': call_record['id'], 'tenant_id': tenant['id']},
                        }
                    )
                    if r.status_code == 201:
                        vapi_data = r.json()
                        call_id   = vapi_data.get('id')
                        await _sb_patch('hermes_voice_calls', f'id=eq.{call_record["id"]}', {
                            'call_id': call_id,
                            'status':  'em_curso',
                        })
            except Exception as e:
                log.warning(f'Vapi error (não-fatal): {e}')

        log.info(f'Chamada iniciada: lead {req.lead_id[:8]} — provider {req.provider}')
        return {
            'call_record_id': call_record['id'],
            'call_id':        call_id,
            'status':         'em_curso' if call_id else 'simulada',
            'numero_destino': telefone,
            'script_preview': call_script[:200] + '...',
            'nota': 'Configure VAPI_KEY + VAPI_PHONE_NUMBER_ID para chamadas reais.' if not vapi_key else None,
        }

    @router.post('/voice/webhook')
    async def voice_webhook(request: Request):
        """Recebe eventos de chamada do Vapi/ElevenLabs."""
        payload = await request.json()
        event   = payload.get('message', {})
        tipo    = event.get('type', '')
        meta    = payload.get('call', {}).get('metadata', {})
        call_record_id = meta.get('call_record_id')

        if not call_record_id:
            return Response(status_code=200)

        updates: dict = {}

        if tipo == 'end-of-call-report':
            duracao = int(event.get('durationSeconds', 0))
            transcricao = event.get('transcript', '')
            outcome_raw = event.get('endedReason', 'unknown')

            outcome_map = {
                'customer-ended-call':    'respondeu',
                'assistant-ended-call':   'respondeu',
                'no-answer':              'nao_atendeu',
                'voicemail':              'voicemail',
                'call-in-progress':       'respondeu',
            }
            outcome = outcome_map.get(outcome_raw, 'respondeu')

            # Analisar com Claude
            analise = ''
            proximo = ''
            if transcricao:
                try:
                    msg = claude.messages.create(
                        model='claude-haiku-4-5-20251001',
                        max_tokens=256,
                        messages=[{'role': 'user', 'content':
                            f'Transcrição de chamada de vendas:\n{transcricao[:800]}\n\n'
                            f'Em 2 frases: (1) Como correu a chamada? (2) Qual deve ser o próximo passo?'
                        }]
                    )
                    texto_analise = msg.content[0].text
                    partes = texto_analise.split('\n', 1)
                    analise = partes[0].strip()
                    proximo = partes[1].strip() if len(partes) > 1 else 'Follow-up WhatsApp em 24h.'
                except Exception:
                    proximo = 'Follow-up WhatsApp em 24h.'

            updates = {
                'status':        'concluida',
                'duracao_seg':   duracao,
                'transcricao':   transcricao,
                'outcome':       outcome,
                'analise_claude': analise,
                'proximo_passo': proximo,
                'terminado_em':  'now()',
            }

        elif tipo in ('status-update',):
            status_vapi = event.get('status', '')
            if status_vapi == 'ringing':  updates = {'status': 'em_curso'}
            elif status_vapi == 'ended':  updates = {'status': 'concluida', 'terminado_em': 'now()'}

        if updates:
            await _sb_patch('hermes_voice_calls', f'id=eq.{call_record_id}', updates)

        return Response(status_code=200)

    @router.get('/voice/historico')
    async def voice_historico(
        limit:         int          = 20,
        authorization: Optional[str] = Header(None),
    ):
        """Histórico de chamadas de voz do tenant."""
        tenant = await _get_tenant_auth(authorization)
        rows = await _sb_get('hermes_voice_calls', {
            'tenant_id': f'eq.{tenant["id"]}',
            'order':     'created_at.desc',
            'limit':     str(limit),
        })
        conversoes = sum(1 for r in rows if r.get('outcome') == 'converteu')
        respostas  = sum(1 for r in rows if r.get('outcome') in ('respondeu', 'converteu'))
        return {
            'chamadas':      rows,
            'total':         len(rows),
            'taxa_resposta': round(respostas / max(len(rows), 1) * 100, 1),
            'taxa_conversao': round(conversoes / max(len(rows), 1) * 100, 1),
        }

    @router.get('/performance')
    async def hermes_performance(authorization: Optional[str] = Header(None)):
        """KPIs globais do Hermes: WA + Voice + A/B testing."""
        tenant = await _get_tenant_auth(authorization)

        variantes = await _sb_get('hermes_variants', {'tenant_id': f'eq.{tenant["id"]}'})
        chamadas  = await _sb_get('hermes_voice_calls', {
            'tenant_id': f'eq.{tenant["id"]}',
            'select':    'status,outcome,duracao_seg',
        })
        persona = await _sb_get('hermes_personas', {'tenant_id': f'eq.{tenant["id"]}'})

        best_variant = max(variantes, key=lambda v: v.get('taxa_resposta', 0)) if variantes else None
        total_calls  = len(chamadas)
        calls_done   = [c for c in chamadas if c.get('status') == 'concluida']
        convertidas  = sum(1 for c in chamadas if c.get('outcome') == 'converteu')

        return {
            'persona':              persona[0] if persona else None,
            'variantes': {
                'total':            len(variantes),
                'melhor':           best_variant,
                'media_resposta':   round(sum(v.get('taxa_resposta', 0) for v in variantes) / max(len(variantes), 1), 1),
            },
            'voice': {
                'total_chamadas':   total_calls,
                'concluidas':       len(calls_done),
                'convertidas':      convertidas,
                'taxa_conversao':   round(convertidas / max(total_calls, 1) * 100, 1),
                'duracao_media_seg': round(sum(c.get('duracao_seg', 0) or 0 for c in calls_done) / max(len(calls_done), 1)),
            },
        }

    return router
