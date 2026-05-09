-- Vanguard Tech — Schema V1
-- Tabela de leads captados pelo Quiz de Diagnóstico

CREATE TABLE leads_diagnostico (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  nome        text        NOT NULL,
  whatsapp    text        NOT NULL,
  nicho       text        NOT NULL,
  gargalo     text        NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  origem      text        NOT NULL DEFAULT 'landing_v1'
);

CREATE INDEX idx_leads_diagnostico_created_at
  ON leads_diagnostico (created_at DESC);

ALTER TABLE leads_diagnostico ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon_insert_only"
  ON leads_diagnostico
  FOR INSERT
  TO anon
  WITH CHECK (true);
