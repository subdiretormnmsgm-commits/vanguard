-- Vanguard Tech — Migration V2
-- Executar no SQL Editor do Supabase depois do schema_v1.sql

-- Permite que utilizadores autenticados (Supabase Auth) leiam todos os leads
CREATE POLICY "auth_read_leads"
  ON leads_diagnostico
  FOR SELECT
  TO authenticated
  USING (true);

-- Cria a tabela de sessões de diagnóstico (usado pelo Cockpit para logs de acesso)
CREATE TABLE IF NOT EXISTS cockpit_sessions (
  id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE cockpit_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "owner_only"
  ON cockpit_sessions
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
