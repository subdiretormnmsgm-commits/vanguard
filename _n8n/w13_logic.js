// W-13 COWORK F(x) NOTIFIER -- jsCode do Code node "calcula_fx_hoje".
// FONTE UNICA: build_w13.ps1 carrega este arquivo via Get-Content -Raw (mesmo padrao do w10_new.js).
// Espelha scripts/cowork_calendar.ps1: dispara SO quando ha tarefa Cowork que exige o Musculo abrir
// sessao (colher briefing M1-M7 / rodar frente F especial / enriquecimento). Dias so com F1 (Radar de
// Dor diario, automatico) = silencia (mesmo padrao do W-6/W-11). Mantem os nomes de campo
// temAtivacao/textoAtivacao/chatId -> IF e Telegram do workflow clonado ficam inalterados.
const agora = new Date(new Date().toLocaleString('en-US', { timeZone: 'America/Sao_Paulo' }));
const dow = agora.getDay();
const dia = agora.getDate();
const tarefas = [];
if (dow === 1) tarefas.push('M1 Radar de Artista');
if (dow === 2) tarefas.push('M2 Regulatorio (entretenimento)');
if (dow === 3) tarefas.push('M3 Prospeccao de Holdings');
if (dia === 1 || dia === 15) tarefas.push('M4 ECAD + Streaming');
if (dia === 1) tarefas.push('M5 Mercado Fonografico');
if (dia === 8 || dia === 22) tarefas.push('M6 Licenciamento de Eventos');
if (dia === 15) tarefas.push('M7 Concorrencia Musical');
if (dow === 1) tarefas.push('F12 + F15 + ROD (Tutor + Guardiao de Dependencias + Rodizio Caca)');
if (dow === 5) tarefas.push('F3 Cacador de Encaixe (consolidacao semanal)');
if (dia === 1 || dia === 15) tarefas.push('F5 + F9 (Espelho Estrategico + Radar de Fomento)');
if (dia === 1) tarefas.push('F7 + F8 + F11 + NICHE_MODELER + M-STATS (enriquecimento mensal)');
const temAtivacao = tarefas.length > 0;
const dataBR = agora.toLocaleDateString('pt-BR');
let texto = '';
if (temAtivacao) {
  const linhas = tarefas.map(function (t) { return '• ' + t; });
  texto = '🔵 *VANGUARD COWORK — F(x) de hoje (' + dataBR + ')*\n\n'
        + 'Abra sessao no *Musculo* (Claude Code) para extrair e executar as F(x) com o Executor Cowork:\n\n'
        + linhas.join('\n')
        + '\n\n_O Musculo colhe os BRIEFING_MUSCULO no INBOX_COWORK e roda as frentes -> PENDING_REVIEW (P-124)._';
}
return [{ json: { temAtivacao: temAtivacao, textoAtivacao: texto, chatId: $env.TELEGRAM_CHAT_ID || '8895733647' } }];
