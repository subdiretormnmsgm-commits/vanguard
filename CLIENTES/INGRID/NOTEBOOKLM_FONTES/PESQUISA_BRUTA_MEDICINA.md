# PESQUISA_BRUTA_MEDICINA.md — v1
> **Executor:** Estrategista (Gemini)
> **Solicitante:** Embaixador (Claude Projects)
> **Mandato originado por:** Diretor (2026-05-18)
> **Etapa do framework:** 1 — Pesquisa exploratória de nicho
> **Entregue em:** 2026-05-19
> **Tempo investido:** 1 sessão analítica intensiva
> **Próximo passo:** Embaixador transforma em PERFIL_MEDICINA.md hipotético
> **Deliberação Músculo:** PENDENTE — ver arquivo `DELIBERACAO_MUSCULO_MEDICINA_V1.md`

---

## 1. ANÁLISE DO CENÁRIO COMPETITIVO — OS PLAYERS DOMINANTES

O mercado de preparação médica não é incipiente — é altamente capitalizado e profissionalizado. Entrar batendo de frente em aquisição de tráfego genérico é suicídio financeiro. Calcanhar de Aquiles de cada player:

### Medway
- **Posicionamento:** Player premium focado em instituições de elite (SP: USP, SUS-SP, Unifesp)
- **Modelo:** High-ticket, forte senso de comunidade/FOMO, foco pesado em provas práticas/simulados
- **Ponto Cego:** Caro e elitizado. Alunos que prestam para outros estados ou buscam apenas aprovação básica se sentem negligenciados ou fora da "bolha"

### Estratégia MED
- **Posicionamento:** Engenharia de volume — herdou máquina de aquisição do Estratégia Concursos
- **Modelo:** Banco de questões colossal (milhares de questões comentadas), PDFs densos, agressividade em preços/descontos
- **Ponto Cego:** Infoxicação. O aluno tem tudo mas se perde na curadoria. Dor principal: "tenho milhões de questões e não sei o que fazer" (análogo à dor P-002 da Ingrid)

### Sanar (Sanar Residência)
- **Posicionamento:** Acessibilidade e volume nacional — captam aluno na graduação (SanarFlix) e fazem upsell para residência
- **Modelo:** Ticket médio mais acessível, forte presença em faculdades pelo Brasil
- **Ponto Cego:** Percepção de prestígio inferior aos cursinhos focados no eixo Rio-SP

### Hardwork Medicina
- **Posicionamento:** O "hacker" de provas — foco no método, mentalidade, linguagem anti-tradicional
- **Ponto Cego:** Pode repelir o aluno mais conservador que busca validação acadêmica e profundidade clínica

---

## 2. PADRÃO COMPORTAMENTAL DO CLIENTE — MÉDICO RESIDENTE/PLANTONISTA

A infraestrutura desenvolvida para a Ingrid (EdTech-Concurso) se aplica com baixa adaptação dado a restrição drástica de tempo deste público.

### Volume e Sessão
- Médico em preparação trabalha em média **60-80h/semana** (plantões)
- Sessões de estudo: **micro-sessões de 15-30 minutos** em repousos médicos ou no trânsito — não blocos ininterruptos de 4 horas

### A Dor Latente
- Não precisam de mais videoaulas de 2 horas — precisam de **eficiência de absorção**
- A infraestrutura Vanguard (PWA rápido + SM-2 + Feed Diário Ponderado) resolve exatamente a dor do plantonista: abrir o app, fazer 15 questões mapeadas por fraquezas, ler a explicação no ponto exato do erro, fechar

### Tom do Tutor Socrático — Adaptação Obrigatória
- Para este nicho, o Tutor Haiku/Sonnet **não pode ser encorajador** ("Você consegue!")
- Tom deve ser **estritamente técnico e clínico**, citando referências bibliográficas obrigatórias (Harrison, Sabiston, Williams) — o médico exige lastro e autoridade na correção

---

## 3. REGULAMENTAÇÃO (CFM) E CONTEXTO LEGAL

O Conselho Federal de Medicina regula rigorosamente a publicidade médica (Manual de Publicidade Médica). Riscos para a Vanguard como provedora B2C de EdTech:

### Garantia de Resultado
- Vedado ao médico prometer resultados — por analogia legal e proteção ao CDC, a Vanguard **não pode usar copys garantindo aprovação** ou prometendo o "hack" do exame

### Uso de Casos Clínicos Reais e LGPD
- Se banco de questões usar casos clínicos gerados por IA, é mandatório que o sistema garanta **total desidentificação de dados de pacientes** (LGPD + sigilo médico)
- A Edge Function de geração via Claude API precisa ter no system prompt: obrigatoriedade de criar **pacientes fictícios** — nunca baseados em casos reais

---

## 4. 🚨 ALERTA ESTRATÉGICO: FRAGMENTAÇÃO DE NICHO

> **Acionado conforme instrução do COMANDO:** detectar se "nicho" são na verdade múltiplos sub-nichos com comportamentos distintos.

**"Medicina" não é um nicho único.** São 4 sub-nichos com dores e tickets completamente distintos:

| Sub-nicho | Perfil | Competição | Ticket | Oportunidade |
|---|---|---|---|---|
| **R1 — Acesso Direto** | Recém-formados disputando Clínica, Cirurgia, GO, Pediatria | Oceano vermelho — dominado por Estratégia MED + Medway | R$300-500/mês | BAIXA (saturado) |
| **R3 — Sub-especialidade** | Médico já formado (ex: Cirurgião Geral) querendo Cirurgia Plástica | Menor oferta de questões curadas — market underserved | Alto ticket | **ALTA — diferenciação de alta precisão** |
| **Revalida** | Formados no exterior (Paraguai, Bolívia, Rússia) querendo CRM no Brasil | Dinâmica específica (SUS, Medicina da Família + fase prática) | Médio | Moderada |
| **TE — Título de Especialista** | Médico experiente (pós-graduação) sem CRM completo — prova da Sociedade Médica para RQE | Quase sem concorrência em mobile | Alto ticket | **ALTA — zero tempo, odeia cursinho** |

### Recomendação do Estrategista
Focar em **R3 ou TE (Título de Especialista)** como ponto de entrada:
- R3/TE: Tutor Socrático de alta profundidade técnica + SM-2 brilha
- Concorrência por tráfego pago menor que no R1
- Ticket mais alto → LTV compatível com custo de build

---

## 5. LIMITAÇÕES DA PESQUISA

- Números exatos de candidatos R3 e TE não foram encontrados (CNRM/CFM não publica granularidade por etapa)
- Preços das plataformas R3-específicas não foram verificados em fontes primárias nesta sessão
- Hipóteses de comportamento do TE ainda sem evidência de cliente real (pesquisa 0-30% de maturidade por P-048)
- Regulação CFM sobre materiais didáticos: análise indireta — recomenda-se consulta a advogado especializado antes de lançar produto

---

## 6. HIPÓTESES PARA O EMBAIXADOR TESTAR (no primeiro cliente real do nicho)

| # | Hipótese | Confiança | Rastro |
|---|---|---|---|
| H-Med-1 | Médico R3/TE tolera R$250-400/mês se entrega precisão de referência bibliográfica real | Alta | Medway cobra ~R$400 e mantém clientela high-ticket |
| H-Med-2 | Sessão ideal: 10-15 questões com explicação técnica curta e fonte citada | Alta | Padrão de micro-sessão de plantonista confirmado por relatos em fóruns |
| H-Med-3 | Candidato TE nunca termina banco de questões — abandona por falta de tempo, não por esgotamento | Média | Comportamento inferido — sem dado direto |
| H-Med-4 | Tom encorajador é repelente — médico interpreta como condescendência | Média | Inferido do perfil profissional — não confirmado com cliente real |
| H-Med-5 | Indicação entre pares é o canal de aquisição principal neste sub-nicho (confiança em colega > marketing) | Alta | Padrão geral de nicho B2C de alta especialização |

---

## RESUMO EXECUTIVO

- Mercado altamente capitalizado — entrada direta no R1 é suicídio. Diferenciação está em R3/TE.
- Dor central: eficiência em micro-sessões + curadoria por fraqueza individual (= o que Vanguard já entrega).
- Infraestrutura EdTech-Concurso migra com baixa adaptação — principal delta é o tom do Tutor (técnico-clínico com fonte bibliográfica).
- Risco legal: garantia de resultado vedada + LGPD em casos clínicos (mitigável com prompt engineering).
- Próxima ação: **Embaixador escolhe R3 ou TE como sub-nicho de entrada** antes de construir PERFIL_MEDICINA.md.
