-- ============================================================
-- TOGA DIGITAL — SCHEMA COMPLETO VALDECE
-- Rodar UMA VEZ no SQL Editor do Supabase do Valdece
-- Ordem: Dia 1 (base) → Dia 3 (campos tema) → ROI Config
-- ============================================================

-- ============================================================
-- BLOCO 1 — EXTENSÃO + CONFIG + CORPUS + LOGS
-- ============================================================

create extension if not exists vector;

create table if not exists config (
  key        text primary key,
  value      text not null,
  updated_at timestamptz default now()
);

insert into config (key, value) values
  ('search_enabled',        'true'),
  ('daily_token_limit_usd', '10'),
  ('sintese_enabled',       'false'),
  ('sentinel_enabled',      'false')
on conflict (key) do nothing;

create table if not exists documents (
  id               bigserial primary key,
  tribunal         text not null check (tribunal in ('STF','STJ')),
  numero_acordao   text,
  ementa           text not null,
  content          text not null,
  area             text default 'penal',
  tema             text default 'outros',
  relator          text,
  data_julgamento  date,
  link             text,
  embedding        vector(768),
  created_at       timestamptz default now()
);

create index if not exists documents_embedding_idx
  on documents using hnsw (embedding vector_cosine_ops)
  with (m = 16, ef_construction = 64);

create index if not exists documents_tema_idx on documents (tema);

create table if not exists search_logs (
  id              bigserial primary key,
  user_id         uuid references auth.users(id) on delete set null,
  query           text not null,
  results_count   int default 0,
  clicked_doc_id  bigint references documents(id) on delete set null,
  marked_relevant boolean default false,
  corpus_gap      float default null,
  session_id      text,
  created_at      timestamptz default now()
);

create table if not exists token_usage (
  id          bigserial primary key,
  date        date default current_date,
  operation   text not null,
  tokens_used int not null,
  cost_usd    numeric(10,6) not null,
  created_at  timestamptz default now()
);

create or replace view daily_cost as
  select
    date,
    sum(tokens_used) as total_tokens,
    sum(cost_usd)    as total_cost_usd
  from token_usage
  group by date;

-- ============================================================
-- BLOCO 2 — FUNÇÃO DE BUSCA SEMÂNTICA
-- ============================================================

create or replace function search_documents(
  query_embedding      vector(768),
  match_count          int     default 10,
  similarity_threshold float   default 0.65
)
returns table (
  id              bigint,
  tribunal        text,
  numero_acordao  text,
  ementa          text,
  content         text,
  link            text,
  data_julgamento date,
  similarity      float
)
language sql stable
as $$
  select
    id, tribunal, numero_acordao, ementa, content, link, data_julgamento,
    1 - (embedding <=> query_embedding) as similarity
  from documents
  where
    embedding is not null
    and 1 - (embedding <=> query_embedding) > similarity_threshold
  order by embedding <=> query_embedding
  limit match_count;
$$;

-- ============================================================
-- BLOCO 3 — RLS (Row Level Security)
-- ============================================================

alter table documents   enable row level security;
alter table search_logs enable row level security;
alter table token_usage enable row level security;
alter table config      enable row level security;

create policy "auth_read_documents"
  on documents for select to authenticated using (true);

create policy "auth_own_search_logs"
  on search_logs for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "anon_read_config"
  on config for select to anon, authenticated using (true);

create policy "service_token_usage"
  on token_usage for all to service_role using (true);

-- ============================================================
-- BLOCO 4 — ROI CONFIG + TELEMETRIA
-- ============================================================

create table if not exists vg_telemetry (
  id          uuid default gen_random_uuid() primary key,
  project_id  text not null,
  event_type  text not null,
  duration_ms integer,
  metadata    jsonb,
  created_at  timestamptz default now()
);

create table if not exists vg_roi_config (
  project_id                text primary key,
  valor_hora_cliente        numeric not null,
  minutos_por_acao_manual   numeric not null,
  acoes_por_mes_estimadas   integer,
  data_go_live              date not null,
  benchmark_antes           jsonb
);

insert into vg_roi_config (
  project_id, valor_hora_cliente, minutos_por_acao_manual,
  acoes_por_mes_estimadas, data_go_live, benchmark_antes
) values (
  'valdece_001', 200, 120, 10, '2026-05-19',
  '{
    "ferramenta_antes": "STF portal + SCON/STJ + Dizer o Direito",
    "problema_antes": "busca por palavra-chave — retorna pela palavra, não pelo conceito",
    "tempo_por_busca_antes_minutos": 120,
    "custo_mensal_ineficiencia_reais": 4000,
    "payback_meses": 1.25,
    "roi_ano_1_percentual": 860
  }'::jsonb
)
on conflict (project_id) do update set
  data_go_live  = excluded.data_go_live,
  benchmark_antes = excluded.benchmark_antes;

create or replace view vg_roi_mensal as
select
  t.project_id,
  count(*)                                                          as total_buscas,
  round(count(*) * r.minutos_por_acao_manual / 60.0, 1)           as horas_economizadas,
  round(count(*) * r.minutos_por_acao_manual / 60.0
        * r.valor_hora_cliente, 2)                                 as valor_economizado_reais,
  date_trunc('month', now())::date                                 as mes_referencia
from vg_telemetry t
join vg_roi_config r on r.project_id = t.project_id
where t.event_type = 'search'
  and t.created_at >= date_trunc('month', now())
group by t.project_id, r.minutos_por_acao_manual, r.valor_hora_cliente;

-- ============================================================
-- VERIFICAÇÃO FINAL — rodar após o script para confirmar
-- ============================================================
-- select table_name from information_schema.tables
--   where table_schema = 'public'
--   order by table_name;
-- select * from vg_roi_config where project_id = 'valdece_001';
-- ============================================================
