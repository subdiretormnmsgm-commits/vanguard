const fs = require('fs');

const wf = JSON.parse(fs.readFileSync('_n8n/workflows/w7_veredito_telegram.json','utf8'));

// ===== PARSEAR COMANDO (estendido com query detection) =====
const parsearLines = [
  "const msg = $input.item.json.message || {};",
  "const texto = (msg.text || '').trim();",
  "const chatId = msg.chat ? String(msg.chat.id) : '';",
  "const fromId = msg.from ? String(msg.from.id) : '';",
  "const DIRETOR_ID = '8895733647'; // LEDGER: Telegram chat_id do Diretor -- identidade fixa, nao valor de negocio",
  "const isDiretor = (chatId === DIRETOR_ID || fromId === DIRETOR_ID);",
  "if (!isDiretor) {",
  "  return [{ json: { tipo: 'erro', valido: false, motivo: 'Acesso nao autorizado.', chatId: chatId || fromId } }];",
  "}",
  "const queryMatch = texto.match(/^\\/(status|score|custo)(?:\\s+(.*))?$/i);",
  "if (queryMatch) {",
  "  return [{ json: { tipo: 'query', cmd: queryMatch[1].toLowerCase(), param: (queryMatch[2]||'').trim(), chatId: chatId } }];",
  "}",
  "const cmdMatch = texto.match(/^\\/(aprovar|rejeitar|veredito)\\s+(.+)/i);",
  "if (!cmdMatch) {",
  "  return [{ json: { tipo: 'erro', valido: false, motivo: 'Cmds: /status /score /custo /aprovar X /rejeitar X /veredito D1:A', chatId: chatId } }];",
  "}",
  "const cmd = cmdMatch[1].toLowerCase();",
  "const arg = cmdMatch[2].trim().toUpperCase();",
  "let itens = [];",
  "if (cmd === 'veredito') {",
  "  const matches = arg.match(/D\\d+:[ABC]/gi);",
  "  if (matches) itens = matches.map(function(m){ return { id: m.split(':')[0], veredito: m.split(':')[1] }; });",
  "} else {",
  "  const v = cmd === 'aprovar' ? 'A' : 'B';",
  "  itens = [{ id: arg, veredito: v }];",
  "}",
  "if (!itens.length) {",
  "  return [{ json: { tipo: 'erro', valido: false, motivo: 'Nenhum item reconhecido. Use D1:A D2:B', chatId: chatId } }];",
  "}",
  "const agora = new Date();",
  "const tsFile = agora.toISOString().replace(/[^0-9]/g,'').slice(0,12);",
  "const dataHora = agora.toISOString().replace('T',' ').slice(0,16) + ' UTC';",
  "return [{ json: { tipo: 'veredito', valido: true, cmd: cmd, itens: itens, chatId: chatId, tsFile: tsFile, dataHora: dataHora } }];"
];
const parsearCode = parsearLines.join('\n');

// ===== PREPARAR QUERY =====
const prepQueryLines = [
  "const item = $input.item.json;",
  "const cmd = item.cmd;",
  "const param = (item.param || '').toLowerCase().trim();",
  "const chatId = item.chatId;",
  "const githubToken = $env.GITHUB_PAT_READONLY || '';",
  "const supabaseUrl = $env.SUPABASE_URL || '';",
  "const supabaseKey = $env.SUPABASE_ANON_KEY || '';",
  "let url = '';",
  "let authHeader = '';",
  "let apiKey = '';",
  "if (cmd === 'status') {",
  "  url = 'https://api.github.com/repos/subdiretormnmsgm-commits/vanguard/contents/CLIENTES/WIP_BOARD.json';",
  "  authHeader = 'token ' + githubToken;",
  "} else if (cmd === 'score') {",
  "  if (supabaseUrl && supabaseKey) {",
  "    url = supabaseUrl + '/rest/v1/respostas?order=respondido_em.desc&limit=100&select=acertou,respondido_em';",
  "    authHeader = 'Bearer ' + supabaseKey;",
  "    apiKey = supabaseKey;",
  "  }",
  "} else if (cmd === 'custo') {",
  "  if (supabaseUrl && supabaseKey) {",
  "    url = supabaseUrl + '/rest/v1/custo_sessoes?order=data.desc&limit=10&select=data,custo_usd,tokens_totais';",
  "    authHeader = 'Bearer ' + supabaseKey;",
  "    apiKey = supabaseKey;",
  "  }",
  "}",
  "return [{ json: { url:url, authHeader:authHeader, apiKey:apiKey, cmd:cmd, param:param, chatId:chatId, semConfig:!url } }];"
];
const prepQueryCode = prepQueryLines.join('\n');

// ===== FORMATAR RESPOSTA =====
const fmtLines = [
  "const prep = $('Preparar Query').item.json;",
  "const cmd = prep.cmd;",
  "const chatId = prep.chatId;",
  "const raw = $input.item.json;",
  "let texto = '';",
  "if (prep.semConfig) {",
  "  texto = cmd + ': config pendente.\\nAdicionar no EasyPanel: SUPABASE_URL + SUPABASE_ANON_KEY';",
  "} else if (raw.message && typeof raw.message === 'string' && raw.message.length < 200) {",
  "  texto = cmd + ': erro -- ' + raw.message;",
  "} else if (cmd === 'status') {",
  "  try {",
  "    const content = raw.content ? Buffer.from(raw.content.replace(/\\n/g,''),'base64').toString('utf8') : null;",
  "    if (!content) throw new Error('sem conteudo');",
  "    const wip = JSON.parse(content);",
  "    const board = wip.board || {};",
  "    const linhas = [];",
  "    ['build','check','retainer'].forEach(function(col) {",
  "      (board[col]||[]).forEach(function(p) {",
  "        const f = p.loop_fase_atual || {};",
  "        linhas.push(col.toUpperCase()+'|'+p.cliente+' L'+(f.loop||'?')+'|'+(f.proximo||p.proximo_passo||'').slice(0,45));",
  "      });",
  "    });",
  "    texto = 'STATUS '+new Date().toISOString().slice(0,10)+'\\n\\n'+(linhas.length?linhas.join('\\n'):'(vazio)');",
  "  } catch(e) { texto = 'status: erro -- '+e.message; }",
  "} else if (cmd === 'score') {",
  "  try {",
  "    const rows = Array.isArray(raw) ? raw : [];",
  "    if (!rows.length) { texto = 'score: sem dados em respostas.'; }",
  "    else {",
  "      const ac = rows.filter(function(r){return r.acertou===true;}).length;",
  "      const pct = Math.round(ac/rows.length*100);",
  "      const lim = new Date(Date.now()-7*24*3600*1000).toISOString();",
  "      const rec = rows.filter(function(r){return r.respondido_em>=lim;});",
  "      const acRec = rec.filter(function(r){return r.acertou===true;}).length;",
  "      const pctR = rec.length ? Math.round(acRec/rec.length*100) : 0;",
  "      texto = 'SCORE INGRID\\n'+ac+'/'+rows.length+' ('+pct+'%)\\n7d: '+acRec+'/'+rec.length+' ('+pctR+'%)\\n'+new Date().toISOString().slice(0,10);",
  "    }",
  "  } catch(e) { texto = 'score: '+e.message; }",
  "} else if (cmd === 'custo') {",
  "  try {",
  "    const rows = Array.isArray(raw) ? raw : [];",
  "    if (!rows.length) { texto = 'custo: sem dados. Registrar sessoes primeiro.'; }",
  "    else {",
  "      const tot = rows.reduce(function(s,r){return s+(parseFloat(r.custo_usd)||0);},0);",
  "      const tok = rows.reduce(function(s,r){return s+(parseInt(r.tokens_totais)||0);},0);",
  "      texto = 'CUSTO '+new Date().toISOString().slice(0,7)+'\\nUSD: '+tot.toFixed(4)+'\\nTokens: '+tok.toLocaleString();",
  "    }",
  "  } catch(e) { texto = 'custo: '+e.message; }",
  "}",
  "return [{ json: { texto:texto, chatId:chatId } }];"
];
const fmtCode = fmtLines.join('\n');

// ===== VALIDAR SINTAXE =====
[['parsearCode', parsearCode], ['prepQueryCode', prepQueryCode], ['fmtCode', fmtCode]].forEach(function(pair) {
  try { new Function(pair[1]); console.log('[OK] Sintaxe ' + pair[0]); }
  catch(e) { console.error('[ERRO] ' + pair[0] + ': ' + e.message); process.exit(1); }
});

// ===== MODIFICAR O WORKFLOW =====
const parsearNode = wf.nodes.find(function(n){return n.name==='Parsear Comando';});
parsearNode.parameters.jsCode = parsearCode;

const newNodes = [
  {
    id: 'if-query', name: 'Eh Query?',
    type: 'n8n-nodes-base.if', typeVersion: 1, position: [680, 500],
    parameters: { conditions: { string: [{ value1: '={{ $json.tipo }}', value2: 'query', operation: 'equal' }] } }
  },
  {
    id: 'code-query-prep', name: 'Preparar Query',
    type: 'n8n-nodes-base.code', typeVersion: 2, position: [900, 500],
    parameters: { jsCode: prepQueryCode }
  },
  {
    id: 'http-query', name: 'Executar Query',
    type: 'n8n-nodes-base.httpRequest', typeVersion: 4.2, position: [1120, 500],
    continueOnFail: true,
    parameters: {
      method: 'GET',
      url: '={{ $json.url }}',
      sendHeaders: true, specifyHeaders: 'keypair',
      headerParameters: { parameters: [
        { name: 'Authorization', value: '={{ $json.authHeader }}' },
        { name: 'Accept', value: 'application/vnd.github.v3+json' },
        { name: 'apikey', value: '={{ $json.apiKey || \'\' }}' }
      ]},
      options: { timeout: 10000 },
      ignoreResponseCode: true
    }
  },
  {
    id: 'code-query-fmt', name: 'Formatar Resposta',
    type: 'n8n-nodes-base.code', typeVersion: 2, position: [1340, 500],
    parameters: { jsCode: fmtCode }
  },
  {
    id: 'telegram-query-resp', name: 'Telegram -- Resposta Query',
    type: 'n8n-nodes-base.httpRequest', typeVersion: 4.2, position: [1560, 500],
    continueOnFail: true,
    parameters: {
      method: 'POST',
      url: "={{ 'https://api.telegram.org/bot' + $env.TELEGRAM_BOT_TOKEN + '/sendMessage' }}",
      sendBody: true, specifyBody: 'keypair',
      bodyParameters: { parameters: [
        { name: 'chat_id', value: '={{ $json.chatId }}' },
        { name: 'text',    value: '={{ $json.texto }}' }
      ]}
    }
  }
];

wf.nodes = wf.nodes.concat(newNodes);

// Parsear Comando agora vai para Eh Query? (nao mais direto para Comando Valido?)
wf.connections['Parsear Comando'] = { main: [[{ node: 'Eh Query?', type: 'main', index: 0 }]] };
wf.connections['Eh Query?'] = { main: [
  [{ node: 'Preparar Query', type: 'main', index: 0 }],
  [{ node: 'Comando Valido?', type: 'main', index: 0 }]
]};
wf.connections['Preparar Query']    = { main: [[{ node: 'Executar Query',         type: 'main', index: 0 }]] };
wf.connections['Executar Query']    = { main: [[{ node: 'Formatar Resposta',       type: 'main', index: 0 }]] };
wf.connections['Formatar Resposta'] = { main: [[{ node: 'Telegram -- Resposta Query', type: 'main', index: 0 }]] };

const minimal = { name: wf.name, nodes: wf.nodes, connections: wf.connections, settings: { executionOrder: 'v1' }, staticData: null };
fs.writeFileSync('_n8n/w7_v2_upload.json', JSON.stringify(minimal), 'utf8');
console.log('w7_v2_upload.json gerado -- ' + wf.nodes.length + ' nodes totais');
