# VAULT SOBERANO — F5: Sync + Adaptação Contextual por Cliente (gate P-059)

> Gerado: 2026-06-17 (quarta-feira) | Insumo: auditoria de hash base↔cliente + WIP_BOARD + mapa de referências de script.
> **STATUS: EXECUTADA E FECHADA 2026-06-17.** Veredito 1-SIM 2-SIM 3-SIM 4-SIM 5-a 6-SIM 7-SIM —
> **corrigido na execução** (ver Seção 5): A+E executados; B/C/D PULADOS por achado de disco (curadoria/cliente-real, não lacuna).
> **Tudo reversível** (`git mv` p/ relocações · `sync -cliente X` isolado por cliente · `-modo verificar` é read-only).
> **GATE P-059 ATIVO:** cada cliente é tratado em isolamento absoluto. Nenhuma ação cruza Ingrid↔Valdece↔Vanguard↔Mumuzinho↔Standby.

---

## 0. ACHADO CENTRAL DA AUDITORIA — F5 É PEQUENA E SEGURA (consultor-first)

A varredura de hash (base universal `NOTEBOOKLM_BASE/` ↔ cópia em cada `CLIENTES/*/NOTEBOOKLM_FONTES/`) provou:

> **O conteúdo já está 100% sincronizado. ZERO divergência de hash em todos os clientes.**
> O único "desvio" é **ausência** de docs base em clientes recentes — nunca conteúdo defasado.

Isso elimina o maior risco que F5 teoricamente carregava (overwrite de conteúdo cruzando a fronteira P-059).
**Não há nada para reescrever.** F5 vira três reconciliações estreitas + um confirm read-only:

| # | Ação | Risco | Territorio |
|---|---|---|---|
| A | Higiene da FONTE: 3 `.bak` strays → `_ARQUIVO/BAK/` | baixo | universal (não-P-059) |
| B | Completar base do MUMUZINHO (DISCOVERY ativo) | baixo | só MUMUZINHO (P-059) |
| C | STANDBY: decisão "é cliente ou slot-template?" | nulo (decisão) | só STANDBY (P-059) |
| D | Gerar `00_MANIFESTO_DE_FONTES.md` nos 2 clientes sem ele | baixo | por cliente (P-059) |
| E | Rodar `sync -modo verificar` por cliente → relatório oficial GREEN | nulo (read-only) | por cliente (P-059) |
| F | "Adaptação contextual profunda" — FORA DE ESCOPO (ver Seção 3) | — | — |

**Estado por cliente (foto da auditoria):**
- **VANGUARD** (BUILD, Loop 35): 27 docs, base completa, **zero ausência** — flagship em ordem. Nada a fazer.
- **VALDECE** (CHECK, Loop 7 concluído): 27 docs, base completa. Nada a fazer.
- **INGRID** (RETAINER, Loop 8 concluído): 27 docs, base completa. Nada a fazer.
- **MUMUZINHO** (DISCOVERY): 12 docs — faltam 5 docs base (00, 02, 05, 08, LEDGER_INDEX) + sem MANIFESTO.
- **STANDBY** (fora do board): 12 docs, espelha MUMUZINHO — provável slot-template, não cliente real.

---

## 1. LISTA NUMERADA — VEREDITO SIM/NÃO (responder por bloco)

### BLOCO A — HIGIENE DA FONTE: 3 `.bak` strays → `_ARQUIVO/BAK/` (universal; baixo risco)
> Backups soltos que poluem locais canônicos. Nenhum script os referencia (checado). Via `git mv`.
> ⚠️ `CLIENTES/WIP_BOARD.md` **NÃO entra** — é lido pelo `notion_sync.ps1` (espelho do board p/ Notion). Fica.
1. `PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE/20_LOOP_STATE_SCHEMA.md.bak` → `_ARQUIVO/BAK/` (★ polui a FONTE do sync)
2. `PENTALATERAL_UNIVERSAL/OPERACAO/DEPENDENCY_MAP.json.bak` → `_ARQUIVO/BAK/`
3. `CLIENTES/WIP_BOARD.json.bak` → `_ARQUIVO/BAK/`

### BLOCO B — MUMUZINHO: completar base (DISCOVERY ativo; P-059 isolado)
4. Rodar `sync_vanguard_docs.ps1 -cliente MUMUZINHO -modo completo` para adicionar os 5 docs base ausentes
   (`00_INSTRUCAO_AUDITOR.md`, `02_MEMORANDO`, `05_PROCESSO_EVOLUTIVO`, `08_ANALISE_SOCIO_ATUAL.txt`, `LEDGER_INDEX.md`).
   - **Recomendação: SIM.** É cliente ativo em DISCOVERY; merece a base completa antes do Loop 1.
   - **Isolamento:** flag `-cliente MUMUZINHO` toca SOMENTE essa pasta. Conteúdo vem do universal (idêntico aos outros). Zero cross-talk.

### BLOCO C — STANDBY: é cliente ou slot-template? (★ DECISÃO DO DIRETOR)
5. STANDBY não está no board (nem discovery). Espelha o MUMUZINHO exatamente. Três opções:
   - **(a) SLOT-TEMPLATE** → renomear para `CLIENTES/_TEMPLATE_CLIENTE/` (deixa explícito que não é cliente real; sai do radar P-059 de cliente ativo). **← recomendação.**
   - **(b) CLIENTE REAL futuro** → manter `STANDBY`, completar base igual ao Bloco B.
   - **(c) DEIXAR como está** → nenhuma ação.
   Responda **5-a**, **5-b** ou **5-c**.

### BLOCO D — MANIFESTO de FONTES nos clientes sem ele (auto-documentação; P-059)
6. Gerar `00_MANIFESTO_DE_FONTES.md` em **MUMUZINHO** (e em STANDBY se 5-b) — espelha o padrão que INGRID/VALDECE/VANGUARD já têm.
   Documento curto: lista o que cada FONTES contém + contexto do cliente. Sem tocar conteúdo de loop.
   - **Recomendação: SIM** (depende do Bloco B existir primeiro).

### BLOCO E — CONFIRM DE INTEGRIDADE (read-only; por cliente)
7. Rodar `sync_vanguard_docs.ps1 -modo verificar` (gera `SYNC_REPORT_AAAAMMDD.md`) para registrar GREEN oficial pós-reconciliação.
   - **Recomendação: SIM.** É a prova de fechamento de F5. Read-only (só escreve o relatório). O relatório vai p/ `_ARQUIVO/SYNC_REPORTS/` na F6.

---

## 2. O QUE *NÃO* SE TOCA (firewall desta fase)
- **Conteúdo de loop de qualquer cliente** (09–16, 18–23): é PROJECT_ONLY, território do loop, nunca do sync universal. Intocável.
- **VANGUARD / VALDECE / INGRID FONTES** — já completos e sincronizados. F5 não os toca.
- `CLIENTES/WIP_BOARD.md` (input vivo do `notion_sync.ps1`) · `WIP_BOARD.json` (canônico R-01).
- Os 4 `.bak` que **já estão** em `_ARQUIVO/BAK/` (CLAUDE/GEMINI/LEDGER/PENDENTES) — já consolidados.
- `Doc Vanguard Evolução Diretor/` (C5) · `.git/ .claude/ .agents/`.
- **Nenhum conteúdo é editado** — F5 é relocação de `.bak` + sync aditivo (só ADICIONA docs base ausentes, nunca sobrescreve).

---

## 3. FORA DE ESCOPO — "ADAPTAÇÃO CONTEXTUAL PROFUNDA" NÃO É F5 (recomendação honesta)

A visão "vault context-adapted-per-client" tem uma leitura ambiciosa: cada FONTES refletir o **nicho**
específico do cliente (injetar perfis de nicho, podar docs irrelevantes para a fase). **Recomendo NÃO fazer isso aqui:**
- Isso é **trabalho de conteúdo**, conduzido pelo loop de cada cliente (Gemini→NotebookLM→Embaixador), não por uma fase de limpeza estrutural.
- O mecanismo já existe: `sync -incluirNichos` + `PERFIS_NICHO/` cobrem injeção de nicho sob demanda, por loop.
- Forçar adaptação de conteúdo dentro do Vault Soberano arrisca pisar em decisões de loop e na fronteira P-059.

→ **F5 entrega sync ÍNTEGRO + base completa + auto-documentação.** A adaptação de conteúdo por nicho fica
com os loops de cliente (onde já vive) e/ou reabre na F7 se o Detector de Deriva exigir um schema por cliente.

---

## 4. SEQUÊNCIA DE EXECUÇÃO PÓS-VEREDITO
1. Bloco A: `git mv` dos 3 `.bak` → `_ARQUIVO/BAK/`.
2. Bloco B/C/D: ações isoladas por cliente conforme veredito (sync `-cliente X` nunca toca outro cliente).
3. Bloco E: `sync -modo verificar` → confirmar GREEN.
4. Commit `refactor(vault): F5 sync+contexto por cliente [veredito ...]` (sem [RESOLVE:] — guarda-chuva #11 fecha na F7).
   - Bloco A não tem nome canônico R-01 → passa limpo. Sync de FONTES não gera código → R-05 N/A.
5. Próximo: **F6** (mirror Drive — `gdrive:vanguard`, só no Gate 10, LOCAL-FIRST preservado).

---

**Gate BLOQUEANTE:** nenhuma linha da Seção 1 executa sem o seu SIM.

---

## 5. RESULTADO DA EXECUÇÃO (2026-06-17) — CORREÇÃO DE ROTA

O veredito aprovou A-E. Na execução, o contato com o disco derrubou a premissa de 3 blocos. Registro honesto:

### ✅ EXECUTADO
- **Bloco A** — 3 `.bak` strays movidos para `_ARQUIVO/BAK/` via `git mv` (`20_LOOP_STATE_SCHEMA.md.bak`,
  `DEPENDENCY_MAP.json.bak`, `CLIENTES/WIP_BOARD.json.bak`). `WIP_BOARD.md` preservado (input vivo do `notion_sync.ps1`).
- **Bloco E** — verify por hash dos 3 clientes EM USO: **VANGUARD / VALDECE / INGRID = GREEN** (todo doc base
  presente e byte-idêntico ao universal). Relatório oficial em `_ARQUIVO/SYNC_REPORTS/SYNC_REPORT_20260617.md`.
  → A regra do Diretor "as pastas que utilizamos devem estar sempre atualizadas" está **satisfeita**.

### ⛔ PULADO (premissa derrubada pelo disco — recomendação corrigida do Músculo)
- **Bloco B (completar base MUMUZINHO):** o `sync -cliente MUMUZINHO -modo completo` adicionou **0 arquivos** —
  por design ele só espelha o subconjunto *curado* existente, nunca empurra docs base novos. A ausência de 5 docs
  **é curadoria, não lacuna de sync.** Mumuzinho está discovery-STANDBY, gated no canal Dudu Félix até 04-07-2026.
  Forçar a base sobrescreveria a curadoria de um cliente parado. A base se completa no Passo 0 da reativação.
- **Bloco C (STANDBY → _TEMPLATE, 5-a):** `CLIENTES/STANDBY/` **NÃO é template** — é o estacionamento de
  projetos parados (Valdece/Ingrid/Mumuzinho), criado em 09-06-2026, com protocolo "COMO REATIVAR" e referência
  em `PENDENTES.md:381`. Rec 5-a foi inferência errada. **Folder preservado intacto (vira 5-c).**
- **Bloco D (manifesto MUMUZINHO):** depende de B; gerar manifesto em cliente parado é churn sem valor. Adiado p/ reativação.

### LIÇÃO PARA O LEDGER
"Lacuna de docs base num cliente ≠ falha de sync." Subconjuntos curados são intencionais; clientes em STANDBY
não devem ter a base forçada. Verificar STATUS do cliente (board/PENDENTES_STANDBY) antes de propor "completar".

**F5 entregue = Bloco A (higiene) + Bloco E (GREEN dos ativos).** Guarda-chuva #11 segue aberto até F7.
