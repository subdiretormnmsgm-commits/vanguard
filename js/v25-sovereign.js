/* ═══════════════════════════════════════════════════════════════════════════
   VANGUARD V25 · Sovereign Gold UI — Interactive Layer
   Cursor Reticle · Forge Reveal · Card Tilt · Ticker · Auditor View
   ═══════════════════════════════════════════════════════════════════════════ */
(function () {
  'use strict';

  /* ─── 1. Noise Texture (Canvas → CSS variable) ─────────────────────────── */
  function initNoise() {
    var canvas = document.getElementById('vg-noise-canvas');
    if (!canvas) return;
    canvas.width  = 200;
    canvas.height = 200;
    var ctx = canvas.getContext('2d');
    var img = ctx.createImageData(200, 200);
    for (var i = 0; i < img.data.length; i += 4) {
      var v = Math.floor(Math.random() * 255);
      img.data[i]     = v;
      img.data[i + 1] = v;
      img.data[i + 2] = v;
      img.data[i + 3] = 255;
    }
    ctx.putImageData(img, 0, 0);
    document.documentElement.style.setProperty(
      '--noise-url',
      'url(' + canvas.toDataURL('image/png') + ')'
    );
  }

  /* ─── 2. Custom Cursor Reticle ─────────────────────────────────────────── */
  function initCursor() {
    if (!window.matchMedia('(hover: hover)').matches) return;

    var cursor = document.createElement('div');
    cursor.className = 'vg-cursor';
    cursor.setAttribute('aria-hidden', 'true');
    cursor.innerHTML =
      '<div class="vg-cursor__ring"></div>' +
      '<div class="vg-cursor__arm vg-cursor__arm--top"></div>'    +
      '<div class="vg-cursor__arm vg-cursor__arm--right"></div>'  +
      '<div class="vg-cursor__arm vg-cursor__arm--bottom"></div>' +
      '<div class="vg-cursor__arm vg-cursor__arm--left"></div>'   +
      '<div class="vg-cursor__dot"></div>'                        +
      '<span class="vg-cursor__meta" id="vg-cursor-meta"></span>';
    document.body.appendChild(cursor);

    var metaEl = cursor.querySelector('#vg-cursor-meta');
    var rafId  = null;
    var mx = -200, my = -200;

    /* RAF-throttled position update */
    document.addEventListener('mousemove', function (e) {
      mx = e.clientX;
      my = e.clientY;
      if (rafId) return;
      rafId = requestAnimationFrame(function () {
        cursor.style.setProperty('--cx', mx + 'px');
        cursor.style.setProperty('--cy', my + 'px');
        rafId = null;
      });
    });

    /* Click feedback */
    document.addEventListener('mousedown', function () {
      cursor.classList.add('vg-cursor--click');
    });
    document.addEventListener('mouseup', function () {
      cursor.classList.remove('vg-cursor--click');
    });

    /* Expand on [data-vg-meta] elements */
    document.querySelectorAll('[data-vg-meta]').forEach(function (el) {
      el.addEventListener('mouseenter', function () {
        cursor.classList.add('vg-cursor--expanded');
        metaEl.textContent = el.getAttribute('data-vg-meta');
      });
      el.addEventListener('mouseleave', function () {
        cursor.classList.remove('vg-cursor--expanded');
      });
    });
  }

  /* ─── 3. Forge Reveal — Cipher Decrypt ─────────────────────────────────── */
  var CIPHER = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%▪□■!?';

  function forgeRevealEl(el, delay) {
    delay = delay || 0;
    setTimeout(function () {
      var original = el.dataset.forgeOriginal;
      if (!original) {
        original = el.textContent.trim();
        el.dataset.forgeOriginal = original;
      }
      var len      = original.length;
      var duration = 520 + len * 17; /* ~17ms per character */
      var start    = null;

      el.classList.add('forge-active');

      function tick(ts) {
        if (!start) start = ts;
        var elapsed  = ts - start;
        var progress = Math.min(elapsed / duration, 1);
        var revealed = Math.floor(progress * len);
        var out = '';
        for (var i = 0; i < len; i++) {
          var ch = original[i];
          if (ch === ' ' || ch === '\n' || ch === '\t') {
            out += ch;
          } else if (i < revealed) {
            out += ch;
          } else {
            out += CIPHER[Math.floor(Math.random() * CIPHER.length)];
          }
        }
        el.textContent = out;
        if (progress < 1) {
          requestAnimationFrame(tick);
        } else {
          el.textContent = original; /* guarantee exact final text */
        }
      }
      requestAnimationFrame(tick);
    }, delay);
  }

  function initForge() {
    /* Simple text targets — IntersectionObserver driven */
    var targets = document.querySelectorAll('[data-forge]');
    if (targets.length) {
      var io = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting && !entry.target.dataset.forgeDone) {
            entry.target.dataset.forgeDone = '1';
            forgeRevealEl(entry.target, 0);
            io.unobserve(entry.target);
          }
        });
      }, { threshold: 0.35 });
      targets.forEach(function (el) { io.observe(el); });
    }

    /* Hero headline ems — staggered on load */
    var heroEms = document.querySelectorAll('.hero__headline em');
    heroEms.forEach(function (em, idx) {
      /* preserve gradient classes — only textContent is mutated */
      var original = em.textContent.trim();
      em.dataset.forgeOriginal = original;
      setTimeout(function () { forgeRevealEl(em, 0); }, 280 + idx * 180);
    });
  }

  /* ─── 4. Card 3D Tilt ──────────────────────────────────────────────────── */
  function initCardTilt() {
    if (!window.matchMedia('(hover: hover)').matches) return;

    document.querySelectorAll('.feature-card').forEach(function (card) {
      var rafId = null;

      card.addEventListener('mousemove', function (e) {
        if (rafId) return;
        var rect = card.getBoundingClientRect();
        rafId = requestAnimationFrame(function () {
          var x  = (e.clientX - rect.left) / rect.width;
          var y  = (e.clientY - rect.top)  / rect.height;
          var rx = (y - 0.5) * -11;
          var ry = (x - 0.5) *  11;
          card.style.setProperty('--tilt-x',  rx.toFixed(2) + 'deg');
          card.style.setProperty('--tilt-y',  ry.toFixed(2) + 'deg');
          card.style.setProperty('--mouse-x', (x * 100).toFixed(1) + '%');
          card.style.setProperty('--mouse-y', (y * 100).toFixed(1) + '%');
          rafId = null;
        });
      });

      card.addEventListener('mouseleave', function () {
        if (rafId) { cancelAnimationFrame(rafId); rafId = null; }
        card.style.setProperty('--tilt-x', '0deg');
        card.style.setProperty('--tilt-y', '0deg');
      });
    });
  }

  /* ─── 5. Ticker — Seamless Loop ────────────────────────────────────────── */
  function initTicker() {
    var track = document.querySelector('.vg-ticker__track');
    if (!track) return;
    /* Clone each item into same track → translateX(-50%) creates seamless loop */
    var items = Array.from(track.children);
    items.forEach(function (item) {
      track.appendChild(item.cloneNode(true));
    });
  }

  /* ─── 6. Auditor View — Ctrl+Shift+A ───────────────────────────────────── */
  function initAuditorView() {
    var hud = document.createElement('div');
    hud.className = 'vg-auditor-hud';
    hud.setAttribute('aria-hidden', 'true');
    document.body.appendChild(hud);

    var active     = false;
    var frameCount = 0;
    var lastTime   = 0;
    var rafId      = null;

    function fpsLoop(ts) {
      if (!active) return;
      frameCount++;
      if (ts - lastTime >= 1000) {
        var fps     = frameCount;
        var latency = Math.round((performance.now() % 100) * 10) / 10;
        var elCount = document.querySelectorAll('*').length;
        hud.innerHTML =
          '<div style="color:var(--c-gold-bright);letter-spacing:0.22em;margin-bottom:5px">▸ AUDITOR MODE</div>' +
          'FPS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;· <strong style="color:var(--c-gold-bright)">' + fps     + '</strong><br>' +
          'LATÊNCIA&nbsp;&nbsp;· <strong style="color:var(--c-gold-bright)">' + latency + ' ms</strong><br>' +
          'ELEMENTOS · <strong style="color:var(--c-gold-bright)">' + elCount + '</strong><br>'  +
          'VIEWPORT&nbsp;&nbsp;· <strong style="color:var(--c-gold-bright)">' + window.innerWidth + '×' + window.innerHeight + '</strong><br>' +
          '<div style="margin-top:6px;color:rgba(197,160,40,0.4);font-size:7.5px;letter-spacing:0.14em">CTRL+SHIFT+A PARA SAIR</div>';
        frameCount = 0;
        lastTime   = ts;
      }
      rafId = requestAnimationFrame(fpsLoop);
    }

    document.addEventListener('keydown', function (e) {
      if (e.ctrlKey && e.shiftKey && (e.key === 'A' || e.key === 'a')) {
        e.preventDefault();
        active = !active;
        document.body.classList.toggle('auditor-mode', active);
        if (active) {
          frameCount = 0;
          lastTime   = performance.now();
          rafId      = requestAnimationFrame(fpsLoop);
        } else {
          if (rafId) { cancelAnimationFrame(rafId); rafId = null; }
        }
      }
    });
  }

  /* ─── Init ──────────────────────────────────────────────────────────────── */
  document.addEventListener('DOMContentLoaded', function () {
    initNoise();
    initCursor();
    initForge();
    initCardTilt();
    initTicker();
    initAuditorView();
  });

})();
