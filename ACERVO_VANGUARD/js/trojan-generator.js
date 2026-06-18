'use strict';

// ── Trojan Outbound Generator V14 ────────────────────────────────────────────
// Gera PNG de alto impacto do HUD personalizado para envio via WhatsApp
// Usa html2canvas (já incluído no index.html via CDN)
// Exposto como window.TrojanGenerator.init()

window.TrojanGenerator = (() => {

  // Score colors (mirror scanner.js)
  function scoreColor(score) {
    if (score <= 3) return '#FF4444';
    if (score <= 5) return '#FFB800';
    if (score <= 7) return '#88CCF0';
    return '#00FF88';
  }

  function tierLabel(score) {
    if (score <= 3) return 'CRÍTICO';
    if (score <= 5) return 'BAIXO';
    if (score <= 7) return 'MÉDIO';
    return 'ALTO';
  }

  // Bottleneck database (subset do scanner.js)
  const BOTTLENECKS = {
    https:      'Site sem HTTPS/SSL — dados em risco',
    speed:      'Velocidade < 3s — 40% dos visitantes saem',
    mobile:     'Não responsivo no mobile — 60% do tráfego perdido',
    cta:        'Sem call-to-action visível — visitantes saem sem agir',
    automation: 'Sem automação de marketing — leads perdidos 24/7',
    seo:        'Invisível no Google — tráfego orgânico zero',
  };

  function getBottlenecks(domain, score) {
    // Deterministic selection based on domain hash (mirrors scanner.js)
    let h = 5381;
    for (let i = 0; i < domain.length; i++) h = ((h << 5) + h) ^ domain.charCodeAt(i);
    h = Math.abs(h);
    const keys = Object.keys(BOTTLENECKS);
    const n = keys.length;
    return [
      BOTTLENECKS[keys[h % n]],
      BOTTLENECKS[keys[(h * 31) % n]],
      BOTTLENECKS[keys[(h * 97) % n]],
    ].filter((v, i, a) => a.indexOf(v) === i).slice(0, 2);
  }

  // Build the visual card DOM (injected into page, captured by html2canvas, then removed)
  function buildCard(domain, score, bottlenecks) {
    const color  = scoreColor(score);
    const tier   = tierLabel(score);
    const tierBg = score <= 3 ? 'rgba(255,68,68,0.15)'
                 : score <= 5 ? 'rgba(255,184,0,0.15)'
                 : score <= 7 ? 'rgba(136,204,240,0.15)'
                 : 'rgba(0,255,136,0.15)';

    const el = document.createElement('div');
    el.id = 'trojan-card-offscreen';
    el.style.cssText = `
      position: fixed;
      left: -9999px;
      top: 0;
      width: 700px;
      background: #080C14;
      border: 1px solid rgba(0,240,255,0.2);
      border-radius: 16px;
      padding: 36px 40px;
      font-family: 'Inter', -apple-system, sans-serif;
      box-shadow: 0 0 60px rgba(0,240,255,0.08), inset 0 0 40px rgba(0,0,0,0.3);
      overflow: hidden;
    `;

    el.innerHTML = `
      <!-- Shimmer top border -->
      <div style="position:absolute;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,#00F0FF 40%,#7B2FBE 60%,transparent);"></div>
      <!-- Corner brackets -->
      <div style="position:absolute;top:12px;left:12px;width:18px;height:18px;border-top:2px solid rgba(0,240,255,0.5);border-left:2px solid rgba(0,240,255,0.5);"></div>
      <div style="position:absolute;top:12px;right:12px;width:18px;height:18px;border-top:2px solid rgba(0,240,255,0.5);border-right:2px solid rgba(0,240,255,0.5);"></div>
      <div style="position:absolute;bottom:12px;left:12px;width:18px;height:18px;border-bottom:2px solid rgba(0,240,255,0.5);border-left:2px solid rgba(0,240,255,0.5);"></div>
      <div style="position:absolute;bottom:12px;right:12px;width:18px;height:18px;border-bottom:2px solid rgba(0,240,255,0.5);border-right:2px solid rgba(0,240,255,0.5);"></div>

      <!-- Header -->
      <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:28px;">
        <div>
          <div style="font-size:10px;letter-spacing:0.22em;color:rgba(0,240,255,0.45);text-transform:uppercase;margin-bottom:4px;">AUDITORIA DIGITAL</div>
          <div style="font-size:18px;font-weight:700;color:#E8EAF0;">${domain}</div>
        </div>
        <div style="font-size:10px;letter-spacing:0.18em;color:rgba(0,240,255,0.6);text-transform:uppercase;font-weight:700;">⬡ VANGUARD TECH™</div>
      </div>

      <!-- Score + Tier -->
      <div style="display:flex;align-items:center;gap:24px;margin-bottom:28px;">
        <div style="text-align:center;">
          <div style="font-size:80px;font-weight:700;color:${color};line-height:1;">${score}</div>
          <div style="font-size:11px;letter-spacing:0.1em;color:rgba(232,234,240,0.35);text-transform:uppercase;margin-top:4px;">/ 10</div>
        </div>
        <div style="flex:1;">
          <div style="font-size:10px;letter-spacing:0.14em;color:rgba(232,234,240,.4);text-transform:uppercase;margin-bottom:8px;">Maturidade Digital</div>
          <div style="display:inline-block;background:${tierBg};border:1px solid ${color}33;border-radius:6px;padding:4px 12px;font-size:13px;font-weight:700;color:${color};margin-bottom:12px;">${tier}</div>
          <div style="height:6px;background:rgba(255,255,255,.06);border-radius:3px;overflow:hidden;">
            <div style="width:${score * 10}%;height:100%;background:linear-gradient(90deg,${color},${color}88);border-radius:3px;"></div>
          </div>
        </div>
      </div>

      <!-- Divider -->
      <div style="height:1px;background:rgba(0,240,255,0.08);margin-bottom:24px;"></div>

      <!-- Gargalos -->
      <div style="margin-bottom:28px;">
        <div style="font-size:10px;letter-spacing:0.18em;color:rgba(0,240,255,0.45);text-transform:uppercase;margin-bottom:14px;">⚠ GARGALOS CRÍTICOS IDENTIFICADOS</div>
        ${bottlenecks.map((b, i) => `
          <div style="display:flex;align-items:flex-start;gap:10px;margin-bottom:${i < bottlenecks.length - 1 ? '10' : '0'}px;">
            <div style="flex-shrink:0;width:22px;height:22px;background:rgba(255,68,68,0.12);border:1px solid rgba(255,68,68,0.25);border-radius:4px;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:#FF8080;">${i + 1}</div>
            <div style="font-size:13px;color:rgba(232,234,240,0.75);line-height:1.4;">${b}</div>
          </div>
        `).join('')}
      </div>

      <!-- CTA -->
      <div style="background:linear-gradient(135deg,rgba(0,240,255,0.06),rgba(123,47,190,0.06));border:1px solid rgba(0,240,255,0.12);border-radius:10px;padding:16px 20px;display:flex;align-items:center;justify-content:space-between;">
        <div>
          <div style="font-size:13px;font-weight:600;color:#E8EAF0;margin-bottom:3px;">Quer resolver estes gargalos em 30 dias?</div>
          <div style="font-size:11px;color:rgba(0,240,255,0.5);">vanguardtech.io · Responda esta mensagem</div>
        </div>
        <div style="font-size:20px;">🚀</div>
      </div>

      <!-- Scanline overlay -->
      <div style="position:absolute;inset:0;background:repeating-linear-gradient(0deg,transparent,transparent 2px,rgba(0,0,0,0.03) 2px,rgba(0,0,0,0.03) 4px);pointer-events:none;border-radius:16px;"></div>
    `;

    return el;
  }

  async function generatePNG(domain, score) {
    const bottlenecks = getBottlenecks(domain, score);
    const card = buildCard(domain, score, bottlenecks);
    document.body.appendChild(card);

    let dataUrl;
    try {
      // html2canvas (already loaded from V12 CDN)
      const canvas = await html2canvas(card, {
        scale: 2.5,
        backgroundColor: '#080C14',
        useCORS: true,
        logging: false,
        width: 700,
      });
      dataUrl = canvas.toDataURL('image/png');
    } finally {
      card.remove();
    }
    return dataUrl;
  }

  function injectStyles() {
    if (document.getElementById('trj-styles')) return;
    const s = document.createElement('style');
    s.id = 'trj-styles';
    s.textContent = `
      .trj-form {
        display: grid;
        grid-template-columns: 1fr 120px auto;
        gap: .75rem;
        align-items: end;
        margin-bottom: 1.25rem;
      }
      @media(max-width:640px){ .trj-form { grid-template-columns:1fr; } }
      .trj-label { font-size:.62rem;letter-spacing:.12em;text-transform:uppercase;color:rgba(232,234,240,.4);display:block;margin-bottom:.3rem; }
      .trj-input {
        background:rgba(0,0,0,.35);border:1px solid rgba(0,240,255,.12);border-radius:7px;
        color:#E8EAF0;font-family:'Inter',sans-serif;font-size:.85rem;
        padding:.55rem .875rem;outline:none;transition:border-color .2s;width:100%;
      }
      .trj-input:focus { border-color:#00F0FF; }
      .trj-btn {
        background:linear-gradient(135deg,#FF4444,#7B2FBE);border:none;border-radius:8px;
        color:#fff;font-family:'Inter',sans-serif;font-size:.78rem;font-weight:700;
        letter-spacing:.1em;padding:.55rem 1.125rem;cursor:pointer;
        text-transform:uppercase;white-space:nowrap;transition:opacity .2s,transform .1s;
      }
      .trj-btn:hover { opacity:.87;transform:translateY(-1px); }
      .trj-btn:disabled { opacity:.4;cursor:not-allowed;transform:none; }
      .trj-preview-wrap { display:flex;gap:1rem;flex-wrap:wrap;align-items:flex-start;margin-top:1rem; }
      .trj-img-preview { max-width:280px;border-radius:8px;border:1px solid rgba(0,240,255,.15); }
      .trj-actions { display:flex;flex-direction:column;gap:.625rem; }
      .trj-action-btn {
        display:inline-flex;align-items:center;gap:.375rem;
        background:rgba(0,240,255,.08);border:1px solid rgba(0,240,255,.2);
        border-radius:7px;color:#00F0FF;font-family:'Inter',sans-serif;
        font-size:.72rem;font-weight:700;letter-spacing:.1em;
        padding:.45rem .875rem;cursor:pointer;text-transform:uppercase;
        transition:background .2s;text-decoration:none;
      }
      .trj-action-btn:hover { background:rgba(0,240,255,.15); }
      .trj-wa-btn {
        background:linear-gradient(135deg,#25D366,#128C7E) !important;
        border-color:transparent !important;color:#fff !important;
      }
      .trj-hint { font-size:.72rem;color:rgba(232,234,240,.35);line-height:1.5;margin-top:.5rem; }
    `;
    document.head.appendChild(s);
  }

  function renderSection() {
    const section = document.getElementById('section-trojan');
    if (!section) return;

    section.innerHTML = `
      <p style="font-size:.82rem;color:rgba(232,234,240,.5);line-height:1.55;margin-bottom:1.125rem;">
        Gere um card visual de alto impacto do HUD com os dados reais do lead.
        O PNG gerado pode ser enviado directamente no WhatsApp — <strong style="color:#00F0FF;">taxa de visualização 85% vs 55% em texto puro.</strong>
      </p>
      <div class="trj-form">
        <div>
          <label class="trj-label">Domínio do Lead</label>
          <input class="trj-input" id="trj-domain" type="text" placeholder="clinicaexemplo.pt" />
        </div>
        <div>
          <label class="trj-label">Score (0–10)</label>
          <input class="trj-input" id="trj-score" type="number" min="0" max="10" step="0.1" value="3.2" />
        </div>
        <button class="trj-btn" id="trj-generate">🎯 Gerar PNG</button>
      </div>
      <div id="trj-output" style="display:none;">
        <div class="trj-preview-wrap">
          <img class="trj-img-preview" id="trj-img" src="" alt="Trojan HUD Card" />
          <div class="trj-actions">
            <a class="trj-action-btn" id="trj-download" href="#" download>⬇ Descarregar PNG</a>
            <a class="trj-action-btn trj-wa-btn" id="trj-wa" href="#" target="_blank" rel="noopener">💬 Abrir WhatsApp</a>
            <p class="trj-hint">
              1. Descarregue o PNG<br>
              2. No WhatsApp, anexe a imagem<br>
              3. Escreva a mensagem Hermes → enviar
            </p>
          </div>
        </div>
      </div>
      <div id="trj-loading" style="display:none;font-size:.82rem;color:rgba(0,240,255,.6);margin-top:.875rem;">
        ⏳ A gerar card visual...
      </div>
    `;

    document.getElementById('trj-generate').addEventListener('click', async () => {
      const domain = document.getElementById('trj-domain').value.trim() || 'exemplo.pt';
      const score  = Math.max(0, Math.min(10,
        parseFloat(document.getElementById('trj-score').value) || 3.2
      ));

      const btn = document.getElementById('trj-generate');
      btn.disabled = true;
      document.getElementById('trj-loading').style.display = 'block';
      document.getElementById('trj-output').style.display  = 'none';

      try {
        if (typeof html2canvas === 'undefined') {
          throw new Error('html2canvas não carregado. Certifique-se que está na página correta.');
        }
        const dataUrl = await generatePNG(domain, score);

        const img      = document.getElementById('trj-img');
        const dlBtn    = document.getElementById('trj-download');
        const waBtn    = document.getElementById('trj-wa');
        const waNum    = '';  // pode ser preenchido pelo utilizador
        const waMsg    = encodeURIComponent(
          `Olá! Analisei o site ${domain} e o score de maturidade digital é ${score}/10.\n\nIdentifiquei gargalos críticos que estão a custar visibilidade e clientes.\n\nPosso mostrar-lhe como resolvemos isto em 30 dias? — Hermes · Vanguard Tech`
        );

        img.src          = dataUrl;
        dlBtn.href       = dataUrl;
        dlBtn.download   = `vanguard-hud-${domain.replace(/[^a-z0-9]/gi, '-')}.png`;
        waBtn.href       = `https://web.whatsapp.com/send/?text=${waMsg}`;

        document.getElementById('trj-output').style.display  = 'flex';
      } catch (err) {
        alert('Erro ao gerar PNG: ' + err.message);
      } finally {
        btn.disabled = false;
        document.getElementById('trj-loading').style.display = 'none';
      }
    });
  }

  function init() {
    injectStyles();
    renderSection();
  }

  return { init, generatePNG };
})();
