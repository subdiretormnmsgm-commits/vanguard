---
name: quadrilateral-editor
description: >
  Use quando o Músculo precisar criar, editar ou promover qualquer documento em
  PENTALATERAL_UNIVERSAL/ ou nos arquivos críticos da raiz (INTELLIGENCE_LEDGER.md,
  WIP_BOARD.json, ANALISE_SOCIO_ATUAL.txt). Triggers: "atualizar o ledger",
  "adicionar princípio", "editar protocolo", "atualizar template", "promover para
  universal", "modificar QUADRILATERAL", "atualizar documento base".
  O hook P-033 dispara o sync automaticamente após cada edição — o Músculo nunca
  roda o sync manualmente.
---

# Quadrilateral Editor — Protocolo de Modificação de Documentos

## Regra Fundamental

**Fluxo obrigatório: UNIVERSAL → PROJETO. Nunca o inverso.**

Editar sempre em `PENTALATERAL_UNIVERSAL/` ou nos arquivos críticos da raiz.
O hook `p033_sync_guardian.ps1` detecta a edição e propaga para todos os
`CLIENTES/*/NOTEBOOKLM_FONTES/` automaticamente. Nenhuma ação manual necessária.

---

## Mapa de Arquivos — Onde Editar Cada Tipo de Conteúdo

### Arquivos Críticos da Raiz (disparam sync automático)

| Arquivo | Editar quando |
|---|---|
| `INTELLIGENCE_LEDGER.md` | Novo princípio P-XXX extraído de fricção real |
| `CLIENTES/WIP_BOARD.json` | Status, gates, delivery_dates, loops de qualquer projeto |
| `CONSELHO/NotebookLM/ANALISE_SOCIO_ATUAL.txt` | Análise do Sócio atualizada pelo Diretor |

### PENTALATERAL_UNIVERSAL\NOTEBOOKLM_BASE\ — Base do Auditor

Estes 9 arquivos numerados são o que o NotebookLM lê em todo projeto. São a
fonte de verdade do Conselho. Editar com cuidado — qualquer mudança propaga
para 100% dos projetos ativos na próxima sessão do Auditor.

| Arquivo | Conteúdo |
|---|---|
| `00_INSTRUCAO_AUDITOR.md` | Prompt de instrução do Auditor |
| `01_SKILL_PROTOCOLO_VANGUARD.md` | Processo operacional completo do Pentalateral |
| `02_MEMORANDO_PENTALATERAL_UNIVERSAL.md` | Constituição e identidade do Quadrilateral |
| `03_MANUAL_DIRETOR.md` | Manual de operação para o Diretor |
| `04_INTELLIGENCE_LEDGER.md` | Cópia do LEDGER sincronizada |
| `05_PROCESSO_EVOLUTIVO_QUADRILATERAL.md` | Loop evolutivo documentado |
| `06_TEMPLATES_COMUNICACAO_QUADRILATERAL.md` | Templates PASSO3/5/7 e formatos fixos |
| `07_WIP_BOARD.txt` | Cópia do WIP_BOARD sincronizada |
| `08_ANALISE_SOCIO_ATUAL.txt` | Cópia da análise do Sócio sincronizada |

### PENTALATERAL_UNIVERSAL\OPERACAO\ — Templates e Processos

Documentos operacionais: templates de fase, SOPs, avisos, processos.
Sincronizados para NOTEBOOKLM_FONTES/ de todos os projetos ativos.

| Arquivo | Editar quando |
|---|---|
| `SKILL_PROTOCOLO_VANGUARD.md` | Processo muda (novo passo, novo membro, P-XXX bloqueante) |
| `PASSO3_GEMINI_TEMPLATE.md` | Template do PASSO3 evolui |
| `PASSO5_NOTEBOOKLM_TEMPLATE.md` | Template do PASSO5 evolui |
| `PASSO7_EMBAIXADOR_TEMPLATE.md` | Template do Embaixador evolui |
| `TEMPLATES_COMUNICACAO_QUADRILATERAL.md` | Formato de MEMORIA/RELATORIO/DIRETRIZ muda |
| `AVISO_ARQUITETO.md` / `AVISO_EMBAIXADOR.md` | Alertas estruturais dos membros |
| `BIBLIOTECA_MANAGEMENT.md` | Novos frameworks de gestão identificados |
| `VANGUARD_BUSINESS_RULES.md` | Regras de negócio da Vanguard mudam |

### Pastas Excluídas do Sync Universal (por padrão)

| Pasta | Motivo da exclusão |
|---|---|
| `PERFIS_NICHO/` | Conteúdo de nicho — incluir com `-incluirNichos LEGALTECH_PENAL` |
| `VANGUARD_HISTORICO/` | Histórico arquivado — não relevante para o Auditor ativo |

---

## Protocolo de Edição — Passo a Passo

### Caso 1: Atualizar arquivo existente

```
1. Ler o arquivo antes de editar (obrigatório para o Edit tool)
2. Editar com Edit tool
3. Hook P-033 detecta e roda sync automaticamente
4. Ver output: "[P-033] X arquivos sincronizados · INTEGRIDADE: VERDE"
```

Nenhum passo adicional. O Diretor não precisa fazer nada.

### Caso 2: Criar novo arquivo em PENTALATERAL_UNIVERSAL/

```
1. Decidir a subpasta correta (tabela acima)
2. Criar com Write tool
3. Hook P-033 propaga para todos os NOTEBOOKLM_FONTES/ automaticamente
4. Verificar: o arquivo aparece em CLIENTES/*/NOTEBOOKLM_FONTES/
```

Convenção de nome: `NOME_EM_MAIUSCULAS_COM_UNDERSCORE.md`
Para NOTEBOOKLM_BASE: adicionar prefixo numérico `09_NOME.md` (próximo da sequência)

### Caso 3: Promover arquivo de projeto para Universal

Quando um documento criado para um cliente específico deve virar universal:

```
1. Obter VEREDITO DO DIRETOR: "este documento serve todos os projetos futuros?"
2. Copiar para a subpasta correta de PENTALATERAL_UNIVERSAL/
3. Hook propaga automaticamente
4. Deletar cópia local do projeto (evitar duplicata)
```

**Nunca promover sem veredito do Diretor. Conteúdo projeto-específico contamina o Auditor.**

### Caso 4: Deletar arquivo da Universal

```
1. Obter veredito do Diretor
2. Usar: sync_vanguard_docs.ps1 -deletar "CLIENTES\PROJETO\NOTEBOOKLM_FONTES\arquivo.md"
   (para remover das cópias de projetos)
3. Deletar da PENTALATERAL_UNIVERSAL/
```

---

## Output Esperado do Hook P-033

Após cada edição em arquivo que dispara sync:

```
[P-033] SKILL_PROTOCOLO_VANGUARD.md modificado — sync iniciado automaticamente...
  Sincronizados nesta rodada: 3
  Orfaos:    0 arquivo(s)
  INTEGRIDADE: VERDE
[P-033] NOTEBOOKLM_FONTES/ sincronizado.
```

Se aparecer `INTEGRIDADE: AMARELO` → há órfãos. Escalar ao Diretor para veredito.
Se aparecer `INTEGRIDADE: VERMELHO` → falha de cópia. Rodar sync completo manual.

---

## Arquivos que NÃO Disparam Sync

Edições em `CLIENTES/*/CLAUDE_PROJECT/`, `CLIENTES/*/frontend/`, `CLIENTES/*/supabase/`,
`scripts/`, `.claude/hooks/`, `.claude/skills/` (exceto skills dentro de PENTALATERAL_UNIVERSAL)
não disparam P-033. Sync só é necessário quando o conteúdo deve ir para o Auditor.

---

*Skill criada por: Músculo — P-033 enforcement automático*
*Hook: `.claude/hooks/p033_sync_guardian.ps1`*
*Versão: 1.0 · 2026-05-20*
