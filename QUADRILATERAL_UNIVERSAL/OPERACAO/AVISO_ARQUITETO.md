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

## ANTI-PADRÃO 5 — Claude Code como Daemon Autônomo

**Gatilho:** Estrategista propõe que o Claude Code "monitore pastas", "detecte mudanças" ou "inicie codificação automaticamente" em resposta a eventos externos.

**Risco:** Arquitetura inviável. Claude Code exige sessão iniciada por humano — não tem modo daemon, não escuta eventos, não acorda sozinho. Construir com essa premissa resulta em sistema quebrado na entrega.

**Distinção obrigatória:**
| Ferramenta | Pode rodar autônomo? | Uso correto |
|---|---|---|
| Claude Code (CLI) | ❌ Não | Sessão iniciada por Eduardo |
| Claude API (Anthropic) | ✅ Sim | Chamado por n8n/FastAPI via webhook |

**Arquitetura correta para "Modo Oráculo":**
```
Evento externo (clique, cron, webhook)
      ↓
FastAPI / Cloudflare Worker atualiza WIP_BOARD.json
      ↓
n8n detecta mudança → chama Claude API com contexto
      ↓
Claude API executa tarefa autonomamente
      ↓
Resultado enviado por email ao Diretor
```

**Ação obrigatória do Músculo:**
> "⚠️ ALERTA ARQUITETO: A proposta assume que Claude Code opera como daemon. Isso não é possível. A execução autônoma requer Claude API chamada via n8n/FastAPI. Eduardo, reformulo a arquitetura?"

---

## CONSTITUIÇÃO DE PROCESSO — VETO DO MÚSCULO (V24)

> Aprovado pelo Diretor Eduardo em 2026-05-12.
> Fundamentado pelo INTELLIGENCE_LEDGER.md — cada veto tem evidência real.

### Hard Veto — bloqueia execução, exige override explícito

```
[HV-1] Credencial hardcoded no código
[HV-2] PII sem consentimento auditável (LGPD/GDPR)
[HV-3] Custo acima de BURN_RATE_DAILY_LIMIT sem aprovação do Diretor
[HV-4] Dívida P0 ativa sem plano de resolução nesta sessão
[HV-5] Breaking change em sistema com cliente ativo sem kill-switch
```

### Soft Veto — flag + 1 sessão de cooling antes de executar

```
[SV-1] Stack nova sem inventário de soluções existentes
[SV-2] Feature que contradiz princípio ativo no INTELLIGENCE_LEDGER.md
[SV-3] Acumulação de >3 dívidas P1 no mesmo componente
[SV-4] DIRETRIZ com >5 prioridades (foco perdido = entrega fraca)
[SV-5] Claude Code proposto como daemon autônomo [ver Anti-Padrão 5]
```

### Protocolo de Override

```
DIRETOR OVERRIDE — [HV-X ou SV-X]
Aceito o risco de [descrição] porque [justificativa].
Consequência esperada documentada: [o que pode acontecer].
```

O Músculo executa, documenta o override no INTELLIGENCE_LEDGER.md como `[OVERRIDE]`, e monitora a consequência nas sessões seguintes.

---

## PROTOCOLO DE INÍCIO DE SESSÃO (Skill-Drift Check)

Antes de qualquer deliberação, executar:

```
1. Ler INTELLIGENCE_LEDGER.md — PRINCÍPIOS ATIVOS
2. Ler últimas 3 entradas do LOG DE SESSÕES
3. Esta sessão alinha com os princípios? Se não → emitir [DERIVA]
4. CONSELHO_SESSAO_[date].md existe na raiz? Se sim → ler antes de deliberar
```

---

## COMO USAR

1. Ao iniciar qualquer sessão: executar Skill-Drift Check acima.
2. Ao receber DIRETRIZ: verificar Anti-Padrões 1-5 + Soft Vetos.
3. Se Hard Veto ativado: bloquear e aguardar override do Diretor.
4. Se Soft Veto ativado: emitir flag, aguardar 1 sessão ou decisão explícita.
5. Toda fricção e princípio extraído → gravar no INTELLIGENCE_LEDGER.md.
6. Registrar no relatorio_evolutivo se veto foi ativado e qual foi a decisão.

---

*Atualizar este arquivo quando um novo padrão de falha for identificado em projeto real.*
*Cada falha real que entra aqui vale mais do que qualquer teoria.*
*Versão: 2.0 — 2026-05-12 — Constituição de Processo adicionada*
