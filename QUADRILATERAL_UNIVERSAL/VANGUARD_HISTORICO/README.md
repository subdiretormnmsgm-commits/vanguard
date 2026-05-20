# VANGUARD HISTORICO — V1 a V24
**Arquivo longitudinal do projeto Vanguard Tech**
**Início:** 2026 · **Versão atual:** V24

---

> Esta pasta contém os artefatos históricos e específicos do projeto Vanguard.
> Não misturar com o QUADRILATERAL_UNIVERSAL — aquele é o modelo portátil,
> esta pasta é o que aconteceu de verdade no Vanguard V1–V24.

---

## Estrutura

```
VANGUARD_HISTORICO/
├── MEMORIAS/           ← MEMORIA_VXX.md de cada versão
├── RELATORIOS/         ← relatorio_evolutivo_vXX.md de cada versão
└── SESOES/             ← PARECER_TECNICO, ALERTA_CONFLITO, CONSELHO_SESSAO por sessão
```

---

## O que NÃO fica aqui (fica na raiz ou em scripts/)

| Arquivo | Motivo para ficar na raiz |
|---|---|
| `VANGUARD_INNOVATION_AUDIT.md` | Referenciado por `fechar_versao.ps1` + `atualizar_notebooklm.ps1` |
| `INTELLIGENCE_LEDGER.md` | `session_close.ps1` escreve nele (path fixo `$BASE\`) |
| `knowledge_graph.json` | `alert_daily_briefing.ps1` + `session_close.ps1` lêem/escrevem |
| `ALERTA_CONFLITO.md` | Protocolo ativo — precisa estar visível na raiz |
| `PARECER_UNIFICADO.md` | Template ativo — precisa estar visível na raiz |
| `.claude/meta/friction.log` | Gerado internamente pelo Claude Code |

---

## Como usar ao fechar cada versão

1. `fechar_versao.ps1` gera e organiza automaticamente a maioria dos arquivos
2. Após o fechamento, mover `MEMORIA_VXX.md` → `MEMORIAS/`
3. Após o fechamento, mover `relatorio_evolutivo_vXX.md` → `RELATORIOS/`
4. PARECERs e sessões importantes → `SESOES/`

---

## Linha do Tempo

| Versão | Missão | Data |
|---|---|---|
| V1–V13 | Fundação → Outbound → Arbitragem | 2026 |
| V14–V18 | Otimização → Pixel de Intenção → MRR | 2026 |
| V19–V22 | Edge Domination → Autonomy | 2026-05-10 |
| V23 | The Revenue Strike | 2026-05-10 |
| V24 | Meta-Intelligence Singularity | 2026-05-12 |
