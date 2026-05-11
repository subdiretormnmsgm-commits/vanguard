/* ═══════════════════════════════════════════════════════════════════════════
   VANGUARD V20 — INTERVENTION WORKER (Cloudflare Worker)
   Endpoint: POST /api/intervention
   Recebe pedidos do Cockpit → escreve flag no KV com TTL
   → federation-proxy.js lê o flag e injeta modal de oferta

   Deploy: wrangler deploy -c cloudflare/wrangler-intervention.toml
   Binding: TENANTS_KV (mesma namespace do federation-proxy)
   Secret:  COCKPIT_SECRET (header Authorization: Bearer <secret>)
   ═══════════════════════════════════════════════════════════════════════════ */

export default {
  async fetch(request, env) {
    /* CORS preflight */
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin':  '*',
          'Access-Control-Allow-Methods': 'POST, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        },
      });
    }

    /* Auth */
    const auth = request.headers.get('Authorization') || '';
    const token = auth.replace('Bearer ', '').trim();
    if (!env.COCKPIT_SECRET || token !== env.COCKPIT_SECRET) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    const url = new URL(request.url);

    /* DELETE /api/intervention?tenant_id=X → remover flag */
    if (request.method === 'DELETE') {
      const tenantId = url.searchParams.get('tenant_id');
      if (!tenantId) {
        return json({ error: 'tenant_id obrigatório' }, 400);
      }
      await env.TENANTS_KV.delete(`intervention:${tenantId}`);
      return json({ ok: true, action: 'removed', tenant_id: tenantId });
    }

    /* POST /api/intervention → activar intervenção */
    if (request.method !== 'POST') {
      return json({ error: 'Método não suportado' }, 405);
    }

    let body;
    try {
      body = await request.json();
    } catch {
      return json({ error: 'Body JSON inválido' }, 400);
    }

    const { tenant_id, type, message, ttl_seconds } = body;

    if (!tenant_id || !type) {
      return json({ error: 'tenant_id e type são obrigatórios' }, 400);
    }

    const ttl = Math.min(Math.max(parseInt(ttl_seconds) || 86400, 300), 604800);

    const payload = {
      tenant_id,
      type,
      message:    message || null,
      activated:  new Date().toISOString(),
      expires_in: ttl,
    };

    await env.TENANTS_KV.put(
      `intervention:${tenant_id}`,
      JSON.stringify(payload),
      { expirationTtl: ttl }
    );

    return json({
      ok:        true,
      tenant_id,
      type,
      ttl_hours: Math.round(ttl / 3600),
      message:   `Intervenção activa — modal injectado em todas as visitas ao site do tenant durante ${Math.round(ttl / 3600)}h`,
    });
  },
};

function json(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      'Content-Type':                'application/json',
      'Access-Control-Allow-Origin': '*',
    },
  });
}

/* ── wrangler.toml (referência — criar em cloudflare/wrangler-intervention.toml)
name = "vanguard-intervention-worker"
main = "cloudflare/intervention-worker.js"
compatibility_date = "2024-01-01"

[[kv_namespaces]]
binding = "TENANTS_KV"
id      = "<mesma KV_NAMESPACE_ID do federation-proxy>"

# secrets:
# wrangler secret put COCKPIT_SECRET   ← chave secreta para o Cockpit
── */
