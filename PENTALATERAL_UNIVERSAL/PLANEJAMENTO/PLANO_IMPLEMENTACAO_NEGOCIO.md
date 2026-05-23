# PLANO DE IMPLEMENTAÇÃO DE NEGÓCIO — VANGUARD / IAH
**Data:** 2026-05-10
**Responsável:** Eduardo (Diretor)
**Objetivo:** Primeiro cliente pagante em 30 dias

---

## VISÃO GERAL — O QUE ESTAMOS A VENDER

| Produto | Preço | Modelo |
|---------|-------|--------|
| Diagnóstico Pentalateral™ | Grátis | Isca / Captação |
| Neural Audit Trail (PDF 12 pág.) | R$50 | Unitário via Stripe |
| Neural Sentinel (monitoramento semanal) | R$97/mês | Recorrente via Stripe |
| Projeto IAH Completo (fábrica digital) | R$3.000–R$6.000 | Proposta comercial |

**Funil:** Diagnóstico gratuito → PDF R$50 → Sentinel R$97/mês → Projeto IAH

---

## BLOCO 1 — ENTIDADE LEGAL & FISCAL
*(Sem CNPJ não há Stripe, não há nota fiscal, não há cliente sério)*

### Ações obrigatórias:
- [ ] **Abrir MEI ou LTDA**
  - MEI: limite R$81.000/ano (~R$6.750/mês) — suficiente para início
  - LTDA: recomendado se projetar >R$10.000/mês em 6 meses
  - Portal: gov.br/empresas-e-negocios/pt-br/empreendedor
  - CNAE sugerido: 6209-1/00 (Suporte técnico, manutenção e outros serviços em TI)

- [ ] **Conta bancária Pessoa Jurídica**
  - Recomendado: Nubank PJ (gratuito) ou Inter PJ
  - Alternativa: C6 Bank (integração Stripe melhor)
  - Documentos: CNPJ + RG + comprovante de endereço

- [ ] **Contrato de Prestação de Serviços**
  - Template para clientes Neural Sentinel (assinatura mensal)
  - Template para projetos IAH (escopo fixo)
  - Incluir: LGPD, uso de dados do Pixel, propriedade intelectual

- [ ] **Nota Fiscal**
  - MEI emite NFS-e via prefeitura do município
  - Configurar emissão no portal da prefeitura

---

## BLOCO 2 — INFRAESTRUTURA DE PAGAMENTOS
*(Bloqueador crítico — nada gera receita sem isto)*

### Stripe:
- [ ] Criar conta Stripe com CNPJ brasileiro (stripe.com/br)
- [ ] Verificar conta (enviar documentos CNPJ + conta bancária PJ)
- [ ] Criar Produtos no Stripe Dashboard:
  - Produto 1: "Neural Audit Trail" — preço único R$50 (BRL)
  - Produto 2: "Neural Sentinel" — R$97/mês recorrente (BRL)
- [ ] Copiar Price IDs gerados para o código
- [ ] Configurar Webhook endpoint: `https://vanguard.tech/api/stripe/webhook`
- [ ] Implementar endpoint `/api/stripe/sentinel-checkout` (dívida crítica V19)
- [ ] Testar checkout de ponta a ponta (modo teste → modo live)

### Alternativa imediata (enquanto Stripe não está pronto):
- [ ] Ativar link de pagamento manual via Mercado Pago ou PagSeguro
- [ ] Cobrar primeiros clientes via PIX + comprovante manual

---

## BLOCO 3 — PLATAFORMAS & ASSINATURAS NECESSÁRIAS

### Já tem / em uso:
| Plataforma | Status | Custo |
|-----------|--------|-------|
| Hostinger | Assinatura activa | já pago |
| Supabase | Free tier | R$0 (até 500MB) |
| GitHub | Free | R$0 |
| Cloudflare | Free tier | R$0 (Workers 100k req/dia) |

### Precisa activar / assinar:
| Plataforma | Para quê | Custo estimado | Prioridade |
|-----------|---------|---------------|-----------|
| **Stripe** | Pagamentos Neural Audit + Sentinel | 3,4% + R$0,40/transação | 🔴 CRÍTICA |
| **Cloudflare Workers Paid** | federation-proxy.js em produção | US$5/mês | 🔴 CRÍTICA |
| **Vapi** | Hermes Voice (ligações automáticas) | ~US$0,05/min | 🟡 MÉDIA |
| **SendGrid** | Sentinel Report Card email semanal | Free até 100/dia | 🟡 MÉDIA |
| **WhatsApp Business API** | Hermes Outbound mensagens | R$0,08–R$0,25/msg | 🟡 MÉDIA |
| **n8n Cloud** | Automações pipeline | US$20/mês | 🟢 BAIXA |
| **Supabase Pro** | Quando ultrapassar 500MB | US$25/mês | 🟢 BAIXA |

### Configurações Cloudflare (gratuito para começar):
- [ ] Criar conta Cloudflare
- [ ] Adicionar domínio vanguard.tech
- [ ] Criar KV Namespace: `TENANTS_KV`
- [ ] Deploy `federation-proxy.js` via wrangler
- [ ] Ativar Custom Hostnames (SSL for SaaS) — requer plano Business US$200/mês OU Workers for Platforms

> **Alternativa económica ao Custom Hostnames:** usar subdomínios `cliente.vanguard.tech` em vez de Custom Hostnames no domínio do cliente — reduz custo de US$200 para US$5/mês.

---

## BLOCO 4 — DOMÍNIO & IDENTIDADE DIGITAL

- [ ] **Domínio principal:** vanguard.tech (verificar se está registado)
  - Se não: registro.br ou Cloudflare Registrar (~US$10/ano)
- [ ] **Subdomínios necessários:**
  - `vanguard.tech` — landing page principal (Hostinger)
  - `pixel.vanguard.tech` → Cloudflare Worker (pixel.js)
  - `api.vanguard.tech` → backend / Supabase edge functions
  - `app.vanguard.tech` → dashboard multi-tenant (futuro)
- [ ] **SSL:** Cloudflare emite automaticamente (já incluso)
- [ ] **Email profissional:** contato@vanguard.tech
  - Via Cloudflare Email Routing (gratuito) → redireciona para Gmail

---

## BLOCO 5 — DEPLOY PRODUÇÃO (HOSTINGER)
*(V20 milestone obrigatório)*

- [ ] Aceder ao painel Hostinger
- [ ] Criar site / subdomínio para deploy
- [ ] Configurar variáveis de ambiente:
  - `SUPABASE_URL`
  - `SUPABASE_ANON_KEY`
  - `STRIPE_SECRET_KEY`
  - `STRIPE_WEBHOOK_SECRET`
- [ ] Upload dos ficheiros (FTP ou Git deploy)
- [ ] Testar landing + quiz + Stripe em produção
- [ ] Apontar DNS do domínio para Hostinger

---

## BLOCO 6 — PRIMEIRO CLIENTE (30 DIAS)
*(A única métrica que importa agora)*

### Estratégia de aquisição:
- [ ] Definir nicho alvo: **clínicas médicas** ou **e-commerce de nicho** (maior dor financeira)
- [ ] 20 diagnósticos gratuitos via `prospectar.ps1` (já pronto)
- [ ] Script de abordagem WhatsApp:
  > "Olá [Nome], fiz uma análise rápida do site [domínio] e identifiquei R$[valor] em receita que pode estar a perder por mês. Posso enviar o relatório gratuito?"
- [ ] Meta semana 1: 20 contactos enviados
- [ ] Meta semana 2: 3 respostas → 1 reunião
- [ ] Meta semana 3: 1 cliente Neural Sentinel R$97/mês

### Proposta comercial mínima:
- Diagnóstico gratuito (Pentalateral™)
- Neural Audit Trail PDF (R$50) — opcional
- Neural Sentinel 3 meses (R$97/mês = R$291 total)
- Upsell: Projeto IAH (R$3.000+) após 30 dias de dados

---

## BLOCO 7 — CHECKLIST DE LANÇAMENTO
*(Em ordem cronológica de dependência)*

```
SEMANA 1 — Fundação Legal & Financeira
  [ ] Abrir MEI/LTDA
  [ ] Abrir conta PJ
  [ ] Criar conta Stripe + verificar
  [ ] Criar produtos Stripe (R$50 + R$97/mês)
  [ ] Registar / verificar domínio vanguard.tech

SEMANA 2 — Deploy & Pagamentos
  [ ] Deploy Hostinger (landing + quiz)
  [ ] Implementar endpoint Stripe /sentinel-checkout
  [ ] Testar checkout ponta a ponta
  [ ] Configurar Cloudflare + pixel.vanguard.tech
  [ ] Email profissional contato@vanguard.tech

SEMANA 3 — Primeiros Contactos
  [ ] 20 diagnósticos via prospectar.ps1
  [ ] Enviar 20 mensagens WhatsApp
  [ ] Follow-up com interessados
  [ ] 1ª reunião de vendas

SEMANA 4 — Primeiro R$ Real
  [ ] 1 cliente Neural Sentinel activo (R$97/mês)
  [ ] Pixel instalado no site do cliente
  [ ] Primeiro relatório Sentinel enviado
  [ ] Plano de upsell preparado
```

---

## BLOQUEADORES IDENTIFICADOS

| Bloqueador | Impacto | Solução |
|-----------|---------|---------|
| Sem CNPJ | Stripe não activa | Abrir MEI esta semana |
| Stripe não configurado | Zero receita | Prioridade 1 V20 |
| Site não deployado | Cliente não pode aceder | Deploy Hostinger V20 |
| Endpoint /sentinel-checkout inexistente | Paywall não funciona | Claude constrói em V20 |
| WABA não configurado | Hermes não envia | Fase 2 (após 1º cliente) |

---

## ORÇAMENTO DE ARRANQUE ESTIMADO

| Item | Custo Mensal | Custo Único |
|------|-------------|------------|
| Hostinger | já pago | — |
| Cloudflare Workers Paid | US$5 (~R$27) | — |
| Stripe (comissão) | 3,4% das vendas | — |
| SendGrid Free | R$0 | — |
| MEI | R$71/mês (DAS) | — |
| Domínio .tech | — | ~R$55/ano |
| **TOTAL mínimo** | **~R$100/mês** | **~R$55** |

**Breakeven:** 2 clientes Neural Sentinel (R$194/mês) cobrem toda a infraestrutura.

---

## PRÓXIMA ACÇÃO IMEDIATA

1. **Eduardo abre o MEI** (30 min no gov.br)
2. **Eduardo cria conta Stripe** com o CNPJ
3. **Claude (V20) implementa** o endpoint Stripe + deploy Hostinger
4. **Primeiro contacto WhatsApp** ainda esta semana
