---
name: embaixador-remote-v1
description: "Invocar SEMPRE que houver qualquer interacao com o Embaixador (Claude Projects) — inclui upload de arquivos, exclusao, envio de mensagens, solicitacao de BLOCO 0. Protocolo completo Playwright + fluxo canonico."
---

SKILL: embaixador-remote-v1.md
Camada: Pentalateral IAH (5o Membro) | Loop: Operacao Claude Projects 2026-06-14 | Stack: Claude.ai Projects + Playwright MCP + browser_file_upload

[AUDITORIA DE COERENCIA]
O Embaixador opera via Claude Projects (claude.ai/project/019e4c70-7e31-75d4-a568-cbb1077fb439), conta subdiretor.mnmsgm@gmail.com. NAO tem API publica - todas as operacoes (upload, exclusao, mensagem, BLOCO 0) sao feitas via Playwright MCP. O protocolo esta em conformidade com P-114 (BLOCO 0 obrigatorio na abertura), P-032 (MEMORIA_EMBAIXADOR automatica apos deliberacao), P-033 (sync universal antes do upload). Coerencia confirmada: arquivos locais sao a fonte canonica (P-110) - o Claude Projects recebe copias para contexto, nunca edita originais. O Embaixador le os 7 arquivos e gera BLOCO 0 somente em texto simples (nunca HTML - leva mais de 5 min e trava o fechamento: decisao do Diretor 2026-06-14). Gate critico: excluir TODOS os arquivos antigos ANTES do upload - Claude Projects nao sobrescreve, empilha versoes.

[CONEXAO HISTORICA]
Operacao inaugural 2026-06-14 (Loop 33 V2, LEDGER P-114): Musculo excluiu 7 arquivos da sessao 2026-06-13 e fez upload dos 7 atualizados. Erros descobertos: (1) 16_VANGUARD_TIMELINE.md tem path em CLIENTES\VANGUARD\CLAUDE_PROJECT\, nao em NOTEBOOKLM_FONTES\ - ENOENT se usar path errado; (2) browser_click exige parametro target (string), nao ref (objeto) - erro "expected string, received undefined"; (3) Embaixador gera BLOCO 0 completo apenas ao ouvir "abrir sessao" - ao encerrar, so confirma em 1 linha; (4) pedido HTML artefato travou por mais de 5 min sem resposta - texto simples sempre. Refs: P-032, P-114, MEMORIA_EMBAIXADOR_VANGUARD.md, WIP_BOARD.json Loop 33, INTELLIGENCE_LEDGER.md P-160.

[PADRAO DE SUCESSO/FALHA]
SUCESSO VALIDADO - Exclusao sequencial com snapshot entre cada arquivo: clicar Excluir do arquivo N -> aguardar snapshot -> obter ref atualizada -> clicar proximo. Refs mudam apos cada exclusao. Validado 2026-06-14 (7 arquivos excluidos, ~5 min).
SUCESSO VALIDADO - Upload simultaneo via browser_file_upload: clicar "Adicionar arquivos" -> "Carregar do aparelho" -> file chooser ativo -> chamar browser_file_upload com lista de 7 paths absolutos em uma unica chamada. Validado 2026-06-14 (~30s).
SUCESSO VALIDADO - BLOCO 0 em texto simples: Embaixador responde em ~60s sem travar.
FALHA (BLOQUEANTE) - Upload sem excluir arquivos antigos: Claude Projects empilha versoes, Embaixador le documentos duplicados e mistura contexto de datas.
FALHA - HTML artefato no BLOCO 0: Embaixador fica "Trabalhando..." por mais de 5 min. Interromper e re-solicitar em texto.
FALHA - browser_file_upload com file chooser inativo: erro "no active file chooser". Chooser so fica ativo apos clicar "Carregar do aparelho". A janela fecha em segundos - chamar browser_file_upload imediatamente apos o clique.
GATE APRENDIDO: Verificar paths com Glob antes de iniciar. 16_VANGUARD_TIMELINE.md esta em CLIENTES\VANGUARD\CLAUDE_PROJECT\ - nao em NOTEBOOKLM_FONTES\.

[PERSPECTIVA DO SOCIO]
Como Socio-Consultor, emito alerta: o Embaixador e o unico membro com memoria persistente do cliente entre sessoes (LEDGER P-031). Recomendacoes obrigatorias: (1) SEMPRE verificar com Glob os 7 paths antes de iniciar - um path errado causa ENOENT silencioso; (2) NUNCA pular exclusao dos arquivos antigos - versoes misturadas corrompem o contexto; (3) confirmar upload via snapshot - verificar nome e tamanho de cada arquivo; (4) texto simples sempre no BLOCO 0 - Diretor declarou 2026-06-14 apos HTML travar sessao; (5) ao receber 1 linha de confirmacao apos mensagem de encerramento, isso e correto - solicitar BLOCO 0 explicitamente. IDEIA DISRUPTIVA: criar modulo ir_ao_embaixador.ps1 -AutoUpload que executa exclusao + upload automaticamente sem intervencao do Musculo alem do disparo. PROPONHO adicionar ao PENDENTES como [musculo] para o proximo ciclo de infraestrutura.

---

## PROTOCOLO OPERACIONAL COMPLETO

### QUANDO INVOCAR
- Qualquer interacao com o Embaixador que envolva anexar arquivos
- Ao fechar sessao (gate 6B session_close): upload dos 7 arquivos + mensagem de encerramento
- Ao abrir sessao (P-114): solicitar BLOCO 0 se o Diretor nao colou no chat
- Ao sincronizar documentos atualizados para o Claude Projects

### 7 ARQUIVOS CANONICOS (verificar paths com Glob antes de cada operacao)
1. PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_[YYYY-MM-DD].md  (gerado por session_close)
2. PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_[YYYY-MM-DD].md  (gerado por session_close)
3. CLIENTES\WIP_BOARD.json
4. INTELLIGENCE_LEDGER.md  (raiz)
5. PENDENTES.md  (raiz)
6. CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md  (ATENCAO: nao em NOTEBOOKLM_FONTES)
7. CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md

### URL DO PROJETO
https://claude.ai/project/019e4c70-7e31-75d4-a568-cbb1077fb439
Conta: subdiretor.mnmsgm@gmail.com

### FLUXO DE EXCLUSAO (um por vez)
1. browser_navigate para a URL do projeto
2. browser_snapshot -> identificar ref do botao Excluir do 1o arquivo
3. browser_click target=<ref>
4. browser_snapshot -> obter nova ref do proximo (refs mudam apos exclusao)
5. Repetir para todos os 7 arquivos

### FLUXO DE UPLOAD
1. browser_click "Adicionar arquivos" -> menu aparece
2. browser_click "Carregar do aparelho" -> file chooser ativa
3. browser_file_upload paths=[lista absoluta dos 7 arquivos] -> imediatamente apos o clique
4. browser_snapshot -> confirmar 7 arquivos listados

### MENSAGEM DE ENCERRAMENTO (adaptar data e loop)
"Sessao [DATA] encerrada — Loop [N] V[X]. Entregas: [lista]. Ficou no ar: [lista]. Proxima sessao: [objetivo]."

### SOLICITACAO DE BLOCO 0 (texto simples - NUNCA HTML)
"Leia os 7 arquivos e gere o BLOCO 0 em texto simples (sem HTML, sem artefato): BLOCO 0 - paragrafo que o Diretor vai colar no Claude Code na proxima abertura (sintese de 3-5 linhas do que ficou, o que o Musculo deve atacar primeiro, alertas criticos). Depois: semaforo de projetos (1 linha cada: VANGUARD / INGRID / VALDECE) + contexto ultima sessao (3 linhas max.) + padrao detectado (so se aparecer em 2+ sessoes) + inconsistencias abertas + maximo 3 acoes do Diretor."