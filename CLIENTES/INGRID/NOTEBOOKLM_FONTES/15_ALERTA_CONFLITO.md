# ALERTA DE CONFLITO TÉCNICO
**Emitido por:** Músculo (Claude Code) — Poder de Veto Soberano
**Protocolo:** Sovereign Veto — Camada 2 (Hard Block)
**Status:** ⛔ PROCESSO PARALISADO

---

> **INSTRUÇÕES:** Este arquivo é um template. Quando um conflito real for emitido, preencha as seções com o conflito específico, commit o arquivo, e o processo não prossegue até resolução documentada.

---

## CONFLITO IDENTIFICADO

**ID do Conflito:** [CONFLITO-XXX]
**Data:** [YYYY-MM-DD]
**Sessão:** [V__-nome-da-sessao]
**Ponto de origem:** [quem emitiu a instrução conflitante]

### Instrução Vetada

> [Copie a instrução exata que está sendo vetada]

### Violação Detectada

**Princípio violado:** [P-00X — nome do princípio] / [Lei X — nome da lei]
**Peso afetado:** [weight_simplicidade_arquitetural | peso_seguranca | etc.]
**Severidade:** [CRITICAL | HIGH | MEDIUM]

### Por que isso viola o princípio

[Explicação técnica objetiva em 3-5 linhas. Sem julgamento — apenas a análise.
Exemplo: "Construir hook de CI/CD requer que o pipeline exista em produção. 
O pipeline não está deployado. Enforcement para infraestrutura inexistente é o 
anti-padrão do museu sem visitantes — identificado e refutado na V22."]

### Impacto se ignorado

- **Técnico:** [dívida específica que será gerada]
- **Comercial:** [custo em tempo ou receita]
- **Arquitetural:** [degradação do sistema]

---

## CONTRAPROPOSTA DO MÚSCULO

**O que fazer em vez disso:**

[Proposta concreta e simples. Código se aplicável. Sem abstrações desnecessárias.]

**GUT da contraproposta:** G[X] × U[X] × T[X] = [score]

---

## PROTOCOLO DE RESOLUÇÃO

### Opção 1 — Aceitar a contraproposta [RECOMENDADO]
O Diretor confirma e o Músculo implementa a contraproposta.
→ Registrar no `friction.log` como evento resolvido.

### Opção 2 — Override com risco documentado [REQUER ASSINATURA]
O Diretor pode fazer override, mas deve assinar explicitamente:

```
OVERRIDE DOCUMENTADO — [CONFLITO-XXX]
Data: [YYYY-MM-DD]
Diretor: Eduardo
Risco aceito: [descrição do risco]
Motivo do override: [justificativa]
Revisão prevista: [quando este override será revisitado]
```

> ⚠️ 3 overrides do mesmo tipo = padrão de comportamento → novo princípio gerado automaticamente no INTELLIGENCE_LEDGER.

### Opção 3 — Deliberação do Conselho
Emitir para o Estrategista e Auditor. Aguardar PARECER_UNIFICADO.md.

---

## RASTREAMENTO

| Campo | Valor |
|---|---|
| Status | ⛔ BLOQUEADO |
| Soft Veto anterior? | [SV-X emitido em sessão anterior? S/N] |
| Recorrência | [1ª ocorrência / 2ª / 3ª] |
| Resolução | [pendente] |
| Resolvido em | [data] |
| Método de resolução | [contraproposta / override / conselho] |

---

## NOTA PARA CI/CD

Quando o pipeline de deploy estiver ativo, adicionar ao `.github/workflows/deploy.yml`:

```yaml
- name: Check for active conflict alerts
  run: |
    if [ -f "ALERTA_CONFLITO.md" ]; then
      if grep -q "⛔ BLOQUEADO" ALERTA_CONFLITO.md; then
        echo "DEPLOY BLOQUEADO: ALERTA_CONFLITO.md ativo"
        exit 1
      fi
    fi
```

*Este hook não está ativo até o pipeline existir em produção.*

---

*Sovereign Veto — Camada 2. Arquitetura antes de velocidade.*
