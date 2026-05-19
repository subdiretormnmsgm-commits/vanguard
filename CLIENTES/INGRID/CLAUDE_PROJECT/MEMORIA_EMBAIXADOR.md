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
| Termo de Uso | **PENDENTE** — gerado em 2026-05-16, não assinado |
| Risco ativo | P-023 — nenhum acesso ao PWA antes da assinatura |
| Compartilhamento | Sem cobertura jurídica enquanto Termo não for assinado |
| Clickwrap no PWA | ENTRA no build Dia 6 — resolve P-023 em código |
| Vigência contratual | Até 2026-09-06 (ciclo do concurso) |

**Ação bloqueada:** Eduardo não entrega o link de acesso antes da assinatura.
**Resolução técnica:** Clickwrap na primeira tela do PWA grava `user_id + timestamp + hash_sha256` na tabela `termos_aceitos`.

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

**M1 — HOJE (antes das 18h):** Enviar mensagem B1 — Ingrid assina o Termo.
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
Status atual: AMARELA
Baseado em: hipótese H-1 confirmada pelo Embaixador (dados reais a partir do Gate Dia 8)
Válido até: próximo contato ou Gate Dia 8
Override ativo: NÃO — aguarda 7 dias de uso real após entrega
Última atualização: 2026-05-18 (Músculo — Síntese Final P-037)
```

**AMARELA porque:** Termo pendente + 2 dias sem contato + gate bloqueado por P-023.
**Não é VERMELHA porque:** nenhum sinal de resistência — H-1 confirmada: silêncio tem explicação plausível (foco de estudo).
**Vira VERDE quando:** Termo assinado + primeiros 7 dias de uso com dados reais (E-4).
**Escalona para AMARELA-ESCURA em:** 2026-05-23 — se nenhuma resposta ao Termo.

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

---

> **Protocolo de uso:** Cole este arquivo no início de cada sessão do Project.
> O Embaixador processa e opera com contexto real — não com suposições.
> Tempo de leitura: 30 segundos. Tempo de atualização: 2 minutos.
