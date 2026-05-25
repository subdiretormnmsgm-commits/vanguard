-- ============================================================
-- VIEW_DIRETOR_ROI — Toga Digital Valdece — V3
-- [G-5] Telemetria agregada para Sentinel Report
-- Executar no Supabase SQL Editor após v3_migration.sql
-- ============================================================

-- PASSO 1: Garantir tabela de telemetria (idempotente)
CREATE TABLE IF NOT EXISTS vg_telemetry (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  project_id  TEXT NOT NULL,
  event_type  TEXT NOT NULL,
  duration_ms INTEGER,
  metadata    JSONB,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- PASSO 2: Garantir configuração ROI (idempotente)
CREATE TABLE IF NOT EXISTS vg_roi_config (
  project_id                TEXT PRIMARY KEY,
  valor_hora_cliente        NUMERIC NOT NULL,
  minutos_por_acao_manual   NUMERIC NOT NULL,
  acoes_por_mes_estimadas   INTEGER,
  data_go_live              DATE NOT NULL,
  benchmark_antes           JSONB
);

INSERT INTO vg_roi_config (
  project_id, valor_hora_cliente, minutos_por_acao_manual,
  acoes_por_mes_estimadas, data_go_live, benchmark_antes
) VALUES (
  'valdece_001', 200, 120, 10, '2026-05-17',
  '{
    "ferramenta_antes": "STF portal + SCON/STJ + Dizer o Direito",
    "tempo_por_busca_antes_minutos": 120,
    "custo_mensal_ineficiencia_reais": 4000,
    "payback_meses": 1.25,
    "roi_ano_1_percentual": 860
  }'::jsonb
)
ON CONFLICT (project_id) DO NOTHING;

-- PASSO 3: view_diretor_roi — painel unificado para o Sentinel Report
CREATE OR REPLACE VIEW view_diretor_roi AS
WITH corpus AS (
  SELECT
    COUNT(*)                                                     AS total_acordaos,
    SUM(CASE WHEN repercussao_geral THEN 1 ELSE 0 END)         AS vinculantes,
    SUM(CASE WHEN recurso_repetitivo THEN 1 ELSE 0 END)        AS repetitivos,
    SUM(CASE WHEN turma = 'Pleno' THEN 1 ELSE 0 END)           AS pleno,
    SUM(CASE WHEN turma = 'Turma' THEN 1 ELSE 0 END)           AS turma,
    SUM(CASE WHEN tribunal = 'STF' THEN 1 ELSE 0 END)          AS stf,
    SUM(CASE WHEN tribunal = 'STJ' THEN 1 ELSE 0 END)          AS stj
  FROM documents
),
atividade AS (
  SELECT
    COUNT(*)                                                     AS total_buscas,
    COALESCE(ROUND(AVG(duration_ms)::numeric, 0), 0)           AS latencia_media_ms,
    COUNT(DISTINCT date_trunc('day', created_at))              AS dias_ativos
  FROM vg_telemetry
  WHERE project_id = 'valdece_001'
    AND event_type = 'search'
),
roi AS (
  SELECT
    a.total_buscas,
    ROUND(a.total_buscas * r.minutos_por_acao_manual / 60.0, 1)       AS horas_economizadas,
    ROUND(a.total_buscas * r.minutos_por_acao_manual / 60.0
          * r.valor_hora_cliente, 2)                                   AS valor_economizado_reais,
    r.data_go_live,
    (CURRENT_DATE - r.data_go_live)                                    AS dias_em_uso
  FROM atividade a
  CROSS JOIN vg_roi_config r
  WHERE r.project_id = 'valdece_001'
)
SELECT
  -- Corpus
  c.total_acordaos,
  c.vinculantes,
  c.repetitivos,
  c.pleno,
  c.turma,
  c.stf,
  c.stj,
  -- Atividade
  a.total_buscas,
  a.latencia_media_ms,
  a.dias_ativos,
  -- ROI
  r.horas_economizadas,
  r.valor_economizado_reais,
  r.data_go_live,
  r.dias_em_uso,
  -- Timestamp
  NOW() AS gerado_em
FROM corpus c
CROSS JOIN atividade a
CROSS JOIN roi r;

-- VERIFICAÇÃO — rodar após criar a view:
-- SELECT * FROM view_diretor_roi;
-- Esperado dia 0: total_acordaos=61, vinculantes=3, total_buscas=0
-- Após uso real: horas_economizadas e valor_economizado_reais crescem automaticamente
