# PASSO 7 — EMBAIXADOR · Seção D · Stack Interno Pentalateral
# Sessão: 2026-06-05 · Músculo preparou · Diretor cola no Claude Projects Ingrid
# Colar este texto no chat do Embaixador (Claude Projects Ingrid).

---

Você é o **Embaixador do Pentalateral IAH** — o único membro com memória persistente do cliente, do nicho de mercado e da Vanguard como empresa.

Este ciclo tem uma natureza diferente de todos os anteriores. Preciso que você reconheça isso antes de responder.

---

## ⚡ O QUE TORNA ESTE CICLO ESPECIAL

Nos ciclos anteriores, seu papel era observar Ingrid e reportar para que o Pentalateral reagisse.

**Neste ciclo, o papel é triplo:**

1. **Como guardião do cliente:** projetar como a mudança interna do Pentalateral vai afetar Ingrid especificamente — não o que aconteceu, mas o que vai acontecer.
2. **Como analista de nicho:** avaliar o que esta infraestrutura significa para o nicho EdTech-Concurso como um todo — Ingrid é a referência de um mercado de 500+ candidatos potenciais.
3. **Como estrategista da Vanguard:** identificar o que esta automação abre ou fecha para a empresa — o que fica mais fácil de vender, o que fica mais difícil de entregar, o que cria moat.

Você é o único membro que opera nessas três camadas ao mesmo tempo. É aqui que você é insubstituível.

---

## CONTEXTO: O QUE O PENTALATERAL DECIDIU FAZER

Ciclo completo: Gemini → NotebookLM → você.

**Decisões aprovadas:**

1. **n8n como orquestrador** (build após 18-06-2026)
   - Automatiza check-ins diários às 7h, 13h e 20h para o Diretor via Telegram
   - Monitor automático do Supabase de cada cliente a cada hora
   - Webhook GitHub → atualiza estado do projeto automaticamente
   - Ao fechar sessão → MEMORIA atualiza sem ação manual do Diretor

2. **Notion como cockpit visual** — WIP_BOARD vira interface visual (view-only para o Diretor)

3. **OpenClaw V2** — desbloqueado após 30 dias de n8n estável
   - Gateway AI multi-canal: WhatsApp, Telegram, Discord, iMessage
   - Toda mensagem externa passa pelo n8n antes de chegar ao Claude API

**Contexto atual de Ingrid:**
- Temperatura: 8.5/10 — VERDE FORTE — "gostou muito da ferramenta"
- Edge Function ativa: gatilho às 19h45 BRT diariamente
- Prova: 06-09-2026 (92 dias)
- Status: RETAINER — piloto fundadora do nicho EdTech-Concurso SEDES-DF

**Contexto do nicho EdTech-Concurso:**
- Meta SaaS: 500 usuários no ciclo Sedes-DF 2026 = R$194.000
- Ingrid é cliente referência (0% → maturidade do nicho)
- Segunda candidata ainda não captada — gate bloqueante para multi-tenant

---

## AS 15 IDEIAS — FILTRO DE REALIDADE EM TRÊS CAMADAS

**REGRA:** Para cada ideia, aplique as três camadas — **CLIENTE** (Ingrid específica), **NICHO** (EdTech-Concurso amplo), **VANGUARD** (empresa). Use CONFIRMA / EXPANDE / ALERTA em cada camada se tiver evidência. Se não tiver, diga claramente.

### Do Estrategista [G-1 a G-5]:

- **G-1 (Notion Stateless):** Notion como cockpit visual — WIP_BOARD visual, view-only para o Diretor, escrita exclusiva via n8n.
- **G-2 (CLI Telegram):** Bot com prefixos (/mem, /status, /alerta) — Diretor gerencia todos os projetos pelo celular.
- **G-3 (Bloqueio Gateway):** Toda mensagem externa passa pelo n8n antes do Claude — sistema deixa de ser acessado diretamente.
- **G-4 (Watchdog EasyPanel):** Monitor de saúde do servidor — detecta queda antes que o cliente perceba.
- **G-5 (Buffer Notificação):** CRÍTICO (imediato) vs. INFORMATIVO (buffer 4h) — Diretor não é inundado de alertas.

### Do Músculo [M-1 a M-5]:

- **M-1:** Protocolo de prefixos Telegram é gate bloqueante — sem lista definida, build não começa.
- **M-2:** Verificar Docker socket antes do watchdog — se EasyPanel não expõe socket, arquitetura muda.
- **M-3:** Migração gradual — PENDENTES.md continua em FASE 1. Notion recebe só WIP_BOARD no primeiro mês.
- **M-4:** Novo princípio: "mensagem externa → n8n → Claude, nunca direto." Toda interação passa por uma camada de orquestração.
- **M-5:** CLAUDE.md e session_close.ps1 não mudam na FASE 1 — estabilidade operacional antes de "nova era" documental.

### Do Auditor [N-1 a N-5]:

- **N-1:** Lock manual no Notion — qualquer edição manual do Diretor em card cria conflito de edição concorrente com n8n.
- **N-2:** Watchdog no mesmo servidor é ponto cego — exige ping externo independente (UptimeRobot ou equivalente).
- **N-3:** session_close.ps1 deve disparar webhook em fire-and-forget — resposta síncrona congela o terminal e cria fricção de ritual.
- **N-4:** Exports de workflow n8n para repositório podem expor credenciais — hook pré-push precisa ser calibrado.
- **N-5:** LEDGER.md deve ser gravado localmente ANTES de qualquer sync para Notion — Notion não substitui o disco.

---

## PERGUNTAS ESPECÍFICAS — SUA INTELIGÊNCIA EXCLUSIVA

### Camada Cliente (Ingrid):

**[Q-1] Automação vs. Calor Humano:**
Com n8n automatizando check-ins e atualizações, o Diretor terá mais tempo — mas menos toques manuais no projeto de Ingrid.
A temperatura 8.5/10 de Ingrid é resultado da ferramenta ou do relacionamento com o Diretor?
Se o Diretor "desaparecer" por estar automatizado, Ingrid percebe e esfria — ou ela valoriza mais a ferramenta funcionando do que o contato direto?

**[Q-2] OpenClaw e canal preferido:**
OpenClaw V2 habilitaria WhatsApp bidirecional com Claude. Ingrid poderia falar com a ferramenta via WhatsApp antes da prova.
Você tem sinais do canal de comunicação que Ingrid prefere?
Adotar um canal automatizado com IA seria percebido como evolução do produto — ou como o Diretor se escondendo atrás da automação?

### Camada Nicho (EdTech-Concurso):

**[Q-3] Escalabilidade do modelo de atenção:**
O modelo atual (Diretor acompanha manualmente cada candidata) não escala para 500 usuárias.
A automação (n8n + monitor Supabase + alertas automáticos) é o que torna o SaaS viável — mas também reduz o diferencial de atenção individual.
O nicho EdTech-Concurso compra ferramenta ou compra atenção personalizada?
Se for atenção, a automação mata o produto. Se for ferramenta, a automação libera o Diretor para focar em produto.

**[Q-4] OpenClaw como feature de nicho:**
WhatsApp bidirecional com Claude como tutor de concurso — disponível 24h, sem esperar o Diretor responder — é uma feature que candidatas do nicho pagariam mais para ter?
Ou o nicho EdTech-Concurso prefere self-service e não valoriza canal de comunicação direta com IA?

### Camada Vanguard (empresa):

**[Q-5] Moat ou commodity:**
A combinação n8n + Notion + OpenClaw (quando V2 chegar) cria um diferencial real de operação que concorrentes não replicam facilmente — ou qualquer agência com n8n tem o mesmo?
O que desta infraestrutura é moat de verdade para a Vanguard?

**[Q-6] Janela antes da prova de Ingrid:**
O gate de 30 dias para OpenClaw significa disponibilidade ~meados de agosto.
A prova de Ingrid é 06-09-2026 — canal WhatsApp com Claude estaria disponível ~3 semanas antes da prova.
Do ponto de vista estratégico: vale acelerar o OpenClaw para estar disponível na reta final antes da prova de Ingrid — como teste de nicho real — ou o risco de instabilidade seria pior do que o benefício?

---

## O QUE ENTREGAR

**SEÇÃO D — Filtro de Realidade (3 camadas):**
Para cada uma das 15 ideias: avalie nas camadas CLIENTE / NICHO / VANGUARD.
Use CONFIRMA / EXPANDE / ALERTA onde tiver evidência. Declare ausência de evidência onde não tiver.

**RESPOSTAS Q-1 a Q-6:** Direto, com base no histórico observado — sem especulação genérica.

**[E-1 a E-5] — Observações exclusivas do Embaixador:**
5 pontos que os outros membros não têm acesso.
Para cada um: O QUE OBSERVOU + POR QUE IMPORTA PARA A DECISÃO DE INFRAESTRUTURA.
Priorize observações que cruzem duas ou mais camadas (ex: comportamento de Ingrid que revela algo sobre o nicho como um todo).

---

*Músculo — Pentalateral IAH — 2026-06-05*
*Localização: CLIENTES/INGRID/PASSO7_EMBAIXADOR_INFRA_2026-06-05.md*
