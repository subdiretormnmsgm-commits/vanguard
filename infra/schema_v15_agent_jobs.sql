-- ═══════════════════════════════════════════════════════════════════════════
-- VANGUARD TECH — Agent Jobs Schema V15
-- Hermes Ready Check: máquina de estados de 7 fases (Detecção → Fecho)
-- + Trigger automático para Maturity Score > 8.0 → Proposta PDF Cyber-Premium
-- Executar no SQL Editor do Supabase
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── 1. ENUM DE ESTADOS ──────────────────────────────────────────────────────
-- 7 estados operacionais + 1 terminal de falha
CREATE TYPE agent_job_status AS ENUM (
  'DETECÇÃO',       -- 1. Lead identificado (quiz/scanner/outbound)
  'CONTACTO',       -- 2. Mensagem Hermes enviada pelo Director
  'EM_CONVERSA',    -- 3. Lead respondeu — conversa activa
  'QUALIFICADO',    -- 4. Hermes extraiu: nicho + gargalo + dor principal
  'PROPOSTA',       -- 5. PDF Cyber-Premium gerado e enviado (auto se score > 8.0)
  'NEGOCIAÇÃO',     -- 6. Lead em análise da proposta
  'FECHADO',        -- 7. Deal fechado ✅ (estado terminal de sucesso)
  'PERDIDO'         --    Sem resposta > 48h ou recusa explícita (terminal de falha)
);

-- ─── 2. TABELA PRINCIPAL ─────────────────────────────────────────────────────
CREATE TABLE agent_jobs (
  id                uuid            PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Ligação ao lead de origem (diagnostico quiz ou scanner)
  lead_id           uuid            REFERENCES leads_diagnostico(id) ON DELETE SET NULL,

  -- Estado da máquina
  status            agent_job_status NOT NULL DEFAULT 'DETECÇÃO',

  -- Dados do lead (copiados aqui para autonomia do job se lead_id for nulo)
  nome              text,
  telefone          text,
  whatsapp          text,
  nicho             text,
  gargalo           text,
  email             text,

  -- Score de maturidade digital (0.0–10.0) — fonte do trigger de proposta
  maturity_score    numeric(4,2)    CHECK (maturity_score BETWEEN 0 AND 10),

  -- Timestamps de cada transição de estado (auditoria completa)
  detected_at       timestamptz     NOT NULL DEFAULT now(),
  contacted_at      timestamptz,
  conversation_at   timestamptz,
  qualified_at      timestamptz,
  proposal_at       timestamptz,
  negotiation_at    timestamptz,
  closed_at         timestamptz,
  lost_at           timestamptz,

  -- Dados do negócio
  deal_value        numeric(10,2),           -- Valor estimado do contrato
  proposal_url      text,                    -- URL do PDF gerado (ou link Supabase Storage)
  close_reason      text,                    -- Motivo do fecho / perda
  next_follow_up    timestamptz,             -- Data do próximo follow-up agendado

  -- Metadata
  origem            text            NOT NULL DEFAULT 'quiz',  -- quiz | scanner | outbound | manual
  assigned_to       text,                    -- email do Director responsável
  notes             text,                    -- notas internas do Director
  created_at        timestamptz     NOT NULL DEFAULT now(),
  updated_at        timestamptz     NOT NULL DEFAULT now()
);

-- ─── 3. ÍNDICES ──────────────────────────────────────────────────────────────
CREATE INDEX idx_agent_jobs_status      ON agent_jobs (status);
CREATE INDEX idx_agent_jobs_lead        ON agent_jobs (lead_id);
CREATE INDEX idx_agent_jobs_whatsapp    ON agent_jobs (whatsapp);
CREATE INDEX idx_agent_jobs_score       ON agent_jobs (maturity_score DESC);
CREATE INDEX idx_agent_jobs_created     ON agent_jobs (created_at DESC);
CREATE INDEX idx_agent_jobs_follow_up   ON agent_jobs (next_follow_up) WHERE next_follow_up IS NOT NULL;

-- ─── 4. RLS ──────────────────────────────────────────────────────────────────
ALTER TABLE agent_jobs ENABLE ROW LEVEL SECURITY;

-- Director lê e escreve jobs da sua sessão autenticada
CREATE POLICY "director_full_access"
  ON agent_jobs FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);

-- Hermes agent (service_role) escreve via webhook — sem policy adicional necessária

-- ─── 5. LOG DE EVENTOS (AUDITORIA DE TRANSIÇÕES) ────────────────────────────
CREATE TABLE agent_job_events (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id      uuid        NOT NULL REFERENCES agent_jobs(id) ON DELETE CASCADE,
  from_status agent_job_status,
  to_status   agent_job_status NOT NULL,
  triggered_by text       NOT NULL DEFAULT 'system',  -- system | director | hermes | auto_score
  metadata    jsonb,       -- dados adicionais (score no momento, mensagem, etc.)
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_agent_events_job ON agent_job_events (job_id, created_at DESC);
ALTER TABLE agent_job_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "director_read_events" ON agent_job_events FOR SELECT TO authenticated USING (true);
CREATE POLICY "system_insert_events" ON agent_job_events FOR INSERT TO authenticated WITH CHECK (true);

-- ─── 6. TRIGGER: updated_at ──────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_agent_job_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_agent_job_updated_at
  BEFORE UPDATE ON agent_jobs
  FOR EACH ROW EXECUTE FUNCTION fn_agent_job_updated_at();

-- ─── 7. TRIGGER: VALIDAÇÃO DE TRANSIÇÕES ────────────────────────────────────
-- Garante que só são permitidas transições válidas na máquina de estados
CREATE OR REPLACE FUNCTION fn_validate_state_transition()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  valid_transitions jsonb := '{
    "DETECÇÃO":  ["CONTACTO", "PERDIDO"],
    "CONTACTO":  ["EM_CONVERSA", "PERDIDO"],
    "EM_CONVERSA": ["QUALIFICADO", "PERDIDO"],
    "QUALIFICADO": ["PROPOSTA", "NEGOCIAÇÃO", "PERDIDO"],
    "PROPOSTA":  ["NEGOCIAÇÃO", "FECHADO", "PERDIDO"],
    "NEGOCIAÇÃO": ["FECHADO", "PERDIDO"],
    "FECHADO":   [],
    "PERDIDO":   ["CONTACTO"]
  }'::jsonb;
  allowed jsonb;
BEGIN
  -- Sem mudança de estado → sem validação
  IF OLD.status = NEW.status THEN RETURN NEW; END IF;

  allowed := valid_transitions -> OLD.status::text;

  IF NOT (allowed @> to_jsonb(NEW.status::text)) THEN
    RAISE EXCEPTION 'Transição inválida: % → %. Transições permitidas: %',
      OLD.status, NEW.status, allowed;
  END IF;

  -- Registar evento de transição
  INSERT INTO agent_job_events (job_id, from_status, to_status, triggered_by, metadata)
  VALUES (
    NEW.id,
    OLD.status,
    NEW.status,
    COALESCE(current_setting('app.triggered_by', true), 'director'),
    jsonb_build_object('maturity_score', NEW.maturity_score, 'timestamp', now())
  );

  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validate_transition
  BEFORE UPDATE OF status ON agent_jobs
  FOR EACH ROW EXECUTE FUNCTION fn_validate_state_transition();

-- ─── 8. TRIGGER: AUTO-PROPOSTA (MATURITY SCORE > 8.0) ───────────────────────
-- Se o score for actualizado para > 8.0 enquanto status = QUALIFICADO,
-- avança automaticamente para PROPOSTA e regista timestamp + URL do PDF
CREATE OR REPLACE FUNCTION fn_auto_proposal_on_high_score()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  -- Condição: score acabou de ultrapassar 8.0 E job está em QUALIFICADO
  IF NEW.maturity_score > 8.0
     AND NEW.status = 'QUALIFICADO'
     AND (OLD.maturity_score IS NULL OR OLD.maturity_score <= 8.0)
  THEN
    -- Desactivar trigger de validação para esta transição automática
    -- (é uma transição válida QUALIFICADO → PROPOSTA)
    NEW.status       := 'PROPOSTA';
    NEW.proposal_at  := now();
    -- URL canónica da proposta — o PDF é gerado pelo dashboard/js via jsPDF
    -- e armazenado via Supabase Storage ou enviado directamente
    NEW.proposal_url := 'https://vanguardtech.io/proposals/cyber-premium/' || NEW.id::text;

    -- Registar evento como triggered by auto_score
    INSERT INTO agent_job_events (job_id, from_status, to_status, triggered_by, metadata)
    VALUES (
      NEW.id,
      'QUALIFICADO',
      'PROPOSTA',
      'auto_score',
      jsonb_build_object(
        'score',       NEW.maturity_score,
        'threshold',   8.0,
        'rule',        'maturity_score > 8.0 → Proposta PDF Cyber-Premium automática',
        'proposal_url', NEW.proposal_url
      )
    );

  END IF;
  RETURN NEW;
END;
$$;

-- Este trigger corre ANTES do de validação para ajustar o status antes da checagem
CREATE TRIGGER trg_auto_proposal_high_score
  BEFORE UPDATE OF maturity_score ON agent_jobs
  FOR EACH ROW EXECUTE FUNCTION fn_auto_proposal_on_high_score();

-- ─── 9. TRIGGER: TIMESTAMPS DE ESTADO ────────────────────────────────────────
-- Preenche automaticamente os timestamps ao transitar de estado
CREATE OR REPLACE FUNCTION fn_state_timestamps()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  IF OLD.status = NEW.status THEN RETURN NEW; END IF;

  CASE NEW.status
    WHEN 'CONTACTO'    THEN NEW.contacted_at    = COALESCE(NEW.contacted_at, now());
    WHEN 'EM_CONVERSA' THEN NEW.conversation_at = COALESCE(NEW.conversation_at, now());
    WHEN 'QUALIFICADO' THEN NEW.qualified_at    = COALESCE(NEW.qualified_at, now());
    WHEN 'PROPOSTA'    THEN NEW.proposal_at     = COALESCE(NEW.proposal_at, now());
    WHEN 'NEGOCIAÇÃO'  THEN NEW.negotiation_at  = COALESCE(NEW.negotiation_at, now());
    WHEN 'FECHADO'     THEN NEW.closed_at       = COALESCE(NEW.closed_at, now());
    WHEN 'PERDIDO'     THEN NEW.lost_at         = COALESCE(NEW.lost_at, now());
    ELSE NULL;
  END CASE;

  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_state_timestamps
  BEFORE UPDATE OF status ON agent_jobs
  FOR EACH ROW EXECUTE FUNCTION fn_state_timestamps();

-- ─── 10. AUTO-EXPIRAÇÃO PARA PERDIDO (pg_cron) ───────────────────────────────
-- Jobs em CONTACTO ou EM_CONVERSA sem actividade > 48h → PERDIDO automático
-- Requer extensão pg_cron activada no Supabase Pro
SELECT cron.schedule(
  'hermes-auto-expire',
  '0 */6 * * *',  -- a cada 6 horas
  $$
    UPDATE agent_jobs
    SET
      status   = 'PERDIDO',
      lost_at  = now(),
      close_reason = 'Auto-expirado: sem resposta em 48h'
    WHERE
      status IN ('CONTACTO', 'EM_CONVERSA')
      AND updated_at < now() - INTERVAL '48 hours';
  $$
);

-- ─── 11. VIEWS OPERACIONAIS ───────────────────────────────────────────────────

-- Pipeline view: jobs activos por estado com métricas de tempo
CREATE OR REPLACE VIEW v_agent_pipeline AS
SELECT
  id,
  nome,
  nicho,
  gargalo,
  whatsapp,
  status,
  maturity_score,
  deal_value,
  proposal_url,
  next_follow_up,
  origem,
  -- Tempo total no pipeline (dias)
  ROUND(EXTRACT(EPOCH FROM (now() - detected_at)) / 86400, 1) AS days_in_pipeline,
  -- Tempo no estado actual (horas)
  ROUND(EXTRACT(EPOCH FROM (now() - updated_at)) / 3600, 1)   AS hours_in_current_status,
  -- Flag de urgência: > 24h sem movimento em estados activos
  CASE
    WHEN status IN ('CONTACTO', 'EM_CONVERSA', 'QUALIFICADO', 'PROPOSTA', 'NEGOCIAÇÃO')
         AND updated_at < now() - INTERVAL '24 hours'
    THEN true
    ELSE false
  END AS needs_attention,
  created_at,
  updated_at
FROM agent_jobs
WHERE status NOT IN ('FECHADO', 'PERDIDO')
ORDER BY maturity_score DESC NULLS LAST, created_at DESC;

-- Funil de conversão por estado
CREATE OR REPLACE VIEW v_conversion_funnel AS
SELECT
  status,
  COUNT(*)                                        AS total,
  AVG(maturity_score)                             AS avg_score,
  SUM(deal_value)                                 AS pipeline_value,
  ROUND(AVG(EXTRACT(EPOCH FROM (updated_at - created_at)) / 3600), 1) AS avg_hours_to_reach
FROM agent_jobs
GROUP BY status
ORDER BY
  CASE status
    WHEN 'DETECÇÃO'    THEN 1
    WHEN 'CONTACTO'    THEN 2
    WHEN 'EM_CONVERSA' THEN 3
    WHEN 'QUALIFICADO' THEN 4
    WHEN 'PROPOSTA'    THEN 5
    WHEN 'NEGOCIAÇÃO'  THEN 6
    WHEN 'FECHADO'     THEN 7
    WHEN 'PERDIDO'     THEN 8
  END;

-- ─── 12. SEED: JOBS DE DEMONSTRAÇÃO ──────────────────────────────────────────
INSERT INTO agent_jobs
  (nome, nicho, gargalo, whatsapp, maturity_score, status, origem, deal_value, contacted_at, qualified_at)
VALUES
  ('Clínica São Lucas',    'Saúde',       'Processos manuais que consomem tempo',                   '351910000001', 8.5, 'PROPOSTA',   'scanner', 1500, now()-'2d'::interval, now()-'1d'::interval),
  ('Escritório Fonseca',   'Advocacia',   'Falta de visibilidade sobre métricas do negócio',         '351920000002', 7.2, 'QUALIFICADO','quiz',    2000, now()-'3d'::interval, now()-'2d'::interval),
  ('Imóveis Atlântico',    'Imobiliário', 'Captação e retenção de clientes',                         '351930000003', 6.1, 'EM_CONVERSA','outbound',1200, now()-'1d'::interval, NULL),
  ('TechStart Lisboa',     'Tecnologia',  'Dependência de ferramentas de terceiros',                  '351940000004', 9.2, 'PROPOSTA',   'quiz',    3000, now()-'4d'::interval, now()-'3d'::interval),
  ('Academia Digital PT',  'Educação',    'Dificuldade em escalar a equipa',                          '351950000005', 5.8, 'CONTACTO',   'scanner', 800,  now()-'12h'::interval, NULL);

-- Score > 8.0 → status já deve ser PROPOSTA (veja seed acima — inserimos directamente como PROPOSTA)
-- Em produção, o trigger fn_auto_proposal_on_high_score() faz isto automaticamente no UPDATE

-- ─── FIM DO SCHEMA V15 ────────────────────────────────────────────────────────
-- Checklist de execução:
-- [ ] Activar extensão pg_cron no Supabase (Settings → Extensions)
-- [ ] Criar bucket 'proposals' no Supabase Storage para PDFs
-- [ ] Configurar webhook Director para notificações de FECHADO e PERDIDO
-- [ ] Rever RLS policies se multi-tenant for necessário
