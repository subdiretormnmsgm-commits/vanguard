# MEMÓRIA TÉCNICA — VANGUARD V31 · Loop 31 · Expansão da Inteligência Interna
> Músculo · Data: 2026-06-09 · Síntese técnica completa para continuidade

---

## 1. RESUMO EXECUTIVO DO LOOP

**Tema:** Expansão da Inteligência Interna do Pentalateral IAH — loop interno sem clientes.

**Missão central:** Fazer o sistema se medir, se otimizar e fechar seus próprios ciclos de aprendizado. A lacuna detectada: 30 loops de histórico, 22+ scripts, n8n + Hermes em produção — mas sem dashboard de saúde, sem transcript de amnésia, sem métrica de deriva.

**Status ao fechar:** Gemini=OK · Auditor=OK (Skill aprovada) · Embaixador=AGUARDA (PASSO7 pronto) · Músculo=AGUARDA_EMBAIXADOR.

**Principal ganho estrutural:** P-143 (checklist anti-esquecimento obrigatório em todo PASSO) + P-144 (dois sócios têm pesquisa web avançada — mecanismos distintos e obrigatórios).

**Principal alerta herdado:** P-133 (Gate Zero de Pipeline) — o sistema está girando rotores mais rápido do que a esteira de aquisição. Loop 32 deve endereçar isso.

---

## 2. ENTREGAS CONFIRMADAS EM DISCO

| Artefato | Caminho | Status |
|----------|---------|--------|
| Ideias M-1 a M-5 (Músculo) | PASSO3_GEMINI.md | ✅ Gerado |
| DIRETRIZ V31 (Antigravity) | CLIENTES/VANGUARD/HISTORICO/DIRETRIZ_V31_VANGUARD.md | ✅ Recebida |
| AUDITOR Loop 31 (NotebookLM) | CLIENTES/VANGUARD/HISTORICO/AUDITOR_LOOP_V31_VANGUARD.md | ✅ Salvo |
| Skill vanguard-v31.md | .claude/skills/vanguard-v31.md | ✅ APROVADA (skill_parser_gate) |
| PASSO7 Embaixador | CLIENTES/VANGUARD/PASSO7_EMBAIXADOR.md | ✅ Pronto para uso |
| LOOP_STATE.json | CLIENTES/VANGUARD/CLAUDE_PROJECT/LOOP_STATE.json | ✅ Atualizado |
| P-143 + P-144 | INTELLIGENCE_LEDGER.md | ✅ Inscritos |
| Commit de artefatos | 6ebb950 | ✅ Commitado |

---

## 3. PRINCÍPIOS INSCRITOS

**P-143 — FERRAMENTA AUTOMÁTICA ANTI-ESQUECIMENTO DO MÚSCULO (2026-06-10)**
Cada PASSO file contém [CHECKLIST DO MÚSCULO] com itens BLOQUEANTES.
skill_parser_gate.ps1 verifica checklist no PASSO5 antes de executar.
session_close.ps1 Gate 6D: AUDITOR_LOOP_V[N] + relatorio nativo obrigatórios.

**P-144 — DOIS SÓCIOS TÊM PESQUISA AVANÇADA WEB — USAR OBRIGATORIAMENTE (2026-06-10)**
AUDITOR: botão Deep Research WEB → NOVAS FONTES no caderno (persistentes) → clicar via Playwright ANTES do PASSO5.
EMBAIXADOR: busca em tempo real → cita URLs → BLOCO 8 no PASSO7.
Checklist PASSO5 Loop 32: (1) Deep Research WEB clicado → (2) fontes adicionadas → (3) enviar PASSO5 → (4) generate report nativo → (5) salvar artefatos.

---

## 4. DECISÕES E VEREDITOS

**D1: W-8 Hermes Grau B**
- Contexto: 7 dias de shadow mode sem incidente. Grau B = age + janela de veto 15min.
- Veredito do Diretor: **D1:A — ATIVAR GRAU B** (2026-06-09)
- Status: Autorizado. Requer EasyPanel Terminal para executar (sem script de automação local).
  - Comando: `sed -i 's/grau: A/grau: B/' /opt/data/config.yaml && cat /opt/data/config.yaml`
  - Reiniciar serviço hermes-agent no EasyPanel após edição.

**D3: RUNNING_INTELLIGENCE.md**
- Contexto: Embaixador tem busca web agora. M-4 (sub-agentes) é build futuro. São independentes.
- Veredito do Diretor: **D3:A — CRIAR AGORA** (2026-06-09)
- Status: Embutido no PASSO7. Embaixador cria ao receber SEÇÃO D.

**D2 (removida pelo Diretor):** Mumuzinho não entra neste loop. Foco = Vanguard interna.

---

## 5. O QUE FICOU PENDENTE

| Item | Tipo | Prazo |
|------|------|-------|
| SEÇÃO D do Embaixador — colar output aqui | [diretor] | Próxima sessão |
| Síntese P-037 + DELIBERAÇÃO_LOOP_V31 | [musculo] | Após Embaixador |
| DECISOES.json (D1 + D3) | [musculo] | Após Embaixador |
| Executar vereditos via executar_vereditos.ps1 | [musculo] | Após DECISOES.json |
| D1:A EasyPanel Terminal — ativar Hermes Grau B | [diretor] | Antes de 2026-06-14 |
| MEMORIA_EMBAIXADOR_VANGUARD (P-032) | [musculo] | Após síntese P-037 |
| [CHECKLIST DO MÚSCULO] no PASSO5 template (P-143) | [musculo] | Loop 32 |
| session_close.ps1 Gate 6D (P-143) | [musculo] | Loop 32 |
| LOOP_TRANSCRIPT_V31 gerado pelo session_close (P-141) | [musculo] | Loop 32 |
| SYSTEM_HEALTH.md schema + métricas (M-1) | [musculo] | Loop 32 |
| BOM UTF-8 no WIP_BOARD.json — reintroduzido | [musculo] | Urgente (bloqueia ChurnWatch) |
| VANGUARD_TIMELINE — update Loop 31 | [musculo] | Esta sessão |
| Demo EdTech/Sedes-DF v0 | [musculo] | 2026-06-16 |

---

## 6. ALERTAS ATIVOS PARA O PRÓXIMO LOOP

**ALERT-1 [CRÍTICO] — P-133 Gate Zero de Pipeline ativo**
Sistema girando rotores mais rápido que esteira de aquisição. Loops de otimização interna
ofuscam ausência de novos MRRs. Loop 32 DEVE endereçar prospecção (M-4 + G-5 → leads reais).

**ALERT-2 [ALTO] — BOM UTF-8 no WIP_BOARD.json**
Detectado via Notion inbox: `Unexpected token '﻿'` quebra ChurnWatch + Notion sync.
Músculo deve corrigir antes do próximo session_close.

**ALERT-3 [ALTO] — Falhas Notion Inbox (4 registradas pelo Diretor)**
1. VANGUARD_TIMELINE desatualizada no Claude Projects (e pastas similares)
2. W-8 sinal classificado incorretamente como INFORMAR (shadow mode funcionando — verificar)
3. Instagram/ChurnWatch: erro BOM + mensagens duplicadas / fora de horário
4. Não recebimento de mensagens diárias (W-1, W-5, W-6 — verificar n8n)

**ALERT-4 [MÉDIO] — Hermes Grau B não executado ainda**
Diretor autorizou D1:A mas requer ação manual no EasyPanel Terminal. Prazo: antes de 2026-06-14.

**ALERT-5 [MÉDIO] — Reward Hacking (M-3 / P-124)**
Auto-calibração direta do Músculo é câmara de eco. M-3 movido para Loop 32 com Scorer cruzado
(Auditor avalia Músculo via P-132 Triangulação Cega). Regra: nenhum LLM pontua a si mesmo.

**ALERT-6 [BAIXO] — W-8 shadow mode expira 2026-06-14**
Se D1:A não executado antes dessa data, Hermes continua em Grau A mas protocolo shadow expira.

---

## 7. ESTADO DO CONSELHO

| Membro | Status | Artefato | Próxima ação |
|--------|--------|----------|--------------|
| Estrategista (Antigravity) | ✅ OK | DIRETRIZ_V31_VANGUARD.md | Aguarda Loop 32 — PASSO3 calibrado |
| Auditor (NotebookLM) | ✅ OK | AUDITOR_LOOP_V31_VANGUARD.md + vanguard-v31.md | Loop 32: Deep Research WEB ANTES do PASSO5 |
| Embaixador (Claude Projects) | ⏳ AGUARDA | — | Receber PASSO7 → SEÇÃO D + E-1 a E-5 + RUNNING_INTELLIGENCE |
| Músculo (Claude Code) | ⏳ AGUARDA_EMBAIXADOR | — | Síntese P-037 após SEÇÃO D |
| Diretor (Eduardo) | ▶ ATIVO | — | Levar PASSO7 ao Embaixador (7 documentos) |

**7 documentos para o Embaixador:**
1. INTELLIGENCE_LEDGER.md
2. WIP_BOARD.json
3. MEMORIA_V31_VANGUARD.md (este arquivo)
4. relatorio_evolutivo_V31_VANGUARD.md
5. AUDITOR_LOOP_V31_VANGUARD.md
6. vanguard-v31.md (.claude/skills/)
7. PASSO7_EMBAIXADOR.md (colar SEÇÃO D no chat)

---

## 8. CONTEXTO TÉCNICO PARA O PRÓXIMO LOOP

**Arquitetura atual do sistema (Loop 32 herda):**
- Antigravity CLI: lê PASSO3_GEMINI.md + CONTEXTO_GEMINI.md do disco → DIRETRIZ sem colagem manual
- NotebookLM VANGUARD caderno: ID d7dab0e1, conta subdiretor.mnmsgm@gmail.com, 23+ fontes
- Hermes Agent: Grau A (→ B pendente D1:A). Telegram @Eduardo431Vanguardbot
- n8n EasyPanel: W-1 a W-8 ativos. W-9 Track TRENDS pendente de import.
- LOOP_STATE.json: sistema de estado durável por loop (v1.0 ativo)
- WIP_BOARD.json: problema BOM reintroduzido — corrigir antes de W-5/W-6/Notion sync

**Prioridade técnica Loop 32:**
1. Corrigir BOM WIP_BOARD.json (bloqueia 3 automações)
2. Completar fechamento Loop 31 (SEÇÃO D + síntese P-037 + DECISOES.json)
3. Implementar M-4 (Deep Research hierárquico via n8n) → converter em prospecção
4. Adicionar [CHECKLIST DO MÚSCULO] ao PASSO5 template (P-143)
5. Demo EdTech/Sedes-DF v0 (deadline 2026-06-16)

**Regra de ouro para Loop 32:** P-133 não é alerta, é gate. Nenhum build de infraestrutura interna
avança sem estar vinculado a um lead ou cliente real.
