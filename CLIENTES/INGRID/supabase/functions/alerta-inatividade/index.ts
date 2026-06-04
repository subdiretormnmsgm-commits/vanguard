// alerta-inatividade -- Edge Function -- F-E Loop 8 -- PROJ-002 Ingrid
// Alerta Compound Telegram: 3 dias sem sessao ou sem evento_uso = Eduardo avisado
// Cron: rodar diariamente (ex: 08:00 UTC via pg_cron ou Supabase Cron)
// Deploy: npx supabase functions deploy alerta-inatividade --project-ref yjqvjhezwhepwomukudt

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL         = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const TELEGRAM_BOT_TOKEN   = Deno.env.get("TELEGRAM_BOT_TOKEN")!;
const TELEGRAM_CHAT_ID     = Deno.env.get("TELEGRAM_CHAT_ID")!;
const USER_ID              = "00000000-0000-0000-0000-000000000001";
const DIAS_LIMITE          = 3; // alerta apos N dias sem atividade

const CORS = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Authorization, Content-Type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });

  try {
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

    // 1. Ultima atividade: checar evento_uso (F-A) OU sessoes_usuario
    const limiteISO = new Date(
      Date.now() - DIAS_LIMITE * 24 * 60 * 60 * 1000
    ).toISOString();

    // Checar evento_uso (mais granular -- inclui sessoes offline-first)
    const { data: eventosRecentes, error: errEvt } = await supabase
      .from("evento_uso")
      .select("criado_em")
      .eq("user_id", USER_ID)
      .gte("criado_em", limiteISO)
      .limit(1);

    if (errEvt) {
      // Fallback: checar sessoes_usuario
      const { data: sessoesRecentes } = await supabase
        .from("sessoes_usuario")
        .select("criado_em")
        .eq("user_id", USER_ID)
        .gte("criado_em", limiteISO)
        .limit(1);

      if (sessoesRecentes && sessoesRecentes.length > 0) {
        return new Response(JSON.stringify({ alerta: false, motivo: "sessao_recente" }), {
          headers: { ...CORS, "Content-Type": "application/json" },
        });
      }
    } else if (eventosRecentes && eventosRecentes.length > 0) {
      return new Response(JSON.stringify({ alerta: false, motivo: "evento_recente" }), {
        headers: { ...CORS, "Content-Type": "application/json" },
      });
    }

    // 2. Nenhuma atividade nos ultimos N dias: calcular dias exatos
    const { data: ultimoEvento } = await supabase
      .from("evento_uso")
      .select("criado_em")
      .eq("user_id", USER_ID)
      .order("criado_em", { ascending: false })
      .limit(1);

    const ultimaAtividade = ultimoEvento?.[0]?.criado_em;
    const diasSemUso = ultimaAtividade
      ? Math.floor((Date.now() - new Date(ultimaAtividade).getTime()) / 86400000)
      : DIAS_LIMITE;

    // 3. Enviar alerta ao Eduardo via Telegram
    const mensagem =
      `⚠️ CHURN-WATCH — INGRID\n` +
      `${diasSemUso} dias sem atividade detectada.\n` +
      `Ultima sessao: ${ultimaAtividade ? new Date(ultimaAtividade).toLocaleDateString("pt-BR") : "desconhecida"}\n` +
      `\n` +
      `Acao sugerida: enviar mensagem humana (nao automatica).\n` +
      `Texto: "Ingrid, o sistema me avisou que voce tem estudado. Como voce esta se sentindo em relacao a prova agora?"`;

    const telegramRes = await fetch(
      `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          chat_id: TELEGRAM_CHAT_ID,
          text: mensagem,
        }),
      }
    );

    const telegramOk = telegramRes.ok;

    return new Response(
      JSON.stringify({
        alerta: true,
        dias_sem_uso: diasSemUso,
        telegram_enviado: telegramOk,
      }),
      { headers: { ...CORS, "Content-Type": "application/json" } }
    );

  } catch (err) {
    return new Response(
      JSON.stringify({ error: String(err) }),
      { status: 500, headers: { ...CORS, "Content-Type": "application/json" } }
    );
  }
});
