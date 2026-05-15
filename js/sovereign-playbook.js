/* ═══════════════════════════════════════════════════════════════════════════
   VANGUARD V18 — SOVEREIGN PLAYBOOK ENGINE
   Gerador de Plano Estratégico 90 dias (12 semanas) ancorado ao ecossistema
   Base: RealScanner V15 (bottlenecks) + jsPDF V12 (client-side) + Ion Gold V16
   Lock-in: cada tarefa requer um Power-Up Vanguard activo — cliente não sai
   Free: semanas 1-2 (lead magnet) | Completo: R$97/mês Neural Sentinel
   ═══════════════════════════════════════════════════════════════════════════ */
const SovereignPlaybook = (() => {
  'use strict';

  // Ion Gold + Deep Obsidian — mesma paleta da V17
  const GOLD  = [197, 160, 40];
  const OBS   = [10,  8,   2];
  const WHITE = [230, 228, 220];
  const DIM   = [90,  85,  70];
  const GREEN = [50,  200, 120];
  const CYAN  = [0,   200, 210];
  const RED   = [220, 60,  60];

  // Power-Ups do ecossistema — cada tarefa ancora um módulo
  const POWER_UPS = {
    scanner:  { label: 'RealScanner™',   icon: '🔬', module: 'Scanner de Site' },
    pixel:    { label: 'Sovereign Pixel',      icon: '📡', module: 'Pixel de Intenção' },
    hermes:   { label: 'Hermes Outbound',      icon: '⚡',       module: 'Motor de Prospecção' },
    closer:   { label: 'Hermes Closer',        icon: '🤖', module: 'Closer Machine' },
    audit:    { label: 'Neural Audit',         icon: '📊', module: 'Neural Audit Trail' },
    sentinel: { label: 'Neural Sentinel',      icon: '🛡️', module: 'Sentinela Semanal' },
    badge:    { label: 'Authority Badge',      icon: '🏆', module: 'Selo de Autoridade' },
    hive:     { label: 'Hive Mind™',      icon: '🧠', module: 'Inteligência Coletiva' },
  };

  // Tasks 1-6 por tipo de gargalo principal (personalizado por bottleneck)
  const BOTTLENECK_MAP = {
    velocidade: [
      { week: 1, task: 'Executar RealScanner™ completo e documentar Score de Base',                       powerUp: 'scanner',  impact: 'ALTO' },
      { week: 2, task: 'Instalar Sovereign Pixel para medir taxa de bounce por velocidade real',               powerUp: 'pixel',    impact: 'ALTO' },
      { week: 3, task: 'Gerar Neural Audit Trail — tradução financeira da lentidão em R$/mês', powerUp: 'audit',    impact: 'CRÍTICO' },
      { week: 4, task: 'Activar Neural Sentinel — monitorar delta semanal de sessões perdidas',      powerUp: 'sentinel', impact: 'ALTO' },
      { week: 5, task: 'Configurar alertas Sentinel para quedas de FIRE > 15%',                               powerUp: 'sentinel', impact: 'MÉDIO' },
      { week: 6, task: 'Re-scan RealScanner™ — medir melhoria vs Score de Base (Sem. 1)',           powerUp: 'scanner',  impact: 'ALTO' },
    ],
    seo: [
      { week: 1, task: 'Scan SEO completo — mapear posição vs 3 concorrentes com RealScanner™', powerUp: 'scanner', impact: 'CRÍTICO' },
      { week: 2, task: 'Instalar Authority Badge — link-building passivo e prova social imediata',            powerUp: 'badge',    impact: 'ALTO' },
      { week: 3, task: 'Lançar Hermes Outbound — 20 prospectos/dia com Hive Mind™ activo',               powerUp: 'hermes',   impact: 'ALTO' },
      { week: 4, task: 'Neural Audit Trail como lead magnet — 3 páginas gratuitas para captura',         powerUp: 'audit',    impact: 'CRÍTICO' },
      { week: 5, task: 'Instalar Sovereign Pixel — rastrear origem de tráfego orgânico real',       powerUp: 'pixel',    impact: 'MÉDIO' },
      { week: 6, task: 'Neural Sentinel — comparar semanas antes/após optimização SEO',        powerUp: 'sentinel', impact: 'ALTO' },
    ],
    conversao: [
      { week: 1, task: 'Activar Hermes Closer™ na landing principal — qualificação automática 24/7', powerUp: 'closer',   impact: 'CRÍTICO' },
      { week: 2, task: 'Lançar Neural Audit Trail — lead magnet de R$50 para captura qualificada',                        powerUp: 'audit',    impact: 'CRÍTICO' },
      { week: 3, task: 'Instalar Sovereign Pixel — mapear abandono de CTA em tempo real',                                 powerUp: 'pixel',    impact: 'ALTO' },
      { week: 4, task: 'Analisar sessões FIRE com Neural Sentinel — agir em leads quentes',                          powerUp: 'sentinel', impact: 'ALTO' },
      { week: 5, task: 'Hermes Outbound — disparar mensagens WhatsApp para sessões FIRE detectadas',                 powerUp: 'hermes',   impact: 'CRÍTICO' },
      { week: 6, task: 'Hive Mind™ — activar templates com maior taxa de resposta no nicho',                        powerUp: 'hive',     impact: 'MÉDIO' },
    ],
    default: [
      { week: 1, task: 'Diagnóstico base com RealScanner™ — identificar Score inicial',     powerUp: 'scanner',  impact: 'ALTO' },
      { week: 2, task: 'Instalar Authority Badge no site — credibilidade imediata',                    powerUp: 'badge',    impact: 'MÉDIO' },
      { week: 3, task: 'Lançar Neural Audit Trail como lead magnet (3 páginas gratuitas)',             powerUp: 'audit',    impact: 'ALTO' },
      { week: 4, task: 'Instalar Sovereign Pixel — começar a recolher dados de intenção', powerUp: 'pixel',  impact: 'ALTO' },
      { week: 5, task: 'Activar Hermes Outbound — 20 prospectos/dia via prospectar.ps1',               powerUp: 'hermes',   impact: 'CRÍTICO' },
      { week: 6, task: 'Neural Sentinel — monitorar evolução semanal e agir em quedas',      powerUp: 'sentinel', impact: 'ALTO' },
    ],
  };

  // Semanas 7-12 — growth e consolidação (iguais para todos os tipos)
  const WEEKS_7_12 = [
    { week: 7,  task: 'Escalar Hermes Outbound para 50 prospectos/dia com templates Hive Mind™', powerUp: 'hermes',   impact: 'CRÍTICO' },
    { week: 8,  task: 'Activar Neural Sentinel Premium — alertas preditivos 48h de antecedência', powerUp: 'sentinel', impact: 'ALTO' },
    { week: 9,  task: 'Re-scan RealScanner™ completo — medir ROI da implementação (Score vs Sem. 1)', powerUp: 'scanner',  impact: 'ALTO' },
    { week: 10, task: 'Hive Mind™ — analisar benchmark do nicho e reposicionar templates Hermes', powerUp: 'hive',     impact: 'MÉDIO' },
    { week: 11, task: 'Neural Audit Trail semanal — enviar para top 5 prospects como prova social',   powerUp: 'audit',    impact: 'ALTO' },
    { week: 12, task: 'Revisão estratégica 90 dias: meta é MRR > R$1.350 com 5 clientes activos', powerUp: 'sentinel', impact: 'CRÍTICO' },
  ];

  function detectBottleneckType(bottlenecks) {
    if (!bottlenecks || !bottlenecks.length) return 'default';
    const t = (bottlenecks[0]?.title || '').toLowerCase();
    if (t.includes('velocidade') || t.includes('speed') || t.includes('performance') || t.includes('lentid')) return 'velocidade';
    if (t.includes('seo') || t.includes('visibilidade') || t.includes('organic')) return 'seo';
    if (t.includes('convers') || t.includes('cta') || t.includes('lead')) return 'conversao';
    return 'default';
  }

  function buildPlan(scanData) {
    const type = detectBottleneckType(scanData?.bottlenecks);
    return [...(BOTTLENECK_MAP[type] || BOTTLENECK_MAP.default), ...WEEKS_7_12];
  }

  // ─── PDF Generation ───────────────────────────────────────────────────────────
  function _generatePDF(scanData, fullVersion) {
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF({ unit: 'mm', format: 'a4' });
    const W = 210, H = 297;
    const plan = buildPlan(scanData);
    const domain = scanData?.domain || 'seu domínio';
    const score  = scanData?.score  || 5;
    const lostRev = scanData?.financial?.lostRevenue || Math.round((10 - score) * 2200);

    const fill   = (...c) => doc.setFillColor(...c);
    const stroke = (...c) => doc.setDrawColor(...c);
    const tColor = (...c) => doc.setTextColor(...c);
    const font   = (s, w = 'normal') => { doc.setFontSize(s); doc.setFont('helvetica', w); };

    // ── CAPA ──────────────────────────────────────────────────────────────────
    fill(...OBS); doc.rect(0, 0, W, H, 'F');
    fill(...GOLD); doc.rect(0, 0, W, 3, 'F');

    tColor(...GOLD); font(8, 'bold'); doc.text('SOVEREIGN PLAYBOOK™', W / 2, 32, { align: 'center' });
    tColor(...WHITE); font(26, 'bold'); doc.text('PLANO DE 90 DIAS', W / 2, 52, { align: 'center' });
    font(11); doc.text('para ' + domain, W / 2, 63, { align: 'center' });

    // Score badge
    fill(20, 16, 5); stroke(...GOLD); doc.setLineWidth(0.5);
    doc.roundedRect(W / 2 - 33, 76, 66, 26, 4, 4, 'FD');
    tColor(...GOLD); font(7, 'bold'); doc.text('DIGITAL MATURITY SCORE™', W / 2, 87, { align: 'center' });
    tColor(...WHITE); font(20, 'bold'); doc.text(score + '/10', W / 2, 98, { align: 'center' });

    // Caixa de alerta de receita
    fill(40, 10, 10); doc.rect(20, 116, W - 40, 24, 'F');
    fill(...RED); doc.rect(20, 116, 4, 24, 'F');
    tColor(...RED); font(7, 'bold'); doc.text('RECEITA EM RISCO', 30, 126);
    tColor(...WHITE); font(18, 'bold'); doc.text('R$ ' + lostRev.toLocaleString('pt-BR') + '/mês', 30, 136);
    font(7); tColor(...DIM); doc.text('estimativa baseada em benchmark B2B Brasil · 2,3% conversão', 30, 142);

    // Promessas do Playbook
    tColor(...GOLD); font(9, 'bold'); doc.text('O QUE ESTE PLAYBOOK ENTREGA:', W / 2, 165, { align: 'center' });
    const promises = [
      '12 semanas de acção concreta, semana a semana',
      'Cada tarefa ligada a um Power-Up Vanguard — plano não existe sem a plataforma',
      'Metas de MRR por fase com tracking automático via Neural Sentinel',
      'Score de referência + re-scan a cada 6 semanas para medir ROI real',
    ];
    tColor(...WHITE); font(9);
    promises.forEach((p, i) => doc.text('→ ' + p, W / 2, 175 + i * 9, { align: 'center' }));

    tColor(...DIM); font(7); doc.text('Vanguard Tech · Sovereign Intelligence Platform · 2026', W / 2, H - 12, { align: 'center' });
    tColor(...GOLD); doc.text('vanguardtech.io', W / 2, H - 7, { align: 'center' });

    // ── PÁG 2: SEMANAS 1-2 (preview gratuito) ─────────────────────────────────
    doc.addPage();
    fill(...OBS); doc.rect(0, 0, W, H, 'F');
    fill(...GOLD); doc.rect(0, 0, W, 3, 'F');

    tColor(...GOLD); font(7, 'bold'); doc.text('SOVEREIGN PLAYBOOK™ — PREVIEW GRATUITO', 20, 16);
    tColor(...WHITE); font(15, 'bold'); doc.text('SEMANAS 1 & 2 — Quick Wins', 20, 27);
    font(8); tColor(...DIM); doc.text('As primeiras 2 semanas de acção imediata para ' + domain, 20, 35);

    let y = 50;
    plan.filter(t => t.week <= 2).forEach(task => {
      const pu  = POWER_UPS[task.powerUp];
      const iC  = task.impact === 'CRÍTICO' ? RED : task.impact === 'ALTO' ? GOLD : [90, 200, 100];
      fill(20, 16, 5); stroke(...GOLD); doc.setLineWidth(0.3);
      doc.roundedRect(15, y - 5, W - 30, 30, 3, 3, 'FD');
      tColor(...GOLD); font(8, 'bold'); doc.text('SEMANA ' + task.week, 22, y + 2);
      fill(...iC); doc.roundedRect(W - 52, y - 3, 34, 8, 2, 2, 'F');
      tColor(...OBS); font(7, 'bold'); doc.text(task.impact, W - 35, y + 3, { align: 'center' });
      tColor(...WHITE); font(10, 'bold');
      const lines = doc.splitTextToSize(task.task, W - 60);
      doc.text(lines, 22, y + 13);
      fill(...GOLD); doc.roundedRect(22, y + 19, 52, 6, 2, 2, 'F');
      tColor(...OBS); font(7, 'bold'); doc.text(pu.icon + ' ' + pu.label, 48, y + 23, { align: 'center' });
      y += 40;
    });

    // Paywall para versão gratuita
    if (!fullVersion) {
      const wallY = Math.max(y + 10, 185);
      fill(15, 12, 3); doc.rect(15, wallY, W - 30, H - wallY - 12, 'F');
      stroke(...GOLD); doc.setLineWidth(0.5); doc.roundedRect(15, wallY, W - 30, H - wallY - 12, 4, 4, 'D');
      tColor(...GOLD); font(13, 'bold'); doc.text('🔒 SEMANAS 3 A 12 BLOQUEADAS', W / 2, wallY + 18, { align: 'center' });
      tColor(...WHITE); font(9); doc.text('O plano completo está disponível no Neural Sentinel™', W / 2, wallY + 30, { align: 'center' });
      tColor(...DIM); font(8); doc.text('Inclui: Semanas 3-12 · Tracking automático · Alertas semanais · R$97/mês', W / 2, wallY + 39, { align: 'center' });
      fill(...GOLD); doc.roundedRect(W / 2 - 48, wallY + 48, 96, 16, 4, 4, 'F');
      tColor(...OBS); font(10, 'bold'); doc.text('Activar Neural Sentinel — R$ 97/mês →', W / 2, wallY + 59, { align: 'center' });
    }

    // ── SEMANAS 3-12 (versão paga) ──────────────────────────────────────────
    if (fullVersion) {
      const paidWeeks = plan.filter(t => t.week >= 3);
      for (let p = 0; p < paidWeeks.length; p += 3) {
        doc.addPage();
        fill(...OBS); doc.rect(0, 0, W, H, 'F');
        fill(...GOLD); doc.rect(0, 0, W, 3, 'F');
        const slice = paidWeeks.slice(p, p + 3);
        tColor(...GOLD); font(7, 'bold'); doc.text('SOVEREIGN PLAYBOOK™ — PLANO COMPLETO', 20, 16);
        tColor(...WHITE); font(15, 'bold');
        doc.text('SEMANAS ' + slice[0].week + '–' + slice[slice.length - 1].week, 20, 27);
        let y2 = 44;
        slice.forEach(task => {
          const pu = POWER_UPS[task.powerUp];
          const iC = task.impact === 'CRÍTICO' ? RED : task.impact === 'ALTO' ? GOLD : [90, 200, 100];
          fill(20, 16, 5); stroke(...GOLD); doc.setLineWidth(0.3);
          doc.roundedRect(15, y2 - 5, W - 30, 38, 3, 3, 'FD');
          tColor(...GOLD); font(8, 'bold'); doc.text('SEMANA ' + task.week, 22, y2 + 3);
          fill(...iC); doc.roundedRect(W - 54, y2 - 3, 36, 9, 2, 2, 'F');
          tColor(...OBS); font(7, 'bold'); doc.text(task.impact, W - 36, y2 + 3.5, { align: 'center' });
          tColor(...WHITE); font(10, 'bold');
          const lines = doc.splitTextToSize(task.task, W - 65);
          doc.text(lines, 22, y2 + 15);
          fill(...GOLD); doc.roundedRect(22, y2 + 26, 55, 7, 2, 2, 'F');
          tColor(...OBS); font(7, 'bold'); doc.text(pu.icon + ' ' + pu.label, 49, y2 + 30.5, { align: 'center' });
          y2 += 54;
        });
        tColor(...DIM); font(7); doc.text('Vanguard Sovereign Playbook™ · ' + domain + ' · 2026', W / 2, H - 8, { align: 'center' });
      }

      // Página final: resumo executivo 90 dias
      doc.addPage();
      fill(...OBS); doc.rect(0, 0, W, H, 'F');
      fill(...GOLD); doc.rect(0, 0, W, 3, 'F');
      tColor(...GOLD); font(11, 'bold'); doc.text('RESUMO EXECUTIVO — 90 DIAS', W / 2, 28, { align: 'center' });
      const phases = [
        { label: 'FASE 1 — Quick Wins (Sem. 1-4)',   goal: 'Score base + Pixel activo + 1.º Neural Audit vendido', color: CYAN },
        { label: 'FASE 2 — Tracção (Sem. 5-8)',      goal: 'Hermes Outbound 20+ leads/dia · MRR > R$270',   color: GOLD },
        { label: 'FASE 3 — Consolidação (Sem. 9-12)', goal: 'Re-scan + 5 clientes activos · MRR > R$1.350', color: GREEN },
      ];
      let py = 46;
      phases.forEach(ph => {
        fill(20, 16, 5); stroke(...ph.color); doc.setLineWidth(0.5);
        doc.roundedRect(20, py, W - 40, 30, 3, 3, 'FD');
        fill(...ph.color); doc.rect(20, py, 5, 30, 'F');
        tColor(...ph.color); font(9, 'bold'); doc.text(ph.label, 32, py + 12);
        tColor(...WHITE); font(8); doc.text('Meta: ' + ph.goal, 32, py + 23);
        py += 40;
      });
      tColor(...WHITE); font(9, 'bold'); doc.text('REGRA DO ARQUITECTO-MESTRE:', 20, py + 14);
      tColor(...DIM); font(8);
      doc.text('Cada versão que fecha sem 1 conversa de venda é incompleta.', 20, py + 23);
      doc.text('Use o Hermes Outbound hoje. O código está pronto. O mercado está à espera.', 20, py + 31);
      tColor(...DIM); font(7); doc.text('Vanguard Tech · Sovereign Intelligence · 2026', W / 2, H - 8, { align: 'center' });
    }

    return doc;
  }

  // ─── API Pública ──────────────────────────────────────────────────────────────
  function generateFree(scanData) {
    if (!window.jspdf) { console.error('SovereignPlaybook: jsPDF não carregado'); return; }
    const doc = _generatePDF(scanData, false);
    doc.save('Sovereign-Playbook-Preview-' + (scanData?.domain || 'vanguard') + '.pdf');
  }

  async function generatePaid(scanData) {
    try {
      const res = await fetch('/api/stripe/sentinel-checkout', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ domain: scanData?.domain, score: scanData?.score, plan: 'neural_sentinel_97' }),
      });
      if (!res.ok) throw new Error('stripe');
      const { url } = await res.json();
      window.location.href = url;
    } catch {
      alert('Activação temporáriamente indisponível. Contacte suporte@vanguardtech.io');
    }
  }

  function checkPostPayment(scanData) {
    if (new URLSearchParams(window.location.search).get('playbook_paid') !== '1') return;
    if (!window.jspdf || !scanData) return;
    const doc = _generatePDF(scanData, true);
    doc.save('Sovereign-Playbook-Completo-' + (scanData?.domain || 'vanguard') + '.pdf');
    window.history.replaceState({}, '', window.location.pathname);
  }

  return { generateFree, generatePaid, checkPostPayment, buildPlan };
})();
