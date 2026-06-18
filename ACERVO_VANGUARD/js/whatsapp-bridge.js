'use strict';

// ── WhatsApp Bridge V15 ───────────────────────────────────────────────────────
// Integração com Evolution API (open-source, self-hosted) ou Z-API (paid SaaS)
// Permite: envio de texto, imagem PNG (Trojan Card), e link HUD personalizado
// Exposto como window.WhatsAppBridge.init(config)

window.WhatsAppBridge = (() => {

  // ─── Configuração ──────────────────────────────────────────────────────────
  // Preenchida pelo Director no painel de configuração ou via CLAUDE.md env
  const DEFAULT_CONFIG = {
    provider:    'evolution',      // 'evolution' | 'zapi'
    baseUrl:     '',               // ex: 'http://evolution.vanguardtech.io:8080'
    apiKey:      '',               // API key da Evolution / Z-API token
    instanceId:  'vanguard-hermes',// Nome da instância (Evolution) ou Instance ID (Z-API)
    zapiToken:   '',               // Apenas para Z-API
  };

  let config = { ...DEFAULT_CONFIG };
  let configSaved = false;

  // ─── Utilitários ───────────────────────────────────────────────────────────
  function normalizePhone(phone) {
    // Remove tudo excepto dígitos; garante prefixo 351 para Portugal
    const digits = phone.replace(/\D/g, '');
    if (digits.startsWith('351') || digits.startsWith('55') || digits.startsWith('1')) {
      return digits; // já tem código de país
    }
    return '351' + digits; // assume Portugal
  }

  function buildEvolutionHeaders() {
    return {
      'Content-Type': 'application/json',
      'apikey': config.apiKey,
    };
  }

  function buildZapiHeaders() {
    return {
      'Content-Type': 'application/json',
      'Client-Token': config.zapiToken || config.apiKey,
    };
  }

  function buildHeaders() {
    return config.provider === 'zapi' ? buildZapiHeaders() : buildEvolutionHeaders();
  }

  // ─── API: Envio de Texto ────────────────────────────────────────────────────
  async function sendText(phone, message) {
    if (!config.baseUrl || !config.apiKey) {
      throw new Error('WhatsApp Bridge não configurado. Insira a URL e API Key.');
    }

    const number = normalizePhone(phone);

    if (config.provider === 'evolution') {
      const url = `${config.baseUrl}/message/sendText/${config.instanceId}`;
      const res = await fetch(url, {
        method: 'POST',
        headers: buildHeaders(),
        body: JSON.stringify({
          number,
          text: message,
          delay: 1200,    // delay em ms (humaniza o envio)
        }),
      });
      if (!res.ok) throw new Error(`Evolution API error: ${res.status} ${await res.text()}`);
      return await res.json();
    }

    if (config.provider === 'zapi') {
      const url = `${config.baseUrl}/instances/${config.instanceId}/token/${config.zapiToken}/send-text`;
      const res = await fetch(url, {
        method: 'POST',
        headers: buildHeaders(),
        body: JSON.stringify({ phone: number, message }),
      });
      if (!res.ok) throw new Error(`Z-API error: ${res.status} ${await res.text()}`);
      return await res.json();
    }
  }

  // ─── API: Envio de Imagem (Trojan PNG) ─────────────────────────────────────
  // imageSource: URL pública OU data URL base64 (do TrojanGenerator.generatePNG)
  async function sendImage(phone, imageSource, caption = '') {
    if (!config.baseUrl || !config.apiKey) {
      throw new Error('WhatsApp Bridge não configurado.');
    }

    const number = normalizePhone(phone);
    const isBase64 = imageSource.startsWith('data:');
    const mediaUrl = isBase64
      ? imageSource.replace(/^data:image\/\w+;base64,/, '')
      : imageSource;

    if (config.provider === 'evolution') {
      const url = `${config.baseUrl}/message/sendMedia/${config.instanceId}`;
      const res = await fetch(url, {
        method: 'POST',
        headers: buildHeaders(),
        body: JSON.stringify({
          number,
          mediatype: 'image',
          mimetype:  'image/png',
          caption,
          media: isBase64 ? mediaUrl : undefined,
          mediaUrl: isBase64 ? undefined : mediaUrl,
          fileName: 'vanguard-hud-audit.png',
        }),
      });
      if (!res.ok) throw new Error(`Evolution API media error: ${res.status} ${await res.text()}`);
      return await res.json();
    }

    if (config.provider === 'zapi') {
      const url = `${config.baseUrl}/instances/${config.instanceId}/token/${config.zapiToken}/send-image`;
      const res = await fetch(url, {
        method: 'POST',
        headers: buildHeaders(),
        body: JSON.stringify({
          phone:   number,
          image:   isBase64 ? `data:image/png;base64,${mediaUrl}` : mediaUrl,
          caption,
        }),
      });
      if (!res.ok) throw new Error(`Z-API image error: ${res.status} ${await res.text()}`);
      return await res.json();
    }
  }

  // ─── API: Envio de Link HUD Personalizado ──────────────────────────────────
  // Envia mensagem Hermes + link para o HUD Preview do domínio do lead
  async function sendHUDLink(phone, domain, score, nome = 'empresário') {
    const previewUrl = `https://vanguardtech.io/preview/?d=${encodeURIComponent(domain)}`;
    const message = [
      `Olá ${nome}! 👋`,
      '',
      `Realizei uma auditoria digital ao site *${domain}* e o resultado está disponível no link abaixo:`,
      '',
      `🔍 *Score de Maturidade Digital: ${score}/10*`,
      `📊 Ver relatório completo: ${previewUrl}`,
      '',
      `Identifiquei gargalos críticos que estão a custar visibilidade e clientes.`,
      `Quer saber como resolver isto em 30 dias?`,
      '',
      `— Hermes · Vanguard Tech 🚀`,
    ].join('\n');

    return sendText(phone, message);
  }

  // ─── API: Disparo Trojan Completo (PNG + mensagem) ─────────────────────────
  // Fluxo completo: gera PNG via TrojanGenerator + envia como imagem + envia link
  async function dispatchTrojan(phone, domain, score, nome = 'empresário') {
    if (typeof window.TrojanGenerator === 'undefined') {
      throw new Error('TrojanGenerator não carregado. Inclua js/trojan-generator.js.');
    }

    // 1. Gerar PNG
    const dataUrl = await window.TrojanGenerator.generatePNG(domain, score);

    // 2. Enviar imagem com caption
    const caption = `Auditoria Digital · ${domain} · Score ${score}/10 · Vanguard Tech`;
    await sendImage(phone, dataUrl, caption);

    // 3. Aguardar 1.5s (humaniza o envio)
    await new Promise(r => setTimeout(r, 1500));

    // 4. Enviar mensagem de texto com link HUD
    return sendHUDLink(phone, domain, score, nome);
  }

  // ─── Verificar conexão da instância ────────────────────────────────────────
  async function checkConnection() {
    if (!config.baseUrl || !config.apiKey) return { connected: false, reason: 'Não configurado' };

    try {
      if (config.provider === 'evolution') {
        const url = `${config.baseUrl}/instance/connectionState/${config.instanceId}`;
        const res = await fetch(url, { headers: buildHeaders() });
        if (!res.ok) return { connected: false, reason: `HTTP ${res.status}` };
        const data = await res.json();
        return {
          connected: data?.instance?.state === 'open',
          state:     data?.instance?.state,
          qrcode:    data?.qrcode,
        };
      }

      if (config.provider === 'zapi') {
        const url = `${config.baseUrl}/instances/${config.instanceId}/token/${config.zapiToken}/status`;
        const res = await fetch(url, { headers: buildHeaders() });
        if (!res.ok) return { connected: false, reason: `HTTP ${res.status}` };
        const data = await res.json();
        return { connected: data?.connected === true, state: data?.status };
      }
    } catch (err) {
      return { connected: false, reason: err.message };
    }
  }

  // ─── Painel de Configuração (UI) ───────────────────────────────────────────
  function injectStyles() {
    if (document.getElementById('wab-styles')) return;
    const s = document.createElement('style');
    s.id = 'wab-styles';
    s.textContent = `
      .wab-config { display:grid; grid-template-columns:1fr 1fr; gap:.75rem; margin-bottom:1rem; }
      @media(max-width:640px){ .wab-config { grid-template-columns:1fr; } }
      .wab-label { font-size:.62rem;letter-spacing:.12em;text-transform:uppercase;color:rgba(232,234,240,.4);display:block;margin-bottom:.3rem; }
      .wab-input {
        background:rgba(0,0,0,.35);border:1px solid rgba(0,240,255,.12);border-radius:7px;
        color:#E8EAF0;font-family:'Inter',sans-serif;font-size:.82rem;
        padding:.5rem .875rem;outline:none;width:100%;transition:border-color .2s;
      }
      .wab-input:focus { border-color:#00F0FF; }
      .wab-select {
        background:rgba(0,0,0,.35);border:1px solid rgba(0,240,255,.12);border-radius:7px;
        color:#E8EAF0;font-family:'Inter',sans-serif;font-size:.82rem;
        padding:.5rem .875rem;outline:none;width:100%;cursor:pointer;
      }
      .wab-status {
        display:inline-flex;align-items:center;gap:.5rem;
        font-size:.75rem;padding:.4rem .875rem;border-radius:6px;font-weight:600;
      }
      .wab-status--ok    { background:rgba(0,255,136,.1);border:1px solid rgba(0,255,136,.25);color:#00FF88; }
      .wab-status--fail  { background:rgba(255,68,68,.1);border:1px solid rgba(255,68,68,.25);color:#FF8080; }
      .wab-status--idle  { background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.1);color:rgba(232,234,240,.4); }
      .wab-btn {
        background:linear-gradient(135deg,#25D366,#128C7E);border:none;border-radius:8px;
        color:#fff;font-family:'Inter',sans-serif;font-size:.78rem;font-weight:700;
        letter-spacing:.1em;padding:.55rem 1.125rem;cursor:pointer;
        text-transform:uppercase;white-space:nowrap;transition:opacity .2s,transform .1s;
      }
      .wab-btn:hover { opacity:.87;transform:translateY(-1px); }
      .wab-btn:disabled { opacity:.35;cursor:not-allowed;transform:none; }
      .wab-btn--secondary {
        background:rgba(0,240,255,.08);border:1px solid rgba(0,240,255,.2);color:#00F0FF;
      }
      .wab-dispatch {
        display:grid;grid-template-columns:1fr 80px auto auto;gap:.625rem;align-items:end;
        margin-top:1rem;
      }
      @media(max-width:640px){ .wab-dispatch { grid-template-columns:1fr; } }
      .wab-log {
        background:rgba(0,0,0,.35);border:1px solid rgba(0,240,255,.08);border-radius:8px;
        font-family:'Courier New',monospace;font-size:.72rem;
        color:rgba(232,234,240,.5);padding:.875rem;
        max-height:120px;overflow-y:auto;margin-top:.875rem;
        line-height:1.6;
      }
      .wab-log span { display:block; }
      .wab-log .ok   { color:#00FF88; }
      .wab-log .err  { color:#FF8080; }
      .wab-log .info { color:#00F0FF; }
    `;
    document.head.appendChild(s);
  }

  function log(container, msg, type = 'info') {
    const ts = new Date().toLocaleTimeString('pt-PT');
    const span = document.createElement('span');
    span.className = type;
    span.textContent = `[${ts}] ${msg}`;
    container.appendChild(span);
    container.scrollTop = container.scrollHeight;
  }

  function renderSection() {
    const section = document.getElementById('section-whatsapp-bridge');
    if (!section) return;

    // Carregar config guardada em localStorage
    const saved = localStorage.getItem('vanguard_wab_config');
    if (saved) {
      try { config = { ...DEFAULT_CONFIG, ...JSON.parse(saved) }; configSaved = true; } catch (_) {}
    }

    section.innerHTML = `
      <p style="font-size:.82rem;color:rgba(232,234,240,.5);line-height:1.55;margin-bottom:1.25rem;">
        Envio directo via <strong style="color:#25D366;">WhatsApp Business API</strong> —
        integração com Evolution API (self-hosted) ou Z-API. Suporta texto, Trojan PNG e links HUD.
      </p>

      <!-- Configuração -->
      <details style="margin-bottom:1.125rem;" ${configSaved ? '' : 'open'}>
        <summary style="cursor:pointer;font-size:.72rem;letter-spacing:.14em;text-transform:uppercase;color:rgba(0,240,255,.6);user-select:none;">
          ⚙ Configuração do Provider
        </summary>
        <div style="margin-top:.875rem;">
          <div class="wab-config">
            <div>
              <label class="wab-label">Provider</label>
              <select class="wab-select" id="wab-provider">
                <option value="evolution" ${config.provider==='evolution'?'selected':''}>Evolution API (self-hosted · open-source)</option>
                <option value="zapi"      ${config.provider==='zapi'?'selected':''}>Z-API (SaaS · pago)</option>
              </select>
            </div>
            <div>
              <label class="wab-label">Base URL</label>
              <input class="wab-input" id="wab-url" type="text"
                placeholder="http://evolution.vanguardtech.io:8080"
                value="${config.baseUrl}" />
            </div>
            <div>
              <label class="wab-label">API Key / Token</label>
              <input class="wab-input" id="wab-key" type="password"
                placeholder="sua-api-key-aqui"
                value="${config.apiKey}" />
            </div>
            <div>
              <label class="wab-label">Instance ID / Nome</label>
              <input class="wab-input" id="wab-instance" type="text"
                placeholder="vanguard-hermes"
                value="${config.instanceId}" />
            </div>
          </div>
          <div style="display:flex;gap:.625rem;align-items:center;flex-wrap:wrap;margin-top:.625rem;">
            <button class="wab-btn wab-btn--secondary" id="wab-save">💾 Guardar Config</button>
            <button class="wab-btn wab-btn--secondary" id="wab-test-conn">🔌 Testar Conexão</button>
            <span class="wab-status wab-status--idle" id="wab-conn-status">● Não testado</span>
          </div>
        </div>
      </details>

      <!-- Disparo rápido -->
      <div>
        <p class="wab-label" style="margin-bottom:.75rem;">Disparo Rápido · Trojan Completo (PNG + Link HUD)</p>
        <div class="wab-dispatch">
          <div>
            <label class="wab-label">Número WhatsApp</label>
            <input class="wab-input" id="wab-phone" type="tel" placeholder="351910000000" />
          </div>
          <div>
            <label class="wab-label">Score</label>
            <input class="wab-input" id="wab-score-field" type="number" min="0" max="10" step="0.1" value="3.2" />
          </div>
          <div>
            <label class="wab-label">Domínio</label>
            <input class="wab-input" id="wab-domain-field" type="text" placeholder="clinica.pt" style="min-width:140px;" />
          </div>
          <div style="display:flex;flex-direction:column;gap:.375rem;">
            <label class="wab-label">&nbsp;</label>
            <button class="wab-btn" id="wab-dispatch-trojan">🚀 Disparar Trojan</button>
          </div>
        </div>
        <div class="wab-dispatch" style="margin-top:.625rem;">
          <div style="grid-column:1/-1;display:flex;gap:.625rem;flex-wrap:wrap;">
            <button class="wab-btn wab-btn--secondary" id="wab-send-text-only">💬 Só Texto + Link</button>
            <button class="wab-btn wab-btn--secondary" id="wab-send-png-only">🖼 Só PNG</button>
          </div>
        </div>
        <div class="wab-log" id="wab-log">
          <span class="info">[sistema] WhatsApp Bridge pronto. Configure o provider e teste a conexão.</span>
        </div>
      </div>
    `;

    const logEl = document.getElementById('wab-log');

    // Guardar configuração
    document.getElementById('wab-save').addEventListener('click', () => {
      config.provider   = document.getElementById('wab-provider').value;
      config.baseUrl    = document.getElementById('wab-url').value.trim().replace(/\/$/, '');
      config.apiKey     = document.getElementById('wab-key').value.trim();
      config.instanceId = document.getElementById('wab-instance').value.trim();
      localStorage.setItem('vanguard_wab_config', JSON.stringify(config));
      configSaved = true;
      log(logEl, 'Configuração guardada em localStorage.', 'ok');
    });

    // Testar conexão
    document.getElementById('wab-test-conn').addEventListener('click', async () => {
      const statusEl = document.getElementById('wab-conn-status');
      statusEl.className = 'wab-status wab-status--idle';
      statusEl.textContent = '● A testar...';
      log(logEl, `A testar conexão com ${config.provider} em ${config.baseUrl}...`, 'info');

      const result = await checkConnection();
      if (result.connected) {
        statusEl.className = 'wab-status wab-status--ok';
        statusEl.textContent = '● Conectado';
        log(logEl, `Conexão OK — estado: ${result.state}`, 'ok');
      } else {
        statusEl.className = 'wab-status wab-status--fail';
        statusEl.textContent = '● Falhou';
        log(logEl, `Erro: ${result.reason}`, 'err');
      }
    });

    // Helpers para obter campos
    function getPhone()  { return document.getElementById('wab-phone').value.trim(); }
    function getDomain() { return document.getElementById('wab-domain-field').value.trim() || 'exemplo.pt'; }
    function getScore()  { return Math.max(0, Math.min(10, parseFloat(document.getElementById('wab-score-field').value) || 3.2)); }

    // Disparo Trojan completo
    document.getElementById('wab-dispatch-trojan').addEventListener('click', async () => {
      const phone = getPhone();
      if (!phone) { log(logEl, 'Erro: número de telefone em falta.', 'err'); return; }

      const btn = document.getElementById('wab-dispatch-trojan');
      btn.disabled = true;
      log(logEl, `A disparar Trojan para ${phone} (${getDomain()}, score ${getScore()})...`, 'info');

      try {
        await dispatchTrojan(phone, getDomain(), getScore());
        log(logEl, `Trojan disparado com sucesso para ${phone}.`, 'ok');
      } catch (err) {
        log(logEl, `Erro: ${err.message}`, 'err');
      } finally {
        btn.disabled = false;
      }
    });

    // Só texto + link
    document.getElementById('wab-send-text-only').addEventListener('click', async () => {
      const phone = getPhone();
      if (!phone) { log(logEl, 'Erro: número em falta.', 'err'); return; }
      try {
        await sendHUDLink(phone, getDomain(), getScore());
        log(logEl, `Mensagem de texto enviada para ${phone}.`, 'ok');
      } catch (err) {
        log(logEl, `Erro: ${err.message}`, 'err');
      }
    });

    // Só PNG
    document.getElementById('wab-send-png-only').addEventListener('click', async () => {
      const phone = getPhone();
      if (!phone) { log(logEl, 'Erro: número em falta.', 'err'); return; }
      try {
        if (typeof window.TrojanGenerator === 'undefined') throw new Error('TrojanGenerator não carregado');
        const dataUrl = await window.TrojanGenerator.generatePNG(getDomain(), getScore());
        await sendImage(phone, dataUrl, `Auditoria Digital · ${getDomain()} · Score ${getScore()}/10`);
        log(logEl, `PNG enviado para ${phone}.`, 'ok');
      } catch (err) {
        log(logEl, `Erro: ${err.message}`, 'err');
      }
    });
  }

  function init(cfg = {}) {
    config = { ...DEFAULT_CONFIG, ...cfg };
    injectStyles();
    renderSection();
  }

  return { init, sendText, sendImage, sendHUDLink, dispatchTrojan, checkConnection };

})();
