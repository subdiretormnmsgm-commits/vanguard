const fs = require('fs');

// W-5 ChurnWatch -- cron diario (8h BRT = 11h UTC)
// Le WIP_BOARD do GitHub, calcula dias sem contato por projeto,
// alerta Telegram se dias >= churn_watch_threshold

const calcularDiasLines = [
  "const githubToken = $env.GITHUB_PAT_READONLY || '';",
  "return [{ json: { githubToken: githubToken } }];"
];

const processarWipLines = [
  "const raw = $input.item.json;",
  "const hoje = new Date();",
  "let alertas = [];",
  "let resumo = [];",
  "try {",
  "  const content = raw.content ? Buffer.from(raw.content.replace(/\\n/g,''),'base64').toString('utf8') : null;",
  "  if (!content) throw new Error('WIP_BOARD vazio');",
  "  const wip = JSON.parse(content);",
  "  const board = wip.board || {};",
  "  ['build','check','retainer'].forEach(function(col) {",
  "    (board[col]||[]).forEach(function(p) {",
  "      const threshold = parseInt(p.churn_watch_threshold) || 3;",
  "      const ultimoContato = p.ultimo_contato_cliente;",
  "      if (!ultimoContato) return;",
  "      const dtUltimo = new Date(ultimoContato);",
  "      const diasSem = Math.floor((hoje - dtUltimo) / (1000*60*60*24));",
  "      const status = diasSem >= threshold ? 'ALERTA' : 'OK';",
  "      resumo.push(p.cliente + ': ' + diasSem + 'd (threshold ' + threshold + 'd) -- ' + status);",
  "      if (diasSem >= threshold) {",
  "        alertas.push({",
  "          cliente: p.cliente,",
  "          diasSem: diasSem,",
  "          threshold: threshold,",
  "          ultimoContato: ultimoContato,",
  "          projeto: p.projeto || '',",
  "          status: col.toUpperCase()",
  "        });",
  "      }",
  "    });",
  "  });",
  "} catch(e) {",
  "  resumo.push('ERRO ao ler WIP_BOARD: ' + e.message);",
  "}",
  "const dataHora = hoje.toISOString().replace('T',' ').slice(0,16) + ' UTC';",
  "const textoResumo = 'ChurnWatch ' + dataHora + '\\n\\n' + resumo.join('\\n');",
  "let textoAlerta = '';",
  "if (alertas.length > 0) {",
  "  const linhas = alertas.map(function(a) {",
  "    return '\\u26a0\\ufe0f ' + a.cliente + ' -- ' + a.diasSem + 'd sem contato (limite: ' + a.threshold + 'd)\\nUltimo: ' + a.ultimoContato + ' | ' + a.status;",
  "  });",
  "  textoAlerta = 'CHURNWATCH -- ALERTA\\n\\n' + linhas.join('\\n\\n');",
  "}",
  "return [{ json: { textoResumo: textoResumo, textoAlerta: textoAlerta, temAlerta: alertas.length > 0, chatId: $env.TELEGRAM_CHAT_ID || '8895733647' } }];" // LEDGER: TELEGRAM_CHAT_ID_DIRETOR -- fallback explicito para operacao autonoma
];

const calcCode = calcularDiasLines.join('\n');
const procCode = processarWipLines.join('\n');

[['calcCode', calcCode], ['procCode', procCode]].forEach(function(pair) {
  try { new Function(pair[1]); console.log('[OK] Sintaxe ' + pair[0]); }
  catch(e) { console.error('[ERRO] ' + pair[0] + ': ' + e.message); process.exit(1); }
});

const w5 = {
  name: '05 -- ChurnWatch Diario',
  nodes: [
    {
      id: 'cron-churn',
      name: 'Cron -- 8h BRT Diario',
      type: 'n8n-nodes-base.scheduleTrigger',
      typeVersion: 1.2,
      position: [240, 300],
      parameters: {
        rule: { interval: [{ field: 'hours', minutesInterval: 1440, triggerAtHour: 11, triggerAtMinute: 0 }] }
      }
    },
    {
      id: 'code-prep-token',
      name: 'Preparar Token',
      type: 'n8n-nodes-base.code',
      typeVersion: 2,
      position: [460, 300],
      parameters: { jsCode: calcCode }
    },
    {
      id: 'http-wip',
      name: 'GitHub -- Ler WIP_BOARD',
      type: 'n8n-nodes-base.httpRequest',
      typeVersion: 4.2,
      position: [680, 300],
      continueOnFail: true,
      parameters: {
        method: 'GET',
        url: 'https://api.github.com/repos/subdiretormnmsgm-commits/vanguard/contents/CLIENTES/WIP_BOARD.json',
        sendHeaders: true,
        specifyHeaders: 'keypair',
        headerParameters: { parameters: [
          { name: 'Authorization', value: '={{ "token " + $json.githubToken }}' },
          { name: 'Accept', value: 'application/vnd.github.v3+json' }
        ]},
        options: { timeout: 10000 },
        ignoreResponseCode: true
      }
    },
    {
      id: 'code-processar',
      name: 'Processar WIP -- Calcular Churn',
      type: 'n8n-nodes-base.code',
      typeVersion: 2,
      position: [900, 300],
      parameters: { jsCode: procCode }
    },
    {
      id: 'if-alerta',
      name: 'Tem Alerta?',
      type: 'n8n-nodes-base.if',
      typeVersion: 1,
      position: [1120, 300],
      parameters: {
        conditions: { boolean: [{ value1: '={{ $json.temAlerta }}', value2: true }] }
      }
    },
    {
      id: 'telegram-alerta',
      name: 'Telegram -- Alerta Churn',
      type: 'n8n-nodes-base.httpRequest',
      typeVersion: 4.2,
      position: [1340, 200],
      continueOnFail: true,
      parameters: {
        method: 'POST',
        url: "={{ 'https://api.telegram.org/bot' + $env.TELEGRAM_BOT_TOKEN + '/sendMessage' }}",
        sendBody: true, specifyBody: 'keypair',
        bodyParameters: { parameters: [
          { name: 'chat_id', value: '={{ $json.chatId }}' },
          { name: 'text',    value: '={{ $json.textoAlerta }}' }
        ]}
      }
    },
    {
      id: 'telegram-resumo',
      name: 'Telegram -- Resumo Diario',
      type: 'n8n-nodes-base.httpRequest',
      typeVersion: 4.2,
      position: [1340, 420],
      continueOnFail: true,
      parameters: {
        method: 'POST',
        url: "={{ 'https://api.telegram.org/bot' + $env.TELEGRAM_BOT_TOKEN + '/sendMessage' }}",
        sendBody: true, specifyBody: 'keypair',
        bodyParameters: { parameters: [
          { name: 'chat_id', value: '={{ $json.chatId }}' },
          { name: 'text',    value: '={{ $json.textoResumo }}' }
        ]}
      }
    }
  ],
  connections: {
    'Cron -- 8h BRT Diario':             { main: [[{ node: 'Preparar Token',                    type: 'main', index: 0 }]] },
    'Preparar Token':                    { main: [[{ node: 'GitHub -- Ler WIP_BOARD',             type: 'main', index: 0 }]] },
    'GitHub -- Ler WIP_BOARD':           { main: [[{ node: 'Processar WIP -- Calcular Churn',    type: 'main', index: 0 }]] },
    'Processar WIP -- Calcular Churn':   { main: [[{ node: 'Tem Alerta?',                        type: 'main', index: 0 }]] },
    'Tem Alerta?': { main: [
      [{ node: 'Telegram -- Alerta Churn',  type: 'main', index: 0 }],
      [{ node: 'Telegram -- Resumo Diario', type: 'main', index: 0 }]
    ]}
  },
  settings: { executionOrder: 'v1' },
  staticData: null
};

fs.writeFileSync('_n8n/w5_churnwatch_upload.json', JSON.stringify(w5), 'utf8');
console.log('w5_churnwatch_upload.json gerado -- ' + w5.nodes.length + ' nodes');
