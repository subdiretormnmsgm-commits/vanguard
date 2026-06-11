# LEDGER_INBOX — Buffer de Princípios e Falhas Pendentes
> Arquivo: `LEDGER_INBOX.md` · Raiz do projeto
> Função: buffer oficial para princípios e erros que aguardam autorização P-098 para entrar no INTELLIGENCE_LEDGER.md
> Regra: ao detectar falha ou princípio na sessão → registrar aqui IMEDIATAMENTE, mesmo sem flag P-098.
> Quando autorizado: Músculo move para INTELLIGENCE_LEDGER.md com `[RESOLVE: LEDGER_INBOX-XXX]`.
> Criado: 2026-06-10 · Loop 32 · ATO 6

---

## P-148 — LEDGER_INBOX COMO BUFFER DE INTEGRIDADE (2026-06-10)

**ID:** P-148
**Status:** PENDENTE AUTORIZAÇÃO P-098 → INTELLIGENCE_LEDGER.md
**Origem:** FALHA [J] desta sessão — FALHAS [A–I] não entraram no LEDGER porque P-098 bloqueava e o sistema não tinha buffer.
**Princípio:** Todo erro ou aprendizado identificado em sessão que não possa ser inscrito no LEDGER imediatamente (P-098 bloqueante) DEVE ir para `LEDGER_INBOX.md` antes de qualquer outra coisa. Não existe "vou registrar depois" — o compacto de contexto apaga o que não está em arquivo.
**Regra operacional:**
  (1) Detectou falha → registrar em LEDGER_INBOX imediatamente (sem flag P-098)
  (2) Ao receber autorização: `[RESOLVE: LEDGER-INBOX-P148]` + mover para INTELLIGENCE_LEDGER.md
  (3) LEDGER_INBOX nunca substitui o LEDGER — é ponte, não destino
**Por que é crítico:** sessão de Loop 31 gerou 11 falhas ([A]–[K]) que ficaram presas no PAINEL porque não havia buffer entre "detectado" e "autorizado". Algumas se repetiram.
**Aplica-se a:** toda sessão que detecte falha operacional. Princípios de processo (não arquitetura) têm prioridade de entrada.
**Ferramenta:** este arquivo. Próximo passo: adicionar ao PENDENTES.md entrada `[musculo] Mover P-148 para LEDGER quando autorizado`.

---

## ADDENDUM P-130 — ANTIGRAVITY É EXECUTOR, NÃO ESTRATEGISTA (2026-06-10)

**ID:** P-130-ADDENDUM
**Status:** PENDENTE AUTORIZAÇÃO P-098 → INTELLIGENCE_LEDGER.md (linha de adição ao P-130 existente)
**P-130 atual diz:** "Antigravity é o canal Gemini→Músculo do Pentalateral, executor isolado do Estrategista (P-124 preservado)."
**Addendum:** "DIRETRIZ é papel exclusivo do Gemini Advanced — Antigravity jamais gera DIRETRIZ de loop. Antigravity = EXECUTOR do Estrategista, não o Estrategista em si. Identidade corrigida em Loop 32 (2026-06-10 · veredito Diretor)."
**Impacto:** todos os documentos do sistema foram atualizados no Loop 32 para refletir esta distinção. PASSO3_GEMINI.md, GEMINI.md, CLAUDE.md, SKILL_PROTOCOLO_VANGUARD v7.0, MANUAL_DIRETOR v1.9 e demais.

---

## FALHAS DO LOOP 31 — [A] a [K] (2026-06-10)

> Estas falhas foram identificadas e registradas no PAINEL mas não puderam entrar no LEDGER por bloqueio P-098.
> Mover para INTELLIGENCE_LEDGER.md com tag `[FALHA-PROCESSO-2026-06-10]` quando autorizado.

### [FALHA-PROCESSO-2026-06-10-A] Skills erradas ao analisar SEÇÃO D do Embaixador
**O que aconteceu:** Músculo usou `mcp-builder` ao analisar E-1..E-5 em vez de `ultrathink-trigger → brainstorming → writing-plans`.
**Gravidade:** CRÍTICO — análise da SEÇÃO D com ferramenta errada produz output degradado.
**Corrigido:** check_skills_embaixador.ps1 criado (P-146). Memória feedback_skills_ao_analisar_embaixador.md atualizada.
**Prevenção:** hook pre-SEÇÃO-D verifica as 3 skills corretas antes de qualquer análise.

### [FALHA-PROCESSO-2026-06-10-B] Deliberação sem citar texto das ideias
**O que aconteceu:** Músculo deliberou sem `[IDEIA: texto literal]` — análise flutuante, não ancorada.
**Gravidade:** ALTO — veredito sem âncora textual é deliberação de memória, não do documento.
**Corrigido:** padrão restabelecido na sessão.
**Prevenção:** PADRÃO DE DELIBERAÇÃO no CLAUDE.md exige citar texto antes de avaliar.

### [FALHA-PROCESSO-2026-06-10-C] Antigravity 0 acionamentos na sessão
**O que aconteceu:** sessão inteira de Loop 31 sem um único acionamento do Antigravity (Estrategista).
**Gravidade:** CRÍTICO — sem Estrategista, o loop perde o vetor de divergência.
**Corrigido:** não corrigido — pendente Loop 33.
**Prevenção:** PASSO3 Loop 33 deve ser PRIMEIRO ATO da próxima sessão.

### [FALHA-PROCESSO-2026-06-10-D] DEF-M-6 — Músculo sugeriu encerramento
**O que aconteceu:** Músculo propôs encerrar a sessão sem ordem do Diretor.
**Gravidade:** MÉDIO — prerrogativa do Diretor violada.
**Corrigido:** registrado. Memória feedback_fechamento_ordem_diretor.md confirma a regra.
**Prevenção:** CLAUDE.md Item 9 (fechamento é prerrogativa do Diretor) já cobre.

### [FALHA-PROCESSO-2026-06-10-E] WIP_BOARD 3 loops atrasado
**O que aconteceu:** WIP_BOARD declarava Loop 29 enquanto sistema estava no Loop 32.
**Gravidade:** ALTO — todo script que lê WIP_BOARD operava com loop errado.
**Corrigido:** commit 478c542 — WIP_BOARD sincronizado.
**Prevenção:** post_loop_action.ps1 deve atualizar WIP_BOARD imediatamente ao fechar loop.

### [FALHA-PROCESSO-2026-06-10-F] Token Hermes morto desde implantação
**O que aconteceu:** Hermes não recebia mensagens do Telegram por token inválido desde implantação.
**Gravidade:** CRÍTICO — canal de comunicação 24/7 estava morto sem detecção.
**Corrigido:** token corrigido (7914321985 → 8146192723). Hermes respondendo.
**Prevenção:** ping_hermes.ps1 no session_start verifica health check. Telegram /status deve retornar em 30s.

### [FALHA-PROCESSO-2026-06-10-G] `sed` passado sem especificar container Linux
**O que aconteceu:** comando sed sugerido pelo Músculo não especificou qual container Docker executar.
**Gravidade:** BAIXO — gerou confusão de execução.
**Corrigido:** RUNBOOK_EASYPANEL.md atualizado com prefixo `docker exec hermes-agent`.
**Prevenção:** toda instrução de terminal com EasyPanel deve incluir `docker exec [container] [cmd]`.

### [FALHA-PROCESSO-2026-06-10-H] BOM UTF-8 silencioso quebrando ChurnWatch
**O que aconteceu:** WIP_BOARD.json tinha BOM que quebrava parsing JSON em múltiplos scripts por múltiplas sessões sem detecção.
**Gravidade:** ALTO — 3ª ocorrência do mesmo problema.
**Corrigido:** commit f11e441 — BOM removido.
**Prevenção:** fix_bom_json.ps1 integrado ao Gate 1 do session_close (ATO 3 — Loop 33).

### [FALHA-PROCESSO-2026-06-10-I] Cron W-1 1x/dia em vez de 3x
**O que aconteceu:** W-1 configurado para disparar 1x/dia (7h BRT) mas deveria ser 3x (7h/13h/20h BRT).
**Gravidade:** ALTO — 2/3 dos briefings diários nunca chegaram ao Diretor.
**Corrigido:** não corrigido — pendente Loop 33.
**Prevenção:** ao importar qualquer workflow n8n → verificar schedule contra especificação em CLAUDE.md.

### [FALHA-PROCESSO-2026-06-10-J] FALHAS [A–I] não entraram no LEDGER
**O que aconteceu:** P-098 bloqueou inscrição das falhas no LEDGER — sem buffer, as falhas ficaram no PAINEL apenas.
**Gravidade:** MÉDIO — falha que não entra no LEDGER não tem prevenção permanente.
**Corrigido:** LEDGER_INBOX.md criado (este arquivo) como solução estrutural.
**Prevenção:** P-148 — toda falha vai para LEDGER_INBOX imediatamente, independente de P-098.

### [FALHA-PROCESSO-2026-06-10-K] Volume de deliberação sem conversão em build
**O que aconteceu:** Loop 31 gerou ~91 ideias e 8 builds aprovados — 0 builds iniciados.
**Gravidade:** ESTRUTURAL — sistema que só delibera sem construir perde velocidade de entrega.
**Corrigido:** Loop 32 foi 100% build (nenhuma deliberação nova) — padrão correto.
**Prevenção:** ao abrir loop com builds_aprovados_nao_iniciados > 0, Músculo propõe build antes de deliberação.

---

## COMO USAR ESTE ARQUIVO

1. **Adicionar:** ao detectar falha ou novo princípio → adicionar seção aqui imediatamente
2. **Autorizar:** quando Diretor disser "AUTORIZO SOBRESCREVER INTELLIGENCE_LEDGER.md" → Músculo move os itens
3. **Commit:** `[RESOLVE: LEDGER-INBOX-FALHAS]` fecha o lote
4. **Limpar:** após mover para LEDGER, remover a seção do INBOX
5. **Nunca:** deixar item no INBOX por mais de 3 loops sem mover

---

*LEDGER_INBOX v1.0 · Criado 2026-06-10 · Loop 32 · ATO 6 concluído*
