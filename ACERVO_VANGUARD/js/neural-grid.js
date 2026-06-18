/**
 * Vanguard V16 — Gold-Laced Neural Grid
 * Canvas animation para o War Room Dashboard.
 *
 * Comportamento:
 *  - Grade de nós dourados a 3% de opacidade → pulso sutil e constante
 *  - Quando fireGoldThread() é chamado (ex: webhook de intenção),
 *    um "fio de ouro" percorre as linhas da grade em 2.2s
 *  - A sensação: o utilizador está conectado à espinha dorsal do B2B
 */

(function NeuralGrid() {
  'use strict';

  const GOLD      = 'rgba(197, 160, 40,';  // base color; append opacity)
  const NODE_DIST = 56;                     // distância entre nós (px)
  const NODE_R    = 1.6;                    // raio dos nós
  const BASE_OP   = 0.03;                   // opacidade base da grade (3%)
  const PULSE_OP  = 0.14;                   // opacidade durante thread de ouro
  const THREAD_SPEED = 280;                 // px/s da thread dourada

  let canvas, ctx, nodes = [], W, H, raf, pulseTimer;

  function init(hostSelector) {
    const host = document.querySelector(hostSelector || '.neural-grid-host');
    if (!host) return;

    canvas = document.createElement('canvas');
    canvas.className = 'neural-grid-canvas';
    canvas.setAttribute('aria-hidden', 'true');
    host.insertBefore(canvas, host.firstChild);

    ctx = canvas.getContext('2d');
    resize();
    buildNodes();
    draw();

    window.addEventListener('resize', () => {
      resize();
      buildNodes();
    });

    // API pública: disparada por eventos de webhook
    window.VanguardGrid = { fireGoldThread };
  }

  function resize() {
    const host = canvas.parentElement;
    W = canvas.width  = host.offsetWidth  || window.innerWidth;
    H = canvas.height = host.offsetHeight || 400;
  }

  function buildNodes() {
    nodes = [];
    const cols = Math.ceil(W / NODE_DIST) + 1;
    const rows = Math.ceil(H / NODE_DIST) + 1;

    for (let r = 0; r <= rows; r++) {
      for (let c = 0; c <= cols; c++) {
        nodes.push({
          x: c * NODE_DIST,
          y: r * NODE_DIST,
          // Jitter sutil para parecer orgânico, não grelha perfeita
          jx: (Math.random() - 0.5) * 8,
          jy: (Math.random() - 0.5) * 8,
          pulse: Math.random() * Math.PI * 2,  // fase de respiração
        });
      }
    }
  }

  function draw(ts = 0) {
    raf = requestAnimationFrame(draw);
    ctx.clearRect(0, 0, W, H);

    const t = ts * 0.0006;

    // ── Desenhar arestas (linhas entre nós vizinhos) ──
    ctx.lineWidth = 0.5;
    for (let i = 0; i < nodes.length; i++) {
      const a = nodes[i];
      const ax = a.x + a.jx;
      const ay = a.y + a.jy;

      for (let j = i + 1; j < nodes.length; j++) {
        const b = nodes[j];
        const dx = b.x - a.x;
        const dy = b.y - a.y;
        // Apenas vizinhos diretos (horizontal, vertical, diagonal próximo)
        if (Math.abs(dx) > NODE_DIST * 1.5 || Math.abs(dy) > NODE_DIST * 1.5) continue;

        const bx = b.x + b.jx;
        const by = b.y + b.jy;
        const alpha = BASE_OP + Math.sin(t + a.pulse) * 0.008;

        ctx.strokeStyle = `${GOLD} ${Math.max(0, alpha)})`;
        ctx.beginPath();
        ctx.moveTo(ax, ay);
        ctx.lineTo(bx, by);
        ctx.stroke();
      }
    }

    // ── Desenhar nós ──
    for (const n of nodes) {
      const nx = n.x + n.jx;
      const ny = n.y + n.jy;
      const a  = (BASE_OP * 2.5) + Math.sin(t * 0.8 + n.pulse) * 0.015;

      ctx.fillStyle = `${GOLD} ${Math.max(0, a)})`;
      ctx.beginPath();
      ctx.arc(nx, ny, NODE_R, 0, Math.PI * 2);
      ctx.fill();
    }
  }

  /**
   * Dispara um "fio de ouro" sobre a grade.
   * Chamar via: window.VanguardGrid.fireGoldThread()
   * Ou com opções: fireGoldThread({ color: '#FF6B35', duration: 1500 })
   */
  function fireGoldThread(opts = {}) {
    if (!canvas) return;

    const color    = opts.color || '#C5A028';
    const duration = opts.duration || 2200;

    // Pulsar a grade para sinalizar actividade
    canvas.classList.add('is-pulsing');
    clearTimeout(pulseTimer);
    pulseTimer = setTimeout(() => canvas.classList.remove('is-pulsing'), duration + 400);

    // Escolher um par de nós aleatórios para a thread
    const startNode = nodes[Math.floor(Math.random() * nodes.length)];
    const endNode   = nodes[Math.floor(Math.random() * nodes.length)];

    const sx = startNode.x + startNode.jx;
    const sy = startNode.y + startNode.jy;
    const ex = endNode.x   + endNode.jx;
    const ey = endNode.y   + endNode.jy;

    // Criar overlay SVG temporário para a thread animada
    const svgNS = 'http://www.w3.org/2000/svg';
    const svg   = document.createElementNS(svgNS, 'svg');
    svg.setAttribute('class', 'neural-thread-svg');
    svg.style.cssText = `position:absolute;inset:0;width:100%;height:100%;pointer-events:none;z-index:2;overflow:visible;`;

    const path   = document.createElementNS(svgNS, 'path');
    const dist   = Math.hypot(ex - sx, ey - sy);
    const cpx    = (sx + ex) / 2 + (Math.random() - 0.5) * 80;
    const cpy    = (sy + ey) / 2 + (Math.random() - 0.5) * 80;

    path.setAttribute('d', `M ${sx} ${sy} Q ${cpx} ${cpy} ${ex} ${ey}`);
    path.setAttribute('stroke', color);
    path.setAttribute('stroke-width', '1.5');
    path.setAttribute('fill', 'none');
    path.setAttribute('stroke-dasharray', dist * 1.2);
    path.setAttribute('stroke-dashoffset', dist * 1.2);
    path.setAttribute('stroke-linecap', 'round');

    // Nó de destino: brilho ao chegar
    const circle = document.createElementNS(svgNS, 'circle');
    circle.setAttribute('cx', ex);
    circle.setAttribute('cy', ey);
    circle.setAttribute('r', '5');
    circle.setAttribute('fill', color);
    circle.setAttribute('opacity', '0');

    svg.appendChild(path);
    svg.appendChild(circle);
    canvas.parentElement.appendChild(svg);

    // Animação via requestAnimationFrame
    let start = null;
    function animate(ts) {
      if (!start) start = ts;
      const prog = Math.min((ts - start) / duration, 1);
      const ease = 1 - Math.pow(1 - prog, 3);  // ease-out cubic

      path.setAttribute('stroke-dashoffset', dist * 1.2 * (1 - ease));
      path.setAttribute('opacity', prog < 0.9 ? 1 : 1 - (prog - 0.9) * 10);

      if (prog >= 0.85) {
        circle.setAttribute('opacity', Math.min((prog - 0.85) * 6, 1) * (1 - (prog - 0.9) * 10 || 1));
        circle.setAttribute('r', 5 + (prog - 0.85) * 40);
      }

      if (prog < 1) {
        requestAnimationFrame(animate);
      } else {
        svg.remove();
      }
    }
    requestAnimationFrame(animate);
  }

  // Auto-init quando o DOM estiver pronto
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => init());
  } else {
    init();
  }
})();
