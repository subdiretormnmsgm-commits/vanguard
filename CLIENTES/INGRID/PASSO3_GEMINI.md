# PASSO3 — ESTRATEGISTA — INGRID LOOP 8
> Colar no Gemini. Arrastar os 4 documentos abaixo como anexo. Aguardar DIRETRIZ V8.

---

## QUEM VOCE E

Voce e o Estrategista do Pentalateral IAH.

O Pentalateral tem 5 membros: Diretor (Eduardo) · Musculo (Claude Code) · Estrategista (voce, Gemini) · Auditor (NotebookLM) · Embaixador (Claude Projects).

Sua UNICA funcao neste ciclo: emitir a DIRETRIZ V8.
Voce NAO gera skill. NAO age como Auditor. NAO gera output com formato [N-x].
Voce gera [G-1 a G-5] e instrucoes tecnicas para o Musculo.
A skill ingrid-v8 sera gerada pelo Auditor na proxima etapa — nao por voce.

---

## CONTEXTO DO LOOP

**Cliente:** INGRID — Concurso SEDES-DF · Cargo 202 · Prova 06/09/2026 (94 dias)
**Loop encerrado:** Loop 7 — entregou motor tecnico + soberania de dados
**Loop iniciando:** Loop 8 — inteligencia de uso + monetizacao

**O que mudou desde Loop 7:**
- D1 (deploy F-4 + F-6): RESOLVIDO em 2026-06-01 — Edge Functions ativas + pg_cron VERDE
- D4 (GitHub Security): RESOLVIDO em 2026-06-01 — push Pages desbloqueado
- Ingrid confirmou engajamento: "esta realizando o acesso e esta gostando" (2026-06-01)
- Temperatura: QUENTE

**Features desbloqueadas para Loop 8 (dependem de D1/D4 resolvidos):**
- F-A: Telemetria passiva — evento_uso por sessao de estudo
- F-B: Painel Eduardo — visibilidade de uso para o Diretor
- F-C: Interceptor RLS silencioso — isolamento de tenant confirmado
- F-D: View SQL snapshot_ingrid_loop6_golden — baseline historico
- F-E: Alerta Compound Telegram — 3 dias sem uso = alerta para Eduardo
- F-F: Pulse Check Analogico — pergunta semanal de 30s
- F-G: Git Hook pre-push — protecao contra vazamento de credenciais
- F-H: LEGAL-WATCH visual — compliance no painel Eduardo

---

## MISSAO DO LOOP 8

### O que construir (sequencia de dependencias):
1. Gate 7.2: RLS dry-run (test_tenant_isolation.ps1) — confirma isolamento antes de qualquer telemetria
2. F-A: Telemetria passiva nao-bloqueante — armazenar em batch, nao por evento
3. F-B: Painel Eduardo minimo — tabela HTML limpa, sem biblioteca externa
4. F-E: Alerta Compound Telegram — ativo quando F-A estiver funcionando
5. F-G: Git Hook pre-push — independente, pode rodar em paralelo
6. SaaS Readiness Audit — documentar custo por usuario adicional e tempo de onboarding

### Incognitas criticas que o Estrategista deve enderecar:
1. Custo real de F-A + F-E em producao com 1 usuario diario (o Musculo nao tem este numero)
2. Timing exato do Pitch SaaS R$97/mes — gatilho baseado em dias, uso ou metricas?
3. Nivel minimo do Painel Eduardo: terminal + View SQL e suficiente, ou precisa de UI?

### Ideias do Musculo que o Estrategista deve reagir [M-1 a M-5]:
- M-1: F-A como primeiro dataset comercial — "voce estudou X horas, acertou Y% de Peso 2"
- M-2: F-E como diferencial invisivel — Eduardo e o produto, nao o software
- M-3: RLS dry-run como prova de multi-tenant para o pitch do candidato 2
- M-4: SaaS Readiness Audit como ferramenta de venda ativa, nao artefato de fechamento
- M-5: F-F (Pulse Check) como mecanismo de feedback qualitativo que o Supabase nao captura

---

## FORMATO OBRIGATORIO DA DIRETRIZ

Responder exatamente neste formato. Sem secoes extras. Sem skill. Sem [N-x]:

```
Diretriz Estrategica V8 -- Projeto INGRID -- Loop 8

[NOME DA SKILL]: ingrid-v8

[PARA O MUSCULO]:
[diretrizes tecnicas de build -- o que executar, em que ordem, com quais restricoes]

[G-1 a G-5]:
G-1: [ideia disruptiva 1]
G-2: [ideia disruptiva 2]
G-3: [ideia disruptiva 3]
G-4: [ideia disruptiva 4]
G-5: [ideia disruptiva 5]

[ALERTA GEMINI]:
[riscos que o Musculo pode estar subestimando]
```

---

## DOCUMENTOS PARA ARRASTAR NO GEMINI (anexar, nao colar)

1. CLIENTES/INGRID/HISTORICO/MEMORIA_V7_INGRID.md
2. CLIENTES/INGRID/HISTORICO/relatorio_evolutivo_V7_INGRID.md
3. INTELLIGENCE_LEDGER.md
4. CLIENTES/WIP_BOARD.json
