# RELATÓRIO EVOLUTIVO V28 — VANGUARD PENTALATERAL IAH
**Loop 28 · The Sovereign Autonomous Layer · 2026-06-07**
**Músculo · Síntese de Negócio + Processo**

---

## SWOT — ESTADO AO FECHAR V28

### FORÇAS

- **Hermes Agent ONLINE:** primeiro motor autônomo do sistema rodando 24h — EasyPanel, OpenRouter, Telegram. Gateway PID 251, config persistida em `/opt/data/config.yaml`. Pentalateral tem agora um 6º componente ativo entre sessões.
- **W-8 Signal Classifier ativo:** taxonomia de sinal implementada (AUTO-RESOLVE / INFORMAR / DELIBERAR-A/B/C). Shadow mode de 7 dias — o sistema aprende antes de agir. Prova de maturidade operacional.
- **Camada de verificação antes da automação (P-116):** o V28 redefiniu a filosofia de build. Verificação semântica via Haiku (gate_coerencia.ps1) entra antes de qualquer propagação de decisão. A dor real identificada pelo Embaixador (E-3) — é o erro que dói, não o esforço — se tornou princípio fundador.
- **State Guard integrado:** anomalias no WIP_BOARD detectadas na abertura de sessão, não quando o Diretor percebe. Fecha o loop de visibilidade sem custo cognitivo adicional.
- **Runbooks canônicos:** RUNBOOK_EASYPANEL.md + RUNBOOK_SUPABASE_DDL.md criados. Conhecimento técnico adquirido com dor documentado antes de ser esquecido — P-050 ativo.

### FRAQUEZAS

- **Hermes em Grau A:** toda ação requer aprovação do Diretor. Aumenta a autonomia percebida do sistema, mas o custo cognitivo de Eduardo não caiu — apenas mudou de canal (Claude Code → Telegram). Grau B é o próximo salto real.
- **W-8 shadow mode não gera alerta ativo:** os logs vão para `silenced_signals_log` mas o Diretor não vê o que o sistema *teria feito*. Falta o relatório de shadow — o Diretor não pode avaliar sem ver.
- **NOTEBOOKLM_FONTES/VANGUARD incompleta:** a pasta foi criada na sessão mas sem os arquivos base universais (00_INSTRUCAO_AUDITOR, 02_MEMORANDO, 05_PROCESSO, 06_TEMPLATES). MANIFEST VERMELHO ao fechar sessão.
- **pentalateral-graus-abc.md não carregada no Hermes:** o Hermes opera sem sua skill de referência. Gap de configuração que pode gerar comportamento inconsistente em interações futuras.

### OPORTUNIDADES

- **Pitch validado:** "Vanguard como primeiro caso do próprio produto" — NARRATIVA_FUNDADOR.md gerado. O diferencial de mercado é demonstrável: fundador que automatizou verificação e tem dados para provar.
- **Teto de projetos simultâneos:** com V28, a estimativa do Embaixador sobe de 3-5 para 6-10 projetos antes de saturar a atenção do Diretor. Capacidade de receita dobrada sem aumentar equipe.
- **Loop de confiança construível:** escada Grau A → B → C documentada. Em 30 dias com dados reais do shadow mode, a decisão de subir para Grau B é técnica, não de fé.

### AMEAÇAS

- **W-8 expira em 2026-06-14:** se o shadow mode não for avaliado antes dessa data, ou o sistema entra em produção sem validação (risco de falso positivo em cliente ativo) ou continua em shadow indefinidamente (automação travada).
- **ChurnWatch Valdece + Ingrid no limiar:** 3 dias sem contato (threshold 3). Se Hermes/W-8 não detectar e o Diretor não agir hoje, o próximo alerta já é VERMELHO — com cliente em Hypercare.
- **RLS do silenced_signals_log permissiva:** anon pode INSERT. Em produção com Grau B/C, um agente mal-configurado pode gravar lixo na tabela de sinal — corrompendo o aprendizado do W-8.

---

## PDCA — ANÁLISE DO CICLO V28

### PLAN (o que foi planejado)

- Arquitetura: Opção C Híbrida — Hermes (ignição) + n8n (orquestrador) + Claude API (verificação semântica)
- Signal Classifier em shadow mode 7 dias antes de qualquer ação real
- Gate de coerência semântica como prioridade 1 (E-1 Embaixador)
- Escopo fechado: ~8h core, 2-3 sessões

### DO (o que foi executado)

- ✅ Hermes Agent deploy EasyPanel — respondeu ao Telegram na sessão
- ✅ W-8 Signal Classifier importado no n8n, shadow mode ativo
- ✅ silenced_signals_log criada no Supabase com RLS
- ✅ gate_coerencia.ps1 + integração ao skill_parser_gate.ps1
- ✅ State Guard integrado ao session_start
- ✅ ping_hermes.ps1, sync_guard -WhatIf, N-4 executar_vereditos
- ✅ MEMORIA_EMBAIXADOR_VANGUARD.md + NARRATIVA_FUNDADOR.md
- ✅ RUNBOOK_EASYPANEL.md + RUNBOOK_SUPABASE_DDL.md
- ✅ P-115 + P-116 inscritos no LEDGER

### CHECK (o que ficou fora do plano)

- ❌ Templates Pentalateral + MANUAL_DIRETOR adiados (escopo grande, priorizou fechar V28 primeiro)
- ❌ Mensagens de atualização aos sócios sobre V28 não enviadas
- ❌ pentalateral-graus-abc.md não carregada no dashboard Hermes
- ❌ NOTEBOOKLM_FONTES/VANGUARD incompleta — MANIFEST VERMELHO
- ❌ relatorio_evolutivo não criado no session_close (gap corrigido nesta sessão)
- ⚠️ EasyPanel Compose BETA não injeta vars do painel "Ambiente" no container — workaround via `hermes config set` documentado no RUNBOOK

### ACT (o que muda no V29)

- Relatório de shadow mode: o W-8 precisa gerar summary semanal para o Diretor avaliar antes de 2026-06-14
- Hermes Grau B: após validação do shadow mode, subir delegação para "age + confirma em 15min"
- RLS silenced_signals_log: restringir INSERT ao service_role
- Integração W-8 → Hermes: sinal DELIBERAR-A dispara análise automática no Hermes

---

## 5W2H — PRÓXIMO LOOP (V29)

| Elemento | Resposta |
|---------|---------|
| **WHAT** | Hermes Grau B + relatório automático do W-8 shadow mode |
| **WHY** | Grau A não reduz custo cognitivo do Diretor. Grau B fecha o gap real. |
| **WHO** | Músculo build · Hermes executa · Diretor delibera escalações |
| **WHEN** | Depende da avaliação do shadow mode: data alvo **2026-06-14** (expiração W-8) |
| **WHERE** | EasyPanel hermes/hermes-agent + n8n + Supabase silenced_signals_log |
| **HOW** | (1) Relatório shadow mode automático via W-8 → Telegram · (2) Subir Grau B · (3) RLS restritiva |
| **HOW MUCH** | ~4h build (relatório shadow + Grau B) + 1h config (RLS + skill Hermes) |

---

## AVALIAÇÃO DO CONSULTOR

V28 entregou o que prometeu com uma ressignificação importante: o Embaixador identificou que o problema central não era automação — era verificação. Automatizar sem verificar é multiplicar erros. O P-116 nasce disso e vale mais que qualquer linha de código entregue neste loop.

O Hermes online é um marco — o Pentalateral tem agora seu primeiro componente 24h. Mas o risco real está na transição: um Hermes em Grau A sem skill carregada e com shadow mode não avaliado pelo Diretor é um componente caro e subaproveitado. A janela de 2026-06-14 é real — o Diretor precisa ver os dados do shadow antes que o prazo expire ou tomar decisão de prorrogar conscientemente.

Ponto positivo operacional: o V28 foi o primeiro loop onde o PROJETO INTERNO (VANGUARD) foi rastreado no WIP_BOARD com os mesmos campos de cliente — isso é evolução de maturidade do sistema.

---

*Relatório Evolutivo V28 · Músculo · Pentalateral IAH · 2026-06-07*
*Próxima etapa: Loop V29 — Gemini PASSO3 com M-1 a M-5 desta MEMORIA*
