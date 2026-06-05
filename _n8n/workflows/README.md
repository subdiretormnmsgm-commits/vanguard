# _n8n/workflows/ — n8n-as-code

Todo workflow do n8n EasyPanel exportado como JSON vive nesta pasta.
Esta pasta é o que permite ao Auditor (NotebookLM) auditar a camada de automação.

## Regra

Após qualquer mudança em workflow no EasyPanel:

```powershell
.\scripts\n8n_export.ps1
git add _n8n/workflows/
git commit -m "chore(n8n): atualizar workflow [nome]"
```

## Workflows ativos

| Arquivo | Workflow EasyPanel | Status |
|---|---|---|
| `w1_checkin.json` | W-1 Check-in | pendente export |
| `w2_monitor_supabase.json` | W-2 Monitor Supabase | pendente export |
| `w3_github_push.json` | W-3 GitHub Push | pendente export |
| `w4_session_close.json` | W-4 Session Close | pendente export |
| `w7_veredito_telegram.json` | W-7 Veredito Telegram | pendente export |

## Linter

`scripts/n8n_audit.ps1` — roda automaticamente no session_close (GATE 7B).
Falha se encontrar lógica de julgamento hardcoded em qualquer node JS.
Exceção: linha com comentário `// LEDGER: [razão]` passa e gera entrada no N8N_AUDIT_REPORT.md.

## Config

`_n8n/N8N_CONFIG.json` — fonte canônica de todos os valores de julgamento.
Lido pelo n8n em runtime via `GET raw.githubusercontent.com/.../N8N_CONFIG.json`.
