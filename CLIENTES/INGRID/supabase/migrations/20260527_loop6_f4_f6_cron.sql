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
-- ─────────────────────────────────────────────────────────────
SELECT cron.schedule(
  'gatilho_temporal_ingrid',
  '45 22 * * *',
  $$
  SELECT net.http_post(
    url     := 'https://yjqvjhezwhepwomukudt.supabase.co/functions/v1/gatilho-temporal',
    headers := jsonb_build_object(
      'Content-Type',  'application/json',
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlqcXZqaGV6d2hlcHdvbXVrdWR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3NjExNzksImV4cCI6MjA5NTMzNzE3OX0.Mb6KxtJ3iECl_3ApWUl6zozxa93pJatLwNOZ7zAdhx4'
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
    url     := 'https://yjqvjhezwhepwomukudt.supabase.co/functions/v1/relatorio-semanal',
    headers := jsonb_build_object(
      'Content-Type',  'application/json',
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlqcXZqaGV6d2hlcHdvbXVrdWR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3NjExNzksImV4cCI6MjA5NTMzNzE3OX0.Mb6KxtJ3iECl_3ApWUl6zozxa93pJatLwNOZ7zAdhx4'
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
