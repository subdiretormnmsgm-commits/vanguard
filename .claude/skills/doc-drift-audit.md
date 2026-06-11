---
name: doc-drift-audit
description: Auditoria de deriva documental — detecta documentos canônicos desatualizados em relação ao estado atual do loop. Usar ao iniciar sessão ou ao suspeitar de deriva.
version: "1.0"
created: "2026-06-11"
---

# DOC DRIFT AUDIT — PENTALATERAL IAH

> Skill ativada quando há suspeita de deriva entre documentos e realidade do sistema.
> Complementa doc_freshness_checker.ps1 (Gate 0.5) com análise semântica.

---

## QUANDO USAR

- Ao iniciar sessão com BLOCO 0 do Embaixador mencionando deriva
- Quando session_start reportar AMARELO em doc_freshness_checker
- Quando o Diretor mencionar que um documento "parece desatualizado"
- A cada 3 loops (CHECK-UP SISTÊMICO)

---

## PROTOCOLO DE AUDITORIA

### 1. INVENTÁRIO DOS DOCUMENTOS RASTREADOS

| Prioridade | Arquivo | Critério de Deriva |
|---|---|---|
| CRÍTICO | CLIENTES/VANGUARD/CLAUDE_PROJECT/LOOP_STATE.json | loop_atual != loop em WIP_BOARD |
| CRÍTICO | PENDENTES.md | Seção "LOOP [N]" ausente para loop atual |
| CRÍTICO | CLIENTES/WIP_BOARD.json | loop_fase_atual.loop != LOOP_STATE.loop_atual |
| ALTO | INTELLIGENCE_LEDGER.md | Último P-XXX tem mais de 2 loops sem adição |
| ALTO | CLIENTES/*/NOTEBOOKLM_FONTES/04_INTELLIGENCE_LEDGER.md | Diverge do LEDGER raiz |
| ALTO | CLIENTES/*/NOTEBOOKLM_FONTES/02_MEMORANDO_PENTALATERAL_UNIVERSAL.md | Diverge do UNIVERSAL |
| MÉDIO | CLIENTES/*/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR_*.md | Sem data do ano atual no cabeçalho |
| MÉDIO | CLIENTES/*/NOTEBOOKLM_FONTES/17_VANGUARD_TIMELINE.md | Não menciona Loop N ou N-1 |

### 2. METODOLOGIA

Para cada arquivo rastreado:
a) Ler as primeiras 20 linhas (cabeçalho, data, loop)
b) Verificar se menciona o loop atual ou anterior
c) Comparar campo crítico com fonte canônica
d) Classificar: VERDE / AMARELO / VERMELHO

Critérios:
- VERDE: menciona loop atual, campos coerentes com WIP_BOARD e LOOP_STATE
- AMARELO: menciona loop anterior (N-1), drift leve mas recuperável
- VERMELHO: menciona N-2 ou anterior, ou campo crítico diverge da fonte

### 3. OUTPUT

```
DOC DRIFT AUDIT — [DATA] — Loop [N] — [CLIENTE]
[VERMELHO] [arquivo] — motivo
[AMARELO]  [arquivo] — motivo
[VERDE]    [arquivo] — coerente

AÇÕES IMEDIATAS (VERMELHO): corrigir antes de qualquer deliberação.
AÇÕES PLANEJADAS (AMARELO): corrigir na mesma sessão.
```

### 4. FALHA-PROCESSO SE DERIVA > 2 LOOPS

```
[FALHA-PROCESSO-{DATA}-DERIVA] [arquivo] — [N] loops sem atualização.
Registrar em LEDGER_INBOX.md imediatamente.
```

---

## INTEGRAÇÃO

- doc_freshness_checker.ps1 (Gate 0.5): verifica CONTEÚDO — automático
- Esta skill: verifica SEMÂNTICA — manual quando suspeita de deriva
- sync_guard.ps1: verifica HASH — integridade física dos arquivos

---

v1.0 (2026-06-11): ATO 3 Loop 33 — análise semântica de deriva documental.