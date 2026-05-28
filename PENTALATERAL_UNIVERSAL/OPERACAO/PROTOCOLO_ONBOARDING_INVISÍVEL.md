# PROTOCOLO_ONBOARDING_INVISÍVEL
> Vanguard Tech · Operações Internas
> Versão: 1.0 · Criado: 2026-05-26
> Princípio base: o cliente nunca cria conta. A Vanguard absorve toda fricção técnica no kickoff.

---

## CONTEXTO E PROPÓSITO

Clientes da Vanguard são avessos à tecnologia. Pedir que criem conta no Supabase, Google AI Studio ou qualquer outra plataforma gera fricção, atraso e risco de abandono antes do projeto começar.

Este protocolo elimina esse problema. A Vanguard cria tudo. O cliente recebe tudo pronto.

**Infraestrutura central:**
- Domínio: `vanguardtech.cloud` (Hostinger)
- Caixa principal: `projetos@vanguardtech.cloud`
- Aliases por cliente: `[nome]@vanguardtech.cloud` → redirecionam para `projetos@`

---

## PASSO 1 — CRIAR ALIAS DO CLIENTE (30 segundos)

**Quando executar:** imediatamente após contrato assinado.

**Onde:** hpanel.hostinger.com → E-mails → Aliases

**Ação:**
```
Alias:   [nome]@vanguardtech.cloud
Aponta para: projetos@vanguardtech.cloud
```

**Exemplos:**
```
ingrid@vanguardtech.cloud   → projetos@vanguardtech.cloud
valdece@vanguardtech.cloud  → projetos@vanguardtech.cloud
joao@vanguardtech.cloud     → projetos@vanguardtech.cloud
```

**Teste obrigatório (P-010):** enviar e-mail de teste para o alias recém-criado e confirmar recebimento em `projetos@` antes de prosseguir.

---

## PASSO 2 — CRIAR CONTAS NOS SERVIÇOS (ordem obrigatória)

Usar sempre o e-mail `[nome]@vanguardtech.cloud` como identidade do cliente em cada serviço.
Todas as confirmações chegam em `projetos@vanguardtech.cloud`.

### 2.1 Google Account
**Por que primeiro:** desbloqueia Google AI Studio, Google Drive, Gmail, e qualquer serviço Google que o projeto precisar.

```
Acesse:   accounts.google.com/signup
E-mail:   [nome]@vanguardtech.cloud
Nome:     [nome completo do cliente]
Senha:    [gerar senha forte — registrar no cofre interno]
```

Confirmar e-mail de verificação que chega em `projetos@`.

### 2.2 Supabase
**Quando:** projetos que usam banco de dados ou Edge Functions.

```
Acesse:   supabase.com → Sign Up
E-mail:   [nome]@vanguardtech.cloud
Senha:    [gerar senha forte — registrar no cofre interno]
```

Após criar conta:
1. Criar novo projeto com nome `[PROJ-XXX]-[nome]`
2. Convidar `[nome]@vanguardtech.cloud` como **Owner** do projeto
3. Registrar URL e anon key no arquivo de configuração do projeto
4. Criar `OFFBOARDING_RUNBOOK.md` no repositório (P-013)

### 2.3 GitHub
**Quando:** projetos com deploy via GitHub Pages ou repositório do cliente.

```
Acesse:   github.com/signup
E-mail:   [nome]@vanguardtech.cloud
Username: [nome]-vanguard (ou definir padrão)
Senha:    [gerar senha forte — registrar no cofre interno]
```

### 2.4 Google AI Studio
**Quando:** projetos com integração Gemini API.

```
Acesse:   aistudio.google.com
Login:    usar conta Google criada no Passo 2.1
Gerar:    API Key → registrar no arquivo de configuração
```

---

## PASSO 3 — REGISTRAR CREDENCIAIS

Toda credencial criada deve ser registrada imediatamente no cofre interno.

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

GITHUB
  Username:  [username]
  Senha:     [senha]

GOOGLE AI STUDIO
  API Key:   [chave]
```

---

## PASSO 4 — ENTREGA AO CLIENTE (única interação necessária)

O cliente recebe **uma única mensagem** via WhatsApp com tudo pronto. Sem jargão técnico. Sem instrução de como criar conta. Sem link de confirmação para clicar.

**Modelo de mensagem:**

```
[Nome], tudo pronto para começarmos!

Preparei o seu acesso ao projeto. Quando precisar entrar:

📧 Seu e-mail: [nome]@vanguardtech.cloud
🔑 Sua senha: [senha — ou "envio separado por segurança"]

Qualquer dúvida, é só me chamar aqui.
```

**Regras de entrega:**
- Nunca enviar senha e e-mail na mesma mensagem se o canal não for seguro
- Nunca mencionar Supabase, GitHub ou qualquer plataforma técnica ao cliente
- O cliente só precisa saber que tem um e-mail e uma senha — o resto é invisível

---

## PASSO 5 — CHECKLIST DE KICKOFF (gate obrigatório — P-010)

Antes de considerar o onboarding concluído, verificar cada item:

```
[ ] Alias [nome]@vanguardtech.cloud criado no hPanel
[ ] E-mail de teste recebido em projetos@
[ ] Conta Google criada e verificada
[ ] Conta Supabase criada (se aplicável)
[ ] Projeto Supabase criado com cliente como Owner (se aplicável)
[ ] OFFBOARDING_RUNBOOK.md no repositório (P-013)
[ ] Conta GitHub criada (se aplicável)
[ ] API Key Google AI Studio gerada (se aplicável)
[ ] Todas as credenciais registradas no cofre interno
[ ] Mensagem de entrega enviada ao cliente
[ ] WIP_BOARD.json atualizado: status ONBOARDING → ATIVO
```

---

## OFFBOARDING (P-013 — Soberania do Cliente)

O cliente pode sair a qualquer momento. O `OFFBOARDING_RUNBOOK.md` de cada projeto instrui como transferir ownership de todos os serviços para e-mail próprio do cliente em menos de 30 minutos.

O cliente que sabe como sair não sai — porque sente confiança, não prisão.

---

## CUSTO OPERACIONAL

| Item | Custo |
|---|---|
| Domínio `vanguardtech.cloud` | já existente |
| Caixa `projetos@vanguardtech.cloud` | R$ 6/mês (Hostinger Starter) |
| Aliases adicionais | R$ 0 (ilimitados no mesmo plano) |
| **Total por cliente novo** | **R$ 0** |
| **Total fixo mensal** | **R$ 6/mês** |

---

## REGISTRO NO INTELLIGENCE LEDGER

> **P-[NNN] (candidato) — Onboarding Invisível**
> O cliente nunca cria conta. Toda fricção técnica de cadastro em serviços externos é absorvida pela Vanguard no kickoff. Aliases `[nome]@vanguardtech.cloud` são a identidade técnica do cliente dentro da infraestrutura Vanguard — profissional, rastreável, custo fixo de R$ 6/mês independente do volume de clientes. Criar conta afasta cliente. Entregar conta pronta fecha projeto.
>
> **Descoberto:** 2026-05-26 | **Sessão:** Decisão operacional do Diretor
> **Aplica-se a:** todo projeto cliente, sem exceção, desde o kickoff

---

*Vanguard Tech · Protocolo interno · Não compartilhar com clientes*
*Próxima revisão: ao integrar novo serviço recorrente ou ao atingir 10 clientes ativos*