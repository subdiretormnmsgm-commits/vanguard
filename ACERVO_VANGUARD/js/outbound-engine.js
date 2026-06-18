'use strict';

// ── Hermes Outbound Engine V13 ────────────────────────────────────────────────
// Exposto como window.OutboundEngine.init(supabaseClient, leads[])
// Chamado pelo dashboard.js após loadLeads()

window.OutboundEngine = (() => {

  // Templates de mensagem Hermes por gargalo
  const HERMES_SCRIPTS = {
    'Dificuldade em escalar a equipe': (nome, nicho) =>
      `Olá ${nome}! 👋\n\nAnalisei o perfil digital do seu negócio em *${nicho}* e identifiquei que a dificuldade em escalar a equipe está travando o seu crescimento.\n\nEsta é a dor mais custosa do setor — empresas que resolvem este gargalo crescem em média 3× mais rápido nos 6 meses seguintes.\n\nA Vanguard Tech já ajudou ${nicho.toLowerCase()}s a automatizar o processo de contratação e treinamento. Podemos mostrar como em 30 minutos?\n\n— Hermes · Vanguard Tech 🚀`,

    'Falta de visibilidade sobre métricas do negócio': (nome, nicho) =>
      `Olá ${nome}! 👋\n\nO seu negócio em *${nicho}* tem um problema crítico: está tomando decisões sem dados.\n\nNo setor de ${nicho.toLowerCase()}, as empresas sem dashboard de métricas perdem em média 23% de margem por trimestre em decisões mal informadas.\n\nInstalamos o painel de controle completo do seu negócio em 72h. Quer ver uma demo?\n\n— Hermes · Vanguard Tech 🚀`,

    'Captação e retenção de clientes': (nome, nicho) =>
      `Olá ${nome}! 👋\n\nAnalisei negócios em *${nicho}* e a captação de clientes é o gargalo #1 do setor.\n\nA boa notícia: temos um sistema que gera leads qualificados automaticamente para ${nicho.toLowerCase()} — sem depender de indicações ou publicidade cara.\n\nPosso mostrar os resultados de outros negócios do mesmo setor? 5 minutos, sem compromisso.\n\n— Hermes · Vanguard Tech 🚀`,

    'Processos manuais que consomem tempo': (nome, nicho) =>
      `Olá ${nome}! 👋\n\nIdentifiquei que o seu negócio em *${nicho}* ainda opera com processos manuais que consomem tempo crítico da equipe.\n\nCalculamos que este gargalo está custando entre 15 a 20 horas semanais que poderiam estar em vendas.\n\nAutomatizamos os 3 processos mais repetitivos do seu setor em menos de uma semana. Posso mostrar como?\n\n— Hermes · Vanguard Tech 🚀`,

    'Dependência de ferramentas de terceiros': (nome, nicho) =>
      `Olá ${nome}! 👋\n\nO seu negócio em *${nicho}* está refém de ferramentas externas — se uma delas mudar o preço ou encerrar, o seu negócio para.\n\nConstruímos infraestrutura própria para ${nicho.toLowerCase()}s no Brasil, eliminando essa dependência.\n\nQuer uma análise gratuita das ferramentas que representam risco para o seu negócio?\n\n— Hermes · Vanguard Tech 🚀`,

    _default: (nome, nicho) =>
      `Olá ${nome}! 👋\n\nSou o Hermes da Vanguard Tech. Analisei centenas de negócios em *${nicho}* e identificamos um padrão de gargalos que afeta diretamente a sua rentabilidade.\n\nA Vanguard Tech tem um sistema específico para ${nicho.toLowerCase()}s. Podemos mostrar resultados reais em 30 minutos?\n\n— Hermes · Vanguard Tech 🚀`,
  };

  function buildMessage(lead) {
    const nome   = lead.nome   || 'empresário';
    const nicho  = lead.nicho  || 'Outro';
    const gargalo = lead.gargalo || '';
    const fn = HERMES_SCRIPTS[gargalo] || HERMES_SCRIPTS._default;
    return fn(nome, nicho);
  }

  function tierColor(tier) {
    return tier === 'VIP'    ? '#FF8080'
         : tier === 'QUENTE' ? '#FFB800'
         : '#80C0FF';
  }

  function tierLabel(tier) {
    return tier === 'VIP'    ? '🔴 VIP'
         : tier === 'QUENTE' ? '🟡 Quente'
         : '🔵 Frio';
  }

  function buildPreviewLink(nicho) {
    // Generates a demo preview URL based on nicho sector for lead research
    const slugs = {
      'Saúde': 'clinica-saude.pt', 'Advocacia': 'escritorio-juridico.pt',
      'Imobiliário': 'imobiliaria-premium.pt', 'E-commerce': 'loja-online.pt',
      'Consultoria': 'consultoria-empresarial.pt', 'Educação': 'escola-digital.pt',
      'Tecnologia': 'startup-tech.pt', 'Restauração': 'restaurante-gourmet.pt',
    };
    const domain = slugs[nicho] || 'negocio-local.pt';
    return `/preview/?d=${encodeURIComponent(domain)}`;
  }

  function renderCard(lead, idx) {
    const score   = lead.scoring?.val ?? 0;
    const tier    = lead.scoring?.tier ?? 'FRIO';
    const msg     = buildMessage(lead);
    const waNum   = (lead.whatsapp || '').replace(/\D/g, '');
    const waLink  = waNum
      ? `https://web.whatsapp.com/send/?phone=${waNum}&text=${encodeURIComponent(msg)}`
      : '#';
    const prevLink = buildPreviewLink(lead.nicho);
    const scoreColor = score >= 75 ? '#FF8080' : score >= 55 ? '#FFB800' : '#80C0FF';

    return `
    <div class="ob-card hud-card" style="animation-delay:${idx * 0.05}s" data-id="${lead.id || idx}">
      <div class="ob-card__top">
        <div class="ob-card__info">
          <span class="ob-card__name">${lead.nome || '—'}</span>
          <span class="ob-card__meta">${lead.nicho || '—'} · ${lead.gargalo ? lead.gargalo.substring(0, 38) + (lead.gargalo.length > 38 ? '…' : '') : '—'}</span>
        </div>
        <div class="ob-card__score-wrap">
          <span class="ob-card__score" style="color:${scoreColor}">${score}</span>
          <span class="ob-card__tier" style="color:${tierColor(tier)}">${tierLabel(tier)}</span>
        </div>
      </div>
      <div class="ob-card__msg">${msg.replace(/\n/g, '<br>').replace(/\*(.*?)\*/g, '<strong>$1</strong>')}</div>
      <div class="ob-card__actions">
        ${waNum
          ? `<a class="ob-btn ob-btn--wa" href="${waLink}" target="_blank" rel="noopener">💬 Enviar no WhatsApp</a>`
          : `<span class="ob-btn ob-btn--disabled">Sem WhatsApp</span>`
        }
        <a class="ob-btn ob-btn--prev" href="${prevLink}" target="_blank" rel="noopener">🔍 Ver Preview HUD</a>
      </div>
    </div>`;
  }

  function injectStyles() {
    if (document.getElementById('ob-styles')) return;
    const s = document.createElement('style');
    s.id = 'ob-styles';
    s.textContent = `
      .ob-section { margin-top: 2.5rem; }
      .ob-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:1.25rem; flex-wrap:wrap; gap:.75rem; }
      .ob-filters { display:flex; gap:.5rem; flex-wrap:wrap; }
      .ob-filter {
        background: rgba(0,240,255,0.06);
        border: 1px solid rgba(0,240,255,0.15);
        border-radius: 6px;
        color: rgba(232,234,240,0.6);
        font-family: 'Inter', sans-serif;
        font-size: 0.72rem;
        font-weight: 600;
        letter-spacing: 0.08em;
        padding: .3rem .75rem;
        cursor: pointer;
        transition: all .2s;
        text-transform: uppercase;
      }
      .ob-filter:hover, .ob-filter--active {
        background: rgba(0,240,255,0.14);
        border-color: rgba(0,240,255,0.4);
        color: #00F0FF;
      }
      .ob-empty { text-align:center; padding:2.5rem; color:rgba(232,234,240,0.35); font-size:.85rem; }
      .ob-grid { display:flex; flex-direction:column; gap:1rem; }
      .ob-card {
        border-radius: 10px;
        padding: 1.25rem;
        animation: slideUp .4s ease both;
      }
      .ob-card__top { display:flex; align-items:flex-start; justify-content:space-between; margin-bottom:.75rem; gap:1rem; }
      .ob-card__info { flex:1; min-width:0; }
      .ob-card__name { display:block; font-weight:600; font-size:.9rem; margin-bottom:.2rem; }
      .ob-card__meta { display:block; font-size:.72rem; color:rgba(232,234,240,0.45); }
      .ob-card__score-wrap { text-align:right; flex-shrink:0; }
      .ob-card__score { display:block; font-size:1.5rem; font-weight:700; line-height:1; }
      .ob-card__tier  { display:block; font-size:.65rem; margin-top:.2rem; }
      .ob-card__msg {
        background: rgba(0,0,0,0.25);
        border: 1px solid rgba(0,240,255,0.06);
        border-radius: 8px;
        padding: .875rem;
        font-size: .78rem;
        line-height: 1.6;
        color: rgba(232,234,240,0.7);
        margin-bottom:.875rem;
        max-height: 120px;
        overflow-y: auto;
      }
      .ob-card__actions { display:flex; gap:.625rem; flex-wrap:wrap; }
      .ob-btn {
        display: inline-flex;
        align-items: center;
        gap: .375rem;
        border-radius: 7px;
        font-family: 'Inter', sans-serif;
        font-size: .72rem;
        font-weight: 700;
        letter-spacing: .08em;
        padding: .45rem .875rem;
        text-decoration: none;
        text-transform: uppercase;
        transition: opacity .2s, transform .1s;
        cursor: pointer;
        border: none;
      }
      .ob-btn:hover { opacity:.82; transform:translateY(-1px); }
      .ob-btn--wa   { background:linear-gradient(135deg,#25D366,#128C7E); color:#fff; }
      .ob-btn--prev { background:rgba(0,240,255,0.1); border:1px solid rgba(0,240,255,0.2); color:#00F0FF; }
      .ob-btn--disabled { background:rgba(255,255,255,0.05); color:rgba(232,234,240,0.3); cursor:not-allowed; }
      .ob-domain-row { display:flex; gap:.625rem; margin-top:1rem; }
      .ob-domain-input {
        flex:1;
        background:rgba(0,0,0,.3);
        border:1px solid rgba(0,240,255,.12);
        border-radius:7px;
        color:#E8EAF0;
        font-family:'Inter',sans-serif;
        font-size:.82rem;
        padding:.45rem .875rem;
        outline:none;
        transition:border-color .2s;
      }
      .ob-domain-input:focus { border-color:#00F0FF; }
      .ob-btn--scan { background:linear-gradient(135deg,#00F0FF,#7B2FBE); color:#080C14; }
      @keyframes slideUp {
        from { opacity:0; transform:translateY(8px); }
        to   { opacity:1; transform:translateY(0); }
      }
    `;
    document.head.appendChild(s);
  }

  function render(leads, filter) {
    const filtered = filter === 'all' ? leads
      : leads.filter(l => l.scoring?.tier === filter);

    const grid = document.getElementById('ob-grid');
    if (!grid) return;

    if (!filtered.length) {
      grid.innerHTML = `<div class="ob-empty">Nenhum lead para este filtro.</div>`;
      return;
    }
    grid.innerHTML = filtered.slice(0, 25).map((l, i) => renderCard(l, i)).join('');
  }

  function init(supabaseClient, leads = []) {
    injectStyles();

    // Find the section container
    const section = document.getElementById('section-outbound');
    if (!section) return;

    const withWA = leads.filter(l => l.whatsapp);
    let activeFilter = 'all';

    section.innerHTML = `
      <div class="ob-header">
        <div>
          <p style="font-size:.65rem;letter-spacing:.18em;color:rgba(0,240,255,.5);text-transform:uppercase;margin-bottom:.3rem;">Hermes Outbound · Fila de Prospecção</p>
          <p style="font-size:.8rem;color:rgba(232,234,240,.5);">${withWA.length} leads com WhatsApp disponível de ${leads.length} no total</p>
        </div>
        <div class="ob-filters">
          <button class="ob-filter ob-filter--active" data-f="all">Todos (${leads.length})</button>
          <button class="ob-filter" data-f="VIP">🔴 VIP (${leads.filter(l=>l.scoring?.tier==='VIP').length})</button>
          <button class="ob-filter" data-f="QUENTE">🟡 Quentes (${leads.filter(l=>l.scoring?.tier==='QUENTE').length})</button>
        </div>
      </div>
      <div class="ob-domain-row">
        <input class="ob-domain-input" id="ob-domain-input" type="text" placeholder="Insira um domínio para gerar preview personalizado (ex: clinica.pt)" />
        <a class="ob-btn ob-btn--scan" id="ob-domain-btn" href="#" target="_blank" rel="noopener">🔍 Gerar Preview</a>
      </div>
      <div class="ob-grid" id="ob-grid"></div>
    `;

    render(leads, 'all');

    // Filter buttons
    section.querySelectorAll('.ob-filter').forEach(btn => {
      btn.addEventListener('click', () => {
        section.querySelectorAll('.ob-filter').forEach(b => b.classList.remove('ob-filter--active'));
        btn.classList.add('ob-filter--active');
        activeFilter = btn.dataset.f;
        render(leads, activeFilter);
      });
    });

    // Domain preview shortcut
    const domainInput = document.getElementById('ob-domain-input');
    const domainBtn   = document.getElementById('ob-domain-btn');
    domainBtn.addEventListener('click', e => {
      const d = domainInput.value.trim();
      if (!d) { e.preventDefault(); return; }
      domainBtn.href = `/preview/?d=${encodeURIComponent(d)}`;
    });
  }

  return { init };
})();
