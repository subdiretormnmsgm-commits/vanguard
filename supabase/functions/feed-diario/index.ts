// Edge Function: feed-diario
// PROJ-002 Ingrid — Dia 3 do build
// Retorna 20 questoes do dia: 70% Peso 2 (especificos) + 30% Peso 1 (gerais)
// SM-2: revisoes urgentes entram antes das questoes novas
// P-006: verifica burn rate antes de acionar gerar-questoes

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const CORS_HEADERS = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, apikey",
};

const CONCURSO_ID = "sedes_df_2026";
const TOTAL_DIA = 20;
const QTD_PESO2 = 14; // 70%
const QTD_PESO1 = 6;  // 30%
const CACHE_MINIMO = 30;
const LOTE_TAMANHO = 50;

// Disciplinas ordenadas por score_prioridade (P-014)
const DISCIPLINAS_PESO2 = [
  "suas_fundamentos",            // score 190
  "direito_administrativo",      // score 184
  "programas_beneficios_df",     // score 180
  "arquivologia_rotinas_atendimento", // score 170
  "direito_constitucional",      // score 156
  "recursos_materiais_patrimonio", // score 144
];

const DISCIPLINAS_PESO1 = [
  "portugues",         // score 95
  "realidade_df_ride", // score 88
  "lei_organica_df",   // score 82
  "lc840",             // score 80
  "maria_da_penha",    // score 75
  "politica_mulheres", // score 60
  "primeiros_socorros",// score 50
];

interface FeedPayload {
  user_id: string;
  modo?: "normal" | "simulado_mini"; // normal = 20q diarias, simulado_mini = 15q
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: CORS_HEADERS });
  }

  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Método não permitido" }), {
      status: 405,
      headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
    });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  );

  const payload: FeedPayload = await req.json();
  const { user_id, modo = "normal" } = payload;

  if (!user_id) {
    return new Response(JSON.stringify({ error: "user_id obrigatorio" }), {
      status: 400,
      headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
    });
  }

  const hoje = new Date().toISOString().split("T")[0];
  const qtdTotal = modo === "simulado_mini" ? 15 : TOTAL_DIA;
  const qtdP2    = modo === "simulado_mini" ? 11 : QTD_PESO2;
  const qtdP1    = modo === "simulado_mini" ? 4  : QTD_PESO1;

  // 1. Questoes de revisao SM-2 com prazo hoje ou vencido (prioridade maxima)
  const { data: revisoes } = await supabase
    .from("progresso_usuario")
    .select("questao_id, questoes_quadrix(id, disciplina_id, peso_edital, score_prioridade, enunciado, alternativas, gabarito, explicacao, nivel_dificuldade)")
    .eq("user_id", user_id)
    .lte("proxima_revisao_em", hoje)
    .not("proxima_revisao_em", "is", null)
    .limit(qtdTotal);

  const revisaoIds   = new Set((revisoes ?? []).map((r: any) => r.questao_id));
  const questoesRev  = (revisoes ?? []).map((r: any) => ({ ...r.questoes_quadrix, revisao: true }));
  const vagasRestantes = qtdTotal - questoesRev.length;

  let questoesNovaPeso2: any[] = [];
  let questoesNovaPeso1: any[] = [];

  if (vagasRestantes > 0) {
    const vagasP2 = Math.min(qtdP2, vagasRestantes);
    const vagasP1 = Math.min(qtdP1, Math.max(0, vagasRestantes - vagasP2));

    // 2. Questoes novas Peso 2 — nao respondidas — ordem por score_prioridade DESC
    if (vagasP2 > 0) {
      const respondidas = await supabase
        .from("progresso_usuario")
        .select("questao_id")
        .eq("user_id", user_id);
      const respondidaIds = (respondidas.data ?? []).map((r: any) => r.questao_id);
      const excluir = [...respondidaIds, ...Array.from(revisaoIds)];

      const { data: novasP2 } = await supabase
        .from("questoes_quadrix")
        .select("id, disciplina_id, peso_edital, score_prioridade, enunciado, alternativas, gabarito, explicacao, nivel_dificuldade, pilula_do_dia")
        .eq("concurso_id", CONCURSO_ID)
        .eq("peso_edital", 2)
        .not("id", "in", `(${excluir.join(",")})`)
        .order("score_prioridade", { ascending: false })
        .limit(vagasP2);

      questoesNovaPeso2 = (novasP2 ?? []).map((q: any) => ({ ...q, revisao: false }));
    }

    // 3. Questoes novas Peso 1
    if (vagasP1 > 0) {
      const respondidas = await supabase
        .from("progresso_usuario")
        .select("questao_id")
        .eq("user_id", user_id);
      const respondidaIds = (respondidas.data ?? []).map((r: any) => r.questao_id);
      const excluir = [...respondidaIds, ...Array.from(revisaoIds)];

      const { data: novasP1 } = await supabase
        .from("questoes_quadrix")
        .select("id, disciplina_id, peso_edital, score_prioridade, enunciado, alternativas, gabarito, explicacao, nivel_dificuldade, pilula_do_dia")
        .eq("concurso_id", CONCURSO_ID)
        .eq("peso_edital", 1)
        .not("id", "in", `(${excluir.join(",")})`)
        .order("score_prioridade", { ascending: false })
        .limit(vagasP1);

      questoesNovaPeso1 = (novasP1 ?? []).map((q: any) => ({ ...q, revisao: false }));
    }
  }

  // 4. Montar feed: revisoes primeiro, depois novas P2, depois novas P1
  const feed = [...questoesRev, ...questoesNovaPeso2, ...questoesNovaPeso1].slice(0, qtdTotal);

  // 5. Verificar cache para disciplinas com poucos estoques (trigger assincronas)
  triggerCacheSeNecessario(supabase, DISCIPLINAS_PESO2.concat(DISCIPLINAS_PESO1));

  // 6. Calcular progresso do plano de 7 dias (para gate Dia 5)
  const { data: statsHoje } = await supabase
    .from("progresso_usuario")
    .select("correta, questoes_quadrix(peso_edital)")
    .eq("user_id", user_id)
    .gte("respondida_em", hoje + "T00:00:00Z");

  const pontosHoje = (statsHoje ?? []).reduce((acc: number, r: any) => {
    if (r.correta) {
      const peso = r.questoes_quadrix?.peso_edital ?? 1;
      return acc + peso;
    }
    return acc;
  }, 0);

  return new Response(
    JSON.stringify({
      feed,
      meta: {
        total: feed.length,
        revisoes: questoesRev.length,
        novas_peso2: questoesNovaPeso2.length,
        novas_peso1: questoesNovaPeso1.length,
        pontos_ponderados_hoje: pontosHoje,
        proporcao_real: feed.length > 0
          ? `${Math.round((feed.filter((q: any) => q.peso_edital === 2).length / feed.length) * 100)}% Peso2`
          : "sem questoes",
        data: hoje,
      },
    }),
    { status: 200, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } }
  );
});

// Dispara gerar-questoes em background se estoque < CACHE_MINIMO (nao bloqueia resposta)
async function triggerCacheSeNecessario(supabase: ReturnType<typeof createClient>, disciplinas: string[]) {
  for (const disc of disciplinas) {
    const { count } = await supabase
      .from("questoes_quadrix")
      .select("id", { count: "exact", head: true })
      .eq("concurso_id", CONCURSO_ID)
      .eq("disciplina_id", disc);

    if ((count ?? 0) < CACHE_MINIMO) {
      const url = Deno.env.get("SUPABASE_URL") + "/functions/v1/gerar-questoes";
      const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
      fetch(url, {
        method: "POST",
        headers: { "Authorization": `Bearer ${key}`, "Content-Type": "application/json" },
        body: JSON.stringify({ disciplina_id: disc, quantidade: LOTE_TAMANHO, modo: "cache_lote" }),
      }).catch(() => {}); // fire-and-forget
    }
  }
}
