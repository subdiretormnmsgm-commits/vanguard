-- ============================================================
-- TOGA DIGITAL VALDECE — SCHEMA COMPLETO V3
-- Rodar UMA VEZ no SQL Editor do Supabase NOVO (conta Valdece)
-- ANTES de executar migrate_to_valdece.py
-- Região recomendada: South America (São Paulo) sa-east-1
-- ============================================================

-- BLOCO 1 — Extensão pgvector (obrigatória)
create extension if not exists vector;

-- BLOCO 2 — Configuração (kill switch + limites)
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

-- BLOCO 3 — Corpus principal (vector 3072 — Gemini Embedding 001)
create table if not exists documents (
  id                 bigserial primary key,
  tribunal           text not null check (tribunal in ('STF','STJ')),
  numero_acordao     text,
  ementa             text not null,
  content            text not null,
  area               text default 'penal',
  tema               text default 'outros',
  relator            text,
  data_julgamento    date,
  data_dje           date,
  link               text,
  repercussao_geral  boolean not null default false,
  recurso_repetitivo boolean not null default false,
  turma              text,
  embedding          vector(3072),
  created_at         timestamptz default now()
);

-- Índice HNSW para busca semântica
create index if not exists documents_embedding_idx
  on documents using hnsw (embedding vector_cosine_ops)
  with (m = 16, ef_construction = 64);

create index if not exists documents_tema_idx on documents (tema);
create index if not exists documents_repercussao_idx on documents (repercussao_geral) where repercussao_geral = true;
create index if not exists documents_repetitivo_idx  on documents (recurso_repetitivo) where recurso_repetitivo = true;

-- BLOCO 4 — Logs de busca + feedback
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

-- BLOCO 5 — Uso de tokens / custo
create table if not exists token_usage (
  id          bigserial primary key,
  date        date default current_date,
  operation   text not null,
  tokens_used int not null,
  cost_usd    numeric(10,6) not null,
  created_at  timestamptz default now()
);

create or replace view daily_cost as
  select date, sum(tokens_used) as total_tokens, sum(cost_usd) as total_cost_usd
  from token_usage
  group by date;

-- BLOCO 6 — Função de busca semântica V3
create or replace function search_documents(
  query_embedding      vector(3072),
  match_count          int     default 10,
  similarity_threshold float   default 0.65
)
returns table (
  id                  bigint,
  tribunal            text,
  numero_acordao      text,
  ementa              text,
  content             text,
  link                text,
  data_julgamento     date,
  data_dje            date,
  repercussao_geral   boolean,
  recurso_repetitivo  boolean,
  turma               text,
  similarity          float
)
language sql stable
as $$
  select
    id, tribunal, numero_acordao, ementa, content, link,
    data_julgamento, data_dje, repercussao_geral, recurso_repetitivo, turma,
    1 - (embedding <=> query_embedding) as similarity
  from documents
  where
    embedding is not null
    and 1 - (embedding <=> query_embedding) > similarity_threshold
  order by embedding <=> query_embedding
  limit match_count;
$$;

-- BLOCO 7 — RLS (Row Level Security)
alter table documents   enable row level security;
alter table search_logs enable row level security;
alter table token_usage enable row level security;
alter table config      enable row level security;

create policy "anon_read_documents"
  on documents for select to anon, authenticated using (true);

create policy "anon_insert_search_logs"
  on search_logs for insert to anon, authenticated
  with check (true);

create policy "anon_update_search_logs"
  on search_logs for update to anon, authenticated
  using (true) with check (true);

create policy "anon_read_config"
  on config for select to anon, authenticated using (true);

create policy "service_token_usage"
  on token_usage for all to service_role using (true);

-- BLOCO 8 — ROI + Telemetria
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
  'valdece_001', 200, 120, 10, '2026-05-17',
  '{
    "ferramenta_antes": "STF portal + SCON/STJ + Dizer o Direito + Legislação Integrada",
    "problema_antes": "busca por palavra-chave — retorna pela palavra, nao pelo conceito juridico",
    "tempo_por_busca_antes_minutos": 120,
    "custo_mensal_ineficiencia_reais": 4000,
    "payback_meses": 1.25,
    "roi_ano_1_percentual": 860
  }'::jsonb
)
on conflict (project_id) do nothing;

-- BLOCO 9 — View do ROI (Sentinel Report)
create or replace view view_diretor_roi as
with corpus as (
  select
    count(*)                                               as total_acordaos,
    sum(case when repercussao_geral  then 1 else 0 end)   as vinculantes,
    sum(case when recurso_repetitivo then 1 else 0 end)   as repetitivos,
    sum(case when turma = 'Pleno'    then 1 else 0 end)   as pleno,
    sum(case when turma = 'Turma'    then 1 else 0 end)   as turma,
    sum(case when tribunal = 'STF'   then 1 else 0 end)   as stf,
    sum(case when tribunal = 'STJ'   then 1 else 0 end)   as stj
  from documents
),
atividade as (
  select
    count(*)                                               as total_buscas,
    coalesce(round(avg(duration_ms)::numeric, 0), 0)      as latencia_media_ms,
    count(distinct date_trunc('day', created_at))          as dias_ativos
  from vg_telemetry
  where project_id = 'valdece_001' and event_type = 'search'
),
roi as (
  select
    a.total_buscas,
    round(a.total_buscas * r.minutos_por_acao_manual / 60.0, 1)            as horas_economizadas,
    round(a.total_buscas * r.minutos_por_acao_manual / 60.0
          * r.valor_hora_cliente, 2)                                        as valor_economizado_reais,
    r.data_go_live,
    (current_date - r.data_go_live)                                         as dias_em_uso
  from atividade a cross join vg_roi_config r
  where r.project_id = 'valdece_001'
)
select
  c.total_acordaos, c.vinculantes, c.repetitivos, c.pleno, c.turma, c.stf, c.stj,
  a.total_buscas, a.latencia_media_ms, a.dias_ativos,
  r.horas_economizadas, r.valor_economizado_reais, r.data_go_live, r.dias_em_uso,
  now() as gerado_em
from corpus c cross join atividade a cross join roi r;

-- ============================================================
-- VERIFICAÇÃO — rodar após o schema para confirmar
-- ============================================================
-- select table_name from information_schema.tables where table_schema = 'public' order by 1;
-- select column_name, data_type from information_schema.columns where table_name = 'documents' order by ordinal_position;
-- select * from vg_roi_config where project_id = 'valdece_001';
-- Esperado: documents com vector(3072), todos campos V3 presentes
-- ============================================================
