# MAPA DO REPOSITÓRIO VANGUARD
**Organograma completo de pastas**
Gerado em: 2026-06-06 | Músculo · Pentalateral IAH

---

## LEGENDA

```
[IAH]  = Sistema Pentalateral — documentos de processo, memória, princípios
[CLI]  = Projeto de cliente — código + documentação operacional
[PRD]  = Código do produto Vanguard (V1–V27) — frontend, backend, infra
[AUT]  = Automação — scripts, n8n, hooks
[FSL]  = Fóssil histórico — supersedido, mantido por rastreabilidade
[NEW]  = Conceito novo ainda em definição
```

---

## ORGANOGRAMA

```
vanguard/                                      ← RAIZ DO REPOSITÓRIO
│
├── [IAH] CLIENTES/                            ← Projetos de clientes ativos
│   ├── WIP_BOARD.json                         ← Estado master (todos os projetos)
│   ├── WIP_BOARD.md                           ← Versão legível do WIP_BOARD
│   │
│   ├── INGRID/                                ← PROJ-002 | EdTech-Concurso | Loop 8
│   │   ├── CLAUDE_PROJECT/                    ← Documentos do Embaixador (Ingrid)
│   │   │   ├── DECISOES/                      ← JSONs de decisão + vereditos
│   │   │   │   └── _ARQUIVADO/                ← Decisões processadas
│   │   │   └── (MEMORIA, PASSO7, PERFIL…)
│   │   ├── NOTEBOOKLM_FONTES/                 ← 17 fontes para o Auditor (Ingrid)
│   │   ├── NOTEBOOKLM_DROP/                   ← Drop zone para Skills recebidas
│   │   ├── HISTORICO/                         ← MEMORIAs + relatórios por loop
│   │   ├── CONSELHO/                          ← Análises e respostas do Conselho
│   │   ├── KNOWLEDGE_BASE/                    ← Soluções técnicas documentadas
│   │   ├── frontend/                          ← App Ingrid (HTML/JS)
│   │   ├── backend/                           ← Edge Functions Ingrid
│   │   │   └── gerar-questoes/
│   │   ├── supabase/                          ← Configuração Supabase Ingrid
│   │   │   ├── functions/                     ← Edge Functions deploy
│   │   │   │   ├── alerta-inatividade/
│   │   │   │   ├── gatilho-temporal/
│   │   │   │   ├── notificar-progresso/
│   │   │   │   ├── relatorio-semanal/
│   │   │   │   └── tutor-socratico/
│   │   │   └── migrations/
│   │   ├── sql/                               ← Migrations SQL locais
│   │   └── scripts/                           ← Scripts específicos de Ingrid
│   │
│   └── VALDECE/                               ← PROJ-001 | LegalTech-Penal | Hypercare
│       ├── CLAUDE_PROJECT/                    ← Documentos do Embaixador (Valdece)
│       │   ├── DECISOES/
│       │   │   └── _ARQUIVADO/
│       │   └── (MEMORIA, PASSO7, VEREDITOS…)
│       ├── NOTEBOOKLM_FONTES/                 ← 17 fontes para o Auditor (Valdece)
│       ├── NOTEBOOKLM_DROP/
│       ├── HISTORICO/
│       ├── CONSELHO/
│       ├── KNOWLEDGE_BASE/
│       ├── app/                               ← App Valdece (HTML/JS)
│       │   ├── css/
│       │   └── js/
│       ├── frontend/
│       ├── backend/
│       ├── netlify/                           ← Netlify functions Valdece
│       │   └── functions/
│       └── sql/
│
├── [IAH] PENTALATERAL_UNIVERSAL/              ← Documentação universal do sistema IAH
│   ├── CONSTITUICAO/                          ← Memorando + Business Rules + SOP
│   ├── NOTEBOOKLM_BASE/                       ← 8 fontes base (01–08) para todo NotebookLM
│   ├── OPERACAO/                              ← Skill Protocolo, Manual Diretor, PASSO files
│   │   └── PHTC/                             ← Processo de Hypercare por template
│   ├── TEMPLATES/                             ← Templates de FASES (Briefing, Discovery…)
│   │   └── scripts/
│   ├── PERFIS_NICHO/                          ← Perfis de nicho (trade secret)
│   │   ├── CONTABILIDADE/
│   │   ├── EDTECH_CONCURSO/
│   │   ├── LEGALTECH_PENAL/
│   │   ├── MEDICINA/
│   │   └── PSICOLOGIA/
│   ├── CLAUDE_PROJECTS/                       ← Templates para Embaixador (instrução, modelo)
│   ├── JURIDICO/                              ← Contratos e termos universais
│   ├── HISTORICO/                             ← Histórico de evolução do processo
│   ├── CONHECIMENTO/
│   ├── KNOWLEDGE_BASE/                        ← Soluções técnicas universais
│   ├── PLANEJAMENTO/
│   ├── PLANEJAMENTO ESTRATÉGICO/              ← Missão, valores, planejamento
│   │   ├── MISSAO E VALORES/
│   │   └── PLANEJAMENTO ESTRATEGICO/
│   ├── APRESENTACAO VANGUARD/                 ← Materiais de apresentação
│   ├── REFERENCIAS/                           ← Referências externas
│   ├── VANGUARD_HISTORICO/                    ← Histórico do produto V1–V27
│   │   ├── MEMORIAS/                          ← MEMORIAs das versões do produto
│   │   ├── RELATORIOS/                        ← Relatórios evolutivos das versões
│   │   └── SESOES/                            ← Sessões históricas do NotebookLM
│   │       ├── NOTEBOOKLM_LOOP1_VALDECE/
│   │       └── NOTEBOOKLM_RAIZ_V16-V24/
│   ├── files/
│   └── scripts/
│
├── [IAH] CONSELHO/                            ← Comunicações e artefatos do Conselho
│   ├── Gemini/                                ← Histórico de comandos ao Estrategista
│   │   └── HISTORICO/
│   └── NotebookLM/                            ← Análises e memorandos do Auditor
│
├── [IAH] PROTOCOLOS_ENCERRAMENTO/             ← PAINELs + CONTEXTO_SESSAO por data
│
├── [IAH] VEREDITOS/                           ← Vereditos recebidos via Telegram (W-7)
│   └── processed/                             ← Vereditos já processados
│
├── [IAH] INTELLIGENCE_LEDGER.md              ← P-001 a P-115 · fonte canônica
├── [IAH] PENDENTES.md                         ← Tarefas abertas (fonte de verdade)
├── [IAH] CONTEXTO_GEMINI.md                   ← Contexto compilado para o Gemini
├── [IAH] CLAUDE.md                            ← Constituição operacional do Músculo
│
├── [AUT] scripts/                             ← Scripts de orquestração do Pentalateral
│   ├── msgs/                                  ← Templates de mensagens
│   └── __pycache__/
│
├── [AUT] .claude/                             ← Configuração do Claude Code
│   ├── hooks/                                 ← Hooks automáticos (session_start, hv1…)
│   ├── skills/                                ← Skills ativas do Músculo
│   │   ├── files/                             ← Scripts auxiliares das skills
│   │   ├── Auditoria/
│   │   ├── Conselho deliberativo/
│   │   ├── Evolução Projeto Vanguard/
│   │   └── [FSL] quadrilateral-v25/           ← Skills da era pré-Pentalateral
│   ├── meta/
│   └── projects/                              ← Memória persistente do Músculo
│       └── C--Users-Eduardo-DELL.../
│           └── memory/
│
├── [AUT] _n8n/                                ← Workflows n8n (JSON export + docs)
│   └── workflows/                             ← Arquivos .json dos workflows
│
├── [NEW] SECRETARIO_VIRTUAL/                  ← Conceito Hermes bidirecional (em definição)
│   └── templates/
│
│── ─────────────────────────────────────────────────────────────────
│   CÓDIGO DO PRODUTO VANGUARD (V1–V27)
│── ─────────────────────────────────────────────────────────────────
│
├── [PRD] api/                                 ← API endpoints do produto
├── [PRD] assets/                              ← CSS, JS, ícones, screenshots do produto
│   ├── css/
│   ├── js/
│   ├── icons/
│   └── screenshots/
├── [PRD] census/                              ← Census Engine (V13)
├── [PRD] certifica/                           ← Certifica SVG (V9)
├── [PRD] clients/                             ← Multi-tenant client management
├── [PRD] cloudflare/                          ← Workers Cloudflare
├── [PRD] cockpit/                             ← Sovereign Ignition Cockpit (V12)
├── [PRD] dashboard/                           ← Dashboard PWA
├── [PRD] docs/                                ← Documentação técnica do produto
│   └── superpowers/
│       ├── plans/
│       └── specs/
├── [PRD] hermes/                              ← Hermes Voice / Webhook (V9)
├── [PRD] infra/                               ← Infraestrutura compartilhada
├── [PRD] intelligence/                        ← Intelligence API (V8)
│   └── assets/
│       ├── css/
│       └── js/
├── [PRD] js/                                  ← JavaScript compartilhado
├── [PRD] marketplace/                         ← Dark Bazaar Marketplace (V7)
│   └── assets/
│       ├── css/
│       └── js/
├── [PRD] methodology/                         ← Metodologia do produto
├── [PRD] n8n_workflows/                       ← Workflows n8n do produto (raiz)
├── [PRD] outbound/                            ← Scraper Outbound (V3)
├── [PRD] preview/                             ← Preview do produto
├── [PRD] saas/                                ← SaaS Multi-tenant (V6)
│   └── assets/
│       ├── css/
│       ├── img/
│       └── js/
├── [PRD] score/                               ← Score™ Microsite (V9)
│   └── assets/
│       ├── css/
│       └── js/
├── [PRD] supabase/                            ← Supabase do produto (raiz / V1–V11)
│   ├── functions/
│   │   ├── feed-diario/
│   │   ├── gerar-questoes/
│   │   └── tutor-socratico/
│   └── .temp/
├── [PRD] templates/                           ← Templates HTML do produto
├── [PRD] tenants/                             ← Gestão de tenants multi-tenant
├── [PRD] tests/                               ← Testes automatizados do produto
└── [PRD] utils/                               ← Utilitários compartilhados
│
│── ─────────────────────────────────────────────────────────────────
│   FÓSSEIS HISTÓRICOS (mantidos por rastreabilidade, não operacionais)
│── ─────────────────────────────────────────────────────────────────
│
├── [FSL] Vanguard - Ingrid/                   ← Era Loop 1 Ingrid (LEDGER P-016)
├── [FSL] quadrilateral/                       ← Era V8-V9 — codebase Python descontinuada
│   ├── CLIENTES/ingrid/                       ← Ingrid da era quadrilateral
│   │   ├── .claude/skills/
│   │   └── src/ (api/, infra/, web/)
│   ├── api/
│   ├── scripts/
│   └── tests/
├── [FSL] memorias/                            ← MEMORIAs V1–V11 do produto
├── [FSL] skills/                              ← ZIP do quadrilateral v25
└── [FSL] pasta sem título/                    ← Pasta sem uso identificado

```

---

## RESUMO POR CATEGORIA

| Categoria | Pastas | Função |
|---|---|---|
| **[IAH] Sistema Pentalateral** | `CLIENTES/` · `PENTALATERAL_UNIVERSAL/` · `CONSELHO/` · `PROTOCOLOS_ENCERRAMENTO/` · `VEREDITOS/` · `INTELLIGENCE_LEDGER.md` · `PENDENTES.md` | Processo, memória, princípios e documentação do Pentalateral IAH |
| **[AUT] Automação** | `scripts/` · `.claude/` · `_n8n/` | Hooks, scripts de orquestração, workflows n8n |
| **[NEW] Em definição** | `SECRETARIO_VIRTUAL/` | Conceito Hermes bidirecional — aguarda deliberação |
| **[PRD] Produto Vanguard** | `api/` `assets/` `census/` `certifica/` `clients/` `cloudflare/` `cockpit/` `dashboard/` `docs/` `hermes/` `infra/` `intelligence/` `js/` `marketplace/` `methodology/` `n8n_workflows/` `outbound/` `preview/` `saas/` `score/` `supabase/` `templates/` `tenants/` `tests/` `utils/` | Código do produto Vanguard V1–V27 |
| **[FSL] Fósseis** | `Vanguard - Ingrid/` · `quadrilateral/` · `memorias/` · `skills/` · `pasta sem título/` | Histórico preservado — não operacional |

---

## CONTAGEM

| Categoria | Qtd de pastas |
|---|---|
| [IAH] Sistema Pentalateral | ~45 pastas |
| [AUT] Automação | ~15 pastas |
| [PRD] Produto Vanguard | ~40 pastas |
| [FSL] Fósseis históricos | ~20 pastas |
| **Total** | **~120 pastas** |

---

## OBSERVAÇÕES DO MÚSCULO

**1. Duplicação de nomes dentro de PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE/**
A pasta contém arquivos com e sem prefixo numérico para o mesmo documento
(ex: `04_INTELLIGENCE_LEDGER.md` e `INTELLIGENCE_LEDGER.md`). O arquivo sem
prefixo está em P-115; o prefixado em P-114. São arquivos distintos com conteúdo divergente.

**2. Três pastas [FSL] que poderiam ser arquivadas ou removidas**
`Vanguard - Ingrid/` (Loop 1), `quadrilateral/` (Python V8-V9) e `skills/` (ZIP)
não são referenciados por nenhum processo ativo. Não alterar sem veredito do Diretor.

**3. O produto Vanguard (V1–V27) vive misturado com o sistema IAH**
As ~40 pastas de código do produto (`api/`, `cockpit/`, `saas/`, etc.) ficam na
raiz junto com os documentos IAH. Isso gera a sensação de caos — mas são dois
mundos distintos compartilhando a mesma raiz: o **produto** e o **processo que o cria**.

---

*Músculo · Pentalateral IAH · 2026-06-06*
*Documento de leitura — nenhuma pasta foi alterada, renomeada ou removida.*
