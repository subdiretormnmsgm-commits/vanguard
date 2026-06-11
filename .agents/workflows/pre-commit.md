---
name: pre-commit-firewall
description: Verifica conformidade com AGENTS.md antes de qualquer commit proposto pelo Antigravity. Bloqueia se arquivo da lista R-01 está no diff.
version: "1.0"
created: "2026-06-11"
trigger: before_commit
---

# PRE-COMMIT FIREWALL — PENTALATERAL IAH

> Este workflow é executado automaticamente antes de qualquer proposta de commit
> pelo Antigravity. Não substitui o .git/hooks/post-commit — este é o gate
> do agente, aquele é o gate do git.

---

## VERIFICAÇÃO R-01 — ARQUIVOS PROIBIDOS

Antes de propor qualquer `git add` + `git commit`, o Antigravity:

### Passo 1 — Inventariar o diff proposto

```
Listar todos os arquivos que seriam incluídos no commit:
  - git status --short
  - git diff --name-only HEAD
```

### Passo 2 — Cruzar com R-01 do AGENTS.md

Para cada arquivo no diff, verificar se está em qualquer bloco R-01:

```python
R01_PATTERNS = [
    "INTELLIGENCE_LEDGER.md",
    "PENDENTES.md",
    "WIP_BOARD.json",
    "DEPENDENCY_MAP.json",
    "CLAUDE.md",
    "GEMINI.md",
    "AGENTS.md",
    "scripts/session_close.ps1",
    "scripts/session_start.ps1",
    "scripts/briefing_diario.ps1",
    "scripts/validate_scripts.ps1",
    "PENTALATERAL_UNIVERSAL/**",
    "CLIENTES/INGRID/**",
    "CLIENTES/VALDECE/**",
    "CLIENTES/MUMUZINHO/**",
    "CLIENTES/*/CLAUDE_PROJECT/**",
    ".claude/hooks/**",
    ".claude/skills/vanguard-*.md",
    ".git/hooks/**",
]
```

### Passo 3 — Bloquear se match encontrado

Se qualquer arquivo do diff match R-01:

```
[PRE-COMMIT BLOQUEADO]
Arquivo(s) R-01 detectado(s) no diff:
  — [arquivo 1]
  — [arquivo 2]

Ação: CANCELAR commit.
Reportar ao Músculo: "[ANTIGRAVITY] tentativa de commit em arquivo R-01 bloqueada."
Inserir em PENDING_REVIEW.md: data + arquivo + motivo da proposta original.
```

### Passo 4 — Proceder somente se diff limpo

Se nenhum arquivo R-01 no diff:

```
[PRE-COMMIT OK] Diff limpo — nenhum arquivo R-01 detectado.
Prosseguir com proposta de commit para o Músculo revisar.
Lembrar: O Músculo executa o commit — o Antigravity apenas propõe.
```

---

## FORMATO DA PROPOSTA DE COMMIT (após gate limpo)

```
[ANTIGRAVITY-EXECUTOR] PROPOSTA DE COMMIT
Data: [data]
Arquivos a commitar:
  — [arquivo 1] (+N/-M linhas)
  — [arquivo 2] (+N/-M linhas)
Mensagem sugerida: "[tipo]([escopo]): [descrição]"
[RESOLVE: keyword] se aplicável

Aguardando aprovação do Músculo para executar.
```

---

## HISTÓRICO

v1.0 (2026-06-11): criado no ATO 3 do Loop 33 — gate pré-commit para Antigravity.
