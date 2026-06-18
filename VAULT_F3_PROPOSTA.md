# VAULT SOBERANO — F3: Organograma + Relocação de Docs Soltos (com mapa de referências)

> Gerado: 2026-06-17 (quarta-feira) | Insumo: F1 (VAULT_AUDIT_REPORT) + F2 (acervo) + mapa de referências desta fase.
> **STATUS: AGUARDANDO VEREDITO BLOCO A BLOCO (C2).** Nada é movido sem SIM do Diretor.
> **Política CONSERVADORA:** toda relocação via `git mv` (100% versionada, reversível). Zero `Remove-Item`.
> **C5:** `Doc Vanguard Evolução Diretor` é PROIBIDA — não entra nesta proposta.

---

## 0. DECISÃO DE ESCOPO — F3 É NARROW (consultor-first, recomendação do Músculo)

O plano original previa "agrupar INFRA viva em `INFRA/`". **O mapa de referências desta fase recomenda NÃO fazer isso:**
- `docker-compose.yml` (EasyPanel) tem build context relativo; `cloudflare/*.js` deploia via wrangler (paths relativos);
  `.netlify/` é estado de deploy; `_n8n` e `n8n_workflows` estão **hardcoded em `.claude/settings.local.json`**.
- Mover essas pastas = quebrar deploy/permissões. **Ganho: cosmético. Risco: alto.**

→ **F3 cobre APENAS docs soltos** (relocação de baixo risco). INFRA **fica onde está**; entrega-se um
`INFRA_INDEX.md` (doc-only, nada movido) mapeando o que cada pasta deploia. Agrupar INFRA fisicamente
só se houver gate dedicado futuro com teste de deploy — não nesta operação.

---

## 1. ORGANOGRAMA-ALVO (F3)

```
vanguard/
├── [CANÔNICOS RAIZ — INTOCADOS]
│   CLAUDE.md GEMINI.md AGENTS.md PENDENTES.md INTELLIGENCE_LEDGER.md LEDGER_INBOX.md
│   knowledge_graph.json  skills-lock.json  CONTEXTO_GEMINI.md (fallback de script — NÃO mover)
│   VAULT_AUDIT_REPORT.md VAULT_F2_PROPOSTA.md VAULT_F3_PROPOSTA.md VAULT_MANIFEST.json (operação ativa → arquiva na F7)
├── CONSELHO/                          # análises de sócio (já existe)
│   ├── SUGESTOES_DIRETOR.md           # ← raiz (canônico R-01 declarado aqui)
│   ├── FEEDBACK_EMBAIXADOR_MUSCULO.md # ← raiz
│   ├── resposta_auditor_v34.txt       # ← raiz
│   └── Gemini/ DIRETRIZ_GEMINI_V28.txt# ← raiz (já existe CONSELHO/Gemini/)
├── CONTEXTO_DIRETOR/                  # ★ NOVO — notas pessoais soltas do Diretor
│   Frases Diretor.txt · FLUXO_PROCESSO_DIRETOR.txt · Documentos Claude Projects.txt
│   Neural Sentinel site explicar depois.txt · Task Scheduler.txt · .claudeignore.txt
├── docs/                             # já existe (superpowers plans/specs)
│   ├── n8n/  N8N.txt · N8N 2.txt · QUADRO COMPLETO N8N.txt
│   └── PESQUISA_SKILLS_2026-06-11.md
├── PENTALATERAL_UNIVERSAL/OPERACAO/   # docs de sistema (DECISÃO do Diretor — ver Bloco D)
│   INSTRUCAO_SISTEMA_UNIVERSAL.md · INSTRUCAO_AUTOMACAO_ABERTURA_FECHAMENTO.md
└── [INFRA VIVA — NÃO MOVER]  hermes/ hermes-agent/ cloudflare/ supabase/ infra/
    _n8n/ n8n_workflows/ .netlify/ docker-compose.yml  → só INFRA_INDEX.md (doc-only)
```

---

## 2. LISTA NUMERADA — VEREDITO SIM/NÃO (responder por bloco ou `1-SIM 2-NÃO ...`)

### BLOCO A — DOCS DE SÓCIO → `CONSELHO/` (baixo risco; nenhum script referencia)
1. `FEEDBACK EMBAIXADOR MUSCULO.md` → `CONSELHO/FEEDBACK_EMBAIXADOR_MUSCULO.md`
2. `resposta_auditor_v34.txt` → `CONSELHO/resposta_auditor_v34.txt`
3. `DIRETRIZ_GEMINI_V28.txt` → `CONSELHO/Gemini/DIRETRIZ_GEMINI_V28.txt`

### BLOCO B — NOTAS PESSOAIS DO DIRETOR → `CONTEXTO_DIRETOR/` (★ nova pasta; baixo risco)
4. `Frases Diretor.txt`
5. `FLUXO_PROCESSO_DIRETOR.txt`
6. `Documentos Claude Projects.txt`
7. `Neural Sentinel site explicar depois.txt`
8. `Task Scheduler.txt`  (o .txt — NÃO confundir com o agendador do Windows; nenhum script lê este arquivo)
9. `.claudeignore.txt`   (note: tem extensão `.txt` → NÃO é um `.claudeignore` ativo; é nota solta)

### BLOCO C — NOTAS N8N + PESQUISA → `docs/` (baixo risco)
10. `N8N.txt` · `N8N 2.txt` · `QUADRO COMPLETO N8N.txt` → `docs/n8n/`
11. `PESQUISA SKILLS 2026-06-11.md` → `docs/PESQUISA_SKILLS_2026-06-11.md`

### BLOCO D — DOCS DE SISTEMA (★ DECISÃO DO DIRETOR — não auto-movo)
12. `SUGESTOES_DIRETOR.md` → `CONSELHO/SUGESTOES_DIRETOR.md`
    - **Por que precisa de você:** é seu arquivo PRIVADO + protegido por R-01 (firewall). O canônico
      declarado já é `CONSELHO/` — então isto é uma *correção de lugar*. Mover exige `[VEREDITO-DIRETOR]`.
13. `INSTRUCAO_SISTEMA_UNIVERSAL.md` → `PENTALATERAL_UNIVERSAL/OPERACAO/` **OU** `docs/`?
    - **Por que precisa de você:** se for TIPO1 (fonte canônica), ir para `PENTALATERAL_UNIVERSAL/` o
      coloca no **sync automático** (copiado para todos os `CLIENTES/*/NOTEBOOKLM_FONTES/`). Se for nota
      avulsa, vai para `docs/` sem sync. **Qual é?** (a) fonte canônica → UNIVERSAL+DEPENDENCY_MAP · (b) nota → docs/
14. `INSTRUCAO_AUTOMACAO_ABERTURA_FECHAMENTO.md` → `PENTALATERAL_UNIVERSAL/OPERACAO/` (doc operacional; sem ref de script)

### BLOCO E — SCRIPT-ENTRY (DIFERIR — opcional)
15. `fechar_sessao.ps1` → `scripts/`?  Nenhum código o chama (só uso manual `.\fechar_sessao.ps1`).
    Mover muda a memória muscular do Diretor. **Recomendação: DEIXAR na raiz** (ou mover + criar shim). Sugiro NÃO.

### BLOCO F — INFRA_INDEX (doc-only; nada movido)
16. Gerar `INFRA_INDEX.md` na raiz mapeando: pasta → o que deploia → onde (EasyPanel/Cloudflare/Netlify/Supabase).
    Zero `git mv`. Só documentação para acabar com o "o que é cada pasta de infra?".

---

## 3. O QUE *NÃO* SE TOCA (firewall desta fase)
- Canônicos raiz (lista do Bloco 1). `CONTEXTO_GEMINI.md` (alvo de `gemini_anchor_generator.ps1`).
- INFRA viva: `hermes/ hermes-agent/ cloudflare/ supabase/ infra/ _n8n/ n8n_workflows/ .netlify/ docker-compose.yml`.
- `Doc Vanguard Evolução Diretor/` (C5). `CLIENTES/*` (P-059, só F5). `.git/ .claude/ .agents/`.
- `ACERVO_VANGUARD/` e `_ARQUIVO/` (já consolidados na F2).

---

## 4. SEQUÊNCIA DE EXECUÇÃO PÓS-VEREDITO
1. Criar pastas-alvo (`CONTEXTO_DIRETOR/`, `docs/n8n/`) só se houver SIM nos blocos correspondentes.
2. `git mv` item a item, **só** o que recebeu SIM, com log origem→destino.
3. Bloco D (SUGESTOES_DIRETOR): commit com `[VEREDITO-DIRETOR]` (R-01).
4. Gerar `INFRA_INDEX.md` (Bloco F) se aprovado.
5. Re-rodar `vault_audit.ps1` → confirmar queda de ruído na raiz.
6. Commit `refactor(vault): F3 organograma -- docs soltos relocados [veredito ...]` (sem [RESOLVE:] — guarda-chuva #11 fecha na F7).

---

**Gate BLOQUEANTE:** nenhuma linha da Seção 2 executa sem o seu SIM. INFRA fica intocada por decisão técnica (escopo narrow).
