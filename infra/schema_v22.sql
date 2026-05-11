-- ═══════════════════════════════════════════════════════════════════════════
-- VANGUARD V22 — Schema Migrations
-- Autonomous Dominion: Hermes Loop + Sentinel Escalation + Oráculo Pulse API
-- Executar: Supabase Dashboard → SQL Editor → Run
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. sentinel_report_log: adicionar colunas de tracking V22 ─────────────
ALTER TABLE sentinel_report_log
  ADD COLUMN IF NOT EXISTS open_token  TEXT,        -- SHA-256 único por relatório
  ADD COLUMN IF NOT EXISTS email_aberto BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS aberto_em   TIMESTAMPTZ;

CREATE UNIQUE INDEX IF NOT EXISTS idx_report_log_open_token
  ON sentinel_report_log (open_token) WHERE open_token IS NOT NULL;

-- ─── 2. escalation_log: registo de acções de escalação ────────────────────
CREATE TABLE IF NOT EXISTS escalation_log (
  id                      UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id               TEXT        NOT NULL,
  nivel                   SMALLINT    NOT NULL,     -- 1=WA, 2=Hermes Voice, 3=IAH Rescue
  acao                    TEXT        NOT NULL,
  semanas_sem_abertura    SMALLINT    NOT NULL DEFAULT 0,
  sucesso                 BOOLEAN     NOT NULL DEFAULT FALSE,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_escalation_log_tenant
  ON escalation_log (tenant_id, created_at DESC);

-- ─── 3. escalation_whatsapp_queue: fila para prospectar.ps1 ───────────────
CREATE TABLE IF NOT EXISTS escalation_whatsapp_queue (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id    TEXT        NOT NULL,
  tenant_nome  TEXT,
  email        TEXT,
  dominio      TEXT,
  message      TEXT        NOT NULL,
  status       TEXT        NOT NULL DEFAULT 'pending',  -- pending | sent | failed
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  sent_at      TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_wa_queue_status
  ON escalation_whatsapp_queue (status, created_at);

-- ─── 4. oracle_api_keys: autenticação do Oráculo Pulse API ────────────────
CREATE TABLE IF NOT EXISTS oracle_api_keys (
  id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  key_hash        TEXT        NOT NULL UNIQUE,   -- SHA-256 da API key
  cliente_nome    TEXT        NOT NULL,
  cliente_email   TEXT,
  plano           TEXT        NOT NULL DEFAULT 'early_access',
  status          TEXT        NOT NULL DEFAULT 'active',
  requests_count  INTEGER     NOT NULL DEFAULT 0,
  last_used_at    TIMESTAMPTZ,
  expires_at      TIMESTAMPTZ,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_oracle_keys_hash
  ON oracle_api_keys (key_hash) WHERE status = 'active';

-- ─── 5. oracle_usage_log: billing e auditoria do Oráculo ──────────────────
CREATE TABLE IF NOT EXISTS oracle_usage_log (
  id           BIGSERIAL   PRIMARY KEY,
  api_key_id   UUID        NOT NULL REFERENCES oracle_api_keys(id),
  cliente_nome TEXT,
  endpoint     TEXT,
  nicho        TEXT,
  region       TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_oracle_usage_key
  ON oracle_usage_log (api_key_id, created_at DESC);

-- ─── 6. hermes_voice_triggers: adicionar coluna auto_calendar ─────────────
ALTER TABLE hermes_voice_triggers
  ADD COLUMN IF NOT EXISTS meeting_link  TEXT,        -- link do evento Google Calendar
  ADD COLUMN IF NOT EXISTS meeting_slot  TEXT,        -- data/hora BRT em texto
  ADD COLUMN IF NOT EXISTS call_id_vapi  TEXT;        -- ID da chamada Vapi

-- ─── 7. View: oracle_mrr — receita estimada do Oráculo ────────────────────
CREATE OR REPLACE VIEW oracle_mrr AS
SELECT
  plano,
  COUNT(*)            AS clientes,
  COUNT(*) * 500      AS mrr_brl,    -- R$500/mês por cliente Early Access
  SUM(requests_count) AS total_requests,
  MAX(last_used_at)   AS ultimo_uso
FROM oracle_api_keys
WHERE status = 'active'
GROUP BY plano;

-- ─── 8. Função: gerar open_token para relatórios ──────────────────────────
CREATE OR REPLACE FUNCTION generate_open_token(p_tenant_id TEXT, p_report_id UUID)
RETURNS TEXT LANGUAGE sql IMMUTABLE AS $$
  SELECT ENCODE(DIGEST(p_tenant_id || ':' || p_report_id::TEXT, 'sha256'), 'hex');
$$;

-- ─── 9. pg_cron: escalação semanal ────────────────────────────────────────
-- Adicionar ao pg_cron (depois do cron da V21):
-- Segunda-feira 09:00 BRT (12:00 UTC) — escalação após envio dos relatórios
-- SELECT cron.schedule(
--   'sentinel-escalation-weekly',
--   '0 12 * * 1',
--   $$SELECT net.http_post(
--     'https://vanguard.tech/api/sentinel/escalation/run',
--     '{}',
--     headers:='{"Authorization":"Bearer " || current_setting("app.cron_secret")}'::jsonb
--   )$$
-- );

-- ─── 10. RLS: oracle_api_keys (apenas service key acede) ──────────────────
ALTER TABLE oracle_api_keys ENABLE ROW LEVEL SECURITY;
CREATE POLICY "service_key_only" ON oracle_api_keys
  USING (current_setting('role') = 'service_role');

ALTER TABLE oracle_usage_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "service_key_only" ON oracle_usage_log
  USING (current_setting('role') = 'service_role');
