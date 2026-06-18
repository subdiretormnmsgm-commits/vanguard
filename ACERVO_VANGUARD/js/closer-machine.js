/* ═══════════════════════════════════════════════════════════════════════
   VANGUARD V12 — THE CLOSER MACHINE · HERMES AGENT V1
   Autonomous Sales Chat · Context-Aware · PDF Proposal Generator
   ═══════════════════════════════════════════════════════════════════════ */
const CloserMachine = (() => {

  let scanData = null;
  let msgCount = 0;
  let pdfReady = false;

  /* ─── Hermes Script Library ───────────────────────────────────────── */
  const SCRIPTS = {
    opener: (d) => `Olá! Sou o <strong>Hermes</strong>, especialista da Vanguard.<br><br>
Acabei de analisar <strong>${d.domain}</strong> e o resultado me preocupa.<br><br>
O seu <strong>Digital Maturity Score™ é ${d.score}/10</strong> — abaixo do benchmark do seu mercado (7.2/10).<br><br>
O maior gargalo identificado: <em>${d.bottlenecks[0]?.title}</em>. Posso mostrar como resolver isso em 30 dias? 🎯`,

    follow1: `Ótimo! Tenho exatamente o plano para isso.<br><br>
Com base nos 3 gargalos detectados no scanner, estou preparando uma <strong>Proposta de Transformação Digital</strong> personalizada para o seu negócio.<br><br>
Devo gerar o PDF agora?`,

    followGeneric: [
      'Com base nos dados do scan, estimo um crescimento de <strong>40% em leads</strong> nos primeiros 60 dias após a implementação.',
      'Nosso sistema Soberano Digital já transformou mais de 50 negócios no seu nicho. Os resultados aparecem nas primeiras semanas.',
      'Vejo uma oportunidade imediata de recuperação. O gargalo de automação que detectei é o que mais custa leads ao seu negócio.',
      'Vou ser direto: cada dia sem resolver estes gargalos representa clientes que vão diretamente para a concorrência.'
    ],

    pdfReady: `✅ <strong>Proposta PDF gerada com sucesso!</strong><br><br>
O documento inclui:<br>
• Análise completa dos 3 gargalos<br>
• Plano de ação de 30 dias<br>
• ROI estimado para o seu nicho<br><br>
Quando podemos agendar <strong>20 minutos</strong> para detalhar o plano juntos?`
  };

  /* ─── UI Helpers ──────────────────────────────────────────────────── */
  function getEl(id) { return document.getElementById(id); }

  function scrollToBottom() {
    const msgs = getEl('cm-messages');
    if (msgs) msgs.scrollTop = msgs.scrollHeight;
  }

  function addMessage(role, html) {
    const msgs = getEl('cm-messages');
    if (!msgs) return;
    const div = document.createElement('div');
    div.className = `cm-msg cm-msg--${role}`;
    div.innerHTML = html;
    msgs.appendChild(div);
    scrollToBottom();
  }

  function showTyping() {
    const msgs = getEl('cm-messages');
    if (!msgs) return;
    removeTyping();
    const t = document.createElement('div');
    t.id = 'cm-typing-indicator';
    t.className = 'cm-typing';
    t.innerHTML = `
      <div class="cm-typing__dot"></div>
      <div class="cm-typing__dot"></div>
      <div class="cm-typing__dot"></div>
    `;
    msgs.appendChild(t);
    scrollToBottom();
  }

  function removeTyping() {
    getEl('cm-typing-indicator')?.remove();
  }

  function hermesReply(html, delay = 1400) {
    showTyping();
    setTimeout(() => {
      removeTyping();
      addMessage('hermes', html);
    }, delay);
  }

  /* ─── PDF Generator ───────────────────────────────────────────────── */
  function generatePDF() {
    if (!scanData) return;

    if (!window.jspdf) {
      addMessage('hermes', '⚠️ A gerar proposta... Por favor aguarde um momento.');
      return;
    }

    const { jsPDF } = window.jspdf;
    const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
    const tier = scanData.score < 3 ? 'CRÍTICO' : scanData.score < 5 ? 'BAIXO' : scanData.score < 7 ? 'MÉDIO' : 'ALTO';

    /* === PAGE BACKGROUND === */
    doc.setFillColor(8, 8, 14);
    doc.rect(0, 0, 210, 297, 'F');

    /* === TOP ACCENT BAR === */
    doc.setFillColor(0, 240, 255);
    doc.rect(0, 0, 210, 2.5, 'F');

    /* Accent side line */
    doc.setFillColor(123, 47, 255);
    doc.rect(0, 0, 3, 297, 'F');

    /* === HEADER === */
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(20);
    doc.setTextColor(0, 240, 255);
    doc.text('VANGUARD TECH', 14, 22);

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(8);
    doc.setTextColor(80, 80, 100);
    doc.text('PROPOSTA DE TRANSFORMAÇÃO DIGITAL  ·  CONFIDENCIAL', 14, 29);
    doc.text(`Gerado em ${new Date().toLocaleDateString('pt-PT')} às ${new Date().toLocaleTimeString('pt-PT', {hour:'2-digit', minute:'2-digit'})}  ·  Válido por 72 horas`, 14, 34);

    /* === CLIENT LINE === */
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(13);
    doc.setTextColor(200, 200, 210);
    doc.text(`Cliente: ${scanData.domain}`, 14, 48);

    /* === SCORE BOX === */
    doc.setFillColor(14, 14, 22);
    doc.roundedRect(14, 56, 85, 48, 4, 4, 'F');
    doc.setDrawColor(0, 240, 255);
    doc.setLineWidth(0.4);
    doc.roundedRect(14, 56, 85, 48, 4, 4, 'D');

    doc.setFont('helvetica', 'bold');
    doc.setFontSize(42);
    doc.setTextColor(0, 240, 255);
    doc.text(`${scanData.score}`, 28, 88);

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(18);
    doc.setTextColor(60, 60, 80);
    doc.text('/10', 55, 88);

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(7);
    doc.setTextColor(80, 80, 100);
    doc.text('DIGITAL MATURITY SCORE™', 17, 98);

    /* Tier badge */
    const tierColor = tier === 'CRÍTICO' ? [255,68,68] : tier === 'BAIXO' ? [255,184,0] : [0,240,255];
    doc.setFillColor(...tierColor, 0.15);
    doc.setDrawColor(...tierColor);
    doc.setLineWidth(0.5);
    doc.roundedRect(108, 62, 34, 12, 3, 3, 'FD');
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(8);
    doc.setTextColor(...tierColor);
    doc.text(tier, 125, 70, { align: 'center' });

    /* === SEPARATOR === */
    doc.setDrawColor(25, 25, 40);
    doc.setLineWidth(0.5);
    doc.line(14, 114, 196, 114);

    /* === GARGALOS === */
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(10);
    doc.setTextColor(0, 240, 255);
    doc.text('GARGALOS CRÍTICOS IDENTIFICADOS', 14, 125);

    scanData.bottlenecks.forEach((b, i) => {
      const yBase = 135 + i * 26;

      doc.setFillColor(16, 16, 26);
      doc.roundedRect(14, yBase - 5, 182, 22, 3, 3, 'F');

      /* Number */
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(14);
      doc.setTextColor(0, 240, 255);
      doc.text(`${i + 1}`, 21, yBase + 8);

      /* Title */
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(9);
      doc.setTextColor(220, 220, 230);
      doc.text(b.title, 31, yBase + 2);

      /* Desc */
      doc.setFont('helvetica', 'normal');
      doc.setFontSize(7.5);
      doc.setTextColor(110, 110, 130);
      const descLines = doc.splitTextToSize(b.desc, 130);
      doc.text(descLines[0], 31, yBase + 9);

      /* Impact badge */
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(7);
      doc.setTextColor(255, 120, 120);
      doc.text(b.impact, 192, yBase + 2, { align: 'right' });
    });

    /* === ACTION PLAN === */
    const planY = 225;
    doc.setFillColor(0, 240, 255);
    doc.rect(14, planY, 182, 1, 'F');

    doc.setFont('helvetica', 'bold');
    doc.setFontSize(10);
    doc.setTextColor(0, 240, 255);
    doc.text('PLANO DE ACÇÃO — 30 DIAS', 14, planY + 12);

    const PLAN = [
      { week: 'SEMANA 1', action: 'Diagnóstico técnico completo + Roadmap personalizado + Setup de rastreamento' },
      { week: 'SEMANA 2', action: 'Correcções críticas de segurança, SEO On-Page e optimização de velocidade' },
      { week: 'SEMANA 3', action: 'Activação do sistema Hermes — automação de leads via IA + WhatsApp' },
      { week: 'SEMANA 4', action: 'Dashboard de métricas ao vivo + Optimização contínua + Relatório de resultados' }
    ];

    PLAN.forEach((item, i) => {
      const y = planY + 22 + i * 10;
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(7.5);
      doc.setTextColor(0, 240, 255);
      doc.text(item.week, 14, y);
      doc.setFont('helvetica', 'normal');
      doc.setTextColor(150, 150, 170);
      doc.text(`→ ${item.action}`, 44, y);
    });

    /* === INVESTMENT BOX === */
    doc.setFillColor(12, 12, 20);
    doc.roundedRect(14, 272, 182, 16, 3, 3, 'F');
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(8);
    doc.setTextColor(0, 240, 255);
    doc.text('PRÓXIMO PASSO:', 20, 281);
    doc.setFont('helvetica', 'normal');
    doc.setTextColor(160, 160, 180);
    doc.text('Agende uma sessão de 20 minutos para detalhar o plano e confirmar o investimento.', 60, 281);

    /* === FOOTER === */
    doc.setFillColor(0, 240, 255);
    doc.rect(0, 291, 210, 6, 'F');
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(6.5);
    doc.setTextColor(8, 8, 14);
    doc.text(
      'vanguard.tech  ·  subdiretor.mnmsgm@gmail.com  ·  Soberano Digital V12  ·  © 2026 Vanguard Tech',
      105, 295.5, { align: 'center' }
    );

    doc.save(`proposta-vanguard-${scanData.domain}.pdf`);
    pdfReady = true;

    hermesReply(SCRIPTS.pdfReady, 900);
  }

  /* ─── Handle User Message ──────────────────────────────────────────── */
  function handleUserMsg(text) {
    if (!text.trim()) return;
    addMessage('user', text);
    msgCount++;

    const lowerText = text.toLowerCase();

    if (msgCount === 1 || lowerText.includes('sim') || lowerText.includes('ok') || lowerText.includes('claro') || lowerText.includes('quero')) {
      hermesReply(SCRIPTS.follow1, 1300);
      setTimeout(() => {
        const pdfArea = getEl('cm-pdf-action');
        if (pdfArea) pdfArea.style.display = 'block';
      }, 1300 + 500);
    } else if (lowerText.includes('pdf') || lowerText.includes('proposta') || lowerText.includes('gerar')) {
      hermesReply('A gerar a sua proposta personalizada...', 600);
      setTimeout(generatePDF, 2000);
    } else {
      const r = SCRIPTS.followGeneric[msgCount % SCRIPTS.followGeneric.length];
      hermesReply(r, 1200 + Math.random() * 600);
    }
  }

  /* ─── Open Chat ────────────────────────────────────────────────────── */
  function open(data) {
    scanData = data;
    msgCount = 0;
    pdfReady = false;

    const cm  = getEl('closer-machine');
    const fab = getEl('hud-fab');
    if (!cm) return;

    /* Reset messages */
    const msgs = getEl('cm-messages');
    if (msgs) msgs.innerHTML = '';

    /* Hide PDF action initially */
    const pdfArea = getEl('cm-pdf-action');
    if (pdfArea) pdfArea.style.display = 'none';

    cm.classList.add('active');
    if (fab) fab.classList.add('hidden');

    /* Hermes greeting sequence */
    setTimeout(() => {
      showTyping();
      setTimeout(() => {
        removeTyping();
        if (data) {
          addMessage('hermes', SCRIPTS.opener(data));
        } else {
          addMessage('hermes', 'Olá! Sou o <strong>Hermes</strong>, agente IA da Vanguard. Execute o scanner primeiro para que eu possa fazer uma análise personalizada do seu negócio. 🎯');
        }
      }, 1600);
    }, 350);
  }

  /* ─── Init UI Events ───────────────────────────────────────────────── */
  function initUI() {
    const cm       = getEl('closer-machine');
    const closeBtn = getEl('cm-close');
    const sendBtn  = getEl('cm-send');
    const input    = getEl('cm-input');
    const pdfBtn   = getEl('cm-pdf-btn');
    const fab      = getEl('hud-fab');

    closeBtn?.addEventListener('click', () => {
      cm?.classList.remove('active');
      if (fab) fab.classList.remove('hidden');
    });

    const sendMsg = () => {
      const txt = input?.value?.trim();
      if (!txt) return;
      handleUserMsg(txt);
      if (input) input.value = '';
    };

    sendBtn?.addEventListener('click', sendMsg);
    input?.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMsg(); }
    });

    pdfBtn?.addEventListener('click', () => {
      addMessage('user', 'Sim, gerar o PDF da proposta por favor.');
      setTimeout(generatePDF, 800);
    });

    fab?.addEventListener('click', () => open(window.Scanner?.getCurrentResult?.() || null));
  }

  document.addEventListener('DOMContentLoaded', initUI);

  return { open };
})();

window.CloserMachine = CloserMachine;
