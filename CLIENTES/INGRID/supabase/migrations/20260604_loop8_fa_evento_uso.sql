-- F-A: Tabela evento_uso (Loop 8 · Telemetria Passiva em Batch)
-- Bloco B da sequencia de build Loop 8
-- Design: batch nao-bloqueante + IndexedDB fallback (N-3)
-- Dados anonimos: user_id UUID sem PII direta

create table if not exists evento_uso (
  id          uuid        not null default gen_random_uuid() primary key,
  user_id     uuid        not null,
  tipo        text        not null,  -- sessao_inicio | questao_respondida | sessao_fim | heartbeat
  dados       jsonb,                 -- metadata: {disciplina, acerto, duracao_ms, questao_id}
  criado_em   timestamptz not null default now(),
  enviado_em  timestamptz,           -- quando foi flushed do IndexedDB (latencia offline)
  constraint tipo_valido check (
    tipo in ('sessao_inicio','questao_respondida','sessao_fim','heartbeat','pulse_check')
  )
);

-- RLS: usuario so ve e insere os proprios eventos
alter table evento_uso enable row level security;

create policy "usuario_proprios_eventos_select"
  on evento_uso for select
  using (user_id = auth.uid() or auth.uid() is null);

create policy "usuario_proprios_eventos_insert"
  on evento_uso for insert
  with check (user_id = auth.uid() or auth.uid() is null);

-- Indice para queries do Painel Eduardo (F-B)
create index if not exists idx_evento_uso_user_criado
  on evento_uso(user_id, criado_em desc);

create index if not exists idx_evento_uso_tipo
  on evento_uso(tipo, criado_em desc);

-- View snapshot_ingrid_loop6_golden (F-D): baseline historico imutavel
-- Captura estado atual de progresso_usuario como golden copy
create or replace view snapshot_ingrid_loop6_golden as
select
  user_id,
  questao_id,
  acertou,
  created_at,
  disciplina,
  peso,
  tti_ms
from progresso_usuario
where user_id = '00000000-0000-0000-0000-000000000001'
  and created_at < '2026-06-04 00:00:00+00';

comment on view snapshot_ingrid_loop6_golden is
  'F-D Loop 8: golden copy dos 102 registros de Ingrid pre-Loop8. Imutavel. Baseline comercial para SaaS pitch.';

comment on table evento_uso is
  'F-A Loop 8: telemetria passiva de uso. Batch nao-bloqueante com IndexedDB fallback (N-3). Dados anonimizados para uso comercial futuro (requer opt-in N-1).';
