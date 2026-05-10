/**
 * Vanguard Pixel Worker — Cloudflare Workers Edge
 * Serve pixel.js com configuração de tenant injetada + CORS
 * Deploy: wrangler publish
 *
 * Routes:
 *   GET  /pixel.js?tid=<tenant_id>&sid=<site_id>  → script com CFG injetado
 *   POST /v1/pixel                                  → recebe eventos → Supabase
 */

// ─── Supabase Config (vars de ambiente no Cloudflare Dashboard) ────────────────
const SUPABASE_URL    = SUPABASE_URL_ENV;    // wrangler secret put SUPABASE_URL_ENV
const SUPABASE_ANON   = SUPABASE_ANON_ENV;   // wrangler secret put SUPABASE_ANON_ENV

// ─── CORS Headers ─────────────────────────────────────────────────────────────
const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

// ─── pixel.js raw (inlined at build time via wrangler --define) ───────────────
// Em produção: use wrangler --define PIXEL_SRC="$(cat js/pixel.js | jq -Rs .)"
// Durante dev: conteúdo do pixel.js é lido do KV store PIXEL_KV
async function getPixelSource(env) {
  if (env.PIXEL_KV) {
    const cached = await env.PIXEL_KV.get('pixel_js');
    if (cached) return cached;
  }
  // Fallback: fetch do origin (só dev)
  const r = await fetch('https://raw.vanguard.tech/pixel.js');
  return r.text();
}

// ─── Handler ──────────────────────────────────────────────────────────────────
export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // Preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: CORS });
    }

    // ── GET /pixel.js → serve script com config injetada ─────────────────────
    if (request.method === 'GET' && url.pathname === '/pixel.js') {
      const tenantId = url.searchParams.get('tid') || '';
      const siteId   = url.searchParams.get('sid') || '';

      // Valida tenant básico (evita abuso)
      if (!tenantId) {
        return new Response('// missing tenant_id', { status: 400, headers: CORS });
      }

      const pixelSrc = await getPixelSource(env);

      // Injeta config antes do script
      const cfg = `window.__VP_CFG={endpoint:"https://pixel.vanguard.tech/v1/pixel",tenant_id:"${tenantId}",site_id:"${siteId}"};`;
      const body = cfg + '\n' + pixelSrc;

      return new Response(body, {
        status: 200,
        headers: {
          ...CORS,
          'Content-Type': 'application/javascript; charset=utf-8',
          'Cache-Control': 'public, max-age=3600',  // cache 1h no CDN
          'X-Vanguard-Tenant': tenantId,
        },
      });
    }

    // ── POST /v1/pixel → recebe evento e persiste no Supabase ─────────────────
    if (request.method === 'POST' && url.pathname === '/v1/pixel') {
      let body;
      try { body = await request.json(); } catch (e) {
        return new Response('invalid json', { status: 400, headers: CORS });
      }

      // Valida campos obrigatórios
      if (!body.tenant_id || !body.session_id || !body.intent) {
        return new Response('missing fields', { status: 422, headers: CORS });
      }

      // Enriquece com metadados edge
      body.ip_country = request.cf?.country || null;
      body.ip_city    = request.cf?.city    || null;
      body.asn        = request.cf?.asn     || null;
      body.user_agent = request.headers.get('User-Agent') || null;

      // Persistência: INSERT na tabela UNLOGGED pixel_events_staging
      const res = await fetch(`${SUPABASE_URL}/rest/v1/pixel_events_staging`, {
        method: 'POST',
        headers: {
          'apikey':        SUPABASE_ANON,
          'Authorization': `Bearer ${SUPABASE_ANON}`,
          'Content-Type':  'application/json',
          'Prefer':        'return=minimal',
        },
        body: JSON.stringify(body),
      });

      if (!res.ok) {
        // Falha silenciosa — não deve afetar o site do cliente
        console.error('Pixel persist error:', res.status, await res.text());
      }

      return new Response(null, { status: 204, headers: CORS });
    }

    return new Response('not found', { status: 404, headers: CORS });
  },
};
