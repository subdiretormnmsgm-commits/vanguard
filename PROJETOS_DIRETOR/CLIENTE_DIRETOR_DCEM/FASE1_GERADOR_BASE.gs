/**
 * ═══════════════════════════════════════════════════════════════════════
 * GERADOR DA BASE — Base de Consultas Asse Ct Orç (DCEM)  ·  Fase 1
 * ═══════════════════════════════════════════════════════════════════════
 * Projeto pessoal do Diretor · isolado (P-059). Roda DENTRO da conta
 * orcamentariodcem@gmail.com — o dado nasce e mora no perímetro soberano
 * (Trilho 1). Este script só CRIA a estrutura; não envia nada para fora.
 *
 * ⚠ COLE O ARQUIVO INTEIRO — do primeiro ao ÚLTIMO caractere.
 *    O erro "ReferenceError: obterOuCriar is not defined" significa que a
 *    seção AUXILIARES (no fim do arquivo) não foi colada. Role até o fim,
 *    confirme que a última linha é a chave "}" de removerAbaPadraoVazia.
 *
 * COMO USAR (5 passos, ~2 min):
 *   1. Logado em orcamentariodcem@gmail.com, abra  https://sheets.new
 *   2. Renomeie a planilha para:  BASE_ASSE_CT_ORC
 *   3. Menu  Extensões → Apps Script
 *   4. Apague o conteúdo, cole ESTE arquivo INTEIRO, salve (Ctrl+S)
 *   5. Selecione a função  construirBase  e clique  ▶ Executar
 *      (autorize o acesso quando o Google pedir — é a sua própria conta)
 *
 * Ao terminar, a planilha terá 7 abas:
 *   LEIA-ME · NORMAS · CASOS · PARAMETROS_ANO_CORRENTE · REGISTROS ·
 *   PAINEL_AUDITORIA · HANDOVER_LOG
 *
 * SEMENTES ANCORADAS NO ACERVO REAL (GATE DE FATO):
 *   Fonte = índice.docx da conta soberana (133 pareceres/DIEx, Cel Santos,
 *   Ch Asse Ct Orç/DCEM, 02/07/2026). Domínio: INDENIZAÇÃO DE MOVIMENTAÇÃO.
 *   Anexo_Referencia = "Nr Ordem" (01–133) do próprio índice — chave natural.
 *
 * ENDURECIMENTOS ATIVOS (dossiê de robustez Vanguard):
 *   E-α  trava [CONFIRMAR] → #N/D (coluna Valor_Utilizavel em PARAMETROS)
 *   E-β  proveniência congelada no registro + obsolescência (🔴/🟠/🟢)
 *   E-γ  abas de governança: LEIA-ME, PAINEL_AUDITORIA, HANDOVER_LOG
 *   E-ε  entrevista de saída = ritual escrito no HANDOVER_LOG (não opcional)
 *   (E-δ, motor grava→email→notifica, é da Fase 3 — não pertence ao Gerador.)
 * ═══════════════════════════════════════════════════════════════════════
 */

// Acento da casa (uso discreto no cabeçalho — sóbrio, não enfeite)
var COR_CABECALHO = '#12151A';   // grafite
var COR_TEXTO_CAB = '#EAEEF4';   // texto claro
var COR_ACENTO    = '#00E0F0';   // ciano Vanguard (só a borda inferior)

function construirBase() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();

  criarLeiaMe(ss);
  criarNormas(ss);
  criarCasos(ss);
  criarParametros(ss);
  criarRegistros(ss);      // depois de NORMAS e CASOS (dropdowns dependem deles)
  criarPainelAuditoria(ss);
  criarHandoverLog(ss);

  removerAbaPadraoVazia(ss);

  // Ordem visual das abas
  ordenar(ss, ['LEIA-ME', 'REGISTROS', 'PAINEL_AUDITORIA', 'NORMAS', 'CASOS',
               'PARAMETROS_ANO_CORRENTE', 'Livro de Passagem de Função']);

  // NÃO-BLOQUEANTE: toast em vez de getUi().alert(). O alert é um modal síncrono; se não for
  // fechado em segundos, trava a execução até o limite de 360s (timeout observado 2026-07-11).
  // O toast informa sem bloquear — a base já está criada acima, a execução encerra limpa.
  ss.toast(
    'As 7 abas foram criadas. E-α: valores em PARAMETROS estão [CONFIRMAR] — Valor_Utilizavel ' +
    'só libera quando o Status vira CONFIRMADO (até lá #N/D). Sementes NORMAS/CASOS do acervo ' +
    '(índice.docx, 133 docs). Anexo_Referencia = Nr Ordem (01–133).',
    'BASE construída ✔',
    30
  );
  Logger.log('construirBase: 7 abas criadas com sucesso.');
}

/* ─────────────────────────── ABA LEIA-ME (E-γ) ─────────────────────────── */
function criarLeiaMe(ss) {
  var aba = obterOuCriar(ss, 'LEIA-ME');
  aba.clear();

  var linhas = [
    ['BASE DE CONSULTAS — ASSE CT ORÇ / DCEM', ''],
    ['', ''],
    ['O que é', 'A memória viva da seção: cada consulta interna vira conhecimento pesquisável, ancorado na norma que a fundamentou. O produto é a MEMÓRIA, não o formulário.'],
    ['O ativo', 'Não é só a norma citada — é o MACETE TÁCITO (como o militar experiente resolve rápido) e a ARMADILHA. Isso é o que se perde na movimentação; é o que esta base retém.'],
    ['Perímetro soberano', 'Tudo mora na conta orcamentariodcem@gmail.com. O dado não sai (Trilho 1). O campo MACETE_TÁCITO é OPSEC — restrito à Asse Ct Orç, nunca visível às 12 seções demandantes.'],
    ['GATE DE FATO', 'Valor legal/financeiro vem da NORMA, nunca de memória. Em PARAMETROS, nada é usável enquanto o Status não for CONFIRMADO (coluna Valor_Utilizavel retorna #N/D).'],
    ['HIERARQUIA DAS NORMAS', 'A resposta segue a hierarquia: Constituição/Súmula Vinculante > Lei Complementar > Lei/MP com força de lei > Decreto > Portaria > Norma Técnica. Quando um Caso-Tipo tem várias normas, ordene pela coluna Hierarquia_Nivel (menor número manda) — a inferior NUNCA contraria a superior.'],
    ['Chave do acervo', 'Cada Norma/Registro aponta para o documento pela coluna Anexo_Referencia = "Nr Ordem" (01–133) do índice.docx do Cel Santos. Imune a mojibake de nome de arquivo.'],
    ['', ''],
    ['AS 7 ABAS', ''],
    ['REGISTROS', 'O coração. Cada consulta atendida = uma linha. Norma_Chave_Primaria (PK) + MACETE_TÁCITO + Armadilha/Macete + autoria e satisfação.'],
    ['PAINEL_AUDITORIA', 'Saúde da base num relance: volume, macetes capturados, satisfação, registros obsoletos, parâmetros confirmados.'],
    ['NORMAS', 'As normas subjacentes (Norma Viva = PK). 24 sementes (18 do acervo + 6 mães do inventário 04; cadeia sobe até Constituição/MP, nível 1-3). Ementa a completar pelo curador.'],
    ['CASOS', 'O vocabulário controlado (Caso-Tipo) — a porta de busca. 18 Casos-Tipo do acervo (17 macro-temas; C12 dividido em 12a/12b; +C15 saúde, +C16 permanência, +C17 reserva de capelão).'],
    ['PARAMETROS_ANO_CORRENTE', 'A camada quente (valores que mudam por ano). Trava E-α: [CONFIRMAR] → #N/D.'],
    ['Livro de Passagem de Função', 'O ritual de movimentação (E-ε). Toda passagem de função é registrada e auditável. (nome técnico interno: HANDOVER_LOG)'],
    ['', ''],
    ['RITUAL DE SAÍDA (E-ε) — NÃO É OPCIONAL', 'Quando um curador é movimentado, ANTES de sair ele: (1) revisa seus registros abertos; (2) confirma o MACETE de cada Caso-Tipo que dominava; (3) registra o repasse no Livro de Passagem de Função. A movimentação dispara o ritual — a memória não vai embora com a pessoa.'],
    ['', ''],
    ['Gerado por', 'Músculo (Pentalateral IAH) · Fase 1 · sementes do acervo real + matriz de cruzamento fechada · ' + '2026-07-12']
  ];
  aba.getRange(1, 1, linhas.length, 2).setValues(linhas);

  aba.getRange(1, 1, 1, 2).merge()
     .setBackground(COR_CABECALHO).setFontColor(COR_TEXTO_CAB)
     .setFontWeight('bold').setFontSize(14).setHorizontalAlignment('center');
  aba.setRowHeight(1, 40);
  // rótulos em negrito
  var rotulos = [3,4,5,6,7,8,11,12,13,14,15,16,18,20];
  for (var i = 0; i < rotulos.length; i++) {
    aba.getRange(rotulos[i], 1).setFontWeight('bold').setFontColor('#0A3A40');
  }
  aba.getRange(7, 1).setFontColor('#8A5A00');           // HIERARQUIA — destaque âmbar
  aba.getRange(10, 1, 1, 2).setBackground('#E6FAFC').setFontWeight('bold'); // AS 7 ABAS
  aba.getRange(18, 1).setFontColor('#8A1C1C');          // RITUAL DE SAÍDA
  aba.setColumnWidth(1, 230);
  aba.setColumnWidth(2, 640);
  aba.getRange(1, 2, linhas.length, 1).setWrap(true);
  aba.setHiddenGridlines(true);
}

/* ─────────────────────────── ABA NORMAS ─────────────────────────── */
function criarNormas(ss) {
  var aba = obterOuCriar(ss, 'NORMAS');
  aba.clear();
  // Sheet.clear() NÃO remove validação de dados: a regra antiga da coluna H (teto no Decreto)
  // rejeitaria o novo valor MP em H16. clearDataValidations é de Range — aplico no range inteiro.
  // Limpar aqui deixa o setValues escrever; aplicarLista reaplica a validação nova (9 valores).
  aba.getRange(1, 1, aba.getMaxRows(), aba.getMaxColumns()).clearDataValidations();

  // Colunas B..G preservadas (a fórmula de obsolescência em REGISTROS lê NORMAS!B:G).
  // Tipo_Norma + Hierarquia_Nivel entram no FIM — não deslocam os índices existentes.
  var cabecalho = ['Cod_Norma', 'Titulo_Norma', 'Ementa_Curta',
                   'Anexo_Referencia', 'Versao_Vigente', 'Hash_Parametros', 'Status',
                   'Tipo_Norma', 'Hierarquia_Nivel'];
  aba.getRange(1, 1, 1, cabecalho.length).setValues([cabecalho]);

  // 24 NORMAS-SEMENTE — 18 originais + 6 mães do inventário 04 (veredito Diretor 2026-07-12).
  // Existência CONFIRMADA pelo acervo (índice.docx) + inventário 04 + matriz de cruzamento.
  // Anexo_Referencia = Nr Ordem (01–133) que cita a norma. Ementa a completar pelo curador.
  // Versao_Vigente = [CONFIRMAR] (GATE DE FATO — o curador valida contra a norma vigente).
  // Hierarquia_Nivel (Diretor 2026-07-11): 1=Constituição · 2=Lei Complementar · 3=Lei/MP ·
  //   4=Decreto · 5=Portaria · 6=Norma Técnica interna. Ordena a resposta: a inferior nunca contraria a superior.
  var dados = [
    ['DEC-4307-2002',      'Decreto 4.307/2002 — Indenização de movimentação (ajuda de custo, transporte); tabelas de valores', '', '32; 108', '[CONFIRMAR]', '', 'Vigente', 'Decreto', 4],
    ['PORT-DGP-290-2013',  'Portaria DGP 290/2013 — Indenização de bagagem/pessoal (Art. 45 = bagagem na mesma sede)',            '', '32; 102', '[CONFIRMAR]', '', 'Vigente', 'Portaria', 5],
    ['PORT-CEX-1169-2014', 'Portaria Cmt Ex 1.169, de 26/09/2014 — Concessão de Diárias e Passagens',                            '', '27',      '[CONFIRMAR]', '', 'Vigente', 'Portaria', 5],
    ['NT-DCEM-1-2-3',      'Norma Técnica DCEM 1, 2 e 3 — IP · Movimentação motivo saúde · Recurso a ato de movimentação',        '', '35',      '[CONFIRMAR]', '', 'Vigente', 'Norma Técnica', 6],
    ['PORT-881',           'Portaria 881 — Guarnições categoria "A"',                                                           '', '36',      '[CONFIRMAR]', '', 'Vigente', 'Portaria', 5],
    ['PORT-CEX-1225-2010', 'Portaria Cmt Ex 1.225/2010 — Reconhecimento de Guarnições Cat "A"',                                 '', '52',      '[CONFIRMAR]', '', 'Vigente', 'Portaria', 5],
    ['PN-MD-86-2020',      'Portaria Normativa 86/MD, de 22/09/2020 — Cursos que dão direito a adicional de habilitação',        '', '75',      '[CONFIRMAR]', '', 'Vigente', 'Portaria', 5],
    ['DEC-11020-2022',     'Decreto 11.020/2022 — Gratificação de Localidade Especial',                                         '', '94',      '[CONFIRMAR]', '', 'Vigente', 'Decreto', 4],
    ['LEI-8112',           'Lei 8.112 — Ajuda de custo / impossibilidade de renúncia [ano a confirmar]',                        '', '115',     '[CONFIRMAR]', '', 'Vigente', 'Lei', 3],
    ['LC-173-2020',        'LC 173/2020 (Art. 8º, IX) — reflexo sobre adicional de permanência',                               '', '73',      '[CONFIRMAR]', '', 'Vigente', 'Lei Complementar', 2],
    ['LEI-9784-1999',      'Lei 9.784/1999 (Art. 54) — decadência quinquenal do ato (não corre com má-fé)',                    '', '118; 127','[CONFIRMAR]', '', 'Vigente', 'Lei', 3],
    ['DEC-20910-1932',     'Decreto 20.910/1932 — prescrição quinquenal contra a Fazenda (actio nata) [força de lei]',         '', '123',     '[CONFIRMAR]', '', 'Vigente', 'Decreto (força de lei)', 3],
    ['LEI-6880-1980',      'Estatuto dos Militares (Lei 6.880/1980) — conceito de "remuneração" [nº a confirmar]',              '', '38',      '[CONFIRMAR]', '', 'Vigente', 'Lei', 3],
    ['LEI-6923-1981',      'Lei 6.923, de 29/06/1981 — reserva remunerada de capelão (tempo especial, 30 anos)',                '', '133',     '[CONFIRMAR]', '', 'Vigente', 'Lei', 3],
    // ── Correção estrutural (matriz de cruzamento fechada 2026-07-12): as âncoras do acervo
    //    sobem até a MP 2.215-10 (nível 3), NÃO param no Dec 4.307 (nível 4). O dropdown antigo
    //    (14 normas, teto nível 4) impedia o operador de citar o teto real. Estas 4 fecham a cadeia.
    ['MP-2215-10-2001',    'MP 2.215-10, de 31/08/2001 — Remuneração dos militares das FA; institui adicionais/indenizações. Teto normativo do acervo (acima do Dec 4.307).', '', '35; 73; 74; 78; 83; 117', '[CONFIRMAR]', '', 'Vigente', 'Medida Provisória (força de lei)', 3],
    ['LEI-13954-2019',     'Lei 13.954, de 16/12/2019 — Sistema de Proteção Social dos militares; tempo p/ reserva e ressarcimento de cursos (art. 97 §2º).', '', '73; 74; 78; 83; 117', '[CONFIRMAR]', '', 'Vigente', 'Lei', 3],
    ['PORT-GM-MD-4044-2021','Portaria GM-MD 4.044/2021 — Ressarcimento de despesas com formação/cursos (art. 2º III). Base do Nr 117.', '', '117', '[CONFIRMAR]', '', 'Vigente', 'Portaria', 5],
    ['PORT-066-DGP-2011',  'Portaria 066-DGP/2011 — Aprova as Normas Técnicas DCEM (NT-DCEM 01 IP · 02 Saúde · 03 Reconsideração). Base do Nr 35.', '', '35', '[CONFIRMAR]', '', 'Vigente', 'Portaria', 5],
    // ── Legislação-mãe do inventário do Drive (04_INVENTARIO_DRIVE_LEGISLACAO), NÃO citada por DIEx do índice.
    //    Raiz dos buracos: a base amarrou parecer↔caso (título de DIEx) mas nunca norma-mãe↔caso — a mãe mora no
    //    inventário de legislação, não no índice de 133 DIEx. Adicionadas 2026-07-12 por veredito do Diretor.
    //    Lei 4.320/1964 DISPENSADA pelo Diretor. Anexo_Referencia vazio: fonte é o inventário, não o índice.
    ['CF-88',              'Constituição Federal de 1988 (Art. 37 §5º — ressarcimento ao erário). [CONFIRMAR-CEL: alcance da imprescritibilidade — STF RE 669.069 restringe a improbidade dolosa; C08 pode reger-se por prescrição, não imprescritibilidade]', '', '', '[CONFIRMAR]', '', 'Vigente', 'Constituição', 1],
    ['LC-73-1993',        'Lei Complementar 73/1993 — Lei Orgânica da AGU; base da uniformização de teses jurídicas (CONJUR). [CONFIRMAR-CEL]', '', '', '[CONFIRMAR]', '', 'Vigente', 'Lei Complementar', 2],
    ['LEI-10406-2002',    'Código Civil (Lei 10.406/2002) — fundamento de restituição (enriquecimento sem causa) e de correção monetária/juros.', '', '', '[CONFIRMAR]', '', 'Vigente', 'Lei', 3],
    ['DEC-2040-1996',     'Decreto 2.040/1996 — regulamenta a movimentação de militares (mãe da matéria de movimentação, inclusive por motivo de saúde). [CONFIRMAR-CEL: vigência]', '', '', '[CONFIRMAR]', '', 'Vigente', 'Decreto', 4],
    ['PORT-DGP-410-2022', 'Portaria DGP 410/2022 — Despesas de Exercícios Anteriores (DEA). [CONFIRMAR-CEL: DEA = "Processo de exercícios anteriores" do Caso-13 ou matéria adjacente]', '', '', '[CONFIRMAR]', '', 'Vigente', 'Portaria', 5],
    ['PORT-CEX-1746-2022','Portaria Cmt Ex 1.746/2022 — Despesas de Exercícios Anteriores (DEA); complementa a Port DGP 410/2022. [CONFIRMAR-CEL]', '', '', '[CONFIRMAR]', '', 'Vigente', 'Portaria', 5]
  ];
  aba.getRange(2, 1, dados.length, cabecalho.length).setValues(dados);

  // Status = validação (Vigente / Revogada) — alimenta a obsolescência E-β
  aplicarLista(aba, 7, 2 + dados.length, ['Vigente', 'Revogada']);
  // Tipo_Norma = validação (mantém o vocabulário da hierarquia limpo).
  // Nível 1 (Constituição / Súmula Vinculante) e MP força de lei (nível 3) entram na correção
  // estrutural de 2026-07-12 — o vocabulário antigo travava no Decreto e não deixava citar o teto.
  aplicarLista(aba, 8, 2 + dados.length,
    ['Constituição', 'Súmula Vinculante', 'Lei Complementar', 'Medida Provisória (força de lei)',
     'Lei', 'Decreto (força de lei)', 'Decreto', 'Portaria', 'Norma Técnica']);

  aba.getRange(1, 4).setNote('Nr Ordem (01–133) do índice.docx que cita esta norma. Chave do acervo — imune a mojibake de nome de arquivo.');
  aba.getRange(1, 5).setNote('Versão/edição vigente da norma. GATE DE FATO: [CONFIRMAR] até o curador validar. Alimenta a obsolescência (E-β).');
  aba.getRange(1, 8).setNote('Espécie normativa — define a posição na hierarquia (Diretor 2026-07-11).');
  aba.getRange(1, 9).setNote('Nível hierárquico: 1=Constituição/Súmula Vinculante · 2=Lei Complementar · 3=Lei/MP com força de lei · 4=Decreto · 5=Portaria · 6=Norma Técnica. Menor número = manda. Ao responder, ordene as normas por este nível — a inferior nunca contraria a superior.');

  estilizarCabecalho(aba, cabecalho.length);
  aba.setColumnWidth(1, 170);
  aba.setColumnWidth(2, 460);
  aba.setColumnWidth(3, 260);
  aba.setColumnWidth(4, 110);
  aba.setColumnWidth(8, 170);   // Tipo_Norma
  aba.setColumnWidth(9, 120);   // Hierarquia_Nivel
  aba.setFrozenRows(1);
}

/* ─────────────────────────── ABA CASOS ─────────────────────────── */
function criarCasos(ss) {
  var aba = obterOuCriar(ss, 'CASOS');
  aba.clear();

  var cabecalho = ['Cod_Caso', 'Tema', 'Normas_Relacionadas', 'Docs_Acervo_NrOrdem'];
  aba.getRange(1, 1, 1, cabecalho.length).setValues([cabecalho]);

  // 18 CASOS-SEMENTE — consolidam os 133 assuntos do acervo em macro-temas (C12→12a/12b; +C15; +C16; +C17).
  // REAMARRAÇÃO 2026-07-12 (veredito Diretor): Normas_Relacionadas reordenada por hierarquia (mãe→filha)
  //   para acabar com a inversão (Portaria regulando Decreto/Lei). Fonte: 17_PROPOSTA_REAMARRACAO_CASOS.md
  //   cruzando as duas auditorias cegas (15_MÚSCULO × 16_ANTIGRAVITY). Lei 4.320/1964 dispensada pelo Diretor.
  //   Itens que exigem leitura jurídica do Cel = [CONFIRMAR-CEL] na ementa da norma correspondente (aba NORMAS).
  var dados = [
    ['CASO-01', 'Ajuda de custo — desligamento / prolongamento / cancelamento de curso',                'MP-2215-10-2001; LEI-13954-2019; LEI-8112; DEC-4307-2002', '01-06; 19; 28; 74'],
    ['CASO-02', 'Ajuda de custo — militares cônjuges (mesma sede / sedes distintas / conclusão de curso)','MP-2215-10-2001; LEI-8112; DEC-4307-2002', '11; 39; 47; 71; 77; 79; 83; 119'],
    ['CASO-03', 'Ajuda de custo majorada — dependentes / ajuste de contas',                              'MP-2215-10-2001; LEI-8112; DEC-4307-2002', '08; 50; 54; 55; 66; 68; 92; 101'],
    ['CASO-04', 'Indenização sem mudança de sede / militar já reside no local',                          'MP-2215-10-2001; DEC-4307-2002', '46; 48; 99; 100'],
    ['CASO-05', 'Transporte de bagagem — modalidade e alteração após ajuste de contas / mesma sede',     'MP-2215-10-2001; DEC-4307-2002; PORT-DGP-290-2013', '18; 26; 67; 86; 102; 107; 108; 110; 116; 126'],
    ['CASO-06', 'Transporte de pessoal / passagens (automóvel, recém-nascido, milhas)',                  'MP-2215-10-2001; DEC-4307-2002', '17; 31; 53; 72; 88; 96; 104'],
    ['CASO-07', 'Diárias e passagens',                                                                   'MP-2215-10-2001; PORT-CEX-1169-2014', '15; 25; 27; 81; 95'],
    ['CASO-08', 'Restituição / ressarcimento ao erário — descumprimento de termo / revogação de mov.',   'CF-88; LEI-10406-2002; LEI-9784-1999; DEC-4307-2002', '30; 64; 65; 76; 84; 85; 105; 109; 111; 112; 113; 124; 130; 131'],
    ['CASO-09', 'Correção monetária e juros — restituição e pagamento em atraso',                        'LEI-10406-2002; DEC-4307-2002', '37; 40; 70; 120; 125'],
    ['CASO-10', 'Prescrição e decadência (quinquenal; Art. 54 Lei 9.784; má-fé)',                        'LEI-9784-1999; DEC-20910-1932', '106; 118; 123; 127'],
    ['CASO-11', 'Adicional de habilitação',                                                              'MP-2215-10-2001; PN-MD-86-2020', '23; 57; 58; 59; 60; 75; 78'],
    ['CASO-12a','Gratificação de representação',                                                         'MP-2215-10-2001; DEC-4307-2002', '24; 34; 49; 61; 132'],
    ['CASO-12b','Gratificação de localidade especial / guarnição categoria "A"',                         'MP-2215-10-2001; DEC-11020-2022; PORT-881; PORT-CEX-1225-2010', '14; 56; 62; 94; 36; 52'],
    ['CASO-13', 'Processo de exercícios anteriores',                                                     'PORT-DGP-410-2022; PORT-CEX-1746-2022', '41; 42; 43; 44'],
    ['CASO-14', 'Uniformização de teses (CONJUR-MD / CONJUR-EB)',                                        'LC-73-1993',                    '110; 118; 121; 122'],
    ['CASO-15', 'Movimentação por motivo de saúde / reconsideração de ato de movimentação',             'LEI-6880-1980; DEC-2040-1996; PORT-066-DGP-2011; NT-DCEM-1-2-3', '35'],
    ['CASO-16', 'Adicional de permanência / reflexos (LC 173/2020 art. 8º IX)',                          'LC-173-2020; MP-2215-10-2001',  '73'],
    ['CASO-17', 'Reserva remunerada — capelão militar (tempo especial, 30 anos, Lei 6.923/1981)',        'LEI-6923-1981',                 '133']
  ];
  aba.getRange(2, 1, dados.length, cabecalho.length).setValues(dados);

  aba.getRange(1, 4).setNote('Nr Ordem (01–133) dos documentos do acervo que tratam deste Caso-Tipo.');

  estilizarCabecalho(aba, cabecalho.length);
  aba.setColumnWidth(1, 90);
  aba.setColumnWidth(2, 470);
  aba.setColumnWidth(3, 230);
  aba.setColumnWidth(4, 320);
  aba.setFrozenRows(1);
}

/* ──────────────────── ABA PARAMETROS_ANO_CORRENTE (E-α) ──────────────────── */
function criarParametros(ss) {
  var aba = obterOuCriar(ss, 'PARAMETROS_ANO_CORRENTE');
  aba.clear();

  var cabecalho = ['Parametro', 'Valor', 'Norma_Fonte', 'Vigencia',
                   'Status_Confirmacao', 'Valor_Utilizavel'];
  aba.getRange(1, 1, 1, cabecalho.length).setValues([cabecalho]);

  // GATE DE FATO: valores provisórios — TODOS [CONFIRMAR]. Só o Dec 4.307 é semeado
  // (é a norma de valores presente no acervo). O curador adiciona os demais ao confirmar.
  var dados = [
    ['Indice_Rodoviario', '',  'DEC-4307-2002', '2026', '[CONFIRMAR CONTRA NORMA VIGENTE]'],
    ['Indice_Aereo',      '',  'DEC-4307-2002', '2026', '[CONFIRMAR CONTRA NORMA VIGENTE]'],
    ['Tarifa_m3',         '',  'DEC-4307-2002', '2026', '[CONFIRMAR CONTRA NORMA VIGENTE]']
  ];
  aba.getRange(2, 1, dados.length, 5).setValues(dados);

  // E-α — TRAVA: Valor_Utilizavel só devolve o número quando Status = CONFIRMADO; senão #N/D.
  // LOCALE (GATE DE FATO): planilha pt-BR exige separador ';' no setFormula (nomes em inglês OK).
  // Provado pelo PAINEL_AUDITORIA, que já usa inglês+';' e funciona. Vírgula → #ERROR!.
  aba.getRange(2, 6).setFormula(
    '=ARRAYFORMULA(IF($A2:$A="";"";IF(EXACT($E2:$E;"CONFIRMADO");$B2:$B;NA())))'
  );

  // Status_Confirmacao vira dropdown (o curador alterna quando valida)
  aplicarLista(aba, 5, 2 + dados.length,
    ['[CONFIRMAR CONTRA NORMA VIGENTE]', 'CONFIRMADO']);

  // Destaca a coluna de status — lembrete visual de que nada está confirmado
  aba.getRange(2, 5, dados.length, 1).setBackground('#3A3417').setFontColor('#E8C84A');
  aba.getRange(1, 6).setNote('E-α (trava GATE DE FATO): retorna #N/D enquanto o Status não for CONFIRMADO. Nenhum parecer usa valor não confirmado.');

  estilizarCabecalho(aba, cabecalho.length);
  aba.setColumnWidth(1, 170);
  aba.setColumnWidth(3, 180);
  aba.setColumnWidth(5, 280);
  aba.setColumnWidth(6, 150);
  aba.setFrozenRows(1);
}

/* ─────────────────────────── ABA REGISTROS (E-β) ─────────────────────────── */
function criarRegistros(ss) {
  var aba = obterOuCriar(ss, 'REGISTROS');
  aba.clear();

  var cabecalho = [
    'ID_Consulta', 'Data_Hora', 'Demandante_Email', 'Secao_Demandante',       // A B C D
    'Caso_Tipo_Tema', 'Norma_Chave_Primaria', 'Fato_Gerador', 'Tipo_Registro',// E F G H
    'MACETE_TACITO', 'Parecer_Oficial_Email', 'Autoria_Posto_Nome',           // I J K
    'Autoria_Visivel', 'Dono_da_Norma_Funcao', 'Satisfacao',                  // L M N
    'Anexo_Referencia', 'Versao_Registrada', 'Status_Obsolescencia'           // O P Q  (E-β)
  ];
  aba.getRange(1, 1, 1, cabecalho.length).setValues([cabecalho]);

  // Contagem DINÂMICA (correção 2026-07-12): o dropdown antigo travava em 14 normas (B2:B15) e
  // amputava a chave — impedia citar MP 2.215-10 e as normas novas. Lê o tamanho real das abas
  // (já criadas por criarNormas/criarCasos antes desta função). Cresce sozinho quando a base cresce.
  var nNormas = ss.getSheetByName('NORMAS').getLastRow() - 1;
  var nCasos  = ss.getSheetByName('CASOS').getLastRow() - 1;
  var ultimaLinha = 1000; // faixa de validação

  // D — Secao_Demandante: as 13 seções (lista fixa)
  var secoes = ['QEMA', 'QSG', 'Cursos e Estágios', 'Praças', 'Ajudância Geral',
                'Seção de Seleção', 'SPEC', 'Assessoria Jurídica', 'AI',
                'Diretor', 'Subdiretor', 'Adjunto de Comando', 'Assistente'];
  aplicarLista(aba, 4, ultimaLinha, secoes);

  // E — Caso_Tipo_Tema: intervalo CASOS!B2:B(1+nCasos) (Tema)
  var faixaCasos = ss.getSheetByName('CASOS').getRange(2, 2, nCasos, 1);
  aplicarIntervalo(aba, 5, ultimaLinha, faixaCasos);

  // F — Norma_Chave_Primaria: intervalo NORMAS!A2:A(1+nNormas) (Cod_Norma) — a PK real do acervo.
  // Veredito Diretor 2026-07-12: a chave operacional é o CÓDIGO (estável), não o Título (muda quando
  // o curador confirma ano/nº — ver LEI-8112/LEI-6880 "[a confirmar]"). CASOS.Normas_Relacionadas e o
  // painel FASE2 já operam por código. A fórmula Q (obsolescência) foi reacoplada a NORMAS!$A:$G.
  var faixaNormas = ss.getSheetByName('NORMAS').getRange(2, 1, nNormas, 1);
  aplicarIntervalo(aba, 6, ultimaLinha, faixaNormas);

  // H — Tipo_Registro (E-3 do Embaixador): separa armadilha de macete
  aplicarLista(aba, 8, ultimaLinha, ['Armadilha', 'Macete Cinzento']);

  // I — MACETE_TACITO [OPSEC]: texto livre, limitado a ~150 caracteres
  var regraMacete = SpreadsheetApp.newDataValidation()
    .requireFormulaSatisfied('=LEN(I2)<=150')
    .setAllowInvalid(false)
    .setHelpText('Macete em uma frase — máx. 150 caracteres. Campo restrito à Asse Ct Orç (OPSEC).')
    .build();
  aba.getRange(2, 9, ultimaLinha - 1, 1).setDataValidation(regraMacete);

  // L — Autoria_Visivel (E-1, condicional / V-A): o autor decide
  aplicarLista(aba, 12, ultimaLinha, ['Sim', 'Não']);

  // N — Satisfacao (V-D): 1 toque
  aplicarLista(aba, 14, ultimaLinha, ['👍', '👎']);

  // O — Anexo_Referencia: Nr Ordem (01–133) do acervo (E-β: liga o registro ao documento)
  // P — Versao_Registrada: congela a versão da norma no momento do registro (E-β)

  // Q — Status_Obsolescencia (E-β): compara a versão congelada com a versão vigente da NORMA.
  // ACOPLAMENTO com F=código (2026-07-12): F agora guarda Cod_Norma (NORMAS!A). O VLOOKUP procura a
  // chave em NORMAS!$A:$G (antes $B:$G, quando F era Título). Índices reajustados: Status = col 7 de
  // A:G (era 6 de B:G) · Versao_Vigente = col 5 de A:G (era 4 de B:G). Sem este reajuste, F=código
  // cairia sempre em "NORMA NAO ENCONTRADA" e o E-β morreria silenciosamente.
  // LOCALE (GATE DE FATO): planilha pt-BR exige separador ';'. Vírgula → #ERROR!. '&""' no lugar de
  // TO_TEXT (locale-safe). Forma validada ao vivo em Q2 (2026-07-11).
  aba.getRange(2, 17).setFormula(
    '=ARRAYFORMULA(IF($F2:$F="";"";' +
      'IFERROR(' +
        'IF(VLOOKUP($F2:$F;NORMAS!$A:$G;7;0)="Revogada";"🔴 REVOGADA";' +
          'IF((VLOOKUP($F2:$F;NORMAS!$A:$G;5;0)&"")<>($P2:$P&"");"🟠 VERSAO MUDOU";"🟢 EM DIA"));' +
        '"⚠ NORMA NAO ENCONTRADA")))'
  );

  // Notas de ancoragem
  aba.getRange(1, 6).setNote('Norma Viva = chave primária (PK). Todo registro se ancora numa norma.');
  aba.getRange(1, 9).setNote('OPSEC — restrito aos curadores da Asse Ct Orç. Nunca exposto às 12 seções.');
  aba.getRange(1, 15).setNote('Nr Ordem (01–133) do documento no acervo. Liga o registro à prova.');
  aba.getRange(1, 16).setNote('E-β: versão da norma no momento do registro. Congelada — não muda quando a norma é atualizada.');
  aba.getRange(1, 17).setNote('E-β obsolescência: 🔴 norma revogada · 🟠 versão da norma mudou desde o registro · 🟢 em dia. (🟡 parâmetro: Fase 3.)');

  estilizarCabecalho(aba, cabecalho.length);
  aba.setColumnWidth(1, 130);
  aba.setColumnWidth(9, 300);
  aba.setColumnWidth(10, 300);
  aba.setColumnWidth(15, 120);
  aba.setColumnWidth(16, 130);
  aba.setColumnWidth(17, 170);
  aba.setFrozenRows(1);
  aba.setFrozenColumns(1);
}

/* ─────────────────── ABA PAINEL_AUDITORIA (E-γ) ─────────────────── */
function criarPainelAuditoria(ss) {
  var aba = obterOuCriar(ss, 'PAINEL_AUDITORIA');
  aba.clear();

  aba.getRange(1, 1, 1, 2).merge()
     .setValue('PAINEL DE AUDITORIA — SAÚDE DA BASE')
     .setBackground(COR_CABECALHO).setFontColor(COR_TEXTO_CAB)
     .setFontWeight('bold').setFontSize(13).setHorizontalAlignment('center');
  aba.setRowHeight(1, 36);

  var linhas = [
    ['Indicador', 'Valor'],
    ['Consultas registradas',              '=COUNTA(REGISTROS!A2:A)'],
    ['Registros com MACETE preenchido',    '=COUNTA(REGISTROS!I2:I)'],
    ['— dos quais Macete Cinzento',        '=COUNTIF(REGISTROS!H2:H;"Macete Cinzento")'],
    ['— dos quais Armadilha',              '=COUNTIF(REGISTROS!H2:H;"Armadilha")'],
    ['Satisfação (👍 / total)',            '=IFERROR(COUNTIF(REGISTROS!N2:N;"👍")&" / "&(COUNTIF(REGISTROS!N2:N;"👍")+COUNTIF(REGISTROS!N2:N;"👎"));"—")'],
    ['Registros OBSOLETOS (🔴 + 🟠)',       '=COUNTIF(REGISTROS!Q2:Q;"🔴*")+COUNTIF(REGISTROS!Q2:Q;"🟠*")'],
    ['Autoria visível (Sim)',              '=COUNTIF(REGISTROS!L2:L;"Sim")'],
    ['', ''],
    ['Normas cadastradas',                 '=COUNTA(NORMAS!A2:A)'],
    ['Normas REVOGADAS',                   '=COUNTIF(NORMAS!G2:G;"Revogada")'],
    ['Casos-Tipo cadastrados',             '=COUNTA(CASOS!A2:A)'],
    ['Parâmetros CONFIRMADOS / total',     '=COUNTIF(PARAMETROS_ANO_CORRENTE!E2:E;"CONFIRMADO")&" / "&COUNTA(PARAMETROS_ANO_CORRENTE!A2:A)']
  ];
  aba.getRange(2, 1, linhas.length, 2).setValues(linhas);
  aba.getRange(2, 1, 1, 2).setFontWeight('bold').setBackground('#E6FAFC');

  // Bloco: volume por Caso-Tipo
  var baseVol = 2 + linhas.length + 1;
  aba.getRange(baseVol, 1, 1, 2).setValues([['Volume por Caso-Tipo', 'Registros']])
     .setFontWeight('bold').setBackground('#E6FAFC');
  // Faixa aberta (B2:B) — cobre qualquer nº de Caso-Tipo. Antes travava em B2:B15 (14) e subcontava.
  aba.getRange(baseVol + 1, 1).setFormula('=ARRAYFORMULA(IF(CASOS!B2:B="";"";CASOS!B2:B))');
  aba.getRange(baseVol + 1, 2).setFormula(
    '=ARRAYFORMULA(IF(CASOS!B2:B="";"";COUNTIF(REGISTROS!E2:E;CASOS!B2:B)))'
  );

  aba.getRange(baseVol, 1).setNote('Onde a demanda se concentra — sinaliza qual Caso-Tipo mais precisa de macete documentado.');
  aba.getRange(8, 1).setNote('E-β: obsoletos = norma revogada (🔴) ou versão mudou (🟠). Priorize revisar estes registros.');

  estilizarCabecalho(aba, 2);
  aba.setColumnWidth(1, 320);
  aba.setColumnWidth(2, 220);
  aba.setFrozenRows(1);
  aba.setHiddenGridlines(true);
}

/* ─────────────────── ABA HANDOVER_LOG (E-γ / E-ε) ─────────────────── */
function criarHandoverLog(ss) {
  var aba = obterOuCriar(ss, 'Livro de Passagem de Função');
  aba.clear();

  aba.getRange(1, 1, 1, 9).merge()
     .setValue('LIVRO DE PASSAGEM DE FUNÇÃO — RITUAL DE MOVIMENTAÇÃO (E-ε · não é opcional)')
     .setBackground(COR_CABECALHO).setFontColor(COR_TEXTO_CAB)
     .setFontWeight('bold').setFontSize(12).setHorizontalAlignment('center');
  aba.setRowHeight(1, 34);

  var cabecalho = ['Data', 'Evento', 'Responsavel_Anterior', 'Responsavel_Novo',
                   'Senha_Trocada', 'Recuperacao_Atualizada', 'Codigos_2FA_Regerados',
                   'DIEx_Registro', 'Observacoes / Macetes revisados na saída'];
  aba.getRange(2, 1, 1, cabecalho.length).setValues([cabecalho]);

  aplicarLista(aba, 2, 500, ['Assunção de função', 'Movimentação (saída)']);   // B
  aplicarLista(aba, 5, 500, ['Sim', 'Não']);   // E
  aplicarLista(aba, 6, 500, ['Sim', 'Não']);   // F
  aplicarLista(aba, 7, 500, ['Sim', 'Não']);   // G

  aba.getRange(2, 1, 1, cabecalho.length)
     .setBackground(COR_CABECALHO).setFontColor(COR_TEXTO_CAB).setFontWeight('bold');
  aba.getRange(2, 9).setNote('E-ε: na saída, o curador revisa e confirma o MACETE de cada Caso-Tipo que dominava. A memória não vai embora com a pessoa.');

  aba.setColumnWidth(1, 100);
  aba.setColumnWidth(2, 150);
  aba.setColumnWidth(3, 170);
  aba.setColumnWidth(4, 170);
  aba.setColumnWidth(9, 380);
  aba.setFrozenRows(2);
  aba.setHiddenGridlines(true);
}

/* ─────────────────────────── AUXILIARES ─────────────────────────── */

function obterOuCriar(ss, nome) {
  var aba = ss.getSheetByName(nome);
  if (!aba) { aba = ss.insertSheet(nome); }
  return aba;
}

function aplicarLista(aba, coluna, ultimaLinha, itens) {
  var regra = SpreadsheetApp.newDataValidation()
    .requireValueInList(itens, true)
    .setAllowInvalid(false)
    .build();
  aba.getRange(2, coluna, ultimaLinha - 1, 1).setDataValidation(regra);
}

function aplicarIntervalo(aba, coluna, ultimaLinha, faixa) {
  var regra = SpreadsheetApp.newDataValidation()
    .requireValueInRange(faixa, true)
    .setAllowInvalid(false)
    .build();
  aba.getRange(2, coluna, ultimaLinha - 1, 1).setDataValidation(regra);
}

function estilizarCabecalho(aba, nCols) {
  var cab = aba.getRange(1, 1, 1, nCols);
  cab.setBackground(COR_CABECALHO)
     .setFontColor(COR_TEXTO_CAB)
     .setFontWeight('bold')
     .setVerticalAlignment('middle');
  aba.setRowHeight(1, 34);
  // faixa ciano fina sob o cabeçalho (assinatura Vanguard, discreta)
  cab.setBorder(null, null, true, null, null, null, COR_ACENTO,
                SpreadsheetApp.BorderStyle.SOLID_THICK);
}

function ordenar(ss, ordem) {
  for (var i = 0; i < ordem.length; i++) {
    var aba = ss.getSheetByName(ordem[i]);
    if (aba) { ss.setActiveSheet(aba); ss.moveActiveSheet(i + 1); }
  }
  var primeira = ss.getSheetByName(ordem[0]);
  if (primeira) { ss.setActiveSheet(primeira); }
}

function removerAbaPadraoVazia(ss) {
  var nomesPadrao = ['Página1', 'Sheet1', 'Planilha1'];
  for (var i = 0; i < nomesPadrao.length; i++) {
    var aba = ss.getSheetByName(nomesPadrao[i]);
    if (aba && ss.getSheets().length > 1) {
      try { ss.deleteSheet(aba); } catch (e) { /* ignora se não puder */ }
    }
  }
}

/* ═══════════════════════════════════════════════════════════════════════════
 *  PATCH NÃO-DESTRUTIVO — Correções da matriz de cruzamento (2026-07-12)
 *  ───────────────────────────────────────────────────────────────────────────
 *  Rota 2 (veredito do Diretor): traz a base VIVA para o padrão corrigido SEM
 *  apagar REGISTROS. construirBase() faria aba.clear() em REGISTROS e perderia
 *  as consultas já lançadas — esta função NÃO toca REGISTROS.
 *
 *  O que faz:
 *   1. Reconstrói NORMAS (semente-referência, sem dado do curador) → 18 normas,
 *      lista Tipo_Norma com Constituição/Súmula/MP, nota de hierarquia corrigida.
 *   2. Reconstrói CASOS (semente-referência) → 18 Casos-Tipo, com C12a/C12b,
 *      C15 (saúde), C16 (permanência), C17 (reserva de capelão) e CASO-01 sem o Nr 24.
 *   3. Re-aponta os dropdowns de REGISTROS (col. E Caso · col. F Norma) para os
 *      intervalos DINÂMICOS — desfaz a amputação que travava a chave em 14 normas.
 *      Só reescreve validações; os VALORES já digitados em REGISTROS permanecem.
 *
 *  Rodar UMA vez, direto pelo editor (▶ aplicarCorrecoes2026_07_12) ou pelo menu.
 * ═══════════════════════════════════════════════════════════════════════════ */
function aplicarCorrecoes2026_07_12() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();

  if (!ss || !ss.getSheetByName('REGISTROS')) {
    Logger.log('ABORTADO: base ainda não existe. Rode construirBase() primeiro.');
    return;
  }

  // Fotografa REGISTROS ANTES (prova de preservação)
  var nR_antes = Math.max(0, ss.getSheetByName('REGISTROS').getLastRow() - 1);

  // GUARD A-2 (2026-07-12): criarNormas() faz aba.clear() e re-semeia NORMAS com [CONFIRMAR].
  // NORMAS NÃO é uma aba-semente inerte — ela ACUMULA trabalho do curador: Ementa_Curta (col C),
  // Versao_Vigente confirmada (col E) e Status=Revogada (col G). Se esse trabalho já existe,
  // reconstruir DESTRÓI silenciosamente. Detectar e abortar antes de tocar em qualquer aba.
  var abaN = ss.getSheetByName('NORMAS');
  if (abaN && abaN.getLastRow() > 1) {
    var nLinN = abaN.getLastRow() - 1;
    var colC = abaN.getRange(2, 3, nLinN, 1).getValues();  // Ementa_Curta
    var colE = abaN.getRange(2, 5, nLinN, 1).getValues();  // Versao_Vigente
    var colG = abaN.getRange(2, 7, nLinN, 1).getValues();  // Status
    var temDadoCurador = false;
    for (var i = 0; i < nLinN; i++) {
      var ement = ('' + colC[i][0]).trim();
      var versa = ('' + colE[i][0]).trim();
      var stat  = ('' + colG[i][0]).trim();
      if (ement !== '') { temDadoCurador = true; break; }
      if (versa !== '' && versa !== '[CONFIRMAR]') { temDadoCurador = true; break; }
      if (stat === 'Revogada') { temDadoCurador = true; break; }
    }
    if (temDadoCurador) {
      var aviso =
        'ABORTADO (guard A-2). A aba NORMAS já contém trabalho do curador (ementa preenchida, ' +
        'versão confirmada ≠ [CONFIRMAR], ou norma marcada Revogada). aplicarCorrecoes reconstrói ' +
        'NORMAS e apagaria esse trabalho. Correção destrutiva bloqueada.\n\n' +
        'Se a intenção for realmente re-semear NORMAS do zero, limpe a aba manualmente antes de rodar.';
      Logger.log(aviso);
      try { SpreadsheetApp.getUi().alert(aviso); } catch (e) { /* rodou pelo editor, sem UI */ }
      return;
    }
  }

  // 1 + 2 — re-semeia NORMAS e CASOS (só chega aqui se o guard A-2 não achou dado do curador)
  criarNormas(ss);
  criarCasos(ss);

  // 3 — re-apontar os dropdowns de REGISTROS sem limpar a aba
  reaplicarDropdownsRegistros(ss);

  var nN = ss.getSheetByName('NORMAS').getLastRow() - 1;
  var nC = ss.getSheetByName('CASOS').getLastRow() - 1;
  var nR_depois = Math.max(0, ss.getSheetByName('REGISTROS').getLastRow() - 1);
  var msg =
    'Correções 2026-07-12 aplicadas.\n' +
    'NORMAS: ' + nN + ' (esperado 24 — 18 originais + 6 mães do inventário 04, reamarração 2026-07-12)\n' +
    'CASOS: ' + nC + ' (esperado 18 — cadeia reordenada por hierarquia; C13/C14 preenchidos)\n' +
    'Dropdown Norma_Chave (REGISTROS!F): dinâmico, por CÓDIGO, todas as ' + nN + ' normas\n' +
    'Obsolescência (REGISTROS!Q): reacoplada a NORMAS!$A:$G (chave = código)\n' +
    'REGISTROS: ' + nR_antes + ' → ' + nR_depois + ' linha(s) — PRESERVADO.';
  Logger.log(msg);                                   // sempre visível no Registro de execução
  try { SpreadsheetApp.getUi().alert(msg); } catch (e) { /* rodou pelo editor, sem UI da planilha */ }
}

/* Reescreve as validações das colunas E (Caso) e F (Norma) de REGISTROS, com os intervalos
 * dinâmicos, E a fórmula de obsolescência Q2 (reacoplada a F=código). Não chama criarRegistros()
 * — logo não faz clear(); os VALORES já digitados em REGISTROS permanecem. */
function reaplicarDropdownsRegistros(ss) {
  var aba = ss.getSheetByName('REGISTROS');
  var nNormas = ss.getSheetByName('NORMAS').getLastRow() - 1;
  var nCasos  = ss.getSheetByName('CASOS').getLastRow() - 1;
  var ultimaLinha = 1000;
  var faixaCasos  = ss.getSheetByName('CASOS').getRange(2, 2, nCasos, 1);   // Tema
  var faixaNormas = ss.getSheetByName('NORMAS').getRange(2, 1, nNormas, 1); // Cod_Norma (PK real)
  aplicarIntervalo(aba, 5, ultimaLinha, faixaCasos);   // E — Caso_Tipo_Tema
  aplicarIntervalo(aba, 6, ultimaLinha, faixaNormas);  // F — Norma_Chave_Primaria (código)

  // Q2 — reescreve a obsolescência com o VLOOKUP acoplado a F=código (NORMAS!$A:$G, índices 7/5).
  // Q é coluna CALCULADA (não guarda dado do curador): reescrever a âncora Q2 é seguro. Sem isto, a
  // base já criada continuaria com a fórmula antiga (B:G) e daria "NORMA NAO ENCONTRADA" para tudo.
  aba.getRange(2, 17).setFormula(
    '=ARRAYFORMULA(IF($F2:$F="";"";' +
      'IFERROR(' +
        'IF(VLOOKUP($F2:$F;NORMAS!$A:$G;7;0)="Revogada";"🔴 REVOGADA";' +
          'IF((VLOOKUP($F2:$F;NORMAS!$A:$G;5;0)&"")<>($P2:$P&"");"🟠 VERSAO MUDOU";"🟢 EM DIA"));' +
        '"⚠ NORMA NAO ENCONTRADA")))'
  );
}
