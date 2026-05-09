#!/bin/sh
# White-Label entrypoint — injeta variáveis de ambiente no brand-config.js
# Executado pelo container frontend antes de iniciar o nginx

set -e

BRAND_CONFIG_PATH="/usr/share/nginx/html/brand-config.js"

cat > "$BRAND_CONFIG_PATH" << JSEOF
/* Brand Config — gerado automaticamente pelo Docker entrypoint */
(function() {
  var r = document.documentElement.style;
  r.setProperty('--c-primary',   '${BRAND_PRIMARY:-#00F0FF}');
  r.setProperty('--c-secondary', '${BRAND_SECONDARY:-#1A0B2E}');
  r.setProperty('--c-accent',    '${BRAND_ACCENT:-#7B2FFF}');
  r.setProperty('--c-bg',        '${BRAND_BG:-#0A0A0A}');
  r.setProperty('--brand-name',    '"${BRAND_NAME:-VANGUARD}"');
  r.setProperty('--brand-tagline', '"${BRAND_TAGLINE:-Forja de Ecossistemas Digitais}"');
})();
JSEOF

echo "[Vanguard] Brand config injectado: ${BRAND_NAME:-VANGUARD} | ${BRAND_PRIMARY:-#00F0FF}"
exec nginx -g "daemon off;"
