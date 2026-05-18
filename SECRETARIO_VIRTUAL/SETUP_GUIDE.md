# SETUP DO SECRETÁRIO VIRTUAL — GUIA COMPLETO
**Quadrilateral IAH · Fase 1 · Tempo de setup: ~2 horas**
**Versão:** 1.0 · 2026-05-11

---

> ⚠️ **ORGANISMO VIVO — ACTUALIZAR QUANDO O PROCESSO EVOLUIR**
> · Nova pergunta útil no formulário → adicionar ao Tally + actualizar parse_tally() em main.py
> · Resposta do cliente mal formatada → afinar EVALUATION_PROMPT em main.py
> · Novo canal de notificação (WhatsApp) → ver Secção 5 deste guia
> · Upgrade para Fase 2 → ver ROADMAP.md

---

## O QUE ESTE SISTEMA FAZ

```
Cliente encontra o link do formulário
        ↓
Preenche as perguntas de qualificação + Discovery (5–10 min)
        ↓
Servidor processa automaticamente (30 segundos)
        ↓
Claude Haiku avalia: GO ou NO-GO
        ↓
SE GO:
  · Eduardo recebe email com BRIEFING pronto para colar no Gemini
  · Cliente recebe email de confirmação
SE NO-GO:
  · Eduardo recebe email informativo (sem acção necessária)
  · Cliente recebe email com proposta de Produto de Entrada
```

---

## PASSO 1 — Criar o Formulário no Tally.so (20 min)

**Ir a:** tally.so → criar conta gratuita → New Form

### Configuração do formulário

**Título:** "Fala connosco — [Nome da empresa]"
**Description:** "Preenche em 5 minutos. Se houver fit, entramos em contacto em 24h."

### Perguntas a criar (NESTA ORDEM EXACTA)

```
SECÇÃO: Sobre você
─────────────────────────────────────────
Campo 1: Input Text — "Nome completo" (obrigatório)
Campo 2: Input Text — "Email" (obrigatório) — tipo Email
Campo 3: Input Text — "WhatsApp (opcional)"

SECÇÃO: O problema
─────────────────────────────────────────
Campo 4: Long Text — "Qual é o problema que te custa dinheiro todos os meses por não estar resolvido?"
  (obrigatório — mínimo 50 caracteres — usar validação do Tally)

Campo 5: Multiple Choice — "Que investimento faz sentido para resolver isso?"
  Opções:
  - Menos de R$2.000
  - Entre R$2.000 e R$5.000
  - Entre R$5.000 e R$15.000
  - Acima de R$15.000
  - Ainda não sei / Depende da proposta

Campo 6: Multiple Choice — "O que acontece se não resolver isso nos próximos 3 meses?"
  Opções:
  - Nada muito grave
  - Perco clientes para a concorrência
  - Continuo a perder receita
  - Tenho um prazo ou evento que não posso perder
  - Outro

SECÇÃO: O projecto
─────────────────────────────────────────
Campo 7: Dropdown — "Que tipo de projecto é?"
  Opções: Site / Landing page, Ecommerce / Loja online, App ou SaaS,
  Automação de processos, Chatbot / IA, Modelo de negócio / Estratégia, Outro

Campo 8: Short Text — "Quem é o teu cliente ideal?"

Campo 9: Multiple Choice — "Quantos clientes/utilizadores por mês (actual ou meta)?"
  Opções: Menos de 500, 500 a 5.000, 5.000 a 50.000, Mais de 50.000

Campo 10: Short Text — "Como gera dinheiro? Qual o ticket médio?"

Campo 11: Long Text — "O que já existe? (código, design, domínio, contas?)"

Campo 12: Short Text — "Há algum prazo ou evento fixo?"

Campo 13: Short Text — "Qual o orçamento aproximado? Tens equipa?"
```

### Configurar Webhook (ESSENCIAL)

1. Tally → Settings → Integrations → Webhooks
2. Add Webhook
3. URL: `https://[URL-DO-SEU-SERVIÇO]/webhook/tally`
4. Events: Form submission
5. Save

**Guardar o link público do formulário** — vai partilhar com clientes.

---

## PASSO 2 — Configurar Gmail App Password (10 min)

O sistema usa Gmail para enviar emails. Precisa de uma App Password (não a senha normal).

1. Ir a: myaccount.google.com
2. Security → 2-Step Verification (activar se não estiver)
3. Security → App passwords
4. Select app: Mail | Select device: Other → nome: "Secretario Virtual"
5. **Copiar a senha gerada (16 caracteres)** — só aparece uma vez

---

## PASSO 3 — Obter Chave Claude API (5 min)

1. Ir a: console.anthropic.com
2. API Keys → Create Key
3. Nome: "Secretario Virtual"
4. **Copiar a chave** — começa com `sk-ant-`

**Custo estimado:** Claude Haiku custa $0.25 por 1M tokens de input.
Uma avaliação de lead usa ~800 tokens. Para 100 leads/mês = $0.02. Praticamente zero.

---

## PASSO 4 — Deploy no Railway (30 min)

Railway é gratuito até 500 horas/mês — suficiente para uso normal.

### 4.1 — Criar conta no Railway

1. Ir a: railway.app
2. Login com GitHub

### 4.2 — Criar repositório no GitHub

```bash
# Na pasta SECRETARIO_VIRTUAL:
git init
git add .
git commit -m "Secretário Virtual IAH v1.0"
git remote add origin https://github.com/[seu-user]/secretario-virtual-iah.git
git push -u origin main
```

### 4.3 — Deploy no Railway

1. Railway → New Project → Deploy from GitHub repo
2. Seleccionar o repositório `secretario-virtual-iah`
3. Railway vai detectar o Procfile automaticamente
4. Ir a Variables → e adicionar cada variável do `.env.example`:

```
ANTHROPIC_API_KEY    = [a sua chave]
GMAIL_USER           = [o seu gmail]
GMAIL_PASSWORD       = [a app password de 16 caracteres]
EDUARDO_EMAIL        = [o email onde quer receber notificações]
NOME_OPERADOR        = Eduardo
NOME_EMPRESA         = [nome da sua empresa/marca]
PRODUTO_ENTRADA_LINK = [link para a página do produto de entrada, se tiver]
```

5. Deploy → copiar o URL público gerado pelo Railway
   Formato: `https://secretario-virtual-iah-production.up.railway.app`

### 4.4 — Actualizar o webhook do Tally

Voltar ao Tally → Settings → Webhooks → actualizar a URL com o link do Railway.

### 4.5 — Testar

1. Abrir o formulário Tally em modo preview
2. Preencher com dados de teste
3. Aguardar 30–60 segundos
4. Verificar email do Eduardo

---

## PASSO 5 — Testar o sistema completo

### Teste GO (deve chegar briefing):

```
Nome: Teste GO
Email: [o seu email]
Problema: A minha loja perde vendas porque não tenho checkout online
Investimento: Entre R$5.000 e R$15.000
Consequência: Continuo a perder receita
Tipo: Ecommerce / Loja online
Cliente ideal: Mulheres 25-45 que compram online
Volume: 500 a 5.000
Receita: Ticket médio R$120
Estado: Tenho o Instagram mas sem loja online
Prazo: Quero lançar antes do Dia das Mães
Recursos: R$8.000, trabalho sozinha
```

**Resultado esperado:** Email com 🟢 GO + briefing formatado.

### Teste NO-GO (deve chegar sem acção):

```
Nome: Teste NO-GO
Email: [outro email]
Problema: Quero crescer e modernizar
Investimento: Menos de R$2.000
Consequência: Nada muito grave
```

**Resultado esperado:** Email com 🔴 NO-GO + confirmação de que email foi enviado ao lead.

---

## SECÇÃO 5 — UPGRADE PARA WHATSAPP (Fase 2)

Quando tiver volume suficiente (15+ leads/mês), adicionar notificação WhatsApp:

**Opção A — Z-API (Brasil, ~R$80/mês):**
1. Criar conta em z-api.io
2. Connectar um número WhatsApp ao Z-API
3. Adicionar a `main.py` a função `send_whatsapp_zapi()`
4. Substituir `send_email(EDUARDO_EMAIL, ...)` por `send_whatsapp_zapi(...)`

**Opção B — Evolution API (open source, grátis no Railway):**
Adicionar um segundo serviço Railway com a Evolution API.
Mais complexo mas sem custo de plataforma.

---

## SECÇÃO 6 — MANUTENÇÃO (ORGANISMO VIVO)

| Situação | O que fazer |
|----------|-------------|
| Claude avaliou mal um lead | Afinar `EVALUATION_PROMPT` em `main.py` |
| Email de cliente soou robótico | Ajustar `email_cliente_go()` / `email_cliente_nogo()` |
| Nova pergunta útil a adicionar | Adicionar ao Tally + mapear em `parse_tally()` |
| Upgrade para WhatsApp | Ver Secção 5 |
| Upgrade para Fase 2 (bot qualificador) | Ver ROADMAP.md |

**Para actualizar e fazer re-deploy:**
```bash
# Fazer a alteração em main.py
git add main.py
git commit -m "Melhoria: [descrever o que mudou]"
git push
# Railway faz re-deploy automaticamente
```

---

## ESTRUTURA DE FICHEIROS

```
SECRETARIO_VIRTUAL/
├── main.py                  ← o serviço completo (editar aqui)
├── requirements.txt         ← dependências Python
├── Procfile                 ← configuração Railway
├── .env.example             ← variáveis de ambiente (não commitar .env)
├── SETUP_GUIDE.md           ← este ficheiro
└── ROADMAP.md               ← próximas fases
```

---

*Secretário Virtual · Quadrilateral IAH · Fase 1 · V1.0*
*Setup: ~2 horas · Custo: $5–10/mês · Resultado: briefings automáticos no email*
