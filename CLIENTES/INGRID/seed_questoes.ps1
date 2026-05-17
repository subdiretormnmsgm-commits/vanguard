# seed_questoes.ps1 - PROJ-002 Ingrid
# Popula o banco com questoes para todas as disciplinas do Cargo 202
# Pre-requisito do Gate Dia 5 - rodar UMA VEZ antes do gate
# Uso: .\seed_questoes.ps1

param(
    [int]$QuantidadePorDisciplina = 50
)

$SUPABASE_URL     = $env:SUPABASE_URL
$SERVICE_ROLE_KEY = $env:SUPABASE_SERVICE_ROLE_KEY

if (-not $SUPABASE_URL -or -not $SERVICE_ROLE_KEY) {
    Write-Host ""
    Write-Host "  SUPABASE_URL e SUPABASE_SERVICE_ROLE_KEY precisam estar no ambiente." -ForegroundColor Red
    Write-Host "  Rode antes:" -ForegroundColor Yellow
    Write-Host '  $env:SUPABASE_URL="https://[projeto].supabase.co"' -ForegroundColor Cyan
    Write-Host '  $env:SUPABASE_SERVICE_ROLE_KEY="[service_role_key]"' -ForegroundColor Cyan
    exit 1
}

$ENDPOINT = "$SUPABASE_URL/functions/v1/gerar-questoes"

$disciplinasPeso2 = @(
    @{ id = "suas_fundamentos";                 nome = "SUAS - Fundamentos";               score = 190 },
    @{ id = "direito_administrativo";            nome = "Direito Administrativo";           score = 184 },
    @{ id = "programas_beneficios_df";           nome = "Programas e Beneficios DF";        score = 180 },
    @{ id = "arquivologia_rotinas_atendimento";  nome = "Arquivologia e Rotinas";           score = 170 },
    @{ id = "direito_constitucional";            nome = "Direito Constitucional";           score = 156 },
    @{ id = "recursos_materiais_patrimonio";     nome = "Recursos Materiais e Patrimonio";  score = 144 }
)

$disciplinasPeso1 = @(
    @{ id = "portugues";            nome = "Lingua Portuguesa";      score = 95 },
    @{ id = "realidade_df_ride";    nome = "Realidade DF/RIDE";      score = 88 },
    @{ id = "lei_organica_df";      nome = "Lei Organica DF";        score = 82 },
    @{ id = "lc840";                nome = "LC 840 - Servidores DF"; score = 80 },
    @{ id = "maria_da_penha";       nome = "Lei Maria da Penha";     score = 75 },
    @{ id = "politica_mulheres";    nome = "Politica para Mulheres"; score = 60 },
    @{ id = "primeiros_socorros";   nome = "Primeiros Socorros";     score = 50 }
)

$todas  = $disciplinasPeso2 + $disciplinasPeso1
$total  = $todas.Count
$idsP2  = $disciplinasPeso2 | ForEach-Object { $_.id }

$custoEstimado = ($disciplinasPeso2.Count * 0.10) + ($disciplinasPeso1.Count * 0.008)

Write-Host ""
Write-Host "  ===========================================" -ForegroundColor Cyan
Write-Host "  SEED QUESTOES - Cargo 202 Sedes-DF 2026"   -ForegroundColor Cyan
Write-Host "  ===========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Disciplinas    : $total"                                          -ForegroundColor White
Write-Host "  Questoes/disc  : $QuantidadePorDisciplina"                       -ForegroundColor White
Write-Host "  Total questoes : $($total * $QuantidadePorDisciplina)"            -ForegroundColor White
Write-Host ("  Custo estimado : ~`${0:F2}" -f $custoEstimado)                  -ForegroundColor Yellow
Write-Host "  Burn rate limit: `$5.00/dia"                                     -ForegroundColor White
Write-Host ""

if ($custoEstimado -gt 4.50) {
    Write-Host "  AVISO: custo estimado proximo do limite diario." -ForegroundColor Red
    Write-Host "  Considere rodar com -QuantidadePorDisciplina 30" -ForegroundColor Yellow
    $resp = Read-Host "  Continuar mesmo assim? (s/N)"
    if ($resp -ne "s" -and $resp -ne "S") { exit 0 }
} else {
    $resp = Read-Host "  Confirma geracao? (s/N)"
    if ($resp -ne "s" -and $resp -ne "S") { exit 0 }
}

Write-Host ""

function Invoke-GerarQuestoes {
    param($DisciplinaId, $Quantidade)

    $body = @{
        disciplina_id = $DisciplinaId
        quantidade    = $Quantidade
        modo          = "cache_lote"
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod `
            -Uri $ENDPOINT `
            -Method POST `
            -Headers @{
                "Authorization" = "Bearer $SERVICE_ROLE_KEY"
                "Content-Type"  = "application/json"
            } `
            -Body $body `
            -TimeoutSec 120

        return @{
            ok        = $true
            salvas    = $response.questoes_salvas
            custo_usd = [double]$response.custo_usd
            modelo    = $response.modelo_usado
        }
    } catch {
        return @{ ok = $false; erro = $_.Exception.Message }
    }
}

$custoTotal  = 0.0
$totalSalvas = 0
$erros       = 0
$indice      = 0

foreach ($disc in $todas) {
    $indice++
    $prefixo  = if ($idsP2 -contains $disc.id) { "P2" } else { "P1" }
    Write-Host "  [$indice/$total] $prefixo | $($disc.nome) (score $($disc.score))" -ForegroundColor White

    $resultado = Invoke-GerarQuestoes -DisciplinaId $disc.id -Quantidade $QuantidadePorDisciplina

    if ($resultado.ok) {
        $custoTotal  += $resultado.custo_usd
        $totalSalvas += $resultado.salvas
        $msg = "    OK - {0} questoes salvas | custo: `${1:F4} | modelo: {2}" -f $resultado.salvas, $resultado.custo_usd, $resultado.modelo
        Write-Host $msg -ForegroundColor Green
    } else {
        $erros++
        Write-Host "    ERRO - $($resultado.erro)" -ForegroundColor Red
    }

    if ($custoTotal -ge 4.00) {
        Write-Host ""
        Write-Host ("  AVISO: custo acumulado `${0:F2} - proximo do limite diario. Parando." -f $custoTotal) -ForegroundColor Red
        break
    }

    if ($indice -lt $total) {
        Start-Sleep -Seconds 2
    }
}

Write-Host ""
Write-Host "  ---------------------------------" -ForegroundColor DarkGray
Write-Host "  RESUMO DO SEED"                    -ForegroundColor Cyan
Write-Host "  Questoes salvas : $totalSalvas"    -ForegroundColor White
Write-Host ("  Custo total     : `${0:F4}" -f $custoTotal) -ForegroundColor White

if ($erros -gt 0) {
    Write-Host "  Erros           : $erros" -ForegroundColor Red
} else {
    Write-Host "  Erros           : 0" -ForegroundColor Green
}

Write-Host ""

if ($erros -eq 0 -and $totalSalvas -ge ($total * $QuantidadePorDisciplina * 0.9)) {
    Write-Host "  BANCO POPULADO - pronto para rodar o Gate Dia 5." -ForegroundColor Green
    Write-Host ""
    Write-Host "  Proximo passo:" -ForegroundColor Yellow
    Write-Host '  $env:USER_ID_INGRID="[UUID]"; node CLIENTES/INGRID/gate_cli_dia5.js' -ForegroundColor Cyan
} else {
    Write-Host "  Banco parcialmente populado. Verifique os erros e rode novamente." -ForegroundColor Yellow
}

Write-Host "  ---------------------------------" -ForegroundColor DarkGray
Write-Host ""
