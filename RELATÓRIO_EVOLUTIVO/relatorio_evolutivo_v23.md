# RELATÓRIO EVOLUTIVO V23 — The Revenue Strike
**Data:** 2026-05-10
**Ciclo PDCA:** Act (Claude) — conversão de tecnologia em canal de vendas real

## O Que Foi Construído

### 1. Tracking Pixel — Dívida Técnica Paga
Pixel 1×1 GIF nativo (sem deps externas) injectado no template HTML do Sentinel Report Card. `open_token` SHA-256 único por relatório. A Escalation Ladder agora sabe se o cliente leu ou ignorou o email — o que activa o nível correcto da cadência.

### 2. Upsell Engine — O Sentinel Report como Vendedor Silencioso
Na semana 3+ com ROI positivo, o Haiku gera uma proposta de upgrade para Projecto IAH personalizada com os dados reais do tenant. Zero intervenção do Diretor. A proposta aparece no rodapé do email quando o cliente já viu o valor do produto — não é venda fria, é consequência lógica dos dados.

### 3. Partner Portal Alpha — Canal de Vendas Externo
Agências de marketing recebem um link único (`?ref=VGP-XXXX`) e um dashboard com o Maturity Score dos clientes que consentiram. Quando o score cai, a agência tem o argumento perfeito para vender mais serviço — e a Vanguard paga comissão automática quando converte.

### 4. Design Sovereign Intelligence Terminal
Site transformado: Chakra Petch + DM Sans + hex grid + intel ticker + pricing section + holographic cards. O site actual comunica agora o nível de sofisticação do produto.

## Avaliação das Ideias Gemini + Eduardo (V23)

| Ideia | Origem | Decisão | Nota |
|-------|--------|---------|------|
| Tracking pixel no template email | NotebookLM + Skill | CONSTRUÍDO — dívida técnica paga | — |
| Upsell Engine (Sentinel → IAH) | Gemini | CONSTRUÍDO — semana 3+ com ROI > 0 | — |
| Partner Portal Alpha | Gemini | CONSTRUÍDO — LGPD compliant | — |
| Hermes Loop Autónomo | Gemini | NÃO CONSTRUÍDO — já existe na V22 | Erro de contexto do Gemini |
| Oráculo para parceiros | Gemini | ADIADO — sem dados suficientes ainda | Correcto adiar |
| Design V22 Sovereign Terminal | Eduardo | CONSTRUÍDO — Chakra Petch + hex grid | — |

## ANÁLISE DE NEGÓCIO — V23

### Pontos Fortes

**1. Upsell Engine automatiza a expansão de MRR**
Antes da V23, a única forma de vender IAH era Eduardo fazer uma chamada activa. Agora, o sistema detecta o momento exacto (semana 3+, ROI positivo, cliente satisfeito) e gera a proposta automaticamente. A conversão Sentinel → IAH pode acontecer sem o Diretor abrir o WhatsApp.

**2. Partner Portal multiplica o canal sem custo fixo**
Cada agência parceira é um vendedor externo com incentivo de comissão. O dashboard com Maturity Scores transforma o produto num argumento de vendas para a agência — não precisam de entender de tecnologia para vender, precisam apenas de mostrar "o score do seu cliente caiu 1.2 pontos esta semana".

**3. Tracking pixel fecha o loop da Escalation Ladder**
Com o pixel activo, o sistema sabe se o email foi lido. Semana 2 de silêncio → WhatsApp automático. Semana 3 → Hermes alerta Eduardo. Semana 4 → IAH Rescue Plan. Antes do pixel, a ladder era cega.

**4. Design profissional eleva percepção de valor**
Chakra Petch + hex grid + intel ticker comunicam "plataforma de inteligência militar", não "site de agência". Para um produto de R$97/mês, o visual é parte da justificação do preço.

**5. ROI baseado em ticket_medio real**
A proposta de upsell agora usa dados declarados pelo cliente (ticket médio) para calcular o ROI. "O sistema recuperou R$1.800 esta semana" é mais convincente do que "o seu score FIRE aumentou".

### Pontos Fracos e Riscos

**1. CRÍTICO: ainda sem clientes — V23 não muda isso sozinha**
O Partner Portal, o Upsell Engine e o tracking pixel só têm valor com clientes activos. Com 0 tenants, 0 pixels são lidos, 0 upsells são enviados, 0 parceiros têm argumento. A V23 construiu o motor — o combustível é o primeiro cliente.

**Acção correctiva:** MEI + Stripe + git push + 10 contactos esta semana. O código está pronto. O bloqueio é operacional, não técnico.

**2. Partner Portal sem provas = argumento fraco para agências**
Uma agência que indica a Vanguard a um cliente está arriscando a sua relação com esse cliente. Sem um case de sucesso documentado ("a Clínica X aumentou 40% o FIRE score em 30 dias"), a proposta para parceiros é fraca.

**Acção correctiva:** Prospectar agências activamente só depois do primeiro case documentado. O Portal existe — mas o pitch de parceria aguarda.

**3. ticket_medio sem campo de onboarding**
O Upsell Engine usa `tenants.metadata.ticket_medio` mas não há um passo de onboarding que peça este valor ao cliente. Sem ele, usa R$300 (conservador — pode subestimar o ROI real).

**Acção correctiva:** Adicionar pergunta ao quiz: "Qual é o ticket médio de cada cliente que fecha?". Campo simples, impacto directo no cálculo de ROI do Upsell Engine.

**4. Comissões do Partner Portal dependem do Stripe webhook**
O endpoint `/commission/record` deve ser chamado pelo webhook do Stripe quando uma subscrição se activa. Se o webhook não estiver configurado, as comissões não são registadas automaticamente.

**Acção correctiva:** Parte da setup do Stripe (que já está pendente). Ao activar o Stripe, configurar o webhook para chamar `/commission/record`.

### Avaliação do Consultor

**Classificação geral da V23: A-**

A V23 está focada no lugar certo: vender. O Upsell Engine é a funcionalidade mais imediata que pode gerar MRR sem esforço do Diretor. O Partner Portal é a aposta de médio prazo correcta — quando houver provas, multiplica o canal. O design é genuinamente premium.

A nota não é A porque as peças estão prontas mas o primeiro cliente ainda não existe. Cada versão sem cliente pagante aumenta o custo de oportunidade. A V24 só deve existir depois do primeiro relatório Sentinel enviado para um cliente real.

**Recomendação:** Fechar a V23, git push, e dedicar esta semana exclusivamente ao operacional. O código faz a sua parte — agora é a vez de Eduardo fazer a dele.

## 5 Ideias Disruptivas para V24

---

**[V24-001] TICKET_MEDIO WIZARD — Onboarding Inteligente**
Adicionar ao quiz (passo 8, opcional) a pergunta "Qual o seu ticket médio?". O valor alimenta o ROI Calculator do Upsell Engine em tempo real. Com 50 tenants declarando o ticket médio, o cálculo de "receita recuperada" deixa de ser estimativa e passa a ser prova matemática personalizada. Impacto: upsell mais convincente, menor custo de persuasão.

---

**[V24-002] PARTNER LEADERBOARD — Gamificação de Vendas**
Dashboard público (sem dados privados) que mostra o ranking de agências parceiras por clientes activos e comissões geradas. "Agência Tráfego SP #1 — 12 clientes activos — R$234 ganhos este mês." Cria pressão social entre agências e incentiva a prospecção activa sem custo para a Vanguard. Custo: zero — é uma VIEW com dados já existentes.

---

**[V24-003] SENTINEL ROI REPORT — Relatório Financeiro Mensal**
Além do Report Card semanal (FIRE/HOT/WARM), criar um relatório mensal mais denso: ROI total acumulado, número de leads convertidos estimados, comissão que o cliente "pagou" ao sistema (leads × taxa de conversão × ticket médio). Documento gerado por Claude Sonnet (mais detalhado que Haiku) e enviado no dia 1 de cada mês. Posiciona o Neural Sentinel como CFO virtual, não como ferramenta de marketing.

---

**[V24-004] PARTNER CONSENT FLOW — Opt-in no Quiz**
Adicionar ao passo de contacto do quiz: "Autorizar a agência [nome] a acompanhar o seu progresso?" (toggle). Se sim, `partner_consent: true` no metadata, e a agência ganha acesso imediato ao Maturity Score no dashboard. Remove a fricção actual (onde o consentimento é manual), acelera a activação do dashboard de parceiros. LGPD compliant por design.

---

**[V24-005] IAH PLAYBOOK AUTO-GERADO — 90 dias com IA**
Ao converter um cliente Sentinel → Projecto IAH, o Claude Sonnet gera automaticamente um Playbook de 90 dias personalizado com o sector, ticket médio e gargalos identificados no Quiz. Cada tarefa do Playbook inclui o módulo da plataforma Vanguard que a executa. Lock-in disfarçado de consultoria: o cliente não consegue seguir o plano sem usar o sistema. Ticket adicional: R$500/mês.

---

## Estado do Ecossistema ao Fechar V23

```
ACTO I — SaaS Operacional (V1–V13):              COMPLETO
ACTO II — Terminal de Dados (V14–V23):           98% (aguarda 1 cliente + Stripe)
ACTO III — Bolsa de Intenção (V22 Oráculo):      v0.1 LANÇADA — aguarda dados
ACTO IV — Canal de Vendas (V23 Partners):        v0.1 LANÇADA — aguarda provas
```

## Plano Imediato (Por Ordem de Prioridade Real)

1. **HOJE — Não é código:** MEI aberto em gov.br/empresas-e-negocios (CNAE 6209-1/00)
2. **HOJE:** Conta Stripe BR activa + produto Neural Sentinel R$97/mês BRL criado
3. **HOJE:** GitHub Secrets: FTP_SERVER + FTP_USERNAME + FTP_PASSWORD
4. **HOJE:** git push → CI/CD → site live na Hostinger
5. **AMANHÃ:** schema_v23.sql aplicado no Supabase + SENDGRID_API_KEY + CRON_SECRET
6. **ESTA SEMANA:** 10 contactos via prospectar.ps1 → 1 Neural Sentinel activo
7. **PRÓXIMA SEMANA:** Primeiro Sentinel Report enviado (com pixel + Upsell Engine activo)
8. **COM 1 CLIENTE ACTIVO:** Prospectar 1 agência parceira para o Partner Portal
9. **COM 3 CLIENTES:** Activar Oráculo Pulse para agências externas (Early Access)
10. **V24:** Só depois do primeiro MRR recebido — não antes
