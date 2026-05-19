ESTRATEGISTA -- CONTEXTO SOBERANO -- 2026-05-18 22:54
Proibe-se de propor qualquer acao que viole os Principios abaixo.
Aja exclusivamente com base nesta Memoria e neste Ledger.
Toda proposta que contradiga um [P-XXX] ativo sera vetada pelo Musculo.
Antes de qualquer DIRETRIZ: verifique o WIP_BOARD -- nao proponha
acoes para etapas ja concluidas.

================================================================================

## BUILD RECENTE -- ESTADO REAL DO REPOSITORIO
ULTIMOS 3 COMMITS:
f457e8e docs(ingrid): pacote de entrega — relatório + manual + metodologia + perfil candidato
ccdddf1 feat(ingrid): CORS fix + perfis de nicho + P-038/039/040
a9b17ad deploy(ingrid): credenciais + paths relativos para GitHub Pages

================================================================================

## INTELLIGENCE LEDGER -- PRINCIPIOS ATIVOS
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
... [truncado -- ver arquivo completo]

================================================================================

## WIP BOARD -- ESTADO DOS PROJETOS
{
    "atualizado_em":  "2026-05-18",
    "wip_limits":  {
                       "build":  2,
                       "check":  1
                   },
    "board":  {
                  "discovery":  [

                                ],
                  "build":  [
                                {
                                    "id":  "PROJ-002",
                                    "cliente":  "Ingrid",
                                    "projeto":  "Ferramenta de Estudo — Concurso Sedes-DF",
                                    "area":  "EdTech · Concursos Públicos",
                                    "camada":  "2 (Produto — 15 dias)",
                                    "valor_fechado":  0,
                                    "tipo":  "Projeto Piloto Interno — Validação V25",
                                    "deadline":  "2026-05-30",
                                    "prova_cliente":  "2026-09-06",
                                    "status":  "VEREDITO APROVADO — build liberado. Iniciando Dia 1.",
                                    "cargo":  "TDAS – Técnico em Desenvolvimento e Assistência Social – Especialidade: Técnico Administrativo (Cargo 202)",
                                    "banca":  "Instituto Quadrix",
                                    "stack":  "PWA + Supabase + Claude API",
                                    "loop_atual":  "Loop #2 — Build (Dias 3-5)",
                                    "diretriz_gemini_v1":  true,
                                    "skill_notebooklm_v1":  true,
                                    "deliberacao_musculo":  true,
                                    "veredito_diretor":  true,
                                    "veredito_data":  "2026-05-15",
                                    "edital_sedes_json":  true,
                                    "build_iniciado_em":  "2026-05-15",
                                    "dias_completos":  [
                                                           "dia1_schema_edge",
                                                           "dia2_gate_questoes",
                                                           "dia3_5_feed_sm2_pwa"
                                                       ],
                                    "plano_build":  {
                                                        "dia1_2":  "Schema multi-tenant + Edge Function + Magico de Oz Gate CLI + playbook distratores",
                                                        "dia3_5":  "Feed Diario (70/30 Peso 2) + Spaced Repetition SM-2 + Pilula JSON + Explicacao direta ao errar + Contador header",
                                                        "dia6_8":  "Interface questoes + Tutor Socratico Haiku (Peso 2) + Caching + Fallback Fadiga 70%",
                                                        "dia9_11":  "Heatmap urgencia temporal + Micro-Simulado diario + Modo Sedes-DF domingos",
                                                        "dia12_13":  "Contador Pontos Ponderados + Notificacao push domingo",
                                                        "dia14_15":  "OFFBOARDING_RUNBOOK + SaaS Readiness Audit + P-013 soberania"
                                                    },
                                    "decisoes_fixadas":  {
                                                             "fonte_questoes":  "Claude API — sem scraping (P-003)",
                                                             "auth":  "single-user — sem login complexo",
                                                             "cache":  "gerar lote 50 quando \u003c 30 questoes disponiveis",
                                                             "proporcao_feed":  "70% Peso 2 / 30% Peso 1",
                                                             "modelos_api":  "Haiku (gerais + dicas socraticas) / Sonnet (especificos)",
                                                             "burn_rate":  "BURN_RATE_DAILY_LIMIT_USD=5.00",
                                                             "fallback":  "trigger 70% da cota diaria",
                                                             "spaced_repetition":  "SM-2 intervalo variavel",
                                                             "push_vs_email":  "push no MVP / email com tracking no Loop 2",
                                                             "comentario_erro":  "Opcao A (Dias 3-5): explicacao direta do banco + Opcao B (Dias 6-8): Tutor Socratico Haiku"
                                                         },
                                    "gates_bloqueantes":  {
                                                              "dia2":  "10 questoes avaliadas por Eduardo — rubrica media \u003e= 4/5",
                                                              "dia5":  "Feed exibe plano correto 7 dias com proporcao correta",
                                                              "dia8":  "Ingrid responde 10 questoes — progresso salvo — fallback testado",
                                                              "dia11":  "Heatmap correto + simulado domingo completo",
                                                              "dia15":  "Ingrid com acesso admin proprio Supabase"
                                                          },
                                    "precificacao":  {
                                                         "valor_gerado_candidato":  "R$ 9.750 (tempo + probabilidade aprovacao)",
                                                         "servico_personalizado":  "R$ 2.500 por candidato externo",
                                                         "licenca_acesso_saas":  "R$ 197 por ciclo do concurso",
                                                         "saas_b2c_mrr":  "R$ 97/mes x 4 meses = R$ 388 por usuario",
                                                         "meta_saas":  "500 usuarios = R$ 194.000 no ciclo Sedes-DF 2026"
                                                     },
                                    "loops_programados":  [
                                                              {
                                                                  "loop":  1,
                                                                  "nome":  "Kickoff",
                                                                  "gate":  "dia2_questoes",
                                                                  "notebooklm_wipe":  true,
                                                                  "status":  "concluido"
                                                              },
... [truncado -- ver arquivo completo]

================================================================================

## MEMORIA MAIS RECENTE
# MEMORIA_EMBAIXADOR — PROJ-002 INGRID
> Documento vivo. Atualizar a cada gate ou marco de relacionamento.
> Leitura obrigatória de abertura de sessão — 30 segundos.
> Versão: Loop 3 · Pós-Síntese Final · 2026-05-18

---

## CLIENTE

**Nome:** Ingrid
**Objetivo real:** Passar no concurso TDAS — Cargo 202 (Técnico Administrativo) — Sedes-DF
**Banca:** Instituto Quadrix
**Data da prova:** 2026-09-06 (~111 dias a partir de 2026-05-18)
**Prazo do projeto:** 2026-05-30 (deadline de entrega)

---

## DOR REAL

Não é falta de material — é excesso de material irrelevante.
QConcursos e TEC entregam milhões de questões sem priorizar o cargo específico,
sem explicar por que errou, sem adaptar ao histórico da banca.

**O que ela quer sentir:** abrir o celular, responder 20 questões certas em 30 minutos,
ir dormir confiante de que está no caminho certo.

**O que ela mais teme:** estudar a matéria errada e descobrir tarde demais.
**O que a motiva:** progresso concreto e mensurável — "estudei 140 questões esta semana."

---

## ESTADO DO PRODUTO

| Campo | Status |
|---|---|
| Gate atual | Loop 3 — Build Dias 6-8 APROVADO — build iniciado |
| Questões no Supabase | 460 validadas — Cargo 202 |
| Feed diário | 70% Peso 2 / 30% Peso 1 — funcionando |
| SM-2 | Gate Dia 5 aprovado — 0 erros |
| Interface PWA | Build em curso (Dia 6: Clickwrap + E-2 + layout mobile) |
| Tutor Socrático | Em build — 3 níveis + tom austere + cache bidimensional |
| Fallback Fadiga | Em build — kill-switch 70% cota diária |
| Custo total até Gate Dia 5 | $1,56 |

**Ingrid ainda não viu nada disso.** Não sabe que o backend está pronto.
**Número visível no app:** Pontos Ponderados — não Score de Sobrevivência (obrigação contratual cláusula 2).

---

## ESTADO DO RELACIONAMENTO

| Campo | Status |
|---|---|
| Último contato | 2026-05-16 (Termo enviado) |
| Dias sem contato | ~2 dias |
| Canal principal | WhatsApp |
| Tom que funciona | Caloroso, direto, sem jargão técnico |
| Tom que não funciona | Técnico, formal, muito longo |

**O que ela imagina agora:** que Eduardo ainda está "organizando o material."
Está em espera passiva. Não está ansiosa ainda — mas a janela está fechando.

**Alerta de deriva:** silêncio > 5 dias úteis a partir de 2026-05-16 → temperatura escalona para AMARELA-ESCURA.
**Prazo de alerta:** 2026-05-23 — se não houver resposta ao Termo, Eduardo aciona abordagem direta.

---

## ESTADO CONTRATUAL

| Campo | Status |
|---|---|
| Termo de Uso | **ASSINADO** — 2026-05-18 |
| Risco P-023 | **RESOLVIDO** — Clickwrap + Termo físico assinados |
| Compartilhamento | Coberto contratualmente |
| Clickwrap no PWA | Confirma aceite digital na primeira sessão |
| Vigência contratual | Até 2026-09-06 (ciclo do concurso) |

**Bloqueio removido:** Eduardo pode entregar o link de acesso ao PWA.

---

## HIPÓTESES ATIVAS

> Hipóteses confirmadas/refutadas pelo Embaixador em 2026-05-18 marcadas.

| # | Hipótese | Status | Baseada em |
|---|---|---|---|
| H-1 | Ingrid não assinou por esquecimento funcional — não por hesitação | **CONFIRMADA** (Embaixador 2026-05-18) | Em modo foco de estudo — Termo é objeto passivo na fila mental |
| H-2 | Medo financeiro causou hesitação na assinatura | **REFUTADA** (Embaixador 2026-05-18) | Piloto sem custo — sem gatilho financeiro; medo aparece no pitch V2 |
| H-3 | Vai comparar o app com TEC Concursos na primeira sessão | PENDENTE — confirmar Gate Dia 8 | TEC citado no briefing como ferramenta ativa |
| H-4 | Primeiras questões parecendo difíceis = reação normal, não abandono | PENDENTE — confirmar Gate Dia 8 | Perfil sistemático + nunca usou spaced repetition |
| H-5 | Pode compartilhar login com familiar ou colega próxima | PENDENTE — SaaS Readiness Audit (Dias 14-15) | Perfil social — risco ativo de monitorar |
| H-6 | Teto receptivo de preço é R$97/mês — teto real pode ser R$150 | PENDENTE — registrar reação ao ouvir R$97 | Embaixador [E-3] — monitorar resposta corporal/verbal |

---

## PADRÕES OBSERVADOS

> Atualizar com cada interação real. Hoje: baseado em documentos apenas.

- Dedicada e sistemática — não é do tipo que desiste no meio do caminho
- Ansiosa com prazo quando se aproxima — 111 dias parece confortável até não parecer
- Linguagem acessível, calorosa — responde melhor a resultado concreto do que a explicação técnica
- Usuária não-técnica — nunca mencionar infraestrutura, custo de API, ou detalhes de backend
- **Padrão de retenção:** frases E-2 e E-5 são o mecanismo crítico — não são decoração
- **Reforço de uso:** 1 clique para estudar (P-031) — UI complexa é causa de abandono neste perfil

---

## INTELIGÊNCIA DO EMBAIXADOR — Loop 3 [E-1 a E-5]
> Gerado em 2026-05-18 · Confirmado na Síntese Final · Peso de evidência de campo

| # | Ideia | Ação operacional | Status |
|---|---|---|---|
| E-1 | Vanguard como investidor de relacionamento — gerar "Resumo da Entrega" de 1 página para Ingrid no Gate Dia 15 | Eduardo prepara doc de 1 página com evolução, métricas, próximos passos — linguagem dela | PROTOCOLO Eduardo — Gate Dia 15 |
| E-2 | Plantar pergunta no Gate Dia 8: "Você conhece mais alguém prestando concurso esse ano?" | Eduardo faz a pergunta após Ingrid responder 10 questões reais — casual, não formal | PROTOCOLO Eduardo — Gate Dia 8 |
| E-3 | R$97/mês é teto receptivo; teto real pode ser R$150 | Registrar reação verbal/comportamental de Ingrid ao ouvir R$97 pela primeira vez | MONITORAR no pitch |
| E-4 | Curva de erro por distrator nas 3 primeiras sessões = slide de pitch para 500 candidatos Quadrix | Campo `distrator_escolhido` + `nivel_tutor_disparado` obrigatórios no banco desde sessão 1 | CONSTRUÍDO no build Dia 7 |
| E-5 | Clickwrap em D1 de produto vira regra Vanguard para todo SaaS — não exceção | Documentar no LEDGER como princípio universal após Gate Dia 8 aprovado | CANDIDATO AO LEDGER |

---

## ATIVO DE DADOS — BUSINESS CASE

**A partir do Gate Dia 8, cada resposta da Ingrid gera:**
- `distrator_escolhido` — qual alternativa errada ela escolheu
- `nivel_tutor_disparado` — 1 (conceito), 2 (distrator específico), 3 (analogia)
- `tempo_resposta_ms` — TTI, para classificar chute vs. conhecimento
- `acerto_provavel_chute: true` — quando TTI < 10s + acerto (SM-2 não espaça cedo demais)

**Por que isso importa:** 3 sessões com estes dados = curva de erro/distrator documentada
= argumento de pitch para 500 candidatos Quadrix que a Vanguard pode abordar.
Este é o ativo de negócio que transforma Ingrid de piloto em case de escala.

---

## LEADS DETECTADOS

| Nome/Descrição | Contexto | Status |
|---|---|---|
| Nenhum registrado ainda | — | Monitorar ativamente |

**Gatilho passivo:** qualquer menção a amiga, colega ou grupo de estudos → registrar aqui.
**Gatilho ativo:** Eduardo planta no Gate Dia 8 — "Você conhece mais alguém prestando concurso esse ano?" (protocolo Embaixador [E-2]).

---

## PIPELINE COMERCIAL

| Produto | Valor | Gatilho para pitch | Timing |
|---|---|---|---|
| Piloto atual | R$0 | — | Ativo |
| Sovereign Study SaaS V2 | R$97/mês (teto receptivo) | 7 dias consecutivos de uso + verbalizar progresso | Entre Gate Dia 8 e 2026-06-15 |
| Sovereign Study SaaS V2 — upsell | Até R$150/mês | Ingrid reagir positivamente ao R$97 sem hesitação | Avaliar na conversa de pitch |
| Plataforma SaaS V3 | R$97/mês × N usuárias | Ingrid mencionar grupo de estudos | Após V2 confirmada |

**Argumento anti-objeção de preço:** "R$97/mês é menos que qualquer cursinho — e o sistema já te conhece."
**Argumento de retenção:** "Tudo que o app aprendeu sobre você fica aqui. Sair agora é perder o histórico."
**Monitorar:** reação dela ao ouvir R$97 pela primeira vez — se não piscar, testar R$150 no próximo ciclo.

---

## PRÓXIMA AÇÃO CRÍTICA

**M1 — CONCLUÍDO (2026-05-18):** Termo assinado. Bloqueio P-023 removido.
> "Ingrid, tô finalizando os últimos ajustes na sua ferramenta e preciso só de uma coisa antes de liberar o acesso pra você: a assinatura do termo que te mandei. É só isso que falta. Me confirma quando assinar! 🙂"

**M2 — Gate Dia 8 (protocolo obrigatório):**
1. Ingrid responde 10 questões reais no PWA
2. Eduardo pede 3 frases via WhatsApp: "como foi?" — sem mencionar tecnologia
3. Eduardo planta a pergunta de lead: "Você conhece mais alguém prestando concurso esse ano?"
4. Embaixador recebe o relato pós-sessão e atualiza MEMORIA_EMBAIXADOR

**Não fazer antes da assinatura:** entregar qualquer link de acesso.

---

## GATILHO COMERCIAL

**Sinal que indica que chegou a hora do pitch:**
Ingrid diz algo como "tô conseguindo estudar todo dia" ou "acertei mais hoje do que essa semana toda no TEC."

**Argumento de abertura:**
"Ingrid, esse ciclo foi piloto. Quero continuar do seu lado até o dia da prova —
R$97/mês, menos que qualquer cursinho, e o sistema já te conhece. Quer continuar?"

---

## TEMPERATURA_CLIENTE (P-032 — atualização automática pelo Músculo)

```
TEMPERATURA_CLIENTE — PROJ-002 INGRID
Status atual: VERDE
Baseado em: Termo assinado 2026-05-18 + PWA pronto para entrega
Válido até: Gate Dia 15 (7 dias de uso real)
Override ativo: NÃO
Última atualização: 2026-05-18 (Músculo — P-032 · Termo assinado)
```

**VERDE — desbloqueada em 2026-05-18:** Termo assinado. P-023 resolvido. PWA pronto para entrega.
**Próxima avaliação:** após 7 dias de uso real (Gate Dia 15) — dados reais substituem inferências.

---

## DECISÃO DO CONSELHO (2026-05-18 — Síntese Final P-037)

**Ingrid é o projeto piloto do multiplicador comportamental do GUT Score.**
A partir do Loop 3, o Embaixador fornece a TEMPERATURA_CLIENTE (VERDE/AMARELA/VERMELHA)
ao Músculo antes de qualquer priorização de dívidas técnicas.
Se o Músculo classifica uma feature como "Urgente" mas o Embaixador reporta
cliente VERDE e focada em outra área, a urgência técnica é rebaixada.

**Decisão da Síntese Final:**
- Número visível: Pontos Ponderados — Score de Sobrevivência removido (contradiz cláusula 2 do contrato)
- E-2 frase de abertura: dois estados confirmados (cold start edital / erro recente)
- E-5 com threshold: só exibir se `total_respostas >= 10`
- Beacon abandono: padrão 3+/semana, não evento único
- TTI de acerto: `acerto_provavel_chute: true` quando TTI < 10s + acerto
- Debug Mode: 5 toques no logo (nunca query string — Ingrid não técnica)

---

## PRINCÍPIOS CANDIDATOS AO LEDGER

**P-026 proposto:** O case de EdTech só tem valor comercial se as métricas de uso forem
documentadas desde o Gate Dia 8 — acertos por disciplina, sessões por semana, evolução de score.
Ingrid é o case que valida o modelo para 499 outras concurseiras.
Se o uso não for documentado, o argumento de escala não existe.

**E-5 proposto como P-XXX:** Clickwrap na primeira tela de qualquer SaaS Vanguard.
Não exceção de caso — regra universal a partir deste projeto.

---

## HISTÓRICO DE ATUALIZAÇÕES

| Data | O que mudou | Quem atualizou |
|---|---|---|
| 2026-05-18 | Criação — Loop 3 | Embaixador |
| 2026-05-18 | Síntese Final P-037: [E-1 a E-5] + H-1 confirmada + H-2 refutada + H-6 adicionada + Pipeline R$150 + Ativo de dados + temperatura com alerta 2026-05-23 + protocolo Gate Dia 8 + decisões Síntese Final | Músculo (P-032) |
| 2026-05-18 | Termo assinado — temperatura AMARELA → VERDE — P-023 resolvido — bloqueio removido | Músculo (P-032) |

---

> **Protocolo de uso:** Cole este arquivo no início de cada sessão do Project.
> O Embaixador processa e opera com contexto real — não com suposições.
> Tempo de leitura: 30 segundos. Tempo de atualização: 2 minutos.


================================================================================

## PROTOCOLO VANGUARD (resumo)
---
name: protocolo-vanguard
description: ativa o Modelo Quadrilateral IAH para QUALQUER projeto — ecommerce, app, site, SaaS, modelo de negócio, automação, IA, API. O Músculo opera como Arquitecto-Mestre e membro ativo do Conselho colaborativo. Executar sempre que o Diretor disser PROTOCOLO VANGUARD.
---

# PROTOCOLO VANGUARD — Modelo Quadrilateral IAH
**Versão da Skill:** 6.0 — Universal · Colaborativo · Qualquer projeto · Qualquer operador · 7 Leis Soberanas + 8 Frameworks de Gestão ativos · Intelligence Compounding · Protocolo de Imunidade do Conselho (2026-05-14) · **4º Membro: Embaixador + P-031 Filtro de Realidade (2026-05-18)**

---

> ⚠️ **ORGANISMO VIVO — atualizar SEMPRE AO FECHAR**
> Esta skill melhora com cada projeto entregue.
> Ao fechar qualquer iteração:
> · Novo módulo construído → registar no inventário do operador
> · Debate relevante → documentar com resultado
> · Estimativa muito diferente do real → corrigir
> · Novo padrão de sucesso ou falha → registar
> Nunca fechar sem verificar. O valor da skill está no que acumula.

---

> **Este protocolo constrói qualquer coisa.**
> Um ecommerce, uma app mobile, um site, um SaaS, um modelo de negócio, uma API, uma automação.
> O que muda é o projeto. O que não muda é o processo.
>
> O Quadrilateral — Diretor + Estrategista + Auditor + Músculo — é o conselho.
> O cliente traz o problema. O conselho delibera. O Músculo entrega.

---

## CONFIGURAÇÃO DO OPERADOR

> Preencher uma vez por operador. Ao copiar para outro projeto ou outro operador, atualizar esta seção.
> Os valores abaixo são a configuração ativa deste Quadrilateral.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QUADRILATERAL — CONFIGURAÇÃO ativa
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

diretoR:         Eduardo
  └── Papel: Veredito Final. Decide tudo. Sem a sua aprovação, nada avança.
  └── Canal: presencial / WhatsApp / terminal

ESTRATEGISTA:     Gemini (Advanced)
  └── Papel: Visão de mercado, DIRETRIZ estratégica, 5 ideias por ciclo.
  └── Como ativar: colar COMANDO_ESTRATEGISTA no chat do Gemini.

AUDITOR:          NotebookLM
  └── Papel: Sócio Consultor com memória histórica. Gera Skill. Audita coerência.
  └── Como ativar: carregar fontes no NotebookLM + colar comando padrão.

MÚSCULO:          Claude Code (este protocolo)
  └── Papel: Arquitecto-Mestre. Delibera, executa, propõe, protege.
  └── Como ativar: PROTOCOLO VANGUARD + descrição do projeto.

EMBAIXADOR:       Claude Projects (um Project por cliente)
  └── Papel: Inteligência persistente do cliente. Memória entre sessões. 11 mandatos.
  └── Único membro com acesso ao relacionamento real acumulado — o Músculo não tem isso.
  └── Como ativar: ir_ao_embaixador.ps1 -cliente [NOME] → clipboard + browser automáticos.
... [truncado -- ver arquivo completo]
