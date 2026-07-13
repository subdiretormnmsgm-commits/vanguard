/**
 * ═══════════════════════════════════════════════════════════════════════
 * FASE 2: CAPTURA WEB APP — Base de Consultas Asse Ct Orç (DCEM)
 * ═══════════════════════════════════════════════════════════════════════
 */

// As 13 seções (espelhado de FASE1_GERADOR_BASE.gs)
var SECOES_VALIDAS = [
  'QEMA', 'QSG', 'Cursos e Estágios', 'Praças', 'Ajudância Geral',
  'Seção de Seleção', 'SPEC', 'Assessoria Jurídica', 'AI',
  'Diretor', 'Subdiretor', 'Adjunto de Comando', 'Assistente'
];

function doGet(e) {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var abaCasos = ss.getSheetByName('CASOS');

  // Lê os casos (macro-temas) ignorando linhas vazias
  var casosRaw = abaCasos.getRange(2, 2, Math.max(1, abaCasos.getLastRow() - 1), 1).getValues();
  var casos = casosRaw.map(function(r) { return r[0]; }).filter(String);

  // ── ROTA B (host externo): modo API. O captura.html hospedado no Cloudflare Pages
  //    pede a lista viva de CASOS + SECOES por aqui (GET ?mode=casos) e recebe JSON.
  //    GET é "simple request": o navegador não dispara preflight OPTIONS, e o Google
  //    devolve Access-Control-Allow-Origin:* no destino final — resposta legível cross-origin.
  if (e && e.parameter && e.parameter.mode === 'casos') {
    return ContentService
      .createTextOutput(JSON.stringify({ sucesso: true, casos: casos, secoes: SECOES_VALIDAS }))
      .setMimeType(ContentService.MimeType.JSON);
  }

  var template = HtmlService.createTemplateFromFile('captura');
  template.secoes = SECOES_VALIDAS;
  template.casos = casos;

  return template.evaluate()
    .setTitle('Consulta — Asse Ct Orç / DCEM')
    .addMetaTag('viewport', 'width=device-width, initial-scale=1');
}

/**
 * Endpoint chamado pelo front-end via google.script.run
 */
function doPostData(dados) {
  var lock = LockService.getScriptLock();
  try {
    lock.waitLock(10000); // 5º Trilho / Concorrência
  } catch (e) {
    throw new Error('Sistema ocupado. Tente novamente em instantes.');
  }

  try {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var aba = ss.getSheetByName('REGISTROS');
    if (!aba) throw new Error('Aba REGISTROS não encontrada na base.');

    // 1. Validação server-side robusta (Assunto conferido contra a lista viva de CASOS)
    validar_(dados, lerCasos_());

    // 2. Geração do ID
    var idConsulta = gerarIdConsulta_(aba);
    var dataHora = new Date();

    // 3. Gravação cirúrgica (via setValues) para proteger ARRAYFORMULA em Q
    // O array compreende as colunas A até G (7 colunas no total).
    // F (Norma_Chave_Primaria) é deixada vazia para o curador.
    var linhaGravar = [[
      idConsulta,        // A: ID_Consulta
      dataHora,          // B: Data_Hora
      dados.email,       // C: Demandante_Email
      dados.secao,       // D: Secao_Demandante
      dados.assunto,     // E: Caso_Tipo_Tema
      "",                // F: Norma_Chave_Primaria (vazio)
      dados.duvida       // G: Fato_Gerador
    ]];

    // Linha-alvo determinística: derivada da coluna A (única sem fórmula) e imune à
    // inflação de getLastRow() que a ARRAYFORMULA de intervalo aberto em Q pode causar.
    var ultimaLinha = proximaLinha_(aba);

    // A coluna E (Caso_Tipo_Tema) herda do GERADOR uma regra de validação de dados
    // (dropdown restrito à lista viva de CASOS). O valor livre "Outros: ..." não está
    // nessa lista e faz o setValues estourar ("violam as regras de validação de dados").
    // Liberamos a validação SÓ da célula-alvo de E antes de gravar — o valor já foi
    // validado por validar_() no servidor, então o dropdown ali não protege mais nada.
    aba.getRange(ultimaLinha, 5).setDataValidation(null);

    aba.getRange(ultimaLinha, 1, 1, 7).setValues(linhaGravar);

    // 4. Trilho 3: E-mail de confirmação ao demandante
    MailApp.sendEmail({
      to: dados.email,
      subject: 'Consulta registrada — ' + idConsulta,
      body: 'Sua consulta (' + idConsulta + ') foi registrada com sucesso na Base de Consultas da Asse Ct Orç / DCEM.\n\n' +
            'Tema: ' + dados.assunto + '\n\n' +
            'Você receberá o parecer técnico neste e-mail assim que nossa equipe finalizar a análise.\n\n' +
            'Atenciosamente,\n' +
            'Asse Ct Orç / DCEM'
    });

    // 4b. Aviso ao CURADOR (quem responde) — orcamentariodcem recebe cada nova consulta.
    //     best-effort (P-110): o registro já está gravado; se o e-mail falhar não quebra nada.
    try {
      MailApp.sendEmail({
        to: Session.getEffectiveUser().getEmail(),   // = orcamentariodcem@gmail.com (dono do script)
        replyTo: dados.email,                          // "Responder" já vai direto ao demandante
        subject: 'NOVA CONSULTA ' + idConsulta + ' — ' + (dados.secao || '-') + ' · ' + (dados.assunto || '-'),
        body: 'Nova consulta registrada — responder ao demandante.\n\n' +
              'Protocolo: ' + idConsulta + '\n' +
              'Seção: ' + (dados.secao || '-') + '\n' +
              'Tema: ' + (dados.assunto || '-') + '\n' +
              'Responder a: ' + (dados.email || '-') + '\n\n' +
              'Dúvida:\n' + (dados.duvida || '-')
      });
    } catch (eCur) { /* best-effort P-110: nunca quebra a gravação */ }

    // 5. Notificação ao curador via Telegram (P-110: best-effort — nunca quebra a
    //    gravação; se o Telegram falhar, o dado já está na planilha + e-mail).
    try { notificarTelegram_(dados, idConsulta); } catch (eTg) { /* fallback: planilha + e-mail */ }

    return { sucesso: true, id: idConsulta };

  } catch (erro) {
    return { sucesso: false, erro: erro.message };
  } finally {
    lock.releaseLock();
  }
}

/**
 * ROTA B — Endpoint HTTP para o formulário hospedado FORA do Apps Script
 * (Cloudflare Pages). O front-end envia POST com Content-Type text/plain;charset=utf-8
 * — isso torna a chamada "simple request" e evita o preflight OPTIONS (que Web Apps
 * do Apps Script não respondem). O corpo é o JSON dos dados. A resposta volta como
 * JSON via ContentService; o Google injeta Access-Control-Allow-Origin:* no destino
 * final (script.googleusercontent.com), então o fetch consegue LER o retorno.
 *
 * Reaproveita integralmente a lógica já validada na V7 (doPostData): validação
 * server-side, fix da regra herdada na coluna E, ID sequencial e e-mail de confirmação.
 */
function doPost(e) {
  var resposta;
  try {
    var dados = JSON.parse(e.postData.contents);
    resposta = doPostData(dados);          // mesma engine da V7 — nada duplicado
  } catch (erro) {
    resposta = { sucesso: false, erro: 'Requisição inválida: ' + erro.message };
  }
  return ContentService
    .createTextOutput(JSON.stringify(resposta))
    .setMimeType(ContentService.MimeType.JSON);
}

/**
 * Validação de integridade Server-Side (nunca confiar no HTML)
 * @param {Object} dados        payload do front-end
 * @param {string[]} casosValidos lista viva de Casos-Tipo (CASOS!B2:B)
 */
function validar_(dados, casosValidos) {
  if (!dados.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(dados.email)) {
    throw new Error('E-mail inválido.');
  }
  if (!dados.secao || SECOES_VALIDAS.indexOf(dados.secao) === -1) {
    throw new Error('Seção inválida (não mapeada).');
  }
  // Aceita Caso-Tipo mapeado OU assunto livre marcado como "Outros:" (militar escreveu tema fora da lista).
  var ehOutros = dados.assunto && dados.assunto.indexOf('Outros:') === 0 && dados.assunto.replace('Outros:', '').trim() !== '';
  if (!ehOutros && (!dados.assunto || casosValidos.indexOf(dados.assunto) === -1)) {
    throw new Error('Assunto inválido (não mapeado).');
  }
  if (!dados.duvida || dados.duvida.trim() === '') {
    throw new Error('Dúvida não pode estar vazia.');
  }
  if (dados.duvida.length > 1000) {
    throw new Error('Dúvida não pode exceder 1000 caracteres.');
  }
}

/**
 * Lê a lista viva de Casos-Tipo (aba CASOS, coluna B "Tema") — mesma fonte do dropdown.
 */
function lerCasos_() {
  var abaCasos = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('CASOS');
  if (!abaCasos) throw new Error('Aba CASOS não encontrada na base.');
  var raw = abaCasos.getRange(2, 2, Math.max(1, abaCasos.getLastRow() - 1), 1).getValues();
  return raw.map(function(r) { return r[0]; }).filter(String);
}

/**
 * Próxima linha de gravação, derivada da coluna A (ID_Consulta).
 * A coluna A nunca tem fórmula, então é imune à inflação de getLastRow() que a
 * ARRAYFORMULA de intervalo aberto em Q ($F2:$F) pode provocar.
 */
function proximaLinha_(aba) {
  var totalLinhas = aba.getLastRow();
  if (totalLinhas < 2) return 2; // só o cabeçalho → primeira consulta na linha 2
  var colA = aba.getRange(2, 1, totalLinhas - 1, 1).getValues();
  var ultimaComDado = 1; // linha 1 = cabeçalho
  for (var i = 0; i < colA.length; i++) {
    if (colA[i][0] !== '' && colA[i][0] !== null) {
      ultimaComDado = i + 2; // +2: índice 0 corresponde à linha 2
    }
  }
  return ultimaComDado + 1;
}

/**
 * Utilitário de autorização (rodar 1x no editor).
 * Chega de fato em MailApp.sendEmail — força a tela de consentimento do escopo
 * script.send_mail, que o doPostData sozinho não dispara (a validação barra antes).
 * Após conceder o acesso, o Web App /exec passa a enviar a confirmação (Trilho 3).
 * Envia um e-mail de teste para a própria conta dona (orcamentariodcem).
 */
function autorizarEmail() {
  MailApp.sendEmail({
    to: Session.getEffectiveUser().getEmail(),
    subject: 'Autorização de e-mail — Base Asse Ct Orç / DCEM',
    body: 'Escopo script.send_mail autorizado. O formulário de captura já envia a confirmação ao demandante.'
  });
}

/**
 * Gera sequencial no formato CONS-AAAAMMDD-NNN
 */
function gerarIdConsulta_(aba) {
  var hoje = new Date();
  var aaaammdd = Utilities.formatDate(hoje, Session.getScriptTimeZone(), 'yyyyMMdd');
  var prefixo = 'CONS-' + aaaammdd + '-';
  
  var numLinhas = Math.max(1, aba.getLastRow());
  var maxSeq = 0;
  
  if (numLinhas > 1) {
    // Busca todos os IDs na coluna A para varrer o maior sequencial do dia
    var rangeIds = aba.getRange(2, 1, numLinhas - 1, 1).getValues();
    for (var i = 0; i < rangeIds.length; i++) {
      var idAtual = rangeIds[i][0];
      if (idAtual && idAtual.toString().indexOf(prefixo) === 0) {
        var partes = idAtual.toString().split('-');
        if (partes.length === 3) {
          var seq = parseInt(partes[2], 10);
          if (!isNaN(seq) && seq > maxSeq) {
            maxSeq = seq;
          }
        }
      }
    }
  }
  
  var proximoSeq = maxSeq + 1;
  var seqFormatado = proximoSeq < 10 ? '00' + proximoSeq : (proximoSeq < 100 ? '0' + proximoSeq : proximoSeq);

  return prefixo + seqFormatado;
}

/**
 * ═══════════════════════════════════════════════════════════════════════
 * TELEGRAM — Notificação ao curador a cada nova consulta
 * ═══════════════════════════════════════════════════════════════════════
 * Segredo NUNCA versionado (doutrina soberana + HV-1): o token e o chat_id
 * vivem nas Propriedades do Script (Configurações do projeto → Propriedades
 * do script), nunca no código. Se não estiverem configurados, a função
 * simplesmente não faz nada — a consulta continua gravando normal.
 */
function notificarTelegram_(dados, idConsulta) {
  var props = PropertiesService.getScriptProperties();
  var token = props.getProperty('TELEGRAM_TOKEN');
  var chatId = props.getProperty('TELEGRAM_CHAT_ID');
  if (!token || !chatId) return; // não configurado → silêncio (fallback: planilha + e-mail)

  var texto =
    '🔔 <b>Nova consulta — Asse Ct Orç / DCEM</b>\n\n' +
    '<b>ID:</b> ' + idConsulta + '\n' +
    '<b>Seção:</b> ' + (dados.secao || '-') + '\n' +
    '<b>De:</b> ' + (dados.email || '-') + '\n' +
    '<b>Tema:</b> ' + (dados.assunto || '-') + '\n\n' +
    '<b>Dúvida:</b>\n' + (dados.duvida || '-');

  UrlFetchApp.fetch('https://api.telegram.org/bot' + token + '/sendMessage', {
    method: 'post',
    contentType: 'application/json',
    payload: JSON.stringify({
      chat_id: chatId,
      text: texto,
      parse_mode: 'HTML',
      disable_web_page_preview: true
    }),
    muteHttpExceptions: true
  });
}

/**
 * Setup 1-toque (rodar 1x no editor, DEPOIS de definir a Script Property
 * TELEGRAM_TOKEN e de mandar qualquer mensagem ao seu bot no Telegram).
 * Descobre o chat_id da última mensagem recebida pelo bot, salva nas
 * Propriedades do Script e dispara uma mensagem-teste de confirmação.
 * Sem underscore no nome: precisa aparecer na lista "Executar" do editor
 * (Apps Script oculta funções terminadas em "_"). notificarTelegram_ segue
 * privada (roda só via doPostData), esta é chamada manualmente 1x.
 */
function configurarTelegram() {
  var props = PropertiesService.getScriptProperties();
  var token = props.getProperty('TELEGRAM_TOKEN');
  if (!token) {
    throw new Error('Defina primeiro a Script Property TELEGRAM_TOKEN em Configurações do projeto → Propriedades do script.');
  }

  var resp = UrlFetchApp.fetch('https://api.telegram.org/bot' + token + '/getUpdates', { muteHttpExceptions: true });
  var data = JSON.parse(resp.getContentText());
  if (!data.ok || !data.result || data.result.length === 0) {
    throw new Error('Nenhuma mensagem encontrada. Abra o seu bot no Telegram, envie qualquer texto (ex: "oi") e rode esta função de novo.');
  }

  var ultimo = data.result[data.result.length - 1];
  var chat = (ultimo.message && ultimo.message.chat) ||
             (ultimo.channel_post && ultimo.channel_post.chat) || null;
  if (!chat || (chat.id === undefined || chat.id === null)) {
    throw new Error('Não consegui ler o chat_id da última atualização.');
  }
  var chatId = chat.id.toString();
  props.setProperty('TELEGRAM_CHAT_ID', chatId);

  UrlFetchApp.fetch('https://api.telegram.org/bot' + token + '/sendMessage', {
    method: 'post',
    contentType: 'application/json',
    payload: JSON.stringify({
      chat_id: chatId,
      text: '✅ Notificações da Base de Consultas (Asse Ct Orç / DCEM) ativadas. A partir de agora, cada nova dúvida cai aqui.'
    }),
    muteHttpExceptions: true
  });

  Logger.log('OK — chat_id salvo: ' + chatId);
}

/**
 * Diagnóstico (rodar 1x se configurarTelegram disser "Nenhuma mensagem encontrada").
 * Não expõe o token: lê da Script Property e só reporta o que importa —
 * qual bot o token abre (getMe), se há webhook roubando os updates
 * (getWebhookInfo) e quantos updates o getUpdates enxerga. Com isso sabemos
 * se o problema é bot errado (A) ou webhook configurado (B).
 */
function diagnosticoTelegram() {
  var token = PropertiesService.getScriptProperties().getProperty('TELEGRAM_TOKEN');
  if (!token) { Logger.log('TELEGRAM_TOKEN ausente nas Propriedades do Script.'); return; }

  var base = 'https://api.telegram.org/bot' + token + '/';

  var me = JSON.parse(UrlFetchApp.fetch(base + 'getMe', { muteHttpExceptions: true }).getContentText());
  Logger.log('getMe.ok=' + me.ok + '  bot=@' + (me.result && me.result.username) + '  nome=' + (me.result && me.result.first_name));

  var wh = JSON.parse(UrlFetchApp.fetch(base + 'getWebhookInfo', { muteHttpExceptions: true }).getContentText());
  var whUrl = wh.result && wh.result.url;
  Logger.log('getWebhookInfo.url=' + (whUrl ? whUrl : '(vazio — sem webhook)') +
             '  pending=' + (wh.result && wh.result.pending_update_count));

  var up = JSON.parse(UrlFetchApp.fetch(base + 'getUpdates', { muteHttpExceptions: true }).getContentText());
  Logger.log('getUpdates.ok=' + up.ok + '  qtd=' + (up.result ? up.result.length : 0));

  if (whUrl) {
    Logger.log('>>> CAUSA B: existe webhook. O getUpdates fica vazio enquanto ele existir. ' +
               'Se este for um bot SÓ para a Base de Consultas, dá para removê-lo; se for o bot do Hermes, use OUTRO bot.');
  } else if (!up.result || up.result.length === 0) {
    Logger.log('>>> CAUSA A: sem webhook e sem updates. A mensagem não chegou a ESTE bot (@' +
               (me.result && me.result.username) + '). Mande "oi" para exatamente este @ e rode de novo.');
  } else {
    Logger.log('>>> Updates presentes — rode configurarTelegram novamente que ele captura o chat_id.');
  }
}
