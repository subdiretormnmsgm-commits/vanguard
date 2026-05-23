---
name: vanguard-doc-sync
description: >
  Use esta skill quando o Músculo ou o Diretor pedir para auditar, atualizar e
  sincronizar todos os documentos da pasta Vanguard. Triggers: "atualiza os docs",
  "sincroniza a pasta", "rodada de sync", "documentos desatualizados", "auditoria
  de documentos", "garante que tudo está atualizado", ou qualquer pedido de revisão
  global da base de conhecimento do Pentalateral IAH.

  Esta skill executa TRÊS rodadas obrigatórias em sequência — nenhuma é pulável.
  Ao final, todo documento em PENTALATERAL_UNIVERSAL deve estar espelhado com
  exatidão nos projetos ativos. Dois documentos divergentes = zero documentos
  confiáveis. Acionar sempre que surgir suspeita de desatualização.
---

# Vanguard Doc Sync — Skill do Auditor para o Músculo

## Por que esta skill existe

O maior risco silencioso do Pentalateral IAH é o Auditor (NotebookLM) ler
fontes velhas e gerar Skill baseada em premissas obsoletas. Um loop que começa
com inteligência contaminada contamina todos os outputs subsequentes.

Esta skill resolve isso com um script executável. O Músculo roda o script —
não narra o processo. O relatório final é gerado automaticamente.

**Princípio raiz:** P-033 — "Sync universal → projetos é obrigatório e imediato."

---

## COMO EXECUTAR (Músculo — Claude Code)

### Passo 1 — Rodar o sync

```powershell
# Windows (PowerShell)
.\scripts\sync_vanguard_docs.ps1

# Ou com parâmetros opcionais:
.\scripts\sync_vanguard_docs.ps1 -cliente VALDECE          # só um projeto
.\scripts\sync_vanguard_docs.ps1 -modo verificar           # só Rodada 1 (inventário sem alterar nada)
.\scripts\sync_vanguard_docs.ps1 -modo completo            # padrão — 3 rodadas
.\scripts\sync_vanguard_docs.ps1 -verbose                  # mostra cada arquivo processado
```

```bash
# Linux/Mac (bash)
bash scripts/sync_vanguard_docs.sh
bash scripts/sync_vanguard_docs.sh --cliente VALDECE
bash scripts/sync_vanguard_docs.sh --modo verificar
bash scripts/sync_vanguard_docs.sh --verbose
```

### Passo 2 — Ler o relatório gerado

```powershell
# O relatório é salvo automaticamente em:
cat SYNC_REPORT_$(Get-Date -Format "yyyyMMdd").md

# Ou abrir diretamente:
notepad SYNC_REPORT_$(Get-Date -Format "yyyyMMdd").md
```

### Passo 3 — Resolver órfãos (se houver)

O relatório lista arquivos marcados como `🔴 ÓRFÃO`. O Músculo apresenta
ao Diretor e aguarda veredito: **deletar** ou **promover para UNIVERSAL**.

```powershell
# Após veredito do Diretor — promover órfão para a universal:
.\scripts\sync_vanguard_docs.ps1 -promover "NOME_DO_ARQUIVO.md" -destino "PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE\"

# Após veredito do Diretor — deletar órfão:
.\scripts\sync_vanguard_docs.ps1 -deletar "CLIENTES\PROJETO\NOTEBOOKLM_FONTES\NOME_DO_ARQUIVO.md"
```

---

## ESTRUTURA DE PASTAS ESPERADA

```
PENTALATERAL_UNIVERSAL\
└── NOTEBOOKLM_BASE\              ← Fonte de verdade. Nunca editar aqui sem sync.
    ├── 00_MEMORANDO.md
    ├── 01_SKILL_PROTOCOLO_VANGUARD.md
    ├── 02_INTELLIGENCE_LEDGER.md
    ├── 03_SOP_VANGUARD_MASTER.md
    ├── 04_VANGUARD_TIMELINE.md
    ├── 05_AVISO_ARQUITETO.md
    ├── 06_ALERTA_CONFLITO.md
    ├── 07_MODELO_AQUISICAO.md
    ├── 08_VANGUARD_BUSINESS_RULES.md
    ├── 09_PASSO3_GEMINI_TEMPLATE.md
    ├── 10_PASSO5_NOTEBOOKLM_TEMPLATE.md
    ├── 11_PASSO6_MUSCULO_TEMPLATE.md
    ├── 12_PASSO7_EMBAIXADOR_TEMPLATE.md
    └── [outros documentos universais]

CLIENTES\
├── VALDECE\
│   └── NOTEBOOKLM_FONTES\        ← Cópia sincronizada. O Auditor lê daqui.
│       └── [espelho exato da NOTEBOOKLM_BASE]
├── INGRID\
│   └── NOTEBOOKLM_FONTES\
│       └── [espelho exato da NOTEBOOKLM_BASE]
└── [outros projetos]\
    └── NOTEBOOKLM_FONTES\
```

---

## AS TRÊS RODADAS — O QUE O SCRIPT FAZ INTERNAMENTE

O Músculo não orquestra as rodadas manualmente. O script faz tudo.

**Rodada 1 — Inventário (read-only)**
Varre `PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE\` e todos os projetos em
`CLIENTES\*\NOTEBOOKLM_FONTES\`. Compara hashes SHA256. Classifica:
`✅ SYNC` | `⚠️ DESATUALIZADO` | `❌ AUSENTE` | `🔴 ÓRFÃO`

**Rodada 2 — Sincronização**
Copia e substitui tudo que não está SYNC. Fluxo obrigatório: UNIVERSAL → PROJETO.
Órfãos não são deletados — ficam no relatório para o Diretor decidir.

**Rodada 3 — Verificação de integridade**
Re-lê cada arquivo sincronizado e compara hashes novamente. Se divergência
for encontrada: re-sincroniza e registra. Nenhuma suposição — tudo verificado.

---

## REGRAS QUE O SCRIPT NUNCA VIOLA

1. **Fluxo sempre UNIVERSAL → PROJETO.** Cópia jamais sobrescreve fonte.
2. **Nunca deletar órfãos automaticamente.** Sempre escalar para o Diretor.
3. **Nunca criar duplicatas.** Um arquivo, um nome, um lugar.
4. **Nunca renomear.** O nome é o que o NotebookLM usa para indexar.
5. **Nunca sobrescrever com arquivo mais antigo.** Hash + timestamp juntos.

---

## QUANDO EXECUTAR

| Gatilho | Momento |
|---|---|
| Início de cada novo loop | Antes do Passo 3 (Gemini) |
| Após editar qualquer doc universal | Imediato — não esperar o loop |
| Antes de carregar fontes no NotebookLM | Pré-requisito do Passo 5 |
| Ao suspeitar de desatualização | Imediato |
| Ao abrir novo projeto cliente | Após criar a pasta NOTEBOOKLM_FONTES\ |

---

## RELATÓRIO — FORMATO DO OUTPUT GERADO

O script salva `SYNC_REPORT_YYYYMMDD.md` na raiz do projeto:

```
VANGUARD DOC SYNC — RELATÓRIO [DATA]

INVENTÁRIO:
✅ SYNC:          [N] arquivos
⚠️ DESATUALIZADO: [N] arquivos → sincronizados nesta rodada
❌ AUSENTE:        [N] arquivos → criados nesta rodada
🔴 ÓRFÃO:          [N] arquivos → aguardando veredito do Diretor

PROJETOS PROCESSADOS: VALDECE | INGRID | [outros]

STATUS FINAL:
INTEGRIDADE: [VERDE / AMARELO / VERMELHO]

DECISÕES PENDENTES PARA O DIRETOR:
🔴 CLIENTES\INGRID\NOTEBOOKLM_FONTES\ARQUIVO.md
   → Não tem correspondente em PENTALATERAL_UNIVERSAL
   → Ação necessária: deletar | promover para universal
```

---

## REFERÊNCIA AOS SCRIPTS

Os scripts estão em `scripts/` nesta pasta da skill:

| Arquivo | Plataforma | Uso |
|---|---|---|
| `sync_vanguard_docs.ps1` | Windows PowerShell | Principal — uso diário |
| `sync_vanguard_docs.sh` | Linux / Mac bash | Alternativo |

---

*Skill criada por: Auditor (NotebookLM) — elaborada pelo Formalizador (Claude Projects)*
*Baseada em: P-033 — Sync universal → projetos é obrigatório e imediato*
*Versão: 1.0 · 2026-05-19*
