-- ═══════════════════════════════════════════════════════════════════════
-- Vanguard V5 — Migração Supabase: Auditor IA (Claude Haiku)
-- Execute no Supabase → SQL Editor
-- ═══════════════════════════════════════════════════════════════════════

-- Adiciona coluna ai_hook para armazenar o hook personalizado gerado pela IA
ALTER TABLE leads_diagnostico
  ADD COLUMN IF NOT EXISTS ai_hook TEXT DEFAULT '';

-- Índice para o n8n filtrar leads com hook IA pendente de envio
CREATE INDEX IF NOT EXISTS idx_leads_ai_hook_pending
  ON leads_diagnostico (created_at DESC)
  WHERE ai_hook IS NOT NULL AND ai_hook <> '';

-- View para o Cockpit mostrar leads com análise IA
CREATE OR REPLACE VIEW leads_com_ia AS
SELECT
  id,
  nome,
  whatsapp,
  nicho,
  gargalo,
  ai_hook,
  origem,
  created_at,
  CASE WHEN ai_hook IS NOT NULL AND ai_hook <> '' THEN true ELSE false END AS tem_hook_ia
FROM leads_diagnostico
ORDER BY created_at DESC;

-- Política RLS para a view (herda da tabela base)
COMMENT ON COLUMN leads_diagnostico.ai_hook IS
  'Hook personalizado gerado pelo Claude Haiku durante a auditoria do site. '
  'Usado pelo n8n (Hermes) para envio via WhatsApp em substituição ao template genérico.';
