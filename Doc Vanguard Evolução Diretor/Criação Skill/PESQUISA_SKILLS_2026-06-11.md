# PESQUISA DE SKILLS — MÚSCULO + ANTIGRAVITY
> Gerado pelo Embaixador Operacional · 2026-06-11
> Fontes inspecionadas: vudovn/ag-kit · rmyndharis/antigravity-skills · skillsmp.com
> Âncora: sessão Loop 32 FECHADO + AGENTS.md anti-catástrofe (2026-06-11 manhã)
> Princípio de curadoria: P-146 (FALHA→FERRAMENTA) + "curar, não despejar" (épico W-10)

---

## VEREDITO DO EMBAIXADOR

**Não instalar no Loop 33.** Loop 33 já tem missão definida (7 docs CONSTITUICAO + ATOs 2-6 + Gate Zero P-133). Empilhar skills repete FALHA-K. O valor desta pesquisa já foi capturado — o mapa existe, os paths estão aqui.

**Sequência recomendada:**
1. Gate de instalação vira princípio no LEDGER_INBOX (1 min — blindagem, não build)
2. Loop 33 fecha sem tocar skill externa
3. V33+: começar por UMA skill — `skillify`
4. As demais do TIER 1 apenas depois de skillify provar valor
5. TIER 2 (Antigravity): só quando o build correspondente abrir

---

## FONTE 1 — AG KIT (github.com/vudovn/ag-kit)

**O que é:** Sistema operacional de agente completo — não é só biblioteca de skills.
Inclui: 20 agentes-persona, 45 skills, 13 workflows slash-command, memória persistente e Coordinator Mode.

**Alerta crítico:** `rules/GEMINI.md` vem com `trigger: always_on` e declara prioridade P0 acima de tudo,
com roteamento automático de agentes e classificador de requisições.
**Instalar o sistema inteiro colide com o Pentalateral e viola P-131 + protocolo anti-catástrofe.**
A Vanguard já é a camada de orquestração.

**Solução:** extrair skills individuais cirurgicamente. Não usar `npx ag-kit init`.

### Skills do AG Kit candidatas (TIER 1 — para o Músculo)

| Skill | Path | Tamanho | Por que importa |
|---|---|---|---|
| `skillify` | `.agents/skills/skillify/SKILL.md` | 115 linhas | Extrai skill de workflow repetitivo. Converte FALHA→FERRAMENTA (P-146) em FALHA→SKILL — mais durável. **A mais estratégica do lote.** |
| `verify-changes` | `.agents/skills/verify-changes/SKILL.md` | 127 linhas | Institucionaliza P-116 ("o que dói é erro, não esforço") em formato executável. Verificação por execução, não inspeção. |
| `batch-operations` | `.agents/skills/batch-operations/SKILL.md` | — | Modificações multi-arquivo com padrão. A campanha de 62 arquivos do Loop 32 foi feita "na mão" — isso é a ferramenta dela. |
| `context-compression` | `.agents/skills/context-compression/SKILL.md` | — | Defesa anti-compactação em sessões longas. Complementa build M-2 (LOOP TRANSCRIPT), não o substitui. |

### Skills do AG Kit candidatas (TIER 2 — para o Antigravity, sob gatilho de build)

| Skill | Path | Gatilho de ativação |
|---|---|---|
| `red-team-tactics` | `.agents/skills/red-team-tactics/SKILL.md` | Build G-1+E-3 (RED TEAMING + QUARENTENA) — 200 linhas de metodologia |
| `vulnerability-scanner` | `.agents/skills/vulnerability-scanner/SKILL.md` | Build G-1+E-3 (entra junto com red-team) — 277 linhas |
| `systematic-debugging` | `.agents/skills/systematic-debugging/SKILL.md` | Modo investigação do EXECUTOR_PLAYBOOK |

### Skills do AG Kit para NÃO instalar

| Skill | Razão |
|---|---|
| `GEMINI.md` / `intelligent-routing` / `coordinator-mode` | Colidem com o Pentalateral. Roteamento automático viola P-131. |
| `orchestrator.md` (agente) | Vanguard já tem orquestrador — o Diretor. |
| `memory-system` | Criaria segunda fonte de memória ao lado de MEMORIA_EMBAIXADOR + LOOP_STATE + RUNNING_INTELLIGENCE. Duas fontes de verdade = deriva. Estudar como referência para M-2, não instalar. |
| `parallel-agents` | Não temos tasks suficientemente independentes para paralelismo externo seguro no momento. Reavaliar com 10+ projetos. |

---

## FONTE 2 — ANTIGRAVITY SKILL VAULT (github.com/rmyndharis/antigravity-skills)

**O que é:** 305 skills — porte automatizado do ecossistema wshobson/agents (Claude Code) para formato Antigravity.

**Alerta de qualidade:** porte gerou degradação em várias descrições.
Ex.: `incident-response`: *"Use when working with incident response incident response"* — skill inválida.
Inspecionar individualmente antes de qualquer instalação.

**Alerta de performance:** cada skill instalada carrega metadados em toda abertura de sessão.
Mais skills = mais tokens + auto-ativação irrelevante. O próprio repositório desaconselha `install --all`.
Agrava o risco de quota (corte de 92% documentado no free tier).

**Mecanismo correto:** usar `catalog.json` + `bundles.json` + `aliases.json` para instalação dirigida.

### Skills do Vault candidatas (TIER 2 — Antigravity, sob gatilho de build)

| Skill | Path | Gatilho de ativação |
|---|---|---|
| `fastapi-pro` | `skills/fastapi-pro/SKILL.md` | Valdece V2 (Sovereign Upload) — stack exata FastAPI+Supabase |
| `prompt-engineering-patterns` | `skills/prompt-engineering-patterns/SKILL.md` | Otimização dos PASSO files e gates Haiku |
| `llm-application-dev-prompt-optimize` | `skills/llm-application-dev-prompt-optimize/SKILL.md` | Claude API calls em produção (Hermes + workflows n8n) |
| `rag-implementation` | `skills/rag-implementation/SKILL.md` | Máquina de Conhecimento Soberana (V30 épico) |
| `observability-monitoring-monitor-setup` | `skills/observability-monitoring-monitor-setup/SKILL.md` | Quando W-8 ativar pleno (Hermes Grau C) |
| `git-advanced-workflows` | `skills/git-advanced-workflows/SKILL.md` | Útil agora — rebase, bisect, reflog para o Músculo |

### Skills do Vault para NÃO instalar agora

| Skill | Razão |
|---|---|
| `startup-analyst` / `sales-automator` | Relevantes só pós Gate Zero P-133. Loop 33 é interno. |
| `seo-content-planner` | Sem projeto de conteúdo ativo no sistema. |
| `defi-protocol-templates` / `nft-standards` | Fora do mapa de nichos da Vanguard. |
| Qualquer skill com descrição degenerada | Verificar `catalog.json` antes — rejeitar se descrição é autorreferente. |

---

## FONTE 3 — SKILLSMP (skillsmp.com)

**O que é:** Marketplace que indexa 1.640.440 arquivos SKILL.md públicos, compatíveis com Claude Code, Codex e ChatGPT.
Organizado em 23 grupos ocupacionais e 867 ocupações SOC. Possui API REST.

**Uso recomendado para a Vanguard (não é "baixar skills"): sensor agendado de inteligência de domínio.**

Integração estratégica com a **Máquina de Conhecimento Soberana (V30)**:
- **Legal**: 17.778 skills indexadas → inteligência do nicho Valdece por cron
- **EdTech**: 19.979 skills em Educational Instruction → nicho Ingrid
- **Business & Financial**: 187.818 skills → pipeline de novos clientes

**API REST:** disponível em `skillsmp.com/docs/api` — permite busca por keyword, ocupação e repositório.
Candidata a fonte no estágio DESCOBERTA do épico Máquina de Conhecimento.

**Alerta (validado pelo próprio marketplace):**
Indexar não certifica segurança nem qualidade — inspecionar fonte, scripts e permissões antes de qualquer instalação.

---

## GATE DE INSTALAÇÃO — CANDIDATO A PRINCÍPIO (LEDGER_INBOX)

> Proposta: registrar no LEDGER_INBOX antes de qualquer import de skill de terceiro.

```
[CANDIDATO P-149] GATE DE INSTALAÇÃO DE SKILLS EXTERNAS
Toda skill de terceiro é código + instruções não auditadas (vetor de prompt injection).

Protocolo obrigatório antes de qualquer import:
(1) Músculo lê SKILL.md + scripts na íntegra — sem exceção
(2) Roda skill_parser_gate.ps1 — já existente
(3) Skill no Antigravity nunca ganha escrita em LEDGER/PENDENTES/WIP — saída sempre PENDING_REVIEW (R-04/P-124)
(4) Adaptação ao contexto Vanguard antes do commit (renomear, ajustar triggers, remover colisões)
(5) Uma skill por vez, com teste — mesma disciplina dos 7 docs CONSTITUICAO seção a seção
(6) Skill sem build ativo que a use = não instalar (peso morto em sessão de quota limitada)
```

---

## LEITURA ESTRATÉGICA — "O FUTURO DA EMPRESA"

O achado mais importante desta pesquisa não é nenhuma skill específica.

É que a Vanguard está prestes a cruzar a linha de **consumidor de skills → fabricante de skills**.

Já temos 6 skills proprietárias: `vanguard-doc-sync`, `notebooklm`, `gemini`, `pbi-modelo-review`, `pbi-doc`, `pbi-dax-create`.
Cada erro documentado no INTELLIGENCE_LEDGER é um candidato a skill. Com `skillify` instalada, o ciclo fica:

```
FALHA detectada → LEDGER_INBOX → autorização → FERRAMENTA (P-146) → SKILL (skillify) → LEDGER_SKILL
```

Isso é o diferencial incopiável de D3: **o sistema aprende a aprender em formato reutilizável.**

Skills compradas/importadas depreciam. Skills nascidas dos erros da própria operação compõem.

---

## RESUMO EXECUTIVO — PRIORIDADES

| Prioridade | Ação | Quando |
|---|---|---|
| 1 | Gate de instalação → LEDGER_INBOX (P-149 candidato) | Agora — 1 min |
| 2 | Loop 33 fecha SEM skill externa | Loop 33 |
| 3 | `skillify` — import único com gate | V33+ (após ATOs 1-6) |
| 4 | `verify-changes` + `batch-operations` + `context-compression` | Após skillify provar valor |
| 5 | TIER 2 Antigravity (por build correspondente) | Conforme builds abrem |
| 6 | API SkillsMP como fonte no épico Máquina de Conhecimento | V30 |

---

*Pesquisa gerada pelo Embaixador Operacional · Loop 32 FECHADO*
*Repositórios inspecionados localmente: ag-kit (45 skills, 13 workflows) · antigravity-skills (305 skills)*
*Marketplace auditado: skillsmp.com (1.640.440 SKILL.md indexadas)*
*Classificação P-124 aplicada: nenhuma skill recomendada entra sem gate e sem build correspondente ativo*
