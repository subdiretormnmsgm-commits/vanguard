/* ══════════════════════════════════════════════════════════════════
   creator.js — Painel do Criador: onboard + pack CRUD + Stripe
════════════════════════════════════════════════════════════════════ */

const API    = window.VANGUARD_CONFIG?.API_BASE || '/api';
const SB_URL = window.VANGUARD_CONFIG?.SUPABASE_URL || '';
const SB_KEY = window.VANGUARD_CONFIG?.SUPABASE_ANON_KEY || '';

let _token   = null;
let _creator = null;
let _packEditId = null;

// ── Init ──────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  initCursor();
  checkSession();
  tratarQueryParams();
});

function initCursor() {
  const cur  = document.getElementById('cursor');
  const ring = document.getElementById('cursorRing');
  if (!cur || !ring) return;
  let rx = 0, ry = 0;
  document.addEventListener('mousemove', e => {
    cur.style.left  = e.clientX + 'px';
    cur.style.top   = e.clientY + 'px';
    rx += (e.clientX - rx) * .14;
    ry += (e.clientY - ry) * .14;
    ring.style.left = rx + 'px';
    ring.style.top  = ry + 'px';
  });
}

async function checkSession() {
  if (!SB_URL || !SB_KEY) {
    mostrarOnboarding();
    return;
  }
  const sb = supabase.createClient(SB_URL, SB_KEY);
  const { data: { session } } = await sb.auth.getSession();
  if (!session) {
    window.location.href = '/saas/?next=/marketplace/creator.html';
    return;
  }
  _token = session.access_token;
  document.getElementById('btnLogout').addEventListener('click', async () => {
    await sb.auth.signOut();
    window.location.href = '/saas/';
  });
  await carregarCreator();
}

// ── Query params ──────────────────────────────────────────────────
function tratarQueryParams() {
  const p = new URLSearchParams(location.search);
  if (p.get('onboarded') === '1') toast('✅ Stripe Connect configurado com sucesso!', 'success');
  if (p.get('refresh')   === '1') toast('Complete o onboarding Stripe para receber pagamentos.', 'info');
}

// ── Carregar criador ──────────────────────────────────────────────
async function carregarCreator() {
  try {
    const res  = await apiCall('/marketplace/creator/me');
    _creator   = res.creator;
    mostrarDashboard();
    renderSidebar(_creator);
    renderMeusPacks(_creator.packs || []);
  } catch (err) {
    if (err.message.includes('404') || err.message.includes('não encontrado')) {
      mostrarOnboarding();
    } else {
      toast('Erro ao carregar perfil: ' + err.message, 'error');
      mostrarOnboarding();
    }
  }
}

function mostrarOnboarding() {
  document.getElementById('onboardingWrap').style.display = 'block';
  document.getElementById('creatorDash').style.display    = 'none';
}
function mostrarDashboard() {
  document.getElementById('onboardingWrap').style.display = 'none';
  document.getElementById('creatorDash').style.display    = 'block';
}

// ── Sidebar ───────────────────────────────────────────────────────
function renderSidebar(creator) {
  document.getElementById('creatorAvatar').textContent = (creator.nome||'C').charAt(0).toUpperCase();
  document.getElementById('creatorNome').textContent   = creator.nome || 'Criador';

  const stripeEl = document.getElementById('stripeStatus');
  const alertEl  = document.getElementById('stripeAlert');
  if (creator.stripe_onboarded) {
    stripeEl.innerHTML = '<span class="badge badge-green">Stripe conectado ✓</span>';
    alertEl.style.display = 'none';
  } else {
    stripeEl.innerHTML = '<span class="badge badge-grey">Stripe pendente</span>';
    alertEl.style.display = 'block';
  }

  document.getElementById('kpiPacks').textContent   = creator.packs_publicados || 0;
  document.getElementById('kpiSubs').textContent    = creator.assinantes_total || 0;
  document.getElementById('kpiReceita').textContent = `R$ ${(creator.receita_total || 0).toFixed(2)}`;

  // Perfil form
  document.getElementById('perfilNome').value = creator.nome || '';
  document.getElementById('perfilBio').value  = creator.bio  || '';
  if (creator.especialidade) {
    const sel = document.getElementById('perfilEspecialidade');
    if (sel) sel.value = creator.especialidade;
  }
}

// ── Meus Packs ────────────────────────────────────────────────────
function renderMeusPacks(packs) {
  const list = document.getElementById('meusPacksList');
  if (!packs.length) {
    list.innerHTML = `<div style="padding:3rem;text-align:center;color:var(--text-3)">
      <div style="font-size:2.5rem;margin-bottom:1rem">📦</div>
      <p>Ainda não tem nenhum pack.</p>
      <button class="btn btn-primary btn-sm" style="margin-top:1rem" onclick="navCreator('novo-pack')">Criar Primeiro Pack</button>
    </div>`;
    return;
  }

  list.innerHTML = packs.map(p => {
    const statusClass = `status-${p.status}`;
    const statusLabel = { draft:'Rascunho', review:'Em Revisão', active:'Activo', paused:'Pausado', archived:'Arquivado' }[p.status] || p.status;
    return `
      <div style="background:var(--bg-2);border:1px solid var(--border);border-radius:var(--r);padding:1.25rem 1.5rem;margin-bottom:.75rem;display:flex;align-items:center;gap:1.5rem">
        <span style="font-size:1.75rem">${p.cover_emoji || '📦'}</span>
        <div style="flex:1">
          <div style="font-family:var(--font-display);font-size:1.1rem;font-weight:600;color:var(--text)">${esc(p.nome)}</div>
          <div style="font-size:.8rem;color:var(--text-3);margin-top:.2rem">${(p.nicho||'').toUpperCase()} · ${p.assinantes||0} subscritores</div>
        </div>
        <span class="badge ${statusClass}" style="font-family:var(--font-mono);font-size:.7rem">${statusLabel}</span>
        <div style="display:flex;gap:.5rem">
          ${p.status === 'draft' ? `<button class="btn btn-primary btn-sm" onclick="abrirModalPublicar('${p.id}')">Publicar</button>` : ''}
          <button class="btn btn-ghost btn-sm" onclick="editarPack('${p.id}')">Editar</button>
        </div>
      </div>`;
  }).join('');
}

// ── Criar/Actualizar Pack ─────────────────────────────────────────
async function submeterPack(e) {
  e.preventDefault();
  const btn = document.getElementById('btnSubmitPack');
  btn.disabled = true;
  btn.textContent = 'A guardar...';

  const tags = document.getElementById('packTags').value
    .split(',').map(t => t.trim()).filter(Boolean);

  const payload = {
    nome:          document.getElementById('packNome').value.trim(),
    descricao:     document.getElementById('packDescricao').value.trim(),
    nicho:         document.getElementById('packNicho').value,
    cidade_alvo:   document.getElementById('packCidade').value.trim() || null,
    preco_mensal:  parseFloat(document.getElementById('packPreco').value) || 97,
    leads_tipicos: parseInt(document.getElementById('packLeads').value) || 50,
    cover_emoji:   document.getElementById('packEmoji').value.trim() || '📦',
    tags,
    config_osm: {
      query:   document.getElementById('packOsmQuery').value.trim(),
      raio_km: parseInt(document.getElementById('packOsmRaio').value) || 10,
    },
    config_prompts: {
      persona:       document.getElementById('packPersona').value.trim(),
      hook_template: document.getElementById('packHookTemplate').value.trim(),
    },
  };

  try {
    if (_packEditId) {
      await apiCall(`/marketplace/creator/packs/${_packEditId}`, { method: 'PUT', body: JSON.stringify(payload) });
      toast('Pack actualizado!', 'success');
    } else {
      await apiCall('/marketplace/creator/packs', { method: 'POST', body: JSON.stringify(payload) });
      toast('Pack criado em modo rascunho!', 'success');
    }
    _packEditId = null;
    await carregarCreator();
    navCreator('meus-packs');
  } catch (err) {
    toast('Erro: ' + err.message, 'error');
  } finally {
    btn.disabled  = false;
    btn.textContent = 'Guardar Rascunho';
  }
}

function editarPack(packId) {
  // Encontra o pack na lista já carregada
  const pack = (_creator?.packs || []).find(p => p.id === packId);
  if (!pack) return;
  _packEditId = packId;
  document.getElementById('packNome').value     = pack.nome || '';
  document.getElementById('packNicho').value    = pack.nicho || '';
  document.getElementById('packCidade').value   = pack.cidade_alvo || '';
  document.getElementById('packPreco').value    = pack.preco_mensal || 97;
  document.getElementById('packLeads').value    = pack.leads_tipicos || 50;
  document.getElementById('packEmoji').value    = pack.cover_emoji || '📦';
  document.getElementById('packTags').value     = (pack.tags||[]).join(', ');
  document.getElementById('btnSubmitPack').textContent = 'Actualizar Pack';
  navCreator('novo-pack');
}

// ── Publicar Pack ─────────────────────────────────────────────────
let _publishPackId = null;
function abrirModalPublicar(packId) {
  _publishPackId = packId;
  openModal('modalPublicar');
  document.getElementById('btnConfirmarPublicar').onclick = confirmarPublicar;
}

async function confirmarPublicar() {
  if (!_publishPackId) return;
  const btn = document.getElementById('btnConfirmarPublicar');
  btn.disabled = true;
  btn.textContent = 'A publicar...';
  try {
    const res = await apiCall(`/marketplace/creator/packs/${_publishPackId}/publish`, { method: 'POST' });
    toast('Pack enviado para revisão! Publicado em até 24h.', 'success');
    fecharModal('modalPublicar');
    await carregarCreator();
  } catch (err) {
    toast('Erro: ' + err.message, 'error');
  } finally {
    btn.disabled = false;
    btn.textContent = 'Confirmar Publicação';
    _publishPackId = null;
  }
}

// ── Onboard ───────────────────────────────────────────────────────
async function iniciarOnboard() {
  if (!_token) {
    window.location.href = '/saas/?next=/marketplace/creator.html';
    return;
  }
  const btn = document.getElementById('btnOnboard');
  btn.disabled = true;
  btn.textContent = 'A criar perfil...';

  try {
    const res = await apiCall('/marketplace/creator/onboard', {
      method: 'POST',
      body: JSON.stringify({
        nome:          document.getElementById('onbNome').value.trim(),
        bio:           document.getElementById('onbBio').value.trim() || null,
        especialidade: document.getElementById('onbEspecialidade').value || null,
      }),
    });
    if (res.onboarding_url) {
      toast('Perfil criado! A redirigir para o Stripe...', 'success');
      setTimeout(() => { window.location.href = res.onboarding_url; }, 1200);
    } else {
      toast('Perfil criado! Configure o Stripe para receber pagamentos.', 'info');
      await carregarCreator();
    }
  } catch (err) {
    toast('Erro: ' + err.message, 'error');
    btn.disabled    = false;
    btn.textContent = 'Criar Perfil + Conectar Stripe →';
  }
}

async function reconectarStripe() {
  try {
    const res = await apiCall('/marketplace/creator/onboard', {
      method: 'POST',
      body: JSON.stringify({ nome: _creator?.nome || 'Criador' }),
    });
    if (res.onboarding_url) window.location.href = res.onboarding_url;
  } catch (err) {
    toast('Erro: ' + err.message, 'error');
  }
}

function abrirStripeDash() {
  toast('A abrir painel Stripe...', 'info');
  window.open('https://dashboard.stripe.com', '_blank');
}

// ── Perfil ────────────────────────────────────────────────────────
async function actualizarPerfil(e) {
  e.preventDefault();
  toast('Funcionalidade de actualização de perfil em breve.', 'info');
}

// ── Navigation ────────────────────────────────────────────────────
function navCreator(section) {
  document.querySelectorAll('.creator-nav__item').forEach(el => {
    el.classList.toggle('active', el.dataset.section === section);
  });
  document.querySelectorAll('.creator-section').forEach(el => {
    el.classList.toggle('active', el.id === `section-${section}`);
  });
  if (section !== 'novo-pack') _packEditId = null;
}

// ── API helper ────────────────────────────────────────────────────
async function apiCall(path, opts = {}) {
  const res = await fetch(`${API}${path}`, {
    headers: {
      'Content-Type': 'application/json',
      ...(  _token ? { Authorization: `Bearer ${_token}` } : {}),
      ...(opts.headers || {}),
    },
    ...opts,
  });
  if (!res.ok) {
    const body = await res.json().catch(() => ({ detail: res.statusText }));
    throw new Error(body.detail || `HTTP ${res.status}`);
  }
  return res.json();
}

// ── Modal + Toast ─────────────────────────────────────────────────
function openModal(id)   { document.getElementById(id)?.classList.add('show'); }
function fecharModal(id) { document.getElementById(id)?.classList.remove('show'); }

function toast(msg, type = 'info') {
  const wrap = document.getElementById('toastWrap');
  const el   = document.createElement('div');
  el.className    = `toast toast--${type}`;
  el.textContent  = msg;
  wrap.appendChild(el);
  setTimeout(() => el.classList.add('show'), 10);
  setTimeout(() => { el.classList.remove('show'); setTimeout(() => el.remove(), 300); }, 4500);
}

function esc(str) {
  return String(str||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}
