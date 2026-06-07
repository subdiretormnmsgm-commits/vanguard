# MAINTENANCE COST — Fallbacks P-110 para Workflows n8n
> Versão: 1.0 · 2026-06-05 · Pentalateral IAH
> P-110: todo workflow crítico tem fallback manual ≤ 3 passos
> Atualizar sempre que workflow for criado, modificado ou desativado

---

## COMO USAR ESTE DOCUMENTO

Se o n8n (EasyPanel) ficar offline ou um workflow falhar:
1. Identificar o workflow afetado na tabela abaixo
2. Executar os passos do fallback na ordem indicada
3. Registrar a ocorrência em `KNOWLEDGE_BASE/` do projeto afetado

**Verificar status n8n:**
```powershell
.\scripts\ping_n8n.ps1
# Se offline → executar fallbacks manuais abaixo
```

---

## W-1 — Check-in Diário (Cron 7h/13h/20h)

**O que faz:** Status dos projetos → Telegram + Notion WIP Board

**Fallback (3 passos):**
1. Abrir WIP_BOARD.md e verificar projetos ativos
2. Enviar mensagem manual no Telegram com status dos projetos críticos
3. Nenhuma ação necessária no Notion (P-109: Notion = output, não entrada)

**Impacto se falhar:** Diretor não recebe briefing automático — baixo impacto (informacional)

---

## W-2 — Monitor Supabase (Cron horário)

**O que faz:** Verifica se Supabase está online → Telegram se offline

**Fallback (3 passos):**
1. Acessar manualmente: `https://app.supabase.com` → verificar projeto ativo
2. Testar endpoint: `curl https://[PROJETO_ID].supabase.co/rest/v1/ -H "apikey: [KEY]"`
3. Se offline → abrir ticket em https://status.supabase.com

**Impacto se falhar:** Alertas de downtime do Supabase não chegam — baixo impacto (monitor redundante)

---

## W-3 — GitHub Push (Webhook GitHub)

**O que faz:** Ao fazer push → notifica Telegram + atualiza Notion WIP Board

**Fallback (3 passos):**
1. Verificar commits: `git log --oneline -5`
2. Postar manualmente no Telegram: "[PROJETO] Commit: [hash] — [mensagem]"
3. Atualizar Notion manualmente se necessário (ou ignorar — P-109 Notion é output)

**Impacto se falhar:** Diretor não recebe notificação de push — médio impacto (tracking manual)

---

## W-4 — Session Close (Webhook POST)

**O que faz:** Ao rodar session_close.ps1 → resumo → Telegram + Notion WIP + Pendentes

**Fallback (3 passos):**
1. Rodar: `.\scripts\session_close.ps1` (já gera e-mail + PROTOCOLO_ENCERRAMENTO)
2. Enviar e-mail manualmente para subdiretor.mnmsgm@gmail.com com resumo da sessão
3. O PAINEL_ATIVIDADES gerado pelo script já captura o estado — não precisa do Notion

**Impacto se falhar:** Resumo não vai ao Notion — baixo impacto (PROTOCOLO_ENCERRAMENTO já existe)

---

## W-7 — Veredito via Telegram (Trigger: /aprovar /rejeitar /veredito)

**O que faz:** Diretor envia comando Telegram → registra veredito → atualiza Notion Pendentes

**Fallback (3 passos):**
1. Abrir `CLIENTES/[CLIENTE]/CLAUDE_PROJECT/DECISOES/DECISOES_[DATA].json`
2. Editar manualmente o campo `status` de cada decisão: `"APROVADO"` ou `"REJEITADO"`
3. Rodar: `.\scripts\executar_vereditos.ps1 -cliente [NOME]`

**⚠️ RISCO P-072:** Este workflow DEVE atualizar o DECISOES.json local após cada veredito.
Se não sincronizar → estado assíncrono → usar o fallback manual acima para garantir integridade.

**Impacto se falhar:** ALTO — vereditos ficam presos sem execução. Usar fallback imediatamente.

---

## W-5 — ChurnWatch (gate: 2026-06-12)

**Status:** Em staging — não está em produção ainda.
**Fallback (quando ativo):**
1. Rodar: `.\scripts\churn_watch_autonomo.ps1`
2. Verificar `ultimo_contato_cliente` no WIP_BOARD.json para cada projeto
3. Enviar mensagem manual ao Telegram se cliente >7 dias sem contato

---

## W-6 — Embaixador API (gate: 30 dias FASE 1)

**Status:** Em staging — não está em produção ainda.
**Fallback (quando ativo):**
1. Rodar: `.\scripts\ir_ao_embaixador.ps1 -cliente [NOME]`
2. Copiar mensagem do clipboard para o Claude Projects manualmente
3. Aguardar resposta e processar manualmente

---

## W-8 — Signal Classifier (Shadow Mode → Produção)

**O que faz:** Categoriza sinais de W-1/W-5/W-3 em [AUTO-RESOLVE] / [INFORMAR] / [DELIBERAR-A/B/C] antes de qualquer notificação. Em shadow mode: classifica mas não bloqueia.

**Fallback (3 passos):**
1. Se W-8 offline: W-1/W-5/W-3 continuam enviando para Telegram diretamente (comportamento pré-V28 — zero perda de alertas)
2. Verificar `silenced_signals_log` no Supabase para auditoria manual dos sinais silenciados
3. Reativar W-8 via EasyPanel → n8n → ativar workflow "Signal Classifier"

**Impacto se falhar:** Shadow mode: zero impacto (sinais passam direto). Produção: sem classificação — alertas voltam ao volume pré-V28. Reverter para comportamento anterior é o fallback.

---

## W-9 — Inversão do Auditor / Hash Check (Cron: abertura de sessão)

**O que faz:** Verifica hash de `NOTEBOOKLM_FONTES/` vs data da DIRETRIZ mais recente. Se FONTES desatualizadas → alerta na abertura de sessão Claude Code.

**Fallback (3 passos):**
1. Rodar manualmente: `.\scripts\sync_vanguard_docs.ps1` — força sync de todos os docs
2. Verificar manualmente: `CLIENTES/[CLIENTE]/NOTEBOOKLM_FONTES/12_DIRETRIZ_GEMINI_V*.txt` — data vs DIRETRIZ em disco
3. Se defasado → preparar_notebooklm_projeto.ps1 -cliente [NOME] antes de ir ao NotebookLM

**Impacto se falhar:** Auditor pode receber fontes desatualizadas — médio impacto. Fallback manual via script existente.

---

## HERMES AGENT — Daemon Persistente (Docker EasyPanel)

**O que faz:** Motor autônomo 24/7. Detecta sinais classificados pelo W-8, age conforme graus A/B/C, chama `claude -p` para execução de Grau C, monta briefing diário via email.

**Fallback (3 passos):**
1. Se Hermes offline: `n8n` assume notificações (W-1/W-5 continuam funcionando independentemente)
2. Briefing manual: abrir WIP_BOARD.md + PENDENTES.md no início da sessão (comportamento atual do session_start)
3. Reiniciar container Hermes: EasyPanel → serviço hermes-agent → Restart

**⚠️ RISCO CRÍTICO P-110:** Se Hermes ficar offline e n8n também → Eduardo opera com session_start manual apenas. Verificar com `ping_n8n.ps1` + `ping_hermes.ps1` (a criar).

**Impacto se falhar:** ALTO — loop autônomo para. Eduardo volta a ser a ignição. Fallback é o estado pré-V28 — reversível e seguro.

**Graus A/B/C — fallback específico:**
- Grau A offline: Eduardo recebe email normalmente (Hermes envia antes de agir) → delibera via painel
- Grau B offline: tarefa fica em fila no SQLite do Hermes até ele voltar online
- Grau C offline: n8n loga o sinal em `silenced_signals_log` — Músculo processa na próxima sessão

---

## DIAGNÓSTICO RÁPIDO — SE TUDO PARAR

```powershell
# 1. Verificar uptime n8n
.\scripts\ping_n8n.ps1

# 2. Verificar credenciais (não expor no terminal)
# (verificar N8N Easypanel.txt — arquivo gitignored)

# 3. Verificar EasyPanel diretamente
# https://vanguard-vanguard-n8n.0ul9nk.easypanel.host

# 4. Se n8n inacessível → verificar EasyPanel admin panel
# Deploy pode ter falhado — verificar logs de container
```

---

*Versão: 2.0 · 2026-06-06 · V28 — Signal Classifier + W-9 + Hermes Agent adicionados*
