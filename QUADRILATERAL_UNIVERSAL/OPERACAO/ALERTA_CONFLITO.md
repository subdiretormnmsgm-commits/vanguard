# PROTOCOLO — ALERTA DE CONFLITO TÉCNICO
**Sovereign Veto — Constituição de Processo do Quadrilateral IAH**
**Versão:** 1.0 · Organismo Vivo

---

> Este documento define o protocolo de veto técnico do Músculo (Claude Code).
> Quando um conflito real ocorrer em um projeto, copie este protocolo e crie
> um `ALERTA_CONFLITO_[PROJETO].md` na raiz do projeto específico.

---

## AS TRÊS CAMADAS DO VETO

```
Camada 1 — Soft Signal  [SV-X]
  · Flag no PARECER TÉCNICO
  · Cooling de 1 sessão antes de construir
  · Diretor pode continuar se confirmar ciência do risco

Camada 2 — Hard Block   [HV-X]
  · ALERTA_CONFLITO_[PROJETO].md criado
  · Processo paralisa completamente
  · Requer resolução documentada antes de qualquer build

Camada 3 — Override Documentado
  · Diretor assina o risco explicitamente
  · Registrado no friction.log com severidade HIGH
  · 3 overrides do mesmo tipo → novo princípio gerado automaticamente
```

---

## QUANDO EMITIR CADA CAMADA

| Situação | Camada |
|---|---|
| Feature viola simplicidade mas o prazo é real | SV (Camada 1) |
| Instrução viola segurança ou dado do cliente | HV (Camada 2) |
| Arquitetura proposta gera dívida irreversível | HV (Camada 2) |
| Gemini propõe infra que não existe em produção | SV (Camada 1) |
| Dado usado como base é estimado, não real | HV (Camada 2) |
| Feature não tem ROI calculável | SV (Camada 1) |

---

## TEMPLATE DE INSTÂNCIA (copiar quando emitir veto real)

```markdown
# ALERTA DE CONFLITO TÉCNICO — [PROJETO]
Emitido: YYYY-MM-DD | Sessão: [VXX] | Camada: [1-SV / 2-HV]

## Instrução Vetada
[copie exatamente]

## Violação
Princípio: [P-00X] | Lei: [nome ou null] | Severidade: [HIGH/MEDIUM]

## Problema
[3-5 linhas objetivas]

## Contraproposta
[o que construir em vez disso]

## Resolução
- [ ] Contraproposta aceita → Músculo implementa
- [ ] Override → Diretor assina abaixo
- [ ] Conselho → emitir PARECER_UNIFICADO

Override (se aplicável):
> Diretor: ___ | Data: ___ | Risco aceito: ___ | Revisão em: ___
```

---

## RASTREAMENTO DE OVERRIDES

> 3 overrides do mesmo tipo de problema = padrão de comportamento.
> Quando atingir 3, o Músculo gera um novo princípio no INTELLIGENCE_LEDGER automaticamente.

| Override | Projeto | Tipo | Data | Revisado? |
|---|---|---|---|---|
| — | — | — | — | — |

---

## NOTA CI/CD

Quando o pipeline de deploy estiver ativo, adicionar verificação:
```yaml
- name: Bloquear deploy se ALERTA_CONFLITO ativo
  run: |
    for f in ALERTA_CONFLITO_*.md; do
      [ -f "$f" ] && grep -q "BLOQUEADO" "$f" && echo "Deploy bloqueado." && exit 1
    done
```
*Hook inativo até pipeline existir em produção.*
