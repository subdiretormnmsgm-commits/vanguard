# PASSO 5 — AUDITOR (NOTEBOOKLM) · PROJETO INGRID · LOOP 5
> Pentalateral IAH — Camada Permanente: não editar blocos de protocolo.
> Criado pelo Músculo em 2026-05-23 (Loop 5 / Diretriz V6 aguardada do Gemini)

---

## ANTES DE IR AO NOTEBOOKLM — checklist obrigatório

```
[ ] 1. DIRETRIZ_GEMINI (Loop 5) recebida e salva em CLIENTES\INGRID\
[ ] 2. Rodar: .\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
[ ] 3. Explorer abre automaticamente — Ctrl+A → arrastar TUDO ao NotebookLM
[ ] 4. Fazer Wipe & Sync das fontes (apagar antigas antes de subir as novas)
[ ] 5. Colar o COMANDO CURTO no chat (não o arquivo inteiro — ele já está nas fontes)
```

> Sem o Wipe & Sync, o Auditor mistura contexto do Loop 4 com o Loop 5.

---

## COMANDO CURTO — colar no chat do NotebookLM

```
Auditor, você opera no Pentalateral IAH — 5 membros ativos: Diretor, Músculo, Estrategista, Auditor e Embaixador. O Embaixador (Claude Projects) acompanha a cliente Ingrid em tempo real — suas hipóteses estão em 14_MEMORIA_EMBAIXADOR.md, use como filtro de realidade antes de validar qualquer sugestão. Leia o arquivo 13_PASSO5_NOTEBOOKLM.md das fontes carregadas detalhadamente e execute todas as instruções contidas nele. Missão principal: gerar a Skill ingrid-v5.md — o Músculo não inicia o Loop 5 sem ela.
```

---

## PROTOCOLO ANTI-ALUCINAÇÃO (ler antes de processar)

| Deficiência | Gatilho de Alerta |
|---|---|
| Amnésia de Contexto | Tratar o projeto como Dia 1 sem MEMORIA |
| Alucinação Estrutural (P-007) | Skill com blocos genéricos sem dados reais do projeto |
| Síndrome do Yes-Man | Validar a DIRETRIZ do Gemini sem questionar |
| Lost-in-the-Middle | Ignorar OVERRIDE recente e aplicar regra V1 |

**Remédio:** "ALERTA: Auditor alucinou. Gatilho de Calibração ativado."

---

## COMPENSAÇÃO DAS DEFICIÊNCIAS DO MÚSCULO

Ao gerar a Skill, compense ativamente:

1. **Amnésia de Sessão** → listar princípios do LEDGER (P-001 a P-055) que o Músculo deve citar ao deliberar
2. **Momentum de Execução** → gates verificáveis por dia — sem output real = gate inválido
3. **Otimismo de Estimativa** → comparar estimativas com loops anteriores; Circuit Breaker preventivo se subestimar
4. **Escopo Silencioso** → listar explicitamente o que NÃO construir neste loop
5. **Drift de Formato** → exigir os 7 pontos de deliberação; sem formato = deliberação rejeitada

---

## CONTEXTO DO PROJETO

**Projeto:** Ingrid — Ferramenta de Estudo Sedes-DF
**Nicho:** EdTech / Concursos Públicos
**Stack:** PWA Vanilla JS + Supabase + Claude API (Haiku + Sonnet) · GitHub Pages
**Prova final:** 2026-09-06 · **Deadline do projeto:** 2026-05-30

**Loop:** #5 — Dias 12-13
**Missão:** Contador de Pontos Ponderados + Notificações Push dominicais

**Gates aprovados:**
- Dia 2: qualidade das questões
- Dia 5: feed 70/30 funcional (7 dias, 0 erros)
- Dia 8: PWA completo — Clickwrap + Tutor 3 níveis + Fallback + TTI (APROVADO 2026-05-19)
- Dia 11: Heatmap + Micro-Simulado funcional (APROVADO 2026-05-20)

**Banco:** 460 questões · 13 disciplinas · Cargo 202 (Instituto Quadrix)
**Temperatura da cliente:** VERDE FRÁGIL → VERDE CONSOLIDANDO

**Restrições ativas (VETO absoluto):**
- P-045: zero tela de login para Ingrid
- P-038: Micro-Simulado só recicla questões SM-2 (já vistas)
- P-003: sem scraping — questões via Claude API apenas
- Burn Rate: `BURN_RATE_DAILY_LIMIT_USD=5.00`
- P-007: validar toda RPC/Edge via CLI antes da UI

**Missão do Auditor neste loop:**
> "Auditor, você recebeu a DIRETRIZ do Gemini para o Loop 5 do Projeto Ingrid.
> O Músculo vai deliberar e construir o Contador de Pontos Ponderados e as Notificações Push.
> Sua missão: auditar a DIRETRIZ cruzando com o histórico real das fontes.
> Identifique: (1) o que contradiz princípios ativos do LEDGER ou decisões já tomadas,
> (2) o que já falhou em projetos anteriores,
> (3) o que o Estrategista está ignorando por otimismo de prazo.
> Incógnita crítica a verificar: Push via Service Worker funciona em iOS Safari (PWA)?
> Não valide por momentum. Discorde quando tiver evidência histórica."

---

## MISSÃO CRÍTICA — GERAR A SKILL ingrid-v5.md

**Nome exato da Skill: `ingrid-v5.md`**

O Músculo executa `/ingrid-v5` antes de qualquer deliberação do Loop 5.
Skill sem os 4 blocos com dados reais = Skill rejeitada pelo `skill_parser_gate.ps1`.

---

## FORMATO OBRIGATÓRIO DA SKILL (4 partes)

```
PARTE 1 — AUDITORIA DE COERÊNCIA
  A DIRETRIZ contradiz algo já construído ou decidido nos Loops 1-4?
  Verificar especificamente:
    - P-045: zero login para Ingrid (NUNCA reverter)
    - P-038: Micro-Simulado só recicla SM-2
    - Burn Rate $5/dia (P-006)
    - Deadline 2026-05-30 (7 dias restantes no momento do Loop 5)
    - Push iOS Safari: limitação estrutural confirmada ou contornada?

PARTE 2 — PERSPECTIVA DO SÓCIO CONSULTOR
  O que funciona em projetos similares (citar projeto + resultado).
  O que falha (citar projeto + razão documentada).
  O que Gemini e Músculo não estão vendo — discordância fundamentada.
  Ciclo 5 vs Ciclo 4: evoluímos ou estamos repetindo padrão?

PARTE 3 — A SKILL (formato copiável para .claude/skills/ingrid-v5.md)
  Incluir obrigatoriamente:
    - Contexto do projeto (cargo, banco, stack, decisões fixadas)
    - Conexão histórica (o que os Loops 1-4 provaram)
    - Padrão de sucesso validado
    - Padrão de falha documentado
    - Perspectiva do Sócio
    - Sequência de build Dias 12-13 com gates verificáveis
    - O que NÃO construir neste loop (com razão objetiva)
    - Alertas ativos (P-045, P-038, P-006, P-007, P-055)

PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR
  Ideias que NÃO vieram do Gemini nem do Músculo.
  Cada uma fundamentada em padrão de projeto anterior ou princípio do LEDGER.
```

---

## COMO CARREGAR AS FONTES

```powershell
.\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
```

O script monta `CLIENTES/INGRID/NOTEBOOKLM_FONTES/` e abre o Explorer automaticamente.
Selecionar tudo (Ctrl+A) → arrastar ao NotebookLM → Wipe & Sync → colar COMANDO CURTO.

---

## ATUALIZAÇÕES DO PROCESSO — SESSÃO 29-05-2026

**[P-069 EXPANDIDO — FORMATO DE DATA MANDATÓRIO]**
Todo item de projeto que referencie um "Dia X" usa agora o formato obrigatório:
"Dia X (DD-MM-YYYY dia-da-semana)" — ex: "Dia 15 (29-05-2026 sexta-feira)".
A Skill gerada pelo Auditor deve usar este formato em toda menção de dia interno do projeto.
Nunca apenas "Dia 15" — sempre o par completo com data e dia da semana.

**[P-013 PROJ-002 INGRID — GATE AUTORIZADO]**
Ingrid criará próprio projeto Supabase (Opção B — soberania do cliente).
O Auditor deve considerar este gate ao avaliar o cronograma Dias 12-15:
- Dia 15 (29-05-2026 sexta-feira): gate P-013 em andamento — aguarda Ingrid enviar credenciais
- Gate deadline: 30-05-2026 sábado
- SQL de migração completo já criado: `migrate_ingrid_supabase_v1.sql`
- Loop 5 não fecha enquanto gate dia15 não for APROVADO pelo Diretor

**[INTEL INGRID — PIPELINE DE REFERRAL]**
D4:A executado: Ingrid não conhece ninguém prestando concurso. Pipeline = zero.
Hipótese H-5 (compartilhamento de login) revisada para IMPROVÁVEL.
Este dado deve informar a análise de mercado do Auditor em PARTE 2 e as ideias disruptivas em PARTE 4.

**[STATUS v17 — DEPLOY CONFIRMADO EM 29-05-2026]**
- App live: https://subdiretormnmsgm-commits.github.io/vanguard/
- Gates aprovados até Dia 11: schema, questões, feed SM-2, PWA, clickwrap, tutor, heatmap, micro-simulado
- Pendente: Dias 12-13 (Contador Pontos Ponderados + Push dominical) + Dias 14-15 (P-013 + SaaS Readiness)
