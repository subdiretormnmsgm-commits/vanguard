// embed.js — Netlify Edge Function
// Proxy para Gemini Embedding API — remove GEMINI_KEY do frontend
// Deploy: Netlify env var GEMINI_API_KEY obrigatória

export default async function handler(req) {
  // CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    });
  }

  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 });
  }

  let body;
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: 'JSON inválido' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const { text } = body;
  if (!text || typeof text !== 'string') {
    return new Response(JSON.stringify({ error: 'Campo "text" obrigatório' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const apiKey = Netlify.env.get('GEMINI_API_KEY');
  if (!apiKey) {
    return new Response(JSON.stringify({ error: 'Serviço indisponível' }), {
      status: 503,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const EMBED_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=${apiKey}`;

  let geminiRes;
  try {
    geminiRes = await fetch(EMBED_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'models/gemini-embedding-001',
        content: { parts: [{ text: text.slice(0, 2048) }] },
        taskType: 'RETRIEVAL_QUERY',
        outputDimensionality: 3072,
      }),
    });
  } catch {
    return new Response(JSON.stringify({ error: 'Falha ao contatar Gemini' }), {
      status: 502,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  if (!geminiRes.ok) {
    return new Response(JSON.stringify({ error: 'Gemini retornou erro' }), {
      status: 502,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const data = await geminiRes.json();
  return new Response(JSON.stringify({ embedding: data.embedding.values }), {
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
  });
}

export const config = { path: '/.netlify/functions/embed' };
