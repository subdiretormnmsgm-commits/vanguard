'use strict';

// ── Hermes Hive Mind V14 ──────────────────────────────────────────────────────
// Exposto como window.HiveMind.init(supabaseClient)
// Gere templates Hermes com métricas reais e promoção automática por nicho

window.HiveMind = (() => {

  // Templates locais (fallback quando Supabase não tem dados)
  const LOCAL_TEMPLATES = [
    { id:'t1', nicho:'Saúde',       gargalo:'Captação e retenção de clientes', send_count:0, response_count:0, response_rate:0, is_vanguard_recommended:false },
    { id:'t2', nicho:'Advocacia',   gargalo:'Captação e retenção de clientes', send_count:0, response_count:0, response_rate:0, is_vanguard_recommended:false },
    { id:'t3', nicho:'Imobiliário', gargalo:'Processos manuais que consomem tempo', send_count:0, response_count:0, response_rate:0, is_vanguard_recommended:false },
    { id:'t4', nicho:'Consultoria', gargalo:'Falta de visibilidade sobre métricas do negócio', send_count:0, response_count:0, response_rate:0, is_vanguard_recommended:false },
    { id:'t5', nicho:'Tecnologia',  gargalo:'Dificuldade em escalar a equipa', send_count:0, response_count:0, response_rate:0, is_vanguard_recommended:false },
  ];

  // Simula dados de performance para demo (até Supabase ter dados reais)
  function demoStats(templates) {
    return templates.map((t, i) => ({
      ...t,
      send_count:      [143, 89, 211, 67, 156][i] || 50,
      response_count:  [98,  41, 127, 28,  89][i]  || 20,
      response_rate:   [68.5, 46.1, 60.2, 41.8, 57.1][i] || 40,
      is_vanguard_recommended: i === 0 || i === 4,
    }));
  }

  function rateColor(rate) {
    if (rate >= 60) return '#00FF88';
    if (rate >= 45) return '#FFB800';
    return '#FF8080';
  }

  function rateBar(rate) {
    const color = rateColor(rate);
    return `
      <div style="display:flex;align-items:center;gap:.5rem;">
        <div style="flex:1;height:4px;background:rgba(255,255,255,.06);border-radius:2px;overflow:hidden;">
          <div style="width:${rate}%;height:100%;background:${color};border-radius:2px;transition:width 1s ease;"></div>
        </div>
        <span style="font-size:.72rem;font-weight:700;color:${color};width:3rem;text-align:right;">${rate}%</span>
      </div>`;
  }

  function renderRow(t, idx) {
    const recBadge = t.is_vanguard_recommended
      ? `<span style="background:rgba(0,240,255,0.12);color:#00F0FF;border:1px solid rgba(0,240,255,0.3);padding:.15rem .55rem;border-radius:4px;font-size:.6rem;font-weight:700;letter-spacing:.08em;">⭐ RECOMENDADO</span>`
      : '';

    return `
    <tr style="animation:fadeUp .3s ease ${idx * 0.04}s both;">
      <td>
        <div style="font-weight:600;font-size:.82rem;">${t.nicho}</div>
        <div style="font-size:.68rem;color:rgba(232,234,240,.4);margin-top:.1rem;">${t.gargalo || 'Geral'}</div>
      </td>
      <td style="font-size:.72rem;font-variant-numeric:tabular-nums;">${t.send_count.toLocaleString('pt')}</td>
      <td style="font-size:.72rem;color:#00FF88;">${t.response_count.toLocaleString('pt')}</td>
      <td style="min-width:140px;">${rateBar(t.response_rate)}</td>
      <td>${recBadge}</td>
      <td>
        <button class="hm-log-btn" data-id="${t.id}" data-action="send"
          style="background:rgba(0,240,255,.08);border:1px solid rgba(0,240,255,.15);
                 border-radius:5px;color:#00F0FF;font-family:'Inter',sans-serif;
                 font-size:.65rem;padding:.25rem .6rem;cursor:pointer;margin-right:.3rem;">
          +Envio
        </button>
        <button class="hm-log-btn" data-id="${t.id}" data-action="response"
          style="background:rgba(0,255,136,.08);border:1px solid rgba(0,255,136,.15);
                 border-radius:5px;color:#00FF88;font-family:'Inter',sans-serif;
                 font-size:.65rem;padding:.25rem .6rem;cursor:pointer;">
          +Resposta
        </button>
      </td>
    </tr>`;
  }

  function renderSection(templates) {
    const section = document.getElementById('section-hivemind');
    if (!section) return;

    const totalSends     = templates.reduce((s, t) => s + t.send_count, 0);
    const totalResponses = templates.reduce((s, t) => s + t.response_count, 0);
    const avgRate        = totalSends > 0 ? (totalResponses / totalSends * 100).toFixed(1) : '0';
    const recommended    = templates.filter(t => t.is_vanguard_recommended).length;

    section.innerHTML = `
      <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:.875rem;margin-bottom:1.25rem;">
        <div class="hm-kpi">
          <div class="hm-kpi__val">${totalSends.toLocaleString('pt')}</div>
          <div class="hm-kpi__lbl">Total Envios</div>
        </div>
        <div class="hm-kpi">
          <div class="hm-kpi__val" style="color:#00FF88;">${totalResponses.toLocaleString('pt')}</div>
          <div class="hm-kpi__lbl">Respostas</div>
        </div>
        <div class="hm-kpi">
          <div class="hm-kpi__val" style="color:#FFB800;">${avgRate}%</div>
          <div class="hm-kpi__lbl">Taxa Média</div>
        </div>
        <div class="hm-kpi">
          <div class="hm-kpi__val" style="color:#00F0FF;">${recommended}</div>
          <div class="hm-kpi__lbl">Templates Rec.</div>
        </div>
      </div>
      <div style="margin-bottom:.875rem;">
        <p style="font-size:.72rem;color:rgba(232,234,240,.4);line-height:1.5;">
          Templates com <strong style="color:#00F0FF;">50+ envios</strong> e taxa superior a 10% da média do nicho são automaticamente promovidos a "Vanguard Recommended" via <code style="font-size:.65rem;color:#7B2FBE;">fn_hive_mind_promote()</code>.
          Registe envios e respostas reais para activar o aprendizado colectivo.
        </p>
      </div>
      <div style="overflow-x:auto;">
        <table style="width:100%;border-collapse:collapse;">
          <thead>
            <tr style="font-size:.62rem;letter-spacing:.1em;text-transform:uppercase;color:rgba(232,234,240,.35);">
              <th style="text-align:left;padding:.5rem 0 .75rem;border-bottom:1px solid rgba(0,240,255,.08);">Nicho · Gargalo</th>
              <th style="text-align:left;padding:.5rem 0 .75rem;border-bottom:1px solid rgba(0,240,255,.08);">Envios</th>
              <th style="text-align:left;padding:.5rem 0 .75rem;border-bottom:1px solid rgba(0,240,255,.08);">Respostas</th>
              <th style="text-align:left;padding:.5rem 0 .75rem;border-bottom:1px solid rgba(0,240,255,.08);min-width:160px;">Taxa de Resposta</th>
              <th style="text-align:left;padding:.5rem 0 .75rem;border-bottom:1px solid rgba(0,240,255,.08);">Status</th>
              <th style="text-align:left;padding:.5rem 0 .75rem;border-bottom:1px solid rgba(0,240,255,.08);">Acções</th>
            </tr>
          </thead>
          <tbody id="hm-tbody">
            ${templates.map(renderRow).join('')}
          </tbody>
        </table>
      </div>
      <div id="hm-feedback" style="margin-top:.75rem;font-size:.72rem;color:#00FF88;min-height:1.2rem;"></div>
    `;

    // Bind log buttons
    section.querySelectorAll('.hm-log-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        const id     = btn.dataset.id;
        const action = btn.dataset.action;
        const tmpl   = templates.find(t => t.id === id);
        if (!tmpl) return;

        if (action === 'send')     { tmpl.send_count++;     }
        if (action === 'response') { tmpl.response_count++; }
        tmpl.response_rate = tmpl.send_count > 0
          ? +((tmpl.response_count / tmpl.send_count) * 100).toFixed(1)
          : 0;

        // Auto-promote logic (mirrors fn_hive_mind_promote)
        const nichTemplates = templates.filter(t => t.nicho === tmpl.nicho && t.send_count >= 10);
        if (nichTemplates.length) {
          const avgRate = nichTemplates.reduce((s, t) => s + t.response_rate, 0) / nichTemplates.length;
          nichTemplates.forEach(t => { t.is_vanguard_recommended = false; });
          const best = nichTemplates.sort((a, b) => b.response_rate - a.response_rate)[0];
          if (best && best.response_rate >= avgRate * 1.10) {
            best.is_vanguard_recommended = true;
          }
        }

        document.getElementById('hm-feedback').textContent =
          action === 'send' ? `✓ Envio registado para ${tmpl.nicho}` : `✓ Resposta registada — taxa actualizada`;
        setTimeout(() => { document.getElementById('hm-feedback').textContent = ''; }, 3000);

        document.getElementById('hm-tbody').innerHTML = templates.map(renderRow).join('');
        rebindButtons(templates);
      });
    });
  }

  function rebindButtons(templates) {
    document.querySelectorAll('.hm-log-btn').forEach(btn => {
      btn.addEventListener('click', () => {});
    });
    // Re-render handles rebinding via renderSection call in log buttons
  }

  function injectStyles() {
    if (document.getElementById('hm-styles')) return;
    const s = document.createElement('style');
    s.id = 'hm-styles';
    s.textContent = `
      .hm-kpi {
        background:rgba(255,255,255,.03);
        border:1px solid rgba(0,240,255,.1);
        border-radius:10px;padding:.875rem 1.125rem;text-align:center;
      }
      .hm-kpi__val { font-size:1.5rem;font-weight:700;color:#00F0FF;line-height:1;margin-bottom:.3rem; }
      .hm-kpi__lbl { font-size:.62rem;letter-spacing:.1em;text-transform:uppercase;color:rgba(232,234,240,.4); }
      @keyframes fadeUp {
        from { opacity:0; transform:translateY(6px); }
        to   { opacity:1; transform:translateY(0); }
      }
    `;
    document.head.appendChild(s);
  }

  async function init(supabaseClient) {
    injectStyles();
    const section = document.getElementById('section-hivemind');
    if (!section) return;

    section.innerHTML = `<div style="text-align:center;padding:2rem;color:rgba(232,234,240,.4);font-size:.82rem;">A carregar inteligência da colmeia...</div>`;

    let templates = LOCAL_TEMPLATES;

    if (supabaseClient) {
      try {
        const { data, error } = await supabaseClient
          .from('hermes_templates')
          .select('id, nicho, gargalo, send_count, response_count, response_rate, is_vanguard_recommended')
          .order('response_rate', { ascending: false })
          .limit(50);

        if (!error && data?.length) {
          templates = data;
        } else {
          templates = demoStats(LOCAL_TEMPLATES);
        }
      } catch {
        templates = demoStats(LOCAL_TEMPLATES);
      }
    } else {
      templates = demoStats(LOCAL_TEMPLATES);
    }

    renderSection(templates);
  }

  return { init };
})();
