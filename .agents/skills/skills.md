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

## 📦 COMO BAIXAR E INSTALAR SKILLS (Antigravity)

> Antes de invocar qualquer skill com @, verifique se ela está instalada em `~/.agents/skills/`.
> Se não estiver, instale com os comandos abaixo. Antigravity executa estes comandos autonomamente.

### Verificar se uma skill está instalada
```powershell
# Checar skill específica antes de invocar:
Test-Path "$env:USERPROFILE\.agents\skills\<nome-da-skill>"

# Listar todas instaladas:
Get-ChildItem "$env:USERPROFILE\.agents\skills" -Directory | Select-Object Name
```

### Instalar skills
```powershell
# Instalar TODAS (1.500+ skills) — uso único, demora alguns minutos:
npx antigravity-awesome-skills --antigravity

# Instalar por categoria (mais rápido e específico):
npx antigravity-awesome-skills --antigravity --category development,backend
npx antigravity-awesome-skills --antigravity --category planning,strategy
npx antigravity-awesome-skills --antigravity --category marketing,seo

# Instalar apenas skills de risco seguro:
npx antigravity-awesome-skills --antigravity --risk safe,none

# Atualizar para versão específica:
npx antigravity-awesome-skills --antigravity --version 12.5.0
```

### Como invocar após instalar
```
@nome-da-skill [prompt/contexto]
```
O arquivo lido é: `~/.agents/skills/<nome-da-skill>/SKILL.md`

---

## 🎯 SKILLS RECOMENDADAS POR PAPEL (curadas — instalar se ausentes)

### ESTRATEGISTA — suporte à produção da DIRETRIZ
```powershell
# Verificar e invocar (já instaladas):
@concise-planning    # abertura obrigatória
@brainstorming       # antes de qualquer DIRETRIZ — 7 passos + Understanding Lock
@multi-agent-brainstorming  # escalada automática se alto impacto/risco
@architecture        # documentar decisão final (ADR)
@analyze-project     # revisão de desvios e saúde

# Skills adicionais recomendadas (instalar se ausentes):
# @decision-navigator          — navegar trade-offs complexos antes de recomendar
# @architecture-decision-records — ADR formal para decisões irreversíveis
# @executing-plans             — estruturar plano de execução após @architecture
# @planning-with-files         — planejar com leitura de arquivos do workspace
```

### EXECUTOR — execução das decisões do Estrategista-Gemini
```powershell
# Skills n8n (críticas para o Hermes + workflows):
@n8n-workflow-patterns      # padrões arquiteturais: webhook, API, scheduled, AI-agent
@n8n-code-javascript        # código JS nos nós Code do n8n
@n8n-expression-syntax      # expressões e variáveis do n8n
@n8n-node-configuration     # configuração correta de nós
@n8n-validation-expert      # validar workflows antes de ativar
@n8n-mcp-tools-expert       # integração MCP no n8n

# Skills de orquestração e automação:
@bash-scripting              # scripts PS1/Bash de automação
@systematic-debugging        # debug estruturado de falhas
@workflow-orchestration-patterns  # padrões de orquestração multi-step
@supabase-automation         # Supabase (banco de dados Vanguard)
@telegram-automation         # Telegram (canal do Hermes Agent)

# Instalar ausentes:
# npx antigravity-awesome-skills --antigravity --tags n8n,automation,workflow
```

### COWORK CONDUCTOR — sessões NICHE_MODELER e inteligência de mercado
```powershell
# Skills de inteligência de nicho (já instaladas):
@20-andruia-niche-intelligence  # dossier de domínio: regulações, UX do nicho, stack padrão
@apify-market-research          # pesquisa de mercado via Apify scraping
@apify-trend-analysis           # análise de tendências de mercado
@apify-competitor-intelligence  # inteligência de concorrentes via Apify
@competitive-landscape          # mapa competitivo do nicho
@market-sizing-analysis         # TAM/SAM/SOM do nicho
@deep-research                  # pesquisa profunda multi-fonte

# Instalar ausentes:
# npx antigravity-awesome-skills --antigravity --tags market-research,competitive,niche
```

---

## 📌 REFERÊNCIAS
- Repositório: github.com/sickn33/antigravity-awesome-skills
- Versão instalada: antigravity-awesome-skills@12.5.0 (atualizado 2026-06-14)
- Skills em: `~/.agents/skills/<nome>/SKILL.md`
- Total disponível: 1.500+ skills (curar 5-10 por papel — não despejar tudo)
