# KNOWLEDGE BASE — Vanguard Tech
**Índice de problemas reais e soluções validadas · Todos os projetos**
**Atualizado:** 2026-05-21

---

> **REGRA:** Ao resolver qualquer problema novo → documentar no RUNBOOK do assunto antes de fechar a sessão. Um problema não documentado vai se repetir.

---

## RUNBOOKS DISPONÍVEIS (fonte canônica por assunto)

| Assunto | Runbook | Problemas cobertos |
|---------|---------|-------------------|
| Busca semântica + pgvector + Supabase | [RUNBOOK_BUSCA_SEMANTICA_SUPABASE.md](../OPERACAO/RUNBOOK_BUSCA_SEMANTICA_SUPABASE.md) | dimension mismatch · outputDimensionality · reembed · cache PostgREST · HNSW limit |
| Testes remotos de frontend (Playwright) | [TESTES_REMOTOS.md](TESTES_REMOTOS.md) | golden path · interceptação de fetch · checklist por tipo de projeto |
| EasyPanel — deploy e API n8n | [RUNBOOK_EASYPANEL.md](../OPERACAO/RUNBOOK_EASYPANEL.md) | Docker Compose deploy · import workflow API · credencial Telegram · erros tRPC |
| Supabase DDL e RLS | [RUNBOOK_SUPABASE_DDL.md](../OPERACAO/RUNBOOK_SUPABASE_DDL.md) | anon vs service role · CREATE TABLE · RLS policies · erros comuns |

---

## COMO ADICIONAR UM RUNBOOK NOVO

1. Criar `PENTALATERAL_UNIVERSAL/OPERACAO/RUNBOOK_[ASSUNTO].md`
2. Seguir o template: [TEMPLATE_PROBLEMA_SOLUCAO.md](TEMPLATE_PROBLEMA_SOLUCAO.md)
3. Adicionar linha neste INDEX.md

---

## ASSUNTOS SEM RUNBOOK AINDA (a criar quando o primeiro caso ocorrer)

- Gemini API — billing, rate limit, chave exposta
- Netlify Deploy — CLI, CDN cache, variáveis de ambiente
- Supabase RLS — políticas anon/authenticated
- Claude Projects / Embaixador — sync de documentos

---

*P-050: teste ao vivo após cada passo. Knowledge Base: solução documentada antes de fechar a sessão.*
