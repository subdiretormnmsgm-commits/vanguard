/**
 * Neural V — Componente de Logo Centralizado
 * Injeta automaticamente em qualquer elemento com [data-nv-logo]
 *
 * Atributos:
 *   data-nv-logo              — activa a injecção
 *   data-nv-size="xs|sm|md|lg" — tamanho do SVG (default: md)
 *   data-nv-label="TEXTO"     — texto ao lado do logo (opcional)
 *   data-nv-gold              — variante dourada para certificados
 */
(function () {
  const SIZES = { xs: [20, 15], sm: [24, 18], md: [32, 24], lg: [48, 36] };
  let _uid = 0;

  function buildSVG(uid, w, h, gold) {
    const g = gold ? '#C5A028' : 'url(#nv-g-' + uid + ')';
    const c1 = gold ? '#C5A028' : '#00F0FF';
    const c2 = gold ? '#8B6914' : '#7B2FFF';
    const blur = gold ? '1' : '1.5';

    return [
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 36"',
      ' width="' + w + '" height="' + h + '" aria-hidden="true" style="flex-shrink:0;display:block">',
      '<defs>',
      !gold ? '<linearGradient id="nv-g-' + uid + '" x1="0%" y1="0%" x2="100%" y2="100%">' +
              '<stop offset="0%" stop-color="#00F0FF"/>' +
              '<stop offset="100%" stop-color="#7B2FFF"/>' +
              '</linearGradient>' : '',
      '<filter id="nv-glow-' + uid + '" x="-30%" y="-30%" width="160%" height="160%">',
      '<feGaussianBlur stdDeviation="' + blur + '" result="b"/>',
      '<feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge>',
      '</filter>',
      '</defs>',
      '<polyline points="2,2 24,34 46,2" fill="none" stroke="' + g + '"',
      ' stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"',
      ' filter="url(#nv-glow-' + uid + ')"/>',
      '<circle cx="2"  cy="2"  r="2.5" fill="' + c1 + '" filter="url(#nv-glow-' + uid + ')"/>',
      '<circle cx="24" cy="34" r="3"   fill="' + c2 + '" filter="url(#nv-glow-' + uid + ')"/>',
      '<circle cx="46" cy="2"  r="2.5" fill="' + c1 + '" filter="url(#nv-glow-' + uid + ')"/>',
      '<circle cx="13" cy="18" r="1.5" fill="' + c1 + '" opacity="0.7"/>',
      '<circle cx="35" cy="18" r="1.5" fill="' + c1 + '" opacity="0.7"/>',
      '<line x1="13" y1="18" x2="35" y2="18" stroke="' + c1 + '" stroke-width="0.6" opacity="0.3"/>',
      '</svg>'
    ].join('');
  }

  function inject() {
    document.querySelectorAll('[data-nv-logo]').forEach(function (el) {
      var size  = el.dataset.nvSize || 'md';
      var label = el.dataset.nvLabel || '';
      var gold  = 'nvGold' in el.dataset;
      var dims  = SIZES[size] || SIZES.md;
      var uid   = ++_uid;

      el.style.display     = 'flex';
      el.style.alignItems  = 'center';
      el.style.gap         = '10px';
      el.style.lineHeight  = '1';

      el.innerHTML = buildSVG(uid, dims[0], dims[1], gold) +
        (label ? '<span style="font-weight:700;letter-spacing:.05em">' + label + '</span>' : '');
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', inject);
  } else {
    inject();
  }
})();
