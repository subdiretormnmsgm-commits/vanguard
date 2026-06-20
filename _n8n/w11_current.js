// W-11 -- Calcular Ativacoes Manuais de Hoje (modelo A/B)
// Fonte de verdade: scripts/comandos_ativacao_atores.json (embutido aqui para nao depender de fetch/GitHub raw).
// Categoria B = COMANDO MANUAL que o Diretor cola no Claude Project. SO a B vira notificacao.
// Categoria A = frentes Cowork automaticas (rodam na madrugada, depositam no INBOX) -- nao notificadas.
// Textos dentro de blocos ``` para o Telegram Markdown nao quebrar com _ e [ ] dos comandos.

const COMANDOS = {
  ed: {
    radar: { rotulo: 'Radar (abertura -- diario)',
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
  }
};

// dow: 0=Dom 1=Seg 2=Ter 3=Qua 4=Qui 5=Sex 6=Sab
const AGENDA = {
  0: { ed: ['radar'],              pj: [] },
  1: { ed: ['radar'],              pj: ['triagem'] },
  2: { ed: ['radar'],              pj: ['projecao'] },
  3: { ed: ['radar'],              pj: [] },
  4: { ed: ['radar'],              pj: [] },
  5: { ed: ['radar', 'validacao'], pj: ['retroalimentacao'] },
  6: { ed: ['radar'],              pj: [] }
};

const agora = new Date(new Date().toLocaleString('en-US', { timeZone: 'America/Sao_Paulo' }));
const dow = agora.getDay();
const dataBR = agora.toLocaleDateString('pt-BR');
const plano = AGENDA[dow] || { ed: [], pj: [] };

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
const temAtivacao = (blocosEd.length + blocosPj.length) > 0;

let texto = '';
if (temAtivacao) {
  const partes = ['🟢 *VANGUARD — Ativacoes manuais de hoje (' + dataBR + ')*',
                  'Cole cada comando no respectivo Claude Project.'];
  if (blocosEd.length) { partes.push('\n👤 *EMBAIXADOR DIGITAL*'); partes.push(blocosEd.join('\n\n')); }
  if (blocosPj.length) { partes.push('\n🏗️ *PROJETISTA*'); partes.push(blocosPj.join('\n\n')); }
  partes.push('\n_As frentes Cowork (Categoria A) ja rodaram na madrugada e depositaram no INBOX. Acima estao apenas os comandos que voce cola manualmente._');
  texto = partes.join('\n');
}

return [{ json: { temAtivacao: temAtivacao, textoAtivacao: texto, chatId: $env.TELEGRAM_CHAT_ID || '8895733647' } }];

