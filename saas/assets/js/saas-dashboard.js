/* ══════════════════════════════════════════════════════════════════
   saas-dashboard.js — Tenant dashboard: KPIs, scraper, leads, plans
   Depends on: saas-auth.js (window.sb, window._token)
═══════════════════════════════════════════════════════════════════ */

// ── State ─────────────────────────────────────────────────────────
let _tenant       = null;
let _allLeads     = [];
let _realtimeSub  = null;
let _leadsPage    = 0;
const PAGE_SIZE   = 20;

// ── Init ──────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  // saas-auth.js starts session check — we hook onAuthStateChange
  // but need a slight delay to ensure _session is set
  sb.auth.onAuthStateChange((event, session) => {
    if (session && !_tenant) {
      window._token = session.access_token;
      loadDashboard();
    }
  });

  // Bind logout
  document.getElementById('btnLogout').addEventListener('click', logout);
});

// ── Navigation ────────────────────────────────────────────────────
function navigate(section) {
  document.querySelectorAll('.nav-item').forEach(el => {
    el.classList.toggle('active', el.dataset.section === section);
  });
  document.querySelectorAll('.section').forEach(el => {
    el.classList.toggle('active', el.id === `section-${section}`);
  });
  const titles = {
    overview:     'Painel de Controlo',
    scraper:      'Motor de Prospecção',
    leads:        'Base de Leads',
    planos:       'Planos e Assinaturas',
    fractal:      'Fractal — White-Label Engine',
    intelligence: 'Intelligence API — Keys',
    arbitrage:    'Mercado de Arbitragem',
    hermes:       'Hermes — Voz & Persona',
  };
  document.getElementById('sectionTitle').textContent = titles[section] || '';

  if (section === 'leads')        loadLeads();
  if (section === 'planos')       loadPlanos();
  if (section === 'fractal')      loadFractalDashboard();
  if (section === 'intelligence') loadApiKeys();
  if (section === 'arbitrage')    loadArbitrageMarket();
  if (section === 'hermes')       loadHermesDashboard();
}

// ── API helper ────────────────────────────────────────────────────
async function apiCall(path, opts = {}) {
  const headers = {
    'Content-Type': 'application/json',
    Authorization: `Bearer ${window._token}`,
    ...(opts.headers || {}),
  };
  const res = await fetch(`${window.VANGUARD_CONFIG?.API_BASE || '/api'}${path}`, {
    ...opts,
    headers,
  });
  if (!res.ok) {
    const body = await res.json().catch(() => ({ detail: res.statusText }));
    throw new Error(body.detail || `HTTP ${res.status}`);
  }
  return res.json();
}

// ── Dashboard master load ─────────────────────────────────────────
async function loadDashboard() {
  try {
    const data = await apiCall('/tenant/me');
    _tenant = data.tenant;
    renderSidebar(_tenant);
    renderKPIs(_tenant);
    loadRecentJobs();
    subscribeRealtime(_tenant.id);
    subscribeIntentionFeed();
  } catch (err) {
    showToast('Erro ao carregar dados: ' + err.message, 'error');
    console.error(err);
  }
}

// ── Sidebar ───────────────────────────────────────────────────────
function renderSidebar(tenant) {
  const badge = document.getElementById('planBadge');
  badge.textContent = tenant.plano.toUpperCase();
  badge.className   = `sidebar__plan-badge plan-${tenant.plano}`;

  const pct = Math.min(100, (tenant.leads_usados / tenant.leads_quota) * 100);
  document.getElementById('quotaLabel').textContent = `${tenant.leads_usados} / ${tenant.leads_quota}`;
  const fill = document.getElementById('quotaFill');
  fill.style.width = `${pct}%`;
  fill.className = 'sidebar__quota-fill' + (pct >= 90 ? ' full' : pct >= 70 ? ' warn' : '');

  const resetDate = new Date(tenant.ciclo_reset_em);
  document.getElementById('quotaReset').textContent = resetDate.toLocaleDateString('pt-PT');

  document.getElementById('userName').textContent  = tenant.nome;
  document.getElementById('userEmail').textContent = tenant.email;
  document.getElementById('userAvatar').textContent = tenant.nome.charAt(0).toUpperCase();
  document.getElementById('leadsCount').textContent = tenant.leads_usados;
}

// ── KPIs ─────────────────────────────────────────────────────────
async function renderKPIs(tenant) {
  // Total leads do tenant
  const { count } = await sb
    .from('leads_diagnostico')
    .select('id', { count: 'exact', head: true });

  // Active jobs
  const { data: jobs } = await sb
    .from('scraper_jobs')
    .select('id, status')
    .eq('tenant_id', tenant.id)
    .in('status', ['queued', 'running']);

  // Score médio (last 50)
  const { data: scored } = await sb
    .from('leads_diagnostico')
    .select('score_digital')
    .not('score_digital', 'is', null)
    .order('created_at', { ascending: false })
    .limit(50);

  const avgScore = scored?.length
    ? (scored.reduce((a, b) => a + (b.score_digital || 0), 0) / scored.length).toFixed(1)
    : '—';

  const restante = Math.max(0, tenant.leads_quota - tenant.leads_usados);

  animateKPI('kpiLeadsTotal', count || 0);
  animateKPI('kpiJobsAtivos', jobs?.length || 0);
  animateKPI('kpiRestante', restante);
  document.getElementById('kpiScoreMedio').textContent = avgScore;

  document.querySelectorAll('.kpi-card').forEach(c => c.classList.remove('skeleton'));
}

function animateKPI(id, target) {
  const el = document.getElementById(id);
  if (!el) return;
  const start = 0;
  const dur   = 800;
  const t0    = performance.now();
  (function tick(now) {
    const p = Math.min(1, (now - t0) / dur);
    el.textContent = Math.round(start + (target - start) * easeOut(p));
    if (p < 1) requestAnimationFrame(tick);
  })(performance.now());
}
const easeOut = t => 1 - Math.pow(1 - t, 3);

// ── Recent Jobs ───────────────────────────────────────────────────
async function loadRecentJobs() {
  try {
    const data = await apiCall('/scraper/jobs?limit=5');
    const jobs = data.jobs || [];
    const container = document.getElementById('recentJobs');
    if (!jobs.length) {
      container.innerHTML = `
        <div class="empty-state">
          <div class="empty-state__icon">◎</div>
          <div class="empty-state__text">Nenhum job ainda.<br>Inicie o seu primeiro scraper!</div>
          <button class="btn-sovereign" style="margin-top:1rem" onclick="navigate('scraper')">Iniciar Scraper</button>
        </div>`;
      return;
    }
    container.innerHTML = jobs.map(renderJobItem).join('');
  } catch (err) {
    console.warn('loadRecentJobs:', err);
  }
}

async function loadActiveJobs() {
  try {
    const data = await apiCall('/scraper/jobs?status=queued,running');
    const jobs = data.jobs || [];
    const container = document.getElementById('activeJobs');
    if (!jobs.length) {
      container.innerHTML = `
        <div class="empty-state">
          <div class="empty-state__icon">◎</div>
          <div class="empty-state__text">Nenhum job activo</div>
        </div>`;
      return;
    }
    container.innerHTML = jobs.map(renderJobItem).join('');
  } catch (err) {
    console.warn('loadActiveJobs:', err);
  }
}

function renderJobItem(job) {
  const statusClass = { queued: 'queued', running: 'running', completed: 'success', failed: 'error', cancelled: 'cancelled' }[job.status] || '';
  const statusLabel = { queued: 'Na fila', running: 'A correr', completed: 'Concluído', failed: 'Falhou', cancelled: 'Cancelado' }[job.status] || job.status;
  const dt = new Date(job.created_at).toLocaleString('pt-PT');
  return `
    <div class="job-item" onclick="openJobDetail('${job.id}')">
      <div class="job-item__info">
        <div class="job-item__title">${esc(job.nicho)} — ${esc(job.cidade)}</div>
        <div class="job-item__meta">${job.modo.toUpperCase()} · ${job.leads_gerados} leads · ${dt}</div>
      </div>
      <div class="job-item__status ${statusClass}">${statusLabel}</div>
    </div>`;
}

// ── Scraper trigger ────────────────────────────────────────────────
async function triggerScraper(e) {
  e.preventDefault();

  if (!_tenant) return showToast('Sessão expirada. Recarregue a página.', 'error');

  const restante = _tenant.leads_quota - _tenant.leads_usados;
  if (restante <= 0) {
    document.getElementById('quotaWarning').style.display = 'block';
    return;
  }

  const payload = {
    nicho:  document.getElementById('scraperNicho').value.trim(),
    cidade: document.getElementById('scraperCidade').value.trim(),
    limite: parseInt(document.getElementById('scraperLimite').value, 10),
    modo:   document.querySelector('input[name="modo"]:checked')?.value || 'osm',
  };

  const btn = document.getElementById('btnScraper');
  btn.disabled = true;
  btn.textContent = '⏳ A disparar...';

  try {
    const res = await apiCall('/scraper/trigger', {
      method: 'POST',
      body:   JSON.stringify(payload),
    });
    showToast(`Job criado! ID: ${res.job_id.slice(0, 8)}…`, 'success');
    loadActiveJobs();
    navigate('scraper');
  } catch (err) {
    showToast('Erro: ' + err.message, 'error');
  } finally {
    btn.disabled = false;
    btn.textContent = '⚡ Disparar Scraper';
  }
}

// ── Leads ─────────────────────────────────────────────────────────
async function loadLeads(search = '') {
  try {
    let query = sb
      .from('leads_diagnostico')
      .select('nome_empresa,nicho,cidade,score_digital,ai_hook,telefone,created_at')
      .order('created_at', { ascending: false })
      .range(_leadsPage * PAGE_SIZE, (_leadsPage + 1) * PAGE_SIZE - 1);

    if (search) query = query.ilike('nome_empresa', `%${search}%`);

    const { data, error } = await query;
    if (error) throw error;
    _allLeads = data || [];
    renderLeadsTable(_allLeads);
  } catch (err) {
    showToast('Erro ao carregar leads: ' + err.message, 'error');
  }
}

function renderLeadsTable(leads) {
  const tbody = document.getElementById('leadsTableBody');
  if (!leads.length) {
    tbody.innerHTML = `<tr><td colspan="7" style="text-align:center;padding:3rem;color:var(--text-muted)">Nenhum lead encontrado</td></tr>`;
    return;
  }
  tbody.innerHTML = leads.map(l => {
    const score    = l.score_digital ?? '—';
    const scoreClass = score >= 7 ? 'high' : score >= 4 ? 'mid' : 'low';
    const dt       = new Date(l.created_at).toLocaleDateString('pt-PT');
    const tel      = l.telefone?.replace(/\D/g,'');
    const waLink   = tel ? `<a class="wa-link" href="https://wa.me/${tel}" target="_blank">↗ WA</a>` : '—';
    const iaHook   = l.ai_hook ? `<span class="ia-badge">IA</span>` : '';
    return `
      <tr>
        <td>${esc(l.nome_empresa || '—')}</td>
        <td>${esc(l.nicho || '—')}</td>
        <td>${esc(l.cidade || '—')}</td>
        <td><span class="score-badge ${scoreClass}">${score}</span></td>
        <td>${iaHook}</td>
        <td>${waLink}</td>
        <td>${dt}</td>
      </tr>`;
  }).join('');
}

function filterLeads(val) {
  _leadsPage = 0;
  loadLeads(val);
}

function exportLeads() {
  if (!_allLeads.length) return showToast('Sem dados para exportar.', 'warning');
  const cols = ['nome_empresa','nicho','cidade','score_digital','telefone','ai_hook','created_at'];
  const rows = [cols.join(','), ..._allLeads.map(l => cols.map(c => `"${(l[c]||'').toString().replace(/"/g,'""')}"`).join(','))];
  const blob = new Blob([rows.join('\n')], { type: 'text/csv' });
  const a    = Object.assign(document.createElement('a'), { href: URL.createObjectURL(blob), download: `leads_vanguard_${Date.now()}.csv` });
  a.click();
}

// ── Planos ────────────────────────────────────────────────────────
async function loadPlanos() {
  try {
    const data = await apiCall('/planos');
    const planos = data.planos || {};
    const grid   = document.getElementById('planGrid');
    const current = _tenant?.plano || 'starter';

    grid.innerHTML = Object.entries(planos).map(([key, plan]) => `
      <div class="plan-card ${key === current ? 'current' : ''}">
        ${key === current ? '<div class="plan-card__badge">Plano actual</div>' : ''}
        <div class="plan-card__name">${key.toUpperCase()}</div>
        <div class="plan-card__price">
          ${plan.preco_mensal ? `R$ ${plan.preco_mensal}<span>/mês</span>` : '<span>Grátis</span>'}
        </div>
        <ul class="plan-card__features">
          <li>✓ ${plan.leads_quota} leads / mês</li>
          <li>✓ Scraper OSM + Places</li>
          <li>✓ Auditor IA (Claude Haiku)</li>
          ${key !== 'starter' ? '<li>✓ Suporte prioritário</li>' : ''}
          ${key === 'enterprise' ? '<li>✓ White-Label incluso</li>' : ''}
        </ul>
        ${key !== current
          ? `<button class="btn-sovereign" onclick="upgradeParaPlano('${key}','${plan.stripe_price_id}')">Fazer upgrade</button>`
          : '<button class="btn-ghost" disabled>Plano actual</button>'
        }
      </div>`).join('');
  } catch (err) {
    showToast('Erro ao carregar planos: ' + err.message, 'error');
  }
}

async function upgradeParaPlano(plano, priceId) {
  try {
    const res = await apiCall('/stripe/checkout', {
      method: 'POST',
      body:   JSON.stringify({ plano }),
    });
    window.location.href = res.checkout_url;
  } catch (err) {
    showToast('Erro ao iniciar checkout: ' + err.message, 'error');
  }
}

async function openPortal() {
  try {
    const res = await apiCall('/stripe/portal', { method: 'POST' });
    window.open(res.portal_url, '_blank');
  } catch (err) {
    showToast('Erro ao abrir portal: ' + err.message, 'error');
  }
}

// ── Realtime ──────────────────────────────────────────────────────
function subscribeRealtime(tenantId) {
  if (_realtimeSub) sb.removeChannel(_realtimeSub);

  _realtimeSub = sb.channel(`jobs-${tenantId}`)
    .on('postgres_changes', {
      event:  '*',
      schema: 'public',
      table:  'scraper_jobs',
      filter: `tenant_id=eq.${tenantId}`,
    }, payload => {
      const job = payload.new || payload.old;
      if (job?.status === 'completed') {
        showToast(`✅ Job concluído! ${job.leads_gerados} leads capturados.`, 'success');
        loadDashboard();
      } else if (job?.status === 'failed') {
        showToast(`❌ Job falhou: ${job.erro_msg || 'erro desconhecido'}`, 'error');
      }
      loadActiveJobs();
      loadRecentJobs();
    })
    .subscribe(status => {
      const dot = document.querySelector('.status-dot');
      if (dot) dot.className = 'status-dot ' + (status === 'SUBSCRIBED' ? 'online' : 'offline');
    });
}

// ── Job detail modal ──────────────────────────────────────────────
async function openJobDetail(jobId) {
  try {
    const data = await apiCall(`/scraper/jobs/${jobId}`);
    const job  = data.job;
    document.getElementById('modalTitle').textContent = `Job — ${job.nicho} / ${job.cidade}`;
    document.getElementById('modalBody').innerHTML = `
      <dl class="modal-dl">
        <dt>ID</dt><dd><code>${job.id}</code></dd>
        <dt>Status</dt><dd>${job.status}</dd>
        <dt>Modo</dt><dd>${job.modo.toUpperCase()}</dd>
        <dt>Leads gerados</dt><dd>${job.leads_gerados}</dd>
        <dt>Iniciado em</dt><dd>${job.iniciado_em ? new Date(job.iniciado_em).toLocaleString('pt-PT') : '—'}</dd>
        <dt>Concluído em</dt><dd>${job.concluido_em ? new Date(job.concluido_em).toLocaleString('pt-PT') : '—'}</dd>
        ${job.erro_msg ? `<dt>Erro</dt><dd style="color:#f87171">${esc(job.erro_msg)}</dd>` : ''}
      </dl>`;
    document.getElementById('modalBackdrop').classList.add('show');
  } catch (err) {
    showToast('Erro ao carregar job: ' + err.message, 'error');
  }
}

function closeModal() {
  document.getElementById('modalBackdrop').classList.remove('show');
}

// ── Toast ─────────────────────────────────────────────────────────
function showToast(msg, type = 'info') {
  const container = document.getElementById('toastContainer');
  const toast = document.createElement('div');
  toast.className = `toast toast--${type}`;
  toast.textContent = msg;
  container.appendChild(toast);
  setTimeout(() => toast.classList.add('show'), 10);
  setTimeout(() => {
    toast.classList.remove('show');
    setTimeout(() => toast.remove(), 300);
  }, 4500);
}

// ── Utils ─────────────────────────────────────────────────────────
function esc(str) {
  return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

// ═════════════════════════════════════════════════════════════════
// V8: Feed de Intenção (Realtime intention_webhooks)
// ═════════════════════════════════════════════════════════════════

const FEED_MAX = 30;
let _intentionSub = null;

function subscribeIntentionFeed() {
  if (_intentionSub) return;
  _intentionSub = sb
    .channel('intention-feed')
    .on('postgres_changes', {
      event:  'INSERT',
      schema: 'public',
      table:  'intention_webhooks',
    }, (payload) => {
      renderIntentionEvent(payload.new);
    })
    .subscribe();
}

function renderIntentionEvent(ev) {
  const feed = document.getElementById('intentionFeed');
  if (!feed) return;

  const empty = feed.querySelector('.intention-feed__empty');
  if (empty) empty.remove();

  const typeLabels = {
    view:           'view',
    preview:        'preview',
    subscribed:     'subscribed',
    scraper_ran:    'scraper',
    checkout_start: 'checkout',
    add_to_cart:    'cart',
  };

  const label  = typeLabels[ev.evento] || ev.evento;
  const ts     = new Date(ev.created_at);
  const timeAgo = _timeAgo(ts);

  const item = document.createElement('div');
  item.className = 'intention-event';
  item.innerHTML = `
    <span class="intention-event__type ev-${ev.evento}">${label}</span>
    <span class="intention-event__info">
      <strong>${esc(ev.nicho || ev.pack_id?.slice(0,8) || '—')}</strong>
      ${ev.cidade ? `· ${esc(ev.cidade)}` : ''}
      ${ev.tenant_id ? `· tenant ${ev.tenant_id.slice(0,6)}` : '· anónimo'}
    </span>
    <span class="intention-event__time">${timeAgo}</span>`;

  feed.insertBefore(item, feed.firstChild);

  // Limitar tamanho do feed
  const items = feed.querySelectorAll('.intention-event');
  if (items.length > FEED_MAX) items[items.length - 1].remove();
}

function _timeAgo(date) {
  const secs = Math.floor((Date.now() - date) / 1000);
  if (secs < 10)  return 'agora';
  if (secs < 60)  return `${secs}s`;
  if (secs < 3600) return `${Math.floor(secs / 60)}m`;
  return `${Math.floor(secs / 3600)}h`;
}

// ═════════════════════════════════════════════════════════════════
// V8: Fractal White-Label
// ═════════════════════════════════════════════════════════════════

async function loadFractalDashboard() {
  try {
    const data = await apiCall('/fractal/dashboard');

    document.getElementById('fractalSubsActivos').textContent  = data.sub_tenants.ativos;
    document.getElementById('fractalQuotaCedida').textContent  = data.quota.cedido_subs;
    document.getElementById('fractalMRR').textContent          = `€${data.receita_mensal_mrr.toFixed(0)}`;
    document.getElementById('fractalLeadsGerados').textContent = data.leads_gerados_total;

    renderSubTenants(data.sub_tenants_lista || []);
  } catch (err) {
    const grid = document.getElementById('fractalSubsList');
    if (grid) grid.innerHTML = `<p style="color:var(--red);font-size:.85rem">Requer plano Pro ou Enterprise.</p>`;
  }
}

function renderSubTenants(subs) {
  const grid = document.getElementById('fractalSubsList');
  if (!grid) return;

  if (!subs.length) {
    grid.innerHTML = `<div class="empty-state">
      <div class="empty-state__icon">⬡</div>
      <div class="empty-state__text">Nenhum sub-tenant ainda.<br>Crie o primeiro revendedor.</div>
    </div>`;
    return;
  }

  grid.innerHTML = subs.map(sub => {
    const pct = Math.round(sub.leads_usados / Math.max(sub.leads_quota, 1) * 100);
    const brand = sub.brand_config || {};
    return `
    <div class="sub-tenant-card" style="--brand-primary: ${brand.primary || 'var(--cyan)'}">
      <div class="sub-tenant-card__header">
        <div>
          <div class="sub-tenant-card__name">${esc(sub.nome)}</div>
          <div class="sub-tenant-card__email">${esc(sub.email)}</div>
        </div>
        <span class="sub-tenant-card__status ${sub.ativo ? 'status-active' : 'status-inactive'}">
          ${sub.ativo ? 'ATIVO' : 'INATIVO'}
        </span>
      </div>
      <div class="sub-tenant-card__quota-bar">
        <div class="sub-tenant-card__quota-fill" style="width:${pct}%"></div>
      </div>
      <div style="font-size:.72rem;color:var(--text-secondary);margin-bottom:.5rem">
        ${sub.leads_usados}/${sub.leads_quota} leads · ${pct}% usado
      </div>
      <div class="sub-tenant-card__stats">
        <div>
          <div class="sub-tenant-card__stat-label">MRR</div>
          <div class="sub-tenant-card__stat-value">€${(sub.preco_cobrado||0).toFixed(0)}</div>
        </div>
        <div>
          <div class="sub-tenant-card__stat-label">Criado</div>
          <div class="sub-tenant-card__stat-value">${new Date(sub.created_at).toLocaleDateString('pt-PT')}</div>
        </div>
      </div>
      <div style="display:flex;gap:.5rem;margin-top:1rem">
        <button class="btn-ghost" style="flex:1;font-size:.72rem" onclick="editarBrandSubTenant('${sub.id}')">
          🎨 Brand
        </button>
        <button class="btn-ghost" style="flex:1;font-size:.72rem;border-color:var(--red);color:var(--red)"
          onclick="desactivarSubTenant('${sub.id}')">
          ✕ Desactivar
        </button>
      </div>
    </div>`;
  }).join('');
}

function abrirModalCriarSubTenant() {
  document.getElementById('modalFractalBackdrop').style.display = 'flex';
}

function fecharModalFractal() {
  document.getElementById('modalFractalBackdrop').style.display = 'none';
}

async function submeterSubTenant(ev) {
  ev.preventDefault();
  const payload = {
    nome:          document.getElementById('ftNome').value,
    email:         document.getElementById('ftEmail').value,
    leads_quota:   +document.getElementById('ftQuota').value,
    preco_cobrado: +document.getElementById('ftPreco').value,
    brand_config: {
      nome:      document.getElementById('ftNome').value,
      primary:   document.getElementById('ftPrimary').value,
      secondary: document.getElementById('ftSecondary').value,
      accent:    document.getElementById('ftAccent').value,
      bg:        '#0A0A0A',
      logo_url:  '',
    },
  };

  try {
    await apiCall('/fractal/sub-tenants', { method: 'POST', body: JSON.stringify(payload) });
    showToast('Sub-tenant criado com sucesso!', 'success');
    fecharModalFractal();
    loadFractalDashboard();
  } catch (err) {
    showToast('Erro: ' + err.message, 'error');
  }
}

async function desactivarSubTenant(id) {
  if (!confirm('Desactivar este sub-tenant?')) return;
  try {
    await apiCall(`/fractal/sub-tenants/${id}`, { method: 'DELETE' });
    showToast('Sub-tenant desactivado.', 'success');
    loadFractalDashboard();
  } catch (err) {
    showToast('Erro: ' + err.message, 'error');
  }
}

function editarBrandSubTenant(id) {
  showToast('Brand editor em breve — use a API PATCH /fractal/sub-tenants/' + id + '/brand', 'info');
}

// ═════════════════════════════════════════════════════════════════
// V8: Intelligence API Keys
// ═════════════════════════════════════════════════════════════════

async function loadApiKeys() {
  try {
    const { data, error } = await sb
      .from('api_keys')
      .select('id,key_prefix,nome,plano,requests_mes,limite_mes,ativo,created_at')
      .order('created_at', { ascending: false });

    if (error) throw new Error(error.message);
    renderApiKeys(data || []);
  } catch (err) {
    console.error('API keys:', err);
  }
}

function renderApiKeys(keys) {
  const list = document.getElementById('apiKeysList');
  if (!list) return;

  if (!keys.length) {
    list.innerHTML = `<div class="empty-state">
      <div class="empty-state__icon">◈</div>
      <div class="empty-state__text">Nenhuma API key criada.<br>Crie a sua primeira key acima.</div>
    </div>`;
    return;
  }

  list.innerHTML = keys.map(k => `
    <div class="api-key-row">
      <div>
        <div class="api-key-row__prefix">${esc(k.key_prefix)}_••••••••</div>
        <div class="api-key-row__name">${esc(k.nome)}</div>
      </div>
      <span class="api-key-row__plano plano-${k.plano}">${k.plano.toUpperCase()}</span>
      <span class="api-key-row__quota">${k.requests_mes} / ${k.limite_mes}</span>
      <button class="btn-ghost" style="font-size:.72rem;color:var(--red);border-color:var(--red)"
        onclick="revogarApiKey('${k.id}')">Revogar</button>
    </div>`).join('');
}

async function criarApiKey() {
  const nome = prompt('Nome da API key (ex: Produção, Teste):');
  if (!nome || !nome.trim()) return;

  try {
    const { data: { user } } = await sb.auth.getUser();
    const prefix  = 'vng_live_' + Math.random().toString(36).slice(2,10);
    const token   = crypto.randomUUID().replace(/-/g,'');
    const fullKey = `${prefix}_${token}`;

    const encoder = new TextEncoder();
    const hashBuf = await crypto.subtle.digest('SHA-256', encoder.encode(fullKey));
    const keyHash = Array.from(new Uint8Array(hashBuf)).map(b => b.toString(16).padStart(2,'0')).join('');

    const { error } = await sb.from('api_keys').insert({
      user_id:    user.id,
      nome:       nome.trim(),
      key_hash:   keyHash,
      key_prefix: prefix,
      plano:      _tenant?.plano === 'enterprise' ? 'pro' : 'free',
    });

    if (error) throw new Error(error.message);

    alert(`✅ API Key gerada (guarde-a agora — não será mostrada novamente):\n\n${fullKey}`);
    loadApiKeys();
  } catch (err) {
    showToast('Erro ao criar key: ' + err.message, 'error');
  }
}

async function revogarApiKey(id) {
  if (!confirm('Revogar esta API key? Não poderá ser recuperada.')) return;
  await sb.from('api_keys').update({ ativo: false }).eq('id', id);
  showToast('API key revogada.', 'success');
  loadApiKeys();
}

// ═══════════════════════════════════════════════════════════════════════════
// V9 — ARBITRAGEM
// ═══════════════════════════════════════════════════════════════════════════

async function loadArbitrageMarket() {
  const nicho  = document.getElementById('arbFiltroNicho')?.value  || '';
  const modelo = document.getElementById('arbFiltroModelo')?.value || '';
  const grid   = document.getElementById('arbitrageMarket');
  if (!grid) return;
  grid.innerHTML = '<div style="color:var(--text-muted);text-align:center;padding:2rem;grid-column:1/-1">A carregar...</div>';

  try {
    const params = new URLSearchParams({ limite: 20 });
    if (nicho)  params.set('nicho', nicho);
    if (modelo) params.set('modelo', modelo);
    const data = await apiCall('/arbitrage/market?' + params.toString());
    const listings = data.listings || [];

    // KPIs
    const mine = data.minhas_listagens || [];
    const totalRec = mine.reduce((s, l) => s + (l.preco_pago || 0), 0);
    document.getElementById('arbListings').textContent  = listings.length;
    document.getElementById('arbAuctions').textContent  = listings.filter(l => l.modelo === 'leilao').length;
    document.getElementById('arbRevenue').textContent   = `€${totalRec.toFixed(2)}`;
    document.getElementById('arbSold').textContent      = mine.filter(l => l.status === 'sold').length;

    if (!listings.length) {
      grid.innerHTML = '<div style="color:var(--text-muted);text-align:center;padding:2rem;grid-column:1/-1">Sem listagens activas neste momento.</div>';
      return;
    }
    grid.innerHTML = listings.map(renderMarketCard).join('');

    // Minhas listagens
    const myGrid = document.getElementById('myListings');
    if (myGrid) myGrid.innerHTML = mine.length ? mine.map(renderMarketCard).join('') : '<div style="color:var(--text-muted);text-align:center;padding:1.5rem">Sem listagens activas.</div>';
  } catch (e) {
    grid.innerHTML = `<div style="color:var(--text-muted);text-align:center;padding:2rem;grid-column:1/-1">Erro: ${esc(e.message)}</div>`;
  }
}

function renderMarketCard(l) {
  const isAuction = l.modelo === 'leilao';
  const expiry = l.horas_restantes != null ? `${l.horas_restantes}h restantes` : '';
  return `<div class="market-card market-card--${isAuction ? 'auction' : 'fixo'}">
    <div class="market-card__header">
      <span class="market-card__nicho">${esc(l.preview_nicho || '—')}</span>
      <span class="market-card__tipo">${isAuction ? '⚖ LEILÃO' : '◆ FIXO'}</span>
    </div>
    <div class="market-card__cidade">${esc(l.preview_cidade || '—')}</div>
    <div style="display:flex;align-items:baseline;gap:.4rem">
      <span class="market-card__score">${l.preview_score?.toFixed(1) ?? '—'}</span>
      <span class="market-card__score-label">SCORE</span>
    </div>
    ${l.preview_gargalo ? `<div class="market-card__gargalo">${esc(l.preview_gargalo)}</div>` : ''}
    <div class="market-card__bid">
      <div>
        <div class="market-card__bid-label">${isAuction ? 'Lance actual' : 'Preço fixo'}</div>
        <div class="market-card__bid-val">€${(l.maior_lance || l.preco_fixo || l.preco_base || 0).toFixed(2)}</div>
      </div>
      ${expiry ? `<span class="market-card__time">⏱ ${esc(expiry)}</span>` : ''}
    </div>
    <div class="market-card__actions">
      ${isAuction
        ? `<button class="btn-bid" onclick="fazerLance('${l.id}', ${l.maior_lance || l.preco_base || 0})">Licitar</button>`
        : `<button class="btn-buy" onclick="comprarDirecto('${l.id}')">Comprar €${(l.preco_fixo || 0).toFixed(2)}</button>`
      }
    </div>
  </div>`;
}

async function fazerLance(listingId, lanceActual) {
  const minLance = +(lanceActual + 0.50).toFixed(2);
  const valor = parseFloat(prompt(`Lance mínimo: €${minLance.toFixed(2)}\nInsira o seu lance (€):`));
  if (isNaN(valor)) return;
  if (valor < minLance) { showToast(`Lance mínimo: €${minLance.toFixed(2)}`, 'error'); return; }
  try {
    await apiCall(`/arbitrage/listings/${listingId}/bid`, {
      method: 'POST', body: JSON.stringify({ valor }),
    });
    showToast('Lance registado com sucesso!', 'success');
    loadArbitrageMarket();
  } catch (e) { showToast('Erro: ' + e.message, 'error'); }
}

async function comprarDirecto(listingId) {
  if (!confirm('Confirmar compra directa? Será redirecionado para pagamento Stripe.')) return;
  try {
    const data = await apiCall(`/arbitrage/listings/${listingId}/buy`, { method: 'POST' });
    if (data.checkout_url) window.open(data.checkout_url, '_blank');
  } catch (e) { showToast('Erro: ' + e.message, 'error'); }
}

async function abrirModalListarLead() {
  const { data: leads } = await sb.from('leads_diagnostico')
    .select('id,empresa_nome,score_digital,nicho')
    .order('created_at', { ascending: false })
    .limit(30);
  if (!leads?.length) { showToast('Sem leads disponíveis para listar.', 'error'); return; }

  const opcoes = leads.map(l => `${l.id.slice(0,8)} — ${l.empresa_nome || '?'} (score ${l.score_digital?.toFixed(1) || '?'})`).join('\n');
  const escolha = prompt(`Selecione o índice do lead (0-${leads.length-1}):\n\n${leads.map((l,i) => i + ': ' + (l.empresa_nome || l.id.slice(0,8))).join('\n')}`);
  const idx = parseInt(escolha, 10);
  if (isNaN(idx) || idx < 0 || idx >= leads.length) return;

  const lead = leads[idx];
  const modelo = prompt('Modelo: "leilao" ou "fixo"?', 'leilao');
  if (!['leilao','fixo'].includes(modelo)) return;
  const preco_base = parseFloat(prompt('Preço base (€):', '10.00'));
  const preco_fixo = modelo === 'fixo' ? parseFloat(prompt('Preço fixo (€):', '50.00')) : undefined;
  const duracao_horas = parseInt(prompt('Duração (horas, 1-168):', '48'), 10);

  try {
    await apiCall('/arbitrage/listings', {
      method: 'POST',
      body: JSON.stringify({ lead_id: lead.id, modelo, preco_base, preco_fixo, duracao_horas }),
    });
    showToast('Lead listado no mercado!', 'success');
    loadArbitrageMarket();
  } catch (e) { showToast('Erro: ' + e.message, 'error'); }
}

// ═══════════════════════════════════════════════════════════════════════════
// V9 — HERMES VOICE
// ═══════════════════════════════════════════════════════════════════════════

async function loadHermesDashboard() {
  try {
    const [perfData, varData, callData] = await Promise.all([
      apiCall('/hermes/persona'),
      apiCall('/hermes/variantes').catch(() => ({ variantes: [] })),
      sb.from('hermes_voice_calls').select('*').order('created_at', { ascending: false }).limit(20),
    ]);

    const persona = perfData?.persona || {};
    document.getElementById('hTom').textContent      = persona.tom || '—';
    document.getElementById('hTaxaResp').textContent = persona.taxa_resposta ? persona.taxa_resposta.toFixed(1) + '%' : '—';
    document.getElementById('hChamadas').textContent = callData?.data?.length || 0;

    renderHermesVariantes(varData?.variantes || []);
    renderVoiceLog(callData?.data || []);
  } catch (e) {
    console.error('Hermes dashboard:', e);
  }
}

function renderHermesVariantes(variantes) {
  const el = document.getElementById('hermesVariantes');
  if (!el) return;
  if (!variantes.length) {
    el.innerHTML = '<div style="color:var(--text-muted);font-size:.9rem;text-align:center;padding:1.5rem">Sem variantes criadas. Crie a primeira!</div>';
    return;
  }
  el.innerHTML = variantes.map(v => `
    <div class="variante-row ${v.is_winner ? 'variante-row--winner' : ''}">
      <span class="variante-nome">${esc(v.nome)}</span>
      <span class="variante-taxa">${v.taxa_resposta != null ? v.taxa_resposta.toFixed(1) + '%' : '—'}</span>
      <span class="variante-canal">${esc(v.canal)}</span>
      ${v.is_winner ? '<span class="variante-winner-badge">WINNER</span>' : '<span></span>'}
      <button class="btn-ghost" style="font-size:.7rem;padding:.25rem .6rem" onclick="removerVariante('${v.id}')">✕</button>
    </div>`).join('');
}

function renderVoiceLog(calls) {
  const el = document.getElementById('voiceLog');
  if (!el) return;
  if (!calls.length) {
    el.innerHTML = '<div style="color:var(--text-muted);font-size:.9rem;text-align:center;padding:1.5rem">Sem chamadas registadas.</div>';
    return;
  }
  el.innerHTML = calls.map(c => {
    const outcomeClass = c.outcome ? `voice-outcome--${c.outcome}` : '';
    const dur = c.duracao_seg ? `${Math.floor(c.duracao_seg/60)}m${c.duracao_seg%60}s` : '—';
    return `<div class="voice-row">
      <span class="voice-row__num">${esc(c.numero_destino || '—')}</span>
      <span class="voice-row__dur">${dur}</span>
      <span class="voice-outcome ${outcomeClass}">${esc(c.outcome || c.status || '—')}</span>
      <span style="font-family:var(--ff-mono);font-size:.65rem;color:var(--text-muted)">${esc(c.provider || 'vapi')}</span>
      <span style="font-size:.75rem;color:var(--text-muted);overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${esc(c.proximo_passo || c.analise_claude || '')}</span>
    </div>`;
  }).join('');
}

async function analisarPersona() {
  showToast('A analisar padrões com Claude Haiku...', 'info');
  try {
    const data = await apiCall('/hermes/persona/analisar', { method: 'POST' });
    showToast('Persona actualizada: ' + (data.persona?.insight || 'OK'), 'success');
    loadHermesDashboard();
  } catch (e) { showToast('Erro: ' + e.message, 'error'); }
}

async function abrirModalVariante() {
  const nome     = prompt('Nome da variante (ex: "Abordagem Urgente"):');
  if (!nome) return;
  const template = prompt('Template (use {nome}, {cidade}, {gargalo}, {ai_hook}):',
    'Olá {nome}! Detectámos que {gargalo} está a custar-lhe clientes em {cidade}. {ai_hook} Posso ajudar?');
  if (!template) return;
  const canal = prompt('Canal (whatsapp/voice/email):', 'whatsapp');
  try {
    await apiCall('/hermes/variantes', {
      method: 'POST',
      body: JSON.stringify({ nome, template, canal: canal || 'whatsapp' }),
    });
    showToast('Variante criada!', 'success');
    loadHermesDashboard();
  } catch (e) { showToast('Erro: ' + e.message, 'error'); }
}

async function removerVariante(id) {
  if (!confirm('Eliminar esta variante?')) return;
  await sb.from('hermes_variants').delete().eq('id', id);
  showToast('Variante eliminada.', 'success');
  loadHermesDashboard();
}
