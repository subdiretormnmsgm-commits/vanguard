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

> **GAPS NUMÉRICOS — RESERVADOS:**
> P-011 e P-012 **não existem**. Foram descartados na origem (pré-V24) antes do LEDGER ser formalizado.
> NÃO reaproveitar esses números — gaps são parte da história do sistema.
> Qualquer referência a P-011 ou P-012 em documentos = erro de numeração.

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
**Aplica-se a:** toda sessão do Pentalateral.

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
**Aplica-se a:** todo projeto gerido pelo Pentalateral. Definir o número de loops no Passo 7 (aprovação do plano).

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
**Aplica-se a:** todo projeto do Pentalateral, toda etapa de build, toda entrega a cliente.

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
**Descoberto:** 2026-05-13 | **Sessão:** PROJETO_001 — Valdece / Padronização do Pentalateral
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
**Aplica-se a:** toda sessão do Pentalateral — qualquer projeto, qualquer cliente.

---

### [P-018] O Diretor é o 4º LLM — Orquestração Dinâmica de Deficiências como Vantagem Competitiva
**Descoberto:** 2026-05-16 | **Sessão:** Opinião Consultora #01 — construção colaborativa Diretor + Músculo
**Evidência:** Ao construir a Ideia Disruptiva da Opinião #01, Eduardo articulou: a vantagem real do Pentalateral não é usar IA — é saber usar a deficiência de cada IA contra a deficiência das outras. Gemini alucina com otimismo → Claude âncora com custo real. Claude tem amnésia → NotebookLM âncora com histórico. NotebookLM valida por momentum → Eduardo rejeita sem os 4 blocos. O sistema é anti-frágil porque foi desenhado em torno de fraquezas conhecidas, não apesar delas.
**Princípio:** O Pentalateral tem três funções constitucionais separadas. Os 3 LLMs são a válvula motriz com **comportamento ativo** — não passivo. Estão em looping evolutivo permanente: geram ideias, combatem as deficiências uns dos outros, acumulam padrões ciclo a ciclo, protegidos por firewalls persistentes (contra-ataques de deficiência estruturalmente embutidos, não dependentes de memória). O Diretor contribui com opiniões nascidas da experiência acumulada e do feeling instintivo — analisadas pelos 3 LLMs e evoluídas por eles. Ao final, dá o Veredito soberano. A cada etapa, a cada processo, a cada projeto, o sistema fica mais inteligente e os processos mais definidos — acumulação exponencial que torna o modelo de negócio imbatível.
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
**Aplica-se a:** toda interação. O Pentalateral é um amplificador da inteligência de Eduardo — não uma cadeia autônoma que o Diretor apenas valida.

---

### [P-022] NotebookLM como advogado do processo — auditor jurídico do Pentalateral
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
[HV-7] Contrato comercial assinado sem Fases 1 e 2 do PROTOCOLO_TESTES_PRE_ASSINATURA
        concluídas e documentadas. Override requer aprovação explícita do Diretor com
        justificativa registrada no LEDGER. [ver P-046]
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

`[CONFIRMADO]` **Documento de troubleshooting funciona:** PENTALATERAL_UNIVERSAL/REFERENCIAS/TROUBLESHOOTING_SUPABASE_CLAUDE_API.md criado com 7 panes + diagrama + sequencia obrigatoria. Proxima vez: diagnose em <5 min.

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
- `PENTALATERAL_UNIVERSAL/REFERENCIAS/TROUBLESHOOTING_SUPABASE_CLAUDE_API.md` — novo
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

**Direção da sessão:** Sessão inteiramente filosófica e constitucional. Nenhum build executado. Foco em clarificar e documentar a arquitetura de papéis do Pentalateral IAH com precisão crescente — através de refinamentos sucessivos propostos pelo Diretor.

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
- `PENTALATERAL_UNIVERSAL/CONSTITUICAO/MEMORANDO_PENTALATERAL_UNIVERSAL.md` — PARADIGMA v3.0 + tabela OS 4 MEMBROS + Manifesto atualizados
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

**Direção da sessão:** Construção da inteligência evolutiva do Pentalateral — sistema de acumulação por sessão.

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

`[FRICÇÃO]` Processo do Pentalateral não estava claro para o Diretor — revisão completa feita e documentada em sessão.

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
- `PENTALATERAL_UNIVERSAL/OPERACAO/PASSO3_GEMINI_TEMPLATE.md` — idem universal
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

**Documento completo:** `PENTALATERAL_UNIVERSAL/REFERENCIAS/TROUBLESHOOTING_SUPABASE_CLAUDE_API.md`
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

**Template atualizado:** `PENTALATERAL_UNIVERSAL/CLAUDE_PROJECTS/TEMPLATE_INSTRUCAO_EMBAIXADOR.md`
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

**Evidência de campo (2026-05-24):** Embaixadores Ingrid e Valdece corrigiram 5 decisões de arquitetura do pipeline DECISOES — critério B2C/B2B, gate Hypercare, requer_uso_confirmado, resumo_para_cliente, VEREDITOS_RESUMO. Nenhuma correção veio de Gemini, Auditor ou Músculo — vieram do comportamento real dos clientes interpretado pelos Embaixadores. P-031 funcionando como filtro de arquitetura, não só de relacionamento.

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
**Contexto:** Após auditoria de migração Pentalateral IAH (2026-05-18), os arquivos PASSO3_GEMINI.md e PASSO5_NOTEBOOKLM.md de Ingrid e Valdece continuavam com "Pentalateral IAH V25". Os scripts de sync (atualizar_notebooklm_base.ps1) cobrem PENTALATERAL_UNIVERSAL/ mas não varrem os arquivos PASSO dos projetos clientes. Eduardo identificou ao revisar o clipboard do PASSO5.

**Regra gerada:** Ao fazer qualquer migração de nomenclatura do sistema, a varredura obrigatória inclui: `CLIENTES/**/PASSO*.md`. Estes arquivos não são gerados por script — são editados manualmente. Criação de ferramenta de varredura: `grep -r "Pentalateral IAH" CLIENTES/**/*.md` como parte do ritual de migração.

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
**Fricção:** Diretor detectou que documentos em PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE/ estavam com nomenclatura "Pentalateral IAH" enquanto os projetos já operavam com "Pentalateral IAH". Fontes do Auditor corrompidas por 2+ dias sem que o Músculo detectasse.

**Regra:** Ao atualizar QUALQUER documento em PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE/, o Músculo sincroniza imediatamente as cópias em TODOS os projetos ativos (CLIENTES/[NOME]/NOTEBOOKLM_FONTES/). Fonte única de verdade = PENTALATERAL_UNIVERSAL. Cópia no projeto = snapshot para o Auditor. Documento atualizado na universal mas não copiado = Auditor que lê versão velha = loop que começa com inteligência contaminada.

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

**Causa raiz:** Músculo não executou sync de documentos universais ao iniciar sessão. Nomenclatura "Pentalateral IAH" estava ativa em 27+ arquivos enquanto o sistema já operava como "Pentalateral IAH" há 2+ dias. PASSO5 de Ingrid indicava DIRETRIZ V5 (futura) quando a corrente era V4. Sem detecção proativa do Músculo — Diretor teve que auditar manualmente arquivo por arquivo.

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

### [P-043] Falácia da Homogeneidade dos Nichos — replicação não é trocar a URL dos dados
**Descoberto:** 2026-05-19 | **Sessão:** PROJ-001 Valdece — análise Estrategista + Auditor pós-gate
**Evidência:** O Estrategista alertou e o Auditor confirmou: o risco silencioso da replicação para outros nichos não é técnico — é epistemológico. Assumir que "Médico funciona como LegalTech mas com dados de medicina" é a falácia. Cada nicho tem vocabulário semântico diferente (jurídico usa "STJ", médico usa "CID-10", contábil usa "IN RFB"), ontologia de busca diferente (criminalista busca por precedente, médico por protocolo, contador por normativa), e critério de sucesso diferente (sim ≥ 0.67 adequado para jurídico pode ser inadequado para médico).
**Princípio:** Antes de replicar para novo nicho, o Músculo executa discovery semântico específico: (1) qual vocabulário de busca o profissional usa naturalmente, (2) qual é o corpus mínimo viável para o nicho, (3) qual threshold de similaridade é adequado, (4) qual é a "cena de sucesso" do nicho (P-041 aplicado ao novo nicho). Replicação sem discovery semântico = sistema com corpus errado, queries inadequadas e demo que não encanta.
**Corolário de build:** O seed_demo.py do Valdece é ponto de partida — não template final. Cada nicho exige calibração de embeddings e validação de queries antes do primeiro cliente.
**Corolário comercial:** O gate de nicho (P-042) precisa ser recalibrado por nicho — não apenas "rodar o mesmo gate com dados diferentes".
**Aplica-se a:** qualquer proposta de replicação do modelo de busca semântica para novos nichos profissionais.

---

### [P-044] Momentum Tecnológico do Músculo — o motor ≠ a viagem do cliente
**Descoberto:** 2026-05-19 | **Sessão:** PROJ-001 Valdece — análise Estrategista pós-gate
**Evidência:** O Músculo otimiza para métricas intrínsecas do sistema (threshold, latência, embedding dimensions) porque oferecem recompensas de engenharia claras e mensuráveis. O cliente, contudo, otimiza para alívio temático em cenários de alta pressão — a cena do "júri em 20 minutos". O distanciamento do PROJ-001 Valdece nasceu exatamente aqui: o Músculo construiu um motor impecável; o cliente compra a viagem, não o motor.
**Princípio:** Ao iniciar cada dia de build, o Músculo relê a cena de sucesso descrita pelo cliente no discovery (P-041). Toda decisão técnica é avaliada com uma pergunta: "Esta decisão aproxima ou afasta o sistema da cena do cliente?" Se afasta → justificar explicitamente ou descartar. Se aproxima → executar. O gate final não testa apenas se o sistema funciona — testa se reproduz a cena do cliente.
**Aplica-se a:** todo projeto cliente, todo dia de build, toda decisão arquitetural.

---

### [P-038] Nada sai da Vanguard sem gate de teste aprovado
**Descoberto:** 2026-05-19 | **Sessão:** Retomada PROJ-001 Valdece
**Fricção:** Eduardo precisou corrigir o Músculo: o sistema de busca do Valdece não foi enviado/configurado na conta dele porque não passou por gate de teste. O princípio já havia sido estabelecido no PROJ-002 Ingrid mas não foi registrado formalmente no LEDGER.
**Princípio:** Nenhum sistema, código ou configuração sai do ambiente Vanguard para o ambiente do cliente sem gate de teste aprovado explicitamente pelo Diretor. Estado "pronto" ≠ estado "aprovado para envio". O gate de teste é o único que autoriza a migração.
**Aplica-se a:** todo projeto cliente — migração de Supabase, deploy de frontend, configuração de credenciais na conta do cliente.
**Consequência do não-cumprimento:** Cliente recebe sistema não testado → falha na demo → janela de encantamento destruída → contrato perdido.

---

### [FALHA-PROCESSO-2026-05-19-B] MEMORIA e relatorio ausentes para loops intermediários
**Detectado por:** Eduardo (Diretor)
**Evidência:** PROJ-001 Valdece chegou no Loop 4 com MEMORIA_V1 e relatorio_V1 apenas. DIRETRIZ V2 e V3 existem — os loops aconteceram — mas MEMORIA_V2, relatorio_V2, MEMORIA_V3 e relatorio_V3 nunca foram gerados. O Músculo avançou os loops sem fechar o ritual de fechamento obrigatório. Resultado: o NotebookLM do Loop 4 recebe contexto do Loop 1, não do Loop 3.
**Causa raiz:** Músculo sob pressão de entrega prioriza o próximo loop em vez de fechar o atual. O ritual de fechamento (MEMORIA + relatorio) é percebido como opcional quando o Diretor autoriza o próximo passo sem exigir os artefatos.
**Regra gerada:** Nenhum loop começa sem que o loop anterior esteja fechado com MEMORIA_VX + relatorio_VX no HISTORICO. Gatilho: ao receber o PASSO3_GEMINI para um novo loop, o Músculo verifica se o loop anterior tem MEMORIA e relatorio em HISTORICO. Se não tiver → bloquear e alertar antes de qualquer deliberação.
**Ferramenta criada:** verificar_fechamento_loop() implementado em `session_close.ps1` — script avisa quando MEMORIA e relatorio do loop atual estão ausentes no HISTORICO.
**Aplica-se a:** todo projeto cliente Camada 1+. Loop sem artefatos de fechamento = loop fantasma.

---

### [P-045] Ritual de Fechamento de Loop é bloqueante — não opcional
**Descoberto:** 2026-05-19 | **Sessão:** Revisão PASSO files — PROJ-001 Valdece
**Evidência:** PROJ-001 Valdece chegou no Loop 4 sem MEMORIA_V2/V3 e relatorio_V2/V3. Os loops 2 e 3 aconteceram (há DIRETRIZ V2 e V3 no HISTORICO), mas o Músculo não gerou os artefatos de fechamento. O preparar_notebooklm enviou contexto do Loop 1 para o NotebookLM do Loop 4 — o Auditor deliberou com 3 loops de defasagem.
**Princípio:** Ao receber PASSO3_GEMINI para o loop N, o Músculo PRIMEIRO verifica:
  `CLIENTES/[CLIENTE]/HISTORICO/MEMORIA_V[N-1]_[CLIENTE].md` — existe?
  `CLIENTES/[CLIENTE]/HISTORICO/relatorio_evolutivo_V[N-1]_[CLIENTE].md` — existe?
  Se não existirem → emitir BLOQUEIO: "Diretor, o loop [N-1] não tem artefatos de fechamento. Gerar MEMORIA_V[N-1] + relatorio_V[N-1] antes de iniciar o Loop [N]. Sem esses artefatos, o Auditor do próximo loop delibera com contexto defasado."
**Aplica-se a:** todo projeto cliente Camada 1+. O loop não começa sem o anterior fechado.

---

### [P-046] Contrato segue teste — nunca precede
**Descoberto:** 2026-05-19 | **Sessão:** Formalização pós-entrega presencial PROJ-001 Valdece
**Fricção:** O contrato do Valdece foi assinado antes da ferramenta ser testada no dispositivo e na rede real do cliente. Na entrega presencial, a ferramenta falhou. O contrato já estava assinado. Trabalho de recuperação foi necessário. Situação inteiramente evitável.
**Princípio:** A sequência obrigatória é:
1. **Testar internamente** — no ambiente de produção, no dispositivo equivalente ao do cliente, em rede externa
2. **Validar com o cliente** — cliente usa a ferramenta antes da reunião de assinatura e confirma funcionamento
3. **Assinar** — contrato formaliza entrega que já funciona, não promessa de que vai funcionar
4. **Entregar** — handoff, Sovereign Playbook, credenciais

O contrato é o ponto de chegada do processo de teste — nunca o ponto de partida.

**Causa raiz:** Pressão de timing comercial + confiança no código testado apenas no ambiente de desenvolvimento. "Funciona no meu computador" não é gate de aprovação.
**Ferramenta criada:** `PENTALATERAL_UNIVERSAL/OPERACAO/PROTOCOLO_TESTES_PRE_ASSINATURA.md` — checklist de 8 itens (Fase 1 interna) + script de envio ao cliente (Fase 2) + nova cláusula contratual de validação prévia.
**Regra de ouro:** Pressão para assinar rápido é sinal de alerta — não de agilidade. Cliente que confia espera 48h de teste. O custo do protocolo é 2h. O custo da falha pós-assinatura é a credibilidade.
**Responsabilidade:** O Diretor é o único que autoriza o avanço para assinatura. O Músculo não tem autonomia para comprimir este protocolo sob nenhuma circunstância.
**Aplica-se a:** todo projeto com cliente externo, qualquer valor, qualquer prazo, qualquer nível de confiança no código.

---

### [P-076] Pendente identificado = registrar imediatamente — não confiar na memória da sessão
**Descoberto:** 2026-05-20 | **Renumerado:** 2026-05-27 (era P-048 duplicado — P-048 correto é "Deliberação do Músculo") | **Sessão:** PROJ-001 Valdece Loop 7 + revisão de processo
**Fricção:** O Diretor perguntou "não tínhamos de levar jurisprudências do STF?" — tarefa identificada em sessão anterior mas nunca registrada formalmente. Quando o contexto compactou, o pendente sumiu. Eduardo: "Se eu não lembro, ficaríamos perdidos. Imagina com 30 projetos."
**Princípio:** Toda tarefa identificada como pendente durante uma sessão → registrar em `PENDENTES.md` na raiz IMEDIATAMENTE, antes de qualquer outra ação. Não esperar `session_close.ps1`. Não confiar na memória da conversa. O `session_close` complementa — não substitui.
**Ferramenta criada:** `PENDENTES.md` na raiz do repositório — lido pelo `briefing_diario.ps1` toda manhã. Formato: `- [ ] \`YYYY-MM-DD\` **descrição**`. Músculo marca `[x]` ao concluir e remove no `session_close`.
**Regra de ouro:** Se foi dito "precisa ser feito" e não está no PENDENTES.md ou no `proximo_passo` do WIP_BOARD, não existe. Memória de sessão não é instrumento de gestão — arquivo é.
**Aplica-se a:** toda sessão, todo projeto, todo processo. Escala para N projetos sem degradação.

---

### [P-047] Engajamento inaugural alto é receptividade — não hábito formado
**Descoberto:** 2026-05-20 | **Sessão:** PROJ-002 Ingrid Loop 4 Gate Dia 8
**Fricção:** Ingrid chegou à Q18 na sessão inaugural, reportou bug de formatação com precisão cirúrgica. O Músculo e o Embaixador quase rotularam como "VERDE CONSOLIDADO". O Embaixador freou: engajamento inaugural ≠ hábito. SM-2 ainda não cobrou, a novidade não acabou.
**Princípio:** O termômetro de retenção real são as sessões 3-5, quando o SM-2 começa a cobrar revisões difíceis e o efeito de novidade evaporou. Sessão 1 excelente = receptividade confirmada. Hábito = padrão repetido sem incentivo externo.
**Temperatura correta:** VERDE FRÁGIL — não VERDE CONSOLIDADO — até sessão 3-5 com dados de retorno.
**Aplica-se a:** todo projeto EdTech ou de hábito com usuário piloto.

---

### [P-048] Deliberação do Músculo é documento persistente — nunca contexto volátil
**Descoberto:** 2026-05-20 | **Sessão:** PROJ-002 Ingrid Loop 4 Deliberação
**Fricção:** A deliberação completa (PASSO A-H com 25 inputs analisados nos 7 pontos) foi executada na sessão anterior. O contexto comprimiu antes do Diretor revisar. O veredito foi pedido sem Eduardo ter lido a análise. "Isso sempre acontece."
**Princípio:** Após PASSO G e antes de PASSO H, o Músculo salva obrigatoriamente a deliberação em `CLIENTES/[NOME]/HISTORICO/DELIBERACAO_LOOP_[N]_[CLIENTE].md`. PASSO H (veredito) só começa com arquivo confirmado no disco. Diretor lê o arquivo — não depende do contexto da sessão.
**Ferramenta criada:** PASSO G.5 adicionado em todos os arquivos PASSO6_MUSCULO — gate obrigatório entre deliberação e veredito.
**Regra de ouro:** Contexto de sessão é RAM — volátil. Arquivo em disco é HD — persistente. Deliberação que não está no HD não aconteceu.
**Aplica-se a:** todo loop de todo projeto do Pentalateral IAH.

---

### [P-049] Output do Auditor é irrecuperável após fechar o NotebookLM
**Descoberto:** 2026-05-20 | **Sessão:** PROJ-002 Ingrid Loop 4 pós-compressão de contexto
**Fricção:** As PARTES 1+2+4 do Auditor (Auditoria de Coerência, Perspectiva do Sócio, [N-1 a N-5]) foram perdidas na compressão de contexto. O Músculo deliberou os [N-1 a N-5] apenas pelos títulos — sem o conteúdo completo. 5 inputs deliberados com informação parcial.
**Princípio:** Ao receber o output do Auditor, antes de sair do NotebookLM: salvar PARTES 1+2+4 em `CLIENTES/[NOME]/HISTORICO/AUDITOR_LOOP_[N]_[CLIENTE].md`. Só então copiar a PARTE 3 (Skill) para `.claude/skills/`. A sequência correta de cópia é: (1) salvar tudo, (2) copiar Skill, (3) rodar gate.
**Regra de ouro:** NotebookLM não tem memória entre sessões. Quando você fecha, o output vai junto. O que não está em arquivo não existe.
**Ferramenta criada:** Gate P-049 adicionado ao final da seção COMANDO CURTO em todos os arquivos PASSO5_NOTEBOOKLM.
**Aplica-se a:** todo loop de todo projeto do Pentalateral IAH.

### [P-050] Teste integrado ao processo — não etapa final
**Descoberto:** 2026-05-21 | **Sessão:** PROJ-001 Valdece V3 — pós-deploy
**Fricção:** Após migração de schema (`vector(768)→3072`), re-embedding completo e deploy no Netlify, o primeiro teste real da busca revelou erro "different vector dimensions 3072 and 768" — a função `search_documents()` ainda tinha a assinatura antiga. O bug existia desde o Dia 1 da migração e só foi detectado no final da sessão, porque nenhum checkpoint de teste foi executado após cada passo.
**Princípio:** Teste de caminho principal (golden path) é obrigatório após cada passo técnico irreversível — não apenas ao fechar a sessão. A ordem correta é: executar passo → testar imediatamente → só então avançar. Teste postergado = bugs acumulados que chegam juntos no final.
**Checkpoints obrigatórios em projetos de busca semântica:**
1. Após aplicar schema → testar INSERT de documento dummy
2. Após criar função de busca → testar via SQL Editor com embedding fake
3. Após re-embedding → testar via curl/Postman contra a função
4. Após deploy de frontend → testar busca real no navegador antes de commitar
5. Após qualquer mudança de modelo de embedding → verificar se frontend e função têm o mesmo número de dims
**Ferramenta:** Músculo usa Playwright para abrir o frontend imediatamente após cada deploy e rodar busca de teste. Console errors e erros visuais são tratados na mesma sessão — nunca postergados.
**Regra de ouro:** "Se funcionou no código mas não testei ao vivo, não funcionou."
**Aplica-se a:** todo projeto com busca semântica, deploy de frontend, ou migração de schema no Pentalateral IAH.

### [P-051] Teste remoto valida a cena do cliente — não a funcionalidade genérica
**Descoberto:** 2026-05-21 | **Sessão:** PROJ-001 Valdece V3 — testes via Playwright
**Fricção:** Os primeiros testes foram feitos com termos genéricos ("prisão preventiva excesso de prazo"). O correto é testar com os termos e cenários exatos que o cliente descreveu no discovery — é a única forma de confirmar que o sistema entrega o que foi prometido, não apenas que roda.
**Princípio:** O roteiro de testes remotos de cada projeto é derivado diretamente da cena de sucesso (P-041) e das palavras usadas pelo cliente no discovery. Testar com termos técnicos genéricos valida o motor. Testar com os termos do cliente valida a entrega.
**Como aplicar:**
1. Ao criar CLIENTES/[NOME]/KNOWLEDGE_BASE/INDEX.md → incluir seção "ROTEIRO DE TESTES DO CLIENTE" com 3-5 queries derivadas do discovery
2. Antes de todo deploy → rodar os testes do cliente via Playwright, não apenas queries genéricas
3. Ao fechar o gate de entrega → screenshot dos resultados com os termos do cliente = evidência da entrega
**Exemplo Valdece:** cliente descreveu que usa HC, RHC, flagrante ilegal, excesso de prazo, pena reduzida → são esses os termos do roteiro de teste, não "busca semântica funcionando".
**Nas interações com o cliente:** o teste remoto via Playwright é executado ao vivo durante a sessão com o cliente — Eduardo relata o que o cliente pediu, o Músculo roda a busca com aquele termo exato e captura o screenshot. O cliente vê o sistema respondendo à própria demanda, não a um demo genérico. Isso fecha o ciclo de confiança.
**Três momentos obrigatórios:**
1. **Pré-entrega** (interno) — confirmar que os termos do discovery retornam resultados relevantes
2. **Na entrega** (com o cliente) — rodar ao vivo os termos que o próprio cliente disse no discovery
3. **Pós-sessão** (debrief) — Embaixador registra quais termos o cliente quis testar na hora → alimentar MEMORIA_EMBAIXADOR
**Conexão:** P-041 (cena de sucesso), P-044 (toda decisão técnica avaliada contra a cena do cliente), P-050 (teste integrado ao processo).
**Aplica-se a:** todo projeto com entrega de produto ao cliente no Pentalateral IAH.

---

### [P-052] Estrategista requer MASTER de ativação em toda sessão — a amnésia é estrutural
**Descoberto:** 2026-05-23 | **Emitido por:** Embaixador + validado pelo Músculo
**Fricção:** O Estrategista (Gemini) não tem memória persistente entre sessões. Toda sessão começava do zero — o Diretor precisava carregar múltiplos documentos manualmente antes de qualquer interação útil. O overhead de onboarding recaía sobre o recurso mais escasso do sistema (atenção do Diretor).
**Princípio:** Toda sessão com o Estrategista começa com o `COMANDO_ESTRATEGISTA_MASTER_v[N].md` colado como PRIMEIRA mensagem. O MASTER é o equivalente funcional da memória persistente — compila identidade, estado atual dos projetos, modelo de negócio, princípios relevantes do LEDGER, deficiências conhecidas, formato de entrega e inventário de ferramentas.
**Manutenção:** O Músculo atualiza o MASTER automaticamente quando atualiza o WIP_BOARD.json — são o mesmo dado. Não há prompts interativos; a manutenção é automática.
**Decisão deliberada:** Não migrar o Estrategista para Claude Projects — perderia busca na web. O MASTER é a ponte certa para o estágio atual.
**Arquivo:** `PENTALATERAL_UNIVERSAL/OPERACAO/COMANDO_ESTRATEGISTA_MASTER_v1.md`
**Aplica-se a:** toda sessão com o Estrategista (Gemini), qualquer projeto, qualquer loop.

---

### [P-053] MANIFESTO_DE_FONTES declara o que o Auditor pode e não pode ver
**Descoberto:** 2026-05-23 | **Emitido por:** Expansão do Pentalateral IAH — DEF-N-4
**Fricção:** O Auditor (NotebookLM) auditava com base nas fontes carregadas, mas nunca declarava explicitamente quais fontes estavam presentes nem qual período coberto. Um Auditor que não sabe o que não vê é um Auditor com ponto cego invisível.
**Princípio:** Em todo loop do Auditor, o NOTEBOOKLM_FONTES/ deve conter um `MANIFESTO_DE_FONTES.md` que declara: (a) quais documentos estão carregados e em qual posição, (b) período coberto (data do mais antigo ao mais recente), (c) o que está ausente e por quê, (d) qual fonte é a mais recente e portanto de maior peso. O Auditor lê o MANIFESTO antes de qualquer análise.
**Impacto:** Skill baseada em fontes declaradas = Skill com rastreabilidade. Auditor que não sabe o que não viu = Skill com ponto cego silencioso.
**Arquivo template:** `PENTALATERAL_UNIVERSAL/TEMPLATES/MANIFESTO_DE_FONTES_TEMPLATE.md`
**Aplica-se a:** todo loop de todo projeto do Pentalateral IAH.

---

### [P-054] Toda operação de substituição em massa exige verificação com grep imediata
**Descoberto:** 2026-05-23 | **Emitido por:** Falha de processo detectada pelo Diretor — varredura de renomeação do sistema antigo → PENTALATERAL IAH
**Fricção:** O rename massivo do sistema antigo → PENTALATERAL IAH foi executado (234 arquivos via `git mv`), mas padrões específicos de texto interno (nomenclatura legada, ciclo desatualizado de 20-ideias) não foram capturados na primeira passagem. O Músculo declarou "feito" sem provar. O Diretor teve que fazer auditoria manual — 51 arquivos ainda desatualizados.
**Princípio:** Após QUALQUER operação de substituição em massa, o Músculo NUNCA declara "concluído" antes de rodar grep e confirmar zero ocorrências do termo antigo. Declarar "feito" sem provar = desinformação de processo.
**Regra derivada:** `scripts/auditar_consistencia.ps1` roda automaticamente no `session_close.ps1`. VERMELHO bloqueia o encerramento. O gate não depende da disciplina do Músculo — é estrutural.
**Ferramenta:** `scripts/auditar_consistencia.ps1` — verifica padrões proibidos em todos os arquivos operacionais. VERDE/AMARELO/VERMELHO. Integrado ao `session_close.ps1` como gate obrigatório.
**Aplica-se a:** qualquer rename, refactor de nomenclatura, atualização de versão, ou substituição de termo em escala — em qualquer projeto ou repositório do Pentalateral.

### [P-055] Estado real de projeto NUNCA vem do resumo de sessão — vem dos arquivos
**Descoberto:** 2026-05-23 | **Emitido por:** Falha de processo detectada pelo Diretor — skill number errado propagado de sessão compactada
**Fricção:** O resumo de sessão dizia "ingrid-v3 NUNCA GERADA — Loop 4 bloqueado." O Músculo repetiu essa afirmação ao Diretor sem verificar os arquivos reais. Na realidade, `ingrid-v4.md` existia com "Gate Dia 8 APROVADO 2026-05-19" e Loop 4 estava concluído. O Diretor identificou o erro ao perceber que o número da skill parecia errado.
**Princípio:** Ao retomar sessão compactada, o Músculo NUNCA repete afirmações de estado de projeto sem verificar: (a) skills reais em `.claude/skills/`, (b) `dias_completos` no `WIP_BOARD.json`, (c) gates aprovados nos arquivos de skill ativos. Resumo de sessão é ponto de partida, não prova de estado.
**Regra derivada:** `scripts/verificar_estado_projetos.ps1` roda automaticamente no `session_start.ps1`. Injeta estado real (skills em disco + dias concluídos) antes de qualquer declaração do Músculo.
**Ferramenta:** `scripts/verificar_estado_projetos.ps1` — lista skills reais por projeto, dias_completos, próximo gate. Injetado no context do session_start como "ESTADO REAL DOS PROJETOS (P-055)".
**Aplica-se a:** qualquer sessão retomada após compactação — especialmente quando há projetos em BUILD com múltiplos loops.

### [P-056] Deploy GitHub Pages exige sync explícito master → gh-pages
**Descoberto:** 2026-05-23 | **Emitido por:** PROJ-002 Ingrid — Dia 12 Loop 5 — 4h de diagnóstico
**Fricção:** Commits de Loop 4 e Loop 5 foram para `master`. GitHub Pages serve da branch `gh-pages`. O app em produção ficou parado no Loop 3 por semanas. Usuário (Ingrid) recebia código antigo. O Músculo declarou features "deployadas" sem verificar a branch que o GitHub Pages serve. Cache, SW, Ctrl+Shift+R — nada funcionou porque o arquivo errado estava em produção.
**Princípio:** Ao usar GitHub Pages com branch `gh-pages` separada, o Músculo NUNCA declara deploy concluído sem provar que o conteúdo correto está na branch que o GH Pages serve. Verificação: `git show gh-pages:app.js | head -3` — confirma a versão em produção.
**Regra derivada:** Ao fechar qualquer sessão com mudanças em frontend Ingrid → rodar o script de sync:
```bash
git checkout gh-pages
git show master:CLIENTES/INGRID/frontend/app.js > app.js
# ... (demais arquivos)
git commit -m "deploy(gh-pages): ..." && git push origin gh-pages
git checkout master
```
**Ferramenta:** Criar `scripts/deploy_ingrid_ghpages.ps1` — automatiza o sync master → gh-pages com um comando.
**Aplica-se a:** PROJ-002 Ingrid e qualquer outro projeto que use GitHub Pages com branch separada.

---

### [P-057] Abandono em EdTech ocorre no pico — não no vale
**Descoberto:** 2026-05-24 | **Emitido por:** PROJ-002 Ingrid — Loop 5 — observação do Embaixador
**Fricção:** Ingrid obteve resultado acima da média no primeiro simulado e sumiu por 3 dias. Expectativa era que resultado positivo gerasse hábito. Na realidade, resultado positivo gera sensação de "missão cumprida" e reduz urgência de retorno.
**Princípio:** O momento de maior vulnerabilidade de abandono em produto EdTech é imediatamente após o primeiro resultado positivo — o aluno sente que "já aprendeu" e reduz frequência antes de formar hábito. Resultado acima da média sem engajamento nos 3 dias seguintes é sinal de churn em formação, não sinal de satisfação.
**Regra derivada:** CHURN-WATCH deve ser acionado automaticamente quando engajamento cai após resultado acima da média. A mensagem de retenção não celebra o resultado — ela reacende a urgência do próximo gap.
**Aplica-se a:** Todos os produtos EdTech/SaaS com ciclo de aprendizado por repetição.

---

### [P-058] Ir ao Gemini com loop técnico incompleto é presentear o Estrategista com estado truncado
**Descoberto:** 2026-05-24 | **Emitido por:** Músculo — deliberação de processo Loop 5 Ingrid
**Fricção:** Ao planejar ir ao Gemini antes de fechar o Dia 13, o Músculo identificou que o Estrategista responderia com base em estado incompleto — sem o output técnico do dia, sem os gates aprovados, sem os artefatos reais.
**Princípio:** Ir ao Gemini antes de fechar o loop técnico é presentear o Estrategista com estado incompleto. O Estrategista é stateless — responde exatamente com o que recebe. Contexto truncado → DIRETRIZ truncada → Skill errada → Loop perdido. A sequência correta é: fechar dia técnico → commit → ir ao Gemini com estado completo.
**Regra derivada:** `gemini_anchor_generator.ps1` só deve ser rodado após o último commit do loop corrente. O gate P-045 (MEMORIA + relatorio) reforça esta regra: se não existem → loop não fechou → Gemini ainda não recebe.
**Aplica-se a:** O loop técnico do projeto ESPECÍFICO em andamento. Não trava projetos paralelos — se o Dia 13 de Ingrid está aberto, isso não impede ir ao Gemini para Valdece ou para Discovery de novo nicho.
**Escopo explícito:** P-058 é por-projeto, não por-sistema. Correção inscrita após Auditor Ingrid detectar risco de "Blackout Estratégico" em 2026-05-24.

---

### [P-059] Isolamento de Contexto por Cliente é Lei — 20 Projetos Simultâneos Exigem Controle Rígido
**Descoberto:** 2026-05-24 | **Emitido por:** Diretor — alerta arquitetural ao prever escala de 20 projetos
**Fricção:** Com 2 projetos, selecionar "primeiro em BUILD" é tolerável. Com 20, auto-seleção silenciosa é risco direto: veredito executado no cliente errado, mensagem de WhatsApp enviada para destinatário errado, LEDGER contaminado com contexto de projeto diferente. O incidente com contexto errado em escala é irrecuperável sem rastreabilidade explícita.
**Regras derivadas:**
- Todo script que toca um cliente DEVE exigir `-cliente [NOME]` explícito OU listar opções e aguardar escolha — nunca auto-selecionar quando há mais de 1 projeto ativo
- DECISOES.json DEVE conter `"cliente"` e `"loop"` como primeiros campos (schema v1.1+) — Músculo valida antes de listar qualquer decisão
- Quando Eduardo cola output do Embaixador no Claude Code, a primeira resposta do Músculo é sempre: `CLIENTE DETECTADO: [NOME] · Loop [N] · confirmar? (s/não)` — sem exceção
- Nenhuma execução de veredito começa sem confirmar que o `cliente` do JSON corresponde ao projeto que Eduardo indicou
- Qualquer script de automação (monitor_hypercare, sync, session_close) deve logar explicitamente "Processando [CLIENTE]" para cada projeto — logs misturados = diagnóstico impossível
**Aplica-se a:** todos os scripts de orquestração, ao comportamento do Músculo ao interpretar DECISOES.json, e a qualquer feature nova que precise identificar o cliente ativo.

---

### [P-060] Músculo é responsável por toda propagação — zero intervenção do Diretor
**Descoberto:** 2026-05-24 | **Emitido por:** Diretor — alerta sistêmico após sessão com múltiplas atualizações manuais
**Fricção:** Em uma única sessão, Eduardo precisou apontar: SKILL_PROTOCOLO desatualizado, MASTER desatualizado, bug em `ir_ao_embaixador.ps1`, schema sem campos de isolamento, LEDGER sem P-059, documentos não propagados para todos os clientes. O Músculo corrigiu tudo — mas só depois de Eduardo detectar. Com 20 projetos, isso é inviável. O Diretor delibera e decide. Não gerencia documentos.
**Regras derivadas:**
- Após qualquer mudança em arquivo-fonte → `propagate_changes.ps1` roda automaticamente (DEPENDENCY_MAP.json define o cascade)
- Após criar ou editar qualquer `.ps1` → `validate_scripts.ps1` roda antes de reportar "concluído"
- O Músculo nunca diz "lembre de atualizar X" — ele atualiza e reporta o que fez
- Se Eduardo apontou um documento desatualizado → DEF-M-6 ativada → Músculo registra a falha e fortalece o cascade
- Sessão encerra somente após `session_close.ps1` confirmar propagação verde
**Ferramentas criadas:** `scripts/propagate_changes.ps1` · `scripts/validate_scripts.ps1` · `PENTALATERAL_UNIVERSAL/OPERACAO/DEPENDENCY_MAP.json`
**Aplica-se a:** toda sessão de build, toda criação de script, toda atualização de documento universal, toda mudança de schema.

---

### [P-061] Nenhuma API key de terceiro pertence ao frontend — proxy obrigatório
**Descoberto:** 2026-05-24 | **Emitido por:** Auditor Valdece — segurança contratual
**Fricção:** `GEMINI_KEY` exposta em `index.html` no repo público. Qualquer pessoa com acesso ao código-fonte podia usar a chave de API do Google AI Studio a custo do Valdece/Vanguard. O risco só foi detectado em auditoria de segurança, não antes do deploy.
**Princípio:** Toda chave de API de serviço externo (Google, OpenAI, Anthropic, Stripe, etc.) é removida do frontend e movida para variável de ambiente do servidor. O frontend chama um proxy interno — Netlify Function, Supabase Edge Function ou backend próprio — que executa a chamada à API de forma segura.
**Regra derivada:** `hv1_credential_guard.ps1` detecta padrões de chave em arquivos `.html`, `.js`, `.ts`. Hook de commit bloqueia se encontrar `AIzaSy` (Google) ou `sk-` (OpenAI) fora de arquivos `.env.*`. O padrão Supabase anon key é aceitável no frontend apenas se RLS estiver ativo na tabela.
**Ferramenta criada:** `CLIENTES/VALDECE/netlify/functions/embed.js` — proxy Netlify que serve embeddings Gemini sem expor a chave. Chave configurada em Netlify → Site Settings → Environment Variables → `GEMINI_API_KEY`.
**Aplica-se a:** todo projeto com chamadas a APIs pagas de terceiros — Valdece, Ingrid, qualquer projeto futuro da Vanguard.

---

### [P-063] Músculo lê PENDENTES.md completo como primeiro ato de qualquer sessão
**Descoberto:** 2026-05-24 | **Emitido por:** Diretor — falha de processo recorrente confirmada
**Fricção:** O hook injeta apenas TÍTULOS das tarefas (ex: "Loop 5 — Gemini PASSO 3"). As instruções detalhadas — arquivos exatos, sequência, o que colar onde — estão no corpo do PENDENTES.md. O Músculo via os títulos e inventava a execução em vez de seguir o que estava escrito. Eduardo teve que dizer explicitamente "Veja o arquivo PENDENTES" — falha de processo confirmada.
**Princípio:** O PENDENTES.md é o roteiro da sessão. Músculo que age apenas com os títulos do hook está improvisando sobre um roteiro que já existe. "Já está escrito" vence sobre "minha análise". Leitura do arquivo completo não é opcional — é o pré-requisito para qualquer deliberação.
**Regras derivadas:**
- `Read("PENDENTES.md")` é a PRIMEIRA ferramenta chamada em qualquer sessão — antes de qualquer resposta ao Diretor
- Antes de executar qualquer tarefa: verificar se o PENDENTES já descreve como fazê-la. Se sim, seguir. Se não, deliberar e registrar antes de executar.
- Hook atualizado: `Get-PendentesAlert` agora injeta título + sub-bullets de cada tarefa (máx 6 linhas por item) para o Músculo ter as instruções no contexto
- CLAUDE.md atualizado: item 23 do bloco "O QUE VOCÊ NUNCA ESQUECE"
**Aplica-se a:** toda sessão do Pentalateral IAH — sem exceção de projeto ou urgência.

---

### [CANDIDATO_A_PRINCIPIO — ARQUITETURAL] LEDGER por índice semântico + compactação cíclica (P-059+ escala)
**Proposto por:** Diretor Eduardo — 2026-05-24 | **Contexto:** P-058 inscritos · 20 projetos previstos
**Fricção prevista:** Com 20 projetos e 3-4 princípios/sessão, o LEDGER ultrapassa 300 entradas em 6 meses (~15.000 linhas). Lost-in-the-Middle (DEF-G-3/DEF-N-3) vai degradar a leitura dos princípios intermediários. O Protocolo de Imunidade se torna o próprio gargalo.
**Decisão arquitetural proposta:**
- `LEDGER_INDEX.md` — índice curto (1 linha/princípio + tags de categoria e nicho) — lido em toda sessão
- `LEDGER_[CATEGORIA].md` — detalhe por categoria (Legal-Tech / EdTech / Processo / Universal) — lido sob demanda
- Compactação cíclica a cada 90 dias: Músculo mescla princípios redundantes, arquiva superseded, mantém ≤60 ativos por arquivo
- Skills de cliente contêm os princípios específicos do nicho — LEDGER universal é fonte-mãe, não operação diária
**Gate para implementação:** ativar quando houver ≥10 projetos simultâneos ou ≥80 princípios no LEDGER.
**Responsável pela execução:** Músculo — sem intervenção do Diretor.
**Aguarda:** aprovação formal do Diretor quando gate for atingido.

---

### [P-062] Nenhum script de orquestração novo enquanto houver MRR não fechado em projeto ativo
**Descoberto:** 2026-05-24 | **Emitido por:** Auditor Ingrid — alerta DEF-M-5 coletiva
**Fricção:** O Pentalateral produziu infraestrutura de excelência (22+ scripts de orquestração) enquanto o primeiro MRR (Manutenção Soberana Valdece) permanecia sem data de fechamento. Sistema mais sofisticado que o negócio que sustenta. A sofisticação técnica mascarou a ausência de receita.
**Princípio:** Nenhum script de orquestração novo é criado enquanto houver contrato de MRR ou renovação não fechado em projeto ativo. A métrica de saúde do sistema é MRR fechado, não scripts funcionando.
**Regra derivada:** Ao iniciar qualquer sessão: verificar WIP_BOARD → campo `retainer`. Se vazio e há projeto em `entregue` → bloquear criação de script novo e alertar o Diretor. A deliberação de processo vem depois da deliberação comercial, não antes.
**Aplica-se a:** todo projeto do Pentalateral IAH com entrega concluída. Bloqueante para PROJ-001 Valdece enquanto Manutenção Soberana não for assinada.

---

### [P-064] Smoke test obrigatório antes de chamar o Diretor — deploy sem evidência é inválido
**Descoberto:** 2026-05-24 | **Emitido por:** Diretor — "Imagine com 20 projetos? Se eu não testasse, ficaríamos perdidos"
**Fricção:** Músculo fez push do proxy Netlify e declarou "pronto". Eduardo testou e encontrou erro (Edge Function syntax no lugar de Serverless Function). O Diretor não deve ser o testador primário de deploys — esse papel é do Músculo.
**Princípio:** Nenhum deploy é declarado "pronto" sem smoke test automatizado executado pelo Músculo. O Diretor testa apenas o golden path após o smoke test passar. Com 20 projetos simultâneos, o Diretor seria consumido por testes manuais se o Músculo não validar antes.
**Regra operacional:**
- Após todo `git push` para projeto com `smoke_tests.json`: rodar `scripts/smoke_test_deploy.ps1 -cliente [NOME]`
- Se PASSOU: "Deploy validado. Diretor pode testar o golden path."
- Se FALHOU: Músculo resolve antes de avisar Eduardo — nunca o contrário
- Arquivo de config por projeto: `CLIENTES/[NOME]/smoke_tests.json`
- Template universal: `scripts/smoke_tests_template.json`
**Aplica-se a:** todo deploy de produto cliente (Netlify, GitHub Pages, qualquer hospedagem).

---

### [CANDIDATO_A_PRINCIPIO] O cliente que sinaliza escopo por áudio antes de assinar vai sinalizar por mensagem depois de assinar
**Proposto por:** Embaixador Valdece — 2026-05-24 | **Aguarda:** numeração do Diretor
**Fricção:** Valdece enviou 5 áudios sobre V3 (data_dje, turma, repercussao_geral) antes de assinar. O mesmo padrão se repete pós-contrato via mensagem. Pipeline sem travamento de escopo antes do primeiro uso = Eduardo respondendo a scope creep sem perceber que é scope creep.
**Princípio candidato:** O cliente que sinaliza escopo antes de assinar vai sinalizar depois de assinar. O pipeline precisa estar travado (flag `requer_uso_confirmado`) antes do primeiro uso, não depois do primeiro pedido. Reativo é sempre mais caro que preventivo.
**Gate implementado:** `requer_uso_confirmado: true` no DECISOES.json bloqueia opção `plantar_hoje` para features V2/V3 até uso ativo confirmado.

---

### [CANDIDATO_A_PRINCIPIO] Automação que falha silenciosamente é pior que ausência de automação
**Proposto por:** Embaixador Ingrid — 2026-05-24 | **Aguarda:** 1 ocorrência adicional ou aprovação direta do Diretor
**Fricção:** VEREDITOS_RESUMO.md gerado mas não sincronizado → Embaixador abre sessão sem rastreabilidade de decisões sem saber que perdeu o contexto. A falha invisível é mais perigosa que a falha explícita — o operador age convicto de ter contexto completo quando não tem.
**Princípio candidato:** Toda automação que carrega dados críticos entre sessões deve emitir confirmação explícita de sucesso antes de prosseguir. Ausência de confirmação = falha assumida, não sucesso assumido.
**Gate implementado:** `ir_ao_embaixador.ps1` exibe "Resumo de vereditos [DATA] incluído" antes de abrir o browser. Se ausente → alerta vermelho → Eduardo decide se prossegue.


---

### [P-065] Advogado que testa antes de assinar já se vendeu — fechamento é confirmação, não persuasão (2026-05-24)
**Origem:** Valdece · Loop 7 · Embaixador
**Fricção:** Valdece enviou 5 áudios de feedback técnico antes de assinar. O comportamento de teste ativo indica decisão interna já tomada — o contrato é formalização, não gatilho. O risco não é o fechamento: é o pós-assinatura, quando ele passa de prospect para usuário real com expectativa elevada.
**Princípio:** Cliente exigente que testa ativamente antes de assinar já tomou a decisão de compra internamente. O esforço de retenção deve começar no dia da assinatura — não 30 dias depois. A régua sobe imediatamente.
**Aplica-se a:** Perfis exigentes + pré-compra engajada em qualquer nicho (LegalTech, EdTech, SaaS). Hypercare ativo no dia 1, não no dia do churn.

---

### [SESSÃO 2026-05-24] — PROJ-001 Valdece / Loop 7 · Pipeline DECISOES executado automaticamente (P-060)

**Direção da sessão:** Loop 7 completo — Gemini ✅ NotebookLM ✅ Embaixador ✅ Músculo delibera pendente · DECISOES pipeline executado sem intervenção do Diretor.

**VALIDAÇÃO P-060 — EXECUÇÃO AUTOMÁTICA REGISTRADA:**
```
Eduardo salvou: VEREDITOS_VALDECE_2026-05-24.json em CLIENTES\VALDECE\CLAUDE_PROJECT\DECISOES\
Eduardo disse: "Feito"
Músculo executou imediatamente: executar_vereditos.ps1 -projeto VALDECE
Zero prompts adicionais do Diretor. Zero intervenção manual. Pipeline funcionou.
```

**O QUE EXECUTOU:**
`[D1]` Mensagem Hypercare Dia 5 → copiada para clipboard (enviar_agora)
`[D2]` Semente de migração → log_apenas (Eduardo confirmou: credenciais já são nossas)
`[D3]` Protocolo scope creep → ativado (qualquer pedido novo = Change-Order formal)
`[D4]` Sentinel Report 2026-06-02 → WhatsApp curto confirmado
`[D5]` P-065 inscrito no LEDGER (erro de numeração automática corrigido manualmente pelo Músculo)
`[D6]` Pipeline OAB → protocolo ativo (pergunta pronta ao ouvir menção a colega)

**BUG IDENTIFICADO — executar_vereditos.ps1 linha ~145:**
`$pNum = "P-{0:D3}" -f $proximo` falha quando `$proximo` é string. Fix: `[int]$proximo` ou usar regex para extrair número. Pendente de correção no cluster.

**RESOLUÇÃO IMPORTANTE (D2):**
WIP_BOARD dizia "aguardando seed nas credenciais do Valdece" — Eduardo confirmou: credenciais obtidas no presencial 2026-05-19. O V3 build pode iniciar imediatamente. Sem dependência de Valdece.

**Documentos criados/atualizados:**
- `CLIENTES/VALDECE/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md` — Loop 7 + P-065 + temperatura score 6.5
- `CLIENTES/WIP_BOARD.json` — VALDECE loop_fase_atual: notebooklm=OK, embaixador=OK
- `INTELLIGENCE_LEDGER.md` — P-065 inscrito
- `CLIENTES/VALDECE/HISTORICO/AUDITOR_LOOP_7_VALDECE.md` — criado
- `CLIENTES/VALDECE/DIRETRIZ_GEMINI_V7.txt` — salvo em localização permanente
- `CLIENTES/VALDECE/CLAUDE_PROJECT/DECISOES/VEREDITOS_RESUMO_VALDECE_2026-05-24.md` — gerado


### [SESSAO 2026-05-25]

`[FRICCAO]` Protocolo de encerramento definia destino do PAINEL como "Claude Project do Diretor" mas o projeto nao existia — Musculo inventou destino sem verificar
`[PRINCIPIO]` P-066: PAINEL_ATIVIDADES vai ao projeto "Embaixador — Diretor" no Claude.ai — destino fixo, explícito, criado pelo Diretor em 2026-05-25

---

### [P-066] PAINEL_ATIVIDADES tem destino fixo — "Embaixador — Diretor" no Claude.ai
**Descoberto:** 2026-05-25 | **Sessão:** Protocolo de Encerramento
**Fricção:** Músculo inventou destino ("Claude Project do Diretor") que não existia. Eduardo apontou: o projeto correto é "Embaixador — Diretor" — criado explicitamente para este fim.
**Princípio:** O PAINEL_ATIVIDADES gerado por `generate_protocolo_encerramento.ps1` vai SEMPRE para o Claude Project "Embaixador — Diretor". Destino fixo, sem inferência. Músculo não decide destino — executa destino declarado pelo Diretor.
**Aplica-se a:** todo ritual de fechamento de sessão.

---

### [P-067] Músculo bloqueado até Embaixador reagir — gate automático pós-Skill aprovada
**Descoberto:** 2026-05-26 | **Sessão:** Loop 5 Ingrid — PASSO5 NotebookLM
**Fricção:** Músculo disse "quando trouxer o output do Auditor, o Músculo delibera" — pulando o Embaixador. Eduardo: "Nãooooo!!!!! Tem o embaixador!!!!" Falha identificada: compactação de contexto apagou a distinção entre "Skill aprovada" e "ciclo completo".
**Princípio:** Após Skill APROVADA pelo gate, o ciclo não está completo. Ordem inviolável: Gemini → NotebookLM → **Embaixador** → Músculo. O gate `skill_parser_gate.ps1` exibe bloco P-067 bloqueante após todo APROVADO e oferece auto-run de `ir_ao_embaixador.ps1`. Músculo que delibera sem Embaixador entrega análise de 20 inputs, não 25 — e ignora o único membro com memória real do cliente.
**Gate implementado:** `skill_parser_gate.ps1` — bloco "PRÓXIMO PASSO BLOQUEANTE — P-067" após todo resultado APROVADO.
**Aplica-se a:** todo loop de todo projeto — sem exceção.

---

### [P-068] Síntese P-037 antes do Painel é bloqueante — Diretor decide, não processa
**Descoberto:** 2026-05-27 | **Sessão:** Loop 5 Ingrid — Síntese pós-Embaixador
**Fricção:** Músculo apresentou o Painel de Deliberação (D1–D5 com opções A/B/C) sem fazer a síntese P-037 das 25 ideias. Eduardo perguntou "As ideias dos sócios, sua análise e sugestão estão aí?" — resposta foi NÃO. O Diretor recebeu decisões sem contexto analítico: exatamente o que P-037 proíbe.
**Causa raiz:** compactação de contexto apagou distinção entre "apresentar Painel" e "apresentar síntese P-037". O sumário dizia "apresentar as 5 decisões" — Músculo executou literalmente.
**Princípio:** Antes de qualquer Painel de Deliberação chegar ao Diretor, o Músculo executa obrigatoriamente a Síntese P-037: (a) analisar cada ideia [M+G+N+E] com os 7 pontos, (b) VETO ou ENTRA ou MERGE ou V2, (c) build order com estimativas. Diretor vê 1 plano consolidado — não 25 inputs brutos para processar. Painel sem síntese = Músculo transferiu trabalho para o Diretor.
**Verificação ao retomar sessão compactada:** antes de apresentar qualquer decisão, perguntar: "A síntese P-037 já foi feita?" Se não → fazer primeiro.
**Aplica-se a:** todo ciclo do Pentalateral, pós-Embaixador, antes do veredito do Diretor.

---

### [P-069] Data calendário rege a ordem de ação — não o dia interno do projeto
**Descoberto:** 2026-05-25 | **Declarado pelo Diretor**
**Fricção:** Com múltiplos projetos ativos, o Músculo avançava projetos por ordem de contexto da conversa — não por data de vencimento calendário. Resultado: um projeto avança enquanto outro acumula pendências do mesmo dia. Em escala de 20 projetos, isso cria cinco projetos adiantados e três com débito do dia.
**Princípio:** O dia interno do projeto (ex: "Dia 16") deve ter correspondência explícita com uma data calendário (ex: 2026-05-25). A data calendário é a unidade de prioridade — mandatória, sem exceção. Ao iniciar qualquer sessão, o Músculo pergunta: "O que está pendente HOJE por data calendário em TODOS os projetos ativos?" e apresenta o mapa completo ao Diretor antes de qualquer ação.

**Modelo de execução:**
- Gates bloqueados por decisão do Diretor → MANTER o bloqueio + alertar o Diretor com ação específica necessária. Nunca bypassar, nunca fingir que não existe.
- Enquanto gate bloqueado aguarda Diretor → trabalhar nas pendências do mesmo dia de OUTROS projetos ativos.
- O Diretor vê o mapa completo do dia (todos os projetos) — não um projeto de cada vez. É ele quem decide onde colocar a atenção.

**Regra operacional:** Todo PENDENTES.md, WIP_BOARD e PASSO file deve conter o mapeamento `dia_projeto → data_calendário`. O briefing diário (7h) organiza por data, não por projeto. Músculo que avança Projeto A ignorando pendência do dia em Projeto B = falha de gestão, não de execução. Músculo que bypassa gate bloqueado sem autorização do Diretor = violação de processo.

**Padrão de formato obrigatório (declarado pelo Diretor em 2026-05-25):** Todo documento — PENDENTES.md, WIP_BOARD, PASSO files, PAINEL, e-mail — deve registrar dias de projeto no formato **"Dia X (DD-MM-YYYY dia-da-semana)"**. Exemplo: "Dia 15 (29-05-2026 sexta-feira)". Esta notação elimina a ambiguidade entre dia interno do projeto e data calendário. Nunca escrever apenas "Dia 15" ou apenas "2026-05-29" — sempre juntos. O mapa diário (mapa_diario_pendencias.ps1) exibe a data no RESUMO ao lado de cada item. Ferramenta de verificação: ao criar qualquer item em PENDENTES.md com "Dia X", verificar que inclui "(DD-MM-YYYY dia-da-semana)" no título.

**Por que é mandatório:** Em escala de 20 projetos, gestão por dia interno cria projetos adiantados com débito calendário acumulado invisível. A data calendário é a única unidade de medida que o Diretor e o cliente enxergam — tudo mais é ilusão operacional. Eduardo declarou: "Deve ser bloqueado, só com autorização do Diretor, que deve ser alertado. Mas temos que pensar nas pendências de todos os projetos em execução."

**Aplica-se a:** toda sessão com mais de 1 projeto ativo. Implementar: campo `calendario` no WIP_BOARD mapeando dias do projeto para datas reais.

**Mandato de assessoria permanente (declarado pelo Diretor em 2026-05-25):** "Não vou avançar em projeto algum com pendência no outro. Sempre devo ser assessorado." O Músculo apresenta o mapa completo de TODOS os projetos antes de qualquer proposta de avanço. O Diretor decide onde alocar atenção — o Músculo não seleciona por ele. Músculo que propõe avanço em Projeto A sem verificar Projeto B = falha de assessoria.

### [SESSAO 2026-05-25]

`[FRICCAO]` session_close.ps1 usa Read-Host — falha em modo non-interativo do Claude Code. Entradas de sessao (friccao, principio, deriva) nao sao capturadas automaticamente. Fix necessario: aceitar parametros via -Friccao/-Principio/-Deriva ou ler de arquivo pre-gerado pelo Musculo.

`[PRINCIPIO]` P-069 operacionalizado: formato "Dia X (DD-MM-YYYY dia-da-semana)" gravado em PENDENTES, WIP_BOARD, CLAUDE.md, LEDGER e PAINEL. mapa_diario_pendencias.ps1 atualizado para exibir data completa em todas as secoes.

`[MANDATO]` "Mensagens aos socios sempre por projeto, contextos diferentes. Eles vao alucinar. Sempre e para sempre." — declarado pelo Diretor em 2026-05-25 com enfase dupla. Cada PASSO file contem apenas informacao do projeto correspondente. Zero mistura entre Ingrid e Valdece.

`[MANDATO]` P-013 Opcao B autorizada: Ingrid cria proprio Supabase. Eduardo ja contatou Ingrid. Deadline 30-05-2026. OFFBOARDING_RUNBOOK.md + migrate_ingrid_supabase_v1.sql criados e commitados.

---

### [P-070] Onboarding Invisível — o cliente nunca cria conta
**Descoberto:** 2026-05-26 | **Sessão:** Decisão do Diretor + Embaixador
**Fricção:** Clientes avessos à tecnologia abandonam o projeto antes do kickoff quando solicitados a criar contas no Supabase, Google AI Studio ou GitHub. Evidência operacional: PROJ-002 Ingrid — atrito real gerado pelo setup técnico antes do primeiro uso.
**Princípio:** A Vanguard absorve toda fricção técnica de cadastro no kickoff. O cliente nunca cria conta. A Vanguard cria caixas de e-mail `[nome]@vanguardtech.cloud` no hPanel da Hostinger e usa essa identidade para criar todas as contas necessárias. Modo MVP (até ~5 clientes): aliases redirect para `projetos@`. Modo Escala (5+ clientes): caixas separadas por cliente. O cliente recebe um único WhatsApp com login e senha — nunca mencionar as plataformas subjacentes.
**Pré-requisitos:** (1) Termo de Uso assinado no kickoff com cláusula de autorização de criação de contas · (2) Cofre de senhas ativo (Bitwarden recomendado)
**Nota de aplicação:** Ingrid e Valdece resolvidos com abordagem pré-protocolo. Aplicar a partir do próximo cliente.
**Runbook:** `PENTALATERAL_UNIVERSAL/OPERACAO/PROTOCOLO_ONBOARDING_INVISÍVEL.md`
**Aplica-se a:** todo projeto cliente, sem exceção, desde o kickoff.

### [P-071] Sessão encerrada é fato técnico, não intenção — gate bloqueante obrigatório
**Descoberto:** 2026-05-26 | **Consolidado:** 2026-05-27 | **Emitido por:** Diretor Eduardo via Embaixador (OSV-001)
**Fricção:** [FALHA-PROCESSO-2026-05-18-D] — 2h de auditoria manual. [P-047] — 51 arquivos desatualizados declarados "feitos". [P-060] — Eduardo apontou manualmente documentos desatualizados. Com 2 projetos ativos, documentos encontrados desatualizados após encerramento recorrente. Causa raiz: `session_close.ps1` não bloqueava se sync não ocorria. Disciplina não escala — arquitetura escala.
**Princípio:** O script `session_close.ps1` é o ÚNICO ponto de saída de qualquer sessão. Executa 9 gates em sequência: auditoria → sync_docs → propagate → ledger_sync → validate → artefatos → LOG → e-mail/Telegram → PAINEL. Gates 1 (auditar_consistencia) e 5 (validate_scripts) com VERMELHO = `exit 1`. Músculo que declara "sessão encerrada" sem os 9 gates = dado falso ao Diretor.
**Princípio relacionado:** "Processo que depende de disciplina humana falha com 2 projetos e colapsa com 20. A solução é tornar o comportamento correto o único caminho disponível — não o mais recomendado."
**Implementação 2026-05-27:**
- `session_close.ps1` — 9 gates sequenciais, Gates 1 e 5 bloqueantes com `exit 1`
- `session_start.ps1` — criado do zero: AGENDA DO DIA + bloqueio DECISOES pendente + P-059
- `decisoes_watcher.ps1` — FileSystemWatcher monitora DECISOES/ e abre render_painel automaticamente
- `generate_protocolo_encerramento.ps1` — ANALISE GERENCIAL e ENTREGAS DO DIA preenchidos automaticamente
- `executar_vereditos.ps1` — bug linha ~145 corrigido; ValidateSet removido (qualquer projeto)
- `DEPENDENCY_MAP.json` — campo `projetos_ativos` adicionado (v1.1)
**Antecedentes:** P-033, P-047, P-060, [FALHA-PROCESSO-2026-05-18-D]
**Aplica-se a:** toda sessão do Pentalateral — com 1, 2 ou 20 projetos ativos. Sem exceção.

---

### [P-072] Deliberação é ato formal, não conversa — painel HTML é o único canal de veredito
**Descoberto:** 2026-05-26 (Loop 5 Ingrid executado informalmente) | **Inscrito:** 2026-05-27
**Emitido por:** Diretor Eduardo via Embaixador (OSV-001 + VEREDITOS_RESUMO_INGRID_2026-05-26.md)
**Fricção:** Gate Dia 15 da Ingrid decidido verbalmente antes do painel HTML ser aberto. VEREDITOS_RESUMO registra como "irregularidade formal". Causa raiz: nenhum mecanismo impede o Diretor de tomar decisões fora do painel. O pipeline dependia de disciplina — não de arquitetura.
**Princípio:** Decisão verbal não registrada no `DECISOES.json` = decisão que não existiu para o sistema. O painel HTML é o ÚNICO canal de deliberação formal. `session_start.ps1` detecta `DECISOES_*.json` sem `VEREDITOS_*.json` correspondente e bloqueia a sessão até deliberação formal. `decisoes_watcher.ps1` detecta novos `DECISOES_*.json` e abre o painel automaticamente. O Diretor NUNCA decide verbalmente quando existe `DECISOES.json` pendente.
**Aplica-se a:** todo loop de qualquer projeto — INGRID, VALDECE, todos os futuros. Sem exceção.
**Ferramentas:** `session_start.ps1` (bloqueio) + `decisoes_watcher.ps1` (detecção) + `render_painel.ps1` (único canal) + `executar_vereditos.ps1` (execução automática).

---

### [SESSAO 2026-05-26]

`[PRINCIPIO]` P-070 — Onboarding Invisível registrado. Cliente nunca cria conta — Vanguard cria aliases/caixas @vanguardtech.cloud e toda infraestrutura no kickoff. MVP: aliases redirect. Escala: caixas separadas. Protocolo em PENTALATERAL_UNIVERSAL/OPERACAO/.

`[PROCESSO]` P-059 compliance concluída: 18_ATUALIZACAO_PENTALATERAL + 16_ALERTA_CONFLITO isolados por cliente (Ingrid + Valdece). VEREDITOS_RESUMO_INGRID_2026-05-26.md criado — Loop 5 executado informalmente.

`[CORRECAO]` SESSAO 2026-05-29 era data futura incorreta — corrigida para 2026-05-25 no LEDGER raiz e no NOTEBOOKLM_BASE/04.

---

### [P-073] Documento editado fora da fonte canônica é uma duplicata — não uma versão
**Descoberto:** 2026-05-27 (LEDGER NOTEBOOKLM_BASE 23:16 vs raiz 06:35 — hashes divergentes) | **Inscrito:** 2026-05-27
**Emitido por:** Músculo — Ordem Integridade Documental
**Fricção:** `PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE/04_INTELLIGENCE_LEDGER.md` tinha timestamp 23:16 de 26/05 (130.725 bytes) enquanto o LEDGER raiz tinha 06:35 de 27/05 (132.435 bytes). Diferença: P-071 e P-072 ausentes no espelho. Causa: R-001 do DEPENDENCY_MAP não incluía NOTEBOOKLM_BASE como destino — propagate_changes.ps1 atualizava CLIENTES/*/NOTEBOOKLM_FONTES/ mas não o espelho intermediário.
**Princípio:** Toda edição acontece NA FONTE CANÔNICA. Derivados são gerados, nunca editados. Se um derivado tem hash diferente do canonical E timestamp mais novo → violação confirmada. `detect_canonical_violation.ps1` detecta e bloqueia no PASSO 0c do `session_start.ps1`. R-001 do DEPENDENCY_MAP foi corrigido para incluir `PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE/04_INTELLIGENCE_LEDGER.md` como primeiro destino da propagação.
**Aplica-se a:** INTELLIGENCE_LEDGER.md, SKILL_PROTOCOLO_VANGUARD.md, MEMORANDO, MANUAL_DIRETOR, todos os docs UNIVERSAL_PURO classificados no DEPENDENCY_MAP v2.0.
**Ferramentas:** `detect_canonical_violation.ps1` (Gate 0c) + `DEPENDENCY_MAP.json v2.0` (classificação UNIVERSAL_PURO) + `propagate_changes.ps1` (propagação R-001 atualizado).

---

### [P-074] Propagação de decisão é total ou não é propagação — parcial é pior que zero
**Descoberto:** 2026-05-27 (10 orfãos falsos no SYNC_REPORT + R-001 sem destino para NOTEBOOKLM_BASE) | **Inscrito:** 2026-05-27
**Emitido por:** Músculo — Ordem Integridade Documental
**Fricção:** `sync_vanguard_docs.ps1` reportava 10 arquivos PROJECT_ONLY como ORFAO — causando falso AMARELO no SYNC_REPORT e distraindo o Diretor com decisões desnecessárias. Simultaneamente, R-001 propagava LEDGER para CLIENTES/ mas não para NOTEBOOKLM_BASE — propagação parcial gerava a duplicata do P-073. Dois problemas, mesma causa raiz: DEPENDENCY_MAP incompleto.
**Princípio:** Propagação incompleta é mais perigosa que ausência de propagação — cria falsa sensação de integridade. `decision_impact.ps1` expõe cascata ANTES de commitar: mostra SYNC / DESATUAL / AUSENTE por destino. `sync_vanguard_docs.ps1 v2.3` distingue ORFAO real de PROJECT_ONLY — lido dinamicamente do DEPENDENCY_MAP v2.0. `declare 'propagação concluída'` só após `decision_impact.ps1` confirmar ZERO desatualizados.
**Aplica-se a:** toda sessão onde um arquivo-fonte do DEPENDENCY_MAP é editado. NUNCA declarar propagação concluída sem evidência instrumental.
**Ferramentas:** `decision_impact.ps1` (impacto pré-commit) + `sync_vanguard_docs.ps1 v2.3` (PROJECT_ONLY) + `DEPENDENCY_MAP.json v2.0` (regras completas R-001 a R-013).

---

### [P-075] O Diretor delibera — não transporta contexto entre membros do Pentalateral
**Descoberto:** 2026-05-27 (OSV-003 — análise do loop de trabalho atual) | **Inscrito:** 2026-05-27
**Emitido por:** Músculo — Ordem OSV-003 aprovada pelo Diretor
**Fricção:** Em cada ciclo do Pentalateral, o Diretor copiava manualmente: LEDGER + WIP + MEMORIA + output do Gemini para o NotebookLM, e resultado do NotebookLM de volta para o Claude Code. Cada transporte manual é um ponto de erro (esqueceu arquivo, ordem errada, versão errada). O loop perdia velocidade e inteligência a cada fricção de transporte.
**Princípio:** O Diretor é o originador da estratégia e o emissor do veredito — nunca o transportador de arquivos entre membros. Todo contexto é preparado, compilado e entregue automaticamente pelo Músculo antes que o Diretor precise agir. O Diretor recebe o payload pronto e decide. `gemini_anchor_generator.ps1` compila e abre o browser. `skill_watcher.ps1` instala a Skill assim que chega. `agenda_scheduler.ps1` alerta os gates sem consulta manual. `churn_watch_autonomo.ps1` monitora clientes sem dependência do Diretor.
**Aplica-se a:** toda transição entre membros do Pentalateral (Músculo→Gemini, Gemini→NotebookLM, NotebookLM→Músculo, qualquer membro→Embaixador). Se o Diretor precisar copiar ou arrastar algo manualmente, o Músculo falhou em preparar o contexto.
**Ferramentas:** `gemini_anchor_generator.ps1` (payload + browser) + `skill_watcher.ps1` (FileSystemWatcher DROP) + `agenda_scheduler.ps1` (gates automáticos) + `churn_watch_autonomo.ps1` (Task Scheduler 08:00).

### [SESSAO 2026-05-27]

`[FRICCAO]` P-048 duplicado existia desde 2026-05-20 -- dois principios com mesmo numero. Detectado por auditoria do Embaixador 2026-05-27. Causa: principio novo inscrito sem verificar unicidade do numero.
`[PRINCIPIO]` P-076 (ex-P-048 duplicado) registrado. P-011/P-012 gaps formalizados. LEDGER_INDEX.md gerado (74 principios). OSV-001/002/003/004/005 concluidas.
`[PROCESSO]` Numeracao de principios: Musculo apresenta ao Diretor (numero proposto + conteudo) e aguarda veredito antes de inscrever. Nunca inscreve ou renumera autonomamente. Confirmado pelo Diretor em 2026-05-27.
`[PRINCIPIO]` P-077 inscrito -- loop_fase_atual atualizado automaticamente pelos scripts do socio. Confirmado pelo Diretor em 2026-05-27.
`[PRINCIPIO]` P-078 inscrito -- abandono silencioso em EdTech ocorre quando app funciona mas nao registra o esforco do usuario. Veredito do Diretor em 2026-05-27 (DECISOES_INGRID D5).
`[DECISAO]` DECISOES_INGRID_2026-05-24: D1/D2 arquivadas (obsoletas 3 dias). D3 veredito Regerar PDF 18/05. D5 aprovado LEDGER. D6 descartado. VEREDITOS_INGRID_2026-05-24.json gerado.
`[PRINCIPIO]` P-079 inscrito -- shift de "estudante ansioso" para "player atacando o placar" e o sinal de pre-comprometimento em EdTech-Concurso. Vocabulario de ataque = janela de pitch. D3_VANGUARD registrado. Veredito Diretor PRINCIPIO-A + D3_VANGUARD-A em 2026-05-27 (Ingrid Loop 6).
`[DADOS-WATCH]` 102 respostas de Ingrid migradas do projeto antigo (ehyaecxqijgyuuiorzcj) para o novo (yjqvjhezwhepwomukudt) via migrate_progresso_supabase.ps1. SM-2 integro. DADOS-WATCH VERDE.

---

### [P-077] loop_fase_atual e atualizado pelo script do socio — nao pelo session_close
**Descoberto:** 2026-05-27 | **Sessao:** Verificacao de Consistencia Sistemica — Embaixador Feedback
**Friccao:** loop_fase_atual era atualizado apenas no session_close, deixando o LEMBRETE DE LOOP desatualizado durante a sessao inteira. Musculo podia declarar "Gemini: PENDENTE" minutos depois de ter ido ao Gemini — dado falso no WIP_BOARD.
**Principio:** Cada script de orquestracao atualiza loop_fase_atual imediatamente ao finalizar: gemini_anchor_generator.ps1 escreve gemini = "OK"; preparar_notebooklm_projeto.ps1 escreve notebooklm = "OK"; ir_ao_embaixador.ps1 escreve embaixador = "OK". O campo "proximo" tambem e atualizado automaticamente com o proximo passo em linguagem humana.
**Ferramenta criada:** bloco de atualizacao em cada um dos 3 scripts — ConvertFrom-Json + campo direto + ConvertTo-Json + Set-Content.
**Regra de ouro:** O LEMBRETE DE LOOP no session_start reflete o estado real do loop no momento em que e lido — nao o estado do fim da ultima sessao. WIP_BOARD e a fonte de verdade viva, nao o relatorio de fechamento.
**Aplica-se a:** todo projeto, todo loop, todo socio. Escala para N projetos sem disciplina adicional do Musculo.

---

### [P-079] Shift de "estudante ansioso" para "player atacando o placar" e o sinal mais preciso de pre-comprometimento com aprovacao
**Descoberto:** 2026-05-27 (Embaixador — INGRID Loop 6 SECAO D) | **Inscrito:** 2026-05-27
**Emitido por:** Embaixador — Loop 6 SECAO D · PRINCIPIO-A aprovado pelo Diretor
**Fricção:** Ingrid enviou mensagem espontânea: "Amanhã volto para atacar mais." O verbo "atacar" (não "estudar", não "tentar") marcou o shift de mindset: de quem tenta sobreviver ao material para quem caça uma posição no placar. Nenhum prompt do Diretor induziu esse shift — ele emergiu do contato com o produto.
**Princípio:** Em EdTech-Concurso, o sinal de conversão para cliente pagante não é o uso diário — é a mudança de vocabulário do usuário. Quando o candidato passa a usar linguagem de competição ("atacar", "vencer", "avançar") em vez de linguagem de sobrevivência ("tentar", "ver se consigo", "tenho que estudar"), o produto ativou o modo player. Esse estado é a janela ideal de pitch — não antes, não depois.
**Aplica-se a:** todo produto EdTech com engajamento autônomo. Monitorar vocabulário espontâneo do usuário como KPI de conversão. Timing de pitch = primeira mensagem com linguagem de ataque.
**D3_VANGUARD:** A Vanguard deve priorizar usuárias que demonstram autonomia de engajamento (retorno sem prompt) como clientes-âncora do pitch SaaS. Candidata que volta sozinha vale mais como prova social do que qualquer testemunhal solicitado.

### [P-078] Abandono silencioso em EdTech ocorre quando sistema funciona mas nao registra o esforco do usuario
**Descoberto:** 2026-05-24 (Embaixador — ativacao INGRID Loop 5) | **Inscrito:** 2026-05-27
**Emitido por:** Embaixador — DECISOES_INGRID_2026-05-24.json, D5 aprovado pelo Diretor
**Fricção:** Ingrid reportou bug em 18/05. Fix deployado em 19/05. Sem reconhecimento da plataforma, 5 dias de silêncio após comportamento de qualidade da usuária. Churn-Watch disparou em 24/05.
**Princípio:** O momento de maior vulnerabilidade de abandono em produto EdTech nao e quando o app e dificil — e quando o app esta funcionando e o usuario nao recebe sinal de que seu esforco foi registrado. Silencio do sistema apos comportamento de qualidade do usuario e interpretado como indiferenca, nao como estabilidade.
**Aplica-se a:** todo produto EdTech com loop de retencao. O ciclo de reconhecimento deve ser automatizado — a plataforma confirma o esforco do usuario sem depender do Diretor lembrar de enviar mensagem. ChurnWatch + mensagens de reengajamento automaticas sao a resposta sistêmica.
**Ferramenta criada:** `churn_watch_autonomo.ps1` (alerta Telegram 08:00) + DECISOES.json com mensagens de reengajamento prontas para veredito do Diretor.

---

## P-080 - PRINCIPIO EXTRAIDO DE PROJETO CLIENTE (2026-05-27)
**Origem:** Valdece . Loop 7 . Embaixador
**Veredito:** Aprovar — Músculo numera e inscreve no LEDGER

> Advogado criminalista que testa ferramenta antes de assinar contrato já vendeu a ferramenta para si mesmo — o fechamento é confirmação, não persuasão. O risco real é o pós-fechamento: ele passou de potencial usuário para usuário real, e a régua sobe imediatamente.

**Aplicacao:** Usar como filtro em decisoes de produto e retencao em projetos EdTech/SaaS.

---

## P-081 - PRINCIPIO EXTRAIDO DE PROJETO CLIENTE (2026-05-27)
**Origem:** Valdece . Loop 7 . Embaixador
**Veredito:** Aprovar — Músculo numera e inscreve no LEDGER

> Advogado criminalista que testa ferramenta antes de assinar contrato já vendeu a ferramenta para si mesmo — o fechamento é confirmação, não persuasão. O risco real é o pós-fechamento: ele passou de potencial usuário para usuário real, e a régua sobe imediatamente.

**Aplicacao:** Usar como filtro em decisoes de produto e retencao em projetos EdTech/SaaS.

---

## P-082 - PRINCIPIO EXTRAIDO DE PROJETO CLIENTE (2026-05-27)
**Origem:** Valdece . Loop 7 . Embaixador
**Veredito:** Aprovar — Músculo numera e inscreve no LEDGER

> Advogado criminalista que testa ferramenta antes de assinar contrato já vendeu a ferramenta para si mesmo — o fechamento é confirmação, não persuasão. O risco real é o pós-fechamento: ele passou de potencial usuário para usuário real, e a régua sobe imediatamente.

**Aplicacao:** Usar como filtro em decisoes de produto e retencao em projetos EdTech/SaaS.

---

## P-083 - PRINCIPIO EXTRAIDO DE PROJETO CLIENTE (2026-05-27)
**Origem:** Valdece . Loop 7 . Embaixador
**Veredito:** Aprovar — Músculo numera e inscreve no LEDGER

> Advogado criminalista que testa ferramenta antes de assinar contrato já vendeu a ferramenta para si mesmo — o fechamento é confirmação, não persuasão. O risco real é o pós-fechamento: ele passou de potencial usuário para usuário real, e a régua sobe imediatamente.

**Aplicacao:** Usar como filtro em decisoes de produto e retencao em projetos EdTech/SaaS.

---

## P-085 - ONBOARDING INVISÍVEL — CLIENTE NUNCA CRIA CONTA (2026-05-27)
**Origem:** Vanguard Operações · Decisão do Diretor · Fricção real com Ingrid e Valdece
**Veredito:** Inscrito — protocolo aprovado e commitado em PENTALATERAL_UNIVERSAL/OPERACAO/

> O cliente nunca cria conta em nenhum serviço. Toda fricção técnica de cadastro (Supabase, GitHub, Google, AI Studio) é absorvida pela Vanguard no kickoff. Aliases `[nome]@vanguardtech.cloud` são a identidade técnica do cliente — profissional, rastreável, custo fixo de R$ 6/mês independente do volume de clientes. Criar conta afasta cliente. Entregar conta pronta fecha projeto.

**Aplicacao:** Todo projeto cliente, desde o kickoff, sem exceção. Runbook completo: PENTALATERAL_UNIVERSAL/OPERACAO/PROTOCOLO_ONBOARDING_INVISÍVEL.md — 5 passos obrigatórios: alias → contas → cofre → mensagem WhatsApp → checklist P-010. Offboarding em 30 min via OFFBOARDING_RUNBOOK.md (P-013).

---

## P-086 - SESSÃO GASTA EM CORREÇÃO = FALHA DO MÚSCULO, NÃO DO SISTEMA (2026-05-28)
**Origem:** INGRID · Loop 6 · Sessão inteira consumida corrigindo protocolos e memórias em vez de construir
**Veredito:** Inscrito — DEF-M-6 ativo — [FALHA-PROCESSO-2026-05-28]

> Quando Eduardo chega ao final de uma sessão dizendo "ficamos o dia corrigindo tudo", o Músculo falhou na função primária: proteger o tempo do Diretor. O Diretor delibera e decide — não depura, não lembra protocolo, não aponta o que está desatualizado. Qualquer minuto de Eduardo gasto em correção que o Músculo deveria ter antecipado é tempo roubado do Diretor. DEF-M-6 não é aceitável como estado permanente — é uma falha que o próprio sistema deve detectar e eliminar.

**Aplicacao:** Ao iniciar sessão: varredura proativa de protocolos pendentes (e-mail, encoding, painel, PENDENTES.md). Ao fechar sessão: não encerrar sem confirmar que cada protocolo obrigatório do CLAUDE.md foi executado. Se algum falhou — registrar causa raiz antes de fechar, não na próxima sessão.

---

## P-087 - MARCAÇÃO DE CONCLUSÃO DESACOPLADA DO ATO DE CONCLUIR É DÍVIDA TÉCNICA DE PROCESSO (2026-05-28)
**Origem:** INGRID · Loop 6 · [FALHA-PROCESSO-2026-05-28] — commits 86e112b e a2b42f5 concluíram F-2/F-4/F-6 sem marcar [x] no PENDENTES.md
**Veredito:** Inscrito — hook + fallback deployados — P-033 aplicado em arquitetura

> Marcação de conclusão que depende de etapa separada do ato de concluir sempre ficará desatualizada. O session_close.ps1 usa leitura passiva do PENDENTES — quando o Músculo commita trabalho após o script de fechamento, a marcação não ocorre. A solução correta é o acoplamento: o commit que resolve a tarefa é o mesmo artefato que a marca como concluída, via tag [RESOLVE:] no commit message + post-commit hook que executa a marcação sem intervenção humana.

**Regra derivada:** toda mensagem de commit que conclui tarefa do PENDENTES.md carrega `[RESOLVE: keyword]` ao final. Formato: `<tipo>(<escopo>): <descricao> [RESOLVE: <keyword>]`. O hook `.git/hooks/post-commit` detecta a tag e chama `auto_resolve_pendentes.ps1` automaticamente — commit separado, não amend, sem loop infinito. Fallback: `reconcile_pendentes.ps1` roda no session_start e alerta discrepâncias residuais via seção PENDENTES-WATCH. Processo que depende de disciplina humana falha (P-033) — a tag [RESOLVE:] torna o comportamento correto o único caminho disponível.

**Ferramentas:** `scripts/auto_resolve_pendentes.ps1` · `scripts/reconcile_pendentes.ps1` · `.git/hooks/post-commit` (Etapa 3) · `.claude/hooks/session_start.ps1` (PENDENTES-WATCH).

---

## P-084 - PIPELINE COM ARQUIVO DE SAIDA DEVE CHECAR EXISTENCIA ANTES DE REPROCESSAR (2026-05-27)
**Origem:** INGRID . Loop 6 . Fricção real — render_painel.ps1 reprocessava DECISOES Loop 5 por tres sessoes consecutivas
**Veredito:** Inscrito — Embaixador identificou causa raiz, Músculo aplicou gate [FALHA-PROCESSO-2026-05-27]

> Pipeline que depende de arquivo de saída para avançar deve checar a existência desse arquivo antes de reprocessar a entrada. DECISOES sem VEREDITOS correspondente pode ser dado pendente ou dado deliberado fora do pipeline formal — o script precisa distinguir os dois estados, ou reprocessa o passado indefinidamente.

**Aplicacao:** Ao construir qualquer script de orquestração que consome JSONs ou arquivos de entrada: sempre checar se o arquivo de saída esperado já existe antes de processar. Adicionar parâmetro -forcar para casos de reabertura intencional. Arquivos deliberados fora do pipeline formal devem ir para pasta com prefixo _ (ex: _ARQUIVADO/) para que filtros os excluam automaticamente.

---

## P-088 - PS5.1 CODIGO-FONTE ASCII-ONLY -- CONTEUDO RICO VAI PARA TEMPLATE EXTERNO (2026-05-28)
**Origem:** INGRID · Loop 6 · [FALHA-PROCESSO-2026-05-28] — gerar_artefato_embaixador.ps1 com here-string contendo em-dashes e acentos causou falha silenciosa de parsing no PS5.1
**Veredito:** Inscrito — Opção 2 implementada — template externo .txt com placeholders {TOKEN}

> Here-strings em PS5.1 com Unicode silenciosamente corrompem o script. O operador `--` (decremento) é lido quando `---` aparece dentro de `@"..."@`. Em-dashes (U+2014), aspas curvas e qualquer caractere não-ASCII causam falha de parsing sem mensagem de erro clara. A solução correta é separar completamente: código PS5.1 fica ASCII-only; conteúdo rico (acentos, em-dashes, markdown) vai para arquivo .txt externo lido com `Get-Content -Raw -Encoding UTF8`. Substituição de placeholders `{TOKEN}` com `-replace` é o único padrão seguro.

**Regra derivada:** Nunca here-string com Unicode em PS5.1. Nunca. Sem exceção. Todo script .ps1 que gere texto rico deve: (a) manter código-fonte 100% ASCII, (b) ler template externo .txt via Get-Content UTF8, (c) usar -replace '\{TOKEN\}', $valor para substituição. Validação obrigatória: `[Parser]::ParseFile()` após criar ou editar qualquer .ps1. O validate_scripts.ps1 aplica esta regra automaticamente (P-060).

**Ferramentas:** `PENTALATERAL_UNIVERSAL/TEMPLATES/scripts/` (pasta de templates externos) · `scripts/validate_scripts.ps1` · DEPENDENCY_MAP TIPO 2 para cada template .txt que gera instância.

---

## P-089 - DOCUMENTO DE CONTEXTO DO SOCIO E REGENERADO PELO SCRIPT DO SOCIO ANTERIOR (2026-05-28)
**Origem:** INGRID · Loop 6 · [FALHA-PROCESSO-2026-05-28] — PASSO3_GEMINI.md ficou na versão Loop 5 porque a regeneração não estava acoplada à conclusão do Gemini. Diretor tentou ir ao Gemini quando o Loop 6 já tinha DIRETRIZ aprovada.
**Veredito:** Inscrito — Embaixador identificou causa raiz — gemini_anchor_generator.ps1 regenera PASSO3_GEMINI.md automaticamente ao marcar gemini=OK

> Documento de contexto desatualizado faz o Pentalateral operar em loop errado. O Músculo assume que "já foi feito" e o Diretor assume que "ainda falta fazer" — ambos corretos para loops diferentes. O acoplamento resolve: o script que avança o WIP_BOARD regenera o PASSO3 na mesma execução, sem etapa separada, sem disciplina humana.

**Regra derivada:** gemini_anchor_generator.ps1 regenera PASSO3_GEMINI.md ao concluir. preparar_notebooklm_projeto.ps1 deve regenerar PASSO5_NOTEBOOKLM.md ao concluir. ir_ao_embaixador.ps1 deve regenerar PASSO7_EMBAIXADOR.md ao concluir. Cada script de sócio é responsável pelo documento de contexto do sócio seguinte — nunca o Músculo manualmente depois. Template externo .txt (P-088) com placeholders: {CLIENTE}, {LOOP_NUM}, {LOOP_PREV}, {DATA}, {GATE_PROXIMO}.

**Ferramentas:** `PENTALATERAL_UNIVERSAL/TEMPLATES/scripts/passo3_template.txt` · `scripts/gemini_anchor_generator.ps1` (bloco P-089 ao final) · DEPENDENCY_MAP TIPO 2.

---

## P-091 — WIP_BOARD REFLETE REALIDADE, NÃO INTENÇÃO (2026-05-30)
**Origem:** Embaixador Ingrid · Via: Diretor Eduardo · 2026-05-30
**Veredito:** AJUSTADO e inscrito pelo Diretor em 2026-05-30.

> P-091: WIP_BOARD reflete realidade — não intenção. socio=OK sem
> artefato correspondente em disco é dado falso. Regra dupla:
> (1) auditar_consistencia.ps1 cruza WIP_BOARD com disco a cada
> fechamento — divergência = exit 2 bloqueante; (2) Músculo verifica
> artefato em disco antes de reportar qualquer socio=OK como verdade —
> nunca confiar no documento sem evidência física. corrigir_wip.ps1
> reverte sócio para PENDENTE quando divergência detectada.

**Artefatos verificados por sócio:**
- `gemini=OK` → `CLIENTES\[CLIENTE]\NOTEBOOKLM_FONTES\12_DIRETRIZ_GEMINI_V[N].txt`
- `notebooklm=OK` → `.claude\skills\[cliente]-v[N].md`
- `musculo=OK` → `CLIENTES\[CLIENTE]\HISTORICO\DELIBERACAO_LOOP_V[N]_[cliente].md`

**Ferramentas:**
- `scripts/auditar_consistencia.ps1` Gate 0 — exit 2 bloqueante se divergência
- `scripts/corrigir_wip.ps1 -cliente X -socio Y -loop N` — reverte para PENDENTE com log

**Aplica-se a:** toda leitura de WIP_BOARD que declare estado de sócio como OK. Todo projeto, todo loop.

---

## P-090 - PASSO3 É ESCRITO NO ARQUIVO — NÃO NO CHAT (2026-05-29)
**Origem:** INGRID · Loop 6 · [FALHA-PROCESSO-2026-05-29] — Músculo gerou M-1 a M-5 no chat mas não escreveu em PASSO3_GEMINI.md. gemini_anchor_generator.ps1 leu o esqueleto vazio com `[MÚSCULO: completar]`. Gemini recebeu placeholder e fez análise livre em vez de DIRETRIZ estruturada.
**Veredito:** Inscrito — Embaixador identificou causa raiz e propôs a ferramenta de prevenção.

> Conteúdo gerado no chat é rascunho. Conteúdo no arquivo é real. O chat não persiste entre sessões, o arquivo sim. O Gemini recebe o arquivo — nunca o chat. Músculo que escreve apenas no chat está executando para si mesmo, não para o sistema.

**Regra derivada:** Ao gerar M-1 a M-5 ou qualquer conteúdo destinado ao PASSO3, o Músculo escreve IMEDIATAMENTE no arquivo `CLIENTES/[CLIENTE]/PASSO3_GEMINI.md` usando Write tool. gemini_anchor_generator.ps1 bloqueia com exit 1 se encontrar `[MUSCULO:` no arquivo antes de ir ao Gemini.

**Ferramentas:** Gate 0 em `scripts/gemini_anchor_generator.ps1` · Gate de versão em `scripts/preparar_notebooklm_projeto.ps1` · Gate 6.5 em `scripts/session_close.ps1` (gera PASSO3 N+1 ao fechar loop completo).


### [SESSAO 2026-05-30]

`[PRINCIPIO]` P-091: WIP_BOARD reflete realidade nao intencao. render_painel injeta campos ausentes automaticamente. gerar_sintese_conselho.ps1 criado.

---

## P-092 — PERGUNTA ABERTA É FALHA DE DESIGN — VERIFICAÇÃO AUTÔNOMA (2026-06-01)
**Origem:** Diretor Eduardo · 2026-06-01 · [FALHA-PROCESSO-2026-06-01]
**Veredito:** Inscrito e corrigido na mesma sessão.

> "O que avançou desde a última sessão?" é uma pergunta aberta — falha estrutural do sistema.
> O Músculo tem acesso a git log, arquivos em disco, e PENDENTES.md. Perguntar o que está
> escrito ou visível = DEF-M-6 (Músculo Reativo). O design correto distingue:
>
> [AUTO-VERDE]        → evidência [RESOLVE:] em commit (P-087) → marcar [x] sem perguntar
> [AUTO-AMARELO]      → tarefa do Músculo sem evidência → executar agora
> [DIRETOR-CONFIRMAR] → ação externa sem artefato verificável → lista SIM/NÃO numerada
>
> A função Get-CheckInPrompt (session_start.ps1) gerava o texto "Musculo DEVE perguntar".
> Isso é instrução de falha hardcoded no sistema. Causa raiz: confundir "não sei" com "devo perguntar".

**Regras derivadas:**
- NUNCA gerar pergunta aberta "o que aconteceu?" — sempre classificar primeiro
- Para ações externas: lista numerada SIM/NÃO — Diretor responde em 2 segundos
- Para artefatos/código: verificar via git log + disco — nunca perguntar
- marcar_confirmados.ps1 processa a resposta e fecha PENDENTES automaticamente

**Ferramentas:**
- `scripts/verificar_estado_autonomo.ps1` — classifica todos os pendentes em 3 categorias
- `scripts/marcar_confirmados.ps1 -Resposta "1-SIM 2-NÃO"` — fecha os confirmados
- Integrado ao `session_start.ps1` — substitui Get-CheckInPrompt

**Aplica-se a:** abertura de TODA sessão. Zero exceções.

### [SESSAO 2026-06-01]

`[PRINCIPIO]` P-092: pergunta aberta "o que avançou?" e falha de design. verificar_estado_autonomo.ps1 classifica pendentes em AUTO-VERDE / AUTO-AMARELO / DIRETOR-CONFIRMAR. session_start atualizado. marcar_confirmados.ps1 criado.

`[PRINCIPIO]` P-093: ferramenta profissional que funciona bem desaparece na rotina antes de criar ROI percebido. primeiro contato pos-entrega nao e verificacao de uso — e criacao de consciencia de valor. Origem: Embaixador Valdece Hypercare Dia 13.

---

## P-093 — FERRAMENTA NORMALIZADA ANTES DO ROI PERCEBIDO (2026-06-01)
**Origem:** Embaixador Valdece · Hypercare Dia 13 · 2026-06-01
**Veredito:** Inscrito pelo Músculo (P-032 automático).

> Ferramenta profissional que funciona bem desaparece na rotina antes de criar ROI percebido.
> O primeiro contato pós-entrega não é verificação de uso — é criação de consciência de valor.
> Sem esse evento intencional, o cliente usa e esquece quanto pagou.
>
> Corolário: "Produto silencioso não é produto aprovado — é produto normalizado.
> A diferença define se o cliente renova, indica ou esquece."

**Regra derivada:** O Sentinel Report não é relatório de atividade — é o primeiro evento de consciência de ROI. A pergunta "como tem sido na prática?" força avaliação ativa onde antes havia uso passivo. Sem ela, a janela de memória fecha (14 dias) e o cliente responde sobre um sistema que "usa há um mês" sem memória dos primeiros casos específicos.

**Aplica-se a:** todo projeto de ferramenta profissional com usuário B2B que paga upfront e usa sem reportar. Especialmente LegalTech, EdTech, qualquer nicho onde o profissional incorpora a ferramenta à rotina silenciosamente.

---

## P-094 — VALIDAÇÃO NO MOMENTO DA ESCRITA SUPERA DOCUMENTAÇÃO (2026-06-01)
**Origem:** Embaixador — feedback sobre dependência inline no PAINEL · 2026-06-01
**Veredito:** Inscrito pelo Músculo.

> Documentação não garante preenchimento. O que garante é validação no momento da escrita.
> Um aviso durante a geração do PAINEL ("2 pendentes futuros sem dependência declarada") cria
> o incentivo certo sem custo de processo — o campo vazio se torna visível na hora em que importa.

**Regra derivada:** Toda convenção de preenchimento manual que depende só de disciplina vai degradar. O sistema precisa de um mecanismo que torna a ausência do campo visível — não punição, mas fricção mínima no momento correto. Aviso sem bloqueio é o ponto ótimo: informa sem interromper.

**V2 planejado:** `validate_painel.ps1` emitir aviso (`⚠ N pendentes futuros sem dependência declarada`) durante geração. Não bloqueia — registra. Junto com histórico de recorrência (pendentes que reaparecem em PAINEIs consecutivos), compõe o P-094 completo.

**Aplica-se a:** qualquer campo de preenchimento opcional em documentos gerados automaticamente — dependência de pendente, tag de origem, link de gate. Se é opcional e importante, precisa de visibilidade de ausência.

---

## P-095 — GATE CHECKER DEVE CRUZAR TODAS AS FONTES DE EVIDÊNCIA (2026-06-01)
**Origem:** Bug no `generate_protocolo_encerramento.ps1` — gate dia15 declarado vencido apesar de `loops_programados` registrar `status: "concluido"` com evidência de commit · 2026-06-01
**Veredito:** Inscrito pelo Músculo após fricção detectada pelo Diretor e confirmada pelo Embaixador.

> Um gate não é aberto ou fechado por um único campo. É fechado quando qualquer fonte canônica confirma conclusão.
> O script checava apenas `dias_completos` — e declarava vencido o que `loops_programados` já marcava concluído.
> O Embaixador recebeu um PAINEL com "Gate Dia 15 vencido há 3 dias" e o Diretor teve que investigar.
> A fricção custou uma sessão inteira de diagnóstico.

**Regra derivada:** Todo gate checker que consulta apenas UMA fonte é incompleto por design. A evidência de conclusão pode estar em qualquer campo canônico do WIP_BOARD: `dias_completos`, `loops_programados`, `gates_bloqueantes` com flag de resolução. O checker deve percorrer todas antes de declarar vencido.

**Corolário — campo stale é ruído com autoridade:** `loop_atual` (string legada) divergia de `loop_fase_atual` (objeto estruturado) porque o script atualizava um e ignorava o outro. Dois campos paralelos com o mesmo semântico são uma bomba de inconsistência. Quando existirem, o script deve preferir o mais estruturado e manter o legado sincronizado.

**Fix aplicado:**
- `generate_protocolo_encerramento.ps1` — `Test-GateCoberto` agora cruza `loops_programados` antes de declarar gate vencido
- `generate_protocolo_encerramento.ps1` — bloco PROJETOS ATIVOS prefere `loop_fase_atual` com fallback para `loop_atual`
- `WIP_BOARD.json` — `loop_atual` Ingrid atualizado para Loop 7 e sincronizado com `loop_fase_atual`
- Commit: `433a368`

## P-096 — UNIVERSALIDADE E O CRITERIO DE ACEITE DA ARQUITETURA (2026-06-04)
**Origem:** Analise cirurgica ORDEM_MUSCULO refatoracao universal session_close + briefing_diario · 2026-06-04
**Veredito:** Aprovado pelo Diretor + confirmado pelo Embaixador · inscrito pelo Musculo.

> Script que resolve problema de um projeto e duplicado para o proximo ja nasceu errado.
> Universalidade e o criterio de aceite da arquitetura -- nao a funcionalidade isolada.
> Um script universal parametrizado custa uma refatoracao.
> Um script por projeto custa N refatoracoes com N divergencias silenciosas.

**Regra derivada:** Ao criar qualquer script de orquestacao, a primeira pergunta nao e "funciona para este projeto?" -- e "funciona para N projetos sem editar o codigo?" Se a resposta for nao, o script nao passou no criterio de aceite de arquitetura, independente de funcionar no caso presente.

**Corolario -- lista estatica hardcoded e sinal de acoplamento prematuro:** Qualquer lista fixa de projetos, clientes ou ambientes no corpo de um script e uma dependencia que exige edicao do codigo quando o contexto mudar. A fonte de verdade dinamica (WIP_BOARD, arquivo de config, parametro injetado) sempre vence sobre a lista hardcoded. Se o script precisa ser editado para adicionar um novo caso, o design esta errado.

**Aplica-se a:** todo script de orquestacao do Pentalateral. Se contem nome de projeto, cliente ou caminho hardcoded no corpo -- revisar. Universalidade nao e refinamento futuro -- e criterio de aceite inicial.

## P-097 -- GATES BLOQUEANTES PRECISAM DE COBERTURA DE REGRESSAO (2026-06-04)
**Origem:** Analise cirurgica ORDEM_MUSCULO -- lacuna identificada pelo Embaixador e confirmada pelo Musculo · 2026-06-04
**Veredito:** Aprovado pelo Diretor · inscrito pelo Musculo apos veredito formal.

> Gates bloqueantes precisam de cobertura de regressao automatica.
> DryRun resolve simulacao manual -- nao garante que mudanca futura nao quebra
> gate critico silenciosamente. testar_gates_criticos.ps1 executa a cada 3
> loops e confirma que exit 1 dispara quando deve disparar.

**Regra derivada:** Qualquer gate com exit 1 que nao tem teste de regressao e um gate que pode ser quebrado silenciosamente. A evidencia de que um gate funciona nao e "foi testado quando criado" -- e "foi testado apos a ultima mudanca de infraestrutura".

**Artefato:** `PENTALATERAL_UNIVERSAL/scripts/testar_gates_criticos.ps1`
Execucao: a cada 3 loops via `meta.loops_desde_ultimo_checkup` (WIP_BOARD).
Gates cobertos: Gate 1 (auditoria), Gate 5 (validate), Gate 6B (P-032), Gate 6C (P-049).

**Aplica-se a:** todo gate com exit 1 no sistema -- session_close e qualquer futuro script de orquestracao com bloqueio critico.

**Validado em producao 2026-06-04:** testar_gates_criticos.ps1 executado. Gate 6B confirmou deteccao de VEREDITO hoje + MEMORIA desatualizada (resultado OK). Gates 1 e 5 retornaram INFO -- injecao de falha nao ativou o padrao especifico, mas logica de deteccao funcionou. Gate 6C detectou placeholders de sessao anterior (comportamento correto). Principio ativo com evidencia parcial -- cobertura completa de exit 1 real em proxima rodada apos mudanca de infraestrutura.

**Aplica-se a:** qualquer script que avalia estado de conclusão a partir do WIP_BOARD — session_close, render_painel, validate_painel, check_diretriz_embaixador. Se o script consulta apenas um campo para declarar bloqueio ou conclusão, revisar.


## P-099 — PING SUPABASE OBRIGATORIO NO ONBOARDING DE QUALQUER CLIENTE (2026-06-04)
**Origem:** PROJ-001 Valdece -- projeto pausado sem alerta -- busca retornando "TypeError: Load failed" em producao.
**Evidencia:** 2 projetos Vanguard + 1 projeto Valdece pausados simultaneamente. Detectado pelo Diretor, nao pelo sistema.

Todo projeto Supabase entregue a cliente DEVE ter ping automatico registrado no Task Scheduler antes do handoff:
1. `scripts/ping_supabase_universal.ps1` -- adicionar o projeto ao array $PROJETOS
2. `scripts/registrar_ping_universal.ps1` -- rodar para atualizar o agendamento
3. Intervalo: 5 dias (free tier pausa apos 7 dias de inatividade)
4. Alerta: Telegram + log em `scripts/ping_universal.log`

Sem ping registrado = cliente pode perder acesso sem aviso. Dado permanece 90 dias apos pausa -- apos isso, DELETADO.
Regra operacional: onboarding de qualquer cliente com Supabase e BLOQUEANTE ate ping registrado e testado VERDE.
Ferramenta: `scripts/ping_supabase_universal.ps1` + `scripts/registrar_ping_universal.ps1`

---

## DECISAO ESTRATEGICA — PROJ-002 INGRID (2026-06-04)
**Diretor Eduardo · Veredito D1 Loop 8 · Irrevogavel neste ciclo.**

Ingrid nao sera cobrada. A ferramenta sera entregue gratuitamente.
Ingrid e a fundadora simbolica do produto Pentalateral EdTech -- seus dados anonimizados
sao o argumento comercial para as proximas candidatas que poderao pagar R\/mes.
O produto prova valor em Ingrid; escala nos proximos clientes.

Regra derivada: o primeiro cliente piloto pode ter valor estrategico superior ao valor comercial.
Cobrar Ingrid agora poderia contaminar a natureza da relacao e enfraquecer a narrativa de fundadora.
Ingrid que passa no concurso e indica o proximo cliente vale mais que R\/mes.

---

## P-100 — EMBAIXADOR OPERA POR RAG — DESIGN DO PASSO7 DEVE RESPEITAR ISSO (2026-06-05)
**Origem:** Analise das capacidades do Claude Projects na sessao 2026-06-05 (stack infra Pentalateral).
**Evidencia:** Claude Projects usa recuperacao semantica (RAG interno) -- nao carrega todos os documentos do projeto de uma vez. Secoes relevantes sao puxadas para o contexto ativo baseadas nas perguntas da conversa.

Tres regras obrigatorias ao preparar PASSO7 para o Embaixador:

1. PERGUNTAS DEVEM USAR TERMOS EXATOS DA MEMORIA_EMBAIXADOR
   Pergunta vaga ("como o cliente reage?") retrieve trecho impreciso.
   Pergunta especifica ("sinais de churn observados" / "temperatura do cliente" / "canal de contato preferido") retrieve o trecho correto.
   O Musculo deve escrever Q-X com os mesmos termos que usa ao escrever a MEMORIA_EMBAIXADOR.

2. CONTEXTO NOVO (session-specific) VAI COMO ATTACHMENT, NAO COMO ARQUIVO DO PROJETO
   WIP_BOARD atualizado, PASSO3 desta sessao, decisoes recentes -- sempre como attachment direto no chat.
   Attachment direto = contexto ativo (lido integralmente). Arquivo do projeto = RAG (retrieved parcialmente).
   Nunca depender que o RAG do projeto encontre contexto que mudou hoje.

3. MEMORIA_EMBAIXADOR DEVE TER SECOES NOMEADAS PARA RETRIEVAL CIRURGICO
   Formato obrigatorio: ## Temperatura do cliente / ## Sinais de churn observados / ## Canal de contato preferido / ## Contexto de nicho / ## Hipoteses ativas.
   Bloco monolitico = retrieve impreciso = resposta generica. Secao nomeada = retrieve cirurgico = insight real.

Limite de upload por sessao: 20 arquivos max, 30 MB cada. Plano Pro: 200K tokens de contexto de chat.
Regra operacional: PASSO7 lean + termos precisos + attachments de sessao = Embaixador respondendo com profundidade maxima.
Ferramenta de verificacao: ao revisar qualquer PASSO7, checar se Q-X usa vocabulario da MEMORIA_EMBAIXADOR.

---


## P-101 -- MENSAGEM EXTERNA NUNCA ACESSA CLAUDE DIRETAMENTE -- n8n COMO CAMADA OBRIGATORIA (2026-06-04)
**Origem:** Analise cirurgica stack infra Pentalateral -- Musculo M-4 -- Veredito [M] do Diretor em 2026-06-04.
**Veredito:** Aprovado pelo Diretor. Texto versao Musculo. Inscrito automaticamente.

> Toda mensagem externa (cliente, sistema, webhook) passa por n8n antes de chegar ao Claude.
> Claude nunca e acessado diretamente por canal externo -- sem excecao na FASE 1.
> n8n nunca e proxy de produto. O cliente percebe a Vanguard como experiencia humana, nunca como bot.
> A camada n8n orquestra internamente; a interface entregue ao cliente e sempre curada pelo Diretor.

**Diferencial declarado:** O cliente e avisado antes que qualquer problema afete seu uso.
Isso distingue monitoramento reativo (o cliente descobre a falha) de proatividade real (a Vanguard age antes).
O watchdog n8n + alertas Telegram tornam este diferencial tecnicamente possivel e comercialmente comunicavel.

**Regra derivada:**
- Nenhum workflow n8n da FASE 1 pode expor endpoint publico do Claude sem camada de autorizacao
- n8n autentica a origem de cada mensagem antes de encaminhar ao modelo
- Prompts de sistema (identidade Vanguard, contexto de cliente, burn rate) sao injetados pelo n8n -- nunca pelo cliente
- Se o n8n cair, o fallback e silencio informado ao Diretor -- nunca acesso direto ao modelo pelo cliente

**Aplica-se a:** todo workflow n8n da FASE 1 e FASE 2. Todo novo canal (WhatsApp, Telegram, Discord) que conectar o Claude a um cliente externo. OpenClaw V2 herda esta regra quando ativado.

## P-102 -- N8N COMPLEMENTA, NAO SUBSTITUI PROCESSOS EXISTENTES (2026-06-04)
**Origem:** Aviso do Diretor Eduardo na sessao 2026-06-04 -- "Lembre-se que temos muitos processos automatizados, nao quero impacta-los."
**Veredito:** Inscrito automaticamente pelo Musculo como constraint de build.

> O n8n FASE 1 adiciona uma camada de orquestracao.
> Ele nao substitui, nao desativa e nao modifica nenhum processo existente:
>   - ChurnWatch_Vanguard (Task Scheduler) -- continua rodando
>   - briefing_diario.ps1 (Task Scheduler) -- continua rodando
>   - ping_supabase_universal.ps1 (Task Scheduler) -- continua rodando
>   - decisoes_watcher.ps1 (watcher ativo) -- continua rodando
>   - skill_watcher.ps1 (watcher ativo) -- continua rodando
>   - session_close.ps1 (canônico) -- NAO MODIFICADO; webhook n8n e extensao no wrapper

> Coexistencia obrigatoria: cada novo processo n8n e adicionado SEM remover o equivalente local.
> Remover um processo local so apos 30 dias de uptime estavel do equivalente n8n (P-FASE2).
> "Novo processo rodando" nao e evidencia suficiente para desligar o anterior.

**Regra derivada:**
- Ao criar qualquer workflow n8n, documentar: "este workflow substitui qual script local?" e "o script local ainda deve rodar?"
- Resposta padrao FASE 1: o script local ainda roda. O n8n e paralelo.
- Conflito (dois processos fazendo a mesma coisa) = bug de arquitetura, nao feature.
- Todo workflow n8n novo deve ser aprovado pelo Diretor com declaracao explicita de coexistencia.

**Aplica-se a:** toda a FASE 1. Revisao na FASE 2 (apos 30 dias de estabilidade) para decidir o que descontinuar.
---

## P-103 — NODE TELEGRAM DO N8N TEM BUG DE CREDENCIAL — USAR HTTP REQUEST (2026-06-04)
**Origem:** instalacao n8n FASE 1 — sessao 2026-06-04.
**Problema:** o node 
8n-nodes-base.telegram v1.2 tem bug: Access Token em modo Expression fica com valor __n8n_BLANK_VALUE mesmo apos criar credencial com sucesso. Erro resultante: 400 Bad Request: chat not found.
**Solucao definitiva:** substituir nodes Telegram por 
8n-nodes-base.httpRequest com URL https://api.telegram.org/bot[TOKEN]/sendMessage e body JSON com chat_id e 	ext. Testado e funcionando.
**Regra:** NUNCA usar node Telegram do n8n para envio de mensagens. Sempre HTTP Request direto.

## P-104 — CAMPO JSODE VS FUNCTIONCODE NO NODE CODE DO N8N (2026-06-04)
**Origem:** instalacao n8n FASE 1 — sessao 2026-06-04.
**Problema:** node 
8n-nodes-base.code versao 2 usa campo jsCode, nao unctionCode. JSON importado com unctionCode carrega template padrao em vez do codigo real — sem aviso de erro.
**Solucao:** todos os workflows devem usar "jsCode" no parametro do node Code. Verificar sempre apos importacao se o codigo foi carregado.
**Regra:** ao criar JSON de workflow para importacao, usar jsCode no campo de codigo.

## P-105 — WEBHOOK N8N V2: BODY ANINHADO EM $JSON.BODY (2026-06-04)
**Origem:** instalacao n8n FASE 1 — sessao 2026-06-04.
**Problema:** webhook node typeVersion 2 do n8n encapsula o POST body em $json.body, nao diretamente em $json. Codigo que acessa $input.item.json.campo recebe undefined — valores default ativam e chegam vazios ao Telegram.
**Solucao:** usar `const payload = $input.item.json.body || $input.item.json;` — lida com ambas as versoes.
**Regra:** todo Code node pos-Webhook deve usar o padrao body-fallback.

## P-106 — CHURNWATCH EDTECH: THRESHOLD 3 DIAS, NAO 5 (2026-06-04)
**Origem:** PERFIL_NICHO EdTech-Concurso V1 — Embaixador · PROJ-002 Ingrid.
**Fundamento:** a concurseira EdTech-Quadrix nao verbaliza insatisfacao — silencia e abandona. Confirmado com Ingrid (5 dias silencio apos bug 18/05 sem queixa verbal). Threshold de 5 dias ja e tarde — a janela de reengajamento efetiva fecha antes disso.
**Regra:** ChurnWatch para perfil EdTech-Concurso: alerta em 3 dias de inatividade real (sem sessao confirmada). 5 dias = urgencia maxima. 7+ dias = provavel perda.
**Aplica-se a:** qualquer projeto EdTech com perfil de usuario nao-verbal.

## P-107 — ANCORA DE PRECO EDTECH: CUSTO DO ERRO DE DIRECAO (2026-06-04)
**Origem:** PERFIL_NICHO EdTech-Concurso V1 — Embaixador · PROJ-002 Ingrid.
**Fundamento:** o medo central da concurseira EdTech-Quadrix nao e financeiro — e desperdicar meses estudando a materia errada. A ancora correta nao e comparar com o preco do TEC (R$50-90/mes). E ancorar no custo da reprovacao por estudar a materia errada.
**Frame validado:** "Gran Cursos cobra R$660/ano e nao sabe que voce vai prestar Cargo 202 no Quadrix. Esse sistema so estuda o que a banca cobra para o seu cargo."
**Regra:** nunca usar preco do concorrente como ancora primaria em pitch EdTech. Usar custo do erro de direcao.

## P-108 — CASE REAL ELEVA TETO DE PRECO DO SEGUNDO CLIENTE NO MESMO NICHO (2026-06-04)
**Origem:** PERFIL_NICHO LegalTech-Criminal V1 — Embaixador · PROJ-001 Valdece.
**Fundamento:** Valdece pagou R$5.000 (primeiro contrato, sem case). Com o case de Valdece + ancora Westlaw (R$36.000/ano), o segundo cliente do mesmo perfil tem teto receptivo de R$7.500-9.000 sem barganhar. O case real e o ativo que eleva o preco — nao a feature.
**Regra:** ao preparar proposta para segundo cliente do mesmo nicho, sempre incluir o case do primeiro como ancora de valor. Nunca repetir o mesmo preco do primeiro contrato — o risco caiu, o valor subiu.
**Aplica-se a:** todo novo projeto IAH onde ja existe um cliente no mesmo nicho.

## P-110 -- AUTOMACAO CRITICA EXIGE FALLBACK MANUAL DE NO MAXIMO 3 PASSOS (2026-06-05)
**Origem:** Deliberacao n8n FASE 2 -- sessao 2026-06-05. Aprovado em DECISOES_N8N_FASE2 D5:A.
**Fundamento:** Automacao sem fallback manual de no maximo 3 passos criou dependencia nao declarada. Se o fallback exige mais que 3 passos, o sistema exige a automacao para sobreviver -- isso e vulnerabilidade, nao feature.
**Regra:** antes de ativar qualquer workflow critico, documentar o fallback manual com no maximo 3 passos. Se o fallback nao couber em 3 passos: simplificar a automacao ou dividir em workflows menores.
**Fallbacks documentados (Pentalateral IAH):**
  W-8 ChurnWatch down  -> Abrir WIP_BOARD.md e checar campo ultimo_contato_cliente manualmente (1 passo)
  W-6 Embaixador down  -> Executar Passo 7 manual via Claude Projects como hoje (1 passo)
  W-7 Veredito down    -> Colar VEREDITOS.json manualmente via terminal (1 passo)
**Aplica-se a:** todo workflow n8n critico + toda automacao PS1 que bloqueia o processo Pentalateral.

## P-109 -- NOTION E OUTPUT-ONLY: GIT E A UNICA FONTE DE VERDADE (2026-06-04)
**Origem:** Decisao ARQ-1 aprovada pelo Diretor -- sessao 2026-06-04. Confirmado "analise ok" apos deliberacao sobre session amnesia e cockpit do Diretor.
**Fundamento:** Notion como cockpit visual -- exclusivamente para leitura e deliberacao. Toda informacao que aparece no Notion foi gerada a partir de artefatos em disco via n8n. Editar diretamente no Notion cria divergencia silenciosa: o sistema nao detecta, o Git nao registra, a proxima automacao sobrescreve.
**Regra:** nunca editar uma pagina Notion do sistema Vanguard manualmente. A pergunta "onde esta a verdade?" tem resposta unica: Git. Notion e uma janela, nao um arquivo.
**Protecao tecnica (3 camadas):**
  REGRA 1 -- warning banner em cada pagina Notion: "SOMENTE LEITURA -- editado pelo n8n"
  REGRA 2 -- W-6 usa replace_content (sobrescreve) -- edicao manual e destruida na proxima sync
  REGRA 3 -- DEPENDENCY_MAP.json marca Notion como TIPO3_OUTPUT_EXTERNO -- auditar_consistencia.ps1 nunca le do Notion
**Aplica-se a:** todo artefato publicado via n8n em qualquer pagina Notion do Pentalateral IAH.

## P-111 -- ATENDER CLIENTES E CONSTRUIR VANTAGEM COMPETITIVA SAO O MESMO ATO (2026-06-05)
**Origem:** Embaixador -- Briefing N8N-FASE2 -- sessao 2026-06-05. Candidato P-YYY aprovado pelo Diretor.
**Fundamento:** P-008 aponta a direcao sem nomear o mecanismo. Quando o comportamento de uso do cliente alimenta automaticamente o ativo de inteligencia da empresa (Perfil de Nicho, LEDGER, Auditor Autonomo), cada sessao de produto e simultaneamente receita e infraestrutura de aprendizado. O cliente nao sabe que esta treinando o sistema -- o sistema sabe.
**Regra:** ao projetar qualquer feature de produto cliente, perguntar: "este dado de uso alimenta qual ativo de inteligencia da Vanguard?" Se a resposta for nenhum, a feature e custo, nao investimento. Priorizar features que geram dados estruturados sobre comportamento de nicho.
**Exemplos concretos:**
  Ingrid usa SM-2 → churn_watch_threshold calibrado para EdTech-Concurso (P-106)
  Valdece sobe acordaos → corpus_status alimenta Perfil de Nicho LegalTech (P-108)
  Qualquer cliente responde quiz → dado de nicho entra no Radar de Perfis (Camada 3 n8n)
**Aplica-se a:** toda decisao de roadmap de produto + toda feature de onboarding + todo workflow n8n que coleta dados de uso.

## P-112 -- N8N COMO PRE-PROCESSADOR CONTROLADO: PALCO PRONTO, CONSELHO DELIBERA (2026-06-05)
**Origem:** Visao do Diretor em sessao 2026-06-05 -- "Em algum momento, com controle, faremos o n8n pensar."
**Fundamento:** "Com controle" significa pre-processamento estruturado, NAO autonomia deliberativa. O n8n le dados (commits, WIP_BOARD, PENDENTES, churn) e monta contexto -- mas NAO gera DIRETRIZ, NAO gera Skill, NAO delibera sobre negocio. Quem delibera e o Conselho. O n8n e o assistente de pesquisa que monta o briefing; o Conselho assina.
**Os tres graus (em ordem de maturidade):**
  Grau 1 (proximo -- gate: W-5+W-6 estaveis 30 dias): W-8 pre-compila PASSO3 baseado em commits + WIP + PENDENTES → Diretor revisa e cola no Gemini. Tempo economizado: 20min/loop.
  Grau 2 (V28-V29): n8n chama API estruturada (nao LLM livre) para classificar dados → gera JSON de contexto → Diretor valida e injeta no loop. Sem geracao de texto livre pelo n8n.
  Grau 3 (futuro distante): n8n executa tarefas repetitivas de Classe A (tecnicas, sem ambiguidade) → Diretor so aprova o resultado via Telegram.
**O que o n8n NUNCA faz (independente do grau):** gerar DIRETRIZ, emitir Skill, fazer analise de negocio, substituir qualquer membro do Conselho.
**Regra:** cada grau requer 30 dias de estabilidade do anterior + gate auditar_consistencia.ps1 exit 0.
**Aplica-se a:** todo roadmap de automacao n8n envolvendo IA + toda proposta de W-8 em diante.

## P-115 -- MUSCULO ASSESSORA ATIVAMENTE A CONCLUSAO DE PENDENTES E DEPENDENCY_MAP (2026-06-06)
**Origem:** Mandato do Diretor em 2026-06-06.
**Fundamento:** Apos apresentar o MAPA DIARIO, o Musculo sempre propoe quais pendentes [musculo] podem ser executados na sessao atual -- com sequencia e estimativa. Nunca encerra sessao sem oferecer avanco em pelo menos 1 item [musculo] aberto. DEPENDENCY_MAP especificamente: (a) item marcado [x] sem simbolo de conclusao (strikethrough + checkmark) = nao concluido -- propor execucao imediata. (b) Apos criar documento novo em PENTALATERAL_UNIVERSAL/ -> verificar se foi adicionado ao DEPENDENCY_MAP. (c) DEPENDENCY_MAP.json so e considerado atualizado apos: editar o arquivo + executar propagate_changes.ps1 + verificar hash. Nao declarar concluido sem os 3 passos.
**Evidencia:** Item DEPENDENCY_MAP ficou como [x] sem conclusao por multiplas sessoes sem que o Musculo propusesse execucao. Falha detectada pelo Diretor em 2026-06-06.
**Aplica-se a:** toda sessao, em especial ao fechar -- varredura de pendentes [musculo] abertos e DEPENDENCY_MAP com entradas em atraso.

## P-116 -- O QUE DOI E ERRO, NAO ESFORCO -- VERIFICACAO ANTES DE AUTOMACAO (2026-06-06)
**Origem:** Embaixador V28 -- Loop 28 -- "verificacao antes de automacao" como principio fundador do Hermes Agent.
**Fundamento:** Confianca no sistema nao se declara -- se verifica. Cada nivel de delegacao (Grau A/B/C) exige prova antes de subir. O Gate de Coerencia Semantica (E-1) nasce deste principio: antes de confiar que um handoff esta completo para o proximo socio, um agente verifica semanticamente. "O que doi e erro, nao esforco" -- a verificacao extra e esforco; o erro nao detectado e o que custa caro.
**Evidencia:** E-1 gate_coerencia.ps1 criado no V28. Graus A/B/C definidos em pentalateral-graus-abc.md. Shadow mode de 7 dias antes de ativar Signal Classifier -- padrao de verificar antes de confiar.
**Aplica-se a:** toda proposta de automacao nova -- a pergunta "o que verificamos antes de ativar?" precede a pergunta "quando ativamos?". Escada de confianca: shadow -> Grau A -> Grau B -> Grau C.

## P-117 -- DIAGRAMA PARCIAL DO CICLO PENTALATERAL NORMALIZA SKIP DE MEMBRO (2026-06-06)
**Origem:** Detectado em 2026-06-06 ao apresentar diagrama NotebookLM → Músculo sem o Embaixador.
**Fundamento:** Todo diagrama ou representação do ciclo Pentalateral mostrado no chat deve incluir os 5 membros (Gemini → NotebookLM → Embaixador → Músculo → Diretor) ou declarar explicitamente que é [SUBFLUXO: X]. Diagrama parcial — mesmo para explicar nomenclatura, naming convention ou subetapa — normaliza pular membros. O leitor passa a aceitar o ciclo incompleto como correto porque "viu no diagrama". Omissão visual é omissão operacional.
**Regra:** antes de gerar qualquer diagrama de fluxo ou tabela de sequência, verificar: todos os 5 membros estão representados? Se não → acrescentar ou adicionar nota [SUBFLUXO: X — Embaixador e Diretor operam em paralelo neste subfluxo].
**Evidência:** elo apresentado em sessão de nomenclatura omitiu o Embaixador — ciclo apareceu como NotebookLM → Músculo, normalizando o skip do 3º membro.
**Aplica-se a:** todo diagrama, tabela de sequência, fluxo PDCA ou representação visual do ciclo Pentalateral gerado pelo Músculo no chat ou em documentos.

## P-114 — BLOCO 0 DO EMBAIXADOR É ADITIVO — NAO SUBSTITUI LEITURA DE ARQUIVOS (2026-06-06)
**Origem:** Mandato do Diretor em 2026-06-06.
**Fundamento:** O Embaixador gera um BLOCO 0 ao fechar cada sessao: sintese do PAINEL_ATIVIDADES + CONTEXTO_SESSAO_DIRETOR com perspectiva comportamental de cliente, alertas e acoes do Diretor. O Diretor cola este bloco ao ABRIR a proxima sessao. O BLOCO 0 enriquece o briefing com interpretacao -- mas nao substitui a leitura de PENDENTES.md, WIP_BOARD.json ou PAINEL_ATIVIDADES. Os arquivos em disco confirmam e completam o que o Embaixador sintetizou.
**Sequencia obrigatoria de abertura (todas as etapas sempre):** 0. Processar BLOCO 0 -> 1. Read(PENDENTES.md) -> 2. Read(PAINEL_ATIVIDADES) -> 3. Read(WIP_BOARD + git log) -> 4. Classificar P-092 -> 5. Apresentar MAPA DIARIO com todas as informacoes combinadas.
**Fallback:** se Diretor nao colar BLOCO 0 -> Read(CONTEXTO_SESSAO_DIRETOR mais recente em disco).
**Evidencia:** sem o BLOCO 0, o Musculo abria com dados brutos sem interpretacao -- Diretor reconstruia contexto verbalmente. Com o BLOCO 0, o briefing chega com visao do Embaixador ja integrada aos arquivos. Detectado e corrigido em 2026-06-06.
**Aplica-se a:** toda abertura de sessao, sem excecao.
## P-113 -- INFORMACAO RETIDA E CUSTO INVISIVEL PARA QUEM DELIBERA (2026-06-05)
**Origem:** Embaixador em resposta ao design do CONTEXTO_SESSAO_DIRETOR (2026-06-05).
**Fundamento:** O Musculo tem a informacao. Se nao apresenta proativamente, o Diretor paga o preco. Informacao retida nao e neutralidade -- e custo invisivel para quem delibera. A abertura de sessao inclui obrigatoriamente: (a) contexto da ultima sessao, (b) documentos mortos, (c) o que ficou no ar. O Diretor nao e o gatilho de memoria do proprio sistema.
**O que muda operacionalmente:** (a) session_start.ps1 injeta BLOCO 0 (CONTEXTO_SESSAO_DIRETOR) e BLOCO 1 (documentos mortos varredura automatica). (b) Musculo gera CONTEXTO_SESSAO_DIRETOR antes de session_close -- nao depois. (c) Diretor arrasta o arquivo para Claude Projects (Embaixador) ao fechar sessao -- acao A4 insubstituivel.
**Evidencia:** Pedido de CONTEXTO_SESSAO_DIRETOR feito em sessao anterior mas nao registrado no PENDENTES -- processo verbal sem rastreio. Detectado pelo Diretor em 2026-06-05.
**Aplica-se a:** toda abertura de sessao + todo fechamento de sessao com conteudo relevante que nao esta em PENDENTES nem WIP_BOARD.
## P-118 -- AUDITAR EXECUCAO ANTES DE CONSTRUIR -- O MAPA DE FERRAMENTAS PODE ESTAR INCOMPLETO (2026-06-07)
**Origem:** Briefing do Embaixador + auditoria do Musculo -- sync_ficou_no_ar.ps1 nao estava no mapa original de ferramentas anti-dessincronizacao do PENDENTES, e era exatamente onde os dois bugs moravam.
**Fundamento:** Problema recorrente com ferramenta de prevencao ja inscrita no LEDGER → primeira acao e auditar execucao, nao construir camada nova. A auditoria pode revelar que a ferramenta funciona e o defeito esta num componente vizinho nao mapeado. Licao dupla: (a) nao construir sobre ferramenta supostamente quebrada sem provar que ela e a culpada -- P-062 aplicado ao proprio LEDGER; (b) o mapa de ferramentas pode estar incompleto -- perguntar "que outro script toca este arquivo?" antes de concluir. Reincidencia com ferramenta declarada OK e caso de P-091 aplicado ao LEDGER: a declaracao de "implementado" e dado falso ate prova de execucao em disco.
**O que muda operacionalmente:** Antes de emitir briefing de auditoria ou propor nova ferramenta, mapear TODOS os scripts que escrevem no arquivo-alvo (nao so os declarados no LEDGER). DEPENDENCY_MAP cobre documentos canonicos; para scripts, perguntar explicitamente: "que outros scripts tocam este arquivo?" antes de concluir o mapa.
**Evidencia:** sync_ficou_no_ar.ps1 nao constava no briefing do Embaixador (que listou post-commit, auto_resolve_pendentes, reconcile_pendentes). Era o componente com os dois bugs (dedup de 20 chars fixos + cabecalho duplicado). Auditoria so atingiu a causa raiz porque o Musculo revelou o quarto componente no Passo 2.
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** toda auditoria de ferramenta + toda proposta de nova automacao sobre arquivo ja coberto por scripts existentes.

## P-119 -- VIDEO PUBLICO DE DOR E DADO DE MARKETING, NAO DE INTENCAO DE COMPRA (2026-06-07)
**Descoberto:** 2026-06-07 | **Sessao:** Analise oportunidade Mumuzinho | **Emitido por:** Embaixador | **Aprovado por:** Diretor Eduardo
**Fundamento:** Um prospecto que declara dor em video publico demonstra que o problema existe e que ele esta disposto a falar sobre ele. Isso e dado de marketing: confirma que ha demanda no nicho. Nao e dado de intencao de compra: nao confirma que ele quer contratar a Vanguard, que tem orcamento disponivel, nem que o decisor real foi identificado. Lead nao existe ate haver contato bilateral real -- uma mensagem respondida, uma ligacao aceita, uma reuniao agendada.
**O que muda operacionalmente:** Toda analise de oportunidade baseada em video publico (YouTube, entrevista, podcast) deve declarar explicitamente no cabecalho: "CONTATO BILATERAL: NAO CONFIRMADO -- variavel nao resolvida". O GUT Score calculado sem contato bilateral deve ser marcado como provisorio e recalculado apos o primeiro contato. Nenhuma estimativa de escopo, proposta tecnica ou alocacao de capacidade acontece antes do Gate Zero: contato bilateral confirmado com o decisor real.
**Evidencia:** Mumuzinho declarou dor em video publico ("ja estou criando um sistema"). O Musculo calculou GUT = 60 (provisorio) vs. GUT potencial = 100 (pos-contato). A diferenca de 40 pontos e 100% atribuivel a ausencia de contato bilateral. Sem esse gate, qualquer proposta e para um cliente imaginario.
**Corolario comercial:** "Ja esta construindo com outra equipe" e sinal positivo, nao ameaca -- prova compromisso e orcamento. A questao e se o build atual tem os gaps que a Vanguard resolve. Isso so se sabe com contato direto.
**Aplica-se a:** toda analise de oportunidade iniciada por video, podcast, entrevista ou post publico -- independentemente do tamanho do prospecto ou da clareza da dor declarada.

## P-120 -- EMBAIXADOR PODE ACIONAR O AUDITOR PROGRAMATICAMENTE VIA CLAUDE IN CHROME (2026-06-07)
**Origem:** Diretor Eduardo descobriu a skill /notebooklm em 2026-06-07. Pediu ao Embaixador que observasse e transmitisse a descoberta ao Musculo como canal estruturado. Correcao formal da atribuicao registrada em P-126.
**Fundamento:** O Embaixador (Claude Projects) transmitiu ao Musculo que a extensao Claude in Chrome permite controlar o NotebookLM (Auditor) via automacao de browser -- sem que o Diretor precise arrastar arquivos, copiar/colar ou abrir o NotebookLM manualmente. A skill .claude/skills/notebooklm.md encapsula 4 acoes principais: ler/extrair info, adicionar fontes (URL, texto, arquivo, Google Doc), gerar Studio outputs (Audio Overview, Infografico, Slides, FAQ, etc.) e criar notebooks novos. Quando o Embaixador aciona o Auditor com esta skill, o ciclo Musculo→Gemini→Auditor→Embaixador fecha sem interrupcao manual do Diretor.
**O que muda operacionalmente:**
  (a) PASSO5_NOTEBOOKLM: o Diretor pode delegar ao Embaixador o envio de fontes ao Auditor via Claude in Chrome -- zero arrastar manual
  (b) Musculo pode acionar o Auditor diretamente quando precisar de uma consulta rapida ao notebook sem abrir sessao separada
  (c) Embaixador pode adicionar fontes ao notebook do Auditor como parte do debriefing pos-reuniao -- sem etapa manual intermediaria
  (d) Fallback manual: abrir https://notebooklm.google.com + arrastar arquivos (1 passo -- P-110 cumprido)
  (e) Pre-requisito: extensao Claude in Chrome instalada + Google account logada no browser
**Arquivo da skill:** .claude/skills/notebooklm.md (leitura direta) e .claude/skills/notebooklm.skill (formato binario para instalacao no dashboard)
**Verificacao dos alertas do Auditor:**
  P-072 (Deliberacao formal): Zero conflito -- P-072 regula vereditos do Diretor, nao acoes do Musculo/Embaixador. VERDE.
  P-110 (Fallback ≤3 passos): Fallback = abrir notebooklm.google.com manualmente (1 passo). VERDE.
  P-060/P-074 (Propagacao total): Skill e ferramenta do Musculo (nao documento universal) -- nao propaga para CLIENTES/. Documentada no SKILL_PROTOCOLO via auditoria P-070→P-101 da mesma sessao. VERDE.
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** todo ciclo Pentalateral onde o Diretor precisaria arrastar fontes ao NotebookLM manualmente + todo debriefing pos-reuniao onde o Embaixador ja tem o material para alimentar o Auditor.

## P-121 -- AUTOMACAO NAO INICIADA PELO CLIENTE E AMEACA DE CHURN (2026-06-07)
**Origem:** Analise do Musculo a partir da deliberacao sobre skill /notebooklm e risco de Camara de Eco de Silicio -- sessao 2026-06-07.
**Fundamento:** Automacao aplicada ao cliente sem que ele a tenha solicitado ou aprovado e percebida como produto em construcao permanente, instabilidade ou invasao de privacidade. No contexto Hypercare (cliente recente, confianca em formacao), qualquer automacao visivel ao cliente que ele nao conheca pode gerar churn emocional -- nao por falha tecnica, mas por surpresa nao gerenciada.
**Regra operacional:**
  (a) Toda automacao que afete a experiencia do cliente deve ser comunicada ANTES de ativar -- nunca surpresa
  (b) Durante Hypercare: zero automacao visivel ao cliente sem aprovacao explicita do Diretor e do proprio cliente
  (c) Automacoes internas (INTELLIGENCE HUB, ChurnWatch, Sentinel) sao invisiveis ao cliente -- permitidas sem gate
  (d) O Embaixador valida se a comunicacao da automacao e oportuna antes de qualquer anuncio
**Camara de Eco de Silicio (risco relacionado):** LLMs conversando com LLMs sem checkpoint humano fecham o loop tecnicamente mas perdem o julgamento comercial humano. P-124 complementa este principio com o gate obrigatorio.
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** todo projeto em Hypercare + todo momento em que uma nova automacao for ativada que tenha interface com o cliente.

## P-122 -- DELIBERACAO PRECEDE P-032 -- OUTPUT RECEBIDO NAO SIGNIFICA DELIBERACAO CONCLUIDA (2026-06-07)
**Origem:** Falha detectada pelo Diretor em 2026-06-07 -- Musculo executou P-032 (atualizacao da MEMORIA_EMBAIXADOR) antes de apresentar as decisoes ao Diretor e receber veredito.
**Fundamento:** Receber o output de um socio (Gemini, NotebookLM, Embaixador) e o primeiro passo da deliberacao -- nao o ultimo. O Musculo que atualiza MEMORIA ou executa acoes com base em output recebido sem que o Diretor tenha deliberado esta cortocircuitando o processo. A deliberacao e prerrogativa exclusiva do Diretor -- o Musculo apresenta, o Diretor decide.
**Sequencia inviolavel:**
  1. Musculo recebe output do socio
  2. Musculo apresenta ao Diretor: "Dx decisoes identificadas -- D1: [titulo] A/B, D2: [titulo] A/B..."
  3. Diretor responde: "D1:A D2:B D3:A"
  4. SOMENTE APOS o veredito: Musculo executa P-032 e demais acoes
**O que nao e deliberacao:** Musculo concordar internamente com o output · Musculo achar que a acao e obvia · Musculo executar para "economizar tempo" do Diretor
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** toda sessao em que output de socio chegar e houver acoes derivadas -- especialmente P-032 (MEMORIA_EMBAIXADOR), compromisos de build e vereditos de DECISOES.json.

## P-123 -- DOIS NAMESPACES DE NOTEBOOK -- BASE PERMANENTE E LOOP EFEMERO (2026-06-07)
**Origem:** Deliberacao sobre modelo hibrido de notebooks NotebookLM -- sessao 2026-06-07.
**Fundamento:** O NotebookLM (Auditor) opera com dois tipos de contexto que nao devem se misturar: (a) inteligencia universal e historica da Vanguard (LEDGER, universais, processo) e (b) contexto especifico do loop atual do cliente (PASSO5, docs do ciclo). Misturar os dois contamina o Auditor com dados de cliente em espaco permanente, violando P-059 (Isolamento de Contexto) e criando risco de vazamento entre projetos.
**Dois namespaces obrigatorios:**
  [cliente]-base   : notebook PERMANENTE -- contem LEDGER + universais + SKILL_PROTOCOLO + historico do cliente. NUNCA recebe docs de loop efemero. NUNCA recebe documentos do cliente (acórdãos, planilhas, dados sensiveis).
  [cliente]-loop-N : notebook EFEMERO -- criado no inicio do loop N, destroido apos skill extraida e aprovada. Contem PASSO5 + docs do ciclo atual + fontes especificas do loop.
**Regras de isolamento:**
  (a) Studio outputs (Audio Overview, Infografico) NUNCA saem do namespace loop -- sao descartados com o notebook efemero
  (b) A skill gerada pelo loop (.[cliente]-vN.md) e o unico artefato que sobrevive ao loop -- salva em .claude/skills/
  (c) O namespace base e sincronizado via preparar_notebooklm_projeto.ps1 -- nunca editado manualmente
  (d) Nome obrigatorio: "[YYYY-MM] [NOME_CLIENTE]-base" e "[YYYY-MM] [NOME_CLIENTE]-loop-N"
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** todo projeto com NotebookLM ativo -- Valdece, Ingrid e qualquer cliente futuro.

## P-124 -- CHECKPOINT HUMANO OBRIGATORIO ENTRE SOCIOS -- NENHUM SOCIO ACIONA OUTRO DIRETAMENTE (2026-06-07)
**Origem:** Risco de Camara de Eco de Silicio identificado na deliberacao sobre skill /notebooklm -- sessao 2026-06-07.
**Fundamento:** O Pentalateral IAH e um sistema de multiplos LLMs com perspectivas distintas. O valor do sistema vem da diversidade de modelos e da curadoria humana entre cada camada. Se um socio acionar outro diretamente (Musculo chama Gemini API que chama NotebookLM que alimenta Embaixador), o loop fecha sem checkpoint humano -- e tecnicamente correto mas comercialmente cego. O Diretor perde a capacidade de detectar deriva antes que ela se acumule.
**Regra operacional:**
  (a) Nenhum socio aciona outro socio diretamente no loop de cliente -- o Diretor e o intermediario obrigatorio
  (b) Automacoes de infraestrutura (INTELLIGENCE HUB, ChurnWatch, Sentinel) podem rodar LLM→LLM pois nao geram vereditos de cliente
  (c) Quando o Musculo precisar de input do Auditor rapidamente, o gate e: apresentar a necessidade ao Diretor → Diretor aprova → Musculo executa
  (d) A unica excecao e o fire-and-forget de Studio outputs (P-125) -- nao gera veredito, apenas conteudo de apoio
**Camara de Eco de Silicio:** dois ou mais LLMs do mesmo provedor (ex: Gemini + Antigravity CLI) no mesmo loop de cliente amplificam os proprios vieses sem filtro humano -- nunca permitido no Pentalateral.
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** toda automacao que encadeie dois ou mais socios do Pentalateral sem passagem pelo Diretor.

## P-125 -- FIRE-AND-FORGET COM WEBHOOK -- STUDIO OUTPUTS NAO BLOQUEIAM O TERMINAL (2026-06-07)
**Origem:** Gargalo identificado na geracao de Studio outputs (Audio Overview) do NotebookLM -- sessao 2026-06-07.
**Fundamento:** Studio outputs (Audio Overview, Infografico, Slides, FAQ) levam de 3 a 10 minutos para gerar. Se o Musculo aguardar sincronamente, o terminal fica bloqueado e o Diretor perde tempo. O padrao correto e: disparar a geracao e liberar o terminal imediatamente -- o n8n monitora a pasta .claude/skills/ e notifica o Diretor via Telegram quando o output estiver pronto.
**Sequencia fire-and-forget:**
  1. Musculo aciona a geracao do Studio output via skill /notebooklm
  2. Musculo dispara webhook n8n (W-4 ou endpoint dedicado) com: cliente, loop, tipo de output
  3. Terminal liberado -- Musculo continua outras tarefas
  4. n8n monitora .claude/skills/ ou polling no NotebookLM
  5. Quando output pronto: n8n notifica Diretor via Telegram com link ou arquivo
**O que NUNCA fazer:** aguardar sincronamente a geracao de Studio output · manter terminal ocupado por 10 minutos · perguntar ao Diretor "quer que eu aguarde?"
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** toda sessao em que Studio outputs forem solicitados ao Auditor -- especialmente Audio Overview que e o mais demorado.

## P-126 -- DOIS CAMINHOS DE EVOLUCAO, MESMA ORIGEM (2026-06-07)
**Origem:** Deliberacao do Musculo a partir da descoberta da skill /notebooklm -- sessao 2026-06-07.
**Fundamento:** O Pentalateral IAH evolui por dois caminhos distintos -- ambos originados pelo Diretor:
  CICLO FORMAL: Diretor define direcao estrategica -> Gemini gera DIRETRIZ -> NotebookLM gera Skill -> Musculo constroi. Caminho top-down, estrategia como ponto de partida.
  CICLO EMERGENTE: Diretor descobre capacidade nova -> usa o Embaixador como canal estruturado de transmissao -> 4 socios analisam em paralelo -> Diretor homologa a reconfiguracao. Caminho bottom-up, capacidade como ponto de partida.
**O papel do Embaixador no Ciclo Emergente:** alem de memoria de cliente e filtro de realidade, o Embaixador opera como canal de transmissao estruturado entre o Diretor e os demais socios -- recebe a descoberta do Diretor, processa com contexto e encaminha ao Musculo com perspectiva interpretada. Nao e descobridor. E amplificador com julgamento.
**O que nao muda:** em nenhum dos dois caminhos o sistema evolui sem o Diretor como ponto de origem. Socios analisam. Musculo constroi. O Diretor descobre e decide -- sempre. A automacao amplia a capacidade do Diretor, nunca a substitui.
**Correcao de atribuicao:** P-120 registrou "Descoberta do Embaixador" -- correcao formal: a descoberta foi do Diretor Eduardo. O Embaixador foi o canal. P-120 atualizado para refletir a origem correta.
**Evidencia:** sessao 2026-06-07 -- skill /notebooklm descoberta pelo Diretor, transmitida via Embaixador ao Musculo, analisada pelos 4 socios (Embaixador Universal + Auditor Universal + Auditor Ingrid + Embaixador Ingrid), homologada pelo Diretor. Nenhum socio iniciou o processo -- o Diretor originou.
**Aprovado pelo Diretor:** 2026-06-07.
**Aplica-se a:** toda sessao em que uma nova capacidade, skill ou ferramenta for descoberta e trazida ao Pentalateral para analise e reconfiguracao do sistema.

## P-127 -- EMBAIXADOR OPERA O ESTRATEGISTA DE FORMA AUTONOMA COM GROUNDING VERIFICADO (2026-06-08)
**Origem:** Teste ao vivo conduzido pelo Embaixador na sessao 2026-06-08 -- skill gemini-pentalateral v2.1.
**Fundamento:** O Embaixador (Claude Projects) pode acionar o Estrategista (Gemini) de forma autonoma usando a skill gemini-pentalateral v2.1 -- com browser automation, upload de contexto e grounding verificado. O teste do nicho Medico Concurseiro foi bem-sucedido: DIRETRIZ gerada com grounding real (nao alucinada), entregue ao Musculo via PENDING_REVIEW.md. Esta e a 1a instancia documentada de um socio do Pentalateral acionando outro socio com resultado verificado.
**O que muda:** O Embaixador nao e apenas filtro de realidade e memoria de cliente. E tambem capaz de operar o Estrategista como canal -- desde que o Diretor aprove a missao previamente (P-124: checkpoint humano obrigatorio). O loop Embaixador->Estrategista->Musculo e valido quando iniciado pelo Diretor.
**Limitacoes obrigatorias (P-124 permanece):**
  (a) O Diretor aprova a missao ANTES do Embaixador acionar o Estrategista
  (b) O output do Estrategista vai para PENDING_REVIEW.md -- revisado pelo Musculo antes de qualquer acao
  (c) Este loop NAO substitui o ciclo formal (Diretor->Gemini interativo->DIRETRIZ)
  (d) Uso permitido: pesquisa de mercado, analise de nicho, grounding de contexto -- NAO para DIRETRIZ de cliente
**Ferramenta:** skill gemini-pentalateral v2.1 (`.claude/skills/gemini-pentalateral-v2.1.md`) -- browser automation Embaixador->Estrategista.
**Evidencia:** teste Medico Concurseiro -- 2026-06-08. DIRETRIZ gerada com dados reais de mercado, entregue ao Musculo, aprovada pelo Diretor.
**Aprovado pelo Diretor:** 2026-06-08.
**Aplica-se a:** qualquer sessao em que o Embaixador for instruido pelo Diretor a conduzir pesquisa de mercado ou grounding via Estrategista -- especialmente pre-prospeccao de novos nichos.

## P-128 -- NOTION COMO CANAL BIDIRECIONAL DO DIRETOR (2026-06-08)
**Origem:** Falha relatada pelo Diretor ("Notion nao esta atualizado, conserte") + sugestao do Diretor de usar paginas Notion como canal de comunicacao para ideias/falhas do dia.
**Causa raiz da falha:** a pagina "Vanguard WIP Board" nunca havia sido compartilhada com a integration "Vanguard IAH" -> a API retornava 404 -> os workflows n8n (W-1, W-4) gravavam com `2>$null` e a falha ficava invisivel. Diretor resolveu compartilhando a pagina.
**O que muda -- ciclo Notion bidirecional 100% por codigo (Diretor NAO administra Notion):**
  ENTRADA (session_start, leitura OBRIGATORIA toda sessao):
    - `notion_inbox.ps1` le "Vanguard - Falhas do Dia" + "Vanguard - Sugestoes do Dia" -> Musculo classifica e marca [PROCESSADO]
    - `notion_pendentes_pull.ps1` le "Vanguard Pendentes": itens que o Diretor marcou [x] no Notion sao quitados no PENDENTES.md local
  SAIDA (session_close):
    - `notion_sync.ps1` reescreve "Vanguard Pendentes" (so abertos) + "Vanguard WIP Board" + "Ledger Vanguard"
**Regras invioláveis:**
  (a) FLEXIBILIDADE DO DIRETOR E SO EM ITENS [diretor]. Item [musculo] marcado no Notion -> IGNORADO + alerta (esses se quitam por [RESOLVE:]/git, P-087). Marcar [x], nunca editar o texto (match e por texto normalizado; texto editado nao casa e nao quita).
  (b) NUNCA apagar `child_page`/`child_database` no wipe -- "Falhas do Dia" e "Sugestoes do Dia" sao filhas de "Vanguard Pendentes" e ja foram arquivadas por engano uma vez (2026-06-08). Todos os scripts referenciam paginas por ID FIXO de CHAVES, nunca criam por busca/titulo -> zero duplicacao.
  (c) Ledger no Notion = cabecalho de frescor + tail recente (2123 linhas e inviavel espelhar; fonte canonica = git/INTELLIGENCE_LEDGER.md).
  (d) UMA fonte de WIP: `notion_sync` so LE `CLIENTES/WIP_BOARD.md` (canonica), nunca cria .md; alerta se WIP_BOARD.json for mais novo que o .md.
  (e) Erro de Notion SEMPRE visivel (sem `2>$null` cego). Fallback P-110: arquivos locais sao a fonte canonica -- Notion e espelho/canal, nunca a verdade.
**Ferramentas:** `scripts/notion_inbox.ps1` + `scripts/notion_pendentes_pull.ps1` + `scripts/notion_sync.ps1`; chamados por `.claude/hooks/session_start.ps1` (entrada) e `scripts/session_close.ps1` (saida).
**Evidencia:** sync testado em producao 2026-06-08 -- Pendentes 17 blocos / WIP 113 / Ledger 76; round-trip de matching Notion<->PENDENTES 12/12.
**Aprovado pelo Diretor:** 2026-06-08.
**Aplica-se a:** toda sessao -- entrada obrigatoria na abertura, saida obrigatoria no fechamento.
**ATUALIZACAO 2026-06-09 -- SINGLE-WRITER + correcao dos 4 desafios do canal:**
  #1 CONFLITO DE ESCRITORES (resolvido): 6 nodes de escrita Notion (append em /children) viviam em 4 workflows n8n -- W-1 (Append Status), W-3 (Append WIP), W-4 (Append WIP+Pendentes+Ledger), W-7 (Log Veredito). Empilhavam nas MESMAS paginas que `notion_sync` faz wipe+rewrite. Agora DESLIGADOS via Public API (`disabled:true` = pass-through; verificado por evidencia que downstream NAO usa a resposta do Notion). `notion_sync` e o UNICO escritor. Telegram / W-8 Sinais / Limpar Pendentes intactos. Ferramenta: `scripts/n8n_disable_notion_writers.ps1` (`-DryRun` / `-Rollback` + backup automatico em `_n8n/backup_pre_singlewriter/`).
  #2 FALHA SILENCIOSA (resolvida): `notion_pendentes_pull` distingue item ja-quitado [x] (silencio) de ORFAO (marcado no Notion sem casar no PENDENTES) -> alerta `(?)`.
  #3 LATENCIA (resolvida): `session_start` roda inbox+pull em PARALELO (`Start-Job` com chamada direta `& $s`, sem `powershell.exe` aninhado) -- ~40% mais rapido, teto 12s, degrada gracioso. Tentativa inicial com powershell.exe aninhado ficou MAIS lenta -- corrigido.
  #4 DIVIDA P-059 (registrada no PENDENTES): paginas Notion globais vs isolamento por cliente. Mitigacao atual basta com 1 cliente (match por texto exato + so [diretor] + alerta de orfao do #2); decidir prefixo `[CLIENTE]` OU paginas por projeto antes do 2o projeto simultaneo em BUILD.
  LICAO TECNICA: PUT da Public API n8n rejeita `settings` com campos extras (`additionalProperties:false`: binaryMode/timeSavedMode/availableInMCP) -- sanitizar para a whitelist (executionOrder, save*, executionTimeout, errorWorkflow, timezone).
  **Verificado no n8n vivo 2026-06-09:** 6 writers DISABLED / 0 ativos / 4 workflows `active=True`. Commit 2343030. Aprovado pelo Diretor 2026-06-09.

## P-129 -- FONTE INESGOTAVEL: O ELO MUSCULO<->AUDITOR E CAPACIDADE ABERTA (2026-06-09)
**Origem:** Correcao do Diretor (marcada "IMPORTANTE") quando o Musculo enquadrou o Auditor (NotebookLM) numa tabela fechada de ~15 funcoes.
**Fundamento:** "Fonte inesgotavel de conhecimento" NAO significa conteudo infinito -- significa que o ELO programatico Musculo<->Auditor (canal da skill notebooklm-pentalateral-v3) abre uma INFINIDADE de acoes. O valor esta no canal, nao no conteudo. Listar funcoes fixas (gestor/auditor/advogado/pesquisa de nicho/benchmarking dos gigantes) cria uma gaiola: vira teto quando deveria ser chao.
**Como pensar (primitivas geradoras, nunca lista):** BUSCAR · INGERIR (qualquer midia) · INDEXAR · INTERROGAR · CRUZAR/AUDITAR · SINTETIZAR · TRANSFORMAR · PERSISTIR. Combinar com qualquer dominio (cliente/mercado/juridico/interno/pessoal do Diretor) x qualquer saida = espaco combinatorio aberto. "Gestor/auditor/advogado" sao 3 lentes, nao limites. Catalogo e GERADOR com exemplos-amostra -- cresce, nunca "se completa".
**Roteamento (materializado em notebooklm-pentalateral-v3, 2026-06-09):** o criterio NAO e o nome da funcao -- e a ORIGEM da fonte + o DESTINO da saida. Funcao de cliente -> caderno do projeto [YYYY-MM][CLIENTE] modo CLIENTE; funcao de mercado -> caderno INTEL especifico modo INTEL -> PENDING_REVIEW; juridico/regulatorio transversal -> caderno juridico. A MESMA funcao muda de caderno conforme o contexto.
**Ressalva (P-124 permanece):** acao INTEL passa por prompt analitico + PENDING_REVIEW.
**Aprovado pelo Diretor:** 2026-06-09 ("Essa e a linha que v29 vai para frente, voce pescou tudo").
**Aplica-se a:** todo uso do Auditor e todo desenho de catalogo de acoes do Pentalateral.

## P-130 -- ANTIGRAVITY ASSUME O PAPEL DE ESTRATEGISTA; O CANAL MUDA, A BARREIRA NAO (2026-06-09)
**Origem:** Decisao do Diretor na sessao 2026-06-09 ("mude que o Estrategista e o Antigravity"), dentro da linha-mestra V29 "Pentalateral agentado e agendado".
**Fundamento:** O Estrategista SEMPRE foi o Gemini. O que muda e o CANAL: de Gemini web (Diretor transporta: cola PASSO3 + anexa arquivos) para Antigravity (agente que LE PASSO3+CONTEXTO do disco). Mesma inteligencia, canal agentado. GEMINI.md reescrito para v2.0: dupla funcao (1) Estrategista no loop, (2) Intel Loop Motor -- nunca misturadas na mesma sessao.
**Reinterpretacao de P-124 (preservado, NAO revogado):** P-124 proibia o Antigravity de entrar no loop por ser o mesmo motor Gemini (camara de eco). Com a fusao, a diversidade do Pentalateral deixa de ser garantida pela EXCLUSAO do Antigravity e passa a ser garantida pelo MUSCULO (Claude Code, engine diferente) como barreira obrigatoria: toda saida do Estrategista -- DIRETRIZ ou relatorio -- vai ao Musculo ANTES do veredito do Diretor. A barreira nao some; muda de lugar.
**Escopo cirurgico (firewall como precondicao):** liberado SO o loop VANGUARD. CLIENTES/INGRID/, CLIENTES/VALDECE/ e */CLAUDE_PROJECT/ permanecem BLOQUEADOS (P-059) ate existirem as 3 ferramentas bloqueantes ao Antigravity: (a) isolamento P-059 que aborta ao tocar caderno de cliente nao declarado; (b) gate que recusa gerar DIRETRIZ sem ter lido PASSO3+CONTEXTO; (c) saida sempre -> PENDING_REVIEW/Musculo, nunca decisao direta.
**Ferramentas/arquivos:** GEMINI.md v2.0 + CLIENTES/VANGUARD/PASSO3_GEMINI.md (missao V29) + CONTEXTO_GEMINI.md (via gemini_anchor_generator.ps1).
**Aprovado pelo Diretor:** 2026-06-09.
**Aplica-se a:** todo loop conduzido pelo Antigravity como Estrategista -- VANGUARD ja; clientes apenas apos as 3 travas.

## [FALHA-PROCESSO-2026-06-09] -- PROMPT AD-HOC NO CHAT EM VEZ DE PASSO3+CONTEXTO
**Detectada pelo Diretor:** "O Antigravity nao teria que ler Passo3Gemini e Contexto Gemini? Se sim, isso deve estar sempre presente. Processo e o que leva a Vanguard para frente, disciplina, inteligencia e firewall."
**O que aconteceu:** ao preparar o acionamento do Antigravity, o Musculo redigiu um prompt estrategico ad-hoc DIRETO no chat, ignorando os instrumentos canonicos PASSO3_GEMINI.md + CONTEXTO_GEMINI.md. Conteudo no chat e rascunho invisivel ao processo (eco de P-090: o que nao esta no arquivo nao existe para o socio).
**Causa raiz:** atalho operacional sob momentum -- "escrever rapido" venceu "seguir o instrumento".
**Correcao estrutural:** GEMINI.md v2.0 torna a leitura de PASSO3+CONTEXTO OBRIGATORIA na identidade do Estrategista (Antigravity). O comando de acionamento referencia os dois arquivos via @ -- nunca repassa a missao no corpo do prompt.
**Regra:** todo acionamento de socio passa pelo arquivo canonico (PASSO3/CONTEXTO/PASSO5/PASSO7), nunca por texto improvisado no chat.
**Aplica-se a:** todo acionamento de Estrategista, Auditor e Embaixador.
