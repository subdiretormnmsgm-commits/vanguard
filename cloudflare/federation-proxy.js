/* ═══════════════════════════════════════════════════════════════════════════
   VANGUARD V19 — FEDERATION PROXY (Cloudflare Worker)
   Pixel Federation v2: proxy transparente via Custom Hostnames / SSL for SaaS
   Injeta: Sovereign Pixel + Authority Badge + Exit Intent Modal (só FIRE)
   Deploy: wrangler deploy -c cloudflare/wrangler-federation.toml
   Bindings: TENANTS_KV (KV namespace), env.SUPABASE_URL, env.SUPABASE_ANON
   ═══════════════════════════════════════════════════════════════════════════ */

/* ── V20: Intervention KV Bus ───────────────────────────────────────────── */
/*
  Cockpit escreve: TENANTS_KV.put(`intervention:${tenantId}`, JSON, { expirationTtl: ttl })
  Worker lê na request → injeta modal de oferta se flag activo
  Endpoint auxiliar: POST /api/intervention → write KV (requer auth header)
*/

async function getIntervention(tenantId, env) {
  if (!env.TENANTS_KV) return null;
  try {
    const raw = await env.TENANTS_KV.get(`intervention:${tenantId}`, 'json');
    return raw;
  } catch { return null; }
}

function interventionSnippet(tenantId, intervention) {
  const msg = intervention?.message
    || 'O nosso sistema detectou uma oportunidade crítica no seu negócio. Um especialista Vanguard pode mostrar-lhe exactamente como recuperar a receita perdida — em 5 minutos.';
  return `
<div id="vg-intervention-modal" style="
  display:flex;position:fixed;inset:0;z-index:9999999;
  background:rgba(0,0,0,0.88);backdrop-filter:blur(8px);
  align-items:center;justify-content:center;
">
  <div style="
    background:linear-gradient(135deg,#0A0802,#100D05);
    border:1px solid rgba(197,160,40,0.6);border-radius:14px;
    padding:40px 44px;max-width:440px;width:90%;position:relative;
    box-shadow:0 24px 80px rgba(0,0,0,0.9),0 0 60px rgba(197,160,40,0.15);
    font-family:'Inter',sans-serif;color:#E6E4DC;text-align:center;
    animation:vgSlideIn .4s cubic-bezier(.16,1,.3,1) both;
  ">
    <style>@keyframes vgSlideIn{from{opacity:0;transform:translateY(24px)}to{opacity:1;transform:none}}</style>
    <button onclick="document.getElementById('vg-intervention-modal').remove()"
            style="position:absolute;top:14px;right:18px;background:none;border:none;
                   color:#5A5546;font-size:18px;cursor:pointer;">✕</button>
    <div style="font-size:36px;margin-bottom:14px">⚡</div>
    <div style="font-size:10px;letter-spacing:.18em;color:rgba(197,160,40,.6);margin-bottom:12px">
      VANGUARD INTELLIGENCE — ALERTA PRIORITÁRIO
    </div>
    <h3 style="font-size:1.3rem;font-weight:700;margin-bottom:14px;color:#E6E4DC;line-height:1.3">
      Acção imediata recomendada
    </h3>
    <p style="font-size:.82rem;color:rgba(230,228,220,.7);line-height:1.6;margin-bottom:26px">
      ${msg}
    </p>
    <a href="https://vanguard.tech?ref=intervention&tid=${tenantId}&type=${intervention?.type || 'offer'}"
       target="_blank" style="
      display:block;background:linear-gradient(135deg,#C5A028,#8B7019);
      color:#0A0802;border-radius:9px;padding:15px;font-weight:700;
      font-size:.88rem;letter-spacing:.04em;text-decoration:none;
      box-shadow:0 4px 20px rgba(197,160,40,0.4);
    ">Falar com especialista agora →</a>
    <p style="font-size:9px;color:#3A3020;margin-top:14px">
      Vanguard Intelligence · Intervenção autorizada pelo Diretor · tid:${tenantId}
    </p>
  </div>
</div>`;
}

/* ── Snippets a injectar ─────────────────────────────────────────────────── */

function pixelSnippet(tenantId) {
  return `<script src="https://pixel.vanguard.tech/pixel.js?tid=${tenantId}" async defer><\/script>`;
}

function badgeSnippet(tenantId) {
  return `
<div id="vg-badge" style="
  position:fixed;bottom:18px;right:18px;z-index:99999;
  background:linear-gradient(135deg,#0A0802,#1A1408);
  border:1px solid rgba(197,160,40,0.5);border-radius:8px;
  padding:7px 13px;display:flex;align-items:center;gap:8px;
  font-family:'Inter',sans-serif;font-size:11px;color:#C5A028;
  box-shadow:0 4px 24px rgba(0,0,0,0.6),0 0 12px rgba(197,160,40,0.12);
  cursor:pointer;text-decoration:none;
" onclick="window.open('https://vanguard.tech?ref=badge&tid=${tenantId}','_blank')">
  <span style="font-size:14px">🛡️</span>
  <span style="font-weight:700;letter-spacing:.04em">VANGUARD</span>
  <span style="opacity:.5;font-size:9px">VERIFIED</span>
</div>`;
}

function exitIntentSnippet(tenantId) {
  return `
<div id="vg-exit-modal" style="
  display:none;position:fixed;inset:0;z-index:999999;
  background:rgba(0,0,0,0.82);backdrop-filter:blur(6px);
  align-items:center;justify-content:center;
">
  <div style="
    background:linear-gradient(135deg,#0A0802,#100D05);
    border:1px solid rgba(197,160,40,0.45);border-radius:14px;
    padding:36px 40px;max-width:420px;width:90%;position:relative;
    box-shadow:0 24px 80px rgba(0,0,0,0.8),0 0 40px rgba(197,160,40,0.1);
    font-family:'Inter',sans-serif;color:#E6E4DC;text-align:center;
  ">
    <button onclick="document.getElementById('vg-exit-modal').style.display='none'"
            style="position:absolute;top:14px;right:18px;background:none;border:none;
                   color:#5A5546;font-size:18px;cursor:pointer;">✕</button>
    <div style="font-size:32px;margin-bottom:12px">⚡</div>
    <div style="font-size:11px;letter-spacing:.15em;color:rgba(197,160,40,.6);margin-bottom:10px">
      VANGUARD INTELLIGENCE
    </div>
    <h3 style="font-size:1.25rem;font-weight:700;margin-bottom:10px;color:#E6E4DC">
      Antes de sair — veja o que está a perder
    </h3>
    <p style="font-size:.8rem;color:rgba(197,160,40,.5);line-height:1.5;margin-bottom:22px">
      O nosso sistema detectou alto interesse. Um especialista pode mostrar-lhe exactamente onde o seu negócio está a perder receita — em 5 minutos.
    </p>
    <a href="https://vanguard.tech?ref=exit&tid=${tenantId}" target="_blank" style="
      display:block;background:linear-gradient(135deg,#C5A028,#8B7019);
      color:#0A0802;border-radius:8px;padding:13px;font-weight:700;
      font-size:.85rem;letter-spacing:.03em;text-decoration:none;
    ">Ver diagnóstico gratuito →</a>
    <p style="font-size:9px;color:#3A3020;margin-top:12px">
      Powered by Vanguard Intelligence · tid:${tenantId}
    </p>
  </div>
</div>
<script>
(function(){
  var shown = false;
  var FIRE_COOKIE = document.cookie.match(/__vg_intent=FIRE/);
  if (!FIRE_COOKIE) return;
  document.addEventListener('mouseleave', function(e) {
    if (shown || e.clientY > 5) return;
    shown = true;
    document.getElementById('vg-exit-modal').style.display = 'flex';
  });
})();
<\/script>`;
}

/* ── HTMLRewriter Handlers ───────────────────────────────────────────────── */

class HeadInjector {
  constructor(tenantId) { this.tenantId = tenantId; }
  element(el) {
    el.append(pixelSnippet(this.tenantId), { html: true });
  }
}

class BodyInjector {
  constructor(tenantId, isFire, intervention) {
    this.tenantId     = tenantId;
    this.isFire       = isFire;
    this.intervention = intervention;
  }
  element(el) {
    el.append(badgeSnippet(this.tenantId), { html: true });
    /* Intervenção do Cockpit tem prioridade sobre Exit Intent normal */
    if (this.intervention) {
      el.append(interventionSnippet(this.tenantId, this.intervention), { html: true });
    } else if (this.isFire) {
      el.append(exitIntentSnippet(this.tenantId), { html: true });
    }
  }
}

/* ── Tenant Config Lookup ────────────────────────────────────────────────── */

async function getTenant(hostname, env) {
  if (!env.TENANTS_KV) return null;
  try {
    return await env.TENANTS_KV.get(hostname, 'json');
  } catch { return null; }
}

/* ── Intent Detection ───────────────────────────────────────────────────── */

function isFireVisitor(request) {
  const cookie = request.headers.get('Cookie') || '';
  return cookie.includes('__vg_intent=FIRE');
}

/* ── Main Handler ───────────────────────────────────────────────────────── */

export default {
  async fetch(request, env) {
    const url      = new URL(request.url);
    const hostname = url.hostname;

    /* Tenant lookup via KV (Custom Hostname → tenant config) */
    const tenant = await getTenant(hostname, env);
    if (!tenant) {
      return new Response('Vanguard Federation: tenant not configured for ' + hostname, {
        status: 200,
        headers: { 'Content-Type': 'text/plain' },
      });
    }

    /* Proxy request to origin */
    const originUrl = new URL(request.url);
    originUrl.hostname = tenant.origin_hostname;

    const originReq = new Request(originUrl.toString(), {
      method:  request.method,
      headers: request.headers,
      body:    ['GET', 'HEAD'].includes(request.method) ? undefined : request.body,
      redirect: 'follow',
    });

    let response;
    try {
      response = await fetch(originReq);
    } catch (err) {
      return new Response('Origin unreachable: ' + err.message, { status: 502 });
    }

    /* Only inject into HTML */
    const ct = response.headers.get('Content-Type') || '';
    if (!ct.includes('text/html')) return response;

    /* Detect FIRE intent from cookie */
    const fire = isFireVisitor(request);

    /* Check active intervention from Cockpit (KV bus) */
    const intervention = await getIntervention(tenant.tenant_id, env);

    /* Inject via HTMLRewriter */
    const transformed = new HTMLRewriter()
      .on('head', new HeadInjector(tenant.tenant_id))
      .on('body', new BodyInjector(tenant.tenant_id, fire, intervention))
      .transform(response);

    /* Add Vanguard headers (audit trail) */
    const headers = new Headers(transformed.headers);
    headers.set('X-Vanguard-Federation', 'v2');
    headers.set('X-Vanguard-Tenant', tenant.tenant_id);

    return new Response(transformed.body, {
      status:  transformed.status,
      headers,
    });
  },
};

/* ── wrangler.toml (referência — criar em cloudflare/wrangler-federation.toml)
name = "vanguard-federation-proxy"
main = "cloudflare/federation-proxy.js"
compatibility_date = "2024-01-01"

[[kv_namespaces]]
binding = "TENANTS_KV"
id      = "<KV_NAMESPACE_ID>"  # criar: wrangler kv:namespace create TENANTS_KV

[vars]
SUPABASE_URL  = "https://ehyaecxqijgyuuiorzcj.supabase.co"

# secrets (wrangler secret put SUPABASE_ANON):
# SUPABASE_ANON = "eyJ..."

# Para adicionar tenant:
# wrangler kv:key put --binding=TENANTS_KV "clinica-abc.com.br" \
#   '{"tenant_id":"clinica-abc","origin_hostname":"origin.clinica-abc.com.br"}'
── */
