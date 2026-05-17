// Edge Function: gerar-questoes
// PROJ-002 Ingrid — Dia 1 do build
// Gera questões estilo Quadrix via Claude API e salva no Supabase
// P-003: sem scraping | P-006: burn rate $5/dia | P-007: gate CLI primeiro

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ---------------------------------------------------------------
// TIPOS
// ---------------------------------------------------------------
interface GerarQuestoesPayload {
  disciplina_id: string;
  quantidade: number;
  modo?: "gate_cli" | "cache_lote"; // gate_cli = Magico de Oz, cache_lote = producao
}

interface Alternativa {
  letra: string;
  texto: string;
  correta: boolean;
}

interface QuestaoGerada {
  enunciado: string;
  alternativas: Alternativa[];
  gabarito: string;
  explicacao: string;
  distrator_principal: string;
  nivel_dificuldade: number;
  estilo_quadrix: string[];
}

// ---------------------------------------------------------------
// CONFIGURAÇÃO
// ---------------------------------------------------------------
const BURN_RATE_DAILY_LIMIT_USD = 5.00;
const CONCURSO_ID = "sedes_df_2026";
const CACHE_MINIMO = 30;
const LOTE_TAMANHO = 50;

// Modelo por peso do edital (decisao aprovada no Veredito)
const MODELO_POR_PESO: Record<number, string> = {
  1: "claude-haiku-4-5-20251001",   // gerais — custo baixo
  2: "claude-sonnet-4-6",           // especificos — qualidade maxima
};

// Score de incidencia historica por disciplina (P-014 — ideia do Diretor Eduardo)
// score_prioridade = peso_edital x incidencia_historica_pct
const INCIDENCIA_HISTORICA: Record<string, number> = {
  suas_fundamentos: 95, programas_beneficios_df: 90, direito_administrativo: 92,
  direito_constitucional: 78, arquivologia_rotinas_atendimento: 85,
  recursos_materiais_patrimonio: 72, portugues: 95, realidade_df_ride: 88,
  lei_organica_df: 82, lc840: 80, maria_da_penha: 75, politica_mulheres: 60,
  primeiros_socorros: 50,
};

// Cargo 202 — Tecnico Administrativo SEDES-DF (recalibrado P-024 2026-05-16)
const PESO_POR_DISCIPLINA: Record<string, number> = {
  // Peso 2 — Conhecimentos Especificos (valem 80/100 pontos da prova)
  suas_fundamentos:               2,
  programas_beneficios_df:        2,
  direito_administrativo:         2,
  direito_constitucional:         2,
  arquivologia_rotinas_atendimento: 2,
  recursos_materiais_patrimonio:  2,
  // Peso 1 — Conhecimentos Gerais (valem 20/100 pontos da prova)
  portugues:                      1,
  realidade_df_ride:              1,
  lei_organica_df:                1,
  lc840:                          1,
  maria_da_penha:                 1,
  politica_mulheres:              1,
  primeiros_socorros:             1,
};

// ---------------------------------------------------------------
// PROMPT DO GERADOR — estilo Quadrix
// ---------------------------------------------------------------
function buildPrompt(disciplina_id: string, quantidade: number): string {
  // Cargo 202 — Tecnico Administrativo SEDES-DF (recalibrado P-024)
  const disciplinas: Record<string, string> = {
    // Peso 2 — Especificos
    suas_fundamentos: "SUAS — Fundamentos, Organização e Gestão. LOAS 8.742/1993 (BPC, benefícios eventuais, CNAS). PNAS 2004 (princípios, proteção social básica e especial). NOB/SUAS (pacto de aprimoramento, níveis municipais). CRAS: PAIF, vigilância socioassistencial. CREAS: PAEFI, média e alta complexidade. Matricialidade sociofamiliar, territorialização, descentralização. Pegadinhas Quadrix: CRAS vs CREAS, competência federal vs municipal, quem paga BPC (INSS federal), confundir PAIF com PAEFI.",
    programas_beneficios_df: "Programas e Benefícios de Assistência Social do DF. Lei Distrital 7.484/2024 (NOVA — alta chance de cobrança). Cartão Prato Cheio: renda per capita até 1/2 SM, benefício mensal. Cartão Gás DF: extrema pobreza, CadÚnico. CadÚnico: porta de entrada, atualização obrigatória a cada 2 anos. Restaurantes Comunitários do DF. Benefícios eventuais: competência municipal. Pegadinhas: confundir critério de renda BPC (1/4 SM) vs Prato Cheio (1/2 SM).",
    direito_administrativo: "Noções de Direito Administrativo. Princípios: LIMPE (Legalidade, Impessoalidade, Moralidade, Publicidade, Eficiência — Art. 37 CF). Ato administrativo: elementos (competência, finalidade, forma, motivo, objeto). Nova Lei de Licitações 14.133/2021 — modalidades (pregão, concorrência, concurso, leilão, diálogo competitivo). Dispensa vs inexigibilidade. Improbidade administrativa (Lei 8.429/92). Serviços públicos: classificação, concessão, permissão. Poderes administrativos. Pegadinhas Quadrix: confundir dispensável com dispensada, modalidades de licitação, hipóteses de inexigibilidade.",
    direito_constitucional: "Noções de Direito Constitucional. Princípios fundamentais da CF/88 (Art. 1 a 4). Direitos e garantias fundamentais (Art. 5 — rol não taxativo, HD, MS, MI, HC). Organização do Estado (Art. 37 a 43): Administração Pública, princípios constitucionais. Poder Executivo e Poder Legislativo: atribuições básicas. Seguridade Social (Art. 194): saúde, previdência e assistência social — distinções. Pegadinhas Quadrix: direitos absolutos vs relativos, remédios constitucionais (confundir HC com MS), responsabilidade civil do Estado.",
    arquivologia_rotinas_atendimento: "Arquivologia e Rotinas de Atendimento ao Público. Gestão de documentos: arquivo corrente, intermediário e permanente. Protocolo: recebimento, registro, distribuição e expedição. Classificação de documentos: sigiloso, reservado, confidencial, secreto, ultrassecreto. Lei de Arquivos 8.159/1991. Atendimento ao público: técnicas de comunicação, empatia, proatividade. Telefonia e redação oficial. Pegadinhas Quadrix: confundir fases do arquivo, prazos de temporalidade, eliminação vs recolhimento ao permanente.",
    recursos_materiais_patrimonio: "Administração de Recursos Materiais e Patrimônio. Gestão patrimonial: inventário, tombamento, alienação, baixa. Materiais: classificação (permanentes vs consumo). Almoxarifado: recebimento, armazenamento, distribuição. Compras públicas: planejamento, requisição, processo licitatório simplificado. Registro patrimonial: número de tombamento, responsáveis. Pegadinhas Quadrix: confundir bem permanente com consumo, processo de alienação (leilão obrigatório), responsabilidade do gestor de patrimônio.",
    // Peso 1 — Gerais
    portugues: "Língua Portuguesa — interpretação de texto (resposta na literalidade — não inferir além do escrito), concordância verbal e nominal, regência verbal e nominal, crase, pontuação (uso da vírgula), reescrita de frases, significação das palavras (sinonímia, antonímia, paronímia, polissemia), ortografia oficial, classes de palavras. Pegadinhas Quadrix: cobrar literalidade, candidato que interpreta além do texto erra.",
    realidade_df_ride: "Realidade do DF e RIDE — RIDE: municípios de GO, MG e DF, criada pela LC 94/1998. Brasília: Missão Cruls, Plano Piloto Lúcio Costa, inauguração 1960 por JK. DF: 33 Regiões Administrativas, maior densidade do Centro-Oeste. Economia do DF: predominância de serviços e administração pública. Clima Cerrado, hidrografia.",
    lei_organica_df: "Lei Orgânica do Distrito Federal (LODF). DF acumula competências estaduais E municipais — não tem municípios próprios. Câmara Legislativa: 24 deputados distritais, mandato 4 anos. Governador: eleito pelo povo. Promulgada em 08/06/1993. Competências cumulativas, organização política e administrativa.",
    lc840: "LC 840/2011 — Estatuto dos Servidores Públicos Civis do DF. Estágio probatório: 3 anos (pegadinha: confundir com 2 anos da lei anterior). Acumulação de cargos: permitida em casos específicos (saúde, professores). Licenças: tipos, prazos, remuneração. Férias e afastamentos. Cargos em comissão vs efetivos. Vencimento vs remuneração.",
    maria_da_penha: "Lei Maria da Penha — Lei 11.340/2006. Não é necessário coabitar com o agressor (Súmula 600 STJ — pegadinha clássica). Lesão corporal dolosa doméstica: ação penal INCONDICIONADA (Súmula 542 STJ). Suspensão condicional e transação penal: VEDADAS expressamente (Art. 41). Formas de violência: física, psicológica, sexual, patrimonial, moral. Medidas protetivas de urgência.",
    politica_mulheres: "Política para Mulheres. Lei do Feminicídio: Lei 13.104/2015 — homicídio qualificado por razão de gênero. Plano Distrital de Política para Mulheres (PDPM). Rede de atendimento: DEAM, Casa da Mulher Brasileira, CRAM, CREAS. Política Nacional de Enfrentamento à Violência contra Mulheres.",
    primeiros_socorros: "Noções de Primeiros Socorros. PCR: checar responsividade → acionar socorro (192/193) → iniciar RCP 30:2. Hemorragia: pressão direta no local — NÃO usar torniquete sem treinamento. Engasgo consciente: Manobra de Heimlich — 5 compressões abdominais. Queimaduras: classificação 1º/2º/3º grau e primeiros cuidados. Desmaio e convulsão: conduta.",
  };

  const tema = disciplinas[disciplina_id] ?? disciplina_id;

  return `Você é um gerador de questões de concurso público especializado no estilo do Instituto Quadrix.

Gere EXATAMENTE ${quantidade} questões sobre: ${tema}

REGRAS OBRIGATÓRIAS DO ESTILO QUADRIX:
1. Múltipla escolha com 5 alternativas (A, B, C, D, E)
2. Enunciado direto e objetivo — máximo 3 linhas
3. LITERALIDADE: a resposta correta está EXPLÍCITA no texto da lei ou norma — nunca inferida
4. Distratores plausíveis: troque "preferencialmente" por "exclusivamente", "deverá" por "poderá", competências entre órgãos similares
5. Pegadinhas típicas Quadrix: troca de competência (CRAS vs CREAS), troca de quem paga (federal vs municipal), troca de prazos
6. Nível de dificuldade entre 2 e 4 (escala 1-5)

FORMATO DE RESPOSTA — JSON puro, sem markdown, sem texto fora do JSON:
{
  "questoes": [
    {
      "enunciado": "texto completo da questão",
      "alternativas": [
        { "letra": "A", "texto": "texto da alternativa", "correta": false },
        { "letra": "B", "texto": "texto da alternativa", "correta": false },
        { "letra": "C", "texto": "texto da alternativa", "correta": true },
        { "letra": "D", "texto": "texto da alternativa", "correta": false },
        { "letra": "E", "texto": "texto da alternativa", "correta": false }
      ],
      "gabarito": "C",
      "explicacao": "A resposta correta é C porque [explicação baseada na literalidade da lei]. As alternativas A e D erram porque [distratores usados].",
      "distrator_principal": "troca_competencia | troca_modalidade | troca_prazo | troca_quem_paga | falsa_exclusividade",
      "nivel_dificuldade": 3,
      "estilo_quadrix": ["literalidade", "pegadinha_competencia"]
    }
  ]
}

Gere questões variadas — não repita o mesmo tópico duas vezes. Distribua por diferentes artigos e incisos da legislação.`;
}

// ---------------------------------------------------------------
// VERIFICAÇÃO DE BURN RATE (P-006)
// ---------------------------------------------------------------
async function verificarBurnRate(supabase: ReturnType<typeof createClient>): Promise<boolean> {
  const hoje = new Date().toISOString().split("T")[0];

  const { data, error } = await supabase
    .from("controle_burn_rate")
    .select("custo_acumulado_usd, limite_diario_usd, bloqueado")
    .eq("data_ref", hoje)
    .single();

  if (error || !data) {
    // Cria registro do dia se nao existir
    await supabase.from("controle_burn_rate").insert({ data_ref: hoje });
    return true; // libera — primeiro acesso do dia
  }

  if (data.bloqueado) return false;
  return data.custo_acumulado_usd < data.limite_diario_usd;
}

// ---------------------------------------------------------------
// ATUALIZA CUSTO (P-006)
// ---------------------------------------------------------------
async function registrarCusto(
  supabase: ReturnType<typeof createClient>,
  custoUsd: number
): Promise<void> {
  const hoje = new Date().toISOString().split("T")[0];

  await supabase.rpc("incrementar_custo_burn_rate", {
    p_data_ref: hoje,
    p_custo: custoUsd,
    p_limite: BURN_RATE_DAILY_LIMIT_USD,
  });
}

// ---------------------------------------------------------------
// HANDLER PRINCIPAL
// ---------------------------------------------------------------
serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Método não permitido" }), { status: 405 });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  );

  const anthropicKey = Deno.env.get("ANTHROPIC_API_KEY");
  if (!anthropicKey) {
    return new Response(JSON.stringify({ error: "ANTHROPIC_API_KEY não configurada" }), { status: 500 });
  }

  // Lê payload
  const payload: GerarQuestoesPayload = await req.json();
  const { disciplina_id, quantidade, modo = "cache_lote" } = payload;

  if (!disciplina_id || !quantidade) {
    return new Response(
      JSON.stringify({ error: "disciplina_id e quantidade são obrigatórios" }),
      { status: 400 }
    );
  }

  // Verifica burn rate (P-006)
  const burnRateOk = await verificarBurnRate(supabase);
  if (!burnRateOk) {
    return new Response(
      JSON.stringify({
        error: "BURN_RATE_LIMIT atingido",
        mensagem: `Limite diário de $${BURN_RATE_DAILY_LIMIT_USD} atingido. Tente amanhã.`,
        codigo: "HV_BURN_RATE"
      }),
      { status: 429 }
    );
  }

  // Define modelo pelo peso do edital
  const peso = PESO_POR_DISCIPLINA[disciplina_id] ?? 1;
  const modelo = MODELO_POR_PESO[peso];

  // Gera questões via Claude API
  const prompt = buildPrompt(disciplina_id, quantidade);

  let geradas: QuestaoGerada[] = [];
  let custoEstimadoUsd = 0;

  try {
    const response = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "x-api-key": anthropicKey,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        model: modelo,
        max_tokens: 4096,
        messages: [{ role: "user", content: prompt }],
      }),
    });

    if (!response.ok) {
      const err = await response.text();
      throw new Error(`Claude API error: ${err}`);
    }

    const apiResponse = await response.json();
    const conteudo = apiResponse.content?.[0]?.text ?? "";

    // Estimativa de custo (tokens de saida ~ mais caros)
    const inputTokens  = apiResponse.usage?.input_tokens  ?? 0;
    const outputTokens = apiResponse.usage?.output_tokens ?? 0;
    // Haiku: $0.25/1M input, $1.25/1M output | Sonnet: $3/1M input, $15/1M output
    const precoInput  = peso === 1 ? 0.00000025 : 0.000003;
    const precoOutput = peso === 1 ? 0.00000125 : 0.000015;
    custoEstimadoUsd  = (inputTokens * precoInput) + (outputTokens * precoOutput);

    // Parse do JSON retornado
    const parsed = JSON.parse(conteudo);
    geradas = parsed.questoes ?? [];

  } catch (err) {
    return new Response(
      JSON.stringify({ error: "Falha na geração via Claude API", detalhe: String(err) }),
      { status: 500 }
    );
  }

  // Modo gate_cli: retorna as questões sem salvar (Mágico de Oz — Eduardo avalia)
  if (modo === "gate_cli") {
    await registrarCusto(supabase, custoEstimadoUsd);
    return new Response(
      JSON.stringify({
        modo: "gate_cli",
        disciplina_id,
        modelo_usado: modelo,
        custo_usd: custoEstimadoUsd.toFixed(4),
        quantidade: geradas.length,
        questoes: geradas,
      }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );
  }

  // Modo cache_lote: salva no Supabase
  const registros = geradas.map((q) => ({
    concurso_id:        CONCURSO_ID,
    disciplina_id,
    peso_edital:        peso,
    score_prioridade:   peso * (INCIDENCIA_HISTORICA[disciplina_id] ?? 50),
    enunciado:          q.enunciado,
    alternativas:       q.alternativas,
    gabarito:           q.gabarito,
    explicacao:         q.explicacao,
    distrator_principal: q.distrator_principal,
    nivel_dificuldade:  q.nivel_dificuldade,
    estilo_quadrix:     q.estilo_quadrix,
  }));

  const { error: insertError } = await supabase
    .from("questoes_quadrix")
    .insert(registros);

  if (insertError) {
    return new Response(
      JSON.stringify({ error: "Falha ao salvar questões", detalhe: insertError.message }),
      { status: 500 }
    );
  }

  // Atualiza controle_cache
  await supabase
    .from("controle_cache")
    .upsert({
      concurso_id: CONCURSO_ID,
      disciplina_id,
      ultima_geracao_em: new Date().toISOString(),
      geracao_em_progresso: false,
    }, { onConflict: "concurso_id,disciplina_id" });

  // Registra custo (P-006)
  await registrarCusto(supabase, custoEstimadoUsd);

  return new Response(
    JSON.stringify({
      modo: "cache_lote",
      disciplina_id,
      modelo_usado: modelo,
      custo_usd: custoEstimadoUsd.toFixed(4),
      questoes_salvas: geradas.length,
    }),
    { status: 200, headers: { "Content-Type": "application/json" } }
  );
});
