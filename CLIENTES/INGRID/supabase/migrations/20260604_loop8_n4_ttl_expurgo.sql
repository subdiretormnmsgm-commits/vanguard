-- N-4: TTL Expurgo Shadow Candidate (Loop 8)
-- Auditoria: P-097 gate coverage + isolamento de dados sinteticos
-- Remove dados de tenant de simulacao a cada 24h via pg_cron
-- user_id prefixado com 'test_' ou 'shadow_' = candidato simulado

-- Funcao de expurgo
create or replace function expurgar_shadow_candidates()
returns void
language plpgsql
security definer
as $$
begin
  -- Expurgar respostas de tenants de simulacao
  delete from progresso_usuario
  where user_id like 'test_%'
     or user_id like 'shadow_%'
     or user_id like 'demo_%';

  -- Expurgar eventos de telemetria de tenants de simulacao (Loop 8)
  delete from evento_uso
  where user_id like 'test_%'
     or user_id like 'shadow_%'
     or user_id like 'demo_%';

  -- Log de auditoria (nao falha se tabela nao existir ainda)
  insert into audit_log (evento, detalhes, criado_em)
  values (
    'expurgo_shadow_candidates',
    json_build_object('timestamp', now(), 'origem', 'pg_cron TTL N-4'),
    now()
  )
  on conflict do nothing;

exception
  when undefined_table then
    null; -- audit_log pode nao existir ainda -- silencioso
end;
$$;

-- Agendar via pg_cron: rodar todo dia a 03:00 UTC
-- Requer extensao pg_cron (ja ativa no projeto Ingrid desde Loop 7)
select cron.schedule(
  'expurgo-shadow-candidates',   -- nome do job
  '0 3 * * *',                   -- todo dia 03:00 UTC
  'select expurgar_shadow_candidates()'
);

comment on function expurgar_shadow_candidates() is
  'N-4 Loop 8: expurga dados sinteticos de tenants de simulacao (test_/shadow_/demo_) para evitar contaminacao de metricas reais. P-097.';
