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
    overview: 'Painel de Controlo',
    scraper:  'Motor de Prospecção',
    leads:    'Base de Leads',
    planos:   'Planos e Assinaturas',
  };
  document.getElementById('sectionTitle').textContent = titles[section] || '';

  if (section === 'leads')  loadLeads();
  if (section === 'planos') loadPlanos();
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
