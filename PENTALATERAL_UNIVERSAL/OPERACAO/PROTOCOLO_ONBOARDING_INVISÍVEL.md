# PROTOCOLO_ONBOARDING_INVISÍVEL
> Vanguard Tech · Operações Universais
> Versão: 1.1 · Criado: 2026-05-26 · Princípio: P-070
> **Aplica-se a:** todo projeto cliente, sem exceção, a partir do kickoff.
> **Nota:** Ingrid e Valdece foram resolvidos com abordagem pré-protocolo. Aplicar a partir do próximo cliente.

---

## PRINCÍPIO BASE (P-070)

O cliente nunca cria conta. A Vanguard absorve toda fricção técnica no kickoff.

**Por quê:** Clientes avessos à tecnologia abandonam o projeto antes do primeiro uso quando solicitados a criar contas no Supabase, Google AI Studio ou GitHub. Entregar a conta pronta fecha o projeto — pedir para criar afasta o cliente.

---

## INFRAESTRUTURA DE E-MAIL — DOIS MODOS

### MODO MVP (até ~5 clientes) — Aliases no hPanel
Custo adicional: R$ 0/mês.

```
projetos@vanguardtech.cloud     → caixa master (Eduardo)
ingrid@vanguardtech.cloud       → alias → projetos@
valdece@vanguardtech.cloud      → alias → projetos@
[proximo]@vanguardtech.cloud    → alias → projetos@
```

**Estado atual (2026-05-26):**
- `ingrid@vanguardtech.cloud` → criado como alias (sem conta de serviço associada — Ingrid já resolvida)
- `valdece@vanguardtech.cloud` → criado como alias (sem conta de serviço associada — Valdece já resolvido)

**Como criar alias no hPanel:**
1. hpanel.hostinger.com → E-mails → Aliases
2. Alias: `[nome]@vanguardtech.cloud` → aponta para: `projetos@vanguardtech.cloud`
3. Teste obrigatório (P-010): enviar e-mail de teste para o alias → confirmar recebimento em `projetos@`

**Limitação:** Todas as confirmações de todos os clientes chegam em `projetos@`. Funciona até ~5 clientes ativos. Acima disso → migrar para MODO ESCALA.

---

### MODO ESCALA (5+ clientes) — Caixas separadas no hPanel
Custo: R$ 6/mês por caixa adicional (plano Starter · 10 GB).

```
diretor@vanguardtech.cloud      → caixa Eduardo (R$ 6/mês)
projetos@vanguardtech.cloud     → caixa operacional (R$ 6/mês)
ingrid@vanguardtech.cloud       → caixa da Ingrid (R$ 6/mês)
valdece@vanguardtech.cloud      → caixa do Valdece (R$ 6/mês)
```

Eduardo acessa todas via webmail da Hostinger ou Gmail (IMAP/SMTP).
Benefício: cada cliente tem sua caixa → sem mistura de e-mails de verificação.

**Quando migrar:** ao atingir 5 clientes ativos ou ao detectar confusão entre e-mails de verificação no inbox de `projetos@`.

---

## PASSO A PASSO — ONBOARDING DE NOVO CLIENTE

> **Pré-requisito bloqueante:** Termo de Uso assinado com cláusula de autorização de contas (ver Passo 0).

### PASSO 0 — Autorização (antes de qualquer conta)

O Termo de Uso do cliente DEVE conter cláusula:

```
"O cliente autoriza expressamente a [Vanguard Tech / razão social] a criar e gerenciar
contas técnicas nos serviços necessários ao projeto (Supabase, Google, GitHub, etc.)
utilizando o endereço [nome]@vanguardtech.cloud como identidade operacional.
As credenciais são gerenciadas pela Vanguard e entregues ao cliente ao final do projeto
ou mediante solicitação de encerramento (Runbook de Offboarding)."
```

Sem assinatura com esta cláusula → não criar nenhuma conta. Ponto.

---

### PASSO 1 — Criar alias/caixa (30 segundos)

Imediatamente após assinatura do Termo.

**MODO MVP:** hPanel → E-mails → Aliases → `[nome]@vanguardtech.cloud` → `projetos@`
**MODO ESCALA:** hPanel → E-mails → Criar conta → `[nome]@vanguardtech.cloud`

Teste P-010: enviar e-mail de teste → confirmar recebimento.

---

### PASSO 2 — Criar contas nos serviços (ordem obrigatória)

Usar sempre `[nome]@vanguardtech.cloud` como identidade do cliente.
Todas as confirmações chegam em `projetos@` (MODO MVP) ou `[nome]@` (MODO ESCALA).

#### 2.1 Google Account (primeiro — desbloqueia tudo Google)
```
Acesse:   accounts.google.com/signup
E-mail:   [nome]@vanguardtech.cloud
Nome:     [nome completo do cliente]
Senha:    [gerar no cofre — ver Passo 3]
```
Confirmar e-mail de verificação. Desbloqueia: Google AI Studio, Drive, Gmail.

#### 2.2 Supabase (projetos com banco de dados / Edge Functions)
```
Acesse:   supabase.com → Sign Up
E-mail:   [nome]@vanguardtech.cloud
Senha:    [gerar no cofre]
Projeto:  [PROJ-XXX]-[nome]
```
Após criar: convidar `[nome]@vanguardtech.cloud` como Owner. Registrar URL + anon key.
Criar `OFFBOARDING_RUNBOOK.md` no repositório (P-013 — transferência de ownership).

#### 2.3 GitHub (projetos com deploy via GitHub Pages)
```
Acesse:   github.com/signup
E-mail:   [nome]@vanguardtech.cloud
Username: [nome]-vanguard
Senha:    [gerar no cofre]
```

#### 2.4 Google AI Studio (projetos com Gemini API)
```
Acesse:   aistudio.google.com
Login:    conta Google criada no Passo 2.1
Gerar:    API Key → registrar no cofre + no arquivo de configuração do projeto
```

---

### PASSO 3 — Registrar credenciais no cofre

**Cofre:** Bitwarden (plano gratuito — recomendado). Nunca planilha, nunca txt solto.

```
CLIENTE:     [nome completo]
PROJ-ID:     PROJ-[NNN]
DATA:        YYYY-MM-DD

GOOGLE
  E-mail:    [nome]@vanguardtech.cloud
  Senha:     [senha]

SUPABASE
  E-mail:    [nome]@vanguardtech.cloud
  Senha:     [senha]
  URL:       https://[hash].supabase.co
  Anon key:  [chave]
  Service key: [chave — NUNCA vai ao frontend]

GITHUB
  Username:  [nome]-vanguard
  Senha:     [senha]

GOOGLE AI STUDIO
  API Key:   [chave — NUNCA vai ao frontend]
```

---

### PASSO 4 — Entrega ao cliente (única interação técnica)

**Modelo de WhatsApp:**

```
[Nome], tudo pronto para começarmos!

Preparei o seu acesso. Quando precisar entrar no sistema:

📧 Seu e-mail: [nome]@vanguardtech.cloud
🔑 Sua senha: [senha — ou "envio em outra mensagem por segurança"]

Qualquer dúvida, é só me chamar aqui.
```

**Regras absolutas:**
- Nunca enviar senha e e-mail na mesma mensagem se o canal não for seguro
- Nunca mencionar Supabase, GitHub, Google AI Studio ao cliente
- O cliente só precisa de e-mail + senha — o resto é invisível

---

### PASSO 5 — Checklist de kickoff (gate obrigatório P-010)

```
[ ] Alias/caixa [nome]@vanguardtech.cloud criado no hPanel
[ ] E-mail de teste recebido em projetos@ (confirmar)
[ ] Conta Google criada e verificada
[ ] Conta Supabase criada (se aplicável)
[ ] Projeto Supabase criado — cliente como Owner (se aplicável)
[ ] OFFBOARDING_RUNBOOK.md no repositório (P-013)
[ ] Conta GitHub criada (se aplicável)
[ ] API Key Google AI Studio gerada (se aplicável)
[ ] Todas as credenciais registradas no cofre (Bitwarden)
[ ] Mensagem de entrega enviada ao cliente
[ ] WIP_BOARD.json atualizado: onboarding_status → "concluido"
```

---

## OFFBOARDING (P-013 — Soberania do Cliente)

O cliente pode sair a qualquer momento. O `OFFBOARDING_RUNBOOK.md` de cada projeto instrui como transferir ownership de todos os serviços para e-mail próprio do cliente em menos de 30 minutos.

O cliente que sabe como sair não sai — porque sente confiança, não prisão.

---

## CUSTO OPERACIONAL

| Item | Custo |
|---|---|
| Domínio `vanguardtech.cloud` | já existente (Hostinger) |
| Caixa `diretor@` + `projetos@` | R$ 12/mês (2 × Starter) |
| Alias de cliente (MODO MVP) | R$ 0 (não cria caixa) |
| Caixa de cliente (MODO ESCALA) | R$ 6/mês por cliente |
| Cofre Bitwarden (gratuito) | R$ 0 |
| **Total por cliente novo (MVP)** | **R$ 0** |
| **Total por cliente novo (Escala)** | **R$ 6/mês** |
| **Total fixo mínimo** | **R$ 12/mês** |

---

## PENDENTE DO DIRETOR

- [ ] Setup do cofre Bitwarden antes do próximo cliente
- [ ] Cláusula de autorização no Termo de Uso (Músculo adiciona quando solicitado)
- [ ] Decidir MODO MVP ou MODO ESCALA para o próximo cliente

---

*Vanguard Tech · Protocolo Universal P-070 · Não compartilhar com clientes*
*Revisão obrigatória: ao integrar novo serviço recorrente ou ao atingir 10 clientes ativos*
