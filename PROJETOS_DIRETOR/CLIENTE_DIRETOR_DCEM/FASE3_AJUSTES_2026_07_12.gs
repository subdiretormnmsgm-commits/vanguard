/* ══════════════════════════════════════════════════════════════════════════
 *  FASE3 — AJUSTES 2026-07-12 (veredito Diretor)
 *  Rodar UMA vez, direto pelo editor (▶ aplicarAjustes20260712). Idempotente.
 *  ────────────────────────────────────────────────────────────────────────
 *  Faz três coisas na planilha JÁ EXISTENTE (não recria a base):
 *   1. Renomeia a aba HANDOVER_LOG → "Livro de Passagem de Função".
 *   2. Aplica "aviso ao editar" (warning-only) nas 5 abas-motor.
 *   3. Não toca em dados. Não trava o painel (script owner ignora o aviso).
 *  NB: o Sheets NÃO tem senha por aba. "Aviso ao editar" é a proteção nativa
 *      contra edição manual acidental — mostra um pop-up de confirmação.
 * ══════════════════════════════════════════════════════════════════════════ */

function aplicarAjustes20260712() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var log = [];
  log.push(renomearLivroPassagem_(ss));
  log.push(protegerAbasMotor_(ss));
  SpreadsheetApp.getActiveSpreadsheet().toast(log.join('  ·  '), 'Ajustes 2026-07-12', 8);
  Logger.log(log.join('\n'));
}

/* 1. Renomeia a aba de passagem de função (nome antigo ou já novo). */
function renomearLivroPassagem_(ss) {
  var NOVO = 'Livro de Passagem de Função';
  var antiga = ss.getSheetByName('HANDOVER_LOG');
  if (ss.getSheetByName(NOVO)) return 'aba já se chama "' + NOVO + '"';
  if (!antiga) return 'aba HANDOVER_LOG não encontrada (nada a renomear)';
  antiga.setName(NOVO);
  return 'aba renomeada → "' + NOVO + '"';
}

/* 2. Aviso ao editar nas abas-motor (warning-only, sem restringir editores). */
function protegerAbasMotor_(ss) {
  var ABAS = ['NORMAS', 'CASOS', 'REGISTROS', 'PARAMETROS_ANO_CORRENTE', 'PAINEL_AUDITORIA'];
  var feitas = [];
  ABAS.forEach(function (nome) {
    var aba = ss.getSheetByName(nome);
    if (!aba) return;
    // remove proteções de aba anteriores para não empilhar duplicadas
    aba.getProtections(SpreadsheetApp.ProtectionType.SHEET).forEach(function (p) {
      if (p.canEdit()) p.remove();
    });
    aba.protect()
       .setDescription('Aba-motor — editar só pelo painel. Aviso 2026-07-12.')
       .setWarningOnly(true);
    feitas.push(nome);
  });
  return 'aviso ao editar aplicado em: ' + (feitas.join(', ') || 'nenhuma');
}
