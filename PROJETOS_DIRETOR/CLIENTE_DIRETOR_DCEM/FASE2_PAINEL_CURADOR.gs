/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 * ║  FASE 2 — PAINEL DE CONFECÇÃO E VALIDAÇÃO DAS RESPOSTAS                    ║
 * ║  Asse Ct Orç / DCEM · Base de Consultas                                   ║
 * ╠══════════════════════════════════════════════════════════════════════════╣
 * ║  DOIS PAINÉIS num só arquivo (Fase 2.2 — fluxo de aprovação do Chefe):    ║
 * ║   · CURADOR → redige o parecer e o envia para avaliação do Chefe.         ║
 * ║   · CHEFE   → avalia (podendo editar) e escolhe uma de três saídas:       ║
 * ║       (a) validar e ENVIAR ao demandante (atalho, pela mão do Chefe);     ║
 * ║       (b) validar e DEVOLVER ao curador (para o curador disparar);        ║
 * ║       (c) NÃO validar / devolver com nota (curador refaz e reenvia).      ║
 * ║  Sequência canônica (Diretor 2026-07-17):                                 ║
 * ║    RESPOSTA CURADOR → AVALIAÇÃO DO CHEFE → (CURADOR) → DEMANDANTE          ║
 * ║  com o atalho do Chefe podendo pular a volta ao curador.                  ║
 * ║                                                                            ║
 * ║  Estado do fluxo mora na coluna U (Status_Fluxo); a nota do Chefe na V.   ║
 * ║  O e-mail final ao demandante carrega a assinatura formal (item 6b) e os   ║
 * ║  links de pesquisa de satisfação 👍/👎 (item 5).                          ║
 * ╚══════════════════════════════════════════════════════════════════════════╝
 */

/* Índices de coluna da aba REGISTROS (1-based), espelham a FASE1. */
var REG = {
  ID: 1, DATA: 2, EMAIL: 3, SECAO: 4, CASO: 5, NORMA_CHAVE: 6, FATO: 7,
  TIPO: 8, MACETE: 9, PARECER: 10, AUTORIA_NOME: 11, AUTORIA_VISIVEL: 12,
  DONO_NORMA: 13, SATISFACAO: 14, ANEXO: 15, VERSAO: 16, OBSOLESCENCIA: 17,
  POSTO: 18, NOME_GUERRA: 19, PRIORIDADE: 20, STATUS_FLUXO: 21, CHEFE_NOTA: 22
};

/* Estados do fluxo (coluna U). Strings partilhadas entre servidor e cliente. */
var FLX = {
  REDACAO:   'Em redação',
  NO_CHEFE:  'Aguardando Chefe',
  VALIDADO:  'Validado — com curador',
  DEVOLVIDO: 'Devolvido — com curador',
  ENVIADO:   'Enviado ao demandante'
};

/* Endereços canônicos (GATE DE FATO — copiados de ENDERECO_EXEC.txt).
   O link de satisfação aponta para o Cloudflare Pages (Rota B), NUNCA para o
   /exec direto: abrir /exec pela câmera em celular logado em 2+ contas Google
   falha. A página estática chama o /exec como API e evita o bug na raiz. */
var PAGES_URL = 'https://dcem-consultas.pages.dev';

/* ───────────────────────────── Menu ───────────────────────────── */
function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu('⬤ Análise e confecção das respostas')
    .addItem('Painel do Curador — redigir respostas', 'abrirPainelCurador')
    .addItem('Painel do Chefe — validar respostas', 'abrirPainelChefe')
    .addSeparator()
    .addItem('Atualizar painel de estatísticas', 'criarPainelEstatisticas')
    .addToUi();
}

function abrirPainelCurador() { abrirPainel_('curador'); }
function abrirPainelChefe()   { abrirPainel_('chefe'); }

function abrirPainel_(papel) {
  var titulo = papel === 'chefe' ? 'Validação das respostas (Chefe)'
                                 : 'Análise e confecção das respostas (Curador)';
  var html = HtmlService.createHtmlOutput(gerarHtmlPainel(papel))
    .setWidth(1000)
    .setHeight(680)
    .setTitle(titulo);
  SpreadsheetApp.getUi().showModalDialog(html, titulo);
}

/* ═══════════════════════ SERVIDOR — leitura ═══════════════════════ */

/** Normaliza o estado do fluxo de uma linha (compat. com registros legados). */
function statusDaLinha_(uVal, parecerVal) {
  var u = String(uVal || '').trim();
  if (u) return u;                                   // estado explícito grava em U
  var p = String(parecerVal || '').trim();
  if (p && p.indexOf('[RASCUNHO]') !== 0) return FLX.ENVIADO;  // legado já respondido
  return FLX.REDACAO;                                // nova consulta ou rascunho
}

/** Estado inicial por papel: fila relevante + métricas do cabeçalho. */
function getEstadoInicial(papel) {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var reg = ss.getSheetByName('REGISTROS');
  var ultima = reg.getLastRow();
  var fila = [], enviadas = 0;

  if (ultima >= 2) {
    var dados = reg.getRange(2, 1, ultima - 1, REG.CHEFE_NOTA).getValues();
    for (var i = 0; i < dados.length; i++) {
      var lin = dados[i], nLinha = i + 2;
      var temFato = String(lin[REG.FATO - 1]).trim() !== '';
      var temId   = String(lin[REG.ID - 1]).trim() !== '';
      if (!temId && !temFato) continue;              // linha vazia
      var status = statusDaLinha_(lin[REG.STATUS_FLUXO - 1], lin[REG.PARECER - 1]);
      if (status === FLX.ENVIADO) { enviadas++; continue; }

      // Filtro por papel:
      //  · Chefe vê SÓ o que está aguardando sua avaliação.
      //  · Curador vê tudo o que ainda não foi enviado (com chip de estado).
      if (papel === 'chefe' && status !== FLX.NO_CHEFE) continue;

      fila.push({
        linha: nLinha,
        id: String(lin[REG.ID - 1] || ('CONS-linha-' + nLinha)),
        tema: String(lin[REG.CASO - 1] || '(sem Caso-Tipo)'),
        secao: String(lin[REG.SECAO - 1] || '—'),
        status: status,
        urgente: String(lin[REG.PRIORIDADE - 1] || '').trim() === 'Urgente'
      });
    }
  }

  // Urgentes primeiro; dentro do mesmo grau, mantém a ordem de chegada.
  fila.sort(function (a, b) { return (b.urgente ? 1 : 0) - (a.urgente ? 1 : 0); });

  return {
    papel: papel,
    fila: fila,
    metricas: { fila: fila.length, enviadas: enviadas }
  };
}

/** Consulta completa + embasamento relacional (Caso → Normas → Acervo → Macete). */
function getConsultaCompleta(nLinha) {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var reg = ss.getSheetByName('REGISTROS');
  var lin = reg.getRange(nLinha, 1, 1, REG.CHEFE_NOTA).getValues()[0];

  // Texto do parecer já redigido, sem o prefixo [RASCUNHO], para pré-preencher
  // o textarea (o curador reabre um rascunho; o chefe recebe o texto para editar).
  var parecerBruto = String(lin[REG.PARECER - 1] || '');
  var parecerRedigido = parecerBruto.indexOf('[RASCUNHO]') === 0
    ? parecerBruto.replace(/^\[RASCUNHO\]\s?/, '') : parecerBruto;

  var status = statusDaLinha_(lin[REG.STATUS_FLUXO - 1], lin[REG.PARECER - 1]);
  var identificacao = ((String(lin[REG.POSTO - 1] || '')) + ' ' +
                       (String(lin[REG.NOME_GUERRA - 1] || ''))).trim();

  var consulta = {
    linha: nLinha,
    id: String(lin[REG.ID - 1] || ''),
    secao: String(lin[REG.SECAO - 1] || ''),
    email: String(lin[REG.EMAIL - 1] || ''),
    identificacao: identificacao,
    urgente: String(lin[REG.PRIORIDADE - 1] || '').trim() === 'Urgente',
    dataHora: lin[REG.DATA - 1] ? Utilities.formatDate(new Date(lin[REG.DATA - 1]),
              Session.getScriptTimeZone(), 'dd/MM HH:mm') : '',
    fato: String(lin[REG.FATO - 1] || ''),
    caso: String(lin[REG.CASO - 1] || ''),
    normaChave: String(lin[REG.NORMA_CHAVE - 1] || ''),
    tipo: String(lin[REG.TIPO - 1] || ''),
    macete: String(lin[REG.MACETE - 1] || ''),
    parecerRedigido: parecerRedigido,
    status: status,
    chefeNota: String(lin[REG.CHEFE_NOTA - 1] || '')
  };
  return { consulta: consulta, embasamento: montarEmbasamento(consulta.caso) };
}

/** Dado o Tema do Caso-Tipo, monta normas (ordenadas por hierarquia) + acervo + macete. */
function montarEmbasamento(temaCaso) {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var vazio = { casoTema: temaCaso || '(não classificado)', normas: [], acervo: [], macete: '' };
  if (!temaCaso) return vazio;

  // 1) achar a linha do Caso pelo Tema
  var casos = ss.getSheetByName('CASOS');
  var cd = casos.getLastRow() >= 2 ? casos.getRange(2, 1, casos.getLastRow() - 1, 4).getValues() : [];
  var normasRel = '', acervoNr = '';
  for (var i = 0; i < cd.length; i++) {
    if (String(cd[i][1]).trim() === String(temaCaso).trim()) {
      normasRel = String(cd[i][2] || '');   // Normas_Relacionadas (códigos ; )
      acervoNr  = String(cd[i][3] || '');    // Docs_Acervo_NrOrdem
      break;
    }
  }

  // 2) resolver cada código de norma → Titulo + Nivel + Status, ordenar por hierarquia
  var normas = ss.getSheetByName('NORMAS');
  var nd = normas.getLastRow() >= 2 ? normas.getRange(2, 1, normas.getLastRow() - 1, 9).getValues() : [];
  var mapa = {};
  for (var j = 0; j < nd.length; j++) {
    mapa[String(nd[j][0]).trim()] = {
      titulo: String(nd[j][1] || ''),
      status: String(nd[j][6] || ''),
      tipo: String(nd[j][7] || ''),
      nivel: Number(nd[j][8]) || 9
    };
  }
  var listaNormas = [];
  normasRel.split(';').forEach(function (cod) {
    cod = cod.trim();
    if (!cod) return;
    var n = mapa[cod];
    if (n) {
      listaNormas.push({
        cod: cod, titulo: tituloCurto(n.titulo), nivel: n.nivel,
        revogada: /revog/i.test(n.status)
      });
    } else {
      listaNormas.push({ cod: cod, titulo: cod + ' [não cadastrada]', nivel: 9, revogada: false });
    }
  });
  listaNormas.sort(function (a, b) { return a.nivel - b.nivel; });  // hierarquia: superior primeiro

  // 3) acervo (Nr Ordem) como fichas
  var acervo = acervoNr.split(';').map(function (s) { return s.trim(); }).filter(String);

  // 4) macete: último REGISTROS do mesmo Caso com MACETE_TACITO preenchido
  var macete = ultimoMacete(temaCaso);

  return { casoTema: temaCaso, normas: listaNormas, acervo: acervo, macete: macete };
}

/** Reaproveita o conhecimento tácito: último macete registrado para o mesmo Caso-Tipo. */
function ultimoMacete(temaCaso) {
  var reg = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('REGISTROS');
  if (reg.getLastRow() < 2) return '';
  var d = reg.getRange(2, 1, reg.getLastRow() - 1, REG.OBSOLESCENCIA).getValues();
  for (var i = d.length - 1; i >= 0; i--) {   // de baixo p/ cima = mais recente
    if (String(d[i][REG.CASO - 1]).trim() === String(temaCaso).trim()) {
      var m = String(d[i][REG.MACETE - 1] || '').trim();
      if (m) return m;
    }
  }
  return '';
}

/* ═══════════════════════ SERVIDOR — escrita ═══════════════════════ */

/**
 * CURADOR → grava o parecer redigido + campos técnicos e manda para o Chefe.
 * payload: { linha, parecer, normaChave, tipo, macete }
 */
function enviarParaChefe(payload) {
  if (!payload || !payload.linha) throw new Error('Consulta não selecionada.');
  var parecer = String(payload.parecer || '').trim();
  if (!parecer) throw new Error('O parecer não pode ir ao Chefe em branco.');

  var reg = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('REGISTROS');
  var n = Number(payload.linha);

  // Campos técnicos com validação (Norma_Chave = col. F) ANTES do PARECER (F-1).
  if (payload.normaChave) reg.getRange(n, REG.NORMA_CHAVE).setValue(payload.normaChave);
  if (payload.tipo)       reg.getRange(n, REG.TIPO).setValue(payload.tipo);
  if (payload.macete)     reg.getRange(n, REG.MACETE).setValue(String(payload.macete).slice(0, 150));
  if (!reg.getRange(n, REG.DATA).getValue()) reg.getRange(n, REG.DATA).setValue(new Date());
  reg.getRange(n, REG.PARECER).setValue(parecer);            // texto limpo (sem [RASCUNHO])
  reg.getRange(n, REG.STATUS_FLUXO).setValue(FLX.NO_CHEFE);  // muda de fila → Chefe

  // Aviso ao Chefe (best-effort, P-110).
  var idc = String(reg.getRange(n, REG.ID).getValue() || '');
  var tema = String(reg.getRange(n, REG.CASO).getValue() || '-');
  notificarChefe_('Consulta ' + idc + ' aguarda sua validação',
    '🕮 Uma resposta aguarda sua avaliação.\n\n' +
    'ID: ' + idc + '\nTema: ' + tema + '\n\n' +
    'Abra o Painel do Chefe na planilha para validar, editar ou devolver.');

  return { ok: true };
}

/** CHEFE → valida e DEVOLVE ao curador (com edição opcional do texto + nota). */
function chefeValidar(payload) {
  if (!payload || !payload.linha) throw new Error('Consulta não selecionada.');
  var reg = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('REGISTROS');
  var n = Number(payload.linha);
  var parecer = String(payload.parecer || '').trim();
  if (parecer) reg.getRange(n, REG.PARECER).setValue(parecer);   // grava eventual edição do Chefe
  if (typeof payload.chefeNota !== 'undefined')
    reg.getRange(n, REG.CHEFE_NOTA).setValue(String(payload.chefeNota || ''));
  reg.getRange(n, REG.STATUS_FLUXO).setValue(FLX.VALIDADO);
  notificarCuradorEstado_(reg, n, 'validada (com você para o disparo final)');
  return { ok: true };
}

/** CHEFE → NÃO valida: devolve ao curador para ajustes. Nota é obrigatória. */
function chefeDevolver(payload) {
  if (!payload || !payload.linha) throw new Error('Consulta não selecionada.');
  var nota = String(payload.chefeNota || '').trim();
  if (!nota) throw new Error('Escreva a nota de devolução (o que ajustar) antes de devolver.');
  var reg = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('REGISTROS');
  var n = Number(payload.linha);
  if (String(payload.parecer || '').trim())   // preserva eventual edição do Chefe, se houver
    reg.getRange(n, REG.PARECER).setValue(String(payload.parecer).trim());
  reg.getRange(n, REG.CHEFE_NOTA).setValue(nota);
  reg.getRange(n, REG.STATUS_FLUXO).setValue(FLX.DEVOLVIDO);
  notificarCuradorEstado_(reg, n, 'devolvida para ajuste — ver a nota do Chefe');
  return { ok: true };
}

/** CHEFE → atalho: valida e ENVIA ele mesmo ao demandante. */
function chefeEnviarDemandante(payload) {
  if (!payload || !payload.linha) throw new Error('Consulta não selecionada.');
  var reg = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('REGISTROS');
  var n = Number(payload.linha);
  if (typeof payload.chefeNota !== 'undefined')
    reg.getRange(n, REG.CHEFE_NOTA).setValue(String(payload.chefeNota || ''));
  return dispararAoDemandante_(reg, n, payload.parecer);
}

/** CURADOR → disparo final ao demandante (após o Chefe validar e devolver). */
function curadorEnviarDemandante(payload) {
  if (!payload || !payload.linha) throw new Error('Consulta não selecionada.');
  var reg = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('REGISTROS');
  var n = Number(payload.linha);
  return dispararAoDemandante_(reg, n, payload.parecer);
}

/**
 * Núcleo do disparo final ao demandante — usado pelo Chefe (atalho) e pelo
 * Curador. Grava o parecer (se editado), monta o e-mail com a assinatura formal
 * (item 6b) e os links de satisfação 👍/👎 (item 5), e marca ENVIADO (col U).
 * PARECER/STATUS são as ÚLTIMAS escritas (F-1): se o e-mail falhar, o erro sobe
 * sem marcar como enviado — a consulta permanece na fila.
 */
function dispararAoDemandante_(reg, n, parecerEditado) {
  var parecer = String(parecerEditado || '').trim();
  if (!parecer) parecer = String(reg.getRange(n, REG.PARECER).getValue() || '').trim();
  if (!parecer) throw new Error('Não há parecer para enviar.');

  var email = String(reg.getRange(n, REG.EMAIL).getValue() || '').trim();
  if (!email) throw new Error('A consulta não tem e-mail do demandante para o envio.');

  var idc  = String(reg.getRange(n, REG.ID).getValue() || '');
  var tema = String(reg.getRange(n, REG.CASO).getValue() || '').trim();
  var referente = tema || 'sua consulta';

  var linkSim = PAGES_URL + '/?sat=' + encodeURIComponent(idc) + '&r=sim';
  var linkNao = PAGES_URL + '/?sat=' + encodeURIComponent(idc) + '&r=nao';

  // Assinatura formal — item 6b (texto exato aprovado pelo Diretor).
  var corpo =
    'Prezado(a),\n\n' +
    'Em resposta a CONS - ' + idc + ', referente a ' + referente + ', segue a resposta:\n\n' +
    parecer + '\n\n' +
    'Atenciosamente,\n' +
    'Assessoria de Controle Orçamentário - DCEM\n\n' +
    '──────────────────────────────\n' +
    'Sua dúvida foi retirada?\n' +
    '   👍 SIM  →  ' + linkSim + '\n' +
    '   👎 NÃO  →  ' + linkNao + '\n';

  // Escreve o parecer (caso ajustado) ANTES do e-mail; STATUS só após o envio.
  reg.getRange(n, REG.PARECER).setValue(parecer);
  MailApp.sendEmail({
    to: email,
    subject: 'Em resposta a CONS - ' + idc + ' — Asse Ct Orç / DCEM',
    body: corpo
  });
  reg.getRange(n, REG.STATUS_FLUXO).setValue(FLX.ENVIADO);   // marca respondida por último
  return { ok: true, emailEnviado: true };
}

/**
 * Botão dedicado do curador → grava só o MACETE tácito (col I) + a classificação
 * (col H) na memória interna da Seção, sem tocar o parecer nem mudar de fila.
 * OPSEC: este conteúdo é referência interna e NUNCA vai ao demandante.
 */
function salvarMacete(payload) {
  if (!payload || !payload.linha) throw new Error('Consulta não selecionada.');
  var reg = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('REGISTROS');
  var n = Number(payload.linha);
  reg.getRange(n, REG.MACETE).setValue(String(payload.macete || '').slice(0, 150));
  if (payload.tipo) reg.getRange(n, REG.TIPO).setValue(payload.tipo);
  return { ok: true };
}

/** Salva rascunho: grava só o parecer, sem sair da fila do curador. */
function salvarRascunho(payload) {
  if (!payload || !payload.linha) throw new Error('Consulta não selecionada.');
  var reg = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('REGISTROS');
  var n = Number(payload.linha);
  reg.getRange(n, REG.PARECER).setValue('[RASCUNHO] ' + String(payload.parecer || ''));
  reg.getRange(n, REG.STATUS_FLUXO).setValue(FLX.REDACAO);
  return { ok: true };
}

/* ═══════════════════════ Notificações inter-papel ═══════════════════════ */
/* Chefe e curador são 2 pessoas. Canais best-effort (P-110): nunca quebram a
   gravação. Endereços/chats ficam em Script Properties — o código não os embute.
   Padrões que funcionam sem config extra: o curador (quem roda o script) recebe
   por e-mail (effective user); o chefe recebe pelo Telegram já configurado. */
function propGet_(k) {
  return PropertiesService.getScriptProperties().getProperty(k);
}

function enviarTelegram_(chatId, texto) {
  var token = propGet_('TELEGRAM_TOKEN');
  if (!token || !chatId) return;
  UrlFetchApp.fetch('https://api.telegram.org/bot' + token + '/sendMessage', {
    method: 'post', muteHttpExceptions: true,
    payload: { chat_id: chatId, text: texto, disable_web_page_preview: 'true' }
  });
}

/** Notifica o CHEFE: Telegram (chat já configurado) + e-mail se EMAIL_CHEFE existir. */
function notificarChefe_(assunto, texto) {
  try { enviarTelegram_(propGet_('TELEGRAM_CHAT_ID'), texto); } catch (e) {}
  var em = propGet_('EMAIL_CHEFE');
  if (em) { try { MailApp.sendEmail({ to: em, subject: assunto, body: texto }); } catch (e) {} }
}

/** Notifica o CURADOR: e-mail (EMAIL_CURADOR ou o próprio dono do script) + Telegram opcional. */
function notificarCuradorEstado_(reg, n, frase) {
  var idc = String(reg.getRange(n, REG.ID).getValue() || '');
  var texto = 'A consulta ' + idc + ' foi ' + frase + '.\n\n' +
              'Abra o Painel do Curador na planilha para prosseguir.';
  var em = propGet_('EMAIL_CURADOR') || Session.getEffectiveUser().getEmail();
  if (em) { try { MailApp.sendEmail({ to: em, subject: 'Consulta ' + idc + ' — ' + frase, body: texto }); } catch (e) {} }
  try { enviarTelegram_(propGet_('TELEGRAM_CHAT_ID_CURADOR'), texto); } catch (e) {}
}

/* ═══════════════════════ Helpers de texto ═══════════════════════ */
function tituloCurto(t) {
  t = String(t || '');
  var corte = t.indexOf(' — ');
  return corte > 0 ? t.slice(0, corte) : (t.length > 60 ? t.slice(0, 57) + '…' : t);
}

/* ═══════════════════════ HTML do modal ═══════════════════════ */
function gerarHtmlPainel(papel) {
  var ehChefe = papel === 'chefe';
  var h1  = ehChefe ? 'Painel do Chefe' : 'Painel da Assessoria';
  var sub = ehChefe ? 'Validação das respostas · Asse Ct Orç / DCEM'
                    : 'Confecção das respostas · Asse Ct Orç / DCEM';
  var lm1 = ehChefe ? 'aguardando' : 'na fila';
  var lm2 = ehChefe ? 'enviadas'   : 'enviadas';
  var filaCab = ehChefe ? 'Aguardando sua avaliação' : 'Fila de trabalho';
  return ''
+ '<!DOCTYPE html><html><head><meta charset="utf-8"><base target="_top">'
+ '<style>'
+ '*,*::before,*::after{box-sizing:border-box}'
+ ':root{--marinho:#12294a;--marinho-2:#1c3a63;--ambar:#b8882f;--ambar-claro:#d8a94b;'
+ '--verde:#2f7d5b;--ambar-st:#b07d1e;--vermelho:#b23a3a;--bg:#f4f1ea;--superf:#fff;'
+ '--superf-2:#efeadf;--borda:#ddd5c6;--tinta:#1b2431;--tinta-2:#55606f;--tinta-3:#8791a0;'
+ '--accent:var(--ambar);--sel:#fbf6ea;--sel-borda:var(--ambar);'
+ "--serif:Georgia,'Times New Roman',serif;--sans:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif;"
+ "--mono:'SFMono-Regular',Consolas,'Liberation Mono',Menlo,monospace;--raio:10px;"
+ '--sombra:0 1px 2px rgba(18,41,74,.06),0 6px 20px rgba(18,41,74,.07)}'
+ 'body{margin:0;background:var(--bg);color:var(--tinta);font-family:var(--sans);font-size:14px;line-height:1.5;-webkit-font-smoothing:antialiased}'
+ '.modal{background:var(--superf);border:1px solid var(--borda);border-radius:14px;box-shadow:var(--sombra);overflow:hidden;margin:2px}'
+ '.cab{background:linear-gradient(120deg,var(--marinho),var(--marinho-2));color:#eaf0f9;padding:14px 20px;display:flex;align-items:center;gap:14px}'
+ '.brasao{width:40px;height:40px;border-radius:8px;flex:none;background:radial-gradient(circle at 30% 25%,var(--ambar-claro),var(--ambar) 70%);display:grid;place-items:center;font-size:20px;box-shadow:inset 0 0 0 2px rgba(255,255,255,.18)}'
+ '.cab h1{font-family:var(--serif);font-size:17px;margin:0;font-weight:600}'
+ '.cab .sub{font-size:11.5px;color:#a9b8d0;margin-top:2px;letter-spacing:.04em;text-transform:uppercase}'
+ '.cab .metricas{margin-left:auto;display:flex;gap:22px;text-align:right}'
+ '.metricas .n{font-family:var(--mono);font-size:19px;font-weight:600;color:#fff;font-variant-numeric:tabular-nums}'
+ '.metricas .l{font-size:10px;color:#9fb0c9;text-transform:uppercase;letter-spacing:.06em}'
+ '.corpo{display:grid;grid-template-columns:290px 1fr;min-height:520px}'
+ '.fila{border-right:1px solid var(--borda);background:var(--superf-2);max-height:560px;overflow:auto}'
+ '.fila-cab{padding:12px 16px 8px;font-size:11px;text-transform:uppercase;letter-spacing:.07em;color:var(--tinta-3);display:flex;justify-content:space-between;position:sticky;top:0;background:var(--superf-2)}'
+ '.card{padding:12px 16px;border-bottom:1px solid var(--borda);cursor:pointer;border-left:3px solid transparent}'
+ '.card:hover{background:var(--sel)}'
+ '.card.sel{background:var(--sel);border-left-color:var(--sel-borda)}'
+ '.card .id{font-family:var(--mono);font-size:11px;color:var(--tinta-3)}'
+ '.card .tema{font-weight:600;font-size:13px;margin:2px 0 4px;color:var(--tinta)}'
+ '.card .meta{font-size:11.5px;color:var(--tinta-2);display:flex;gap:6px;flex-wrap:wrap}'
+ '.chip{display:inline-flex;align-items:center;gap:4px;font-size:10.5px;font-weight:600;padding:2px 8px;border-radius:999px;white-space:nowrap}'
+ '.chip.sec{background:rgba(18,41,74,.12);color:var(--marinho-2)}'
+ '.chip.pend{background:rgba(176,125,30,.16);color:var(--ambar-st)}'
+ '.chip.chefe{background:rgba(28,58,99,.15);color:var(--marinho-2)}'
+ '.chip.dia{background:rgba(47,125,91,.15);color:var(--verde)}'
+ '.chip.rev{background:rgba(178,58,58,.15);color:var(--vermelho)}'
+ '.chip.urg{background:rgba(178,58,58,.16);color:var(--vermelho)}'
+ '.chip.hier{background:rgba(18,41,74,.10);color:var(--tinta-2);font-family:var(--mono)}'
+ '.work{padding:18px 22px;overflow:auto;max-height:560px}'
+ '.bloco{margin-bottom:20px}'
+ '.bloco>.titulo{font-size:11px;text-transform:uppercase;letter-spacing:.08em;color:var(--accent);font-weight:700;margin:0 0 8px;display:flex;align-items:center;gap:7px}'
+ '.bloco>.titulo::before{content:"";width:14px;height:2px;background:var(--accent);border-radius:2px}'
+ '.consulta{background:var(--superf-2);border:1px solid var(--borda);border-radius:var(--raio);padding:14px 16px}'
+ '.consulta .linha{display:flex;gap:8px;flex-wrap:wrap;align-items:center;margin-bottom:8px}'
+ '.consulta .proto{font-family:var(--mono);font-size:12px;color:var(--tinta-3)}'
+ '.consulta .de{font-size:12.5px;color:var(--tinta-2)}'
+ '.consulta .duvida{font-size:13.5px;color:var(--tinta);line-height:1.55}'
+ '.rel{border:1px solid var(--borda);border-radius:var(--raio);overflow:hidden}'
+ '.rel .passo{padding:11px 14px;border-bottom:1px solid var(--borda);display:flex;gap:10px;align-items:flex-start}'
+ '.rel .passo:last-child{border-bottom:none}'
+ '.rel .rot{flex:none;width:88px;font-size:10.5px;text-transform:uppercase;letter-spacing:.05em;color:var(--tinta-3);padding-top:3px}'
+ '.rel .val{flex:1;display:flex;gap:6px;flex-wrap:wrap;align-items:center}'
+ '.norma{display:inline-flex;align-items:center;gap:7px;background:var(--superf-2);border:1px solid var(--borda);border-radius:8px;padding:5px 9px;font-size:12.5px;color:var(--tinta)}'
+ '.norma.revog{text-decoration:line-through;opacity:.7}'
+ '.doc{font-family:var(--mono);font-size:11.5px;background:rgba(18,41,74,.08);color:var(--tinta-2);border-radius:6px;padding:3px 7px}'
+ '.macete{background:rgba(184,136,47,.10);border:1px solid rgba(184,136,47,.35);border-radius:var(--raio);padding:11px 13px;font-size:13px;color:var(--tinta);line-height:1.5}'
+ '.macete .tag{font-size:10px;font-weight:700;letter-spacing:.06em;text-transform:uppercase;color:var(--accent);display:block;margin-bottom:4px}'
+ '.nota{border-radius:var(--raio);padding:11px 13px;font-size:13px;color:var(--tinta);line-height:1.5;margin-bottom:12px}'
+ '.nota .tag{font-size:10px;font-weight:700;letter-spacing:.06em;text-transform:uppercase;display:block;margin-bottom:4px}'
+ '.nota.dev{background:rgba(178,58,58,.08);border:1px solid rgba(178,58,58,.3)}'
+ '.nota.dev .tag{color:var(--vermelho)}'
+ '.nota.val{background:rgba(47,125,91,.08);border:1px solid rgba(47,125,91,.3)}'
+ '.nota.val .tag{color:var(--verde)}'
+ '.resp label{display:block;font-size:11.5px;color:var(--tinta-2);margin:0 0 5px;font-weight:600}'
+ '.resp textarea,.resp input,.resp select{width:100%;font-family:var(--sans);font-size:13.5px;color:var(--tinta);background:var(--superf);border:1px solid var(--borda);border-radius:8px;padding:9px 11px;resize:vertical}'
+ '.resp textarea:focus,.resp input:focus,.resp select:focus{outline:2px solid var(--accent);outline-offset:1px;border-color:var(--accent)}'
+ '.resp .campo{margin-bottom:12px}'
+ '.resp .duo{display:grid;grid-template-columns:1fr 160px;gap:12px}'
+ '.acoes{display:flex;gap:10px;align-items:center;margin-top:6px;flex-wrap:wrap}'
+ '.btn{font-family:var(--sans);font-size:13px;font-weight:600;border-radius:8px;padding:10px 18px;cursor:pointer;border:1px solid transparent}'
+ '.btn.prim{background:var(--accent);color:#1a1204;border-color:var(--accent)}'
+ '.btn.prim:hover{filter:brightness(1.05)}'
+ '.btn.prim:disabled{opacity:.5;cursor:default}'
+ '.btn.env{background:var(--verde);color:#fff;border-color:var(--verde)}'
+ '.btn.env:hover{filter:brightness(1.05)}'
+ '.btn.dev{background:transparent;color:var(--vermelho);border-color:rgba(178,58,58,.5)}'
+ '.btn.dev:hover{background:rgba(178,58,58,.08)}'
+ '.btn.sec{background:transparent;color:var(--tinta-2);border-color:var(--borda)}'
+ '.btn.sec:hover{background:var(--superf-2)}'
+ '.acoes .aviso{font-size:11.5px;color:var(--tinta-3);margin-left:auto;display:flex;align-items:center;gap:5px}'
+ '.opt{font-size:11.5px;color:var(--tinta-2);display:inline-flex;align-items:center;gap:6px}'
+ '.vazio{padding:60px 20px;text-align:center;color:var(--tinta-3);font-size:13px}'
+ '.toast{position:fixed;left:50%;bottom:18px;transform:translateX(-50%);background:var(--marinho);color:#eaf0f9;padding:10px 18px;border-radius:8px;font-size:13px;box-shadow:var(--sombra);opacity:0;transition:opacity .2s;pointer-events:none}'
+ '.toast.show{opacity:1}'
+ '</style></head><body>'
+ '<div class="modal">'
+ '<header class="cab"><div class="brasao">' + (ehChefe ? '⚖' : '🎖') + '</div>'
+ '<div><h1>' + h1 + '</h1><div class="sub">' + sub + '</div></div>'
+ '<div class="metricas">'
+ '<div class="m"><div class="n" id="mFila">–</div><div class="l">' + lm1 + '</div></div>'
+ '<div class="m"><div class="n" id="mResp">–</div><div class="l">' + lm2 + '</div></div>'
+ '</div></header>'
+ '<div class="corpo">'
+ '<aside class="fila"><div class="fila-cab"><span>' + filaCab + '</span><span id="filaN">–</span></div>'
+ '<div id="fila"></div></aside>'
+ '<section class="work" id="work"><div class="vazio">Carregando a fila…</div></section>'
+ '</div></div>'
+ '<div class="toast" id="toast"></div>'
+ '<script>var PAPEL=' + JSON.stringify(papel) + ';var FLX=' + JSON.stringify(FLX) + ';'
+ gerarClientJs() + '</script>'
+ '</body></html>';
}

/* JS do cliente — separado para legibilidade. */
function gerarClientJs() {
  return ''
+ 'var ESTADO={fila:[],sel:null,dados:null};'
+ 'function esc(s){return String(s==null?"":s).replace(/[&<>"]/g,function(c){return{"&":"&amp;","<":"&lt;",">":"&gt;","\\"":"&quot;"}[c];});}'
+ 'function val(id){var el=document.getElementById(id);return el?el.value:"";}'
+ 'function toast(m){var t=document.getElementById("toast");t.textContent=m;t.classList.add("show");setTimeout(function(){t.classList.remove("show");},2600);}'
+ 'function chipStatus(st){'
+ '  if(st===FLX.NO_CHEFE)return "<span class=\\"chip chefe\\">no Chefe</span>";'
+ '  if(st===FLX.VALIDADO)return "<span class=\\"chip dia\\">✔ validada</span>";'
+ '  if(st===FLX.DEVOLVIDO)return "<span class=\\"chip rev\\">devolvida</span>";'
+ '  return "<span class=\\"chip pend\\">● em redação</span>";}'
+ 'function init(){google.script.run.withSuccessHandler(function(e){'
+ '  ESTADO.fila=e.fila;'
+ '  document.getElementById("mFila").textContent=e.metricas.fila;'
+ '  document.getElementById("mResp").textContent=e.metricas.enviadas;'
+ '  document.getElementById("filaN").textContent=e.fila.length;'
+ '  renderFila();'
+ '  if(e.fila.length){selecionar(e.fila[0].linha);}'
+ '  else{document.getElementById("work").innerHTML="<div class=\\"vazio\\">"+(PAPEL==="chefe"?"Nada aguardando validação. ⚖":"Nenhuma consulta na fila. Tudo enviado. 🎖")+"</div>";}'
+ '}).withFailureHandler(function(err){document.getElementById("work").innerHTML="<div class=\\"vazio\\">Erro: "+esc(err.message)+"</div>";}).getEstadoInicial(PAPEL);}'
+ 'function renderFila(){var h="";ESTADO.fila.forEach(function(p){'
+ '  h+="<div class=\\"card"+(p.linha===ESTADO.sel?" sel":"")+"\\" onclick=\\"selecionar("+p.linha+")\\">"'
+ '   +"<div class=\\"id\\">"+esc(p.id)+"</div>"'
+ '   +"<div class=\\"tema\\">"+esc(p.tema)+"</div>"'
+ '   +"<div class=\\"meta\\"><span class=\\"chip sec\\">"+esc(p.secao)+"</span>"'
+ '   +(p.urgente?"<span class=\\"chip urg\\">🔴 urgente</span>":"")'
+ '   +chipStatus(p.status)+"</div></div>";'
+ '});document.getElementById("fila").innerHTML=h;}'
+ 'function selecionar(linha){ESTADO.sel=linha;renderFila();'
+ '  document.getElementById("work").innerHTML="<div class=\\"vazio\\">Carregando…</div>";'
+ '  google.script.run.withSuccessHandler(renderWork).withFailureHandler(function(err){'
+ '    document.getElementById("work").innerHTML="<div class=\\"vazio\\">Erro: "+esc(err.message)+"</div>";'
+ '  }).getConsultaCompleta(linha);}'
+ 'function renderWork(d){ESTADO.dados=d;var c=d.consulta,e=d.embasamento;'
+ '  var normasH=e.normas.length?e.normas.map(function(n){'
+ '    var niv="<span class=\\"chip hier\\">nível "+n.nivel+"</span>";'
+ '    var st=n.revogada?"<span class=\\"chip rev\\">revogada</span>":"<span class=\\"chip dia\\">🟢 em dia</span>";'
+ '    return "<span class=\\"norma"+(n.revogada?" revog":"")+"\\"><b>"+esc(n.titulo)+"</b> "+niv+" "+st+"</span>";'
+ '  }).join(""):"<span class=\\"de\\">— sem normas cadastradas para este Caso —</span>";'
+ '  var acervoH=e.acervo.length?e.acervo.map(function(a){return "<span class=\\"doc\\">Nr "+esc(a)+"</span>";}).join(""):"<span class=\\"de\\">—</span>";'
+ '  var maceteH=e.macete?("<div class=\\"macete\\"><span class=\\"tag\\">⚡ atalho de resolução (registro anterior)</span>"+esc(e.macete)+"</div>"):"<div class=\\"de\\" style=\\"font-size:12.5px\\">Sem macete registrado ainda para este Caso-Tipo — o seu parecer pode inaugurar um.</div>";'
+ '  var h="";'
+ '  h+="<div class=\\"bloco\\"><p class=\\"titulo\\">Consulta recebida</p><div class=\\"consulta\\">"'
+ '   +"<div class=\\"linha\\"><span class=\\"proto\\">"+esc(c.id)+"</span>"'
+ '   +(c.urgente?"<span class=\\"chip urg\\">🔴 urgente</span>":"")'
+ '   +(c.secao?"<span class=\\"chip sec\\">"+esc(c.secao)+"</span>":"")'
+ '   +(c.identificacao?"<span class=\\"de\\"><b>"+esc(c.identificacao)+"</b></span>":"")'
+ '   +(c.email?"<span class=\\"de\\">· "+esc(c.email)+(c.dataHora?" · "+esc(c.dataHora):"")+"</span>":"")+"</div>"'
+ '   +"<p class=\\"duvida\\">"+esc(c.fato||"(sem texto da dúvida)")+"</p></div></div>";'
+ '  h+="<div class=\\"bloco\\"><p class=\\"titulo\\">Embasamento — busca relacional (Caso → Norma → Documento → Precedente)</p><div class=\\"rel\\">"'
+ '   +"<div class=\\"passo\\"><div class=\\"rot\\">Caso-Tipo</div><div class=\\"val\\"><span class=\\"norma\\"><b>"+esc(e.casoTema)+"</b></span></div></div>"'
+ '   +"<div class=\\"passo\\"><div class=\\"rot\\">Normas</div><div class=\\"val\\">"+normasH+"</div></div>"'
+ '   +"<div class=\\"passo\\"><div class=\\"rot\\">Acervo</div><div class=\\"val\\">"+acervoH+"</div></div>"'
+ '   +"<div class=\\"passo\\"><div class=\\"rot\\">Macete</div><div class=\\"val\\" style=\\"display:block\\">"+maceteH+"</div></div>"'
+ '   +"</div></div>";'
+ '  h+=montarAcoes(c,e);'
+ '  document.getElementById("work").innerHTML=h;}'
// ── Bloco de ações: ramifica por papel + estado do fluxo ──
+ 'function montarAcoes(c,e){'
+ '  if(PAPEL==="chefe")return blocoChefe(c);'
+ '  return blocoCurador(c,e);}'
// CHEFE — avalia, edita e escolhe: enviar ao demandante / validar e devolver / devolver
+ 'function blocoChefe(c){'
+ '  var h="<div class=\\"bloco resp\\"><p class=\\"titulo\\">Avaliação do Chefe</p>";'
+ '  h+="<div class=\\"campo\\"><label>Resposta do curador (edite se necessário)</label><textarea id=\\"fParecer\\" rows=\\"5\\">"+esc(c.parecerRedigido||"")+"</textarea></div>";'
+ '  h+="<div class=\\"campo\\"><label>Nota do Chefe (obrigatória ao devolver · vai junto ao curador)</label><textarea id=\\"fChefeNota\\" rows=\\"2\\" placeholder=\\"o que ajustar, ou observação da validação\\">"+esc(c.chefeNota||"")+"</textarea></div>";'
+ '  h+="<div class=\\"acoes\\">"'
+ '   +"<button class=\\"btn env\\" id=\\"btA\\" onclick=\\"chefeEnvia()\\">✓ Validar e enviar ao demandante</button>"'
+ '   +"<button class=\\"btn prim\\" id=\\"btB\\" onclick=\\"chefeValida()\\">Validar e devolver ao curador</button>"'
+ '   +"<button class=\\"btn dev\\" id=\\"btC\\" onclick=\\"chefeDevolve()\\">Não validar / devolver</button>"'
+ '   +"</div></div>";'
+ '  return h;}'
// CURADOR — depende do estado: redação/devolvido (redige→Chefe) · no Chefe (só leitura) · validado (dispara)
+ 'function blocoCurador(c,e){'
+ '  if(c.status===FLX.NO_CHEFE){'
+ '    return "<div class=\\"bloco\\"><div class=\\"nota val\\"><span class=\\"tag\\">⏳ com o Chefe</span>Esta resposta está aguardando a avaliação do Chefe. Quando ele validar ou devolver, ela volta para cá.</div></div>";}'
+ '  var h="<div class=\\"bloco resp\\">";'
+ '  if(c.status===FLX.DEVOLVIDO&&c.chefeNota){h+="<div class=\\"nota dev\\"><span class=\\"tag\\">↩ devolvida pelo Chefe — ajustar</span>"+esc(c.chefeNota)+"</div>";}'
+ '  if(c.status===FLX.VALIDADO){'
+ '    if(c.chefeNota){h+="<div class=\\"nota val\\"><span class=\\"tag\\">✔ validada pelo Chefe</span>"+esc(c.chefeNota)+"</div>";}'
+ '    h+="<p class=\\"titulo\\">Disparo final ao demandante</p>";'
+ '    h+="<div class=\\"campo\\"><label>Resposta validada (ajuste fino, se preciso)</label><textarea id=\\"fParecer\\" rows=\\"5\\">"+esc(c.parecerRedigido||"")+"</textarea></div>";'
+ '    h+="<div class=\\"acoes\\"><button class=\\"btn env\\" id=\\"btEnv\\" onclick=\\"curadorEnvia()\\">✓ Enviar ao demandante</button>"'
+ '     +"<span class=\\"aviso\\">assinatura formal + pesquisa de satisfação</span></div></div>";'
+ '    return h;}'
// redação ou devolvido → editor completo + envio ao Chefe
+ '  var normaSelVal=c.normaChave||(e.normas[0]?e.normas[0].cod:"");'
+ '  var normaOpts="<option value=\\"\\">— sem norma —</option>"+e.normas.map(function(n){var s=(n.cod===normaSelVal)?" selected":"";return "<option value=\\""+esc(n.cod)+"\\""+s+">"+esc(n.titulo)+" ("+esc(n.cod)+")</option>";}).join("");'
+ '  var tipoSel=c.tipo||"Atalho de resolução";'
+ '  var tipoOpts=["Atalho de resolução","Ponto de atenção"].map(function(t){return "<option"+(t===tipoSel?" selected":"")+">"+t+"</option>";}).join("");'
+ '  h+="<p class=\\"titulo\\">Parecer ao demandante</p>";'
+ '  h+="<div class=\\"campo\\"><label>Resposta técnica</label><textarea id=\\"fParecer\\" rows=\\"5\\" placeholder=\\"Redija o parecer… (o macete é referência OPSEC — não o cole cru na resposta ao demandante)\\">"+esc(c.parecerRedigido||"")+"</textarea></div>";'
+ '  h+="<div class=\\"campo\\"><label>Norma_Chave_Primária (col. F · código)</label><select id=\\"fNorma\\">"+normaOpts+"</select></div>";'
// ── Bloco do MACETE — memória interna da Seção, destacado + botão próprio (Diretor 2026-07-17) ──
+ '  h+="<div class=\\"macete\\" style=\\"margin-bottom:14px\\"><span class=\\"tag\\">⚡ Macete da Seção — memória interna (OPSEC · não vai ao demandante)</span>";'
+ '  h+="<div class=\\"campo\\" style=\\"margin:6px 0 10px\\"><input id=\\"fMacete\\" maxlength=\\"150\\" value=\\""+esc(c.macete||"")+"\\" placeholder=\\"a frase-atalho que resolve casos futuros iguais (máx. 150)\\"></div>";'
+ '  h+="<div class=\\"duo\\"><div class=\\"campo\\" style=\\"margin:0\\"><label>Classificação</label><select id=\\"fTipo\\">"+tipoOpts+"</select></div>";'
+ '  h+="<div class=\\"campo\\" style=\\"margin:0;display:flex;align-items:flex-end\\"><button class=\\"btn sec\\" type=\\"button\\" id=\\"btMacete\\" onclick=\\"salvarMacete()\\">💾 Salvar macete na memória</button></div></div></div>";'
+ '  h+="<div class=\\"acoes\\"><button class=\\"btn prim\\" id=\\"btChefe\\" onclick=\\"enviarChefe()\\">Enviar para avaliação do Chefe</button>"'
+ '   +"<button class=\\"btn sec\\" onclick=\\"rascunho()\\">Salvar rascunho</button>"'
+ '   +"<span class=\\"aviso\\">o macete segue junto ao enviar · o Chefe valida antes do demandante</span></div></div>";'
+ '  return h;}'
// ── coletas + chamadas ao servidor ──
+ 'function trava(ids){ids.forEach(function(id){var b=document.getElementById(id);if(b){b.disabled=true;}});}'
+ 'function enviarChefe(){var parecer=val("fParecer");if(!parecer.trim()){toast("O parecer está em branco.");return;}'
+ '  trava(["btChefe"]);'
+ '  google.script.run.withSuccessHandler(function(){toast("Enviado ao Chefe para validação.");init();})'
+ '   .withFailureHandler(function(err){toast("Erro: "+err.message);init();})'
+ '   .enviarParaChefe({linha:ESTADO.sel,parecer:parecer,normaChave:val("fNorma"),tipo:val("fTipo"),macete:val("fMacete")});}'
+ 'function rascunho(){google.script.run.withSuccessHandler(function(){toast("Rascunho salvo.");}).withFailureHandler(function(err){toast("Erro: "+err.message);}).salvarRascunho({linha:ESTADO.sel,parecer:val("fParecer")});}'
+ 'function salvarMacete(){var m=val("fMacete");if(!m.trim()){toast("Escreva o macete antes de salvar.");return;}var b=document.getElementById("btMacete");if(b)b.disabled=true;'
+ '  google.script.run.withSuccessHandler(function(){toast("Macete salvo na memória da Seção. ⚡");if(b)b.disabled=false;})'
+ '   .withFailureHandler(function(err){toast("Erro: "+err.message);if(b)b.disabled=false;})'
+ '   .salvarMacete({linha:ESTADO.sel,macete:m,tipo:val("fTipo")});}'
+ 'function chefeValida(){trava(["btA","btB","btC"]);'
+ '  google.script.run.withSuccessHandler(function(){toast("Validada e devolvida ao curador.");init();})'
+ '   .withFailureHandler(function(err){toast("Erro: "+err.message);init();})'
+ '   .chefeValidar({linha:ESTADO.sel,parecer:val("fParecer"),chefeNota:val("fChefeNota")});}'
+ 'function chefeDevolve(){if(!val("fChefeNota").trim()){toast("Escreva a nota de devolução.");return;}trava(["btA","btB","btC"]);'
+ '  google.script.run.withSuccessHandler(function(){toast("Devolvida ao curador para ajuste.");init();})'
+ '   .withFailureHandler(function(err){toast("Erro: "+err.message);init();})'
+ '   .chefeDevolver({linha:ESTADO.sel,parecer:val("fParecer"),chefeNota:val("fChefeNota")});}'
+ 'function chefeEnvia(){var parecer=val("fParecer");if(!parecer.trim()){toast("O parecer está em branco.");return;}trava(["btA","btB","btC"]);'
+ '  google.script.run.withSuccessHandler(function(){toast("Validada e enviada ao demandante.");init();})'
+ '   .withFailureHandler(function(err){toast("Erro: "+err.message);init();})'
+ '   .chefeEnviarDemandante({linha:ESTADO.sel,parecer:parecer,chefeNota:val("fChefeNota")});}'
+ 'function curadorEnvia(){var parecer=val("fParecer");if(!parecer.trim()){toast("O parecer está em branco.");return;}trava(["btEnv"]);'
+ '  google.script.run.withSuccessHandler(function(){toast("Enviada ao demandante.");init();})'
+ '   .withFailureHandler(function(err){toast("Erro: "+err.message);init();})'
+ '   .curadorEnviarDemandante({linha:ESTADO.sel,parecer:parecer});}'
+ 'init();';
}
