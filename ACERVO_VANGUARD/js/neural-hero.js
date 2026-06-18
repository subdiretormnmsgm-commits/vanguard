/* ═══════════════════════════════════════════════════════════════════════════
   VANGUARD V18 — NEURAL PARTICLE HERO (Design Direction 1)
   Canvas: partículas douradas formando conexões neurais em tempo real
   Performance: requestAnimationFrame, 60 fps, pausa quando fora de viewport
   ═══════════════════════════════════════════════════════════════════════════ */
const NeuralHero = (() => {
  'use strict';

  const GOLD      = 'rgba(197,160,40,';
  const GOLD_DIM  = 'rgba(197,160,40,0.08)';
  const N_MOBILE  = 42;
  const N_DESKTOP = 80;
  const CONNECT_DIST = 140;
  const PULSE_INTERVAL = 2800;

  let canvas, ctx, particles, raf, running, pulseTimer;

  function resize() {
    canvas.width  = canvas.offsetWidth  * (window.devicePixelRatio || 1);
    canvas.height = canvas.offsetHeight * (window.devicePixelRatio || 1);
    ctx.scale(window.devicePixelRatio || 1, window.devicePixelRatio || 1);
  }

  function rand(min, max) { return min + Math.random() * (max - min); }

  function Particle(w, h) {
    this.x  = rand(0, w);
    this.y  = rand(0, h);
    this.vx = rand(-0.3, 0.3);
    this.vy = rand(-0.3, 0.3);
    this.r  = rand(1.2, 2.8);
    this.alpha = rand(0.3, 0.8);
    this.pulse = 0;
    this.pulsing = false;
  }

  function spawnParticles(w, h) {
    const n = w < 640 ? N_MOBILE : N_DESKTOP;
    particles = Array.from({ length: n }, () => new Particle(w, h));
  }

  function triggerPulse() {
    const p = particles[Math.floor(Math.random() * particles.length)];
    p.pulsing = true;
    p.pulse = 0;
  }

  function draw() {
    const w = canvas.offsetWidth;
    const h = canvas.offsetHeight;

    ctx.clearRect(0, 0, w, h);

    /* Connexions */
    for (let i = 0; i < particles.length; i++) {
      for (let j = i + 1; j < particles.length; j++) {
        const a = particles[i], b = particles[j];
        const dx = a.x - b.x, dy = a.y - b.y;
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist > CONNECT_DIST) continue;
        const opacity = (1 - dist / CONNECT_DIST) * 0.18;
        ctx.beginPath();
        ctx.strokeStyle = GOLD + opacity + ')';
        ctx.lineWidth = 0.6;
        ctx.moveTo(a.x, a.y);
        ctx.lineTo(b.x, b.y);
        ctx.stroke();
      }
    }

    /* Particles */
    particles.forEach(p => {
      /* move */
      p.x += p.vx;
      p.y += p.vy;
      if (p.x < 0) p.x = w;
      if (p.x > w) p.x = 0;
      if (p.y < 0) p.y = h;
      if (p.y > h) p.y = 0;

      /* pulse animation */
      let extra = 0;
      if (p.pulsing) {
        p.pulse += 0.05;
        extra = Math.sin(p.pulse * Math.PI) * 6;
        if (p.pulse >= 1) { p.pulsing = false; p.pulse = 0; }
      }

      /* draw dot */
      ctx.beginPath();
      ctx.arc(p.x, p.y, p.r + extra * 0.4, 0, Math.PI * 2);
      ctx.fillStyle = GOLD + (p.alpha - extra * 0.04) + ')';
      ctx.fill();

      /* pulse ring */
      if (extra > 0.5) {
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.r + extra, 0, Math.PI * 2);
        ctx.strokeStyle = GOLD + (0.2 - extra * 0.025) + ')';
        ctx.lineWidth = 0.8;
        ctx.stroke();
      }
    });
  }

  function loop() {
    if (!running) return;
    draw();
    raf = requestAnimationFrame(loop);
  }

  function init(canvasId) {
    canvas = document.getElementById(canvasId);
    if (!canvas || !canvas.getContext) return;
    ctx = canvas.getContext('2d');

    resize();
    window.addEventListener('resize', () => {
      resize();
      spawnParticles(canvas.offsetWidth, canvas.offsetHeight);
    });

    spawnParticles(canvas.offsetWidth, canvas.offsetHeight);

    running = true;
    loop();

    /* Periodic pulse events */
    pulseTimer = setInterval(triggerPulse, PULSE_INTERVAL);

    /* Pause when hero leaves viewport */
    const observer = new IntersectionObserver(entries => {
      running = entries[0].isIntersecting;
      if (running) loop();
    }, { threshold: 0.05 });
    observer.observe(canvas.parentElement || canvas);
  }

  return { init };
})();
