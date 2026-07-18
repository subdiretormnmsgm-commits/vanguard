# KB — Redeploy de Apps Script sem clasp: canal clipboard → Monaco

- **Projeto:** DCEM · Base de Consultas (Asse Ct Orç)
- **Data de origem:** 2026-07-17
- **Contexto:** transferir `captura_webapp.gs` V10→V11 para o editor Apps Script (`script.google.com`)
  quando NÃO há `clasp`/API habilitada e o objetivo é preservar o `/exec` existente (QR vivo).

## Problema
Para atualizar o Web App `/exec` sem matar o QR, é preciso colar o novo código no editor
Apps Script e redeployar como **"Nova versão" da implantação existente** (nunca "Nova
implantação"). Dois canais de transferência de conteúdo FALHARAM:

1. **`file_upload` do browser tool** — passou a rejeitar caminho de host:
   ```
   file_upload no longer accepts host filesystem paths. The MCP controller must read
   the file and pass its contents via the `files` parameter.
   ```
2. **Loopback de rede (servir o arquivo em `127.0.0.1:PORTA` e `fetch` no browser)** —
   bloqueado por **PNA (Private Network Access)**: página pública (`script.google.com`)
   não pode buscar `localhost`.

Digitar/transcrever o arquivo à mão está proibido (risco de 1 char errado em 20 mil).

## Solução — canal clipboard → Monaco (o que funcionou)
O editor Apps Script usa **Monaco**. O caminho confiável, zero-transcrição:

1. **Carregar o conteúdo exato no clipboard do SO** (PowerShell):
   ```powershell
   $txt = [System.IO.File]::ReadAllText($caminhoDoArquivo)
   Add-Type -AssemblyName System.Windows.Forms
   [System.Windows.Forms.Clipboard]::SetText($txt)
   ```
   > Resolver o caminho por glob/wildcard — o literal "Área de Trabalho" corrompe para
   > "Ãrea" em alguns contextos de tool (encoding). Ver KB de paths acentuados.

2. **No browser, focar o Monaco e selecionar tudo** (via `javascript_tool`/console):
   ```javascript
   const e = monaco.editor.getEditors()[0];
   e.focus();
   const m = e.getModel();
   e.setSelection(m.getFullModelRange());
   ```

3. **Ctrl+V** pelo `computer` tool (colagem real do SO — dispara o handler nativo do Monaco).

4. **GATE SHA-256 antes de salvar** — ler o conteúdo do modelo e conferir o hash contra a
   fonte aprovada. Só salvar se bater:
   ```javascript
   monaco.editor.getEditors()[0].getModel().getValue().length   // confere nº de chars
   ```
   (hash calculado por fora; no DCEM V11 = `38a7aed8…64afe6c`, 20117 chars / 21006 bytes).

5. **Ctrl+S** para salvar.

## Armadilhas observadas
- **Byte count difere (local vs modelo):** o arquivo local tem CRLF; o `getValue()` do
  Monaco devolve LF-normalizado. A diferença = nº de linhas (cada CRLF perde 1 byte).
  **Não é corrupção** — comparar por conteúdo/hash normalizado, não por byte bruto.
- **Aria-live "Salvando o projeto…" que não vira "Salvo":** o elemento de status (width 0,
  fora da tela) pode reter o template e não atualizar. **Confirmar o save de outra forma:**
  a aba do arquivo perde o marcador de "não salvo" (bolinha), e o renderer volta a responder
  (um screenshot que antes dava timeout CDP volta a funcionar = save concluído).
- **Screenshot com timeout CDP durante o save** (`Page.captureScreenshot timed out after
  30000ms`): o renderer está ocupado salvando. Reintentar após o save concluir.

## Redeploy sem matar o QR (parte crítica)
Implantar → **Gerenciar implantações** → editar (lápis) a implantação existente →
dropdown **Versão** → **"Nova versão"** → Implantar. Isso **preserva o tail** do `/exec`
(no DCEM: `…RRLV8LzSdw/exec`) e **não dispara tela de consentimento OAuth**.
"Nova implantação" geraria outro `/exec` → QR morto. Confirmar o tail em `ENDERECO_EXEC.txt`
(nunca de memória).

## Verificação pós-deploy (V11-only)
Handler exclusivo da V11 responde → prova de que a versão nova está no ar:
```
GET /exec?mode=satisfacao&id=<qualquer>&r=sim
→ {"sucesso":false,"erro":"Protocolo não encontrado."}   (JSON = V11 ativa)
```

## Padrão reutilizável
Qualquer redeploy de Apps Script sem clasp: **clipboard (PowerShell SetText) → focar Monaco
→ selecionar tudo → Ctrl+V → gate SHA → Ctrl+S → "Nova versão" da implantação existente**.
É o canal de transferência exata (zero transcrição) quando `file_upload` e loopback falham.
