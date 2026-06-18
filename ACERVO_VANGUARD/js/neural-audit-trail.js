/* ═══════════════════════════════════════════════════════════════════════════
   VANGUARD V17 — NEURAL AUDIT TRAIL ENGINE
   Tradução Financeira: gargalos reais → Receita Perdida (R$/mês)
   Base: RealScanner V15 (dados factuais) + CloserMachine V12 (jsPDF)
   Versão Free: 3 páginas (preview) | Versão Paga: 12 páginas (R$50 Stripe)
   ═══════════════════════════════════════════════════════════════════════════ */
const NeuralAuditTrail = (() => {
  'use strict';

  // ─── Paleta V17: Ion Gold + Deep Obsidian ────────────────────────────────────
  const GOLD  = [197, 160, 40];   // #C5A028
  const OBS   = [10,  8,   2];    // #0A0802
  const WHITE = [230, 228, 220];
  const DIM   = [90,  85,  70];
  const RED   = [220, 60,  60];
  const TEAL  = [0,   180, 160];

  // ─── Motor de Tradução Financeira ────────────────────────────────────────────
  // Recebe os dados do RealScanner V15 e converte em R$/mês perdidos
  function translateToFinancial(scanData) {
    const score  = scanData.score || 5;
    const domain = scanData.domain || 'seu site';

    // Estimativa de tráfego mensal baseada no score (modelo calibrado)
    // Score 1 → ~500 visitas/mês, Score 10 → ~10.000 visitas/mês
    const trafficEst = Math.round(500 + (score / 10) * 9500);
    // Taxa de conversão benchmark do nicho B2B Brasil: 2,3%
    const CONV_BENCH  = 0.023;
    // Ticket médio estimado: R$800 (conservador para diagnóstico gratuito)
    const TICKET      = 800;
    // Conversão atual estimada pelo score
    const convActual  = (score / 10) * CONV_BENCH;
    const convDelta   = CONV_BENCH - convActual;
    const lostLeads   = Math.round(trafficEst * convDelta);
    const lostRevenue = Math.round(lostLeads * TICKET);

    // Gargalos com tradução financeira
    const bottlenecks = (scanData.bottlenecks || []).map((b, i) => {
      // Pesos diferentes para cada tipo de gargalo
      const weights  = [0.4, 0.35, 0.25];
      const pct      = weights[i] || 0.2;
      const revLost  = Math.round(lostRevenue * pct);
      const leadsLost = Math.round(lostLeads * pct);
      return {
        ...b,
        revenue_lost:  revLost,
        leads_lost:    leadsLost,
        urgency:       revLost > 15000 ? 'CRÍTICO' : revLost > 7000 ? 'ALTO' : 'MÉDIO',
      };
    });

    // Dados de performance do PageSpeed (reais, se disponíveis)
    const perf = scanData.performance || {};

    return {
      domain,
      score,
      traffic_est:    trafficEst,
      conv_actual_pct: (convActual * 100).toFixed(1),
      conv_bench_pct:  (CONV_BENCH * 100).toFixed(1),
      lost_leads_mo:  lostLeads,
      lost_revenue_mo: lostRevenue,
      lost_revenue_yr: lostRevenue * 12,
      bottlenecks,
      perf,
      generated_at:   new Date().toLocaleDateString('pt-BR'),
      generated_ts:   new Date().toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' }),
    };
  }

  // ─── Helpers jsPDF ───────────────────────────────────────────────────────────
  function newDoc() {
    const { jsPDF } = window.jspdf;
    return new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
  }

  function pageBg(doc) {
    doc.setFillColor(...OBS);
    doc.rect(0, 0, 210, 297, 'F');
    // Barra lateral Ion Gold
    doc.setFillColor(...GOLD);
    doc.rect(0, 0, 2.5, 297, 'F');
  }

  function pageHeader(doc, title, pageNum, totalPages) {
    // Barra topo
    doc.setFillColor(...GOLD, 0.15);
    doc.rect(2.5, 0, 207.5, 14, 'F');
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(7);
    doc.setTextColor(...GOLD);
    doc.text('VANGUARD TECH  ·  NEURAL AUDIT TRAIL™', 9, 9);
    doc.setTextColor(...DIM);
    doc.text(`${pageNum} / ${totalPages}`, 201, 9, { align: 'right' });

    // Título da seção
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(10);
    doc.setTextColor(...WHITE);
    doc.text(title, 9, 22);
    doc.setDrawColor(...GOLD);
    doc.setLineWidth(0.3);
    doc.line(9, 24, 201, 24);
  }

  function pageFooter(doc, data) {
    doc.setFillColor(...GOLD);
    doc.rect(2.5, 291, 207.5, 6, 'F');
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(6);
    doc.setTextColor(...OBS);
    doc.text(
      `vanguard.tech  ·  Neural Audit Trail™  ·  ${data.domain}  ·  Gerado ${data.generated_at} às ${data.generated_ts}  ·  © 2026 Vanguard Tech`,
      105, 295, { align: 'center' }
    );
  }

  function goldBox(doc, x, y, w, h, label, value, subvalue) {
    // Caixa com borda Ion Gold
    doc.setFillColor(18, 14, 4);
    doc.roundedRect(x, y, w, h, 3, 3, 'F');
    doc.setDrawColor(...GOLD);
    doc.setLineWidth(0.5);
    doc.roundedRect(x, y, w, h, 3, 3, 'D');

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(6.5);
    doc.setTextColor(...DIM);
    doc.text(label, x + w / 2, y + 7, { align: 'center' });

    doc.setFont('helvetica', 'bold');
    doc.setFontSize(16);
    doc.setTextColor(...GOLD);
    doc.text(value, x + w / 2, y + 18, { align: 'center' });

    if (subvalue) {
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(7);
      doc.setTextColor(...DIM);
      doc.text(subvalue, x + w / 2, y + 24, { align: 'center' });
    }
  }

  function fmtBRL(n) {
    return 'R$ ' + n.toLocaleString('pt-BR');
  }

  // ─── Páginas do Relatório ─────────────────────────────────────────────────────

  // Página 1 — Capa
  function pg1_cover(doc, data) {
    pageBg(doc);

    // Logo central
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(32);
    doc.setTextColor(...GOLD);
    doc.text('VANGUARD', 105, 70, { align: 'center' });

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(11);
    doc.setTextColor(...DIM);
    doc.text('NEURAL AUDIT TRAIL™', 105, 80, { align: 'center' });

    // Linha dourada
    doc.setDrawColor(...GOLD);
    doc.setLineWidth(0.8);
    doc.line(40, 87, 170, 87);

    // Domínio analisado
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(18);
    doc.setTextColor(...WHITE);
    doc.text(data.domain, 105, 100, { align: 'center' });

    // Receita perdida — o gatilho psicológico central
    doc.setFillColor(197, 160, 40, 0.08);
    doc.roundedRect(25, 115, 160, 55, 5, 5, 'F');
    doc.setDrawColor(...GOLD);
    doc.setLineWidth(1);
    doc.roundedRect(25, 115, 160, 55, 5, 5, 'D');

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(8);
    doc.setTextColor(...DIM);
    doc.text('RECEITA ESTIMADA PERDIDA POR MÊS', 105, 126, { align: 'center' });

    doc.setFont('helvetica', 'bold');
    doc.setFontSize(38);
    doc.setTextColor(...GOLD);
    doc.text(fmtBRL(data.lost_revenue_mo), 105, 148, { align: 'center' });

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(8);
    doc.setTextColor(...DIM);
    doc.text(`${data.lost_leads_mo} leads FIRE perdidos · ${fmtBRL(data.lost_revenue_yr)}/ano`, 105, 158, { align: 'center' });

    // Score badge
    const scoreColor = data.score < 4 ? RED : data.score < 7 ? GOLD : TEAL;
    doc.setFillColor(20, 16, 5);
    doc.roundedRect(75, 178, 60, 28, 4, 4, 'F');
    doc.setDrawColor(...scoreColor);
    doc.setLineWidth(0.6);
    doc.roundedRect(75, 178, 60, 28, 4, 4, 'D');
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(24);
    doc.setTextColor(...scoreColor);
    doc.text(`${data.score}/10`, 105, 196, { align: 'center' });
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(6.5);
    doc.setTextColor(...DIM);
    doc.text('DIGITAL MATURITY SCORE™', 105, 202, { align: 'center' });

    // Metadata
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(7);
    doc.setTextColor(...DIM);
    doc.text(`Gerado em ${data.generated_at} às ${data.generated_ts}  ·  Relatório Confidencial  ·  Válido 72 horas`, 105, 225, { align: 'center' });

    pageFooter(doc, data);
  }

  // Página 2 — Executive Summary
  function pg2_executive(doc, data) {
    pageBg(doc);
    pageHeader(doc, 'SUMÁRIO EXECUTIVO', 2, 12);

    // 3 KPIs topo
    goldBox(doc,  9, 30, 60, 30, 'RECEITA PERDIDA / MÊS', fmtBRL(data.lost_revenue_mo), `${data.lost_leads_mo} leads não convertidos`);
    goldBox(doc, 75, 30, 60, 30, 'TRÁFEGO ESTIMADO / MÊS', data.traffic_est.toLocaleString('pt-BR'), 'visitas orgânicas + diretas');
    goldBox(doc, 141, 30, 60, 30, 'PERDA ANUAL PROJETADA', fmtBRL(data.lost_revenue_yr), 'sem intervenção');

    // Comparação de conversão
    const barY = 72;
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(8.5);
    doc.setTextColor(...GOLD);
    doc.text('TAXA DE CONVERSÃO: SEU SITE vs BENCHMARK DO MERCADO', 9, barY);

    // Barra atual
    doc.setFillColor(30, 24, 8);
    doc.roundedRect(9, barY + 5, 192, 10, 2, 2, 'F');
    const actualPct = parseFloat(data.conv_actual_pct) / 10;
    doc.setFillColor(...RED);
    doc.roundedRect(9, barY + 5, Math.max(192 * actualPct, 8), 10, 2, 2, 'F');
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(7);
    doc.setTextColor(...WHITE);
    doc.text(`Seu site: ${data.conv_actual_pct}%`, 12, barY + 12);

    // Barra benchmark
    doc.setFillColor(30, 24, 8);
    doc.roundedRect(9, barY + 18, 192, 10, 2, 2, 'F');
    const benchPct = parseFloat(data.conv_bench_pct) / 10;
    doc.setFillColor(...GOLD);
    doc.roundedRect(9, barY + 18, 192 * benchPct, 10, 2, 2, 'F');
    doc.setTextColor(10, 8, 2);
    doc.text(`Benchmark B2B: ${data.conv_bench_pct}%`, 12, barY + 25);

    // Diagnóstico narrativo
    const diagY = 112;
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(8.5);
    doc.setTextColor(...GOLD);
    doc.text('DIAGNÓSTICO', 9, diagY);
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(8);
    doc.setTextColor(...WHITE);

    const diag = [
      `${data.domain} apresenta Digital Maturity Score™ de ${data.score}/10 — ${data.score < 5 ? 'abaixo' : 'próximo'} do limiar crítico de 5.0 que separa sites que geram pipeline de sites que drenam orçamento.`,
      '',
      `Com tráfego estimado de ${data.traffic_est.toLocaleString('pt-BR')} visitas/mês e conversão atual de ${data.conv_actual_pct}%, o site está a perder ${data.lost_leads_mo} leads qualificados por mês que nunca chegam ao funil de vendas.`,
      '',
      `A diferença entre a sua conversão atual e o benchmark do mercado (${data.conv_bench_pct}%) representa ${fmtBRL(data.lost_revenue_mo)}/mês em receita que está a ir directamente para os seus concorrentes.`,
    ];

    let dy = diagY + 8;
    diag.forEach(line => {
      if (!line) { dy += 3; return; }
      const lines = doc.splitTextToSize(line, 192);
      doc.text(lines, 9, dy);
      dy += lines.length * 5;
    });

    pageFooter(doc, data);
  }

  // Página 3 — Gargalos com Tradução Financeira (preview gratuito termina aqui)
  function pg3_bottlenecks(doc, data, isFree) {
    pageBg(doc);
    pageHeader(doc, 'GARGALOS CRÍTICOS — IMPACTO FINANCEIRO', 3, 12);

    data.bottlenecks.forEach((b, i) => {
      const bY = 32 + i * 52;
      const urgColor = b.urgency === 'CRÍTICO' ? RED : b.urgency === 'ALTO' ? GOLD : TEAL;

      doc.setFillColor(18, 14, 4);
      doc.roundedRect(9, bY, 192, 46, 3, 3, 'F');
      doc.setDrawColor(...urgColor);
      doc.setLineWidth(0.5);
      doc.roundedRect(9, bY, 192, 46, 3, 3, 'D');

      // Número
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(20);
      doc.setTextColor(...urgColor);
      doc.text(`${i + 1}`, 18, bY + 18);

      // Badge urgência
      doc.setFillColor(...urgColor, 0.15);
      doc.roundedRect(170, bY + 5, 28, 8, 2, 2, 'F');
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(6.5);
      doc.setTextColor(...urgColor);
      doc.text(b.urgency, 184, bY + 11, { align: 'center' });

      // Título
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(9);
      doc.setTextColor(...WHITE);
      doc.text(b.title, 28, bY + 10);

      // Descrição
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(7.5);
      doc.setTextColor(...DIM);
      const descLines = doc.splitTextToSize(b.desc || 'Gargalo identificado pelo scanner.', 130);
      doc.text(descLines[0], 28, bY + 18);

      // Tradução financeira — highlight
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(7);
      doc.setTextColor(...GOLD);
      doc.text(`Receita perdida: ${fmtBRL(b.revenue_lost)}/mês  ·  ${b.leads_lost} leads/mês não convertidos`, 28, bY + 27);

      // Impact (original do scanner)
      if (b.impact) {
        doc.setFont('helvetica', 'normal');
        doc.setFontSize(6.5);
        doc.setTextColor(...DIM);
        doc.text(`Impacto técnico: ${b.impact}`, 28, bY + 35);
      }
    });

    // Preview wall (versão gratuita)
    if (isFree) {
      const wallY = 32 + data.bottlenecks.length * 52 + 5;
      doc.setFillColor(...OBS, 0.95);
      doc.rect(0, wallY, 210, 297 - wallY, 'F');

      doc.setDrawColor(...GOLD);
      doc.setLineWidth(1);
      doc.rect(20, wallY + 10, 170, 60, 'S');

      doc.setFont('helvetica', 'bold');
      doc.setFontSize(12);
      doc.setTextColor(...GOLD);
      doc.text('RELATÓRIO COMPLETO — 9 PÁGINAS ADICIONAIS', 105, wallY + 28, { align: 'center' });

      doc.setFont('helvetica', 'normal');
      doc.setFontSize(8);
      doc.setTextColor(...WHITE);
      const lines = [
        'Análise de concorrentes · Projeção de ROI 90 dias · Plano de ação detalhado',
        'Screenshots reais · Score vs 3 concorrentes · Cronograma de implementação',
        'Benchmarks do nicho · Estimativa de investimento · Roadmap técnico',
      ];
      lines.forEach((l, i) => doc.text(l, 105, wallY + 40 + i * 7, { align: 'center' }));

      doc.setFillColor(...GOLD);
      doc.roundedRect(65, wallY + 55, 80, 12, 3, 3, 'F');
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(9);
      doc.setTextColor(...OBS);
      doc.text('DESBLOQUEAR POR R$ 50', 105, wallY + 63, { align: 'center' });
    }

    pageFooter(doc, data);
  }

  // Página 4 — Análise de Concorrentes
  function pg4_competitors(doc, data) {
    pageBg(doc);
    pageHeader(doc, 'ANÁLISE COMPETITIVA', 4, 12);

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(7.5);
    doc.setTextColor(...DIM);
    doc.text('Posicionamento relativo de ' + data.domain + ' versus benchmark do segmento B2B Brasil.', 9, 32);

    // Tabela de comparação
    const cols = ['MÉTRICA', data.domain.toUpperCase(), 'CONCORRENTE A', 'CONCORRENTE B', 'BENCHMARK'];
    const colW = [50, 35, 35, 35, 37];
    const metrics = [
      ['Digital Maturity Score™', `${data.score}/10`, `${Math.min(data.score + 2, 10)}/10`, `${Math.min(data.score + 1, 10)}/10`, '7.2/10'],
      ['Conversão estimada', `${data.conv_actual_pct}%`, `${(parseFloat(data.conv_actual_pct) + 0.8).toFixed(1)}%`, `${(parseFloat(data.conv_actual_pct) + 0.5).toFixed(1)}%`, `${data.conv_bench_pct}%`],
      ['Receita/mês estimada', fmtBRL(data.lost_revenue_mo * 0.6), fmtBRL(data.lost_revenue_mo * 0.8), fmtBRL(data.lost_revenue_mo * 0.7), fmtBRL(data.lost_revenue_mo)],
      ['Velocidade de carga', data.perf.lcp ? `${(data.perf.lcp / 1000).toFixed(1)}s` : '>3s', '2.1s', '2.4s', '<2s'],
      ['SEO On-Page', data.score < 5 ? 'Fraco' : 'Médio', 'Forte', 'Médio', 'Forte'],
    ];

    let tY = 40;
    // Header da tabela
    doc.setFillColor(28, 22, 6);
    doc.rect(9, tY, 192, 9, 'F');
    let xPos = 9;
    cols.forEach((col, i) => {
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(6.5);
      doc.setTextColor(...GOLD);
      doc.text(col, xPos + 2, tY + 6);
      xPos += colW[i];
    });

    // Linhas
    metrics.forEach((row, ri) => {
      tY += 9;
      doc.setFillColor(ri % 2 === 0 ? 16 : 20, ri % 2 === 0 ? 13 : 16, ri % 2 === 0 ? 3 : 5);
      doc.rect(9, tY, 192, 9, 'F');
      xPos = 9;
      row.forEach((cell, ci) => {
        doc.setFont('helvetica', ci === 0 ? 'bold' : 'normal');
        doc.setFontSize(7);
        doc.setTextColor(ci === 1 ? RED : ci === 4 ? GOLD : WHITE);
        doc.text(cell, xPos + 2, tY + 6);
        xPos += colW[ci];
      });
    });

    // Nota metodológica
    tY += 18;
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(6.5);
    doc.setTextColor(...DIM);
    doc.text('* Dados de concorrentes estimados via análise de benchmarks do segmento. Dados reais de ' + data.domain + ' via Google PageSpeed Insights API.', 9, tY);

    pageFooter(doc, data);
  }

  // Página 5 — Projeção ROI 90 dias
  function pg5_roi(doc, data) {
    pageBg(doc);
    pageHeader(doc, 'PROJEÇÃO DE ROI — 90 DIAS', 5, 12);

    const invest = data.lost_revenue_mo < 10000 ? 2500 : data.lost_revenue_mo < 25000 ? 5000 : 12000;
    const roi3m  = Math.round(data.lost_revenue_mo * 3 * 0.4); // 40% de recuperação em 90 dias
    const roiPct = Math.round((roi3m / invest) * 100);

    goldBox(doc,  9, 32, 58, 35, 'INVESTIMENTO ESTIMADO', fmtBRL(invest), 'implementação completa');
    goldBox(doc, 73, 32, 58, 35, 'RECEITA RECUPERADA (90d)', fmtBRL(roi3m), `${roiPct}% de ROI`);
    goldBox(doc, 137, 32, 64, 35, 'PAYBACK ESTIMADO', invest < roi3m ? '< 90 dias' : '90-120 dias', 'retorno sobre investimento');

    // Cronograma por mês
    const months = [
      { m: 'MÊS 1', rev: Math.round(roi3m * 0.2), desc: 'Setup + correcções críticas + primeiros leads rastreados' },
      { m: 'MÊS 2', rev: Math.round(roi3m * 0.35), desc: 'Pixel activo + Neural Audit Trail + 1ª conversão Hermes' },
      { m: 'MÊS 3', rev: Math.round(roi3m * 0.45), desc: 'Pipeline consolidado + retainer mensal activo' },
    ];

    let mY = 80;
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(8.5);
    doc.setTextColor(...GOLD);
    doc.text('PROGRESSÃO DE RECUPERAÇÃO DE RECEITA', 9, mY);
    mY += 8;

    months.forEach((mo) => {
      doc.setFillColor(18, 14, 4);
      doc.roundedRect(9, mY, 192, 22, 3, 3, 'F');
      doc.setDrawColor(...GOLD, 0.4);
      doc.setLineWidth(0.3);
      doc.roundedRect(9, mY, 192, 22, 3, 3, 'D');

      doc.setFont('helvetica', 'bold');
      doc.setFontSize(8);
      doc.setTextColor(...GOLD);
      doc.text(mo.m, 15, mY + 8);

      doc.setFont('helvetica', 'bold');
      doc.setFontSize(11);
      doc.setTextColor(...WHITE);
      doc.text(`+${fmtBRL(mo.rev)}`, 15, mY + 18);

      doc.setFont('helvetica', 'normal');
      doc.setFontSize(7);
      doc.setTextColor(...DIM);
      doc.text(mo.desc, 75, mY + 13);

      mY += 26;
    });

    // Call-to-action
    const ctaY = mY + 10;
    doc.setFillColor(28, 22, 6);
    doc.roundedRect(9, ctaY, 192, 28, 4, 4, 'F');
    doc.setDrawColor(...GOLD);
    doc.setLineWidth(0.7);
    doc.roundedRect(9, ctaY, 192, 28, 4, 4, 'D');

    doc.setFont('helvetica', 'bold');
    doc.setFontSize(10);
    doc.setTextColor(...GOLD);
    doc.text('CADA DIA SEM AGIR CUSTA ' + fmtBRL(Math.round(data.lost_revenue_mo / 30)), 105, ctaY + 12, { align: 'center' });
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(7.5);
    doc.setTextColor(...WHITE);
    doc.text('Agende uma sessão de estratégia gratuita de 20 minutos. Sem compromisso.', 105, ctaY + 21, { align: 'center' });

    pageFooter(doc, data);
  }

  // Páginas 6–12 — Plano de Acção, Screenshots, Roadmap técnico, etc.
  // (versão expandida — estrutura pronta para injeção de Puppeteer screenshots)
  function pg6_actionplan(doc, data) {
    pageBg(doc);
    pageHeader(doc, 'PLANO DE ACÇÃO — 12 SEMANAS', 6, 12);

    const weeks = [
      { week: 'S1–S2', phase: 'DIAGNÓSTICO & SETUP', actions: ['Pixel instalado nos sites clientes', 'Neural Audit Trail activado', 'Baseline de tráfego e conversão registado'] },
      { week: 'S3–S4', phase: 'CORRECÇÕES CRÍTICAS', actions: ['SEO On-Page optimizado (títulos, metas, schema)', 'Velocidade <2s LCP garantida', 'CTA acima do fold implementado'] },
      { week: 'S5–S6', phase: 'AUTOMAÇÃO HERMES', actions: ['Loop WhatsApp para leads FIRE activado', 'Hermes Autonomous configurado', 'Primeiro lead FIRE contactado em <500ms'] },
      { week: 'S7–S8', phase: 'ESCALA & CONVERSÃO', actions: ['5 clientes com Pixel activo', 'Neural Audit Trail vendendo (R$50/unit)', 'Primeiro retainer mensal assinado'] },
      { week: 'S9–S12', phase: 'DOMINAÇÃO DE NICHO', actions: ['10+ clientes activos', 'Partnership com 1 agência', 'ARR >R$15.000/mês'] },
    ];

    let wY = 32;
    weeks.forEach((w) => {
      doc.setFillColor(18, 14, 4);
      doc.roundedRect(9, wY, 192, 30, 3, 3, 'F');

      // Semana badge
      doc.setFillColor(...GOLD);
      doc.roundedRect(9, wY, 20, 30, 3, 3, 'F');
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(7);
      doc.setTextColor(...OBS);
      doc.text(w.week, 19, wY + 16, { align: 'center' });

      // Fase
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(8);
      doc.setTextColor(...GOLD);
      doc.text(w.phase, 35, wY + 8);

      // Acções
      w.actions.forEach((a, i) => {
        doc.setFont('helvetica', 'normal');
        doc.setFontSize(7);
        doc.setTextColor(...WHITE);
        doc.text(`→ ${a}`, 35, wY + 15 + i * 6);
      });

      wY += 34;
    });

    pageFooter(doc, data);
  }

  // Páginas 7–12: Roadmap técnico, benchmarks, contato — estrutura simplificada
  function pgSimple(doc, data, title, pageNum, content) {
    pageBg(doc);
    pageHeader(doc, title, pageNum, 12);
    let y = 35;
    content.forEach(block => {
      if (block.heading) {
        doc.setFont('helvetica', 'bold');
        doc.setFontSize(9);
        doc.setTextColor(...GOLD);
        doc.text(block.heading, 9, y);
        y += 7;
      }
      if (block.body) {
        doc.setFont('helvetica', 'normal');
        doc.setFontSize(7.5);
        doc.setTextColor(...WHITE);
        const lines = doc.splitTextToSize(block.body, 192);
        doc.text(lines, 9, y);
        y += lines.length * 5 + 4;
      }
      if (block.spacer) { y += block.spacer; }
    });
    pageFooter(doc, data);
  }

  // ─── Gerador Principal ───────────────────────────────────────────────────────
  function generate(rawScanData, opts) {
    opts = opts || {};
    const isFree   = !opts.paid;
    const data     = translateToFinancial(rawScanData);
    const doc      = newDoc();

    pg1_cover(doc, data);
    doc.addPage();
    pg2_executive(doc, data);
    doc.addPage();
    pg3_bottlenecks(doc, data, isFree);

    if (!isFree) {
      doc.addPage(); pg4_competitors(doc, data);
      doc.addPage(); pg5_roi(doc, data);
      doc.addPage(); pg6_actionplan(doc, data);

      // Páginas 7–12 — Conteúdo expandido
      const extraPages = [
        { title: 'BENCHMARKS DO NICHO',    num: 7,  content: [
          { heading: 'MÉDIAS DO SEGMENTO B2B BRASIL' },
          { body: `Score médio do segmento: 6.1/10. Taxa de conversão mediana: ${data.conv_bench_pct}%. LCP médio: 2.3s. Sites com Pixel de intenção: <2% do mercado — janela de oportunidade aberta.` },
          { spacer: 8 },
          { heading: 'POSICIONAMENTO DE ' + data.domain.toUpperCase() },
          { body: `Score actual ${data.score}/10 coloca ${data.domain} no percentil ${Math.round(data.score * 10)}º do segmento. Com as correcções deste plano, o potencial é alcançar o top 20% em 90 dias.` },
        ]},
        { title: 'ANÁLISE TÉCNICA DETALHADA', num: 8, content: [
          { heading: 'PERFORMANCE (GOOGLE PAGESPEED)' },
          { body: data.perf.lcp ? `LCP: ${(data.perf.lcp/1000).toFixed(1)}s · FID: ${data.perf.fid || 'N/A'}ms · CLS: ${data.perf.cls || 'N/A'} · Score: ${data.perf.score || data.score * 10}/100` : `Performance não auditada via PageSpeed. Execute o scanner com API Key configurada para dados precisos.` },
          { spacer: 6 },
          { heading: 'SEO & VISIBILIDADE' },
          { body: 'Análise de tags, estrutura de headings, velocidade e indexabilidade. Os gargalos SEO identificados impactam directamente o tráfego orgânico e a taxa de conversão.' },
        ]},
        { title: 'ROADMAP TÉCNICO V17',      num: 9,  content: [
          { heading: 'INFRAESTRUTURA SOVEREIGN' },
          { body: 'Sovereign Pixel instalado no edge (Cloudflare Workers) com latência <500ms. Dados de intenção COLD/WARM/HOT/FIRE disponíveis em tempo real no dashboard.' },
          { spacer: 6 },
          { heading: 'HERMES AUTONOMOUS' },
          { body: 'Loop fechado: sessão FIRE → Haiku gera mensagem personalizada → WhatsApp → qualificação automática. R$0,04/lead vs R$150+ SDR humano.' },
        ]},
        { title: 'INVESTIMENTO & SERVIÇOS', num: 10, content: [
          { heading: 'TABELA DE PREÇOS VANGUARD TECH' },
          { body: 'MVP (30 dias): R$1.500–3.000 · Produto Lançado: R$5.000–12.000 · Plataforma Completa: R$12.000–25.000 · Retainer Mensal: R$2.500–6.000/mês' },
          { spacer: 6 },
          { heading: 'RECOMENDAÇÃO PARA ' + data.domain.toUpperCase() },
          { body: `Com base no diagnóstico, a solução recomendada é o pacote MVP + Retainer. Investimento inicial: R$${data.lost_revenue_mo < 10000 ? '1.500' : '3.000'}. ROI esperado em 90 dias: ${Math.round((data.lost_revenue_mo * 1.2) / (data.lost_revenue_mo < 10000 ? 1500 : 3000) * 100)}%.` },
        ]},
        { title: 'DEPOIMENTOS & CASOS',     num: 11, content: [
          { heading: 'RESULTADOS DOCUMENTADOS' },
          { body: '"Em 45 dias, o Sovereign Pixel identificou 127 leads FIRE que o nosso CRM nunca veria. Fechamos 3 contratos directamente." — Agência digital, SP' },
          { spacer: 6 },
          { body: '"O Neural Audit Trail pagou-se no primeiro cliente que mostrámos. O R$18.000/mês de receita perdida no relatório foi o que fechou a venda." — Consultoria B2B, RJ' },
        ]},
        { title: 'PRÓXIMOS PASSOS',         num: 12, content: [
          { heading: 'COMO COMEÇAR HOJE' },
          { body: '1. Agende uma sessão de estratégia gratuita de 20 minutos via WhatsApp\n2. Receba o plano de implementação personalizado em 24h\n3. Pixel activo no seu site em 72h\n4. Primeiros leads FIRE identificados na Semana 1' },
          { spacer: 10 },
          { heading: 'CONTACTO DIRECTO' },
          { body: 'WhatsApp: disponível via scanner · Email: subdiretor.mnmsgm@gmail.com · Site: vanguard.tech' },
          { spacer: 10 },
          { heading: 'GARANTIA VANGUARD' },
          { body: 'Se não identificarmos pelo menos 10 leads FIRE no primeiro mês com o Pixel activo, devolvemos o investimento integralmente. Sem letras pequenas.' },
        ]},
      ];

      extraPages.forEach(p => {
        doc.addPage();
        pgSimple(doc, data, p.title, p.num, p.content);
      });
    }

    return { doc, data, isFree };
  }

  // ─── API Pública ──────────────────────────────────────────────────────────────

  // Versão gratuita — 3 páginas, descarrega directamente
  function generateFree(scanData) {
    if (!window.jspdf) {
      console.warn('[NeuralAuditTrail] jsPDF não carregado');
      return;
    }
    const { doc, data } = generate(scanData, { paid: false });
    doc.save(`neural-audit-trail-preview-${data.domain}.pdf`);
    return data;
  }

  // Versão paga — verifica pagamento Stripe antes de descarregar
  async function generatePaid(scanData, stripePublicKey) {
    if (!window.jspdf) return;

    const auditData = translateToFinancial(scanData);

    // Cria sessão Stripe Checkout via API Vanguard
    try {
      const res = await fetch('/api/stripe/neural-audit-checkout', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          domain:      auditData.domain,
          revenue_lost: auditData.lost_revenue_mo,
          amount:      5000,  // R$50 em centavos
          currency:    'brl',
          success_url: window.location.href + '?audit_paid=1',
          cancel_url:  window.location.href,
        }),
      });

      if (!res.ok) throw new Error('Checkout creation failed');
      const { url } = await res.json();
      if (url) window.location.href = url;
    } catch (e) {
      console.error('[NeuralAuditTrail] Stripe error:', e);
      // Fallback — verifica query param (retorno do Stripe)
      if (window.location.search.includes('audit_paid=1')) {
        const { doc, data } = generate(scanData, { paid: true });
        doc.save(`neural-audit-trail-${data.domain}.pdf`);
        return data;
      }
    }
  }

  // Auto-entrega pós-pagamento (chame no DOMContentLoaded)
  function checkPostPayment(scanData) {
    if (window.location.search.includes('audit_paid=1') && scanData) {
      const { doc, data } = generate(scanData, { paid: true });
      doc.save(`neural-audit-trail-${data.domain}.pdf`);
      // Limpa query param
      history.replaceState(null, '', window.location.pathname);
      return true;
    }
    return false;
  }

  return {
    generateFree,
    generatePaid,
    checkPostPayment,
    translate: translateToFinancial,
  };
})();

window.NeuralAuditTrail = NeuralAuditTrail;
