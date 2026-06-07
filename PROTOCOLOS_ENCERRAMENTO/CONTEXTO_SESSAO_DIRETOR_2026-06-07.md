# CONTEXTO DA SESSÃO — DIRETOR
**Data:** 2026-06-07 · **Loop:** V28 — Pentalateral Autônomo · **Status:** ENCERRADO

---

## 1. O QUE FOI CONSTRUÍDO

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

---

## 2. DECISÕES TOMADAS

- **Hermes via OpenRouter** (não Anthropic direto) — Eduardo escolheu opção A
- **Env vars via `hermes config set`** (não docker-compose) — EasyPanel Compose BETA não injeta vars
- **Templates/MANUAL_DIRETOR adiados** — escopo grande, próxima sessão com deliberação
- **Mensagens aos sócios adiadas** — Eduardo priorizou fechar V28 primeiro
- **W-8 shadow mode** — 7 dias de observação antes de ativar ação real (expira 2026-06-14)

---

## 3. DIREÇÃO DO DIRETOR

- "TEMOS QUE MUDAR VÁRIOS ARQUIVOS — A VANGUARD MUDOU" → confirmado: CLAUDE.md + protocolo atualizados
- "NÃO PREFERE FAZER HOJE?" → fez os 2 críticos agora, resto próxima sessão
- "SESSÃO SÓ FECHA QUANDO EU FALO OK" → registrado como regra de processo
- "SÓMENTE UMA MENSAGEM NO TERMINAL" → e-mail consolidado, não PASSO3/5/7 separados

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

---

## 9. PRÓXIMA SESSÃO

Atualizar Templates + MANUAL_DIRETOR + mensagens aos sócios — e verificar W-8 shadow mode (expira 2026-06-14).
