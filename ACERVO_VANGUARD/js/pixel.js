/*!
 * Vanguard Sovereign Pixel v1.0 — pixel.js
 * Edge Intent Classifier: COLD / WARM / HOT / FIRE
 * < 3KB minified · LGPD/GDPR compliant · Cloudflare Worker ready
 * Dispatch → Supabase pixel_events_staging (UNLOGGED, high-perf)
 */
(function (W, D) {
  'use strict';

  // ─── Config (injetado pelo Worker no serve) ──────────────────────────────────
  var CFG = W.__VP_CFG || {};
  var ENDPOINT = CFG.endpoint || 'https://api.vanguard.tech/v1/pixel';
  var TENANT_ID = CFG.tenant_id || '';
  var SITE_ID   = CFG.site_id   || '';
  var CONSENT_KEY = 'vp_consent';

  // ─── LGPD/GDPR — Consent Guard ──────────────────────────────────────────────
  function hasConsent() {
    try { return localStorage.getItem(CONSENT_KEY) === '1'; } catch (e) { return false; }
  }

  function grantConsent() {
    try { localStorage.setItem(CONSENT_KEY, '1'); } catch (e) {}
  }

  function showConsentBanner() {
    if (hasConsent() || D.getElementById('vp-consent')) return;
    var b = D.createElement('div');
    b.id = 'vp-consent';
    b.setAttribute('style', [
      'position:fixed;bottom:0;left:0;right:0;z-index:99999',
      'background:#0A0802;color:#ccc;font:13px/1.5 sans-serif',
      'padding:12px 20px;display:flex;align-items:center;gap:16px',
      'border-top:1px solid #C5A028'
    ].join(';'));
    b.innerHTML = '<span style="flex:1">Este site usa cookies analíticos para melhorar a sua experiência. ' +
      '<a href="/privacidade" style="color:#C5A028">Saiba mais</a></span>' +
      '<button id="vp-accept" style="background:#C5A028;color:#0A0802;border:none;' +
      'padding:6px 18px;cursor:pointer;font-weight:700;border-radius:4px">Aceitar</button>' +
      '<button id="vp-decline" style="background:transparent;color:#888;border:1px solid #444;' +
      'padding:6px 14px;cursor:pointer;border-radius:4px">Recusar</button>';
    D.body.appendChild(b);
    D.getElementById('vp-accept').onclick = function () {
      grantConsent();
      b.remove();
      boot();
    };
    D.getElementById('vp-decline').onclick = function () { b.remove(); };
  }

  // ─── Session State ───────────────────────────────────────────────────────────
  var SESSION = {
    id:           genId(),
    tenant_id:    TENANT_ID,
    site_id:      SITE_ID,
    url:          W.location.href,
    referrer:     D.referrer || '',
    started_at:   Date.now(),
    intent:       'COLD',       // COLD | WARM | HOT | FIRE
    // signals
    dwell_ms:     0,
    scroll_pct:   0,
    cta_hover_ms: 0,
    exit_intent:  false,
    clicks:       0,
  };

  var _ctaHoverStart = 0;
  var _scrollTimer   = null;

  function genId() {
    return 'vp_' + Math.random().toString(36).slice(2, 11) + Date.now().toString(36);
  }

  // ─── Intent Classifier ──────────────────────────────────────────────────────
  // Regra: score ponderado → bucket
  // dwell >90s=2, >30s=1 | scroll >70%=2, >40%=1 | cta_hover >5s=2, >1s=1
  // exit_intent=+2 | clicks >3=1
  function classify() {
    var s = SESSION;
    var score = 0;
    if (s.dwell_ms > 90000) score += 2; else if (s.dwell_ms > 30000) score += 1;
    if (s.scroll_pct > 70)  score += 2; else if (s.scroll_pct > 40)  score += 1;
    if (s.cta_hover_ms > 5000) score += 2; else if (s.cta_hover_ms > 1000) score += 1;
    if (s.exit_intent) score += 2;
    if (s.clicks > 3)  score += 1;

    if (score >= 7) return 'FIRE';
    if (score >= 4) return 'HOT';
    if (score >= 2) return 'WARM';
    return 'COLD';
  }

  // ─── Signal Collectors ──────────────────────────────────────────────────────
  function trackDwell() {
    setInterval(function () {
      if (!D.hidden) SESSION.dwell_ms += 1000;
    }, 1000);
  }

  function trackScroll() {
    W.addEventListener('scroll', function () {
      clearTimeout(_scrollTimer);
      _scrollTimer = setTimeout(function () {
        var el = D.documentElement;
        var pct = Math.round((el.scrollTop / (el.scrollHeight - el.clientHeight)) * 100);
        if (pct > SESSION.scroll_pct) SESSION.scroll_pct = pct;
      }, 200);
    }, { passive: true });
  }

  function trackCTAs() {
    // Seleciona elementos CTA comuns
    var selectors = 'a[href*="contato"],a[href*="contact"],a[href*="whatsapp"],' +
      'button,[data-cta],form,[class*="cta"],[class*="btn-primary"]';
    try {
      D.querySelectorAll(selectors).forEach(function (el) {
        el.addEventListener('mouseenter', function () { _ctaHoverStart = Date.now(); });
        el.addEventListener('mouseleave', function () {
          if (_ctaHoverStart) SESSION.cta_hover_ms += Date.now() - _ctaHoverStart;
          _ctaHoverStart = 0;
        });
      });
    } catch (e) {}
  }

  function trackExitIntent() {
    D.addEventListener('mouseleave', function (e) {
      if (e.clientY < 5) {
        SESSION.exit_intent = true;
        flush('exit_intent');
      }
    });
  }

  function trackClicks() {
    D.addEventListener('click', function () { SESSION.clicks++; }, { passive: true });
  }

  // ─── Dispatch ────────────────────────────────────────────────────────────────
  var _lastFlush = 0;
  var _flushDebounce = 10000; // flush máx a cada 10s

  function flush(trigger) {
    var now = Date.now();
    if (now - _lastFlush < _flushDebounce && trigger !== 'exit_intent' && trigger !== 'unload') return;
    _lastFlush = now;

    SESSION.intent = classify();
    SESSION.dwell_ms = Date.now() - SESSION.started_at;

    var payload = JSON.stringify({
      session_id:   SESSION.id,
      tenant_id:    SESSION.tenant_id,
      site_id:      SESSION.site_id,
      url:          SESSION.url,
      referrer:     SESSION.referrer,
      intent:       SESSION.intent,
      dwell_ms:     SESSION.dwell_ms,
      scroll_pct:   SESSION.scroll_pct,
      cta_hover_ms: SESSION.cta_hover_ms,
      exit_intent:  SESSION.exit_intent,
      clicks:       SESSION.clicks,
      ts:           new Date().toISOString(),
      trigger:      trigger || 'periodic',
    });

    // Beacon API (não bloqueia unload)
    if (navigator.sendBeacon) {
      navigator.sendBeacon(ENDPOINT, new Blob([payload], { type: 'application/json' }));
    } else {
      var xhr = new XMLHttpRequest();
      xhr.open('POST', ENDPOINT, true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.send(payload);
    }
  }

  // ─── Boot ────────────────────────────────────────────────────────────────────
  function boot() {
    trackDwell();
    trackScroll();
    trackCTAs();
    trackExitIntent();
    trackClicks();

    // Flush periódico (30s e 60s)
    setTimeout(function () { flush('30s'); }, 30000);
    setTimeout(function () { flush('60s'); }, 60000);

    // Flush on unload
    W.addEventListener('pagehide', function () { flush('unload'); });
    W.addEventListener('beforeunload', function () { flush('unload'); });
  }

  // ─── Entry Point ─────────────────────────────────────────────────────────────
  function init() {
    if (hasConsent()) {
      boot();
    } else {
      showConsentBanner();
    }
  }

  if (D.readyState === 'loading') {
    D.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // API pública (para debug/testes)
  W.VanguardPixel = {
    getSession: function () { return SESSION; },
    getIntent:  function () { return classify(); },
    flush:      function () { flush('manual'); },
  };

}(window, document));
