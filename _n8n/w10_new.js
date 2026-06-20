// W-10 Analyze Health -- logica pura, sem HTTP calls
// Recebe dados de 'HTTP Get Workflows' e 'HTTP Get Executions' (TODAS as execucoes, limit 250).
// S-3 (2026-06-19): alem de alertar falhas, lista as execucoes de SUCESSO das ultimas 24h
// -- confirmacao POSITIVA de que os workflows/agentes rodaram (pedido do Diretor).
const EXPECTED_ACTIVE = ['W-1','W-2','W-3','W-4','W-5','W-6','W-7','W-8','W-9','W-10'];

const wfNode = $('HTTP Get Workflows').all();
const wfData = (wfNode.length > 0) ? wfNode[0].json : { data: [] };
const workflows = wfData.data || [];

const allExecs = $input.all()[0].json.data || [];

const now = new Date();
const ontem = new Date(now.getTime() - 86400000);
const chatId = $env.TELEGRAM_CHAT_ID || '8895733647';
const dataHora = now.toISOString().replace('T', ' ').slice(0, 16) + ' UTC';

const wfMap = {};
workflows.forEach(function(w) { wfMap[w.id] = w.name; });

const execs24h = allExecs.filter(function(e) {
  const dt = new Date(e.startedAt || e.createdAt || 0);
  return dt >= ontem;
});

const erros24h = execs24h.filter(function(e) { return e.status === 'error' || e.status === 'crashed'; });
const sucessos24h = execs24h.filter(function(e) { return e.status === 'success'; });

const errorsByWf = {};
erros24h.forEach(function(e) {
  const nome = wfMap[e.workflowId] || ('ID:' + e.workflowId);
  if (!errorsByWf[nome]) errorsByWf[nome] = [];
  errorsByWf[nome].push({ id: e.id, startedAt: e.startedAt });
});

const successByWf = {};
sucessos24h.forEach(function(e) {
  const nome = wfMap[e.workflowId] || ('ID:' + e.workflowId);
  successByWf[nome] = (successByWf[nome] || 0) + 1;
});

function blocoSucesso() {
  const nomes = Object.keys(successByWf);
  if (nomes.length === 0) return 'Rodaram 24h (sucesso): 0 -- NENHUMA execucao OK registrada. Verifique se os crons dispararam.';
  const linhas = ['Rodaram 24h (sucesso): ' + nomes.length + ' workflow(s)'];
  nomes.sort().forEach(function(n) { linhas.push('  - ' + n + ': ' + successByWf[n] + ' OK'); });
  return linhas.join('\n');
}

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
  textoOK = '[OK] n8n SAUDAVEL -- ' + dataHora + '\n\nWorkflows: ' + totalWf + ' total | ' + ativosCount + ' ativos\nErros 24h: 0\nInativos inesperados: 0\n\n' + blocoSucesso() + '\n\nSistema operando normalmente. Proximo check: amanha 6h30 BRT.';
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
  linhas.push(blocoSucesso());
  linhas.push('');
  antigravityContext = 'Problemas: ' + Object.keys(errorsByWf).concat(inactivos).join(', ') + '. Data: ' + dataHora;
  linhas.push('[ANTIGRAVITY] Para diagnosticar:');
  linhas.push('  .\\scripts\\n8n_antigravity_repair.ps1');
  linhas.push('  Skill: @n8n-validation-expert -> @systematic-debugging');
  textoAlerta = linhas.join('\n');
}

return [{ json: { textoOK: textoOK, textoAlerta: textoAlerta, temAlerta: temAlerta, chatId: chatId, antigravityContext: antigravityContext, wfComErro: wfComErro, inativosCount: inactivos.length, dataHora: dataHora } }];
