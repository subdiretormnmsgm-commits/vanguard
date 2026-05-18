"""
AUDITOR ENGINE — Fase 2 do Quadrilateral sem copy-paste

O que este módulo resolve:
  Antes: Eduardo copia DIRETRIZ do Gemini → cola no NotebookLM → lê Skill → copia → cola no terminal
  Depois: POST /auditor/gerar-skill → Skill gerada e registrada automaticamente

Por que Claude e não NotebookLM aqui:
  NotebookLM não tem API pública. Claude via API tem raciocínio superior para
  síntese estratégica. O grounding no histórico é garantido pelo contexto injetado
  nos princípios ativos do LEDGER e nas MEMORIAs passadas como documentos.

Opinião do Músculo (eu):
  A Fase 2 era o maior ponto de atrito do processo. Um Auditor que requer 
  que o Diretor opere como protocolo de rede entre ferramentas não é um 
  Conselho — é uma linha de montagem manual com etiqueta premium. 
  Este módulo fecha esse gap de verdade.
"""

import os
from datetime import datetime, timezone

import anthropic
from pydantic import BaseModel

from .ledger import (
    FricaoEvento,
    Principio,
    adicionar_principio,
    listar_principios_ativos,
    registrar_fricao,
)


# ── Modelos de entrada/saída ───────────────────────────────────────────────────

class AuditorRequest(BaseModel):
    projeto: str
    cliente: str
    iteracao: str                          # ex: "V25"
    diretriz_gemini: str                   # output completo do Gemini
    memorias_anteriores: list[str] = []    # conteúdo das últimas MEMORIAs
    stack_tecnica: str = ""
    maior_risco: str = ""
    sessao_id: str = ""


class SkillGerada(BaseModel):
    projeto: str
    iteracao: str
    timestamp: str
    skill_markdown: str                    # pronto para salvar em .claude/skills/
    auditoria_coerencia: str
    padroes_sucesso: list[str]
    padroes_falha: list[str]
    alertas_criticos: list[str]
    modulos_reutilizaveis: list[str]
    o_que_nao_construir: list[str]
    cinco_ideias_auditor: list[str]
    principios_aplicados: list[str]        # IDs dos princípios usados na análise


# ── Prompt do Auditor ──────────────────────────────────────────────────────────

def _montar_system_prompt(principios: list[Principio]) -> str:
    principios_txt = "\n".join(
        f"- {p.id}: {p.descricao} (origem: {p.origem})"
        for p in principios
    )
    return f"""Você é o AUDITOR do Conselho Quadrilateral IAH.

Seu papel exclusivo:
1. Conectar a DIRETRIZ nova ao histórico real documentado
2. Identificar padrões de sucesso e falha com evidência
3. Sinalizar contradições com decisões anteriores
4. Gerar a Skill técnica com os 4 blocos obrigatórios preenchidos com dados reais

PRINCÍPIOS ATIVOS DO LEDGER (respeitar obrigatoriamente):
{principios_txt}

REGRAS DE OURO:
- Bloco genérico sem dado real = escrever "dados insuficientes" — nunca inventar (P-007)
- Skill com menos de 4 blocos obrigatórios é Skill inválida
- Filtro de Recência: princípio mais recente prevalece sobre regra antiga
- Tensão Ativa: auditar a DIRETRIZ, não validá-la. Ser o "chato" da sala quando necessário
- Você NÃO decide. NÃO cria estratégia. NÃO escreve código de produção. Você fundamenta.

FORMATO OBRIGATÓRIO DA SKILL (retornar dentro de ```skill ... ```):
## CONTEXTO DO PROJETO
## AUDITORIA DE COERÊNCIA
## CONEXÃO HISTÓRICA (com localização exata de módulos reutilizáveis)
## PADRÃO DE SUCESSO (com evidência e projeto de origem)
## PADRÃO DE FALHA (com falha específica e projeto de origem)
## PERSPECTIVA DO SÓCIO CONSULTOR
## SEQUÊNCIA DE BUILD RECOMENDADA (dia a dia com gates obrigatórios)
## ALERTAS CRÍTICOS (P0 / P1 / P2)
## O QUE NÃO CONSTRUIR NESTA ENTREGA
## SUAS 5 IDEIAS DISRUPTIVAS COMO AUDITOR

Após a Skill, retornar também um bloco JSON dentro de ```json ... ``` com:
{{
  "auditoria_coerencia": "resumo em 2 linhas",
  "padroes_sucesso": ["lista"],
  "padroes_falha": ["lista"],
  "alertas_criticos": ["lista com severidade"],
  "modulos_reutilizaveis": ["lista com localização"],
  "o_que_nao_construir": ["lista"],
  "cinco_ideias_auditor": ["lista"],
  "principios_aplicados": ["P-001", "P-007", ...]
}}"""


def _montar_user_prompt(req: AuditorRequest) -> str:
    memorias_txt = ""
    if req.memorias_anteriores:
        memorias_txt = "\n\n### MEMÓRIAS DAS ÚLTIMAS ITERAÇÕES:\n"
        for i, m in enumerate(req.memorias_anteriores, 1):
            memorias_txt += f"\n--- Memória {i} ---\n{m[:3000]}\n"  # limita por memória

    return f"""QUADRILATERAL IAH — AUDITOR
Projeto: {req.projeto} | Cliente: {req.cliente} | Iteração: {req.iteracao}
Stack: {req.stack_tecnica or 'não informada'}
Maior risco identificado: {req.maior_risco or 'não informado'}

### DIRETRIZ DO GEMINI (ESTRATEGISTA):
{req.diretriz_gemini}
{memorias_txt}

Execute sua auditoria completa e gere a Skill técnica para o Músculo."""


# ── Executor principal ─────────────────────────────────────────────────────────

def gerar_skill(req: AuditorRequest) -> SkillGerada:
    """
    Chama Claude como Auditor e retorna a Skill estruturada.
    Registra automaticamente fricções se detectar problemas.
    """
    client = anthropic.Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])
    principios = listar_principios_ativos()

    response = client.messages.create(
        model="claude-sonnet-4-6",  # Sonnet para custo/benefício; Opus se crítico
        max_tokens=8000,
        system=_montar_system_prompt(principios),
        messages=[{"role": "user", "content": _montar_user_prompt(req)}],
    )

    raw = response.content[0].text

    # ── Extrair skill markdown ─────────────────────────────────────────────────
    skill_md = _extrair_bloco(raw, "skill")
    if not skill_md:
        # Auditor falhou em gerar Skill válida — registrar fricção
        registrar_fricao(FricaoEvento(
            id="",
            timestamp=datetime.now(timezone.utc).isoformat(),
            sessao=req.sessao_id or req.iteracao,
            tipo="ALUCINACAO_TECNICA",
            fonte="AuditorEngine",
            instrucao_original=req.diretriz_gemini[:300],
            problema_detectado="Auditor não gerou Skill com bloco ```skill``` obrigatório",
            acao_tomada="Skill retornada como texto bruto — revisar antes de usar no Músculo",
            principio_gerado="P-007",
            severidade="HIGH",
        ))
        skill_md = raw  # fallback: retorna tudo

    # ── Extrair JSON de metadados ──────────────────────────────────────────────
    meta = _extrair_json(raw)

    # ── Registrar novo princípio se o Auditor identificou um ──────────────────
    for ideia in meta.get("cinco_ideias_auditor", []):
        if ideia.startswith("P-NOVO:"):
            descricao = ideia.replace("P-NOVO:", "").strip()
            adicionar_principio(Principio(
                id="",
                descricao=descricao,
                origem=f"{req.projeto}-{req.iteracao}",
                data=datetime.now(timezone.utc).date().isoformat(),
            ))

    return SkillGerada(
        projeto=req.projeto,
        iteracao=req.iteracao,
        timestamp=datetime.now(timezone.utc).isoformat(),
        skill_markdown=skill_md,
        auditoria_coerencia=meta.get("auditoria_coerencia", ""),
        padroes_sucesso=meta.get("padroes_sucesso", []),
        padroes_falha=meta.get("padroes_falha", []),
        alertas_criticos=meta.get("alertas_criticos", []),
        modulos_reutilizaveis=meta.get("modulos_reutilizaveis", []),
        o_que_nao_construir=meta.get("o_que_nao_construir", []),
        cinco_ideias_auditor=meta.get("cinco_ideias_auditor", []),
        principios_aplicados=meta.get("principios_aplicados", []),
    )


# ── Helpers ────────────────────────────────────────────────────────────────────

def _extrair_bloco(texto: str, tag: str) -> str:
    import re
    pattern = rf"```{tag}\s*(.*?)```"
    match = re.search(pattern, texto, re.DOTALL)
    return match.group(1).strip() if match else ""


def _extrair_json(texto: str) -> dict:
    import json
    import re
    match = re.search(r"```json\s*(.*?)```", texto, re.DOTALL)
    if match:
        try:
            return json.loads(match.group(1))
        except json.JSONDecodeError:
            pass
    return {}
