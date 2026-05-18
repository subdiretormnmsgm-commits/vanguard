# PROJETO — ingrid
**Nicho:** outro | **Camada:** 2 — Produto | **Criado:** 2026-05-15
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

### Passo 3 — Ativar o Auditor (Camada 2 — OBRIGATÓRIO)
```
[ ] Carregar no NotebookLM: BRIEFING_DISCOVERY.md + DIRETRIZ_V1
[ ] OU usar: POST /auditor/gerar-skill (automático)
[ ] Salvar Skill em: .claude/skills/ingrid-v1.md
```

### Passo 4 — Ativar o Músculo
```
[ ] Dizer: "PROTOCOLO VANGUARD — ingrid. Leia tudo e delibere."
[ ] Trazer: DIRETRIZ + Skill (se Camada 2+)
[ ] Aguardar deliberação e plano antes de aprovar build
```

### Passo 5 — Preencher configurações antes do Módulo 0
```
[ ] sentinel_config.json — preencher campos [PREENCHER]
[ ] feature_flags.json — confirmar features ativas para Camada 2
[ ] .env — copiar de env_TEMPLATE.example e preencher
```

---

## ESTRUTURA DE ARQUIVOS

```
CLIENTES/ingrid/
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
