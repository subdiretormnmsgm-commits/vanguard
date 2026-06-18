---
titulo: OPERACAO VAULT SOBERANO -- Plano Cirurgico
tipo: PLANO_OPERACIONAL
status: CONCLUIDA
created: 2026-06-17
updated: 2026-06-17
autor: Musculo (Claude Code)
veredito_diretor: aprovado_por_fase
fases: F0 OK | F1 OK | F2 OK | F3 OK | F4 OK | F5 OK | F6 verificado (push no Gate 10) | F7 OK (Detector ativo)
related: [INTELLIGENCE_LEDGER, DEPENDENCY_MAP, reference_detector_deriva_estado_arte, project_obsidian_intencao]
---

# OPERACAO VAULT SOBERANO -- Plano Cirurgico

> Decisoes de arranque ja vereditadas pelo Diretor (2026-06-17):
> F1 primeiro + F0 em paralelo | exclusao CONSERVADORA (_ARQUIVO/ antes de apagar) | plano cristalizado aqui.
> Fase pos-operacao (Detector de Deriva) acrescentada por ordem do Diretor (2026-06-17).

## Objetivo (1 frase)

Transformar o vault Vanguard de um repositorio organico/desorganizado em uma arquitetura limpa,
**verificavel por data+hora**, 100% Markdown, com procedimentos **adaptados por contexto de cliente**,
e pronta para operar com o **Detector de Deriva**.

---

## Principios de execucao (constraints transversais -- valem em TODAS as fases)

| # | Constraint | Origem |
|---|---|---|
| C1 | **LOCAL-FIRST absoluto** -- toda leitura/edicao no filesystem local. NUNCA sobre o mount rclone. `gdrive:vanguard` so e tocado no Gate 10 final. | P-169/P-181 |
| C2 | **Nada destrutivo sem veredito + checkpoint git** -- commit de checkpoint antes de cada fase que apaga/move. | P-098 |
| C3 | **Isolamento por cliente** -- Ingrid/Valdece/Vanguard nunca se cruzam; adaptacao respeita o contexto de cada um. | P-059 |
| C4 | **Classificar antes de tocar** -- todo doc e TIPO 1/2/3 (DEPENDENCY_MAP) antes de mover/sincronizar/deletar. | P-073/P-074 |
| C5 | **Pasta "Doc Vanguard Evolucao Diretor" e PROIBIDA** -- fora da varredura, fora dos commits. | Diretor |

---

## Correlacoes confirmadas (analise pre-plano)

1. **Timeline P-073/P-059 == auditoria por data/hora.** A Timeline defasada nao e item isolado; e o
   sintoma visivel da ausencia de auditoria de frescor sistematica. A Fase 1 a sinaliza como subproduto
   e cria o mecanismo que impede recorrencia. Nao ha "tarefa Timeline" separada.
2. **Mensagem do rclone == regra de execucao, nao fase.** Varrer/editar sobre o mount causa perda de
   conteudo + latencia. Vira a constraint C1: leitura/edicao sempre local; Drive so no fim.
3. **Frontmatter datado (Segundo Cerebro) == espinha da Fase 1 e do Detector.** O `created/updated` em
   YAML e a mesma unidade de verificacao por data que a auditoria exige -- por isso o Detector (Fase 7)
   reaproveita a Fase 1 em vez de duplicar.

---

## Sequencia e dependencias

```
FASE 0 (skills) ........... independente, roda em paralelo
FASE 1 (auditoria) --> FASE 2 (dedup/reorg) --> +-- FASE 3 (organograma)
                                                 +-- FASE 4 (markdown)
                                                 +-- FASE 5 (sync + adaptacao) --> FASE 6 (Drive)
                                                                                       |
                                                                                       v
                                                                                  FASE 7 (Detector) -- POS-OPERACAO
```

---

## FASE 0 -- Skills .md como skills reais da tool Skill  ·  independente  ·  0,5-3h

| | |
|---|---|
| **Objetivo** | A tool `Skill` parar de devolver "Unknown skill" para os .md locais Vanguard. |
| **Diagnostico (~30min, 1o passo)** | Hipotese forte: os .md sao flat files em `.claude/skills/` sem a estrutura `skill-name/SKILL.md` + frontmatter que o loader indexa (as Tier-1 ogilvy/frontend foram instaladas via shell por isso). Confirmar: comparar 1 skill que carrega vs 1 que da "Unknown skill". |
| **Acao** | Conforme diagnostico: migrar para estrutura de pasta + frontmatter valido OU registrar no manifest do plugin. |
| **Gate** | Invocar 1 skill migrada e confirmar carregamento real (nao fallback por Read). |
| **Risco** | Quebrar a trava P-180 (que hoje depende de Read no .md). Validar que a trava continua satisfeita. |

## FASE 1 -- Inventario e Auditoria de Frescor (FUNDACAO)  ·  bloqueia 2-7  ·  2-4h

| | |
|---|---|
| **Objetivo** | Manifesto unico e verificavel de TUDO. |
| **Escopo (sem excecao, local)** | `PENTALATERAL_UNIVERSAL/**` + `CLIENTES/**` + `PENDENTES.md` + `LEDGER_INBOX.md` + `INTELLIGENCE_LEDGER.md`. Exclui apenas C5. |
| **Coleta por arquivo** | caminho · tamanho · LastWriteTime · SHA-256 · TIPO (1/2/3) · formato (md/json/txt/outros). |
| **Deteccoes** | duplicados (hash igual) · orfaos · stale (data antiga vs fonte canonica) · nao-Markdown · Timeline defasada cai aqui automaticamente. |
| **Output** | `VAULT_MANIFEST.json` + `VAULT_AUDIT_REPORT.md` (semaforo por pasta). Script PS roda LOCAL (C1). |
| **Gate** | Diretor revisa o relatorio antes de qualquer acao das fases seguintes. |

## FASE 2 -- De-dup e Reorganizacao  ·  depende F1  ·  2-3h + veredito

| | |
|---|---|
| **Objetivo** | Decidir o que deletar/mover e desenhar a arvore-alvo. |
| **Metodo** | Plan Mode + skill de arquitetura/brainstorming -- aqui e o lugar certo dela. |
| **Output** | Proposta de nova arvore + lista de exclusoes NUMERADA. |
| **Gate BLOQUEANTE** | Exclusoes aprovadas item a item (C2). Politica CONSERVADORA: mover para `_ARQUIVO/` antes de apagar. Nada deletado por inferencia do Musculo. |

## FASE 3 -- Organograma + Workflow  ·  depende F2  ·  1-2h

Diagrama da arvore de pastas + workflow de documentos (quem escreve onde, como cascateia via DEPENDENCY_MAP).
Output: `ESTRUTURA_VAULT.md` (Mermaid + descricao).

## FASE 4 -- Padronizacao Markdown  ·  depende F2  ·  1-2h

Converter `.txt`/outros para `.md` (preparar o Detector de Deriva).
**Whitelist obrigatoria:** chaves gitignored (`CHAVES_SISTEMA_VANGUARD.txt`, `N8N Easypanel.txt`) e logs NAO convertem.

## FASE 5 -- Sync + Adaptacao Contextual  ·  depende F1-F4  ·  2-4h

| | |
|---|---|
| **Diferencial** | Nao e so copiar (P-007 proibe copia direta de TEMPLATE) -- e ADAPTAR procedimentos ao contexto de cada destino: Ingrid · Valdece · Vanguard · Templates. |
| **Mecanica** | `sync_vanguard_docs.ps1` + `propagate_changes.ps1` para UNIVERSAL_PURO; camada de adaptacao para TEMPLATE_COM_INSTANCIA. |
| **Gate** | Integridade SHA pos-sync: VERDE (0 falhas) / AMARELO (orfaos p/ veredito) / VERMELHO (falha de copia). |

## FASE 6 -- Espelho para Drive (Gate 10 rclone)  ·  final da operacao  ·  0,5h

So agora: `local -> gdrive:vanguard` via Gate 10 (rclone preserva mtime). O Drive recebe o estado ja limpo. Confirma C1.

---

# FASE 7 -- ATIVACAO DO DETECTOR DE DERIVA  ·  POS-OPERACAO  ·  depende de F1-F6 concluidas

> So inicia depois que o vault estiver limpo, datado e 100% Markdown. Detector sobre vault sujo = ruido.

## O que e o Detector de Deriva (em linguagem simples)

O Detector de Deriva e o **vigia que compara o que os documentos DIZEM com o que e VERDADE no disco e no
git**. Quando um documento afirma um estado que nao corresponde a realidade (ex: WIP_BOARD diz "gemini=OK"
sem a DIRETRIZ existir; Timeline parada ha 7 dias enquanto 2 loops aconteceram), ele aponta a deriva
antes que ela vire decisao errada. E o antivirus contra "o papel diz uma coisa, a realidade diz outra".

A pasta `CONSELHO/Detentor de Deriva` ja traz a base pronta: o kit **Segundo Cerebro** (Claude Code +
Obsidian) com memoria persistente (`_memory/current-state.md`), registro de decisoes (`_decisions/`),
aprendizados (`_learnings/`), 8 slash commands e frontmatter datado. O Obsidian e a **camada visual** do
Detector. A Fase 7 nao cria do zero -- ela ADAPTA esse kit ao contexto Vanguard e o liga aos socios.

## O que o Detector vai FAZER (acoes automaticas concretas)

| Acao | O que faz, em 1 frase | Base reaproveitada |
|---|---|---|
| **Varredura de frescor** | Re-roda a auditoria da Fase 1 e marca docs cuja `updated` diverge da realidade (git/disco). | Fase 1 + frontmatter `updated` |
| **Cruzamento estado-vs-verdade** | Confere WIP_BOARD/Timeline/PENDENTES contra git log e artefatos em disco (P-091/P-092). | auditar_consistencia.ps1 |
| **Briefing de deriva** | Gera um resumo do que derivou desde a ultima checagem, em linguagem simples. | comando `/daily-briefing` adaptado |
| **Registro automatico** | Toda deriva detectada vira nota datada em `_decisions/` ou `_learnings/` com contexto. | `/end-session` adaptado |
| **Visual no Obsidian** | O grafo do Obsidian mostra os pontos de deriva como nos destacados. | `Meu Segundo Cerebro/.obsidian` |
| **Guarda de injecao** | Trata conteudo externo como dado, nunca instrucao (OWASP ASI01). | CLAUDE.md do kit (secao 4) |

## Periodicidade

| Frequencia | Acao | Gatilho |
|---|---|---|
| **Diaria** | Varredura de frescor + briefing de deriva | session_start (junto do mapa diario) ou cron Hermes 7h |
| **Semanal** | Revisao de deriva acumulada (o que travou, o que ficou stale) | `/weekly-review` adaptado · segunda-feira |
| **Por loop** | Cruzamento estado-vs-verdade no fechamento de cada loop Pentalateral | session_close (Gate novo) |
| **Por evento** | Deriva critica (ex: TIPO 1 editado fora da fonte) dispara alerta imediato | detect_canonical_violation.ps1 |

## Integracao com os socios

- **Musculo:** consome o briefing de deriva no session_start; corrige docs derivados ANTES de qualquer acao (mandato CLAUDE.md item 0).
- **Auditor (NotebookLM):** recebe a lista de docs stale para nao propagar deriva as FONTES.
- **Estrategista (Gemini):** o `CONTEXTO_GEMINI.md` so e gerado se o Detector confirmar frescor (anti-stale anchor).
- **Embaixador (Claude Projects):** o BLOCO 0 ja lista "Inconsistencias abertas" -- o Detector passa a alimentar essa secao automaticamente.
- **Hermes (n8n):** cron diario/semanal dispara a varredura e notifica o Telegram quando ha deriva (clone do padrao W-11/W-12).

## Sequencia da Fase 7

1. **Mapear o kit** (FEITO em 2026-06-17): pasta inspecionada, 8 comandos + estrutura Segundo Cerebro identificados.
2. **Adaptar o CLAUDE.md do kit** ao contexto Vanguard (identidade = Pentalateral, nao freelancer generico).
3. **Reaproveitar a Fase 1** como motor de varredura de frescor do Detector (zero duplicacao).
4. **Ligar os gatilhos** (session_start, session_close, crons Hermes) -- cada um com fallback manual <=3 passos (P-110).
5. **Ligar a camada visual** Obsidian (grafo de deriva).
6. **Dar ciencia ao Diretor** em 1 pagina: o que o Detector faz, quando, e como ler o alerta.
7. **Gate:** rodar o Detector 1x e confirmar que ele pega uma deriva real conhecida (ex: a Timeline defasada).

## Estimativa Fase 7

~4-6h (1 sessao dedicada Opus), apos F1-F6 concluidas.

---

## Estimativa e cadencia global

| Sessao | Fases | Estimativa |
|---|---|---|
| 1 | F0 + F1 | 3-7h |
| 2 | F2 (deliberacao pesada) | 2-3h + veredito |
| 3 | F3 + F4 | 2-4h |
| 4 | F5 + F6 | 2,5-4,5h |
| 5 (pos) | F7 Detector | 4-6h |

**Total ~14-24h -> 4-5 sessoes dedicadas (Opus).**

## Riscos principais

1. **Varredura sobre rclone -> perda de conteudo.** Mitiga: C1 absoluto.
2. **Deletar canonico achando que e duplicado.** Mitiga: C4 + veredito item a item + checkpoint git + politica `_ARQUIVO/`.
3. **Adaptacao de procedimento que diverge do universal.** Mitiga: UNIVERSAL continua fonte; adaptacao documentada no commit.
4. **Detector sobre vault sujo = ruido.** Mitiga: F7 so apos F1-F6.

## Arranque

Proxima sessao dedicada (Opus): iniciar por **F0 (diagnostico skills ~30min) em paralelo a F1 (auditoria)**.
Nenhuma fase destrutiva sem veredito do Diretor.

---

## ENCERRAMENTO DA OPERACAO (2026-06-17)

**Operacao Vault Soberano CONCLUIDA.** As 7 fases foram executadas com veredito por fase (consultor-first):
F0-F5 OK, F6 verificado (zero segredo no dry-run; push real defere ao Gate 10/session_close, estrito C1),
F7 OK -- **Detector de Deriva ATIVO**.

### F7 -- o que foi feito (achado central: o Detector ja existia, disperso)
F7 nao construiu motor de deteccao novo. ATIVOU e cabeou os gates deterministicos ja existentes:
- **`scripts/detector_deriva.ps1`** (b-min): maestro fino que orquestra 5 motores ja presentes
  (frescor, consistencia textual, violacao canonica TIPO 1, drift de comandos de ativacao, inventario do vault),
  mapeia exit codes heterogeneos para semaforo comum (0 VERDE / 1 AMARELO / 2 VERMELHO), read-only, LOCAL-FIRST.
- **`session_start.ps1`** (c-1): briefing read-only na abertura (`-Leve -Quiet`), fault-tolerant, so exibe se exit >= 1.
- **CLAUDE.md**: Detector registrado como ATOR COADJUVANTE (nao 6o membro) -- detecta, nunca corrige (P-124).
- **Persona `CONSELHO/SYSTEM_PROMPT_DETECTOR_DERIVA.md` v1.4** + skill `.claude/skills/doc-drift-audit.md`: camada semantica.

### Prova-de-vida (Bloco F) -- o Detector pegou 4 derivas REAIS na 1a varredura
Registradas em `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PENDING_REVIEW.md` (Detector detecta, Diretor decide):
- **F7-01** (MEDIA): Timelines 16/17 defasadas (sem Loop 34/35).
- **F7-02** (MEDIA): persona sec 7 referencia `PENTALATERAL_UNIVERSAL/MAPA_VAULT.md` inexistente (so existe em CONSELHO/).
- **F7-03** (MEDIA): zona-cinza P-059 -- 3 docs do Intelligence Hub cross-referenciam clientes por nome (decisao do Diretor).
- **F7-04** (BAIXA): sem read-guard de credenciais em hook (defesa "por persona", nao mecanica).

### Decisao diferida (Bloco E)
Obsidian permanece **camada VISUAL opcional**, nunca runtime do Detector. Orientacao de uso entregue ao Diretor.

Esta operacao **fecha o item guarda-chuva #11** do PENDENTES (`operacao-vault-soberano-arranque`).
