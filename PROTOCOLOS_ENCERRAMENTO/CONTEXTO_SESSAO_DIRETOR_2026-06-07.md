# CONTEXTO DA SESSÃO — DIRETOR
**Data:** 2026-06-07 · **Loop:** V28 — Pentalateral Autônomo · **Status:** ENCERRADO

---

## 1. O QUE FOI CONSTRUÍDO

**Parte 1 (madrugada — ~01:06):**
- **Hermes Agent ONLINE** — deploy EasyPanel projeto hermes/hermes-agent. OpenRouter ✓ Telegram ✓ Gateway PID 251. Respondeu /status com estado real dos projetos.
- **W-8 Signal Classifier** — importado e ativado no n8n EasyPanel em shadow mode (expira 2026-06-14)
- **silenced_signals_log** — tabela Supabase criada com RLS (Eduardo rodou SQL manualmente)
- **RUNBOOK_EASYPANEL.md** — fonte canônica: deploy Compose BETA, erros conhecidos, comandos Hermes
- **RUNBOOK_SUPABASE_DDL.md** — fonte canônica: DDL, RLS, anon vs service role
- **MEMORIA_V27 + MEMORIA_V28** — loops fechados (P-045 gate desbloqueado)
- **CLAUDE.md v13** — Hermes como componente ativo, W-5/W-7/W-8 na tabela n8n
- **vanguard-protocolo.md v6.5** — Hermes + Graus A/B/C integrados ao loop
- **WIP_BOARD.json** — pendentes_v28 zerados, hermes_agent ONLINE documentado
- Commit: `5f3efbe feat(v28): V28 ENTREGUE`

**Parte 2 (tarde — sessão continuada):**
- **sync_ficou_no_ar.ps1** (NEW) — converte itens de "8. FICOU NO AR" do CONTEXTO em `[ ]` no PENDENTES.md automaticamente; integrado ao session_close.ps1 antes do webhook n8n. Commit: `010fec0`
- **hermes_skill_sync.ps1** (NEW) — gera comandos bash para carregar skills no Hermes via EasyPanel terminal. Commit: `010fec0`
- **GitHub secundário resolvido** — PAT `ghp_CR3P...` hardcoded em commit histórico `7838356` (PENDENTES.md:104) removido via `git filter-repo --replace-text`; force push bem-sucedido para `subdiretormnmsgm-commits/vanguard.git`. Commit final: `554d9c3`
- **session_close.ps1 — bloco Embaixador corrigido** — formato validado pelo Diretor: 7 documentos sem numeração + mensagem completa para colar. "Simples como coisa de soldado." Commit: `d7694e3`
- **Secretário Virtual — diagnóstico completo** — `SECRETARIO_VIRTUAL/main.py` existe (FastAPI + Haiku), `vanguard-briefing.netlify.app` submete para Formspree `xjglyyer`; gap: webhook Formspree → backend não configurado. Plano: próxima sessão.

---

## 2. DECISÕES TOMADAS

- **Hermes via OpenRouter** (não Anthropic direto) — Eduardo escolheu opção A
- **Env vars via `hermes config set`** (não docker-compose) — EasyPanel Compose BETA não injeta vars
- **Templates/MANUAL_DIRETOR adiados** — escopo grande, próxima sessão com deliberação
- **Mensagens aos sócios adiadas** — Eduardo priorizou fechar V28 primeiro
- **W-8 shadow mode** — 7 dias de observação antes de ativar ação real (expira 2026-06-14)
- **GitHub secundário: opção B (reescrita de histórico)** — Eduardo escolheu filter-repo em vez de clicar no link do GitHub
- **Secretário Virtual adiado** — diagnóstico feito, deploy e adaptação Formspree ficam para próxima sessão
- **Formato do bloco Embaixador validado** — "simples como coisa de soldado" — lista de arquivos + mensagem sem enumeração, sem blocos dinâmicos

---

## 3. DIREÇÃO DO DIRETOR

- "TEMOS QUE MUDAR VÁRIOS ARQUIVOS — A VANGUARD MUDOU" → confirmado: CLAUDE.md + protocolo atualizados
- "NÃO PREFERE FAZER HOJE?" → fez os 2 críticos agora, resto próxima sessão
- "SESSÃO SÓ FECHA QUANDO EU FALO OK" → registrado como regra de processo
- "SÓMENTE UMA MENSAGEM NO TERMINAL" → e-mail consolidado, não PASSO3/5/7 separados
- "O que você faz hoje repetirá amanhã e há stress para o Diretor" → processo deve ser confiável sem intervenção
- "Simples como coisa de soldado" → saída do terminal deve ser direta, sem enfeites, copiável
- "As ferramentas que implementamos não deveriam deixar os documentos atualizados?" → falha de processo identificada: CONTEXTO e MEMORIA devem ser atualizados automaticamente ou pelo Músculo sem precisar de lembrete

---

## 4. ESTADO DOS PROJETOS

| Projeto | Antes | Depois |
|---------|-------|--------|
| VANGUARD V28 | BUILD — pendentes abertos | ✅ ENTREGUE — Hermes ONLINE |
| Valdece | HYPERCARE | ⚠️ ChurnWatch: 3d sem contato — WhatsApp pendente |
| Ingrid | Loop 8 aguarda | ⚠️ ChurnWatch: 3d sem contato — WhatsApp pendente |

---

## 5. FRICÇÕES DO PROCESSO

- **EasyPanel Compose BETA não injeta env vars** — workaround: `hermes config set` persiste em `/opt/data/config.yaml`
- **YAML parsing errors** — `version:`, `container_name:`, `ports:` incompatíveis com Compose BETA
- **P-098 bloqueou vanguard-protocolo.md** — Eduardo precisou ver o texto antes de AUTORIZO (correto)
- **Músculo pediu AUTORIZO sem mostrar texto primeiro** — violação P-098, corrigido na sessão
- **GitHub Push Protection bloqueou push** — PAT em commit histórico `7838356`; resolvido com `git filter-repo --replace-text`
- **filter-repo removeu origin remoto** — comportamento esperado; remote readicionado manualmente após reescrita
- **Bloco Embaixador exibia paths errados** — bug de escaping no teste ad-hoc via Bash; script real estava correto
- **CONTEXTO e MEMORIA não atualizados após a segunda metade da sessão** — Músculo não executou P-032 proativamente; falha identificada pelo Diretor ("as ferramentas não deveriam garantir isso?")

---

## 6. O QUE O SISTEMA NÃO SABIA

- Hermes `nousresearch/hermes-agent` é imagem real MIT com OpenRouter nativo (não conceptual)
- EasyPanel Compose BETA: env vars do painel "Ambiente" NÃO chegam ao container
- Hermes lê `.env` em `/opt/hermes/` e config em `/opt/data/config.yaml` (volume)
- `/status` do Hermes já retornou estado real dos projetos (WIP_BOARD integrado)

---

## 7. DOCUMENTOS MORTOS / INCONSISTÊNCIAS

- `gemini=OK` no WIP_BOARD Loop 28 sem `12_DIRETRIZ_GEMINI_V28.txt` — corrigido para PENDENTE
- Templates Pentalateral desatualizados (Hermes não refletido) — pendente próxima sessão
- MANUAL_DIRETOR desatualizado — pendente próxima sessão

---

## 8. FICOU NO AR

- Mensagens aos sócios (Gemini/NotebookLM/Embaixador) sobre V28
- Templates Pentalateral + MANUAL_DIRETOR + SKILL_PROTOCOLO_VANGUARD
- Skill `pentalateral-graus-abc.md` upload no dashboard Hermes
- WhatsApp Valdece + Ingrid (ChurnWatch alertou)
- Deploy Secretário Virtual no EasyPanel (adaptar main.py para Formspree + configurar webhook)
- [diretor] Login no formspree.io para confirmar acesso ao formulário `xjglyyer`
- [diretor] Considerar abertura de MEI antes do primeiro contrato

---

## 9. PRÓXIMA SESSÃO

Deploy Secretário Virtual (Formspree → EasyPanel) + Templates + MANUAL_DIRETOR + verificar W-8 shadow mode (expira 2026-06-14).
