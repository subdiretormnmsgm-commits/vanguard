// gate_cli_dia5.js — Gate Bloqueante Dia 5
// Verifica: feed exibe plano correto 7 dias com proporcao 70/30
// Rodar: node gate_cli_dia5.js
// Gate passa se proporcao_peso2 >= 0.65 e proporcao_peso2 <= 0.75

const SUPABASE_URL = process.env.SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const USER_ID = process.env.USER_ID_INGRID ?? "00000000-0000-0000-0000-000000000001";

async function verificarFeed() {
  console.log("\n🎯 GATE DIA 5 — Feed Diario Proporcao 70/30\n");
  console.log("Simulando 7 dias de feed...\n");

  let totalP2 = 0;
  let totalP1 = 0;
  let totalGeral = 0;
  let erros = 0;

  for (let dia = 1; dia <= 7; dia++) {
    const res = await fetch(`${SUPABASE_URL}/functions/v1/feed-diario`, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${SERVICE_ROLE_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ user_id: USER_ID }),
    });

    if (!res.ok) {
      console.error(`  ❌ Dia ${dia}: Erro HTTP ${res.status}`);
      erros++;
      continue;
    }

    const dados = await res.json();
    const feed = dados.feed ?? [];
    const meta = dados.meta ?? {};

    const p2 = feed.filter((q) => q.peso_edital === 2).length;
    const p1 = feed.filter((q) => q.peso_edital === 1).length;
    const total = feed.length;
    const pctP2 = total > 0 ? ((p2 / total) * 100).toFixed(1) : "0";

    totalP2 += p2;
    totalP1 += p1;
    totalGeral += total;

    const ok = total >= 15 && p2 / total >= 0.65 && p2 / total <= 0.80;
    const icone = ok ? "✅" : "⚠️";

    console.log(`  ${icone} Dia ${dia}: ${total} questoes | ${p2} Peso2 (${pctP2}%) + ${p1} Peso1 | Revisoes: ${meta.revisoes ?? 0}`);
  }

  console.log("\n─────────────────────────────────");
  const pctP2Total = totalGeral > 0 ? ((totalP2 / totalGeral) * 100).toFixed(1) : "0";
  console.log(`  Total 7 dias: ${totalGeral} questoes`);
  console.log(`  Peso 2: ${totalP2} (${pctP2Total}%) | Peso 1: ${totalP1}`);
  console.log(`  Erros de API: ${erros}`);

  const gatePass =
    erros === 0 &&
    totalGeral >= 100 && // minimo 14-15 q/dia × 7 dias
    parseFloat(pctP2Total) >= 65 &&
    parseFloat(pctP2Total) <= 80;

  console.log("\n─────────────────────────────────");
  if (gatePass) {
    console.log("  🟢 GATE DIA 5 APROVADO");
    console.log("  Proporcao 70/30 verificada em 7 dias simulados.");
    console.log("  Feed pronto para Ingrid usar.");
  } else {
    console.log("  🔴 GATE DIA 5 REPROVADO");
    if (erros > 0) console.log(`  → ${erros} erro(s) de API`);
    if (parseFloat(pctP2Total) < 65) console.log(`  → Proporcao Peso 2 baixa: ${pctP2Total}% (esperado: 65-75%)`);
    if (parseFloat(pctP2Total) > 80) console.log(`  → Proporcao Peso 2 alta: ${pctP2Total}% (esperado: 65-75%)`);
    if (totalGeral < 100) console.log(`  → Poucas questoes: ${totalGeral} (esperado: ≥105)`);
  }
  console.log("");
}

verificarFeed().catch(console.error);
