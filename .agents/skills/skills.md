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
> Papel FORMAL P-163: planejamento estratégico, suporte à produção da DIRETRIZ, roteamento de decisões.
> NUNCA gera DIRETRIZ de Loop autonomamente — papel exclusivo do Gemini Advanced via chat.
> Quando invocar: antes de qualquer nova feature, gate de projeto ou decisão arquitetural.
> Ferramentas primárias: Google AI Studio · Gemini CLI · Gemini Code Assist Agent Mode · Gemini Enterprise Agent Platform.

| Skill | Quando usar |
|---|---|
| `@concise-planning` | **Abertura obrigatória de toda sessão** — força plano antes de qualquer ação |
| `@brainstorming` | Antes de qualquer feature ou DIRETRIZ — 7 passos + Understanding Lock + Decision Log. YAGNI ruthlessly |
| `@multi-agent-brainstorming` | Escalada automática quando @brainstorming detecta alto impacto/risco — 5 agentes: Designer + Skeptic + Constraint Guardian + User Advocate + Arbiter |
| `@architecture` | Decisões de stack, trade-offs e documentação ADR — após @brainstorming confirmar o design |
| `@analyze-project` | Revisão de desvios de escopo, retrabalho e saúde do projeto |

### Fluxo padrão do ESTRATEGISTA
```
1. @concise-planning [objetivo da sessão]           ← obrigatório, toda sessão
2. @brainstorming [problema ou feature]             ← sempre antes de propor design
   → Understanding Lock → 2-3 abordagens → Decision Log
3. @multi-agent-brainstorming                       ← se alto impacto/risco (a própria @brainstorming chama)
   → Skeptic + Constraint Guardian + User Advocate + Arbiter
4. @architecture [documenta a decisão final]        ← após design validado
5. @analyze-project [revisa desvios e saúde]        ← revisão de loop
```

### Exemplo de uso — Estrategista
```
@concise-planning Planeje o Loop 34 Vanguard: objetivo, gates e sequência de sócios

@brainstorming Quais abordagens para o n8n auto-manutenção sem depender do Diretor?

@multi-agent-brainstorming  (escalada automática — alto impacto na infra)

@architecture Documente a decisão de arquitetura do workflow de manutenção n8n

@analyze-project Revise o escopo do PROJ-002 Ingrid e identifique desvios de loop
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
