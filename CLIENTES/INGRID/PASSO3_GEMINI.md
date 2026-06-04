# PASSO3 — INGRID LOOP 8
> Colar no Gemini. Arrastar APENAS os 3 documentos listados no final. NAO anexar o LEDGER.

---

Voce e um consultor estrategico analisando um projeto de software educacional.

Preciso que voce analise o contexto abaixo e emita uma DIRETRIZ no formato especificado.

---

## PROJETO

**Cliente:** Ingrid — candidata ao concurso SEDES-DF (prova 06/09/2026, 94 dias)
**Produto:** PWA de estudos com SM-2, heatmap, tutor socratico, questoes geradas por IA
**Stack:** Vanilla JS + Supabase + Claude API + GitHub Pages
**Contexto completo:** ver documentos anexos

---

## O QUE FOI ENTREGUE (Loop 7)

- 3 Edge Functions deployadas em producao (gatilho temporal, relatorio semanal, RLS)
- pg_cron ativo (cron 45 22 * * * + 0 13 * * 0)
- GitHub Security resolvido — push Pages desbloqueado
- Ingrid confirmou engajamento ativo: "esta realizando o acesso e esta gostando" (2026-06-01)
- Temperatura: QUENTE

---

## O QUE PRECISA SER FEITO (Loop 8)

**Bloco A — Seguranca e isolamento:**
- Gate 7.2: RLS dry-run via test_tenant_isolation.ps1 — confirmar isolamento de tenant antes de telemetria
- F-G: Git Hook pre-push — barreira contra vazamento de credenciais

**Bloco B — Telemetria (desbloqueado com Edge Functions ativas):**
- F-A: registrar evento_uso em Supabase — batch nao-bloqueante, nao por evento individual
- F-D: View SQL snapshot_ingrid_loop6_golden — baseline historico para comparacao entre loops

**Bloco C — Visibilidade e alertas (depende de F-A):**
- F-B: Painel Eduardo — tabela HTML limpa mostrando dias de uso, questoes, horario
- F-E: Alerta Telegram — 3 dias sem uso dispara notificacao para Eduardo

**Bloco D — Monetizacao:**
- SaaS Readiness Audit — documentar custo por usuario adicional e tempo de onboarding
- Pitch R$97/mes: janela aberta — Ingrid disse que gosta, ainda nao verbalizou progresso especifico

---

## MINHAS 5 IDEIAS — REAJA A CADA UMA (aprovada / modificada / descartada + razao)

M-1: F-A como primeiro dataset comercial — "estudou X horas, acertou Y% das questoes dificeis" vira argumento de venda para o proximo candidato
M-2: F-E como diferencial invisivel — Eduardo e o produto, nao o software; nenhum concorrente alerta o coach quando o candidato para de usar
M-3: RLS dry-run agora como prova de multi-tenant para o pitch ao candidato 2
M-4: SaaS Readiness Audit como ferramenta de venda ativa, nao apenas artefato de fechamento
M-5: F-F (Pulse Check — pergunta semanal de 30s) como dado qualitativo que o Supabase nao captura

---

## INCOGNITAS QUE PRECISO QUE VOCE ENDERECE

1. Custo real de F-A + F-E em producao com 1 usuario diario — o Musculo nao tem esse numero
2. Timing do pitch R$97/mes — gatilho por dias, por uso ou por metrica de aprovacao?
3. Nivel minimo do Painel Eduardo — terminal + View SQL e suficiente ou precisa de UI?
4. M-1 (telemetria como dataset comercial): ha algum risco legal de usar dados da Ingrid como argumento de venda para terceiros sem consentimento explicito?

---

## FORMATO DA RESPOSTA

Responda exatamente assim — sem adicionar secoes extras:

```
Diretriz Estrategica V8 -- Projeto INGRID -- Loop 8

[NOME DA SKILL]: ingrid-v8

[PARA O MUSCULO]:
[diretrizes tecnicas: o que executar, em que ordem, o que NAO construir, gates por dia de build]

REACAO AS MINHAS IDEIAS:
M-1: [aprovada / modificada / descartada — razao em 1 linha]
M-2: [aprovada / modificada / descartada — razao em 1 linha]
M-3: [aprovada / modificada / descartada — razao em 1 linha]
M-4: [aprovada / modificada / descartada — razao em 1 linha]
M-5: [aprovada / modificada / descartada — razao em 1 linha]

5 IDEIAS DISRUPTIVAS (suas — o que eu nao vi):
[G-1]: [ideia disruptiva 1]
[G-2]: [ideia disruptiva 2]
[G-3]: [CONTRA-INTUITIVO] [ideia que vai contra o obvio]
[G-4]: [ideia disruptiva 4]
[G-5]: [CONTRA-INTUITIVO] [segunda ideia contra-intuitiva]

[ALERTA]:
[riscos que estamos subestimando]
```

Minimo 2 ideias marcadas [CONTRA-INTUITIVO] — ideias que vao contra o que parece obvio fazer agora.

---

## DOCUMENTOS PARA ARRASTAR (apenas estes 3 — nao o LEDGER)

1. CLIENTES/INGRID/HISTORICO/MEMORIA_V7_INGRID.md
2. CLIENTES/INGRID/HISTORICO/relatorio_evolutivo_V7_INGRID.md
3. CLIENTES/WIP_BOARD.json
