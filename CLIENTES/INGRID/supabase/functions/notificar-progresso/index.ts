// notificar-progresso — Edge Function — PROJ-002 Ingrid
// Envia briefing de gestão ao Eduardo via Telegram após cada sessão:
//   - Resumo da sessão (acertos, taxa, pontos)
//   - Análise do dia em relação ao projeto (dias até prova, urgência)
//   - Sugestão de foco + linha pronta para calendário (M-2)
// Deploy: npx supabase functions deploy notificar-progresso --project-ref ehyaecxqijgyuuiorzcj

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const TELEGRAM_BOT_TOKEN = Deno.env.get("TELEGRAM_BOT_TOKEN")!;
const TELEGRAM_CHAT_ID   = Deno.env.get("TELEGRAM_CHAT_ID")!;

// Contexto fixo do projeto Ingrid
const PROVA_DATA    = new Date("2026-09-06T00:00:00-03:00");
const PROJETO_FIM   = new Date("2026-05-30T00:00:00-03:00");
const CLIENTE_NOME  = "Ingrid";

const CORS = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Authorization, Content-Type",
};

function diasAte(data: Date): number {
  const hoje = new Date();
  hoje.setHours(0, 0, 0, 0);
  return Math.ceil((data.getTime() - hoje.getTime()) / 86_400_000);
}

function nomeDisc(id: string): string {
  const nomes: Record<string, string> = {
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
  return nomes[id] ?? id.replace(/_/g, " ");
}

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  try {
    const { sessao_hoje, progresso_semanal, heatmap_top3 } = await req.json();

    const hoje = new Date().toLocaleDateString("pt-BR", {
      timeZone: "America/Sao_Paulo",
      weekday: "short", day: "2-digit", month: "2-digit",
    });

    const diasProva    = diasAte(PROVA_DATA);
    const diasEntrega  = diasAte(PROJETO_FIM);

    // ── SESSÃO ──
    const { acertos, total, pontos } = sessao_hoje ?? {};
    const pct = total > 0 ? Math.round((acertos / total) * 100) : 0;
    const avalSession = pct >= 75 ? "🟢 Boa sessão" : pct >= 50 ? "🟡 Sessão mediana" : "🔴 Sessão fraca";

    // ── SEMANA ──
    const semPct   = progresso_semanal?.taxa_acerto_pct ?? 0;
    const semTotal = progresso_semanal?.total_questoes_semana ?? 0;
    const semTrend = semPct >= 70 ? "▲" : semPct >= 50 ? "→" : "▼";

    // ── FOCO RECOMENDADO ──
    const top = (heatmap_top3 ?? []).filter((d: any) => d.urgencia >= 0.35);
    const focoNome    = top.length > 0 ? nomeDisc(top[0].disciplina_id) : null;
    const focoTaxa    = top.length > 0 ? top[0].taxa_acerto_pct : null;
    const focoInativ  = top.length > 0 ? top[0].dias_sem_atividade : null;

    const focoLinha = focoNome
      ? `📌 *Foco próxima sessão:* ${focoNome} (${focoTaxa}% acerto · ${focoInativ === 0 ? "estudada hoje" : focoInativ + "d sem estudar"})`
      : `📌 Sem disciplina crítica — manter ritmo`;

    // ── LINHA DE CALENDÁRIO (calendário-ready) ──
    const calendarioLinha = focoNome
      ? `🗓 *Calendário:* Agendar revisão de ${focoNome} com ${CLIENTE_NOME} nos próximos 2 dias`
      : `🗓 *Calendário:* ${CLIENTE_NOME} em dia — próxima sessão normal`;

    // ── CONTEXTO DO PROJETO ──
    const projetoLinha = diasEntrega > 0
      ? `📋 Projeto: ${diasEntrega}d até entrega (30/05) · Prova: ${diasProva}d (06/09)`
      : `📋 Projeto ENTREGUE · Prova: ${diasProva}d (06/09)`;

    const msg = [
      `📊 *${CLIENTE_NOME} — ${hoje}*`,
      `${avalSession}: ${acertos}/${total} acertos · ${pct}% · ${pontos} pts`,
      ``,
      `${semTrend} Semana: ${semTotal} questões · ${semPct}% acerto`,
      ``,
      focoLinha,
      ``,
      calendarioLinha,
      ``,
      projetoLinha,
    ].join("\n");

    if (TELEGRAM_BOT_TOKEN && TELEGRAM_CHAT_ID) {
      await fetch(`https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          chat_id:    TELEGRAM_CHAT_ID,
          text:       msg,
          parse_mode: "Markdown",
        }),
      });
    }

    return new Response(JSON.stringify({ ok: true }), {
      headers: { ...CORS, "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { ...CORS, "Content-Type": "application/json" },
    });
  }
});
