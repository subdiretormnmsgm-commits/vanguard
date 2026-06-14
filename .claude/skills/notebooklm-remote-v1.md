---
name: notebooklm-remote-v1
description: "Camada tecnica pura para operar o NotebookLM via Playwright MCP (RPA) — navegar, Wipe & Sync de fontes, enviar PASSO5, extrair Skill. Invocar antes de qualquer operacao remota no NotebookLM. Primario: CLI notebooklm-py. Fallback: esta skill."
---

SKILL: notebooklm-remote-v1.md
Camada: Infraestrutura Pentalateral (Universal) | Stack: NotebookLM + Playwright MCP (RPA) + notebooklm-py (CLI primario)

[AUDITORIA DE COERENCIA]
O NotebookLM nao tem API publica. Caminho primario: CLI notebooklm-py (ver notebooklm-pentalateral-v3.md). Caminho secundario (fallback/RPA): Playwright MCP — usar quando CLI falha por token expirado, timeout ou operacao nao suportada pela CLI. Coerencia com P-033: wipe e sync das fontes a cada loop — nunca empilhar versoes antigas. Coerencia com P-059: cada cliente tem caderno isolado com prefixo "[YYYY-MM] [CLIENTE]" — nunca operar caderno errado. Coerencia com P-110: arquivos locais sao a fonte canonica — NotebookLM recebe copias de leitura de NOTEBOOKLM_FONTES/. Coerencia com P-053: fontes do modo CLIENTE vem EXCLUSIVAMENTE de NOTEBOOKLM_FONTES/ do repo — nunca URL externa. Login: conta subdiretor.mnmsgm@gmail.com via Google. Caderno VANGUARD: ID d7dab0e1. Esta skill documenta O COMO tecnico — o O QUE (quais fontes, qual prompt) esta em notebooklm-pentalateral-v3.md.

[CONEXAO HISTORICA]
Acesso remoto via Playwright validado em multiplos loops desde Loop 29 (2026-06-09). Caderno VANGUARD (d7dab0e1) — Wipe & Sync realizado Loop 30 (2026-06-09). Erro historico critico: usar conta Google errada no Playwright — caderno nao aparece na lista. Conta correta sempre: subdiretor.mnmsgm@gmail.com. CLI notebooklm-py falha com Python 3.13+ (rookiepy nao compila) — Playwright e o fallback garantido neste cenario. LEDGER P-033: Wipe & Sync e mandatorio ao fechar qualquer loop de cliente — sem isso, o Auditor analisa fontes antigas misturadas com novas. P-125: disparo de audio/video e fire-and-forget — nunca aguardar sincronamente. Refs: INTELLIGENCE_LEDGER.md P-033/P-059/P-053/P-125, notebooklm-pentalateral-v3.md, caderno d7dab0e1.

[PADRAO DE SUCESSO/FALHA]
SUCESSO VALIDADO — Wipe via Playwright: navegar para caderno -> selecionar todas as fontes -> excluir uma a uma com snapshot entre cada exclusao (refs mudam apos cada delete, identico ao Claude Projects).
SUCESSO VALIDADO — Upload de fontes: clicar "Adicionar fontes" -> "Fazer upload de arquivo" -> file chooser ativo -> browser_file_upload com lista de paths de NOTEBOOKLM_FONTES/ -> confirmar status=ready via snapshot antes de enviar prompt.
SUCESSO VALIDADO — Envio do PASSO5 via chat: browser_type no campo de input do NotebookLM -> browser_press_key Enter -> aguardar resposta completa antes de extrair.
FALHA (BLOQUEANTE) — Conta Google errada no Playwright: caderno do cliente nao aparece, lista mostra cadernos de outra conta. Sempre verificar que o login e subdiretor.mnmsgm@gmail.com antes de qualquer operacao.
FALHA (BLOQUEANTE) — Upload de fontes sem Wipe previo: NotebookLM empilha versoes — Auditor analisa contexto hibrido de datas diferentes. P-033 violado.
FALHA — Aguardar audio/video sincronamente (P-125): Playwright trava esperando geracao que pode levar horas. Disparar e soltar — checar artifact list em sessao separada.
GATE APRENDIDO — Verificar status=ready de TODAS as fontes antes de enviar o prompt do PASSO5. Fonte em processamento retorna resposta incompleta ou alucinada.

[PERSPECTIVA DO SOCIO]
Como Socio-Consultor, o NotebookLM via Playwright e mais fragil que o Claude Projects: a UI do Google muda com mais frequencia e os seletores podem quebrar silenciosamente. Recomendacoes obrigatorias: (1) SEMPRE browser_snapshot antes de qualquer acao para obter refs atuais; (2) verificar login antes de operar — se URL redirecionar para tela Google, fazer login com subdiretor.mnmsgm@gmail.com; (3) confirmar que o caderno correto esta selecionado via titulo antes de iniciar Wipe — um Wipe no caderno errado destroi o trabalho de outro cliente (P-059 critico); (4) verificar status de todas as fontes via snapshot antes de enviar o PASSO5 — fonte nao processada gera Skill invalida que vai falhar no skill_parser_gate. IDEIA DISRUPTIVA: criar script notebooklm_wipe_sync.ps1 que executa Playwright automaticamente com os comandos RPA — eliminando necessidade do Musculo montar o fluxo manualmente toda vez. PROPONHO adicionar ao PENDENTES como item [musculo] para o proximo ciclo de infraestrutura.

---

## DECISAO DE CAMINHO — CLI vs RPA

| Situacao | Caminho |
|----------|---------|
| Token valido (auth check ok) | CLI notebooklm-py (notebooklm-pentalateral-v3) |
| Token expirado / Python 3.13+ | Playwright RPA (esta skill) |
| Operacao nao suportada pela CLI | Playwright RPA (esta skill) |

Verificar antes: `notebooklm auth check --test --json` → se token_fetch=true → CLI. Se false → RPA.

## FLUXO RPA VIA PLAYWRIGHT

### Login e navegacao
1. browser_navigate "https://notebooklm.google.com"
2. Se redirecionar para login Google → browser_click "Fazer login" → selecionar subdiretor.mnmsgm@gmail.com
3. browser_snapshot → localizar o caderno pelo titulo "[YYYY-MM] [CLIENTE]"
4. browser_click no caderno correto

### Wipe das fontes (P-033 — obrigatorio antes de cada sync)
1. browser_snapshot → listar todas as fontes com suas refs
2. Para cada fonte: browser_click botao excluir → browser_snapshot (ref muda apos cada delete)
3. Confirmar lista vazia via snapshot antes de prosseguir

### Upload de fontes (NOTEBOOKLM_FONTES/ do cliente)
1. browser_click "Adicionar fontes" → submenu aparece
2. browser_click "Fazer upload de arquivo" → file chooser ativo
3. browser_file_upload paths=[lista de NOTEBOOKLM_FONTES/ do cliente] → imediatamente
4. browser_snapshot → aguardar status=ready em todas as fontes antes de prosseguir

### Envio do PASSO5 e extracao da Skill
1. browser_click no campo de chat do NotebookLM
2. browser_type conteudo do PASSO5_PROMPT (ou usar --prompt-file via CLI)
3. browser_press_key "Enter"
4. Aguardar resposta completa (browser_wait_for ou snapshot periodico)
5. Extrair texto da resposta → salvar em .claude/skills/[cliente]-v[N].md
6. Rodar: scripts\skill_parser_gate.ps1 -skill ".claude\skills\[cliente]-v[N].md"