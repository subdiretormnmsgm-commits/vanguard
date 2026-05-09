-- Vanguard Tech — Migration V3
-- Executar no SQL Editor do Supabase depois de schema_v2.sql
-- Nota: o scraper injeta na tabela leads_diagnostico com origem='scraper'
-- Não é necessária nova tabela — o Cockpit V2 já filtra por origem.

-- Índice para acelerar filtros por origem no Cockpit
CREATE INDEX IF NOT EXISTS idx_leads_diagnostico_origem
  ON leads_diagnostico (origem);

-- View de conveniência para o Director ver apenas leads outbound
CREATE OR REPLACE VIEW leads_outbound AS
  SELECT * FROM leads_diagnostico
  WHERE origem = 'scraper'
  ORDER BY created_at DESC;

-- RLS na view (herda da tabela base, sem configuração adicional)
