# PENDENTES — Vanguard IAH
> Atualizado pelo Músculo em tempo real durante qualquer sessão.
> O briefing matinal lê este arquivo — tudo aqui aparece às 7h.
> Regra P-047: qualquer tarefa identificada como pendente → registrar aqui IMEDIATAMENTE.
> Feito? Marcar [x]. Músculo remove os [x] ao fechar sessão.

---

## 🔴 ALERTAS CRÍTICOS — AÇÃO IMEDIATA DO DIRETOR

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

- [ ] `2026-06-09` **[DIRETOR] Arrastar 7 arquivos ao Embaixador + colar mensagem** [diretor]
  Arquivos: PAINEL_ATIVIDADES · CONTEXTO_SESSAO_DIRETOR · WIP_BOARD · LEDGER · PENDENTES · VANGUARD_TIMELINE · MEMORIA_EMBAIXADOR
  Mensagem já preparada: colar a mensagem copiada do terminal da sessão 2026-06-08.

- [ ] `2026-06-09` **[MÚSCULO] DIRETRIZ V29 — ir ao Gemini com PASSO3_GEMINI.md** [musculo]
  PASSO3 pronto em CLIENTES/VANGUARD/PASSO3_GEMINI.md.
  Pré-requisito: auditoria cirúrgica concluída.
  Usar skill gemini-pentalateral: subir PASSO3 ao Drive → anexar + disparar.

- [ ] `2026-06-09` **[MÚSCULO] Fix sistêmico P-073 — sync_vanguard_docs.ps1 deve atualizar NOTEBOOKLM_BASE** [musculo]
  Problema recorrente: OPERACAO/ é atualizado → sync copia para CLIENTES/ mas NÃO para NOTEBOOKLM_BASE/.
  detect_canonical usa BASE como referência → falso positivo VERMELHO toda sessão.
  Fix: adicionar Passo 0 no sync_vanguard_docs.ps1 — OPERACAO → NOTEBOOKLM_BASE antes de OPERACAO → CLIENTES.
  Afeta: 01_SKILL_PROTOCOLO + 03_MANUAL_DIRETOR (detectado em 2026-06-09).
  Baixa prioridade mas recorrente — eliminar para sempre.

- [ ] `2026-06-09` **[DIRETOR] W-9 Track TRENDS — importar no EasyPanel n8n** [diretor]
  Arquivo: `_n8n/workflows/w9_trends_semanal.json` (criado em 2026-06-08, pronto para import).
  Acesso: EasyPanel → n8n → Workflows → Import from file.
  Após import: configurar ENV_VARS (ANTHROPIC_API_KEY + TELEGRAM_BOT_TOKEN + TELEGRAM_CHAT_ID já existem).
  Cron: segunda-feira 8h BRT. Gera relatório de tendências por nicho no INTELLIGENCE_HUB/TRENDS/.

- [x] `2026-06-09` ~~**[MÚSCULO] W-8 — deploy 4 workflows via API + reativar** [musculo]~~
  ✅ Músculo deployou via API (GET live→modify→PUT): W-1 (7 nodes) · W-3 (7 nodes) · W-5 (8 nodes) · W-8 (7 nodes). Todos reativados. Shadow mode real começou — silenced_signals_log receberá dados a partir de 2026-06-09. Fix crítico descoberto: settings com binaryMode/timeSavedMode/availableInMCP causa 400 no PUT — usar só executionOrder. [RESOLVE: W-8-deploy]

- [x] `2026-06-09` ~~**[DIRETOR] W-8 — adicionar 2 env vars no EasyPanel n8n** [diretor]~~
  ✅ SUPABASE_VANGUARD_URL + SUPABASE_VANGUARD_ANON_KEY confirmadas pelo Diretor 2026-06-09.
  W-8 shadow mode 100% operacional — pode gravar em silenced_signals_log.
  ALERTA RESIDUAL (sem impacto): SUPABASE_URL_INGRID aponta para Vanguard (não Ingrid) — variável órfã, não usada por nenhum workflow.

- [ ] `2026-06-14` **[DIRETOR] W-8 shadow mode — avaliar ativação plena** [diretor]
  DEADLINE HARD: shadow mode expira 2026-06-14.
  PRÉ-REQUISITO: item EasyPanel acima deve estar feito antes desta avaliação.
  Decisão: se silenced_signals_log tiver dados → ativar pleno (`shadowMode = false` em w8 + reimport). Senão prorrogar.

- [ ] `2026-06-18` **[DIRETOR] Sentinel Valdece — Hypercare encerra** [diretor]
  Hypercare até 18/06/2026. Sentinel antes desta data.
  P-120 ATIVO: NÃO mencionar automação/IA/agentes ao Valdece.

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

---
## PROJ-001 · Valdece (Hypercare até 18/06/2026)

- [x] `2026-06-02` ~~**Sentinel Report — PASSO7-C preparado pelo Músculo:**~~
  ✅ PASSO7_SECAO_B_SENTINEL_2026-06-01.md gerado · Embaixador processou · texto pronto.

- [x] `2026-06-02` ~~**Sentinel Report — Eduardo ENVIA WhatsApp ao Valdece (02-06-2026 terça-feira):**~~
  ✅ WhatsApp enviado pelo Diretor — 2026-06-01. Aguardar resposta de Valdece.

- [x] `2026-05-26` ~~**NotebookLM Wipe & Sync — Valdece:**~~
  ✅ Confirmado pelo Diretor em 2026-05-27. (PENDENTES não foi atualizado na sessão anterior — falha do Músculo.)

---

## PROJ-002 · Ingrid (Loop 7 CONCLUÍDO · Loop 8 aguarda)

- [x] `2026-06-01` ~~**Ingrid — D4: GitHub Security — Pages push bloqueado (pré-requisito de tudo):**~~
  ✅ Token sbp_ revogado + alerta GitHub dispensado — confirmado pelo Diretor 2026-06-01.

- [x] `2026-06-01` ~~**Ingrid — D1: Deploy CLI F-4 + F-6 (Gate 7.1) — aguarda D4:**~~
  ✅ 3 Edge Functions deployadas em yjqvjhezwhepwomukudt + pg_cron VERDE — 2026-06-01.
  gatilho_temporal_ingrid (45 22 * * *) + relatorio_semanal_ingrid (0 13 * * 0) ativos.

- [x] `2026-05-31` ~~**Ingrid — D3: Debrief casual Ingrid (gate informal pitch):**~~
  ✅ Mensagem enviada pelo Diretor — 2026-06-01. Aguardar resposta de Ingrid.

- [x] `2026-06-04` ~~**Ingrid — D2: Gate 7.2 RLS dry-run — encerrado:**~~
  ✅ Registrado como dívida técnica (single-user by design). Multi-tenant requer refatoração futura.

- [x] `2026-06-XX` **Ingrid — D6: Semente E-4 pós-aprovação — aguardar engajamento:** [diretor]
  Veredito do Diretor 2026-05-30: aguardar sessão com mais engajamento verbal de Ingrid.
  Frase pronta: "Quando você passar, você vai ser a prova que esse negócio funciona — aí a gente pensa em expandir. 😄"


- [x] `2026-06-07` ~~**[MÚSCULO] W-6 Session Watch — criar no n8n EasyPanel via API e desativar o workflow estático:**~~
  ✅ W-6 (ID: `0MoOx1AAtd44ePET`) criado + ativado via API — 2026-06-07. Session Watch estático (pSd0cUNVVyp5IsMO) desativado. Dados agora dinâmicos (lê PENDENTES.md + verifica W-4). `_n8n/workflows/w6_session_watch.json` atualizado com W-4 check + IF node.

- [x] `2026-06-07` ~~**[MÚSCULO] Gate 1.6 — reconcile_pendentes.ps1 virar bloqueante no session_close:**~~
  ✅ reconcile_pendentes.ps1 agora emite exit 2 quando detecta divergências. Gate 1.6 inserido no session_close.ps1 entre Gate 1.5 e Gate 2 — bloqueia (exit 1) em exit 2. G1_6 adicionado ao gateStatus. 2026-06-07.

- [x] `2026-06-07` ~~**[MÚSCULO] SKILL_PROTOCOLO v6.7 + MANUAL_DIRETOR v1.7 — gaps P-087/P-090/P-118/Gate1.6/W-5/W-6:**~~
  ✅ P-087 (RESOLVE tag) + P-090 (PASSO3 no arquivo) + P-118 (auditar antes de construir) adicionados ao SKILL_PROTOCOLO. Gate 1.6 + W-5 ChurnWatch + W-6 Session Watch documentados no MANUAL_DIRETOR. Cadeia canônica NOTEBOOKLM_BASE → CLIENTES propagada. Hook P-073 VERDE.

- [x] `2026-06-07` ~~**[MÚSCULO] Audit SKILL_PROTOCOLO — princípios P-070 a P-111 ausentes**~~
  ✅ Seção "PRINCÍPIOS RECENTES — P-070 a P-101" adicionada ao SKILL_PROTOCOLO v6.8. 17 princípios de impacto operacional direto (P-070 a P-101) incorporados. Propagado para NOTEBOOKLM_BASE + INGRID + VALDECE + VANGUARD. 2026-06-07. [RESOLVE: Audit SKILL_PROTOCOLO]

- [ ] `2026-06-07` **[MÚSCULO] Pentalateral — Levar descoberta /notebooklm ao Auditor + Embaixador** [musculo]
  PASSO5 (Auditor): análise histórica + riscos + como a skill muda o ciclo + N-1 a N-5
  PASSO7-D (Embaixador): SEÇÃO D com análise do Músculo (M-1 a M-5) sobre ampliação de habilidades
  Contexto: skill /notebooklm instalada + P-120 inscrito + análise de /gemini como próximo elo
  Objetivo: Auditor + Embaixador deliberam sobre "ampliar habilidades do Pentalateral"

## Ficou no Ar -- 2026-06-07 (gerado automaticamente)
- [ ] "2026-06-07" **Deploy Secretário Virtual no EasyPanel (adaptar main.py para Formspree + configurar webhook)** [musculo]
- [ ] "2026-06-07" **[diretor] Login no formspree.io para confirmar acesso ao formulário `xjglyyer`** [diretor]
- [ ] "2026-06-07" **[diretor] Considerar abertura de MEI antes do primeiro contrato** [diretor]

- [x] "2026-06-07" ~~**Mensagens aos sócios (Gemini/NotebookLM/Embaixador) sobre V28**~~
  ✅ Feito na sessão 2026-06-07 — confirmado pelo Diretor. Pendente era falso positivo do sync_ficou_no_ar.ps1.
- [x] "2026-06-07" ~~**Templates Pentalateral + MANUAL_DIRETOR + SKILL_PROTOCOLO_VANGUARD**~~
  ✅ MANUAL_DIRETOR v1.6 (7f89fef) + SKILL_PROTOCOLO v6.6 + TEMPLATES v2.1 (34578d4) + sync todos clientes (309d02a). Pendente era duplicata gerada por sync_ficou_no_ar.ps1.
- [x] "2026-06-07" ~~**Skill `pentalateral-graus-abc.md` upload no dashboard Hermes**~~
  ✅ Arquivo em hermes-agent/skills/ + confirmado no container /opt/data/skills/ pelo Diretor (2026-06-07). Commit 139827f. Pendente era duplicata do sync_ficou_no_ar.ps1.
- [x] "2026-06-09" ~~**WhatsApp Valdece + Ingrid (ChurnWatch alertou)**~~ [diretor]
  ✅ Ambos responderam em 2026-06-09: ferramentas OK. Projetos em standby. ultimo_contato atualizado → 2026-06-09. ChurnWatch VERDE.

- [ ] `2026-06-XX` **Ingrid — D5: M-4 Link Demo BLOQUEADO até segunda usuária:** [musculo]
  Com 1 usuária, anonimato é fictício. Liberar quando segunda usuária ativa.
  Quando liberar: só gráficos e Heatmap — NUNCA conteúdo das questões.

- [x] `2026-05-26` ~~**NotebookLM Wipe & Sync — Ingrid:**~~
  ✅ Fontes antigas deletadas → 18 arquivos de CLIENTES/INGRID/NOTEBOOKLM_FONTES/ carregados — 2026-05-26

- [x] `2026-05-26` ~~**Ingrid — Assinatura física do Termo de Uso — RESOLVIDO:**~~
  ✅ Reassinatura física confirmada pelo Diretor em 2026-05-27. LEGAL-WATCH VERDE.

- [x] `2026-05-27` ~~**Ingrid — Termo de Uso — RESOLVIDO:**~~
  ✅ PDF 18/05/2026 enviado + reassinatura física obtida — confirmado pelo Diretor em 2026-05-27. LEGAL-WATCH VERDE.

- [x] `2026-05-26` ~~**Deploy GitHub Pages — Ingrid v19 — GATE TESTE:**~~
  ✅ Eduardo confirmou v19 funcionando no celular em 2026-05-27. Dashboard, SM-2, saudação, debug — VERDE.
  Gate desbloqueado: Músculo pode iniciar F-2 + F-4 + F-6 (backend Loop 6).

- [x] `2026-05-30` ~~**Loop 6 Ingrid — Gemini PASSO3:**~~
  ✅ DIRETRIZ V6 recebida · ingrid-v6.md instalada — confirmado pelo Diretor 2026-05-27.

- [x] `2026-05-30` ~~**Loop 6 Ingrid — Embaixador PASSO7 Seção D:**~~
  ✅ SEÇÃO D executada — Embaixador retornou TEMPERATURA 7.5/10 + [E-1 a E-5] + PAINEL — 2026-05-27

- [x] `2026-05-30` ~~**Loop 6 Ingrid — Músculo /ingrid-v6 + síntese P-037:**~~
  ✅ ingrid-v6.md lida · DELIBERACAO_LOOP_V6_INGRID.md gerado · MEMORIA_EMBAIXADOR atualizada (P-032) — 2026-05-27

- [x] `2026-05-30` ~~**Loop 6 Ingrid — Backend F-2 + F-4 + F-6 (após gate v19):**~~
  ✅ Commits 86e112b + a2b42f5 confirmam — backend completo em 2026-05-28 00:24. PENDENTES não foi atualizado na sessão anterior — falha do Músculo corrigida agora.

- [x] `2026-05-30` **Ingrid — Dia 13 (29-05-2026 sexta-feira) — Contador Pontos Ponderados + Notificação push domingo:**
  Contador Pontos Ponderados: exibir no header/dashboard a pontuação ponderada acumulada da Ingrid.
  Notificação push domingo: acionar notificação automática aos domingos para lembrar do Micro-Simulado.
  Referência: plano_build dia12_13 do WIP_BOARD + skill ingrid-v6.md.

- [x] `2026-05-27` ~~**Loop 6 Ingrid — PAINEL DE DELIBERAÇÃO:**~~
  ✅ P0-A (DADOS-WATCH VERDE: 102 respostas migradas) · P1-A (aguardar até 31/05) · PRINCIPIO-A (P-079 inscrito) · D3_VANGUARD-A (registrado) — 2026-05-27

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

- [ ] `2026-07-XX` **Ingrid — Gate 7.2 RLS refactor — pré-requisito multi-tenant:** [musculo]
  Sistema atual é single-user por design (USING true). Para 2ª candidata: adicionar Supabase Auth + substituir UUID localStorage por auth.uid() em todas as tabelas.
  Não bloqueia nada até decisão de onboarding multi-tenant.

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

- [x] `2026-06-05` ~~**[SISTEMA] B-2 — W-7 Cérebro de Bolso MVP (3 queries):**~~
  ✅ /status /score /custo integrados ao W-7 (13 nodes). Execução 68 success.
  /status testado: retornou CHECK|Valdece L7 + RETAINER|Ingrid L8 com dados reais do GitHub.
  /score + /custo: funcionais após adicionar SUPABASE_URL + SUPABASE_ANON_KEY no EasyPanel.

- [x] `2026-06-05` ~~**[SISTEMA] B-2 — /score e /custo: env vars Supabase no EasyPanel:**~~
  ✅ SUPABASE_URL + SUPABASE_ANON_KEY adicionadas — /score retornou "sem dados" (OK, tabela vazia) — 2026-06-05.

- [x] `2026-06-05` ~~**[SISTEMA] B-3 — AI-BOM / security module integrado ao n8n_audit.ps1:**~~
  ✅ MODULO 2 adicionado: detecta JWT, GitHub PAT, Supabase, Notion, Anthropic, Telegram, Slack, Bearer literal.
  Teste adversarial: ghp_ simulado → [SEC-CRED:GitHub-PAT] detectado + bloqueio DryRun confirmado.
  Workflows reais: CLEAN (todos usam $env.). MODULO 1 falsos positivos corrigidos (numPattern req keyword).

## PROCESSO / INFRA -- n8n FASE 2 (adicionado 2026-06-05)

- [x] `2026-06-05` ~~**n8n FASE 2 — Deliberação D1-D5 aprovada e registrada:**~~
  ✅ DECISOES_N8N_FASE2_2026-06-05.json aprovado (D1:A D2:A D3:A D4:A D5:A).
  Ref: PENTALATERAL_UNIVERSAL/HISTORICO/DECISOES_N8N_FASE2_2026-06-05.json
  Sequência de build: N-4 → N-1 → W-8 → M-4 → W-6 → W-7 MVP → W-7 v1.1 → Notion.

- [x] `2026-06-05` ~~**n8n FASE 2 — N-4: pre-commit hook valida schema DECISOES.json v1.1:**~~
  ✅ .git/hooks/pre-commit atualizado com seção N-4 (Python inline). Valida schema_version=1.1 + campos obrigatórios + vereditos A/B/C.

- [x] `2026-06-05` ~~**n8n FASE 2 — N-1: ping_n8n.ps1 + session_start.ps1 PASSO 8e:**~~
  ✅ scripts/ping_n8n.ps1 criado · PASSO 8e adicionado no session_start.ps1 · P-060 validate VERDE.

- [x] `2026-06-05` ~~**n8n FASE 2 — D2: Configurar ENV_VARS completas no n8n EasyPanel:**~~ [diretor]
  ✅ CONCLUÍDO 2026-06-05: todas as 10 variáveis configuradas.
  NOTION_LEDGER_PAGE_ID = 376ac59f774f80809e9fee855d62070a (Ledger Vanguard — adicionado 2026-06-05).
  ANTHROPIC_API_KEY validada via teste direto à API (Haiku respondeu OK).
  Gate D3 desbloqueado.
  ⚠️ ATUALIZAR 2026-06-05: NOTION_WIP_PAGE_ID = 376ac59f774f817db1d8c204d6abcea5 (WIP Board recriado standalone — página antiga era inline dentro de Pendentes).

- [x] `2026-06-05` ~~**Notion — NOTION_WIP_PAGE_ID atualizado no EasyPanel:**~~
  ✅ 376ac59f774f817db1d8c204d6abcea5 configurado — W-3 confirmou Notion operacional — 2026-06-05.

- [x] `2026-06-12` ~~**n8n FASE 2 — D5: Timer 7 dias staging FASE 1 — gate para W-5 ChurnWatch:**~~
  ✅ W-5 construído e ativo desde 2026-06-05. W-1/W-3/W-4 sem erros em 2026-06-06 (OK:4/OK:4/OK:2). Gate cumprido antecipadamente — W-5 em produção. [RESOLVE: D5]

- [x] `2026-06-05` ~~**n8n FASE 2 — D6: Build W-7 Veredito MVP texto:**~~
  ✅ Importado + ativo (ID: KisAa6ynD4btgrkL) · /aprovar TESTE confirmado pelo Diretor 2026-06-05.
  Comandos: /aprovar A · /rejeitar B · /veredito D1:A D2:B · log automático no Notion Pendentes.

- [x] `2026-06-05` ~~**n8n FASE 2 — Blocos 4-6: Notion OUTPUT em W-1 + W-3 + W-4:**~~
  ✅ Nodes Preparar Body + Notion Append adicionados nos 3 workflows (continueOnFail: true — P-110).
  W-1 (Check-in): STATUS → NOTION_WIP_PAGE_ID · W-3 (GitHub Push): COMMIT → NOTION_WIP_PAGE_ID
  W-4 (Session Close): SESSAO → NOTION_WIP_PAGE_ID · PENDENTES → NOTION_PENDENTES_PAGE_ID
  Workflows ativados via API em 2026-06-05 — todos status: active=True.
  P-110 inscrito no LEDGER (toda automação crítica exige fallback ≤3 passos).

- [x] `2026-06-07` ~~**[BUILD] Rodar TESTE_PROCESSO_COMPLETO.md Bloco A — build significativo detectado**~~
  ✅ A1 VERDE (sem placeholders) · A2 VERDE (todos artefatos: MEMORIA+relatorio+DELIBERACAO para VANGUARD/VALDECE/INGRID) · A3 INFO (PASSO3 referencia loop anterior — normal, regenerado ao iniciar próximo loop) · A4 INFO (MEMORIA_EMBAIXADOR: sem vereditos hoje, sem obrigação P-032). [RESOLVE: TESTE-PROCESSO-BLOCO-A]
- [x] `2026-06-07` ~~**[BUILD] Rodar TESTE_PROCESSO_COMPLETO.md Bloco A — build significativo detectado**~~
  ✅ A1 VERDE (sem placeholders) · A2 VERDE (todos artefatos: MEMORIA+relatorio+DELIBERACAO para VANGUARD/VALDECE/INGRID) · A3 INFO (PASSO3 referencia loop anterior — normal, regenerado ao iniciar próximo loop) · A4 INFO (MEMORIA_EMBAIXADOR: sem vereditos hoje, sem obrigação P-032). [RESOLVE: TESTE-PROCESSO-BLOCO-A]