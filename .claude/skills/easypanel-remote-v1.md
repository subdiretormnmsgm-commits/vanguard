SKILL: easypanel-remote-v1.md
Camada: Infraestrutura Pentalateral (Universal) | Loop: Operacao EasyPanel 2026-06-14 | Stack: EasyPanel + Playwright MCP + CodeMirror 6 + xterm.js

[AUDITORIA DE COERENCIA]
O EasyPanel expoe toda a gestao de servicos via UI web (CodeMirror 6 para env vars, xterm.js para terminal) sem API publica para autenticacao de admin. O Musculo pode operar remotamente via Playwright MCP com total coerencia desde que: (1) a sessao de login do Diretor esteja ativa no browser Playwright; (2) o CodeMirror 6 seja manipulado via dispatch API (cmTile.view) -- nunca via fill() ou InputEvent; (3) o terminal xterm.js seja manipulado via browser_type com seletor .terminal.xterm.focus -- nunca via eventos sinteticos JS. O protocolo esta em conformidade com P-060 (zero intervencao do Diretor em propagacao de documentos) desde que aplicado a operacoes de infraestrutura aprovadas pelo Diretor.

[CONEXAO HISTORICA]
Operacao EasyPanel 2026-06-14 (inaugural): Musculo adicionou GOOGLE_AI_API_KEY as env vars do vanguard-n8n via CodeMirror dispatch. Problema identificado: fill() substituiu todo o conteudo do editor -- Ctrl+Z necessario para recuperar. Solucao descoberta: EditorView acessivel via cm-content.cmTile.view com dispatch cirurgico. Deploy confirmado: redeploy manual obrigatorio apos Salvar (botao Implantar separado). Deploy Hermes Agent 2026-06-07: primeira operacao de deploy Docker Compose via EasyPanel UI, estabelecendo padrao de navegacao e autenticacao. Ambas as operacoes confirmam que o painel nao expoe API REST de admin -- operacoes de infraestrutura requerem Playwright.

[PADRAO DE SUCESSO/FALHA]
SUCESSO -- CodeMirror 6 Dispatch API: document.querySelector('.cm-content').cmTile.view.dispatch({ changes: { from: insertAt, to: docLength, insert: 'NOME=VALOR' } }). Insercao cirurgica sem destruir conteudo existente. Validado em Operacao EasyPanel 2026-06-14 (38 linhas preservadas, nova variavel inserida na linha 38).
SUCESSO -- xterm.js via browser_type: browser_type com seletor .terminal.xterm.focus textarea[aria-label="Terminal input"]. Unico metodo que envia eventos nativos aceitos pelo xterm.js. Validado no deploy Hermes 2026-06-07.
FALHA (IRRECUPERAVEL) -- fill() no CodeMirror: browser_type com target .cm-content usa fill() internamente e SUBSTITUI TODO O CONTEUDO do editor. Unica recuperacao: Ctrl+Z imediato.
FALHA -- execCommand e InputEvent: ambos ignorados pelo CodeMirror 6 e pelo xterm.js. Nenhum efeito observavel.
FALHA -- WebSocket monkey-patch no xterm.js: corrompeu o estado do terminal. Exigiu fechar e reabrir o console dialog.
GATE APRENDIDO: Salvar env vars NAO dispara redeploy automatico. Sempre clicar Implantar separadamente e aguardar icone verde na aba Implantacoes.

[PERSPECTIVA DO SOCIO]
Como Socio-Consultor, emito alerta: operacao remota sobre infraestrutura de producao (n8n, Hermes) via Playwright e uma capacidade poderosa e tambem de alto risco. Uma insercao errada de env var pode derrubar o n8n e interromper os 9 workflows ativos (W-1 a W-9). Recomendacoes obrigatorias: (1) SEMPRE ler o conteudo atual do editor antes de modificar -- confirmar quantas linhas existem; (2) NUNCA usar fill() -- documentar esta proibicao na PARTE 2; (3) verificar o resultado da insercao ANTES de clicar Salvar -- view.state.doc.toString().slice(-60); (4) apos redeploy, aguardar icone verde E verificar que o n8n esta respondendo antes de declarar sucesso; (5) manter RUNBOOK_EASYPANEL.md como fonte canonica de erros conhecidos -- toda nova falha documentada antes de fechar sessao (P-050).

IDENTIDADE E ESCOPO:
URL base: https://0ul9nk.easypanel.host
Credenciais: login do Diretor no browser (sem API de admin publica)
Projetos gerenciados: vanguard (n8n), hermes (Hermes Agent)

SELETORES CHAVE:
  Editor CodeMirror 6: .cm-content
  EditorView (dispatch): document.querySelector('.cm-content').cmTile.view
  Terminal xterm.js: .terminal.xterm.focus textarea[aria-label="Terminal input"]
  Botao Implantar header: document.querySelectorAll('button')[6]

URLS OPERACIONAIS:
  Env vars n8n:  https://0ul9nk.easypanel.host/projects/vanguard/app/vanguard-n8n/environment
  Deploys n8n:   https://0ul9nk.easypanel.host/projects/vanguard/app/vanguard-n8n/deployments
  Hermes:        https://0ul9nk.easypanel.host/projects/hermes/app/hermes-agent

RUNBOOK: PENTALATERAL_UNIVERSAL/OPERACAO/RUNBOOK_EASYPANEL.md