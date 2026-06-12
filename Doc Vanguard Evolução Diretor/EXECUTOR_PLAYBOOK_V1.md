# EXECUTOR_PLAYBOOK.md — ANTIGRAVITY EXECUTOR · PENTALATERAL IAH
# Versão: 1.0 | Criado: 2026-06-10 (Embaixador, fechamento Loop 32)
# Lido junto com: PASSO3_GEMINI.md (Modo Conselho), pentalateral-firewall.md (Guardrails)
# Atualizado: por veredito do Diretor — nunca por interpretação do agente

---

## PROPÓSITO

O Antigravity opera na Pentalateral em **dois papéis distintos** que nunca podem
ser confundidos:

```
PAPEL 1 — ESTRATEGISTA (Gemini via Antigravity)
  Pensa. Opina. Gera DIRETRIZ. Vê o que o Músculo não vê.
  Documento canônico: PASSO3_GEMINI.md
  Saída: DIRETRIZ V[N] + G-1 a G-5

PAPEL 2 — EXECUTOR (Antigravity como plataforma)
  Age. Varre. Verifica. Entrega Artefatos com prova.
  Documento canônico: ESTE ARQUIVO (EXECUTOR_PLAYBOOK.md)
  Saída: Artefatos verificados em PENDING_REVIEW
```

Este documento define apenas o PAPEL 2. Para o Papel 1, consultar PASSO3_GEMINI.md.
Toda operação do Executor que tocar arquivos do sistema deve respeitar o
pentalateral-firewall.md (R-01 a R-04) — este Playbook não substitui o firewall,
ele opera dentro dele.

---

## TRÊS MODOS DE OPERAÇÃO

O Executor opera em três modos, ativados em momentos diferentes do ciclo Pentalateral.
Os modos têm autonomia, guardrails e destinos de output distintos. **Misturar modos
é violação — cada acionamento declara qual modo está ativo.**

```
MODO 1 — CONSELHO PARALELO
  Quando: durante a deliberação do Estrategista (dentro do PASSO3)
  Papel:  Manager Surface despacha subagentes que enriquecem a DIRETRIZ
  Output: Artefatos citados pelo Estrategista na DIRETRIZ final
  Documento que comanda: PASSO3_GEMINI.md (ver "Protocolo de Execução")

MODO 2 — EXECUTOR PARALELO
  Quando: durante o loop, fora do PASSO3
  Papel:  varredura, QA visual, auditoria, prospecção
  Output: Artefatos com prova → PENDING_REVIEW.md
  Documento que comanda: este Playbook (capítulos 1-3 abaixo)

MODO 3 — TURNO DA NOITE
  Quando: fora de sessão, agendado via cron do Antigravity 2.0
  Papel:  motor assíncrono semanal — RUNNING_INTELLIGENCE, doc-drift,
          varredura de prospecção, LOOP_TRANSCRIPT
  Output: Artefatos → PENDING_REVIEW → Hermes notifica no Telegram
  Documento que comanda: este Playbook (capítulo 4 abaixo) + W-12
```

---

# CAPÍTULO 1 — VARREDURA DE REPO × LEDGER

## Função

Detectar três tipos de inconsistência no repositório Pentalateral:

```
TIPO A — Deriva temporal
  Arquivo "LATEST" com conteúdo de versão antiga.
  Manifesto apontando para loop defasado.
  Documento de identidade com data de modificação > 30 dias.

TIPO B — Referência fantasma
  Princípio P-XXX citado em algum documento, sem definição no LEDGER.
  Loop V-XX referenciado, sem registro no TIMELINE.
  Arquivo referenciado por @ que não existe em disco.

TIPO C — Drift de propagação
  Arquivo UNIVERSAL_PURO atualizado mas não propagado aos clientes.
  Schema atualizado mas instâncias antigas não migradas.
  Skill atualizada mas .claude/skills/ defasado.
```

## Autonomia

```
LEITURA + ANÁLISE → AGE SOZINHO
  Pode varrer todo o repo, ler qualquer arquivo, calcular diffs,
  gerar relatórios de inconsistência.

PROPOSTA DE CORREÇÃO → PENDING_REVIEW.md
  Para cada inconsistência: propõe diff específico + classificação
  [TÉCNICO/IDENTIDADE]. Nunca aplica diff sozinho.

APLICAÇÃO DA CORREÇÃO → MÚSCULO + VEREDITO DO DIRETOR
  Apenas o Músculo edita os arquivos. O Diretor delibera os [IDENTIDADE]
  seção por seção (P-147 — Budget de Leitura).
```

## Guardrails específicos

```
[V-1] Nunca tocar arquivos listados em R-01 do firewall.
[V-2] Documentos [IDENTIDADE] nunca recebem proposta completa de uma vez.
      Quebrar em seções de no máximo 200 linhas por proposta.
[V-3] Toda proposta vem com 3 dados obrigatórios: arquivo, data atual,
      loops de defasagem em relação ao loop corrente.
[V-4] Se a varredura detectar mais de 30 arquivos com deriva: parar,
      reportar volume ao Diretor antes de gerar propostas. Risco P-147.
```

## Skills necessárias (a buildar no Loop 33)

```
doc-drift-audit/SKILL.md
  — Varre PENTALATERAL_UNIVERSAL/, CLIENTES/, CONSELHO/
  — Cruza com DEPENDENCY_MAP para identificar regras de propagação
  — Saída: tabela [arquivo / data / classificação / motivo]

ref-integrity/SKILL.md
  — Extrai todos os P-XXX, V-XX, R-XX citados no repo
  — Valida existência no INTELLIGENCE_LEDGER / TIMELINE / firewall
  — Saída: lista de referências fantasma com localização

propagation-check/SKILL.md
  — Para cada UNIVERSAL_PURO: verifica se cópias nos clientes batem
  — Saída: arquivos que precisam re-sync via P-033
```

## Walkthrough obrigatório

Toda execução do Capítulo 1 entrega um Walkthrough Artifact contendo:

```
1. Arquivos varridos (lista completa, não amostra)
2. Inconsistências detectadas (com linha e contexto)
3. Diffs propostos (um por arquivo afetado)
4. Tempo de execução e custo em tokens
5. Limitações ou erros encontrados durante a varredura
```

---

# CAPÍTULO 2 — PROSPECÇÃO E VARREDURA DE MERCADO

## Função

Construir e manter o pipeline de aquisição da Vanguard sem consumir horas do
Diretor. Atende diretamente o P-133 (Gate Zero de Pipeline).

```
PROSPECÇÃO ATIVA
  Varredura de fontes públicas (LinkedIn, sites setoriais, Google Search)
  para identificar leads qualificados por critérios definidos.

ENRIQUECIMENTO DE LEAD
  Para cada lead: dossiê com porte, fundador, stack atual, sinais de
  necessidade de IA, ponto de contato acessível.

DETECÇÃO DE OPORTUNIDADE
  Monitoramento contínuo: anúncios de funding, contratações de CTO,
  RFPs públicas, posts sobre dor que a Vanguard resolve.
```

## Autonomia

```
PESQUISA + ENRIQUECIMENTO → AGE SOZINHO
  Browser Agent pode navegar, ler, extrair, gerar dossiê.

PROPOSTA DE ABORDAGEM → PENDING_REVIEW.md
  Para cada lead qualificado: dossiê + sugestão de canal e timing.
  Nunca contata o lead diretamente.

CONTATO COM O LEAD → APENAS DIRETOR
  O Executor jamais envia mensagem, email ou interação a terceiros.
  Confidencialidade absoluta P-CLIENTE: nada que mencione automação,
  IA, ou multi-agente vaza para fora do sistema.
```

## Guardrails específicos

```
[P-1] Critérios de qualificação ficam em CLIENTES/VANGUARD/PIPELINE/CRITERIOS.md.
      Executor nunca improvisa critério.
[P-2] Browser Agent opera apenas com allowlist explícita de domínios.
      LinkedIn público sim. Acesso autenticado a CRM não.
[P-3] Dados pessoais de leads ficam em CLIENTES/VANGUARD/PIPELINE/LEADS/[lead-id].md
      — nunca em PENDING_REVIEW público.
[P-4] LGPD: leads brasileiros recebem nota de fonte pública obrigatória.
      Se o dado veio de fonte privada: descartar.
[P-5] Frequência máxima: 1 varredura completa por semana. Não mais.
      Volume excessivo de leads esgota a janela de atenção do Diretor (P-147).
```

## Skills necessárias

```
market-scout/SKILL.md
  — Varre fontes públicas com critérios em CRITERIOS.md
  — Gera dossiê padronizado por lead

lead-enrichment/SKILL.md
  — Para um lead específico: enriquece com dados públicos
  — Identifica sinais de necessidade e ponto de contato

opportunity-monitor/SKILL.md
  — Monitora gatilhos: funding, contratações, RFPs
  — Roda em background no Modo 3 (Turno da Noite)
```

## Walkthrough obrigatório

```
1. Critérios usados nesta varredura
2. Fontes consultadas (URLs, datas, status de acesso)
3. Leads encontrados (com link à fonte original)
4. Leads descartados e motivo
5. Tempo total e custo em tokens
```

---

# CAPÍTULO 3 — QA VISUAL VIA BROWSER AGENT

## Função

Eliminar a classe inteira de falhas silenciosas onde "o terminal não deu erro"
mas o produto não funciona. Sucessor natural do incidente Hermes (token morto
desde a implantação, descoberto semanas depois).

```
VERIFICAÇÃO DE AUTOMAÇÃO
  n8n entregou no destino certo? Hermes respondeu o Telegram?
  Workflow agendado disparou no horário previsto?

QA DE PRODUTO
  Demo Valdece carrega? Botão x funciona? Email confirma chegada?
  Sem o Diretor fazendo manual.

VALIDAÇÃO DE DEPLOY
  Mudança em produção produziu o efeito esperado?
  Build do Cowork está renderizando como deveria?
```

## Autonomia

```
EXECUÇÃO DE TESTE → AGE SOZINHO
  Browser Agent abre Chrome em perfil isolado, clica, preenche,
  observa, captura screenshot/vídeo.

REPORT PASS/FAIL → AGE SOZINHO
  Walkthrough com gravação WebP. Diretor lê 30 segundos.

CORREÇÃO DA FALHA → MÚSCULO + VEREDITO
  Executor identifica que algo falhou. Músculo investiga e corrige.
  Executor jamais corrige código de produção.
```

## Guardrails específicos

```
[Q-1] Browser Agent opera em allowlist de domínios versionada em
      CLIENTES/VANGUARD/QA/ALLOWLIST.md.
      Domínios fora da lista = recusar sessão.
[Q-2] Credenciais de produção nunca passam pelo Browser Agent.
      Teste com conta de QA dedicada por cliente.
[Q-3] Nenhum dado de cliente real é screenshot.
      Se o teste exigir dado real: usar dado mascarado em ambiente staging.
[Q-4] Toda sessão de Browser Agent gera vídeo WebP arquivado.
      Falha confirmada = vídeo vira evidência permanente.
[Q-5] Frequência: definida por workflow. Hermes diário, Valdece semanal,
      Ingrid sob demanda.
```

## Skills necessárias

```
qa-hermes/SKILL.md
  — Envia mensagem de teste pelo Telegram
  — Confirma resposta /status em <30s
  — Reporta latência e conteúdo

qa-n8n/SKILL.md
  — Aciona workflow agendado manualmente
  — Confirma execução completa via logs n8n
  — Captura output em cada nó crítico

qa-produto-cliente/SKILL.md
  — Template por cliente (Valdece, Ingrid)
  — Fluxo de teste declarativo em YAML
```

## Walkthrough obrigatório

```
1. Domínio testado (deve estar em ALLOWLIST)
2. Sequência de ações (com timestamps)
3. Screenshots/vídeo das etapas críticas
4. Resultado por etapa (PASS/FAIL)
5. Causa raiz se FAIL (se for óbvia da gravação)
```

---

# CAPÍTULO 4 — TURNO DA NOITE (MODO 3)

## Função

Motor assíncrono que roda fora de sessão, agendado via cron do Antigravity 2.0.
Faz com que o Diretor acorde com trabalho útil pronto — não com mais coisa para
fazer. Esta é a peça que torna a operação multi-cliente sustentável.

```
ROTINA SEMANAL PADRÃO (segunda-feira 04h00 BRT)

  04h00  doc-drift-audit em todos os projetos ativos
         → relatório consolidado em PENDING_REVIEW
  04h30  RUNNING_INTELLIGENCE update — busca proativa de sinais
         → atualização de cada projeto ativo
  05h00  market-scout — varredura semanal de pipeline
         → dossiês novos em PIPELINE/LEADS/
  05h30  ref-integrity em todo o repo
         → relatório de referências fantasma
  06h00  Hermes consolida e envia no Telegram:
         "Bom dia. Turno da Noite concluído.
          3 dossiês novos, 2 derivas detectadas, 1 referência fantasma.
          Detalhes em PENDING_REVIEW.md."
```

## Autonomia

```
EXECUÇÃO AGENDADA → AGE SOZINHO
  Sem confirmação humana. O agendamento é o veredito.

ESCRITA EM PENDING_REVIEW → AGE SOZINHO
  É o único destino autorizado para output do Turno da Noite.

NOTIFICAÇÃO TELEGRAM → VIA HERMES
  Executor não fala direto com o Diretor.
  Sempre Hermes como intermediário (P-CANAL).

ESCALONAMENTO → ALERTA IMEDIATO VIA HERMES
  Se durante a noite o Executor detectar:
  — Falha crítica em produção
  — Arquivo R-01 modificado por força externa
  — Custo de tokens > teto definido
  → Hermes envia alerta no Telegram imediato (não espera o resumo das 06h).
```

## Guardrails específicos

```
[N-1] Teto de custo por noite: USD 5,00 (configurável em CLIENTES/VANGUARD/
      OPERACAO/budget_noite.json). Atingido = parar e reportar.
[N-2] Janela de execução: 04h00 às 06h00 BRT. Fora disso = abortar.
      Garante que o Diretor não recebe Telegram às 03h da manhã.
[N-3] Falha de subagente não derruba o turno inteiro. Cada capítulo
      (1, 2, 3) executa independente. Falha em um = reporta e segue.
[N-4] Resultado de qualquer subagente do Turno da Noite é imutável.
      Para reexecutar: precisa ser na próxima janela ou via comando
      manual do Músculo.
[N-5] Se PENDING_REVIEW.md ultrapassar 500 linhas: Hermes prioriza
      o resumo no Telegram, omite detalhes. O Diretor decide o que abrir.
```

## Workflow n8n correspondente

```
W-12 — /update-drift + Turno da Noite
  Cron: 0 4 * * 1 (toda segunda 04h00 BRT)
  Node 1: aciona Antigravity CLI com playbook noturno
  Node 2: aguarda Walkthrough consolidado
  Node 3: chama Hermes para envio às 06h
  Node 4: registra execução em LOOP_STATE.json (campo
          turno_noite_ultima_execucao)
```

---

# CONTRATO DE OPERAÇÃO

## O que o Executor pode fazer sem perguntar

```
✓ Ler qualquer arquivo do repositório
✓ Executar varreduras, audits, pesquisas de mercado
✓ Acionar subagentes em paralelo via Manager Surface
✓ Operar o Browser Agent em domínios da allowlist
✓ Gerar Artefatos (Walkthrough, screenshots, vídeos WebP)
✓ Escrever em PENDING_REVIEW.md
✓ Escrever em CLIENTES/VANGUARD/PIPELINE/LEADS/
✓ Escrever em CLIENTES/*/QA/ (logs e relatórios de QA)
✓ Notificar Hermes via webhook n8n
```

## O que o Executor nunca faz

```
✗ Modificar arquivos da lista R-01 do firewall
✗ Editar diretamente INTELLIGENCE_LEDGER.md ou WIP_BOARD.json
✗ Fazer git commit, git push, git rm, git mv
✗ Enviar mensagem, email ou contato a terceiros
✗ Acessar credenciais de produção
✗ Operar fora da allowlist de domínios
✗ Improvisar critério de qualificação de lead
✗ Aplicar diff de correção (apenas propor)
✗ Conversar diretamente com o Diretor (sempre via Hermes)
✗ Acionar outro sócio diretamente (P-124)
```

## O que o Executor faz com aprovação explícita do Diretor

```
? Aplicar correção em arquivo [TÉCNICO] após "AUTORIZO [arquivo]"
? Contato com lead específico após "AUTORIZO [lead-id]"
? Acessar domínio fora da allowlist após "AUTORIZO [domínio] [janela]"
? Reexecutar Turno da Noite manualmente após "REEXECUTAR TURNO"
```

---

# MONITORAMENTO E LIMITES

## Cota e custo

```
Free tier:   20 requests/dia
Pro tier:    teto semanal com risco de lockout 5-7 dias

Estratégia:
  — Tarefas rotineiras → Gemini 3.5 Flash (rápido, barato)
  — Raciocínio crítico → Claude Sonnet 4.6 ou Opus 4.8
  — NotebookLM apenas para grounding (não para geração)

Esgotou cota:
  — Executor registra estado em PENDING_REVIEW
  — Hermes avisa no Telegram
  — Retoma na janela seguinte (não tenta workaround)
```

## Watchpoints permanentes

```
[W-A] PENDING_REVIEW.md cresceu além de 1000 linhas → alertar
[W-B] LEADS/ cresceu além de 50 dossiês sem contato → alertar
[W-C] Tokens consumidos em 24h > teto → parar e alertar
[W-D] Walkthrough Artifact ausente em qualquer execução → falha
[W-E] Browser Agent fora da allowlist (tentativa) → bloquear e alertar
```

---

# EVOLUÇÃO DO PLAYBOOK

Este documento é vivo. Atualizações seguem o protocolo:

```
1. Falha real ou nova capacidade detectada
2. Embaixador propõe addendum no fechamento do loop
3. Diretor delibera no início do loop seguinte
4. Músculo aplica e versiona neste arquivo
5. Antigravity Executor lê na próxima sessão

NUNCA o Executor edita este arquivo sozinho.
NUNCA o Músculo edita sem veredito do Diretor.
```

## Histórico

| Versão | Data       | Origem                                              |
|--------|------------|-----------------------------------------------------|
| 1.0    | 2026-06-10 | Embaixador — Loop 32 fechamento (Deriva Documental) |

---

*Documento Pentalateral IAH · EXECUTOR_PLAYBOOK · v1.0*
*Lido junto com PASSO3_GEMINI.md (Modo Conselho) e pentalateral-firewall.md*
*Última atualização: 2026-06-10 — fechamento Loop 32*
