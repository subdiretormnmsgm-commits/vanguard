════════════════════════════════════════════════════════════
PENTALATERAL IAH — DIRETOR → ESTRATEGISTA
projeto: Base de Consultas Asse Ct Orç (DCEM) | ITERAÇÃO: V1 (Loop 1) | DATA: 2026-07-11 (sábado)
════════════════════════════════════════════════════════════

> Formato canônico COMANDO 1 (01_SKILL_PROTOCOLO_VANGUARD.md). Projeto PESSOAL do Diretor,
> rodado com o mesmo rigor das 35 versões. Empresa Vanguard PAUSADA — este loop roda ISOLADO,
> só para o DCEM (P-059). NÃO engaja Cowork/n8n/clientes/ChurnWatch. É iteração INICIAL (sem MEMORIA anterior).

Estrategista, somos o PENTALATERAL IAH — 5 atores: Estrategista + Diretor + Auditor + Músculo + Embaixador.
Estrategista (tu) | Diretor (Eduardo) | Auditor (NotebookLM) | Músculo (Claude Code) | Embaixador (Claude Projects).

── PAPEL DECLARADO (P-166) ──────────────────────────────────
PAPEL = ESTRATEGISTA. Arsenal exato desta sessão, nesta ordem:
@concise-planning → @brainstorming → @architecture → @analyze-project → deliberação 7 pontos.
O Estrategista SUPORTA a produção da DIRETRIZ; não executa build. Lê o workspace/Drive direto.
─────────────────────────────────────────────────────────────

════════════════════
BRIEFING DO CLIENTE (iteração inicial)
════════════════════
NICHO/SETOR: Assessoria de Controle Orçamentário (Asse Ct Orç) de uma Diretoria militar (DCEM).
             Responde consultas internas das demais seções sobre orçamento de movimentação.
PROBLEMA PRINCIPAL: o raciocínio institucional que resolve a consulta HOJE morre no balcão e SAI
             com o militar quando ele é movimentado. O conhecimento tácito de resolução rápida
             (o macete, o atalho legal, "isso aqui se faz assim") não fica retido nem pesquisável.
VOLUME: consultas recorrentes das 13 seções demandantes (indenização de transporte/bagagem,
             empenho, Decreto 4.307/2002, teto de gastos, frete).
ESTADO ATUAL: informal, sem registro. Semente real já existe no Drive (ver CONTEXTO).
URGÊNCIA: fundacional — a base tem de nascer LIMPA (vocabulário controlado) ou nasce suja.
RECURSOS: conta Google da seção (Forms/Sheets/Gmail/Drive/Apps Script). n8n liberado se o roteamento exigir.
CAMADA ESTIMADA: 1–2 (fundação de gestão de conhecimento, não SaaS).

════════════════════
O OBJETIVO DESTE LOOP (ratificado pelo Diretor — P-160)
════════════════════
"Ao final deste Loop, teremos a ARQUITETURA da Base de Consultas da Asse Ct Orç validada
(NORMA VIVA + fluxo oficial de 5 passos) + o VOCABULÁRIO CONTROLADO fundacional, projetada
para RETER O CONHECIMENTO TÁCITO DE RESOLUÇÃO RÁPIDA dos militares experientes."

⚠️ O CORAÇÃO DO PROJETO (ampliação do Diretor — leia como a missão):
O valor NÃO é só a norma citada. É o conhecimento tácito de resolução rápida do militar
experiente — as situações que ele sabe resolver rápido pela vivência. Hoje isso evapora na
movimentação. A norma é a ÂNCORA; a experiência de COMO resolver rápido é o ATIVO.
"O produto é a MEMÓRIA da seção — não o formulário."

════════════════════
CONTEXTO (fato em disco — GATE DE FATO)
════════════════════
FLUXO OFICIAL DO PROCESSO (declarado pelo Diretor — fonte de verdade):
1. Demandante preenche formulário via QR CODE: interessado · seção de movimentação ·
   consulta · WhatsApp · e-mail · norma relacionada (se souber).
2. Info fica on-line para o CHEFE da Asse Ct Orç, que roteia por tema ao MILITAR específico.
3. Militar registra a solução on-line → Chefe APRECIA, VALIDA, RETIFICA e encaminha ao interessado.
4. Tudo que tramita → BANCO DE DADOS (a MEMÓRIA) → alimenta futuras consultas.
5. Autor preenche PESQUISA DE SATISFAÇÃO.

13 SEÇÕES DEMANDANTES (lista fechada — trava o dropdown do QR):
QEMA · QSG · Cursos e Estágios · Praças · Ajudância Geral · Seção de Seleção · SPEC ·
Assessoria Jurídica · AI (Ass. de Inteligência) · Diretor · Subdiretor · Adjunto de Comando · Assistente.

OS 4 TRILHOS DUROS (fato — NÃO reabrir):
1. Dado em repouso 100% na conta Google da seção. Não sai.
2. Captura pelo próprio demandante, < 60s. Se pesar, a base morre vazia.
3. E-mail (Google) carrega conteúdo substantivo. WhatsApp = só notificação/metadado. Nunca conteúdo.
4. Sem IA embutida no produto. Sem Obsidian.

A SEMENTE JÁ EXISTE NO DRIVE (não começamos do zero):
Cadernos de Orientações DCEM (Cotista / Pgto Mov) = doutrina viva · DIEx da Asse Ct Orç
(3458/546/730/2276-AJ) = consultas já respondidas com base em norma · Decreto 4.307/2002 = base recorrente.

⚠️ ACHADO DE PESO (inventário da pasta "Gestão do conhecimento" — ~90 arquivos, 2026-07-11):
O TÁCITO JÁ ESTÁ MEIO-CAPTURADO num arquivo solto — o "Prompt Notebook LM.docx". Ele codifica,
por escrito, o macete de resolução rápida do militar experiente: (a) ordem de citação
CF→Lei→MP→Decreto→Portaria; (b) regra de conflito hierarquia > recência; (c) fontes EXCLUSIVAS por tema
(adicional → "tabela de valores"; transporte de bagagem → "tabela de transporte"); (d) percentuais por
posto/curso (Gen 28%… praça 13%; habilitação 73%→12%); (e) fórmulas de indenização (cubagem × R$/m³ ×
distância; passagem rodoviária 0,50; aérea 0,49); (f) regra read-time "desconsidere o revogado/tachado" +
princípio da especialidade (prioriza MP 2.215 · Lei 13.954 · Dec 4.307 · Port 290-DGP).
⚠️ MAS ESSE PROMPT DEVE SER APERFEIÇOADO — hoje é frágil (mora numa pessoa/num .docx, mistura regra de
cálculo com instrução de redação, não versiona, não sabe quando a tabela muda). A MISSÃO do Estrategista
inclui projetar como esse conhecimento evolui de "prompt solto" para ATIVO retido, acoplado à norma,
versionado e confiável no read-time — E propor a versão APERFEIÇOADA da lógica (o que falta, o que está
errado, o que quebra quando muda a tabela anual).
Higiene: 10 grupos de DUPLICATAS na pasta (Port 374/2002, 47-DGP/2012, 1.555/2021, 1845/2022 em 3× cada;
071-SEF/2020 com dois números) → a base dedupica por NORMA (código+ano), nunca por arquivo.

════════════════════
DELIBERAÇÃO PRÉVIA DO MÚSCULO (Conselho Deliberativo local — 5+5 revisores)
════════════════════
⚠️ ISTO É PONTO DE PARTIDA, NÃO GAIOLA. Não é para você apenas "reagir a isto".
Refute, transcenda, proponha uma arquitetura MELHOR se enxergar. O Músculo NÃO está te
algemando à conclusão dele — o valor deste loop está no que VOCÊ amplia além daqui.
Trate as linhas abaixo como hipóteses a testar, não como veredito:
- Hipótese: arquitetar a base como ÍNDICE DE NORMAS VIVAS (norma = chave primária; cada resposta = append datado),
  NÃO como arquivo de consultas. (Refute se houver unidade atômica melhor para reter o TÁCITO.)
- Hipótese: KPI = REÚSO ("norma consultada N×"), não "consulta evitada" (métrica de vaidade).
- Hipótese: VOCABULÁRIO CONTROLADO = 80% do risco (lista fechada de temas + índice de normas).
- Hipótese: OPSEC/controle de acesso = 5º trilho não escrito. Curador POR FUNÇÃO (sucessão do zelador).
- Hipótese: respondente escreve um REGISTRO estruturado (tema + norma + porquê 3 linhas); o e-mail é GERADO do registro.
Se a captura do tácito exigir romper qualquer hipótese acima (menos os 4 trilhos duros), rompa e justifique.

════════════════════
O QUE QUERO QUE O ESTRATEGISTA ATAQUE (amplitude máxima — NÃO delimite)
════════════════════
Pontos de partida, não gaiola. Explore além. Sem número fixo de queries, sem fronteira de tema.
1. O NÚCLEO — capturar o TÁCITO, não só a norma: como estruturar o REGISTRO da resposta para que o
   conhecimento de resolução rápida (macete, sequência prática, armadilha comum, atalho legal) fique
   retido e pesquisável, ACOPLADO à norma, sem depender da pessoa.
   1b. APERFEIÇOAR O "Prompt Notebook LM" existente: apontar o que está errado/frágil nele e propor a
       versão evoluída da lógica de resolução (separar regra de cálculo de instrução de redação; versionar;
       amarrar cada regra à norma/tabela-fonte; sinalizar quando a tabela anual muda). É semente, não teto.
2. NORMA VIVA como chave primária — validar/refutar/aprimorar sem violar os 4 trilhos.
3. Vocabulário controlado fundacional — derivá-lo dos Cadernos de Orientações já no Drive.
4. Confiança no READ-TIME — como quem consulta amanhã sabe que a resposta/macete ainda vale (obsolescência, dono de norma).
5. Painel ao Comando — sinais de valor: volume · resolução · REÚSO · satisfação · "mapa de quem sabe" (leitura emergente sob sigilo).
6. A ferramenta do "ambiente on-line" dentro dos trilhos (Forms/Sheets/Apps Script onFormSubmit; n8n só se o roteamento exigir).

════════════════════
AS 6 DECISÕES ABERTAS (o Diretor decide — o Estrategista aconselha)
════════════════════
1. NORMA VIVA como chave primária? · 2. OPSEC = 5º trilho? · 3. Tratamento das 5 sementes ·
4. Ferramenta inicial (Apps Script vs n8n) · 5. Dono de norma + curador por função ·
6. Obsidian (briefing citou; Trilho 4 proíbe — reconciliar).

════════════════════
RESPONDE COM 5 BLOCOS (contrato canônico — obrigatório)
════════════════════
BLOCO 0 — DIAGNÓSTICO (o problema real + a oportunidade não vista; REFORMULAÇÃO_DO_PROBLEMA + POSIÇÃO_ADVERSARIAL)
BLOCO 1 — CAMADA E 3 PRIORIDADES (em ordem de impacto institucional)
BLOCO 2 — PROPOSTA DE VALOR (o que a base entrega ao Comando/à seção, em linguagem do cliente)
BLOCO 3 — DIRETRIZ TÉCNICA, com os 3 sub-blocos obrigatórios:
   [PARA O NOTEBOOKLM] — nome EXATO da Skill a gerar (elo obrigatório)
   [PARA O MÚSCULO]    — o MESMO nome de Skill + intenção estratégica + o que construir primeiro
   [PARA O EMBAIXADOR] — o que observar no comportamento do "cliente" (Chefe/militares/Comando)
BLOCO 4 — PRÓXIMOS PASSOS DO DIRETOR (próximas 24h)

OBRIGATÓRIO: 5 ideias disruptivas [G-1 a G-5] ampliativas sobre o OBJETO deste loop
(reter o tácito de resolução rápida). Cada uma com ARCO_DE_CONSEQUÊNCIAS.
Ao final: TRADUÇÃO_PARA_AÇÃO (o que o Músculo faz nas próximas 24h).

Título esperado da resposta:
"Diretriz Estratégica V1 — Base de Consultas Asse Ct Orç (DCEM) — Loop 1".

Pesquisa AMPLIATIVA (Deep Research liberado): Top-5 fontes por vetor, registradas; sem blog; sem nº fixo de queries.
════════════════════════════════════════════════════════════
