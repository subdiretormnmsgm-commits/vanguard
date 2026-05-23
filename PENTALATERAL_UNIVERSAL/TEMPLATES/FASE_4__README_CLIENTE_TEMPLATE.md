# [NOME DO projeto] — Guia de Operação
**Cliente:** [nome do cliente] | **Versão:** V[X] | **Entregue em:** [data]
**Desenvolvido por:** [NOME DO OPERADOR]

---

## ACESSO RÁPIDO

| Recurso | URL / contato |
|---------|---------------|
| Sistema principal | [URL] |
| Painel de administração | [URL/admin] |
| Supabase (base de dados) | [URL do projeto Supabase] |
| Stripe (pagamentos) | [URL do dashboard Stripe] |
| Repositório Git | [URL do repositório] |
| Suporte: WhatsApp | [número do operador] |
| Suporte: Email | [email do operador] |

---

## INSTALAÇÃO E DEPLOY

```bash
# 1. Clonar o repositório
git clone [URL do repositório]
cd [nome-do-projeto]

# 2. Instalar dependências
[npm install / pip install -r requirements.txt]

# 3. Configurar variáveis de ambiente
cp .env.example .env
# Editar .env com os valores reais (ver seção abaixo)

# 4. Correr em desenvolvimento
[npm run dev / uvicorn main:app --reload]

# 5. Deploy em produção
[instrução de deploy específica do projeto]
```

---

## VARIÁVEIS DE AMBIENTE

Ver arquivo `.env.example` na raiz do projeto para a lista completa.
**Nunca commitar o arquivo `.env` com valores reais.**

Variáveis críticas que o cliente precisa de gerir:
- `STRIPE_SECRET_KEY` — renovar se comprometida
- `SUPABASE_SERVICE_KEY` — renovar se comprometida
- `ANTHROPIC_API_KEY` — monitorar consumo no painel Anthropic

---

## SERVIÇOS EXTERNOS E CUSTOS

| Serviço | Função | Custo mensal | Conta em nome de |
|---------|--------|-------------|-----------------|
| [Supabase] | Base de dados | R$[X]/mês | [Cliente] |
| [Vercel/Railway] | Hospedagem | R$[X]/mês | [Cliente] |
| [Stripe] | Pagamentos | % por transação | [Cliente] |
| [Resend/SendGrid] | Email | R$[X]/mês | [Cliente] |
| [Anthropic] | IA (relatórios) | ~R$[X]/mês | [Operador — cobrado no Retainer] |

**Total mensal estimado:** R$[X]/mês

---

## O QUE FAZER SE ALGO PARAR DE FUNCIONAR

### O site está inacessível
1. Verificar status da hospedagem: [URL de status do serviço de hosting]
2. Verificar Cloudflare: [URL]
3. Se persistir: contactar operador — WhatsApp: [número]

### A base de dados não responde
1. Verificar Supabase status: https://status.supabase.com
2. Verificar se a `SUPABASE_URL` no `.env` está correcta
3. Contactar operador

### Os pagamentos não estão a processar
1. Verificar Stripe dashboard: https://dashboard.stripe.com
2. Verificar se as chaves Stripe no `.env` são de produção (começam com `sk_live_`)
3. Contactar operador

### Os relatórios automáticos pararam
1. Verificar se o pg_cron está ativo no Supabase (SQL Editor: `SELECT * FROM cron.job;`)
2. Verificar saldo de créditos na conta Anthropic
3. Contactar operador

---

## RENOVAÇÃO DE CHAVES DE API

| Serviço | Quando renovar | Como renovar |
|---------|---------------|-------------|
| Supabase | Se comprometida | Dashboard Supabase → Settings → API → Reveal/Reset |
| Stripe | Se comprometida | Dashboard Stripe → Developers → API keys → Roll key |
| Anthropic | Se comprometida | console.anthropic.com → API Keys → Create new |

**Após renovar qualquer chave:** atualizar o `.env` em produção e reiniciar o serviço.

---

## ESTRUTURA DO projeto

```
[nome-do-projeto]/
├── api/              ← backend (FastAPI / Node.js)
├── web/              ← frontend (Next.js / HTML)
├── infra/            ← schemas SQL, Docker, deploy
├── scripts/          ← scripts de automação
├── .env.example      ← template de variáveis de ambiente
├── sentinel_config.json  ← configuração do relatório automático
├── feature_flags.json    ← flags de funcionalidades
└── README.md         ← este arquivo
```

---

## SUPORTE PÓS-ENTREGA

**Incluído:** [X] dias de suporte após entrega — bugs críticos (P0) resolvidos sem custo.
**Retainer disponível:** evolução contínua por R$[X]/mês — [N] iterações incluídas.

Para suporte ou evolução: **[WhatsApp do operador]** ou **[email do operador]**

---

*Documento preparado por [NOME DO OPERADOR] · V[X]*
*atualizar a cada iteração — versão mais recente no repositório*
