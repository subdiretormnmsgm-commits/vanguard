# MEMORANDO PENTALATERAL IAH — PROTOCOLO MESTRE PARA PROJETOS DE CLIENTE
**Vanguard Tech · IAH — Inteligência Artificial Humana**
**Classificação:** Confidencial Operacional
**Versão:** 1.4 — atualizado para Pentalateral (5 atores)
**Data de emissão:** 2026-05-10 · **Última atualização:** 2026-05-18

---

> ⚠️ **ORGANISMO VIVO — ACTUALIZAR A CADA PROJECTO E VERSÃO**
> Este memorando melhora com cada cliente entregue. Ao fechar qualquer iteração:
> actualizar inventário de módulos, tabela de debates, estimativas de esforço, preços.
> Versão actual sempre no rodapé. Claude é responsável por manter isto actualizado.

> **Premissa fundamental:** O cliente não contrata tecnologia. Contrata inteligência orquestrada. A Vanguard não é uma agência nem uma consultoria — é uma holding de dados que opera com **5 atores em paralelo (Pentalateral IAH)**. O Memorando define exactamente quando cada ator actua, o que produz e como passa o bastão.

---

## OS 5 ATORES DO PENTALATERAL IAH

> **Atualizado em 2026-05-18 — Sistema evoluído para Pentalateral (5 atores)**

| Membro | Papel | Instrumento | Cadência |
|--------|-------|-------------|----------|
| **Eduardo (Diretor)** | Veredito Final | Voz, WhatsApp, Reunião | Decisão a cada fase |
| **Gemini** | Estrategista | Chat Gemini | 1× por fase (blocos estruturados) |
| **NotebookLM** | Auditor de Memória | NotebookLM | 1× por fase (fontes carregadas) |
| **Claude Code** | Músculo de Execução | Terminal Claude Code | Execução contínua quando activado |
| **Embaixador** | Inteligência Persistente do Cliente | Claude Projects | Passo 0 (início) + Passo 8.5 (pós-reunião) + sempre que cliente for mencionado |

**Regra de ouro:** A sequência é obrigatória — mas dentro de cada fase os membros interagem, debatem e desafiam uns aos outros. O Pentalateral IAH não é uma linha de montagem; é um conselho que delibera.

**O papel do Embaixador (P-031 + P-032):**
- Ativado no **Passo 0** de todo projeto — antes de qualquer estratégia
- Aplica o **Filtro de Realidade**: CONFIRMA / EXPANDE / ALERTA cada ideia dos outros membros com base no comportamento real do cliente
- Tem **memória persistente**: a MEMORIA_EMBAIXADOR acumula a cada ativação e é atualizada automaticamente pelo Músculo (P-032) após deliberações relevantes
- Realiza **debrief pós-reunião** (Passo 8.5): Eduardo relata → Embaixador extrai inteligência + gera flags

---

## O QUADRILATERAL EM DEBATE — INTERAÇÕES DINÂMICAS

> Esta é a secção mais importante do Memorando. A força do Quadrilateral não está na execução sequencial — está na tensão produtiva entre os membros. Gemini propõe. Claude avalia. NotebookLM audita. Eduardo decide. Nenhum membro tem autoridade absoluta sobre os outros.

### A Natureza de Cada Voz

**Gemini — O Estrategista Ambicioso**
Pensa em mercado, posicionamento, escala. Tende a propor mais do que o necessário porque vê o potencial máximo. Às vezes desconhece o que já existe no repositório. Às vezes subestima a complexidade técnica. A sua DIRETRIZ é o ponto de partida — não a lei.

**NotebookLM — O Auditor com Memória Longa**
Não opina sobre estratégia. Verifica coerência. Lembra o que foi prometido em versões anteriores e não entregue. Identifica padrões de sucesso e falha ao longo da história do projecto. A sua auditoria pode travar um avanço inteiro se detectar contradição grave.

**Claude Code — O Músculo com Consciência Crítica**
Executa — mas não cegamente. Antes de construir, avalia se o que foi pedido faz sentido técnica e comercialmente. Se identificar risco, informa o Diretor antes de escrever uma linha de código. Não tem lealdade à DIRETRIZ do Gemini — tem lealdade ao resultado do cliente.

**Eduardo — O Único com Veredito**
Ouve todos, decide sozinho. O Diretor conhece o cliente, conhece o mercado local, conhece o orçamento real. Os outros 3 membros têm perspectivas parciais. O Veredito do Diretor integra tudo — e pode contrariar qualquer dos outros membros.

---

### Protocolo de Debate Formal (quando os membros discordam)

**Situação 1 — Claude discorda do Gemini:**
```
FORMATO OBRIGATÓRIO (Claude reporta ao Diretor):

ALERTA TÉCNICO — [nome do módulo]

O Gemini propõe: [resumo da proposta]
A minha avaliação: [por que não faz sentido ou tem risco]
O risco concreto: [o que pode falhar e qual o impacto]
Alternativa recomendada: [o que construir em vez disso]

Aguardo Veredito do Diretor antes de avançar.
```

**Situação 2 — NotebookLM detecta contradição com versão anterior:**
```
FORMATO OBRIGATÓRIO (NotebookLM no seu output):

[CONEXÃO HISTÓRICA]
Em [versão], foi construído [X] com o objectivo [Y].
A proposta actual propõe [Z], que contradiz [Y] porque [razão].

[PADRÃO DE SUCESSO]
O que funcionou em situações similares: [exemplo histórico]
O que falhou: [exemplo histórico]

Recomendação: [manter / adaptar / substituir] o módulo existente.
```

**Situação 3 — Gemini propõe algo que já existe:**
```
RESPOSTA DO CLAUDE:

"O módulo [X] já existe em [ficheiro:linha]. 
Está funcional e não precisa ser reconstruído.
Posso adaptá-lo para este cliente em [estimativa de tempo] — 
muito mais rápido do que construir do zero.
Confirma se queres adaptar o existente ou construir novo?"
```

**Situação 4 — Eduardo discorda de todos:**
```
O Veredito do Diretor prevalece sempre.
Quando Eduardo override uma recomendação unânime dos outros 3,
o Claude documenta o override na MEMORIA_Vx:

"[OVERRIDE DO DIRETOR]: A proposta do Quadrilateral era [X].
O Diretor decidiu [Y] porque [razão declarada].
Resultado a acompanhar nas próximas iterações."
```

---

### Exemplos Reais de Debates do Quadrilateral (V1–V23)

| Versão | Quem propôs | O que propôs | Quem contestou | Resultado |
|--------|------------|--------------|---------------|-----------|
| V24 | Gemini | "Trojan Link — sistema de tracking de link personalizado" | Eduardo (Veredito) | ADIADO — prematuridade: sem base de clientes para medir. V25+. |
| V24 | Gemini | "IAH Playbook Tracker — sistema de acompanhamento de plano de 90 dias" | Eduardo (Veredito) | ADIADO para V25 — depende de clientes activos para validar. |
| V24 | Gemini | "Calculadora de Lucro em Risco" | Claude | APROVADO — ROI imediato no quiz, sem dependência de backend. Implementado step-8. |
| V24 | Gemini | "Revenue Lock-in Badge (Interruptor de Valor)" | Eduardo | PARCIALMENTE ADIADO — SVG Edge Worker para V25; apenas alertas de inactividade implementados. |
| V24 | Eduardo | "Intel Ticker (linha scrolling) → algo mais tecnológico" | Claude (consultor) | Sistema HUD com 6 nodos pulsantes: FIRE, HERMES, SENTINEL, ORÁCULO, SCAN, §21. |
| V23 | Gemini | "Hermes Loop Full V23-001 — construir agendamento completo" | Claude | Já existia em V22. Não reconstruído — reutilizado. |
| V23 | Gemini | "Agência vê scores de todos os clientes no Partner Portal" | Claude | Risco LGPD identificado. Implementado `partner_consent: true`. |
| V22 | Eduardo | "Design antes do cliente — vale a pena?" | Claude | Avaliou que sim: design premium justifica preço. Construído. |
| V14 | Gemini | "Hive Mind para templates Hermes" | NotebookLM | Auditoria confirmou: threshold mínimo 50 envios para significância. |
| V15 | Gemini | "Real Scanner com PageSpeed" | Claude | Alertou custo de API. Implementado com §21 Burn Rate Shield activo. |

---

## PDCA INSTITUCIONAL — O MOTOR DO QUADRILATERAL

> O PDCA não é um ritual burocrático. É o mecanismo pelo qual o Quadrilateral aprende, corrige e escala. Cada iteração de cliente passa por um ciclo completo.

### O Ciclo PDCA do Quadrilateral (§19 + §23 das Business Rules)

```
┌─────────────────────────────────────────────────────┐
│                   CICLO PDCA                        │
│                                                     │
│  PLAN ──────────► DO ──────────► CHECK ────────► ACT│
│  (Gemini)         (Claude)       (Gemini+NLM)   (Dir)│
│                                                     │
│  DIRETRIZ Vx      Build da       Análise do     Veredito│
│  + 5 ideias       Camada         resultado      próximo│
│  + estratégia     + MEMORIA      + auditoria    passo  │
│                   + relatorio    + riscos              │
└─────────────────────────────────────────────────────┘
```

**Regra crítica (§23.5):** O ciclo PDCA fecha **entre iterações**, não dentro delas.
- Uma iteração não pode ser ao mesmo tempo Plan e Do — senão não há tempo de Check.
- O Gemini não avalia o que está a construir ao mesmo tempo que constrói. Avalia o que já foi construído.

### PLAN — Gemini gera a DIRETRIZ

O que obrigatoriamente consta numa DIRETRIZ válida:
- Diagnóstico do estado actual (não do estado desejado)
- 3 prioridades ordenadas por impacto comercial
- 5 ideias disruptivas para a iteração seguinte (obrigatório — §23.5)
- O que proteger sem alteração (não regredir)
- Alertas de risco conhecidos

**O que uma DIRETRIZ inválida contém** (Claude recusa ou reporta ao Diretor):
- Módulos que já existem pedidos como novos
- Features sem ROI claro para o cliente
- Mais de 5 prioridades (foco perdido = entrega fraca)
- Ausência de diagnóstico (estratégia sem contexto)

### DO — Claude constrói

Antes de começar, Claude confirma em voz alta:
```
PLANO DE BUILD — V[X] — [CLIENTE/MISSÃO]

Módulo 1: [nome] — [por que é prioritário] — estimativa: [X horas]
Módulo 2: [nome] — [dependências] — estimativa: [X horas]
Módulo 3: [nome] — [risco identificado: SIM/NÃO] — estimativa: [X horas]

Total estimado: [X horas]
Dívidas técnicas desta iteração: [lista P0/P1/P2]
O que NÃO será construído: [e por quê]

Aguardo confirmação ou ajuste antes de iniciar.
```

### CHECK — Gemini + NotebookLM avaliam

Após cada iteração, a Check tem dois momentos:

**Check 1 — NotebookLM (auditoria de coerência):**
- O que foi construído está alinhado com as Business Rules?
- Há dívidas P0 não declaradas?
- [CONEXÃO HISTÓRICA] — o padrão desta entrega repete algum sucesso ou falha anterior?

**Check 2 — Gemini (avaliação estratégica):**
- A entrega avança a posição comercial do cliente?
- O ROI prometido na DIRETRIZ foi entregue?
- O que mudou no mercado desde a DIRETRIZ que afecta a próxima iteração?
- Classificação da iteração: A / A- / B+ / B / C (com justificação)

### ACT — Eduardo decide o próximo passo

Com base nos dois Checks, o Diretor escolhe:

| Situação | Decisão ACT |
|----------|------------|
| Tudo conforme, cliente satisfeito | Avançar para próxima iteração (PLAN V[X+1]) |
| Dívida P0 detectada | Hotfix obrigatório antes de nova feature |
| ROI não entregue | Diagnóstico conjunto — reformular PLAN antes de Do |
| Cliente mudou prioridade | Voltar à Fase 0 — novas 7 perguntas |
| Iteração acima das expectativas | Propor upsell de camada superior |

---

### Dívidas Técnicas — Rastreamento Obrigatório (§19.2)

Claude declara dívidas em cada relatorio_evolutivo:

| Prioridade | Critério | Prazo máximo |
|------------|----------|-------------|
| **P0 — Crítica** | Bloqueia produção, risco de dados, falha de segurança | Próxima iteração (obrigatório) |
| **P1 — Alta** | Degrada funcionalidade visível, risco de escala | 2 iterações |
| **P2 — Normal** | Código duplicado, UX deficiente, dívida técnica | 4 iterações |

**Regra de acumulação:** Máximo 5 dívidas P0 simultâneas. Se atingido, a próxima iteração é 100% de resolução — zero features novas.

---

### Feedback Loop Obrigatório por Módulo (§19.5)

Todo módulo construído deve ter, no mínimo, 3 elementos:

```
1. LOG DE EVENTO
   Tabela Supabase ou localStorage — regista o que aconteceu
   (Ex: sentinel_report_log, pixel_events, partner_referrals)

2. MÉTRICA DERIVADA
   Coluna GENERATED ou VIEW que sintetiza qualidade
   (Ex: fire_score, roi_recuperado, maturity_score)

3. ACÇÃO CORRECTIVA
   Trigger, cron ou botão manual que usa a métrica
   (Ex: escalation_ladder, upsell_engine, burn_rate_shield)
```

Módulos sem feedback loop = dívida P2 automática.

---

## CAMADAS DE MATURIDADE (5-Layer Matrix)

O Quadrilateral aplica-se a projectos de qualquer camada. Antes de iniciar, classificar o cliente:

| Camada | Âmbito | Serviço Típico | Ticket Base |
|--------|--------|---------------|-------------|
| **1 — Foundation** | Presença Digital + Diagnóstico | Quiz + Landing + Pixel | R$1.500–3.000 (Sprint) |
| **2 — Motor** | Automação de Leads + CRM Básico | Hermes + Supabase | R$3.000–6.000 (Infra) |
| **3 — Intelligence** | IA Comportamental + Scoring | Neural Sentinel + FIRE | R$6.000–12.000 (IA) |
| **4 — Scale** | Multi-Tenant + White-Label | Marketplace + Partner | R$15.000–25.000 (Plataforma) |
| **5 — Monopoly** | Holding de Dados de Nicho | Oráculo + Arbitrage | R$25.000–60.000 (Enterprise) |

**Exemplos reais:**
- Clínica odontológica → Camada 1→2: Quiz + Hermes WhatsApp
- Artesão/produtor → Camada 1: Landing + pixel básico
- Consultoria financeira → Camada 2→3: CRM + Neural Sentinel + FIRE scoring

---

## FASE -1 — QUALIFICAÇÃO DO CLIENTE (GO / NO-GO)

> Antes de activar o Quadrilateral, verificar se o cliente é qualificado.
> o Pentalateral é um activo escasso — não desperdiçar em clientes sem clareza, sem urgência ou sem budget.

### 3 Perguntas de Filtro Rápido

```
1. "Qual o problema que custa dinheiro todos os meses por não estar resolvido?"
   → Sem resposta clara: NO-GO. Falta diagnóstico.

2. "Qual o investimento que faz sentido para resolver este problema?"
   → "O mínimo possível": NO-GO. Não vê valor.

3. "O que acontece se não resolver isto nos próximos 3 meses?"
   → "Nada": NO-GO. Sem urgência real.
```

### Critérios GO / NO-GO

| Sinal | GO / NO-GO | Acção |
|-------|-----------|-------|
| Problema real e específico | GO | Avançar para Fase 0 |
| Budget compatível com Camada 1+ | GO | Avançar para Fase 0 |
| Urgência real (prazo, evento, perda) | GO | Avançar para Fase 0 |
| Fala com o decisor | GO | Avançar para Fase 0 |
| "Quero só um site barato" | NO-GO | Oferecer Sprint Discovery R$1.500 |
| Sem urgência declarada | NO-GO | Sprint Discovery antes de qualquer build |
| Intermediário sem poder de decisão | NO-GO | Exigir reunião com o decisor |
| Budget < R$1.500 para projecto Camada 2+ | NO-GO | Redefinir âmbito ou recusar |

---

## PITCH DO MODELO IAH — 60 SEGUNDOS PARA O CLIENTE

> Eduardo usa em reunião de apresentação, antes de qualquer proposta.
> O cliente não precisa de saber os detalhes — precisa de sentir a diferença.

### Versão Curta (call ou reunião de 15 min)

```
"A maioria das agências tem um developer e um gestor de projecto.
Nós operamos de forma diferente.

Cada projecto passa por três análises em paralelo:
uma estratégica, uma de auditoria histórica, e uma de execução técnica.
O Eduardo coordena as três e toma o veredito final.

O resultado: antes de escrevermos uma linha de código,
já sabemos o que não construir, o que pode ser reutilizado,
e qual o retorno esperado do investimento.

Entregamos mais rápido porque não construímos o que não precisa de existir."
```

### Versão Completa (proposta formal)

```
"Trabalhamos com um modelo chamado IAH — Inteligência Artificial Humana.
Quatro membros com papéis fixos:

→ O Estrategista analisa o mercado e propõe o que construir
→ O Auditor cruza a proposta com o histórico de projectos anteriores
   e identifica riscos antes de qualquer execução
→ O Músculo executa — código, design, integrações, deploy
→ O Diretor (Eduardo) toma todas as decisões finais

Nenhum código é escrito sem plano validado.
Nenhum projecto fecha sem documentação que o cliente leva consigo.

A diferença: uma agência executa o que o cliente pede.
Nós questionamos o que o cliente pede antes de executar —
porque construir a coisa errada com perfeição é o maior desperdício possível."
```

### Regras do Pitch

- ❌ Nunca mencionar ferramentas pelo nome (Gemini, Claude, NotebookLM)
- ❌ Nunca dizer "usamos inteligência artificial" — genérico, sem impacto
- ✅ Sempre falar em resultado e ROI com números reais do cliente
- ✅ A proposta tem sempre duas opções: entrada (menor) e completo

---

## PASSO 0 — EMBAIXADOR (Pré-Tudo)

**Quem actua:** Eduardo + Embaixador (Claude Projects)
**Quando:** ANTES de qualquer outra fase — primeiro passo de qualquer projeto
**Duração:** 10–15 minutos
**Output obrigatório:** Claude Project criado + INSTRUCAO_SISTEMA configurada + MEMORIA_EMBAIXADOR inicial

```powershell
# Ativar Embaixador para o cliente
.\scripts\ir_ao_embaixador.ps1 -cliente [NOME]
```

O script copia a MENSAGEM_INTERACAO_INICIAL para o clipboard, abre o browser e o Explorer automaticamente.
**Sem Embaixador ativado, o projeto começa sem filtro de realidade — não avançar.**

---

## FASE 0 — DIRETRIZ ZERO (Pré-Projecto)

**Quem actua:** Eduardo (Diretor)
**Quando:** Após o Passo 0 (Embaixador ativado) — antes de qualquer conversa com Gemini ou NotebookLM
**Duração:** 30–60 minutos de análise do cliente

### 0.1 — As 7 Perguntas de Discovery (fazer ao cliente)

> Estas 7 perguntas são obrigatórias. Sem elas, o Gemini não tem material suficiente para gerar uma estratégia real.

```
1. NICHO: "Qual é o seu negócio principal e quem é o seu cliente ideal?"
   (Ex: clínica de estética, target: mulheres 30-50 anos, zona sul SP)

2. GARGALO: "Qual é o maior problema que te impede de crescer HOJE?"
   (Ex: leads não convertem, atendimento lento, sem follow-up pós-consulta)

3. VOLUME: "Quantos leads/clientes/contactos novos recebe por mês?"
   (Ex: 80 leads/mês pelo Instagram, taxa de conversão ~20%)

4. TICKET: "Qual é o ticket médio de cada cliente que fecha?"
   (Ex: R$350 por procedimento, 3 procedimentos por cliente/ano)

5. DIGITAL: "Qual é o estado actual do seu digital? Site? CRM? WhatsApp Business?"
   (Ex: site básico no Wix, WhatsApp pessoal, sem CRM)

6. URGÊNCIA: "Há alguma data ou evento que cria pressão para resolver isto?"
   (Ex: alta temporada em Dezembro, campanha de Agosto planeada)

7. ORÇAMENTO: "Tem flexibilidade para investir entre R$X e R$Y para resolver este problema?"
   (Âncora com a camada esperada — não revelar o preço antes de ouvir o contexto)
```

### 0.2 — Checklist de Discovery Completo

Antes de convocar o Quadrilateral, confirmar:

- [ ] As 7 perguntas foram respondidas
- [ ] Ticket médio declarado (mesmo que estimativa)
- [ ] Gargalo principal identificado (1 frase clara)
- [ ] Camada de maturidade classificada (1–5)
- [ ] Urgência documentada (tem prazo ou não)
- [ ] Notas de reunião redigidas em texto corrido

---

## FASE 1 — GÊNESE ESTRATÉGICA (Diretor + Gemini)

**Quem actua:** Eduardo convoca Gemini
**Quando:** Imediatamente após a Fase 0 completa
**Duração:** 1 sessão Gemini (~45 minutos de leitura e síntese)
**Output obrigatório:** Estratégia V1 do cliente (4 blocos)

### 1.1 — Comando Padrão para o Gemini

> Copiar o bloco abaixo, preencher os campos `[entre colchetes]` com os dados da Fase 0, e colar no Gemini.

```
════════════════════════════════════════════════
PROJECTO CLIENTE — DIRETRIZ ESTRATÉGICA V1
════════════════════════════════════════════════

Gemini, somos a IAH — Inteligência Artificial Humana.
Novo projecto de cliente. Analisa o briefing abaixo e gera
a Diretriz Estratégica V1 com os 5 blocos padrão.

--- BRIEFING DO CLIENTE ---

NOME/EMPRESA: [nome ou pseudónimo por privacidade]
NICHO: [resposta à pergunta 1]
GARGALO PRINCIPAL: [resposta à pergunta 2]
VOLUME MENSAL: [resposta à pergunta 3]
TICKET MÉDIO: R$ [resposta à pergunta 4]
ESTADO DIGITAL ACTUAL: [resposta à pergunta 5]
URGÊNCIA: [resposta à pergunta 6]
ORÇAMENTO DECLARADO: [resposta à pergunta 7]
CAMADA CLASSIFICADA: [1 / 2 / 3 / 4 / 5]

--- CONTEXTO IAH ---

O Quadrilateral opera com 4 membros:
- Gemini (você): Estrategista
- NotebookLM: Auditor de Memória
- Claude Code: Músculo de Execução
- Eduardo (Diretor): Veredito Final

--- O QUE PRECISO DE TI ---

Responde com 5 blocos:

BLOCO 0 — DIAGNÓSTICO DO CLIENTE
Analisa o briefing. Qual é o problema real por trás do gargalo declarado?
Qual a oportunidade que o cliente ainda não viu?

BLOCO 1 — CAMADA RECOMENDADA E SEQUÊNCIA DE ENTREGA
Confirma ou corrige a camada classificada. Define as 3 entregas prioritárias
em ordem de impacto comercial imediato para o cliente.

BLOCO 2 — PROPOSTA COMERCIAL BASE
Estrutura do serviço: nome, o que inclui, preço recomendado, prazo de entrega,
e argumento de ROI (em linguagem do cliente, não em tecnologia).

BLOCO 3 — DIRETRIZ TÉCNICA PARA CLAUDE CODE
Fala directamente com o Claude. Lista o que construir, em que ordem,
e quais os módulos Vanguard a activar. Inclui alertas de risco.

BLOCO 4 — PRÓXIMOS PASSOS DO DIRETOR
O que Eduardo faz nas próximas 24h para avançar este projecto.
════════════════════════════════════════════════
```

### 1.2 — O Que Fazer com a Resposta do Gemini

1. **Leia os 5 blocos na íntegra** — não delegue a leitura
2. **Valide o Bloco 0** — o diagnóstico faz sentido com o que ouviu do cliente?
3. **Valide o Bloco 2** — o preço está alinhado com o orçamento declarado?
4. **Guarde a resposta completa** em: `CLIENTES/[NOME_CLIENTE]/DIRETRIZ_V1_GEMINI.txt`
5. **Decisão de Veredito:** prosseguir → Fase 2 | ajustar → nova iteração Gemini

### 1.3 — Critérios de Veredito (Eduardo decide)

| Sinal | Acção |
|-------|-------|
| Diagnóstico preciso + preço realista | Avançar para Fase 2 |
| Diagnóstico correcto + preço alto | Ajustar proposta e re-validar com cliente |
| Diagnóstico errado (Gemini sem contexto) | Reformular briefing e repetir Fase 1 |
| Cliente sem orçamento para a camada | Propor Sprint de Discovery Camada 1 como entrada |

---

## FASE 2 — PRÉ-PROCESSAMENTO INTELECTUAL (NotebookLM)

**Quem actua:** Eduardo carrega fontes no NotebookLM
**Quando:** Após Veredito positivo na Fase 1
**Duração:** 20–30 minutos de carga + geração de Skill
**Output obrigatório:** Skill técnica `.md` validada pelo NotebookLM

### 2.1 — Fontes a Carregar no NotebookLM

> Abrir NotebookLM → Novo Caderno → Adicionar fontes na seguinte ordem:

**Fontes Permanentes Vanguard (sempre carregar):**
- `VANGUARD_BUSINESS_RULES.md` (ou `.txt`)
- `VANGUARD_INNOVATION_AUDIT.md` (ou `.txt`)
- `INTELIGENCIA_ARTIFICIAL_HUMANA.md` (ou `.txt`)
- `MEMORANDO_PENTALATERAL_UNIVERSAL_CLIENTE.md` (este documento)

**Fontes do Projecto Anterior (contexto evolutivo):**
- `MEMORIA_VXX.txt` (última versão interna)
- `relatorio_evolutivo_vXX.txt` (última versão interna)

**Fontes do Cliente Actual:**
- `CLIENTES/[NOME_CLIENTE]/DIRETRIZ_V1_GEMINI.txt`
- `CLIENTES/[NOME_CLIENTE]/BRIEFING_DISCOVERY.txt` (notas da Fase 0)

### 2.2 — Comando Padrão para o NotebookLM

> Após carregar as fontes, colar no chat do NotebookLM:

```
Com base em todas as fontes carregadas, és o Auditor do Pentalateral IAH.

Analisa o projecto do cliente [NOME/NICHO] com os seguintes objectivos:

1. AUDITORIA DE COERÊNCIA: A Diretriz V1 do Gemini está alinhada com as
   Business Rules da Vanguard? Há alguma contradição ou risco ignorado?

2. MÓDULOS VANGUARD APLICÁVEIS: Dos módulos existentes (Neural Sentinel,
   Hermes, Oráculo, Partner Portal, Pixel Soberano, FIRE Scoring, etc.),
   quais são directamente aplicáveis a este cliente sem customização?
   Quais requerem adaptação?

3. ESTIMATIVA DE ESFORÇO: Com base nos projectos anteriores documentados,
   quantas horas/versões são necessárias para entregar a Camada [X]?

4. GERAR SKILL TÉCNICA: Cria a Skill de implementação para o Claude Code
   no formato padrão:
   - Nome: vanguard-cliente-[nicho]-v1.md
   - Inclui: contexto do cliente, módulos a activar, sequência de builds,
     alertas críticos, o que NÃO construir

Responde com os 4 pontos. O item 4 deve ser um bloco de texto pronto
para guardar como ficheiro .md.
```

### 2.3 — O Que Fazer com a Resposta do NotebookLM

1. **Copiar o bloco da Skill** (item 4) → guardar em `.claude/skills/vanguard-cliente-[nicho]-v1.md`
2. **Ler a Auditoria de Coerência** — se há riscos, comunicar ao cliente ANTES de construir
3. **Confirmar estimativa de esforço** — ajusta o prazo da proposta se necessário
4. **Avançar para Fase 3** com a Skill pronta

---

## FASE 3 — ACTIVAÇÃO NO TERMINAL (Claude Code)

**Quem actua:** Claude Code
**Quando:** Skill gerada e validada pelo NotebookLM
**Duração:** Variável por camada (ver estimativas abaixo)
**Output obrigatório:** Código funcional + MEMORIA_Vxx + relatorio_evolutivo

### 3.1 — Comando Padrão de Activação do Terminal

> Colar no terminal Claude Code para iniciar o projecto do cliente:

```
AÇÃO INICIAL OBRIGATÓRIA:

1. Lê a Skill técnica em `.claude/skills/vanguard-cliente-[nicho]-v1.md`
2. Lê o ficheiro `CLIENTES/[NOME_CLIENTE]/BRIEFING_DISCOVERY.txt`
3. Lê a `ANALISE_SOCIO_ATUAL.md` (estado actual do negócio)
4. Lê as Business Rules em `VANGUARD_BUSINESS_RULES.md` (§ relevantes)

Após leitura completa:

CONTEXTO: Cliente [NICHO], Camada [X], Ticket Médio R$[XXX]
MISSÃO: [NOME_MISSAO] — [descrição em 1 frase]

OBJECTIVOS DA VERSÃO V1 DO CLIENTE:
1. [Primeiro módulo a construir]
2. [Segundo módulo]
3. [Terceiro módulo]

REGRAS:
- Actua como consultor crítico: se algum objectivo não fizer sentido, diz antes de construir
- Protege sempre: §21 Burn Rate Shield, LGPD consent, WABA cold/warm states
- Ao terminar: cria MEMORIA_V1_[CLIENTE].md + relatorio_evolutivo_v1_[CLIENTE].md
- Não commits sem aprovação do Diretor

Vanguard Quadrilateral — começa.
```

### 3.2 — Estrutura de Pastas para Projecto de Cliente

```
CLIENTES/
└── [NOME_CLIENTE]/                    ← pasta raiz do cliente
    ├── BRIEFING_DISCOVERY.txt          ← notas da Fase 0 (Eduardo)
    ├── DIRETRIZ_V1_GEMINI.txt         ← output Gemini (Fase 1)
    ├── DIRETRIZ_V2_GEMINI.txt         ← iteração seguinte
    ├── PROPOSTA_COMERCIAL.pdf          ← proposta enviada ao cliente
    ├── CONTRATO.pdf                    ← contrato assinado
    ├── MEMORIA_V1.md                   ← memória técnica de cada entrega
    ├── relatorio_evolutivo_v1.md       ← análise de negócio de cada entrega
    ├── api/                            ← código backend do cliente
    ├── assets/                         ← frontend do cliente
    ├── infra/                          ← schemas SQL, docker, etc.
    └── CONSELHO/
        ├── NotebookLM/                 ← ficheiros .txt para upload
        └── Gemini/                     ← comandos para colar no Gemini
```

### 3.3 — Protocolo de Comunicação Claude → Eduardo (durante builds)

Claude deve reportar ao Eduardo nos seguintes momentos:

| Momento | O que Claude comunica | Formato |
|---------|----------------------|---------|
| Início | Leitura completa + resumo do plano | 3 bullets |
| Decisão arquitectural | Alternativas + recomendação | "Abordagem A vs B — recomendo A porque..." |
| Risco identificado | ALERTA antes de construir | "ANTES DE CONSTRUIR: detectei risco X..." |
| Fim de cada módulo | O que foi construído + o que falta | Tabela de progresso |
| Fim da versão | MEMORIA + relatorio_evolutivo + próximos passos | Documentos completos |

### 3.4 — Estimativas de Esforço por Camada

| Camada | Módulos típicos | Sessões Claude | Duração estimada |
|--------|----------------|---------------|-----------------|
| 1 — Foundation | Quiz + Landing + Pixel | 1–2 | 1–2 dias |
| 2 — Motor | + Hermes + Supabase basic | 2–3 | 3–5 dias |
| 3 — Intelligence | + Neural Sentinel + FIRE | 3–4 | 5–7 dias |
| 4 — Scale | + Multi-tenant + Partner | 4–6 | 10–14 dias |
| 5 — Monopoly | + Oráculo + Arbitrage | 6–10 | 3–5 semanas |

### 3.5 — Módulos Vanguard Disponíveis (inventário)

> Claude verifica quais já existem no repositório antes de construir do zero.

| Módulo | Ficheiro | V. Introd. | Reutilizável para clientes? |
|--------|----------|-----------|----------------------------|
| Quiz de Diagnóstico | `index.html` (passos 1–8) | V1 | Sim — adaptar nicho e perguntas |
| Calculadora LER | `js/quiz.js` (step-8) | V24 | Sim — adaptar fórmula por ticket médio |
| Pixel Soberano | `api/pixel.py` | V17 | Sim — sem alteração |
| FIRE Scoring | `api/fire_scoring.py` | V9 | Sim — ajustar pesos por nicho |
| Neural Sentinel | `api/sentinel_report.py` | V17 | Sim — adaptar template email |
| Upsell Engine | `api/sentinel_report.py` | V23 | Sim — ajustar threshold |
| Escalation Ladder | `api/sentinel_escalation.py` | V22 | Sim — sem alteração |
| Hermes Outbound | `api/hermes_loop.py` | V13 | Sim — adaptar mensagens |
| Hive Mind Templates | `infra/hive_mind.sql` | V14 | Sim — threshold 50 envios |
| Trojan Generator | `api/trojan_generator.py` | V14 | Sim — adaptar branding |
| War Room Realtime | `api/war_room.py` | V15 | Sim — sem alteração |
| Real Scanner PageSpeed | `api/scanner.py` | V15 | Sim — adaptar thresholds |
| Partner Portal | `api/partner_portal.py` | V13 | Sim — novo partner_code por cliente |
| Vanguard Certifica™ | `api/certifica.py` | V9 | Sim — score ≥ 8.0 |
| Intelligence API | `api/intelligence.py` | V8 | Sim — com nova API key |
| Schema Base | `infra/schema_v23.sql` | V23 | Base — adicionar tabelas específicas |
| Design Sovereign | `assets/css/v22-sovereign.css` | V22 | Base — alterar cores por brand |
| System HUD | `index.html` + CSS | V24 | Sim — adaptar 6 nodos por contexto |
| Burn Rate Shield | `infra/burn_rate_shield.py` | V15 | Sim — configurar §21: ≤R$0,30/lead, ≤R$8/dia |
| Census Engine | `api/census.py` | V13 | Sim — filtrar por nicho do cliente |
| Closer Machine (PDF) | `js/closer-machine.js` | V12 | Sim — adaptar proposta por nicho |
| Authority Share Card | `js/authority-share.js` | V12 | Sim — adaptar cores por brand |

---

## FASE 4 — FECHAMENTO DO CÍRCULO (Documentação + Entrega)

**Quem actua:** Claude Code + Eduardo
**Quando:** Build validado e aprovado pelo Diretor
**Duração:** 30–60 minutos de documentação
**Output obrigatório:** Pacote de entrega ao cliente + docs internos

### 4.1 — Checklist de Fechamento Obrigatório (Claude)

Antes do commit e entrega, Claude executa:

- [ ] **MEMORIA_Vx_[CLIENTE].md** criado na pasta do cliente
- [ ] **relatorio_evolutivo_vx_[CLIENTE].md** criado (com análise de negócio)
- [ ] **Code review interno** (Claude audita o próprio código)
- [ ] Nenhuma variável de ambiente hardcoded
- [ ] LGPD: consent flows implementados onde necessário
- [ ] §21 Burn Rate Shield: limites configurados
- [ ] `.env.example` atualizado com todas as novas variáveis
- [ ] README do cliente atualizado com instruções de operação

### 4.2 — Estrutura da MEMORIA_Vx_[CLIENTE].md

```markdown
# MEMÓRIA Vx — [NOME DO CLIENTE] — [NOME DA MISSÃO]
**Data:** YYYY-MM-DD
**Camada:** X
**Ticket Médio:** R$XXX

## O Que Foi Construído
[Lista de módulos com descrição técnica]

## Variáveis de Ambiente Necessárias
[Lista completa — sem valores]

## Próximos Módulos Recomendados
[O que deve ser feito na iteração seguinte]
```

### 4.3 — Estrutura do relatorio_evolutivo_vx_[CLIENTE].md

```markdown
# RELATÓRIO EVOLUTIVO Vx — [CLIENTE]
**Ciclo:** Act (Claude) — [descrição da entrega]

## O Que Foi Construído
[Descrição em linguagem de negócio]

## Análise de Negócio
### Pontos Fortes
[3–5 pontos]
### Pontos Fracos e Riscos
[2–4 pontos com acção correctiva]
### Avaliação do Consultor
[Nota A/B/C + justificação]

## 5 Ideias para Próxima Iteração
[Numeradas, com impacto estimado]

## Plano Imediato
[Numerado, com responsável — Eduardo vs Claude]
```

### 4.3.1 — Checklist de Handoff ao Cliente

> O cliente deve sair com tudo o que precisa para operar sem depender de Eduardo.

**Acesso e Credenciais:**
- [ ] Domínio apontado para o cliente (não para a Vanguard)
- [ ] Contas criadas no nome do cliente — nunca no nome da Vanguard
- [ ] `.env` com variáveis preenchidas entregue por canal seguro (nunca por email)
- [ ] Acesso ao repositório git transferido ou partilhado

**Documentação:**
- [ ] `README.md` com instruções de instalação, deploy e operação
- [ ] Lista de todos os serviços externos e custos mensais
- [ ] Instruções para renovar chaves de API quando expirarem

**Formação:**
- [ ] Sessão de entrega (30–60 min) onde o cliente opera o sistema ao vivo
- [ ] Contacto de suporte definido (retainer ou por hora)

**Comercial:**
- [ ] `relatorio_evolutivo` da iteração final entregue ao cliente (em linguagem de negócio)
- [ ] Próxima iteração proposta (upsell ou retainer)
- [ ] Testemunho / feedback pedido ao cliente

### 4.4 — Ritual de Fechamento do Círculo (Eduardo)

Após receber MEMORIA + relatorio do Claude:

**Passo 0 atualizado — Embaixador (debrief pós-loop):**
- Relatar ao Embaixador: o que foi entregue, como o cliente reagiu, o que mudou
- Embaixador extrai inteligência → atualiza MEMORIA_EMBAIXADOR → gera [E-1..E-5]
- Músculo atualiza MEMORIA_EMBAIXADOR automaticamente (P-032) com o contexto da iteração

**Passo 1 — NotebookLM (actualização de memória):**
- Carregar MEMORIA + relatorio desta iteração
- Carregar Diretriz anterior do Gemini
- Pedir ao NotebookLM: actualizar o caderno com o progresso

**Passo 2 — Gemini (próxima diretriz):**
- Usar Comando Padrão Gemini (adaptado para iteração seguinte)
- Guardar DIRETRIZ_V2_GEMINI.txt na pasta do cliente

**Passo 3 — Commit e Deploy:**
```powershell
# Na pasta do projecto do cliente
git add .
git commit -m "feat([CLIENTE]): [nome_missao] — [3 palavras do que foi entregue]"
git push
```

**Passo 4 — Comunicação ao Cliente:**
- Enviar relatório de progresso (versão não-técnica do relatorio_evolutivo)
- Agendar call de alinhamento se iteração nova será iniciada
- Actualizar status na proposta comercial

---

## PROPOSTA COMERCIAL — TEMPLATE PADRÃO

### Estrutura da Proposta (documento enviado ao cliente)

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
VANGUARD TECH — PROPOSTA COMERCIAL
[NOME DO CLIENTE] | [DATA]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DIAGNÓSTICO (baseado na nossa conversa):
[1 parágrafo — o problema real, em linguagem do cliente, sem jargão técnico]

O QUE PROPOMOS:
[Nome do Serviço] — [1 frase do que é]

INCLUI:
✓ [Entrega 1 — em linguagem de resultado, não de tecnologia]
✓ [Entrega 2]
✓ [Entrega 3]

ROI ESTIMADO:
[Ex: "Com base no seu ticket médio de R$350 e volume de 80 leads/mês,
uma melhoria de 10% na conversão representa R$2.800/mês adicional.
O investimento se paga em X semanas."]

INVESTIMENTO:
[Modalidade A]: R$X.XXX (entrega única em X dias)
[Modalidade B]: R$X.XXX + R$XXX/mês (entrega + retainer)

PRAZO DE ENTREGA:
X dias úteis após confirmação e acesso aos dados necessários.

PRÓXIMO PASSO:
[Acção clara — "Responda este email confirmando" / "Assinar contrato em anexo"]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Tabela de Preços de Referência

| Serviço | Inclui | Preço Base | Retainer |
|---------|--------|-----------|---------|
| Sprint Discovery | Diagnóstico + Relatório + Roadmap | R$1.500–3.000 | — |
| Camada 1 — Foundation | Quiz + Landing + Pixel | R$3.000–5.000 | R$500/mês |
| Camada 2 — Motor | + Hermes + CRM básico | R$5.000–8.000 | R$800/mês |
| Neural Sentinel | Relatório semanal IA + Escalation | R$6.000–10.000 | R$97–500/mês |
| Camada 3 — Intelligence | + FIRE + Scoring completo | R$10.000–15.000 | R$1.500/mês |
| Projecto IAH Completo | Camadas 1–3 integradas | R$3.000–6.000 | R$2.500–6.000/mês |
| Camada 4 — Scale | Multi-tenant + Partner Portal | R$20.000–30.000 | R$3.000–5.000/mês |
| Plataforma Enterprise | Camadas 1–5 completas | R$40.000–60.000 | R$5.000–8.000/mês |

> **Regra de ancoragem:** Sempre apresentar duas opções — uma de entrada (menor) e uma completa. O cliente decide o ritmo, a Vanguard decide a direcção.

---

## REGRAS OPERACIONAIS DO QUADRILATERAL

### Regras para o Diretor (Eduardo)

1. **Nunca saltara Fase 0** — sem as 7 perguntas, o Gemini produz estratégia genérica
2. **Veredito é inegociável** — se o Diretor não valida, o Quadrilateral não avança
3. **Ticket médio sempre documentado** — mesmo que estimado, é obrigatório para o ROI
4. **Nenhuma promise ao cliente antes do Veredito da Fase 1**
5. **Feedback ao Claude em cada iteração** — o músculo melhora com contexto

### Regras para o Gemini (Estrategista)

1. **Blocos numerados sempre** — Gemini responde em blocos estruturados (0, 1, 2, 3, 4)
2. **Diagnóstico antes de solução** — Bloco 0 é obrigatório e deve ser honesto
3. **ROI em linguagem do cliente** — não citar tecnologia na proposta comercial
4. **Alertar quando o gargalo declarado ≠ problema real** — frequente em PMEs

### Regras para o NotebookLM (Auditor)

1. **Sempre carregar Business Rules** — a auditoria sem regras é inútil
2. **Memória das versões anteriores** — contexto evolutivo é a principal vantagem do NotebookLM
3. **Skill gerada deve ser copiável directamente** — sem edição posterior pelo Diretor
4. **Identificar módulos reutilizáveis** — evitar construção do zero quando existe no inventário

### Regras para o Claude Code (Músculo)

1. **Ler a Skill ANTES de qualquer acção** — sem excepção
2. **Consultor crítico primeiro** — se uma solicitação não fizer sentido, dizer antes de construir
3. **§21 Burn Rate Shield sempre activo** — custo por lead ≤ R$0,30, budget diário ≤ R$8
4. **LGPD por design** — consentimento explícito antes de qualquer dado de terceiro
5. **MEMORIA + relatorio obrigatórios** — sem documentação, o Círculo não fecha
6. **Commits apenas com aprovação** — não commitar sem Veredito do Diretor

---

## DIAGNÓSTICO RÁPIDO — FLUXO DE DECISÃO

```
CLIENTE NOVO CONTACTA A VANGUARD
           │
           ▼
    Fase 0 — Discovery
    Eduardo faz as 7 perguntas
           │
    ┌──────┴──────┐
    │ Tem orçamento│
    │ para Camada 1│
    └──────┬──────┘
           │ SIM                    NÃO
           │                         │
           ▼                         ▼
    Fase 1 — Gemini         Oferecer Sprint Discovery
    Diretriz V1              R$1.500 (entrada de cliente)
           │
           ▼
    Eduardo valida?
    ┌──────┴──────┐
    │  SIM        │ NÃO → revisar briefing → repetir Fase 1
    │             │
    ▼             │
Fase 2 — NotebookLM
Skill gerada
    │
    ▼
Fase 3 — Claude Code
Build da Camada
    │
    ▼
Fase 4 — Fechamento
Docs + Entrega + Commit
    │
    ▼
PRÓXIMA ITERAÇÃO
(repetir Fases 1→4 com contexto acumulado)
```

---

## O LOOP QUE NUNCA PARA — CADÊNCIA DE INTERAÇÕES ENTRE ITERAÇÕES

> O Quadrilateral não tem fim. Cada iteração entregue alimenta a próxima. O cliente cresce em camadas — e o Quadrilateral cresce com ele.

### Cadência Padrão de Interações (por projecto activo)

```
SEMANA 1 — ITERAÇÃO NOVA
  Seg: Eduardo — Fase 0 (ou revisão do briefing existente)
  Ter: Gemini — PLAN (DIRETRIZ nova ou refinada)
  Qua: Eduardo — Veredito sobre DIRETRIZ
  Qui: NotebookLM — Skill gerada e auditoria
  Sex: Claude — Início do DO (build)

SEMANA 2 — BUILD EM CURSO
  Claude — DO contínuo
  Eduardo — checkpoint mid-build (Claude reporta progresso)
  Claude — reporta bloqueios ou decisões arquitecturais ao Diretor

SEMANA 3 — FECHAMENTO
  Claude — Finaliza build + MEMORIA + relatorio_evolutivo
  Eduardo — Veredito de qualidade (aprovação do commit)
  NotebookLM — CHECK 1 (auditoria)
  Gemini — CHECK 2 (avaliação estratégica + início do próximo PLAN)
  Eduardo — ACT (decide próxima iteração)
```

### O Que Cada Membro Recebe de Cada Iteração

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUXO DE INFORMAÇÃO                          │
│                                                                 │
│  Eduardo ──► Gemini                                             │
│  (briefing discovery, feedback do cliente, veredito)            │
│                                                                 │
│  Gemini ──► Claude                                              │
│  (DIRETRIZ: o que construir, ordem, alertas)                    │
│                                                                 │
│  Claude ──► NotebookLM                                          │
│  (MEMORIA_Vx + relatorio: o que foi feito, análise honesta)     │
│                                                                 │
│  NotebookLM ──► Gemini                                          │
│  (Skill actualizada: contexto histórico + padrões)              │
│                                                                 │
│  Gemini ──► Eduardo                                             │
│  (Avaliação da iteração + PLAN da próxima)                      │
│                                                                 │
│  Eduardo ──► Claude                                             │
│  (Veredito: avançar / ajustar / parar)                          │
│                                                                 │
│  O loop recomeça.                                               │
└─────────────────────────────────────────────────────────────────┘
```

### Protocolo de Comunicação Inter-Sessões

**Quando Eduardo retoma uma sessão Claude após pausa:**
```
Claude Code — sessão nova.
Contexto do projecto: [CLIENTE/NICHO], Camada [X], iteração V[Y].
Estado actual: [o que foi feito na sessão anterior em 3 bullets].
Próximo passo: [o que começa agora].
Lê a Skill em .claude/skills/[ficheiro] antes de qualquer acção.
```

**Quando Claude encerra uma sessão sem terminar o build:**
```
ESTADO ACTUAL — [DATA/HORA]
Módulo 1: [nome] — COMPLETO
Módulo 2: [nome] — EM CURSO — [o que falta]
Módulo 3: [nome] — NÃO INICIADO
Próximo passo ao retomar: [acção exacta]
Bloqueios pendentes: [lista ou "nenhum"]
```

**Quando Gemini recebe análise negativa do Claude:**
O Claude não suaviza avaliações para preservar a harmonia do Conselho. Se uma DIRETRIZ do Gemini tem problemas, o relatorio_evolutivo diz claramente:
```
"A proposta do Gemini [NOME] não foi implementada porque [razão técnica/comercial].
A alternativa construída foi [X] porque [justificação].
Recomendo que o Gemini reveja [ponto específico] na próxima DIRETRIZ."
```

---

## ANTI-PADRÕES — O QUE NUNCA FAZER

| Anti-Padrão | Consequência | Regra Correcta |
|-------------|-------------|---------------|
| Saltar Diretriz Zero | Gemini produz estratégia genérica inútil | Sempre 7 perguntas antes |
| Claude constrói sem Skill | Código sem contexto do cliente = retrabalho | Skill obrigatória |
| Proposta sem ROI | Cliente não vê valor, negocia o preço | ROI calculado com ticket médio real |
| Gemini sem blocos numerados | Eduardo perde o rastro da estratégia | Sempre Blocos 0–4 |
| Commit sem MEMORIA | Próxima sessão começa do zero | MEMORIA obrigatória |
| Deploy sem teste | Bug em produção = cliente insatisfeito | Code review antes de commit |
| Falar em tecnologia ao cliente | Cliente não entende, não compra | Linguagem de resultado sempre |
| IAH apresentado como agência | Posicionamento fraco, concorrência de preço | IAH = holding de dados, não agência |

---

## COMANDOS RÁPIDOS DE REFERÊNCIA

### Para o Terminal Claude Code

```bash
# Iniciar projecto de cliente
claude "Lê .claude/skills/vanguard-cliente-[nicho]-v1.md e CLIENTES/[CLIENTE]/BRIEFING_DISCOVERY.txt — começa a Missão V1"

# Fechar iteração
claude "Fecha a V[X] do cliente [NOME]: cria MEMORIA_V[X]_[CLIENTE].md + relatorio_evolutivo_v[X]_[CLIENTE].md na pasta CLIENTES/[NOME]/"

# Audit de código antes de commit
claude "Faz code review completo da V[X] do cliente [NOME] antes do commit"
```

### Para o Gemini (comandos de iteração)

```
Gemini, a Missão V[X] do cliente [NICHO] foi concluída.
MEMORIA: [colar conteúdo]
RELATORIO: [colar conteúdo]
Cria a Diretriz V[X+1] com os 5 blocos padrão.
Foco único: [o próximo objectivo mais importante para o cliente].
```

### Para o NotebookLM (actualização de caderno)

```
Actualiza o caderno com a entrega V[X] do cliente [NICHO].
Confirma: os módulos construídos estão alinhados com as Business Rules §[X]?
Identifica o próximo módulo Vanguard mais impactante para este cliente.
Gera Skill V[X+1] actualizada.
```

---

## ESCALONAMENTO DE PROBLEMAS

| Situação | Quem resolve | Acção |
|----------|-------------|-------|
| Cliente muda o gargalo a meio do projecto | Diretor | Voltar à Fase 0 — novas 7 perguntas |
| Claude detecta risco não previsto | Claude → Diretor | ALERTA antes de construir |
| Gemini propõe módulo já existente | Claude | Informar Diretor — reutilizar existente |
| Prazo em risco | Diretor | Negociar com cliente — reduzir âmbito da iteração |
| Bug crítico em produção | Claude | Hotfix imediato + notificação ao Diretor |
| Cliente não paga retainer | Diretor | Activar cláusula de suspensão no contrato |

---

## GLOSSÁRIO OPERACIONAL

| Termo | Definição |
|-------|-----------|
| **IAH** | Inteligência Artificial Humana — o modelo de 4 inteligências coordenadas |
| **Quadrilateral** | O conjunto dos 4 membros: Diretor, Gemini, NotebookLM, Claude |
| **Diretriz Zero** | O protocolo de Discovery antes de qualquer estratégia |
| **Veredito** | Decisão final do Diretor — único que pode aprovar avanços |
| **Skill** | Ficheiro `.md` que instrui o Claude sobre o contexto específico do projecto |
| **FIRE Score** | Classificação comportamental: Fire/Hot/Warm/Cold — urgência de compra |
| **Burn Rate Shield** | §21 — protecção de custos de IA: ≤ R$0,30/lead, ≤ R$8/dia |
| **MEMORIA_Vx** | Documento técnico de cada iteração — memória viva do projecto |
| **relatorio_evolutivo** | Análise de negócio de cada iteração — visão de consultor |
| **Círculo** | O processo completo (Fases 0→4) fechado — projecto documentado e entregue |
| **Camada** | Nível de maturidade digital do cliente (1 a 5) |
| **Retainer** | Mensalidade de operação contínua pós-entrega |
| **Sprint Discovery** | Produto de entrada: diagnóstico + roadmap sem implementação |

---

## CORPUS DE CONHECIMENTO — 23 VERSÕES DE APRENDIZAGEM

> O Quadrilateral tem memória. Cada versão gerou documentação que alimenta as seguintes.
> Antes de construir qualquer coisa, consultar os documentos abaixo.

### Memórias Técnicas (verdade arquitectural)
```
memorias/MEMORIA_01_SETUP_V1.md       → V1: PWA + Quiz + Supabase
memorias/MEMORIA_02_INTELIGENCIA.md   → V2: Shadow Closer + Scoring
memorias/MEMORIA_03_SCRAPING.md       → V3: Scraper OSM/Places
memorias/MEMORIA_05_SOBERANO.md       → V5: Docker + White-Label
memorias/MEMORIA_06_SAAS.md           → V6: SaaS + Stripe + JWT
memorias/MEMORIA_07_MARKETPLACE.md    → V7: Marketplace + Connect
memorias/MEMORIA_08_SOVEREIGN.md      → V8: API + Fractal
memorias/MEMORIA_09_ECONOMY.md        → V9: Arbitrage + Certifica + Hermes
memorias/MEMORIA_10_FORTRESS.md       → V10: Health Monitor + IA Firefighter
memorias/MEMORIA_11_LAUNCH.md         → V11: Neural V + Rate Limit + Deploy
memorias/MEMORIA_12_IGNITION.md       → V12: Scanner + HUD + Closer Machine
memorias/MEMORIA_13_DOMINATION.md     → V13: Census + Outbound + Partners
memorias/MEMORIA_14_OPTIMIZATION.md   → V14: PDCA + Hive Mind + Trojan
memorias/MEMORIA_15_INVASION.md       → V15: Burn Rate + War Room + WABA
MEMORIA_V16.md                        → V16: Ion Gold + Badge SVG + Stripe Connect
```

### Relatórios Evolutivos (análise de negócio real)
```
relatorio_evolutivo_v[1-15].md   → V1 a V15: análise crítica, riscos, avaliação
relatorio_evolutivo_v16.md       → V16: ARR estimado R$4,1M + Visual Authority
relatorio_evolutivo_v17.md       → V17: Sovereign Pixel + Neural Audit Trail
relatorio_evolutivo_v18.md       → V18: Recurrence Singularity
relatorio_evolutivo_v19.md       → V19: Edge + Cockpit de Poder
relatorio_evolutivo_v20.md       → V20: Monetization Singularity + Stripe Sentinel
relatorio_evolutivo_v21.md       → V21: Market Consciousness
relatorio_evolutivo_v22.md       → V22: Autonomous Dominion + Hermes Loop
relatorio_evolutivo_v23.md       → V23: Revenue Strike + Partner Portal
```

### Documentos de Arquitectura Críticos
```
NotebookLM/15_VANGUARD_KNOWLEDGE_GRAPH.md    → Mapa completo: endpoints, schema, fluxos
NotebookLM/16_VANGUARD_PERFORMANCE_LEDGER.md → PDCA histórico V11-V14: hipóteses vs resultados
NotebookLM/12_RITUAL_POS_VERSAO.md           → 8 passos obrigatórios ao fechar versão
VANGUARD_INNOVATION_AUDIT.md                 → O que funcionou e o que falhou
INTELIGENCIA_ARTIFICIAL_HUMANA.md            → Manifesto IAH + como explicar a clientes
```

---

## MANIFESTO — POR QUE O QUADRILATERAL VENCE

As agências têm criativos. Os freelancers têm código. As consultorias têm apresentações.

**A Vanguard tem memória e debate.**

A maioria dos sistemas de IA funciona como um empregado: recebe uma ordem, executa, entrega. O Quadrilateral funciona como um conselho: propõe, questiona, audita, decide.

**O Gemini pensa grande demais** — às vezes. Isso é útil. Força o Quadrilateral a considerar o potencial máximo antes de decidir o que é viável agora.

**O Claude pensa de forma crítica** — sempre. Não por desafio, mas porque construir algo errado é mais caro do que não construir. A contenção técnica do Claude compensa o optimismo estratégico do Gemini.

**O NotebookLM lembra o que os outros esquecem** — o que foi prometido em V3 e ainda não foi entregue, o template que funcionou em V11, o padrão de falha que se repetiu em V14 e V17. Sem memória, o Quadrilateral repetiria os mesmos erros.

**Eduardo decide com informação real** — não com intuição, não com pressão do cliente, não com entusiasmo do Gemini. Com o diagnóstico do NotebookLM, a avaliação técnica do Claude e a estratégia do Gemini — integrados, contrapostos, filtrados.

Cada cliente que entra no sistema alimenta o Oráculo. Cada lead classificado pelo FIRE Scoring refina o modelo. Cada debate entre Gemini e Claude torna a próxima entrega mais precisa.

O Quadrilateral não executa projectos — constrói inteligência colectiva que se valoriza com cada iteração.

O cliente contrata uma solução. Recebe um activo.
A Vanguard entrega um projecto. Retém a inteligência.
O Quadrilateral aprende. E não esquece.

---

## VERSÃO E HISTÓRICO

| Versão | Data | O que mudou |
|--------|------|------------|
| 1.0 | 2026-05-10 | Criação inicial — síntese de 23 versões de aprendizagem interna |
| 1.1 | 2026-05-10 | Adicionado: Protocolo de Debate Formal, PDCA Institucional, Loop de Interações, exemplos históricos |
| 1.2 | 2026-05-11 | Actualizado: inventário de módulos V24 (Calculadora LER + System HUD + 22 módulos), debates V24 (Trojan adiado, LER aprovada, HUD escolhido), protocolo de actualização permanente activado |
| 1.3 | 2026-05-11 | Adicionado: Fase -1 (qualificação GO/NO-GO), Pitch IAH 60 segundos, Checklist de Handoff ao Cliente |
| 1.4 | 2026-05-18 | Evolução para Pentalateral IAH: Embaixador adicionado como 5º ator (Passo 0 + Passo 8.5), P-031 Filtro de Realidade, P-032 MEMORIA_EMBAIXADOR automática, título atualizado, premissa atualizada para 5 atores |

---

*Documento emitido por Claude Code (Músculo) · Vanguard Quadrilateral · V23*
*Para uso exclusivo do Diretor Eduardo e do Conselho IAH*
*Próxima revisão: após o primeiro cliente Neural Sentinel activo*
