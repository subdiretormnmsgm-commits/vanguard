/**
 * Vanguard V16 — Cryptographic Glitch Data
 * Micro-animação de cifragem visual antes de revelar dados reais.
 *
 * Uso em HTML:
 *   <span class="cipher-reveal" data-real="7.4M">████████</span>
 *
 * O motor detecta todos os .cipher-reveal e, quando o elemento
 * entra no viewport (IntersectionObserver), executa a animação:
 *   1. Pisca em caracteres hex/matrix aleatórios em Ion Gold
 *   2. Reduz gradualmente o ruído
 *   3. Revela o valor real com fade
 *
 * Chamar manualmente: window.CipherGlitch.run(element)
 * Ou em todos de uma vez: window.CipherGlitch.runAll()
 */

(function CipherGlitch() {
  'use strict';

  // Conjunto de caracteres para o "ruído criptográfico"
  const MATRIX_CHARS = '0123456789ABCDEF░▒▓█▄▀■□▪▫◆◇';
  const CRYPTO_CHARS = '①②③④⑤⑥⑦⑧⑨⑩ΩΨΦΛΞΠΣΘαβγδεζ';
  const ALL_CHARS    = MATRIX_CHARS + CRYPTO_CHARS;

  const CIPHER_DURATION = 1200;  // ms total da animação
  const FRAME_INTERVAL  =  60;   // ms entre frames (≈16fps)

  function randomStr(len) {
    let s = '';
    for (let i = 0; i < len; i++) {
      s += ALL_CHARS[Math.floor(Math.random() * ALL_CHARS.length)];
    }
    return s;
  }

  function run(el) {
    if (el.dataset.cipherDone === 'true') return;
    el.dataset.cipherDone = 'true';

    const realValue = el.dataset.real || el.textContent.trim();
    const len       = Math.max(realValue.length, 4);
    const frames    = Math.ceil(CIPHER_DURATION / FRAME_INTERVAL);
    let   frame     = 0;

    el.classList.add('is-ciphering');
    el.setAttribute('aria-busy', 'true');

    const timer = setInterval(() => {
      frame++;
      const progress = frame / frames;  // 0 → 1

      if (progress < 0.75) {
        // Fase 1 (0–75%): ruído total em Gold
        el.textContent = randomStr(len);
        el.style.color = `rgba(197, 160, 40, ${1 - progress * 0.3})`;
        el.style.letterSpacing = `${0.12 - progress * 0.08}em`;
      } else {
        // Fase 2 (75–100%): revelar progressivamente o valor real
        const reveal = Math.floor((progress - 0.75) / 0.25 * realValue.length);
        const revealed = realValue.slice(0, reveal);
        const noise    = randomStr(len - reveal);
        el.textContent = revealed + noise;
        el.style.color = '';
        el.style.letterSpacing = '';
      }

      if (frame >= frames) {
        clearInterval(timer);
        el.textContent = realValue;
        el.style.color = '';
        el.style.letterSpacing = '';
        el.classList.remove('is-ciphering');
        el.classList.add('is-revealed');
        el.removeAttribute('aria-busy');
      }
    }, FRAME_INTERVAL);
  }

  function runAll(scope) {
    const root = scope || document;
    root.querySelectorAll('.cipher-reveal:not([data-cipher-done="true"])').forEach(run);
  }

  // IntersectionObserver: anima quando entra no viewport
  function observe() {
    const targets = document.querySelectorAll('.cipher-reveal');
    if (!targets.length) return;

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(e => {
        if (e.isIntersecting) {
          run(e.target);
          observer.unobserve(e.target);
        }
      });
    }, { threshold: 0.3 });

    targets.forEach(el => observer.observe(el));
  }

  // API pública
  window.CipherGlitch = { run, runAll };

  // Init automático
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', observe);
  } else {
    observe();
  }

  // Suporte a elementos adicionados dinamicamente (MutationObserver)
  const mutObs = new MutationObserver((mutations) => {
    mutations.forEach(m => {
      m.addedNodes.forEach(node => {
        if (node.nodeType !== 1) return;
        if (node.matches?.('.cipher-reveal')) run(node);
        node.querySelectorAll?.('.cipher-reveal').forEach(el => {
          if (el.dataset.cipherDone !== 'true') run(el);
        });
      });
    });
  });

  mutObs.observe(document.body, { childList: true, subtree: true });
})();
