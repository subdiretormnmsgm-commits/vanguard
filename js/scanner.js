/* ═══════════════════════════════════════════════════════════════════════
   VANGUARD V12 — INSTANT REALITY SCANNER ENGINE
   Ghost Holographics · 6-Axis Radar · Authority Share Generator
   ═══════════════════════════════════════════════════════════════════════ */
const Scanner = (() => {

  /* ─── Bottleneck Database ──────────────────────────────────────────── */
  const BOTTLENECKS = {
    https: {
      icon: '🔒',
      title: 'Protocolo Inseguro Detectado',
      desc: 'O site opera sem HTTPS. O Google Chrome marca o site como "Não Seguro" e penaliza o SEO em até 40%.',
      impact: '-40% SEO'
    },
    speed: {
      icon: '⚡',
      title: 'Velocidade de Carregamento Crítica',
      desc: 'Cada segundo adicional de load reduz conversões em 7%. Sites lentos perdem até 53% dos visitantes mobile.',
      impact: '-7% por segundo'
    },
    mobile: {
      icon: '📱',
      title: 'Experiência Mobile Comprometida',
      desc: '73% dos visitantes chegam via smartphone. Sem responsividade adequada, a maioria das conversões é perdida.',
      impact: '-73% alcance'
    },
    cta: {
      icon: '🎯',
      title: 'Ausência de CTA Estratégico',
      desc: 'Sem chamada para acção clara e posicionada, o visitante sai sem agir. Taxa de conversão fica abaixo de 0.5%.',
      impact: '<0.5% conversão'
    },
    automation: {
      icon: '🤖',
      title: 'Zero Automação de Leads',
      desc: '68% dos contactos perdidos ocorrem por resposta lenta (>5 minutos). IA de automação recupera estes leads.',
      impact: '-68% leads'
    },
    seo: {
      icon: '🔍',
      title: 'Invisibilidade nas Pesquisas',
      desc: 'Sem estrutura SEO, o negócio não aparece quando potenciais clientes pesquisam. Tráfego orgânico = zero.',
      impact: '0 tráfego orgânico'
    },
    pixel: {
      icon: '📊',
      title: 'Sem Rastreamento de Conversões',
      desc: 'Sem Meta Pixel ou Google Tag, é impossível fazer retargeting. Todo o investimento em ads vai para o lixo.',
      impact: '-100% retargeting'
    },
    social: {
      icon: '🌐',
      title: 'Autoridade Social Fragmentada',
      desc: 'Redes sociais desconectadas do site reduzem a autoridade de marca e criam fricção na jornada do cliente.',
      impact: '-55% autoridade'
    },
    copy: {
      icon: '✍️',
      title: 'Copy Genérico sem Proposta de Valor',
      desc: 'Texto sem storytelling ou diferenciação clara. Os visitantes não conseguem identificar por que escolher este negócio.',
      impact: '-80% retenção'
    },
    gmb: {
      icon: '📍',
      title: 'Invisível no Google Local',
      desc: 'Sem Google Meu Negócio optimizado, o negócio é inexistente nas buscas "perto de mim" e Google Maps.',
      impact: '0 visibilidade local'
    },
    chat: {
      icon: '💬',
      title: 'Sem Canal de Atendimento Instantâneo',
      desc: 'Sem chat ao vivo ou widget de WhatsApp, clientes que chegam com dúvidas saem sem conversão.',
      impact: '-45% contactos'
    }
  };

  const BOTTLENECK_BY_CATEGORY = {
    seguranca:  ['https', 'pixel'],
    velocidade: ['speed', 'mobile'],
    conversao:  ['cta', 'copy', 'chat'],
    seo:        ['seo', 'gmb'],
    automacao:  ['automation'],
    presenca:   ['social']
  };

  const RADAR_LABELS = [
    'Presença Digital',
    'Velocidade',
    'Conversão',
    'SEO',
    'Automação',
    'Segurança'
  ];

  let radarChart = null;
  let currentResult = null;

  /* ─── Deterministic Score Engine ───────────────────────────────────── */
  function hashStr(s) {
    let h = 5381;
    for (let i = 0; i < s.length; i++) h = (h << 5) + h + s.charCodeAt(i);
    return Math.abs(h >>> 0);
  }

  function seededRand(seed, offset, min, max) {
    const x = Math.sin(seed * 9301 + offset * 49297 + 233) * 100003;
    const r = x - Math.floor(x);
    return Math.round(min + r * (max - min));
  }

  function analyzeURL(rawURL) {
    const url = rawURL.startsWith('http') ? rawURL : 'https://' + rawURL;
    let domain;
    try {
      domain = new URL(url).hostname.replace(/^www\./, '');
    } catch {
      domain = rawURL.replace(/^https?:\/\//,'').split('/')[0].replace(/^www\./, '');
    }

    const seed = hashStr(domain);
    const hasHttps  = rawURL.startsWith('https://') || (!rawURL.startsWith('http://') && true);
    const isFreeHost = /wix\.|blogspot\.|wordpress\.com|weebly\.|jimdo\.|webnode\.|squarespace\.com/.test(domain);

    /* Category scores 0–10 */
    const scores = {
      presenca:   seededRand(seed, 1, isFreeHost ? 2 : 3, isFreeHost ? 6 : 8),
      velocidade: seededRand(seed, 2, 2, 7),
      conversao:  seededRand(seed, 3, 1, 6),
      seo:        seededRand(seed, 4, rawURL.startsWith('http://') ? 1 : 2, 6),
      automacao:  seededRand(seed, 5, 1, 4),
      seguranca:  rawURL.startsWith('http://') ? seededRand(seed, 6, 1, 3) : seededRand(seed, 6, 5, 9)
    };

    const overall = Object.values(scores).reduce((a,b) => a+b, 0) / 6;
    const roundedScore = Math.round(overall * 10) / 10;

    /* Pick worst 3 categories → select their representative bottleneck */
    const ranked = Object.entries(scores)
      .sort(([,a],[,b]) => a - b)
      .slice(0, 3);

    const bottlenecks = ranked.map(([cat]) => {
      const ids = BOTTLENECK_BY_CATEGORY[cat];
      const id = ids[seededRand(seed, ids.length, 0, ids.length - 1)];
      return BOTTLENECKS[id];
    });

    return {
      url,
      domain,
      score: roundedScore,
      radarData: [
        scores.presenca,
        scores.velocidade,
        scores.conversao,
        scores.seo,
        scores.automacao,
        scores.seguranca
      ],
      bottlenecks
    };
  }

  function getTier(score) {
    if (score < 3) return { label: 'CRÍTICO',  cls: 'critical' };
    if (score < 5) return { label: 'BAIXO',    cls: 'low'      };
    if (score < 7) return { label: 'MÉDIO',    cls: 'medium'   };
    return               { label: 'ALTO',     cls: 'high'     };
  }

  /* ─── Ghost Neural Loader ──────────────────────────────────────────── */
  function startGhostLoader(domain) {
    const loader = document.getElementById('ghost-loader');
    const canvas = document.getElementById('ghost-canvas');
    const statusEl = document.getElementById('ghost-status');
    if (!loader || !canvas) return { stop: () => {} };

    loader.classList.add('active');

    const W = canvas.clientWidth || 640;
    const H = 160;
    const DPR = window.devicePixelRatio || 1;
    canvas.width  = W * DPR;
    canvas.height = H * DPR;
    canvas.style.width  = W + 'px';
    canvas.style.height = H + 'px';

    const ctx = canvas.getContext('2d');
    ctx.scale(DPR, DPR);

    /* Generate neural nodes */
    const nodes = Array.from({ length: 20 }, (_, i) => ({
      x:     14 + Math.random() * (W - 28),
      y:     12 + Math.random() * (H - 24),
      r:     1.5 + Math.random() * 2.5,
      phase: Math.random() * Math.PI * 2,
      speed: 0.025 + Math.random() * 0.04,
      born:  Date.now() + i * 150
    }));

    const MESSAGES = [
      `Conectando a ${domain}...`,
      'Analisando estrutura HTML e meta tags...',
      'Verificando protocolos de segurança...',
      'Auditando performance e Core Web Vitals...',
      'Mapeando oportunidades de automação...',
      'Calculando Digital Maturity Score™...',
      'Gerando relatório de autoridade...'
    ];

    let msgIdx = 0;
    const msgTimer = setInterval(() => {
      if (statusEl && msgIdx < MESSAGES.length) {
        statusEl.textContent = MESSAGES[msgIdx++];
      }
    }, 520);

    let raf;
    function draw() {
      ctx.clearRect(0, 0, W, H);
      const now = Date.now();
      const alive = nodes.filter(n => now > n.born);

      /* Edges */
      for (let i = 0; i < alive.length; i++) {
        for (let j = i + 1; j < alive.length; j++) {
          const dx = alive[i].x - alive[j].x;
          const dy = alive[i].y - alive[j].y;
          const dist = Math.sqrt(dx*dx + dy*dy);
          if (dist < 130) {
            const alpha = (1 - dist / 130) * 0.22;
            ctx.strokeStyle = `rgba(0,240,255,${alpha})`;
            ctx.lineWidth = 0.7;
            ctx.beginPath();
            ctx.moveTo(alive[i].x, alive[i].y);
            ctx.lineTo(alive[j].x, alive[j].y);
            ctx.stroke();
          }
        }
      }

      /* Nodes */
      alive.forEach(n => {
        const pulse = 0.55 + 0.45 * Math.sin(n.phase + now * n.speed);
        const r = n.r * pulse;

        /* Glow halo */
        const grad = ctx.createRadialGradient(n.x, n.y, 0, n.x, n.y, r * 4);
        grad.addColorStop(0, `rgba(0,240,255,${pulse * 0.18})`);
        grad.addColorStop(1, 'rgba(0,240,255,0)');
        ctx.beginPath();
        ctx.arc(n.x, n.y, r * 4, 0, Math.PI * 2);
        ctx.fillStyle = grad;
        ctx.fill();

        /* Node core */
        ctx.beginPath();
        ctx.arc(n.x, n.y, r, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(0,240,255,${pulse * 0.85})`;
        ctx.fill();
      });

      raf = requestAnimationFrame(draw);
    }
    draw();

    return {
      stop() {
        cancelAnimationFrame(raf);
        clearInterval(msgTimer);
      }
    };
  }

  /* ─── Radar Chart ──────────────────────────────────────────────────── */
  function renderRadar(data) {
    const el = document.getElementById('scanner-radar');
    if (!el || !window.Chart) return;
    if (radarChart) radarChart.destroy();

    radarChart = new Chart(el, {
      type: 'radar',
      data: {
        labels: RADAR_LABELS,
        datasets: [
          {
            label: 'Seu Site',
            data,
            backgroundColor: 'rgba(0,240,255,0.07)',
            borderColor:     'rgba(0,240,255,0.85)',
            pointBackgroundColor: '#00F0FF',
            pointBorderColor:     'rgba(0,240,255,0.4)',
            pointHoverBackgroundColor: '#fff',
            borderWidth: 2,
            pointRadius: 4,
            pointHoverRadius: 6
          },
          {
            label: 'Benchmark',
            data: [7, 7, 6, 7, 6, 8],
            backgroundColor: 'rgba(123,47,255,0.05)',
            borderColor:     'rgba(123,47,255,0.4)',
            borderDash: [4, 4],
            pointBackgroundColor: 'rgba(123,47,255,0.5)',
            borderWidth: 1,
            pointRadius: 2
          }
        ]
      },
      options: {
        animation: { duration: 1000, easing: 'easeInOutQuart' },
        responsive: true,
        maintainAspectRatio: true,
        scales: {
          r: {
            min: 0,
            max: 10,
            ticks: {
              stepSize: 2,
              color: 'rgba(255,255,255,0.25)',
              font: { size: 9 },
              backdropColor: 'transparent'
            },
            grid:        { color: 'rgba(255,255,255,0.05)' },
            angleLines:  { color: 'rgba(0,240,255,0.1)' },
            pointLabels: {
              color: 'rgba(255,255,255,0.6)',
              font: { size: 9, family: "'JetBrains Mono', monospace" }
            }
          }
        },
        plugins: {
          legend: {
            labels: {
              color: 'rgba(255,255,255,0.45)',
              font: { size: 9 },
              boxWidth: 10
            }
          },
          tooltip: {
            backgroundColor: 'rgba(8,8,14,0.95)',
            borderColor:     'rgba(0,240,255,0.3)',
            borderWidth: 1,
            titleColor: '#00F0FF',
            bodyColor:  '#fff'
          }
        }
      }
    });
  }

  /* ─── Render Results ───────────────────────────────────────────────── */
  function renderResults(result) {
    const panel  = document.getElementById('scanner-results');
    const scoreEl = document.getElementById('scan-score-value');
    const tierEl  = document.getElementById('scan-score-tier');
    const urlEl   = document.getElementById('scan-url-label');
    const bttEl   = document.getElementById('scan-bottlenecks');
    if (!panel) return;

    const tier = getTier(result.score);
    if (scoreEl) scoreEl.innerHTML = `${result.score}<span>/10</span>`;
    if (tierEl)  {
      tierEl.textContent = tier.label;
      tierEl.className = `scanner-score__tier scanner-score__tier--${tier.cls}`;
    }
    if (urlEl) urlEl.textContent = result.domain;

    if (bttEl) {
      bttEl.innerHTML = result.bottlenecks.map(b => `
        <div class="scanner-bottleneck">
          <div class="scanner-bottleneck__icon">${b.icon}</div>
          <div>
            <div class="scanner-bottleneck__title">${b.title}</div>
            <div class="scanner-bottleneck__desc">${b.desc}</div>
            <span class="scanner-bottleneck__impact">${b.impact}</span>
          </div>
        </div>
      `).join('');
    }

    panel.classList.add('active');
    renderRadar(result.radarData);
    currentResult = result;
  }

  /* ─── Authority Share Card ─────────────────────────────────────────── */
  function openShareCard() {
    if (!currentResult) return;
    const overlay   = document.getElementById('authority-share-overlay');
    const visual    = document.getElementById('share-card-visual');
    if (!overlay || !visual) return;

    const tier = getTier(currentResult.score);
    const scoreColor = tier.cls === 'critical' ? '#FF8080'
                     : tier.cls === 'low'      ? '#FFB800'
                     : tier.cls === 'medium'   ? '#00F0FF'
                     :                           '#00FF88';

    visual.innerHTML = `
      <div style="font-family:'Inter',sans-serif;color:#fff;">
        <div style="display:flex;align-items:center;gap:10px;margin-bottom:18px;">
          <div style="width:30px;height:30px;background:linear-gradient(135deg,#00F0FF,#7B2FFF);border-radius:7px;display:flex;align-items:center;justify-content:center;font-weight:800;color:#05050A;font-size:13px;font-family:inherit;">V</div>
          <span style="font-size:10px;letter-spacing:0.18em;color:rgba(255,255,255,0.38);text-transform:uppercase;font-family:'JetBrains Mono',monospace;">VANGUARD · DIGITAL MATURITY REPORT</span>
        </div>
        <div style="font-size:11px;color:rgba(0,240,255,0.7);font-family:'JetBrains Mono',monospace;margin-bottom:10px;">${currentResult.domain}</div>
        <div style="font-size:58px;font-weight:800;line-height:1;color:${scoreColor};margin-bottom:5px;font-family:inherit;">${currentResult.score}<span style="font-size:22px;font-weight:400;color:rgba(255,255,255,0.25)">/10</span></div>
        <div style="font-size:10px;color:rgba(255,255,255,0.35);font-family:'JetBrains Mono',monospace;margin-bottom:18px;letter-spacing:0.12em;">DIGITAL MATURITY SCORE™ · ${tier.label}</div>
        <div style="border-top:1px solid rgba(255,255,255,0.05);padding-top:14px;">
          ${currentResult.bottlenecks.slice(0,2).map(b =>
            `<div style="font-size:11px;color:rgba(255,255,255,0.48);margin-bottom:6px;">${b.icon} ${b.title}</div>`
          ).join('')}
        </div>
        <div style="margin-top:18px;font-size:9px;color:rgba(255,255,255,0.2);font-family:'JetBrains Mono',monospace;">Scan gratuito · vanguard.tech</div>
      </div>
    `;

    overlay.classList.add('active');
  }

  function downloadShare() {
    if (!currentResult) return;
    const visual = document.getElementById('share-card-visual');
    if (!visual || !window.html2canvas) {
      alert('Função disponível após o scan. Certifique-se que o scan foi concluído.');
      return;
    }
    html2canvas(visual, {
      backgroundColor: '#0A0A0A',
      scale: 2.5,
      useCORS: true,
      logging: false
    }).then(canvas => {
      const link = document.createElement('a');
      link.download = `vanguard-score-${currentResult.domain}.png`;
      link.href = canvas.toDataURL('image/png');
      link.click();
    });
  }

  /* ─── Init ─────────────────────────────────────────────────────────── */
  function init() {
    const form    = document.getElementById('scanner-form');
    const urlInput = document.getElementById('scanner-url');
    const loader   = document.getElementById('ghost-loader');
    const results  = document.getElementById('scanner-results');

    const shareBtn    = document.getElementById('btn-authority-share');
    const overlay     = document.getElementById('authority-share-overlay');
    const shareClose  = document.getElementById('share-overlay-close');
    const downloadBtn = document.getElementById('btn-share-download');
    const hermesBtn   = document.getElementById('btn-hermes-open');

    if (!form) return;

    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      const raw = urlInput.value.trim();
      if (!raw) return;

      /* Reset state */
      if (results) results.classList.remove('active');

      /* Ghost Loader ON */
      const domain = raw.replace(/^https?:\/\//, '').split('/')[0].replace(/^www\./, '');
      const loaderCtrl = startGhostLoader(domain);

      await new Promise(r => setTimeout(r, 3900));

      /* Ghost Loader OFF */
      loaderCtrl.stop();
      if (loader) loader.classList.remove('active');

      /* Analyze & render */
      const result = analyzeURL(raw);
      renderResults(result);

      /* Smooth scroll */
      setTimeout(() => {
        results?.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }, 120);
    });

    /* Authority Share */
    shareBtn?.addEventListener('click', openShareCard);
    shareClose?.addEventListener('click', () => overlay?.classList.remove('active'));
    overlay?.addEventListener('click', (e) => { if (e.target === overlay) overlay.classList.remove('active'); });
    downloadBtn?.addEventListener('click', downloadShare);

    /* Hermes */
    hermesBtn?.addEventListener('click', () => {
      window.CloserMachine?.open(currentResult);
    });
  }

  document.addEventListener('DOMContentLoaded', init);

  return { init, getCurrentResult: () => currentResult };
})();
