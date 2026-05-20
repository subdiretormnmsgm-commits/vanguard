# PENDENTES — Vanguard IAH
> Atualizado pelo Músculo em tempo real durante qualquer sessão.
> O briefing matinal lê este arquivo — tudo aqui aparece às 7h.
> Regra P-047: qualquer tarefa identificada como pendente → registrar aqui IMEDIATAMENTE.
> Feito? Marcar [x]. Músculo remove os [x] ao fechar sessão.

---

## PROJ-001 · Valdece (Deadline: 23/05 Sab)

- [ ] `2026-05-20` **Dia 6 — V3 SEQUÊNCIA COMPLETA:**
  1. Criar `sql/v3_migration.sql` — ALTER TABLE ADD COLUMN (data_dje, repercussao_geral, recurso_repetitivo, turma)
  2. Atualizar `ingest.py` com `--mode reingest` — UPDATE 61 acórdãos existentes via Gemini Flash, SEM re-embedding
  3. Rodar `ingest.py --mode reingest --dry-run` — validar output (campos preenchidos sem tocar no banco)
  4. Rodar `ingest.py --mode reingest` — aplicar no Supabase Vanguard
  5. Atualizar `search_documents()` — retornar novos campos no response
  6. Frontend: badges VINCULANTE / REPETITIVO / REPERCUSSÃO nos cards de resultado
  7. Migração Supabase conta Valdece (sa-east-1) — ÚLTIMO após tudo testado

- [ ] `2026-05-20` **MEMORIA_EMBAIXADOR Valdece** — campo "Estado Contratual" ainda diz "PENDENTE" → corrigir para "ASSINADO — 2026-05-19"

- [ ] `2026-05-20` **Billing Gemini conta Valdece** — ativar antes da migração (quota free esgotou 2x — risco de outage)

---

## PROJ-002 · Ingrid (Deadline: 30/05 Sab)

- [ ] `2026-05-20` **Dias 12-13:**
  1. Contador de Pontos Ponderados (header ou dashboard)
  2. Notificações Push — domingo = Micro-Simulado Sedes-DF

- [ ] `2026-05-20` **Loop 4** — após Dias 12-13: ir ao Gemini com PASSO3 → DIRETRIZ V4 → NotebookLM → ingrid-v4.md → Músculo executa skill

---

## PROCESSO / INFRA

- [ ] `2026-05-20` **P-047 no INTELLIGENCE_LEDGER** — registrar: "Pendente identificado = atualizar PENDENTES.md imediatamente. Não esperar session_close."

---

## COMO USAR

**Adicionar pendente (Músculo):**
```
- [ ] `YYYY-MM-DD` **[PROJ/PROCESSO]** descrição exata da tarefa
```

**Marcar feito:**
```
- [x] `YYYY-MM-DD` ~~descrição~~
```

**Remover concluídos:** Músculo limpa os `[x]` ao rodar `session_close.ps1`.
