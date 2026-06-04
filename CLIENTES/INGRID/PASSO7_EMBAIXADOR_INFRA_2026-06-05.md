# PASSO 7 — EMBAIXADOR · Seção D · Stack Interno Pentalateral
# Sessão: 2026-06-05 · Músculo preparou · Diretor cola no Claude Projects Ingrid
# Colar este texto no chat do Embaixador (Claude Projects Ingrid).

---

Você é o **Embaixador do Pentalateral IAH** — o único membro com memória persistente do cliente.

Este ciclo tem uma natureza diferente de todos os anteriores. Preciso que você reconheça isso antes de responder.

---

## ⚡ O QUE TORNA ESTE CICLO ESPECIAL

Nos ciclos anteriores, seu papel era observar Ingrid e reportar para que o Pentalateral reagisse.

**Neste ciclo, o papel é o oposto.**

O Pentalateral está prestes a mudar internamente — não o produto da Ingrid, mas a infraestrutura do próprio Conselho. E você é o único membro com dados reais de como Ingrid se comporta, o que ela valoriza, o que a retém, e o que poderia criar estranheza.

Você está sendo chamado não como relator de comportamento passado. Está sendo chamado como **guardião do cliente no futuro próximo**: o sistema vai mudar, e você precisa dizer se essa mudança vai servir melhor a Ingrid ou apenas ao Diretor.

Esta é sua análise mais estratégica até agora.

---

## CONTEXTO: O QUE O PENTALATERAL DECIDIU FAZER

Ciclo completo: Gemini → NotebookLM → você.

**Decisões aprovadas:**

1. **n8n como orquestrador** — entra em build após 18-06-2026
   - Automatiza check-ins diários às 7h, 13h e 20h via Telegram para o Diretor
   - Monitor automático do Supabase de Ingrid a cada hora
   - Webhook GitHub → atualiza estado do projeto automaticamente
   - Ao fechar sessão → MEMORIA atualiza sem ação do Diretor

2. **Notion como cockpit visual** — WIP_BOARD vira interface visual
   - Diretor vê estado de Ingrid numa URL, não num .json bruto
   - Notion recebe apenas leitura — toda escrita é via n8n

3. **OpenClaw V2** — desbloqueado apenas após 30 dias de n8n estável
   - Gateway AI multi-canal: WhatsApp, Telegram, Discord, iMessage
   - Toda mensagem externa passa pelo n8n antes de chegar ao Claude

**Dados de Ingrid que você já tem:**
- Temperatura atual: 8.5/10 — VERDE FORTE
- Depoimento recente: "gostou muito da ferramenta"
- Edge Function ativa: gatilho às 19h45 BRT todos os dias
- Prova: 06-09-2026 (92 dias)
- Status: RETAINER — sem novos loops de build até segunda candidata

---

## AS 15 IDEIAS — CADA UMA PASSA PELO SEU FILTRO

**REGRA:** Para cada ideia, você deve dizer CONFIRMA / EXPANDE / ALERTA — com evidência específica sobre Ingrid, não sobre "clientes em geral". Se não tiver evidência específica, diga isso claramente em vez de especular.

### Do Estrategista [G-1 a G-5]:

- **G-1 (Notion Stateless):** Notion como cockpit visual dos projetos — WIP_BOARD visual, view-only para o Diretor, escrita exclusiva via n8n.
- **G-2 (CLI Telegram):** Bot Telegram com prefixos (/mem, /status, /alerta) — Diretor gerencia projetos pelo celular sem abrir terminal.
- **G-3 (Bloqueio Gateway):** Toda mensagem externa passa pelo n8n antes de Claude API — o sistema deixa de ser diretamente acessível.
- **G-4 (Watchdog EasyPanel):** Monitor de saúde do servidor — detecta queda antes do Diretor perceber.
- **G-5 (Buffer Notificação):** CRÍTICO (imediato) vs. INFORMATIVO (buffer 4h) — Diretor não é inundado de alertas.

### Do Músculo [M-1 a M-5]:

- **M-1:** Protocolo de prefixos Telegram é gate bloqueante — sem lista definida, build não começa.
- **M-2:** Verificar Docker socket antes do watchdog — se EasyPanel não expõe socket, arquitetura muda.
- **M-3:** Migração gradual — PENDENTES.md continua em FASE 1. Notion recebe só WIP_BOARD no primeiro mês.
- **M-4:** Novo princípio operacional: "mensagem externa → n8n → Claude, nunca direto."
- **M-5:** CLAUDE.md e session_close.ps1 não mudam na FASE 1 — estabilidade antes de "nova era" documental.

### Do Auditor [N-1 a N-5]:

- **N-1:** Lock manual severo no Notion — qualquer edição manual do Diretor em card cria conflito de edição concorrente com n8n.
- **N-2:** Watchdog dentro do mesmo servidor é ponto cego — se o servidor cair, o alerta cai junto. Exige ping externo (ex: UptimeRobot).
- **N-3:** session_close.ps1 deve disparar webhook em fire-and-forget (assíncrono) — resposta síncrona congela o terminal.
- **N-4:** Exports de workflow n8n para repositório podem expor credenciais — hook pré-push precisa ser calibrado antes do deploy.
- **N-5:** LEDGER.md deve ser gravado localmente ANTES de qualquer sync para Notion — Notion não substitui o disco como repositório permanente.

---

## PERGUNTAS ESPECÍFICAS — SUA INTELIGÊNCIA EXCLUSIVA

Estas perguntas só você pode responder. Não com generalização — com o que sabe sobre Ingrid.

**[Q-1] Automação vs. Calor Humano:**
Com n8n automatizando check-ins e atualizações, o Diretor vai ter mais tempo — mas menos toques manuais no projeto da Ingrid.
A temperatura 8.5/10 dela é resultado da ferramenta ou do relacionamento com o Diretor?
Se o Diretor "desaparecer" por estar automatizado, Ingrid percebe e esfria — ou ela valoriza mais a ferramenta funcionando do que o contato direto?

**[Q-2] OpenClaw e canal preferido:**
OpenClaw V2 vai habilitar WhatsApp bidirecional com Claude. Ingrid poderia, teoricamente, falar com a ferramenta via WhatsApp em vez do app.
Você tem algum sinal do canal de comunicação que Ingrid prefere?
Adotar um canal automatizado com IA seria percebido como evolução do produto ou como o Diretor se escondendo atrás da automação?

**[Q-3] Sinais de churn detectáveis pelo n8n:**
O monitor automático do Supabase vai detectar inatividade de Ingrid antes que o Diretor perceba.
Quais padrões de comportamento de Ingrid que você já observou seriam os primeiros sinais de churn que o n8n deveria alertar?
(Ex: frequência de acesso, horário de uso, padrão de resposta ao Diretor)

**[Q-4] Janela de oportunidade antes da prova:**
O gate de 30 dias para OpenClaw significa que ele só estaria disponível em meados de agosto (se build começar em 19-06).
A prova de Ingrid é em 06-09-2026 — o canal WhatsApp com Claude estaria disponível ~3 semanas antes da prova.
Você vê valor em ter esse canal disponível para Ingrid nas semanas finais antes da prova? Ou a ferramenta atual é suficiente para o período de pressão máxima?

---

## O QUE ENTREGAR

**SEÇÃO D — Filtro de Realidade:**
Para cada uma das 15 ideias: CONFIRMA / EXPANDE / ALERTA + evidência específica de Ingrid (ou "sem evidência específica").

**RESPOSTAS Q-1 a Q-4:** Com base no histórico observado — direto, sem especulação.

**[E-1 a E-5]:** 5 observações exclusivas do Embaixador que os outros membros não têm acesso. Cada uma: O QUE OBSERVOU + POR QUE IMPORTA PARA A DECISÃO DE INFRAESTRUTURA.

---

*Músculo — Pentalateral IAH — 2026-06-05*
*Localização: CLIENTES/INGRID/PASSO7_EMBAIXADOR_INFRA_2026-06-05.md*
