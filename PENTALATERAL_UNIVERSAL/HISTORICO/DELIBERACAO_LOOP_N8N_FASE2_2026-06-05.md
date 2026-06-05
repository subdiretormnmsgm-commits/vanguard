# DELIBERAÇÃO — Loop N8N-FASE2
**Músculo · Síntese P-037 · 2026-06-05**
**Tipo:** Loop de Processo — evolução do sistema Vanguard
**Sócios consultados:** Gemini (DIRETRIZ) · NotebookLM (Skill n8n-orquestracao-v1.md) · Embaixador (Seção D completa)

---

## CONSENSO — Os 3 sócios concordam

- **Gemini API para DIRETRIZ: DESCARTADO** — unanimidade. Risco de erosão do papel do Diretor como originador (P-021). G-2 vetado.
- **W-5 (ChurnWatch) é o primeiro build** — menor complexidade, retorno imediato ao Diretor.
- **M-4 (Circuit Breaker) é pré-requisito de W-6** — W-6 sem Circuit Breaker = burn rate sem velocímetro.
- **W-7 MVP em texto antes de botões** — Eduardo tem histórico de atrasar builds com UI complexa. Botões = W-7 v1.1.
- **N-4 (Git Hook schema) é implementação imediata** — independente de n8n, protege hoje.
- **P-102 respeitado** — scripts locais coexistem por 30 dias de uptime comprovado.

---

## DIVERGÊNCIAS RESOLVIDAS PELO MÚSCULO

### M-5 (PASSO3 auto-preparado) — Músculo vs Embaixador
- **Embaixador:** limitar a 60% do contexto para preservar atrito produtivo.
- **Músculo resolve:** percentual arbitrário. Melhor definir quais seções são auto-preenchidas (MEMORIA, WIP, histórico de commits) e quais Eduardo preenche (intenção estratégica do próximo loop, pergunta central para o Gemini). Preserva o atrito onde tem valor sem comprometer o contexto técnico.

### Ponto único de falha (EasyPanel) — Embaixador detectou, sócios não viram
- **Embaixador:** EasyPanel down = sistema mudo por até 24h.
- **Músculo resolve:** N-1 (Dead-Man's Switch) detecta. Falta o fallback manual documentado. Candidato a princípio P-110: "Toda automação crítica deve ter fallback manual de no máximo 3 passos."

### INSTRUÇÃO_SISTEMA do Embaixador em W-6 — risco de persona desatualizada
- **Embaixador detectou:** W-6 com system prompt fixo vai divergir do Embaixador no Claude Projects a cada atualização.
- **Músculo resolve:** W-6 lê INSTRUCAO_SISTEMA_EMBAIXADOR do repositório Git em runtime via HTTP Request no n8n — nunca variável de ambiente estática.

### Parâmetros de cliente hardcoded
- **Embaixador detectou:** thresholds (3 dias, $0.30/chamada) hardcoded no n8n não escalam para 20 clientes.
- **Músculo resolve:** todos os parâmetros por cliente vêm do WIP_BOARD.json — n8n lê do GitHub Raw em cada execução. Já implementado no W-1 (Ler WIP_BOARD). Padrão a replicar em W-5 e W-6.

---

## ADIÇÕES DO EMBAIXADOR INCORPORADAS AO PLANO

| Adição | Status |
|---|---|
| Ressalva de drift de relógio (NTP) no M-1 | Registrado como requisito de build do W-5 |
| Contexto com dado no alerta de ChurnWatch (M-2) | Requisito de build do W-5 |
| Circuit Breaker antes de W-6 | Sequência D1 Opção A |
| Linha de reação do Diretor antes de deliberar (W-6) | Campo "evento_focal" no payload do W-6 |
| Staging de 7 dias antes de active:true | Critério D3 |
| enum para campos de status no schema | Adicionado ao N-4 |

---

## PLANO CONSOLIDADO — O QUE O MÚSCULO RECOMENDA

**Sequência de build:**
```
1. N-4 — Git Hook schema JSON (implementar esta semana, independente de n8n)
2. N-1 — ping_n8n.ps1 no session_start.ps1 (pré-requisito universal)
3. W-5 + N-3 — ChurnWatch com isolamento B2B/B2C
4. M-4 — Circuit Breaker (pré-requisito de W-6)
5. W-6 + N-2 — Embaixador via Claude API com Idempotência
6. W-7 MVP — Veredito texto simples
7. W-7 v1.1 + N-5 — Botões + Undo Window (após 30 dias W-7 MVP)
```

**Variáveis de ambiente:** configurar todas em uma sessão antes de qualquer workflow ir active:true.

**Primeiro gate FASE2:** confirmar uptime de FASE1 > 7 dias antes de ativar qualquer workflow novo.

---

## 5 DECISÕES PARA VEREDITO DO DIRETOR

Ver DECISOES.json gerado após este documento.

---

*Síntese P-037 · Músculo · 2026-06-05 · DELIBERACAO_LOOP_N8N_FASE2_2026-06-05.md*
