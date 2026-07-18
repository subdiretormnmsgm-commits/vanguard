/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 * ║  FASE 3 — PAINEL DE ESTATÍSTICAS (item 6 · tally/analytics)                ║
 * ║  Asse Ct Orç / DCEM · Base de Consultas                                    ║
 * ╠══════════════════════════════════════════════════════════════════════════╣
 * ║  Contagem de dúvidas: total, hoje, semana, mês, respondidas × pendentes,   ║
 * ║  satisfação 👍/👎, recorte por Seção e por estado do fluxo.                ║
 * ║                                                                            ║
 * ║  100% FÓRMULAS VIVAS (não é snapshot): a aba se recalcula sozinha a cada   ║
 * ║  nova consulta/resposta. Roda 1x para (re)criar a aba — pelo menu          ║
 * ║  "⬤ Análise…" → "Atualizar painel de estatísticas" ou no editor.          ║
 * ║                                                                            ║
 * ║  As fórmulas são gravadas em notação US (setFormula exige inglês/vírgula); ║
 * ║  o Sheets exibe traduzido conforme o idioma da planilha. Lêem colunas por  ║
 * ║  posição fixa (A=ID, B=Data, D=Seção, N=Satisfação, U=Status_Fluxo) — as   ║
 * ║  novas colunas R..V não deslocam nenhuma dessas. NÃO toca a ARRAYFORMULA Q.║
 * ╚══════════════════════════════════════════════════════════════════════════╝
 */

var ABA_STATS = 'ESTATISTICAS';
var STATUS_ENVIADO = 'Enviado ao demandante';   // espelha FLX.ENVIADO da FASE2

function criarPainelEstatisticas() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  if (!ss.getSheetByName('REGISTROS')) throw new Error('Aba REGISTROS não encontrada.');

  var aba = ss.getSheetByName(ABA_STATS);
  if (aba) aba.clear(); else aba = ss.insertSheet(ABA_STATS);

  var MAR = '#12294a', MAR2 = '#1c3a63', AMBAR = '#b8882f', CINZA = '#efeadf', BORDA = '#ddd5c6';

  // ── Título ────────────────────────────────────────────────────────────────
  aba.getRange('A1:G1').merge()
    .setValue('PAINEL DE ESTATÍSTICAS — Base de Consultas · Asse Ct Orç / DCEM')
    .setBackground(MAR).setFontColor('#ffffff').setFontWeight('bold')
    .setFontSize(13).setHorizontalAlignment('left').setVerticalAlignment('middle');
  aba.setRowHeight(1, 34);
  aba.getRange('A2:G2').merge()
    .setValue('Fórmulas vivas — recalcula a cada consulta. Atualizado ao abrir a planilha.')
    .setFontColor('#8791a0').setFontStyle('italic').setFontSize(10);

  // ── Bloco 1 — Visão geral ──────────────────────────────────────────────────
  faixa_(aba, 'A4:G4', 'VISÃO GERAL', MAR2);
  var rotulos = ['Total', 'Respondidas', 'Pendentes', 'Taxa de resposta', '👍 Sim', '👎 Não', 'Satisfação'];
  aba.getRange('A5:G5').setValues([rotulos])
    .setFontWeight('bold').setFontColor(MAR2).setBackground(CINZA)
    .setHorizontalAlignment('center').setBorder(true, true, true, true, true, true, BORDA, null);

  aba.getRange('A6').setFormula('=COUNTA(REGISTROS!A2:A)');
  aba.getRange('B6').setFormula('=COUNTIF(REGISTROS!U2:U,"' + STATUS_ENVIADO + '")');
  aba.getRange('C6').setFormula('=A6-B6');
  aba.getRange('D6').setFormula('=IFERROR(B6/A6,0)');
  aba.getRange('E6').setFormula('=COUNTIF(REGISTROS!N2:N,"👍")');
  aba.getRange('F6').setFormula('=COUNTIF(REGISTROS!N2:N,"👎")');
  aba.getRange('G6').setFormula('=IFERROR(E6/(E6+F6),0)');
  aba.getRange('A6:G6').setFontSize(15).setFontWeight('bold').setHorizontalAlignment('center')
    .setVerticalAlignment('middle').setBorder(true, true, true, true, true, true, BORDA, null);
  aba.setRowHeight(6, 40);
  aba.getRange('D6').setNumberFormat('0%');
  aba.getRange('G6').setNumberFormat('0%');
  aba.getRange('E6').setFontColor('#2f7d5b');
  aba.getRange('F6').setFontColor('#b23a3a');

  // ── Bloco 2 — Por período (consultas RECEBIDAS, pela Data_Hora / col. B) ────
  faixa_(aba, 'A8:G8', 'POR PERÍODO  ·  consultas recebidas', MAR2);
  aba.getRange('A9:D9').setValues([['Hoje', 'Esta semana', 'Este mês', 'Total']])
    .setFontWeight('bold').setFontColor(MAR2).setBackground(CINZA)
    .setHorizontalAlignment('center').setBorder(true, true, true, true, true, true, BORDA, null);
  aba.getRange('A10').setFormula('=COUNTIFS(REGISTROS!B2:B,">="&TODAY())');
  // Semana começa na segunda: WEEKDAY(...,3) → 0=seg … 6=dom.
  aba.getRange('B10').setFormula('=COUNTIFS(REGISTROS!B2:B,">="&(TODAY()-WEEKDAY(TODAY(),3)))');
  aba.getRange('C10').setFormula('=COUNTIFS(REGISTROS!B2:B,">="&(EOMONTH(TODAY(),-1)+1))');
  aba.getRange('D10').setFormula('=COUNTA(REGISTROS!A2:A)');
  aba.getRange('A10:D10').setFontSize(15).setFontWeight('bold').setHorizontalAlignment('center')
    .setVerticalAlignment('middle').setBorder(true, true, true, true, true, true, BORDA, null);
  aba.setRowHeight(10, 40);

  // ── Bloco 3 — Por Seção (QUERY dinâmico) ───────────────────────────────────
  faixa_(aba, 'A12:C12', 'POR SEÇÃO', AMBAR);
  aba.getRange('A13').setFormula(
    '=IFERROR(QUERY(REGISTROS!A2:U,' +
    '"select D, count(A) where A is not null group by D order by count(A) desc ' +
    'label D \'Seção\', count(A) \'Consultas\'",0),"— sem dados —")');

  // ── Bloco 4 — Por estado do fluxo (QUERY dinâmico) ─────────────────────────
  faixa_(aba, 'E12:G12', 'POR ESTADO DO FLUXO', AMBAR);
  aba.getRange('E13').setFormula(
    '=IFERROR(QUERY(REGISTROS!A2:U,' +
    '"select U, count(A) where A is not null group by U order by count(A) desc ' +
    'label U \'Estado\', count(A) \'Qtd\'",0),"— sem dados —")');

  // ── Larguras + limpeza visual ──────────────────────────────────────────────
  var larg = { 1: 150, 2: 130, 3: 110, 4: 130, 5: 90, 6: 90, 7: 120 };
  Object.keys(larg).forEach(function (c) { aba.setColumnWidth(parseInt(c, 10), larg[c]); });
  aba.setHiddenGridlines(true);
  aba.setFrozenRows(2);
  aba.activate();

  var msg = 'OK — aba "' + ABA_STATS + '" (re)criada com fórmulas vivas.';
  Logger.log(msg);
  return msg;
}

/** Faixa-título de bloco (merge + fundo + texto branco). */
function faixa_(aba, a1, texto, cor) {
  aba.getRange(a1).merge()
    .setValue(texto).setBackground(cor).setFontColor('#ffffff')
    .setFontWeight('bold').setFontSize(11).setVerticalAlignment('middle')
    .setHorizontalAlignment('left');
  aba.setRowHeight(aba.getRange(a1).getRow(), 26);
}
