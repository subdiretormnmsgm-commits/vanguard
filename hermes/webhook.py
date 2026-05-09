#!/usr/bin/env python3
"""
Protocolo Hermes — Webhook Python
Secretário Executivo Virtual Autónomo da Vanguard Tech

Recebe mensagens do WhatsApp Business API (Meta),
extrai dados via Claude AI e persiste no Supabase.

Deploy: uvicorn webhook:app --host 0.0.0.0 --port 8000
"""

import json
import logging
import os
import urllib.request
from contextlib import asynccontextmanager
from datetime import datetime

import httpx
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Query, Request, Response

load_dotenv()

logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')
log = logging.getLogger('hermes')

# ─── Configuração ─────────────────────────────────────────────────────────────
WA_VERIFY_TOKEN   = os.getenv('WA_VERIFY_TOKEN', 'hermes_vanguard_2026')
WA_TOKEN          = os.getenv('WA_TOKEN', '')           # Meta Graph API token
WA_PHONE_ID       = os.getenv('WA_PHONE_NUMBER_ID', '') # ID do número WhatsApp
SUPABASE_URL      = os.getenv('SUPABASE_URL', '')
SUPABASE_KEY      = os.getenv('SUPABASE_SERVICE_KEY', '') # service_role key para INSERT
ANTHROPIC_API_KEY = os.getenv('ANTHROPIC_API_KEY', '')

META_API_URL = f'https://graph.facebook.com/v20.0/{WA_PHONE_ID}/messages'

# ─── Prompt do Hermes ─────────────────────────────────────────────────────────
SYSTEM_PROMPT = """Você é o Hermes, secretário executivo da Vanguard Tech.
Sua missão: qualificar leads via WhatsApp de forma humanizada, nunca parecendo um robô.

Analise a mensagem recebida e extraia as seguintes informações em JSON válido:
{
  "nome": "nome da pessoa (null se não mencionado)",
  "nicho": "nicho de negócio (null se não mencionado)",
  "gargalo_tecnologico": "principal problema ou necessidade tecnológica (null se não claro)",
  "status_agendamento": "NOVO|QUALIFICADO|AGENDADO",
  "resposta": "sua resposta humanizada para o cliente (max 150 palavras, tom profissional e empático)"
}

Regras de status:
- NOVO: primeira mensagem, sem dados suficientes
- QUALIFICADO: nicho e gargalo identificados
- AGENDADO: cliente confirmou interesse em reunião

Responda APENAS com o JSON, sem markdown."""

# ─── Supabase Client ──────────────────────────────────────────────────────────

async def salvar_lead(client: httpx.AsyncClient, dados: dict) -> bool:
    payload = {
        'nome':                dados.get('nome') or 'Não identificado',
        'telefone':            dados['telefone'],
        'nicho':               dados.get('nicho'),
        'gargalo_tecnologico': dados.get('gargalo_tecnologico'),
        'status_agendamento':  dados.get('status_agendamento', 'NOVO'),
        'mensagem_original':   dados.get('mensagem_original'),
        'resposta_hermes':     dados.get('resposta'),
        'conversa_id':         dados.get('conversa_id'),
        'origem':              'hermes',
    }

    resp = await client.post(
        f'{SUPABASE_URL}/rest/v1/leads_qualificados',
        json=payload,
        headers={
            'apikey':        SUPABASE_KEY,
            'Authorization': f'Bearer {SUPABASE_KEY}',
            'Prefer':        'resolution=merge-duplicates',
        }
    )
    return resp.status_code in (200, 201)


async def salvar_memoria(client: httpx.AsyncClient, telefone: str, role: str, conteudo: str) -> None:
    await client.post(
        f'{SUPABASE_URL}/rest/v1/hermes_conversas',
        json={'telefone': telefone, 'role': role, 'conteudo': conteudo},
        headers={
            'apikey':        SUPABASE_KEY,
            'Authorization': f'Bearer {SUPABASE_KEY}',
        }
    )


async def buscar_historico(client: httpx.AsyncClient, telefone: str, limite: int = 6) -> list:
    resp = await client.get(
        f'{SUPABASE_URL}/rest/v1/hermes_conversas',
        params={'telefone': f'eq.{telefone}', 'order': 'created_at.desc', 'limit': limite},
        headers={
            'apikey':        SUPABASE_KEY,
            'Authorization': f'Bearer {SUPABASE_KEY}',
        }
    )
    if resp.status_code == 200:
        return list(reversed(resp.json()))
    return []

# ─── Claude AI ────────────────────────────────────────────────────────────────

async def extrair_com_ia(client: httpx.AsyncClient, mensagem: str, historico: list) -> dict:
    messages = []

    # Injeta histórico para memória conversacional
    for h in historico:
        messages.append({'role': h['role'], 'content': h['conteudo']})

    messages.append({'role': 'user', 'content': mensagem})

    resp = await client.post(
        'https://api.anthropic.com/v1/messages',
        json={
            'model':      'claude-haiku-4-5-20251001',
            'max_tokens': 500,
            'system':     SYSTEM_PROMPT,
            'messages':   messages,
        },
        headers={
            'x-api-key':         ANTHROPIC_API_KEY,
            'anthropic-version': '2023-06-01',
            'content-type':      'application/json',
        },
        timeout=20.0
    )
    resp.raise_for_status()
    texto = resp.json()['content'][0]['text'].strip()

    # Limpa possível markdown residual
    if texto.startswith('```'):
        texto = texto.split('```')[1]
        if texto.startswith('json'):
            texto = texto[4:]
    return json.loads(texto)

# ─── WhatsApp API ─────────────────────────────────────────────────────────────

async def enviar_resposta(client: httpx.AsyncClient, telefone: str, mensagem: str) -> None:
    await client.post(
        META_API_URL,
        json={
            'messaging_product': 'whatsapp',
            'to':                telefone,
            'type':              'text',
            'text':              {'body': mensagem},
        },
        headers={
            'Authorization': f'Bearer {WA_TOKEN}',
            'Content-Type':  'application/json',
        },
        timeout=10.0
    )

# ─── App ──────────────────────────────────────────────────────────────────────

@asynccontextmanager
async def lifespan(app: FastAPI):
    log.info('Protocolo Hermes iniciado.')
    yield
    log.info('Protocolo Hermes encerrado.')

app = FastAPI(title='Protocolo Hermes', version='1.0.0', lifespan=lifespan)


@app.get('/webhook')
async def verificar_webhook(
    hub_mode:      str = Query(None, alias='hub.mode'),
    hub_token:     str = Query(None, alias='hub.verify_token'),
    hub_challenge: str = Query(None, alias='hub.challenge'),
):
    """Verificação do webhook pela Meta (passo único de configuração)."""
    if hub_mode == 'subscribe' and hub_token == WA_VERIFY_TOKEN:
        log.info('Webhook verificado pela Meta.')
        return Response(content=hub_challenge, media_type='text/plain')
    log.warning('Tentativa de verificação inválida.')
    raise HTTPException(status_code=403, detail='Token inválido')


@app.post('/webhook')
async def receber_mensagem(request: Request):
    """Recebe eventos do WhatsApp, processa com IA e salva no Supabase."""
    body = await request.json()
    log.debug(f'Payload recebido: {json.dumps(body)[:300]}')

    # Extrai mensagem do payload Meta
    try:
        entry   = body['entry'][0]
        changes = entry['changes'][0]['value']

        if 'messages' not in changes:
            return {'status': 'ignorado', 'motivo': 'sem mensagem'}

        msg        = changes['messages'][0]
        telefone   = msg['from']
        texto      = msg.get('text', {}).get('body', '')
        conversa_id = entry.get('id', '')

        if not texto:
            return {'status': 'ignorado', 'motivo': 'sem texto'}

        log.info(f'Mensagem de {telefone}: {texto[:80]}')
    except (KeyError, IndexError) as e:
        log.error(f'Payload inesperado: {e}')
        return {'status': 'ignorado', 'motivo': 'formato inesperado'}

    async with httpx.AsyncClient() as client:
        # Busca histórico conversacional (memória do Hermes)
        historico = await buscar_historico(client, telefone)

        # Salva mensagem do user na memória
        await salvar_memoria(client, telefone, 'user', texto)

        # Extrai informações via Claude
        try:
            dados = await extrair_com_ia(client, texto, historico)
        except Exception as e:
            log.error(f'Erro na IA: {e}')
            dados = {
                'nome': None, 'nicho': None,
                'gargalo_tecnologico': None, 'status_agendamento': 'NOVO',
                'resposta': 'Olá! Recebi sua mensagem. Em que posso ajudá-lo?'
            }

        dados['telefone']          = telefone
        dados['mensagem_original'] = texto
        dados['conversa_id']       = conversa_id

        # Persiste no Supabase
        ok = await salvar_lead(client, dados)
        log.info(f'Lead salvo: {ok} | Status: {dados.get("status_agendamento")}')

        # Salva resposta na memória
        resposta = dados.get('resposta', 'Obrigado pelo contacto!')
        await salvar_memoria(client, telefone, 'assistant', resposta)

        # Envia resposta pelo WhatsApp
        if WA_TOKEN and WA_PHONE_ID:
            await enviar_resposta(client, telefone, resposta)
        else:
            log.warning('WA_TOKEN/WA_PHONE_ID não configurados — resposta não enviada.')

    return {'status': 'processado'}


@app.get('/health')
async def health():
    return {'status': 'ok', 'servico': 'Protocolo Hermes', 'ts': datetime.utcnow().isoformat()}


@app.get('/leads')
async def listar_leads(limite: int = 20):
    """Endpoint de diagnóstico — lista leads recentes (desactivar em produção)."""
    async with httpx.AsyncClient() as client:
        resp = await client.get(
            f'{SUPABASE_URL}/rest/v1/leads_qualificados',
            params={'order': 'created_at.desc', 'limit': limite},
            headers={'apikey': SUPABASE_KEY, 'Authorization': f'Bearer {SUPABASE_KEY}'}
        )
        return resp.json()
