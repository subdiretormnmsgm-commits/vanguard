// app.js — Sedes-DF 2026 — PROJ-002 Ingrid
// Loop 5 · Dia 12 fix: G-5 lógica corrigida (errosConsecutivos precede ultima) · debug panel expandido

// ── UTILS ─────────────────────────────────────────────────────────────────────
// Converte **texto** para <strong>texto</strong> com escape seguro de HTML
function md2html(text) {
  if (!text) return "";
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>");
}

// ── CONFIG ────────────────────────────────────────────────────────────────────
const SUPABASE_URL      = "https://yjqvjhezwhepwomukudt.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlqcXZqaGV6d2hlcHdvbXVrdWR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3NjExNzksImV4cCI6MjA5NTMzNzE3OX0.Mb6KxtJ3iECl_3ApWUl6zozxa93pJatLwNOZ7zAdhx4";
const USER_ID           = "00000000-0000-0000-0000-000000000001";
const VERSAO_TERMO      = "termo_v2_18_05"; // Clickwrap V2 — data real de assinatura 18/05
const COTA_DIARIA_USD   = 5.00;
const KILL_SWITCH_PCT   = 0.70;
const ADMIN_TOKEN_CONF  = "vg-admin-2026-ingrid"; // substituir antes do deploy
const LINHA_CORTE_DEFAULT = 67;   // N-3 — Eduardo ajusta no Dashboard (3 toques no logo)

// Distribuição real do edital Sedes-DF 2026 (questoes × peso = 100 pts máx)
const EDITAL_DIST = {
  portugues:               { questoes: 7,  peso: 1 },
  realidade_df_ride:       { questoes: 4,  peso: 1 },
  lei_organica_df:         { questoes: 3,  peso: 1 },
  lc840:                   { questoes: 3,  peso: 1 },
  maria_da_penha:          { questoes: 1,  peso: 1 },
  politica_mulheres:       { questoes: 1,  peso: 1 },
  primeiros_socorros:      { questoes: 1,  peso: 1 },
  suas_fundamentos:        { questoes: 12, peso: 2 },
  programas_beneficios_df: { questoes: 8,  peso: 2 },
  direito_administrativo:  { questoes: 8,  peso: 2 },
  arquivologia:            { questoes: 6,  peso: 2 },
  direito_constitucional:  { questoes: 3,  peso: 2 },
  recursos_materiais:      { questoes: 3,  peso: 2 },
};
const INGRID_WHATSAPP     = "";   // N-1 — preencher: "55619..." (usado no push Mágico de Oz)

// Admin override: ?admin=<token>
const _params   = new URLSearchParams(location.search);
const ADMIN_MODE = _params.get("admin") === ADMIN_TOKEN_CONF && ADMIN_TOKEN_CONF !== "vg-admin-2026-ingrid";

// ── G-3: VACINA LEGISLAÇÃO — disciplinas que Quadrix sempre cai ───────────────
const VACINA_DISCIPLINAS = new Set(['lc840', 'maria_da_penha', 'politica_mulheres', 'lei_organica_df']);

// ── G-1: PUSH CIRCUIT BREAKER — detecta iOS Safari (sem suporte a Web Push) ──
function isIosSafari() {
  return /iP(hone|od|ad)/.test(navigator.userAgent)
    && /WebKit/.test(navigator.userAgent)
    && !window.MSStream;
}
const PUSH_SUPORTADO = 'Notification' in window && 'serviceWorker' in navigator && !isIosSafari();

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
let feed                  = [];
let indiceAtual           = 0;
let pontosAcumulados      = 0;
let acertos               = 0;
let revisoesPendentes     = 0;
let questaoStartedAt      = 0;
let timerAbandono         = null;
let tapCount              = 0;
let tapTimer              = null;
let gastoEstimado         = 0;
let killSwitchAtivado     = false;
let totalRespostasGlobal  = 0;
let ultimoCacheStatus     = "—";
let acertosConsecutivos        = 0;    // E-3: streak de acertos consecutivos
let errosConsecutivos          = 0;    // G-5: Socrática Pânico após 3 erros seguidos
let sessaoId                   = null; // rastreia sessao atual em sessoes_usuario
const errosPorQuestao          = {};
let simuladoErrosPorDisciplina = {};   // G-5: disciplina mais errática no simulado

// ── MICRO-SIMULADO — Dia 11 ───────────────────────────────────────────────────
const SIMULADO_TOTAL     = 10;
const SIMULADO_TEMPO_SEG = 90; // segundos por questão

let simuladoQuestoes = [];
let simuladoIndice   = 0;
let simuladoAcertos  = 0;
let simuladoTempos   = []; // ms por questão
let simuladoTimer    = null;
let simuladoInicioQ  = 0;

// ── INIT ──────────────────────────────────────────────────────────────────────
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("sw.js").catch(() => {});
}

document.addEventListener("DOMContentLoaded", iniciar);

// Pontos acumulados de sessões anteriores (carregados do DB no init)
let pontosBase = 0;

async function iniciar() {
  configurarLogoDeTap();
  configurarStaleSession();

  const aceitou = await verificarClickwrap();
  if (!aceitou) return;

  // Dia 13: Widget Contador — carregar pontos cumulativos do DB antes de exibir feed
  calcularPontosCumulativos().then(dados => {
    if (dados && dados.pontos_total > 0) {
      pontosBase = dados.pontos_total;
      document.getElementById("pontos-valor").textContent = pontosBase;
    }
  });

  // Dia 13: Lembrete dominical
  verificarDominical();

  iniciarSessao(); // fire-and-forget — não bloqueia o feed
  await carregarFeedEIniciar();
}

// ── CLICKWRAP (P-023) — Dia 6 ─────────────────────────────────────────────────
async function verificarClickwrap() {
  try {
    const res = await fetch(
      `${SUPABASE_URL}/rest/v1/termos_aceitos?user_id=eq.${USER_ID}&versao_termo=eq.${VERSAO_TERMO}&limit=1&select=id`,
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

  // G-3: Vacina Legislação — badge para disciplinas que Quadrix sempre cai
  if (VACINA_DISCIPLINAS.has(q.disciplina_id)) {
    const vacinaEl = document.createElement("span");
    vacinaEl.className   = "badge-vacina";
    vacinaEl.textContent = "⚡ Cai sempre";
    card.querySelector(".questao-meta").appendChild(vacinaEl);
  }

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
  card.querySelector(".questao-enunciado").innerHTML = md2html(q.enunciado);

  const contAlts = card.querySelector(".alternativas");
  (q.alternativas ?? []).forEach((alt) => {
    const tplAlt = document.getElementById("tpl-alternativa").content.cloneNode(true);
    const btn    = tplAlt.querySelector(".alternativa");
    btn.querySelector(".letra").textContent = alt.letra + ".";
    btn.querySelector(".texto").innerHTML = md2html(alt.texto);
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
    acertosConsecutivos++;
    errosConsecutivos = 0;
    pontosAcumulados += questao.peso_edital;
    document.getElementById("pontos-valor").textContent = pontosBase + pontosAcumulados;
  } else {
    acertosConsecutivos = 0;
    errosConsecutivos++;
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
  bodyDiv.innerHTML = md2html(questao.explicacao ?? "");

  // E-3: streak badge após 3+ acertos consecutivos
  if (acertou && acertosConsecutivos >= 3) {
    const streakEl = document.createElement("div");
    streakEl.className   = "streak-badge";
    streakEl.textContent = `Você acertou as últimas ${acertosConsecutivos} — esse é seu ritmo.`;
    expDiv.appendChild(streakEl);
  }

  card.appendChild(expDiv);

  // Tutor e save em paralelo
  const [tutorData] = await Promise.all([
    buscarTutor(questao, letraEscolhida, nivelTutor, acertou),
    salvarProgresso(questao, letraEscolhida, acertou, tti, chute, nivelTutor),
  ]);

  // Atualiza com explicação do Tutor se veio algo melhor
  if (tutorData.explicacao && tutorData.explicacao !== questao.explicacao) {
    bodyDiv.innerHTML = md2html(tutorData.explicacao);
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
    if (errosConsecutivos >= 3) {
      // G-5: Socrática Pânico — 3 erros seguidos (verifica antes de ultima para não perder o trigger)
      ativarSocraticaPanico("feed");
    } else if (ultima) {
      mostrarFim();
    } else {
      renderizarQuestao(indiceAtual + 1);
    }
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
  encerrarSessao(); // fire-and-forget

  // Busca dados em paralelo — RPC de pontos ponderados + total de respostas
  const [total, dadosPontos] = await Promise.all([
    buscarTotalRespostas(),
    calcularPontosCumulativos(),
  ]);

  const tpl = document.getElementById("tpl-fim").content.cloneNode(true);
  const pct = feed.length > 0 ? Math.round((acertos / feed.length) * 100) : 0;

  tpl.getElementById("stat-acertos").textContent  = `${acertos}/${feed.length}`;
  tpl.getElementById("stat-pct").textContent       = `${pct}%`;
  tpl.getElementById("stat-revisoes").textContent  = revisoesPendentes;

  // [E-1]: Contador com linguagem de posse + delta semanal (não "sua nota", mas "território conquistado")
  const pontosEl = tpl.getElementById("stat-pontos");
  if (dadosPontos && dadosPontos.pontos_total > 0) {
    pontosEl.textContent = dadosPontos.pontos_total;
    const delta = dadosPontos.pontos_esta_semana - dadosPontos.pontos_semana_passada;
    const descEl = pontosEl.nextElementSibling;
    if (descEl) {
      descEl.textContent = delta > 0
        ? `+${delta} pts esta semana`
        : "pontos conquistados";
    }
  } else {
    pontosEl.textContent = pontosAcumulados;
  }

  // E-5: só exibir se total >= 10 (RPC definitivo)
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

  // Botão Micro-Simulado — inserido antes do "Fechar"
  const btnSim = document.createElement("button");
  btnSim.className   = "btn-simulado";
  btnSim.textContent = "⏱ Simular 10 questões";
  btnSim.addEventListener("click", iniciarMicroSimulado);
  document.getElementById("btn-fechar")?.before(btnSim);

  // N-3: Linha de Corte — barra de progresso vs meta configurada no Dashboard
  const metaPts  = carregarLinhaCorte();
  const ptsTotal = dadosPontos && dadosPontos.pontos_total > 0 ? dadosPontos.pontos_total : pontosAcumulados;
  inserirMetaBarra(main, ptsTotal, metaPts);

  // N-5: Exportar card de progresso como PNG
  const btnExport = document.createElement("button");
  btnExport.className   = "btn-simulado";
  btnExport.style.marginTop = "0";
  btnExport.textContent = "📱 Salvar progresso";
  btnExport.addEventListener("click", exportarCardProgresso);
  document.getElementById("btn-fechar")?.before(btnExport);

  // Dia 10: Mapa de Soberania — busca e exibe automaticamente após sessão
  buscarEExibirMapa(main);
}

// ── MAPA DE SOBERANIA — Dia 10 ────────────────────────────────────────────────
async function buscarEExibirMapa(container) {
  let dados;
  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/get_heatmap_disciplinas`, {
      method: "POST",
      headers: { ...headers(), "Content-Type": "application/json" },
      body: JSON.stringify({ p_user_id: USER_ID }),
    });
    if (!res.ok) return;
    dados = await res.json();
  } catch (_) { return; }

  if (!dados || dados.length === 0) return;

  // Notifica Eduardo com os dados da sessão (M-2)
  notificarEduardo(dados);

  const tpl  = document.getElementById("tpl-mapa-soberania").content.cloneNode(true);
  const lista = tpl.getElementById("mapa-lista");

  dados.forEach((d) => {
    const item = document.getElementById("tpl-mapa-item").content.cloneNode(true);
    const nome = NOMES_DISCIPLINAS[d.disciplina_id] ?? d.disciplina_id;

    item.querySelector(".mapa-disc-nome").textContent = nome;

    const badge = item.querySelector(".mapa-nivel-badge");
    badge.textContent  = d.nivel;
    badge.classList.add(d.nivel);

    const urgenciaCls = d.urgencia >= 0.65 ? "alta" : d.urgencia >= 0.35 ? "media" : "baixa";
    const fill = item.querySelector(".mapa-barra-fill");
    fill.classList.add(urgenciaCls);
    fill.style.width = `${Math.round(d.urgencia * 100)}%`;

    item.querySelector(".mapa-taxa").textContent      = `${d.taxa_acerto_pct}% acerto`;
    item.querySelector(".mapa-atividade").textContent =
      d.dias_sem_atividade === 0 ? "estudada hoje"
      : d.dias_sem_atividade === 1 ? "ontem"
      : `${d.dias_sem_atividade}d atrás`;
    item.querySelector(".mapa-revisoes").textContent  =
      d.revisoes_pendentes > 0 ? `${d.revisoes_pendentes} revisões pendentes` : "";

    lista.appendChild(item);
  });

  // Substitui a tela de fim pelo mapa ao clicar
  const btnMapa = document.createElement("button");
  btnMapa.className   = "btn-proxima";
  btnMapa.style.margin = "16px 0 0";
  btnMapa.textContent = "Ver Mapa de Soberania →";
  btnMapa.addEventListener("click", () => {
    trocarMain(tpl);
    document.getElementById("btn-fechar-mapa")
      ?.addEventListener("click", () => location.reload());
  });
  container.appendChild(btnMapa);
}

// ── NOTIFICAR EDUARDO — M-2 ────────────────────────────────────────────────────
// Envia resumo da sessão para Edge Function que dispara mensagem ao Eduardo
async function notificarEduardo(heatmap) {
  try {
    const progresso = await fetch(`${SUPABASE_URL}/rest/v1/rpc/get_progresso_semanal`, {
      method: "POST",
      headers: { ...headers(), "Content-Type": "application/json" },
      body: JSON.stringify({ p_user_id: USER_ID }),
    }).then((r) => r.ok ? r.json() : null).catch(() => null);

    // dia_build: dias desde 15/05 (início do projeto), capped em 1-15
    const diaAtual = Math.min(Math.max(
      Math.ceil((Date.now() - new Date("2026-05-15T00:00:00-03:00").getTime()) / 86_400_000),
      1), 15);

    await fetch(`${SUPABASE_URL}/functions/v1/notificar-progresso`, {
      method: "POST",
      headers: { Authorization: `Bearer ${SUPABASE_ANON_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        user_id:           USER_ID,
        sessao_hoje:       { acertos, total: feed.length, pontos: pontosAcumulados },
        progresso_semanal: progresso,
        heatmap_top3:      heatmap.slice(0, 3),
        dia_build:         diaAtual,
      }),
    });
  } catch (_) { /* silencioso — não bloqueia o fluxo */ }
}

// ── STALE SESSION (N-4) — Dia 8 ──────────────────────────────────────────────
// ── DIA 13: LEMBRETE DOMINICAL ────────────────────────────────────────────────
function verificarDominical() {
  const hoje = new Date();
  if (hoje.getDay() !== 0) return; // só domingo

  // Banner in-app — funciona em todos os dispositivos incluindo iOS Safari
  const banner = document.createElement("div");
  banner.id = "banner-dominical";
  banner.innerHTML = `
    <span>⏱ Domingo de estudo — hora do Micro-Simulado!</span>
    <button id="btn-banner-simulado">Simular agora</button>
    <button id="btn-banner-fechar" aria-label="Fechar">✕</button>`;
  document.body.prepend(banner);

  document.getElementById("btn-banner-fechar").addEventListener("click", () => banner.remove());
  document.getElementById("btn-banner-simulado").addEventListener("click", () => {
    banner.remove();
    iniciarMicroSimulado();
  });

  // Notificação do browser para não-iOS (sem servidor — dispara ao abrir o app)
  if (PUSH_SUPORTADO) {
    Notification.requestPermission().then(perm => {
      if (perm === "granted") {
        new Notification("Sedes-DF 2026", {
          body: "Domingo de estudo! Micro-Simulado de 10 questões te espera.",
          icon: "/vanguard/icon-192.png",
          tag: "dominical",
        });
      }
    });
  }
}

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
    if (tapCount >= 3) { tapCount = 0; toggleDebug(); }
  });
}

function toggleDebug() {
  const panel = document.getElementById("debug-panel");
  if (!panel) return;
  const abrindo = panel.style.display === "none";
  panel.style.display = abrindo ? "block" : "none";
  if (abrindo) carregarDashboard(); // N-3 + N-1: popula controles ao abrir
}

function atualizarDebug(questao, cacheStatus, custo) {
  const el = document.getElementById("debug-content");
  if (!el) return;

  ultimoCacheStatus = cacheStatus ?? ultimoCacheStatus;
  const isVacina = VACINA_DISCIPLINAS.has(questao?.disciplina_id);
  el.innerHTML = [
    `ID: <b>${questao?.id ?? "—"}</b>`,
    `Disciplina: ${questao?.disciplina_id ?? "—"}${isVacina ? " <b style='color:#FFD600'>⚡vacina</b>" : ""}`,
    `Peso SM-2: ${questao?.peso_edital ?? "—"} · Feed: ${feed.length}q`,
    `Erros consec.: <b>${errosConsecutivos}</b> (G-5 dispara em 3)`,
    `Cache: ${ultimoCacheStatus}`,
    `Gasto est.: $${gastoEstimado.toFixed(4)} / $${(COTA_DIARIA_USD * KILL_SWITCH_PCT).toFixed(2)}`,
    `Kill-switch: ${killSwitchAtivado ? "<b style='color:var(--red)'>ATIVO</b>" : "off"}`,
    `Total respostas: ${totalRespostasGlobal}`,
    ADMIN_MODE ? `<b style='color:var(--yellow)'>ADMIN MODE</b>` : "",
  ].filter(Boolean).map((l) => `<div>${l}</div>`).join("");
}

// ── SESSOES_USUARIO — Dia 9 ───────────────────────────────────────────────────
async function iniciarSessao() {
  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/sessoes_usuario`, {
      method: "POST",
      headers: { ...headers(), "Content-Type": "application/json", Prefer: "return=representation" },
      body: JSON.stringify({ user_id: USER_ID }),
    });
    if (res.ok) {
      const rows = await res.json();
      sessaoId = rows[0]?.id ?? null;
    }
  } catch (_) {}
}

async function encerrarSessao() {
  if (!sessaoId) return;
  try {
    await fetch(`${SUPABASE_URL}/rest/v1/sessoes_usuario?id=eq.${sessaoId}`, {
      method: "PATCH",
      headers: { ...headers(), "Content-Type": "application/json", Prefer: "return=minimal" },
      body: JSON.stringify({
        encerrada_em:         new Date().toISOString(),
        questoes_respondidas: feed.length,
      }),
    });
  } catch (_) {}
}

// ── MICRO-SIMULADO — Dia 11 ───────────────────────────────────────────────────

async function iniciarMicroSimulado() {
  trocarMain('<div class="estado-vazio"><div class="spinner"></div><p>Preparando simulado…</p></div>');

  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/get_questoes_simulado`, {
      method: "POST",
      headers: { ...headers(), "Content-Type": "application/json" },
      body: JSON.stringify({ p_user_id: USER_ID, p_quantidade: SIMULADO_TOTAL }),
    });
    if (!res.ok) throw new Error(`Simulado: ${res.status}`);
    simuladoQuestoes = await res.json();
    if (!simuladoQuestoes || simuladoQuestoes.length === 0) {
      mostrarErro("Sem questões disponíveis para o simulado.");
      return;
    }
  } catch (err) {
    mostrarErro(err.message);
    return;
  }

  simuladoIndice  = 0;
  simuladoAcertos = 0;
  simuladoTempos  = [];

  document.getElementById("progresso-header").textContent = "Simulado";
  renderizarQuestaoSimulado(0);
}

function renderizarQuestaoSimulado(indice) {
  simuladoIndice  = indice;
  simuladoInicioQ = Date.now();
  const q = simuladoQuestoes[indice];

  clearInterval(simuladoTimer);

  const tpl  = document.getElementById("tpl-questao").content.cloneNode(true);
  const card = tpl.querySelector(".questao-card");

  const nomeDisc = NOMES_DISCIPLINAS[q.disciplina_id] ?? q.disciplina_id;
  const badgeDisc = card.querySelector(".badge-disciplina");
  badgeDisc.textContent = nomeDisc;
  badgeDisc.className   = q.peso_edital === 2 ? "badge-peso2" : "badge-peso1";

  const badgeTipo = card.querySelector(".badge-tipo");
  if (q.revisao) {
    badgeTipo.textContent = "[Simulado de Fixação]"; // N-4: SM-2 — questão já vista antes
    badgeTipo.className   = "badge-sm2";
  } else {
    badgeTipo.textContent = "⏱ Simulado";
    badgeTipo.className   = "badge-simulado";
  }

  const numEl = card.querySelector(".questao-numero");
  numEl.textContent = `${indice + 1}/${SIMULADO_TOTAL} · ${SIMULADO_TEMPO_SEG}s`;

  const barraFill = card.querySelector(".barra-fill");
  barraFill.style.transition = "none";
  barraFill.style.width      = "100%";
  barraFill.className        = "barra-fill timer-ok";

  card.querySelector(".questao-enunciado").innerHTML = md2html(q.enunciado);

  const contAlts = card.querySelector(".alternativas");
  (q.alternativas ?? []).forEach((alt) => {
    const tplAlt = document.getElementById("tpl-alternativa").content.cloneNode(true);
    const btn    = tplAlt.querySelector(".alternativa");
    btn.querySelector(".letra").textContent = alt.letra + ".";
    btn.querySelector(".texto").innerHTML   = md2html(alt.texto);
    btn.dataset.letra = alt.letra;
    btn.addEventListener("click", () => processarRespostaSimulado(q, alt.letra, card));
    contAlts.appendChild(btn);
  });

  trocarMain(card); // card entra no DOM

  // Reflow + transição linear para o timer
  void card.offsetWidth;
  barraFill.style.transition = "width 0.9s linear";

  let segsRestantes = SIMULADO_TEMPO_SEG;
  simuladoTimer = setInterval(() => {
    segsRestantes--;
    numEl.textContent = `${indice + 1}/${SIMULADO_TOTAL} · ${segsRestantes}s`;

    const pct = (segsRestantes / SIMULADO_TEMPO_SEG) * 100;
    barraFill.style.width = `${pct}%`;

    if (segsRestantes <= 10)      barraFill.className = "barra-fill timer-critico";
    else if (segsRestantes <= 30) barraFill.className = "barra-fill timer-alerta";

    if (segsRestantes <= 0) {
      clearInterval(simuladoTimer);
      processarRespostaSimulado(q, null, card);
    }
  }, 1000);
}

function processarRespostaSimulado(questao, letraEscolhida, card) {
  clearInterval(simuladoTimer);

  const tti    = Date.now() - simuladoInicioQ;
  const correta = questao.gabarito;
  const acertou = letraEscolhida !== null && letraEscolhida === correta;
  if (acertou) {
    simuladoAcertos++;
  } else {
    // G-5: rastreia disciplina mais errática para a Socrática Pânico
    const d = questao.disciplina_id;
    simuladoErrosPorDisciplina[d] = (simuladoErrosPorDisciplina[d] ?? 0) + 1;
  }
  simuladoTempos.push(tti);

  // Desabilita alternativas
  const btns = card.querySelectorAll(".alternativa");
  btns.forEach((b) => { b.disabled = true; });

  // Colorir gabarito
  btns.forEach((b) => {
    if (b.dataset.letra === correta)                             b.classList.add("correta");
    else if (b.dataset.letra === letraEscolhida && !acertou)    b.classList.add("errada");
  });

  // Feedback mínimo — sem tutor
  const tplExp = document.getElementById("tpl-explicacao").content.cloneNode(true);
  const expDiv = tplExp.querySelector(".explicacao");
  expDiv.classList.add(acertou ? "acerto" : "erro");

  const icone = letraEscolhida === null ? "⏰" : (acertou ? "✅" : "❌");
  const msgTxt = letraEscolhida === null
    ? `Tempo esgotado. Gabarito: ${correta}`
    : acertou ? `Correto! Gabarito: ${correta}` : `Errado. Gabarito: ${correta}`;

  expDiv.querySelector(".icone-resultado").textContent  = icone;
  expDiv.querySelector(".texto-resultado").textContent  = msgTxt;
  expDiv.querySelector(".explicacao-body").style.display  = "none";
  expDiv.querySelector(".explicacao-nivel").style.display = "none";

  card.appendChild(expDiv);

  // Salva progresso apenas quando houve escolha (não timeout)
  if (letraEscolhida !== null) {
    salvarProgresso(questao, letraEscolhida, acertou, tti, false, 0);
  }

  // Botão próxima ou resultado
  const tplBtn  = document.getElementById("tpl-btn-proxima").content.cloneNode(true);
  const btnNext = tplBtn.querySelector(".btn-proxima");
  const ultima  = simuladoIndice === simuladoQuestoes.length - 1;
  btnNext.textContent = ultima ? "Ver resultado →" : "Próxima →";
  btnNext.addEventListener("click", () => {
    if (ultima) mostrarResultadoSimulado();
    else renderizarQuestaoSimulado(simuladoIndice + 1);
  });
  card.appendChild(btnNext);
}

function mostrarResultadoSimulado() {
  clearInterval(simuladoTimer);

  const total    = simuladoQuestoes.length;
  const pct      = Math.round((simuladoAcertos / total) * 100);
  const medioMs  = simuladoTempos.length > 0
    ? simuladoTempos.reduce((a, b) => a + b, 0) / simuladoTempos.length
    : 0;
  const medioSeg = Math.round(medioMs / 1000);

  const avaliacao = pct >= 70
    ? { icon: "🟢", msg: "Aprovado no bloco! Ritmo de prova." }
    : pct >= 50
    ? { icon: "🟡", msg: "Quase lá — reforçar antes da prova." }
    : { icon: "🔴", msg: "Reforço urgente antes do dia H." };

  // Quadrix: ~120 questões em 4h ≈ 2 min/questão
  const ritmoMsg = medioSeg <= 120
    ? `Ritmo ok — ${medioSeg}s por questão`
    : `Atenção ao tempo — ${medioSeg}s por questão (limite ≈ 120s)`;

  trocarMain(`
    <div class="fim-sessao">
      <div style="font-size:48px">${avaliacao.icon}</div>
      <h2>Resultado do Simulado</h2>
      <div class="fim-stats" style="grid-template-columns:1fr 1fr 1fr;max-width:360px">
        <div class="stat-box">
          <div class="valor">${simuladoAcertos}/${total}</div>
          <div class="desc">Acertos</div>
        </div>
        <div class="stat-box">
          <div class="valor">${pct}%</div>
          <div class="desc">Aproveit.</div>
        </div>
        <div class="stat-box">
          <div class="valor">${medioSeg}s</div>
          <div class="desc">Tempo médio</div>
        </div>
      </div>
      <p class="frase-encerramento" style="display:block">${avaliacao.msg}</p>
      <p style="color:var(--muted);font-size:13px;max-width:280px;text-align:center;line-height:1.5">${ritmoMsg}</p>
      <button class="btn-novo-dia" onclick="location.reload()">Fechar</button>
    </div>
  `);

  document.getElementById("progresso-header").textContent = "Simulado";

  // G-5: Socrática Pânico — pct abaixo de 50% no simulado
  if (pct < 50) {
    setTimeout(() => ativarSocraticaPanico("simulado"), 2000);
  }
}

// Debug: força G-5 para testes — acessível via botão no debug panel
window._testG5 = () => { errosConsecutivos = 3; ativarSocraticaPanico("feed"); };

// ── G-5: SOCRÁTICA PÂNICO ────────────────────────────────────────────────────
function ativarSocraticaPanico(tipo) {
  // Identifica disciplina mais errática para orientar o foco
  let discFoco = null;
  if (tipo === "simulado") {
    const entradas = Object.entries(simuladoErrosPorDisciplina).sort((a, b) => b[1] - a[1]);
    if (entradas.length > 0) discFoco = NOMES_DISCIPLINAS[entradas[0][0]] ?? entradas[0][0];
  } else {
    // feed: agrupa erros por disciplina usando o feed atual
    const errosPorDisc = {};
    feed.forEach((q) => {
      if (errosPorQuestao[q.id]) {
        errosPorDisc[q.disciplina_id] = (errosPorDisc[q.disciplina_id] ?? 0) + errosPorQuestao[q.id];
      }
    });
    const entradas = Object.entries(errosPorDisc).sort((a, b) => b[1] - a[1]);
    if (entradas.length > 0) discFoco = NOMES_DISCIPLINAS[entradas[0][0]] ?? entradas[0][0];
  }

  const titulo = tipo === "simulado"
    ? "Resultado abaixo de 50%."
    : "Três erros seguidos.";
  const corpo = tipo === "simulado"
    ? "Normal em treino — você está mapeando seus pontos cegos. Esse mapa vai guiar as próximas sessões."
    : "O cérebro aprende melhor com uma pausa. Respira e continua.";
  const focoStr = discFoco
    ? `<p class="panico-foco">Próximo foco: <strong>${discFoco}</strong></p>`
    : "";

  trocarMain(`
    <div class="panico-screen">
      <div class="panico-icon">💙</div>
      <h2 class="panico-titulo">${titulo}</h2>
      <p class="panico-corpo">${corpo}</p>
      ${focoStr}
      <button class="btn-proxima" id="btn-continuar-panico">Continuar estudando →</button>
    </div>
  `);

  document.getElementById("btn-continuar-panico")?.addEventListener("click", () => {
    errosConsecutivos = 0;
    simuladoErrosPorDisciplina = {};
    if (tipo === "simulado") {
      location.reload();
    } else if (indiceAtual >= feed.length - 1) {
      // G-5 disparou na última questão — vai para resultado em vez de próxima
      mostrarFim();
    } else {
      renderizarQuestao(indiceAtual + 1);
    }
  });
}

// ── RPC: CALCULAR PONTOS PONDERADOS CUMULATIVOS ───────────────────────────────
async function calcularPontosCumulativos() {
  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/calcular_pontos_ponderados`, {
      method: "POST",
      headers: { ...headers(), "Content-Type": "application/json" },
      body: JSON.stringify({ p_user_id: USER_ID }),
    });
    if (!res.ok) return null;
    const rows = await res.json();
    return Array.isArray(rows) ? rows[0] : rows;
  } catch (_) {
    return null;
  }
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

// ── N-3: LINHA DE CORTE — Dia 14 ─────────────────────────────────────────────
function carregarLinhaCorte() {
  return parseInt(localStorage.getItem("linhaCorte_pts") || LINHA_CORTE_DEFAULT, 10);
}

function salvarLinhaCorte(pts) {
  localStorage.setItem("linhaCorte_pts", String(pts));
}

function inserirMetaBarra(container, pts, meta) {
  const pct   = Math.min(Math.round((pts / Math.max(meta, 1)) * 100), 100);
  const acima = pts >= meta;
  const div   = document.createElement("div");
  div.className = "meta-corte";
  div.innerHTML = `
    <div class="meta-header">
      <span class="meta-label">Território conquistado</span>
      <span class="meta-valores">${pts} pts</span>
    </div>
    <div class="meta-barra-bg">
      <div class="meta-barra-fill${acima ? " meta-ok" : ""}" style="width:${pct}%"></div>
    </div>
    <div class="meta-rodape">${acima ? "✅ Acima da linha de corte!" : "Meta estimada: " + meta + " pts (" + pct + "% atingido)"}</div>
  `;
  const btnFechar = container.querySelector("#btn-fechar");
  if (btnFechar) btnFechar.before(div);
  else container.appendChild(div);
}

// ── N-1 + N-3: DASHBOARD (painel 3-toques no logo) — Dia 14 ─────────────────
async function carregarDashboard() {
  // N-3: Linha de Corte
  const linhaAtual  = carregarLinhaCorte();
  const inputCorte  = document.getElementById("dash-corte-input");
  const statusCorte = document.getElementById("dash-corte-status");
  const btnSave     = document.getElementById("dash-corte-save");

  if (inputCorte)  inputCorte.value = linhaAtual;
  if (statusCorte) statusCorte.textContent = "Atual: " + linhaAtual + " pts";

  if (btnSave) {
    btnSave.onclick = () => {
      const v = parseInt(inputCorte ? inputCorte.value : "", 10);
      if (!isNaN(v) && v > 0) {
        salvarLinhaCorte(v);
        if (statusCorte) statusCorte.textContent = "✅ Salvo: " + v + " pts";
      }
    };
  }

  // N-1: Buscar última sessão de Ingrid → gerar mensagem de push
  const pushInfo = document.getElementById("dash-push-info");
  const pushCopy = document.getElementById("dash-push-copy");

  if (!pushInfo) return;

  try {
    const res = await fetch(
      `${SUPABASE_URL}/rest/v1/sessoes_usuario?user_id=eq.${USER_ID}&order=iniciada_em.desc&limit=1&select=iniciada_em`,
      { headers: headers() }
    );
    const rows = await res.json();

    if (rows.length > 0 && rows[0].iniciada_em) {
      const dt   = new Date(rows[0].iniciada_em);
      const hora = dt.toLocaleTimeString("pt-BR", { hour: "2-digit", minute: "2-digit" });
      const dia  = dt.toLocaleDateString("pt-BR", { weekday: "long", day: "2-digit", month: "2-digit" });
      pushInfo.textContent = "Última sessão: " + hora + " (" + dia + ")";

      const msgTexto = "Ingrid, vi que você estudou hoje às " + hora + "! Como tá indo? Me conta um acerto que você teve hoje 💪";

      if (pushCopy) {
        pushCopy.onclick = () => {
          navigator.clipboard.writeText(msgTexto)
            .then(() => {
              pushCopy.textContent = "✅ Copiado!";
              setTimeout(() => { pushCopy.textContent = "Copiar mensagem"; }, 2000);
            })
            .catch(() => window.prompt("Copie a mensagem:", msgTexto));
        };
      }
    } else {
      pushInfo.textContent = "Nenhuma sessão registrada ainda.";
    }
  } catch (_) {
    pushInfo.textContent = "Erro ao buscar sessão.";
  }

  // Nota Simulada de Prova (estatística)
  calcularNotaSimulada();
}

// ── NOTA SIMULADA DE PROVA (estatística) — Dia 15 ────────────────────────────
async function calcularNotaSimulada() {
  const notaEl = document.getElementById("dash-nota-valor");
  const fillEl = document.getElementById("dash-nota-fill");
  const infoEl = document.getElementById("dash-nota-info");
  if (!notaEl) return;

  try {
    const res = await fetch(
      `${SUPABASE_URL}/rest/v1/rpc/get_heatmap_disciplinas`,
      {
        method: "POST",
        headers: { ...headers(), "Content-Type": "application/json" },
        body: JSON.stringify({ p_user_id: USER_ID })
      }
    );
    const dados = await res.json();
    if (!Array.isArray(dados) || dados.length === 0) {
      notaEl.textContent = "–";
      if (infoEl) infoEl.textContent = "Sem dados suficientes ainda.";
      return;
    }

    const taxaMap = {};
    for (const row of dados) taxaMap[row.disciplina_id] = row.taxa_acerto_pct ?? 0;

    let notaProjetada = 0;
    let discCobertas  = 0;
    for (const [disc, e] of Object.entries(EDITAL_DIST)) {
      notaProjetada += ((taxaMap[disc] ?? 0) / 100) * e.questoes * e.peso;
      if (taxaMap[disc] !== undefined) discCobertas++;
    }
    notaProjetada = Math.round(notaProjetada * 10) / 10;

    const pct     = Math.min(Math.round(notaProjetada), 100);
    const atingiu = notaProjetada >= 67;

    notaEl.textContent = notaProjetada.toFixed(1) + " / 100";
    notaEl.style.color = atingiu ? "#4ade80" : "var(--cyan)";
    if (fillEl) {
      fillEl.style.width = pct + "%";
      fillEl.className   = "meta-barra-fill" + (atingiu ? " meta-ok" : "");
    }
    if (infoEl) {
      const statusTxt = atingiu
        ? "Acima do corte estimado (67 pts)"
        : "Abaixo do corte estimado (67 pts)";
      infoEl.textContent = (atingiu ? "✅ " : "⚠️ ") + statusTxt
        + " · " + discCobertas + "/" + Object.keys(EDITAL_DIST).length + " disciplinas";
    }
  } catch (_) {
    if (notaEl) notaEl.textContent = "–";
    if (infoEl) infoEl.textContent = "Erro ao calcular nota simulada.";
  }
}

// ── N-5: EXPORTAR CARD DE PROGRESSO — Dia 14 ─────────────────────────────────
async function exportarCardProgresso() {
  if (typeof html2canvas === "undefined") {
    window.alert("Exportação indisponível — verifique a conexão e tente novamente.");
    return;
  }

  const meta = carregarLinhaCorte();
  const pts  = pontosBase + pontosAcumulados;
  const pct  = Math.min(Math.round((pts / Math.max(meta, 1)) * 100), 100);
  const data = new Date().toLocaleDateString("pt-BR", { day: "2-digit", month: "long", year: "numeric" });

  const card = document.createElement("div");
  card.style.cssText =
    "position:fixed;top:-9999px;left:0;width:320px;padding:28px 24px;background:#0A0A0A;" +
    "border:1px solid rgba(0,240,255,0.25);border-radius:16px;font-family:Inter,sans-serif;" +
    "color:#E8E8E8;box-sizing:border-box;";
  card.innerHTML =
    '<div style="font-size:10px;color:#00F0FF;letter-spacing:.1em;text-transform:uppercase;margin-bottom:2px">Sedes-DF 2026</div>' +
    '<div style="font-size:12px;color:#555;margin-bottom:20px">' + data + '</div>' +
    '<div style="font-size:52px;font-weight:800;color:#00F0FF;line-height:1">' + pts + '</div>' +
    '<div style="font-size:12px;color:#555;margin-top:4px;margin-bottom:16px">pontos · meta ' + meta + '</div>' +
    '<div style="height:6px;background:#1a1a1a;border-radius:3px;overflow:hidden;margin-bottom:16px">' +
      '<div style="height:100%;background:#00F0FF;border-radius:3px;width:' + pct + '%"></div>' +
    '</div>' +
    '<div style="font-size:13px;color:#B0F0FF;font-weight:600">' + acertos + ' acertos hoje · ' + feed.length + ' questões respondidas</div>' +
    '<div style="font-size:10px;color:#333;margin-top:20px;letter-spacing:.05em">VANGUARD TECH · SEDES-DF 2026</div>';

  document.body.appendChild(card);

  try {
    const canvas = await html2canvas(card, { scale: 2, backgroundColor: "#0A0A0A", useCORS: true, logging: false });
    const link = document.createElement("a");
    link.download = "sedes-progresso-" + new Date().toISOString().slice(0, 10) + ".png";
    link.href = canvas.toDataURL("image/png");
    link.click();
  } catch (_) {
    window.alert("Não foi possível exportar. Tente novamente.");
  } finally {
    card.remove();
  }
}
