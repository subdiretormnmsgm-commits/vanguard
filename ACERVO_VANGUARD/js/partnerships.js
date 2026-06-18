'use strict';

// ── Partnerships Engine V13 ───────────────────────────────────────────────────
// Exposto como window.PartnershipsEngine.init()
// Gerencia parceiros/agências (UI + localStorage para demo)

window.PartnershipsEngine = (() => {

  const STORAGE_KEY = 'vanguard_partners';

  // Partners iniciais de demonstração
  const DEFAULT_PARTNERS = [
    {
      id: 'p1',
      name: 'Growth Studio Lisboa',
      email: 'parceiro@growthstudio.pt',
      plan: 'Agency',
      apiKey: 'vg-api-9f2a4e8b',
      scans: 247,
      revenue: 116.50,
      joinedAt: '2026-04-12',
      status: 'active',
    },
    {
      id: 'p2',
      name: 'Digital Masters PT',
      email: 'tech@digitalmasters.pt',
      plan: 'White-Label',
      apiKey: 'vg-api-3c91f72d',
      scans: 489,
      revenue: 380.20,
      joinedAt: '2026-03-28',
      status: 'active',
    },
    {
      id: 'p3',
      name: 'Agência Alpha BR',
      email: 'contato@agenciaalpha.com.br',
      plan: 'Agency',
      apiKey: 'vg-api-a17b8c3e',
      scans: 88,
      revenue: 41.00,
      joinedAt: '2026-05-02',
      status: 'trial',
    },
  ];

  const PLANS = {
    'Agency':      { label: 'Agency',      price: 49,  limit: 500,   badge: 'badge--agency' },
    'White-Label': { label: 'White-Label', price: 149, limit: 2000,  badge: 'badge--wl' },
    'Free':        { label: 'Free',        price: 0,   limit: 10,    badge: 'badge--free' },
  };

  function loadPartners() {
    try {
      const stored = localStorage.getItem(STORAGE_KEY);
      return stored ? JSON.parse(stored) : [...DEFAULT_PARTNERS];
    } catch { return [...DEFAULT_PARTNERS]; }
  }

  function savePartners(partners) {
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify(partners)); } catch {}
  }

  function maskKey(key) {
    return key.slice(0, 10) + '****' + key.slice(-4);
  }

  function statusBadge(status) {
    const map = {
      active: ['✅ Activo',  'rgba(0,255,136,0.1)',  '#00FF88'],
      trial:  ['⏳ Trial',   'rgba(255,184,0,0.1)',  '#FFB800'],
      paused: ['⏸ Pausado', 'rgba(255,68,68,0.1)',   '#FF8080'],
    };
    const [lbl, bg, col] = map[status] || map.active;
    return `<span style="background:${bg};color:${col};padding:.15rem .55rem;border-radius:4px;font-size:.62rem;font-weight:700;">${lbl}</span>`;
  }

  function planBadge(plan) {
    const color = plan === 'White-Label' ? '#7B2FBE' : plan === 'Agency' ? '#00F0FF' : '#888';
    return `<span style="background:rgba(123,47,190,0.12);color:${color};padding:.15rem .55rem;border-radius:4px;font-size:.62rem;font-weight:700;border:1px solid ${color}33;">${plan}</span>`;
  }

  function renderPartnerRow(p) {
    return `
    <tr>
      <td>
        <div style="font-weight:600;font-size:.85rem;">${p.name}</div>
        <div style="font-size:.7rem;color:rgba(232,234,240,0.4);">${p.email}</div>
      </td>
      <td>${planBadge(p.plan)}</td>
      <td style="font-family:'Courier New',monospace;font-size:.72rem;color:rgba(0,240,255,0.6);">${maskKey(p.apiKey)}</td>
      <td style="font-variant-numeric:tabular-nums;">${p.scans.toLocaleString('pt')}</td>
      <td style="color:#00FF88;font-weight:600;">€ ${p.revenue.toFixed(2)}</td>
      <td>${statusBadge(p.status)}</td>
      <td style="font-size:.72rem;color:rgba(232,234,240,.4);">${p.joinedAt}</td>
    </tr>`;
  }

  function renderModal() {
    return `
    <div id="ps-modal-overlay" style="
      position:fixed;inset:0;background:rgba(8,12,20,0.85);
      backdrop-filter:blur(8px);z-index:999;
      display:flex;align-items:center;justify-content:center;padding:1rem;">
      <div style="
        background:#0D1520;border:1px solid rgba(0,240,255,0.15);
        border-radius:14px;padding:2rem;width:100%;max-width:480px;
        position:relative;">
        <button id="ps-modal-close" style="
          position:absolute;top:1rem;right:1rem;
          background:none;border:none;color:rgba(232,234,240,0.4);
          font-size:1.25rem;cursor:pointer;">✕</button>
        <p style="font-size:.65rem;letter-spacing:.18em;color:rgba(0,240,255,.5);text-transform:uppercase;margin-bottom:.5rem;">Nova Parceria</p>
        <h3 style="font-size:1.1rem;font-weight:700;margin-bottom:1.5rem;">Adicionar Agência Parceira</h3>
        <div style="display:flex;flex-direction:column;gap:.875rem;">
          <div>
            <label style="font-size:.65rem;letter-spacing:.1em;text-transform:uppercase;color:rgba(232,234,240,.4);display:block;margin-bottom:.3rem;">Nome da Agência</label>
            <input id="ps-name" type="text" placeholder="Ex: Growth Studio Lisboa" style="
              width:100%;background:rgba(0,0,0,.35);border:1px solid rgba(0,240,255,.12);
              border-radius:7px;color:#E8EAF0;font-family:'Inter',sans-serif;
              font-size:.85rem;padding:.55rem .875rem;outline:none;">
          </div>
          <div>
            <label style="font-size:.65rem;letter-spacing:.1em;text-transform:uppercase;color:rgba(232,234,240,.4);display:block;margin-bottom:.3rem;">Email</label>
            <input id="ps-email" type="email" placeholder="parceiro@agencia.pt" style="
              width:100%;background:rgba(0,0,0,.35);border:1px solid rgba(0,240,255,.12);
              border-radius:7px;color:#E8EAF0;font-family:'Inter',sans-serif;
              font-size:.85rem;padding:.55rem .875rem;outline:none;">
          </div>
          <div>
            <label style="font-size:.65rem;letter-spacing:.1em;text-transform:uppercase;color:rgba(232,234,240,.4);display:block;margin-bottom:.3rem;">Plano</label>
            <select id="ps-plan" style="
              width:100%;background:rgba(0,0,0,.35);border:1px solid rgba(0,240,255,.12);
              border-radius:7px;color:#E8EAF0;font-family:'Inter',sans-serif;
              font-size:.85rem;padding:.55rem .875rem;outline:none;">
              <option value="Free">Free — 10 scans/dia (aquisição)</option>
              <option value="Agency" selected>Agency — 500 scans/mês · €49/mês</option>
              <option value="White-Label">White-Label — 2000 scans/mês · €149/mês</option>
            </select>
          </div>
          <button id="ps-modal-save" style="
            background:linear-gradient(135deg,#00F0FF,#7B2FBE);
            border:none;border-radius:8px;color:#080C14;
            font-family:'Inter',sans-serif;font-size:.8rem;
            font-weight:700;letter-spacing:.1em;padding:.7rem;
            cursor:pointer;text-transform:uppercase;margin-top:.25rem;">
            Criar Parceiro & Gerar API Key →
          </button>
        </div>
      </div>
    </div>`;
  }

  function generateApiKey() {
    const chars = 'abcdef0123456789';
    const seg = () => Array.from({length:8}, () => chars[Math.floor(Math.random()*chars.length)]).join('');
    return `vg-api-${seg()}`;
  }

  function openModal(partners, onSave) {
    document.body.insertAdjacentHTML('beforeend', renderModal());

    document.getElementById('ps-modal-close').addEventListener('click', () => {
      document.getElementById('ps-modal-overlay').remove();
    });

    document.getElementById('ps-modal-save').addEventListener('click', () => {
      const name  = document.getElementById('ps-name').value.trim();
      const email = document.getElementById('ps-email').value.trim();
      const plan  = document.getElementById('ps-plan').value;
      if (!name || !email) {
        alert('Preencha o nome e o email.');
        return;
      }
      const newPartner = {
        id: 'p' + Date.now(),
        name, email, plan,
        apiKey: generateApiKey(),
        scans: 0,
        revenue: 0,
        joinedAt: new Date().toISOString().slice(0, 10),
        status: 'trial',
      };
      partners.unshift(newPartner);
      savePartners(partners);
      document.getElementById('ps-modal-overlay').remove();
      onSave(partners);
    });
  }

  function injectStyles() {
    if (document.getElementById('ps-styles')) return;
    const s = document.createElement('style');
    s.id = 'ps-styles';
    s.textContent = `
      .ps-kpis { display:grid; grid-template-columns:repeat(3,1fr); gap:.875rem; margin-bottom:1.25rem; }
      @media(max-width:600px){ .ps-kpis { grid-template-columns:1fr 1fr; } }
      .ps-kpi {
        background:rgba(255,255,255,.03);
        border:1px solid rgba(0,240,255,.1);
        border-radius:10px;padding:1rem 1.25rem;text-align:center;
      }
      .ps-kpi__val { font-size:1.6rem;font-weight:700;color:#00F0FF;line-height:1;margin-bottom:.3rem; }
      .ps-kpi__lbl { font-size:.62rem;letter-spacing:.1em;text-transform:uppercase;color:rgba(232,234,240,.4); }
      .ps-table-wrap { overflow-x:auto; }
      .ps-table { width:100%;border-collapse:collapse; }
      .ps-table th {
        font-size:.62rem;letter-spacing:.1em;text-transform:uppercase;
        color:rgba(232,234,240,.35);text-align:left;
        padding:.5rem 0 .75rem;border-bottom:1px solid rgba(0,240,255,.08);
      }
      .ps-table td { padding:.75rem 0;border-bottom:1px solid rgba(0,240,255,.04);font-size:.83rem; }
      .ps-table tr:last-child td { border-bottom:none; }
      .ps-empty { text-align:center;padding:2.5rem;color:rgba(232,234,240,.3);font-size:.85rem; }
      .ps-add-btn {
        background:linear-gradient(135deg,#00F0FF,#7B2FBE);
        border:none;border-radius:8px;color:#080C14;
        font-family:'Inter',sans-serif;font-size:.75rem;
        font-weight:700;letter-spacing:.1em;
        padding:.5rem 1.125rem;cursor:pointer;
        text-transform:uppercase;transition:opacity .2s,transform .1s;
      }
      .ps-add-btn:hover { opacity:.87; transform:translateY(-1px); }
      .ps-plan-info {
        background:rgba(0,240,255,.04);
        border:1px solid rgba(0,240,255,.08);
        border-radius:8px;padding:1rem 1.25rem;
        margin-top:1.25rem;font-size:.78rem;
        line-height:1.55;color:rgba(232,234,240,.55);
      }
      .ps-plan-info strong { color:#00F0FF; }
    `;
    document.head.appendChild(s);
  }

  function renderContent(partners) {
    const totalRevenue = partners.reduce((s, p) => s + p.revenue, 0);
    const totalScans   = partners.reduce((s, p) => s + p.scans, 0);
    const active       = partners.filter(p => p.status === 'active').length;

    const section = document.getElementById('section-partnerships');
    if (!section) return;

    section.innerHTML = `
      <div class="ps-kpis">
        <div class="ps-kpi">
          <div class="ps-kpi__val">${partners.length}</div>
          <div class="ps-kpi__lbl">Agências Parceiras</div>
        </div>
        <div class="ps-kpi">
          <div class="ps-kpi__val" style="color:#00FF88;">€ ${totalRevenue.toFixed(0)}</div>
          <div class="ps-kpi__lbl">Receita Gerada</div>
        </div>
        <div class="ps-kpi">
          <div class="ps-kpi__val">${totalScans.toLocaleString('pt')}</div>
          <div class="ps-kpi__lbl">Scans via API</div>
        </div>
      </div>
      <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:1rem;flex-wrap:wrap;gap:.75rem;">
        <p style="font-size:.72rem;color:rgba(232,234,240,.4);">${active} parceiros activos · Revenue share 20% em leads convertidos</p>
        <button class="ps-add-btn" id="ps-add-btn">+ Adicionar Parceiro</button>
      </div>
      <div class="ps-table-wrap">
        ${partners.length
          ? `<table class="ps-table">
              <thead><tr>
                <th>Agência</th><th>Plano</th><th>API Key</th>
                <th>Scans</th><th>Receita</th><th>Estado</th><th>Entrada</th>
              </tr></thead>
              <tbody>${partners.map(renderPartnerRow).join('')}</tbody>
            </table>`
          : `<div class="ps-empty">Nenhum parceiro registado. Adicione a primeira agência.</div>`
        }
      </div>
      <div class="ps-plan-info">
        <strong>Planos Partnership API:</strong><br>
        🔹 <strong>Free:</strong> 10 scans/dia · aquisição orgânica<br>
        🔹 <strong>Agency (€49/mês):</strong> 500 scans/mês · logo Vanguard nos relatórios<br>
        🔹 <strong>White-Label (€149/mês):</strong> 2000 scans/mês · logo próprio nos PDFs + revenue share 20% em clientes convertidos
      </div>
    `;

    document.getElementById('ps-add-btn').addEventListener('click', () => {
      openModal(partners, (updated) => renderContent(updated));
    });
  }

  function init() {
    injectStyles();
    const partners = loadPartners();
    renderContent(partners);
  }

  return { init };
})();
