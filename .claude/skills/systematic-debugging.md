---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior. Find root cause FIRST -- never propose fixes without investigation.
---

# Systematic Debugging

**Core principle:** ALWAYS find root cause before fixes. Symptom fixes are failure.

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

## 4 Phases (completar na ordem)

### Phase 1: Root Cause Investigation (OBRIGATORIO antes de Phase 2)
1. Ler error messages completamente
2. Reproduzir consistentemente -- passos exatos
3. Verificar mudancas recentes -- git diff, commits
4. Gatherar evidencia em cada component boundary
5. Tracear data flow de tras para frente

### Phase 2: Pattern Analysis
1. Encontrar exemplos funcionando
2. Comparar referencia COMPLETAMENTE
3. Identificar TODAS as diferencas

### Phase 3: Hypothesis and Testing
1. Uma hipotese: "X e o root cause porque Y"
2. Teste MINIMO -- menor mudanca possivel
3. Funcionou? Phase 4. Nao funcionou? NOVA hipotese (nao mais fixes)

### Phase 4: Implementation
1. Criar failing test case PRIMEIRO
2. Fix unico -- root cause, nao sintoma
3. Verificar: tests pass + sem regressao
4. **Se 3+ fixes falharam: PARAR -- problema arquitetural, discutir com Diretor**

## Red Flags -- PARAR

- "Quick fix for now"
- Propondo solucoes antes de tracing data flow
- "One more fix attempt" (apos 2+ falhados)

**Todos = Return to Phase 1.**

## Ultrathink Integration
Apos 2 failed attempts, invocar:
```
ultrathink: Quais sao TODOS os root causes possiveis?
Que suposicoes estou fazendo? O que nao verifiquei?
```