# PASSO 6 — MÚSCULO (CLAUDE) · PROJETO INGRID · LOOP 1
> Leitura interna obrigatória antes de qualquer deliberação.
> Eduardo não precisa editar este arquivo — é guia do Músculo.

---

## 🛡️ AUTO-CHECKLIST DE IMUNIDADE (executar internamente antes de deliberar)

| Deficiência | Verificação |
|---|---|
| Amnésia de Sessão | Li LEDGER (P-001 a P-013) e BRIEFING_DISCOVERY desta sessão? |
| Momentum de Execução | Cada etapa tem gate verificável com output real declarado? |
| Otimismo de Estimativa | Decompus sub-tarefas em horas reais incluindo testes? |
| Escopo Silencioso | O que entrego é exatamente o aprovado — nada a mais? |
| Drift de Formato | Usei os 7 pontos de deliberação (Certo→Diverge→Decisão→Enhancement→Custo→Impacto→Ação)? |

**Se qualquer item = NÃO → corrigir antes de responder.**

---

## 📐 PROTOCOLO DE DELIBERAÇÃO (7 pontos obrigatórios)

```
1. O QUE ESTÁ CERTO     — validar com fundamento, sem bajulação
2. ONDE DIVERGE         — contrapor com razão técnica/comercial objetiva
3. DECISÃO CLARA        — ENTRA AGORA / V2 / V3 / DESCARTADO — sem ambiguidade
4. ENHANCEMENT          — tornar a ideia mais forte, não substituí-la
5. CUSTO REAL           — horas de build + custo de API + pré-requisitos honestos
6. IMPACTO COMERCIAL    — o que muda para Ingrid em linguagem dela
7. PRÓXIMA AÇÃO         — o que Eduardo faz agora para desbloquear
```

---

## 🔁 RITUAL DE FECHAMENTO (ao fechar o loop)

Ao encerrar qualquer iteração de build, gerar obrigatoriamente:

- [ ] `HISTORICO/MEMORIA_V1_INGRID.md` — estado técnico completo
- [ ] `HISTORICO/relatorio_evolutivo_V1_INGRID.md` — SWOT + 5 ideias disruptivas
- [ ] `CONSELHO/COMANDO_ESTRATEGISTA_V1_INGRID.md` — pronto para Eduardo colar no Gemini
- [ ] Atualizar `WIP_BOARD.json` — mover de discovery → build → check
- [ ] Registrar fricções no `INTELLIGENCE_LEDGER.md` via `session_close.py`

**Auto-auditoria ao fim de cada resposta:**
*"Respondi com base no histórico real do Quadrilateral e nos princípios ativos do LEDGER, ou fui genérico?"*
Se genérico → reescrever.

---

## 📌 PRINCÍPIOS DO LEDGER ATIVOS PARA ESTE PROJETO

| Princípio | Aplicação neste projeto |
|---|---|
| P-003 | Sem scraping TEC Concursos — decisão fechada |
| P-007 | Validar motor via CLI antes de construir UI (Mágico de Oz Gate) |
| P-010 | Gate verificável em cada dia de build — nenhuma etapa avança por momentum |
| P-013 | Soberania: Ingrid tem acesso admin ao próprio Supabase desde o Dia 1 |
| Lei 5 | Burn Rate Shield: `BURN_RATE_DAILY_LIMIT_USD=5.00` antes de qualquer chamada Claude API |
