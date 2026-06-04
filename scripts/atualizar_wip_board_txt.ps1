# atualizar_wip_board_txt.ps1
# Gera 07_WIP_BOARD.txt e propaga para CLIENTES/*/NOTEBOOKLM_FONTES/
# Nao depende de ConvertFrom-Json -- imune a encoding do WIP_BOARD.json
# P-060: Musculo atualiza o bloco $CONTEUDO neste script quando WIP_BOARD muda
# Uso: .\scripts\atualizar_wip_board_txt.ps1

param(
    [string]$Raiz = (Split-Path $PSScriptRoot -Parent),
    [switch]$Verbose
)

$hoje = (Get-Date).ToString("yyyy-MM-dd")
$sep  = "=================================================="

# ============================================================
# CONTEUDO DO WIP_BOARD -- atualizado pelo Musculo por sessao
# Ultima atualizacao: 2026-06-04
# ============================================================
$CONTEUDO = @"
WIP BOARD -- PENTALATERAL IAH
Atualizado: $hoje | Script: atualizar_wip_board_txt.ps1
Referencia base: 2026-06-04 (ultima atualizacao manual)

$sep
PROJETOS ATIVOS
$sep

--- PROJ-002 - Ingrid ---
Status: RETAINER -- Loop 8 CONCLUIDO -- produto entregue -- depoimento capturado
Stack: PWA + Supabase + Claude API
Prova cliente: 2026-09-06
Loop 8: Gemini=OK | NotebookLM=OK | Embaixador=OK | Musculo=OK
Proximo: Loop 9 -- Gate 7.2 RLS + captacao 2a candidata antes 04-07-2026
Decisoes fixadas:
  fonte_questoes: Claude API -- sem scraping (P-003)
  auth: single-user -- sem login complexo
  modelos_api: Haiku (gerais + dicas socraticas) / Sonnet (especificos)
  burn_rate: BURN_RATE_DAILY_LIMIT_USD=5.00
Dias completos: dia1_schema_edge, dia2_gate_questoes, dia3_5_feed_sm2_pwa,
                dia6_8_tutor_fallback, dia9_11_heatmap_simulado,
                dia12_contador_socratica_vacina_push_cb
URL publica: https://subdiretormnmsgm-commits.github.io/vanguard/
Churn watch threshold: 5 dias
Formalizador: Termo_Uso_Ingrid_PROJ002_30052026.pdf -- ASSINADO 2026-05-18

--- PROJ-001 - Valdece ---
Status: HYPERCARE ate 18-06-2026 -- Sistema LIVE -- Sentinel ativo
Stack: PWA + Supabase + Claude API
Valor: R$5000
Loop 7: Gemini=OK | NotebookLM=OK | Embaixador=OK | Musculo=PENDENTE
Proximo: Musculo -- P-037 sintese Loop 7 Valdece -- DELIBERACAO_LOOP_V7_VALDECE.md
Dias completos: dia1_infraestrutura, dia2_corpus_pipeline, dia3_stj_tema_ui,
                dia4_gate_abnt_threshold_toga, dia5_corpus_deploy_demo
Deploy: https://toga-digital-valdece.netlify.app
Corpus: 61 acordaos -- 22 temas -- threshold 0.45 -- latencia 2.1-3.4s
Formalizador: Contrato_Toga_Digital_Valdece_19052026.pdf -- ASSINADO 2026-05-19
Sentinel Report previsto: 2026-06-02
Churn watch threshold: 3 dias

$sep
INFRA INTERNA -- PENTALATERAL
$sep

Status: PLANEJAMENTO -- FASE 0 CONCLUIDA
n8n FASE 1: desbloqueado apos 18-06-2026 (Hypercare Valdece encerra)
  4 workflows: check-ins 7h/13h/20h + monitor Supabase horario + webhook GitHub + formulario->MEMORIA
Notion: cockpit interno (ARQ-1) -- zero visibilidade de cliente
OpenClaw: V2 -- gateway AI multi-canal -- apos n8n estabilizar 30 dias
Data inicio build: 19-06-2026
Skill gerada: pentalateral-stack-v1.md (NotebookLM -- 2026-06-05)

Gates bloqueantes FASE 1:
  Gate Prefixos: lista Telegram (/mem, /status, /alerta) deve estar definida antes do 1o workflow
  Gate Hardware: verificar RAM livre no EasyPanel antes de qualquer deploy n8n

PROIBIDO na FASE 1:
  - Interface de login proprietaria ou espelhamento externo
  - Permissao de edicao manual no Notion para o Diretor
  - Acoplar OpenClaw antes de 30 dias de uptime n8n
  - Refatorar CLAUDE.md ou session_close.ps1

$sep
PERFIS DE NICHO
$sep

EdTech-Concurso:      maturidade=60% | status=consolidado parcial | ref=PROJ-002 Ingrid
Legal-Tech-Criminal:  maturidade=75% | status=CONTRATO ASSINADO 2026-05-19 | ref=PROJ-001 Valdece
Medico-Prova-Especialidade: GO aprovado 2026-05-19 -- aguarda Gemini PASSO3
Contabilidade-PME:    GO aprovado 2026-05-19 -- aguarda Gemini PASSO3
Psicologo-Clinico:    GO aprovado 2026-05-19 -- aguarda Gemini PASSO3

$sep
POLITICA DO BOARD
$sep

regra_1: Nada entra em BUILD sem Briefing aprovado pelo Diretor
regra_2: Nada sai de BUILD sem check_leis.ps1 aprovado
regra_3: Nada vai para ENTREGUE sem Sovereign Playbook gerado
regra_4: Sentinel do cliente atual validado antes de novo projeto entrar em BUILD
regra_5: Retainer so apos 30 dias de dados reais do Sentinel

$sep
PRINCIPIOS CRITICOS ATIVOS
$sep

P-001: Claude Code nao e daemon autonomo -- automacao exige Claude API + n8n
P-003: Scraping de terceiros e dependencia, nao ativo
P-008: Primeiro cliente de nicho e canal de distribuicao, nao MRR
P-059: Isolamento de contexto por cliente e lei -- nunca confundir projetos
P-060: Musculo e responsavel por toda propagacao -- zero intervencao do Diretor
P-099: Ping Supabase obrigatorio no onboarding -- previne pausa free tier
P-100: Embaixador opera por RAG -- design do PASSO7 deve usar termos exatos e nomes de secao

$sep
META
$sep

data_ultima_sessao: 2026-06-04
loops_desde_ultimo_checkup: 1
data_ultimo_checkup: 2026-05-27

$sep
FIM DO WIP BOARD
$sep
"@

# Propaga para CLIENTES/*/NOTEBOOKLM_FONTES/07_WIP_BOARD.txt
$clientesDir = Join-Path $Raiz "CLIENTES"
if (-not (Test-Path $clientesDir)) {
    Write-Host "[ATUALIZAR_WIP] ERRO: $clientesDir nao encontrado" -ForegroundColor Red
    exit 1
}

$fontesDirs = Get-ChildItem $clientesDir -Directory | ForEach-Object {
    $fp = Join-Path $_.FullName "NOTEBOOKLM_FONTES"
    if (Test-Path $fp) { $fp }
} | Where-Object { $_ }

if (-not $fontesDirs) {
    Write-Host "[ATUALIZAR_WIP] Nenhuma pasta NOTEBOOKLM_FONTES encontrada." -ForegroundColor Yellow
    exit 0
}

$atualizados = 0
foreach ($fontesDir in $fontesDirs) {
    $destino = Join-Path $fontesDir "07_WIP_BOARD.txt"
    [System.IO.File]::WriteAllText($destino, $CONTEUDO, [System.Text.Encoding]::UTF8)
    $atualizados++
    if ($Verbose) { Write-Host "[ATUALIZAR_WIP] OK: $destino" -ForegroundColor Green }
}

Write-Host "[ATUALIZAR_WIP] $atualizados pasta(s) sincronizadas em $hoje. Modo: direto (sem JSON)." -ForegroundColor Cyan
exit 0
