# PASSO 3 — ESTRATEGISTA (GEMINI) · PROJETO INGRID · LOOP 4
> Pentalateral IAH — Camada Permanente: não editar blocos de protocolo.
> Atualizado pelo Músculo em 2026-05-18 após Síntese Final do Loop 3.
> Usar após Gate Dia 8 aprovado + relatorio_evolutivo_V3 gerado.

---

## 🎯 MISSÃO DESTA SESSÃO

Estrategista, você está recebendo o contexto completo do Loop 3 do Projeto Ingrid.

**Sua missão:**
Gerar a DIRETRIZ V5 para o Loop 4 — consolidação, SaaS Readiness e escala.
O Loop 3 entregou a interface PWA completa (Dias 6-8): Clickwrap + Tutor Socrático 3 níveis +
Fallback de Fadiga + Telemetria TTI + Graceful Degradation.
O Loop 4 começa com Ingrid usando o app de verdade. Os dados chegam. A análise começa.

**Prazo remanescente:** ~dias até 2026-05-30 (conferir WIP_BOARD).
**Gate do Loop 4:** Gate Dia 15 — Ingrid com 7 dias de uso, curva de erro por distrator documentada.

---

## 📌 ANTES DE IR AO GEMINI — o que anexar

Anexar nesta ordem:

```
1. INTELLIGENCE_LEDGER.md
   Caminho: vanguard\INTELLIGENCE_LEDGER.md
   Motivo:  P-001 a P-037 ativos — sem isso, Gemini não conhece P-037 (Síntese Final)

2. WIP_BOARD.json
   Caminho: vanguard\CLIENTES\WIP_BOARD.json
   Motivo:  estado atual de todos os projetos

3. HISTORICO\MEMORIA_V3.md
   Caminho: vanguard\CLIENTES\INGRID\HISTORICO\MEMORIA_V3.md
   Motivo:  decisões técnicas + dívidas do Loop 3 (gerar após Gate Dia 8)

4. HISTORICO\relatorio_evolutivo_V3.md
   Caminho: vanguard\CLIENTES\INGRID\HISTORICO\relatorio_evolutivo_V3.md
   Motivo:  SWOT + [M-1 a M-5] do Músculo (gerar após Gate Dia 8)

5. PASSO3_GEMINI.md (este arquivo)
   Caminho: vanguard\CLIENTES\INGRID\PASSO3_GEMINI.md
   Motivo:  contexto Loop 4 + [E-1 a E-5] do Embaixador + formato obrigatório
```

Após receber a DIRETRIZ (7 blocos):
- Se vier incompleta → dizer: "Estrategista, DIRETRIZ inválida. Reapresente nos 7 blocos."
- Salvar como: `vanguard\CLIENTES\INGRID\DIRETRIZ_GEMINI_V5.txt`

---

## 🆕 ATUALIZAÇÕES DO PROCESSO DESDE LOOP 3

> Estrategista: internalizar antes de responder. Estes princípios estão no LEDGER
> mas resumidos aqui para ancoragem rápida.

| Princípio | Regra em 1 linha |
|---|---|
| **P-034** | Músculo faz Análise Cirúrgica de [G+N] ANTES de enviar ao Embaixador |
| **P-035** | Embaixador opera em amplitude total — comercial, pipeline, business case, não só cliente |
| **P-036** | Músculo prepara mensagem estruturada (6 blocos) para o Embaixador ao fim da análise cirúrgica |
| **P-037** | Músculo faz Síntese Final com 25 inputs [M+G+N+M'+E] antes do veredito do Diretor |

**Loop agora tem 7 passos:** Músculo → Gemini → NotebookLM → Músculo (cirúrgico) →
Embaixador → Músculo (Síntese Final P-037) → Diretor (veredito).

**25 ideias/ciclo:** [M-1 a M-5] + [M'-1 a M'-5] + [G-1 a G-5] + [N-1 a N-5] + [E-1 a E-5].

---

## ⚠️ [MANDATO_DIRETO_DO_DIRETOR] — PRIORIDADE CRÍTICA ANCORADA

[2026-05-16] Eduardo declarou diretamente:
1. Contrato formal é pré-requisito antes de qualquer projeto Camada 1+ [P-023]
2. NotebookLM atua como advogado do processo — objeções com base em precedentes [P-022]
3. O Diretor é o originador das inovações estratégicas — sistema amplifica, não substitui [P-021]

[2026-05-18] Adições:
4. Síntese Final do Músculo sempre antes do veredito do Diretor [P-037]
5. Embaixador ativo antes e depois de toda entrega ao cliente [P-031]

---

## ⚔️ PROTOCOLO ANTI-DERIVA

| Deficiência | Gatilho de Alerta |
|---|---|
| Miopia por Excesso | Citar diretriz antiga ignorando P-034 a P-037 |
| Alucinação Otimista | Propor feature que leva >4h sem decompor sub-tarefas |
| Lost-in-the-Middle | Ignorar que Ingrid tem agora dados reais de uso (não só perfil inferido) |
| Síndrome de Complacência | Ignorar os alertas do Embaixador no [E-1 a E-5] abaixo |

---

## 🔧 COMPENSAÇÃO DAS DEFICIÊNCIAS DO MÚSCULO

1. **Amnésia de Sessão** → citar P-001 a P-037 relevantes
2. **Momentum de Execução** → gates verificáveis por dia (output real)
3. **Otimismo de Estimativa** → decompor em sub-horas; total >4h = simplificar
4. **Escopo Silencioso** → listar explicitamente o que NÃO construir
5. **Drift de Formato** → DIRETRIZ em 7 blocos; Músculo sem formato = deliberação inválida

---

## 📋 CONTEXTO DO PROJETO

**Cliente:** Ingrid
**Cargo:** 202 — Técnico Administrativo · Sedes-DF · Banca Quadrix
**Prova:** 2026-09-06
**Prazo do projeto:** 2026-05-30
**Camada:** 2 — Produto
**Loop atual:** #4 — Pós-entrega (uso real + dados + SaaS Readiness)

### GATES CONCLUÍDOS

| Gate | O que foi entregue | Status |
|---|---|---|
| Dia 2 | 10 questões CLI avaliadas (rubrica ≥ 4/5) | APROVADO |
| Dia 5 | Feed 70/30 · 7 dias simulados · SM-2 · 0 erros | APROVADO |
| Dia 8 | PWA completo: Clickwrap + Tutor 3 níveis + Fallback + TTI + Telemetria | [GATE PENDENTE] |

### DECISÕES FIXADAS (não reverter)

- Stack: PWA Vanilla JS + Supabase + Claude Haiku
- Auth: single-user hardcoded
- Feed: 70/30 (Peso 2 / Peso 1)
- SM-2 original preservado (apenas coletar latência, não alterar fórmula)
- 1 Edge Function por invocação (não monolito)
- Clickwrap resolve P-023 em código (Gate Dia 8)
- Pontos Ponderados = único número visível (obrigação contratual cláusula 2)

### O QUE FOI CONSTRUÍDO NO LOOP 3 (Dias 6-8)

| Item | Status |
|---|---|
| Clickwrap Termo de Uso (`termos_aceitos` + SHA-256) | Construído |
| E-2 com cold start state (edital → erro recente) | Construído |
| E-5 com threshold ≥ 10 questões | Construído |
| Tutor Socrático 3 níveis + tom austere | Construído |
| TTI (acertos < 10s + erros por tempo) | Construído |
| Curva erro/distrator/nivel_tutor como campo explícito | Construído |
| Debug Mode: 5 toques no logo | Construído |
| Beacon abandono: padrão 3+ na semana | Construído |
| Stale session reload após 4h | Construído |
| Graceful degradation (cache → explicacao_base → sem tela branca) | Construído |

---

## 🧭 [E-1 a E-5] DO EMBAIXADOR — Loop 3 · 2026-05-18

> O Estrategista reage a cada [E-X] no BLOCO 4 da DIRETRIZ.
> [E-X] são input de campo — têm peso equivalente ao [M-X] do Músculo.

| # | Ideia | Dimensão |
|---|---|---|
| [E-1] | Vanguard é investidor de relacionamento neste piloto — gerar "Resumo da Entrega" de 1 página para Ingrid no Gate Dia 15 | Comercial |
| [E-2] | Plantar pergunta no Gate Dia 8: "Você conhece mais alguém prestando concurso esse ano?" | Pipeline |
| [E-3] | R$97/mês é teto receptivo da Ingrid; teto possível pode ser R$150 — registrar reação dela ao ouvir o número | Precificação |
| [E-4] | Curva de erro por distrator nas 3 primeiras sessões = slide de pitch para 500 candidatos Quadrix | Business Case |
| [E-5] | Clickwrap em D1 de produto vira regra Vanguard para todo SaaS — não exceção de caso | Portfólio |

---

## 💡 5 IDEIAS DO MÚSCULO — Loop 3

> ⚠️ PREENCHER após gerar relatorio_evolutivo_V3 (Gate Dia 8 concluído).
> Seção abaixo é placeholder — substituir pelo conteúdo real do relatório.

```
[M-1] [preencher após Loop 3]
[M-2] [preencher após Loop 3]
[M-3] [preencher após Loop 3]
[M-4] [preencher após Loop 3]
[M-5] [preencher após Loop 3]
```

---

## 📤 FORMATO OBRIGATÓRIO DA DIRETRIZ (7 blocos — sem exceção)

> **Título obrigatório na primeira linha da resposta:**
> `Diretriz Estratégica V5 — Projeto Ingrid — Loop 4`
> Sem o título, a DIRETRIZ não é identificável nem arquivável.

```
BLOCO 0 — DIAGNÓSTICO
  Risco real que o Músculo e o Diretor não estão endereçando com Ingrid usando o app.
  O que os dados das primeiras sessões reais revelarão que o perfil inferido não revelou.

BLOCO 1 — PRIORIDADES DE BUILD (máximo 3)
  Cada uma com: o que construir + por que agora + horas reais + o que fica fora.
  Foco: SaaS Readiness Audit (Dias 14-15), monetização V2 e escala para próximos candidatos.

BLOCO 2 — PROPOSTA COMERCIAL E HANDOFF
  Posicionamento da Ingrid como case documentado de EdTech para 500 candidatos Quadrix.
  Pitch V2 (R$97/mês) com timing e gatilho de conversão precisos.
  Reagir ao [E-1 a E-5] do Embaixador — especialmente [E-3] (precificação) e [E-4] (business case).

BLOCO 3 — DIRETRIZ TÉCNICA (3 sub-blocos obrigatórios)

  [PARA O AUDITOR] — MANDATÓRIO:
  1. Nome exato da Skill: `ingrid-v4.md`
  2. Gerar em 4 partes obrigatórias:
     PARTE 1 — Auditoria de Coerência: o que a DIRETRIZ V5 contradiz no histórico real
     PARTE 2 — Perspectiva do Sócio Consultor: o que Gemini e Músculo não estão vendo
     PARTE 3 — A Skill copiável (contexto Loop 4, padrões, alertas, sequência de build)
     PARTE 4 — 5 Ideias Disruptivas do Auditor (exclusivas)
  3. Risco a priorizar: dados reais da Ingrid vs. inferências dos Loops 1-3.

  [PARA O MÚSCULO]:
  Intenção estratégica + prioridades + o que NÃO construir + gates verificáveis.
  MANDATÓRIO:
    (0) Executar `/ingrid-v4` antes de qualquer deliberação.
    (a) Reagir a cada [G-1 a G-5] do Estrategista nos 7 pontos.
    (b) Reagir a cada [N-1 a N-5] do Auditor com razão técnica.
    (c) Reagir a cada [E-1 a E-5] do Embaixador (comportamento real tem peso de evidência).
    (d) Propor [M-1 a M-5] disruptivos ao fechar.
    (e) Executar Síntese Final (P-037) com todos os 25 inputs antes do veredito do Diretor.

  [VISÃO DE LONGO PRAZO]: Motor Anti-Quadrix white-label para bancas regionais do Brasil.

BLOCO 4 — RESPOSTA ÀS IDEIAS
  Reagir a cada [M-1 a M-5] do Músculo: aprovada / modificada / descartada — com razão objetiva.
  Reagir a cada [E-1 a E-5] do Embaixador: CONFIRMA / EXPANDE / ALERTA — com visão estratégica.

BLOCO 5 — PRÓXIMOS PASSOS DO DIRETOR
  3 ações concretas — o quê, onde, como. Incluir: captura de voz da Ingrid no Gate Dia 8.

BLOCO 6 — 5 IDEIAS DISRUPTIVAS DO ESTRATEGISTA
  Ideias que o Músculo não propôs. Foco: pós-uso real da Ingrid, escala e monetização.
  Para cada uma: o que é + impacto + pergunta direta ao Músculo.
```

**Se desviar deste formato:**
> "Estrategista, DIRETRIZ inválida. Reapresente nos 7 blocos. Prioridades >3 = descartadas."
> "Estrategista, BLOCO 3 inválido. [PARA O AUDITOR] deve mandar gerar Skill em 4 partes. Reapresente."
> "Estrategista, BLOCO 4 incompleto. Reagir a [E-1 a E-5] é obrigatório — Embaixador tem peso de evidência de campo."
