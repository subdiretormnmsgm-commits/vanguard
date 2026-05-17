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

// Peso do edital por disciplina — Cargo 202: Tecnico Administrativo
const PESO_POR_DISCIPLINA: Record<string, number> = {
  // Conhecimentos Especificos (peso 2) — Cargo 202
  suas_fundamentos: 2,           // SUAS, PNAS, LOAS, NOB/SUAS, CRAS/CREAS, tipificacao
  programas_beneficios_df: 2,    // Lei 7484/2024, Cartao Prato Cheio, CadUnico, BPC, beneficios eventuais
  direito_administrativo: 2,     // principios, atos, licitacoes 14.133, improbidade, processo adm
  direito_constitucional: 2,     // CF/88 arts. 1-17 + 37-41, direitos fundamentais
  arquivologia_rotinas_atendimento: 2, // arquivologia, protocolo, redacao oficial, atendimento ao publico
  recursos_materiais_patrimonio: 2,    // gestao de estoques, patrimonio, compras publicas
  // Conhecimentos Gerais (peso 1)
  portugues: 1, realidade_df_ride: 1, lei_organica_df: 1, lc840: 1,
  maria_da_penha: 1, politica_mulheres: 1, primeiros_socorros: 1,
};

// ---------------------------------------------------------------
// PROMPT DO GERADOR — estilo Quadrix
// ---------------------------------------------------------------
function buildPrompt(disciplina_id: string, quantidade: number): string {
  // Cargo 202 — Tecnico Administrativo SEDES-DF
  const disciplinas: Record<string, string> = {
    // Conhecimentos Especificos
    suas_fundamentos: "SUAS — Fundamentos, Organização, Gestão e Marcos Operacionais: PNAS 2004 (princípios, diretrizes, níveis de proteção), LOAS 8.742/1993 (BPC, benefícios eventuais, CNAS, financiamento), NOB/SUAS (gestão municipal inicial/básica/plena, pacto de aprimoramento), Tipificação Nacional CNAS 109/2009, CRAS/PAIF, CREAS/PAEFI, proteção básica e especial, matricialidade sociofamiliar, territorialização, vigilância socioassistencial",
    programas_beneficios_df: "Programas, Benefícios e Instrumentos de Assistência Social do DF — Lei Distrital 7.484/2024 (política de assistência social do DF), Cartão Prato Cheio DF (critérios, renda per capita ≤ 1/2 SM), Cartão Gás DF (CadÚnico, extrema pobreza), DF Social, Restaurantes Comunitários, CadÚnico (cadastramento, atualização, papel nos programas), BPC (critérios, 1/4 SM, operacionalização INSS), Benefícios Eventuais (competência municipal)",
    direito_administrativo: "Noções de Direito Administrativo — Princípios da Adm Pública (Art. 37 CF/88: LIMPE + implícitos), Atos Administrativos (elementos: competência, finalidade, forma, motivo, objeto; atributos: presunção de legitimidade, imperatividade, autoexecutoriedade; vícios e anulação), Poderes Administrativos (vinculado, discricionário, hierárquico, disciplinar, regulamentar, de polícia), Processo Administrativo Lei 9.784/1999 (princípios, prazos, recursos), Licitações e Contratos Lei 14.133/2021 (modalidades: Pregão, Concorrência, Concurso, Leilão, Diálogo Competitivo; fases; dispensa e inexigibilidade), Improbidade Administrativa Lei 8.429/1992 (atos que importam enriquecimento ilícito, dano ao erário, violação de princípios; sanções), Controle da Administração",
    direito_constitucional: "Noções de Direito Constitucional — CF/88: Princípios Fundamentais (Título I: soberania, cidadania, dignidade da pessoa humana, valores sociais do trabalho), Direitos e Garantias Fundamentais (Art. 5: igualdade, legalidade, HC, MS, ação popular, direitos sociais Art. 6-11), Administração Pública (Arts. 37-41: princípios LIMPE, cargos e empregos públicos, concurso público, estabilidade, acumulação de cargos), separação dos Poderes",
    arquivologia_rotinas_atendimento: "Atendimento ao Público, Rotinas Administrativas e Arquivologia — Arquivologia: conceitos (arquivo, documento, fundo, coleção), princípios arquivísticos (proveniência, organicidade, unicidade, indivisibilidade), ciclo vital dos documentos (corrente, intermediário, permanente), gestão de documentos (produção, tramitação, uso, avaliação, arquivamento), tabela de temporalidade (elaboração, aprovação, destinação), protocolo (recebimento, classificação, registro, distribuição, expedição), Redação Oficial: Manual da Presidência 3ª edição (ofício, e-mail institucional, exposição de motivos, relatório — clareza, impessoalidade, concisão), Atendimento ao público: qualidade, acessibilidade, comunicação, ética no serviço público",
    recursos_materiais_patrimonio: "Noções de Recursos Materiais, Patrimônio e Compras — Administração de materiais: classificação, codificação, padronização, catalogação; Gestão de estoques: curva ABC (A=alto valor/poucos itens, B=médio, C=baixo valor/muitos itens), ponto de pedido, estoque mínimo e máximo, PEPS/UEPS; Almoxarifado: recebimento, armazenagem, controle, inventário; Patrimônio público: tombamento, inventário anual, depreciação, alienação, baixa de bens; Compras públicas: planejamento, pesquisa de mercado, Lei 14.133/2021 (dispensa até R$50mil bens/serviços, até R$100mil obras; inexigibilidade)",
    // Conhecimentos Gerais
    portugues: "Língua Portuguesa — interpretação de texto (literalidade Quadrix), concordância verbal e nominal, regência, crase, pontuação/vírgula, reescrita de frases, ortografia oficial, significação das palavras",
    realidade_df_ride: "Realidade do DF e RIDE — história de Brasília (Missão Cruls, JK, Lúcio Costa, inauguração 1960), RIDE (LC 94/1998, municípios GO/MG/DF, SUDECO), 33 Regiões Administrativas, economia do DF, dados demográficos",
    lei_organica_df: "Lei Orgânica do DF — competência cumulativa estadual+municipal, Câmara Legislativa (24 deputados, 4 anos), Governador, direitos e garantias no DF, promulgada 08/06/1993",
    lc840: "LC 840/2011 — Estatuto dos Servidores do DF — direitos e deveres, regime disciplinar, licenças (tipos, prazos, remuneração), férias, estabilidade (3 anos de estágio probatório), aposentadoria, acumulação de cargos, vencimento vs remuneração",
    maria_da_penha: "Lei Maria da Penha — Lei 11.340/2006 — definição de violência doméstica (Art. 5, não exige coabitação), formas de violência (física, psicológica, sexual, patrimonial, moral), medidas protetivas, ação penal incondicionada (Súmula 542 STJ), vedação suspensão condicional (Art. 41), Súmula 600 STJ",
    politica_mulheres: "Política para Mulheres — Lei do Feminicídio 13.104/2015, PDPM, rede de serviços (DEAM, Casa da Mulher, CRAM, CREAS), Política Nacional de Enfrentamento à Violência",
    primeiros_socorros: "Noções de Primeiros Socorros — PCR (reconhecimento, acionamento 192/193, RCP 30:2), hemorragias (pressão direta), engasgo (Heimlich), queimaduras (classificação), desmaio e convulsão",
  };

  const tema = disciplinas[disciplina_id] ?? disciplina_id;

  return `Você é um gerador de questões de concurso público especializado no estilo do Instituto Quadrix.

Gere EXATAMENTE ${quantidade} questões sobre: ${tema}

REGRAS OBRIGATÓRIAS DO ESTILO QUADRIX:
1. Múltipla escolha com 5 alternativas (A, B, C, D, E)
2. Enunciado direto e objetivo — máximo 3 linhas
3. LITERALIDADE: a resposta correta está EXPLÍCITA no texto da lei ou norma — nunca inferida
4. Distratores plausíveis: troque "preferencialmente" por "exclusivamente", "deverá" por "poderá", competências entre órgãos similares
5. Pegadinhas típicas Quadrix: troca de competência (CRAS vs CREAS), troca de quem paga (BPC=federal vs benefício eventual=municipal), troca de prazos (estágio probatório 3 anos, não 2), troca de modalidade de licitação (Pregão vs Concorrência), troca de arquivo corrente por intermediário, troca de "dispensável" por "dispensada", uso de Lei 8.666 no lugar da 14.133/2021
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
    score_prioridade:   peso * (PESO_POR_DISCIPLINA[disciplina_id] ? 85 : 50),
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
