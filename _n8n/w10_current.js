// W-10 Analyze Health -- logica pura, sem HTTP calls
// Recebe dados de 'HTTP Get Workflows' e 'HTTP Get Executions' via n8n node selector
const EXPECTED_ACTIVE = ['W-1','W-2','W-3','W-4','W-5','W-6','W-7','W-8','W-9','W-10'];

const wfNode = $('HTTP Get Workflows').all();
const wfData = (wfNode.length > 0) ? wfNode[0].json : { data: [] };
const workflows = wfData.data || [];

const failedExecs = $input.all()[0].json.data || [];

const now = new Date();
const ontem = new Date(now.getTime() - 86400000);
const chatId = $env.TELEGRAM_CHAT_ID || '8895733647';
const dataHora = now.toISOString().replace('T', ' ').slice(0, 16) + ' UTC';

const wfMap = {};
workflows.forEach(function(w) { wfMap[w.id] = w.name; });

const erros24h = failedExecs.filter(function(e) {
  const dt = new Date(e.startedAt || e.createdAt || 0);
  return dt >= ontem;
});

const errorsByWf = {};
erros24h.forEach(function(e) {
  const nome = wfMap[e.workflowId] || ('ID:' + e.workflowId);
  if (!errorsByWf[nome]) errorsByWf[nome] = [];
  errorsByWf[nome].push({ id: e.id, startedAt: e.startedAt });
});

const inactivos = [];
EXPECTED_ACTIVE.forEach(function(wName) {
  const found = workflows.find(function(w) { return w.name.indexOf(wName) >= 0; });
  if (found && !found.active) inactivos.push(found.name);
});

const totalWf = workflows.length;
const ativosCount = workflows.filter(function(w) { return w.active; }).length;
const wfComErro = Object.keys(errorsByWf).length;
const temAlerta = wfComErro > 0 || inactivos.length > 0;

let textoOK = '', textoAlerta = '', antigravityContext = '';

if (!temAlerta) {
  textoOK = '[OK] n8n SAUDAVEL -- ' + dataHora + '\n\nWorkflows: ' + totalWf + ' total | ' + ativosCount + ' ativos\nErros 24h: 0\nInativos inesperados: 0\n\nSistema operando normalmente. Proximo check: amanha 6h30 BRT.';
} else {
  const linhas = ['[ALERTA] n8n FALHA -- ' + dataHora, ''];
  if (wfComErro > 0) {
    linhas.push('Erros 24h (' + wfComErro + ' workflow(s)):');
    Object.keys(errorsByWf).forEach(function(nome) {
      linhas.push('  - ' + nome + ': ' + errorsByWf[nome].length + ' falha(s)');
    });
    linhas.push('');
  }
  if (inactivos.length > 0) {
    linhas.push('Inativos inesperados (' + inactivos.length + '):');
    inactivos.forEach(function(n) { linhas.push('  - ' + n); });
    linhas.push('');
  }
  antigravityContext = 'Problemas: ' + Object.keys(errorsByWf).concat(inactivos).join(', ') + '. Data: ' + dataHora;
  linhas.push('[ANTIGRAVITY] Para diagnosticar:');
  linhas.push('  .\\scripts\\n8n_antigravity_repair.ps1');
  linhas.push('  Skill: @n8n-validation-expert -> @systematic-debugging');
  textoAlerta = linhas.join('\n');
}

return [{ json: { textoOK: textoOK, textoAlerta: textoAlerta, temAlerta: temAlerta, chatId: chatId, antigravityContext: antigravityContext, wfComErro: wfComErro, inativosCount: inactivos.length, dataHora: dataHora } }];

