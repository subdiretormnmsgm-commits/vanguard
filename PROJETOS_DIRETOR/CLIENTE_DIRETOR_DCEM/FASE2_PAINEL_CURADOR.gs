/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 * ║  FASE 2 — PAINEL DO CURADOR · "Análise e confecção das respostas"         ║
 * ║  Asse Ct Orç / DCEM · Base de Consultas                                   ║
 * ╠══════════════════════════════════════════════════════════════════════════╣
 * ║  Modal (~1000px) dentro do Google Sheets. Fiel ao mockup aprovado.       ║
 * ║  Lê a base gerada pela FASE1 (NORMAS · CASOS · REGISTROS) e grava de      ║
 * ║  volta na aba REGISTROS ao enviar o parecer. Um único arquivo: cole no    ║
 * ║  editor Apps Script junto do FASE1_GERADOR_BASE.gs.                        ║
 * ║                                                                            ║
 * ║  Fluxo: onOpen() cria o menu → "Abrir painel" → modal.                    ║
 * ║  Uma consulta PENDENTE = linha em REGISTROS com Fato_Gerador preenchido e  ║
 * ║  Parecer_Oficial_Email VAZIO. Enviar o parecer preenche J/F/H e marca     ║
 * ║  respondida (opcionalmente notifica o demandante por e-mail).             ║
 * ╚══════════════════════════════════════════════════════════════════════════╝
 */

/* Índices de coluna da aba REGISTROS (1-based), espelham a FASE1. */
var REG = {
  ID: 1, DATA: 2, EMAIL: 3, SECAO: 4, CASO: 5, NORMA_CHAVE: 6, FATO: 7,
  TIPO: 8, MACETE: 9, PARECER: 10, AUTORIA_NOME: 11, AUTORIA_VISIVEL: 12,
  DONO_NORMA: 13, SATISFACAO: 14, ANEXO: 15, VERSAO: 16, OBSOLESCENCIA: 17
};

/* ───────────────────────────── Menu ───────────────────────────── */
function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu('⬤ Análise e confecção das respostas')
    .addItem('Abrir painel', 'abrirPainelCurador')
    .addToUi();
}

function abrirPainelCurador() {
  var html = HtmlService.createHtmlOutput(gerarHtmlPainel())
    .setWidth(1000)
    .setHeight(680)
    .setTitle('Painel da Assessoria');
  SpreadsheetApp.getUi().showModalDialog(html, 'Análise e confecção das respostas');
}

/* ═══════════════════════ SERVIDOR — leitura ═══════════════════════ */

/** Estado inicial: fila de pendentes + métricas do cabeçalho. */
function getEstadoInicial() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var reg = ss.getSheetByName('REGISTROS');
  var ultima = reg.getLastRow();
  var pendentes = [], respondidas = 0;

  if (ultima >= 2) {
    var dados = reg.getRange(2, 1, ultima - 1, REG.OBSOLESCENCIA).getValues();
    for (var i = 0; i < dados.length; i++) {
      var lin = dados[i], nLinha = i + 2;
      var temFato = String(lin[REG.FATO - 1]).trim() !== '';
      var temId   = String(lin[REG.ID - 1]).trim() !== '';
      if (!temId && !temFato) continue;           // linha vazia
      // F-2: um rascunho grava '[RASCUNHO] …' em PARECER — NÃO é resposta final, continua pendente.
      var valParecer = String(lin[REG.PARECER - 1]).trim();
      var respondida = valParecer !== '' && valParecer.indexOf('[RASCUNHO]') !== 0;
      if (respondida) { respondidas++; continue; }
      pendentes.push({
        linha: nLinha,
        id: String(lin[REG.ID - 1] || ('CONS-linha-' + nLinha)),
        tema: String(lin[REG.CASO - 1] || '(sem Caso-Tipo)'),
        secao: String(lin[REG.SECAO - 1] || '—')
      });
    }
  }
  return {
    pendentes: pendentes,
    metricas: { pendentes: pendentes.length, respondidas: respondidas }
  };
}

/** Consulta completa + embasamento relacional (Caso → Normas → Acervo → Macete). */
function getConsultaCompleta(nLinha) {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var reg = ss.getSheetByName('REGISTROS');
  var lin = reg.getRange(nLinha, 1, 1, REG.OBSOLESCENCIA).getValues()[0];

  // F-2: se houver rascunho salvo, devolvê-lo (sem o prefixo) para pré-preencher o textarea ao reabrir.
  var parecerBruto = String(lin[REG.PARECER - 1] || '');
  var rascunho = parecerBruto.indexOf('[RASCUNHO]') === 0
    ? parecerBruto.replace(/^\[RASCUNHO\]\s?/, '') : '';

  var consulta = {
    linha: nLinha,
    id: String(lin[REG.ID - 1] || ''),
    secao: String(lin[REG.SECAO - 1] || ''),
    email: String(lin[REG.EMAIL - 1] || ''),
    dataHora: lin[REG.DATA - 1] ? Utilities.formatDate(new Date(lin[REG.DATA - 1]),
              Session.getScriptTimeZone(), 'dd/MM HH:mm') : '',
    fato: String(lin[REG.FATO - 1] || ''),
    caso: String(lin[REG.CASO - 1] || ''),
    normaChave: String(lin[REG.NORMA_CHAVE - 1] || ''),
    tipo: String(lin[REG.TIPO - 1] || ''),
    rascunho: rascunho
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
 * Grava o parecer na linha da consulta e marca respondida.
 * payload: { linha, parecer, normaChave, tipo, autoriaNome, autoriaVisivel,
 *            macete, satisfacao, notificarEmail (bool) }
 */
function enviarParecer(payload) {
  if (!payload || !payload.linha) throw new Error('Consulta não selecionada.');
  var parecer = String(payload.parecer || '').trim();
  if (!parecer) throw new Error('O parecer não pode ficar em branco.');

  var reg = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('REGISTROS');
  var n = Number(payload.linha);

  // F-1: grava os campos com validação (Norma_Chave = col. F) ANTES do PARECER. Se a validação
  // rejeitar a escrita, o erro sobe SEM ter marcado a consulta como respondida — ela permanece na
  // fila. PARECER é sempre a ÚLTIMA escrita: só marca respondida quando todo o resto passou.
  if (payload.normaChave)  reg.getRange(n, REG.NORMA_CHAVE).setValue(payload.normaChave);
  if (payload.tipo)        reg.getRange(n, REG.TIPO).setValue(payload.tipo);
  if (payload.macete)      reg.getRange(n, REG.MACETE).setValue(String(payload.macete).slice(0, 150));
  // F-4: autoria só é tocada quando o painel realmente enviar esses campos. Não forçar 'Não' a cada
  // envio — isso apagaria em silêncio uma escolha de visibilidade (E-1 do Embaixador). UI de autoria
  // fica para a V2; até lá, o painel não manda autoria e a coluna preserva o que já houver.
  if (payload.autoriaNome) reg.getRange(n, REG.AUTORIA_NOME).setValue(payload.autoriaNome);
  if (typeof payload.autoriaVisivel !== 'undefined')
    reg.getRange(n, REG.AUTORIA_VISIVEL).setValue(payload.autoriaVisivel ? 'Sim' : 'Não');
  if (!reg.getRange(n, REG.DATA).getValue()) reg.getRange(n, REG.DATA).setValue(new Date());
  reg.getRange(n, REG.PARECER).setValue(parecer);   // PARECER POR ÚLTIMO (F-1)

  // Notificação ao demandante — opcional, tolerante a falha (P-110).
  var enviado = false, emailErro = '';
  if (payload.notificarEmail) {
    var email = String(reg.getRange(n, REG.EMAIL).getValue() || '').trim();
    if (email) {
      try {
        var idc = String(reg.getRange(n, REG.ID).getValue() || '');
        MailApp.sendEmail({
          to: email,
          subject: 'Parecer — sua consulta ' + idc + ' (Asse Ct Orç / DCEM)',
          body: parecer + '\n\n— Assessoria de Controle Orçamentário / DCEM'
        });
        enviado = true;
      } catch (e) { emailErro = String(e); }
    }
  }
  return { ok: true, emailEnviado: enviado, emailErro: emailErro };
}

/** Salva rascunho: grava só o parecer, sem marcar respondida nem notificar. */
function salvarRascunho(payload) {
  if (!payload || !payload.linha) throw new Error('Consulta não selecionada.');
  var reg = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('REGISTROS');
  var n = Number(payload.linha);
  // rascunho vai para MACETE_TACITO? Não — guardamos em Fato? Usamos coluna Parecer com marca [RASCUNHO].
  reg.getRange(n, REG.PARECER).setValue('[RASCUNHO] ' + String(payload.parecer || ''));
  return { ok: true };
}

/* ═══════════════════════ Helpers de texto ═══════════════════════ */
function tituloCurto(t) {
  t = String(t || '');
  var corte = t.indexOf(' — ');
  return corte > 0 ? t.slice(0, corte) : (t.length > 60 ? t.slice(0, 57) + '…' : t);
}

/* ═══════════════════════ HTML do modal (fiel ao mockup) ═══════════════════════ */
function gerarHtmlPainel() {
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
+ '.chip.dia{background:rgba(47,125,91,.15);color:var(--verde)}'
+ '.chip.rev{background:rgba(178,58,58,.15);color:var(--vermelho)}'
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
+ '.btn.sec{background:transparent;color:var(--tinta-2);border-color:var(--borda)}'
+ '.btn.sec:hover{background:var(--superf-2)}'
+ '.acoes .aviso{font-size:11.5px;color:var(--tinta-3);margin-left:auto;display:flex;align-items:center;gap:5px}'
+ '.opt{font-size:11.5px;color:var(--tinta-2);display:inline-flex;align-items:center;gap:6px}'
+ '.vazio{padding:60px 20px;text-align:center;color:var(--tinta-3);font-size:13px}'
+ '.toast{position:fixed;left:50%;bottom:18px;transform:translateX(-50%);background:var(--marinho);color:#eaf0f9;padding:10px 18px;border-radius:8px;font-size:13px;box-shadow:var(--sombra);opacity:0;transition:opacity .2s;pointer-events:none}'
+ '.toast.show{opacity:1}'
+ '</style></head><body>'
+ '<div class="modal">'
+ '<header class="cab"><div class="brasao">🎖</div>'
+ '<div><h1>Painel da Assessoria</h1><div class="sub">Base de Consultas · Asse Ct Orç / DCEM</div></div>'
+ '<div class="metricas">'
+ '<div class="m"><div class="n" id="mPend">–</div><div class="l">pendentes</div></div>'
+ '<div class="m"><div class="n" id="mResp">–</div><div class="l">respondidas</div></div>'
+ '</div></header>'
+ '<div class="corpo">'
+ '<aside class="fila"><div class="fila-cab"><span>Fila de pendentes</span><span id="filaN">–</span></div>'
+ '<div id="fila"></div></aside>'
+ '<section class="work" id="work"><div class="vazio">Carregando a fila…</div></section>'
+ '</div></div>'
+ '<div class="toast" id="toast"></div>'
+ '<script>' + gerarClientJs() + '</script>'
+ '</body></html>';
}

/* JS do cliente — separado para legibilidade. */
function gerarClientJs() {
  return ''
+ 'var ESTADO={pendentes:[],sel:null,dados:null};'
+ 'function esc(s){return String(s==null?"":s).replace(/[&<>"]/g,function(c){return{"&":"&amp;","<":"&lt;",">":"&gt;","\\"":"&quot;"}[c];});}'
+ 'function toast(m){var t=document.getElementById("toast");t.textContent=m;t.classList.add("show");setTimeout(function(){t.classList.remove("show");},2600);}'
+ 'function init(){google.script.run.withSuccessHandler(function(e){'
+ '  ESTADO.pendentes=e.pendentes;'
+ '  document.getElementById("mPend").textContent=e.metricas.pendentes;'
+ '  document.getElementById("mResp").textContent=e.metricas.respondidas;'
+ '  document.getElementById("filaN").textContent=e.pendentes.length;'
+ '  renderFila();'
+ '  if(e.pendentes.length){selecionar(e.pendentes[0].linha);}'
+ '  else{document.getElementById("work").innerHTML="<div class=\\"vazio\\">Nenhuma consulta pendente. Tudo respondido. 🎖</div>";}'
+ '}).withFailureHandler(function(err){document.getElementById("work").innerHTML="<div class=\\"vazio\\">Erro: "+esc(err.message)+"</div>";}).getEstadoInicial();}'
+ 'function renderFila(){var h="";ESTADO.pendentes.forEach(function(p){'
+ '  h+="<div class=\\"card"+(p.linha===ESTADO.sel?" sel":"")+"\\" onclick=\\"selecionar("+p.linha+")\\">"'
+ '   +"<div class=\\"id\\">"+esc(p.id)+"</div>"'
+ '   +"<div class=\\"tema\\">"+esc(p.tema)+"</div>"'
+ '   +"<div class=\\"meta\\"><span class=\\"chip sec\\">"+esc(p.secao)+"</span><span class=\\"chip pend\\">● pendente</span></div></div>";'
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
+ '   +(c.secao?"<span class=\\"chip sec\\">"+esc(c.secao)+"</span>":"")'
+ '   +(c.email?"<span class=\\"de\\">de <b>"+esc(c.email)+"</b>"+(c.dataHora?" · "+esc(c.dataHora):"")+"</span>":"")+"</div>"'
+ '   +"<p class=\\"duvida\\">"+esc(c.fato||"(sem texto da dúvida)")+"</p></div></div>";'
+ '  h+="<div class=\\"bloco\\"><p class=\\"titulo\\">Embasamento — busca relacional (Caso → Norma → Documento → Precedente)</p><div class=\\"rel\\">"'
+ '   +"<div class=\\"passo\\"><div class=\\"rot\\">Caso-Tipo</div><div class=\\"val\\"><span class=\\"norma\\"><b>"+esc(e.casoTema)+"</b></span></div></div>"'
+ '   +"<div class=\\"passo\\"><div class=\\"rot\\">Normas</div><div class=\\"val\\">"+normasH+"</div></div>"'
+ '   +"<div class=\\"passo\\"><div class=\\"rot\\">Acervo</div><div class=\\"val\\">"+acervoH+"</div></div>"'
+ '   +"<div class=\\"passo\\"><div class=\\"rot\\">Macete</div><div class=\\"val\\" style=\\"display:block\\">"+maceteH+"</div></div>"'
+ '   +"</div></div>";'
+ '  var normaSelVal=c.normaChave||(e.normas[0]?e.normas[0].cod:"");'
+ '  var normaOpts="<option value=\\"\\">— sem norma —</option>"+e.normas.map(function(n){var s=(n.cod===normaSelVal)?" selected":"";return "<option value=\\""+esc(n.cod)+"\\""+s+">"+esc(n.titulo)+" ("+esc(n.cod)+")</option>";}).join("");'
+ '  h+="<div class=\\"bloco resp\\"><p class=\\"titulo\\">Parecer ao demandante</p>"'
+ '   +"<div class=\\"campo\\"><label>Resposta técnica</label><textarea id=\\"fParecer\\" rows=\\"5\\" placeholder=\\"Redija o parecer… (o macete é referência OPSEC — não o cole cru na resposta ao demandante)\\">"+esc(c.rascunho||"")+"</textarea></div>"'
+ '   +"<div class=\\"duo\\"><div class=\\"campo\\"><label>Norma_Chave_Primária (col. F · código)</label><select id=\\"fNorma\\">"+normaOpts+"</select></div>"'
+ '   +"<div class=\\"campo\\"><label>Tipo do registro</label><select id=\\"fTipo\\"><option>Macete Cinzento</option><option>Armadilha</option></select></div></div>"'
+ '   +"<div class=\\"campo\\"><label>Macete tácito (opcional · máx. 150, OPSEC)</label><input id=\\"fMacete\\" maxlength=\\"150\\" placeholder=\\"a frase-atalho que resolve casos futuros iguais\\"></div>"'
+ '   +"<div class=\\"acoes\\"><button class=\\"btn prim\\" id=\\"btEnviar\\" onclick=\\"enviar()\\">✓ Enviar parecer ao demandante</button>"'
+ '   +"<button class=\\"btn sec\\" onclick=\\"rascunho()\\">Salvar rascunho</button>"'
+ '   +"<label class=\\"opt\\"><input type=\\"checkbox\\" id=\\"fNotificar\\" checked> notificar por e-mail</label>"'
+ '   +"<span class=\\"aviso\\">grava em REGISTROS · marca respondida</span></div></div>";'
+ '  document.getElementById("work").innerHTML=h;}'
+ 'function coleta(){return{linha:ESTADO.sel,'
+ '  parecer:document.getElementById("fParecer").value,'
+ '  normaChave:document.getElementById("fNorma").value,'
+ '  tipo:document.getElementById("fTipo").value,'
+ '  macete:document.getElementById("fMacete").value,'
+ '  notificarEmail:document.getElementById("fNotificar").checked};}'
+ 'function enviar(){var p=coleta();if(!p.parecer.trim()){toast("O parecer está em branco.");return;}'
+ '  var b=document.getElementById("btEnviar");b.disabled=true;b.textContent="Enviando…";'
+ '  google.script.run.withSuccessHandler(function(r){'
+ '    toast(r.emailEnviado?"Parecer enviado e e-mail disparado.":(r.emailErro?"Gravado. E-mail falhou: "+r.emailErro:"Parecer gravado e marcado respondido."));'
+ '    init();'
+ '  }).withFailureHandler(function(err){b.disabled=false;b.textContent="✓ Enviar parecer ao demandante";toast("Erro: "+err.message);}).enviarParecer(p);}'
+ 'function rascunho(){var p=coleta();google.script.run.withSuccessHandler(function(){toast("Rascunho salvo.");}).withFailureHandler(function(err){toast("Erro: "+err.message);}).salvarRascunho(p);}'
+ 'init();';
}
