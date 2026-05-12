# AVISO DO ARQUITETO — Padrões de Falha da Memória Longa

> Lido pelo Músculo ANTES de iniciar qualquer build.
> Ativado sempre que o Estrategista sugerir qualquer dos cenários abaixo.
> Não é opcional. É proteção do projeto e do cliente.

---

## ANTI-PADRÃO 1 — SaaS B2B sem Billing

**Gatilho:** Estrategista pede features core (dashboard, API, lógica de negócio) sem mencionar billing.

**Risco:** Refatoração pesada quando o Stripe for plugado depois. Arquitetura de multi-tenant precisa do modelo de billing desde o início.

**Ação obrigatória do Músculo:**
> "⚠️ ALERTA ARQUITETO: O plano atual não inclui billing (Stripe) antes das features core. Histórico mostra refatoração pesada neste cenário. Recomendo conectar Stripe no Módulo 0 antes de qualquer feature. Eduardo, veredito?"

---

## ANTI-PADRÃO 2 — Custom/Nativo quando Off-the-Shelf resolve

**Gatilho:** Estrategista sugere desenvolvimento custom de e-commerce, app mobile nativa, ou CMS próprio.

**Regra:** Se uma solução off-the-shelf (Shopify, PWA, Webflow, Bubble) resolve 80% do problema, custom só se justifica se o 20% restante for o diferencial competitivo central.

**Ação obrigatória do Músculo:**
> "⚠️ ALERTA ARQUITETO: Solução custom sugerida. Verificando se off-the-shelf cobre 80%+ do problema. [análise]. Recomendação: [off-the-shelf / custom justificado porque X]. Eduardo, veredito?"

---

## ANTI-PADRÃO 3 — Automação/IA sem Logs e Feedback

**Gatilho:** Qualquer fluxo de automação (n8n, Zapier, Python) ou LLM sem sistema de logs estruturados.

**Risco:** Falha silenciosa. Sem logs, é impossível auditar, debugar ou provar ao cliente que o sistema funcionou.

**Regra:** Todo fluxo automatizado → tabela de logs no Supabase ou arquivo de log estruturado (JSON). Todo LLM → ciclo de feedback com avaliação de output.

**Classificação automática:** Fluxo sem logs = **Dívida P2** declarada na MEMÓRIA.

**Ação obrigatória do Músculo:**
> "⚠️ ALERTA ARQUITETO: Fluxo sem logs identificado. Adicionando tabela de logs antes de qualquer outra feature. Dívida P2 declarada se não for resolvido nesta iteração."

---

## ANTI-PADRÃO 4 — Marketplace sem Split de Pagamento Nativo

**Gatilho:** Estrategista sugere marketplace onde o cliente recebe pagamento e repassa para outros.

**Risco:** Fazer split manual (transferência bancária, pix manual) é armadilha de compliance, IOF, e responsabilidade legal. Em escala, vira dívida P0.

**Regra:** Marketplace com split → Stripe Connect obrigatório desde a Fase 0. Sem Stripe Connect disponível no Brasil para o modelo = reformular o modelo de negócio antes de construir.

**Ação obrigatória do Músculo:**
> "⚠️ ALERTA ARQUITETO: Marketplace com split de receita identificado. Stripe Connect é obrigatório. Verificando disponibilidade para o modelo de negócio específico. Eduardo, veredito antes de avançar?"

---

## COMO USAR

1. Ao receber qualquer DIRETRIZ do Estrategista, ler esta lista antes de codificar.
2. Se qualquer anti-padrão for detectado → emitir o alerta correspondente no chat com Eduardo.
3. Eduardo dá veredito → Músculo avança.
4. Registrar no relatorio_evolutivo se o alerta foi ativado e qual foi a decisão.

---

*Atualizar este arquivo quando um novo padrão de falha for identificado em projeto real.*
*Cada falha real que entra aqui vale mais do que qualquer teoria.*
