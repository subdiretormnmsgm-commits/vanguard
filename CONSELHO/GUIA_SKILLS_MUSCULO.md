# GUIA DE USO DAS SKILLS DO MÚSCULO
> Atualizado 2026-06-12 — 11 skills instaladas (S-4 revisado + S-3)
> Para mapa operacional completo de gatilhos: `CONSELHO/SKILLS_GATILHOS.md`
> Atualizar quando nova skill for instalada ou o comportamento mudar.

---

## O QUE SÃO SKILLS

Skills são módulos de comportamento especializado instalados em `.claude/skills/`.
Quando ativadas, sobrescrevem o comportamento padrão do Músculo para uma tarefa específica.
O Músculo invoca skills automaticamente quando o contexto se encaixa — o Diretor não precisa pedir.

**Como invocar manualmente:** digitar `/nome-da-skill` no chat.
**Como ver a lista completa:** `ls .claude/skills/` no terminal.

---

## SKILLS ESSENCIAIS DO PENTALATERAL

### `/brainstorming`
**Quando usar:** antes de qualquer tarefa de criação — novo feature, nova tela, nova automação.
**O que faz:** força o Músculo a perguntar e explorar o espaço do problema ANTES de escrever código.
**Gate obrigatório:** o Músculo NÃO pode codificar antes de apresentar um design e receber aprovação.
**Gatilho automático:** sempre que o Diretor propõe uma nova funcionalidade.
**Usar quando:** "quero construir X", "adiciona Y no sistema", "precisamos de Z".

---

### `/ultrathink-trigger` (alias: `/ultrathink`)
**Quando usar:** problemas com múltiplos arquivos, arquitetura, debug com >=2 tentativas falhas, segurança.
**O que faz:** escala o nível de raciocínio do Músculo — mais tempo pensando antes de agir.
**Escala de complexidade:**
| Sinal | Peso |
|-------|------|
| Mais de 5 arquivos afetados | +2 |
| Primeira vez em linguagem/framework | +3 |
| Decisão de arquitetura | +4 |
| >=2 tentativas de fix falhadas | +3 |
| Segurança (auth, credentials) | +3 |
**Threshold de ativação:** score >= 5 → Músculo ativa automaticamente.
**Usar quando:** debug que não resolve, refatoração complexa, decisão com trade-offs.

---

### `/superpowers` (alias: `/using-superpowers`)
**Quando usar:** ao iniciar uma nova sessão de trabalho intenso, ou quando quer que o Músculo aplique TODAS as skills disponíveis ao contexto.
**O que faz:** instrui o Músculo sobre como e quando invocar cada skill disponível no sistema.
**Prioridade:** as instruções do Diretor (CLAUDE.md) SEMPRE têm prioridade sobre as skills.
**Regra de ouro:** se há 1% de chance de uma skill se aplicar → Músculo DEVE invocá-la.
**Usar quando:** "maximize o uso das suas capacidades", "aplica tudo que você tem disponível".

---

### `/mcp-builder`
**Quando usar:** quando for construir um servidor MCP — integração com API externa, tool para Claude Code.
**O que faz:** guia o processo de criação de servidores MCP em Python (FastMCP) ou Node/TypeScript (MCP SDK).
**Fases do processo:**
1. Definição de ferramentas (o que o LLM pode fazer)
2. Design de erros e respostas
3. Implementação com boas práticas
4. Teste e publicação
**Usar quando:** "quero que o Claude controle X via ferramenta", "precisamos de MCP para Y".

---

### `/cowork-engine` (Vanguard-específico)
**Quando usar:** ao iniciar sessão — busca documentos no Google Drive antes de qualquer resposta.
**O que faz:** Playwright navega no Google Drive, lê arquivos recentes do Diretor, entrega ao Músculo antes do BLOCO 0.
**Gate:** BLOQUEANTE — sem Cowork completado, o Músculo não deve responder ao BLOCO 0.
**Usar quando:** início de sessão, sempre que o Diretor deixou documentos no Drive entre sessões.

---

## COMO ENCONTRAR SKILLS DISPONÍVEIS

### Via terminal (lista completa):
```powershell
ls .claude/skills/
```

### Via Músculo (busca semântica):
Perguntar: "Músculo, existe alguma skill para [tarefa]?"
O Músculo verifica `.claude/skills/` e retorna as opções.

### Skills por categoria:
| Categoria | Skills |
|-----------|--------|
| **Processo** | `/brainstorming`, `/ultrathink-trigger`, `/writing-plans`, `/executing-plans`, `/find-skills` |
| **Build** | `/mcp-builder`, `/webapp-testing`, `/frontend-design`, `/skill-creator` |
| **Análise** | `/systematic-debugging`, `/verification-before-completion`, `/doc-drift-audit`, `/json-bom-guard` |
| **Inteligência** | `/firecrawl` |
| **Clientes** | `/ingrid-v8`, `/cowork-engine-v1`, `/vanguard-v33` |
| **Automação** | `/n8n-orquestracao-v1`, `/notebooklm` |

---

## REGRAS DE USO (RESUMO)

1. **Músculo invoca skills automaticamente** — o Diretor não precisa pedir
2. **Se o Diretor pede `/skill`** — Músculo deve invocar antes de qualquer resposta
3. **Skills de processo vêm primeiro** — `/brainstorming` antes de `/mcp-builder`
4. **Skills do Vanguard têm prioridade** sobre skills genéricas quando há conflito
5. **`/ultrathink` é automático** para score >= 5 — o Diretor pode forçar com `/ultrathink`

---

## ADICIONANDO NOVAS SKILLS

```powershell
# Instalar skill de um arquivo
Copy-Item "skill.md" ".claude/skills/nome-da-skill.md"

# Instalar do NOTEBOOKLM_DROP (automático via skill_watcher.ps1)
Copy-Item "skill.md" "CLIENTES/[NOME]/NOTEBOOKLM_DROP/"
# skill_watcher.ps1 detecta e instala automaticamente
```
