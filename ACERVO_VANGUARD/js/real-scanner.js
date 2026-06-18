'use strict';

// ── Real Scanner V15 — Motor de Auditoria HTTP Real ──────────────────────────
// Substitui o motor determinístico (djb2) por auditorias reais via:
//   1. Google PageSpeed Insights API v5 (quando API Key configurada)
//   2. DNS-over-HTTPS Cloudflare (verificação de existência do domínio)
//   3. Fallback determinístico aprimorado (sem chave ou API indisponível)
//
// Dynamic Rate Limiting: fila com controlo de concorrência e delays adaptativos
// Exposto como: window.RealScanner = { scan(domain), setApiKey(key), getQueue() }

window.RealScanner = (() => {
  'use strict';

  // ─── Configuração ──────────────────────────────────────────────────────────
  const CFG = {
    pageSpeedKey:      localStorage.getItem('vanguard_psi_key') || '',
    maxConcurrent:     2,       // máx requisições simultâneas
    requestDelay:      2500,    // ms entre pedidos (protege Hostinger de sobrecarga)
    timeoutMs:         12000,   // timeout por pedido
    cacheMinutes:      60,      // cache de resultados por domínio
    rateLimitPerHour:  80,      // max scans/hora (Dynamic Rate Limiting)
  };

  // ─── Fila e Rate Limiting ──────────────────────────────────────────────────
  let _queue       = [];
  let _active      = 0;
  let _hourCount   = 0;
  let _hourReset   = Date.now() + 3600000;
  const _cache     = new Map(); // domain → { result, expiresAt }

  function resetHourIfNeeded() {
    if (Date.now() > _hourReset) { _hourCount = 0; _hourReset = Date.now() + 3600000; }
  }

  function isRateLimited() {
    resetHourIfNeeded();
    return _hourCount >= CFG.rateLimitPerHour;
  }

  function getQueueStatus() {
    return {
      queued: _queue.length,
      active: _active,
      scansThisHour: _hourCount,
      limitPerHour: CFG.rateLimitPerHour,
      isLimited: isRateLimited(),
    };
  }

  // Processa próximo item da fila
  function processQueue() {
    if (_queue.length === 0 || _active >= CFG.maxConcurrent) return;
    const { domain, resolve, reject } = _queue.shift();
    _active++;
    _hourCount++;
    _doScan(domain)
      .then(resolve)
      .catch(reject)
      .finally(() => {
        _active--;
        setTimeout(processQueue, CFG.requestDelay);
      });
  }

  // ─── Cache ─────────────────────────────────────────────────────────────────
  function cacheGet(domain) {
    const entry = _cache.get(domain);
    if (!entry) return null;
    if (Date.now() > entry.expiresAt) { _cache.delete(domain); return null; }
    return entry.result;
  }

  function cacheSet(domain, result) {
    _cache.set(domain, {
      result,
      expiresAt: Date.now() + CFG.cacheMinutes * 60000,
    });
  }

  // ─── Utilitários ───────────────────────────────────────────────────────────
  function normalizeUrl(domain) {
    domain = domain.trim().toLowerCase().replace(/^https?:\/\//, '').replace(/\/$/, '');
    return `https://${domain}`;
  }

  function extractDomain(domain) {
    return domain.trim().toLowerCase().replace(/^https?:\/\//, '').replace(/\/$/, '').split('/')[0];
  }

  // djb2 hash para fallback determinístico
  function djb2(str) {
    let h = 5381;
    for (let i = 0; i < str.length; i++) h = ((h << 5) + h) ^ str.charCodeAt(i);
    return Math.abs(h);
  }

  function seeded(hash, min, max) {
    const x = Math.sin(hash) * 10000;
    return min + (x - Math.floor(x)) * (max - min);
  }

  // ─── DNS-over-HTTPS: verifica se o domínio existe ─────────────────────────
  async function checkDomainExists(domain) {
    try {
      const url = `https://cloudflare-dns.com/dns-query?name=${encodeURIComponent(domain)}&type=A`;
      const res = await fetch(url, {
        headers: { Accept: 'application/dns-json' },
        signal: AbortSignal.timeout(4000),
      });
      if (!res.ok) return { exists: false };
      const data = await res.json();
      // Status 0 = NOERROR (domain exists), 3 = NXDOMAIN (not found)
      return {
        exists: data.Status === 0 && data.Answer?.length > 0,
        ips:    (data.Answer || []).map(r => r.data).filter(d => /^\d/.test(d)),
      };
    } catch {
      return { exists: true }; // assume existe se timeout (evita falso negativo)
    }
  }

  // ─── PageSpeed Insights API v5 ────────────────────────────────────────────
  async function runPageSpeedAudit(url) {
    if (!CFG.pageSpeedKey) return null;

    const endpoint = new URL('https://www.googleapis.com/pagespeedonline/v5/runPagespeed');
    endpoint.searchParams.set('url', url);
    endpoint.searchParams.set('key', CFG.pageSpeedKey);
    endpoint.searchParams.set('strategy', 'mobile');
    ['performance', 'accessibility', 'best-practices', 'seo'].forEach(c =>
      endpoint.searchParams.append('category', c)
    );

    const res = await fetch(endpoint.toString(), {
      signal: AbortSignal.timeout(CFG.timeoutMs),
    });

    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      if (err?.error?.code === 429) throw new Error('PSI_RATE_LIMIT');
      if (err?.error?.code === 400) throw new Error('PSI_INVALID_URL');
      throw new Error(`PSI_HTTP_${res.status}`);
    }

    return await res.json();
  }

  // ─── Converter resultado PSI para Score Vanguard (0–10) ───────────────────
  function psiToVanguardScore(psiResult, domainExists) {
    if (!psiResult) return null;

    const cats   = psiResult.lighthouseResult?.categories  || {};
    const audits = psiResult.lighthouseResult?.audits      || {};

    // Dimensões (0–1 cada)
    const perf    = cats.performance?.score          ?? 0;
    const access  = cats.accessibility?.score        ?? 0;
    const best    = cats['best-practices']?.score    ?? 0;
    const seo     = cats.seo?.score                  ?? 0;
    const https   = audits['uses-https']?.score      ?? (domainExists ? 0 : 0);
    const mobile  = audits.viewport?.score            ?? 0;
    const fcp     = audits['first-contentful-paint']?.numericValue ?? 5000;
    const tti     = audits.interactive?.numericValue              ?? 8000;
    const lcp     = audits['largest-contentful-paint']?.numericValue ?? 6000;

    // Speed score (normalizado: < 1s = 1.0, > 6s = 0.0)
    const speedScore = Math.max(0, 1 - (fcp / 6000));

    // Score composto (pesos alinhados com §17.1 Business Rules)
    const composite = (
      perf    * 0.25 +   // Presença/Velocidade
      seo     * 0.20 +   // SEO/Visibilidade
      https   * 0.15 +   // Segurança
      mobile  * 0.15 +   // Conversão Mobile
      access  * 0.10 +   // Acessibilidade
      best    * 0.10 +   // Boas Práticas
      speedScore * 0.05  // Velocidade FCP
    );

    const score = Math.round(composite * 10 * 10) / 10; // 0.0–10.0

    // Bottlenecks: identificar as dimensões com pior score
    const dimensions = [
      { key: 'performance', label: 'Velocidade & Performance',       score: perf,       weight: 0.25 },
      { key: 'seo',         label: 'Visibilidade no Google (SEO)',   score: seo,        weight: 0.20 },
      { key: 'security',    label: 'Segurança & HTTPS',              score: https,      weight: 0.15 },
      { key: 'mobile',      label: 'Experiência Mobile',             score: mobile,     weight: 0.15 },
      { key: 'accessibility',label: 'Acessibilidade',                score: access,     weight: 0.10 },
      { key: 'best_pract',  label: 'Boas Práticas Web',             score: best,       weight: 0.10 },
    ];

    const bottlenecks = dimensions
      .filter(d => d.score < 0.7)
      .sort((a, b) => a.score - b.score)
      .slice(0, 3)
      .map(d => ({
        key:     d.key,
        label:   d.label,
        score:   Math.round(d.score * 100),
        impact:  BOTTLENECK_IMPACTS[d.key] || 'Impacto directo na conversão e visibilidade',
      }));

    // Métricas reais para exibição
    const metrics = {
      fcp:  Math.round(fcp)  + 'ms',
      tti:  Math.round(tti)  + 'ms',
      lcp:  Math.round(lcp)  + 'ms',
      perf: Math.round(perf  * 100) + '%',
      seo:  Math.round(seo   * 100) + '%',
    };

    return { score, dimensions, bottlenecks, metrics, isReal: true, source: 'pagespeed-v5' };
  }

  // ─── Base de impactos por bottleneck ──────────────────────────────────────
  const BOTTLENECK_IMPACTS = {
    performance:   'Velocidade < 3s — 40% dos visitantes abandonam antes de carregar',
    seo:           'Invisível no Google — tráfego orgânico próximo de zero',
    security:      'Site sem HTTPS — dados em risco e penalização do Chrome/Google',
    mobile:        'Não responsivo — 60% do tráfego mobile desperdiçado',
    accessibility: 'Barreiras de acessibilidade — perda de até 20% do público',
    best_pract:    'Más práticas web — vulnerabilidades e má reputação técnica',
  };

  // ─── Fallback Determinístico Aprimorado ───────────────────────────────────
  function deterministicScore(domain) {
    const h = djb2(domain);
    const s = (index) => seeded(h + index * 997, 0, 1);

    const dimensions = [
      { key: 'performance',   label: 'Velocidade & Performance',     score: s(0),  weight: 0.25 },
      { key: 'seo',           label: 'Visibilidade no Google (SEO)', score: s(1),  weight: 0.20 },
      { key: 'security',      label: 'Segurança & HTTPS',            score: s(2) > 0.3 ? 1 : 0, weight: 0.15 },
      { key: 'mobile',        label: 'Experiência Mobile',           score: s(3),  weight: 0.15 },
      { key: 'accessibility', label: 'Acessibilidade',               score: s(4),  weight: 0.10 },
      { key: 'best_pract',    label: 'Boas Práticas Web',            score: s(5),  weight: 0.10 },
    ];

    const composite = dimensions.reduce((sum, d) => sum + d.score * d.weight, 0) / 0.95;
    const score = Math.round(Math.max(0, Math.min(10, composite * 10)) * 10) / 10;

    const bottlenecks = dimensions
      .filter(d => d.score < 0.7)
      .sort((a, b) => a.score - b.score)
      .slice(0, 3)
      .map(d => ({
        key:    d.key,
        label:  d.label,
        score:  Math.round(d.score * 100),
        impact: BOTTLENECK_IMPACTS[d.key] || '',
      }));

    return { score, dimensions, bottlenecks, metrics: null, isReal: false, source: 'deterministic-v15' };
  }

  // ─── Motor Principal de Scan ───────────────────────────────────────────────
  async function _doScan(domain) {
    const cleanDomain = extractDomain(domain);
    const url         = normalizeUrl(cleanDomain);

    // 1. Verificar existência do domínio via DNS-over-HTTPS
    const { exists, ips } = await checkDomainExists(cleanDomain);

    if (!exists) {
      return {
        domain:      cleanDomain,
        score:       10.0,
        dimensions:  [],
        bottlenecks: [{ key: 'no_website', label: 'Sem website detectado', score: 0, impact: 'Oportunidade máxima — empresa sem presença digital' }],
        metrics:     null,
        isReal:      true,
        source:      'dns-nxdomain',
        exists:      false,
        ips:         [],
      };
    }

    // 2. Tentar PageSpeed Insights API
    let psiResult = null;
    try {
      psiResult = await runPageSpeedAudit(url);
    } catch (err) {
      console.warn('[RealScanner] PSI indisponível:', err.message, '— usando fallback determinístico');
    }

    // 3. Converter ou fazer fallback
    const result = psiResult
      ? psiToVanguardScore(psiResult, exists)
      : deterministicScore(cleanDomain);

    return { domain: cleanDomain, exists: true, ips, ...result };
  }

  // ─── API Pública ───────────────────────────────────────────────────────────
  function scan(domain) {
    return new Promise((resolve, reject) => {
      const cleanDomain = extractDomain(domain);

      // Cache hit
      const cached = cacheGet(cleanDomain);
      if (cached) return resolve({ ...cached, fromCache: true });

      // Rate limit hard stop
      if (isRateLimited()) {
        console.warn('[RealScanner] Rate limit atingido — usando fallback imediato');
        const fallback = deterministicScore(cleanDomain);
        return resolve({ domain: cleanDomain, ...fallback, rateLimited: true });
      }

      // Adicionar à fila
      _queue.push({
        domain: cleanDomain,
        resolve: (result) => { cacheSet(cleanDomain, result); resolve(result); },
        reject,
      });
      processQueue();
    });
  }

  function setApiKey(key) {
    CFG.pageSpeedKey = key;
    localStorage.setItem('vanguard_psi_key', key);
  }

  function clearCache() { _cache.clear(); }

  // ─── Painel de Configuração do Scanner ────────────────────────────────────
  function renderConfigPanel(containerId) {
    const container = document.getElementById(containerId);
    if (!container) return;

    container.innerHTML = `
      <div style="display:grid;grid-template-columns:1fr auto;gap:.625rem;align-items:end;margin-bottom:.875rem;">
        <div>
          <label style="font-size:.62rem;letter-spacing:.12em;text-transform:uppercase;color:rgba(0,240,255,.4);display:block;margin-bottom:.3rem;">
            Google PageSpeed Insights API Key
          </label>
          <input id="psi-key-input" type="password"
            style="background:rgba(0,0,0,.35);border:1px solid rgba(0,240,255,.12);border-radius:7px;
                   color:#E8EAF0;font-family:'Inter',sans-serif;font-size:.82rem;
                   padding:.5rem .875rem;outline:none;width:100%;transition:border-color .2s;"
            placeholder="AIzaSy... (opcional — activa auditorias reais)"
            value="${CFG.pageSpeedKey}"
            onfocus="this.style.borderColor='#00F0FF'"
            onblur="this.style.borderColor='rgba(0,240,255,.12)'" />
        </div>
        <button onclick="window.RealScanner.setApiKey(document.getElementById('psi-key-input').value);this.textContent='✓ Guardado';setTimeout(()=>this.textContent='Guardar',2000);"
          style="background:rgba(0,240,255,.1);border:1px solid rgba(0,240,255,.25);border-radius:7px;
                 color:#00F0FF;font-family:'Inter',sans-serif;font-size:.75rem;font-weight:700;
                 letter-spacing:.08em;padding:.5rem 1rem;cursor:pointer;white-space:nowrap;
                 text-transform:uppercase;">
          Guardar
        </button>
      </div>
      <p style="font-size:.72rem;color:rgba(232,234,240,.35);line-height:1.5;">
        Sem API Key: o scanner usa análise determinística (consistente para demos).
        Com API Key: auditorias reais via Google PageSpeed Insights.
        <a href="https://developers.google.com/speed/docs/insights/v5/get-started" target="_blank" rel="noopener"
           style="color:rgba(0,240,255,.5);text-decoration:none;">Obter key gratuita →</a>
      </p>
    `;
  }

  return { scan, setApiKey, clearCache, getQueue: getQueueStatus, renderConfigPanel };
})();
