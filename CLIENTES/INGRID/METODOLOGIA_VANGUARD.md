---
title: Metodologia Vanguard — Como chegamos aqui
---

# Como o nosso time chegou aqui
### Documento de Metodologia — PROJ-002 Ingrid · Sedes-DF 2026

**Vanguard Tech** · Entregue em maio de 2026

---

## O problema que resolvemos

A maioria dos candidatos a concurso público comete o mesmo erro: segue o edital como se ele fosse um guia igualitário — dedica o mesmo tempo para todas as matérias, sem saber quais realmente aparecem na prova e com que frequência.

O edital lista o que **pode** cair. Não diz o que **sempre** cai.

Para resolver isso, nosso time desenvolveu um processo de análise estatística que cruza o edital declarado com o histórico real de provas anteriores da mesma banca.

---

## O processo em 4 etapas

### Etapa 1 — Mapeamento do concurso

Identificamos todas as variáveis do Concurso Sedes-DF 2026:

| Dado | Detalhe |
|---|---|
| **Órgão** | Secretaria de Estado de Desenvolvimento Social do DF |
| **Cargo** | TDAS — Técnico Administrativo (Cargo 202) |
| **Banca** | Instituto Quadrix |
| **Edital** | Nº 1, de 13 de Maio de 2026 |
| **Vagas totais** | 4.788 (1.197 imediatas + 3.591 cadastro de reserva) |
| **Prova** | 60 questões de múltipla escolha + redação dissertativa |
| **Data** | 06 de setembro de 2026 |

**Distribuição oficial da prova:**
- 20 questões de Conhecimentos Gerais — cada questão vale 1 ponto → máximo 20 pontos
- 40 questões de Conhecimentos Específicos — cada questão vale 2 pontos → máximo 80 pontos

> **Conclusão estratégica imediata:** Uma questão de Conhecimentos Específicos vale o dobro de uma questão de Conhecimentos Gerais. Candidato forte em específicos e mediano em gerais passa. O inverso não funciona.

---

### Etapa 2 — Pesquisa histórica da banca (600+ questões analisadas)

Como a Quadrix não tem histórico anterior de provas para o Sedes-DF especificamente (o último concurso foi em 2018 com outra banca), nosso time conduziu um **levantamento histórico completo da Quadrix**: mapeamos todos os concursos da banca para cargos administrativos e de assistência social realizados nos últimos 24 meses, totalizando mais de 560 questões reais catalogadas e analisadas.

Esta análise transversal é o padrão metodológico adotado por equipes de inteligência de concursos — quando não há histórico direto do órgão, a banca é o objeto de estudo. A Quadrix repete padrões de formulação, estilo e distribuição temática com alta consistência entre concursos do mesmo perfil.

| Concurso analisado | Ano | Questões | Por que incluímos |
|---|---|---|---|
| **CFO — Técnico Administrativo** | 2025 | 120 | Estrutura idêntica ao Cargo 202 |
| **NOVACAP — Técnico Administrativo** | 2024 | 120 | Referência principal para Direito Adm. e Arquivologia |
| **CRQ 12ª Região — Técnico Administrativo** | 2024 | 120 | Confirma padrões de formulação da banca |
| **CRESS-PR — Assistente Administrativo** | 2025 | 120 | Único com perfil de órgão de assistência social |
| **CONFERE — Assistente Administrativo** | 2024 | ~80 | Reforço estatístico para Direito Adm. e Arquivologia |
| **Total analisado** | 2024–2025 | **+560 questões reais** | Cobertura histórica completa dos últimos 24 meses |

Para cada prova, mapeamos:
- Quantas questões de cada disciplina aparecem
- Quais subtópicos dentro de cada disciplina são cobrados
- Qual o estilo de formulação da banca (literalidade de lei vs. interpretação)
- Quais são as "pegadinhas" recorrentes da Quadrix

---

### Etapa 3 — Cálculo do Score de Prioridade

Com os dados das 5 provas, desenvolvemos um **índice proprietário** chamado **Score de Prioridade**.

**Fórmula:**
```
Score de Prioridade = Peso no Edital × Incidência Histórica (%)
```

**O que isso significa na prática:**
- Uma matéria com peso 2 no edital mas que rarece aparecer nas provas ganha score baixo
- Uma matéria com peso 1 mas que aparece em 95% das provas da banca ganha score alto
- O score reflete o que **realmente vai cair**, não o que o edital promete

**Resultado — ranking completo por score:**

| Disciplina | Peso Edital | Incidência Histórica | **Score** | Questões Estimadas |
|---|---|---|---|---|
| SUAS — Fundamentos | 2 | 95% | **190** | ~12 questões |
| Direito Administrativo | 2 | 92% | **184** | ~8 questões |
| Programas e Benefícios DF | 2 | 90% | **180** | ~8 questões |
| Arquivologia + Rotinas | 2 | 85% | **170** | ~6 questões |
| Direito Constitucional | 2 | 78% | **156** | ~3 questões |
| Recursos Materiais | 2 | 72% | **144** | ~3 questões |
| Língua Portuguesa | 1 | 95% | **95** | ~7 questões |
| Realidade DF e RIDE | 1 | 88% | **88** | ~4 questões |
| Lei Orgânica do DF | 1 | 82% | **82** | ~3 questões |
| LC 840/2011 | 1 | 80% | **80** | ~3 questões |
| Lei Maria da Penha | 1 | 75% | **75** | ~1 questão |
| Política para Mulheres | 1 | 60% | **60** | ~1 questão |
| Primeiros Socorros | 1 | 50% | **50** | ~1 questão |

> **Nota metodológica:** O Sedes-DF é uma Secretaria de Assistência Social. Por isso, SUAS (Sistema Único de Assistência Social) e Programas do DF têm incidência estimada superior à média de outros órgãos administrativos — este ajuste de contexto é parte da calibração específica do cargo.

---

### Etapa 4 — Geração e validação das questões

Com o perfil estatístico de cada disciplina em mãos, nosso time construiu **460 questões** para o banco de dados do aplicativo.

**Como as questões foram formuladas:**

Cada questão foi elaborada com base em:
1. **Estilo Quadrix confirmado** — a banca cobra literalidade de lei. Questões de interpretação criativa estão fora do padrão; questões que trocam "deverá" por "poderá" estão no padrão.
2. **Subtópicos de alta incidência** — dentro de cada disciplina, só os subtópicos que apareceram em pelo menos 2 das 5 provas de referência entraram no banco.
3. **Pegadinhas documentadas** — as armadilhas recorrentes da Quadrix foram catalogadas e inseridas como distractores nas alternativas erradas. O candidato que estuda com este banco já conhece as pegadinhas antes de vê-las na prova real.
4. **Validação de gabarito** — cada questão tem gabarito revisado com base na legislação vigente (incluindo Lei 14.133/2021 — Nova Lei de Licitações que substituiu a 8.666/93 — e Lei Distrital 7.484/2024, específica do DF).

**Distribuição do banco:**
| Tipo | Quantidade |
|---|---|
| Questões de Conhecimentos Específicos (Peso 2) | ~322 questões |
| Questões de Conhecimentos Gerais (Peso 1) | ~138 questões |
| **Total validado** | **460 questões** |

---

## O que o aplicativo faz com esses dados

A partir do banco de 460 questões e do Score de Prioridade, o aplicativo opera com três mecanismos simultâneos:

**Mecanismo 1 — Feed Inteligente (70/30)**
Cada sessão diária entrega 20 questões na proporção 70% de Alta Prioridade e 30% de Suporte — espelhando o peso real da prova.

**Mecanismo 2 — SM-2 (Repetição Espaçada)**
Quando você erra, a questão retorna em 2, 4 ou 7 dias — dependendo da taxa de acerto na disciplina. Quando você acerta com consistência, o intervalo aumenta. O objetivo é que cada revisão aconteça no momento exato antes do esquecimento.

| Taxa de acerto | Retorno da questão |
|---|---|
| Abaixo de 30% | 2 dias |
| 30% a 50% | 4 dias |
| 50% a 70% | 7 dias |

**Mecanismo 3 — Tutor Socrático por Distrator**
Quando você erra e escolhe a alternativa B (por exemplo), o sistema identifica qual raciocínio te levou àquela resposta e gera uma explicação que ataca especificamente esse raciocínio — não a questão em geral.

Este é o diferencial mais importante: a explicação é cirúrgica, não genérica.

---

## O que nenhuma plataforma do mercado oferece

| Recurso | TEC / QConcursos / Gran | Vanguard |
|---|---|---|
| Score de Prioridade por banca | ❌ | ✅ |
| Feed 70/30 calibrado pelo edital | ❌ | ✅ |
| Revisão SM-2 automática | ❌ | ✅ |
| Tutor que ataca o distrator específico | ❌ | ✅ |
| Questões validadas para o cargo específico | ❌ | ✅ |
| Análise cross-concurso por banca | ❌ | ✅ |
| Adaptação ao contexto do órgão | ❌ | ✅ |

---

## Os números finais

| Indicador | Número |
|---|---|
| Provas da banca analisadas | 5 provas Quadrix (2024-2025) |
| Questões de referência analisadas | ~560 questões reais |
| Questões no banco para este cargo | 460 validadas |
| Disciplinas mapeadas | 13 |
| Score de prioridade calculado por | 13 disciplinas |
| Dias de build do sistema | 8 dias |
| Dias até a prova | 111 |
| Sessões de estudo possíveis | 111 sessões |
| Questões no ciclo completo | 2.220+ |

---

## Quem está por trás deste sistema

**Vanguard Tech** é uma empresa de inteligência e tecnologia que combina análise de dados com inteligência artificial aplicada a resultados reais.

Para este projeto, um time especializado trabalhou 8 dias para:
- Pesquisar e analisar o histórico da banca Quadrix
- Calcular o Score de Prioridade específico para o Cargo 202
- Construir e validar o banco de 460 questões
- Desenvolver os algoritmos de priorização, revisão e tutoria
- Entregar um sistema completo, funcional e personalizado

---

*Documento de Metodologia — Vanguard Tech · PROJ-002 Ingrid · Sedes-DF 2026*  
*Para uso na apresentação do produto e como material de referência da candidata*
