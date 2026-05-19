-- ============================================================
-- PROJ-002 Ingrid — Migração Dias 6-8
-- Loop 3: Clickwrap + Tutor Socrático + Telemetria TTI
-- Executar no Supabase SQL Editor antes do deploy do Dia 6
-- ============================================================

-- 1. TERMOS_ACEITOS — Clickwrap P-023
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS termos_aceitos (
  id           uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id      uuid        NOT NULL,
  accepted_at  timestamptz NOT NULL,
  versao_termo text        NOT NULL,
  hash_sha256  text        NOT NULL,
  UNIQUE (user_id, versao_termo)
);

ALTER TABLE termos_aceitos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon lê próprios termos"
  ON termos_aceitos FOR SELECT TO anon
  USING (true);

CREATE POLICY "anon registra aceite"
  ON termos_aceitos FOR INSERT TO anon
  WITH CHECK (true);

CREATE POLICY "service_role gerencia termos"
  ON termos_aceitos FOR ALL TO service_role
  USING (true);


-- 2. EXPLICACAO_TUTOR — Cache bidimensional P-006
-- ─────────────────────────────────────────────────────────────
-- Chave: (questao_id, nivel, distrator)
-- Nível 1 e 3: distrator = '' (cache genérico por questão)
-- Nível 2: distrator = letra escolhida (específico por erro)
CREATE TABLE IF NOT EXISTS explicacao_tutor (
  id          uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  questao_id  text        NOT NULL,
  nivel       integer     NOT NULL CHECK (nivel BETWEEN 1 AND 3),
  distrator   text        NOT NULL DEFAULT '',
  explicacao  text        NOT NULL,
  cached_at   timestamptz DEFAULT now(),
  UNIQUE (questao_id, nivel, distrator)
);

ALTER TABLE explicacao_tutor ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon lê cache tutor"
  ON explicacao_tutor FOR SELECT TO anon
  USING (true);

CREATE POLICY "service_role gerencia cache"
  ON explicacao_tutor FOR ALL TO service_role
  USING (true);


-- 3. ABANDONMENT_LOG — Beacon de abandono N-5
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS abandonment_log (
  id           uuid        DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id      uuid        NOT NULL,
  questao_id   text        NOT NULL,
  viewed_at    timestamptz NOT NULL,
  abandoned_at timestamptz NOT NULL
);

ALTER TABLE abandonment_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon insere abandono"
  ON abandonment_log FOR INSERT TO anon
  WITH CHECK (true);

CREATE POLICY "service_role gerencia log"
  ON abandonment_log FOR ALL TO service_role
  USING (true);


-- 4. ESTENDER PROGRESSO_USUARIO — Telemetria TTI + Distrator + Nível
-- ─────────────────────────────────────────────────────────────
-- Campos novos: tempo_resposta_ms, distrator_escolhido,
--   nivel_tutor_disparado, acerto_provavel_chute, disciplina_id
ALTER TABLE progresso_usuario
  ADD COLUMN IF NOT EXISTS disciplina_id          text,
  ADD COLUMN IF NOT EXISTS tempo_resposta_ms      integer,
  ADD COLUMN IF NOT EXISTS distrator_escolhido    text,
  ADD COLUMN IF NOT EXISTS nivel_tutor_disparado  integer,
  ADD COLUMN IF NOT EXISTS acerto_provavel_chute  boolean DEFAULT false;

-- Índice para buscar último erro por disciplina (E-2 frase de abertura)
CREATE INDEX IF NOT EXISTS idx_progresso_usuario_ultimo_erro
  ON progresso_usuario (user_id, correta, respondida_em DESC)
  WHERE correta = false;

-- Índice para curva erro/distrator — business case E-4
CREATE INDEX IF NOT EXISTS idx_progresso_usuario_distrator
  ON progresso_usuario (user_id, disciplina_id, distrator_escolhido)
  WHERE distrator_escolhido IS NOT NULL;


-- 5. RPC get_total_respostas_ingrid — alimenta E-5 sem baixar histórico
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_total_respostas_ingrid(p_user_id uuid)
RETURNS integer
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT COALESCE(COUNT(*)::integer, 0)
  FROM progresso_usuario
  WHERE user_id = p_user_id;
$$;

GRANT EXECUTE ON FUNCTION get_total_respostas_ingrid(uuid) TO anon;
GRANT EXECUTE ON FUNCTION get_total_respostas_ingrid(uuid) TO authenticated;


-- 6. VIEW para curva erro/distrator (E-4 — business case Quadrix)
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_curva_distrator AS
SELECT
  user_id,
  disciplina_id,
  distrator_escolhido,
  nivel_tutor_disparado,
  COUNT(*)                                          AS total_ocorrencias,
  MIN(respondida_em)                                AS primeira_vez,
  MAX(respondida_em)                                AS ultima_vez
FROM progresso_usuario
WHERE distrator_escolhido IS NOT NULL
GROUP BY user_id, disciplina_id, distrator_escolhido, nivel_tutor_disparado
ORDER BY total_ocorrencias DESC;

-- ============================================================
-- VERIFICAÇÃO PÓS-MIGRAÇÃO
-- Copie e rode para confirmar que tudo foi criado:
-- ============================================================
-- SELECT table_name FROM information_schema.tables
-- WHERE table_schema = 'public'
-- AND table_name IN ('termos_aceitos','explicacao_tutor','abandonment_log');
--
-- SELECT column_name FROM information_schema.columns
-- WHERE table_name = 'progresso_usuario'
-- AND column_name IN ('disciplina_id','tempo_resposta_ms','distrator_escolhido',
--                     'nivel_tutor_disparado','acerto_provavel_chute');
--
-- SELECT proname FROM pg_proc WHERE proname = 'get_total_respostas_ingrid';
-- ============================================================
