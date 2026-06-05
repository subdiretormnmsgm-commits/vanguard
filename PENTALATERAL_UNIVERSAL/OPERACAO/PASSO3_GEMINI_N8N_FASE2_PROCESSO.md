# PASSO3 — GEMINI ESTRATEGISTA
## Missão: Redesenho do Processo Pentalateral IAH com n8n como Camada de Orquestração

**De:** Músculo · Pentalateral IAH
**Para:** Gemini Estrategista
**Data:** 2026-06-04
**Tipo:** Evolução de processo — não é projeto cliente

---

## IDENTIDADE DO CONSELHO

Você é o **Estrategista do Pentalateral IAH** — o conselho de inteligência que opera projetos de consultoria tech para clientes não-técnicos. O conselho tem 5 membros: Diretor (Eduardo), Músculo (Claude Code), Estrategista (Gemini), Auditor (NotebookLM), Embaixador (Claude Projects).

O processo atual funciona. A questão não é "está quebrado" — é "como evoluir sem quebrar o que funciona".

---

## CONTEXTO — O QUE ACONTECEU HOJE

Em 2026-06-04, o Músculo instalou o **n8n no EasyPanel** como camada de automação. 4 workflows estão ativos:

1. **Check-in 7h/13h/20h** → Telegram automático sem computador ligado
2. **Monitor Supabase horário** → alerta imediato se cliente cair
3. **GitHub Push webhook** → notifica cada commit no Telegram
4. **Session Close webhook** → resumo automático ao fechar sessão

Ao ver o n8n funcionando, Eduardo percebeu algo maior: **o n8n pode atuar como sistema nervoso do Pentalateral** — preparando arquivos, notificando o sócio certo, reduzindo transporte manual do Diretor.

Mas isso não é uma decisão do Músculo. É uma decisão do Conselho.

---

## O QUE NÃO MUDA (RESTRIÇÃO INVIOLÁVEL)

- O loop Gemini → NotebookLM → Embaixador → Músculo → Diretor permanece
- O Diretor delibera e veredicta — nunca executa
- Nenhum sócio é substituído
- A qualidade da deliberação não pode cair
- P-102: coexistência obrigatória — n8n não substitui processos locais na FASE 1

---

## O QUE ESTÁ EM ABERTO (MISSÃO DO ESTRATEGISTA)

### M-1 — Loop com n8n integrado
Como fica o fluxo completo de um loop com n8n? Quais etapas podem ser automáticas? Quais PRECISAM do Diretor?

Limitações técnicas reais:
- Gemini: não tem API pública no n8n → ainda requer Eduardo abrir o browser
- NotebookLM: não tem API → ainda requer Eduardo arrastar arquivos
- Claude API: existe → n8n pode chamar o Músculo e o Embaixador diretamente
- Google Gemini API (AI Studio): existe → n8n poderia chamar o Estrategista via API (diferente do Gemini Chat)

### M-2 — Papel cirúrgico do Diretor
O que o Diretor FAZ em cada PASSO com n8n FASE 2?
- PASSO 3 (Gemini): o que é automático, o que exige Eduardo?
- PASSO 5 (NotebookLM): o que é automático, o que exige Eduardo?
- PASSO 7 (Embaixador): pode ser chamado via Claude API pelo n8n?
- Veredito: como chega ao Diretor? Telegram com botões?

### M-3 — Documentos do Pentalateral que precisam ser atualizados
Quais documentos centrais mudam com a integração do n8n?
- CLAUDE.md (Constituição) — quais seções?
- vanguard-protocolo.md — qual seção do processo?
- TEMPLATES_COMUNICACAO_PENTALATERAL.md — os PASSOs mudam de formato?
- DEPENDENCY_MAP.json — n8n entra como dependência?
- session_start.ps1 / session_close.ps1 — o que já está integrado, o que falta?

### M-4 — Workflows FASE 2 prioritários
Quais são os 3 workflows n8n mais impactantes a construir a seguir?
Critérios: reduz mais transporte do Diretor + menor risco de quebrar processo existente.

Candidatos identificados pelo Músculo (não validados):
- Auto-preparo do PASSO3 quando VEREDITOS.json é criado
- Embaixador via Claude API (sem abrir Claude Projects)
- Relatório semanal automático de todos os projetos ativos
- ChurnWatch integrado ao n8n (sem depender de Task Scheduler local)

### M-5 — Risco de processo
Quais os 3 maiores riscos de integrar n8n ao loop do Pentalateral?
O Conselho não pode adotar automação que degrade a qualidade da deliberação ou crie amnésia de sócio.

---

## FORMATO DA DIRETRIZ ESPERADA

```
DIRETRIZ ESTRATÉGICA — Pentalateral IAH — Loop N8N-FASE2
[5 blocos: M-1 a M-5 respondidos]
[SKILL PARA O NOTEBOOKLM]: nome-da-skill-v1.md
[PARA O MÚSCULO]: síntese de 3 decisões a implementar
[PARA O NOTEBOOKLM]: o que auditar nos documentos existentes
```

---

## COMO USAR ESTE PASSO3

1. Cole este arquivo no chat do Gemini (não como anexo — como texto)
2. Anexe como arquivos: MEMORIA mais recente + relatorio_evolutivo mais recente + INTELLIGENCE_LEDGER.md
3. Aguarde a DIRETRIZ
4. Cole a DIRETRIZ no Músculo para deliberação

---

*Músculo · Pentalateral IAH · 2026-06-04*
*P-090: este arquivo é a fonte de verdade — o chat é rascunho*
