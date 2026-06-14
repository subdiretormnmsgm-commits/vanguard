# skills.md — Pentalateral IAH · Vanguard Tech
# Formato: Antigravity IDE (docs/users/bundles.md)
# Versão: 2.0 · Eduardo · 2026-06-14 · P-163: 3 papéis formais (ESTRATEGISTA + EXECUTOR + COWORK CONDUCTOR)
#
# COMO O ANTIGRAVITY LÊ ESTE ARQUIVO:
# 1. Coloque este arquivo na raiz do projeto: ./skills.md
# 2. O agente ativo carrega automaticamente ao iniciar sessão
# 3. Invoque cada skill com @ seguido do nome exato
#    Exemplo: @brainstorming Planeje a próxima release do Ledger API
# 4. Skills instaladas via: npx antigravity-awesome-skills --antigravity

---

## 🧠 ESTRATEGISTA (Gemini)
> Papel: planejamento estratégico, roteamento de decisões, definição do que o Músculo executa.
> Quando invocar: antes de qualquer nova feature, gate de projeto ou decisão arquitetural.

| Skill | Quando usar |
|---|---|
| `@brainstorming` | Antes de qualquer feature ou mudança arquitetural — transforma requisito vago em design validado |
| `@architecture` | Decisões de stack, trade-offs e documentação ADR para a infra da Vanguard |
| `@concise-planning` | Abertura de toda sessão — força plano antes de delegar ao Músculo |
| `@analyze-project` | Revisão de desvios de escopo, retrabalho e saúde do projeto (PROJ-001 / PROJ-002) |

### Exemplo de uso — Estrategista
```
@concise-planning Planeje a próxima etapa do Ledger API: endpoints de fechamento de ciclo

@brainstorming Quais abordagens para versionamento da API sem quebrar clientes existentes?

@architecture Documente a decisão de usar FastAPI vs Flask para o Ledger API

@analyze-project Revise o escopo do PROJ-002 Ingrid e identifique desvios
```

---

## ⚡ EXECUTOR (Antigravity — executa o que o Estrategista-Gemini definiu)
> Papel FORMAL P-163: executa decisões do Gemini Advanced — lê PASSO3_GEMINI.md + CONTEXTO_GEMINI.md do disco. Não age por intuição — age pelo que Gemini definiu. Todo output vai para PENDING_REVIEW.md (P-124).
> Ferramentas primárias: n8n (docs.n8n.io), PowerShell (learn.microsoft.com/powershell), GitHub CLI (cli.github.com), EasyPanel (easypanel.io).
> Quando invocar: ao receber output aprovado do Estrategista-Gemini para implementação.

| Skill | Quando usar |
|---|---|
| `@github-actions-templates` | Criar ou revisar workflows CI/CD do Ledger API no GitHub Actions |
| `@systematic-debugging` | Debug de erros de gateway, falhas de pipeline e exceções da FastAPI |
| `@error-handling-patterns` | Implementar resiliência nos endpoints do Ledger API |
| `@bash-scripting` | Scripts de automação de sessão, gerenciamento de ambiente e deploy |
| `@lint-and-validate` | Validação de código antes de qualquer commit no repositório Vanguard |
| `@git-pushing` | Padronização de commits, branching e push seguro |
| `@docs-architect` | Geração de documentação técnica a partir do codebase existente |
| `@claude-code-guide` | Referência de configuração e melhores práticas do Claude Code |

### Exemplo de uso — Músculo
```
@systematic-debugging O endpoint /ledger/ciclo retorna 502 após 30s — identifique o root cause

@github-actions-templates Crie workflow CI para rodar testes do Ledger API em cada PR

@error-handling-patterns Implemente retry com backoff exponencial no client do Ledger API

@bash-scripting Escreva script de inicialização de sessão Pentalateral com verificação de ambiente

@docs-architect Gere documentação técnica dos endpoints do Ledger API a partir do codebase

@lint-and-validate Valide o código antes do commit desta feature
```

---

## 🌐 COWORK CONDUCTOR (Antigravity — conduz sessões NICHE_MODELER e inteligência de mercado)
> Papel FORMAL P-163: conduz sessões NICHE_MODELER — lê INBOX_COWORK + BIBLIOTECA + NICHE_INDEX. 5 tarefas: (1) fit_score, (2) enriquecimento de campos, (3) alertas regulatórios, (4) nichos novos, (5) mapa de prioridade.
> Ferramentas primárias: Semrush (semrush.com), Ahrefs (ahrefs.com), SimilarWeb (similarweb.com), Google Trends (trends.google.com), SpyFu (spyfu.com).
> Quando invocar: ao conduzir sessão NICHE_MODELER ou ciclo de inteligência de nicho (não misturar com EXECUTOR na mesma sessão).
> Uso via scripts — Antigravity lê corpus e executa análise:

| Skill | Uso indireto |
|---|---|
| `@bash-scripting` | Gerar scripts que o Cowork executa para mover, renomear ou organizar arquivos |
| `@error-detective` | Correlacionar erros quando o Cowork reporta falhas em automações |

### Exemplo de uso — Cowork (via Músculo)
```
# O Músculo gera o script, o Cowork executa:

@bash-scripting Escreva script PowerShell que organiza os arquivos de entrega
do PROJ-001 em pastas por data e tipo de documento

@error-detective O Cowork falhou ao processar os arquivos da pasta /PROJ-002/entregas
— analise o log e identifique o padrão de erro
```

---

## 🔁 FLUXO PADRÃO DE SESSÃO PENTALATERAL

```
1. ESTRATEGISTA abre sessão:
   @concise-planning [objetivo da sessão]

2. ESTRATEGISTA define rota:
   @brainstorming [problema ou feature]
   → entrega: plano validado para o Músculo

3. MÚSCULO executa:
   @systematic-debugging / @github-actions-templates / @bash-scripting
   → entrega: código, script ou documentação

4. MÚSCULO fecha com:
   @lint-and-validate
   @git-pushing

5. ESTRATEGISTA revisa:
   @analyze-project [revise o que foi entregue]
```

---

## 📦 INSTALAÇÃO DAS SKILLS

```powershell
# Instalar no Antigravity (já executado):
npx antigravity-awesome-skills --antigravity

# Verificar instalação:
dir $env:USERPROFILE\.agents\skills

# Skills instaladas em:
# ~/.agents/skills/<nome-da-skill>/SKILL.md
```

---

## 📌 REFERÊNCIAS
- Repositório: https://github.com/sickn33/antigravity-awesome-skills
- Bundles oficiais: docs/users/bundles.md
- Catálogo completo: CATALOG.md (1.441 skills)
- Versão instalada: antigravity-awesome-skills@12.4.0
