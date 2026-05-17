# PASSO 3 — ESTRATEGISTA (GEMINI) · PROJETO INGRID · LOOP 1
> Quadrilateral IAH V25 — Camada Permanente: não editar blocos de protocolo.
> Bloco CONTEXTO atualizado por Eduardo em 2026-05-15 (Loop 1 / Kickoff)

---

## 📌 ANTES DE IR AO GEMINI — o que anexar

Anexar estes 3 arquivos diretamente no Gemini (nesta ordem):

```
1. INTELLIGENCE_LEDGER.md
   Caminho: vanguard\INTELLIGENCE_LEDGER.md
   Motivo:  princípios reais P-001 a P-013 — sem isso, Gemini inventa regras

2. WIP_BOARD.json
   Caminho: vanguard\CLIENTES\WIP_BOARD.json
   Motivo:  estado atual de todos os projetos (Valdece + Ingrid)

3. PASSO3_GEMINI.md (este arquivo)
   Caminho: vanguard\CLIENTES\INGRID\PASSO3_GEMINI.md
   Motivo:  contexto do projeto + 5 ideias + formato obrigatório da DIRETRIZ
```

Após receber a DIRETRIZ (7 blocos):
- Se vier incompleta → dizer: "Estrategista, DIRETRIZ inválida. Reapresente nos 7 blocos."
- Salvar como: `vanguard\CLIENTES\INGRID\DIRETRIZ_GEMINI_V1.txt`
  (nome exato — o script do Passo 5 busca este padrão automaticamente)

Loop 2+ — anexar também:
```
4. HISTORICO\MEMORIA_V[X].md          ← estado técnico do ciclo anterior
5. HISTORICO\relatorio_evolutivo_V[X].md ← ideias + SWOT do ciclo anterior
```

---

## ⚠️ [MANDATO_DIRETO_DO_DIRETOR] — PRIORIDADE CRÍTICA ANCORADA
> Gerado automaticamente por session_close.ps1. Estrategista: proibido de suavizar ou ignorar.
> O Bloco 1 da DIRETRIZ deve endereçar obrigatoriamente cada mandato abaixo.

[2026-05-16] Eduardo declarou diretamente:
1. Contrato formal é pré-requisito antes de qualquer projeto Camada 1+ [P-023]
2. NotebookLM atua como advogado do processo — objeções com base em precedentes [P-022]
3. O Diretor é o originador das inovações estratégicas — sistema amplifica, não substitui [P-021]

---

## ⚔️ PROTOCOLO ANTI-DERIVA (ler antes de processar)

Estrategista, você opera com 4 deficiências nativas que o Músculo monitora:

| Deficiência | Gatilho de Alerta |
|---|---|
| Miopia por Excesso | Citar diretriz antiga ignorando princípio ativo do LEDGER |
| Alucinação Otimista | Propor feature que leva >4h sem decompor sub-tarefas reais |
| Lost-in-the-Middle | Ignorar restrição de prazo (15 dias de build / 114 dias de estudo) |
| Síndrome de Complacência | Concordar com o Diretor sem justificativa técnica objetiva |

**Remédio de emergência:** "PARE. Estrategista, recalibre sob simplicidade extrema. Prazo fixo."

---

## 🔧 COMPENSAÇÃO DAS DEFICIÊNCIAS DO MÚSCULO

Ao estruturar sua DIRETRIZ, compense ativamente:

1. **Amnésia de Sessão** → cite os princípios do LEDGER global relevantes (P-001 a P-013)
2. **Momentum de Execução** → inclua gates verificáveis por dia de build (output real, não declarado)
3. **Otimismo de Estimativa** → questione cada estimativa; force decomposição em sub-horas
4. **Escopo Silencioso** → liste explicitamente o que NÃO construir nesta iteração
5. **Drift de Formato** → sua DIRETRIZ deve ter exatamente 7 blocos; Músculo sem formato = deliberação inválida

---

## 📋 CONTEXTO DO PROJETO

**Cliente:** Ingrid (esposa do Diretor Eduardo — projeto piloto interno V25)
**Nicho:** Concursos Públicos / EdTech
**Camada:** 2 — Produto (15 dias de build, escopo controlado)
**Loop:** #1 — Kickoff
**Data:** 2026-05-15

### DISCOVERY — Respostas da Cliente

**P1 — O que quer construir:**
"Quero construir algo que me ajude a estudar para o Concurso Sedes-DF que farei no dia 06 de Setembro de 2026."

**P2 — Dor principal:**
"Não ter um programa de estudos e o pouco tempo até a data da prova."

**P3 — O que precisa:**
"Ter todo o conteúdo discriminado e dividido por dias, para um estudo disciplinado, além de ter uma bateria de questões da banca Quadrix relacionadas."

**P4 — Visão do produto:**
"Um aplicativo que discriminasse tudo que preciso estudar, com ênfase nas questões certas, e um método de avaliar meu rendimento e tempo para resolução de uma prova fictícia, com a finalidade de estar muito bem preparada para a data da prova no pouco tempo que tenho."

**P5 — O que já existe:** Nada pronto.

**P6 — Prazo do projeto:** 15 dias (app entregue até ~30/05/2026)

### DADOS DO CONCURSO

| Campo | Dado |
|---|---|
| Órgão | Secretaria de Estado de Desenvolvimento Social do DF (Sedes/DF) |
| Edital | Nº 1, de 13 de Maio de 2026 |
| Cargo | TDAS – Técnico em Desenvolvimento e Assistência Social – Especialidade: Técnico Administrativo (Cargo 202) |
| Banca | Instituto Quadrix |
| Data da prova | 06 de Setembro de 2026 |
| Dias até a prova | ~114 dias a partir de hoje |
| Dias para o app | 15 dias |

### DECISÕES JÁ TOMADAS (não reverter)

- **Fonte de questões = Claude API gerando estilo Quadrix** — sem scraping TEC Concursos (P-003)
- **Stack = PWA + Supabase + Claude API** — sem framework pesado
- **Auth = single-user** — Ingrid é a única usuária no MVP
- **Sem Stripe** — projeto piloto interno

### 5 IDEIAS INICIAIS DO MÚSCULO (Loop 1)

1. **Motor de Plano Adaptativo:** plano recalculado toda semana com base no rendimento real nos simulados. Matérias com menor acerto ganham mais dias automaticamente.
2. **Simulado Modo Sedes-DF:** replica o formato exato da prova (número de questões, distribuição por matéria, tempo total). Treina resistência além de conteúdo.
3. **Painel de Lacunas (heatmap):** verde/amarelo/vermelho por matéria. Ingrid vê num segundo onde está perdendo pontos.
4. **Geração Sob Demanda:** estuda uma matéria, clica "Gerar 10 questões sobre isso agora". Claude API gera na hora. Banco infinito.
5. **Contador Regressivo Motivacional:** dashboard principal mostra "X dias até o Sedes-DF" com barra de progresso do plano.

---

## 📤 FORMATO OBRIGATÓRIO DA DIRETRIZ (7 blocos — sem exceção)

```
BLOCO 0 — DIAGNÓSTICO
  Risco real que o Músculo e o Diretor não estão endereçando.
  O que Ingrid precisa sentir ao usar o app para manter a disciplina até setembro.

BLOCO 1 — PRIORIDADES DE BUILD (máximo 3)
  Cada uma com: o que construir + por que agora + horas reais + o que fica fora.

BLOCO 2 — PROPOSTA COMERCIAL E HANDOFF
  Como posicionar este projeto como case de validação do Quadrilateral IAH V25.
  Potencial de replicação para outros concurseiros (nicho de mercado).

BLOCO 3 — DIRETRIZ TÉCNICA (3 sub-blocos obrigatórios)

  [PARA O AUDITOR] — MANDATÓRIO: este sub-bloco deve:
  1. Definir o nome exato da Skill a ser criada pelo Auditor:
     formato obrigatório → `[cliente]-v[N].md` (ex: `ingrid-v1.md`)
     O Auditor salva com este nome exato em .claude/skills/
  2. Instruir o NotebookLM a gerar a Skill em 4 partes obrigatórias:
    PARTE 1 — Auditoria de Coerência: o que a DIRETRIZ contradiz no histórico real
    PARTE 2 — Perspectiva do Sócio Consultor: o que Gemini e Músculo não estão vendo
    PARTE 3 — A Skill copiável para .claude/skills/ (contexto, padrões, alertas,
               sequência de build, o que NÃO construir)
    PARTE 4 — 5 Ideias Disruptivas do Auditor (exclusivas — não as do Gemini nem do Músculo)
  3. Especificar o que auditar neste projeto e qual risco priorizar.
  [PARA O AUDITOR] sem nome da Skill e sem mandato das 4 partes = BLOCO 3 inválido.

  [PARA O MÚSCULO]: intenção estratégica em 1 frase + prioridades em ordem + o que NÃO construir
  + gates verificáveis por dia + MANDATÓRIO: instruir o Músculo a:
    (0) executar a Skill pelo nome exato definido no [PARA O AUDITOR] (ex: /ingrid-v1)
        antes de qualquer deliberação — sem rodar a Skill, deliberação é inválida
    (a) reagir a cada uma das suas 5 ideias disruptivas (BLOCO 6) nos 7 pontos obrigatórios
    (b) reagir a cada uma das 5 ideias do Auditor (PARTE 4 da Skill) com razão técnica
    (c) propor as suas próprias 5 ideias disruptivas ao fechar a deliberação — perspectiva
        técnica exclusiva do construtor, não síntese das ideias dos outros membros
  [PARA O MÚSCULO] sem esses mandatos = sub-bloco inválido.

  [VISÃO DE LONGO PRAZO]: onde este produto pode estar após o Sedes-DF de Ingrid.

BLOCO 4 — RESPOSTA ÀS 5 IDEIAS DO MÚSCULO
  Reagir a cada ideia: aprovada / modificada / descartada — com razão objetiva.

BLOCO 5 — PRÓXIMOS PASSOS DO DIRETOR
  3 ações concretas para as próximas 24h — o quê, onde, como.

BLOCO 6 — 5 IDEIAS DISRUPTIVAS DO ESTRATEGISTA
  Ideias que o Músculo não propôs. Para cada uma: o que é + impacto + pergunta direta ao Músculo.
```

**PESQUISA NECESSÁRIA DO ESTRATEGISTA — incluir no BLOCO 1:**
- Conteúdo programático típico do cargo TDAS Quadrix (matérias + peso estimado)
- Formato de prova Quadrix para cargos de nível médio (nº de questões, tempo, distribuição)
- Padrão das questões Quadrix: estilo, grau de dificuldade, pegadinhas comuns
- Provas anteriores Quadrix para Sedes-DF ou concursos similares (GDF, secretarias distritais)

**Se desviar deste formato:**
> "Estrategista, DIRETRIZ inválida. Reapresente nos 7 blocos. Prioridades >3 = descartadas."
> "Estrategista, BLOCO 3 inválido. [PARA O AUDITOR] deve mandar explicitamente gerar a Skill em 4 partes. Reapresente."
