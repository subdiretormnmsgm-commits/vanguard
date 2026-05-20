// notificar-progresso — Edge Function — PROJ-002 Ingrid
// Envia briefing de gestão ao Eduardo via Telegram após cada sessão:
//   - Resumo da sessão (acertos, taxa, pontos)
//   - Foco de coaching para Ingrid (disciplina mais urgente)
//   - Calendário do projeto: dia atual, próximo gate, deadline
// Deploy: npx supabase functions deploy notificar-progresso --project-ref ehyaecxqijgyuuiorzcj

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const TELEGRAM_BOT_TOKEN = Deno.env.get("TELEGRAM_BOT_TOKEN")!;
const TELEGRAM_CHAT_ID   = Deno.env.get("TELEGRAM_CHAT_ID")!;

// Contexto fixo do projeto Ingrid — atualizar ao mudar gate ou prazo
const PROVA_DATA   = new Date("2026-09-06T00:00:00-03:00");
const PROJETO_FIM  = new Date("2026-05-30T00:00:00-03:00");
const BUILD_INICIO = new Date("2026-05-15T00:00:00-03:00");
const CLIENTE_NOME = "Ingrid";

// Calendário de gates do projeto (dia de build → data alvo → descrição)
const GATES = [
  { dia: 2,  data: "16/05", desc: "Qualidade das questões",          status: "✅" },
  { dia: 5,  data: "17/05", desc: "Feed 70/30 · SM-2 · 7 dias",      status: "✅" },
  { dia: 8,  data: "19/05", desc: "PWA completo · Tutor · Fallback",  status: "✅" },
  { dia: 11, data: "22/05", desc: "Heatmap + Micro-Simulado",         status: "✅" },
  { dia: 13, data: "24/05", desc: "Pontos Ponderados + Push domingo", status: "🔜" },
  { dia: 15, data: "30/05", desc: "Entrega final + SaaS Readiness",   status: "⬜" },
];

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
    const { sessao_hoje, progresso_semanal, heatmap_top3, dia_build } = await req.json();

    const hoje = new Date().toLocaleDateString("pt-BR", {
      timeZone: "America/Sao_Paulo",
      weekday: "short", day: "2-digit", month: "2-digit",
    });

    const diasProva   = diasAte(PROVA_DATA);
    const diasEntrega = diasAte(PROJETO_FIM);

    // ── SESSÃO ──
    const { acertos, total, pontos } = sessao_hoje ?? {};
    const pct = total > 0 ? Math.round((acertos / total) * 100) : 0;
    const avalSession = pct >= 75 ? "🟢 Boa sessão" : pct >= 50 ? "🟡 Sessão mediana" : "🔴 Sessão fraca";

    // ── SEMANA ──
    const semPct   = progresso_semanal?.taxa_acerto_pct ?? 0;
    const semTotal = progresso_semanal?.total_questoes_semana ?? 0;
    const semTrend = semPct >= 70 ? "▲" : semPct >= 50 ? "→" : "▼";

    // ── FOCO DE COACHING ──
    const top = (heatmap_top3 ?? []).filter((d: any) => d.urgencia >= 0.35);
    const focoNome = top.length > 0 ? nomeDisc(top[0].disciplina_id) : null;
    const focoTaxa = top.length > 0 ? top[0].taxa_acerto_pct : null;
    const focoLinha = focoNome
      ? `👩‍💼 *Coaching:* Ingrid precisa de ${focoNome} (${focoTaxa}% acerto)`
      : `👩‍💼 *Coaching:* Ingrid em dia — manter ritmo`;

    // ── CALENDÁRIO DO PROJETO ──
    // Dia de build atual: passado pelo frontend ou calculado pela data
    const diaAtual = dia_build ?? (() => {
      const diffMs  = new Date().getTime() - BUILD_INICIO.getTime();
      const diffDias = Math.ceil(diffMs / 86_400_000);
      return Math.min(Math.max(diffDias, 1), 15);
    })();

    const proximoGate = GATES.find((g) => g.status === "🔜");
    const diasGate    = proximoGate
      ? diasAte(new Date(`2026-${proximoGate.data.split("/").reverse().join("-")}T00:00:00-03:00`))
      : null;

    const calendarioBloco = [
      `📅 *Calendário do Projeto*`,
      `Dia ${diaAtual}/15 · ${diasEntrega > 0 ? diasEntrega + "d até entrega" : "ENTREGUE"} · Prova em ${diasProva}d`,
      proximoGate
        ? `⏰ Próx. gate: Dia ${proximoGate.dia} (${proximoGate.data}) — ${proximoGate.desc}${diasGate !== null ? ` · ${diasGate}d` : ""}`
        : `✅ Todos os gates concluídos`,
    ].join("\n");

    const msg = [
      `📊 *${CLIENTE_NOME} — ${hoje}*`,
      `${avalSession}: ${acertos}/${total} acertos · ${pct}% · ${pontos} pts`,
      ``,
      `${semTrend} Semana: ${semTotal} questões · ${semPct}% acerto`,
      ``,
      focoLinha,
      ``,
      calendarioBloco,
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
