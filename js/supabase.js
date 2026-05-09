// Substitua os placeholders depois de criar o projecto no Supabase
const SUPABASE_URL      = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';

const supabaseClient = (() => {
  const client = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

  async function saveLeadDiagnostico({ nicho, gargalo, nome, whatsapp }) {
    const { error } = await client
      .from('leads_diagnostico')
      .insert([{ nicho, gargalo, nome, whatsapp, origem: 'landing_v1' }]);

    if (error) return { success: false, error: error.message };
    return { success: true };
  }

  return { saveLeadDiagnostico };
})();
