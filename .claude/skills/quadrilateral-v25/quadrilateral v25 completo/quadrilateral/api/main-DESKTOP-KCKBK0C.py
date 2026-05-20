"""
QUADRILATERAL API — Sistema Nervoso Central do Conselho IAH

Endpoints:
  GET  /ledger/principios          → lista princípios ativos
  POST /ledger/friccao             → registra evento de fricção
  POST /ledger/principio           → adiciona princípio novo
  POST /ledger/veto                → ativa Hard ou Soft Veto
  POST /ledger/veto/resolver       → resolve veto com override do Diretor
  GET  /ledger/exportar            → gera INTELLIGENCE_LEDGER.md atualizado
  GET  /deploy/verificar/{projeto} → verifica se há Hard Veto bloqueando deploy
  POST /auditor/gerar-skill        → Fase 2 automatizada (Gemini → Auditor → Skill)
  POST /sessao/iniciar             → registra início de sessão
  GET  /status                     → saúde do sistema + resumo do estado

Como usar:
  uvicorn api.main:app --reload --port 8765
  
  Ou via script:
  python -m quadrilateral.scripts.start
"""

from datetime import datetime, timezone

from fastapi import FastAPI, HTTPException
from fastapi.responses import PlainTextResponse
from pydantic import BaseModel

from .auditor import AuditorRequest, gerar_skill
from .ledger import (
    FricaoEvento,
    Principio,
    VetoAtivo,
    adicionar_principio,
    ativar_veto,
    exportar_para_markdown,
    get_state,
    incrementar_sessao,
    listar_principios_ativos,
    registrar_fricao,
    resolver_veto,
    verificar_bloqueio_deploy,
)

app = FastAPI(
    title="Quadrilateral IAH — API",
    description="Sistema nervoso central do Conselho. Substitui copy-paste por automação.",
    version="1.0.0",
)


# ── Status ─────────────────────────────────────────────────────────────────────

@app.get("/status")
def status():
    state = get_state()
    vetos_abertos = [v for v in state.vetos_ativos if v.override_diretor is None]
    return {
        "status": "operacional" if not vetos_abertos else "bloqueado",
        "versao": state.versao,
        "sessoes_acumuladas": state.sessoes_count,
        "ultima_sessao": state.ultima_sessao,
        "principios_ativos": len([p for p in state.principios if p.ativo]),
        "fricoes_registradas": len(state.fricoes),
        "vetos_abertos": len(vetos_abertos),
        "vetos_detalhes": [f"{v.tipo} · {v.projeto}" for v in vetos_abertos],
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }


# ── LEDGER endpoints ────────────────────────────────────────────────────────────

@app.get("/ledger/principios")
def get_principios():
    """Lista todos os princípios ativos. O Músculo chama isso no início de cada sessão."""
    principios = listar_principios_ativos()
    return {
        "total": len(principios),
        "principios": [p.model_dump() for p in principios],
    }


@app.post("/ledger/friccao")
def post_friccao(evento: FricaoEvento):
    """
    Registra evento de fricção. Chamado pelo Músculo ao detectar qualquer desvio.
    Substitui a atualização manual do friction.log.
    """
    registrado = registrar_fricao(evento)
    return {"registrado": True, "id": registrado.id}


@app.post("/ledger/principio")
def post_principio(principio: Principio):
    """Adiciona novo princípio ao LEDGER. Chamado ao fim de cada sessão."""
    adicionado = adicionar_principio(principio)
    return {"adicionado": True, "id": adicionado.id}


@app.post("/ledger/veto")
def post_veto(veto: VetoAtivo):
    """
    Ativa Hard ou Soft Veto. Hard Veto bloqueia deploy automaticamente via CI/CD.
    """
    ativado = ativar_veto(veto)
    bloqueio = veto.tipo.startswith("HV-")
    return {
        "ativado": True,
        "tipo": ativado.tipo,
        "deploy_bloqueado": bloqueio,
        "mensagem": (
            f"⛔ HARD VETO ativo — deploy bloqueado até override do Diretor"
            if bloqueio
            else f"⚠️ SOFT VETO ativo — aguardando 1 sessão ou decisão explícita"
        ),
    }


class ResolverVetoRequest(BaseModel):
    tipo: str
    projeto: str
    override_diretor: str   # texto do override assinado pelo Diretor


@app.post("/ledger/veto/resolver")
def post_resolver_veto(req: ResolverVetoRequest):
    """
    Resolve veto com override documentado do Diretor.
    O override é registrado permanentemente no LEDGER.
    """
    from .ledger import VetoTipo
    resolvido = resolver_veto(req.tipo, req.projeto, req.override_diretor)  # type: ignore
    if not resolvido:
        raise HTTPException(404, f"Veto {req.tipo} não encontrado para projeto {req.projeto}")
    return {
        "resolvido": True,
        "override_registrado": req.override_diretor,
        "aviso": "3 overrides do mesmo tipo = novo princípio gerado automaticamente",
    }


@app.get("/ledger/exportar", response_class=PlainTextResponse)
def get_exportar():
    """
    Gera INTELLIGENCE_LEDGER.md atualizado a partir do estado vivo.
    Substituição direta da atualização manual do arquivo.
    Copie o output e salve em INTELLIGENCE_LEDGER.md no repositório.
    """
    return exportar_para_markdown()


# ── Deploy check ────────────────────────────────────────────────────────────────

@app.get("/deploy/verificar/{projeto}")
def get_deploy_verificar(projeto: str):
    """
    Endpoint chamado pelo GitHub Actions antes de qualquer deploy.
    Retorna 200 se limpo, 403 se Hard Veto ativo.
    
    No workflow: curl -f http://localhost:8765/deploy/verificar/{projeto}
    Falha automaticamente (exit 1) se retornar 403.
    """
    resultado = verificar_bloqueio_deploy(projeto)
    if resultado["bloqueado"]:
        raise HTTPException(
            status_code=403,
            detail={
                "mensagem": "⛔ DEPLOY BLOQUEADO — Hard Veto ativo sem override do Diretor",
                "motivos": resultado["motivos"],
                "como_resolver": "POST /ledger/veto/resolver com override assinado pelo Diretor",
            },
        )
    return {
        "deploy_liberado": True,
        "projeto": projeto,
        "timestamp": resultado["timestamp"],
    }


# ── Auditor endpoint ────────────────────────────────────────────────────────────

@app.post("/auditor/gerar-skill")
def post_gerar_skill(req: AuditorRequest):
    """
    FASE 2 AUTOMATIZADA.
    
    Antes: Eduardo copia DIRETRIZ → cola no NotebookLM → copia Skill → cola no terminal
    Depois: POST com a DIRETRIZ → Skill gerada, estruturada e pronta para o Músculo
    
    Requer: ANTHROPIC_API_KEY no ambiente
    Custo estimado por chamada: ~$0.10-0.30 (Sonnet) ou ~$0.50-1.50 (Opus)
    """
    try:
        skill = gerar_skill(req)
        return skill.model_dump()
    except Exception as e:
        raise HTTPException(500, f"Erro ao gerar Skill: {str(e)}")


# ── Sessão ─────────────────────────────────────────────────────────────────────

class SessaoRequest(BaseModel):
    nome: str       # ex: "V25-cliente-onboarding"
    projeto: str


@app.post("/sessao/iniciar")
def post_sessao_iniciar(req: SessaoRequest):
    """
    Registra início de sessão. 
    O Músculo chama isso automaticamente ao ler o PROTOCOLO VANGUARD.
    Incrementa o contador de sessões — o ativo mais importante do Quadrilateral.
    """
    n = incrementar_sessao(req.nome)
    principios = listar_principios_ativos()
    return {
        "sessao": req.nome,
        "numero": n,
        "principios_ativos": [f"{p.id}: {p.descricao}" for p in principios],
        "aviso": "Leia os princípios acima ANTES de qualquer deliberação.",
    }
