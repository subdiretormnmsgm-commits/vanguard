# PROTOCOLO DE ENCERRAMENTO — PROJETO PESSOAL DO DIRETOR · BASE DE CONSULTAS ASSE CT ORÇ (DCEM)

**Data da sessão: 11–12/07/2026 · Loop 1 (isolado P-059 · empresa Vanguard PAUSADA)**

> ⚠️ CONTEXTO DE ISOLAMENTO (ler antes de tudo): este é projeto PESSOAL do Diretor. NÃO é cliente Vanguard.
> Não engajar CLIENTES/, WIP_BOARD, ChurnWatch, Cowork, n8n, nichos ou loops de cliente.
> Máquina autônoma permanece pausada. Ao gerar o BLOCO 0, tratar SÓ o DCEM.

---

## SEMÁFORO DO PROJETO
- 🟢 VERDE — Fase 2 (captura Web App) entregue, no ar e testada ao vivo. Nenhum bloqueio técnico aberto.
- 🟡 AMARELO — 2 decisões do Diretor pendentes (endereço elegante + método do QR). Não bloqueiam, mas travam o próximo passo.

## O QUE FOI FEITO NESTA SESSÃO
1. Design premium (grafite escuro + acento ciano contido, logo DCEM embutido, rótulos em maiúsculas, selo "≈60s") portado para o arquivo real `captura.html`, mantendo o motor `captura_webapp.gs` 100% intacto.
2. 3 edições de copy aplicadas por veredito do Diretor:
   - (a) subtítulo agora "Asse Ct Orç — Consulta de indenização de movimentação/deslocamento";
   - (b) "Seção" com S maiúsculo onde aparecia minúsculo;
   - (c) rodapé simplificado — removido o jargão "dados em repouso" e "nada sai para fora do Google". Rodapé final: "Seus dados ficam 100% na conta da Seção. A resposta oficial vai por e-mail."
3. Deploy remoto feito pelo Músculo via automação de navegador — Versão 4, MESMO /exec, sem novo OAuth. Render confirmado ao vivo: as 3 edições corretas, sem quebra de layout, contador 0/600, sem campo de data.

## ESTADO REAL EM DISCO (fonte de verdade)
- `captura.html` — form premium portado (~75 KB, logo base64). Editado e salvo.
- `captura_webapp.gs` — backend intacto (13 seções válidas, doPostData grava A–G, protocolo CONS-AAAAMMDD-NNN, e-mail de confirmação). NÃO tocado.
- `LOOP_STATE.json` — Fase 2 "ENTREGUE E EM TESTE".
- Deploy vivo: Versão 5 no /exec (12/07 10:44). URL COMPLETA E VERIFICADA (GATE DE FATO): `https://script.google.com/macros/s/AKfycbyZW1XO8edEEk1szLPoax4Yml1NvIUBzfp4ZzHz6Jc4oQvobz99wH3p-YhdRRLV8LzSdw/exec` (tail correto `RRLV8LzSdw`, extraído da fonte viva). Subtítulo atualizado para "Asse Ct Orç — Formulário de dúvidas" — confirmado renderizado ao vivo.

## DECISÕES JÁ TRAVADAS (não reabrir)
- Campo de data ("preciso da resposta até") REMOVIDO.
- Leitura DINÂMICA dos Casos-Tipo da aba CASOS mantida.
- Formato de protocolo CONS-AAAAMMDD-NNN mantido.
- Limite do "Descreva o fato" = 600 caracteres.
- Autorização/login OAuth do Google fica SEMPRE com o Diretor — o Músculo para e entrega o clique.

## PENDÊNCIAS PARA A PRÓXIMA SESSÃO (aguardam veredito do Diretor)
1. **ENDEREÇO NA INTERNET** — a URL /exec é longa e não-editável (limitação do Apps Script). Opções deliberadas:
   - (A) só QR sobre o /exec — 100% soberano, imediato **[recomendada]**;
   - (B) Google Site na conta orcamentariodcem para ter link ditável, ~20 min, continua dentro do Google;
   - (C) encurtador — DESCARTADO (fura o trilho "não sai do Google").
   - Falta o Diretor escolher A ou B.
2. **QR CODE** — gerar imagem apontando para o endereço final (depende da decisão 1). Método soberano/offline: HTML autocontido (sem instalar nada) ou Python local (instala módulo `qrcode`). Falta o Diretor escolher o método.

## BACKLOG JÁ ROTEIRIZADO (Fase 2.1+, deliberado, sem "vai")
- Ideia 2 (terminal do curador) PRIORITÁRIA → depois ideia 1 (deep-link) + ideia 3 (gatilho de doutrina). Ideia 4 descartada · ideia 5 só V3.
- Fase 3 = motor de notificação (MailApp + UrlFetchApp Telegram, nativo). Fase 6 = camada de consulta com IA (Caminho A, zero-retention).
- **ACHADO DE INTEGRIDADE a tratar na 2.1:** no `doPostData` a linha é gravada ANTES do envio do e-mail; falha de e-mail persiste a linha mas retorna sucesso=false → risco latente de duplicidade.

## LEMBRETE DE MISSÃO (para o Embaixador ancorar o BLOCO 0)
O produto é a MEMÓRIA da Seção, não o formulário — reter o conhecimento tácito de resolução rápida do militar experiente que hoje se perde quando ele é movimentado. Dado em repouso 100% na conta orcamentariodcem.

## 3 AÇÕES DO DIRETOR PARA ABRIR A PRÓXIMA SESSÃO
1. Decidir o endereço: Opção A (só QR) ou B (Google Site ditável).
2. Decidir o método do QR: HTML autocontido ou Python local.
3. Colar o BLOCO 0 (gerado pelo Embaixador a partir deste protocolo) no chat ao abrir, para o Músculo retomar sem perda de contexto.
