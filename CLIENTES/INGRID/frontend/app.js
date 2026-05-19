// app.js — Sedes-DF 2026 — PROJ-002 Ingrid
// Loop 3 · Dias 6-8: Clickwrap + Tutor Socrático + Telemetria TTI + Fallback

// ── CONFIG ────────────────────────────────────────────────────────────────────
const SUPABASE_URL      = "https://ehyaecxqijgyuuiorzcj.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVoeWFlY3hxaWpneXV1aW9yemNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgyODMzNTAsImV4cCI6MjA5Mzg1OTM1MH0.xZfcEe2Av5Fn9BKEkNRIi5CQkPD6C6ADSNzMfh3DGPo";
const USER_ID           = "00000000-0000-0000-0000-000000000001";
const VERSAO_TERMO      = "1.0";
const COTA_DIARIA_USD   = 5.00;
const KILL_SWITCH_PCT   = 0.70;
const ADMIN_TOKEN_CONF  = "vg-admin-2026-ingrid"; // substituir antes do deploy

// Admin override: ?admin=<token>
const _params   = new URLSearchParams(location.search);
const ADMIN_MODE = _params.get("admin") === ADMIN_TOKEN_CONF && ADMIN_TOKEN_CONF !== "vg-admin-2026-ingrid";

// ── NOMES LEGÍVEIS DAS DISCIPLINAS ────────────────────────────────────────────
const NOMES_DISCIPLINAS = {
  suas_fundamentos:                "SUAS",
  programas_beneficios_df:         "Programas DF",
  direito_administrativo:          "Dir. Administrativo",
  direito_constitucional:          "Dir. Constitucional",
  arquivologia_rotinas_atendimento:"Arquivologia",
  recursos_materiais_patrimonio:   "Recursos Materiais",
  portugues:                       "Português",
  realidade_df_ride:               "Realidade DF/RIDE",
  lei_organica_df:                 "Lei Orgânica DF",
  lc840:                           "LC 840 — Servidores",
  maria_da_penha:                  "Lei Maria da Penha",
  politica_mulheres:               "Política para Mulheres",
  primeiros_socorros:              "Primeiros Socorros",
};

// ── ESTADO ────────────────────────────────────────────────────────────────────
let feed                = [];
let indiceAtual         = 0;
let pontosAcumulados    = 0;
let acertos             = 0;
let revisoesPendentes   = 0;
let questaoStartedAt    = 0;
let timerAbandono       = null;
let tapCount            = 0;
let tapTimer            = null;
let gastoEstimado       = 0;
let killSwitchAtivado   = false;
let totalRespostasGlobal = 0;
let ultimoCacheStatus   = "—";
const errosPorQuestao   = {};

// ── INIT ──────────────────────────────────────────────────────────────────────
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("sw.js").catch(() => {});
}

document.addEventListener("DOMContentLoaded", iniciar);

async function iniciar() {
  configurarLogoDeTap();
  configurarStaleSession();

  const aceitou = await verificarClickwrap();
  if (!aceitou) return;

  await carregarFeedEIniciar();
}

// ── CLICKWRAP (P-023) — Dia 6 ─────────────────────────────────────────────────
async function verificarClickwrap() {
  try {
    const res = await fetch(
      `${SUPABASE_URL}/rest/v1/termos_aceitos?user_id=eq.${USER_ID}&limit=1&select=id`,
      { headers: headers() }
    );
    const rows = await res.json();
    if (rows.length > 0) return true;
  } catch (_) {}

  renderizarClickwrap();
  return false;
}

function renderizarClickwrap() {
  const tpl = document.getElementById("tpl-clickwrap").content.cloneNode(true);
  trocarMain(tpl);

  document.getElementById("btn-aceitar-termo").addEventListener("click", async () => {
    const btn = document.getElementById("btn-aceitar-termo");
    btn.disabled = true;
    btn.textContent = "Registrando…";

    const ok = await registrarAceite();
    if (ok) {
      await carregarFeedEIniciar();
    } else {
      btn.disabled = false;
      btn.textContent = "Aceito os Termos — Iniciar";
    }
  });
}

async function registrarAceite() {
  const agora = new Date().toISOString();
  const hash  = await sha256(`${VERSAO_TERMO}|${agora}|${USER_ID}`);

  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/termos_aceitos`, {
      method: "POST",
      headers: { ...headers(), "Content-Type": "application/json", Prefer: "return=minimal" },
      body: JSON.stringify({ user_id: USER_ID, accepted_at: agora, versao_termo: VERSAO_TERMO, hash_sha256: hash }),
    });
    return res.status === 201;
  } catch (_) {
    return false;
  }
}

async function sha256(msg) {
  const buf  = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(msg));
  return Array.from(new Uint8Array(buf)).map((b) => b.toString(16).padStart(2, "0")).join("");
}

// ── CARREGAR FEED E INICIAR ───────────────────────────────────────────────────
async function carregarFeedEIniciar() {
  trocarMain('<div class="estado-vazio"><div class="spinner"></div><p>Carregando seu feed do dia…</p></div>');

  try {
    const [dadosFeed, total] = await Promise.all([
      buscarFeed(),
      buscarTotalRespostas(),
    ]);

    totalRespostasGlobal = total;
    feed = dadosFeed.feed ?? [];

    if (feed.length === 0) { mostrarVazio(); return; }

    const ultimoErro = total > 0 ? await buscarUltimoErro() : null;
    renderizarFraseAbertura(total, ultimoErro);

    // Pequena pausa para a frase ser lida, depois carrega primeira questão
    setTimeout(() => renderizarQuestao(0), 1800);
  } catch (err) {
    mostrarErro(err.message);
  }
}

async function buscarFeed() {
  const res = await fetch(`${SUPABASE_URL}/functions/v1/feed-diario`, {
    method: "POST",
    headers: { Authorization: `Bearer ${SUPABASE_ANON_KEY}`, "Content-Type": "application/json" },
    body: JSON.stringify({ user_id: USER_ID }),
  });
  if (!res.ok) throw new Error(`Feed: ${res.status}`);
  return res.json();
}

async function buscarTotalRespostas() {
  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/get_total_respostas_ingrid`, {
      method: "POST",
      headers: { ...headers(), "Content-Type": "application/json" },
      body: JSON.stringify({ p_user_id: USER_ID }),
    });
    if (!res.ok) return 0;
    const val = await res.json();
    return typeof val === "number" ? val : 0;
  } catch (_) {
    return 0;
  }
}

async function buscarUltimoErro() {
  try {
    const res = await fetch(
      `${SUPABASE_URL}/rest/v1/progresso_usuario?user_id=eq.${USER_ID}&correta=eq.false&order=respondida_em.desc&limit=1&select=disciplina_id`,
      { headers: headers() }
    );
    const rows = await res.json();
    return rows.length > 0 ? rows[0].disciplina_id : null;
  } catch (_) {
    return null;
  }
}

// ── FRASE DE ABERTURA (E-2) — Dia 6 ──────────────────────────────────────────
function renderizarFraseAbertura(total, ultimoErroDisciplinaId) {
  let texto;
  if (total === 0 || !ultimoErroDisciplinaId) {
    texto = "Hoje começamos pelo Peso 2 — Direito Administrativo cai mais que qualquer outra.";
  } else {
    const nome = NOMES_DISCIPLINAS[ultimoErroDisciplinaId] ?? ultimoErroDisciplinaId;
    texto = `Hoje atacamos o que travou você ontem: ${nome}.`;
  }

  const tpl = document.getElementById("tpl-frase-abertura").content.cloneNode(true);
  tpl.querySelector(".frase-texto").textContent = texto;
  trocarMain(tpl);
}

// ── RENDERIZAR QUESTÃO ────────────────────────────────────────────────────────
function renderizarQuestao(indice) {
  indiceAtual      = indice;
  questaoStartedAt = Date.now();
  const q          = feed[indice];

  clearTimeout(timerAbandono);
  timerAbandono = setTimeout(() => registrarAbandono(q), 2 * 60 * 1000);

  document.getElementById("progresso-header").textContent = `${indice + 1} / ${feed.length}`;

  const tpl  = document.getElementById("tpl-questao").content.cloneNode(true);
  const card = tpl.querySelector(".questao-card");

  const nomeDisc = NOMES_DISCIPLINAS[q.disciplina_id] ?? q.disciplina_id;
  const badgeDisc = card.querySelector(".badge-disciplina");
  badgeDisc.textContent = nomeDisc;
  badgeDisc.className   = q.peso_edital === 2 ? "badge-peso2" : "badge-peso1";

  const badgeTipo = card.querySelector(".badge-tipo");
  if (q.revisao) {
    badgeTipo.textContent = "🔁 Revisão";
    badgeTipo.className   = "badge-revisao";
  } else {
    badgeTipo.textContent = `Peso ${q.peso_edital}`;
    badgeTipo.className   = q.peso_edital === 2 ? "badge-peso2" : "badge-peso1";
  }

  card.querySelector(".questao-numero").textContent = `${indice + 1}/${feed.length}`;
  card.querySelector(".barra-fill").style.width     = `${((indice + 1) / feed.length) * 100}%`;
  card.querySelector(".questao-enunciado").textContent = q.enunciado;

  const contAlts = card.querySelector(".alternativas");
  (q.alternativas ?? []).forEach((alt) => {
    const tplAlt = document.getElementById("tpl-alternativa").content.cloneNode(true);
    const btn    = tplAlt.querySelector(".alternativa");
    btn.querySelector(".letra").textContent = alt.letra + ".";
    btn.querySelector(".texto").textContent = alt.texto;
    btn.dataset.letra   = alt.letra;
    btn.addEventListener("click", () => processarResposta(q, alt.letra, card));
    contAlts.appendChild(btn);
  });

  trocarMain(card);
  atualizarDebug(q, "—");
}

// ── PROCESSAR RESPOSTA — Dia 7 ────────────────────────────────────────────────
async function processarResposta(questao, letraEscolhida, card) {
  // Debounce: desabilita todos os botões imediatamente (N-3)
  card.querySelectorAll(".alternativa").forEach((btn) => { btn.disabled = true; });
  clearTimeout(timerAbandono);

  const tti    = Date.now() - questaoStartedAt;
  const correta = questao.gabarito;
  const acertou = letraEscolhida === correta;
  const chute   = acertou && tti < 10000; // TTI < 10s + acerto = possível chute

  // Colorir alternativas
  card.querySelectorAll(".alternativa").forEach((btn) => {
    if (btn.dataset.letra === correta)                       btn.classList.add("correta");
    else if (btn.dataset.letra === letraEscolhida && !acertou) btn.classList.add("errada");
  });

  // Pontos ponderados: Peso 2 = 2pts, Peso 1 = 1pt
  if (acertou) {
    acertos++;
    pontosAcumulados += questao.peso_edital;
    document.getElementById("pontos-valor").textContent = pontosAcumulados;
  } else {
    revisoesPendentes++;
  }

  const nivelTutor = determinarNivelTutor(questao.id, acertou, tti);

  // Exibir bloco de explicação com fallback imediato
  const tplExp = document.getElementById("tpl-explicacao").content.cloneNode(true);
  const expDiv = tplExp.querySelector(".explicacao");
  expDiv.classList.add(acertou ? "acerto" : "erro");
  expDiv.querySelector(".icone-resultado").textContent  = acertou ? "✅" : "❌";
  expDiv.querySelector(".texto-resultado").textContent  = acertou
    ? `Correto! Gabarito: ${correta}`
    : `Errado. Gabarito: ${correta}`;

  const bodyDiv  = expDiv.querySelector(".explicacao-body");
  const nivelDiv = expDiv.querySelector(".explicacao-nivel");

  // Fallback imediato: explicacao_base da questão
  bodyDiv.textContent = questao.explicacao ?? "";
  card.appendChild(expDiv);

  // Tutor e save em paralelo
  const [tutorData] = await Promise.all([
    buscarTutor(questao, letraEscolhida, nivelTutor, acertou),
    salvarProgresso(questao, letraEscolhida, acertou, tti, chute, nivelTutor),
  ]);

  // Atualiza com explicação do Tutor se veio algo melhor
  if (tutorData.explicacao && tutorData.explicacao !== questao.explicacao) {
    bodyDiv.textContent = tutorData.explicacao;
  }

  if (!acertou && tutorData.cacheHit !== null) {
    nivelDiv.textContent = `Nível ${nivelTutor} · ${tutorData.cacheHit ? "cache ✓" : "API"}`;
    ultimoCacheStatus    = tutorData.cacheHit ? "cache HIT" : "cache MISS";
  }

  atualizarDebug(questao, ultimoCacheStatus, tutorData.custoEstimado);

  // Botão próxima
  const tplBtn = document.getElementById("tpl-btn-proxima").content.cloneNode(true);
  const btn    = tplBtn.querySelector(".btn-proxima");
  const ultima = indiceAtual === feed.length - 1;
  if (ultima) btn.textContent = "Ver resultado →";

  btn.addEventListener("click", () => {
    if (ultima) mostrarFim();
    else renderizarQuestao(indiceAtual + 1);
  });
  card.appendChild(btn);
}

// ── NÍVEL DO TUTOR — Dia 7 ────────────────────────────────────────────────────
function determinarNivelTutor(questaoId, acertou, tti) {
  if (acertou) return 0;

  if (!errosPorQuestao[questaoId]) errosPorQuestao[questaoId] = 0;
  errosPorQuestao[questaoId]++;
  return Math.min(errosPorQuestao[questaoId], 3);
}

// ── TUTOR SOCRÁTICO — cache-first (Dia 7) ─────────────────────────────────────
// Degradação graciosa: Edge Function → cache → explicacao_base → nunca tela branca
async function buscarTutor(questao, letraEscolhida, nivel, acertou) {
  if (acertou || nivel === 0) {
    return { explicacao: questao.explicacao, cacheHit: null, custoEstimado: 0 };
  }

  // Kill-switch: 70% da cota diária
  if (killSwitchAtivado) {
    return { explicacao: questao.explicacao, cacheHit: false, custoEstimado: 0 };
  }

  const distratorCache = nivel === 2 ? (letraEscolhida ?? "") : "";

  // 1. Checar cache no Supabase
  if (!ADMIN_MODE) {
    try {
      const cacheRes = await fetch(
        `${SUPABASE_URL}/rest/v1/explicacao_tutor?questao_id=eq.${questao.id}&nivel=eq.${nivel}&distrator=eq.${encodeURIComponent(distratorCache)}&limit=1&select=explicacao`,
        { headers: headers() }
      );
      const cache = await cacheRes.json();
      if (cache.length > 0) {
        return { explicacao: cache[0].explicacao, cacheHit: true, custoEstimado: 0 };
      }
    } catch (_) {}
  }

  // 2. Chamar Edge Function tutor-socratico
  try {
    const res = await fetch(`${SUPABASE_URL}/functions/v1/tutor-socratico`, {
      method: "POST",
      headers: { Authorization: `Bearer ${SUPABASE_ANON_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        user_id:    USER_ID,
        questao_id: questao.id,
        enunciado:  questao.enunciado,
        gabarito:   questao.gabarito,
        distrator:  letraEscolhida ?? "",
        disciplina: questao.disciplina_id,
        nivel,
        force_refresh: ADMIN_MODE,
      }),
    });

    if (!res.ok) throw new Error(res.status);
    const dados = await res.json();

    // Custo estimado: Haiku ~280 tokens output
    const custo = (280 / 1_000_000) * 0.25;
    gastoEstimado += custo;

    if (gastoEstimado >= COTA_DIARIA_USD * KILL_SWITCH_PCT) {
      killSwitchAtivado = true;
    }

    return { explicacao: dados.explicacao, cacheHit: false, custoEstimado: custo };
  } catch (_) {
    // Fallback final: explicacao_base
    return { explicacao: questao.explicacao, cacheHit: false, custoEstimado: 0 };
  }
}

// ── SALVAR PROGRESSO (SM-2 + Telemetria) — Dia 7 ─────────────────────────────
async function salvarProgresso(questao, resposta, acertou, tti, chute, nivelTutor) {
  const hoje          = new Date();
  const diasRevisao   = acertou ? 7 : 2;
  const proximaRev    = new Date(hoje.getTime() + diasRevisao * 86400000).toISOString().split("T")[0];

  await fetch(`${SUPABASE_URL}/rest/v1/progresso_usuario`, {
    method: "POST",
    headers: { ...headers(), "Content-Type": "application/json", Prefer: "return=minimal" },
    body: JSON.stringify({
      user_id:                USER_ID,
      questao_id:             questao.id,
      disciplina_id:          questao.disciplina_id,
      resposta_usuario:       resposta,
      correta:                acertou,
      proxima_revisao_em:     proximaRev,
      respondida_em:          new Date().toISOString(),
      tempo_resposta_ms:      tti,
      distrator_escolhido:    acertou ? null : resposta,
      nivel_tutor_disparado:  nivelTutor,
      acerto_provavel_chute:  chute,
    }),
  }).catch(() => {});

  totalRespostasGlobal++;
}

// ── FIM DE SESSÃO + FRASE E-5 — Dia 6 ────────────────────────────────────────
async function mostrarFim() {
  const tpl = document.getElementById("tpl-fim").content.cloneNode(true);
  const pct = feed.length > 0 ? Math.round((acertos / feed.length) * 100) : 0;

  tpl.getElementById("stat-acertos").textContent  = `${acertos}/${feed.length}`;
  tpl.getElementById("stat-pontos").textContent    = pontosAcumulados;
  tpl.getElementById("stat-pct").textContent       = `${pct}%`;
  tpl.getElementById("stat-revisoes").textContent  = revisoesPendentes;

  // E-5: só exibir se total >= 10 (RPC definitivo)
  const total = await buscarTotalRespostas();
  if (total >= 10) {
    const fraseEl = tpl.getElementById("frase-encerramento");
    fraseEl.style.display = "block";
    fraseEl.textContent   = `${feed.length} questões hoje. ${total} no total. Continua.`;
  }

  const main = document.getElementById("main-content");
  main.innerHTML = "";
  main.appendChild(tpl);
  document.getElementById("progresso-header").textContent = "Concluído";
  document.getElementById("btn-fechar")?.addEventListener("click", () => location.reload());
}

// ── STALE SESSION (N-4) — Dia 8 ──────────────────────────────────────────────
function configurarStaleSession() {
  let hiddenEm = 0;

  document.addEventListener("visibilitychange", () => {
    if (document.hidden) {
      hiddenEm = Date.now();
    } else if (hiddenEm > 0 && Date.now() - hiddenEm > 4 * 60 * 60 * 1000) {
      window.location.reload();
    }
  });
}

// ── BEACON ABANDONO (N-5) — Dia 8 ────────────────────────────────────────────
function registrarAbandono(questao) {
  // fetch com keepalive suporta headers — equivalente funcional ao sendBeacon
  fetch(`${SUPABASE_URL}/rest/v1/abandonment_log`, {
    method: "POST",
    keepalive: true,
    headers: { ...headers(), "Content-Type": "application/json", Prefer: "return=minimal" },
    body: JSON.stringify({
      user_id:     USER_ID,
      questao_id:  questao.id,
      viewed_at:   new Date(questaoStartedAt).toISOString(),
      abandoned_at: new Date().toISOString(),
    }),
  }).catch(() => {});
}

// ── DEBUG MODE — 5 toques no logo (M'-3) ─────────────────────────────────────
function configurarLogoDeTap() {
  const logo = document.getElementById("logo-tap");
  if (!logo) return;

  logo.addEventListener("click", () => {
    tapCount++;
    clearTimeout(tapTimer);
    tapTimer = setTimeout(() => { tapCount = 0; }, 2000);
    if (tapCount >= 5) { tapCount = 0; toggleDebug(); }
  });
}

function toggleDebug() {
  const panel = document.getElementById("debug-panel");
  if (panel) panel.style.display = panel.style.display === "none" ? "block" : "none";
}

function atualizarDebug(questao, cacheStatus, custo) {
  const el = document.getElementById("debug-content");
  if (!el) return;

  ultimoCacheStatus = cacheStatus ?? ultimoCacheStatus;
  el.innerHTML = [
    `ID: <b>${questao?.id ?? "—"}</b>`,
    `Disciplina: ${questao?.disciplina_id ?? "—"}`,
    `Peso SM-2: ${questao?.peso_edital ?? "—"}`,
    `Cache: ${ultimoCacheStatus}`,
    `Gasto est.: $${gastoEstimado.toFixed(4)} / $${(COTA_DIARIA_USD * KILL_SWITCH_PCT).toFixed(2)}`,
    `Kill-switch: ${killSwitchAtivado ? "<b style='color:var(--red)'>ATIVO</b>" : "off"}`,
    `Total respostas: ${totalRespostasGlobal}`,
    ADMIN_MODE ? `<b style='color:var(--yellow)'>ADMIN MODE</b>` : "",
  ].filter(Boolean).map((l) => `<div>${l}</div>`).join("");
}

// ── HELPERS ───────────────────────────────────────────────────────────────────
function headers() {
  return { apikey: SUPABASE_ANON_KEY, Authorization: `Bearer ${SUPABASE_ANON_KEY}` };
}

function trocarMain(conteudo) {
  const main = document.getElementById("main-content");
  main.innerHTML = "";
  if (typeof conteudo === "string") {
    main.innerHTML = conteudo;
  } else {
    main.appendChild(conteudo);
  }
}

function mostrarVazio() {
  trocarMain(`
    <div class="estado-vazio">
      <div class="icon">🎉</div>
      <h2>Feed do dia concluído!</h2>
      <p>Você respondeu todas as questões de hoje.<br>
         Volte amanhã — o SM-2 já agendou suas revisões.</p>
    </div>`);
}

function mostrarErro(msg) {
  trocarMain(`
    <div class="estado-vazio">
      <div class="icon">⚠️</div>
      <h2>Erro ao carregar</h2>
      <p>${msg}</p>
      <button class="btn-novo-dia" onclick="location.reload()">Tentar novamente</button>
    </div>`);
}

