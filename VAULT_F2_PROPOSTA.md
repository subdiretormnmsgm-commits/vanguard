# VAULT SOBERANO — F2: Árvore-Alvo + Exclusões Numeradas (revisada)

> Gerado: 2026-06-17 (quarta-feira) | Insumo: VAULT_AUDIT_REPORT.md (F1) + gate técnico da RAIZ.
> **STATUS: AGUARDANDO VEREDITO BLOCO A BLOCO (C2).** Nada é movido/apagado sem SIM do Diretor.
> **Política CONSERVADORA:** "excluído" = `git mv` para `_ARQUIVO/` (100% versionado, reversível) — nunca `Remove-Item`, salvo lixo inequívoco (Bloco 1).
> **C5:** `Doc Vanguard Evolução Diretor` é PROIBIDA — não entra nesta proposta em nenhuma hipótese.

---

## 0. DECISÃO DE ESCOPO — RESOLVIDA (C', aprovada pelo Diretor 2026-06-17)

O código-produto V1-V24 **NÃO é legado descartável** — é a **base técnica reutilizável** dos projetos Vanguard
(Stripe Connect, RLS multi-tenant, badge SVG, scrapers, Census Engine...). Decisão do Diretor:
*"Não queria excluir o histórico da Vanguard. V1 a 24... é a base que temos para os diversos projetos."*

→ **Caminho C' — Acervo organizado e indexado, não arquivo-morto.** O código-produto inerte é
**consolidado e preservado** num `ACERVO_VANGUARD/` visível na raiz, com `INDEX.md` que mapeia
componente → versão → reuso. Nada é deletado; tudo continua no git; o histórico fica **mais acessível**, não menos.

**Distinção crítica do gate técnico:** infra que alimenta serviço VIVO no EasyPanel (Hermes/n8n) **não é
histórico** — fica fora do acervo, intocada nesta fase (Bloco 5).

---

## 1. ORGANOGRAMA-ALVO

```
vanguard/
├── PENTALATERAL_UNIVERSAL/      # fonte canônica do sistema (TIPO1/TIPO2)
├── CLIENTES/                    # isolamento P-059 (intocado na F2)
├── CONSELHO/                    # análises de sócio, Detector de Deriva
├── scripts/                     # automação canônica
├── .claude/ .agents/ .github/   # config/hooks
├── PROTOCOLOS_ENCERRAMENTO/
├── ACERVO_VANGUARD/             # ★ NOVO — base técnica V1-V24 preservada e indexada
│   ├── INDEX.md                 #   mapa componente → versão → reuso (gerado das MEMORIAS V1-V24)
│   ├── api/ saas/ marketplace/ census/ score/ cockpit/ dashboard/
│   ├── quadrilateral/ js/ assets/ intelligence/ preview/ utils/ tests/
│   └── PWA/                     #   index.html, sw.js, manifest.json, server.js, knowledge_graph.json
├── INFRA/                       # (F3) agrupar infra viva — NÃO mexer na F2
├── CLAUDE.md GEMINI.md AGENTS.md PENDENTES.md INTELLIGENCE_LEDGER.md LEDGER_INBOX.md
└── _ARQUIVO/                    # detrito de sessão (versionado, reversível)
    ├── SYNC_REPORTS/  SCREENSHOTS/  BAK/  RELATORIOS_DATADOS/  SNAPSHOTS_NBLM/
```

---

## 2. LISTA NUMERADA — VEREDITO SIM/NÃO (responder `1-SIM 2-NÃO ...` ou por bloco)

### BLOCO 1 — LIXO INEQUÍVOCO (apagar; exceção à política conservadora)
1. `@{meta=...}` — arquivo de nome corrompido (objeto PowerShell serializado, 0 conteúdo útil) → **DELETE**
2. `.Rhistory` (já gitignored, vazio) → **DELETE**
3. Pastas vazias (0 arquivos): `clients/ VEREDITOS/ certifica/ methodology/ templates/ tenants/` → **DELETE**
4. `.playwright-mcp/` — 82 arquivos rastreados apesar de já estar no `.gitignore` → **`git rm --cached`** (mantém local, sai do índice)

### BLOCO 2 — HIGIENE DE RAIZ (→ `_ARQUIVO/`, reversível)
5. 15× `SYNC_REPORT_*.md` (logs) → `_ARQUIVO/SYNC_REPORTS/`
6. Screenshots na raiz: `toga_*.png` (3), `valdece_demo_test.png`, `netlify_dashboard.png`, `Vanguard - Imagem*.png` (2) → `_ARQUIVO/SCREENSHOTS/`
7. 4× `*.bak` (CLAUDE/GEMINI/PENDENTES/INTELLIGENCE_LEDGER) → `_ARQUIVO/BAK/`
8. Relatórios datados superados: `RELATORIO_FASE1_SYNC_GUARD_2026-06-06.md`, `MAPA_REPOSITORIO.md`, `AUDITORIA_VANGUARD.txt` → `_ARQUIVO/RELATORIOS_DATADOS/`

### BLOCO 3 — SNAPSHOTS CONGELADOS (achado DRIFT_INTRA da F1)
9. `PENTALATERAL_UNIVERSAL/VANGUARD_HISTORICO/SESOES/NOTEBOOKLM_RAIZ_V16-V24/` (cópias já superadas pelos vivos) → `_ARQUIVO/SNAPSHOTS_NBLM/`

### BLOCO 4 — ACERVO_VANGUARD (★ preservar V1-V24 indexado — código INERTE, ref-check confirmado)
10. Consolidar pastas-produto inertes → `ACERVO_VANGUARD/`: `api saas marketplace quadrilateral js assets intelligence score cockpit dashboard census preview utils tests`
11. Mover arquivos-produto soltos da raiz → `ACERVO_VANGUARD/PWA/`: `server.js sw.js index.html manifest.json knowledge_graph.json start_quadrilateral.ps1 requirements.txt deploy.sh preflight.ps1 n8n-workflow-hermes.json`
12. Gerar `ACERVO_VANGUARD/INDEX.md` cruzando com as MEMORIAS V1-V24 (mapa componente → versão → reuso)

### BLOCO 5 — INFRA VIVA (★ NÃO TOCAR na F2 — fonte de deploy EasyPanel)
- `hermes/ hermes-agent/ _n8n/ n8n_workflows/ n8n_exports/ supabase/ infra/ cloudflare/ .netlify/` + `Dockerfile* docker-compose* .dockerignore`
- **Razão (gate técnico):** `hermes-agent/.env`+`docker-compose.yml`, `hermes/Dockerfile`, `infra/Dockerfile` alimentam o Hermes/n8n VIVOS no EasyPanel. Reorganizar (→ `INFRA/`) é F3, com gate próprio.

### BLOCO 6 — DOCS SOLTOS NA RAIZ (DIFERIR para F3 organograma)
- ~25 `.txt/.md` de contexto soltos (`N8N.txt`, `Frases Diretor.txt`, `O NOVO LOOPING...V27.txt`, `DIRETRIZ_GEMINI_V28.txt`, etc.).
- **Não entram na F2:** alguns são referenciados (`CONTEXTO_GEMINI.md` gerado por script, `INSTRUCAO_SISTEMA_UNIVERSAL.md`). Mover é decisão de design + risco de referência → tratado na F3 com mapa de referências.

---

## 3. O QUE *NÃO* SE TOCA (firewall desta fase)
- `Doc Vanguard Evolução Diretor/` — C5, PROIBIDO.
- `CLIENTES/*/` — isolamento P-059; só F5 mexe, com veredito próprio.
- Canônicos na raiz: `CLAUDE.md GEMINI.md AGENTS.md PENDENTES.md INTELLIGENCE_LEDGER.md LEDGER_INBOX.md DEPENDENCY_MAP`.
- Infra viva (Bloco 5). `.git/ .claude/ .agents/`.

---

## 4. SEQUÊNCIA DE EXECUÇÃO PÓS-VEREDITO
1. Checkpoint git: commit `chore(vault): checkpoint pre-F2` (estado antes de qualquer movimento).
2. `_ARQUIVO/` + `ACERVO_VANGUARD/` + subpastas; mover **só** o que recebeu SIM, com log origem→destino por arquivo.
3. Gerar `INDEX.md` do acervo.
4. Re-rodar `vault_audit.ps1` → confirmar queda de ruído.
5. Commit `refactor(vault): F2 dedup/reorg — N itens [veredito bloco a bloco]` (passa R-05 code-review).
6. Só então F3 (organograma: INFRA/ + docs soltos) + F4 (markdown) + F5 (sync/adaptação).

---

**Gate BLOQUEANTE:** nenhuma linha da Seção 2 executa sem o seu SIM. Bloco 5 fica intocado nesta fase por decisão técnica.
