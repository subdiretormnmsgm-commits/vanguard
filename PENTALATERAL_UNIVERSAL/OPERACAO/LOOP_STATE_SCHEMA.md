# LOOP_STATE — Schema Universal v1.0
> Documento: `PENTALATERAL_UNIVERSAL/OPERACAO/LOOP_STATE_SCHEMA.md`
> Versão: 1.0 · Criado: 2026-06-07 · Pentalateral IAH
> Uso: template universal copiado para `CLIENTES/[NOME]/CLAUDE_PROJECT/LOOP_STATE.json` por cliente

---

## O QUE É O LOOP_STATE

O LOOP_STATE é o arquivo de estado de loop por cliente. Resolve o problema de amnésia pós-compactação de contexto: quando o Claude Code compacta a conversa, o Músculo perde o rastreamento de qual fase do loop cada projeto está. Com o LOOP_STATE em disco, o estado é durável.

**Princípio:** WIP_BOARD.json rastreia projetos. LOOP_STATE.json rastreia fases internas do loop de cada projeto.

---

## CAMPOS DO SCHEMA

### Identificação

| Campo | Tipo | Descrição |
|---|---|---|
| `schema_version` | string | Versão do schema (atualmente "1.0") |
| `cliente` | string | Nome do cliente em MAIÚSCULAS (INGRID, VALDECE, VANGUARD) |
| `loop_atual` | número | Número do loop em curso |
| `loop_status` | enum | Estado geral do loop: `CONCLUIDO` / `EM_BUILD` / `BLOQUEADO` |
| `fase_atual` | enum | Fase ativa: `GEMINI_PENDENTE` / `NOTEBOOKLM_PENDENTE` / `EMBAIXADOR_PENDENTE` / `MUSCULO_PENDENTE` / `LOOP_ENCERRADO` |

---

### Bloco SOCIOS

Rastreia o status de cada membro do Pentalateral no loop atual.

Cada sócio tem 4 campos:

| Campo | Tipo | Descrição |
|---|---|---|
| `status` | enum | `PENDENTE` / `OK` / `BLOQUEADO` |
| `artefato` | string | Caminho em disco do artefato que evidencia conclusão |
| `data_conclusao` | string/null | Data de conclusão no formato YYYY-MM-DD (null se pendente) |
| `proximo` | string/null | Próxima instrução para este sócio (null se concluído) |

**Sócios rastreados:**

- **gemini** — artefato: `CLIENTES/[NOME]/NOTEBOOKLM_FONTES/12_DIRETRIZ_GEMINI_V[N].txt`
- **notebooklm** — artefato: `.claude/skills/[cliente]-v[N].md`
- **embaixador** — artefato: `CLIENTES/[NOME]/CLAUDE_PROJECT/MEMORIA_EMBAIXADOR.md`
- **musculo** — artefato: `CLIENTES/[NOME]/HISTORICO/DELIBERACAO_LOOP_V[N]_[NOME].md`

**Regra P-091:** O Músculo só declara `status: OK` se o artefato existir em disco. `OK` sem arquivo = inconsistência bloqueante.

---

### Bloco GATES

Gates de processo que devem ser verdadeiros antes de fechar o loop.

| Gate | Princípio | O que verifica |
|---|---|---|
| `p045_memoria_anterior_existe` | P-045 | MEMORIA e relatorio do loop anterior existem em disco |
| `p037_deliberacao_concluida` | P-037 | Síntese Músculo pós-Embaixador gerada antes do DECISOES.json |
| `p032_memoria_embaixador_atualizada` | P-032 | MEMORIA_EMBAIXADOR atualizada no mesmo dia dos vereditos |
| `p087_resolve_commitado` | P-087 | Commit com `[RESOLVE: keyword]` realizado |

**Regra:** `pre_loop_action.ps1` valida todos os gates antes de avançar para novo loop.

---

### Bloco CONTEXTO_SNAPSHOT

Informações de contexto do cliente no momento da última atualização.

| Campo | Tipo | Descrição |
|---|---|---|
| `cliente_temperatura` | enum | `FRIA` / `MORNA` / `AQUECENDO` / `QUENTE` / `CRITICA` |
| `ultimo_contato_cliente` | string | Data do último contato no formato YYYY-MM-DD |
| `proximo_gate_externo` | string | Descrição do próximo gate que depende do cliente |
| `prazo` | string | Data limite do gate externo |
| `observacoes` | string | Notas livres sobre o estado atual |

---

### Campos finais

| Campo | Tipo | Descrição |
|---|---|---|
| `pendentes_abertos` | array | Lista de pendências abertas do loop atual (strings descritivas) |
| `ultima_atualizacao` | string | Data da última atualização do arquivo (YYYY-MM-DD) |
| `proxima_acao_musculo` | string | O que o Músculo faz ao retomar esta sessão |
| `proxima_acao_diretor` | string | O que o Diretor precisa fazer antes do próximo loop |

---

## SCRIPTS DE AUTOMAÇÃO

### pre_loop_action.ps1

**Quando usar:** antes de iniciar novo loop  
**Parâmetros:** `-cliente [NOME]` · `-AutoAvancar` (opcional)  
**O que faz:**
1. Lê LOOP_STATE.json do cliente
2. Verifica `loop_status = CONCLUIDO` (gate P-045)
3. Verifica que cada artefato marcado OK existe em disco (gate P-091)
4. Verifica gates P-037, P-032, P-087
5. Reporta `PRONTO` ou `BLOQUEADO` com motivo
6. Com `-AutoAvancar`: incrementa loop_atual, reseta todos sócios para PENDENTE

### post_loop_action.ps1

**Quando usar:** após concluir fase de um sócio  
**Parâmetros:** `-cliente [NOME]` · `-socio [gemini|notebooklm|embaixador|musculo]` · `-artefato [caminho]` · `-data [YYYY-MM-DD]` · `-FecharLoop` (opcional)  
**O que faz:**
1. Atualiza status do sócio para OK
2. Registra artefato e data de conclusão
3. Determina nova fase_atual
4. Sincroniza WIP_BOARD.json
5. Com `-FecharLoop`: muda loop_status para CONCLUIDO

---

## INSTÂNCIAS ATIVAS

| Cliente | Arquivo | Loop Atual | Status |
|---|---|---|---|
| INGRID | `CLIENTES/INGRID/CLAUDE_PROJECT/LOOP_STATE.json` | Loop 8 | CONCLUIDO |
| VALDECE | `CLIENTES/VALDECE/CLAUDE_PROJECT/LOOP_STATE.json` | Loop 7 | CONCLUIDO + HYPERCARE até 2026-06-18 |
| VANGUARD | `CLIENTES/VANGUARD/CLAUDE_PROJECT/LOOP_STATE.json` | Loop 29 | EM_BUILD |

---

## REGRA DE ATUALIZAÇÃO

O Músculo atualiza o LOOP_STATE imediatamente após cada fase concluída — não ao fechar sessão. Estado em arquivo = estado real. WIP_BOARD.json é atualizado em paralelo via `post_loop_action.ps1`.

**Nunca:** declarar sócio OK no LOOP_STATE sem artefato em disco.  
**Nunca:** fechar loop sem gates P-045 e P-037 verdadeiros.
