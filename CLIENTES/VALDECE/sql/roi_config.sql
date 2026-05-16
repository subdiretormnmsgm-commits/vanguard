-- ROI CONFIG — PROJETO VALDECE
-- Fonte: BRIEFING_DISCOVERY.txt · 2026-05-12
-- Executar no Supabase do Dr. Valdece após o handoff do Dia 5

-- PASSO 1: Criar tabelas universais (se ainda não existirem)

CREATE TABLE IF NOT EXISTS vg_telemetry (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  project_id  TEXT NOT NULL,
  event_type  TEXT NOT NULL,   -- 'search', 'doc_access', 'session_start', 'session_end'
  duration_ms INTEGER,
  metadata    JSONB,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS vg_roi_config (
  project_id                TEXT PRIMARY KEY,
  valor_hora_cliente        NUMERIC NOT NULL,
  minutos_por_acao_manual   NUMERIC NOT NULL,
  acoes_por_mes_estimadas   INTEGER,
  data_go_live              DATE NOT NULL,
  benchmark_antes           JSONB
);

-- PASSO 2: Inserir configuração real do Valdece
-- Fonte dos números: Discovery presencial 2026-05-12 com o Dr. Valdece

INSERT INTO vg_roi_config (
  project_id,
  valor_hora_cliente,
  minutos_por_acao_manual,
  acoes_por_mes_estimadas,
  data_go_live,
  benchmark_antes
) VALUES (
  'valdece_001',
  200,     -- R$/hora (advogado criminal — informado no Discovery)
  120,     -- minutos por busca manual (2h por busca — declarado pelo cliente)
  10,      -- buscas/mês (estimativa conservadora do Discovery)
  '2026-05-17',  -- data da entrega presencial
  '{
    "ferramenta_antes": "STF portal + SCON/STJ + Dizer o Direito + Legislação Integrada",
    "problema_antes": "busca por palavra-chave — retorna pela palavra, não pelo conceito jurídico",
    "tempo_por_busca_antes_minutos": 120,
    "custo_mensal_ineficiencia_reais": 4000,
    "payback_meses": 1.25,
    "roi_ano_1_percentual": 860
  }'::jsonb
)
ON CONFLICT (project_id) DO UPDATE SET
  valor_hora_cliente      = EXCLUDED.valor_hora_cliente,
  minutos_por_acao_manual = EXCLUDED.minutos_por_acao_manual,
  data_go_live            = EXCLUDED.data_go_live,
  benchmark_antes         = EXCLUDED.benchmark_antes;

-- PASSO 3: View do ROI mensal (cola no dashboard)

CREATE OR REPLACE VIEW vg_roi_mensal AS
SELECT
  t.project_id,
  COUNT(*)                                                           AS total_buscas,
  ROUND(COUNT(*) * r.minutos_por_acao_manual / 60.0, 1)            AS horas_economizadas,
  ROUND(COUNT(*) * r.minutos_por_acao_manual / 60.0
        * r.valor_hora_cliente, 2)                                  AS valor_economizado_reais,
  date_trunc('month', NOW())::date                                  AS mes_referencia
FROM vg_telemetry t
JOIN vg_roi_config r ON r.project_id = t.project_id
WHERE t.event_type = 'search'
  AND t.created_at >= date_trunc('month', NOW())
GROUP BY t.project_id, r.minutos_por_acao_manual, r.valor_hora_cliente;

-- VERIFICAÇÃO RÁPIDA (rodar após o INSERT para confirmar)
-- SELECT * FROM vg_roi_config WHERE project_id = 'valdece_001';
-- SELECT * FROM vg_roi_mensal;
