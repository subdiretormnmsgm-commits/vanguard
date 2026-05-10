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
    viewLogin.hidden   = true;
    viewCockpit.hidden = false;
    document.getElementById('cockpit-user-email').textContent = email;
    loadLeads();
  }

  function showLogin() {
    viewLogin.hidden   = false;
    viewCockpit.hidden = true;
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
  async function loadLeads() {
    const { data, error } = await client
      .from('leads_diagnostico')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) { console.error(error); return; }

    allLeads = (data || []).map(l => ({ ...l, scoring: score(l.nicho, l.gargalo) }));
    renderKpis(allLeads);
    renderHeatmap(allLeads);
    renderTable(allLeads);
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
