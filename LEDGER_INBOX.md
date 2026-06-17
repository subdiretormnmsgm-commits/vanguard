# LEDGER_INBOX — Buffer de Princípios e Falhas Pendentes
> Arquivo: `LEDGER_INBOX.md` · Raiz do projeto
> Função: buffer oficial para princípios e erros que aguardam autorização P-098 para entrar no INTELLIGENCE_LEDGER.md
> Regra: ao detectar falha ou princípio na sessão → registrar aqui IMEDIATAMENTE, mesmo sem flag P-098.
> Quando autorizado: Músculo move para INTELLIGENCE_LEDGER.md (raiz canônica — NUNCA o 06_, ver P-171) com `[RESOLVE: LEDGER-INBOX-XXX]`.
> Criado: 2026-06-10 · Loop 32 · ATO 6

---

## STATUS: 3 ENTRADAS PENDENTES (2026-06-15)

### FALHA-PROCESSO-2026-06-15-A — LOOP LONGO DEMAIS + CÓDIGOS ERRADOS (inadmissível em escala 20 projetos)
- **Sintoma:** Loop 34 durou ~5h30 (22h30 → 04h00). Muitas falhas e scripts errados no meio do caminho. Diretor: "Com 20 projetos não se consegue. Sou humano."
- **Causa raiz (3):** (1) deliberação feita no chat e perdida na compactação → retrabalho de reconstrução; (2) edição de arquivos P-098 sem flag preparada → ciclos de bloqueio/retry; (3) eixo do loop reorganizado por 1 sócio (P-172) → síntese teve de ser refeita.
- **Solução proposta (P-146 — construir, não só documentar):** (a) gate `gate_loop_objetivo` já existe — adicionar `gate_fechamento_resultado.ps1` que compara `resultados_esperados` × entregue antes de fechar; (b) deliberação de 7 pontos gravada no arquivo ANTES do veredito (P-170) — já em vigor; (c) pré-criar `.musculo_autorizacao.flag` quando o Diretor sinaliza formalização P-098, eliminando o ciclo bloqueio/retry; (d) BUDGET DE TEMPO POR LOOP: meta ≤90min; estourou → parar e fatiar em sessões. → mover para LEDGER como **P-173**.
- **Palco:** próxima sessão (Diretor: "isso será palco de outra sessão" p/ docs desatualizados; a ferramenta de tempo entra junto).

### FALHA-PROCESSO-2026-06-15-B — LOOP RECICLA O BAU EM VEZ DE ENTREGAR O DELTA DA INTENÇÃO (raiz)
- **Sintoma:** a intenção do Loop 34 pedia CONSTRUIR o que capacita o papel dos 3 novos sócios. O loop entregou pesquisa de mercado (ECD/nicho/post) — trabalho HABITUAL (Cowork/Intel Hub) que já se faz. Nenhum sócio propôs UMA atividade agendável para os novos atores. Diretor: "O que foi construído para contribuir para o papel dos sócios, eu pedi na intenção... focamos em pesquisa de mercado que já se faz. Ninguém falou de atividade que poderia ser agendada. Não dá." (2026-06-15)
- **Causa raiz:** (1) não há gate que verifique INTENÇÃO→ENTREGA — `resultados_esperados` existe no LOOP_STATE mas ninguém confere no fim; (2) o PASSO3/5/7 não EXIGE que cada sócio proponha atividade agendável para um ator novo; (3) o loop não distingue DELTA (o que a intenção pede) de BAU (pesquisa de mercado rotineira) — recicla o fácil; (4) "formalizar ator" não tem definição de pronto (ferramenta + atividade agendada + integração).
- **Mecanismo anti-recorrência (4 builds — P-146):**
  - **P-174 GATE INTENÇÃO→ENTREGA** — `resultados_esperados` no LOOP_STATE vira TIPADO; `gate_fechamento_resultado.ps1` lê cada Rn e exige evidência em disco antes de fechar (exit 1 se faltar). Loop não fecha com R não entregue.
  - **P-175 DEFINIÇÃO DE PRONTO DE ATOR NOVO** — formalizar ator = 5 itens obrigatórios: (a) system prompt reconciliado com paths reais; (b) skill operacional; (c) CLAUDE.md + DEPENDENCY_MAP; (d) **atividade agendada** (cron/n8n/gate: o quê, gatilho, frequência); (e) canal de devolução de sinal (output→PENDING_REVIEW). Sem os 5 = ator nominal, não funcional.
  - **P-176 SÓCIO OBRIGADO A PROPOR ATIVIDADE AGENDÁVEL** — quando o loop trata ator/capacidade nova, cada PASSO (3/5/7) exige de cada sócio ≥1 atividade agendável (o quê + gatilho + frequência). Ideia sobre ator sem atividade agendada = incompleta.
  - **P-177 LOOP ENTREGA O DELTA, NÃO O BAU** — abertura do loop lista o que JÁ é feito rotineiramente (Cowork/Intel Hub/pesquisa de mercado) e marca como FORA DO ESCOPO, salvo se a intenção pedir explicitamente. O loop produz o delta pedido pela intenção.
- **Palco:** sessão dedicada de PROCESSO (construir os 4 gates com cabeça fresca — não às 04h, para não repetir o erro de código errado). Desenho pronto neste INBOX.

### FALHA-PROCESSO-2026-06-15-C — CODE-REVIEW E DOUTRINA, NAO EXECUCAO (origem dos "muitos erros de codigo ao longo dos loops")
- **Sintoma:** Diretor (2026-06-15): "Percebi muitos erros de codigos ao longo dos loops." Code-review existe so como CHECKLIST/PRINCIPIO em 3 lugares (vanguard-protocolo.md secao "Code Review Antes do Commit"; MEMORANDO_QUADRILATERAL_CLIENTE.txt "Code review interno"; memory feedback_code_review) mas NUNCA e executado: nao ha passo no loop Pentalateral, nao ha task no Cowork, nenhum hook/gate dispara. O unico parente que roda e validate_scripts.ps1 (P-060) = so sintaxe/encoding de .ps1, nao revisa logica/HTML/JS.
- **Causa raiz:** code-review nasceu para fechamento de versao de SOFTWARE DE CLIENTE (Vanguard V1..V16). O Pentalateral migrou para deliberacao + automacao (.ps1/.json/.html) e o code-review nao acompanhou → virou doutrina sem ponto de execucao. Liga direto a FALHA-PROCESSO-2026-06-15-A (mesma raiz: scripts errados no meio do loop).
- **Mecanismo anti-recorrencia (P-146 — construir, nao so documentar):**
  - **P-178 CODE-REVIEW EXECUTADO, NAO SO DOUTRINADO** [CONSTRUIDO 2026-06-16] — `scripts/gate_code_review.ps1` (3 camadas wired: session_start `-List`/`-Report` na abertura · pre-commit R-05 `-Verify` bloqueante · session_close GATE 6E enforcement). Bug corrigido na revisao inline: `-List`/`-Report` comparavam so presenca da chave; agora `Get-WorktreeSha` compara hash da arvore de trabalho -> codigo revisado e re-modificado volta a contar como pendente (P-178). Bypass de emergencia: env `PENTALATERAL_AUTORIZO`. Testado: parse OK, ASCII puro, -List re-detecta arquivo re-modificado. Build original:
    (a) detecta arquivos de CODIGO modificados na sessao via `git diff --name-only` filtrando extensoes .ps1/.psm1/.js/.mjs/.html/.py + .json de infra/config — NUNCA .md de conteudo, NUNCA dados de cliente (P-059);
    (b) se >=1 arquivo de codigo modificado E nao houver marcador `.code_review_done.flag` (com hash dos arquivos) → exit 1 + lista os arquivos: "N arquivos de codigo sem code-review. Invocar skill requesting-code-review antes do commit.";
    (c) escopo restrito aos MODIFICADOS da sessao — nao o repo inteiro (/code-review ultra fica reservado a fechamento de versao de software de cliente);
    (d) o .ps1 NAO invoca a skill (skill e do Claude/Musculo) — o gate DETECTA + BLOQUEIA + LISTA; o Musculo EXECUTA a skill superpowers `requesting-code-review` nos arquivos listados, corrige inline, grava o flag → gate libera (exit 0).
- **ENCAIXE (1) — ONDE EXECUTAR (APROVADO pelo Diretor 2026-06-15 "sigo a sua sugestao" = PRIMARIO + ENFORCEMENT):**
  - **PRIMARIO (recomendado): pos-build, antes do veredito/commit, DENTRO do loop** — Musculo roda `gate_code_review.ps1` ao terminar qualquer fatia que tocou codigo. Erro corrigido aqui e o mais barato (antes de cascatear). Maior ganho de qualidade.
  - **ENFORCEMENT (rede de seguranca): novo Gate no `session_close.ps1`** — nada com codigo modificado fecha o dia sem review. Chokepoint confiavel.
  - **RESERVADO: `/code-review ultra`** — so para fechamento de versao de software de cliente real (repo/branch inteiro), como a memoria original previa. Nao para cada loop.
- **Palco:** build entra como item [musculo] no PENDENTES (P-146). Sessao dedicada de PROCESSO (junto com os gates P-173..P-177 — cabeca fresca, nao as 04h).

### INTENCAO-OBSIDIAN-2026-06-15 — captura pendente
- Diretor declarou intenção sobre Obsidian "desde o começo"; o Músculo NÃO capturou/registrou → falha de retenção (memory `project_obsidian_intencao`). Escopo a confirmar com o Diretor (drift detection? gestão de docs? base de conhecimento?). Arquivos de referência estão em pasta exclusiva do Diretor (proibida) — não ler; aguardar 1 frase de escopo.

---

## STATUS ANTERIOR: 0 ENTRADAS PENDENTES — INBOX limpo (2026-06-15, antes do lote acima)

---

## [MOVIDOS PARA INTELLIGENCE_LEDGER.md (raiz canônica) — 2026-06-15]

> Autorização do Diretor: "AUTORIZO SOBRESCREVER INTELLIGENCE_LEDGER.md" (2026-06-15).
> Alvo correto = raiz `./INTELLIGENCE_LEDGER.md` (não o `06_`, conforme P-171 criado nesta mesma sessão).

- **P-167** → PASSO 7 auto-invoca skill embaixador-passo7-[cliente]-v1 · Loop 34 · [RESOLVE: LEDGER-INBOX-P167]
- **P-168** → Gate de frescor valida o sync, não a idade do arquivo (datetime) · Loop 34 · [RESOLVE: LEDGER-INBOX-P168]
- **P-169** → Gatilhos obrigatórios de rclone sync (G1..G4) · Loop 34 · [RESOLVE: LEDGER-INBOX-P169]
- **P-170** → Deliberação de 7 pontos por ideia gravada no arquivo antes do veredito · Loop 34 · [RESOLVE: LEDGER-INBOX-P170]
- **P-171** → Canonicidade do LEDGER (raiz = fonte; 06_/04_ = cópias; sem prefixo em CLAUDE_PROJECT = órfão) · Loop 34 · criado direto na análise da falha
- **P-172** → Síntese P-037 medida contra o objetivo declarado do Loop (P-160), nunca reorganizada por 1 sócio · Loop 34 · criado direto na análise da falha

> NOTA: P-157 e P-158 estavam listados como pendentes neste INBOX mas já constavam no LEDGER canônico (linhas 2590 e 2601) — eram resíduo obsoleto. Removidos do buffer sem reinserir (já estavam lá).

---

## [MOVIDOS PARA INTELLIGENCE_LEDGER.md — 2026-06-13]

- **P-154** → adicionado após P-153 · Loop 33 · [RESOLVE: LEDGER-INBOX-P154]
- **P-155** → adicionado após P-154 · Loop 33 · [RESOLVE: LEDGER-INBOX-P155]
- **P-156** → adicionado após P-155 · Loop 33 · [RESOLVE: LEDGER-INBOX-P156]

---

## [MOVIDOS PARA INTELLIGENCE_LEDGER.md — 2026-06-12]

- **P-149** → adicionado após FALHA-K · [RESOLVE: LEDGER-INBOX-P149]
- **P-150** → adicionado após P-149 · [RESOLVE: LEDGER-INBOX-P150]

Todos os itens do lote Loop 31+32 foram movidos para INTELLIGENCE_LEDGER.md:
- **P-148** → adicionado após P-141
- **P-130-ADDENDUM** → inserido no P-130 existente
- **FALHA-H** (deliberação sem citar texto) → adicionada
- **FALHA-I** (sed sem container) → adicionada
- **FALHA-J** (Cron W-1 1x/dia) → adicionada
- **FALHA-K** (meta-falha: falhas não entraram no LEDGER) → adicionada
- **FALHA-A..G** (Loop 31) → já estavam no LEDGER — sem duplicação

Commit: [RESOLVE: ATO 5] [RESOLVE: LEDGER-INBOX-FALHAS]

---

## COMO USAR ESTE ARQUIVO

1. **Adicionar:** ao detectar falha ou novo princípio → adicionar seção aqui imediatamente
2. **Autorizar:** quando Diretor disser "AUTORIZO SOBRESCREVER INTELLIGENCE_LEDGER.md" → Músculo move os itens para a RAIZ canônica (P-171), nunca o 06_
3. **Commit:** `[RESOLVE: LEDGER-INBOX-XXX]` fecha cada item
4. **Limpar:** após mover para LEDGER, remover a seção do INBOX
5. **Nunca:** deixar item no INBOX por mais de 3 loops sem mover

---

*LEDGER_INBOX v1.2 · Atualizado 2026-06-15 · Loop 34 · lote P-167..P-172 movido*
