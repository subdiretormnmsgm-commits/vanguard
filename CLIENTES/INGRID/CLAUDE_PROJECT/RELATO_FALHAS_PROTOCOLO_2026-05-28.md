# RELATO DE FALHAS DE PROTOCOLO — 2026-05-28
> Para: Embaixador — Claude Projects
> De: Músculo — Pentalateral IAH
> Sessão: Loop 6 Build — INGRID

---

## FALHAS IDENTIFICADAS NESTA SESSÃO

### FALHA 1 — E-mail com caracteres corrompidos (recorrente)
- **O que aconteceu:** E-mail de fechamento chegou com caracteres especiais ilegíveis (ã, ç, ê, etc.)
- **Causa raiz:** `session_close.ps1` usava `WriteAllBytes` sem BOM. PS 5.1 interpreta como Windows-1252 sem BOM.
- **Corrigido em:** `session_close.ps1` — trocado para `Out-File -Encoding utf8` (grava BOM)
- **Status:** Fix commitado. Testar na próxima sessão.

### FALHA 2 — Tabela de pendentes ausente no e-mail
- **O que aconteceu:** E-mail mostrava no máximo 5 pendentes, sem formatação de tabela.
- **Causa raiz:** `Select-Object -First 5` no bloco do e-mail — limite arbitrário.
- **Corrigido em:** `session_close.ps1` — removido limite, mostra todos os pendentes.
- **Status:** Fix commitado.

### FALHA 3 — Painel de Atividades gerado mas localização desconhecida pelo Diretor
- **O que aconteceu:** Eduardo perguntou "Cadê o painel?" — foi gerado mas em pasta não comunicada claramente.
- **Localização:** `PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_2026-05-28.md`
- **Causa raiz:** Session close exibe o caminho no terminal mas Eduardo não viu / estava cansado.
- **Ação necessária:** E-mail de fechamento deve incluir o caminho do PAINEL de forma destacada.

### FALHA 4 — Protocolos não executados (relatado pelo Diretor)
- **O que aconteceu:** Eduardo reportou que "vários protocolos não são executados".
- **Protocolos em suspeita:**
  - [ ] P-069 MAPA DIÁRIO — apresentado ao Diretor no início da sessão?
  - [ ] P-063 PENDENTES.md lido completo no início?
  - [ ] P-032 MEMORIA_EMBAIXADOR atualizada após deliberação?
  - [ ] AUDITORIA DE DOCUMENTOS ao fechar (Gate 11)?
  - [ ] WIPE & SYNC lembrado ao encerrar loop?
- **Ação necessária:** Embaixador deve auditar quais protocolos do CLAUDE.md estão sendo sistematicamente pulados.

### FALHA 5 — Deploy Edge Functions: 1h+ de tentativas por problemas de permissão
- **O que aconteceu:** Deploy Supabase CLI falhou por 403 por múltiplos motivos:
  - Eduardo não era Owner da organização (só do projeto)
  - Token do CLI sobrescrevia o `$env:SUPABASE_ACCESS_TOKEN`
  - Dashboard exigia zip, mas zip também falhou
- **Causa raiz:** Falta de runbook de deploy documentado para projetos Supabase de clientes.
- **Ação necessária:** Criar `KNOWLEDGE_BASE/KB_SUPABASE_DEPLOY_CLIENTE.md` com:
  - Token deve ser da conta owner da ORG (não do projeto)
  - `$env:SUPABASE_ACCESS_TOKEN` deve ser setado DEPOIS do `npx supabase login`
  - Comandos devem ser colados UM POR UM no PowerShell

---

## SOLICITAÇÃO AO EMBAIXADOR

1. **Auditar sistematicamente** quais protocolos do CLAUDE.md (especialmente itens 0-29) não estão sendo executados pelo Músculo
2. **Gerar lista priorizada** de falhas recorrentes com base nesta sessão e nas anteriores
3. **Propor ajuste** no `session_close.ps1` para incluir o caminho do PAINEL no e-mail de fechamento
4. **Confirmar:** o Músculo está lendo PENDENTES.md completo no início de cada sessão conforme P-063?

---

**Próxima sessão:** 2026-05-29 (quinta-feira)
**Prioridade 1:** Testar G-5 com fix — deploy GitHub Pages v20
**Prioridade 2:** Resolver pendentes do PAINEL
