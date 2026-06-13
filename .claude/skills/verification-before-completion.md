---
name: verification-before-completion
description: Use before claiming work is complete or passing. Evidence before assertions -- always. Run the command, read the output, THEN claim.
---

# Verification Before Completion

**Core principle:** Claiming work is complete without verification is dishonesty.

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

## The Gate Function

BEFORE claiming any status:
1. IDENTIFY: Qual comando prova esta afirmacao?
2. RUN: Executar o comando COMPLETO (fresh)
3. READ: Output completo + exit code
4. VERIFY: Output confirma a afirmacao?
   - Se NAO: Reportar status real com evidencia
   - Se SIM: Fazer afirmacao COM evidencia
5. SOMENTE ENTAO: Fazer a afirmacao

## Common Failures

| Afirmacao | Requer |
|---|---|
| Tests pass | Output: 0 failures |
| Build succeeds | Build command: exit 0 |
| Bug fixed | Testar sintoma original: passa |
| Pendente concluido | [RESOLVE:] em commit OU git log |

## Red Flags -- PARAR

- Usando "should", "probably", "seems to"
- "Great!", "Done!" antes de verificacao
- Commitar sem rodar o comando
- Confiar em relatorio de agente sem verificar

## Pentalateral Application

No Pentalateral, protege:
- Gate 0.5: doc_freshness rodar antes de "VERDE confirmado"
- P-037 gate: DELIBERACAO_LOOP.md existe antes de "sintese completa"
- Gate 6A: MEMORIA + relatorio existem antes de "loop fechado"
- WIP_BOARD socio=OK: artefato em disco existe antes de reportar OK

**Evidencia antes de declaracao. Sempre.**