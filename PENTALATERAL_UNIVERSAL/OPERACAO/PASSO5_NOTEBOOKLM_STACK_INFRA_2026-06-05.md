# PASSO 5 — AUDITOR (NotebookLM) · Stack Interno Pentalateral
# Sessão: 2026-06-05 · Músculo preparou · Diretor cola no NotebookLM Ingrid
# Colar este texto no chat do NotebookLM após carregar as fontes listadas no final.

---

Você é o **Auditor do Pentalateral IAH** — NotebookLM com memória histórica do sistema. — não sobre o projeto Ingrid.
  Use os documentos universais como base.

Seu papel neste ciclo:
- Ler a DIRETRIZ do Estrategista (Gemini)  Diretriz Estratégica V1 e a reação do Músculo
- Consolidar numa Skill operacional para o Músculo executar
- Emitir [N-1 a N-5]: 5 alertas ou padrões que os outros membros não viram

**Esta análise é sobre infraestrutura INTERNA do Pentalateral — não sobre o projeto Ingrid.**
Use os documentos universais como base. Ignore contexto específico de Ingrid.

---

## CONTEXTO DESTA SESSÃO

**Tema:** Stack interno do Pentalateral IAH — n8n + OpenClaw + Notion
**Diretriz recebida:** Diretriz Estratégica V1 — Stack Interno Pentalateral — 2026-06-05
**Decisão central do Estrategista:** n8n + Notion na FASE 1 (após 18-06-2026). OpenClaw V2.

**Reação do Músculo às 5 ideias do Estrategista [G-1 a G-5]:**

- G-1 (Notion Stateless): APROVADO com modificação — permissão "view only" para Diretor, "edit" só para integration token do n8n. Campo source + timestamp em cada registro.
- G-2 (CLI Telegram): APROVADO com gate — protocolo de prefixos obrigatório antes do build: /mem · /status · /alerta. Bot vira CLI mobile. OpenClaw se torna opcional.
- G-3 (Bloqueio Gateway): ARQUITETURA DA V2 — toda mensagem externa passa pelo n8n antes de Claude API. Latência negligível (~100-200ms). Registrar como princípio no LEDGER.
- G-4 (Watchdog EasyPanel): V2 CONDICIONAL — verificar se EasyPanel expõe Docker socket antes de commitar. Se não: alternativa via SSH.
- G-5 (Buffer Notificação): APROVADO na FASE 1 — parte do build dos 4 workflows. Dois níveis: CRÍTICO (imediato) · INFORMATIVO (buffer 4h). +1h no setup.

**5 ideias do Músculo [M-1 a M-5] para o Auditor auditar:**

- M-1: Protocolo de prefixos do bot Telegram é gate bloqueante do G-2. Sem lista definida, build não começa.
- M-2: Verificar Docker socket no EasyPanel antes de incluir G-4 no roadmap.
- M-3: Migração gradual — PENDENTES.md continua durante FASE 1. Notion recebe apenas WIP_BOARD no primeiro mês. PENDENTES.md → Notion é V2.
- M-4: G-3 gera princípio novo para o LEDGER: "mensagem externa → n8n → Claude, nunca direto."
- M-5: CLAUDE.md não muda na FASE 1. A "nova era" de documentos acontece na V2, após o stack estar estável.

---

## O QUE O AUDITOR DEVE GERAR

**Skill obrigatória:** `pentalateral-stack-v1.md`

A Skill deve conter 4 partes obrigatórias:

**PARTE 1 — ARQUITETURA DA FASE 1**
- Stack aprovado: n8n (orquestrador) + Notion (cockpit visual)
- OpenClaw: V2 — condições de desbloqueio
- Data de início: 19-06-2026 (após Hypercare Valdece)
- Restrição de recursos: monitorar RAM do EasyPanel durante setup

**PARTE 2 — RESPONSABILIDADES POR EVENTO**
Para cada evento, quem aciona e quem responde:
- Check-in 7h/13h/20h
- Supabase alarme
- GitHub push
- Sessão fecha → MEMORIA atualiza
- WIP_BOARD muda → Notion atualiza
- Diretor envia comando Telegram (/mem, /status, /alerta)

**PARTE 3 — REGRAS DE BUILD (o que NÃO fazer)**
- Proibido: interface de login ou acesso externo na FASE 1
- Proibido: edição manual no Notion pelo Diretor (view only)
- Proibido: OpenClaw antes do n8n estabilizar por 30 dias
- Proibido: CLAUDE.md e session_close.ps1 alterados antes da V2
- Gate obrigatório: protocolo de prefixos Telegram definido antes do primeiro workflow
- Gate obrigatório: verificar RAM livre no EasyPanel antes de deploy do n8n

**PARTE 4 — ALERTAS DO AUDITOR [N-1 a N-5]**
5 padrões históricos ou riscos que os outros membros não viram.
Para cada alerta: O QUE É + POR QUE IMPORTA + EVIDÊNCIA DO HISTÓRICO (se houver).

---

## FONTES PARA CARREGAR NO NOTEBOOKLM

> Arrastar estes arquivos como fontes ANTES de colar o comando acima.

1. A DIRETRIZ do Gemini desta sessão (copiar como arquivo .txt ou colar como fonte)
2. `INTELLIGENCE_LEDGER.md` — já nas FONTES universais (arquivo 06)
3. `CLIENTES/WIP_BOARD.json` — já nas FONTES universais (arquivo 07)
4. `PENTALATERAL_UNIVERSAL/OPERACAO/PASSO3_GEMINI_STACK_INFRA_2026-06-05.md` — contexto da missão

---

*Músculo — Pentalateral IAH — 2026-06-05*
