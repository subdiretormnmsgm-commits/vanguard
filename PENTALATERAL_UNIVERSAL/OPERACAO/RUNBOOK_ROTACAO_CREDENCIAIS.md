# RUNBOOK — ROTAÇÃO DAS 7 CREDENCIAIS EXPOSTAS (P-185-ROTACAO)

> Ação EXCLUSIVA do Diretor — o Músculo nunca gira chave. Este runbook é o passo-a-passo.
> Origem: syncs antigos sem filtro empurraram 7 segredos ao `gdrive:vanguard` (Drive de terceiros).
> Purga do Drive já feita (7/7) + fix do sync (P-185-guard) aplicado — MAS purgar não desfaz a
> exposição passada. Enquanto não rotacionar, qualquer cópia capturada do Drive ainda é válida.
> Pendente desde 2026-06-16 (terça-feira). Só o Diretor encerra o item no PENDENTES após rotacionar.

---

## REGRA DE OURO
Rotacionar = **gerar nova chave → atualizar onde ela é consumida → revogar a antiga**.
Nunca revogar a antiga ANTES de a nova estar funcionando (derruba os workflows).
Após cada rotação, atualizar os arquivos locais gitignored: `CHAVES_SISTEMA_VANGUARD.txt` + `N8N Easypanel.txt`.

---

## AS 7 CREDENCIAIS — ORDEM SUGERIDA (menor risco de quebra primeiro)

### 1. Telegram Bot Token (@Eduardo431Vanguardbot)
- **Onde girar:** Telegram → @BotFather → `/revoke` → confirma o bot → recebe token novo.
- **Onde atualizar:** EasyPanel → serviço n8n → variável `TELEGRAM_BOT_TOKEN` + serviço hermes-agent → `/opt/data/config.yaml` (ou env). Reiniciar ambos.
- **Consumido por:** W-1, W-5, W-11, W-12 (e o S-2 novo) + Hermes polling.
- **Teste:** rodar `.\scripts\ping_hermes.ps1` + aguardar 1 disparo de qualquer W.

### 2. OpenRouter API Key
- **Onde girar:** openrouter.ai → Keys → revogar a atual → criar nova.
- **Onde atualizar:** EasyPanel → hermes-agent → env `OPENROUTER_API_KEY`. Reiniciar.
- **Consumido por:** Hermes Agent (modelo claude-sonnet-4-6 via OpenRouter).
- **Teste:** mandar `/status` ao bot no Telegram → Hermes deve responder.

### 3. Anthropic API Key
- **Onde girar:** console.anthropic.com → API Keys → criar nova → revogar a antiga.
- **Onde atualizar:** qualquer workflow/script que chame a Anthropic direto (conferir n8n + `CHAVES_SISTEMA_VANGUARD.txt`).
- **Teste:** disparar o workflow que a usa; conferir log sem 401.

### 4. n8n API Key (EasyPanel)
- **Onde girar:** n8n → Settings → n8n API → revogar → gerar nova.
- **Onde atualizar:** `N8N Easypanel.txt` (local) + qualquer script que faça `curl -H "X-N8N-API-KEY:"`.
- **Teste:** `.\scripts\ping_n8n.ps1` (deve voltar UP).

### 5. Supabase Keys (anon + service_role)
- **Onde girar:** dashboard Supabase → Project Settings → API → "Reset" / rotacionar (JWT secret regenera anon+service).
- **Onde atualizar:** EasyPanel n8n → `SUPABASE_VANGUARD_URL` (não muda) + `SUPABASE_VANGUARD_ANON_KEY` (muda) + qualquer service_role em workflows (W-2, W-8).
- **ATENÇÃO:** rotacionar o JWT secret invalida TODAS as chaves do projeto de uma vez — atualizar tudo no mesmo passo.
- **Teste:** W-2 Monitor Supabase deve seguir verde.

### 6. Credenciais EasyPanel (login do painel)
- **Onde girar:** EasyPanel → conta → trocar senha (e e-mail de recuperação, se aplicável).
- **Onde atualizar:** `CHAVES_SISTEMA_VANGUARD.txt` (local).
- **Teste:** logout/login no painel.

### 7. Segredos em arquivos de script
- **Conferir e regerar o que houver em:** `scripts/n8n_config.ps1`, `scripts/alert_config.ps1`, `hermes-agent/.env`.
- Se qualquer um trouxer uma das chaves acima hardcoded → substituir pela nova e confirmar que o arquivo está gitignored.
- **Teste:** `git status` não deve listar esses arquivos; `validate_scripts.ps1` sem credencial em claro.

---

## FECHAMENTO DO ITEM
1. As 6 chaves novas funcionando (testes acima verdes) + arquivos locais atualizados.
2. Revogar/expirar TODAS as 7 antigas (confirmar revogação em cada console).
3. Diretor marca `[x]` no item `P185-ROTACAO` do PENDENTES (não fecha por RESOLVE/git — encerramento manual do Diretor).

> FALLBACK se algo quebrar: a chave antiga ainda não revogada continua válida — só revogue depois do teste verde.
