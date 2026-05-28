// gatilho-temporal — Edge Function — PROJ-002 Ingrid
// N-1: dispara às 19h45 BRT via pg_cron (22h45 UTC)
// Se Ingrid não estudou hoje → envia lembrete via Telegram (WhatsApp template)
// Deploy: npx supabase functions deploy gatilho-temporal --project-ref yjqvjhezwhepwomukudt

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL            = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_KEY    = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const TELEGRAM_BOT_TOKEN      = Deno.env.get("TELEGRAM_BOT_TOKEN")!;
const TELEGRAM_CHAT_ID        = Deno.env.get("TELEGRAM_CHAT_ID")!;
const USER_ID                 = "00000000-0000-0000-0000-000000000001";

const CORS = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Authorization, Content-Type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  try {
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

    // Verificar se Ingrid já teve sessão hoje (fuso BRT = UTC-3)
    const hoje = new Date();
    const inicioBRT = new Date(Date.UTC(
      hoje.getUTCFullYear(),
      hoje.getUTCMonth(),
      hoje.getUTCDate(),
      3, 0, 0  // 00h00 BRT = 03h00 UTC
    ));
    const fimBRT = new Date(inicioBRT.getTime() + 86_400_000); // próxima meia-noite BRT

    const { data: sessoes, error } = await supabase
      .from("sessoes_usuario")
      .select("id")
      .eq("user_id", USER_ID)
      .gte("iniciada_em", inicioBRT.toISOString())
      .lt("iniciada_em", fimBRT.toISOString())
      .limit(1);

    if (error) throw error;

    if (sessoes && sessoes.length > 0) {
      // Ingrid já estudou hoje — sem lembrete
      return new Response(
        JSON.stringify({ ok: true, acao: "nenhuma", motivo: "sessao_encontrada" }),
        { headers: { ...CORS, "Content-Type": "application/json" } }
      );
    }

    // Ingrid não estudou hoje → enviar lembrete
    const msg = [
      "📚 *Ingrid — 19h45*",
      "",
      "Suas questões de hoje ainda estão esperando.",
      "Só 15 minutos já fazem diferença na semana da prova.",
      "",
      "👉 Acesse agora e marque mais um dia de treino.",
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
      JSON.stringify({ ok: true, acao: "lembrete_enviado" }),
      { headers: { ...CORS, "Content-Type": "application/json" } }
    );

  } catch (err) {
    return new Response(
      JSON.stringify({ error: String(err) }),
      { status: 500, headers: { ...CORS, "Content-Type": "application/json" } }
    );
  }
});
