# PERFIL DE NICHO — EDTECH-CONCURSO
## Concurseira sistemática em pré-prova (180-90 dias)
> **Status:** PILOTO — baseado em cliente real (PROJ-002 Ingrid) com 1 ciclo de uso documentado.
> **Maturidade:** 60% consolidado — 40% extrapolado de pesquisa de mercado pendente.
> **Guardião:** Embaixador. **Validador:** Auditor.
> **Criado em:** 2026-05-18 · **Versão:** v1
>
> **AVISO:** este documento é trade secret da Vanguard Tech. Acelera onboarding interno do próximo cliente deste nicho. Não circular externamente. Não citar em propostas comerciais.

---

## ARQUÉTIPO DA CLIENTE

### Quem é
Mulher entre 25 e 45 anos, candidata a concurso público de nível técnico ou médio, na janela final de preparação (90 a 180 dias até a prova). Tem renda própria ou apoio familiar suficiente para se dedicar ao estudo em tempo parcial ou integral. Já tentou concursos antes (provavelmente sem sucesso) ou está mudando de área. Acessa material de estudo principalmente pelo celular.

### Como ela pensa sobre o concurso
Não como aposta — como projeto. Tem cronograma mental, lista de matérias, e fica ansiosa quando o cronograma derrapa. A pergunta que ela faz dezenas de vezes por dia é "estou estudando o que importa?" — e a resposta nunca é tranquilizadora.

### O que ela não vai dizer mas é verdade
Tem medo de descobrir, no dia da prova, que estudou as coisas erradas. Esse medo é maior do que o medo de não estudar o suficiente. Volume não a tranquiliza — direção sim.

---

## TRÊS VETORES DO PERFIL

### Vetor Comportamental

**Padrão de uso esperado:**
- Sessões de 20 a 30 minutos, geralmente de manhã cedo ou à noite tarde.
- 20 a 50 questões por dia em ritmo sustentado (não pico-vale).
- Lê o enunciado com atenção literal — não com leitura dinâmica. **Quadrix recompensa esse perfil. Outras bancas (Cebraspe) podem castigá-lo.**
- Reporta bugs com precisão técnica em linguagem natural — não pede feature, aponta defeito.
- Não compara com concorrente uma vez que se sentiu acolhida pelo produto. Antes de se sentir acolhida, compara muito.

**Gatilhos de engajamento:**
- Progresso mensurável visível na tela ("X questões respondidas hoje", "Y dias consecutivos").
- Feedback imediato ao errar — com referência à fonte legal específica, não comentário genérico.
- Sensação de que o sistema "já me conhece" depois de 3-5 dias de uso.

**Gatilhos de abandono:**
- UI complexa com mais de um clique para começar a estudar.
- Fricção técnica não resolvida em 24-48h (bug visto, reportado, ignorado → quebra de confiança).
- Sensação de estar perdendo tempo em matéria que sabe que não vai cair.
- Comparação interna desfavorável com plataforma que ela já paga (TEC, QConcursos).

**Padrão emocional:**
- Silêncio prolongado não é desinteresse — é absorção. Concurseira em foco silencia. Cobrar resposta no silêncio quebra a concentração e gera fricção.
- Feedback positivo espontâneo no primeiro uso é dado raro e valioso — capturar verbatim sempre.
- Ansiedade cresce não-linearmente conforme a prova se aproxima — pode dobrar nos 30 dias finais.

---

### Vetor Comercial

**Como ela tomou a decisão de procurar uma ferramenta personalizada:**
Não tomou. **A ferramenta foi oferecida.** O ponto-chave do nicho: este perfil **não busca ativamente** alternativa às plataformas grandes. Ela aceita uma alternativa quando alguém de confiança oferece e demonstra que serve.

**Sensibilidade a preço:**
- Plataformas referência: Gran (R$660/ano), Estratégia (R$2.700/ano), TEC (R$50/mês).
- Teto receptivo de mensalidade para EdTech personalizada: R$97/mês — confortável.
- Teto real provável: R$150/mês — sem regateio se o produto entregou nos primeiros 7 dias.
- **Esperança não regateia.** Cliente em modo aspiracional (passar no concurso = mudança de vida) tem teto de preço mais alto do que cliente em modo negociação.
- Argumento de venda que ela aceita: "Menos que um cursinho mensal e o sistema já te conhece."
- Argumento que ela rejeita: comparação técnica entre features (não fala a língua dela).

**Janela ideal de pitch:**
Entre dia 7 e dia 30 de uso real. Antes, cliente ainda não confia. Depois, cliente já acomodou o uso gratuito como direito adquirido e cobrar gera atrito desnecessário.

**Sinal que indica disposição de pagar:**
Ela verbalizar progresso espontâneo. *"Tô conseguindo estudar todo dia"* ou *"acertei mais hoje do que essa semana toda no TEC"*. Antes desse sinal, o pitch é prematuro.

**Argumento anti-objeção mais forte:**
*"Tudo que o app aprendeu sobre você fica aqui. Sair agora é perder o histórico."* — apela ao patrimônio cognitivo já construído, não ao preço.

---

### Vetor Técnico

**Plataforma obrigatória:** PWA mobile-first. App nativo é overhead desnecessário. Browser é universal, instalação é opcional via "adicionar à tela inicial".

**Restrições críticas:**
- **1 clique para estudar.** Nenhuma escolha de matéria, nenhum filtro, nenhum dashboard. Abrir → estudar.
- **Tempo da abertura à primeira questão respondida: < 5 segundos.** Acima disso, fricção desproporcional para o uso diário esperado.
- **Sem dependência de conexão constante.** Caching agressivo, fallback de modo passivo se API cair.
- **Sem login complexo.** Hardcoded user_id para single-user; auth real só na V2 multi-tenant.
- **Clickwrap do Termo de Uso na primeira tela.** Resolve juridicamente sem fricção de PDF separado.

**Stack mínima validada:**
- Frontend: PWA Vanilla JS (sem React/Vue — overhead injustificado para o caso).
- Backend: Supabase (Edge Functions + Postgres + Auth quando aplicável).
- Geração de conteúdo: Claude API (Haiku para volume, Sonnet para curadoria).
- Custo operacional comprovado em piloto: <$2,00 por usuária por mês de uso real.

**Métricas técnicas que importam para este perfil:**
- `tempo_assinatura → primeiro_acesso` — KPI fundamental, define escala.
- `tempo_primeiro_acesso → primeira_questao_respondida` — define se a UI cumpre o "1 clique".
- `distrator_escolhido` + `tempo_resposta_ms` — alimenta o tutor socrático e o pitch da V2.
- `acerto_provavel_chute` (TTI < 10s + acerto) — protege o SM-2 de espaçar cedo demais.

**Features que NÃO entram no MVP deste perfil:**
- Dashboards analíticos com múltiplos gráficos. (Cliente lê 1 número: pontos ponderados.)
- Gamificação infantil (badges, foguetes). Tom austere é o que funciona.
- Multi-disciplina simultânea (todas as matérias em paralelo). O sistema escolhe.
- Funcionalidades sociais (ranking, comparação com outros usuários). Aumenta ansiedade, não desempenho.

**Features que vão aparecer na V2 deste perfil (validadas como pedidas implicitamente):**
- Áudio gerado por IA do conteúdo do dia (commuting/exercício/casa).
- Modo intensivo nos 30 dias finais (reta final com proporção alterada).
- Notificação push opcional uma vez ao dia em horário escolhido pela usuária.

---

## DIFERENCIAÇÃO ESTRUTURAL VS. OUTROS PERFIS

Este Perfil **NÃO é variação** do Perfil Legal-Tech ou de qualquer outro. As diferenças que importam para o método Vanguard:

| Eixo | EdTech-Concurso | Diferença que importa |
|---|---|---|
| Motivação | Aspiracional ("mudar de vida") | Cliente tolera fricção menor — está investindo emoção, não só dinheiro |
| Modo de decisão | Esperança, não negociação | Não regateia preço justo; rejeita comparação racional fria |
| Ritmo de uso | Diário, sustentado, 20-30 min | Produto precisa caber na rotina, não exigir bloco de tempo |
| Sensibilidade a bugs | Alta, mas reporta com civilidade | Fix em 24h fortalece; ignorar em 48h destrói |
| Pipeline de indicação | Boca a boca entre concurseiras | Indicação acontece se ela já se identificou com o produto, não por incentivo financeiro |

**Princípio derivado:** Confundir este Perfil com Legal-Tech (Valdece) é o erro mais provável. Valdece quer ferramenta de soberania profissional. Ingrid quer companhia confiável na jornada. Mesmo produto base, posicionamento e tom radicalmente diferentes.

---

## HIPÓTESES EM TESTE — O QUE AINDA PRECISA SER VALIDADO

> Hipóteses ainda não confirmadas que se aplicam a este perfil. Atualizar conforme dado real chegar.

| ID | Hipótese | Como validar |
|---|---|---|
| H-NICHO-1 | A janela ideal de captação é 90-180 dias antes da prova — acima disso, candidato ainda procrastina; abaixo, está em pânico e não confia em algo novo | Capturar data de início vs. data da prova de cada nova cliente |
| H-NICHO-2 | Indicação espontânea acontece após 30 dias de uso, não antes | Plantar pergunta de lead apenas após 30 dias |
| H-NICHO-3 | Perfil acima de 40 anos prefere PWA com botão "adicionar à tela inicial" explicado em texto, não em imagem | Documentar idade da próxima cliente vs. taxa de instalação como app |
| H-NICHO-4 | Concursos federais (CESPE/Cebraspe) demandam estilo de leitura diferente — Perfil pode não funcionar como está | Não atender CESPE antes de adaptar Perfil |
| H-NICHO-5 | Concurseiras que estudam em grupo são leads de melhor conversão que isoladas | Capturar contexto social no Discovery |

---

## SINAIS DE ALERTA — QUANDO ESTE PERFIL NÃO É O CERTO

Não toda candidata a concurso público se encaixa neste Perfil. Sinais de incompatibilidade:

- Candidata que estuda há mais de 5 anos sem mudança de método → resistência a sistema novo (perfil de inércia).
- Candidata que pede "todos os recursos disponíveis" no Discovery → busca completude, não direção. Plataforma grande serve melhor.
- Candidata que negocia preço no primeiro contato → modo negociação, não modo esperança. Conversão difícil.
- Candidata para concurso federal de alto valor (Magistratura, MP) → ticket médio diferente, ciclo de estudo de 2-5 anos, Perfil dedicado precisa ser construído separadamente.

---

## EVIDÊNCIA DE CAMPO — CLIENTE DE REFERÊNCIA

**Cliente:** PROJ-002 Ingrid (anonimizar em qualquer uso interno; remover de qualquer uso externo)
**Concurso:** TDAS — Cargo 202 — Sedes-DF — Banca Quadrix
**Data da prova:** 2026-09-06
**Início do projeto:** 2026-05-15 (111 dias antes da prova — dentro da janela ideal H-NICHO-1)
**Modelo de entrega:** Piloto interno, R$0
**Primeira sessão real:** 2026-05-18
**Feedback verbatim na primeira sessão:** *"Gostou muito do aplicativo, só fez essa ressalva: na questão 18, não houve palavra destacada em negrito, como informava o enunciado."*

**O que essa cliente já provou (com 1 sessão de uso):**
- H-1 (esquecimento funcional, não hesitação) — CONFIRMADA.
- H-3 (vai comparar com TEC) — REFUTADA, surpresa positiva.
- H-4 (dificuldade vs abandono) — REFUTADA pela via positiva.
- Atenção literal ao enunciado — característica do perfil, recompensada por Quadrix.

**Próximas validações pendentes:**
- 7 dias de uso real consecutivo (Gate Dia 15).
- Reação ao primeiro pitch comercial.
- Pergunta de lead E-2 ainda a plantar.

---

## TEMPLATE DE ONBOARDING PARA CLIENTE NOVA DESTE PERFIL

Quando o próximo cliente EdTech-Concurso aparecer, este é o checklist para acelerar o ciclo:

1. **Discovery em 7 perguntas** (mesmo do Ingrid — funcionou). Reaproveitar `01_BRIEFING_DISCOVERY.txt`.
2. **Validar janela temporal** — se < 90 dias da prova, recusar com gentileza ou ajustar escopo.
3. **Confirmar cargo específico no Dia 0** (P-024) — não TDAS genérico, cargo 202 ou 203 ou outro.
4. **Build acelerado:** Skill base do Ingrid serve como template. Tempo previsto: 8-10 dias (vs. 15 do piloto).
5. **Clickwrap na primeira tela** (não PDF separado — P-040 candidato).
6. **Frases E-2/E-5 calibradas** ao tom da cliente (caloroso/austere/intermediário).
7. **Pitch comercial não antes de Gate Dia 8** + verbalização espontânea de progresso.

**Tempo total de onboarding esperado para 2ª cliente do nicho:** 1/3 do tempo do piloto (~5 dias vs. 15).

---

## ECONOMIA DO PERFIL — POR QUE ELE VALE

**Investimento na primeira cliente (Ingrid):** ~15 dias de build + custo de API < $5 + tempo do Conselho.
**Receita direta da primeira cliente:** R$0 (piloto).
**O que a primeira cliente ENTREGOU como ativo:** este Perfil + Skill template + banco de 460 questões Cargo 202 (reaproveitável para Cargo 203/204 com adaptação mínima).
**Receita potencial das próximas 50 clientes deste nicho:** 50 × R$97/mês × 4 meses = **R$ 19.400** por ciclo, com onboarding 3x mais rápido.
**Receita potencial das próximas 500 (modelo de escala SaaS):** R$ 194.000 por ciclo Sedes-DF.

**Conclusão econômica:** o Perfil consolidado vale mais que qualquer cliente individual deste nicho. Proteger o Perfil é proteger todo o nicho.

---

## PROTOCOLO DE ATUALIZAÇÃO DESTE PERFIL

- **Embaixador atualiza** após cada nova cliente do nicho concluir Gate Dia 8.
- **Auditor valida** se padrões observados em N clientes diferentes sustentam os vetores aqui.
- **Diretor aprova** revisões maiores (mudança de teto de preço, alteração da janela ideal de captação).
- **Versionar:** cada revisão maior gera v2, v3, etc. Histórico nunca apagado.

---

> *Princípio P-039 aplicado: este documento é inferência sustentada por fatos da CAMADA_FATOS do PROJ-002 Ingrid.*
> *Princípio derivado: Perfil de Nicho é trade secret — moat competitivo da Vanguard, não produto.*
