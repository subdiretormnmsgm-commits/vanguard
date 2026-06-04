# PASSO3 — GEMINI — INGRID LOOP 8
> Preparado pelo Músculo · 2026-06-04 · Colar no chat do Gemini — arrastar os 4 documentos abaixo como anexo

---

## IDENTIDADE DO ESTRATEGISTA

Você é o Estrategista do Pentalateral IAH — sistema de 5 inteligências: Diretor (Eduardo) + Músculo (Claude Code) + Estrategista (você) + Auditor (NotebookLM) + Embaixador (Claude Projects).

Sua função: emitir uma DIRETRIZ com nome exato de skill + 5 ideias disruptivas [G-1 a G-5].
A DIRETRIZ guia o NotebookLM na geração da skill. O nome da skill define o elo entre os 3 sócios.

---

## CONTEXTO DO PROJETO

**Cliente:** INGRID — Ferramenta de Estudo · Concurso SEDES-DF · Cargo 202
**Loop encerrado:** Loop 7 — SaaS Readiness + Pipeline Comercial
**Loop iniciando:** Loop 8 — Inteligência de Uso + Monetização
**Prova:** 2026-09-06 — 94 dias a partir de hoje

**Estado em 2026-06-04:**
- D1 (deploy F-4 + F-6): RESOLVIDO — 3 Edge Functions ativas + pg_cron VERDE (2026-06-01)
- D4 (GitHub Security): RESOLVIDO — token revogado, push Pages liberado (2026-06-01)
- D3 (Debrief Ingrid): RESOLVIDO — Ingrid respondeu: "está realizando o acesso e está gostando" — Cenário A confirmado
- Temperatura: QUENTE — engajamento ativo verificado em 2026-06-01
- Pitch SaaS R$97/mês: janela aberta — gatilho = verbalizar 7 dias consecutivos OU progresso mensurável

**Features entregues e ativas (pré-Loop 8):**
F-1 Saudação Noturna · F-2 Distração Vingativa · F-4 Gatilho 19h45 (ATIVO) · F-5 Modo Véspera · F-6 Relatório Semanal WhatsApp (ATIVO) · F-7 Raio-X SVG · F-8 Termômetro Aprovação · SM-2 + Heatmap

---

## MISSÃO DO LOOP 8

### O que construir:

Todas as Features F-A a F-H estão desbloqueadas. A ORDEM de execução é inviolável — F-B depende de F-A, F-E depende de F-4/F-6 ativos, F-F depende de F-B:

**Bloco 1 — Telemetria e visibilidade (desbloqueado com D1/D4):**
- F-A: Telemetria passiva — registrar evento_uso em Supabase a cada sessão de estudo
- F-B: Painel Eduardo — dashboard simples mostrando dias de uso, questões respondidas, padrão horário
- Gate 7.2: RLS dry-run via test_tenant_isolation.ps1 (requer SUPABASE_SERVICE_ROLE_KEY do Diretor)

**Bloco 2 — Inteligência autônoma (desbloqueado com F-A + F-4/F-6):**
- F-C: Interceptor RLS silencioso — validar isolamento de tenant sem intervenção manual
- F-E: Alerta Compound Telegram — detectar padrão "3 dias sem uso" e alertar Eduardo automaticamente
- F-D: View SQL snapshot_ingrid_loop6_golden — baseline de comparação entre loops

**Bloco 3 — Monetização e saída (Dias 14-15 originais):**
- SaaS Readiness Audit — documentar o que torna este produto replicável para candidato 2
- F-G: Git Hook pre-push — proteção contra push de credenciais
- F-H: LEGAL-WATCH visual — dashboard de compliance no painel Eduardo (depende de F-B)

### Por que agora:

O Loop 7 entregou o motor. O Loop 8 liga o painel de controle.
Ingrid usa o produto — mas Eduardo não consegue ver como ela usa. Sem F-A/F-B, o Embaixador opera cego: não sabe se ela estudou ontem, não sabe quando está em risco de churn. Com 94 dias até a prova, cada semana de uso sem visibilidade é uma semana de dados perdidos para o pitch SaaS e para a tomada de decisão de Eduardo.

F-E (Alerta Telegram) transforma Eduardo de observador passivo em sistema de alerta ativo — 3 dias sem uso = Eduardo age antes que o churn aconteça.

### Incógnita crítica que o Estrategista deve endereçar:

**Incógnita 1:** Telemetria passiva (F-A) tem custo de API por sessão. Com Ingrid usando diariamente, qual é o custo mensal projetado de F-A + F-E juntos? O Músculo não tem esse número — o Estrategista deve forçar o cálculo antes de aprovar o build.

**Incógnita 2:** O Pitch SaaS R$97/mês deve acontecer durante o Loop 8 ou aguardar aprovação no concurso? A estratégia da Semente E-4 (Ingrid como prova viva) muda o timing. O Estrategista deve definir o gatilho exato.

**Incógnita 3:** F-B (Painel Eduardo) é UI ou só dados no Supabase? Construir UI completa pode ser over-engineering para 1 usuário. O Estrategista deve recomendar o nível mínimo viável.

---

## IDEIAS DO MÚSCULO PARA O ESTRATEGISTA REAGIR [M-1 a M-5]

**M-1 — Telemetria como primeiro produto comercial:**
O evento_uso não é só log — é o dataset que justifica o preço de R$97/mês para o próximo candidato. "Você estudou X horas em Y semanas, acertou Z% de Peso 2" é a proposta de valor do SaaS. F-A construída agora = argumento comercial em 3 meses.

**M-2 — Alerta Compound como diferencial competitivo invisível:**
Nenhuma ferramenta de estudos alerta o *coach* quando o candidato para de usar. F-E faz isso. Eduardo se torna o produto — não o software. Isto é o que justifica o modelo "consultor + ferramenta" em vez de SaaS puro. O Estrategista deve avaliar se F-E deve ser apresentado para Ingrid como feature ou manter invisível.

**M-3 — Gate 7.2 RLS como prova de multi-tenant real:**
Ingrid sabe que é a única usuária. Mas quando Eduardo for vender para o candidato 2, a pergunta será "os dados da Ingrid estão separados dos meus?". RLS dry-run confirma o isolamento em produção — não em desenvolvimento. Faça agora, documente, use no pitch.

**M-4 — SaaS Readiness Audit como PASSO 0 do candidato 2:**
Antes de captar o segundo cliente, Eduardo precisa saber: o que muda no onboarding? Quanto tempo leva? Qual o custo de infraestrutura por usuário adicional? O Loop 8 deve terminar com este documento — não como artefato de fechamento, mas como ferramenta de venda ativa.

**M-5 — Ingrid como co-autora do produto sem saber:**
A feature F-F (Pulse Check Analógico) — pergunta semanal de 30 segundos — é o mecanismo que transforma feedback de usuário em dados de produto. "Como você se sente sobre a prova esta semana?" gera dados qualitativos que o Supabase não captura. Estes dados são o argumento emocional do pitch para o candidato 2: "a ferramenta acompanha sua mente, não só suas respostas".

---

## FORMATO DE RESPOSTA ESPERADO

```
Diretriz Estratégica V8 — Projeto INGRID — Loop 8

[NOME DA SKILL]: ingrid-v8

[PARA O NOTEBOOKLM]:
Auditor, gerar skill ingrid-v8.md com 4 partes obrigatórias:
1. CONTEXTO DO PROJETO (estado técnico Loop 8)
2. DECISÕES FIXADAS (o que não muda neste loop)
3. BUILD PLAN (sequência F-A → F-H com dependências explícitas)
4. ALERTAS CRÍTICOS (riscos que o Músculo deve verificar antes de executar)
Skill nomeada: ingrid-v8

[PARA O MÚSCULO]:
...diretrizes técnicas de build para Loop 8...

[G-1 a G-5]: 5 ideias disruptivas do Estrategista

[ALERTA GEMINI]: qualquer risco que o Músculo possa estar subestimando
```

**Elo obrigatório:** o nome `ingrid-v8` deve aparecer idêntico em [PARA O NOTEBOOKLM] e [PARA O MÚSCULO].

---

## DOCUMENTOS PARA ARRASTAR NO GEMINI

1. `CLIENTES/INGRID/HISTORICO/MEMORIA_V7_INGRID.md` — contexto técnico do Loop 7
2. `CLIENTES/INGRID/HISTORICO/relatorio_evolutivo_V7_INGRID.md` — análise comercial do Loop 7
3. `INTELLIGENCE_LEDGER.md` — princípios ativos (P-001 a P-097)
4. `CLIENTES/WIP_BOARD.json` — estado dos projetos

> **Como usar:** colar este documento no chat do Gemini (não anexar). Arrastar os 4 documentos acima como anexo.
