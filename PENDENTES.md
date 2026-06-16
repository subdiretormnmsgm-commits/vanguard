# PENDENTES — Vanguard IAH
> Atualizado pelo Músculo em tempo real durante qualquer sessão.
> O briefing matinal lê este arquivo — tudo aqui aparece às 7h.
> Regra P-047: qualquer tarefa identificada como pendente → registrar aqui IMEDIATAMENTE.
> Feito? Marcar [x]. Músculo remove os [x] ao fechar sessão.

---

## ABERTURA DA PRÓXIMA SESSÃO — OBRIGATÓRIO

- [x] `2026-06-13` ~~**[MÚSCULO] AUDITORIA NOTEBOOKLM — preparar_notebooklm_projeto.ps1 -cliente VANGUARD** [musculo]~~
  ✅ Wipe & Sync concluido 2026-06-14. 23 fontes carregadas. P-161 registrado (auto-conversao .json→.txt implementada). [RESOLVE: auditoria-notebooklm-vanguard]
  Motivo: 4 arquivos ausentes nas FONTES após sessão Cowork 2026-06-13:
  - RUNBOOK_COWORK_ENGINE.md (novo)
  - COWORK_HANDOFF.md (novo)
  - PASSO_NICHE_MODELER.md (atualizado)
  - NICHE_INDEX.json v1.5 (atualizado)
  - 16_VANGUARD_TIMELINE.md (desatualizado na cópia FONTES)
  Executar antes de qualquer ciclo com o Auditor.

- [ ] `2026-06-15` **[MÚSCULO] P-166 — gemini_anchor_generator.ps1: injetar PAPEL + ARSENAL DE SKILLS no comando ao Antigravity** [musculo]
  Ferramenta anti-recorrência (P-146) da falha P-166. Adicionar mapa PAPEL→arsenal (P-163):
  ESTRATEGISTA = @concise-planning → @brainstorming → @architecture → @analyze-project → deliberação 7 pontos;
  EXECUTOR = @systematic-debugging, @bash-scripting, @git-pushing, @error-detective;
  COWORK CONDUCTOR = @bash-scripting, @error-detective.
  O comando gerado deve sempre conter: (1) "Sessão Antigravity: [PAPEL]", (2) arsenal exato na ordem, (3) nota de fronteira.
  Comando sem papel/arsenal = inválido. [RESOLVE: P-166]

- [ ] `2026-06-16` **[MÚSCULO] P-174 — gate em session_close.ps1: EMBAIXADOR_LOOP_V[N] obrigatório quando o Embaixador entregou no loop** [musculo]
  Ferramenta anti-recorrência (P-146) da falha P-174 (ideia de sócio que só existe no chat não existe — E-5/E-6 perdidos na compactação do Loop 35).
  Build no `session_close.ps1` (análogo ao Gate 6B/6C):
  (a) se há veredito com `E-X` no DECISOES/LOOP_STATE do loop e `CLIENTES/[CLIENTE]/HISTORICO/EMBAIXADOR_LOOP_V[N]_[CLIENTE].md` ausente OU mais antigo que o `DELIBERACAO_LOOP_V[N]` → exit 1 bloqueante;
  (b) checagem espelho em `render_painel.ps1` (gate P-037): arquivo do Embaixador deve existir antes de gerar DECISOES.json.
  Build na sessão dedicada de processo (junto com P-173..P-178, cabeça fresca). [RESOLVE: P-174]

- [ ] `2026-06-15` **[MÚSCULO] P-178 — gate_code_review.ps1: code-review EXECUTADO nos arquivos de código modificados na sessão** [musculo]
  Ferramenta anti-recorrência (P-146) da lacuna P-178 (LEDGER_INBOX FALHA-2026-06-15-C). Origem: Diretor percebeu muitos erros de código ao longo dos loops; code-review hoje é só checklist, nunca executado.
  Build `scripts/gate_code_review.ps1`:
  (a) `git diff --name-only` da sessão → filtrar .ps1/.psm1/.js/.mjs/.html/.py + .json de infra (NUNCA .md de conteúdo, NUNCA dados de cliente P-059);
  (b) ≥1 arquivo de código sem marcador `.code_review_done.flag` (com hash) → exit 1 + lista os arquivos;
  (c) escopo só os modificados da sessão — /code-review ultra fica reservado p/ fechamento de versão de software de cliente;
  (d) o .ps1 detecta+bloqueia+lista; o Músculo invoca a skill `requesting-code-review` nos arquivos, corrige inline, grava o flag → libera.
  ONDE EXECUTAR (APROVADO Diretor 2026-06-15 "sigo a sua sugestão"): PRIMÁRIO = pós-build dentro do loop (antes do veredito/commit) + ENFORCEMENT = novo Gate no session_close.ps1. RESERVADO = /code-review ultra só p/ fechamento de versão de software de cliente.
  Build na sessão dedicada de processo (junto com P-173..P-177, cabeça fresca). [RESOLVE: P-178]

- [x] `2026-06-16` ~~**[MÚSCULO] P-173 — WIRE do gate_yt_search.ps1 na abertura de loop + antes da síntese P-037**~~ [musculo]
  ✅ Wire concluído e testado nesta sessão. (a) ADVISORY em `gate_loop_objetivo.ps1` (abertura de loop — lembra, não bloqueia); (b) BLOQUEANTE em `render_painel.ps1` (antes da síntese P-037 — exit 2 sem yt-search <24h, com bypass `-forcar` p/ o Diretor). Ambos os caminhos VERDE/BLOQUEIO testados. validate_scripts sem erro crítico. [RESOLVE: P-173-wire]

---

## COWORK ENGINE — Inteligência de Mercado Vanguard

- [x] `2026-06-13` ~~**[MÚSCULO] LEITURA OBRIGATÓRIA — COWORK_HANDOFF.md ao iniciar sessão Cowork** [musculo]~~
  ✅ Lido + HANDOFF atualizado 2026-06-14: Fase 2 marcada concluida, gate_cowork_fase2.ps1 libera. [RESOLVE: cowork-handoff-leitura]

- [x] `2026-06-13` ~~**[MÚSCULO] FASE 2 COWORK — veredito 14 arquivos INBOX_COWORK via MCP Drive** [musculo]~~
  ✅ Veredito emitido 2026-06-14: 13 APROVADOS + 1 STANDBY (F5 v2 -- scheduler gap). COWORK_HANDOFF.md atualizado. [RESOLVE: fase2-cowork-veredito]

- [x] `2026-06-13` ~~**[MÚSCULO] P-159 — gate_cowork_fase2.ps1 — bloquear Fase 3 se Fase 2 pendente** [musculo]~~
  ✅ scripts/gate_cowork_fase2.ps1 criado e testado 2026-06-14. Saida: BLOQUEADO (exit 1) / liberado (exit 0). [RESOLVE: P-159]

- [x] `2026-06-13` ~~**[MÚSCULO] P-160 — gate_loop_objetivo.ps1 — bloquear Loop sem objetivo declarado** [musculo]~~
  ✅ scripts/gate_loop_objetivo.ps1 criado e testado 2026-06-14. Modo -registrar e -verificar funcionais. [RESOLVE: P-160]

- [x] `2026-06-14` ~~**[MÚSCULO] sync_inbox_pending_review.ps1 — gap F5 v2 (Embaixador nao notificava PENDING_REVIEW)** [musculo]~~
  ✅ Script criado 2026-06-14. Le manifesto CLIENTES/VANGUARD/INTEL/INBOX_COWORK_MANIFEST.json e registra novos arquivos em PENDING_REVIEW. Modo -Status (sem alterar) + modo -Arquivo direto. Testado. [RESOLVE: sync-inbox-pending-review]

- [x] `2026-06-14` ~~**[MÚSCULO] ARQUITETURA DRIVE-FIRST — Embaixador busca arquivos do gdrive:vanguard em vez de receber upload** [musculo]~~
  ✅ Entregue 2026-06-14: verify_gdrive_freshness.ps1 criado + 4 skills atualizadas (encerramento + passo7 VANGUARD/INGRID/VALDECE). Playwright agora envia apenas mensagem com paths do Drive. Embaixador busca via MCP. [RESOLVE: drive-first-embaixador]
  Decisão do Diretor (2026-06-14): eliminar upload Playwright de arquivos. Novo fluxo:
  1. Músculo atualiza docs localmente
  2. Gate 10 (rclone) sincroniza para gdrive:vanguard
  3. `scripts/verify_gdrive_freshness.ps1` — verifica frescor dos arquivos no Drive (timestamp local vs Drive) — gate bloqueante
  4. Playwright abre Claude Projects → envia mensagem no chat (SEM upload):
     - ENCERRAMENTO: template canônico (ENCERRAMENTO DE SESSÃO + ENTREGAS + FICOU NO AR + PRÓXIMA SESSÃO + pedido BLOCO 0 texto simples)
     - PASSO7 [cliente]: template padrão do PASSO7 daquele cliente
  Skills a atualizar: embaixador-encerramento-v1 · embaixador-passo7-vanguard-v1 · embaixador-passo7-ingrid-v1 · embaixador-passo7-valdece-v1
  Remover: bloco de exclusão de arquivos antigos + bloco browser_file_upload de todas as skills
  Custo estimado: 60-90 min · Gate: sessão dedicada.

- [ ] `2026-06-13` **[MÚSCULO] COWORK — sincronizar INTELLIGENCE_HUB para CLIENTES/VANGUARD/ via sync** [musculo]
  Veredito Diretor (2026-06-13): Opção C — manter em PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/ (fonte canônica) + espelhar para CLIENTES/VANGUARD/INTELLIGENCE_HUB/ via sync automático.
  Custo: sessão dedicada 4-6h · scripts afetados: sync_vanguard_docs.ps1, DEPENDENCY_MAP, preparar_notebooklm, gemini_anchor_generator, PENDING_REVIEW paths.
  Gate: executar em sessão dedicada — NÃO misturar com outro foco.
  CONTEXT: Ação Cowork Engine — não é Loop do Pentalateral.

---

## 🔴 ALERTAS CRÍTICOS — AÇÃO IMEDIATA DO DIRETOR

- [ ] `2026-06-13` **⚠️ [ALERTA NICHE] Eventos Fiscais / ECD 2026 — 17 DIAS** [diretor]
  Prazo: **30/06/2026 (30-06-2026 terça-feira)**
  Acao: Prospectar escritórios de contabilidade de médio porte via WhatsApp/LinkedIn esta semana
  Mensagem: "O prazo da ECD encerra em 30 de junho e a Receita automatizou as multas; sua contabilidade já opera com auditoria de Eventos Fiscais?"

- [ ] `2026-06-13` **[ALERTA NICHE] Conformidade AI Act — Deadline 02/08/2026** [diretor]
  Prazo: **02/08/2026 (02-08-2026 domingo)**
  Acao: Mapear e contatar 3 CTOs/Diretores Juridicos de fintechs brasileiras que operam na Europa
  Canal: LinkedIn

- [ ] `2026-06-13` **[ALERTA NICHE] Setor Eletrico / GD — ANEEL auditoria 60 dias** [diretor]
  Prazo: **05/08/2026 (05-08-2026 quarta-feira)**
  Acao: Identificar 2 integradoras GD com mais de 500 kW instalados para abordagem imediata
  Canal: WhatsApp / Indicacao

- [x] `2026-05-26` ~~**TOKEN SUPABASE EXPOSTO — RESOLVIDO:**~~
  ✅ Token revogado no dashboard Supabase — confirmado pelo Diretor em 2026-05-27. Arquivos redatados.

---

## PROJ-000 · Vanguard (VanguardV29 — Pentalateral Autônomo)

- [x] `2026-06-09` ~~**[MANDATO DIRETOR] Auditoria cirúrgica completa — TODOS os documentos desatualizados** [musculo]~~
  ✅ Auditoria concluída 2026-06-09. 7 DESATUALIZADO corrigidos: SKILL_PROTOCOLO v6.9 + MANUAL_DIRETOR v1.8 + CLAUDE.md V29 + WIP_BOARD Loop 29 + LEDGER P-127 + propagação sync_vanguard_docs.ps1 x2. Commit a3a7d99 (50 arquivos). DIRETRIZ V29 DESBLOQUEADA.

- [x] `2026-06-09` ~~**[MÚSCULO] P-127 → INTELLIGENCE_LEDGER** [musculo]~~
  ✅ P-127 inscrito: "Embaixador opera Estrategista de forma autônoma com grounding verificado — 1ª instância documentada." — 2026-06-09. [RESOLVE: P-127]

- [x] `2026-06-09` ~~**[DIRETOR] Veredito Mumuzinho — onboarding formal ou pasta excluída** [diretor]~~
  ✅ Diretor escolheu Opção A: PROJ-003 criado em DISCOVERY STANDBY. Estrutura + MEMORIA_EMBAIXADOR + WIP_BOARD atualizados. "Quadrilateral" → "Pentalateral IAH" corrigido (GATE 1 VERDE). Diretor aciona quando tiver canal para Dudu Félix. Commit 0d6bb1c.

- [x] `2026-06-09` **[DIRETOR] Arrastar 7 arquivos ao Embaixador + colar mensagem** [diretor]
  Arquivos: PAINEL_ATIVIDADES · CONTEXTO_SESSAO_DIRETOR · WIP_BOARD · LEDGER · PENDENTES · VANGUARD_TIMELINE · MEMORIA_EMBAIXADOR
  Mensagem já preparada: colar a mensagem copiada do terminal da sessão 2026-06-08.

- [x] `2026-06-09` ~~**[MÚSCULO] doc_freshness_checker.ps1 — detecção de deriva de documentos** [musculo]~~
  ✅ Script existe e funcional — criado no ATO 1 do Loop 33. Rastreia WIP_BOARD, LOOP_STATE, PENDENTES, MEMORIA_EMBAIXADOR, LEDGER_INBOX, 16_VANGUARD_TIMELINE (CLAUDE_PROJECT/), 17_VANGUARD_TIMELINE. Status "VEREDITO_CONFIRMADO" adicionado como válido 2026-06-12. [RESOLVE: doc-freshness]

- [x] `2026-06-09` ~~**[MÚSCULO+DIRETOR] Triar sugestões órfãs em `.claude/skills/Sugestões.md`** [musculo]~~
  ✅ Triagem concluída 2026-06-09: (a) code-review + (b) Instagram + (c) n8n vs Hermes migrados para CONSELHO/SUGESTOES_DIRETOR.md como itens 11-13 [PENDENTE]. (d) Antigravity nos sócios descartado (feito no Loop 29). Resíduo `.claude/skills/Sugestões.md` apagado.

- [x] `2026-06-09` ~~**[MÚSCULO] Reconciliar as 4 cópias da TIMELINE — definir fonte canônica única** [musculo]~~
  ✅ Fonte canônica definida em 2026-06-12: `CLIENTES/VANGUARD/CLAUDE_PROJECT/16_VANGUARD_TIMELINE.md`
  ✅ Propagado para 17_FONTES de VANGUARD + INGRID + VALDECE — hash C8304FF43028 verificado nos 3. Commit a2967e5.
  Dívida Loop 34: (a) criar sync automático 1→N `16_CP → 17_FONTES x3`; (b) adicionar ao DEPENDENCY_MAP; (c) incluir no doc_freshness_checker.

- [x] `2026-06-09` ~~**[MÚSCULO] DIRETRIZ V29 — ir ao Gemini com PASSO3_GEMINI.md** [musculo]~~
  ✅ FANTASMA QUITADO: DIRETRIZ V29 rodou via Antigravity (P-130) — commit b30c342 confirma Loop 29 fechado com síntese P-037 completa. Antigravity = canal do Estrategista, dispensou envio manual ao Gemini. Quitado na abertura 2026-06-09.

- [x] `2026-06-09` **[MÚSCULO] Fix sistêmico P-073 — sync_vanguard_docs.ps1 deve atualizar NOTEBOOKLM_BASE** [musculo]
  Problema recorrente: OPERACAO/ é atualizado → sync copia para CLIENTES/ mas NÃO para NOTEBOOKLM_BASE/.
  detect_canonical usa BASE como referência → falso positivo VERMELHO toda sessão.
  Fix: adicionar Passo 0 no sync_vanguard_docs.ps1 — OPERACAO → NOTEBOOKLM_BASE antes de OPERACAO → CLIENTES.
  Afeta: 01_SKILL_PROTOCOLO + 03_MANUAL_DIRETOR (detectado em 2026-06-09).
  Baixa prioridade mas recorrente — eliminar para sempre.

- [x] `2026-06-09` ~~**[MÚSCULO] Dívida arquitetural P-059 — páginas Notion globais vs. isolamento por cliente** [musculo]~~
  ✅ Opção A implementada 2026-06-14: notion_sync.ps1 prefixa [CLIENTE] por seção PROJ-N; notion_pendentes_pull.ps1 strip o prefixo antes do match — isolamento sem quebrar quitação. [RESOLVE: P-059-notion-isolamento]
  Contexto: o canal bidirecional Notion (P-128) usa páginas GLOBAIS (Pendentes/WIP/Ledger/Falhas/Sugestões), únicas para todo o sistema. O Pentalateral suporta até 20 projetos simultâneos (P-059) com isolamento de contexto por cliente.
  Risco: com >1 cliente em BUILD, o Diretor veria pendentes de vários clientes numa única página Notion — pode marcar [x] no item do cliente errado.
  Mitigação atual (suficiente com 1 cliente ativo): o pull casa por TEXTO EXATO da linha do PENDENTES.md (não por cliente) e só quita itens [diretor]; o #2 agora alerta órfãos (marcado no Notion sem casar no PENDENTES).
  Fix a decidir ANTES do 2º projeto simultâneo em BUILD: (a) prefixar `[CLIENTE]` em toda linha [diretor] sincronizada ao Notion, ou (b) páginas Notion por projeto.
  Origem: análise dos 4 desafios do canal Notion bidirecional, 2026-06-09.

- [x] `2026-06-09` ~~**[MÚSCULO] W-9 Track TRENDS — importar no EasyPanel n8n** [musculo]~~
  ✅ Importado e publicado via Playwright 2026-06-14. JSON reconstruído via Node.js (BOM + escape bug no original). 9 nós ativos: Cron→Gemini→GitHub→Telegram→PENDING_REVIEW. Status: Published. [RESOLVE: w9-trends]

- [x] `2026-06-09` ~~**[MÚSCULO] W-8 — deploy 4 workflows via API + reativar** [musculo]~~
  ✅ Músculo deployou via API (GET live→modify→PUT): W-1 (7 nodes) · W-3 (7 nodes) · W-5 (8 nodes) · W-8 (7 nodes). Todos reativados. Shadow mode real começou — silenced_signals_log receberá dados a partir de 2026-06-09. Fix crítico descoberto: settings com binaryMode/timeSavedMode/availableInMCP causa 400 no PUT — usar só executionOrder. [RESOLVE: W-8-deploy]

- [x] `2026-06-09` ~~**[DIRETOR] W-8 — adicionar 2 env vars no EasyPanel n8n** [diretor]~~
  ✅ SUPABASE_VANGUARD_URL + SUPABASE_VANGUARD_ANON_KEY confirmadas pelo Diretor 2026-06-09.
  W-8 shadow mode 100% operacional — pode gravar em silenced_signals_log.
  ALERTA RESIDUAL (sem impacto): SUPABASE_URL_INGRID aponta para Vanguard (não Ingrid) — variável órfã, não usada por nenhum workflow.

- [x] `2026-06-21` ~~**[DIRETOR] W-8 shadow mode — avaliar ativação plena** [diretor]~~
  ✅ Avaliado 2026-06-13 — Grau B permanente confirmado. 7 dias shadow mode limpos — dados consistentes em Supabase. Grau C adiado para Loop 35+ (após ≥30 dias log limpo). W-8 permanece em shadow mode registrando sinais. [RESOLVE: W8-grau-b]

- [x] `2026-06-06` ~~**V28 — gate_coerencia.ps1 (E-1 Haiku API) + skill_parser_gate integrado:**~~
  ✅ gate_coerencia.ps1 criado e integrado ao skill_parser_gate.ps1 — commit baf693a.

- [x] `2026-06-06` ~~**V28 — sync_guard -WhatIf — modo passivo real:**~~
  ✅ -WhatIf implementado: exibe o que faria sem escrever em disco. Detectado 2026-06-06.

- [x] `2026-06-06` ~~**V28 — N-4: sync forçado pós-veredito em executar_vereditos.ps1:**~~
  ✅ N-4 adicionado ao final de executar_vereditos.ps1 — P-033 automático após deliberação.

- [x] `2026-06-06` ~~**V28 — State Guard (state_guard.ps1) integrado ao session_start:**~~
  ✅ Criado + integrado ao .claude/hooks/session_start.ps1 — anomalias WIP_BOARD na abertura.

- [x] `2026-06-06` ~~**V28 — ping_hermes.ps1 — health check do Hermes Agent:**~~
  ✅ Criado: exit 0 (UP) / exit 1 (DOWN) / exit 2 (config ausente). -Silencioso + -Telegram.

- [x] `2026-06-06` ~~**V28 — MEMORIA_EMBAIXADOR_VANGUARD.md — perfil comportamental do Fundador:**~~
  ✅ Criado em CLIENTES/VANGUARD/CLAUDE_PROJECT/ — temperatura 9.2/10, hipóteses H-V1 a H-V4.

- [x] `2026-06-06` ~~**V28 — NARRATIVA_FUNDADOR.md — E-4 Vanguard como primeiro caso do produto:**~~
  ✅ Criado em CLIENTES/VANGUARD/ — argumento central, história, pitch, métricas.

- [x] `2026-06-06` ~~**V28 — W-8 Signal Classifier JSON (shadow mode) para n8n:**~~
  ✅ _n8n/w8_signal_classifier.json criado — 6 nós, classificação AUTO-RESOLVE/DELIBERAR-A/B/C.

- [x] `2026-06-06` ~~**V28 — Hermes Agent Docker config para EasyPanel:**~~
  ✅ hermes-agent/docker-compose.yml + hermes-agent/skills/pentalateral-graus-abc.md criados.
  ✅ `pentalateral-graus-abc.md` carregada no container Hermes (/opt/data/skills/) — confirmado pelo Diretor em 2026-06-07.

- [x] `2026-06-06` ~~**V28 — P-116 inscrito no INTELLIGENCE_LEDGER.md:**~~
  ✅ "O que dói é erro, não esforço — verificação antes de automação" inscrito. AUTORIZO concedido.

- [x] `2026-06-06` ~~**V28 — [DIRETOR] W-8: importar no EasyPanel n8n:**~~
  ✅ W-8 Signal Classifier importado, credenciais configuradas, ativado em shadow mode — 2026-06-07.

- [x] `2026-06-06` ~~**V28 — [DIRETOR] Hermes Agent: deploy EasyPanel:**~~
  ✅ Deploy concluído — projeto hermes/hermes-agent rodando. OpenRouter ✓ · Telegram ✓ · Gateway PID 251.
  Respondeu ao Diretor no Telegram em 2026-06-07. Config persistida em /opt/data/config.yaml.

- [x] `2026-06-06` ~~**V28 — [DIRETOR] Supabase: criar tabela silenced_signals_log:**~~
  ✅ Tabela criada com RLS — "Success. No rows returned" confirmado pelo Diretor 2026-06-07.

### 🔧 LOOP 31 — ERROS → FERRAMENTAS (P-146: documentar sem automatizar = repetir o erro)

- [x] `2026-06-10` ~~**[MÚSCULO] fix_bom_json.ps1 — eliminar BOM UTF-8 de todos os .json (3ª ocorrência)** [musculo]~~
  ✅ fix_bom_json.ps1 existia; adicionado auto-commit + integração validate_scripts.ps1 (BOM check em .json).
  14 arquivos corrigidos (WIP_BOARD.json x4 + knowledge_graph.json + _n8n + settings). Commit 690d0eb automático. [RESOLVE: bom-json]

- [x] `2026-06-10` ~~**[MÚSCULO] update_memoria_embaixador.ps1 — atualização event-driven (P-145)** [musculo]~~
  ✅ scripts/update_memoria_embaixador.ps1 criado 2026-06-13: -Passo 5|7, extrai AUDITOR_LOOP/SECAO_D, insere LOG DE CONTATOS, atualiza p032 gate em LOOP_STATE.json, cria flag do dia. Gate 6B em session_close.ps1 atualizado para verificar flag por cliente ativo (BUILD/RETAINER/HYPERCARE). [RESOLVE: update-memoria-embaixador]

- [x] `2026-06-10` **[MÚSCULO] [CHECKLIST DO MÚSCULO] bloqueante no PASSO5 template (P-143)** [musculo]
  Erro: Deep Research WEB não clicado antes do PASSO5 + relatorio nativo esquecido (Loop 31).
  P-143 registrado mas template não atualizado — registro sem ferramenta é decoração.
  O que construir:
  (a) Adicionar bloco ao `PENTALATERAL_UNIVERSAL/OPERACAO/PASSO5_NOTEBOOKLM_TEMPLATE.md`:
      ```
      ## [CHECKLIST DO MÚSCULO — BLOQUEANTE]
      - [ ] Deep Research WEB clicado via Playwright (ANTES de enviar PASSO5)
      - [ ] Aguardado até fontes aparecerem no caderno
      - [ ] PASSO5 enviado com todas as PARTES
      - [ ] notebooklm generate report --format briefing-doc executado
      - [ ] AUDITOR_LOOP_V[N]_[CLIENTE].md salvo em HISTORICO/
      - [ ] Skill [nome].md salva em .claude/skills/ e validada por skill_parser_gate
      - [ ] update_memoria_embaixador.ps1 rodado (PASSO5.5)
      ```
  (b) skill_parser_gate.ps1: verificar se PASSO5 tem [CHECKLIST DO MÚSCULO] — exit 1 se ausente
  (c) Propagar para PASSO3 e PASSO7 templates com checklists equivalentes
  Custo: ~1h. Protege contra DEF-M-6 por esquecimento estrutural.

- [x] `2026-06-10` ~~**[MÚSCULO] session_close Gate 6A — MEMORIA + relatorio obrigatórios ANTES de fechar** [musculo]~~
  ✅ Gate 6A implementado em 2026-06-12. Inserido entre Gate 6C e Gate 6B no script canônico.
  Lógica: se musculo.status=OK no LOOP_STATE + MEMORIA/relatorio ausentes → exit 1 BLOQUEANTE.
  Exceção: fase_atual=AGUARDA_EMBAIXADOR → alerta não-bloqueante.
  DryRun confirmou detecção: VANGUARD Loop 33 sem MEMORIA_V33 + relatorio_V33 → "BLOQUEARIA com exit 1".
  P-033 sync propagado. [RESOLVE: Gate-6A]

- [x] `2026-06-10` ~~**[MÚSCULO] Expandir doc_freshness_checker para CLAUDE_PROJECT/ (TIMELINE + MEMORIA_EMBAIXADOR)** [musculo]~~
  ✅ Verificado 2026-06-12: doc_freshness_checker.ps1 JÁ rastreia 16_VANGUARD_TIMELINE.md (CLAUDE_PROJECT/) e MEMORIA_EMBAIXADOR — itens [4] e [6] do script. Confirmado execução VERDE. [RESOLVE: doc-freshness-expand]

---

### 🔁 LOOP 33 — ABERTURA PENDENTE (2026-06-10)

> Loop 32 FECHADO (commit 4defaf6). Loop 33 abre nesta sessão ou na próxima.
> Missão: 7 docs CONSTITUICAO + ATOs 2-6 + Antigravity PASSO3 V33 + Gate Zero P-133.

- [x] `2026-06-11` ~~**[DIRETOR] B-1 gate — confirmar backup antes de abrir Antigravity** [diretor]~~
  ✅ Confirmado pelo Diretor em sessão 2026-06-11.

- [x] `2026-06-11` ~~**[DIRETOR] Wipe & Sync NotebookLM VANGUARD — Loop 32 encerrado** [diretor]~~
  ✅ Wipe: Diretor fez manualmente (Playwright falhou — bug "Excluir" documentado no RUNBOOK).
     Sync: Músculo carregou 19 fontes via Playwright browser_file_upload. Caderno d7dab0e1 ativo.

- [x] `2026-06-11` ~~**[DIRETOR] Autorizar SOBRESCREVER INTELLIGENCE_LEDGER.md — LEDGER_INBOX items** [diretor]~~
  ✅ Autorizado pelo Diretor em 2026-06-11. ATO 5 desbloqueado — Músculo move todos os itens para INTELLIGENCE_LEDGER.md.

- [x] `2026-06-11` ~~**[MÚSCULO] 7 docs CONSTITUICAO — seção a seção no Loop 33** [musculo]~~
  ✅ Auditoria dos 7 arquivos: 5 sem referência Antigravity (OK/não existentes). PASSO5_NOTEBOOKLM_TEMPLATE.md: 1 linha corrigida ("Google Antigravity Platform — Estrategista"). vanguard-v31.md: histórica (Loop 31, superada por v33) — risco baixo, 0 impacto em loops futuros. [RESOLVE: 7-docs-constituicao]

- [x] `2026-06-11` ~~**[MÚSCULO] ATO 3 — expandir pentalateral-firewall.md + 3 skills + session_start gate** [musculo]~~
  ✅ AGENTS.md criado na raiz (v1.1 — R-01-EXPANDIDO preenchido com 628 arquivos inventariados).
  ✅ .agents/workflows/pre-commit.md criado — gate R-01 pré-commit para Antigravity.
  ✅ .claude/skills/doc-drift-audit.md criado — auditoria semântica de deriva documental.
  ✅ .claude/skills/json-bom-guard.md criado — prevenção FALHA-H (BOM UTF-8).
  ✅ session_start.ps1: gate AGENTS.md + alerta se ausente. [RESOLVE: ATO 3]

- [x] `2026-06-11` ~~**[MÚSCULO] ATO 4 — build_budget_guard (monitor builds_aprovados_nao_iniciados)** [musculo]~~
  ✅ build_budget_guard.ps1 criado + integrado ao session_start (relatório na abertura) + session_close (FALHA-PADRÃO no PAINEL se count>=5). Parâmetro -iniciar [id] remove do LOOP_STATE e cria PENDENTES com [RESOLVE:]. [RESOLVE: ATO 4]

- [x] `2026-06-11` ~~**[MÚSCULO] PASSO3_GEMINI.md V33 + CONTEXTO_GEMINI + YT-SEARCH + fontes NotebookLM** [musculo]~~
  ✅ relatorio_evolutivo_V32_VANGUARD.md criado (gate P-045 desbloqueado).
  ✅ PASSO3_GEMINI.md V33 gravado: M-1..M-5 (Cowork, Licitações, Dor, Escala, Presença) + [CAPACIDADES] completas.
  ✅ gemini_anchor_generator.ps1 → CONTEXTO_GEMINI.md (112K chars) gerado.
  ✅ YT-SEARCH executado — 3 queries Loop 33: Licitações, AI Agents, Claude Cowork.
  ✅ 5 vídeos adicionados ao caderno VANGUARD d7dab0e1 — total: 24 fontes (19 docs + 5 YT).
  ✅ DIRETRIZ V33 recebida do Antigravity — G-1..G-5 + [PARA O NOTEBOOKLM]. [RESOLVE: Loop 33 abertura]

- [ ] `2026-06-12` **[DIRETOR] ⚠️ URGENTE — nomear 1 prospect alvo para Vertical Licitações (G-2+G-3)** [diretor]
  Loop 33 D1:A aprovado. O sistema está pronto para executar G-2 (auditoria PNCP) + G-3 (Pitch Reverso ROI).
  GATE BLOQUEANTE: Músculo não pode iniciar sem um nome de prospect.
  Pedir indicação ao Valdece ANTES de 18-06 (E-2 — janela fecha com o hypercare).
  Resposta esperada do Diretor: nome/empresa/nicho do alvo.

- [x] `2026-06-12` ~~**[DIRETOR] ⚠️ URGENTE — E-2 Ponte Valdece antes de 18-06** [diretor]~~
  ✅ Realizado 2026-06-14. Valdece respondeu que nao conhece prospects no nicho de Licitacoes. Gate de prospecção via Valdece encerrado -- buscar prospect por canal direto (LinkedIn/evento). [RESOLVE: E-2-ponte-valdece]

- [x] `2026-06-12` ~~**[MÚSCULO] G-4+A-3 — LOOP_STATE v1.1 por cliente + Context Routing n8n** [musculo]~~
  ✅ G-4: INGRID + VALDECE migrados para schema v1.1 em 2026-06-12.
  ✅ A-3: DESIGN_CONTEXT_ROUTING.md criado (PENTALATERAL_UNIVERSAL/OPERACAO/) — Opção A (local, session_start.ps1 PASSO 8g) recomendada. Gate de build: Diretor aprova Opção A vs B antes de implementar. [RESOLVE: G4-A3]

- [x] `2026-06-12` ~~**[MÚSCULO] E-5 — update_memoria_embaixador.ps1 (automação P-032 completa)** [musculo]~~
  ✅ Implementado junto com Loop 31 item. [RESOLVE: E-5-update-memoria]

- [x] `2026-06-12` ~~**[MÚSCULO] P-150 → INTELLIGENCE_LEDGER — após autorização P-098** [musculo]~~
  ✅ Movido junto com P-149 em 2026-06-12. LEDGER_INBOX confirma STATUS: 0 entradas. [RESOLVE: LEDGER-INBOX-P150]

- [x] `2026-06-12` **[MÚSCULO] P-149 → INTELLIGENCE_LEDGER — após autorização P-098** [musculo]
  P-149 registrado no LEDGER_INBOX: PASSO3 apresenta problemas, nunca soluções pré-compiladas.
  Aguarda: AUTORIZO SOBRESCREVER INTELLIGENCE_LEDGER.md

- [x] `2026-06-11` ~~**[MÚSCULO] Build M-2 — LOOP TRANSCRIPT anti-amnésia** [musculo]~~
  ✅ scripts/generate_loop_transcript.ps1 criado 2026-06-13: extrai M/G/N/E por sócio, arquivos do git log, skills usadas, síntese P-037. Integrado ao session_close.ps1 -- gera automaticamente para clientes com loop CONCLUIDO. [RESOLVE: M-2-loop-transcript]

- [x] `2026-06-11` ~~**[MÚSCULO] Cron W-1 — restaurar 3x/dia no n8n Studio** [musculo]~~
  ✅ Verificado via API 2026-06-12: W-1 já configurado com 3 intervalos (7h/13h/20h) — corrigido em sessão anterior.
  Workflow name: "01 -- Check-in Temporal 7h 13h 20h" confirma. [RESOLVE: cron-w1-3x]

- [x] `2026-06-11` ~~**[MÚSCULO] ATO 5 — LEDGER_INBOX → INTELLIGENCE_LEDGER (autorizado 2026-06-11)** [musculo]~~
  ✅ Concluído 2026-06-11. P-148 + P-130-ADDENDUM + FALHA-H..K adicionados ao LEDGER (2.419→2.455 linhas). Sync P-033 executado (9 arquivos). LEDGER_INBOX zerado. [RESOLVE: ATO 5]

- [x] `2026-06-11` ~~**[MÚSCULO] ATO 6 — notify_hermes.ps1 + watch_readonly.ps1** [musculo]~~
  ✅ Concluído 2026-06-11. notify_hermes.ps1 (CRITICO|ALERTA|AVISO|INFO + dedup 30min + buffer flush).
  watch_readonly.ps1 (monitor SHA-256 dos 7 arquivos R-01 em background). Integrados ao session_start
  (launch) + session_close (stop + flush). Teste AVISO "ATOs 1-6" confirmado no Telegram. [RESOLVE: ATO 6]

- [x] `2026-06-12` ~~**[MÚSCULO] Dívida técnica Loop 34 — reescrever R-01/R-02 do pre-commit-firewall** [musculo]~~
  ✅ R-01 reescrito por filename (não diretório) em .git/hooks/pre-commit.ps1. R-02 migrado para .git/hooks/commit-msg.ps1 com tag [VEREDITO-DIRETOR]. Wrappers pre-commit.bat + commit-msg.bat criados. Hook pre-commit (bash) atualizado para chamar pre-commit.ps1. Hook commit-msg (bash) criado para chamar commit-msg.ps1. Status pre-commit-firewall.md: ATIVO. [RESOLVE: divida-pre-commit-firewall]

### 🔒 LOOP 33 — PENDENTES PÓS-FECHAMENTO (2026-06-13)

- [x] `2026-06-13` ~~**[MÚSCULO] E-1: PADROES_FUNDADOR — seção na MEMORIA_EMBAIXADOR_VANGUARD.md** [musculo]~~
  ✅ PADROES_FUNDADOR adicionado à MEMORIA_EMBAIXADOR_VANGUARD.md v2.2. 6 padrões confirmados: PF-1 (Builder>Vendedor) · PF-2 (Originator Burst) · PF-3 (Aprovação por Silêncio) · PF-4 (Intervenção por CAPS) · PF-5 (Tolerância Zero a Falha Repetida) · PF-6 (Deriva Documental como Incidente). Alertas PF-1 ativos para Loop 34 documentados. [RESOLVE: E-1]

- [x] `2026-06-13` ~~**[MÚSCULO] E-3: ARTEFATO_DE_PROVA — campo no template PAINEL_ATIVIDADES** [musculo]~~
  ✅ Seção ARTEFATO_DE_PROVA adicionada ao generate_protocolo_encerramento.ps1: auto-popula com arquivos do commit do dia + campo CAMPANHA ATIVA + Gate E-4. INSTRUCAO PARA O EMBAIXADOR recebeu bloco 8 com verificação de existência do artefato em disco. [RESOLVE: E-3]

- [x] `2026-06-13` ~~**[MÚSCULO] E-5 RED-TEAM — seção no PASSO7-A template** [musculo]~~
  ✅ BLOCO 5.5 RED-TEAM adicionado ao PASSO7_EMBAIXADOR_TEMPLATE.md: premissa vulnerável + evidência contrária + condição de validade + veredito FORTE/FRÁGIL/BLOQUEAR por E-N. Pergunta obrigatória ao Diretor embutida. Tabela VALIDAÇÃO atualizada com gate RED-TEAM. [RESOLVE: E-5]

- [x] `2026-06-13` ~~**[DIRETOR] P-154 → INTELLIGENCE_LEDGER** [diretor]~~
  ✅ P-154 já inscrito no INTELLIGENCE_LEDGER.md — commit 1c28986 (Loop 33). [RESOLVE: LEDGER-INBOX-P154]

  Arquivos: PAINEL_ATIVIDADES_2026-06-13 · CONTEXTO_SESSAO_DIRETOR_2026-06-13 · WIP_BOARD.json · INTELLIGENCE_LEDGER.md · PENDENTES.md · 16_VANGUARD_TIMELINE.md · MEMORIA_EMBAIXADOR_VANGUARD.md
  Colar mensagem gerada pelo session_close (Gate EMBAIXADOR FORMAT).

---

### 🧭 BACKLOG V30 — registrado no fechamento do Loop 29 (P-134)

- [ ] `2026-06-XX` **[V30 ÉPICO] Máquina de Conhecimento Soberana — canais → FONTES → Auditor → banco gigante** [musculo] — BACKLOG, aguarda Diretor abrir V30
  Visão do Diretor (Loop 29, 09-06-2026 terça-feira): usar os canais externos de TODOS os membros como motor de descoberta de FONTES → canalizar para o Auditor (NotebookLM) → "o mais importante: um gigante banco de dados" / enciclopédia inteligente / criador de podcast-áudio — TUDO agendado. É o Sovereign Data Layer do modelo de negócio.
  Pipeline (5 estágios):
  (1) DESCOBERTA (Source Engine) — `/yt-search` (instalada 09-06) + WebSearch/WebFetch/context7 (Músculo) · Deep Research (Auditor) · Cowork (Embaixador) · varredura (Estrategista). Saída = FONTES {url, data, canal, nicho, por quê, métricas, confianca}.
  (2) CURADORIA (gate firewall) — fontes caem em PENDING_REVIEW; Músculo cura (P-132: fonte+data sempre; dedup; relevância). CURAR alto sinal, nunca despejar.
  (3) INGESTÃO (Auditor/NotebookLM) — fontes curadas → cadernos (P-123: BASE + LOOP + INTEL). Camada de transformação/consulta, NÃO o store durável.
  (4) TRANSFORMAÇÃO — gestor de conhecimento · enciclopédia consultável · podcast/Audio Overview · briefings.
  (5) AGENDAMENTO — cron n8n/Hermes (modelo do W-9 TRENDS) → PENDING_REVIEW → Diretor (P-127: trabalho agendado exige missão aprovada).
  Gate de credibilidade (refinamento Diretor, "para depois"): aplicar o modelo `/yt-search` à WEB com whitelist/denylist de domínios + score de confiança — só fontes fidedignas (oficial/primária/acadêmica), BLOG EXCLUÍDO.
  Riscos do consultor: (a) DILUIÇÃO — valor está na CURADORIA, não no volume; (b) NotebookLM tem LIMITE de fontes → store durável = INTELLIGENCE_HUB (arquivos) → depois Supabase; (c) FONTE ≠ verdade (só "confirmado" com triangulação P-132); (d) firewall P-059/P-124 na ingestão agendada.
  Primeiro passo cirúrgico recomendado: schema de FONTE + captura YT → INTELLIGENCE_HUB/SOURCES/ → PENDING_REVIEW, provar com 1 nicho antes de escalar.
  Memória: project_maquina_conhecimento_soberana + project_motor_de_verdade_engines.

- [ ] `2026-06-XX` **[V30 ÉPICO] Embaixador agentado via Cowork — 2º motor de tempo real (independente de sessão)** [musculo] — BACKLOG, aguarda Diretor abrir V30
  Visão central do Diretor (Loop 29, 09-06-2026 terça-feira): "Cowork te faz ter controle sobre o tempo, INDEPENDENTE de abertura ou fechamento de sessão." Agentar o Embaixador no Cowork para fazer pesquisas, buscar ferramentas/vídeos/concorrentes — "quase tudo" — em DIAS PROGRAMADOS, no relógio do mundo, não no da sessão.
  POR QUE é grande: quebra a limitação do P-001 (Claude Code exige sessão humana). O Cowork vira um 2º motor autônomo (ao lado do Hermes/n8n) que trabalha 24/7 e ACUMULA entre sessões. A Vanguard passa a ter DOIS relógios — o de sessão (Músculo/Diretor) e o do mundo (Hermes + Cowork) — e a abertura de sessão é o ponto de SINCRONIZAÇÃO: o Músculo apenas COLHE o que se acumulou.
  Mecânica proposta: destino fixo `INTELLIGENCE_HUB/INBOX_COWORK/[data].md` (fila durável — P-134, item vive em arquivo nunca em memória de turno); leitura entra como novo PASSO da sequência de abertura (BLOCO 0 → PENDENTES → ... → INBOX externo). Cadência reaproveita o modelo cron do W-9 + dias definidos pelo Diretor (ver D9: competitivo/tendências semanal · edital quinzenal · tecnológico sob gatilho).
  Firewall OBRIGATÓRIO: Cowork não tem firewall nativo — saída cai em PENDING_REVIEW primeiro (P-124), curada na abertura, fonte+data sempre ou "não confirmado" (P-132), nunca direto ao MAPA DIÁRIO. Não cruzar dado de cliente (P-059).
  Liga com a Máquina de Conhecimento (é o estágio DESCOBERTA do Embaixador) e com M'-5 (vigilância 24/7) virando rotina.
  Memória: project_maquina_conhecimento_soberana + project_motor_de_verdade_engines.

- [x] `2026-06-XX` **[V30 ÉPICO] Antigravity motor de deriva / W-10 — comandos determinados + repositório de skills** [musculo] — BACKLOG, aguarda Diretor abrir V30
  Liga doc_freshness_checker + M-4 (curar deriva) num motor do Estrategista (Antigravity) que varre deriva de documentos e processos e só reporta para PENDING_REVIEW (nunca direto a DECISOES/WIP — P-124).
  Inclui curadoria de 5-10 skills do repo Antigravity awesome-skills (1.525+ SKILL.md — curar, não despejar).
  Memória: feedback_antigravity_motor_falhas_deriva + reference_antigravity_awesome_skills.

---
> 📂 PROJ-001 Valdece · PROJ-002 Ingrid · PROJ-003 Mumuzinho em **STANDBY** por decisão do Diretor (09-06-2026) — ver `CLIENTES/STANDBY/PENDENTES_STANDBY.md`. Músculo não toca sem gatilho explícito.

---

## PROCESSO / INFRA

- [x] `2026-06-06` ~~**[GAP] FONTES_DE_VERDADE.json — par estado_wip ausente:**~~
  ✅ Par adicionado com bloqueante_fechamento: false (decisão do Diretor 2026-06-06).
  Fonte: CLIENTES/WIP_BOARD.md · Cópias: INGRID/07_WIP_BOARD.md + VALDECE/07_WIP_BOARD.md
  sync_guard -Abertura: 5 pares · OK: 12 · Divergentes: 0 · VERDE.

- [x] `2026-06-06` ~~**[CANDIDATO A PRINCÍPIO] Diagrama de ciclo sem todos os membros normaliza skip:**~~
  ✅ Registrado como P-117 no INTELLIGENCE_LEDGER.md em 2026-06-07 — veredito do Diretor. [RESOLVE: diagrama-ciclo-skip]

- [x] `2026-06-06` ~~**[CANDIDATO A PRINCÍPIO] sync_guard -WhatIf — modo verdadeiramente passivo:**~~
  ✅ -WhatIf implementado em sync_guard.ps1 (V28). Modo passivo real: exibe o que faria sem escrever em disco. [RESOLVE: sync_guard-whatif]
  DryRun no sync_guard precisa de flag verdadeiramente passivo (-WhatIf) que não escreva em disco.
  Nomenclatura "DryRun" sem modo passivo real é risco de execução silenciosa — detectado em 2026-06-06
  quando -AutoCorrigir alterou NOTEBOOKLM_BASE/01_SKILL durante teste descrito como "DryRun".
  Numeração do princípio atribuída pelo Diretor na próxima sessão com o Embaixador.
  Ação: implementar `-WhatIf` no sync_guard.ps1 que exiba o que seria feito sem alterar nenhum arquivo.

- [x] `2026-06-12` ~~**[SISTEMA] MANUAL_DIRETOR.md — adicionar seção n8n (slot 03 sem n8n):**~~
  ✅ MANUAL_DIRETOR v1.5 já contém PARTE 8 (n8n) — feito na sessão 2026-06-05 (commit 630ab0d). Sync Ingrid+Valdece confirmado.

- [x] `2026-06-12` ~~**[SISTEMA] DEPENDENCY_MAP.json v2.2 — REGISTRO_DE_PREMISSAS + CANDIDATOS:**~~
  ✅ Já estavam em PROJECT_ONLY.padroes desde 2026-06-05 (schema_version 2.2). PENDENTES não foi marcado na época — falha de rastreio corrigida em 2026-06-06 (P-115).

- [x] `2026-06-05` ~~**[SISTEMA] W-7 Telegram — Teste /aprovar TESTE executado:**~~
  ✅ Execução 64 confirmada: isDiretor OK · Parsear OK · Preparar OK · Notion OK · Telegram OK
  GitHub 401: GITHUB_PAT_WRITE não definido no EasyPanel — AÇÃO DO DIRETOR: adicionar env var.
  Após PAT adicionado: W-7 100% funcional.

- [x] `2026-06-05` ~~**[SISTEMA] W-7 — GitHub OK confirmado após GITHUB_PAT_WRITE:**~~
  ✅ Execução 65 success · SHA 1b08156a · VEREDITOS_202606051931.json · diretor_confirmado: true.
  W-7 ENTREGUE E FUNCIONAL — Telegram + Notion + GitHub todos operacionais.

- [x] `2026-06-12` ~~**[SISTEMA] P-072 — W-7 VEREDITOS → session_start processa localmente:**~~
  ✅ PASSO 8f implementado em session_start.ps1: git pull → detecta VEREDITOS/*.json → exibe vereditos pendentes ao Músculo com instrução de processamento. Pasta VEREDITOS/processed/ criada. [RESOLVE: P-072]

- [x] `2026-05-27` ~~**[BLOQUEANTE] ChurnWatch_Vanguard NAO registrado no Task Scheduler:**~~
  ✅ Registrado pelo Músculo em 2026-05-27 (sem Admin necessário). Próxima execução: 28-05-2026 08:00.

- [x] `2026-05-27` ~~**C4 — Watchers EncodedCommand — VERDE:**~~
  ✅ decisoes_watcher.log: OK (20:30). skill_watcher: OK (teste manual 20:46). EncodedCommand funciona com path acentuado.

- [x] `2026-05-27` ~~**Confirmar detect_canonical_violation.ps1 funcionando:**~~
  ✅ PASSO 0c validado em 2026-05-27: violação injetada em NOTEBOOKLM_FONTES/INGRID → VERMELHO exit 1 detectado. Restaurado → VERDE exit 0. NOTEBOOKLM_BASE sync corrigido.

- [x] `2026-05-26` ~~**PROTOCOLO_ONBOARDING_INVISÍVEL.md — decidir destino:**~~
  ✅ Veredito do Diretor em 2026-05-27: ENTRA AGORA. Movido para PENTALATERAL_UNIVERSAL/OPERACAO/. P-085 inscrito no LEDGER.

---

## COMO USAR

**Adicionar pendente (Músculo):**

Formato: traço, espaço, `[ ]`, espaço, data entre crases, bold com contexto + descrição.

**Marcar feito:**
```
- [x] `YYYY-MM-DD` ~~descrição~~
```

**Remover concluídos:** Músculo limpa os `[x]` ao rodar `session_close.ps1`.

- [x] `2026-05-31` ~~**PAINEL_ATIVIDADES — enviar ao Embaixador (Ingrid + Valdece):**~~
  ✅ Confirmado pelo Diretor 2026-06-01 — ambos os arquivos enviados aos respectivos Embaixadores.

- [x] `2026-05-31` ~~**MEMORIA_EMBAIXADOR Ingrid — upload no Claude Projects:**~~
  ✅ Confirmado pelo Diretor 2026-06-01 — carregada no Claude Projects Ingrid.

- [x] `2026-06-05` ~~**TESTE_PROCESSO_COMPLETO.md Bloco A — executado:**~~
  ✅ Arquivo criado (fantasma resolvido) · A1 VERDE · A2 VERDE · A3 VERDE · A4 VERDE · P-050 VERDE (P-099 no LEDGER)

- [x] `2026-06-04` ~~**NotebookLM Wipe & Sync — Valdece:**~~
  ✅ Realizado pelo Diretor em 2026-06-04.

- [x] `2026-06-04` ~~**NotebookLM Wipe & Sync — Ingrid:**~~
  ✅ Executado pelo Diretor em 2026-06-04.

- [x] `2026-06-04` ~~**Capturar depoimento de Ingrid:**~~
  ✅ Ingrid enviou mensagem ao Diretor dizendo que gostou muito da ferramenta. Depoimento capturado.

- [x] `2026-06-04` ~~**Ingrid — mover para RETAINER no WIP_BOARD:**~~
  ✅ Depoimento capturado. Ingrid move para RETAINER — sem mais loops de build.

- [x] `2026-06-04` ~~**Sentinel Report Valdece — WhatsApp enviado:**~~
  ✅ Enviado pelo Diretor em 2026-06-04.

- [x] `2026-06-04` ~~**n8n FASE 1 — build EasyPanel (adiantado de 18-06-2026):**~~
  ✅ 4 workflows ativos em https://vanguard-vanguard-n8n.0ul9nk.easypanel.host
  01 Check-in 7h/13h/20h · 02 Monitor Supabase horário · 03 GitHub Push · 04 Session Close.
  GitHub webhook configurado · n8n_config.ps1 criado · P-103/P-104/P-105 inscritos.

## PROCESSO / INFRA -- n8n FASE 1 (adicionado 2026-06-04)

- [x] `2026-06-04` ~~**n8n -- 4 JSONs de workflow criados e importados:**~~ ✅ todos publicados em produção.

- [x] `2026-06-04` ~~**n8n -- EasyPanel instalado + volume persistente + WEBHOOK_URL configurado:**~~ ✅

- [x] `2026-06-04` ~~**n8n -- GitHub webhook configurado no repositório vanguard:**~~ ✅

- [x] `2026-06-04` ~~**Embaixador V4.0 -- Mandato 19: Perfis de Nicho V1 gerados:**~~
  ✅ PERFIL_NICHO_LEGALTECH_V1.md (Valdece) + PERFIL_NICHO_EDTECH_V1.md (Ingrid) salvos em CLAUDE_PROJECT de cada projeto.
  Princípios P-106/P-107/P-108 inscritos no LEDGER.

- [x] `2026-06-07` ~~**[BUG] W-5 ChurnWatch — falso positivo VERMELHO — RESOLVIDO:**~~
  ✅ Causa confirmada: WIP_BOARD tinha ultimo_contato_cliente=2026-05-20 (desatualizado). Após atualizar para 2026-06-04, alerta voltou a "2d OK". Código do W-5 está correto — lê os campos certos. Não havia workflow antigo duplicado.

- [x] `2026-06-18` ~~**Segurança -- webhooks n8n sem autenticação:**~~
  ✅ W-4: Code node "Validar Secret" adicionado via API PUT (HTTP 200). Verifica X-Webhook-Secret.
  ✅ W-3: Code node "Validar Origem GitHub" adicionado via API PUT (HTTP 200). Verifica X-Hub-Signature.
  ✅ Script local: n8n_session_webhook.ps1 envia X-Webhook-Secret em todo POST para W-4.
  Segredo: N8N_WEBHOOK_SECRET (já no EasyPanel). [RESOLVE: seguranca-webhooks]

- [x] `2026-06-12` ~~**[MUSCULO] GATE 1.6 -- calibrar reconcile_pendentes.ps1** [musculo]~~
  ✅ 22 → 3 matches: (1) excluir commits com [RESOLVE:] da verificação; (2) comparar só contra título negrito **...**; (3) word boundary \b; (4) threshold 5→7 chars; (5) stopwords expandidas (+20 termos); restam 3 ruídos aceitáveis (1 genuíno: doc_freshness sem tag). [RESOLVE: GATE-1.6]

- [x] `2026-06-12` ~~**[MUSCULO] Register-Veredito -- fix Loop display** [musculo]~~
  ✅ Verificado 2026-06-12: commit fa9514d já aplica regex `$rawLoop -match "(\d+)"` — extrai só o número. [RESOLVE: register-veredito-loop]

- [x] `2026-06-12` ~~**[MUSCULO] Gate 7C -- verificacao por HORARIO, nao por data** [musculo]~~
  ✅ Verificado 2026-06-12: Gate 7C já usa threshold 8h (TotalHours) + exibe "yyyy-MM-dd HH:mm".
  Commit 235fe57 aplicou o fix nesta sessão. [RESOLVE: gate7c-horario]

- [x] `2026-06-12` ~~**[MUSCULO] PASSO 0 BLOQUEANTE -- Cowork + Notion com mesma forca que BLOCO 0** [musculo]~~
  ✅ session_start.ps1 atualizado: $colheitaCowork reescrito com linguagem ⛔ BLOQUEANTE.
  Sequencia obrigatoria: [1] Notion (hook automatico -- confirmar) → [2] Cowork MCP Drive → BLOCO 0.
  Musculo que solicita BLOCO 0 antes de executar PASSO 0 = DEF-M-6 automatico. [RESOLVE: passo0-bloqueante]

- [x] `2026-06-12` ~~**[MUSCULO] Notion FALHA -- ChurnWatch JSON parse error (W-5)** [musculo]~~
  ✅ Causa real: BOM UTF-8 no WIP_BOARD.json (FALHA-L, 2ª ocorrência de FALHA-F).
  fix_bom_json.ps1 corrigiu (commit 6bcae81). W-5 atualizado via API: strip BOM no decode + continueOnFail:true + alerta dedicado.
  FALHA-L inscrita no LEDGER. [RESOLVE: ChurnWatch-parse-error]

- [x] `2026-06-12` ~~**[MUSCULO] Notion SUGESTOES -- classificadas P-092** [musculo]~~
  ✅ S-3: CONSELHO/GUIA_SKILLS_MUSCULO.md criado (brainstorming/ultrathink/superpowers/mcp-builder/cowork).
  ✅ S-4: Descartado pelo Diretor ("Nada de Lovable") 2026-06-12.
  ✅ S-5: P-153 inscrito no INTELLIGENCE_LEDGER.md (Músculo identifica falhas antes de concordar). [RESOLVE: sugestoes-notion]
  S-1/S-2: Expandir LMM Embaixador + Antigravity em V30 -- registrar em backlog V30 [diretor delibera]

- [ ] [musculo] [P-146/P-140] Build `gate_yt_search.ps1` — bloquear upload ao NotebookLM se NAO existir `19_FONTES_YOUTUBE_*.md` do loop atual. Causa-raiz (2026-06-15): Musculo seguiu resumo de compactacao e pulou o YT-SEARCH de abertura. Gate integra preparar_notebooklm_projeto.ps1 (exit 1 sem fonte YT do loop). [FALHA-PROCESSO-2026-06-15-YTSEARCH]

- [x] `2026-06-16` ~~**[MÚSCULO] R-01/flag P-098 quebrado em OneDrive — `.git/hooks/pre-commit.ps1` não enxerga `.musculo_autorizacao.flag`**~~ [musculo]
  ✅ RESOLVIDO 2026-06-16 (P-182 no LEDGER). Causa-raiz confirmada via systematic-debugging: console **CP850/ibm850** quando o git-sh dispara `powershell.exe` — `git rev-parse --show-toplevel` emite UTF-8, o PS decodifica como CP850, "Área de Trabalho" corrompe, `Test-Path` do flag (e do gate R-05) → False. Fix: `$raiz` derivado de `$PSScriptRoot` (argv chega em UTF-16 via `-File`, imune), `git rev-parse` só como fallback (`.git/hooks/pre-commit.ps1` linhas 9-22). Reparou os 2 consumidores num só ponto (flag P-098 + gate R-05). Verificado em CP850: R-01 dispara sem flag (exit 1) / autoriza com flag (exit 0) / consome one-shot. Hook não é versionado → correção local ativa; reinstalar se reclonar (preservar derivação $PSScriptRoot). [RESOLVE: R-01-flag-onedrive]
  ---
  Causa-raiz (2026-06-16): ao commitar o P-180 no INTELLIGENCE_LEDGER.md, o `.musculo_autorizacao.flag` (conteúdo `INTELLIGENCE_LEDGER.md`, ASCII sem BOM) foi criado corretamente — teste manual em PowerShell confirmou `eqFlag=True` (Get-Content -Raw .Trim() lê o nome exato). MAS o `powershell.exe` que o git spawna via `sh` (MINGW) NÃO enxergou o flag → R-01 abortou com "requer autorizacao" em 3 tentativas seguidas. Tive que usar o bypass de emergência `PENTALATERAL_AUTORIZO=1` (linha 62) para commitar (e776076).
  IMPACTO: o caminho (a) do firewall R-01 — "criar `.musculo_autorizacao.flag`" — está INOPERANTE em repositório OneDrive. Hoje só funcionam (b) `[VEREDITO-DIRETOR]` (verificado em commit-msg, mas pre-commit aborta ANTES) e o env var de emergência. A mensagem do hook ("Opcoes: (a) criar flag... (b) [VEREDITO-DIRETOR]") mente sobre o que de fato libera.
  O que investigar/corrigir em `.git/hooks/pre-commit.ps1`:
  (a) CAUSA-RAIZ CONFIRMADA (2026-06-16, 2ª ocorrência ao commitar o Detector): NÃO é timing/sync. É **encoding do caminho acentuado**. Prova: `git rev-parse --show-toplevel` retorna `.../OneDrive/Área de Trabalho/vanguard`; rodando `Test-Path $flag` MANUALMENTE no PowerShell tool → `True` e o flag é lido. Mas o `powershell.exe` que o `git` spawna via `sh`/`pre-commit.bat` roda noutro codepage onde o "Á" de "Área de Trabalho" é mal-decodificado → o `Test-Path $autorizacaoFlag` dentro do hook resolve para um caminho que NÃO existe → `$arquivoAutorizado` fica vazio → R-01 aborta E o flag NEM é consumido (continua em disco após a falha — sintoma-diagnóstico). CORREÇÃO indicada: forçar UTF-8/codepage no `pre-commit.bat` (`chcp 65001` antes do powershell, e/ou `[Console]::OutputEncoding`/`$OutputEncoding` UTF-8 no .ps1) OU passar o toplevel já normalizado como argumento do `sh` (que enxerga o path correto) ao .ps1, em vez de recomputá-lo dentro do powershell filho. Validar com `Test-Path` logando o caminho exato visto pelo hook;
  (b) alinhar a mensagem do hook à realidade: se (a) não for corrigível, remover a opção (a) enganosa e documentar `[VEREDITO-DIRETOR]` + env var como os caminhos válidos — mas pre-commit.ps1 precisaria então LER a mensagem do commit (hoje não lê; só commit-msg.ps1 lê);
  (c) garantir consumo one-shot consistente (linha 100) qualquer que seja o caminho escolhido.
  Build na sessão dedicada de processo (mexer no firewall git é sensível — cabeça fresca, testar BLOQUEIO + LIBERA antes de confiar). [RESOLVE: R-01-flag-onedrive]

- [x] ~~`2026-06-16` **[MÚSCULO] `propagate_changes.ps1 -Arquivo` faz no-op silencioso — furo no firewall de propagação P-060** [musculo]~~
  ✅ RESOLVIDO 2026-06-16 (systematic-debugging, streams separados). **CAUSA RAIZ — NÃO era path acentuado (hipótese (a)/(b) descartada).** O arquivo `scripts/propagate_changes.ps1` era **UTF-8 SEM BOM e continha 3 em-dashes `—` (bytes E2 80 94)**. O `powershell.exe -File` do PS 5.1 lê arquivo sem BOM na codepage ANSI/OEM legada e mal-decodifica o multibyte (0x94→aspas-curva em CP1252), **corrompendo a tokenização das strings** → o fluxo desviava silenciosamente após o bloco `if (count -eq 0)` (linha 45-48) e caía direto na linha "Nenhuma propagacao" com `propagados=0`. Não reproduzia no console do Claude Code (CP65001/UTF-8) — só via `-File`. Mesma família de `feedback_ps51_encoding.md` (utf8NoBOM mata script) e prima do P-182 (lá era console; aqui é arquivo). **FIX (alinhado à convenção "scripts em ASCII"):** troquei os 3 em-dashes por hífen → arquivo ASCII puro (0 bytes não-ASCII), imune a codepage sem precisar de BOM. **VERIFICADO:** `-Arquivo INTELLIGENCE_LEDGER.md` agora propaga aos 10 destinos; `-Forcar` → 73 destinos; `validate_scripts` OK. Itens (c)/(d) viram backlog separado (SHA-256 pós-cópia + auditoria do hook que mascarava). **BLAST RADIUS:** 44 `.ps1` sem BOM com não-ASCII têm o mesmo risco latente → recomendação P-183 + tool anti-recorrência apresentada ao Diretor.
  Achado (2026-06-16, ao propagar o P-182 no INTELLIGENCE_LEDGER.md): `propagate_changes.ps1 -Arquivo "INTELLIGENCE_LEDGER.md"` devolveu **"Nenhuma propagacao necessaria"** e NÃO tocou os destinos mapeados no DEPENDENCY_MAP (`NOTEBOOKLM_BASE/04` + 3× `CLIENTES/*/CLAUDE_PROJECT/06` ficaram STALE). Os 3 `CLIENTES/*/NOTEBOOKLM_FONTES/04` ficaram frescos por OUTRA via (provável hook PostToolUse no Edit), o que MASCARA o defeito. Tive que sincronizar os 4 stale à mão (Copy-Item canônico→destino + verificação SHA-256 → 8 arquivos HASH-OK).
  IMPACTO: o Músculo confiaria no "nada necessário" e deixaria espelhos desatualizados — Auditor/Embaixador leriam LEDGER stale. Viola P-060 (propagação confiável, zero intervenção do Diretor) e P-033 (sync universal).
  O que investigar em `scripts/propagate_changes.ps1`:
  (a) por que o ramo `-Arquivo` (linhas 30-31, `$arquivosAlterados = @($Arquivo)`) não dispara a regra `trigger: "INTELLIGENCE_LEDGER.md"` — match em linha 67-72 (`$a -like "*$trigger*"`) deveria casar; verificar se `$propagados` fica 0 por falha de `Test-Path` de origem/destino ou por encoding do path acentuado (mesma classe do P-182);
  (b) se a causa for path acentuado, aplicar a mesma correção do P-182 (derivar `$raiz` de `$PSScriptRoot`, não de processo externo decodificado pelo console);
  (c) adicionar verificação SHA-256 pós-cópia ao próprio script (hoje copia mas não confirma integridade no modo `-Arquivo`);
  (d) confirmar qual hook deixou os FONTES frescos e garantir que ele cobre TODOS os destinos do DEPENDENCY_MAP, não só FONTES — senão o mascaramento persiste.
  Sessão de processo (firewall de propagação é sensível — testar com diff de hash antes/depois em todos os destinos do trigger). [RESOLVE: propagate-noop-arquivo]

- [ ] [musculo] [P-146/P-183] **Ferramenta anti-recorrência: bloquear `.ps1` com byte não-ASCII (>127).** Causa-raiz (2026-06-16): `propagate_changes.ps1` quebrou silenciosamente por em-dash em arquivo sem BOM lido pelo PS 5.1 `-File` em codepage ANSI/OEM (P-183 no LEDGER). 44 `.ps1` sem BOM com não-ASCII têm o mesmo risco latente (piores: prospectar.ps1, iah-clone.ps1, loop_guardian.ps1, session_start.ps1). Build em 3 partes: (a) **guard PreToolUse Write/Edit** que NEGA gravar `.ps1` com qualquer byte >127 (força ASCII na fonte) — padrão de `file_protection_guard.ps1`, fail-open; (b) **lint em `validate_scripts.ps1`** que falha se `.ps1` tiver byte >127; (c) **normalizador batch** dos 44 `.ps1` existentes, em sessão dedicada testando cada um (session_start/hooks são sensíveis — testar BLOQUEIO+LIBERA antes de confiar). Sem este build, o P-183 é decoração (P-146). [FALHA-PROCESSO-2026-06-16] [RESOLVE: guard-nao-ascii-ps1]
