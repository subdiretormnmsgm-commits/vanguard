/* ═══════════════════════════════════════════════════════════════════════════
   VANGUARD V18 — NEURAL SENTINEL ENGINE
   Guarda do Castelo: Delta Semanal do Sovereign Pixel → Alerta de Receita
   Lógica: current_week vs previous_week sessions/FIRE/revenue_estimate
   Subscrição: R$97/mês via Stripe — histórico bloqueado se não subscrito
   Exposto como: window.NeuralSentinel = { init, checkPostPayment, isSubscribed }
   ═══════════════════════════════════════════════════════════════════════════ */
const NeuralSentinel = (() => {
  'use strict';

  const SENTINEL_KEY   = 'vg_sentinel_sub';
  const TICKET_MEDIO   = 800;  // R$ — ticket médio B2B Brasil (mesmo da V17)
  const FIRE_ALERT_PCT = 15;   // queda de FIRE % que dispara alerta

  // ─── Supabase: buscar dados de uma semana ─────────────────────────────────────
  async function _fetchWeek(tenantId, weeksBack) {
    const now  = new Date();
    const wStart = new Date(now);
    wStart.setDate(now.getDate() - now.getDay() - weeksBack * 7);
    wStart.setHours(0, 0, 0, 0);
    const wEnd = new Date(wStart);
    wEnd.setDate(wStart.getDate() + 7);

    try {
      const sb = window._supabase || window.supabase;
      if (!sb) throw new Error('no-supabase');
      const { data, error } = await sb
        .from('pixel_events_staging')
        .select('intent_level')
        .eq('tenant_id', tenantId)
        .gte('created_at', wStart.toISOString())
        .lt('created_at', wEnd.toISOString());
      if (error) throw error;
      return {
        total: data.length,
        fire:  data.filter(e => e.intent_level === 'FIRE').length,
        hot:   data.filter(e => e.intent_level === 'HOT').length,
        warm:  data.filter(e => e.intent_level === 'WARM').length,
        cold:  data.filter(e => e.intent_level === 'COLD').length,
        weekStart: wStart,
        _live: true,
      };
    } catch {
      // Dados demo — apresenta widget mesmo sem Pixel instalado
      const seeds = [
        { total: 142, fire: 18, hot: 35, warm: 54, cold: 35 },
        { total: 187, fire: 31, hot: 42, warm: 67, cold: 47 },
      ];
      return { ...seeds[weeksBack] || seeds[1], weekStart: wStart, _demo: true };
    }
  }

  function _deltaPct(cur, prev) {
    if (!prev) return 0;
    return Math.round(((cur - prev) / prev) * 100);
  }

  function _revDelta(curFire, prevFire) {
    return Math.round((prevFire - curFire) * TICKET_MEDIO);
  }

  // ─── Subscrição ────────────────────────────────────────────────────────────────
  function isSubscribed() {
    try {
      const s = JSON.parse(localStorage.getItem(SENTINEL_KEY) || 'null');
      return s && new Date(s.expires) > new Date();
    } catch { return false; }
  }

  function _markSubscribed(days = 30) {
    const exp = new Date();
    exp.setDate(exp.getDate() + days);
    localStorage.setItem(SENTINEL_KEY, JSON.stringify({ expires: exp.toISOString() }));
  }

  // ─── Widget HTML ────────────────────────────────────────────────────────────────
  function _kpi(label, value, delta, up) {
    const dColor = up ? '#32C878' : '#DC3C3C';
    const dSign  = delta >= 0 ? '+' : '';
    return `
      <div style="background:#0F0C04;border:1px solid #3A3020;border-radius:8px;padding:12px 10px;text-align:center;flex:1;min-width:0">
        <div style="font-size:10px;color:#5A5546;margin-bottom:6px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${label}</div>
        <div style="font-size:20px;font-weight:700;color:#E6E4DC">${value !== null ? value : ''}</div>
        <div style="font-size:12px;font-weight:700;color:${dColor};margin-top:3px">${dSign}${delta}%</div>
      </div>`;
  }

  function _alertBanner(fireDelta, revDelta) {
    const abs = Math.abs(revDelta);
    return `
      <div style="background:#1E0606;border:1px solid #DC3C3C;border-radius:8px;padding:12px 16px;margin-bottom:14px;display:flex;gap:12px;align-items:flex-start">
        <span style="font-size:22px;flex-shrink:0">⚠️</span>
        <div>
          <div style="color:#DC3C3C;font-weight:700;font-size:12px;margin-bottom:4px">ALERTA DE RECEITA DETECTADO</div>
          <div style="color:#E6E4DC;font-size:11px;line-height:1.5">
            Sessões FIRE caíram <strong>${Math.abs(fireDelta)}%</strong> esta semana.<br>
            Receita estimada em risco: <strong style="color:#DC3C3C">R$ ${abs.toLocaleString('pt-BR')}</strong>
          </div>
        </div>
      </div>`;
  }

  function _paywall() {
    return `
      <div style="background:#0F0C04;border:1px solid #C5A02860;border-radius:8px;padding:18px;text-align:center;margin-top:4px">
        <div style="font-size:11px;color:#5A5546;margin-bottom:8px">🔒 HISTÓRICO DE 4 SEMANAS BLOQUEADO</div>
        <div style="color:#E6E4DC;font-size:12px;margin-bottom:14px;line-height:1.5">
          Veja a evolução completa do seu Pixel +<br>alertas automáticos toda segunda-feira
        </div>
        <button id="ns-subscribe-btn" style="
          background:#C5A028;color:#0A0802;border:none;padding:11px 0;
          border-radius:6px;font-weight:700;font-size:13px;cursor:pointer;width:100%;
          transition:opacity .2s
        ">Activar Neural Sentinel — R$ 97/mês →</button>
        <div style="font-size:10px;color:#5A5546;margin-top:10px">Cancele quando quiser · Inclui Sovereign Playbook completo</div>
      </div>`;
  }

  function _history(cur, prev) {
    const weeks = ['Actual', '1 semana atrás', '2 semanas atrás', '3 semanas atrás'];
    return `
      <div style="border-top:1px solid #3A3020;padding-top:14px;margin-top:8px">
        <div style="font-size:10px;color:#5A5546;margin-bottom:10px;letter-spacing:.05em">HISTÓRICO COMPLETO — SUBSCRIBER</div>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px;font-size:11px">
          <div style="color:#5A5546">Semana actual: <strong style="color:#C5A028">${cur.fire} FIRE</strong></div>
          <div style="color:#5A5546">Semana anterior: <strong style="color:#E6E4DC">${prev.fire} FIRE</strong></div>
          <div style="color:#5A5546">HOT esta semana: <strong style="color:#E6E4DC">${cur.hot}</strong></div>
          <div style="color:#5A5546">HOT semana ant.: <strong style="color:#E6E4DC">${prev.hot}</strong></div>
        </div>
      </div>`;
  }

  function _render(container, cur, prev, subscribed) {
    const fireDelta  = _deltaPct(cur.fire, prev.fire);
    const totalDelta = _deltaPct(cur.total, prev.total);
    const revDelta   = _revDelta(cur.fire, prev.fire);
    const isAlert    = fireDelta < -FIRE_ALERT_PCT || revDelta > 1500;
    const demoNote   = cur._demo
      ? '<span style="opacity:.35;font-size:10px"> · demo (instale Pixel)</span>' : '';

    container.innerHTML = `
      <div id="ns-widget" style="
        background:linear-gradient(135deg,#0A0802,#100D05);
        border:1px solid #C5A028;border-radius:12px;padding:20px 24px;
        color:#E6E4DC;font-family:'Inter',sans-serif;max-width:540px;
      ">
        <div style="display:flex;align-items:center;gap:10px;margin-bottom:16px">
          <span style="font-size:18px">🛡️</span>
          <span style="color:#C5A028;font-weight:700;font-size:13px;letter-spacing:.05em">NEURAL SENTINEL™</span>
          <span style="margin-left:auto;font-size:11px;color:#5A5546">v18 · 2026${demoNote}</span>
        </div>

        <div style="font-size:10px;color:#5A5546;margin-bottom:14px;letter-spacing:.04em">
          DELTA SEMANA ACTUAL vs SEMANA ANTERIOR
        </div>

        <div style="display:flex;gap:12px;margin-bottom:16px">
          ${_kpi('Sessões Totais', cur.total, totalDelta, totalDelta >= 0)}
          ${_kpi('Sessões FIRE 🔥', cur.fire, fireDelta, fireDelta >= 0)}
          ${_kpi('Delta Receita', 'R$', Math.abs(Math.round(revDelta / TICKET_MEDIO * 100)) / 100 > 0 ? Math.round(revDelta / 100) * 100 : 0, revDelta <= 0)}
        </div>

        ${isAlert ? _alertBanner(fireDelta, revDelta) : ''}
        ${!subscribed ? _paywall() : _history(cur, prev)}
      </div>`;

    const btn = container.querySelector('#ns-subscribe-btn');
    if (btn) btn.addEventListener('click', () => NeuralSentinel.activateSubscription());
  }

  // ─── API Pública ──────────────────────────────────────────────────────────────
  async function init(containerEl, tenantId) {
    if (!containerEl) return;
    const [cur, prev] = await Promise.all([
      _fetchWeek(tenantId, 0),
      _fetchWeek(tenantId, 1),
    ]);
    _render(containerEl, cur, prev, isSubscribed());
  }

  async function activateSubscription() {
    try {
      const res = await fetch('/api/stripe/sentinel-checkout', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ plan: 'neural_sentinel_97' }),
      });
      if (!res.ok) throw new Error();
      const { url } = await res.json();
      window.location.href = url;
    } catch {
      alert('Activação temporariamente indisponível. Contacte suporte@vanguardtech.io');
    }
  }

  function checkPostPayment(tenantId, containerEl) {
    const p = new URLSearchParams(window.location.search);
    if (p.get('sentinel_paid') !== '1') return;
    _markSubscribed(30);
    window.history.replaceState({}, '', window.location.pathname);
    if (containerEl && tenantId) init(containerEl, tenantId);
  }

  return { init, activateSubscription, checkPostPayment, isSubscribed };
})();
