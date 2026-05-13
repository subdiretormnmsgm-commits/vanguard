// ============================================================
// KILL-SWITCH — Lei 6 Soberana
// Desabilita busca sem derrubar o app (72h grace period)
// Gerenciado via tabela config no Supabase
// ============================================================

async function isSearchEnabled(supabase) {
  const { data, error } = await supabase
    .from('config')
    .select('value')
    .eq('key', 'search_enabled')
    .single();

  if (error) return true; // fail open — não bloqueia por erro de rede
  return data?.value === 'true';
}

async function isFeatureEnabled(supabase, featureKey) {
  const { data } = await supabase
    .from('config')
    .select('value')
    .eq('key', featureKey)
    .single();

  return data?.value === 'true';
}

// Middleware: bloqueia busca se Kill-Switch ativo
async function killSwitchMiddleware(req, res, next, supabase) {
  const enabled = await isSearchEnabled(supabase);
  if (!enabled) {
    return res.status(503).json({
      error: 'Sistema em manutenção programada.',
      message: 'A busca será reativada em breve. Contate o suporte.'
    });
  }
  next();
}

module.exports = { isSearchEnabled, isFeatureEnabled, killSwitchMiddleware };
