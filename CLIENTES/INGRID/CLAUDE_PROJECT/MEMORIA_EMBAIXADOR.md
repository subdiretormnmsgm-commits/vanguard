# MEMORIA_EMBAIXADOR — PROJ-002 INGRID
> Estrutura em 3 camadas — aprovada pelo Diretor em 2026-05-19
> **CAMADA_FATOS:** dado bruto e verbatim. Zero interpretação. Auditor lê esta camada diretamente.
> **CAMADA_INFERENCIA:** análise do Embaixador. Ler sabendo que é opinião fundamentada.
> **CAMADA_DECISAO:** deliberações formais do Conselho. Verdades acordadas do projeto.
> Versão: Loop 4 · Gate Dia 8 · 2026-05-19

---

## CAMADA_FATOS

### CLIENTE — dados objetivos

- **Nome:** Ingrid
- **Cargo-alvo:** TDAS Cargo 202 (Técnico Administrativo) — Sedes-DF 2026
- **Banca:** Instituto Quadrix
- **Data da prova:** 2026-09-06 (~111 dias a partir de 2026-05-18)
- **Canal principal de contato:** WhatsApp

### CONTATOS REGISTRADOS

| Data | Canal | Evento objetivo | Fonte |
|---|---|---|---|
| 2026-05-16 | WhatsApp | Termo enviado para assinatura | Diretor |
| 2026-05-18 | WhatsApp | Termo assinado por Ingrid | Diretor (confirmado 2026-05-19) |
| 2026-05-18 | App (PWA) | Primeira sessão real — Gate Dia 8 | Ingrid |

### FALAS VERBATIM DE INGRID

| Data | Canal | Fala exata | Contexto |
|---|---|---|---|
| 2026-05-18 | Via Diretor | *"Gostou muito do aplicativo, só fez essa ressalva: Na questão 18, não houve palavra destacada em negrito, como informava o enunciado."* | Primeira sessão real — Gate Dia 8 |

### EVENTOS OBSERVÁVEIS

| Data | Evento | Detalhe factual |
|---|---|---|
| 2026-05-18 | Termo assinado | Data no corpo do PDF: **30/05/2026** — Eduardo confirmou assinatura em **18/05/2026** — inconsistência documental ativa |
| 2026-05-18 | Primeira sessão real | Chegou até pelo menos a questão 18 |
| 2026-05-18 | Bug identificado | Questão 18 — negrito ausente no enunciado que o referenciava |
| 2026-05-19 | Bug corrigido | Fix deployado em GitHub Pages (commit da9887a) |

### ESTADO DO PRODUTO (fatos técnicos)

| Campo | Estado | Data |
|---|---|---|
| Gate atual | Loop 4 — Build Dias 6-8 em execução | 2026-05-19 |
| Questões no banco | 460 — Cargo 202 SEDES-DF | 2026-05-18 |
| App no ar | https://subdiretormnmsgm-commits.github.io/vanguard/ | 2026-05-18 |
| Fix renderização negrito | Deployado | 2026-05-19 |

### HIPÓTESES RESOLVIDAS — evidência factual

| # | Hipótese | Status | Evidência factual |
|---|---|---|---|
| H-1 | Não assinou por esquecimento — não por hesitação | **CONFIRMADA** | Assinou em ~48h sem questionamento, negociação ou pedido de desconto |
| H-2 | Medo financeiro causou hesitação | **REFUTADA** | Piloto R$0 — sem gatilho financeiro presente |
| H-3 | Compararia o app com TEC Concursos na primeira sessão | **PENDENTE** | Q18 sem menção ao TEC — modo imersivo, não avaliativo. Só confirma quando verbalizar. |
| H-4 | Dificuldade = risco de abandono na primeira sessão | **ATIVA** | Q18 é receptividade, não hábito. Teste real ocorre na sessão 3-5 quando SM-2 começa a cobrar. |

---

## CAMADA_INFERENCIA

### HIPÓTESES ATIVAS

| # | Hipótese | Status | Base de inferência |
|---|---|---|---|
| H-5 | Pode compartilhar login com familiar ou colega | PENDENTE | Perfil social — sem dado ainda |
| H-6 | Teto receptivo real pode ser R$150/mês, não R$97 | PENDENTE | Embaixador: "esperança não regateia" |
| H-7 | Lê enunciados com atenção literal — Quadrix mindset nativo | **NOVA — confirmar nas próximas 2 sessões** | Notou discrepância entre o que o enunciado "informava" e o que a UI entregou |

### TEMPERATURA DO CLIENTE

```
TEMPERATURA: VERDE FRÁGIL
Razão: Q18 na sessão inaugural confirma engajamento real (perfil sistêmico), mas hábito tem < 72h.
Verde de Primeira Impressão — não Verde Consolidado. Hábito confirma-se na sessão 3-5 quando SM-2 cobra.
CHURN-WATCH: MONITORANDO — qualquer silêncio > 3 dias ativa AMARELO independente de Q18.
Próxima reavaliação: sessão 3-5 (SM-2 começa a cobrar) e check-in 2026-05-21
Última atualização: 2026-05-20 (Músculo P-032 — Loop 4 Deliberação)
```

### PADRÕES INFERIDOS — atualizar com cada sessão real

- **Mais analítica do que o registrado anteriormente:** leu o enunciado inteiro da questão 18 e notou discrepância precisa — comunicação de QA, não de cliente comum
- **Não compara com concorrentes:** no Gate Dia 8, TEC não foi mencionado — pode ter descolado cognitivamente ou o app criou identidade própria suficiente
- **Feedback acionável e específico:** não diz "tá estranho" — diz "questão 18, negrito ausente, como informava o enunciado." Precisa de precisão
- **Tom que funciona:** caloroso, direto, sem jargão técnico
- **Tom que não funciona:** formal, técnico, longo

### INTELIGÊNCIA DO EMBAIXADOR — Loop 4 PRÉ-BUILD [E-1 a E-5] (Gate Dia 8 · 2026-05-19)

| # | Insight | Ação prescrita |
|---|---|---|
| E-1 | Ingrid validou o moat do produto sem saber: leitura literal = musculatura Quadrix em treinamento | Documentar como prova social âncora: *"começou a notar detalhes da banca que não notava no TEC"* |
| E-2 | Resolução do bug em 24h = transição de cliente para parceira do produto | Enviar mensagem BLOCO 7 (Camada Decisão) imediatamente após fix deployado |
| E-3 | Não comparou com TEC → argumento comparativo não precisa aparecer no pitch | Revisar 04_PROPOSTA_COMERCIAL.md: retirar tabela comparativa do bloco principal |
| E-4 | KPI do R$194k: timestamp da questão 18 vs. primeiro acesso = primeiro dado real de engajamento EdTech | Músculo: query `progresso_usuario` WHERE `user_id = Ingrid` ORDER BY `created_at` |
| E-5 | Princípio: primeiro feedback espontâneo de piloto vale mais que qualquer pesquisa de mercado | Candidato P-046 ao LEDGER |

### INTELIGÊNCIA DO EMBAIXADOR — Loop 4 DELIBERAÇÃO [E-1 a E-5] (2026-05-20)

| # | Insight | Ação prescrita |
|---|---|---|
| E-1 | Horário de pico de Ingrid desconhecido — Q18 não captura horário. Se estuda às 22h, Simulado Dominical 10h pode ser feature desperdiçada. | Eduardo pergunta no check-in 2026-05-21: "Você estuda mais de manhã, tarde ou noite?" |
| E-2 | Q18 sem pausa = estado de fluxo. Risco não é login quebrando acesso — é qualquer interrupção técnica visível quebrar a imagem do app. Fallback deve ser invisível para Ingrid. | Músculo: garantir que modo passivo (fallback de fadiga) seja indistinguível do modo ativo. |
| E-3 | Ingrid precisa de "você está no seu melhor momento hoje" — confirmação de progresso, não alerta de risco. Heatmap de urgência cobre ameaça; falta cobrir conquista. | Músculo: adicionar feedback positivo pós-sequência de acertos ("Você acertou as últimas 4 — esse é seu ritmo"). |
| E-4 | Campo `horario_inicio_sessao` não existe no schema. Padrão noturno de Ingrid (provável) é argumento de pitch: "feito para quem estuda depois das 20h." | Avaliar antes do Gate Dia 15 se vale incluir timestamp de sessão no schema. |
| E-5 | Mensagem semanal de Eduardo com número de questões via WhatsApp (não push do app) ativa circuito de responsabilidade social além de progresso pessoal. Custo: 30s/semana. | Diretor autoriza protocolo de envio semanal — Músculo já tem `get_total_respostas`. |

### ALERTAS DO EMBAIXADOR — Loop 4 Deliberação (2026-05-20)

- **VETO [G-3] Persona Sargento:** ALERTA CRÍTICO — confronto verbal por TTI baixo vai gerar estresse que Ingrid não nomeia mas abandona silenciosamente. Ingrid não vai reclamar — vai sumir.
- **ALERTA [G-2] Distrator Assombração:** adiar para V2 — perfil de Ingrid é de quem quer superar erro, não ser confrontada repetidamente por ele.
- **CONFIRMA [P-045] veto ao login:** Q18 confirma engajamento real — qualquer atrito de acesso neste momento é risco genuíno.
- **Heatmap linguagem:** enquadrar disciplinas soberanas como "território conquistado", nunca "baixa prioridade".
- **Simulado Dominical:** não construir antes de confirmar horário de estudo de Ingrid (check-in 2026-05-21).

### WATCHDOG

| Flag | Status | Ação se não resolvido |
|---|---|---|
| [CHURN-WATCH] | MONITORANDO — Ingrid usou o app | Rearmar se silêncio > 3 dias a partir de 2026-05-20 |
| [QA-WATCH] negrito questão 18 | RESOLVIDO | Fix deployado 2026-05-19 |
| [SCOPE-WATCH] H-5 compartilhamento | ATIVO — sem dado | Monitorar na próxima sessão |
| [LEGAL-WATCH] Termo data | ATIVO | Reassinatura pendente: PDF diz 30/05, assinatura foi em 18/05 |

### PIPELINE COMERCIAL

| Produto | Valor | Gatilho verbal de Ingrid | Timing |
|---|---|---|---|
| Piloto atual | R$0 | — | Ativo |
| SaaS V2 | R$97/mês | "tô conseguindo estudar todo dia" ou verbalizar progresso | Entre Gate Dia 8 e 2026-06-15 |
| SaaS V2 upsell | R$150/mês | Ingrid não piscar no R$97 | Avaliar no momento do pitch |

**Abertura do pitch:** *"Ingrid, esse ciclo foi piloto. Quero continuar do seu lado até o dia da prova — R$97/mês, menos que qualquer cursinho, e o sistema já te conhece. Quer continuar?"*

### LEADS DETECTADOS

| Nome | Contexto | Status |
|---|---|---|
| Nenhum registrado | — | Plantar pergunta na próxima sessão: *"Você conhece mais alguém prestando concurso esse ano?"* |

---

## CAMADA_DECISAO

### DECISÕES FORMAIS DO CONSELHO

| Data | Decisão | Autoridade |
|---|---|---|
| 2026-05-18 | P-023 resolvido: Clickwrap na UI + Termo físico assinado | Conselho — Síntese Final P-037 |
| 2026-05-18 | Número visível: Pontos Ponderados — Score de Sobrevivência removido (viola cláusula 2) | Conselho — Síntese Final P-037 |
| 2026-05-18 | Debug mode: 5 toques no logo — nunca query string (Ingrid não é técnica) | Conselho — Síntese Final P-037 |
| 2026-05-18 | Perfis de Nicho: trade secret interno — nunca produto comercializável externamente | Embaixador ALERTA + Músculo — Síntese Final |
| 2026-05-19 | MEMORIA_EMBAIXADOR reestruturada em 3 camadas (FATOS / INFERENCIA / DECISAO) | Diretor — aprovação explícita |

### PROTOCOLOS ATIVOS

**Mensagem imediata — enviar AGORA (fix já deployado):**
> *"Ingrid, que bom que gostou — fico feliz mesmo. E olha, valeu demais por ter notado aquilo da questão 18 com o negrito. Era um bug de formatação chato, já corrigi. Esse tipo de olho fino é exatamente o que a banca da Quadrix cobra na prova, viu? Continua estudando assim 👊"*

**Reassinatura do Termo (próxima interação):**
- Gerar novo PDF com data 18/05/2026 no corpo
- Eduardo: *"Corrigi uma data no documento, precisa assinar rapidinho de novo"*
- Simples, sem drama, antes do Gate Dia 15

**Próxima sessão de Ingrid:**
1. Plantar pergunta de lead: *"Você conhece mais alguém prestando concurso esse ano?"*
2. Embaixador recebe debrief em até 24h com `FRASES_VERBATIM` separado de interpretação

### PRINCÍPIOS CANDIDATOS AO LEDGER

| Código | Princípio | Proposto em |
|---|---|---|
| P-042 | FALAS_CLIENTE: repositório único por projeto — captura única, extração múltipla por membro | 2026-05-19 |
| P-043 | Membro que acusa outro de viés metodológico entrega evidência verbatim, não conclusão sintética | 2026-05-19 |
| P-044 | Princípio extraído do LEDGER sem rotina operacional declarada é prosa — não aprendizado | 2026-05-19 |
| P-045 | URL pública (GitHub Pages) aceita só em piloto — auth real obrigatório antes do primeiro cliente pagante | 2026-05-19 |
| P-046 | Primeiro feedback espontâneo de piloto é o ativo mais valioso do projeto — captura verbatim com timestamp | 2026-05-19 |
| P-047 | Engajamento inaugural alto (Q18+) é indicador de receptividade, não hábito formado. Hábito confirma-se na sessão 3-5 quando SM-2 cobra e a novidade foi embora. Temperatura Verde depende da qualidade das sessões 2-5, não da sessão 1. | 2026-05-20 |

### HISTÓRICO DE ATUALIZAÇÕES

| Data | O que mudou | Quem |
|---|---|---|
| 2026-05-18 | Criação inicial | Embaixador |
| 2026-05-18 | Síntese Final P-037: E-1 a E-5 + H-1/H-2 + Pipeline + Temperatura + decisões | Músculo (P-032) |
| 2026-05-18 | Termo assinado — VERDE — P-023 resolvido — URL pública ativa | Músculo (P-032) |
| 2026-05-19 | Gate Dia 8: "gostou muito" + bug questão 18 — primeiro dado verbatim real | Embaixador (LOG_006) |
| 2026-05-19 | H-3/H-4 refutadas, H-7 nova, TEMPERATURA QUENTE, fix deployado | Músculo (P-032) |
| 2026-05-19 | Reestruturação em 3 camadas aprovada pelo Diretor | Músculo (P-032) |
| 2026-05-20 | Loop 4 Deliberação: E-1 a E-5 + alertas CRÍTICOS (Persona Sargento / Distrator) + temperatura VERDE FRÁGIL | Músculo (P-032) |
| 2026-05-20 | H-3 revertida para PENDENTE, H-4 mantida ATIVA — engajamento inaugural ≠ hábito formado | Embaixador |

---

> **Protocolo de uso:** CAMADA_FATOS = Auditor lê sem viés do Embaixador. CAMADA_INFERENCIA = Embaixador interpreta (ler sabendo que é opinião). CAMADA_DECISAO = Conselho deliberou — são verdades formais.
> Tempo de leitura por camada: 30 segundos. Atualização: 2 minutos.
