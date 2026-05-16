#!/usr/bin/env node
// =============================================================
// MÁGICO DE OZ GATE — PROJ-002 Ingrid
// P-007: validar geração de questões via CLI antes de construir UI
// Dia 2: Eduardo avalia 10 questões — rubrica média >= 4/5 para avançar
// =============================================================
// Uso: node gate_cli.js --disciplina suas --quantidade 10
// =============================================================

// Carrega .env se existir (nunca commitar o .env — só o .env.example)
const fs = require("fs");
const path = require("path");
const envPath = path.join(__dirname, ".env");
if (fs.existsSync(envPath)) {
  fs.readFileSync(envPath, "utf8").split("\n").forEach((line) => {
    const [key, ...rest] = line.split("=");
    if (key && rest.length) process.env[key.trim()] = rest.join("=").trim();
  });
}

const readline = require("readline");

const args = process.argv.slice(2);
const getArg = (flag) => {
  const i = args.indexOf(flag);
  return i !== -1 ? args[i + 1] : null;
};

const DISCIPLINA = getArg("--disciplina") || "suas";
const QUANTIDADE = parseInt(getArg("--quantidade") || "10", 10);
const SUPABASE_URL = process.env.SUPABASE_URL;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;

if (!SUPABASE_URL || !ANTHROPIC_API_KEY) {
  console.error("❌ Configure SUPABASE_URL e ANTHROPIC_API_KEY no ambiente.");
  process.exit(1);
}

const RUBRICA = [
  "Estilo Quadrix? (enunciado direto, literalidade da lei, sem interpretação além do texto)",
  "Distratores plausíveis? (alternativas erradas que enganam quem não estudou bem)",
  "Gabarito correto? (a alternativa correta realmente está certa pela lei)",
  "Explicação clara? (o 'ao errar' explica o erro e o acerto com referência à lei)",
  "Dificuldade adequada? (nem trivial, nem impossível — grau 2-4 de 5)",
];

const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
const pergunta = (texto) => new Promise((res) => rl.question(texto, res));

async function chamarEdgeFunction() {
  console.log(`\n🔄 Gerando ${QUANTIDADE} questões de [${DISCIPLINA.toUpperCase()}] via Claude API...`);
  console.log("   Modelo: Sonnet (peso 2) | Haiku (peso 1)");
  console.log("   Modo: gate_cli — questões NÃO salvas no banco\n");

  const resp = await fetch(`${SUPABASE_URL}/functions/v1/gerar-questoes`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${process.env.SUPABASE_ANON_KEY}`,
    },
    body: JSON.stringify({
      disciplina_id: DISCIPLINA,
      quantidade: QUANTIDADE,
      modo: "gate_cli",
    }),
  });

  if (!resp.ok) {
    const err = await resp.text();
    throw new Error(err);
  }

  return resp.json();
}

async function avaliarQuestao(questao, numero, total) {
  console.log("\n" + "═".repeat(60));
  console.log(`📝 QUESTÃO ${numero}/${total} — ${DISCIPLINA.toUpperCase()}`);
  console.log("═".repeat(60));
  console.log(`\n${questao.enunciado}\n`);

  for (const alt of questao.alternativas) {
    const marcador = alt.correta ? "✅" : "  ";
    console.log(`${marcador} ${alt.letra}) ${alt.texto}`);
  }

  console.log(`\n📌 Gabarito: ${questao.gabarito}`);
  console.log(`💡 Explicação: ${questao.explicacao}`);
  console.log(`🎯 Distrator principal: ${questao.distrator_principal}`);
  console.log(`📊 Dificuldade: ${questao.nivel_dificuldade}/5`);
  console.log(`🏷️  Estilo: ${(questao.estilo_quadrix || []).join(", ")}`);
  console.log("\n" + "─".repeat(60));
  console.log("RUBRICA DE AVALIAÇÃO (0-5 para cada critério):");

  const notas = [];
  for (let i = 0; i < RUBRICA.length; i++) {
    const nota = await pergunta(`  [${i + 1}] ${RUBRICA[i]}\n      Nota (0-5): `);
    notas.push(parseFloat(nota) || 0);
  }

  const media = notas.reduce((a, b) => a + b, 0) / notas.length;
  console.log(`\n⭐ Média desta questão: ${media.toFixed(2)}/5`);

  return { questao: numero, notas, media };
}

async function main() {
  console.log("╔══════════════════════════════════════════════════════════╗");
  console.log("║          MÁGICO DE OZ GATE — PROJ-002 Ingrid             ║");
  console.log("║    Validação da geração de questões estilo Quadrix        ║");
  console.log("╚══════════════════════════════════════════════════════════╝");
  console.log(`\nDisciplina: ${DISCIPLINA.toUpperCase()}`);
  console.log(`Quantidade: ${QUANTIDADE} questões`);
  console.log(`Gate de aprovação: média >= 4.0/5\n`);

  let dados;
  try {
    dados = await chamarEdgeFunction();
  } catch (err) {
    // Fallback: gerar direto via API sem Supabase (para teste local)
    console.log("⚠️  Edge Function não disponível. Gerando direto via Claude API...");
    dados = await gerarDireto();
  }

  console.log(`✅ ${dados.questoes.length} questões geradas | Custo: $${dados.custo_usd}`);

  const resultados = [];
  for (let i = 0; i < dados.questoes.length; i++) {
    const resultado = await avaliarQuestao(dados.questoes[i], i + 1, dados.questoes.length);
    resultados.push(resultado);
  }

  rl.close();

  // Relatório final
  const mediaGeral = resultados.reduce((s, r) => s + r.media, 0) / resultados.length;
  const aprovado = mediaGeral >= 4.0;

  console.log("\n" + "═".repeat(60));
  console.log("📊 RELATÓRIO DO GATE");
  console.log("═".repeat(60));
  resultados.forEach((r) =>
    console.log(`  Questão ${r.questao}: ${r.media.toFixed(2)}/5 ${r.media >= 4 ? "✅" : "❌"}`)
  );
  console.log(`\n📈 Média geral: ${mediaGeral.toFixed(2)}/5`);
  console.log(`🚦 Gate: ${aprovado ? "✅ APROVADO — build da UI pode avançar" : "❌ REPROVADO — ajustar prompt antes de avançar"}`);

  if (!aprovado) {
    console.log("\n⚠️  O que ajustar no prompt:");
    const pioresRubricas = RUBRICA.map((r, i) => ({
      rubrica: r,
      media: resultados.reduce((s, q) => s + q.notas[i], 0) / resultados.length,
    })).filter((r) => r.media < 3.5);

    pioresRubricas.forEach((r) =>
      console.log(`  → ${r.rubrica.split("?")[0]}: média ${r.media.toFixed(2)}/5`)
    );
  }

  console.log("\n💾 Salve este log e registre no INTELLIGENCE_LEDGER se o gate falhou.");
  process.exit(aprovado ? 0 : 1);
}

// Fallback: gerar diretamente via Claude API (sem Edge Function)
async function gerarDireto() {
  const peso = ["suas","pnas","loas","cras_creas_servicos","lei_distrital_7484","nob_suas","programas_sociais_df","bpc_beneficios"].includes(DISCIPLINA) ? 2 : 1;
  const modelo = peso === 2 ? "claude-sonnet-4-6" : "claude-haiku-4-5-20251001";

  if (!ANTHROPIC_API_KEY) {
    console.error("❌ ANTHROPIC_API_KEY não encontrada. Verifique o arquivo .env");
    process.exit(1);
  }

  console.log(`   Modelo: ${modelo} | Chave: ${ANTHROPIC_API_KEY.substring(0, 20)}...`);

  const resp = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: modelo,
      max_tokens: 8192,
      messages: [{
        role: "user",
        content: `Gere ${QUANTIDADE} questões de concurso público estilo Instituto Quadrix sobre ${DISCIPLINA.toUpperCase()}.
        Múltipla escolha, 5 alternativas, literalidade da lei, distratores plausíveis.
        IMPORTANTE: Retorne APENAS o JSON puro abaixo, sem nenhum texto antes ou depois, sem markdown:
        { "questoes": [{ "enunciado": "...", "alternativas": [{"letra": "A","texto": "...","correta": false},{"letra": "B","texto": "...","correta": false},{"letra": "C","texto": "...","correta": true},{"letra": "D","texto": "...","correta": false},{"letra": "E","texto": "...","correta": false}], "gabarito": "C", "explicacao": "...", "distrator_principal": "troca_competencia", "nivel_dificuldade": 3, "estilo_quadrix": ["literalidade"] }] }`
      }]
    })
  });

  if (!resp.ok) {
    const err = await resp.text();
    console.error("❌ Claude API retornou erro:", resp.status, err);
    process.exit(1);
  }

  const data = await resp.json();
  const texto = data.content?.[0]?.text ?? "{}";

  let parsed;
  try {
    // Extrai JSON pelo primeiro { e último } — funciona com ou sem markdown
    const start = texto.indexOf("{");
    const end = texto.lastIndexOf("}");
    const jsonStr = (start !== -1 && end > start)
      ? texto.slice(start, end + 1)
      : texto.trim();
    parsed = JSON.parse(jsonStr);
  } catch (e) {
    console.error("❌ Falha ao fazer parse do JSON retornado pela API:");
    console.error(texto.substring(0, 500));
    process.exit(1);
  }

  const input = data.usage?.input_tokens ?? 0;
  const output = data.usage?.output_tokens ?? 0;
  const custo = peso === 2
    ? (input * 0.000003 + output * 0.000015)
    : (input * 0.00000025 + output * 0.00000125);

  return { questoes: parsed.questoes ?? [], custo_usd: custo.toFixed(4), modelo_usado: modelo };
}

main().catch((err) => { console.error(err); process.exit(1); });
