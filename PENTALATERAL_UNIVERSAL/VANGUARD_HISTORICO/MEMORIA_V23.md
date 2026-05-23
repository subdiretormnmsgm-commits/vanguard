# MEMÓRIA V23 — The Revenue Strike
**Data:** 2026-05-10
**Versão:** 23
**Tema:** Fim do laboratório — início do faturamento

## O Que Foi Construído

### 1. Tracking Pixel — Dívida Técnica V22 Paga (api/sentinel_report.py)
- `<img src="https://vanguard.tech/api/sentinel/track/{open_token}.gif">` injectado no template HTML do Sentinel Report Card
- `open_token` gerado via SHA-256(tenant_id + timestamp) — único por relatório
- `open_token` armazenado em `sentinel_report_log` → `sentinel_escalation.py` pode agora detectar emails abertos vs ignorados com precisão
- A Escalation Ladder deixa de operar às cegas

### 2. Upsell Engine (api/sentinel_report.py)
- Nova função `_gerar_upsell_section(tenant_nome, roi_recuperado, ticket_medio, week_count)`
- Activado quando: week_count >= 3 AND roi_recuperado > 0
- ROI calculado como: `max(0, fire_delta_positivo × ticket_medio)`
- `ticket_medio` declarado pelo tenant em `tenants.metadata.ticket_medio` (default: R$300)
- Haiku gera proposta personalizada de upgrade para Projecto IAH (R$6.000) no rodapé do email
- Custo Haiku: ~$0.01 por proposta (adicional ao relatório)
- Resultado esperado: conversão passiva de Sentinel → IAH sem intervenção do Diretor

### 3. Partner Portal Alpha (api/partner_portal.py)
- `POST /api/partners/register` — registo de agência: gera `VGP-XXXX` + API key (raw mostrada apenas uma vez, armazenada como SHA-256)
- `GET /api/partners/link` — link de afiliado único por agência
- `GET /api/partners/dashboard` — métricas de performance: referrals activos, comissões ganhas/pendentes
- `GET /api/partners/clients` — Maturity Scores dos clientes com `partner_consent: true` (LGPD compliant)
- `POST /api/partners/commission/record` — registo de comissão quando referral converte
- `POST /api/partners/referral/register` — chamado pelo backend quando novo tenant usa `?ref=VGP-XXXX`
- Comissões: R$19,40 (20% do 1.º mês Sentinel) + R$600 (IAH convertido)

### 4. Design "Sovereign Intelligence Terminal" (assets/css/v22-sovereign.css)
- **Fontes:** Chakra Petch (headlines HUD) · DM Sans (body) · JetBrains Mono (dados)
- **Background:** hex grid animado SVG + radial gradients (cyan/purple)
- **Global scan line:** sweep animado a cada 10s
- **Intel Ticker:** faixa de dados ao vivo após a navbar (FIRE · HERMES · SENTINEL · ORÁCULO)
- **Holographic card sweep:** efeito de sweep em hover nas feature cards
- **Pricing Section:** Neural Sentinel R$97/mês vs Projecto IAH R$3k–6k com scan-reveal animado
- **Todos os V18 → V22** actualizados no HTML

### 5. Schema SQL (infra/schema_v23.sql)
- `partner_agencies` — registo de agências com API key hashed + partner_code
- `partner_referrals` — relação agência ↔ tenant indicado
- `partner_commissions` — comissões ganhas por tipo (sentinel/iah) + flag pago
- VIEW `partner_mrr` — MRR por agência para o dashboard do Diretor
- ALTER TABLE `sentinel_report_log` — garante colunas `open_token`, `email_aberto`, `aberto_em`
- Índice LGPD: `idx_tenants_partner_consent` — filtra tenants consented em ms

## Dependências Externas
- Sem novas dependências — Python stdlib `hashlib` + `secrets` já em uso
- Supabase: 3 novas tabelas + 1 VIEW
- Partner Portal: autenticação por `X-Partner-Key` (hash SHA-256)

## Variáveis de Ambiente Novas
Nenhuma — o Partner Portal usa SUPABASE_URL + SUPABASE_SERVICE_KEY já configurados.
