// embed.js — Netlify Serverless Function
// Proxy para Gemini Embedding API — GEMINI_API_KEY fica server-side
// Variável de ambiente obrigatória: GEMINI_API_KEY (Netlify Dashboard)

// Expansão lexical de termos penais — melhora recall sem custo de API
const SINONIMOS = {
  'prisao preventiva':   'prisão preventiva cautelar medida restritiva liberdade prisão provisória',
  'prisão preventiva':   'prisão preventiva cautelar medida restritiva liberdade prisão provisória',
  'habeas corpus':       'habeas corpus liberdade locomoção writ coação constrangimento ilegal',
  'hc ':                 'habeas corpus liberdade locomoção writ',
  'nulidade':            'nulidade processual invalidade ato processual vício cerceamento defesa',
  'flagrante':           'prisão em flagrante delito ilegal relaxamento',
  'trafico':             'tráfico drogas entorpecentes Lei 11.343 narcotráfico',
  'tráfico':             'tráfico drogas entorpecentes Lei 11.343 narcotráfico',
  'peculato':            'peculato apropriação indébita crime funcional funcionário público',
  'corrupcao':           'corrupção passiva ativa suborno propina crime funcional',
  'corrupção':           'corrupção passiva ativa suborno propina crime funcional',
  'roubo':               'roubo furto qualificado patrimônio violência grave ameaça',
  'homicidio':           'homicídio doloso culposo crime vida júri plenário',
  'homicídio':           'homicídio doloso culposo crime vida júri plenário',
  'dosimetria':          'dosimetria pena fixação aplicação sanção circunstâncias judiciais',
  'revisao criminal':    'revisão criminal rescisória condenação injusta absolvição',
  'revisão criminal':    'revisão criminal rescisória condenação injusta absolvição',
  'execucao penal':      'execução penal pena cumprimento regime progressão remição',
  'execução penal':      'execução penal pena cumprimento regime progressão remição',
  'excesso de prazo':    'excesso prazo constrangimento ilegal prisão provisória razoável duração',
  'lavagem':             'lavagem dinheiro ocultação dissimulação produtos crime Lei 9.613',
  'estelionato':         'estelionato fraude engano vantagem ilícita prejuízo alheio',
  'legitima defesa':     'legítima defesa excludente ilicitude proporcionalidade moderação',
  'legítima defesa':     'legítima defesa excludente ilicitude proporcionalidade moderação',
  'reincidencia':        'reincidência agravante pena antecedentes criminais',
  'reincidência':        'reincidência agravante pena antecedentes criminais',
  'concurso de crimes':  'concurso material formal continuado exasperação cumulação penas',
};

function expandQuery(text) {
  const lower = text.toLowerCase();
  const added = new Set();
  for (const [term, expansion] of Object.entries(SINONIMOS)) {
    if (lower.includes(term) && !added.has(expansion)) {
      added.add(expansion);
    }
  }
  if (!added.size) return text;
  return `${text} ${[...added].join(' ')}`.slice(0, 2048);
}

exports.handler = async function (event) {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };

  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 200, headers: corsHeaders, body: '' };
  }

  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, headers: corsHeaders, body: 'Method not allowed' };
  }

  let body;
  try {
    body = JSON.parse(event.body);
  } catch {
    return {
      statusCode: 400,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: 'JSON inválido' }),
    };
  }

  const { text } = body;
  if (!text || typeof text !== 'string') {
    return {
      statusCode: 400,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: 'Campo "text" obrigatório' }),
    };
  }

  const expandedText = expandQuery(text);

  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    return {
      statusCode: 503,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: 'Serviço indisponível' }),
    };
  }

  const EMBED_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=${apiKey}`;

  let geminiRes;
  try {
    geminiRes = await fetch(EMBED_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'models/gemini-embedding-001',
        content: { parts: [{ text: expandedText }] },
        taskType: 'RETRIEVAL_QUERY',
        outputDimensionality: 3072,
      }),
    });
  } catch (err) {
    return {
      statusCode: 502,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: 'Falha ao contatar Gemini' }),
    };
  }

  if (!geminiRes.ok) {
    const detail = await geminiRes.text().catch(() => '');
    return {
      statusCode: 502,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: 'Gemini retornou erro', detail }),
    };
  }

  const data = await geminiRes.json();
  return {
    statusCode: 200,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    body: JSON.stringify({ embedding: data.embedding.values }),
  };
};
