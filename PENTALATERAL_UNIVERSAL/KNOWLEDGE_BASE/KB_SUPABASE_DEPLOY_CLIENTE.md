# KB_SUPABASE_DEPLOY_CLIENTE.md
> Criado após: FALHA Loop 6 Build 2026-05-28 — PROJ-002 Ingrid
> Proxima revisao: se ocorrer nova falha de deploy Supabase

---

## PREMISSA CRITICA — VERIFICAR ANTES DE INICIAR

O token deve ser da conta **Owner da ORGANIZACAO** — nao do projeto.
Ser Owner do projeto mas nao da org resulta em 403 silencioso.

**Verificacao:**
- Supabase Dashboard → Settings → Organization → Members
- Confirmar que a conta usada aparece como "Owner"
- Se nao: pedir ao Owner original para gerar token e passar ao Musculo

---

## SEQUENCIA CORRETA (um comando por vez no PowerShell)

```powershell
# 1. Navegar para a pasta do cliente (OBRIGATORIO — CLI lê config.toml daqui)
Set-Location "C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard\CLIENTES\[NOME]"

# 2. Setar token do Owner da org (obtido no browser da conta correta)
#    Account → Access Tokens → Generate new token → copie o sbp_...
$env:SUPABASE_ACCESS_TOKEN = "[REDACTED-sbp]_DO_OWNER_AQUI"

# 3. Deploy (um por vez — nao concatenar com &&)
npx supabase functions deploy [nome-da-funcao] --project-ref [ref] --use-api
```

**Nota:** `--use-api` evita dependencia do Docker. Sempre usar.

---

## CONFIG.TOML OBRIGATORIO

O CLI exige `supabase/config.toml` na pasta do cliente. Minimo necessario:

```toml
project_id = "[project-ref]"

[api]
enabled = true
port = 54321
schemas = ["public", "storage", "graphql_public"]
extra_search_path = ["public", "extensions"]
max_rows = 1000

[db]
port = 54322
shadow_port = 54320
major_version = 15

[auth]
enabled = true
site_url = "http://127.0.0.1:3000"
jwt_expiry = 3600
enable_refresh_token_rotation = true
refresh_token_reuse_interval = 10
enable_signup = true
enable_anonymous_sign_ins = false

[edge_runtime]
enabled = true
policy = "oneshot"

[analytics]
enabled = false
```

---

## SECRETS (apos deploy bem-sucedido)

Secrets de Edge Functions NAO aceitam `ALTER DATABASE` — permissao negada.
Usar CLI com token do Owner:

```powershell
# Um secret por vez — nao concatenar na mesma linha
npx supabase secrets set NOME_SECRET="valor" --project-ref [ref]
```

Se CLI falhar (403): Dashboard → Edge Functions → Secrets → adicionar manualmente.

---

## ARMADILHAS

| Sintoma | Causa | Fix |
|---|---|---|
| 403 Unauthorized | Token de conta sem Owner da org | Gerar token da conta Owner |
| 400 Entrypoint path | Rodando CLI fora da pasta do cliente | Set-Location para pasta correta |
| Comando se parte ao colar | PowerShell 5.1 cola linha a linha | Colar um comando por vez |
| 403 em secrets set | Mesma causa do deploy | Usar Dashboard se CLI falhar |
| `order: random()` em REST API Supabase | Parametro invalido — retorna 400 silenciado | Usar `.sort(() => Math.random() - 0.5)` no JS apos o fetch |

---

## PROJECT-REF

Encontrar em: Dashboard → Project Settings → General → Reference ID
Formato: string de 20 caracteres alfanumericos (ex: `yjqvjhezwhepwomukudt`)
