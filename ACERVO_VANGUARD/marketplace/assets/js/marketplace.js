/* ══════════════════════════════════════════════════════════════════
   marketplace.js — Browse público de packs + subscribe + cursor
   Depende de: VANGUARD_CONFIG (injectado pelo nginx/brand-config)
════════════════════════════════════════════════════════════════════ */

const API    = window.VANGUARD_CONFIG?.API_BASE || '/api';
const SB_URL = window.VANGUARD_CONFIG?.SUPABASE_URL || '';
const SB_KEY = window.VANGUARD_CONFIG?.SUPABASE_ANON_KEY || '';

let _sb     = null;
let _token  = null;
let _allPacks = [];
let _offset   = 0;
const PAGE    = 18;
let _nicho    = '';
let _ordem    = 'assinantes';

// ── Init ──────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  initCursor();
  initScroll();
  checkSession();
  carregarPacks(true);
  carregarCriadores();
  tratarQueryParams();

  // Drag scroll for featured
  initDragScroll(document.getElementById('featuredScroll'));

  // Filtros nicho
  document.querySelectorAll('.filter-chip').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.filter-chip').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      _nicho  = btn.dataset.nicho || '';
      _offset = 0;
      carregarPacks(true);
    });
  });
});

// ── Custom cursor ─────────────────────────────────────────────────
function initCursor() {
  const cur  = document.getElementById('cursor');
  const ring = document.getElementById('cursorRing');
  if (!cur || !ring) return;
  let rx = 0, ry = 0;
  document.addEventListener('mousemove', e => {
    cur.style.left  = e.clientX + 'px';
    cur.style.top   = e.clientY + 'px';
    rx += (e.clientX - rx) * .12;
    ry += (e.clientY - ry) * .12;
    ring.style.left = rx + 'px';
    ring.style.top  = ry + 'px';
    requestAnimationFrame(() => {
      rx += (e.clientX - rx) * .12;
      ry += (e.clientY - ry) * .12;
    });
  });
}

// ── IntersectionObserver para reveal ─────────────────────────────
function initScroll() {
  const io = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('visible'); io.unobserve(e.target); } });
  }, { threshold: .12 });
  document.querySelectorAll('.reveal, .clip-reveal').forEach(el => io.observe(el));
}

// ── Drag scroll ───────────────────────────────────────────────────
function initDragScroll(el) {
  if (!el) return;
  let isDown = false, startX, scrollLeft;
  el.addEventListener('mousedown', e => { isDown = true; startX = e.pageX - el.offsetLeft; scrollLeft = el.scrollLeft; });
  el.addEventListener('mouseleave', () => { isDown = false; });
  el.addEventListener('mouseup',   () => { isDown = false; });
  el.addEventListener('mousemove', e => {
    if (!isDown) return;
    e.preventDefault();
    el.scrollLeft = scrollLeft - (e.pageX - el.offsetLeft - startX) * 1.5;
  });
}

// ── Session (opcional — para mostrar botão "Subscrever") ──────────
async function checkSession() {
  if (!SB_URL || !SB_KEY) return;
  try {
    _sb = supabase.createClient(SB_URL, SB_KEY);
    const { data: { session } } = await _sb.auth.getSession();
    if (session) _token = session.access_token;
  } catch (e) { /* sem sessão */ }
}

// ── Query params ──────────────────────────────────────────────────
function tratarQueryParams() {
  const params = new URLSearchParams(location.search);
  if (params.get('sub') === 'success') toast('✅ Pack subscrito com sucesso!', 'success');
  if (params.get('sub') === 'cancel')  toast('Checkout cancelado.', 'info');
}

// ── Carregar Packs ────────────────────────────────────────────────
async function carregarPacks(reset = false) {
  if (reset) { _offset = 0; _allPacks = []; }

  const params = new URLSearchParams({
    limite: PAGE, offset: _offset, ordem: _ordem,
    ...(  _nicho ? { nicho: _nicho } : {}),
  });

  try {
    const res  = await fetch(`${API}/marketplace/packs?${params}`);
    const data = await res.json();
    const packs = data.packs || [];

    _allPacks = reset ? packs : [..._allPacks, ...packs];
    _offset  += packs.length;

    renderPacksGrid(_allPacks);
    if (reset) renderFeatured(packs.slice(0, 5));

    document.getElementById('packsCount').textContent = `${_allPacks.length} packs`;
    document.getElementById('loadMoreWrap').style.display = packs.length >= PAGE ? 'block' : 'none';
  } catch (err) {
    console.error(err);
    toast('Erro ao carregar packs.', 'error');
  }
}

function filtrarPacks() {
  _ordem = document.getElementById('sortSelect').value;
  _offset = 0;
  carregarPacks(true);
}

function carregarMais() {
  carregarPacks(false);
}

// ── Render Packs Grid ─────────────────────────────────────────────
function renderPacksGrid(packs) {
  const grid = document.getElementById('packsGrid');
  if (!packs.length) {
    grid.innerHTML = `<div style="grid-column:1/-1;text-align:center;padding:4rem;color:var(--text-3)">
      <div style="font-size:3rem;margin-bottom:1rem">📦</div>
      <div>Nenhum pack neste nicho ainda.</div>
      <a href="creator.html" class="btn btn-ghost btn-sm" style="margin-top:1rem;display:inline-flex">Seja o primeiro criador</a>
    </div>`;
    return;
  }
  grid.innerHTML = packs.map(p => renderPackCard(p)).join('');
}

function renderFeatured(packs) {
  const scroll = document.getElementById('featuredScroll');
  if (!packs.length) { scroll.innerHTML = ''; return; }
  scroll.innerHTML = packs.map(p => renderPackCard(p, true)).join('');

  // Hero featured
  if (packs[0]) {
    document.getElementById('heroFeaturedPack').innerHTML = renderPackCard(packs[0], false, true);
  }
}

function renderPackCard(p, featured = false, hero = false) {
  const stars = '★'.repeat(Math.round(p.rating || 5)) + '☆'.repeat(5 - Math.round(p.rating || 5));
  const preco = (p.preco_mensal || 97).toFixed(0);
  const creators = p.creator || {};
  return `
    <div class="pack-card${hero ? ' pack-card--hero' : ''}" onclick="abrirPackDetail('${p.id}')">
      <div class="pack-card__rating">${stars} ${(p.rating || 5).toFixed(1)}</div>
      <div class="pack-card__cover">
        <span class="pack-card__emoji">${p.cover_emoji || '📦'}</span>
        <div class="pack-card__nicho">${(p.nicho || '').toUpperCase()}</div>
        <div class="pack-card__nome">${esc(p.nome)}</div>
        ${p.cidade_alvo ? `<div class="pack-card__cidade">📍 ${esc(p.cidade_alvo)}</div>` : '<div class="pack-card__cidade">🌐 Nacional</div>'}
      </div>
      <div class="pack-card__body">
        <div class="pack-card__metrics">
          <div class="pack-card__metric">
            <span class="pack-card__metric-value">${p.leads_tipicos || 50}</span>
            <div class="pack-card__metric-label">Leads/mês</div>
          </div>
          <div class="pack-card__metric">
            <span class="pack-card__metric-value">${p.taxa_conversao ? p.taxa_conversao + '%' : '—'}</span>
            <div class="pack-card__metric-label">Conversão</div>
          </div>
          <div class="pack-card__metric">
            <span class="pack-card__metric-value">${p.score_medio ? p.score_medio.toFixed(1) : '—'}</span>
            <div class="pack-card__metric-label">Score IA</div>
          </div>
        </div>
        <div class="pack-card__footer">
          <div class="pack-card__price">R$ ${preco}<span>/mês</span></div>
          <div class="pack-card__sub-count">${p.assinantes || 0} activos</div>
        </div>
      </div>
      <div class="pack-card__overlay">
        <div style="width:100%">
          <div style="font-size:.8rem;color:var(--text-3);margin-bottom:.5rem">por ${esc(creators.nome || 'Criador')}</div>
          <div class="btn btn-primary" style="width:100%;justify-content:center">Ver Pack →</div>
        </div>
      </div>
    </div>`;
}

// ── Pack Detail Modal ─────────────────────────────────────────────
async function abrirPackDetail(packId) {
  // Registar intenção (view)
  registarIntencao(packId, 'view');

  openModal('modalPackDetail');
  document.getElementById('modalPackDetailBody').innerHTML =
    '<div class="skeleton" style="height:300px;border-radius:.5rem"></div>';

  try {
    const res  = await fetch(`${API}/marketplace/packs/${packId}`);
    const data = await res.json();
    const p    = data.pack;
    if (!p) throw new Error('Pack não encontrado');

    document.getElementById('modalPackDetailTitle').textContent = p.nome;
    document.getElementById('modalPackDetailBody').innerHTML = `
      <div class="pack-detail__hero">
        <div class="pack-detail__emoji">${p.cover_emoji || '📦'}</div>
        <div class="pack-detail__info">
          <div style="font-family:var(--font-mono);font-size:.7rem;color:var(--amber);letter-spacing:.1em;text-transform:uppercase;margin-bottom:.35rem">${p.nicho || ''}</div>
          <div style="font-family:var(--font-display);font-size:1.3rem;font-weight:700;color:var(--text);margin-bottom:.5rem">${esc(p.nome)}</div>
          <div style="font-size:.85rem;color:var(--text-3)">por ${esc(p.creator?.nome || '—')} ${p.cidade_alvo ? '· 📍 ' + esc(p.cidade_alvo) : '· 🌐 Nacional'}</div>
        </div>
      </div>

      <p style="color:var(--text-2);line-height:1.7;margin-bottom:1.5rem">${esc(p.descricao || 'Sem descrição.')}</p>

      <div class="pack-detail__metrics-grid">
        <div class="pack-detail__metric">
          <span style="font-family:var(--font-mono);font-size:1.5rem;font-weight:700;color:var(--amber);display:block">${p.leads_tipicos}</span>
          <span style="font-size:.75rem;color:var(--text-3)">Leads típicos/mês</span>
        </div>
        <div class="pack-detail__metric">
          <span style="font-family:var(--font-mono);font-size:1.5rem;font-weight:700;color:var(--amber);display:block">${p.taxa_conversao ? p.taxa_conversao + '%' : '—'}</span>
          <span style="font-size:.75rem;color:var(--text-3)">Taxa de conversão</span>
        </div>
        <div class="pack-detail__metric">
          <span style="font-family:var(--font-mono);font-size:1.5rem;font-weight:700;color:var(--amber);display:block">${p.assinantes}</span>
          <span style="font-size:.75rem;color:var(--text-3)">Subscritores activos</span>
        </div>
      </div>

      ${p.tags?.length ? `<div style="display:flex;gap:.5rem;flex-wrap:wrap;margin-bottom:1.5rem">${p.tags.map(t => `<span class="badge badge-amber">${esc(t)}</span>`).join('')}</div>` : ''}

      <div style="display:flex;align-items:center;justify-content:space-between;padding:1.25rem;background:var(--bg-3);border-radius:var(--r);border:1px solid var(--border);margin-bottom:1.5rem">
        <div>
          <span style="font-family:var(--font-mono);font-size:1.5rem;font-weight:700;color:var(--text)">R$ ${(p.preco_mensal||97).toFixed(0)}</span>
          <span style="font-size:.8rem;color:var(--text-3)">/mês · Cancele quando quiser</span>
        </div>
        <button class="btn btn-primary" onclick="subscreverPack('${packId}')">Subscrever Pack →</button>
      </div>

      ${p.ultimas_reviews?.length ? `
        <div style="font-family:var(--font-mono);font-size:.7rem;color:var(--amber);letter-spacing:.1em;text-transform:uppercase;margin-bottom:1rem">Avaliações</div>
        ${p.ultimas_reviews.map(r => `
          <div class="review-item">
            <div>
              <div class="review-stars">${'★'.repeat(r.rating)}${'☆'.repeat(5-r.rating)}</div>
              ${r.comentario ? `<div class="review-text">${esc(r.comentario)}</div>` : ''}
              <div class="review-date">${new Date(r.created_at).toLocaleDateString('pt-PT')}</div>
            </div>
          </div>`).join('')}` : ''}
    `;
  } catch (err) {
    document.getElementById('modalPackDetailBody').innerHTML =
      `<p style="color:var(--crimson)">Erro ao carregar pack: ${err.message}</p>`;
  }
}

async function subscreverPack(packId) {
  if (!_token) {
    toast('Entre na sua conta para subscrever.', 'info');
    setTimeout(() => { window.location.href = '/saas/?next=/marketplace/'; }, 1500);
    return;
  }
  registarIntencao(packId, 'checkout_start');
  try {
    const res = await fetch(`${API}/marketplace/subscribe/${packId}`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${_token}` },
    });
    const data = await res.json();
    if (data.checkout_url) {
      window.location.href = data.checkout_url;
    } else {
      toast(data.detail || 'Erro ao iniciar checkout.', 'error');
    }
  } catch (err) {
    toast('Erro: ' + err.message, 'error');
  }
}

// ── Criadores ─────────────────────────────────────────────────────
async function carregarCriadores() {
  // Buscar packs e agregar por creator
  try {
    const res  = await fetch(`${API}/marketplace/packs?limite=50`);
    const data = await res.json();
    const packs = data.packs || [];

    // Agregar por criador
    const criadoresMap = {};
    packs.forEach(p => {
      const c = p.creator;
      if (!c?.id) return;
      if (!criadoresMap[c.id]) criadoresMap[c.id] = { ...c, packs: 0, subs: 0 };
      criadoresMap[c.id].packs++;
      criadoresMap[c.id].subs += (p.assinantes || 0);
    });

    const criadores = Object.values(criadoresMap).sort((a,b) => b.subs - a.subs).slice(0, 8);
    const grid = document.getElementById('criadoresGrid');

    if (!criadores.length) {
      grid.innerHTML = `<div style="grid-column:1/-1;text-align:center;color:var(--text-3);padding:2rem">
        <div style="font-size:2rem;margin-bottom:.5rem">👤</div>Nenhum criador ainda. <a href="creator.html" style="color:var(--amber)">Seja o primeiro</a>
      </div>`;
      return;
    }

    grid.innerHTML = criadores.map(c => `
      <div class="creator-card">
        <div class="creator-card__avatar">${(c.nome||'C').charAt(0).toUpperCase()}</div>
        <div class="creator-card__nome">${esc(c.nome || '—')}</div>
        <div class="creator-card__especialidade">${(c.especialidade || 'Generalista').toUpperCase()}</div>
        <div class="creator-card__stats">
          <div><span class="creator-card__stat-val">${c.packs}</span><span class="creator-card__stat-lbl">Packs</span></div>
          <div><span class="creator-card__stat-val">${c.subs}</span><span class="creator-card__stat-lbl">Subs</span></div>
          <div><span class="creator-card__stat-val">${(c.rating_medio||5).toFixed(1)}★</span><span class="creator-card__stat-lbl">Rating</span></div>
        </div>
      </div>`).join('');
  } catch (err) {
    console.warn('carregarCriadores:', err);
  }
}

// ── Intenção ──────────────────────────────────────────────────────
async function registarIntencao(packId, evento) {
  try {
    await fetch(`${API}/marketplace/webhook/intention`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(  _token ? { Authorization: `Bearer ${_token}` } : {}),
      },
      body: JSON.stringify({ pack_id: packId, evento }),
    });
  } catch (e) { /* silent */ }
}

// ── Modal helpers ─────────────────────────────────────────────────
function openModal(id)  { document.getElementById(id)?.classList.add('show'); }
function fecharModal(id){ document.getElementById(id)?.classList.remove('show'); }

// ── Toast ─────────────────────────────────────────────────────────
function toast(msg, type = 'info') {
  const wrap = document.getElementById('toastWrap');
  const el   = document.createElement('div');
  el.className = `toast toast--${type}`;
  el.textContent = msg;
  wrap.appendChild(el);
  setTimeout(() => el.classList.add('show'), 10);
  setTimeout(() => { el.classList.remove('show'); setTimeout(() => el.remove(), 300); }, 4500);
}

function esc(str) {
  return String(str||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}
