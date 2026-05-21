-- Força reload do schema cache do PostgREST
-- Supabase usa PostgREST; após mudar função, o cache pode estar stale
NOTIFY pgrst, 'reload schema';
