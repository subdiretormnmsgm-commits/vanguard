# PROTOCOLO DE ENCERRAMENTO — PENTALATERAL IAH
> Template fixo. Preenchido pelo Músculo ao fechar cada sessão.
> Enviado por e-mail ao Diretor + usado pelo Embaixador como artefato de gestão.
> Versão: 1.0 · Atualizado: 2026-05-24

---

## CABEÇALHO

| Campo | Valor |
|---|---|
| **Data** | `YYYY-MM-DD` |
| **Sessão Nº** | `[S-NNN]` *(sequencial por projeto ativo)* |
| **Projetos ativos** | `[CLIENTE-A · Loop N] · [CLIENTE-B · Loop N]` |
| **Commit** | `[hash]` — N arquivos |
| **Próxima sessão agendada** | `YYYY-MM-DD ou "não agendada"` |

---

## BLOCO 1 — ENTREGAS DO DIA

> O que foi construído, corrigido ou documentado nesta sessão.
> Status: ✅ Concluído · ⚠️ Parcial (motivo) · ❌ Bloqueado (motivo)

| # | Entrega | Tipo | Status |
|---|---|---|---|
| 1 | `[descrição]` | `BUILD / DOC / PROCESSO / BUG` | ✅ |
| 2 | `[descrição]` | | ⚠️ `[motivo]` |
| 3 | `[descrição]` | | ❌ `[bloqueio]` |

**Total: N entregues · N parciais · N bloqueadas**

---

## BLOCO 2 — ALERTAS EMITIDOS

> Registrar TODOS os alertas — críticos, técnicos e de processo.
> Alertas sem Veredito do Diretor permanecem abertos na próxima sessão.

| Prioridade | Alerta | Veredito |
|---|---|---|
| 🔴 CRÍTICO | `[descrição]` | `Pendente / [decisão do Diretor]` |
| 🟡 TÉCNICO | `[descrição]` | `Pendente / [decisão do Diretor]` |
| 🔵 PROCESSO | `[descrição]` | `Pendente / [decisão do Diretor]` |

---

## BLOCO 3 — PENDENTES POR PROJETO

> Lista consolidada de TODOS os pendentes abertos — não apenas os desta sessão.
> Fonte: `PENDENTES.md` (atualizado em tempo real).

### [PROJETO-CLIENTE-A] — Deadline: `YYYY-MM-DD · N dias`

| Prioridade | Tarefa | Responsável | Prazo |
|---|---|---|---|
| 🔴 | `[tarefa]` | Músculo / Eduardo / Embaixador | `YYYY-MM-DD` |
| 🟡 | `[tarefa]` | | |
| ⬜ | `[tarefa]` | | |

### [PROJETO-CLIENTE-B] — Deadline: `YYYY-MM-DD · N dias`

| Prioridade | Tarefa | Responsável | Prazo |
|---|---|---|---|
| 🔴 | `[tarefa]` | | |

### PROCESSO / INFRA

| Prioridade | Tarefa | Responsável | Prazo |
|---|---|---|---|
| 🟡 | `[tarefa]` | | |

**Total pendentes: N · Concluídos hoje: N**

---

## BLOCO 4 — PRÓXIMOS GATES

> Gate = evento que desbloqueia a próxima fase. Nenhum gate = processo parado.

| Gate | Projeto | Prazo | Desbloqueado por |
|---|---|---|---|
| `[nome do gate]` | `[cliente]` | `YYYY-MM-DD` | `Eduardo / Músculo / Cliente` |

---

## BLOCO 5 — AÇÃO DO DIRETOR

> Somente o que Eduardo precisa fazer. Nada que o Músculo resolve sozinho aparece aqui.
> Máximo 5 ações. Se tiver mais, priorizar.

| # | Ação | Urgência | Prazo |
|---|---|---|---|
| ① | `[ação específica]` | 🔴 Hoje | `YYYY-MM-DD` |
| ② | `[ação específica]` | 🟡 Esta semana | |
| ③ | `[ação específica]` | ⬜ Quando disponível | |

---

## BLOCO 6 — AUDITORIA NOTEBOOKLM

> Documentos das NOTEBOOKLM_FONTES auditados ao fechar sessão.
> Fonte: `CLIENTES/[NOME]/NOTEBOOKLM_FONTES/`

| Status | Documento | Ação necessária |
|---|---|---|
| ✅ Em dia | `[nome]` | — |
| ⚠️ Desatualizado | `[nome]` | `[o que falta]` |
| ❌ Ausente | `[nome]` | `[criar na próxima sessão]` |

**Wipe & Sync necessário:** `Sim / Não` · Projetos: `[lista]`

---

## BLOCO 7 — ESTADO DO LOOP (por projeto)

> Snapshot do ciclo Pentalateral atual para cada projeto ativo.

### [CLIENTE-A] · Loop N

| Etapa | Status | Artefato |
|---|---|---|
| Gemini (PASSO 3) | ✅ / ⏳ / ❌ | `DIRETRIZ_VN.txt` |
| NotebookLM (PASSO 5) | | `[cliente]-vN.md` |
| Embaixador (PASSO 7) | | `PASSO7_EMBAIXADOR.md` |
| Músculo (Execução) | | `Dia N concluído` |
| Fechamento do Loop | | `MEMORIA_VN + relatorio_VN` |

---

## RODAPÉ

```
Músculo — Pentalateral IAH
Sessão encerrada: YYYY-MM-DD HH:MM
Próxima prioridade: [uma linha]
```

---

> **FLUXO DE ENCERRAMENTO:**
> 1. Músculo preenche este protocolo e envia por e-mail ao Diretor
> 2. Diretor copia o protocolo e envia ao Embaixador (Claude Projects)
> 3. Embaixador cria/atualiza o artefato `PAINEL_ATIVIDADES.md` com:
>    (a) Resumo executivo em 3 bullets: o que avançou · o que está em risco · o que o Diretor decide
>    (b) Tabela de pendentes por projeto com semáforo visual (🔴🟡✅)
>    (c) Próxima ação do Diretor em destaque — única, clara, com prazo
> 4. Embaixador retorna o artefato atualizado ao Diretor
>
> O artefato é cumulativo — reflete sempre o estado mais recente de TODOS os projetos.
> O Diretor gerencia as atividades a partir do PAINEL_ATIVIDADES atualizado pelo Embaixador.
