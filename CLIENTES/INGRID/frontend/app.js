// app.js — Sedes-DF 2026 — PROJ-002 Ingrid
// Dias 3-5: Feed Diario + SM-2 + Explicacao direta + Contador ponderado

// ── CONFIG (preencher antes do deploy) ──────────────────────────────────────
const SUPABASE_URL = "__SUPABASE_URL__";          // ex: https://xxxx.supabase.co
const SUPABASE_ANON_KEY = "__SUPABASE_ANON_KEY__"; // chave anon publica
const USER_ID = "__USER_ID_INGRID__";              // UUID fixo da Ingrid no Supabase

// ── NOMES LEGIVEIS DAS DISCIPLINAS ──────────────────────────────────────────
const NOMES_DISCIPLINAS = {
  suas_fundamentos:               "SUAS",
  programas_beneficios_df:        "Programas DF",
  direito_administrativo:         "Dir. Administrativo",
  direito_constitucional:         "Dir. Constitucional",
  arquivologia_rotinas_atendimento: "Arquivologia",
  recursos_materiais_patrimonio:  "Recursos Materiais",
  portugues:                      "Português",
  realidade_df_ride:              "Realidade DF/RIDE",
  lei_organica_df:                "Lei Orgânica DF",
  lc840:                          "LC 840 — Servidores",
  maria_da_penha:                 "Lei Maria da Penha",
  politica_mulheres:              "Política para Mulheres",
  primeiros_socorros:             "Primeiros Socorros",
};

// ── ESTADO ───────────────────────────────────────────────────────────────────
let feed = [];
let indiceAtual = 0;
let pontosAcumulados = 0;
let acertos = 0;
let revisoesPendentes = 0;

// ── INIT ─────────────────────────────────────────────────────────────────────
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/sw.js").catch(() => {});
}

document.addEventListener("DOMContentLoaded", iniciar);

async function iniciar() {
  try {
    const dados = await carregarFeed();
    feed = dados.feed ?? [];

    if (feed.length === 0) {
      mostrarVazio();
      return;
    }

    renderizarQuestao(0);
  } catch (err) {
    mostrarErro(err.message);
  }
}

// ── CARREGAR FEED ─────────────────────────────────────────────────────────────
async function carregarFeed() {
  const res = await fetch(`${SUPABASE_URL}/functions/v1/feed-diario`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${SUPABASE_ANON_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ user_id: USER_ID }),
  });

  if (!res.ok) throw new Error("Erro ao carregar feed: " + res.status);
  return res.json();
}

// ── RENDERIZAR QUESTAO ───────────────────────────────────────────────────────
function renderizarQuestao(indice) {
  indiceAtual = indice;
  const q = feed[indice];
  const main = document.getElementById("main-content");

  // Atualizar header
  document.getElementById("progresso-header").textContent = `${indice + 1} / ${feed.length}`;

  const tpl = document.getElementById("tpl-questao").content.cloneNode(true);
  const card = tpl.querySelector(".questao-card");

  // Meta: disciplina + tipo (Peso 1/2) + revisao
  const nomeDisc = NOMES_DISCIPLINAS[q.disciplina_id] ?? q.disciplina_id;
  const badgeDisc = card.querySelector(".badge-disciplina");
  badgeDisc.textContent = nomeDisc;
  badgeDisc.className = q.peso_edital === 2 ? "badge-peso2" : "badge-peso1";

  const badgeTipo = card.querySelector(".badge-tipo");
  if (q.revisao) {
    badgeTipo.textContent = "🔁 Revisão";
    badgeTipo.className = "badge-revisao";
  } else {
    badgeTipo.textContent = `Peso ${q.peso_edital}`;
    badgeTipo.className = q.peso_edital === 2 ? "badge-peso2" : "badge-peso1";
  }

  card.querySelector(".questao-numero").textContent = `${indice + 1}/${feed.length}`;

  // Barra de progresso
  card.querySelector(".barra-fill").style.width = `${((indice + 1) / feed.length) * 100}%`;

  // Pílula do dia (se existir na questão)
  if (q.pilula_do_dia) {
    const tplPilula = document.getElementById("tpl-pilula").content.cloneNode(true);
    tplPilula.querySelector(".pilula-texto").textContent = q.pilula_do_dia;
    main.innerHTML = "";
    main.appendChild(tplPilula);
    main.appendChild(card);
  } else {
    main.innerHTML = "";
    main.appendChild(card);
  }

  // Enunciado
  card.querySelector(".questao-enunciado").textContent = q.enunciado;

  // Alternativas
  const contAlts = card.querySelector(".alternativas");
  (q.alternativas ?? []).forEach((alt) => {
    const tplAlt = document.getElementById("tpl-alternativa").content.cloneNode(true);
    const btn = tplAlt.querySelector(".alternativa");
    btn.querySelector(".letra").textContent = alt.letra + ".";
    btn.querySelector(".texto").textContent = alt.texto;
    btn.dataset.letra = alt.letra;
    btn.dataset.correta = alt.correta;
    btn.addEventListener("click", () => processarResposta(q, alt.letra, card));
    contAlts.appendChild(btn);
  });
}

// ── PROCESSAR RESPOSTA ────────────────────────────────────────────────────────
async function processarResposta(questao, letraEscolhida, card) {
  const alts = card.querySelectorAll(".alternativa");
  alts.forEach((btn) => { btn.disabled = true; });

  const correta = questao.gabarito;
  const acertou = letraEscolhida === correta;

  // Colorir alternativas
  alts.forEach((btn) => {
    if (btn.dataset.letra === correta) {
      btn.classList.add("correta");
    } else if (btn.dataset.letra === letraEscolhida && !acertou) {
      btn.classList.add("errada");
    }
  });

  // Atualizar pontuação
  if (acertou) {
    acertos++;
    pontosAcumulados += questao.peso_edital * 2; // Peso 2 vale 2 pts, Peso 1 vale 2 pts (ponderado)
    document.getElementById("pontos-valor").textContent = pontosAcumulados;
  } else {
    revisoesPendentes++;
  }

  // Exibir explicação imediata (Opção A — Dias 3-5)
  const tplExp = document.getElementById("tpl-explicacao").content.cloneNode(true);
  const expDiv = tplExp.querySelector(".explicacao");
  expDiv.classList.add(acertou ? "acerto" : "erro");

  const header = expDiv.querySelector(".explicacao-header");
  header.querySelector(".icone-resultado").textContent = acertou ? "✅" : "❌";
  header.querySelector(".texto-resultado").textContent = acertou
    ? `Correto! Gabarito: ${correta}`
    : `Errado. Gabarito: ${correta}`;

  expDiv.querySelector(".explicacao-body").textContent = questao.explicacao ?? "";

  card.appendChild(expDiv);

  // Botão próxima
  const tplBtn = document.getElementById("tpl-btn-proxima").content.cloneNode(true);
  const btn = tplBtn.querySelector(".btn-proxima");

  const ultimaQuestao = indiceAtual === feed.length - 1;
  if (ultimaQuestao) {
    btn.textContent = "Ver resultado da sessão →";
  }

  btn.addEventListener("click", () => {
    if (ultimaQuestao) {
      mostrarFim();
    } else {
      renderizarQuestao(indiceAtual + 1);
    }
  });

  card.appendChild(btn);

  // Salvar progresso no Supabase (fire-and-forget)
  salvarProgresso(questao, letraEscolhida, acertou);
}

// ── SALVAR PROGRESSO (SM-2) ───────────────────────────────────────────────────
async function salvarProgresso(questao, resposta, acertou) {
  // Calcula proxima revisao SM-2 com base na performance global da disciplina
  // Simplificado para MVP: acerto → 7 dias, erro → 2 dias
  const hoje = new Date();
  const diasRevisao = acertou ? 7 : 2;
  const proximaRevisao = new Date(hoje.getTime() + diasRevisao * 86400000)
    .toISOString().split("T")[0];

  await fetch(`${SUPABASE_URL}/rest/v1/progresso_usuario`, {
    method: "POST",
    headers: {
      "apikey": SUPABASE_ANON_KEY,
      "Authorization": `Bearer ${SUPABASE_ANON_KEY}`,
      "Content-Type": "application/json",
      "Prefer": "return=minimal",
    },
    body: JSON.stringify({
      user_id: USER_ID,
      questao_id: questao.id,
      resposta_usuario: resposta,
      correta: acertou,
      proxima_revisao_em: proximaRevisao,
      respondida_em: new Date().toISOString(),
    }),
  }).catch(() => {}); // nao bloquear UI se falhar
}

// ── FIM DE SESSAO ─────────────────────────────────────────────────────────────
function mostrarFim() {
  const main = document.getElementById("main-content");
  const tpl = document.getElementById("tpl-fim").content.cloneNode(true);

  const pct = feed.length > 0 ? Math.round((acertos / feed.length) * 100) : 0;

  tpl.getElementById("stat-acertos").textContent = `${acertos}/${feed.length}`;
  tpl.getElementById("stat-pontos").textContent = pontosAcumulados;
  tpl.getElementById("stat-pct").textContent = `${pct}%`;
  tpl.getElementById("stat-revisoes").textContent = revisoesPendentes;

  main.innerHTML = "";
  main.appendChild(tpl);

  document.getElementById("progresso-header").textContent = "Concluído";
}

// ── ESTADOS DE ERRO/VAZIO ─────────────────────────────────────────────────────
function mostrarVazio() {
  const main = document.getElementById("main-content");
  main.innerHTML = `
    <div class="estado-vazio">
      <div class="icon">🎉</div>
      <h2>Parabéns, Ingrid!</h2>
      <p>Você já respondeu todas as questões disponíveis para hoje.<br>
         Volte amanhã para as suas revisões SM-2.</p>
    </div>`;
}

function mostrarErro(msg) {
  const main = document.getElementById("main-content");
  main.innerHTML = `
    <div class="estado-vazio">
      <div class="icon">⚠️</div>
      <h2>Erro ao carregar</h2>
      <p>${msg}</p>
      <button class="btn-novo-dia" onclick="location.reload()">Tentar novamente</button>
    </div>`;
}
