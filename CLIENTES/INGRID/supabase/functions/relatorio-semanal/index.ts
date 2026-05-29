// relatorio-semanal — Edge Function — PROJ-002 Ingrid
// M-4 + E-3: todo domingo, gera Relatório Semanal personalizado via Claude Haiku
// e envia para Eduardo via Telegram (para repassar ao WhatsApp de Ingrid)
// Deploy: npx supabase functions deploy relatorio-semanal --project-ref yjqvjhezwhepwomukudt

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL         = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const TELEGRAM_BOT_TOKEN   = Deno.env.get("TELEGRAM_BOT_TOKEN")!;
const TELEGRAM_CHAT_ID     = Deno.env.get("TELEGRAM_CHAT_ID")!;
const ANTHROPIC_API_KEY    = Deno.env.get("ANTHROPIC_API_KEY")!;
const USER_ID              = "00000000-0000-0000-0000-000000000001";

const CORS = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Authorization, Content-Type",
};

const NOMES_DISC: Record<string, string> = {
  suas_fundamentos:                "SUAS",
  programas_beneficios_df:         "Programas DF",
  direito_administrativo:          "Dir. Administrativo",
  direito_constitucional:          "Dir. Constitucional",
  arquivologia_rotinas_atendimento:"Arquivologia",
  recursos_materiais_patrimonio:   "Recursos Materiais",
  portugues:                       "Português",
  realidade_df_ride:               "Realidade DF/RIDE",
  lei_organica_df:                 "Lei Orgânica DF",
  lc840:                           "LC 840",
  maria_da_penha:                  "Maria da Penha",
  politica_mulheres:               "Pol. Mulheres",
  primeiros_socorros:              "Primeiros Socorros",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  try {
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

    // 1. Buscar progresso semanal
    const { data: semana, error: errSem } = await supabase.rpc("get_progresso_semanal", {
      p_user_id: USER_ID,
    });
    if (errSem) throw errSem;

    // 2. Buscar heatmap de disciplinas
    const { data: heatmap, error: errHeat } = await supabase.rpc("get_heatmap_disciplinas", {
      p_user_id: USER_ID,
    });
    if (errHeat) throw errHeat;

    const totalQuestoes = semana?.total_questoes_semana ?? 0;
    const taxaAcerto    = semana?.taxa_acerto_pct ?? 0;
    const discForte     = NOMES_DISC[semana?.disciplina_mais_forte] ?? semana?.disciplina_mais_forte ?? "—";
    const discFraca     = NOMES_DISC[semana?.disciplina_mais_fraca] ?? semana?.disciplina_mais_fraca ?? "—";

    // Dias de estudo (sessões únicas por dia na semana)
    const { data: sessoes } = await supabase
      .from("sessoes_usuario")
      .select("iniciada_em")
      .eq("user_id", USER_ID)
      .gte("iniciada_em", new Date(Date.now() - 7 * 86_400_000).toISOString());

    const diasUnicos = new Set(
      (sessoes ?? []).map((s: any) =>
        new Date(s.iniciada_em).toLocaleDateString("pt-BR", { timeZone: "America/Sao_Paulo" })
      )
    ).size;

    // 3. Semanas até a prova
    const prova     = new Date("2026-09-06T00:00:00-03:00");
    const semanasRestantes = Math.ceil((prova.getTime() - Date.now()) / (7 * 86_400_000));

    // 4. Gerar texto via Claude Haiku
    const promptContexto = [
      `Você é um assistente de estudos conciso. Escreva um relatório semanal de 4 linhas para Ingrid,`,
      `uma candidata de concurso público que estuda pelo app de questões da Vanguard.`,
      `Tom: encorajador, direto, sem exagero.`,
      ``,
      `Dados da semana:`,
      `- Questões respondidas: ${totalQuestoes}`,
      `- Taxa de acerto: ${taxaAcerto}%`,
      `- Dias de estudo: ${diasUnicos}/7`,
      `- Disciplina mais forte: ${discForte}`,
      `- Disciplina mais fraca: ${discFraca}`,
      `- Semanas restantes até a prova (06/09/2026): ${semanasRestantes}`,
      ``,
      `Formato obrigatório (max 4 linhas, sem emojis excessivos):`,
      `Linha 1: resumo numérico da semana`,
      `Linha 2: ponto forte`,
      `Linha 3: ponto a melhorar`,
      `Linha 4: motivação curta para a próxima semana`,
    ].join("\n");

    const claudeRes = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "x-api-key":         ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
        "Content-Type":      "application/json",
      },
      body: JSON.stringify({
        model:      "claude-haiku-4-5-20251001",
        max_tokens: 200,
        messages:   [{ role: "user", content: promptContexto }],
      }),
    });

    const claudeJson  = await claudeRes.json();
    const textoGerado = claudeJson?.content?.[0]?.text ?? "Relatório indisponível esta semana.";

    // 5. Montar e enviar mensagem ao Eduardo
    const dataHoje = new Date().toLocaleDateString("pt-BR", {
      timeZone: "America/Sao_Paulo",
      weekday: "long", day: "2-digit", month: "2-digit",
    });

    const msg = [
      `📊 *Relatório Semanal — Ingrid (${dataHoje})*`,
      ``,
      textoGerado,
      ``,
      `─────────────────────`,
      `📌 *Dados brutos:*`,
      `${totalQuestoes} questões · ${taxaAcerto}% acerto · ${diasUnicos}/7 dias`,
      `💪 Forte: ${discForte} · ⚠️ Fraca: ${discFraca}`,
      `⏳ ${semanasRestantes} semanas até 06/09/2026`,
      ``,
      `🎯 *Domingo de estudo!* Abra o app e faça o Micro-Simulado de 10 questões cronometradas.`,
      ``,
      `_Copie e envie para Ingrid no WhatsApp._`,
    ].join("\n");

    await fetch(`https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        chat_id:    TELEGRAM_CHAT_ID,
        text:       msg,
        parse_mode: "Markdown",
      }),
    });

    return new Response(
      JSON.stringify({ ok: true, total_questoes: totalQuestoes, taxa_acerto: taxaAcerto }),
      { headers: { ...CORS, "Content-Type": "application/json" } }
    );

  } catch (err) {
    return new Response(
      JSON.stringify({ error: String(err) }),
      { status: 500, headers: { ...CORS, "Content-Type": "application/json" } }
    );
  }
});
