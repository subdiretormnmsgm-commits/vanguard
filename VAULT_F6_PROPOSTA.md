# VAULT SOBERANO — F6: Espelho Drive (`gdrive:vanguard`)

> Gerado: 2026-06-17 (quarta-feira) | Insumo: auditoria do aparato rclone + dry-run read-only com filtro de segredos.
> **STATUS: VERIFICAÇÃO FEITA (read-only). O PUSH REAL é ação de Gate 10 — aguarda decisão do Diretor (Seção 3).**
> **C1/P-169 ATIVO:** OneDrive é canônico; `gdrive:vanguard` é mirror read-only; sync só no Gate 10. Nunca varrer sobre mount.

---

## 0. ACHADO CENTRAL — O MIRROR JÁ EXISTE E ESTÁ CABEADO (consultor-first)

F6 **não constrói** nada. O espelhamento já está implementado e automatizado:
- **Comando canônico:** `session_close.ps1:651` (Gate 10) + `verify_gdrive_freshness.ps1:169` (auto-sync P-169).
  ```
  rclone sync . gdrive:vanguard --exclude ".git/**" --exclude ".playwright-mcp/**" --exclude ".serena/**"
        --exclude "node_modules/**" --exclude "*.pyc" --exclude-from scripts/rclone_secrets_exclude.txt
  ```
- **Firewall de segredos (P-185):** `.claude/hooks/rclone_secrets_guard.ps1` bloqueia qualquer `rclone sync/copy` para
  remoto SEM `--exclude-from`. `scripts/rclone_secrets_exclude.txt` espelha a seção de credenciais do `.gitignore`.
- **Freshness (P-168/P-169):** `verify_gdrive_freshness.ps1` confere por data+hora se o Drive está atrás do local.

→ **F6 = verificar que o mirror refletirá fielmente a reorg F2–F5 e que nenhum segredo vaza — depois deixar o
push real acontecer no Gate 10.** Não há código novo a escrever.

---

## 1. VERIFICAÇÃO EXECUTADA (dry-run read-only, 2026-06-17)

Comando: o canônico acima + `--dry-run` (não muta nada; passa pelo guard P-185 porque inclui o filtro).

| Métrica | Valor | Leitura |
|---|---|---|
| **Copy (novos)** | 288 | Arquivos da reorg que o Drive ainda não tem: `ACERVO_VANGUARD/`, `CONTEXTO_DIRETOR/*.md`, `_ARQUIVO/`, `VAULT_*`, docs relocados. |
| **Update** | 1 | `CLIENTES/WIP_BOARD.json` (board atualizado). |
| **Delete (no Drive)** | 270 | Caminhos ANTIGOS dos arquivos que a reorg moveu (ex.: `api/intelligence.py`, `js/scanner.js`, `quadrilateral/api/auditor.py` → agora sob `ACERVO_VANGUARD/`) + lixo (`.Rhistory`, `SYNC_REPORT` velho, 1 arquivo de nome corrompido). É o outro lado do `git mv` — mirror fiel. |
| **🔒 Segredos transferidos** | **0 (ZERO)** | Checagem explícita por `.env`/`CHAVES`/`N8N`/`Detalhes da chave`/`Projeto Supabase`/`settings.local`/`.flac`: lista **VAZIA**. Filtro P-185 confirmado. |

### Achado bônus — lixo a limpar no Drive
- `@{meta=; principles=System.Object[]; ...}` (16.9 KiB) — arquivo no Drive com **nome = hashtable PowerShell serializada**
  (bug de sync passado). Não existe no local → o mirror o **deleta** corretamente. Higiene grátis.

### Sobre os 270 deletes (não é perda de dados)
`rclone sync` torna o Drive um espelho EXATO do local. Como o local é canônico (C1) e a reorg foi intencional
(`git mv`, tudo reversível e versionado no git), os deletes são apenas os caminhos antigos sendo removidos —
o conteúdo correspondente já está nas linhas de **copy** sob o novo caminho. **Net = movimentação, não exclusão.**
O git permanece a rede de segurança: nada do Drive é fonte única.

---

## 2. O QUE *NÃO* SE TOCA / FIREWALL DESTA FASE
- **Segredos** (lista `rclone_secrets_exclude.txt`) — nunca ao Drive. Confirmado VAZIO no dry-run.
- **`.git/`, `.playwright-mcp/`, `.serena/`, `node_modules/`, `*.pyc`** — excluídos por padrão.
- **C1:** o sync REAL roda SÓ no Gate 10 (session_close) ou sob autorização explícita do Diretor. Nunca silenciosamente, nunca sobre mount.
- Direção única: **local → Drive** (push). Nunca Drive → local (o Drive jamais sobrescreve o canônico).

---

## 3. DECISÃO DO DIRETOR — COMO FAZER O PUSH REAL

A verificação está limpa (zero vazamento, deltas corretos). O push real é a única ação que falta, e é Gate 10:

- **(1) DEFERIR AO GATE 10 (estrito C1 — recomendado):** não rodo `rclone sync` agora. Ele acontece naturalmente
  quando você fechar a sessão (`session_close.ps1`). F6 fica "verificado + na fila". Zero risco de desvio de C1.
- **(2) PUSH AGORA (Gate 10 pontual):** você autoriza explicitamente "rodar Gate 10 agora" e eu executo o
  `rclone sync` canônico imediatamente, trazendo o Drive ao dia (288 copy / 270 delete / 0 segredo). Reversível via git no local.

→ Responda **F6-DEFERIR** ou **F6-PUSH-AGORA**.

---

## 4. SEQUÊNCIA PÓS-DECISÃO
1. Commit deste doc de verificação (`refactor(vault): F6 verificacao mirror Drive`) — sem código, sem canônico, sem [RESOLVE:].
2. Se F6-PUSH-AGORA: rodar o `rclone sync` canônico + `verify_gdrive_freshness.ps1` para confirmar GREEN.
3. Se F6-DEFERIR: marcar PENDENTES "F6 verificado — push no próximo Gate 10".
4. Próximo: **F7 — Detector de Deriva** (fecha o guarda-chuva #11). Última fase da Operação Vault Soberano.

---

**Gate BLOQUEANTE C1:** o `rclone sync` real não roda sem Gate 10 ou seu SIM explícito. A verificação prova que, quando rodar, o Drive vira espelho fiel do vault reorganizado — sem um único segredo a bordo.
