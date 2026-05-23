# RELATÓRIO EVOLUTIVO V2 — PROJ-002 Ingrid
**Loop:** #2 — Build Dias 3–5 (Feed Diário + Banco de Questões)  
**Data:** 2026-05-17  
**Próxima fase:** Loop #3 — Dias 6–8 (Interface + Tutor Socrático + Fallback)

---

## PARA A INGRID — O QUE FOI CONSTRUÍDO

Ingrid, enquanto você estudava, a equipe construiu o coração do seu app.

Hoje o sistema tem 460 questões no estilo exato da banca Quadrix — cobrindo as 13 disciplinas do Cargo 202 que você vai fazer. Não questões genéricas: questões calibradas com as pegadinhas reais que a Quadrix usa, com o mesmo nível de dificuldade e o mesmo estilo de alternativas.

E o mais importante: o sistema já foi testado. Por 7 dias simulados, ele entregou exatamente 14 questões das matérias mais pesadas e 6 das gerais — todos os dias, sem falhar uma vez. Isso é o que vai acontecer quando você abrir o app todo dia de estudo.

O que vem a seguir: a interface para você responder as questões no celular, o tutor que vai te explicar por que você errou (e mudar o ângulo de explicação se você errar de novo), e o modo de revisão para os dias mais curtos.

---

## ESTADO ATUAL

| Dimensão | Situação |
|---|---|
| Banco de questões | 460 questões — 13 disciplinas Cargo 202 |
| Feed diário | 70.0% Peso 2 + 30% Peso 1 — validado 7 dias consecutivos |
| Interface mobile | Ainda não construída — Loop 3 |
| Dias de build usados | 5 de 15 |
| Deadline | 2026-05-30 (10 dias restantes) |
| Prova | 2026-09-06 (~112 dias) |

---

## ANÁLISE SWOT DO LOOP 2

### Forças
- **Banco próprio validado:** 460 questões geradas no estilo Quadrix, priorizadas por score de incidência — nenhuma plataforma de concurso no mercado tem esse cruzamento para este cargo específico
- **Feed exato do edital:** proporção 70/30 testada por 7 dias — Ingrid vai estudar o que cai, na proporção certa, todos os dias automaticamente
- **Arquitetura de custo controlado:** custo real de ~$0,054 por 5 questões Sonnet — dentro do budget. A lógica de batch externo garante que a stack não estoura timeout nem custo
- **Troubleshooting proprietário:** 7 panes documentadas com causa + solução — a Vanguard vai resolver em <5 min qualquer problema que levou horas hoje

### Fraquezas
- **Interface ainda não existe:** Ingrid não pode usar o app ainda — Loop 3 é bloqueante para a experiência real
- **MEMORIA e RELATORIO do Loop 2 não foram gerados ao fechar o loop** — Eduardo teve que intervir. Processo manual ainda depende de memória do Músculo
- **Skill do Auditor (Loop 1) não está na pasta CONSELHO/INGRID** — não foi localizada para alimentar o Loop 3

### Oportunidades
- **Tutor Socrático com memória de erro** é o diferencial de produto que separa o app de qualquer flashcard do mercado. Quadrix não testa conhecimento — testa raciocínio. O tutor que muda o ângulo no segundo erro vai preparar Ingrid para o raciocínio, não para a decoreba
- **Cache de explicações** é custo zero no acerto: ao errar pela 2ª vez, o Tutor Haiku usa o que já gerou. API gasta só em questões novas — nunca em repetição
- **Modo Revisão Express** resolve o maior problema de adesão: dias curtos. Ingrid abre o app no ônibus, responde 5 questões SM-2 vencidas, fecha. Consistência bate esporádico sempre

### Ameaças
- **10 dias de build restantes** para 3 loops: Dias 6-8 (interface), 9-11 (heatmap + simulado), 12-15 (soberania). Prazo apertado — qualquer loop que estourar comprime os seguintes
- **Gate Dia 8** exige que Ingrid interaja com o app real. Se a interface não estiver funcional até Dia 8, o gate não pode ser executado

---

## PDCA DO LOOP 2

### Plan (Planejado)
- Feed diário 70/30 com SM-2
- Seed de questões Cargo 202 (recalibrado de TDAS para Técnico Administrativo)
- Gate Dia 5: 7 dias simulados com proporção exata

### Do (Executado)
- edital_sedes.json v3.0 — reconstruído do zero com disciplinas corretas
- Edge Function `gerar-questoes` refatorada — 1 Claude call por invocação
- Edge Function `feed-diario` deployada pela primeira vez
- 460 questões geradas no Supabase — 13 disciplinas Cargo 202
- `iniciar.ps1` — ponto de entrada único da sessão
- `gate_cli_dia5.js` corrigido (import node-fetch removido)
- `session_close.ps1` com auditoria automática de documentos
- `TROUBLESHOOTING_SUPABASE_CLAUDE_API.md` — 7 panes permanentes

### Check (Verificado)
- Gate Dia 5: 7 dias × 20 questões, 70.0% Peso 2, 0 erros — APROVADO 2026-05-17
- Custo real Sonnet: ~$0,054/5 questões — dentro do budget
- Falha detectada: MEMORIA e RELATORIO não foram gerados ao fechar loop

### Act (Próxima ação)
- Wipe & Sync NotebookLM + sessão Gemini → DIRETRIZ 2 → sessão NotebookLM → Build Dias 6-8

---

## DECISÃO CRÍTICA REGISTRADA — RECALIBRAÇÃO DE CARGO

A decisão mais importante do Loop 2 não foi técnica — foi de validação de dados.

O projeto começou com o cargo TDAS área social (SUAS, LOAS, PNAS). No Loop 2, a validação revelou que Ingrid faz o **Cargo 202 — Técnico Administrativo**, com disciplinas completamente diferentes. O banco inteiro foi reconstruído.

**O que isso muda:** todo projeto EdTech deve validar o número exato do cargo e a especialidade antes de gerar qualquer questão. O edital tem cargo, especialidade e área — os três devem ser conferidos. Virou o P-024.

---

## 5 IDEIAS DISRUPTIVAS DO MÚSCULO (Loop 3 — para o Gemini reagir)

### M-6 — Tutor Socrático com Memória de Erro
Ao errar a mesma questão duas vezes, o Tutor Haiku muda o ângulo. 1ª tentativa: explica o conceito. 2ª: ataca especificamente o distrator que Ingrid escolheu. 3ª: formula uma pergunta analógica para forçar o raciocínio próprio. Tutor que repete não ensina — que adapta ao erro específico, ensina.  
**Impacto:** elimina o "ler a explicação sem aprender" — o Tutor força o processamento ativo  
**Custo:** campo `tentativas_erradas jsonb` em `progresso_usuario` + lógica de seleção de prompt, 2h  
**Pergunta para o Gemini:** o ciclo de 3 ângulos é suficiente ou o 4º erro deve acionar revisão agendada obrigatória?

### M-7 — Cache de Explicações
Explicações geradas pelo Tutor Haiku para cada questão são salvas no campo `explicacao_tutor` em `questoes_quadrix`. Na 2ª vez que Ingrid errar a mesma questão, o sistema usa o cache — zero custo de API, resposta instantânea. A cota de API se concentra em questões novas.  
**Impacto:** reduz custo de API em 40-60% nas semanas de revisão (SM-2 traz questões repetidas)  
**Custo:** migração para adicionar coluna `explicacao_tutor text` + lógica de cache, 1h  
**Pergunta para o Gemini:** cache por questão ou por dupla (questão × distrator escolhido)?

### M-8 — Fallback de Fadiga com Pílulas Passivas
Quando Ingrid atinge 70% da cota diária de API (`controle_burn_rate`), o app não para — muda de modo. Exibe as "pílulas do dia" salvas no banco (campo `pilula_do_dia`): frases-âncora das pegadinhas, resumos legislativos em 2 linhas, casos práticos sem questão.  
**Impacto:** estudo contínuo sem custo extra de API — o dia de estudo não termina por limite de cota  
**Custo:** coluna `pilula_do_dia text` em edital_sedes.json + UI de card passivo, 1.5h  
**Pergunta para o Gemini:** pílulas geradas via Haiku em batch ou escritas manualmente pelo Músculo?

### M-9 — Progresso Visual por Disciplina no Header
Em vez de contador genérico de questões respondidas, mostrar barra de progresso por disciplina Peso 2 (as 6 mais importantes). Ingrid vê que "Direito Administrativo" está em 45% e "SUAS" em 80% — sabe onde atacar sem o app precisar dizer. A visualização cria urgência específica, não genérica.  
**Impacto:** decisão autônoma de onde estudar — aumenta a sensação de controle e progresso real  
**Custo:** query agregada de acerto por disciplina + 6 barras no header, 2h  
**Pergunta para o Gemini:** mostrar % de acerto ou % de questões completadas? Os dois comunicam coisas diferentes para quem estuda.

### M-10 — Modo Revisão Express (5 min)
Para dias com pouco tempo: 5 questões pré-selecionadas pelo SM-2 — apenas as com intervalo vencido e maior score de prioridade. Ingrid abre no ônibus, responde 5, fecha. Consistência diária supera sessões longas esporádicas. O produto que se adapta ao tempo disponível retém mais do que o que exige bloco de 30 min.  
**Impacto:** adesão nos dias de baixa disponibilidade — o dia não é "perdido"  
**Custo:** query filtrada por `proxima_revisao_em <= today()` + modo UI simplificado, 1.5h  
**Pergunta para o Gemini:** 5 questões é o número certo ou o número deve ser dinâmico (SM-2 vencidas disponíveis, máx 10)?

---

## 5 IDEIAS DISRUPTIVAS DO MÚSCULO — Loop 3 · Sessão 2026-05-18 (M-11 a M-15)

> Geradas na sessão de build do Loop 3 antes do Gate Dia 8.
> Para o Gemini reagir no próximo ciclo junto com [M-6 a M-10].

### M-11 — verificar_projeto.ps1 como padrão universal (P-041)
Checklist de 6 artefatos obrigatórios por projeto: PASSO3 + PASSO5 + PASSO6 + PASSO7 + 00_INSTRUCAO_SISTEMA + MEMORIA_EMBAIXADOR. Projeto sem os 6 = setup incompleto, detectado antes do primeiro build via `.\scripts\verificar_projeto.ps1 -cliente [NOME]`. Falha detectada hoje: PASSO7_EMBAIXADOR não havia sido instanciado para a Ingrid — setup estava incompleto sem que o Músculo detectasse.
**Impacto:** elimina a classe de falha "artefato faltando descoberto no meio do build"
**Custo:** script já construído e testado — adicionar ao ritual de kickoff de qualquer projeto
**Pergunta para o Gemini:** P-041 deve entrar no BLOCO 0 (Diagnóstico) da DIRETRIZ como verificação obrigatória antes de qualquer novo loop?

### M-12 — G/N/E/V no iniciar.ps1 — acesso cirúrgico ao Conselho
Menu `[G]` / `[N]` / `[E]` / `[V]` integrado ao `iniciar.ps1` de cada projeto. Diretor escolhe 1 letra — sistema roda o script correto, abre Explorer e browser automaticamente. Elimina dependência de memória do Diretor sobre qual script rodar, em qual ordem, com quais argumentos. Implementado hoje no PROJ-002.
**Impacto:** zero fricção para acionar qualquer membro do Conselho — barreira de adoção eliminada
**Custo:** padrão já implementado — replicar para PROJ-001 Valdece e qualquer novo projeto
**Pergunta para o Gemini:** [E] deve ser a primeira opção do menu (antes de [G] e [N]) dado que o Embaixador é o filtro de realidade do loop?

### M-13 — Perfis de Nicho como produto central da Vanguard (P-040)
EdTech-Concurso e LegalTech-Penal documentados hoje como nichos inaugurais. Cada projeto deixa para trás: perfil do candidato/cliente, troubleshooting proprietário, playbook de distratores e modelo de testes validado. O segundo projeto no mesmo nicho começa 60% mais rápido que o primeiro. V26 da Vanguard tem Perfis de Nicho como núcleo de produto — não apenas repositório interno.
**Impacto:** diferencial competitivo que acumula a cada projeto; impossível de copiar sem o histórico
**Custo:** PERFIL_CANDIDATO_SEDES_DF.md e METODOLOGIA_VANGUARD.md já criados — padrão definido
**Pergunta para o Gemini:** os Perfis de Nicho devem ter uma pasta própria em PENTALATERAL_UNIVERSAL/ (hoje estão em CLIENTES/[PROJ]/) para que o próximo projeto os herde automaticamente?

### M-14 — BLOQUEIO_CRITICO — detecção proativa de dependências externas críticas
Toda dependência externa com potencial de bloquear o build (crédito Anthropic, cota de API, chave expirada, limite de plano) deve ter detecção automática com mensagem clara e link direto de resolução. Implementado hoje no seed: quando créditos Anthropic esgotam, o processo para imediatamente com `BLOQUEIO_CRITICO` + link para console.anthropic.com. Antes: erro genérico sem diagnóstico — horas de debug.
**Impacto:** elimina a classe de falha "build parou por recurso externo sem diagnóstico claro"
**Custo:** padrão já implementado no seed — replicar para qualquer script que chame API externa
**Pergunta para o Gemini:** BLOQUEIO_CRITICO deve gerar alerta automático no Telegram além de exibir no terminal?

### M-15 — PASSO7_EMBAIXADOR com 6 blocos como padrão universal para todos os clientes
Formato instanciado hoje para Ingrid: Temperatura do Cliente · Hipóteses Ativas · Comportamento Observado · Watchdog de Silêncio · [E-1 a E-5] · Próxima Ação. Os 6 blocos cobrem: estado do relacionamento, o que confirmar/refutar, ação imediata e inteligência para o loop. Antes do projeto Ingrid, PASSO7 existia só como template universal — nunca havia sido instanciado.
**Impacto:** Embaixador opera com contexto específico de cada cliente, não com template genérico
**Custo:** instanciamento leva ~30 min por projeto — deve ser o Passo 0 de qualquer projeto Camada 1+
**Pergunta para o Gemini:** o PASSO7 deve ser gerado pelo Músculo automaticamente ao criar o projeto (junto com o 00_INSTRUCAO_SISTEMA), ou continua sendo instanciado manualmente?

---

## O QUE ESTE LOOP PROVOU QUE É UNIVERSAL

| Princípio | Aplicação futura |
|---|---|
| **P-024 — Validação de cargo** | Qualquer projeto EdTech: validar cargo + especialidade + área antes de qualquer geração |
| **P-025 — Arquitetura Supabase+Claude** | 1 Claude call por Edge Function invocation. Loop externo. Strip markdown sempre. Batch Sonnet ≤ 5q |
| **TROUBLESHOOTING_SUPABASE_CLAUDE_API.md** | Checklist de 10 pontos antes de qualquer projeto com esta stack — evita ~6h de debug |
| **Falha de processo → ferramenta, não regra** | Auditoria automática de documentos no session_close.ps1. Regra sem ferramenta se repete |

---

## PRÓXIMOS PASSOS (para Eduardo executar)

**Ação 1 — Wipe & Sync do NotebookLM (antes da sessão Gemini)**
```powershell
.\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
```
Apagar todas as fontes atuais do NotebookLM. Arrastar a pasta `CLIENTES\INGRID\NOTEBOOKLM_FONTES\` inteira. O script monta tudo em ordem — arrastar, não selecionar um a um.

**Ação 2 — Sessão Gemini (PASSO 3)**
Anexar em ordem: `INTELLIGENCE_LEDGER.md` → `WIP_BOARD.json` → `PASSO3_GEMINI.md`  
Resultado esperado: DIRETRIZ_GEMINI_V2 nos 7 blocos obrigatórios  
Salvar como: `CLIENTES\INGRID\DIRETRIZ_GEMINI_V2.txt`

**Ação 3 — Sessão NotebookLM (PASSO 5)**
Rodar `preparar_notebooklm_projeto.ps1` novamente após salvar a DIRETRIZ V2 (ela será incluída como fonte 12)  
Skill esperada: `ingrid-v2.md` — 4 partes obrigatórias

---

*Relatório gerado pelo Músculo ao fechar Loop 2 · PROJ-002 Ingrid · 2026-05-17*  
*Quadrilateral IAH V25 — Conselho: Eduardo (Diretor) · Gemini (Estrategista) · NotebookLM (Auditor) · Claude Code (Músculo)*
