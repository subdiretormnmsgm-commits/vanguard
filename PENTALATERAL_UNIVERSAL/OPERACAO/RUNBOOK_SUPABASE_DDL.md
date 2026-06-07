# RUNBOOK — Supabase DDL e Configuração
**Fonte canônica · Todos os projetos · Atualizado: 2026-06-07**

---

## PROJETOS ATIVOS

| Projeto | URL | Ref ID |
|---------|-----|--------|
| Vanguard (sistema interno) | `https://ehyaecxqijgyuuiorzcj.supabase.co` | `ehyaecxqijgyuuiorzcj` |
| Ingrid | projeto separado | ver `CLIENTES/INGRID/.env` |
| Valdece | projeto separado | ver `CLIENTES/VALDECE/.env` |

**Credenciais Vanguard:** em `.env` na raiz do repo (gitignored):
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY` — chave pública (role anon, com RLS)
- **Service role key NÃO está salva** — buscar em supabase.com/dashboard → Settings → API

---

## CRIAR TABELA VIA DASHBOARD (quando sem service role key)

1. Abrir: `https://supabase.com/dashboard/project/ehyaecxqijgyuuiorzcj/sql`
2. Colar o SQL e executar
3. Resposta esperada: `Success. No rows returned` = sucesso

**Músculo gera o arquivo SQL em `infra/schema_*.sql` antes de pedir ao Diretor.**

---

## CRIAR TABELA VIA API (quando com service role key)

```bash
curl -X POST "https://ehyaecxqijgyuuiorzcj.supabase.co/rest/v1/rpc/exec_sql" \
  -H "apikey: [SERVICE_ROLE_KEY]" \
  -H "Authorization: Bearer [SERVICE_ROLE_KEY]" \
  -H "Content-Type: application/json" \
  -d '{"query": "CREATE TABLE ..."}'
```

**IMPORTANTE:** A anon key NÃO tem permissão de DDL (CREATE TABLE, ALTER, DROP).
Somente a service role key pode executar DDL via API.

---

## PADRÃO RLS OBRIGATÓRIO (toda tabela nova)

```sql
ALTER TABLE nome_tabela ENABLE ROW LEVEL SECURITY;

-- Leitura pública (anon pode SELECT)
CREATE POLICY "anon_read" ON nome_tabela FOR SELECT TO anon USING (true);

-- Escrita pública (anon pode INSERT — apenas quando necessário)
CREATE POLICY "anon_insert" ON nome_tabela FOR INSERT TO anon WITH CHECK (true);

-- Sem policy = tabela inacessível para anon mesmo com RLS ativo
```

---

## ANON KEY × SERVICE ROLE KEY

| Propriedade | Anon Key | Service Role Key |
|-------------|----------|-----------------|
| Segura para expor? | Sim (pública por design) | NÃO — nunca committar |
| Pode DDL? | Não | Sim |
| Respeita RLS? | Sim | Bypassa RLS |
| Onde usar? | Frontend, n8n, scripts locais | Só backend seguro |
| Rotação necessária? | Apenas se RLS incorreto | Se exposta = rotacionar imediatamente |

---

## TABELAS CRIADAS (log)

| Tabela | Projeto | Data | SQL |
|--------|---------|------|-----|
| `silenced_signals_log` | Vanguard | 2026-06-07 | `infra/schema_w8_silenced_signals.sql` |
| Ver histórico completo | — | — | `infra/schema_*.sql` |

---

## ERROS CONHECIDOS

| Erro | Causa | Solução |
|------|-------|---------|
| `42501 insufficient_privilege` | Anon key tentando DDL | Usar service role key ou SQL editor |
| `PGRST116 no rows` | RLS bloqueando SELECT sem policy | Criar policy SELECT para anon |
| `23505 duplicate key` | INSERT duplicado com PK | Usar `ON CONFLICT DO NOTHING` |
| `42P07 relation already exists` | CREATE TABLE sem IF NOT EXISTS | Adicionar `IF NOT EXISTS` |
