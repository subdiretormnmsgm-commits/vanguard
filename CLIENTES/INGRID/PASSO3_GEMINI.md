# PASSO3 — GEMINI — INGRID LOOP 7
> Preparado pelo Músculo · 2026-05-30 · Levar ao Estrategista após MEMORIA_V6 + relatorio_evolutivo_V6

---

## IDENTIDADE DO ESTRATEGISTA

Você é o Estrategista do Pentalateral IAH — sistema de 5 inteligências: Diretor (Eduardo) + Músculo (Claude Code) + Estrategista (você) + Auditor (NotebookLM) + Embaixador (Claude Projects).

Sua função: emitir uma DIRETRIZ com nome exato de skill + 5 ideias disruptivas [G-1 a G-5].
A DIRETRIZ guia o NotebookLM na geração da skill. O nome da skill define o elo entre os 3 sócios.

---

## CONTEXTO DO PROJETO

**Cliente:** INGRID · Cargo 202 — Técnico Administrativo · Concurso SEDES-DF 2026 (banca Quadrix)
**Data da prova:** 2026-09-06 · **Dias até a prova:** ~99 dias
**Stack:** PWA Vanilla JS · Supabase próprio da Ingrid (yjqvjhezwhepwomukudt) · Claude API Haiku/Sonnet · GitHub Pages
**Versão em produção:** v20 · URL: https://subdiretormnmsgm-commits.github.io/vanguard/
**Temperatura da cliente:** 7.5/10 — VERDE SUSTENTADO · "Gostei bastante. Amanhã volto para atacar mais" (2026-05-24)

### Estado técnico atual (pós-Loop 6 / DIRETRIZ V6):

| Feature | Status |
|---|---|
| F-1 Saudação Noturna Dinâmica | Ativa — "Boa noite, N questões te esperam" após 18h |
| F-2 Distração Vingativa Silenciosa | Ativa — pegadinhas injetadas sem label visível |
| F-4 Gatilho Temporal 19h45 + pg_cron | Código entregue — deploy CLI PENDENTE |
| F-5 Modo Véspera | Ativo — ativar em 2026-08-30 |
| F-6 Relatório Semanal WhatsApp | Código entregue — deploy CLI PENDENTE |
| F-7 Raio-X SVG + Brasão Semanal | Ativo — html2canvas export PNG |
| F-8 Termômetro da Aprovação | Ativo — Nota Projetada vs Linha de Corte |
| SM-2 Spaced Repetition | Ativo — 102 respostas com 1 user_id correto |
| Banco de questões | 460+ questões Quadrix Cargo 202 |

### Bloqueios técnicos ativos:
1. **Edge Functions não deployadas via CLI** — F-4 (cron) e F-6 (relatório) operam via Mágico de Oz manual. Ingrid pode não receber o primeiro relatório domingo se o cron falhar.
2. **GitHub Pages push bloqueado** — secret revogado mas link de unblock pendente no GitHub Security. Cada deploy requer workaround.

### Decisões fixadas (não reverter sem veredito):
- G-5 Distração silenciosa sem label (punição visível = churn)
- Gatilho às 19h45 (horário modal de sessão noturno confirmado)
- Modo Véspera ativado por Eduardo, não por Ingrid
- G-3 Bloqueio TTL VETADO PERMANENTE
- G-1 Simulador Invalidação VETADO PERMANENTE

---

## MISSÃO DO LOOP 7

### O que construir neste loop:

**Prioridade 1 — Resolver bloqueios técnicos (desbloqueiam o que já está construído):**
- Deploy Edge Functions via `supabase login + supabase functions deploy` no projeto da Ingrid
- Desbloquear GitHub Pages push (Eduardo segue link GitHub Security)

**Prioridade 2 — SaaS Readiness Audit:**
- Verificar isolamento de dados: RLS ativo no projeto Supabase da Ingrid?
- Verificar que zero dados Vanguard vazam para o projeto dela
- Documentar o que seria necessário para onboardar um segundo cliente em 3 dias
- Identificar o que impediria escala para 10 usuários simultâneos

**Prioridade 3 — Pipeline comercial ativo:**
- Painel de uso real para Eduardo: Ingrid abriu hoje? Qual feature tocou? Quanto tempo?
- Gatilho de reativação após 5 dias sem sessão
- Script E-4 pronto para Eduardo plantar: "Quando você passar, vou ter o sistema pronto para quem você indicar"

**Prioridade 4 — Audit Trail de churn:**
- Alerta Telegram quando: 3+ dias sem sessão + cron falhou + relatório não enviado

### Por que agora:

- **Bloqueio de deploy** cria risco real no próximo domingo (F-4 + F-6 não autônomos ainda)
- **Temperatura sustentada** de Ingrid (7.5/10) é a janela de pitch — se cair antes do E-4, a semente se perde
- **Sentinel Report Valdece** vence em 2026-06-02 — Loop 7 de Ingrid precisa estar em build antes disso para não perder o ritmo
- **Motor replicável:** o próximo cliente Quadrix pode ser onboardado em 3 dias. O SaaS Readiness Audit documenta isso agora, enquanto o produto está fresco

### Incógnitas críticas que o Estrategista deve endereçar:

1. **Analytics de uso real:** Ingrid efetivamente tocou F-7 (export) e F-8 (termômetro)? Sem dados de comportamento, o painel de deliberação do próximo loop é cego.
2. **Data da prova:** SEDES-DF 2026 inédito — e se a data mudar para 2027? O Modo Véspera e o Relatório Semanal perdem urgência. O Estrategista propõe como o sistema se adapta a esse cenário?
3. **Segundo cliente:** qual é o próximo nicho Quadrix mais provável? O motor está pronto — o cliente potencial existe?

---

## IDEIAS DO MÚSCULO [M-1 a M-5]

**[M-1] Painel de Uso Real para Eduardo — não para Ingrid**
Dashboard interno (acesso só de Eduardo) que mostra: Ingrid abriu hoje? Qual feature tocou? Tempo de sessão? F-7 teve cliques? F-8 foi visualizado? Eduardo enxerga o comportamento real sem perguntar — sabe o momento certo de acionar o WhatsApp de reativação antes do churn acontecer. Custo: 1 Edge Function simples + tabela `evento_uso`.

**[M-2] Gatilho de Reativação Silenciosa após 5 dias sem sessão**
Se Ingrid não abre o app por 5 dias corridos, o sistema envia automaticamente uma mensagem: "Você estava indo muito bem — faltam N dias para a prova. Só 10 questões hoje." Uma mensagem, sem sequência, sem pressão. Reativação passiva — Eduardo não monitora, o sistema age. Diferente da notificação diária (19h45) — esta é o gatilho de emergência.

**[M-3] Score de Consistência Semanal — não de acerto**
Métrica alternativa ao % de acerto: quantos dias da semana Ingrid fez pelo menos 5 questões? Exibido no relatório semanal como "Você foi consistente em X/7 dias esta semana." Consistência prediz aprovação melhor que acerto isolado. Para o pitch SaaS: "Ela manteve consistência de 6/7 dias nas últimas 3 semanas com o sistema."

**[M-4] Link de Demonstração Anônimo para Prospects**
URL de leitura pública (sem login) que Eduardo envia para prospectos: mostra dashboard anonimizado de Ingrid com números reais — questões respondidas, % acerto, streak, Raio-X. "Veja como funciona para um candidato real." Custo zero — o banco já tem os dados. Argumento de venda: prova social com números reais, não mockup.

**[M-5] Audit Trail de Churn Risk — Alerta Compound no Telegram**
Se as 3 condições acontecem juntas: Ingrid não abre em 3 dias + cron 19h45 falhou + relatório semanal não foi enviado → Telegram do Eduardo: "CHURN RISK — Ingrid · 3 dias sem sessão · Push falhou · Relatório não enviado." Três sinais simultâneos = risco real, não falso positivo. Eduardo age com 1 WhatsApp antes do abandono silencioso.

---

## FORMATO DE RESPOSTA ESPERADO

```
Diretriz Estratégica V7 — Projeto INGRID — Loop 7

[NOME DA SKILL]: ingrid-v7

[PARA O NOTEBOOKLM]:
Você é o Auditor do Pentalateral IAH.
Gerar a skill nomeada exatamente: ingrid-v7
A skill tem 4 partes obrigatórias:
PARTE 1 — Contexto operacional e stack atual
PARTE 2 — Gates de validação sequencial para este loop
PARTE 3 — Alertas ativos e Circuit Breakers
PARTE 4 — Restrições rígidas (o que NÃO construir)
Use apenas dados dos documentos anexos. Zero alucinação estrutural.
Skill nomeada: ingrid-v7

[PARA O MÚSCULO]:
...diretrizes técnicas de build para Loop 7...
...decisões fixadas que não reverter...
...sequência de execução...

[G-1 a G-5]: 5 ideias disruptivas do Estrategista para Loop 7

[ALERTA GEMINI]: risco que o Músculo pode estar subestimando
```

**Elo obrigatório:** o nome `ingrid-v7` deve aparecer idêntico em [PARA O NOTEBOOKLM] e [PARA O MÚSCULO].

---

## DOCUMENTOS ANEXOS (arrastar no chat do Gemini)

1. `CLIENTES/INGRID/HISTORICO/MEMORIA_V6_INGRID.md` — contexto completo do Loop 6
2. `CLIENTES/INGRID/HISTORICO/relatorio_evolutivo_V6_INGRID.md` — SWOT + PDCA + 5W2H + [M-1 a M-5]
3. `INTELLIGENCE_LEDGER.md` — princípios ativos (P-001 a P-091)
4. `CLIENTES/WIP_BOARD.json` — estado atual dos projetos

> **Como usar:** colar este documento no chat do Gemini (não anexar). Arrastar os 4 documentos acima como anexo.
