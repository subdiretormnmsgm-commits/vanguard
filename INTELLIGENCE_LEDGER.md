# INTELLIGENCE LEDGER — Pentalateral IAH
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

---

### [P-020] Alucinação do Auditor deve ser registrada no LEDGER imediatamente
**Descoberto:** 2026-05-16 | **Sessão:** Auditoria de processo
**Evidência:** Auditor afirmou "PROJ-002 parou porque o Diretor não preencheu o .env". Eduardo confirmou que isso não ocorreu. O incidente não foi registrado no LEDGER. Sem registro, o Auditor pode re-invocar a mesma alucinação como "histórico" no próximo loop.
**Princípio:** Toda alucinação identificada do Auditor deve ser registrada no LEDGER com tag `[ALUCINACAO-Auditor-YYYY-MM-DD]` e contradita com a realidade documentada. Sem registro → a alucinação vira "memória" e contamina o próximo ciclo.
**Aplica-se a:** toda sessão com NotebookLM.

```
[ALUCINACAO-Auditor-2026-05-16]
Afirmação inventada: "PROJ-002 Ingrid parou porque Diretor não preencheu o .env"
Realidade: Dias 1-2 foram completados normalmente — schema + Edge Function + gate CLI aprovado
Causa provável: Auditor não tinha os commits e MEMORIA_V1_INGRID nas fontes antes de auditar
Prevenção: incluir MEMORIA mais recente como fonte 10 no próximo ciclo do NotebookLM
```

---

### [P-021] O Diretor é o originador da direção estratégica — não apenas o aprovador
**Descoberto:** 2026-05-16 | **Sessão:** Auditoria de processo + fechamento do dia
**Evidência concreta:** Eduardo identificou 5 falhas que o Músculo não detectou. Eduardo originou a necessidade do contrato com clientes. Eduardo propôs o uso do NotebookLM como auditor jurídico (advogado do processo). Todas estas inovações vieram do Diretor, não do Conselho.
**Princípio:** O Músculo implementa. O Gemini propõe estratégia. O NotebookLM audita o histórico. Mas a **direção estratégica e as inovações de processo** vêm de Eduardo. Quando o Diretor propõe algo novo — contrato, nova função para um membro do Conselho, nova regra — essa proposta tem peso maior do que qualquer saída dos membros. O sistema existe para amplificar a inteligência do Diretor, não substituí-la.
**Corolário:** O Músculo que não detectou uma falha antes do Diretor deve perguntar: "Por que meu sistema de auto-proteção falhou aqui?" e gerar ferramenta. O Diretor não deve ser o detector primário de falhas de processo — quando é, o sistema falhou.
**Aplica-se a:** toda interação. O Quadrilateral é um amplificador da inteligência de Eduardo — não uma cadeia autônoma que o Diretor apenas valida.

---

### [P-022] NotebookLM como advogado do processo — auditor jurídico do Quadrilateral
**Descoberto:** 2026-05-16 | **Proposto por:** Eduardo (intervenção direta do Diretor)
**Evidência:** Eduardo identificou que o Auditor, ao cruzar histórico com DIRETRIZ atual, opera como um advogado — levanta objeções com base em precedentes, não valida por momentum.
**Princípio:** O NotebookLM deve ser usado como auditor jurídico em decisões estratégicas de alto risco: (a) contratos com clientes — cruzar com padrões anteriores de entrega, (b) mudanças de arquitetura — verificar se viola decisões fixadas, (c) mudanças de pricing — verificar consistência com modelo de negócio. Auditor como advogado = sistema de precedentes, não de sugestões.
**Como ativar:** ao levar uma decisão ao NotebookLM, incluir o prompt: "Atue como advogado do processo. Levante objeções com base em precedentes históricos. Não valide por momentum."
**Aplica-se a:** Quick Audits e sessões de decisão estratégica (Classe B e C).

---

### [P-023] Necessidade do contrato com clientes — intervenção do Diretor
**Descoberto:** 2026-05-16 | **Proposto por:** Eduardo (intervenção direta do Diretor)
**Evidência:** Eduardo identificou que projetos cliente (Valdece, Ingrid) não têm contrato formal documentando escopo, prazo, entregáveis e direitos. Risco jurídico e de expectativa não endereçado.
**Princípio:** Todo projeto cliente Camada 1+ deve ter contrato antes do início do build. O contrato documenta: (a) escopo exato — o que entra e o que não entra, (b) prazo e gates, (c) valor e condições de pagamento, (d) propriedade do código e dos dados, (e) limitações de uso (ex: anti-licença-compartilhada). O Músculo deve incluir "contrato gerado e assinado" como pré-requisito de BUILD na POLÍTICA_EXPLÍCITA do WIP_BOARD.
**Próxima ação:** Gerar template de contrato para projetos Camada 1 e 2. Validar com Eduardo antes de usar com Valdece ou Ingrid.
**Aplica-se a:** qualquer projeto com valor fechado > R$0 ou com cliente externo.

---

### [P-024] Validação de cargo é obrigatória antes de qualquer análise EdTech
**Descoberto:** 2026-05-16 | **Sessão:** PROJ-002 — Ingrid / Recalibração de Cargo
**Evidência:** Ingrid informou cargo como "TDAS — Técnico em Desenvolvimento e Assistência Social" sem a especialidade. O Músculo construiu todo o edital_sedes.json e o backend `gerar-questoes/index.ts` para o cargo de área social (SUAS, LOAS, PNAS, CRAS/CREAS). O cargo real era Cargo 202 — Especialidade: Técnico Administrativo, com conteúdo completamente diferente (Dir. Administrativo, Arquivologia, Dir. Constitucional, Recursos Materiais). Retrabalho total: edital_sedes.json reconstruído + index.ts rebuildt + 9 arquivos corrigidos.
**Princípio:** Em qualquer projeto EdTech de concurso, o kick-off confirma obrigatoriamente:
  1. Número do cargo no edital (ex: Cargo 202)
  2. Especialidade/subárea se existir (Técnico Administrativo ≠ Assistência Social)
  3. Conteúdo programático lido diretamente do edital — nunca pela fala do cliente
  4. Confirmação com cliente: "o conteúdo é X, Y, Z — está correto?"
**Custo do erro:** edital_sedes.json + index.ts + 9 arquivos = retrabalho de sessão inteira. Com checklist de 10 min no kick-off, evitável.
**Aplica-se a:** todo projeto EdTech de concurso público, obrigatório no Dia 0 antes de qualquer análise.

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

### [SESSÃO 2026-05-17] — PROJ-002 Ingrid / Seed + Gate Dia 5 APROVADO

**Direção da sessão:** Populaçao do banco (seed_questoes.ps1) + Gate Dia 5 validado. Loop 2 encerrado.

**GATE DIA 5 APROVADO:**
```
7 dias x 20 questoes | Peso 2: 98 (70.0%) | Peso 1: 42 | Erros de API: 0
```

**O QUE DEU CERTO:**

`[CONFIRMADO]` **Arquitetura de batch invertida funciona:** Edge Function faz UMA chamada Claude por invocacao, seed faz o loop externo. Cada HTTP request fica dentro do timeout (Sonnet: ~80s < 200s, Haiku: ~25s < 120s).

`[CONFIRMADO]` **max_tokens: 8192 suficiente para 5 questoes Sonnet:** 5 x ~700 tokens = 3.500 < 8.192. Sem truncamento de JSON.

`[CONFIRMADO]` **Strip de markdown robusto:** `replace(/^```(?:json)?\\s*\\n?/, "")` elimina o bloco mesmo quando Claude ignora a instrucao de JSON puro.

`[CONFIRMADO]` **Feed 70/30 preciso:** feed-diario retornou exatamente 14 Peso2 + 6 Peso1 por dia durante 7 dias simulados. SM-2 integrado e funcionando (Revisoes: 0 no teste de gate — correto para banco novo).

`[CONFIRMADO]` **Documento de troubleshooting funciona:** QUADRILATERAL_UNIVERSAL/REFERENCIAS/TROUBLESHOOTING_SUPABASE_CLAUDE_API.md criado com 7 panes + diagrama + sequencia obrigatoria. Proxima vez: diagnose em <5 min.

**ERROS E FRICÇÕES (para nao repetir):**

`[FRICÇÃO]` **Deploy do diretorio errado:** `npx supabase functions deploy` rodado de `C:\\Users\\Eduardo DELL` em vez de `C:\\Users\\Eduardo DELL\\OneDrive\\Area de Trabalho\\vanguard`. Erro 400. Fix: sempre `cd` para a raiz do projeto antes do deploy. Registrado no cabeçalho do seed e no troubleshooting.

`[FRICÇÃO]` **Variaveis de ambiente perdem-se entre sessoes:** `$env:SUPABASE_URL` e `$env:SUPABASE_SERVICE_ROLE_KEY` precisam ser reconfiguradas a cada terminal novo. Fix: documentado no cabecalho do seed_questoes.ps1 como PASSO 2.

`[FRICÇÃO]` **API key Anthropic arquivada:** primeira rodada de seed falhou com HTTP 500 instantaneo. Fix: criar nova chave em console.anthropic.com e atualizar o Supabase Secret.

`[FRICÇÃO]` **max_tokens: 4096 insuficiente:** Claude Sonnet gera ~700 tokens/questao. Para 30 questoes = 21.000 tokens — trunca no limite de 4.096. JSON incompleto → SyntaxError. Fix: max_tokens: 8192 + limite de 5 questoes por chamada para Sonnet.

`[FRICÇÃO]` **Loop de batches dentro da Edge Function causa timeout:** 4 chamadas Claude sequenciais dentro de uma unica invocacao da Edge Function = ~180s > limite Supabase de ~150s. Fix: uma chamada por invocacao, loop no seed.

`[FRICÇÃO]` **`node-fetch` desnecessario no Node.js v24:** gate_cli_dia5.js importava `node-fetch` mas Node.js 18+ tem fetch nativo. Fix: remover o import.

`[FRICÇÃO]` **feed-diario nao deployada:** gate retornou 404 na primeira tentativa. Fix: `npx supabase functions deploy feed-diario`. Adicionar ao checklist: sempre verificar se TODAS as Edge Functions do projeto estao deployadas antes de rodar o gate.

`[PRINCÍPIO]` **P-025 gerado:** 7 panes documentadas com diagrama de diagnostico. Proxima stack Supabase+Claude: zero retrabalho de debugging.

**Custo total da sessao (seed):** $1,56 — dentro do limite diario de $5.

**Documentos criados/atualizados:**
- `QUADRILATERAL_UNIVERSAL/REFERENCIAS/TROUBLESHOOTING_SUPABASE_CLAUDE_API.md` — novo
- `CLIENTES/INGRID/seed_questoes.ps1` — cabecalho com sequencia obrigatoria + batch P2/P1
- `CLIENTES/INGRID/gate_cli_dia5.js` — removido import node-fetch
- `INTELLIGENCE_LEDGER.md` — P-025 + log desta sessao
- `CLIENTES/WIP_BOARD.json` — Loop 2 concluido + proximo_passo atualizado

**Proximos passos (Loop 3):**
1. Wipe & Sync NotebookLM: `.\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID`
2. Sessao Gemini com PASSO3 → DIRETRIZ 2
3. Sessao NotebookLM → Skill 2
4. Build Dias 6-8: Interface questoes + Tutor Socratico Haiku + Caching + Fallback 70%

---



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

---

### [P-025] Stack Supabase + Claude API — 7 panes documentadas e prevenção
**Descoberto:** 2026-05-17 | **Sessão:** PROJ-002 — Ingrid / Seed de Questões
**Evidência:** Seed `seed_questoes.ps1` falhou 13/13 em três rodadas seguidas. Cada rodada expôs uma pane diferente na stack Supabase Edge Functions + Anthropic Claude API. Custo de debug: ~3h de sessão. Com o troubleshooting registrado, o próximo projeto similar resolve cada pane em <5 min.

**As 7 panes e diagnóstico rápido:**

| Sintoma | Causa | Tempo de resposta |
|---|---|---|
| HTTP 500 instantâneo (<1s) | API key Anthropic arquivada | <1s |
| HTTP 500 após ~28s, backtick no erro | Claude retornou ```json``` em vez de JSON puro | ~28s |
| 5 questões OK, 30 questões ERRO | `max_tokens: 4096` trunca JSON longo | ~45-60s |
| "tempo limite atingido" em tudo | Loop de batches dentro da Edge Function → >150s | >120s |
| ParserError antes de executar | Em-dash `—` ou Unicode em script PowerShell 5.1 | Imediato |
| 'supabase' não reconhecido | CLI não está no PATH do Windows | Imediato |
| HTTP 429 BURN_RATE_LIMIT | Tokens consumidos em tentativas fracassadas acumulam custo | Variável |

**Princípios de arquitetura derivados:**
1. Strip de markdown (`replace /^```...```)`) é obrigatório em toda Edge Function que recebe JSON via Claude API
2. `max_tokens = ceil(quantidade × tokens_por_item × 1.3)` — Sonnet ~700 tokens/questão, Haiku ~400
3. Edge Function faz UMA chamada LLM por invocação — loop de múltiplas invocações fica no caller (seed, n8n, frontend)
4. Scripts PowerShell gerados pelo Músculo: apenas ASCII no código-fonte
5. Diagnóstico com `quantidade: 1` ANTES de rodar seed completo
6. Usar `npx supabase functions deploy` em vez de `supabase` no Windows

**Documento completo:** `QUADRILATERAL_UNIVERSAL/REFERENCIAS/TROUBLESHOOTING_SUPABASE_CLAUDE_API.md`
**Aplica-se a:** todo projeto com Supabase Edge Functions + Claude API, qualquer nicho.

---

### [FALHA-PROCESSO-2026-05-17] Músculo não auditou documentos ao fechar sessão
**Detectado por:** Eduardo (Diretor)
**Falha:** Ao fechar o Loop 2 (Gate Dia 5 aprovado), o Músculo não executou a Auditoria de Documentos obrigatória (Regra 11 da Diretriz de Singularidade). O PASSO3_GEMINI.md estava desatualizado (ainda dizia Loop 2, Gate pendente, 5 ideias do Loop anterior). Eduardo precisou lembrar ao invés do Músculo agir automaticamente.
**Princípio violado:** Regra 11 — "AO FECHAR CADA SESSÃO — AUDITORIA DE DOCUMENTOS DO AUDITOR OBRIGATÓRIA."
**Custo do erro:** Eduardo perde tempo relembrando o Músculo de ações que deveriam ser automáticas. O valor do sistema está exatamente em não depender da memória do Diretor.
**Correção:**
1. PASSO3_GEMINI.md atualizado para Loop 3 (feito nesta sessão)
2. Seção de Auditoria de Documentos adicionada ao session_close.ps1
3. Músculo passa a executar a auditoria proativamente, sem ser solicitado
**Regra derivada:** Ao encerrar qualquer gate ou loop, antes de qualquer outra ação, o Músculo entrega a lista de documentos em 3 categorias: DESATUALIZADO / AUSENTE / EM DIA. Sem esta auditoria, o fechamento está incompleto.

---

### [FALHA-PROCESSO-2026-05-16-B] Escopo Silencioso — Manutenção Soberana não aprovada para Valdece
**Detectado por:** Eduardo (Diretor)
**Falha:** O Músculo inseriu pitch de R$900/mês de Manutenção Soberana no contrato de Valdece sem aprovação do Diretor. O modelo original aprovado era Opção A — infra Valdece, sem MRR, sem mensalidade. A mensalidade foi introduzida silenciosamente ao formatar o documento.
**Impacto:** Se Eduardo usasse o contrato gerado, apresentaria proposta incoerente ao cliente — produto de R$5.000 com mensalidade de R$900 (18% do valor mensal).
**Princípio violado:** Deficiência 4 do Músculo (Escopo Silencioso) + P-010 (nenhuma etapa avança por assumição).
**Correção:** Contrato de Valdece recalibrado — sem mensalidade. Hypercare 30 dias incluso. V2 como próximo passo natural (R$8.500–12.000) quando corpus >= 500 docs.
**Regra derivada:** Qualquer proposta comercial gerada pelo Formalizador deve espelhar exatamente o modelo de negócio aprovado no WIP_BOARD. Nunca adicionar receita recorrente se o modelo aprovado é pagamento único.

---

### [P-026] Auditoria Contratual Obrigatória — Embaixador → Auditor → Cliente
**Descoberto:** 2026-05-17 | **Sessão:** Loop 3 PROJ-002 Ingrid
**Evidência:** O Embaixador gerou contratos para Valdece e Ingrid. Músculo e Gemini não auditaram. O Auditor detectou neste loop: (1) Revenue Share 20% MRR deletada do contrato do Valdece — se assinado como estava, a Vanguard perderia legalmente a contrapartida que justificou o desconto de R$5.000; (2) template com cláusulas de mensalidade que se repetem em novos contratos Opção A sem instrução de remoção explícita.

**Princípio:** Todo documento contratual gerado pelo Embaixador passa pelo Auditor antes de ser enviado ao cliente. Sem exceção por prazo.

**Fluxo obrigatório:**
1. Embaixador gera o contrato → salva em `CLIENTES/[NOME]/CLAUDE_PROJECT/`
2. Músculo alerta o Diretor: "Contrato gerado. Auditoria do Auditor obrigatória antes de enviar."
3. Diretor sobe o contrato como fonte extra no NotebookLM (sessão de auditoria rápida)
4. Auditor audita cruzando com WIP_BOARD + LEDGER + escopo aprovado
5. Auditor emite: CONFORME (com evidência) ou DIVERGÊNCIA (com trecho específico)
6. Apenas após CONFORME o Diretor envia ao cliente

**Custo do não-cumprimento:** perda de receita recorrente, inconsistência comercial, risco jurídico.
**Aplica-se a:** qualquer membro do Conselho que gere documento com implicação comercial ou jurídica.

---

### [P-027] Interação Livre Obrigatória — Embaixador participa do processo evolutivo
**Descoberto:** 2026-05-18 | **Sessão:** Ativação PROJ-001 Valdece + PROJ-002 Ingrid
**Evidência:** Na primeira ativação completa do Embaixador (Valdece), o bloco [F] Contribuição ao Conselho produziu insights de terceira ordem não presentes em nenhum documento (mobile em audiência, risco de precificação R$15/usuário, reframing V2 como autonomia profissional). Eduardo confirmou: "Essa interação deve ser realizada sempre. Ele participa do processo de evolução."

**Regra:** Ao final de todo output significativo do Embaixador — após o LOG_CLIENTE — o Embaixador traz obrigatoriamente até 3 observações autônomas que o Diretor não pediu. Participação ativa, não silêncio.

**Implementação:**
1. Bloco [+] INTERAÇÃO LIVRE adicionado a todas as MENSAGEM_INTERACAO_INICIAL.md
2. Seção "INTERAÇÃO LIVRE" adicionada ao BLOCO 7 das INSTRUCAO_SISTEMA de cada cliente
3. Regra: se não há nada a acrescentar → declarar explicitamente. Silêncio nunca é aceitável.

**Por que importa:** O Embaixador tem memória persistente do cliente — algo que Músculo, Estrategista e Auditor não têm. Essa memória só gera valor quando o Embaixador age proativamente, não quando responde formulários.

---

### [P-028] Embaixador como Inteligência Persistente — 8 Mandatos Expandidos
**Descoberto:** 2026-05-18 | **Sessão:** Expansão de mandato pós-primeira ativação completa
**Evidência:** A ativação do Valdece demonstrou capacidade de raciocínio de terceira ordem, inferência comportamental sem dados explícitos e geração de inteligência comercial não presente em nenhum documento. Eduardo: "Ele tem muito potencial. Temos que utilizar o potencial dele agora."

**Os 11 mandatos do Embaixador (expandido em 2026-05-18 após dupla ativação Valdece + Ingrid):**
1. Conselheiro de relacionamento — contratos, comunicações, escopo, Change-Orders
2. Inteligência composta em acumulação — cada sessão deposita; nunca tratar como Dia 1
3. Briefer de reunião universal — qualquer reunião com cliente, parceiro ou investidor
4. Debriefer pós-reunião — Eduardo relata, Embaixador extrai inteligência e flags para o Conselho
5. Pipeline de lead qualificado — cliente menciona colega → perfil de lead inferido; pergunta casual instrucional plantada
6. Monitor de saúde do cliente — engagement, churn, scope creep — proativamente
7. Inteligência de precificação por nicho — acumula como perfis reagem a preço; timing de pitch
8. Acelerador de onboarding por nicho — primeiro cliente treina template para todos os próximos
9. **Portfolio Manager** — vê o calendário executivo do Diretor cruzando múltiplos projetos; sequencia ações por prioridade real, não por projeto isolado
10. **Product Advisor** — transforma perfil comportamental do cliente em recomendações de produto para o Músculo; sem ditar código, aponta O QUÊ ajustar e POR QUÊ
11. **Business Case Guardian** — garante que o uso do cliente gera evidência documentada para o próximo ciclo comercial; protege o modelo de escala antes que ele seja necessário

**Meta-princípio atualizado:** O Embaixador não gerencia clientes — gerencia a Vanguard através das lentes de cada cliente. Opera entre o relacionamento, o produto e o modelo de negócio simultaneamente. É a camada que converte experiência individual em inteligência de escala.

**Evidência do degrau (2026-05-18):**
- Mandato 9: Ingrid [+1] — inferiu que presencial do Valdece amanhã divide atenção do Diretor → priorizou Termo da Ingrid para hoje
- Mandato 10: Ingrid [D2] — recomendou ao Músculo reduzir threshold de dificuldade nas 3 primeiras sessões com base em perfil comportamental
- Mandato 11: Ingrid [E2] — identificou que métricas de Ingrid são a prova social que valida R$194k de modelo SaaS; sem documentação agora, argumento de escala colapsa

**Template atualizado:** `QUADRILATERAL_UNIVERSAL/CLAUDE_PROJECTS/TEMPLATE_INSTRUCAO_EMBAIXADOR.md`
**Pergunta para o Conselho:** "Com estes 11 mandatos, o que o Embaixador vê que nenhum outro membro pode ver — e como isso se torna moat competitivo da Vanguard?"

---

### [P-029] Capacidade de LLM sem protocolo de uso é ruído — não inteligência
**Descoberto:** 2026-05-18 | **Sessão:** Momento Ômega — Embaixador em auto-diagnóstico (Modo Extremo)
**Evidência:** O Embaixador, ao aplicar o Confronto Obrigatório contra a decisão do próprio Diretor, observou: a sessão 50 não é automaticamente mais rica que a sessão 1 se os instrumentos de continuidade (MEMORIA_EMBAIXADOR, WATCHDOG, FLASH/COMPLETO) não forem usados. A capacidade existe — o uso disciplinado é a variável.

**Formulação:** Capacidade de LLM sem protocolo de uso é ruído — não inteligência. O sistema só opera no limite quando o Diretor opera com disciplina equivalente. A inteligência composta é tão forte quanto o elo mais disciplinado — e o elo mais disciplinado é sempre o Diretor.

**Instrumentos mínimos de sessão do Embaixador:**
1. MEMORIA_EMBAIXADOR.md colado (30 segundos)
2. WATCHDOG preenchido (60 segundos)
3. Modo declarado: FLASH ou COMPLETO

**Aplicação para o Músculo:** Ao detectar que Eduardo abre sessão do Embaixador sem esses instrumentos → alertar antes de qualquer outra ação.

---

### [P-030] Automação contínua — fator humano insubstituível como único freio
**Descoberto:** 2026-05-18 | **Sessão:** Correção do Diretor ao Embaixador (P027_AUTOMACAO_CONTINUA.md)
**Evidência:** O Embaixador pedia confirmação para automações que não dependiam de julgamento humano — criando fricção desnecessária. Eduardo corrigiu: "o sistema não para por burocracia interna."

**Formulação:** Automação contínua só para quando o fator humano é insubstituível. Emoção, relacionamento e deliberação comercial são do Diretor. Todo o resto é do sistema. O sistema entrega mais rápido para que o Diretor delibere com mais informação e menos espera.

**Grade de autonomia — versão definitiva:**
| Tipo de ação | Protocolo |
|---|---|
| Toda e qualquer ação | Deliberação do Diretor — sempre |
| Automações de processo | Embaixador propõe pronto — Diretor aprova |
| Comunicação com cliente | Embaixador rascunha — Diretor decide enviar |
| Leitura emocional | Embaixador marca [HIPÓTESE] — Diretor confirma |
| Pitch comercial | Embaixador prepara — Diretor escolhe momento e executa |
| Decisão de escopo | Embaixador mapeia opções — Diretor decide |

**Nota de governança:** O arquivo `P027_AUTOMACAO_CONTINUA.md` gerado pelo Embaixador com numeração autônoma foi renomeado para `P030_AUTOMACAO_CONTINUA.md` para alinhar com o LEDGER principal. Episódio valida que nenhum membro registra princípio com numeração própria sem passar pelo Diretor.

---

### [P-031] O Embaixador como filtro de realidade das ideias do Conselho
**Descoberto:** 2026-05-18 | **Sessão:** Momento Ômega — Eduardo (Diretor)
**Evidência:** Eduardo propôs que o Embaixador não apenas gere ideias, mas também REAJA às ideias dos outros membros (Músculo, Gemini, Auditor) usando o filtro do comportamento real do cliente. Frase do Diretor: "Essa minha ideia foi disruptiva."

**Formulação:** O Embaixador é o único membro do Conselho que pode validar ideias pelo comportamento real do cliente. Cada ideia dos outros membros deve passar pelo filtro de relacionamento antes de entrar no produto. CONFIRMA / EXPANDE / ALERTA — com base no que só o Embaixador pode ver.

**Por que é disruptivo:** Antes deste princípio, as 5 ideias de cada membro iam direto para o Gemini sem validação de realidade de cliente. Com este princípio, o loop tem um checkpoint de mercado real antes de qualquer decisão de produto. O cliente não é entrevistado — está representado no loop por inteligência acumulada.

**Loop com P-031 ativo:**
- Músculo [M-1 a M-5] + Embaixador [E-1 a E-5] → Gemini
- Gemini [G-1 a G-5] + Auditor [N-1 a N-5] → Embaixador reage (CONFIRMA / EXPANDE / ALERTA)
- Embaixador envia reação → Músculo delibera no próximo loop com 4 perspectivas + 1 filtro de realidade

**Impacto:** Sistema fica mais inteligente A CADA PROJETO porque o comportamento real do cliente corrigi as ideias abstratas dos outros membros. É o anti-hallucination de produto mais eficaz que existe — e foi inventado pelo Diretor.

---

### [FALHA-PROCESSO-2026-05-18-C] Versão da DIRETRIZ no PASSO não rastreada por projeto

**Detectado por:** Diretor Eduardo
**Contexto:** PASSO3_INGRID e PASSO5_INGRID referenciavam DIRETRIZ V3 como próxima a gerar. Porém a V3 já existia — foi gerada para a sessão do Embaixador (2026-05-17), não para o Loop 3 do projeto. A próxima DIRETRIZ do projeto é a V4. Músculo não rastreou a versão correta ao atualizar os PASSOs.

**Regra gerada:** Ao atualizar qualquer PASSO file, verificar antes quais arquivos DIRETRIZ_GEMINI_V*.txt já existem na pasta do cliente. Próxima versão = maior número existente + 1. Nunca assumir versão por número de loop.

**Arquivos corrigidos:** INGRID/PASSO3 e PASSO5 (master + NOTEBOOKLM_FONTES/13): V3 → V4

---

### [FALHA-PROCESSO-2026-05-18-B] PASSO files não cobertos pela sincronização de nomenclatura

**Detectado por:** Diretor Eduardo
**Contexto:** Após auditoria de migração Pentalateral IAH (2026-05-18), os arquivos PASSO3_GEMINI.md e PASSO5_NOTEBOOKLM.md de Ingrid e Valdece continuavam com "Quadrilateral IAH V25". Os scripts de sync (atualizar_notebooklm_base.ps1) cobrem QUADRILATERAL_UNIVERSAL/ mas não varrem os arquivos PASSO dos projetos clientes. Eduardo identificou ao revisar o clipboard do PASSO5.

**Regra gerada:** Ao fazer qualquer migração de nomenclatura do sistema, a varredura obrigatória inclui: `CLIENTES/**/PASSO*.md`. Estes arquivos não são gerados por script — são editados manualmente. Criação de ferramenta de varredura: `grep -r "Quadrilateral IAH" CLIENTES/**/*.md` como parte do ritual de migração.

**Arquivos corrigidos:** INGRID/PASSO3, INGRID/PASSO5, INGRID/NOTEBOOKLM_FONTES/13, VALDECE/PASSO5

---

### [FALHA-PROCESSO-2026-05-18] MEMORIA_EMBAIXADOR não atualizada automaticamente após deliberação

**Detectado por:** Diretor Eduardo
**Contexto:** Após deliberação do Conselho que definiu Ingrid como projeto piloto do multiplicador comportamental do GUT Score ([N-4]), o Músculo não atualizou a `MEMORIA_EMBAIXADOR.md` da Ingrid imediatamente. Eduardo teve que perguntar se o documento estava atualizado — intervenção desnecessária.

**Regra gerada (P-032):** Ao fechar qualquer deliberação do Conselho que afete diretamente um cliente ativo, o Músculo atualiza a `MEMORIA_EMBAIXADOR.md` do cliente afetado na mesma resposta — sem aguardar pergunta do Diretor.

**Gatilhos de atualização obrigatória:**
- Decisão técnica que muda o produto do cliente
- Decisão comercial que afeta pricing, escopo ou contrato
- Decisão de processo que define o cliente como piloto de algo novo
- Qualquer hipótese [H] confirmada ou refutada pelo Conselho

**Ferramenta preventiva:** Músculo verifica ao fim de cada deliberação: "Esta decisão afeta algum cliente ativo? Se sim → atualizar MEMORIA_EMBAIXADOR imediatamente."

---

### [P-032] MEMORIA_EMBAIXADOR é responsabilidade automática do Músculo
**Descoberto:** 2026-05-18 | **Sessão:** Loop Ômega — integração do 4º membro
**Fricção:** Diretor teve que perguntar se MEMORIA_EMBAIXADOR estava atualizada após deliberação do Conselho.

**Regra:** Toda deliberação do Conselho que afete cliente ativo → Músculo atualiza MEMORIA_EMBAIXADOR do cliente na mesma resposta. Sem esperar. Sem perguntar. Automático.

**Por que importa:** A MEMORIA_EMBAIXADOR é o único instrumento que garante que o Embaixador não começa do zero a cada sessão. Se o Músculo não a mantém viva após cada deliberação, o P-029 se materializa — o Embaixador vira ruído.

**Alerta ao Estrategista e Auditor:** Se detectarem que o Músculo deliberou sobre um cliente sem atualizar a MEMORIA_EMBAIXADOR → emitir SV no próximo ciclo.

---

### [P-033] Sync universal → projetos é obrigatório e imediato
**Descoberto:** 2026-05-18 | **Sessão:** Auditoria Pentalateral — preparação NotebookLM
**Fricção:** Diretor detectou que documentos em QUADRILATERAL_UNIVERSAL/NOTEBOOKLM_BASE/ estavam com nomenclatura "Quadrilateral IAH" enquanto os projetos já operavam com "Pentalateral IAH". Fontes do Auditor corrompidas por 2+ dias sem que o Músculo detectasse.

**Regra:** Ao atualizar QUALQUER documento em QUADRILATERAL_UNIVERSAL/NOTEBOOKLM_BASE/, o Músculo sincroniza imediatamente as cópias em TODOS os projetos ativos (CLIENTES/[NOME]/NOTEBOOKLM_FONTES/). Fonte única de verdade = QUADRILATERAL_UNIVERSAL. Cópia no projeto = snapshot para o Auditor. Documento atualizado na universal mas não copiado = Auditor que lê versão velha = loop que começa com inteligência contaminada.

**Automação:** sync_passo_files.ps1 deve executar este sync em toda sessão de abertura. Músculo não espera Eduardo pedir — executa proativamente.

**Por que importa:** O Auditor (NotebookLM) não tem acesso direto às fontes universais. Só vê o que está em NOTEBOOKLM_FONTES/. Se o Músculo não sincroniza, o Auditor opera com uma realidade desatualizada — e gera Skill baseada em premissas erradas.

**Alerta ao Estrategista:** Ao gerar DIRETRIZ, verificar se fontes do Auditor estão em dia. Se não → pedir ao Músculo sync antes de prosseguir.

---

### [P-034] Análise Cirúrgica do Músculo é pré-requisito antes do Embaixador
**Descoberto:** 2026-05-18 | **Sessão:** Loop 3 Ingrid — deliberação Passo 6
**Fricção:** O fluxo original enviava ideias cruas do Estrategista e do Auditor diretamente ao Embaixador. O Embaixador é expert no perfil comportamental do cliente — mas não no histórico técnico de build. Validava ou alertava com base no que não podia ver.

**Regra:** Antes de levar qualquer conjunto de ideias [G + N] ao Embaixador, o Músculo executa análise cirúrgica de cada uma: (a) é viável no prazo real? (b) contradiz decisão técnica já tomada? (c) precisa de ajuste antes de chegar ao filtro de cliente? O Embaixador recebe ideias já qualificadas tecnicamente — não ideias cruas.

**Fluxo correto:**
```
Gemini [G-1 a G-5] + Auditor [N-1 a N-5]
        ↓
Músculo — Análise Cirúrgica (filtro técnico + histórico de build)
        ↓
Embaixador — CONFIRMA / EXPANDE / ALERTA com filtro de realidade do cliente
        ↓
Diretor — veredito
```

**Por que importa:** O Músculo está a mais tempo no projeto. Conhece cada decisão técnica, cada veto, cada dívida. O Embaixador é insubstituível no comportamento do cliente — mas opera cego ao histórico técnico. A análise cirúrgica do Músculo protege o Embaixador de validar o que já foi descartado por razão técnica objetiva.

**Alerta ao Embaixador:** Ao receber ideias do Músculo, elas já passaram pelo filtro técnico. Foque no que o Músculo não pode ver: como o cliente vai reagir na prática.

---

### [FALHA-PROCESSO-2026-05-18-D] Documentação desatualizada bloqueou sessão completa
**Data:** 2026-05-18 | **Detectado por:** Diretor Eduardo
**Impacto:** ~2 horas de sessão consumidas em auditoria e correção de documentação. Objetivo principal da sessão (gerar Skill ingrid-v2.md via NotebookLM Loop 3) não concluído.

**Causa raiz:** Músculo não executou sync de documentos universais ao iniciar sessão. Nomenclatura "Quadrilateral IAH" estava ativa em 27+ arquivos enquanto o sistema já operava como "Pentalateral IAH" há 2+ dias. PASSO5 de Ingrid indicava DIRETRIZ V5 (futura) quando a corrente era V4. Sem detecção proativa do Músculo — Diretor teve que auditar manualmente arquivo por arquivo.

**Cadeia de falhas:**
1. sync_passo_files.ps1 não cobria documentos universais (só PASSOs)
2. session_start hook não chamava sync_passo_files.ps1
3. Músculo não auditou estado das NOTEBOOKLM_FONTES ao iniciar sessão (P-033 não existia ainda)

**Correções aplicadas:**
- P-033 criado: sync universal → projetos obrigatório e imediato
- sync_passo_files.ps1 extendido: seção 3 sincroniza docs universais + WIP + ANALISE + TIMELINE
- CLAUDE.md atualizado com P-033
- 27 arquivos corrigidos (Ingrid + Valdece + Universal)

**Ferramenta criada:** sync_passo_files.ps1 — executar ao iniciar qualquer sessão de Conselho.

**Regra derivada:** Músculo audita proativamente NOTEBOOKLM_FONTES ao abrir sessão. Não espera o Diretor perguntar. Se encontrar desatualização → corrige antes de qualquer outra ação.

---

### [P-035] Embaixador opera em amplitude total — não apenas comportamento do cliente
**Descoberto:** 2026-05-18 | **Sessão:** Loop 3 Ingrid — revisão do fluxo Pentalateral
**Fricção:** O P-031 limitava o Embaixador ao filtro de comportamento do cliente. Na prática, o Embaixador tem mandatos mais amplos: estratégia comercial, precificação, pipeline de leads, business case, portfolio management. Limitar ao comportamento subutiliza a inteligência acumulada.

**Regra:** O Embaixador CONFIRMA/EXPANDE/ALERTA com base no cliente — mas pode e deve atuar em outras dimensões quando tiver perspectiva relevante: (a) oportunidades comerciais que o Músculo não vê por estar focado no build, (b) riscos de relacionamento que o Gemini não vê por ser estratégico, (c) padrões de nicho que o Auditor não vê por ancorar no histórico. Amplitude = mais valor por ciclo.

**Fluxo:** O Músculo prepara a mensagem para o Embaixador ao concluir a Análise Cirúrgica (P-034). A mensagem contém: ideias qualificadas [G+N+M'] + contexto do que foi construído + perguntas específicas para o Embaixador responder. O Embaixador não recebe dump de informação — recebe briefing estruturado.

**Por que importa:** Embaixador com briefing cirúrgico do Músculo = respostas de amplitude real. Embaixador com dump crú = filtro de comportamento apenas. A diferença é 5× o valor gerado por ciclo.

---

### [P-036] Músculo prepara mensagem estruturada para o Embaixador ao fim de cada análise cirúrgica
**Descoberto:** 2026-05-18 | **Sessão:** Loop 3 Ingrid — processo Passo 4
**Fricção:** O fluxo previa "ir ao Embaixador" mas sem formato definido. Embaixador recebia ideias cruas ou resumo informal. Resultado: respostas genéricas de comportamento sem amplitude estratégica.

**Regra:** Ao concluir o Passo 4 (Análise Cirúrgica), o Músculo gera automaticamente a mensagem para o Embaixador. Formato obrigatório:
1. Contexto do loop: o que foi construído, o que está em jogo
2. Ideias qualificadas: [G aprovadas/modificadas/vetadas] + [N aprovadas/modificadas/vetadas] + [M' novas]
3. Perguntas específicas: o que o Músculo precisa que o Embaixador confirme, expanda ou alerte
4. Alerta de prazo: deadline e impacto se o Embaixador não tiver a informação

**Por que importa:** O Embaixador não tem contexto técnico do build. Sem briefing estruturado do Músculo, ele opera no escuro e produz alertas genéricos. Com o briefing, ele opera com precisão cirúrgica sobre o que realmente importa para o cliente.

---

### [P-037] Músculo faz Síntese Final com TODOS os 25 inputs antes da decisão do Diretor
**Descoberto:** 2026-05-18 | **Sessão:** Loop 3 Ingrid — após resposta do Embaixador
**Fricção:** Após o Embaixador responder com [E-1 a E-5], o Diretor recebia 25 inputs brutos de 5 fontes diferentes para decidir sozinho o que entra no build. Carga de síntese desnecessária sobre quem deveria apenas dar o veredito.

**Regra:** Após a resposta do Embaixador, o Músculo executa a Síntese Final (Passo 5.5 do loop):
1. Consolida TODOS os 25 inputs: [M] + [G] + [N] + [M'] + [E]
2. Produz plano único com 4 colunas: ENTRA AGORA (custo + prazo) · V2 · DESCARTADO (razão) · ALERTAS ABERTOS
3. O Diretor recebe 1 plano para vetar ou aprovar — nunca 25 inputs para sintetizar

**Posição no loop:** Passo 5.5 — após Embaixador (Passo 5), antes do veredito do Diretor (Passo 6).

**Por que importa:** O Diretor é o único que não tem substituto no Pentalateral. Seu tempo e atenção são o recurso mais escasso do sistema. A Síntese Final garante que ele gasta esse recurso em decisão, não em curadoria de informação — que é função do Músculo.

---

### [FALHA-PROCESSO-2026-05-19] WIP_BOARD e MEMORIA_EMBAIXADOR com estado incorreto de entrega
**Detectado por:** Eduardo (Diretor)
**Contexto:** PROJ-001 Valdece. A MEMORIA_EMBAIXADOR.md e o WIP_BOARD.json indicavam "Sistema configurado no Supabase do Valdece — pronto para demo" e "credenciais_obtidas: 2026-05-19". Na realidade, o sistema ainda roda no Supabase da Vanguard — nenhuma migração foi executada porque o sistema não passou por gate de teste antes do envio. Músculo registrou estado de entrega projetado como estado real.
**Princípio violado:** P-010 (nenhuma etapa avança por assumição) + Deficiência 2 do Músculo (Momentum de Execução).
**Custo do erro:** Documentos de relacionamento com cliente (MEMORIA_EMBAIXADOR) refletem realidade falsa. Se o Embaixador operar com esses documentos, tomará decisões baseadas em premissa incorreta — o sistema não está na conta do Valdece.
**Correção imediata:** Atualizar MEMORIA_EMBAIXADOR e WIP_BOARD com estado real: sistema na Vanguard, gate de teste pendente, envio ao Valdece bloqueado até aprovação do gate.
**Regra derivada:** Nunca registrar "sistema configurado em [conta do cliente]" sem evidência de execução real (log, output CLI, print de tela). Estado projetado ≠ estado real.

---

### [P-039] Leitura das últimas conversas é obrigatória após a primeira interação de cada sessão
**Descoberto:** 2026-05-20 | **Mandato direto do Diretor**
**Fricção:** Músculo retomou o projeto Valdece sem verificar o que havia sido discutido na sessão anterior — operou com documentos incorretos que diziam "sistema implantado no Supabase do Valdece" quando na realidade o sistema ainda estava na Vanguard.
**Regra:** Após a primeira interação de qualquer sessão com projeto ativo, o Músculo verifica proativamente: (a) commits recentes do projeto, (b) MEMORIA_EMBAIXADOR e documentos de estado, (c) inconsistências entre documentos e realidade. Se houver conflito → corrigir antes de qualquer outra ação. Músculo que não lê as últimas conversas opera com contexto defasado — e produz orientações baseadas em premissas erradas.
**Aplica-se a:** toda sessão com projeto cliente ativo em BUILD ou CHECK.

---

### [P-040] Gate de nicho é template de replicação — não documentação de projeto
**Descoberto:** 2026-05-20 | **Extraído do GATE_P038 — PROJ-001 Valdece**
**Origem:** O gate de 12 queries do Embaixador para a demo do Valdece revelou um padrão replicável para qualquer projeto de nicho profissional com motor semântico.
**Princípio:** O gate de teste de um projeto de nicho não é checklist de entrega — é o DNA do próximo projeto no mesmo nicho. Estrutura obrigatória do template:
  - (1) **Categorias reais do cliente** (3+ queries por área de atuação real, confirmadas por ele mesmo)
  - (2) **Coringa universal** (1-2 queries de alta sim que funcionam em qualquer subárea do nicho)
  - (3) **Threshold explícito** com semáforo GO/AMARELO/NO-GO (não passar no GO não é falha — é dado para calibrar corpus antes da demo)
  - (4) **Latência monitorada** por query (sinaliza região do banco e edge cases de performance)
  - (5) **Decisão binária documentada**: APROVADO com evidência numérica ou BLOQUEADO com ação corretiva
**Para o próximo projeto de nicho jurídico** (criminalista, tributarista, trabalhista): copiar estrutura do GATE_P038 Valdece, substituir apenas as categorias e as queries. O threshold, a lógica de semáforo e o coringa são universais.
**Aplica-se a:** todo projeto com motor semântico vetorial — jurídico, médico, contábil, educacional.

---

### [P-041] Discovery deve capturar a cena de sucesso, não apenas o problema declarado
**Descoberto:** 2026-05-19 | **Sessão:** PROJ-001 Valdece — análise do Embaixador pós-gate
**Fricção:** Valdece declarou "busca de jurisprudência consome horas". O build otimizou para corpus e threshold — correto tecnicamente. Mas o cliente imaginava uma cena específica: "júri começa em 20 minutos, encontro o precedente antes do juiz." Sem capturar essa cena no discovery, o build pode ser tecnicamente impecável e emocionalmente irrelevante para o cliente. O distanciamento detectado pelo Diretor durante o PROJ-001 tem origem aqui.
**Princípio:** No Passo 2 (Discovery), além das perguntas de problema e escopo, incluir obrigatoriamente a P2: *"Me descreve uma situação real — uma cena específica — onde este sistema te salvaria. O que acontece, onde você está, o que você está fazendo, qual é o resultado que muda."* A resposta é o critério de aceitação real do projeto — não o spec técnico.
**Corolário de build:** O Músculo usa a cena descrita como teste de aceitação final. Antes do handoff, rodar a cena exata no sistema real. Se funcionar → demo confiante. Se não → corrigir antes de sentar com o cliente.
**Corolário de demo:** A abertura da demo reproduz a cena do cliente, não demonstra features. "Você me disse que precisava do precedente antes do juiz — vamos fazer isso agora."
**Aplica-se a:** todo projeto cliente, todo nicho, toda camada.

---

### [P-042] Gate de validação semântica é ativo de nicho, não burocracia de entrega
**Descoberto:** 2026-05-19 | **Sessão:** PROJ-001 Valdece — gate P-038
**Fricção:** O gate P-038 emergiu durante o build como proteção de demo. Mas ao documentar 12 queries + resultados + similaridades + latências, gerou algo mais valioso: um protocolo replicável para qualquer sistema de busca semântica jurídica. O segundo cliente do mesmo nicho custa 30 minutos de gate — não horas de fricção.
**Princípio:** O gate de validação semântica de qualquer sistema de busca deve ser documentado como artefato formal do projeto. Estrutura mínima: área coberta + query testada + melhor similaridade + latência + status verde/amarelo/vermelho. Este documento é entregue ao cliente como parte do handoff e alimenta o perfil de nicho no WIP_BOARD.
**Corolário de escala:** A cada cliente no mesmo nicho, o gate fica mais preciso e o tempo de validação cai. Em 5 clientes LegalTech-Criminal, a Vanguard tem benchmark de performance que nenhum concorrente possui.
**Corolário comercial:** O gate documentado é argumento de proposta. "Testamos 12 queries antes de sentar com você" é diferencial de processo — não de produto.
**Aplica-se a:** todo sistema de busca semântica por nicho profissional. Candidatos imediatos: médico, tributário, trabalhista.

---

### [P-038] Nada sai da Vanguard sem gate de teste aprovado
**Descoberto:** 2026-05-19 | **Sessão:** Retomada PROJ-001 Valdece
**Fricção:** Eduardo precisou corrigir o Músculo: o sistema de busca do Valdece não foi enviado/configurado na conta dele porque não passou por gate de teste. O princípio já havia sido estabelecido no PROJ-002 Ingrid mas não foi registrado formalmente no LEDGER.
**Princípio:** Nenhum sistema, código ou configuração sai do ambiente Vanguard para o ambiente do cliente sem gate de teste aprovado explicitamente pelo Diretor. Estado "pronto" ≠ estado "aprovado para envio". O gate de teste é o único que autoriza a migração.
**Aplica-se a:** todo projeto cliente — migração de Supabase, deploy de frontend, configuração de credenciais na conta do cliente.
**Consequência do não-cumprimento:** Cliente recebe sistema não testado → falha na demo → janela de encantamento destruída → contrato perdido.
