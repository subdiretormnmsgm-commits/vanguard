const SUPABASE_URL      = 'https://ehyaecxqijgyuuiorzcj.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVoeWFlY3hxaWpneXV1aW9yemNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgyODMzNTAsImV4cCI6MjA5Mzg1OTM1MH0.xZfcEe2Av5Fn9BKEkNRIi5CQkPD6C6ADSNzMfh3DGPo';

const supabaseClient = (() => {
  const client = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

  async function saveLeadDiagnostico({ nicho, gargalo, nome, whatsapp, metadata }) {
    const row = { nicho, gargalo, nome, whatsapp, origem: 'landing_v18' };
    if (metadata) row.metadata = metadata;
    const { error } = await client
      .from('leads_diagnostico')
      .insert([row]);

    if (error) return { success: false, error: error.message };
    return { success: true };
  }

  return { saveLeadDiagnostico };
})();
