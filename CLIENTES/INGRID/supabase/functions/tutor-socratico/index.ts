// tutor-socratico — Edge Function — PROJ-002 Ingrid
// Tutor Socrático 3 níveis com cache bidimensional (P-006)
// Nível 1: conceito da alternativa correta
// Nível 2: ataca o distrator específico escolhido
// Nível 3: analogia com a vida cotidiana
// Deploy: npx supabase functions deploy tutor-socratico --project-ref ehyaecxqijgyuuiorzcj

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const SUPABASE_URL      = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE_KEY  = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY")!;

const CORS = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Authorization, Content-Type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { headers: CORS });
  if (req.method !== "POST")    return new Response("Method Not Allowed", { status: 405 });

  let body: {
    user_id:       string;
    questao_id:    string;
    enunciado:     string;
    gabarito:      string;
    distrator:     string;
    disciplina:    string;
    nivel:         number;
    force_refresh: boolean;
  };

  try {
    body = await req.json();
  } catch {
    return json({ error: "JSON inválido" }, 400);
  }

  const { questao_id, enunciado, gabarito, distrator, disciplina, nivel, force_refresh } = body;

  if (!questao_id || !enunciado || !gabarito || nivel < 1 || nivel > 3) {
    return json({ error: "Parâmetros inválidos" }, 400);
  }

  // Chave de cache: nível 2 inclui o distrator, outros não
  const distratorCache = nivel === 2 ? (distrator ?? "") : "";

  // 1. Checar cache (ignorar se force_refresh = admin mode)
  if (!force_refresh) {
    const cacheCheck = await supabaseFetch(
      `rest/v1/explicacao_tutor?questao_id=eq.${questao_id}&nivel=eq.${nivel}&distrator=eq.${encodeURIComponent(distratorCache)}&limit=1&select=explicacao`
    );
    const cache = await cacheCheck.json();
    if (cache.length > 0) {
      return json({ explicacao: cache[0].explicacao, cache: true });
    }
  }

  // 2. Prompt por nível
  const nomeDisc = disciplina.replace(/_/g, " ");
  let userMessage = "";

  if (nivel === 1) {
    userMessage =
      `Questão de ${nomeDisc}:\n${enunciado}\n\n` +
      `A resposta correta é a alternativa ${gabarito}.\n\n` +
      `Explique em 2-3 frases curtas por que ${gabarito} está correta. ` +
      `Sem introdução, sem "Vamos ver", direto ao ponto.`;
  } else if (nivel === 2) {
    userMessage =
      `Questão de ${nomeDisc}:\n${enunciado}\n\n` +
      `Resposta correta: ${gabarito}. A candidata escolheu: ${distrator}.\n\n` +
      `Em 2-3 frases, explique exatamente por que ${distrator} está errada e ` +
      `por que ${gabarito} está certa. Seja específico sobre o erro conceitual.`;
  } else {
    userMessage =
      `Questão de ${nomeDisc}:\n${enunciado}\n\n` +
      `Resposta correta: ${gabarito}.\n\n` +
      `Crie uma analogia simples com a vida cotidiana (máximo 3 frases) ` +
      `que ajude a memorizar por que ${gabarito} é a correta. ` +
      `Use algo do dia a dia: trabalho, casa, ônibus, supermercado.`;
  }

  // 3. Chamar Claude Haiku
  let explicacao = "";
  try {
    const response = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "x-api-key":         ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
        "content-type":      "application/json",
      },
      body: JSON.stringify({
        model:      "claude-haiku-4-5-20251001",
        max_tokens: 280,
        system:
          "Você é um servidor público concursado com 15 anos de experiência, " +
          "agora ajudando uma candidata a passar no concurso. " +
          "Seja direto, austero, acredite no aluno. " +
          "Não comece com 'Vamos analisar', 'Excelente questão' ou qualquer frase AI-fria. " +
          "Responda como um profissional que sabe muito e tem pouco tempo.",
        messages: [{ role: "user", content: userMessage }],
      }),
    });

    if (!response.ok) {
      console.error("Anthropic error:", response.status, await response.text());
      throw new Error("API Anthropic falhou");
    }

    const msg = await response.json();
    if (msg.content?.[0]?.type === "text") {
      explicacao = msg.content[0].text.trim();
    }
  } catch (err) {
    console.error("Tutor error:", err);
    return json({ error: "Erro ao gerar explicação", cache: false }, 502);
  }

  // 4. Gravar no cache
  supabaseFetch("rest/v1/explicacao_tutor", "POST", {
    questao_id,
    nivel,
    distrator:  distratorCache,
    explicacao,
  }).catch(() => {});

  return json({ explicacao, cache: false });
});

// ── Helpers ───────────────────────────────────────────────────────────────────
function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS, "Content-Type": "application/json" },
  });
}

async function supabaseFetch(path: string, method = "GET", body?: unknown) {
  const headers: Record<string, string> = {
    apikey:         SERVICE_ROLE_KEY,
    Authorization:  `Bearer ${SERVICE_ROLE_KEY}`,
  };

  if (body) {
    headers["Content-Type"] = "application/json";
    headers["Prefer"]       = "return=minimal";
  }

  return fetch(`${SUPABASE_URL}/${path}`, {
    method,
    headers,
    body: body ? JSON.stringify(body) : undefined,
  });
}
