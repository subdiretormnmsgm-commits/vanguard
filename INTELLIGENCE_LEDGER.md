# INTELLIGENCE LEDGER — Quadrilateral IAH
**Organismo Vivo — atualizado a cada sessão pelo Músculo**
**Criado:** 2026-05-12 | **Compactação:** mensal (arquivar entradas > 90 dias)

> Este arquivo é lido pelo Músculo no INÍCIO de cada sessão.
> Cada princípio aqui vale mais do que qualquer código — é o que torna o sistema impossível de copiar.

---

## PROTOCOLO DE LEITURA — INÍCIO DE SESSÃO

Antes de qualquer deliberação, o Músculo executa:

```
1. Ler PRINCÍPIOS ATIVOS — há algum que se aplica à sessão atual?
2. Ler últimas 3 entradas do LOG DE SESSÕES — há fricção recente relevante?
3. Skill-Drift check — a direção desta sessão alinha com os princípios?
4. Se CONSELHO_SESSAO_[date].md existir na raiz → ler antes de deliberar
```

---

## PRINCÍPIOS ATIVOS

Princípios extraídos de fricções reais. Cada um tem evidência — não é teoria.

---

### [P-001] Claude Code ≠ Daemon Autônomo
**Descoberto:** 2026-05-12 | **Sessão:** V24 Setup
**Evidência:** Estrategista propôs que Claude Code "monitore pastas e inicie codificação automaticamente". Físicamente impossível — Claude Code exige sessão humana. Arquitetura correta usa Claude API via n8n.
**Princípio:** Toda proposta de "execução autônoma" deve especificar Claude API + n8n, nunca Claude Code como daemon.
**Aplica-se a:** qualquer DIRETRIZ que mencione automação, monitoramento contínuo, ou "Claude que age sozinho".

---

### [P-002] VEREDITO BINÁRIO não é burocracia universal
**Descoberto:** 2026-05-12 | **Sessão:** V24 Setup
**Evidência:** Protocolo criado para decisões com divergência real. Risco de virar overhead em decisões óbvias.
**Princípio:** Emitir VEREDITO BINÁRIO apenas quando há divergência técnica real entre duas abordagens. Decisões com clareza >90% → Plano de Build direto.
**Aplica-se a:** toda sessão de deliberação técnica.

---

### [P-003] Scraping de terceiros é dependência, não ativo
**Descoberto:** 2026-05-12 | **Sessão:** Análise SEDES-DF (descartada)
**Evidência:** Proposta de scraping QConcursos viola ToS e cria dependência de terceiro. IP some se API muda.
**Princípio:** Nunca construir sobre dados de terceiros sem acordo formal. Ativo de IP = dados gerados pelo nosso sistema.
**Aplica-se a:** qualquer proposta envolvendo scraping, integração não-oficial, ou dados de plataformas externas.

---

### [P-004] O primeiro cliente não vem do site — vem de uma ligação
**Descoberto:** 2026-05-12 | **Sessão:** Discussão site V24
**Evidência:** GUT do site reformulado = 12. GUT de prospectar.ps1 esta semana = 125. O site é importante, mas não é o caminho para o primeiro real.
**Princípio:** Melhorias de posicionamento (site, design) têm GUT baixo enquanto há 0 clientes. Só sobem na prioridade após o primeiro MRR confirmado.
**Aplica-se a:** qualquer proposta de redesign, branding, ou melhorias de funil antes do primeiro cliente.

---

### [P-006] Precificação de serviço deve ser calculada por ROI do cliente, não por feeling
**Descoberto:** 2026-05-12 | **Sessão:** PROJETO_001 — Valdece
**Evidência:** Primeiro cliente real (Valdece, advogado penal) propôs R$5.000 pela ferramenta. Cálculo GUT de aceitar vs. renegociar = 75 (G:5 · U:5 · T:3). ROI calculado para o cliente: ferramenta economiza ~20h/mês × R$200/h = R$4.000/mês de dívida de tempo. Payback em 1,25 meses. Valor justo de mercado: R$12.000–18.000.
**Princípio:** Antes de aceitar qualquer preço de cliente, rodar o algoritmo: (horas_perdidas × valor_hora_cliente) × 12 = valor_anual_gerado. Preço justo = 10–25% do valor anual gerado. Se o cliente propôs abaixo disso, aceitar apenas com contrapartida (% de MRR, cláusula de referência, ou direito de case público).
**Aplica-se a:** toda proposta de precificação de projeto cliente.

---

### [P-005] Inteligência acumulada por sessão, não por versão
**Descoberto:** 2026-05-12 | **Sessão:** V24 Intelligence Engine
**Evidência:** 23 versões aprenderam, mas o aprendizado ficou preso em MEMORIAs que descrevem "o que foi feito", não "o princípio descoberto". Lag de semanas entre fricção e princípio.
**Princípio:** Todo ALERTA emitido, toda fricção, todo override do Diretor → capturado imediatamente neste LEDGER. O princípio é extraído na mesma sessão, não na próxima versão.
**Aplica-se a:** toda sessão do Quadrilateral.

---

### [P-009] Número de loops evolutivos é proporcional à amplitude do projeto
**Descoberto:** 2026-05-13 | **Sessão:** PROJ-001 — Valdece / Calibração do processo
**Evidência:** Diretor identificou que loops em excesso num projeto pequeno geram ruído, não inteligência. Loops insuficientes num projeto grande geram deriva sem correção de rota.
**Princípio:** A cadência do loop Músculo→Gemini→NotebookLM→Músculo é calibrada pela Camada do projeto, não pelo calendário. Cada loop consome tempo do Diretor e dos membros — deve acontecer quando há output real suficiente para deliberar.

| Camada | Escopo | Prazo | Loops totais | Cadência |
|---|---|---|---|---|
| 1 — MVP | Protótipo funcional | 1–5 dias | 2–3 loops | Início + meio do build + fechamento |
| 2 — Produto | Produto completo | 1–3 semanas | 4–6 loops | 1 loop por semana de build |
| 3 — Plataforma | IA, dados, automação | 2–6 semanas | 6–10 loops | 1 loop por sprint (3–5 dias) |
| 4 — Ecossistema | Multi-tenant, marketplace | 1–3 meses | 10–16 loops | 2 loops por semana |
| 5 — Monopólio | Ativo de setor | 3–6 meses | 20–30 loops | Loop semanal fixo |

**Regra de ouro:** Loop acontece quando há output real para deliberar — gate passado, módulo entregue, decisão de arquitetura tomada, cliente reagindo. Nunca por calendário fixo sem evidência nova.
**Aplica-se a:** todo projeto gerido pelo Quadrilateral. Definir o número de loops no Passo 7 (aprovação do plano).

---

### [P-008] Primeiro cliente com produto soberano vale mais que MRR
**Descoberto:** 2026-05-13 | **Sessão:** PROJ-001 — Valdece / Decisão Opção A
**Evidência:** Valdece pediu sistema sem mensalidade que se atualize sozinho. Diretor escolheu Opção A: produto na infra do cliente, corpus auto-atualiza por R$0,22/mês, zero vínculo. Raciocínio: "Com o melhor sistema possível, ele será nossa propaganda."
**Princípio:** O primeiro cliente de um nicho não é fonte de MRR — é canal de distribuição. Um advogado satisfeito em uma sala da OAB fala com 50 colegas. Entregar soberania total elimina objeção de churn e transforma o cliente em vendedor ativo. Cada indicação = R$3.000–5.000 de novo projeto com o mesmo codebase. MRR vem na V2, quando o cliente já está dependente e pede mais.
**Aplica-se a:** qualquer primeiro cliente de nicho com comunidade profissional densa (advogados, médicos, contadores, engenheiros).

---

### [P-010] Verificar em cada etapa antes de avançar
**Descoberto:** 2026-05-13 | **Sessão:** PROJ-001 — Valdece / Padrão de execução
**Evidência:** Diretor identificou que o Gate Semântico do Dia 3 não é apenas uma validação técnica — é a expressão de um padrão universal: nenhuma etapa avança por momentum, só por verificação explícita. "A cada etapa, temos que sempre verificar."
**Princípio:** Cada etapa do build tem um checkpoint obrigatório antes da próxima começar. Verificar não é "parece que funciona" — é executar e ver o output real.

| Camada | Checkpoint obrigatório |
|---|---|
| Dia → próximo dia | Gate: output funcionando ou explicação de por que não |
| Módulo → integração | Teste isolado antes de conectar ao sistema |
| Build → commit | Code review próprio do Músculo |
| Entrega → cliente | Teste com dado real do cliente, não dado de mock |
| Iteração → loop | MEMORIA + relatorio_evolutivo gerados e revisados |
| Proposta → execução | Veredito explícito do Diretor — nunca iniciar sem aprovação |

**Por que importa:** Avançar por assumição é o padrão de falha mais comum em build rápido. Uma UI bonita sobre corpus ruim é fachada. Um commit sem review é débito técnico disfarçado de velocidade. O Gate valida — o produto entrega.
**Aplica-se a:** todo projeto do Quadrilateral, toda etapa de build, toda entrega a cliente.

---

### [P-013] Soberania do Cliente não é promessa — é pré-requisito de build
**Descoberto:** 2026-05-14 | **Sessão:** Identidade Vanguard — Missão, Visão e Valores
**Evidência:** Pilar "Soberania Absoluta do Cliente" aprovado pelo Conselho como valor fundacional. Risco identificado: sem um veto formal, projetos podem ser entregues com infra dependente do Vanguard por omissão — não por intenção. Um Supabase project sob conta Vanguard = cliente refém, independente do que a proposta comercial prometeu.
**Princípio:** Antes do Dia 1 de qualquer build, checklist de soberania deve estar completo:
  1. Projeto Supabase criado na conta/org do CLIENTE (não do Vanguard)
  2. Cliente tem acesso admin ao próprio projeto
  3. OFFBOARDING_RUNBOOK.md criado no repositório com: instruções de export, remoção do Vanguard como colaborador, e lista de API keys transferíveis
  4. Nenhuma API key exclusiva do Vanguard sem equivalente documentado para o cliente
**Corolário comercial:** O OFFBOARDING_RUNBOOK.md é o maior argumento anti-churn do portfólio. O cliente que vê "como me demitir em 30 minutos" no handoff não cancela — porque sente confiança, não prisão.
**Aplica-se a:** todo projeto cliente, sem exceção. Ativado como [HV-6] na Constituição de Processo.

---

### [P-007] Template colado em IA = alucinação estrutural
**Descoberto:** 2026-05-13 | **Sessão:** PROJETO_001 — Valdece / Padronização do Quadrilateral
**Evidência:** Criamos templates de comunicação com campos `[entre colchetes]`. Diretor identificou que colar isso diretamente no Gemini faz ele preencher os campos mecanicamente sem deliberar sobre o projeto real — alucina na estrutura em vez de pensar no contexto.
**Princípio:** Templates são referência para o Músculo escrever documentos completos — nunca scripts para colar em IAs. O Músculo lê o template + lê o contexto real + escreve o documento pronto. A IA recebe contexto, não formulário.
**Aplica-se a:** qualquer comunicação com Gemini, NotebookLM ou qualquer outro modelo — COMANDO 1, COMANDO 2, qualquer prompt estruturado.

---

### [P-014] Score de Incidência Histórica como variável de priorização em EdTech concursos
**Descoberto:** 2026-05-15 | **Sessão:** PROJ-002 — Ingrid / Loop 1 Kickoff
**Ideia de:** Eduardo (Diretor) — Loop 1
**Evidência:** O edital do concurso Sedes-DF define pesos por disciplina (Peso 1 / Peso 2), mas não reflete frequência histórica de cobrança. Algoritmo criado: `score_prioridade = peso_edital × incidencia_historica_pct`. Resultado: SUAS com score 196 vs Primeiros Socorros com score 50 — diferença de 3,9× que não aparece na leitura linear do edital.
**Princípio:** Em todo produto EdTech para concursos públicos, o feed de estudo deve ser organizado por `score_prioridade`, não pela ordem do edital. Disciplina com peso 2 e baixa incidência histórica < disciplina com peso 1 e alta incidência histórica. O candidato que segue o edital linearmente perde para quem segue a frequência real de cobrança.
**Aplica-se a:** todo projeto EdTech de concurso público com histórico de provas disponível. Registrar `incidencia_historica_pct` como campo obrigatório no schema de disciplinas.

---

### [P-015] Análise cross-concurso como método de calibração para primeiras edições
**Descoberto:** 2026-05-15 | **Sessão:** PROJ-002 — Ingrid / Loop 1 Kickoff
**Ideia de:** Eduardo (Diretor) — Loop 1
**Evidência:** SEDES-DF 2026 (Quadrix) não tem histórico direto — é o primeiro concurso desta banca neste órgão. Gap de 8 anos desde o último concurso (2018, banca IBRAE). Workaround aplicado: triangular com provas Quadrix similares (SEDF 2022, CFP 2024, CRQ-12 2024, CRT-01 2024) + análise de top-6 temas nacionais de assistência social (SUAS, LOAS, PNAS, CRAS/CREAS).
**Princípio:** Quando concurso não tem histórico direto da mesma banca no mesmo cargo: (1) usar provas da banca em cargos similares, (2) usar concursos do mesmo cargo em bancas diferentes, (3) usar ranking nacional do tema. Nunca deixar `incidencia_historica_pct` vazio — estimar com fonte declarada explicitamente. Incerteza declarada é melhor que ausência de dado.
**Corolário de IP:** O banco de dados Provas×Editais, quando construído sistematicamente, vira ativo proprietário do Vanguard — impossível de replicar por concorrente sem as mesmas fontes e o mesmo trabalho manual de classificação.
**Aplica-se a:** todo projeto EdTech para concurso sem histórico direto. Documentar as fontes cruzadas em `provas_referencia` no schema.

---

### [P-016] Podcast como canal de retenção passiva em EdTech (recurso V2)
**Descoberto:** 2026-05-15 | **Sessão:** PROJ-002 — Ingrid / Loop 1 Kickoff
**Ideia de:** Eduardo (Diretor) — Loop 1
**Evidência:** Proposta de criar áudio para Ingrid ouvir durante commuting, exercício, tarefas domésticas. Análise: viável com geração de roteiro via Claude API + TTS nativo do browser (Web Speech API) sem custo extra. Nenhum app de concurso entrega áudio proprietário gerado por IA.
**Princípio:** Em produtos EdTech de Camada 2+, adicionar canal de áudio como V2 após validação do MVP visual. Sequência: roteiro → TTS → reprodução in-app. O candidato que estuda em estado passivo (ouvindo) retém ~50% do conteúdo com zero custo cognitivo adicional. Feature premium natural: plano básico = texto, plano premium = áudio do dia gerado por IA.
**Restrição:** Nunca usar scraping ou TTS de conteúdo de terceiros (P-003). Roteiro sempre gerado pela API sobre conteúdo proprietário do edital_sedes.json.
**Aplica-se a:** todo projeto EdTech Camada 2+. Não entra no MVP — entra no V2 após Dia 15 com output real validado.

---

### [P-017] Infraestrutura de e-mail do Conselho — nunca reconfigurar do zero
**Descoberto:** 2026-05-16 | **Sessão:** PROJ-002 Ingrid / Dias 1-2
**Evidência:** Diretor não sabia onde estava registrada a infraestrutura de e-mail estabelecida numa sessão anterior. Sistema existia mas não estava documentado no LEDGER — risco de retrabalho ou reconfiguração desnecessária.
**Princípio:** A infraestrutura de comunicação do Conselho com o Diretor está em:
- `scripts/alert_config.ps1` — credenciais Gmail (senha de app + destinatário)
- `scripts/email_fechamento.ps1` — envia e-mail de fechamento de sessão
- `scripts/alert_teste_email.ps1` — teste do sistema
O Músculo aciona `email_fechamento.ps1` ao fechar qualquer sessão. Nunca recriar ou alterar `alert_config.ps1` sem instrução explícita do Diretor.
**Aplica-se a:** toda sessão do Quadrilateral — qualquer projeto, qualquer cliente.

---

### [P-018] O Diretor é o 4º LLM — Orquestração Dinâmica de Deficiências como Vantagem Competitiva
**Descoberto:** 2026-05-16 | **Sessão:** Opinião Consultora #01 — construção colaborativa Diretor + Músculo
**Evidência:** Ao construir a Ideia Disruptiva da Opinião #01, Eduardo articulou: a vantagem real do Quadrilateral não é usar IA — é saber usar a deficiência de cada IA contra a deficiência das outras. Gemini alucina com otimismo → Claude âncora com custo real. Claude tem amnésia → NotebookLM âncora com histórico. NotebookLM valida por momentum → Eduardo rejeita sem os 4 blocos. O sistema é anti-frágil porque foi desenhado em torno de fraquezas conhecidas, não apesar delas.
**Princípio:** O Quadrilateral tem três funções constitucionais separadas. Os 3 LLMs são a válvula motriz com **comportamento ativo** — não passivo. Estão em looping evolutivo permanente: geram ideias, combatem as deficiências uns dos outros, acumulam padrões ciclo a ciclo, protegidos por firewalls persistentes (contra-ataques de deficiência estruturalmente embutidos, não dependentes de memória). O Diretor contribui com opiniões nascidas da experiência acumulada e do feeling instintivo — analisadas pelos 3 LLMs e evoluídas por eles. Ao final, dá o Veredito soberano. A cada etapa, a cada processo, a cada projeto, o sistema fica mais inteligente e os processos mais definidos — acumulação exponencial que torna o modelo de negócio imbatível.
**Aplica-se a:** toda proposta de substituir o processo por execução direta ou reduzir a tensão entre os LLMs. O comportamento ativo e o looping cíclico são a fonte da vantagem composta. Reduzir a tensão é reduzir a inteligência. Os firewalls persistentes não são burocracia — são o que impede a deriva silenciosa que mata sistemas complexos.

---

### [P-019] IAH Retainer não se vende sem MRR confirmado — Soft Veto ativo
**Descoberto:** 2026-05-16 | **Sessão:** Análise do Auditor sobre Opinião Consultora #01
**Evidência:** Auditor identificou, com base na V22, que propor IAH Retainer (modelo de receita recorrente de Conselho) antes do primeiro MRR real é vender método sem credencial. O argumento "pagamos por si mesmo" é especulativo sem um case de antes/depois mensurável. O Auditor ainda apontou risco de percepção: cliente assina retainer por confiança, não por prova — e cancela quando não vê ROI tangível.
**Princípio:** IAH Retainer só é ofertado após: (1) pelo menos 1 projeto cliente entregue e pago na íntegra, (2) pelo menos 1 case documentado com ROI mensurável para o cliente, (3) o cliente já ter vivenciado pelo menos 1 ciclo completo do Conselho. Ofertar antes é vender expectativa — e expectativa sem prova é argumento fraco que gera churn acelerado.
**Soft Veto [SV-6] ativo:** Qualquer proposta de oferta de IAH Retainer → flag + revisão obrigatória antes de apresentar ao cliente. Override requer: case documentado com ROI + aprovação explícita do Diretor.
**Aplica-se a:** toda proposta comercial que inclua IAH Retainer como pacote de entrada ou produto isolado.

---

## PADRÕES CONFIRMADOS

O que sistematicamente funciona — com evidência de projeto real.

| Padrão | Confirmado em | Condição de aplicabilidade |
|---|---|---|
| Schema granular desde o Dia 1 | V13-V23 | Todo projeto com dados comportamentais |
| Burn Rate Shield antes de features de IA | V15-V23 | Todo projeto com custo variável de API |
| Kill-Switch com 72h grace period | V6-V23 | Todo projeto SaaS com billing |
| COMANDO_ESTRATEGISTA fecha o loop Gemini↔Claude | V12-V23 | Todo ciclo PDCA completo |
| Freemium by Design desde Camada 1 | V16-V23 | Todo projeto com camadas de upgrade |

---

## PADRÕES REFUTADOS

O que sistematicamente falha — com evidência de projeto real.

| Padrão | Refutado em | Por que falha |
|---|---|---|
| Build de feature antes de billing | V1-V5 | Refatoração pesada quando Stripe é plugado depois |
| Marketplace com split manual | V7 | Compliance, IOF, responsabilidade legal em escala |
| Automação sem logs estruturados | V9-V11 | Falha silenciosa — impossível auditar ou debugar |
| Proposta de parceria sem case documentado | V23 | Argumento fraco — parceiro arrisca relação com cliente |

---

## CONSTITUIÇÃO DE PROCESSO — VETO DO MÚSCULO

### Hard Veto (bloqueia execução — override explícito do Diretor obrigatório)

```
[HV-1] Credencial hardcoded no código
[HV-2] PII sem consentimento auditável (LGPD/GDPR)
[HV-3] Custo acima de BURN_RATE_DAILY_LIMIT sem aprovação
[HV-4] Dívida P0 ativa sem plano de resolução nesta sessão
[HV-5] Breaking change em sistema com cliente ativo sem kill-switch
[HV-6] Infra Prisioneira — build sem: (a) acesso admin do cliente ao próprio Supabase,
        (b) API keys documentadas e transferíveis, (c) OFFBOARDING_RUNBOOK.md no repositório
```

### Soft Veto (flag + 1 sessão de cooling antes de executar)

```
[SV-1] Stack nova sem inventário de soluções existentes
[SV-2] Feature que contradiz princípio ativo neste LEDGER
[SV-3] Acumulação de >3 dívidas P1 no mesmo componente
[SV-4] DIRETRIZ com >5 prioridades (foco perdido = entrega fraca)
[SV-5] Proposta de Claude Code como daemon autônomo [ver P-001]
[SV-6] Oferta de IAH Retainer sem MRR confirmado e case documentado [ver P-019]
```

### Protocolo de Override

```
DIRETOR OVERRIDE — [HV-X ou SV-X]
Aceito o risco de [descrição do risco] porque [justificativa].
Consequência esperada documentada: [o que pode acontecer].
```

O Músculo executa, documenta o override neste LEDGER como `[OVERRIDE]`, e monitora a consequência nas sessões seguintes.

---

## SHADOW ARCHITECT — Template Obrigatório

Todo PLANO DE BUILD inclui esta seção antes da execução:

```
[SHADOW ANALYSIS] — [nome do módulo]

Blast radius se falhar em produção:
  → [o que quebra, quem é afetado, reversibilidade]

Harder fix se errarmos a arquitetura agora:
  → [o que seria mais difícil de consertar depois]

Cenário 1000x (escala):
  → [como se comporta com 1000x o volume atual]

Ponto de falha mais provável:
  → [onde vai quebrar primeiro e por quê]

Avaliação: APROVADO / REQUER AJUSTE / BLOQUEADO
```

---

## LOG DE SESSÕES

### [SESSÃO 2026-05-16] — Evolução Constitucional · Opinião Consultora #01 · P-018

**Direção da sessão:** Sessão inteiramente filosófica e constitucional. Nenhum build executado. Foco em clarificar e documentar a arquitetura de papéis do Quadrilateral IAH com precisão crescente — através de refinamentos sucessivos propostos pelo Diretor.

**Eventos capturados:**

`[PRINCÍPIO]` **P-018 extraído e refinado iterativamente:** O Diretor é o Gestor Soberano — contribui com opiniões nascidas da experiência acumulada e do feeling instintivo, analisadas pelos 3 LLMs. Dá o Veredito. Os 3 LLMs são a válvula motriz em looping evolutivo ativo, com firewalls persistentes estruturalmente embutidos.

`[INTENÇÃO]` Diretor clarificou em 4 iterações o seu papel preciso: não operador, não co-autor das ideias — Gestor Soberano que ergueu o processo, gerencia, pontua o que é pertinente e dá o Veredito. A evolução sempre será a inteligência que os 3 LLMs conceberam.

`[PRINCÍPIO]` **Automação Cíclica** nomeada como diferencial central da Vanguard: o loop Músculo→Gemini→NotebookLM→Músculo é o que torna o sistema exponencialmente mais difícil de copiar a cada ciclo.

`[CONFIRMADO]` **PARADIGMA v3.0** inserido na Constituição: Conselho em Looping Evolutivo Ativo — comportamento ativo (não passivo), firewalls persistentes, acumulação exponencial, modelo de negócio progressivamente imbatível.

`[CONFIRMADO]` Opinião Consultora #01 concluída com Ideia Disruptiva completa: 3 LLMs como Conselho Evolutivo + papel preciso do Diretor + vantagem composta + IAH Retainer como produto empacotável.

`[FRICÇÃO]` Refinamento do papel do Diretor exigiu 4 iterações para chegar à definição precisa. Cada iteração o Diretor corrigiu com uma palavra ou frase mais exata: operador → orquestrador → gerencia → opiniões analisadas. Evidência de que o processo de refinamento colaborativo entre Diretor e Músculo é o próprio P-018 em ação.

**Documentos atualizados nesta sessão:**
- `CONSELHO/OPINIAO_CONSULTORA_01_2026-05-16.md` — completa, com Ideia Disruptiva e papel constitucional do Diretor
- `INTELLIGENCE_LEDGER.md` — P-018 extraído e refinado
- `CLIENTES/INGRID/NOTEBOOKLM_FONTES/04_INTELLIGENCE_LEDGER.md` — sincronizado
- `QUADRILATERAL_UNIVERSAL/CONSTITUICAO/MEMORANDO_QUADRILATERAL_UNIVERSAL.md` — PARADIGMA v3.0 + tabela OS 4 MEMBROS + Manifesto atualizados
- `.claude/skills/vanguard-memorando.md` — sincronizado
- `CLIENTES/INGRID/NOTEBOOKLM_FONTES/01_SKILL_PROTOCOLO_VANGUARD.md` — PARADIGMA v3.0 inserido
- `CLAUDE.md` — QUEM VOCÊ É: Músculo como Agente Ativo

**Princípios gerados nesta sessão:** P-018

**Próximo passo:** Sessão Gemini com Opinião Consultora #01 — reação do Estrategista às 3 ideias principais + IAH Retainer. Segunda-feira: onboarding presencial PROJ-001 Valdece.

---

### [SESSÃO 2026-05-13] — PROJETO_001 · Dia 1 commit + Dia 2 corpus pipeline · Valdece

**Direção da sessão:** Execução do build Dia 1 (commit ef3f1cd) e Dia 2 do projeto Valdece. WIP_BOARD movido de discovery → build. Corpus pipeline Python criado com Mágico de Oz gate.

**Eventos capturados:**

`[CONFIRMADO]` Padrão "Token Rate Shield antes de features IA" aplicado: ingest.py inclui estimativa de custo + confirmação do usuário antes de chamar API Gemini. Conforme P-003 e P-006 do LEDGER.

`[PADRÃO NOVO]` **Mágico de Oz Gate**: Validar busca semântica via CLI (search_cli.py) antes de construir UI. Se CLI não retornar resultados relevantes → corpus ruim → parar build antes de investir em frontend. Candidato a PADRÃO CONFIRMADO após Dia 2 ser completado com sucesso.

`[INTENÇÃO]` Diretor reforçou: "Precisamos do processo evolutivo rodando, esse é o nosso diferencial." → Músculo deve registrar cada padrão emergente de projeto real neste LEDGER na mesma sessão.

`[FRICÇÃO]` Sessão foi interrompida (context compaction) após criação do kill_switch.js — commit do Dia 1 ainda não havia sido feito. Retomada nesta sessão com commit imediato.

**Princípios candidatos desta sessão:**

- **P-007 (candidato):** "Mágico de Oz Gate" — validar motor semântico CLI antes de UI. Corpus ruim não melhora com UI bonita.
- **P-008 (candidato):** "Context compaction = risco de perda de estado" — qualquer sessão longa deve ter checkpoint git de cada Dia de build antes de continuar.

**Confirmar em próxima sessão se padrões viraram princípios.**

**Princípios ativos aplicados:** P-003 (sem scraping intrusivo — STF Open Data público), P-006 (custo estimado antes de executar).

---

### [SESSÃO 2026-05-12] — V24 Intelligence Compounding Engine

**Direção da sessão:** Construção da inteligência evolutiva do Quadrilateral — sistema de acumulação por sessão.

**Eventos capturados:**

`[FRICÇÃO]` Estrategista propôs Claude Code como daemon → Músculo vetou → Princípio P-001 extraído.

`[FRICÇÃO]` Sessão SEDES-DF aberta e descartada pelo Diretor ("foi errado, tudo") → Foco retornou ao projeto modelo.

`[PRINCÍPIO]` P-002 extraído: VEREDITO BINÁRIO é protocolo, não burocracia universal.

`[PRINCÍPIO]` P-004 extraído: site reformulado tem GUT 12 vs prospecção GUT 125 com 0 clientes.

`[INTENÇÃO]` Diretor declarou "inteligência evolutiva" como foco V24 → intenção real detectada: não features de produto, mas composição exponencial do conhecimento do sistema.

`[DERIVA]` Sessão quase divergiu para redesign do site (GUT baixo) → Músculo sinalizou → Diretor manteve foco em inteligência.

**Princípios gerados nesta sessão:** P-001, P-002, P-003, P-004, P-005

**Override do Diretor:** V24 aberta antes do primeiro cliente (override da regra V23). Aceito. Motivo: "construção de inteligência é o maior ativo". Documentado.

### [SESSÃO 2026-05-12] — PROJETO_001 · Primeiro Case Real · Valdece

**Direção da sessão:** Discovery completo com cliente Valdece (advogado penal). Ativação do PROTOCOLO VANGUARD para ferramenta de busca semântica de jurisprudências STF/STJ.

**Eventos capturados:**

`[INTENÇÃO]` Diretor declarou: "Tudo o que for gravado nesse nosso primeiro projeto é primordial." → Projeto Valdece = caso de sucesso fundacional do modelo IAH.

`[PRINCÍPIO]` P-006 extraído: precificação deve ser calculada por ROI do cliente, não por feeling. R$5.000 proposto pelo cliente = abaixo do mercado (valor justo: R$12k–18k). Decisão: aceitar com contrapartida de % MRR do SaaS do cliente.

`[FRICÇÃO]` Músculo entrou na Etapa 4 (build) antes da Etapa 2 (Gemini) e Etapa 3 (NotebookLM). Corrigido após sinalização do Diretor.

`[FRICÇÃO]` Processo do Quadrilateral não estava claro para o Diretor — revisão completa feita e documentada em sessão.

`[CONFIRMADO]` Algoritmo de qualificação BLOCO A funcionou: 3 respostas fortes = GO imediato. Prazo de 5 dias confirmado como restrição real, não negociável.

**Próximos passos em aberto:** COMANDO 1 → Gemini → DIRETRIZ · COMANDO 2 → NotebookLM → SKILL · Build 5 dias

**Princípios gerados nesta sessão:** P-006

---

### [SESSÃO 2026-05-15 — Loop 1 Build Deliberation] — PROJ-002 Ingrid / Deliberação Completa

**Direção da sessão:** Completar o Loop 1 do PROJ-002 Ingrid — deliberação do Músculo com a Skill do Auditor e a DIRETRIZ do Gemini. Construção do edital_sedes.json com score de incidência. Pesquisa de provas anteriores Quadrix + SEDES-DF. Registro das ideias do Diretor Eduardo.

**Eventos capturados:**

`[FRICÇÃO]` PASSO3_GEMINI.md não continha mandato explícito para o Gemini instruir o Auditor a criar a Skill em 4 partes. Corrigido: mandato embedded no [PARA O AUDITOR] de todos os PASSO3 — Gemini passa o nome exato da Skill e as 4 partes obrigatórias.

`[FRICÇÃO]` PASSO6_MUSCULO.md não continha sequência explícita para o Músculo: (a) reagir às 5 ideias do Estrategista, (b) reagir às 5 ideias do Auditor, (c) propor as próprias 5 ideias. Corrigido com sequência A-H formal.

`[PRINCÍPIO]` **P-014 extraído:** Score de Incidência Histórica — `score_prioridade = peso_edital × incidencia_historica_pct`. Mais poderoso que seguir o edital literalmente. Ideia do Diretor.

`[PRINCÍPIO]` **P-015 extraído:** Cross-concurso como método de calibração para primeiras edições — SEDES-DF 2026 não tem histórico Quadrix. Triangular com CFP 2024, SEDF 2022, CRQ-12 2024.

`[PRINCÍPIO]` **P-016 extraído:** Podcast como canal de retenção passiva — V2 feature. Roteiro → TTS → audio do dia. Nenhum app de concurso entrega isso. Ideia do Diretor.

`[CONFIRMADO]` Arquitetura multi-tenant validada: `questoes_quadrix` (global + concurso_id) + `progresso_usuario` (por user_id). Evita refatoração massiva quando escalar para B2C SaaS.

`[CONFIRMADO]` Gap SEDES-DF confirmado por pesquisa: último concurso foi 2018 (banca IBRAE, não Quadrix). Este 2026 é o primeiro concurso Quadrix neste órgão. Cross-concurso obrigatório.

`[FRICÇÃO]` Skill do Auditor chegou sem blocos PARTE 1 e PARTE 2 completos no arquivo `.claude/skills/`. Eduardo colou manualmente. Gate de qualidade `skill_parser_gate.ps1` deve ser rodado antes de aceitar qualquer Skill.

`[CODE REVIEW]` `edital_sedes.json`: questoes_estimadas somavam 21 (gerais) e 45 (específicos) — corrigido para 20 e 40. Bug identificado e corrigido no mesmo loop.

`[INTENÇÃO]` Diretor: "Quero mostrar esse relatório para a minha esposa, para ela observar o nosso poder conjunto." → Relatório final do Loop 1 deve ser legível por Ingrid — não só técnico, mas narrativo e motivacional.

**Princípios gerados nesta sessão:** P-014, P-015, P-016

**Princípios aplicados:** P-003 (sem scraping), P-007 (CLI gate), P-010 (gate por etapa), P-013 (soberania)

**Documentos atualizados nesta sessão:**
- `CLIENTES/INGRID/edital_sedes.json` — score incidência + pesquisa + D-5 + achados
- `CLIENTES/INGRID/PASSO3_GEMINI.md` — mandato Skill explícito
- `QUADRILATERAL_UNIVERSAL/OPERACAO/PASSO3_GEMINI_TEMPLATE.md` — idem universal
- `CLIENTES/INGRID/PASSO6_MUSCULO.md` — sequência A-H formal
- `CLIENTES/INGRID/DIRETRIZ_GEMINI_V1.txt` — DIRETRIZ completa 7 blocos
- `CLIENTES/WIP_BOARD.json` — PROJ-002 movido para build
- `INTELLIGENCE_LEDGER.md` — P-014, P-015, P-016 + log desta sessão

---

### [SESSÃO 2026-05-15] — V25 Migration + PROJ-002 Ingrid Kickoff

**Direção da sessão:** Implantação da V25 (3 Alavancas), correção de encoding no Windows, criação da estrutura completa do PROJ-002 Ingrid, atualização dos documentos universais.

**Eventos capturados:**

`[PRINCÍPIO]` **P-011 confirmado (e-mail como meio oficial):** Ao fechar atividades, deliberações ou entregas importantes, gerar rascunho de e-mail. Mensagem no chat não substitui comunicação formal por e-mail.

`[PRINCÍPIO]` **Encoding UTF-8 obrigatório no Windows:** `write_text()` sem `encoding='utf-8'` quebra silenciosamente em Python 3.13+ no Windows (cp1252 padrão). Corrigido em ledger.py, veto.py, session_close.py, clone_project.py. 17/17 testes passando após fix.

`[FRICÇÃO]` Diretor confundiu Claude Projects / Claude API / Claude Code — três produtos completamente diferentes. Explicação documentada: Projects é UI opcional, API é o que auditor.py usa internamente, Code é o Músculo no terminal.

`[CONFIRMADO]` V25 é ADIÇÃO, não substituição. Zero arquivos deletados. NotebookLM + Gemini + Claude Code continuam exatamente como nas 23 versões anteriores.

`[CONFIRMADO]` Estrutura `CLIENTES/INGRID/` criada com BRIEFING_DISCOVERY.txt, PASSO3_GEMINI.md, PASSO5_NOTEBOOKLM.md, PASSO6_MUSCULO.md, CONSELHO/DECISOES_PENDENTES.md.

`[DECISÃO A — PROJ-002]` Fonte de questões = Claude API gerando estilo Quadrix. Descartado: scraping TEC Concursos (viola ToS, cria dependência, risco de ban da conta).

`[FRICÇÃO]` PDF do edital Sedes-DF não pôde ser extraído via WebFetch (binário). Workaround: Gemini pesquisa padrão Quadrix — instrução incluída no PASSO3_GEMINI.md.

`[INTENÇÃO]` Diretor: "Fizemos 23 versões até chegar nisso. Não posso arriscar perder esse trabalho de noites e noites." — Trabalho protegido em git history. V25 é adição, não risco.

**Princípios aplicados:** P-003 (sem scraping), P-007 (CLI gate antes de UI), P-010 (gate por etapa), P-013 (soberania do cliente).

**Projetos ativos após esta sessão:**
- PROJ-001 Valdece: build completo, aguardando Dia 5 presencial com cliente
- PROJ-002 Ingrid: kickoff completo, PASSO3_GEMINI.md pronto para Gemini

---

## GLOSSÁRIO DO LEDGER

| Marcação | Significado |
|---|---|
| `[FRICÇÃO]` | Momento de resistência — ALERTA emitido, pushback, mudança de escopo |
| `[PRINCÍPIO]` | Padrão extraído de fricção real — lei do sistema |
| `[SOMBRA]` | Output do Shadow Architect — análise adversarial |
| `[DERIVA]` | Sessão divergindo de princípio ativo — sinalizado pelo Skill-Drift |
| `[INTENÇÃO]` | Intenção real detectada vs. declarada |
| `[OVERRIDE]` | Diretor ativou protocolo de override de veto |
| `[CONFIRMADO]` | Padrão confirmado por resultado real |
| `[REFUTADO]` | Padrão que sistematicamente falha |
