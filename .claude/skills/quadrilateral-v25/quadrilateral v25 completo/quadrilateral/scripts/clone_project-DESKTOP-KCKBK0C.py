#!/usr/bin/env python3
"""
CLONE PROJECT — Setup de novo projeto de cliente em 5 minutos

O que faz:
  1. Cria estrutura CLIENTES/[NOME_CLIENTE]/
  2. Copia e pré-preenche todos os templates das FASES
  3. Cria sentinel_config.json e feature_flags.json com campos destacados
  4. Inicializa INTELLIGENCE_LEDGER.md e knowledge_graph.json do projeto
  5. Cria DECISOES_PENDENTES.md vazio para o Módulo 0
  6. Gera README.md com próximos passos exatos

Antes: Eduardo levava 30 minutos para configurar um novo projeto
Depois: 5 minutos + responder algumas perguntas

Uso:
  python scripts/clone_project.py
  python scripts/clone_project.py --cliente "Valdece" --nicho "clinica" --camada 2
  python scripts/clone_project.py --cliente "João Silva" --silencioso
"""

import argparse
import json
import shutil
from datetime import datetime, timezone
from pathlib import Path


TEMPLATES_BASE = Path("QUADRILATERAL_UNIVERSAL/FASES")
CLIENTES_BASE = Path("CLIENTES")


def _slug(nome: str) -> str:
    """Converte nome do cliente para slug de pasta."""
    import re
    s = nome.lower().strip()
    s = re.sub(r'[^a-z0-9\s-]', '', s)
    s = re.sub(r'\s+', '-', s)
    return s


def _perguntar(prompt: str, default: str = "") -> str:
    try:
        r = input(f"{prompt} [{default}]: ").strip()
        return r if r else default
    except (EOFError, KeyboardInterrupt):
        return default


def _criar_sentinel_config(cliente: str, nicho: str, camada: int) -> dict:
    """Gera sentinel_config.json pré-preenchido."""
    fire_map = {
        "ecommerce": "purchase_completed",
        "clinica": "booking_submitted",
        "saas": "trial_started",
        "consultoria": "quote_requested",
        "app": "signup_completed",
        "marketplace": "first_sale",
        "outro": "quote_requested",
    }
    fire = fire_map.get(nicho.lower(), "quote_requested")

    return {
        "_instrucoes": "Preencher campos marcados com [PREENCHER] antes do lançamento.",
        "projecto": {
            "nome": cliente,
            "nicho": nicho,
            "camada": camada,
        },
        "fire_event": {
            "success_event": fire,
            "success_label": f"[PREENCHER: ex. {fire.replace('_', ' ').title()}]",
            "fire_threshold_score": 70,
            "_nota": f"Pré-configurado para nicho '{nicho}'. Confirmar com o cliente.",
        },
        "ticket_medio": {
            "valor": "[PREENCHER: ticket médio em BRL — ex: 150.00]",
            "monthly_client_volume": "[PREENCHER: clientes por mês — ex: 80]",
            "currency_code": "BRL",
        },
        "sentinel_report": {
            "report_day": "monday",
            "report_time": "09:00",
            "report_language": "pt-BR",
            "upsell_threshold": 50,
            "upsell_service": "[PREENCHER: ex. Retainer de Evolução — R$2.500/mês]",
            "upsell_cta_whatsapp": "[PREENCHER: número do operador]",
        },
        "destinatario": {
            "client_email": "[PREENCHER: email do cliente]",
            "client_name": "[PREENCHER: nome do responsável]",
            "operator_email": "[PREENCHER: seu email]",
        },
        "email_tracking": {
            "tracking_pixel_enabled": True,
            "tracking_pixel_url": "[PREENCHER: URL do pixel]",
        },
        "modelo_ia": {
            "model": "claude-haiku-4-5-20251001",
            "max_tokens": 1024,
            "_nota": "Haiku para custo ~R$0.04/relatório. Não alterar sem Veredito.",
        },
    }


def _criar_feature_flags(camada: int) -> dict:
    """Gera feature_flags.json com features ativas conforme camada."""
    return {
        "_instrucoes": f"Pré-configurado para Camada {camada}. Revisar antes do lançamento.",
        "_camada_detectada": camada,
        "features": {
            "core": {
                "landing_page": {"enabled": True, "tier": 1},
                "contact_form": {"enabled": True, "tier": 1},
                "cookie_consent": {"enabled": True, "tier": 1},
            },
            "produto": {
                "auth": {
                    "enabled": camada >= 2,
                    "tier": 2,
                    "teaser": camada < 2,
                    "upgrade_message": "Disponível no Plano Produto.",
                },
                "payment": {
                    "enabled": camada >= 2,
                    "tier": 2,
                    "teaser": camada < 2,
                    "upgrade_message": "Aceite pagamentos. Disponível no Plano Produto.",
                },
                "admin_panel": {
                    "enabled": camada >= 2,
                    "tier": 2,
                    "teaser": camada < 2,
                    "upgrade_message": "Painel de gestão. Disponível no Plano Produto.",
                },
            },
            "plataforma": {
                "ai_reports": {
                    "enabled": camada >= 3,
                    "tier": 3,
                    "teaser": camada < 3,
                    "upgrade_message": "Relatórios semanais com IA. Disponível no Plano Plataforma.",
                },
                "auto_followup": {
                    "enabled": camada >= 3,
                    "tier": 3,
                    "teaser": camada < 3,
                    "upgrade_message": "Follow-up automático. Disponível no Plano Plataforma.",
                },
            },
        },
        "upgrade_cta": {
            "whatsapp": "[PREENCHER: número do operador]",
            "email": "[PREENCHER: email do operador]",
            "cta_text": "Fale connosco para activar →",
        },
    }


def _criar_ledger_projeto(cliente: str, slug: str) -> dict:
    """Inicializa knowledge_graph.json para o projeto."""
    return {
        "meta": {
            "project": cliente,
            "version": "1.0",
            "created": datetime.now(timezone.utc).date().isoformat(),
            "last_updated": datetime.now(timezone.utc).date().isoformat(),
            "total_sessions": 0,
            "schema": "quadrilateral-kg-v1",
        },
        "principles": [],
        "patterns": {"confirmed": [], "refuted": []},
        "constitution": {"hard_vetos": [], "soft_vetos": []},
        "sessions": [],
    }


def _criar_readme_projeto(cliente: str, slug: str, nicho: str, camada: int) -> str:
    """Gera README.md com próximos passos exatos para este cliente."""
    data = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    camada_nome = {1: "MVP", 2: "Produto", 3: "Plataforma", 4: "Ecossistema", 5: "Monopólio"}
    return f"""# PROJETO — {cliente}
**Nicho:** {nicho} | **Camada:** {camada} — {camada_nome.get(camada, '?')} | **Criado:** {data}
**Operador:** Eduardo | **Quadrilateral:** V25+

---

## PRÓXIMOS PASSOS (nesta ordem)

### Passo 1 — Completar o Discovery
```
[ ] Preencher BRIEFING_DISCOVERY.md com as 8 respostas
[ ] Preencher PERFIL_CLIENTE.md com o perfil humano do cliente
[ ] Calcular hemorragia: clientes_perdidos × ticket_médio × 4 = R$/mês
```

### Passo 2 — Ativar o Gemini
```
[ ] Abrir PASSO3_GEMINI.md
[ ] Enviar ao Gemini: BRIEFING_DISCOVERY.md (primeiro)
[ ] Enviar ao Gemini: PASSO3_GEMINI.md (por último)
[ ] Salvar DIRETRIZ como: DIRETRIZ_V1_ESTRATEGISTA.txt
```

### Passo 3 — Ativar o Auditor (Camada {camada} {'— OBRIGATÓRIO' if camada >= 2 else '— OPCIONAL'})
```
{"[ ] Carregar no NotebookLM: BRIEFING_DISCOVERY.md + DIRETRIZ_V1" if camada >= 2 else "[ ] Camada 1 — pode ir direto para o Músculo sem Auditor"}
{"[ ] OU usar: POST /auditor/gerar-skill (automático)" if camada >= 2 else ""}
{"[ ] Salvar Skill em: .claude/skills/" + slug + "-v1.md" if camada >= 2 else ""}
```

### Passo 4 — Ativar o Músculo
```
[ ] Dizer: "PROTOCOLO VANGUARD — {cliente}. Leia tudo e delibere."
[ ] Trazer: DIRETRIZ + Skill (se Camada {camada}+)
[ ] Aguardar deliberação e plano antes de aprovar build
```

### Passo 5 — Preencher configurações antes do Módulo 0
```
[ ] sentinel_config.json — preencher campos [PREENCHER]
[ ] feature_flags.json — confirmar features ativas para Camada {camada}
[ ] .env — copiar de env_TEMPLATE.example e preencher
```

---

## ESTRUTURA DE ARQUIVOS

```
CLIENTES/{slug}/
├── BRIEFING_DISCOVERY.md       ← preencher agora
├── PERFIL_CLIENTE.md           ← preencher agora
├── DIRETRIZ_V1_ESTRATEGISTA.txt ← output do Gemini
├── DECISOES_PENDENTES.md       ← atualizar durante o build
├── INTELLIGENCE_LEDGER.md      ← atualizado pelo session_close.py
├── knowledge_graph.json        ← estado programático do projeto
├── sentinel_config.json        ← ⚠️ preencher antes do Módulo 0
├── feature_flags.json          ← confirmar antes do build
├── .env.example                ← copiar para .env (nunca commitar .env)
├── PROPOSTA_COMERCIAL.md       ← gerar após DIRETRIZ
├── CONTRATO.md                 ← gerar após proposta aceita
├── MEMORIA_V1.md               ← gerado pelo Músculo ao fechar
├── relatorio_evolutivo_V1.md   ← gerado pelo Músculo ao fechar
├── SOVEREIGN_PLAYBOOK.md       ← gerado na entrega
├── README_CLIENTE.md           ← gerado na entrega
└── ROI_TRACKER_30DIAS.md       ← ativar 30 dias após lançamento
```

---

*Projeto clonado pelo `scripts/clone_project.py` · Quadrilateral IAH · V25*
*Atualizar este README ao fechar cada iteração*
"""


def clonar_projeto(
    cliente: str,
    nicho: str = "outro",
    camada: int = 2,
    silencioso: bool = False,
) -> Path:
    """Cria a estrutura completa do projeto."""
    slug = _slug(cliente)
    projeto_dir = CLIENTES_BASE / slug
    projeto_dir.mkdir(parents=True, exist_ok=True)

    # Subpastas
    (projeto_dir / "src" / "api").mkdir(parents=True, exist_ok=True)
    (projeto_dir / "src" / "web").mkdir(parents=True, exist_ok=True)
    (projeto_dir / "src" / "infra").mkdir(parents=True, exist_ok=True)
    (projeto_dir / ".claude" / "skills").mkdir(parents=True, exist_ok=True)

    data = datetime.now(timezone.utc).date().isoformat()

    # ── sentinel_config.json ─────────────────────────────────────────────────
    sentinel = _criar_sentinel_config(cliente, nicho, camada)
    (projeto_dir / "sentinel_config.json").write_text(
        json.dumps(sentinel, indent=2, ensure_ascii=False)
    )

    # ── feature_flags.json ───────────────────────────────────────────────────
    flags = _criar_feature_flags(camada)
    (projeto_dir / "feature_flags.json").write_text(
        json.dumps(flags, indent=2, ensure_ascii=False)
    )

    # ── knowledge_graph.json ─────────────────────────────────────────────────
    kg = _criar_ledger_projeto(cliente, slug)
    (projeto_dir / "knowledge_graph.json").write_text(
        json.dumps(kg, indent=2, ensure_ascii=False)
    )

    # ── INTELLIGENCE_LEDGER.md ───────────────────────────────────────────────
    ledger_md = f"""---
cliente: "{cliente}"
versao: "V1"
data: "{data}"
principios_ativos: 0
sessoes: 0
---

# INTELLIGENCE LEDGER — {cliente.upper()}
**Organismo:** Memória Viva do Quadrilateral IAH para este projeto
**Ciclo:** por sessão — atualizar via `python scripts/session_close.py`

> Este documento acumula a inteligência operacional do projeto.

## PRINCÍPIOS ATIVOS

*(nenhum ainda — o organismo começa vazio e cresce com cada sessão)*

## PADRÕES CONFIRMADOS

*(nenhum ainda)*

## PADRÕES REFUTADOS

*(nenhum ainda)*

## LOG DE SESSÕES

### [SESSÃO {data} — Kickoff]

`[PRINCÍPIO]` Primeira sessão do projeto — LEDGER inicializado via clone_project.py.
"""
    (projeto_dir / "INTELLIGENCE_LEDGER.md").write_text(ledger_md)

    # ── DECISOES_PENDENTES.md ────────────────────────────────────────────────
    decisoes = f"""# DECISOES_PENDENTES — {cliente} — V1
**Criado:** {data} | **Status:** sem decisões abertas

> Músculo: adicionar aqui decisões Classe B e C durante o build.
> Classe B = escopo/arquitetura (Diretor valida na próxima sync).
> Classe C = estratégica (parar e aguardar Veredito antes de avançar).

## DECISÕES ABERTAS

*(nenhuma ainda — projeto recém-inicializado)*

## DECISÕES RESOLVIDAS

| Data | Classe | Decisão | Veredito | Resultado |
|------|--------|---------|----------|-----------|
"""
    (projeto_dir / "DECISOES_PENDENTES.md").write_text(decisoes)

    # ── README.md ────────────────────────────────────────────────────────────
    readme = _criar_readme_projeto(cliente, slug, nicho, camada)
    (projeto_dir / "README.md").write_text(readme)

    # ── Copiar templates de fases (se a pasta existir) ────────────────────────
    templates_copiados = []
    template_map = {
        "FASE_0/BRIEFING_DISCOVERY.md": "BRIEFING_DISCOVERY.md",
        "FASE_0/PERFIL_CLIENTE_TEMPLATE.md": "PERFIL_CLIENTE.md",
        "FASE_4/PROPOSTA_COMERCIAL_TEMPLATE.md": "PROPOSTA_COMERCIAL.md",
        "FASE_4/CONTRATO_TEMPLATE.md": "CONTRATO.md",
        "FASE_4/SOVEREIGN_PLAYBOOK_TEMPLATE.md": "SOVEREIGN_PLAYBOOK.md",
        "FASE_4/README_CLIENTE_TEMPLATE.md": "README_CLIENTE.md",
        "FASE_5/INTELLIGENCE_LEDGER_TEMPLATE.md": "INTELLIGENCE_LEDGER_TEMPLATE_REF.md",
        "FASE_5/MEMORIA_TEMPLATE.md": "MEMORIA_V1_TEMPLATE.md",
        "FASE_5/relatorio_evolutivo_TEMPLATE.md": "relatorio_evolutivo_V1_TEMPLATE.md",
        "FASE_5/ROI_TRACKER_TEMPLATE.md": "ROI_TRACKER_30DIAS.md",
        "FASE_3/env_TEMPLATE.example": ".env.example",
    }

    for origem_rel, destino_nome in template_map.items():
        origem = TEMPLATES_BASE / origem_rel
        destino = projeto_dir / destino_nome
        if origem.exists() and not destino.exists():
            shutil.copy2(origem, destino)
            templates_copiados.append(destino_nome)

    if not silencioso:
        print()
        print("═" * 55)
        print(f"  PROJETO CRIADO: {cliente}")
        print("═" * 55)
        print(f"  Pasta  : CLIENTES/{slug}/")
        print(f"  Nicho  : {nicho}")
        print(f"  Camada : {camada}")
        print()
        print("  Arquivos criados:")
        print("  ✅ sentinel_config.json (preencher [PREENCHER])")
        print("  ✅ feature_flags.json")
        print("  ✅ knowledge_graph.json")
        print("  ✅ INTELLIGENCE_LEDGER.md")
        print("  ✅ DECISOES_PENDENTES.md")
        print("  ✅ README.md (próximos passos)")
        if templates_copiados:
            print(f"  ✅ {len(templates_copiados)} templates copiados das FASES")
        print()
        print("  PRÓXIMO PASSO:")
        print(f"  Abrir CLIENTES/{slug}/README.md")
        print("═" * 55)
        print()

    return projeto_dir


def main():
    parser = argparse.ArgumentParser(description="Clone Project — Quadrilateral IAH")
    parser.add_argument("--cliente", default="", help="Nome do cliente")
    parser.add_argument("--nicho", default="",
                        choices=["ecommerce", "clinica", "saas", "consultoria", "app", "marketplace", "outro"],
                        help="Nicho do cliente")
    parser.add_argument("--camada", type=int, default=0,
                        choices=[1, 2, 3, 4, 5], help="Camada de complexidade (1-5)")
    parser.add_argument("--silencioso", action="store_true", help="Sem output")
    args = parser.parse_args()

    cliente = args.cliente
    nicho = args.nicho
    camada = args.camada

    # Modo interativo se campos não fornecidos
    if not cliente:
        print("\n  CLONE PROJECT — Quadrilateral IAH\n")
        cliente = _perguntar("Nome do cliente (ex: Valdece, João Silva)", "Novo Cliente")
        nicho = _perguntar("Nicho (ecommerce/clinica/saas/consultoria/app/marketplace/outro)", "outro")
        camada_str = _perguntar("Camada (1=MVP, 2=Produto, 3=Plataforma, 4=Ecossistema, 5=Monopólio)", "2")
        try:
            camada = int(camada_str)
        except ValueError:
            camada = 2

    if not nicho:
        nicho = "outro"
    if not camada:
        camada = 2

    clonar_projeto(cliente=cliente, nicho=nicho, camada=camada, silencioso=args.silencioso)


if __name__ == "__main__":
    main()
