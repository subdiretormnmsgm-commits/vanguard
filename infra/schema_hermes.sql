-- Vanguard Tech — Protocolo Hermes
-- Executar no SQL Editor do Supabase

-- Tabela principal de leads qualificados pelo Secretário Virtual
CREATE TABLE leads_qualificados (
  id                   uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  nome                 text        NOT NULL,
  telefone             text        NOT NULL,
  nicho                text,
  gargalo_tecnologico  text,
  status_agendamento   text        NOT NULL DEFAULT 'NOVO',
  mensagem_original    text,
  resposta_hermes      text,
  conversa_id          text,
  origem               text        NOT NULL DEFAULT 'hermes',
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now()
);

-- Índices para o Cockpit
CREATE INDEX idx_leads_qualificados_status    ON leads_qualificados (status_agendamento);
CREATE INDEX idx_leads_qualificados_created   ON leads_qualificados (created_at DESC);
CREATE INDEX idx_leads_qualificados_telefone  ON leads_qualificados (telefone);

-- RLS
ALTER TABLE leads_qualificados ENABLE ROW LEVEL SECURITY;

-- Hermes insere via service_role key (webhook Python) — sem policy anon INSERT
-- Director lê via Cockpit autenticado
CREATE POLICY "auth_read_qualificados"
  ON leads_qualificados FOR SELECT TO authenticated USING (true);

-- Tabela de memória conversacional do Hermes
CREATE TABLE hermes_conversas (
  id           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  telefone     text        NOT NULL,
  role         text        NOT NULL CHECK (role IN ('user', 'assistant')),
  conteudo     text        NOT NULL,
  created_at   timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_hermes_conversas_telefone ON hermes_conversas (telefone, created_at DESC);

ALTER TABLE hermes_conversas ENABLE ROW LEVEL SECURITY;
CREATE POLICY "auth_read_conversas" ON hermes_conversas FOR SELECT TO authenticated USING (true);

-- Trigger para actualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_leads_qualificados_updated
  BEFORE UPDATE ON leads_qualificados
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enums de status (comentário de referência)
-- NOVO        → primeira mensagem recebida
-- QUALIFICADO → Hermes extraiu nicho + gargalo
-- AGENDADO    → reunião confirmada
-- PERDIDO     → sem resposta há 48h
