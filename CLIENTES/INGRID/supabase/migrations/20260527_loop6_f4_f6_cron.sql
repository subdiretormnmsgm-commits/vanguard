-- ============================================================
-- PROJ-002 Ingrid — Migração Loop 6 F-4 + F-6
-- N-1: Gatilho Temporal 19h45 (cron pg_cron)
-- M-4+E-3: Relatório Semanal domingo (cron pg_cron)
-- Requer: pg_cron ativo + Edge Functions deployadas
-- ============================================================

-- ATENÇÃO: antes de rodar esta migração, fazer deploy das Edge Functions:
--   npx supabase functions deploy gatilho-temporal --project-ref yjqvjhezwhepwomukudt
--   npx supabase functions deploy relatorio-semanal --project-ref yjqvjhezwhepwomukudt
-- ============================================================


-- F-4: N-1 Gatilho Temporal — 19h45 BRT = 22h45 UTC (todo dia)
-- Chama a Edge Function via net.http_post (requer extensão http ou pg_net)
-- ─────────────────────────────────────────────────────────────
SELECT cron.schedule(
  'gatilho_temporal_ingrid',
  '45 22 * * *',
  $$
  SELECT net.http_post(
    url     := current_setting('app.supabase_url') || '/functions/v1/gatilho-temporal',
    headers := jsonb_build_object(
      'Content-Type',  'application/json',
      'Authorization', 'Bearer ' || current_setting('app.supabase_anon_key')
    ),
    body    := '{}'::jsonb
  )
  $$
);


-- F-6: M-4+E-3 Relatório Semanal — domingo 10h BRT = 13h UTC
-- ─────────────────────────────────────────────────────────────
SELECT cron.schedule(
  'relatorio_semanal_ingrid',
  '0 13 * * 0',
  $$
  SELECT net.http_post(
    url     := current_setting('app.supabase_url') || '/functions/v1/relatorio-semanal',
    headers := jsonb_build_object(
      'Content-Type',  'application/json',
      'Authorization', 'Bearer ' || current_setting('app.supabase_anon_key')
    ),
    body    := '{}'::jsonb
  )
  $$
);


-- ============================================================
-- GATE CLI — verificar após migração no SQL Editor do Supabase:
-- ============================================================
-- SELECT jobname, schedule, command
--   FROM cron.job
--   WHERE jobname IN ('gatilho_temporal_ingrid', 'relatorio_semanal_ingrid');
--
-- Resultado esperado:
--   gatilho_temporal_ingrid  | 45 22 * * *  | SELECT net.http_post(...)
--   relatorio_semanal_ingrid | 0 13 * * 0   | SELECT net.http_post(...)
-- ============================================================
