(() => {
  'use strict';

  const SUPABASE_URL      = 'https://ehyaecxqijgyuuiorzcj.supabase.co';
  const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVoeWFlY3hxaWpneXV1aW9yemNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgyODMzNTAsImV4cCI6MjA5Mzg1OTM1MH0.xZfcEe2Av5Fn9BKEkNRIi5CQkPD6C6ADSNzMfh3DGPo';

  const client = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

  // ─── Algoritmo de scoring (espelho do shadow_closer_v2.py) ────────────────
  const GARGALO_SCORES = {
    'Dificuldade em escalar a equipa':                   100,
    'Falta de visibilidade sobre métricas do negócio':    85,
    'Captação e retenção de clientes':                    80,
    'Processos manuais que consomem tempo':               70,
    'Dependência de ferramentas de terceiros':             65,
  };

  const NICHO_MULTIPLIERS = {
    'Finanças':    1.00, 'Consultoria': 0.95, 'Tecnologia':  0.90,
    'Saúde':       0.85, 'Imobiliário': 0.80, 'E-commerce':  0.75,
    'Educação':    0.70, 'Outro':       0.65,
  };

  const URGENCY_KW = { 'escal': 10, 'crise': 15, 'urgente': 15, 'bloqueio': 10, 'travar': 10, 'perder': 8, 'queda': 8 };

  function score(nicho, gargalo) {
    const base  = GARGALO_SCORES[gargalo] ?? 50;
    const mult  = NICHO_MULTIPLIERS[nicho] ?? 0.65;
    const lower = gargalo.toLowerCase();
    const bonus = Math.max(-20, Math.min(20,
      Object.entries(URGENCY_KW).reduce((s, [k, w]) => s + (lower.includes(k) ? w : 0), 0)
    ));
    const val   = Math.max(0, Math.min(100, Math.round(base * mult + bonus)));
    const tier  = val >= 75 ? 'VIP' : (val >= 55 ? 'QUENTE' : 'FRIO');
    return { val, tier };
  }

  // ─── Views ────────────────────────────────────────────────────────────────
  const viewLogin   = document.getElementById('view-login');
  const viewCockpit = document.getElementById('view-cockpit');

  function showCockpit(email) {
    viewLogin.style.display   = 'none';
    viewCockpit.style.display = 'block';
    document.getElementById('cockpit-user-email').textContent = email;
    loadLeads();
    startWarRoom();
    try { window.PartnershipsEngine?.init(); } catch (e) { console.warn('PartnershipsEngine:', e); }
    try { window.HiveMind?.init(client);     } catch (e) { console.warn('HiveMind:', e); }
    try { window.TrojanGenerator?.init();    } catch (e) { console.warn('TrojanGenerator:', e); }
    try { window.WhatsAppBridge?.init();     } catch (e) { console.warn('WhatsAppBridge:', e); }
  }

  function showLogin() {
    viewLogin.style.display   = 'flex';
    viewCockpit.style.display = 'none';
  }

  // ─── Auth ─────────────────────────────────────────────────────────────────
  client.auth.getSession().then(({ data: { session } }) => {
    if (session) showCockpit(session.user.email);
    else showLogin();
  });

  document.getElementById('login-form').addEventListener('submit', async e => {
    e.preventDefault();
    const btn = document.getElementById('login-btn');
    const err = document.getElementById('login-error');
    const email    = document.getElementById('login-email').value.trim();
    const password = document.getElementById('login-password').value;

    btn.disabled     = true;
    btn.textContent  = 'A autenticar...';
    err.hidden       = true;

    const { error } = await client.auth.signInWithPassword({ email, password });
    if (error) {
      err.textContent = 'Credenciais inválidas. Verifique o e-mail e a palavra-passe.';
      err.hidden      = false;
      btn.disabled    = false;
      btn.textContent = 'Entrar no Cockpit →';
    } else {
      showCockpit(email);
    }
  });

  document.getElementById('btn-logout').addEventListener('click', async () => {
    await client.auth.signOut();
    showLogin();
  });

  // ─── Filtros ──────────────────────────────────────────────────────────────
  let allLeads = [];
  let activeFilter = 'all';

  document.querySelectorAll('.cockpit__filter').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.cockpit__filter').forEach(b => b.classList.remove('cockpit__filter--active'));
      btn.classList.add('cockpit__filter--active');
      activeFilter = btn.dataset.filter;
      renderTable(allLeads);
    });
  });

  // ─── Dados ────────────────────────────────────────────────────────────────
  const LEADS_PAGE_SIZE = 200;

  async function loadLeads() {
    const { data, error } = await client
      .from('leads_diagnostico')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(LEADS_PAGE_SIZE);

    if (error) { console.error(error); return; }

    allLeads = (data || []).map(l => ({ ...l, scoring: score(l.nicho, l.gargalo) }));
    renderKpis(allLeads);
    renderHeatmap(allLeads);
    renderTable(allLeads);
    renderDynamicAlerts(allLeads);
    try { window.OutboundEngine?.init(client, allLeads); } catch (e) { console.warn('OutboundEngine:', e); }
  }

  // ─── War Room Realtime (V15) ──────────────────────────────────────────────
  // Supabase Realtime: novos leads piscam instantaneamente sem reload
  let _realtimeChannel = null;

  function startWarRoom() {
    if (_realtimeChannel) return; // já activo

    injectWarRoomStyles();

    _realtimeChannel = client
      .channel('war-room-leads')
      .on(
        'postgres_changes',
        { event: 'INSERT', schema: 'public', table: 'leads_diagnostico' },
        (payload) => {
          const raw   = payload.new;
          const lead  = { ...raw, scoring: score(raw.nicho, raw.gargalo) };

          // Prepend + cap
          allLeads = [lead, ...allLeads].slice(0, LEADS_PAGE_SIZE);

          // Re-renderizar tudo
          renderKpis(allLeads);
          renderHeatmap(allLeads);
          renderTable(allLeads);
          renderDynamicAlerts(allLeads);

          // Flash de alerta no HUD
          flashWarRoomAlert(lead);

          // Actualizar Outbound Engine com novo lead no topo
          try { window.OutboundEngine?.init(client, allLeads); } catch (e) {}
        }
      )
      .subscribe((status) => {
        updateWarRoomStatus(status);
      });
  }

  function stopWarRoom() {
    if (_realtimeChannel) {
      client.removeChannel(_realtimeChannel);
      _realtimeChannel = null;
    }
  }

  function flashWarRoomAlert(lead) {
    const tier  = lead.scoring?.tier ?? 'FRIO';
    const color = tier === 'VIP' ? '#FF8080' : tier === 'QUENTE' ? '#FFB800' : '#00F0FF';

    const flash = document.createElement('div');
    flash.className = 'wr-flash';
    flash.innerHTML = `
      <span style="font-size:1.1rem;">${tier === 'VIP' ? '🔴' : tier === 'QUENTE' ? '🟡' : '📥'}</span>
      <strong style="color:${color};">NOVO LEAD ${tier}</strong>
      <span style="color:rgba(232,234,240,.7);">${lead.nome || 'Anónimo'} · ${lead.nicho || '—'} · Score ${lead.scoring?.val ?? '?'}</span>
    `;
    document.body.appendChild(flash);

    // Pulsar durante 4s depois remover
    setTimeout(() => flash.classList.add('wr-flash--exit'), 4000);
    setTimeout(() => flash.remove(), 4600);

    // Pulsar dot de status
    const dot = document.getElementById('wr-status-dot');
    if (dot) { dot.classList.add('wr-dot--pulse'); setTimeout(() => dot.classList.remove('wr-dot--pulse'), 1000); }
  }

  function updateWarRoomStatus(status) {
    const indicator = document.getElementById('wr-status-text');
    const dot       = document.getElementById('wr-status-dot');
    if (!indicator) return;

    const states = {
      SUBSCRIBED:    { text: 'WAR ROOM · ONLINE', color: '#00FF88', dotClass: 'wr-dot--green' },
      CHANNEL_ERROR: { text: 'WAR ROOM · ERRO',   color: '#FF8080', dotClass: 'wr-dot--red' },
      TIMED_OUT:     { text: 'WAR ROOM · TIMEOUT', color: '#FFB800', dotClass: 'wr-dot--amber' },
      CLOSED:        { text: 'WAR ROOM · OFFLINE', color: 'rgba(232,234,240,.35)', dotClass: '' },
    };
    const s = states[status] || states.CLOSED;
    indicator.textContent = s.text;
    indicator.style.color = s.color;
    if (dot) { dot.className = 'wr-status-dot ' + s.dotClass; }
  }

  function injectWarRoomStyles() {
    if (document.getElementById('wr-styles')) return;
    const s = document.createElement('style');
    s.id = 'wr-styles';
    s.textContent = `
      .wr-status-dot {
        width:8px;height:8px;border-radius:50%;
        background:rgba(232,234,240,.2);display:inline-block;margin-right:6px;
        transition:background .3s;
      }
      .wr-dot--green { background:#00FF88; box-shadow:0 0 8px rgba(0,255,136,.6); }
      .wr-dot--amber { background:#FFB800; box-shadow:0 0 8px rgba(255,184,0,.6); }
      .wr-dot--red   { background:#FF4444; box-shadow:0 0 8px rgba(255,68,68,.6); }
      @keyframes wr-pulse { 0%,100%{transform:scale(1)} 50%{transform:scale(1.8)} }
      .wr-dot--pulse { animation:wr-pulse .4s ease 2; }

      @keyframes wr-flash-in  { from{opacity:0;transform:translateY(80px) scale(.95)} to{opacity:1;transform:translateY(0) scale(1)} }
      @keyframes wr-flash-out { from{opacity:1;transform:translateY(0)} to{opacity:0;transform:translateY(-20px)} }
      .wr-flash {
        position:fixed;bottom:2rem;right:2rem;z-index:9000;
        background:rgba(8,12,20,.92);
        border:1px solid rgba(0,240,255,.25);
        border-left:3px solid #00F0FF;
        border-radius:10px;
        padding:.875rem 1.25rem;
        display:flex;align-items:center;gap:.75rem;
        font-family:'Inter',sans-serif;font-size:.82rem;
        box-shadow:0 8px 32px rgba(0,0,0,.5);
        animation:wr-flash-in .35s cubic-bezier(.16,1,.3,1) both;
        max-width:400px;
      }
      .wr-flash--exit { animation:wr-flash-out .5s ease both; }
    `;
    document.head.appendChild(s);
  }

  // ─── Dynamic HUD Alerts (V14) ────────────────────────────────────────────
  function renderDynamicAlerts(leads) {
    const existing = document.getElementById('dynamic-alert-bar');
    if (existing) existing.remove();

    const vips    = leads.filter(l => l.scoring.tier === 'VIP');
    const today   = new Date().toISOString().slice(0, 10);
    const todayN  = leads.filter(l => l.created_at?.startsWith(today)).length;
    const avgScore = leads.length
      ? Math.round(leads.reduce((s, l) => s + l.scoring.val, 0) / leads.length)
      : 0;

    const alerts = [];
    if (vips.length > 0)   alerts.push({ color: '#FF8080', bg: 'rgba(255,68,68,0.08)',   icon: '🔴', msg: `${vips.length} lead${vips.length > 1 ? 's' : ''} VIP aguarda${vips.length > 1 ? 'm' : ''} contacto imediato` });
    if (todayN > 5)        alerts.push({ color: '#00FF88', bg: 'rgba(0,255,136,0.08)',   icon: '⚡', msg: `Dia de alta actividade — ${todayN} leads captados hoje` });
    if (avgScore < 50 && leads.length > 5) alerts.push({ color: '#FFB800', bg: 'rgba(255,184,0,0.08)', icon: '📊', msg: `Score médio baixo (${avgScore}/100) — oportunidade de upsell no censo` });

    if (!alerts.length) return;

    const bar = document.createElement('div');
    bar.id = 'dynamic-alert-bar';
    bar.style.cssText = 'margin-bottom:1rem;display:flex;flex-direction:column;gap:.5rem;';

    bar.innerHTML = alerts.map(a => `
      <div style="
        background:${a.bg};border:1px solid ${a.color}33;border-left:3px solid ${a.color};
        border-radius:8px;padding:.625rem 1rem;
        display:flex;align-items:center;gap:.625rem;
        font-size:.78rem;color:${a.color};font-weight:500;
        animation:slideUp .3s ease;">
        <span style="font-size:1rem;">${a.icon}</span>
        ${a.msg}
      </div>
    `).join('');

    const kpiSection = document.getElementById('cockpit-kpis');
    if (kpiSection) kpiSection.after(bar);
  }

  // ─── KPIs ─────────────────────────────────────────────────────────────────
  function renderKpis(leads) {
    const today = new Date().toISOString().slice(0, 10);
    const vips  = leads.filter(l => l.scoring.tier === 'VIP');
    const avg   = leads.length
      ? Math.round(leads.reduce((s, l) => s + l.scoring.val, 0) / leads.length)
      : 0;
    const todayCount = leads.filter(l => l.created_at.startsWith(today)).length;

    document.getElementById('kpi-total').textContent = leads.length;
    document.getElementById('kpi-vip').textContent   = vips.length;
    document.getElementById('kpi-avg').textContent   = avg;
    document.getElementById('kpi-today').textContent = todayCount;
  }

  // ─── Mapa de Calor ────────────────────────────────────────────────────────
  const GARGALO_LABELS = {
    'Dificuldade em escalar a equipa':                   'Escalar Equipa',
    'Falta de visibilidade sobre métricas do negócio':   'Métricas / BI',
    'Captação e retenção de clientes':                   'Captação Clientes',
    'Processos manuais que consomem tempo':              'Processos Manuais',
    'Dependência de ferramentas de terceiros':           'Dependência Tools',
  };

  function renderHeatmap(leads) {
    const counts = {};
    leads.forEach(l => { counts[l.gargalo] = (counts[l.gargalo] ?? 0) + 1; });
    const max = Math.max(1, ...Object.values(counts));

    const container = document.getElementById('heatmap');
    container.innerHTML = Object.entries(GARGALO_LABELS).map(([key, label]) => {
      const count = counts[key] ?? 0;
      const pct   = Math.round((count / max) * 100);
      const heat  = pct >= 75 ? 'hot' : (pct >= 40 ? 'warm' : 'cold');
      return `<div class="heatmap__row">
        <span class="heatmap__label">${label}</span>
        <div class="heatmap__bar-wrap">
          <div class="heatmap__bar heatmap__bar--${heat}" style="width:${pct || 2}%"></div>
        </div>
        <span class="heatmap__count">${count}</span>
      </div>`;
    }).join('');
  }

  // ─── Tabela ───────────────────────────────────────────────────────────────
  const TIER_BADGE = {
    VIP:    '<span class="tier-badge tier-badge--vip">🔴 VIP</span>',
    QUENTE: '<span class="tier-badge tier-badge--quente">🟡 Quente</span>',
    FRIO:   '<span class="tier-badge tier-badge--frio">🔵 Frio</span>',
  };

  function renderTable(leads) {
    const filtered = activeFilter === 'all'
      ? leads
      : leads.filter(l => l.scoring.tier === activeFilter);

    document.getElementById('leads-filter-label').textContent =
      activeFilter === 'all' ? `(${filtered.length})` : `(${filtered.length} ${activeFilter.toLowerCase()}s)`;

    const tbody = document.getElementById('leads-tbody');
    if (!filtered.length) {
      tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;padding:2rem;color:var(--color-gray-400)">Nenhum lead encontrado.</td></tr>';
      return;
    }

    tbody.innerHTML = filtered.map(l => {
      const date = l.created_at.slice(0, 10);
      const waHref = `https://web.whatsapp.com/send/?phone=${l.whatsapp.replace(/\D/g, '')}`;
      const scoreBar = `<div class="score-bar"><div class="score-bar__fill" style="width:${l.scoring.val}%"></div><span>${l.scoring.val}</span></div>`;
      return `<tr>
        <td>${l.nome}</td>
        <td>${l.nicho}</td>
        <td class="gargalo-cell">${l.gargalo}</td>
        <td>${scoreBar}</td>
        <td>${TIER_BADGE[l.scoring.tier]}</td>
        <td>${date}</td>
        <td><a href="${waHref}" target="_blank" class="btn btn--outline btn--sm">💬</a></td>
      </tr>`;
    }).join('');
  }

})();
