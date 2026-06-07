-- W-8 Signal Classifier -- Tabela de Log (Shadow Mode)
-- Executar no Supabase SQL Editor: https://supabase.com/dashboard/project/ehyaecxqijgyuuiorzcj/sql

CREATE TABLE IF NOT EXISTS silenced_signals_log (
  id          SERIAL       PRIMARY KEY,
  origem      TEXT,
  cliente     TEXT,
  categoria   TEXT,
  grau        TEXT,
  motivo      TEXT,
  shadow_mode BOOLEAN      DEFAULT true,
  timestamp   TIMESTAMPTZ  DEFAULT now()
);

-- Index para consulta por data e categoria
CREATE INDEX IF NOT EXISTS idx_ssl_timestamp  ON silenced_signals_log (timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_ssl_categoria  ON silenced_signals_log (categoria);

-- RLS
ALTER TABLE silenced_signals_log ENABLE ROW LEVEL SECURITY;

-- Anon pode ler (Musculo consulta o log de sombra)
CREATE POLICY "anon_read_signals" ON silenced_signals_log
  FOR SELECT TO anon USING (true);

-- Service role pode inserir (W-8 via anon key com header apikey)
CREATE POLICY "anon_insert_signals" ON silenced_signals_log
  FOR INSERT TO anon WITH CHECK (true);
