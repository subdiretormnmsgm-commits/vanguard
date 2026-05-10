/* ═══════════════════════════════════════════════════════════════════════════
   VANGUARD V19 — BURN RATE SHIELD §21
   Maturity Score Engine: calcula score composto 0–10 por sessão/lead
   Gate: Hermes Voice (Vapi) só activa para score > 8.5
   Exposto como: window.BurnRateShield = { getScore, isVoiceReady, renderGate }
   ═══════════════════════════════════════════════════════════════════════════ */
const BurnRateShield = (() => {
  'use strict';

  const VOICE_THRESHOLD = 8.5;   /* §21 — imutável */
  const TICKET_MEDIO    = 800;   /* R$ — mesmo da V17/V18 */

  /* Pesos do score composto */
  const W = {
    intent:   0.60,
    depth:    0.25,
    recencia: 0.15,
  };

  /* Pontuação base por intent_level */
  const INTENT_SCORES = { FIRE: 9.0, HOT: 6.0, WARM: 3.0, COLD: 1.0 };

  /* ─── Calcular Maturity Score a partir de eventos do Pixel ─────────── */
  function computeScore(events) {
    if (!events || !events.length) return 0;

    const now = Date.now();

    /* Intent score: máximo nível visto na sessão */
    const maxIntent = events.reduce((best, ev) => {
      const s = INTENT_SCORES[ev.intent_level] || 0;
      return s > best ? s : best;
    }, 0);
    const intentScore = maxIntent;

    /* Depth score: normalizado pelo nº de eventos (cap em 10 eventos = 100%) */
    const depthScore = Math.min(events.length / 10, 1.0) * 10.0;

    /* Recência score: último evento nas 72h = 10 / senão = 3 */
    const lastSeen = Math.max(...events.map(ev => new Date(ev.created_at || ev.ts || 0).getTime()));
    const recenciaScore = (now - lastSeen) < 72 * 3600 * 1000 ? 10.0 : 3.0;

    const score = (intentScore * W.intent) + (depthScore * W.depth) + (recenciaScore * W.recencia);
    return Math.round(score * 100) / 100;
  }

  /* ─── Gate §21: Hermes Voice activo? ─────────────────────────────────── */
  function isVoiceReady(score) {
    return score > VOICE_THRESHOLD;
  }

  /* ─── Buscar score do tenant via Supabase ─────────────────────────────── */
  async function getScore(tenantId, sessionId) {
    try {
      const sb = window._supabase || window.supabase;
      if (!sb) throw new Error('no-supabase');

      const since = new Date(Date.now() - 7 * 24 * 3600 * 1000).toISOString();
      const query = sb
        .from('pixel_events_staging')
        .select('intent_level, created_at')
        .eq('tenant_id', tenantId)
        .gte('created_at', since);

      if (sessionId) query.eq('session_id', sessionId);

      const { data, error } = await query;
      if (error) throw error;

      return computeScore(data || []);
    } catch {
      /* Demo: retorna score baseado em cookie de intenção */
      const cookie = document.cookie;
      if (cookie.includes('__vg_intent=FIRE')) return 9.2;
      if (cookie.includes('__vg_intent=HOT'))  return 6.8;
      if (cookie.includes('__vg_intent=WARM')) return 3.5;
      return 1.0;
    }
  }

  /* ─── Render: HUD widget do Burn Rate Shield ─────────────────────────── */
  async function renderGate(containerEl, tenantId, sessionId) {
    if (!containerEl) return;

    const score = await getScore(tenantId, sessionId);
    const ready = isVoiceReady(score);
    const pct   = Math.round((score / 10) * 100);

    const barColor = ready
      ? 'linear-gradient(90deg,#1A7A1A,#32C878)'
      : score > 6
        ? 'linear-gradient(90deg,#7A5A00,#C5A028)'
        : 'linear-gradient(90deg,#5A1010,#DC3C3C)';

    containerEl.innerHTML = `
      <div style="
        background:#0F0C04;border:1px solid #3A3020;border-radius:10px;
        padding:16px 20px;font-family:'Inter',sans-serif;color:#E6E4DC;
        max-width:480px;
      ">
        <div style="display:flex;align-items:center;gap:8px;margin-bottom:14px">
          <span style="font-size:16px">🛡️</span>
          <span style="color:#C5A028;font-weight:700;font-size:12px;letter-spacing:.05em">
            BURN RATE SHIELD §21
          </span>
          <span style="margin-left:auto;font-size:10px;color:#5A5546">v19</span>
        </div>

        <div style="font-size:10px;color:#5A5546;margin-bottom:10px;letter-spacing:.04em">
          MATURITY SCORE — LIMIAR HERMES VOICE: ${VOICE_THRESHOLD}
        </div>

        <div style="display:flex;align-items:center;gap:12px;margin-bottom:12px">
          <div style="flex:1;height:8px;background:#1A1408;border-radius:4px;overflow:hidden">
            <div style="height:100%;width:${pct}%;background:${barColor};
                        border-radius:4px;transition:width 800ms ease"></div>
          </div>
          <span style="font-size:18px;font-weight:700;color:${ready ? '#32C878' : '#C5A028'};
                       min-width:2.5rem;text-align:right">${score}</span>
        </div>

        <div style="
          background:${ready ? 'rgba(50,200,120,0.07)' : 'rgba(220,60,60,0.07)'};
          border:1px solid ${ready ? 'rgba(50,200,120,0.3)' : 'rgba(220,60,60,0.25)'};
          border-radius:7px;padding:11px 14px;font-size:11px;line-height:1.5;
        ">
          ${ready
            ? `<strong style="color:#32C878">✓ HERMES VOICE AUTORIZADO</strong><br>
               Score ${score} supera o limiar §21 (${VOICE_THRESHOLD}). Lead qualificado para contacto de voz. Receita estimada: <strong>R$ ${(Math.round(score * TICKET_MEDIO / 10 / 100) * 100).toLocaleString('pt-BR')}</strong>.`
            : `<strong style="color:#DC3C3C">✗ HERMES VOICE BLOQUEADO</strong><br>
               Score ${score} abaixo do limiar §21 (${VOICE_THRESHOLD}). Lead em maturação. ${(VOICE_THRESHOLD - score).toFixed(1)} pontos em falta.`
          }
        </div>
      </div>`;
  }

  return { getScore, computeScore, isVoiceReady, renderGate };
})();
