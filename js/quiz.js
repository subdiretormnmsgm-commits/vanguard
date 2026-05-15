/* ═══════════════════════════════════════════════════════════════════════════
   VANGUARD V26 — DIAGNÓSTICO QUADRILATERAL™
   Quatro quadrantes: Presença (P) · Aquisição (A) · Conversão (C) · Retenção (R)
   Scoring matrix por resposta → recomendação de produto baseada no quadrante fraco
   V26: campo "Outros" em Q2–Q7 + texto PT-BR
   ═══════════════════════════════════════════════════════════════════════════ */
const Quiz = (() => {
  'use strict';

  const WA_NUMBER = '5521996008570';
  const TOTAL_QUESTIONS = 8;

  /* ─── Estado ──────────────────────────────────────────────────────────── */
  const state = {
    step: 1,
    q1: '', q2: '', q3: '', q4: '', q5: '', q6: '', q7: '',
    q8_custo_ads: 0,
    nome: '', whatsapp: '', email: '',
    scores: { P: 0, A: 0, C: 0, R: 0 },
    outros_textos: {},
  };

  /* ─── Scoring Matrix ──────────────────────────────────────────────────── */
  const SCORE_MAP = {
    q2_lt10:    { P:2, A:2, C:2, R:2 },
    q2_10_50:   { P:4, A:4, C:4, R:4 },
    q2_50_150:  { P:6, A:6, C:6, R:6 },
    q2_gt150:   { P:8, A:8, C:8, R:8 },
    q2_outros:  { P:4, A:4, C:4, R:4 },

    q3_indicacao:  { P:3, A:4, C:8, R:8 },
    q3_social:     { P:7, A:6, C:4, R:3 },
    q3_prospeccao: { P:4, A:8, C:5, R:4 },
    q3_misto:      { P:6, A:7, C:6, R:5 },
    q3_nenhum:     { P:1, A:1, C:2, R:2 },
    q3_outros:     { P:4, A:4, C:4, R:4 },

    q4_site_bom:    { P:9, A:7, C:6, R:5 },
    q4_site_velho:  { P:4, A:4, C:5, R:4 },
    q4_redes:       { P:5, A:6, C:3, R:3 },
    q4_sem_digital: { P:1, A:1, C:2, R:2 },
    q4_outros:      { P:5, A:5, C:4, R:4 },

    q5_lt1:  { P:2, A:3, C:1, R:2 },
    q5_1_3:  { P:4, A:5, C:3, R:4 },
    q5_3_5:  { P:6, A:6, C:6, R:5 },
    q5_gt5:  { P:7, A:7, C:9, R:8 },
    q5_outros: { P:5, A:5, C:5, R:5 },

    q6_visibilidade: { P:1, A:4, C:5, R:5 },
    q6_leads:        { P:4, A:1, C:4, R:4 },
    q6_fechamento:   { P:5, A:4, C:1, R:5 },
    q6_retencao:     { P:5, A:5, C:4, R:1 },
    q6_tempo:        { P:3, A:3, C:3, R:3 },
    q6_outros:       { P:4, A:4, C:4, R:4 },

    q7_nunca:      { P:2, A:2, C:2, R:2 },
    q7_tentei:     { P:4, A:3, C:4, R:3 },
    q7_agencia:    { P:5, A:5, C:4, R:4 },
    q7_freelancer: { P:4, A:4, C:5, R:4 },
    q7_sistema:    { P:6, A:5, C:5, R:6 },
    q7_outros:     { P:4, A:4, C:4, R:4 },
  };

  /* ─── Recomendações por quadrante mais fraco ──────────────────────────── */
  const RECOMMENDATIONS = {
    P: {
      label: 'Presença Digital',
      icon: '🌐',
      problem: 'Sua presença digital não está trabalhando por você — está invisível para quem importa.',
      solution: 'Authority Badge + RealScanner™',
      description: 'O RealScanner™ identifica exatamente o que está custando visibilidade e o Authority Badge posiciona sua marca como referência no nicho.',
      cta: 'Quero dominar minha presença digital',
    },
    A: {
      label: 'Aquisição de Clientes',
      icon: '⚡',
      problem: 'Seu pipeline de novos clientes é inconsistente — depende de sorte, não de sistema.',
      solution: 'Hermes Outbound + Sovereign Pixel',
      description: 'O Hermes Outbound automatiza a prospecção com precisão cirúrgica. O Pixel identifica quem visitou seu site e está pronto para comprar.',
      cta: 'Quero um sistema previsível de aquisição',
    },
    C: {
      label: 'Conversão e Fechamento',
      icon: '🎯',
      problem: 'Oportunidades entram, mas escapam — o processo de venda tem fugas críticas.',
      solution: 'Neural Audit Trail + Hermes Closer',
      description: 'O Neural Audit Trail mostra ao seu prospecto exatamente o que está perdendo em reais. O Hermes Closer estrutura a conversa para o sim.',
      cta: 'Quero converter mais dos meus leads',
    },
    R: {
      label: 'Retenção e Receita Recorrente',
      icon: '🛡️',
      problem: 'Clientes conquistados com esforço saem sem que você perceba por que — o MRR é frágil.',
      solution: 'Neural Sentinel + Sovereign Playbook',
      description: 'O Neural Sentinel monitora sinais de abandono antes de acontecerem. O Playbook dá ao cliente um mapa de 90 dias que o mantém engajado na plataforma.',
      cta: 'Quero blindar minha receita recorrente',
    },
  };

  const REVENUE_BASE = {
    lt10: 8000, '10_50': 28000, '50_150': 90000, gt150: 200000,
  };

  /* ─── Cálculos ────────────────────────────────────────────────────────── */
  function computeScores() {
    const keys = ['q2','q3','q4','q5','q6','q7'];
    const totals = { P:0, A:0, C:0, R:0 };
    let count = 0;
    for (const k of keys) {
      const val = state[k];
      if (!val) continue;
      const entry = SCORE_MAP[k + '_' + val];
      if (!entry) continue;
      totals.P += entry.P; totals.A += entry.A;
      totals.C += entry.C; totals.R += entry.R;
      count++;
    }
    const div = count || 1;
    state.scores = {
      P: Math.round(totals.P / div),
      A: Math.round(totals.A / div),
      C: Math.round(totals.C / div),
      R: Math.round(totals.R / div),
    };
  }

  function getWeakestQuadrant() {
    const s = state.scores;
    return Object.keys(s).reduce((a, b) => s[a] <= s[b] ? a : b);
  }

  function getRevenueRisk() {
    const base = REVENUE_BASE[state.q2] || 8000;
    const avg = (state.scores.P + state.scores.A + state.scores.C + state.scores.R) / 4;
    const riskPct = Math.max(0.15, (10 - avg) / 10 * 0.55);
    return Math.round(base * riskPct / 1000) * 1000;
  }

  /* ─── V24: Calculadora de Lucro em Risco ────────────────────────────── */
  function calcLucroEmRisco(custoAds) {
    const ads = parseFloat(custoAds) || 0;
    if (ads <= 0) return null;
    const taxaConversao = 0.20;
    const leadsCusto    = 15;
    const leadsGerados  = Math.round(ads / leadsCusto);
    const leadsPerdidos = Math.round(leadsGerados * (1 - taxaConversao));
    const baseRevenue   = REVENUE_BASE[state.q2] || 8000;
    const ticketMedio   = Math.round(baseRevenue / 20);
    const desperdicio   = Math.round(leadsPerdidos * ticketMedio / 1000) * 1000;
    const recuperacao   = Math.round(desperdicio * 0.30 / 100) * 100;
    const roi           = ads > 0 ? (recuperacao / 97).toFixed(1) : 0;
    return { ads, leadsGerados, leadsPerdidos, desperdicio, recuperacao, roi };
  }

  function fmtBRL(n) {
    return 'R$ ' + Math.round(n).toLocaleString('pt-BR');
  }

  function updateRiskPreview() {
    const ads = parseFloat(document.getElementById('quiz-custo-ads')?.value) || 0;
    const box  = document.getElementById('risk-preview-box');
    const btn  = document.getElementById('btn-next-8');
    if (!box) return;
    if (ads > 0) {
      const r = calcLucroEmRisco(ads);
      box.style.display = 'block';
      document.getElementById('rp-ads').textContent         = fmtBRL(r.ads);
      document.getElementById('rp-desperdicio').textContent = fmtBRL(r.desperdicio) + '/mês';
      document.getElementById('rp-recuperacao').textContent = fmtBRL(r.recuperacao) + '/sem';
      if (btn) btn.disabled = false;
    } else {
      box.style.display = 'none';
      if (btn) btn.disabled = true;
    }
  }

  /* ─── Navegação ───────────────────────────────────────────────────────── */
  function showStep(id) {
    document.querySelectorAll('.quiz__step')
      .forEach(el => el.classList.add('quiz__step--hidden'));
    const el = document.getElementById(id);
    if (el) el.classList.remove('quiz__step--hidden');
  }

  function setProgress(step) {
    const pct = step === 'done' ? 100 : Math.round((step / (TOTAL_QUESTIONS + 1)) * 100);
    const bar = document.getElementById('quiz-progress-bar');
    const lbl = document.getElementById('quiz-step-label');
    if (bar) bar.style.width = pct + '%';
    if (lbl) lbl.textContent = step === 'done' ? 'Análise completa' : 'Pergunta ' + step + ' de ' + TOTAL_QUESTIONS;
  }

  function goTo(step) {
    state.step = step;
    if (step <= TOTAL_QUESTIONS) {
      setProgress(step);
      showStep('step-' + step);
    } else if (step === 'preview') {
      setProgress('done');
      showStep('step-preview');
      renderPreview();
    } else if (step === 'contact') {
      showStep('step-contact');
    }
  }

  /* ─── Card selection (com suporte a "outros") ─────────────────────────── */
  function setupCards(groupName, stateKey, nextStep) {
    document.querySelectorAll('[data-group="' + groupName + '"]').forEach(function(card) {
      card.addEventListener('click', function() {
        document.querySelectorAll('[data-group="' + groupName + '"]')
          .forEach(function(c) { c.classList.remove('quiz__card-opt--active'); });
        card.classList.add('quiz__card-opt--active');

        var val = card.dataset.value;

        if (val === 'outros') {
          /* Mostra caixa de texto — não avança automaticamente */
          var outrosBox = document.getElementById('outros-' + groupName);
          if (outrosBox) {
            outrosBox.style.display = 'block';
            var inp = outrosBox.querySelector('.outros-input');
            if (inp) { inp.value = ''; inp.focus(); }
            var btn = outrosBox.querySelector('.outros-confirmar');
            if (btn) btn.disabled = true;
          }
        } else {
          /* Oculta caixa de outros se estava aberta */
          var outrosBox = document.getElementById('outros-' + groupName);
          if (outrosBox) outrosBox.style.display = 'none';

          state[stateKey] = val;
          setTimeout(function() {
            if (typeof nextStep === 'function') nextStep();
            else goTo(nextStep);
          }, 280);
        }
      });
    });

    /* Confirmar botão do campo "outros" */
    var outrosBox = document.getElementById('outros-' + groupName);
    if (outrosBox) {
      var inp = outrosBox.querySelector('.outros-input');
      var btn = outrosBox.querySelector('.outros-confirmar');
      if (inp && btn) {
        inp.addEventListener('input', function() {
          btn.disabled = !inp.value.trim();
        });
        btn.addEventListener('click', function() {
          if (!inp.value.trim()) return;
          state[stateKey] = 'outros';
          state.outros_textos[stateKey] = inp.value.trim();
          outrosBox.style.display = 'none';
          if (typeof nextStep === 'function') nextStep();
          else goTo(nextStep);
        });
        inp.addEventListener('keydown', function(e) {
          if (e.key === 'Enter' && inp.value.trim()) btn.click();
        });
      }
    }
  }

  /* ─── Quadrant bar renderer ──────────────────────────────────────────── */
  function renderQuadBars(containerId, quads) {
    var el = document.getElementById(containerId);
    if (!el) return;
    el.innerHTML = quads.map(function(q) {
      var barClass = 'quiz__quad-bar';
      if (q.locked) barClass += ' quiz__quad-bar--locked';
      else barClass += ' quiz__quad-bar--full';
      if (q.danger) barClass += ' quiz__quad-bar--danger';
      var labelClass = 'quiz__quad-label' + (q.weak ? ' quiz__quad-label--weak' : '');
      return '<div class="quiz__quad-row">' +
        '<span class="' + labelClass + '">' + q.key + ' — ' + q.label + '</span>' +
        '<div class="quiz__quad-track"><div class="' + barClass + '" data-w="' + (q.locked ? '' : q.score * 10) + '"></div></div>' +
        '<span class="quiz__quad-score">' + (q.locked ? '🔒' : q.score + '/10') + '</span>' +
        '</div>';
    }).join('');
    requestAnimationFrame(function() {
      el.querySelectorAll('[data-w]').forEach(function(bar) {
        var w = bar.dataset.w;
        if (w) bar.style.width = w + '%';
      });
    });
  }

  /* ─── Preview ─────────────────────────────────────────────────────────── */
  function renderPreview() {
    computeScores();
    var s = state.scores;
    var risk = getRevenueRisk();

    renderQuadBars('preview-quads', [
      { key:'P', label:'Presença',  score: s.P },
      { key:'A', label:'Aquisição', score: s.A },
      { key:'C', label:'Conversão', score: s.C, locked: true },
      { key:'R', label:'Retenção',  score: s.R, locked: true },
    ]);

    var riskEl = document.getElementById('preview-risk');
    if (riskEl) riskEl.textContent = 'R$ ' + risk.toLocaleString('pt-BR') + '/mês';
    var sectorEl = document.getElementById('preview-sector');
    if (sectorEl) sectorEl.textContent = state.q1 || '—';

    var lerBox = document.getElementById('lucro-em-risco-box');
    var riskBox = document.getElementById('preview-risk-box');
    var ler = calcLucroEmRisco(state.q8_custo_ads);
    if (ler && lerBox) {
      lerBox.style.display = 'block';
      if (riskBox) riskBox.style.display = 'none';
      document.getElementById('ler-ads').textContent         = fmtBRL(ler.ads) + '/mês';
      document.getElementById('ler-desperdicio').textContent = fmtBRL(ler.desperdicio) + '/mês';
      document.getElementById('ler-recuperacao').textContent = fmtBRL(ler.recuperacao) + '/semana';
      document.getElementById('ler-roi').textContent         = ler.roi + '×';
    } else if (lerBox) {
      lerBox.style.display = 'none';
    }
  }

  /* ─── Resultado completo ──────────────────────────────────────────────── */
  function renderResult() {
    computeScores();
    var s = state.scores;
    var weak = getWeakestQuadrant();
    var rec = RECOMMENDATIONS[weak];
    var risk = getRevenueRisk();

    renderQuadBars('result-quads', [
      { key:'P', label:'Presença',  score: s.P, weak: weak==='P', danger: weak==='P' },
      { key:'A', label:'Aquisição', score: s.A, weak: weak==='A', danger: weak==='A' },
      { key:'C', label:'Conversão', score: s.C, weak: weak==='C', danger: weak==='C' },
      { key:'R', label:'Retenção',  score: s.R, weak: weak==='R', danger: weak==='R' },
    ]);

    var riskEl = document.getElementById('result-risk');
    if (riskEl) riskEl.textContent = 'R$ ' + risk.toLocaleString('pt-BR') + '/mês';

    var recEl = document.getElementById('result-recommendation');
    if (recEl && rec) {
      recEl.innerHTML =
        '<div class="quiz__rec-icon">' + rec.icon + '</div>' +
        '<div class="quiz__rec-tag">GARGALO CRÍTICO: ' + rec.label + '</div>' +
        '<p class="quiz__rec-problem">' + rec.problem + '</p>' +
        '<div class="quiz__rec-solution">' +
          '<span class="quiz__rec-solution-label">Solução recomendada</span>' +
          '<strong>' + rec.solution + '</strong>' +
        '</div>' +
        '<p class="quiz__rec-desc">' + rec.description + '</p>';
    }

    var ctaEl = document.getElementById('btn-whatsapp-contact');
    if (ctaEl && rec) {
      var msg = encodeURIComponent(
        'Olá! Fiz o Diagnóstico Vanguard.\n' +
        'Setor: ' + state.q1 + '\n' +
        'Gargalo principal: ' + rec.label + '\n' +
        'Receita em risco: R$ ' + risk.toLocaleString('pt-BR') + '/mês\n\n' +
        rec.cta
      );
      ctaEl.href = 'https://wa.me/' + WA_NUMBER + '?text=' + msg;
    }
  }

  /* ─── Submit ──────────────────────────────────────────────────────────── */
  async function submitLead() {
    var nomeEl  = document.getElementById('quiz-nome');
    var waEl    = document.getElementById('quiz-whatsapp');
    var emailEl = document.getElementById('quiz-email');
    var btn     = document.getElementById('btn-submit');
    if (!nomeEl || !nomeEl.value.trim() || !waEl || !waEl.value.trim()) return;

    state.nome     = nomeEl.value.trim();
    state.whatsapp = waEl.value.trim();
    state.email    = emailEl ? emailEl.value.trim() : '';

    if (btn) btn.disabled = true;
    setProgress('done');
    showStep('step-processing');
    computeScores();

    var payload = {
      nicho:    state.q1,
      gargalo:  getWeakestQuadrant(),
      nome:     state.nome,
      whatsapp: state.whatsapp,
      metadata: {
        email:        state.email,
        faturamento:  state.q2,
        canal:        state.q3,
        presenca:     state.q4,
        conversao:    state.q5,
        obstaculo:    state.q6,
        historico:    state.q7,
        custo_ads:    state.q8_custo_ads,
        scores:       state.scores,
        revenue_risk: getRevenueRisk(),
        lucro_em_risco: calcLucroEmRisco(state.q8_custo_ads),
        outros_textos:  state.outros_textos,
      },
    };

    try {
      await supabaseClient.saveLeadDiagnostico(payload);
    } catch (_) { /* não bloqueia o fluxo */ }

    renderResult();
    setTimeout(function() { showStep('step-success'); }, 2200);
  }

  /* ─── Init ────────────────────────────────────────────────────────────── */
  function init() {
    setProgress(1);
    showStep('step-1');

    /* Q1 — setor dropdown */
    var selectQ1 = document.getElementById('quiz-sector');
    var btnQ1    = document.getElementById('btn-next-1');
    if (selectQ1 && btnQ1) {
      selectQ1.addEventListener('change', function() {
        state.q1 = selectQ1.value;
        btnQ1.disabled = !state.q1;
      });
      btnQ1.addEventListener('click', function() { if (state.q1) goTo(2); });
    }

    /* Q2–Q7 — grupos de cards */
    setupCards('q2', 'q2', 3);
    setupCards('q3', 'q3', 4);
    setupCards('q4', 'q4', 5);
    setupCards('q5', 'q5', 6);
    setupCards('q6', 'q6', 7);
    setupCards('q7', 'q7', 8);

    /* Q8 — Calculadora de Lucro em Risco */
    var adsInput = document.getElementById('quiz-custo-ads');
    var btn8     = document.getElementById('btn-next-8');
    var btnSkip8 = document.getElementById('btn-skip-8');
    if (adsInput) {
      adsInput.addEventListener('input', function() {
        state.q8_custo_ads = parseFloat(adsInput.value) || 0;
        updateRiskPreview();
      });
    }
    if (btn8) {
      btn8.addEventListener('click', function() {
        state.q8_custo_ads = parseFloat(adsInput?.value) || 0;
        goTo('preview');
      });
    }
    if (btnSkip8) {
      btnSkip8.addEventListener('click', function() {
        state.q8_custo_ads = 0;
        goTo('preview');
      });
    }

    /* Preview → Contato */
    var btnPreviewNext = document.getElementById('btn-preview-next');
    if (btnPreviewNext) {
      btnPreviewNext.addEventListener('click', function() { goTo('contact'); });
    }

    /* Contato: habilita submit quando nome + whatsapp válidos */
    var nomeEl = document.getElementById('quiz-nome');
    var waEl   = document.getElementById('quiz-whatsapp');
    var btn    = document.getElementById('btn-submit');
    var WA_REGEX = /^\+?[1-9]\d{7,14}$/;

    function checkContact() {
      if (btn) btn.disabled = !(nomeEl && nomeEl.value.trim() && waEl && WA_REGEX.test(waEl.value.trim()));
    }
    if (nomeEl) { nomeEl.addEventListener('input', checkContact); nomeEl.addEventListener('change', checkContact); }
    if (waEl)   { waEl.addEventListener('input', checkContact);   waEl.addEventListener('change', checkContact);   }
    if (btn)    { btn.addEventListener('click', submitLead); }
  }

  return { init };
})();
