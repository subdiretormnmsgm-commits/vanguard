# OFFBOARDING RUNBOOK — INGRID
## Soberania Total — P-013 | Dia 15 (29-05-2026 sexta-feira)

---

> **Objetivo:** Ingrid passa a ter o próprio banco de dados Supabase, com controle total sobre os dados.
> **Tempo total estimado:** ~45 minutos (Eduardo + Ingrid juntos ou por ligação)
> **Quem faz o quê:** Ingrid cria a conta (5 min) · Eduardo faz o resto (40 min)

---

## PASSO 1 — INGRID: Criar conta Supabase (5 min)

**Eduardo envia esta mensagem para Ingrid:**
> "Ingrid, para a última etapa precisamos criar um espaço de banco de dados SÓ SEU.
> Você vai ter controle total dos seus dados de estudo.
> São 3 cliques:
> 1. Acesse supabase.com
> 2. Clique em 'Start your project' (gratuito)
> 3. Entre com o Google ou crie uma conta com seu e-mail"

Após Ingrid criar a conta:
- Ingrid cria um **New Project** com nome: `sedes-ingrid-2026`
- Região: **South America (São Paulo)** — essencial para latência
- Password: Ingrid define uma senha forte e anota
- Free tier é suficiente para o volume atual

**Ingrid envia para Eduardo:**
- URL do projeto: `https://[referencia].supabase.co`
- Anon Key (em: Project Settings → API → Project API Keys → `anon public`)

---

## PASSO 2 — EDUARDO: Criar estrutura no projeto dela (10 min)

1. Fazer login no Supabase com as credenciais de Ingrid (ou pedir que ela compartilhe a tela)
2. Ir em: **SQL Editor** (ícone de banco de dados na barra lateral)
3. Clicar em **New query**
4. Abrir o arquivo: `CLIENTES/INGRID/sql/migrate_ingrid_supabase_v1.sql`
5. Copiar TODO o conteúdo e colar no SQL Editor
6. Clicar em **RUN**

✅ Verificação: o resultado deve mostrar:
```
tabelas_criadas | funcoes_criadas | linhas_cache
     9+         |      8+         |     13
```

---

## PASSO 3 — EDUARDO: Migrar as questões (10 min)

As 460+ questões estão no projeto Vanguard. Exportar e importar:

### Opção A — Via Supabase Dashboard (mais fácil)
1. No projeto **Vanguard** (ehyaecxqijgyuuiorzcj):
   - Ir em Table Editor → questoes_quadrix
   - Clicar no botão de exportação (⬇) → Export to CSV
2. No projeto da **Ingrid**:
   - Table Editor → questoes_quadrix → Import data → Upload CSV

### Opção B — Via SQL (mais confiável para dados grandes)
No projeto **Vanguard**, executar no SQL Editor:
```sql
-- Gera INSERT statements para exportação
SELECT 'INSERT INTO questoes_quadrix VALUES (' ||
  quote_literal(id::text) || ',' ||
  quote_literal(concurso_id) || ',' ||
  quote_literal(disciplina_id) || ',' ||
  peso_edital || ',' || COALESCE(score_prioridade::text, 'NULL') || ',' ||
  quote_literal(enunciado) || ',' ||
  quote_literal(alternativas::text) || '::jsonb,' ||
  quote_literal(gabarito) || ',' ||
  quote_literal(explicacao) || ',' ||
  COALESCE(quote_literal(distrator_principal), 'NULL') || ',' ||
  COALESCE(nivel_dificuldade::text, 'NULL') || ',NULL,' ||
  COALESCE(quote_literal(tipo_pegadinha), 'NULL') || ',' ||
  vacina_legislacao || ',' ||
  quote_literal(criada_em::text) || ',' ||
  quote_literal(criada_por) || ') ON CONFLICT DO NOTHING;'
FROM questoes_quadrix
ORDER BY criada_em;
```
Executar o resultado no projeto da Ingrid.

### Migrar progresso da Ingrid (histórico de respostas)
Igualmente no projeto Vanguard, exportar `progresso_usuario` e importar na Ingrid.

---

## PASSO 4 — EDUARDO: Implantar as Edge Functions (15 min)

As 3 funções precisam ser deployadas no projeto da Ingrid via Supabase CLI.

### Pré-requisito: Supabase CLI
```powershell
# Verificar se está instalado
supabase --version
# Se não: winget install Supabase.CLI
```

### Deploy das funções
```powershell
cd "CLIENTES\INGRID\supabase"

# Fazer link com o projeto da Ingrid
supabase link --project-ref [REF_PROJETO_INGRID]

# Fazer deploy das funções
supabase functions deploy tutor-socratico
supabase functions deploy notificar-progresso

# A função feed-diario está no Supabase remoto mas não localmente
# Exportar do projeto Vanguard primeiro:
supabase functions download feed-diario --project-ref ehyaecxqijgyuuiorzcj
# Depois fazer deploy no projeto da Ingrid
supabase functions deploy feed-diario
```

### Variáveis de ambiente das Edge Functions
No Dashboard da Ingrid → **Edge Functions → Manage secrets**:
- `ANTHROPIC_API_KEY` = [chave da API Claude]
- `SUPABASE_SERVICE_ROLE_KEY` = [service role key do projeto da Ingrid]

---

## PASSO 5 — MÚSCULO: Atualizar app.js com novas credenciais (5 min)

O Músculo atualiza as linhas 16-17 do `CLIENTES/INGRID/frontend/app.js`:
```javascript
// ANTES (projeto Vanguard)
const SUPABASE_URL      = "https://ehyaecxqijgyuuiorzcj.supabase.co";
const SUPABASE_ANON_KEY = "[REDACTED]";

// DEPOIS (projeto da Ingrid)
const SUPABASE_URL      = "https://[REF_INGRID].supabase.co";
const SUPABASE_ANON_KEY = "[REDACTED]";
```

Depois, bump de versão e deploy:
```powershell
# Bumpar para v18 em index.html
# Commitar
git add CLIENTES/INGRID/frontend/
git commit -m "feat(ingrid): P-013 soberania — Supabase proprio da Ingrid"

# Eduardo testa PRIMEIRO antes do deploy
# Após aprovação:
.\scripts\deploy_ingrid_ghpages.ps1
```

---

## PASSO 6 — GATE: Verificação final (5 min)

✅ Checklist antes de declarar P-013 APROVADO:
- [ ] Ingrid acessa `sedes-ingrid-2026` no Supabase dashboard
- [ ] Questões aparecem na Table Editor (460+ linhas)
- [ ] App carrega sem erros (Network tab)
- [ ] Responder 1 questão → progresso aparece no dashboard
- [ ] Heatmap funciona (precisa de ≥3 respostas)
- [ ] Nota Simulada calcula (precisa de ≥3 respostas em alguma disciplina)
- [ ] Última sessão aparece no Dashboard

---

## STATUS DO GATE

| Gate | Requisito | Status |
|------|-----------|--------|
| dia15 | Ingrid com acesso admin ao próprio Supabase | ✅ APROVADO — 2026-05-30 |

**Data aprovação:** 30-05-2026 sábado — confirmado pelo Diretor
**P-013 soberania:** app.js já aponta para projeto Ingrid (yjqvjhezwhepwomukudt) — v20 em produção

---

*Músculo — Pentalateral IAH — 29-05-2026*
