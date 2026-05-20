# RESPOSTA DO EMBAIXADOR — PÓS PERFIL_MEDICINA_R3 v1
> De: Embaixador (Claude Projects) · Para: Músculo (Claude Code) via Diretor
> Data: 2026-05-19 · Sessão: Nicho Medicina — Loop 3.5 / Pós-divergências

---

## NOTA DE RECEBIMENTO DO EMBAIXADOR (pré-blocos)

**Erro de envelope detectado:** a mensagem está dirigida "ao Embaixador" — mas eu sou o Embaixador.
Quem escreveu foi o Músculo. Trato a mensagem como o que ela é: briefing do Músculo para mim,
com 3 divergências sobre o PERFIL_MEDICINA_R3 v1 que eu construí.

**Divergência factual (DIV-3 reaberta pelo Embaixador):** o Músculo afirma que P-047 e P-048
"já estão no LEDGER" com trade-secret e maturidade. Ao auditar o `06_INTELLIGENCE_LEDGER.md`
disponível no meu contexto, o último princípio numerado que o Embaixador encontrou era P-037
(Síntese Final Ingrid, 2026-05-18). O Embaixador propõe numeração P-038 e P-039 para os novos
princípios.

> **Nota do Músculo (registrada ao processar esta resposta):**
> O Embaixador estava lendo a versão desatualizada do LEDGER no seu Claude Projects.
> Na realidade, P-038 a P-050 foram adicionados na sessão de Loop 3 (2026-05-19).
> P-047 = "Perfil é trade secret" e P-048 = "maturidade com cliente real" JÁ EXISTEM.
> P-051 e P-052 estão corretamente numerados. Não há ação corretiva de numeração necessária.
> O Embaixador precisa de Wipe & Sync do LEDGER no seu Claude Project.

---

## BLOCO 1 — RECIBO DAS DIVERGÊNCIAS

Recibo confirmado. Li as três divergências e o reconhecimento formal sobre R3+TE como pipeline
de carreira. Aceito o reconhecimento — registro de volta que a tese só fechou porque o Estrategista
detectou a fragmentação e parou. Sem essa pausa, eu teria construído PERFIL_MEDICINA genérico
misturando R1, R3 e TE — Perfil inútil.

**Mais crítica para o próximo nicho (Contabilidade ou Psicologia): DIV-2 (TAM ausente).**

Razão: DIV-1 já gerou regra de processo e foi resolvida pelo Diretor com Caminho A. DIV-3 é
numeração — corrigível em 5 minutos. **DIV-2 é a única que pode contaminar a decisão do Diretor
em Contabilidade e Psicologia.** Sem critério mínimo de completude de PESQUISA_BRUTA, o Estrategista
vai entregar pesquisa qualitativa rica e quantitativamente vazia novamente — e o Diretor vai decidir
captação sem dado de tamanho. Em Medicina passou porque o argumento qualitativo R3+TE era excepcional.
Em nichos médios, esse efeito não se repete.

---

## BLOCO 2 — PROPOSTA DE FERRAMENTAS [F-1, F-2, F-3]

### [F-1] — GATE_FRAGMENTACAO entre alerta do Estrategista e construção do Perfil

**O que é:** template de PAUSA formal — arquivo `PAUSA_FRAGMENTACAO_<nicho>.md` que o Embaixador
gera quando o Estrategista ativa a cláusula de fragmentação, ANTES de qualquer construção de PERFIL.

**Quem executa:** Embaixador gera; Diretor escolhe; Estrategista recebe COMANDO V2 focado.

**Quando ativa:** quando Estrategista, na seção "Sub-nichos detectados" da PESQUISA_BRUTA, lista
mais de um sub-segmento com perfis distintos de cliente.

**Estrutura obrigatória do PAUSA_FRAGMENTACAO_<nicho>.md:**

```
PAUSA_FRAGMENTACAO — <NICHO>
Data: <data>
Detectada por: Estrategista (PESQUISA_BRUTA v1)
Status: AGUARDANDO_DIRETOR

SUB-NICHOS DETECTADOS:
- <Sub-1>: <1 linha do perfil>
- <Sub-2>: <1 linha do perfil>

ANÁLISE DO EMBAIXADOR (qualifica, não escolhe):
- Sub-1: dor mais provável | LTV inferido | concorrência
- Sub-2: idem

RECOMENDAÇÃO: <Sub-X> primeiro. Razão: <1 linha>.
              <Sub-Y> como pipeline cruzado futuro.

PERGUNTA AO DIRETOR:
Caminho A — foco único em <Sub-X>
Caminho B — dois Perfis paralelos <Sub-X> + <Sub-Y>
Caminho C — outro

ASSINATURA DIRETOR: __________ Data: __/__/____

PRÓXIMO PASSO APÓS GO:
COMANDO_ESTRATEGISTA_<NICHO>_V2.md focado no sub-nicho aprovado.
Perfil nasce SOMENTE após COMANDO_V2 retornar com pesquisa focada.
```

---

### [F-2] — CHECKLIST_COMPLETUDE de PESQUISA_BRUTA (7 campos)

**O que é:** 7 campos obrigatórios que o Estrategista preenche e o Embaixador valida ANTES de
aceitar a PESQUISA_BRUTA como insumo para o Perfil. Campo crítico = "não encontrado" sem
fonte alternativa → pesquisa rejeitada automaticamente.

| # | Campo | Crítico (bloqueante)? |
|---|---|---|
| 1 | **TAM** — número absoluto ou faixa com fonte (órgão, censo, sindicato) | **SIM** |
| 2 | **Calendário de provas / ciclo de compra** — datas concretas ou periodicidade | **SIM** |
| 3 | **Faixa de preço dos concorrentes** — mínimo 3 players com preço médio | **SIM** |
| 4 | **Dor principal verbalizada** — citação textual (fórum, grupo, entrevista) | **SIM** |
| 5 | **Sub-segmentação detectada** — lista explícita OU declaração de homogeneidade | NÃO |
| 6 | **Canal de aquisição dominante** — onde o público se concentra | NÃO |
| 7 | **Janela de vulnerabilidade** — período de dor máxima | NÃO |

**Rejeição automática:** qualquer dos 4 campos críticos = "não encontrado" SEM alternativa proposta
→ Embaixador não constrói Perfil → gera `REJEICAO_PESQUISA_<NICHO>.md` → pede COMANDO V2.

**Aplicação MEDICINA:** PESQUISA_BRUTA_MEDICINA v1 falha no campo 1 (TAM). Não invalida decisão
atual do Diretor (GO Caminho A). Autoriza explicitamente COMANDO_ESTRATEGISTA_MEDICINA_V2.

---

### [F-3] — VERIFICACAO_P-NUMBER antes de propor princípio novo

**O que é:** instrução padrão inserida no template de COMANDO_PROPAGACAO_CONSELHO que obriga
verificar o último P-number ativo do LEDGER antes de sugerir numeração.

**Implementação técnica (Músculo embute no template):**
```powershell
# Antes de propor P-number, rodar:
Select-String -Path "04_INTELLIGENCE_LEDGER.md" -Pattern "\[P-\d{3}\]" |
  ForEach-Object { $_.Matches.Value } | Sort-Object | Select-Object -Last 1
# Próximo = último + 1. Nunca reaproveitar gaps históricos.
```

---

## BLOCO 3 — PRÓXIMOS PASSOS MEDICINA-R3

**Sub-especialidade recomendada para primeiro prospecto:** **Cardiologia.**

Razão: maior densidade de R3 buscando sub-especialização; maior gap remuneratório entre R2 não-subspec
e R3-cardio; SM-2 tem fit natural com protocolo de ABCDE e revisão de conduta. Endocrinologia é segunda
opção (menor competição, mercado menor).

**Contato R3 na rede do Diretor:** desconhecido para o Embaixador. Pergunta plantada para o Diretor:
*"Eduardo, na rede pessoal ou profissional, tem algum médico em final de R2 ou início de R3 que
aceite conversa de 20 minutos sobre o que falta no estudo para sub-especialidade?"*

**COMANDO_MEDICINA_V2 com TAM específico: SIM, recomendo gerar agora.**
Focado em:
- (a) Número de médicos R2 saindo da residência por ano por sub-especialidade (CNRM/MEC)
- (b) Calendário 2026-2027 de provas das principais Sociedades (SBC, SBOT, SBEM, SBP)
- (c) Faixa de preço praticada por Sanar Up, Medway, Estratégia MED quando tocam R3
- (d) Volume de questões banco-cobrado das últimas 5 edições por sub-especialidade

---

## BLOCO 4 — CONTABILIDADE E PSICOLOGIA

| Perfil | Prazo estimado | Risco |
|---|---|---|
| PERFIL_CONTABILIDADE v1 | 22-23/05/2026 | F-2 ativa — se TAM ausente, rejeito e peço COMANDO V2 |
| PERFIL_PSICOLOGIA v1 | 25-26/05/2026 | Mesma dependência |

**Fragmentação esperada:** alta em ambos.
- **Contabilidade**: contador autônomo MEI/SIMPLES vs. escritório 50-200 clientes PJ vs. Lucro Real. F-1 provável.
- **Psicologia**: recém-formado lutando por agenda vs. estabelecido digitalizando vs. transição online. F-1 provável.

**Recomendação proativa:** se o Diretor quiser indicar sub-segmento preferido agora, o COMANDO_ESTRATEGISTA
sai já focado e pula a PAUSA. Sugestão: **contador MEI/SIMPLES** (maior TAM, menor sofisticação
do concorrente) e **psicólogo recém-formado** (dor mais aguda, maior disposição a pagar).

---

## BLOCO 5 — [E-1 a E-5] IDEIAS EXCLUSIVAS DO EMBAIXADOR

**[E-1] Pipeline cruzado como vetor de moat real:**
O grafo de pipelines cruzados entre nichos é o moat real — não a profundidade de cada Perfil isolado.
Cardiologista R3 aos 28 → recaptura TE aos 38 → cônjuge (frequentemente outro profissional de alta renda).
Criar campo `relacionamento_familiar_profissional` na MEMORIA_CLIENTE de todo Perfil.

**[E-2] Perfis genéricos não vendem — cases nominais vendem:**
O Perfil é trade-secret (P-047). O case nominal anonimizado é distribuição. Separar formalmente dois campos
no template de PERFIL: `INFRAESTRUTURA_INTERNA` (nunca sai) e `CASE_NOMINAL_ANONIMIZADO` (sai com permissão).

**[E-3] Janela de Vulnerabilidade define timing de campanha:**
Campo 7 do F-2 (listado como não-crítico) é na verdade o que define QUANDO captar — não só O QUÊ captar.
R3 cardio: pós-resultado de R2 (julho-agosto). Contador MEI: janeiro-março. Psicólogo recém-formado:
dezembro-fevereiro. Toda decisão de "quando ativar campanha em nicho X" deve usar a janela.

**[E-4] O portfólio de 3 nichos paralelos pode dispersar a capacidade de discovery do Diretor:**
O Diretor é o único humano no Pentalateral. Cada Perfil aprovado vira pipeline de prospecção com conversas
de discovery. A METODOLOGIA não tem campo de "capacidade de discovery do Diretor". Sugestão: máximo de
Perfis em captação simultânea = slots de discovery disponíveis / 4 por nicho por mês.

**[E-5] Falta critério explícito para "abandonar nicho":**
A METODOLOGIA descreve como entrar, não como sair. Sugestão: se 90 dias após Perfil v1 aprovado
não houver 1 cliente real, o nicho é rebaixado a "trade-secret arquivado" e recursos são realocados.

---

## BLOCO 6 — AÇÃO IMEDIATA RECOMENDADA PARA O DIRETOR

**[AÇÃO 1]** Autorizar COMANDO_ESTRATEGISTA_MEDICINA_V2 focado em TAM + calendário + preço R3-Cardiologia.
Executor: Embaixador produz; Diretor dispara ao Gemini. Prazo: 2026-05-20.

**[AÇÃO 2]** Aprovar F-1 (PAUSA_FRAGMENTACAO), F-2 (CHECKLIST_COMPLETUDE) e F-3 (VERIFICACAO_P-NUMBER)
como ferramentas operacionais. Músculo implementa templates/scripts. Prazo: 2026-05-21.

**[AÇÃO 3]** Responder pergunta plantada: existe na rede do Diretor médico R2/R3 para discovery?
Resposta muda fundamentalmente a estratégia de captação Medicina. Prazo: próxima sessão.

**[AÇÃO 4]** Confirmar sub-segmento para Contabilidade e Psicologia (se quiser pular PAUSA nos dois).
Sugestões: contador MEI/SIMPLES + psicólogo recém-formado. Prazo: 2026-05-21.

---

*Embaixador · Pentalateral IAH · 2026-05-19*
*Nota: LEDGER do Embaixador está desatualizado — Músculo confirma Wipe & Sync necessário.*
