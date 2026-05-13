-- ============================================================
-- JURISPRUDÊNCIA SEMÂNTICA VALDECE — Schema Supabase
-- Dia 1 · Infraestrutura & 7 Leis Soberanas
-- ============================================================

-- Lei 1: pgvector habilitado
create extension if not exists vector;

-- ============================================================
-- KILL-SWITCH (Lei 6) — config table
-- ============================================================
create table if not exists config (
  key   text primary key,
  value text not null,
  updated_at timestamptz default now()
);

insert into config (key, value) values
  ('search_enabled',         'true'),
  ('daily_token_limit_usd',  '10'),
  ('sintese_enabled',        'false'),  -- Feature Flag: Ideia 1 (desabilitada no MVP)
  ('sentinel_enabled',       'false')   -- Feature Flag: Ideia 4 (desabilitada no MVP)
on conflict (key) do nothing;

-- ============================================================
-- CORPUS (Motor Semântico) — documents
-- Gemini embedding-004 = 768 dimensões
-- ============================================================
create table if not exists documents (
  id               bigserial primary key,
  tribunal         text not null check (tribunal in ('STF','STJ')),
  numero_acordao   text,
  ementa           text not null,
  content          text not null,
  area             text default 'penal',
  relator          text,
  data_julgamento  date,
  link             text,
  embedding        vector(768),
  created_at       timestamptz default now()
);

-- Índice HNSW para busca semântica rápida
create index if not exists documents_embedding_idx
  on documents using hnsw (embedding vector_cosine_ops)
  with (m = 16, ef_construction = 64);

-- ============================================================
-- SOVEREIGN PIXEL (Lei 1) — search_logs
-- ============================================================
create table if not exists search_logs (
  id              bigserial primary key,
  user_id         uuid references auth.users(id) on delete set null,
  query           text not null,
  results_count   int default 0,
  clicked_doc_id  bigint references documents(id) on delete set null,
  marked_relevant boolean default false,
  session_id      text,
  created_at      timestamptz default now()
);

-- ============================================================
-- BURN RATE SHIELD (Lei 5) — token_usage
-- ============================================================
create table if not exists token_usage (
  id           bigserial primary key,
  date         date default current_date,
  operation    text not null, -- 'embed_query' | 'embed_ingest' | 'synthesize'
  tokens_used  int not null,
  cost_usd     numeric(10,6) not null,
  created_at   timestamptz default now()
);

-- View diária de custo (usada pelo Shield)
create or replace view daily_cost as
  select
    date,
    sum(tokens_used) as total_tokens,
    sum(cost_usd)    as total_cost_usd
  from token_usage
  group by date;

-- ============================================================
-- FUNÇÃO DE BUSCA SEMÂNTICA
-- ============================================================
create or replace function search_documents(
  query_embedding   vector(768),
  match_count       int     default 10,
  similarity_threshold float default 0.65
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
    id,
    tribunal,
    numero_acordao,
    ementa,
    content,
    link,
    data_julgamento,
    1 - (embedding <=> query_embedding) as similarity
  from documents
  where
    embedding is not null
    and 1 - (embedding <=> query_embedding) > similarity_threshold
  order by embedding <=> query_embedding
  limit match_count;
$$;

-- ============================================================
-- RLS — Row Level Security (Lei 2: LGPD)
-- ============================================================
alter table documents   enable row level security;
alter table search_logs enable row level security;
alter table token_usage enable row level security;
alter table config      enable row level security;

-- Usuários autenticados lêem documentos
create policy "auth_read_documents"
  on documents for select to authenticated using (true);

-- Usuários lêem e escrevem seus próprios logs
create policy "auth_own_search_logs"
  on search_logs for all to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Config: apenas service_role escreve
create policy "anon_read_config"
  on config for select to anon, authenticated using (true);

-- Token usage: apenas service_role
create policy "service_token_usage"
  on token_usage for all to service_role using (true);
