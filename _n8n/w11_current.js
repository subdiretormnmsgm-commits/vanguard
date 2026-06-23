// W-11 -- Calcular Ativacoes Manuais de Hoje (modelo A/B)
// Fonte de verdade: scripts/comandos_ativacao_atores.json (embutido aqui para nao depender de fetch/GitHub raw).
// Categoria B = COMANDO MANUAL que o Diretor cola (Claude Project OU Antigravity VS Code). SO a B vira notificacao.
// Categoria A = frentes Cowork automaticas (rodam na madrugada, depositam no INBOX) -- nao notificadas.
// Diretor 2026-06-22: o COMANDO de conducao Cowork (executor_cowork = Antigravity COWORK) passa a notificar (grupo cw).
//   E Categoria B (comando que o Diretor cola no VS Code); as frentes A continuam rodando sozinhas sem notificacao.
// Textos dentro de blocos ``` para o Telegram Markdown nao quebrar com _ e [ ] dos comandos.

const COMANDOS = {
  ed: {
    radar: { rotulo: 'Radar (abertura -- Segunda)',
      texto: 'EMBAIXADOR DIGITAL, mostrar radar.\nExecute o Protocolo de Leitura (material do Projetista + DIGITAL/INBOX + PENDING_REVIEW + NICHE_INDEX).\nApresente: nichos prontos para campanha, material do Projetista disponivel, alertas criticos novos -- ordenados pela prioridade comercial. Me pergunte qual nicho trabalhar.\nNao monte campanha ainda.' },
    validacao: { rotulo: 'Relatorio de validacao',
      texto: 'EMBAIXADOR DIGITAL, relatorio de validacao.\nAnalise os seguidores por porte (ICP), o CTR vs curtidas, e a auditoria comportamental dos novos seguidores. Me diga se o posicionamento esta atraindo os decisores certos.\nPrepare a retroalimentacao para o Projetista.' }
  },
  pj: {
    triagem: { rotulo: 'Triagem (fronteira DELTA)',
      texto: 'PROJETISTA, triagem.\nOlhe os REPETIDOS prestes a virar TENDENCIA (DELTA). Sinalize a fronteira. Nao projete.' },
    projecao: { rotulo: 'Nova oportunidade (projecao)',
      texto: 'PROJETISTA, nova oportunidade.\nNicho: [nome/codigo] | DELTA: [sinal] | Ciclos: [N] | Janela: [quando]\nUltima deliberacao Cowork: [data] | Tipo: [LEVE/PADRAO/PESADA]\nCruze o VANGUARD_HISTORICO com a inteligencia de mercado e estruture o plano pelo ciclo de vida de projeto.' },
    retroalimentacao: { rotulo: 'Retroalimentacao',
      texto: 'PROJETISTA, retroalimentacao.\nO Embaixador Digital reportou: [resultado de campanha].\nAtualize as projecoes dos nichos afetados (Encerramento -- licoes aprendidas).' }
  },
  cw: {
    conduzir: { rotulo: 'Conducao Cowork do dia (Antigravity)',
      texto: 'ANTIGRAVITY COWORK -- conducao do dia.\nHa atividade Cowork prevista hoje. Abra a sessao Claude Code: o Musculo gera o COMANDO COWORK (ir_ao_antigravity.ps1 -papel COWORK) com os briefings M e frentes F do dia para voce colar no Antigravity (VS Code).' }
  }
};

// dow: 0=Dom 1=Seg 2=Ter 3=Qua 4=Qui 5=Sex 6=Sab
// Opcao A (Diretor 2026-06-20): ED nao e diario. radar SO Segunda + validacao Sexta.
// cw (Diretor 2026-06-22): conducao Cowork em todo dia util (Seg-Sex) -- ha frente F1 diaria + M/F especificas.
const AGENDA = {
  0: { ed: [],            pj: [],                  cw: [] },
  1: { ed: ['radar'],     pj: ['triagem'],         cw: ['conduzir'] },
  2: { ed: [],            pj: ['projecao'],        cw: ['conduzir'] },
  3: { ed: [],            pj: [],                  cw: ['conduzir'] },
  4: { ed: [],            pj: [],                  cw: ['conduzir'] },
  5: { ed: ['validacao'], pj: ['retroalimentacao'], cw: ['conduzir'] },
  6: { ed: [],            pj: [],                  cw: [] }
};

const agora = new Date(new Date().toLocaleString('en-US', { timeZone: 'America/Sao_Paulo' }));
const dow = agora.getDay();
const diaMes = agora.getDate();
const dataBR = agora.toLocaleDateString('pt-BR');
const plano = AGENDA[dow] || { ed: [], pj: [], cw: [] };

// -- Cadencia das tarefas Cowork fonograficas M1-M7 (espelha cowork_calendar.ps1) --
function cadenciaHoje(regra) {
  switch (regra) {
    case 'Semanal-Segunda': return dow === 1;
    case 'Semanal-Terca':   return dow === 2;
    case 'Semanal-Quarta':  return dow === 3;
    case 'Quinzenal-1-15':  return diaMes === 1 || diaMes === 15;
    case 'Mensal-1':        return diaMes === 1;
    case 'Quinzenal-8-22':  return diaMes === 8 || diaMes === 22;
    case 'Mensal-15':       return diaMes === 15;
    default:                return false;
  }
}
const M_TASKS = [
  { id: 'M1', tema: 'Radar de Artista',             regra: 'Semanal-Segunda' },
  { id: 'M2', tema: 'Regulatorio (entretenimento)', regra: 'Semanal-Terca' },
  { id: 'M3', tema: 'Prospeccao de Holdings',       regra: 'Semanal-Quarta' },
  { id: 'M4', tema: 'ECAD + Streaming',             regra: 'Quinzenal-1-15' },
  { id: 'M5', tema: 'Mercado Fonografico',          regra: 'Mensal-1' },
  { id: 'M6', tema: 'Licenciamento de Eventos',     regra: 'Quinzenal-8-22' },
  { id: 'M7', tema: 'Concorrencia Musical',         regra: 'Mensal-15' }
];
const mHoje = M_TASKS.filter(function (t) { return cadenciaHoje(t.regra); });

// Frentes F (espelha cowork_calendar.ps1) -- AGENDA VANGUARD oficial 2026-06-17.
const F_SEMANAL = {
  1: 'F1 + F12 + F15 + ROD (Radar de Dor + Tutor do Fundador + Guardiao de Dependencias + Rodizio Caca)',
  2: 'F1 (Radar de Dor -- diario)',
  3: 'F1 (Radar de Dor -- diario)',
  4: 'F1 (Radar de Dor -- diario)',
  5: 'F1 + F3 (Radar de Dor + Cacador de Encaixe -- consolidacao semanal)',
  0: 'F1 (Radar de Dor -- diario)',
  6: 'F1 (Radar de Dor -- diario)'
};
const fExtra = [];
if (diaMes === 1 || diaMes === 15) fExtra.push('F5 + F9 (Espelho Estrategico + Radar de Fomento -- quinzenal)');
if (diaMes === 1) fExtra.push('F7 + F8 + F11 + NICHE_MODELER + M-STATS (enriquecimento mensal)');

function resumoCowork() {
  const linhas = [];
  if (mHoje.length) {
    linhas.push('Tarefas M hoje: ' + mHoje.map(function (t) { return t.id + ' ' + t.tema; }).join(' | '));
  }
  linhas.push('Frentes F: ' + (F_SEMANAL[dow] || 'F1 (Radar de Dor -- diario)'));
  for (let i = 0; i < fExtra.length; i++) linhas.push(fExtra[i]);
  if (mHoje.length) {
    linhas.push('Colher no INBOX_COWORK: ' + mHoje.map(function (t) { return 'BRIEFING_MUSCULO_' + t.id; }).join(', '));
  }
  return linhas.join('\n');
}

function bloco(grupo, chaves) {
  const linhas = [];
  for (const k of chaves) {
    const c = COMANDOS[grupo][k];
    if (!c) continue;
    linhas.push('*' + c.rotulo + '*\n```\n' + c.texto + '\n```');
  }
  return linhas;
}

const blocosEd = bloco('ed', plano.ed);
const blocosPj = bloco('pj', plano.pj);
const blocosCw = bloco('cw', plano.cw);
const temAtivacao = (blocosEd.length + blocosPj.length + blocosCw.length) > 0;

let texto = '';
if (temAtivacao) {
  const partes = ['🟢 *VANGUARD — Ativacoes de hoje (' + dataBR + ')*',
                  'Cole cada comando no respectivo ator (Claude Project / Antigravity).'];
  if (blocosEd.length) { partes.push('\n👤 *EMBAIXADOR DIGITAL*'); partes.push(blocosEd.join('\n\n')); }
  if (blocosPj.length) { partes.push('\n🏗️ *PROJETISTA*'); partes.push(blocosPj.join('\n\n')); }
  if (blocosCw.length) {
    partes.push('\n🛰️ *ANTIGRAVITY COWORK / EXECUTOR*');
    partes.push(blocosCw.join('\n\n'));
    partes.push('*O que roda hoje:*\n```\n' + resumoCowork() + '\n```');
  }
  partes.push('\n_Frentes Cowork automaticas (Categoria A) ja rodaram na madrugada e depositaram no INBOX. Acima estao os comandos que voce cola manualmente._');
  texto = partes.join('\n');
}

return [{ json: { temAtivacao: temAtivacao, textoAtivacao: texto, chatId: $env.TELEGRAM_CHAT_ID || '8895733647' } }];
