// ============================================================
// BURN RATE SHIELD — Lei 5 Soberana
// Rastreia custo diário de tokens Gemini e bloqueia se > limite
// ============================================================

// Gemini embedding-004: $0.000025 por 1K tokens
const COST_PER_1K_EMBED = 0.000025;
// Gemini Pro (síntese futura): $0.00015 por 1K tokens input
const COST_PER_1K_SYNTH = 0.00015;

function calcCost(tokens, operation) {
  const rate = operation === 'synthesize' ? COST_PER_1K_SYNTH : COST_PER_1K_EMBED;
  return (tokens / 1000) * rate;
}

async function getDailyCost(supabase) {
  const today = new Date().toISOString().split('T')[0];
  const { data, error } = await supabase
    .from('daily_cost')
    .select('total_cost_usd')
    .eq('date', today)
    .single();

  if (error || !data) return 0;
  return parseFloat(data.total_cost_usd);
}

async function checkAllowed(supabase) {
  const { data: cfg } = await supabase
    .from('config')
    .select('value')
    .eq('key', 'daily_token_limit_usd')
    .single();

  const limit = parseFloat(cfg?.value || process.env.DAILY_TOKEN_LIMIT_USD || 10);
  const dailyCost = await getDailyCost(supabase);

  return {
    allowed:  dailyCost < limit,
    warning:  dailyCost >= limit * 0.8,   // alerta em 80%
    daily_cost: dailyCost,
    limit,
    remaining: Math.max(0, limit - dailyCost)
  };
}

async function logUsage(supabase, { operation, tokens }) {
  const costUsd = calcCost(tokens, operation);
  await supabase.from('token_usage').insert({
    date:        new Date().toISOString().split('T')[0],
    operation,
    tokens_used: tokens,
    cost_usd:    costUsd
  });
  return costUsd;
}

// Middleware express: bloqueia rota se limite excedido
async function burnRateMiddleware(req, res, next, supabase) {
  const status = await checkAllowed(supabase);
  if (!status.allowed) {
    return res.status(429).json({
      error: 'Limite diário de processamento atingido.',
      reset_at: 'Meia-noite (horário de Brasília)',
      daily_cost_usd: status.daily_cost,
      limit_usd: status.limit
    });
  }
  req.burnRate = status;
  next();
}

module.exports = { checkAllowed, logUsage, burnRateMiddleware, calcCost };
