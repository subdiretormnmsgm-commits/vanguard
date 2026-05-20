// notificar-progresso — Edge Function — PROJ-002 Ingrid
// Recebe dados da sessão e envia resumo ao Eduardo via Telegram (M-2)
// Dispara automaticamente ao final de cada sessão de Ingrid
// Deploy: npx supabase functions deploy notificar-progresso --project-ref ehyaecxqijgyuuiorzcj

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const TELEGRAM_BOT_TOKEN = Deno.env.get("TELEGRAM_BOT_TOKEN")!;
const TELEGRAM_CHAT_ID   = Deno.env.get("TELEGRAM_CHAT_ID")!;   // ID do Eduardo

const CORS = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Authorization, Content-Type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  try {
    const { sessao_hoje, progresso_semanal, heatmap_top3 } = await req.json();

    const hoje = new Date().toLocaleDateString("pt-BR", {
      timeZone: "America/Sao_Paulo",
      day: "2-digit", month: "2-digit",
    });

    const { acertos, total, pontos } = sessao_hoje ?? {};
    const pct = total > 0 ? Math.round((acertos / total) * 100) : 0;

    // Urgência: disciplinas que mais precisam de atenção
    const urgentes = (heatmap_top3 ?? [])
      .filter((d: any) => d.urgencia >= 0.35)
      .map((d: any) => `  • ${d.disciplina_id.replace(/_/g, " ")} — ${d.taxa_acerto_pct}% acerto`)
      .join("\n");

    // Progresso semanal
    const semana = progresso_semanal
      ? `📅 Semana: ${progresso_semanal.total_questoes_semana} questões · ${progresso_semanal.taxa_acerto_pct}% acerto`
      : "";

    const msg = [
      `📊 *Ingrid estudou hoje (${hoje})*`,
      ``,
      `✅ ${acertos}/${total} acertos · ${pct}% · ${pontos} pts ponderados`,
      semana,
      ``,
      urgentes ? `⚠️ *Focar amanhã:*\n${urgentes}` : `✨ Todas as disciplinas em dia`,
    ].filter(Boolean).join("\n");

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
