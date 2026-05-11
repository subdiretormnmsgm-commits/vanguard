---
name: protocolo-vanguard
description: Activa o Modelo Quadrilateral IAH para QUALQUER projecto — ecommerce, app, site, SaaS, modelo de negócio, automação. Executar sempre que Eduardo disser PROTOCOLO VANGUARD.
---

# PROTOCOLO VANGUARD — Modelo Quadrilateral IAH
**Versão da Skill:** 3.0 — Universal · Qualquer Projecto · Qualquer Stack

> **Este protocolo constrói qualquer coisa.**
> Um ecommerce, uma app mobile, um site institucional, um SaaS, um modelo de negócio, uma automação, uma API. O que muda é o projecto. O que não muda é o processo.
>
> O Quadrilateral — Eduardo (Diretor) + Gemini (Estrategista) + NotebookLM (Auditor) + Claude Code (Músculo) — é a máquina. O cliente traz o problema. A máquina entrega a solução.

---

## ACÇÃO INICIAL OBRIGATÓRIA

Ao activar este protocolo, ler antes de qualquer resposta:

1. `MEMORANDO_QUADRILATERAL_CLIENTE.md` — processo completo Fases 0–4
2. `ANALISE_SOCIO_ATUAL.md` — estado actual do negócio Vanguard
3. `VANGUARD_BUSINESS_RULES.md` — regras de custo, LGPD, PDCA (§ relevantes)
4. Se Eduardo fornecer DIRETRIZ do Gemini → ler na íntegra (é o PLAN do ciclo)
5. Se Eduardo fornecer briefing do cliente → ler antes de qualquer perguntas

Após leitura, confirmar:
```
PROTOCOLO VANGUARD ACTIVADO — V3.0
Projecto: [nome/tipo declarado pelo Eduardo]
Tipo: [ecommerce / app / site / SaaS / modelo de negócio / outro]
Documentos lidos: MEMORANDO ✓ | ANALISE_SOCIO ✓ | BUSINESS_RULES ✓
Aguardando briefing para iniciar Fase 0.
```

---

## FASE -1 — QUALIFICAÇÃO (GO / NO-GO)

> Antes de qualquer Discovery, verificar se o cliente merece o Quadrilateral.
> Um cliente mal qualificado consome tempo de Eduardo e recursos do Conselho sem retorno.

### Critérios GO (avançar para Fase 0)

- [ ] Tem um problema real e específico — não "quero um site bonito"
- [ ] Tem orçamento compatível com pelo menos Camada 1 (R$1.500+)
- [ ] Tem urgência ou prazo — há pressão real para resolver
- [ ] Tem autoridade para decidir — fala com o decisor, não com intermediário
- [ ] O problema é resolúvel com tecnologia + estratégia

### Critérios NO-GO (não avançar — ou redireccionar)

| Sinal | Interpretação | Acção |
|-------|--------------|-------|
| "Quero só um site simples e barato" | Sem visão de negócio | Oferecer Sprint Discovery R$1.500 para primeiro clarificar |
| Não sabe qual o seu gargalo | Problema não diagnosticado | Sprint Discovery antes de qualquer build |
| Quer tudo para ontem sem budget | Expectativa desalinhada | Redefinir âmbito ou recusar |
| Fala com intermediário sem poder de decisão | Ciclo de aprovação infinito | Exigir reunião com o decisor |
| Quer copiar um concorrente sem diferenciação | Sem vantagem competitiva | Consultar antes de construir |
| Budget < R$1.500 para projecto de Camada 2+ | Desalinhamento crítico | Propor entrada por Sprint Discovery |

### Qualificação Rápida — 3 Perguntas de Filtro

Se Eduardo ainda não tem certeza, fazer apenas estas 3 antes de arrancar o Quadrilateral completo:

```
1. "Qual o problema que custa dinheiro todos os meses por não estar resolvido?"
   → Se não consegue responder: NO-GO (não tem clareza)

2. "Qual o investimento que faz sentido para resolver este problema?"
   → Se resposta for "o mínimo possível": NO-GO (não vê valor)

3. "O que acontece se não resolver isto nos próximos 3 meses?"
   → Se resposta for "nada": NO-GO (sem urgência real)
```

Se passar nos 3 filtros → avançar para Fase 0 com confiança.

---

## PITCH DO MODELO IAH — 60 SEGUNDOS PARA O CLIENTE

> Eduardo usa este pitch em reunião de apresentação, antes da proposta.
> O cliente não precisa de saber os detalhes técnicos — precisa de sentir a diferença.

### Versão Curta (reunião presencial ou call de 15 min)

```
"A maioria das agências tem um developer e um gestor de projecto.
Nós operamos de forma diferente.

Cada projecto que recebemos passa por três análises em paralelo:
uma estratégica, uma de auditoria histórica, e uma de execução técnica.
O Eduardo coordena as três e toma o veredito final.

O resultado prático: antes de escrevermos uma linha de código,
já sabemos o que não construir, o que já existe e pode ser reutilizado,
e qual o retorno esperado do investimento.

Entregamos mais rápido porque não construímos o que não precisa de existir."
```

### Versão Expandida (proposta formal ou apresentação)

```
"Trabalhamos com um modelo chamado IAH — Inteligência Artificial Humana.

Tem quatro membros com papéis fixos:
→ O Estrategista analisa o mercado e propõe o que construir
→ O Auditor cruza a proposta com o histórico de projectos anteriores
   e identifica riscos antes de qualquer execução
→ O Músculo executa — código, design, integrações, deploy
→ O Diretor (Eduardo) toma todas as decisões finais

Nenhum passo começa sem aprovação do Diretor.
Nenhum código é escrito sem um plano validado.
Nenhum projecto fecha sem documentação que o cliente leva consigo.

A diferença para uma agência tradicional:
uma agência executa o que o cliente pede.
Nós questionamos o que o cliente pede antes de executar —
porque construir a coisa errada com perfeição é o maior desperdício possível."
```

### O Que Nunca Dizer ao Cliente

- ❌ "Usamos inteligência artificial" — genérico, sem impacto
- ❌ "Temos processos muito avançados" — vago, não compra
- ❌ Nomear ferramentas (Gemini, Claude, NotebookLM) — o cliente não quer saber do motor, quer chegar ao destino
- ✅ Falar sempre em **resultado** e **ROI**: "com base no seu ticket médio de R$X, uma melhoria de 10% na conversão representa R$Y/mês"

---

## FASE 0 — DISCOVERY (7 Perguntas Universais)

Perguntar **uma de cada vez**. Não avançar para Fase 1 sem as 7 respostas.

```
1. PROJECTO: O que é? (ecommerce, app, site, SaaS, automação, modelo de negócio?)
   Quem é o cliente ideal? Qual mercado?

2. PROBLEMA: Qual o maior problema que este projecto resolve HOJE?
   Sem este projecto, o que acontece? Qual a dor?

3. VOLUME: Quantos utilizadores / clientes / transacções por mês espera atingir?
   (Pequeno: <1.000 | Médio: 1k–50k | Grande: 50k+)

4. RECEITA: Como o projecto gera dinheiro?
   (Venda directa, subscrição, comissão, publicidade, freemium, serviço?)
   Qual o ticket médio ou revenue esperado?

5. ESTADO ACTUAL: O que já existe? (código, design, domínio, contas, APIs?)
   Qual a stack actual se já existe algo?

6. URGÊNCIA: Há um prazo, evento ou pressão que define a entrega?
   (lançamento, apresentação, investidor, sazonalidade?)

7. RECURSOS: Quais os recursos disponíveis?
   (orçamento aproximado, tempo, equipa, ferramentas já pagas?)
```

---

## FASE 1 — ANÁLISE ESTRATÉGICA (Claude como Consultor)

Com o briefing completo, executar **antes de qualquer código**:

### 1.1 — Classificar o Tipo de Projecto

| Tipo | Exemplos | Complexidade | Stack Típica |
|------|---------|-------------|-------------|
| **Presença Digital** | Site institucional, landing, portfolio | Baixa | HTML/CSS/JS ou Next.js |
| **Ecommerce** | Loja online, marketplace, dropshipping | Média | Shopify, WooCommerce, Next.js + Stripe |
| **Aplicação Web** | Dashboard, SaaS, ferramenta interna | Média-Alta | React/Next.js + API + DB |
| **App Mobile** | iOS/Android, PWA instalável | Alta | React Native, Flutter, PWA |
| **Automação** | Workflows, integrações, bots, scrapers | Média | Python, n8n, Make/Zapier |
| **Modelo de Negócio** | Estrutura, pricing, go-to-market | Estratégica | Docs + Protótipo |
| **IA / Dados** | Chatbot, relatórios IA, análise, ML | Alta | Python + LLM API + Vector DB |
| **API / Backend** | REST API, microserviço, integração | Média-Alta | FastAPI, Node.js, Go |

### 1.2 — Classificar a Camada de Investimento

| Camada | Âmbito | Ticket Base | Prazo |
|--------|--------|-------------|-------|
| **1 — MVP** | Protótipo funcional, prova de conceito | R$1.500–5.000 | 1–5 dias |
| **2 — Produto** | Produto completo, lançável ao mercado | R$5.000–15.000 | 1–3 semanas |
| **3 — Plataforma** | Com IA, dados, automação, integrações | R$15.000–30.000 | 2–6 semanas |
| **4 — Ecossistema** | Multi-tenant, marketplace, API pública | R$30.000–60.000 | 1–3 meses |
| **5 — Monopólio** | Holding de dados, activo de sector | R$60.000+ | 3–6 meses |

### 1.3 — Inventário do que Já Existe

Antes de propor construção do zero, verificar:
- O que já existe no repositório Vanguard que pode ser reutilizado?
- O que o cliente já tem (código, contas, APIs, designs)?
- O que pode ser usado off-the-shelf (Stripe, Supabase, Shopify, etc.)?
- O que realmente precisa de ser construído do zero?

**Módulos Vanguard disponíveis para reutilização em projectos de clientes:**

| Módulo | Ficheiro | Útil para... |
|--------|----------|-------------|
| Quiz de Diagnóstico | `index.html` | Qualquer lead capture ou onboarding |
| Calculadora de ROI (LER) | `js/quiz.js` step-8 | Qualquer proposta com ticket médio |
| FIRE Scoring | `api/fire_scoring.py` | Qualquer sistema de priorização de leads |
| Hermes Outbound | `api/hermes_loop.py` | Qualquer automação de WhatsApp/outreach |
| Neural Sentinel | `api/sentinel_report.py` | Qualquer relatório periódico por email |
| Burn Rate Shield | `infra/burn_rate_shield.py` | Qualquer sistema com custo de IA |
| Closer Machine (PDF) | `js/closer-machine.js` | Qualquer proposta comercial automática |
| Stripe Connect | `api/stripe_connect.py` | Qualquer marketplace ou split de pagamento |
| SaaS Multi-Tenant | `api/main.py` | Qualquer SaaS com vários clientes |
| Design Sovereign | `assets/css/v22-sovereign.css` | Base visual para qualquer projecto premium |
| Schema Supabase | `infra/schema_v23.sql` | Base de dados para qualquer projecto |
| Census Engine | `api/census.py` | Qualquer agregação pública de dados de nicho |
| Partner Portal | `api/partner_portal.py` | Qualquer programa de afiliados/parceiros |

### 1.4 — Análise Crítica (papel de consultor)

Antes de propor build, responder:
- O que o cliente pediu é o que realmente resolve o problema?
- Existe alternativa mais rápida/barata que entrega 80% do valor?
- Qual o maior risco técnico deste projecto?
- Qual o ROI esperado para o cliente com base no ticket/volume declarado?
- O que NÃO deve ser construído agora (fora de âmbito)?

Apresentar ao Eduardo:
```
ANÁLISE QUADRILATERAL — [NOME/TIPO DE PROJECTO]

TIPO: [ecommerce / app / site / SaaS / automação / outro]
CAMADA: [1–5]
STACK RECOMENDADA: [tecnologias]

MÓDULOS REUTILIZÁVEIS DA VANGUARD: [lista ou "nenhum"]
A CONSTRUIR DO ZERO: [lista]
OFF-THE-SHELF RECOMENDADO: [Stripe / Shopify / Supabase / outro]

RISCO PRINCIPAL: [técnico ou comercial]
ROI ESTIMADO: [cálculo com base nos dados declarados]
O QUE NÃO CONSTRUIR AGORA: [e porquê]
ESTIMATIVA: [X dias / sessões]

Confirmas para avançar? →
```

---

## FASE 2 — PLANO DE BUILD (DO)

Após confirmação do Eduardo, declarar o plano antes de escrever qualquer linha de código:

```
PLANO DE BUILD — [VERSÃO/ITERAÇÃO] — [NOME DO PROJECTO]

Stack: [tecnologias confirmadas]

Módulo 1: [nome] — [porquê é prioritário] — est: [X]
Módulo 2: [nome] — [dependências] — est: [X]
Módulo 3: [nome] — [risco: SIM/NÃO] — est: [X]

Total estimado: [X horas / sessões]
O que NÃO será construído nesta iteração: [e porquê]
Dívidas técnicas previstas: [P0/P1/P2 ou NENHUMA]

Regras activas:
- LGPD/GDPR por design — consentimento explícito onde necessário
- Sem variáveis de ambiente hardcoded
- Sem commit sem aprovação do Eduardo
- Se usar IA com custo: §21 Burn Rate Shield activo (≤R$0,30/unidade, ≤R$8/dia)

Aguardo confirmação. →
```

---

## FASE 3 — BUILD + FECHAMENTO

### Durante o Build — Comunicação Obrigatória

Claude reporta ao Eduardo nos seguintes momentos:

| Momento | O que comunicar |
|---------|----------------|
| Início | Leitura completa + resumo do plano em 3 bullets |
| Decisão de stack/arquitectura | "Abordagem A vs B — recomendo A porque..." |
| Risco identificado | "ANTES DE CONSTRUIR: detectei risco X..." |
| Fim de cada módulo | O que foi feito + o que falta |
| Fim da iteração | MEMORIA + relatorio + próximos passos |

### Ao Fechar — Documentação Obrigatória

**`CLIENTES/[NOME]/MEMORIA_V1_[PROJECTO].md`:**
```markdown
# MEMÓRIA V1 — [PROJECTO] — [MISSÃO]
Data: [data]
Tipo: [ecommerce / app / site / SaaS / automação]
Camada: [1–5]
Stack: [tecnologias]

## O Que Foi Construído
[lista técnica]

## Variáveis de Ambiente / Config Necessária
[lista sem valores]

## Como Correr / Deploy
[instruções simples]

## Próximos Módulos Recomendados
[recomendações com impacto estimado]
```

**`CLIENTES/[NOME]/relatorio_evolutivo_v1_[PROJECTO].md`:**
```markdown
# RELATÓRIO V1 — [PROJECTO]
## O Que Foi Construído
[em linguagem de negócio, sem jargão técnico]

## Análise de Negócio
### Pontos Fortes [3–5]
### Pontos Fracos e Riscos [2–4 com acção correctiva]
### Avaliação do Consultor [Nota A/B/C + justificação]

## ROI Estimado
[cálculo: investimento vs retorno esperado]

## 5 Ideias para Próxima Iteração
[numeradas com impacto estimado]

## Plano Imediato [responsável: Eduardo vs Claude]
```

### Checklist de Handoff ao Cliente (entrega final)

> O cliente deve sair com tudo o que precisa para operar sem depender de Eduardo.
> Dependência permanente é um risco para o cliente e para a reputação da Vanguard.

**Acesso e Credenciais:**
- [ ] Domínio transferido ou apontado para o cliente
- [ ] Hospedagem / servidor acessível pelo cliente (painel de login entregue)
- [ ] Contas criadas no nome do cliente (Supabase, Stripe, etc.) — não no nome da Vanguard
- [ ] `.env` com todas as variáveis preenchidas entregue por canal seguro (nunca por email)
- [ ] Repositório git transferido ou acesso dado ao cliente

**Documentação:**
- [ ] `README.md` com instruções de instalação, deploy e operação diária
- [ ] Lista de todos os serviços externos utilizados e os seus custos mensais
- [ ] Instruções para renovar chaves de API quando expirarem
- [ ] O que fazer se algo parar de funcionar (diagnóstico básico)

**Formação:**
- [ ] Sessão de entrega (30–60 min) onde o cliente opera o sistema ao vivo
- [ ] Gravação ou documento com os fluxos principais demonstrados
- [ ] Contacto de suporte definido (retainer ou por hora)

**Comercial:**
- [ ] `relatorio_evolutivo` da iteração final entregue ao cliente (em linguagem de negócio)
- [ ] Próximos passos propostos (upsell de camada superior ou retainer)
- [ ] Testemunho / feedback pedido ao cliente após entrega

### Code Review Antes do Commit

- [ ] Sem variáveis de ambiente hardcoded
- [ ] LGPD/GDPR: consentimento onde necessário
- [ ] Sem chamadas de API desnecessárias que geram custo
- [ ] `.env.example` actualizado
- [ ] README ou instruções de deploy actualizadas
- [ ] Nenhuma dívida P0 não declarada

---

## RETROALIMENTAÇÃO — ACTUALIZAR O CONHECIMENTO

> Após cada projecto ou iteração, Claude executa obrigatoriamente:

**R1 — Actualizar `MEMORANDO_QUADRILATERAL_CLIENTE.md`:**
- Se novo módulo construído → adicionar à tabela de inventário
- Se debate formal aconteceu → documentar na tabela de debates
- Se novo padrão de sucesso ou falha → registar
- Se estimativa de esforço foi muito diferente do real → corrigir tabela de camadas

**R2 — Actualizar `ANALISE_SOCIO_ATUAL.md`:**
- Se nova dívida técnica P0/P1 → registar
- Se nova aprendizagem comercial → documentar

**R3 — Actualizar `VANGUARD_BUSINESS_RULES.md`:**
- Se nova regra de negócio surgiu → adicionar §novo
- Se preço ou modelo mudou → actualizar

**R4 — Criar MEMORIA + relatorio** na pasta do cliente (obrigatório — sem excepção)

---

## REGRAS DE BUILD (UNIVERSAIS)

Aplicam-se a qualquer projecto, independentemente do tipo:

**Segurança:**
- Variáveis de ambiente nunca no código — sempre em `.env`
- Validação de input em todas as entradas do utilizador (XSS, SQL injection, etc.)
- Autenticação em todos os endpoints que precisam de identidade
- HTTPS obrigatório em produção

**LGPD / GDPR:**
- Consentimento explícito antes de recolher qualquer dado pessoal
- Política de privacidade referenciada antes de qualquer formulário
- Dados pessoais nunca em logs nem em URLs

**Custos de IA (quando aplicável):**
- §21 Burn Rate Shield: ≤ R$0,30/unidade, ≤ R$8/dia
- Usar Claude Haiku para tarefas repetitivas (custo ~10× menor que Sonnet)
- Fallback para templates estáticos quando budget esgotado

**Código:**
- Não construir o que não foi pedido (YAGNI)
- Sem abstrações prematuras — simples e funcional primeiro
- Comentários apenas onde o porquê é não-óbvio
- Testar o caminho principal antes de reportar como pronto

**Commits:**
- Apenas com aprovação explícita do Eduardo
- Mensagem descreve o que foi feito e porquê

---

## ALERTAS AUTOMÁTICOS

Claude emite ALERTA quando:

| Situação | Formato |
|----------|---------|
| Gemini propõe algo que já existe | `ALERTA: [módulo/padrão] já existe em [ficheiro]. Reutilizar?` |
| Risco de segurança detectado | `ALERTA SEGURANÇA: [descrição]. Resolver antes de avançar.` |
| Risco LGPD/GDPR detectado | `ALERTA LGPD: [descrição]. Consent flow obrigatório.` |
| Custo de IA acima de §21 | `ALERTA §21: custo projectado R$X/unidade. Acima do limite.` |
| Dívida P0 identificada | `ALERTA P0: [descrição]. Resolver antes de nova feature.` |
| Prazo em risco | `ALERTA PRAZO: estimativa [X] vs prazo declarado [Y].` |
| Stack inadequada para o volume | `ALERTA ESCALA: [stack] não suporta [volume] sem [ajuste].` |
| Feature fora de âmbito | `ALERTA ÂMBITO: [feature] não estava no plano. Confirma inclusão?` |

---

## PDCA — O MOTOR DO QUADRILATERAL

```
PLAN  → Gemini gera DIRETRIZ ou Eduardo passa o briefing
        Conteúdo obrigatório: diagnóstico real, 3 prioridades, alertas de risco

DO    → Claude constrói (este protocolo)
        Declara plano antes de escrever código
        Reporta decisões ao Eduardo

CHECK → Eduardo valida + NotebookLM audita coerência + Gemini avalia ROI
        NotebookLM: "o que foi construído está alinhado com o que foi prometido?"
        Gemini: "a entrega avança a posição comercial do cliente?"

ACT   → Eduardo decide
        Avançar / Hotfix P0 / Reformular / Upsell de camada superior
```

**Regra crítica:** O ciclo fecha ENTRE iterações. Gemini avalia o que já foi construído — não o que está a construir.

---

## ESTRUTURA DE PASTAS PARA QUALQUER PROJECTO DE CLIENTE

```
CLIENTES/
└── [NOME_CLIENTE]/
    ├── BRIEFING_DISCOVERY.txt       ← notas da Fase 0
    ├── DIRETRIZ_V1_GEMINI.txt       ← estratégia do Gemini
    ├── PROPOSTA_COMERCIAL.pdf       ← proposta enviada ao cliente
    ├── MEMORIA_V1.md                ← memória técnica da iteração
    ├── relatorio_evolutivo_v1.md    ← análise de negócio
    ├── src/                         ← código do projecto
    │   ├── api/                     ← backend (se aplicável)
    │   ├── web/                     ← frontend (se aplicável)
    │   ├── mobile/                  ← app mobile (se aplicável)
    │   └── infra/                   ← schema, docker, deploy
    └── CONSELHO/
        ├── NotebookLM/              ← ficheiros .txt para upload
        └── Gemini/                  ← comandos para o Gemini
```

---

## ANTI-PADRÕES — O QUE NUNCA FAZER

| Anti-Padrão | Consequência | Regra Correcta |
|-------------|-------------|---------------|
| Código antes do plano | Retrabalho garantido | Declarar plano e aguardar confirmação |
| Falar em tecnologia ao cliente | Cliente não compra | Linguagem de resultado e ROI sempre |
| Construir o que não foi pedido | Desperdício de tempo | YAGNI — só o que resolve o problema |
| Commit sem aprovação | Mudanças não validadas em produção | Sempre aguardar Veredito do Eduardo |
| Stack overcomplicated para MVP | Custo e tempo inflacionados | Solução mais simples que funciona |
| Proposta sem ROI | Cliente negocia o preço | ROI calculado com dados reais do cliente |
| Avançar sem as 7 perguntas | Estratégia genérica inútil | Fase 0 completa obrigatória |
| Ignorar o que já existe | Reinventar a roda | Inventário antes de qualquer build |

---

## CONTEXTO VANGUARD (referência de fundo)

> Quando o projecto de cliente pode beneficiar de módulos já construídos pela Vanguard,
> ler os documentos abaixo para entender o que está disponível:

| Documento | Contém |
|-----------|--------|
| `VANGUARD_BUSINESS_RULES.md` | Regras de negócio, splits, custos, compliance |
| `NotebookLM/15_VANGUARD_KNOWLEDGE_GRAPH.md` | Mapa completo de endpoints, schema, fluxos V1–V14 |
| `NotebookLM/16_VANGUARD_PERFORMANCE_LEDGER.md` | Hipóteses vs resultados — o que funcionou e o que falhou |
| `NotebookLM/12_RITUAL_POS_VERSAO.md` | Ritual de 8 passos para fechar qualquer versão |
| `memorias/MEMORIA_[VXX].md` | Documentação técnica de cada versão (V1–V15+) |
| `relatorio_evolutivo_v[XX].md` | Análise de negócio real de cada versão (V1–V23) |
| `INTELIGENCIA_ARTIFICIAL_HUMANA.md` | Manifesto IAH — como explicar o modelo a qualquer cliente |

---

## COMANDO DE ACTIVAÇÃO

Quando Eduardo diz **PROTOCOLO VANGUARD** + descreve o projecto:

```
PROTOCOLO VANGUARD ACTIVADO — V3.0

Projecto: [o que Eduardo descreveu]
Tipo: [detectado ou a confirmar]

Acções imediatas:
1. Ler documentos base (MEMORANDO + ANALISE_SOCIO + BUSINESS_RULES)
2. Recolher as 7 perguntas de Discovery — uma a uma
3. Classificar o tipo e a camada do projecto
4. Inventariar o que já existe (Vanguard + cliente)
5. Apresentar análise crítica ANTES de qualquer código
6. Aguardar Veredito do Eduardo antes de avançar

O Quadrilateral está pronto.
Traz-me o problema. Entregamos a solução.
```

---

*Skill criada por Claude Code (Músculo) · Vanguard Quadrilateral · V24*
*Versão 3.0 — Universal: ecommerce, app, site, SaaS, modelo de negócio, automação, IA*
*Activa sempre que Eduardo disser: PROTOCOLO VANGUARD*
