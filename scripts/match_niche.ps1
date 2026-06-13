# match_niche.ps1 - Repositorio de Nicho Vanguard - Matchmaking para novos projetos
# Uso: .\scripts\match_niche.ps1 -setor "engenharia" -tags "edital,licitacao"
# Uso: .\scripts\match_niche.ps1 -setor "saude" -minScore 4.5
# Uso: .\scripts\match_niche.ps1 -status MOVER_AGORA
# Uso: .\scripts\match_niche.ps1 -listar  (lista todos com fit_score)

param(
    [string]$setor = "",
    [string]$tags = "",
    [double]$minScore = 0.0,
    [string]$status = "",
    [switch]$listar,
    [switch]$detalhado
)

$indexPath = "$PSScriptRoot\..\PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\NICHE_INDEX.json"
$modelsDir = "$PSScriptRoot\..\PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\NICHE_MODELS"

if (-not (Test-Path $indexPath)) {
    Write-Host "[ERRO] NICHE_INDEX.json nao encontrado: $indexPath" -ForegroundColor Red
    exit 1
}

$index = Get-Content $indexPath -Raw -Encoding UTF8 | ConvertFrom-Json
$nichos = $index.nichos

Write-Host ""
Write-Host "=== NICHE INTELLIGENCE REPOSITORY - VANGUARD ===" -ForegroundColor Cyan
Write-Host "Versao: $($index._meta.versao) | Atualizado: $($index._meta.ultima_atualizacao)" -ForegroundColor DarkGray
Write-Host "Total: $($nichos.Count) nichos | MOVER_AGORA: $($index.resumo.MOVER_AGORA) | MONITORAR: $($index.resumo.MONITORAR)" -ForegroundColor DarkGray
Write-Host ""

# Modo: listar todos
if ($listar) {
    Write-Host "--- TODOS OS NICHOS (por fit_score) ---" -ForegroundColor Yellow
    $nichos | Sort-Object fit_score -Descending | ForEach-Object {
        $cor = if ($_.status -eq "MOVER_AGORA") { "Green" } else { "Yellow" }
        Write-Host ("  [{0:N1}] {1,-45} [{2}]" -f $_.fit_score, $_.nome, $_.status) -ForegroundColor $cor
        Write-Host ("        Setor: {0}" -f $_.setor) -ForegroundColor DarkGray
        Write-Host ("        Tags:  {0}" -f ($_.match_keywords -join ", ")) -ForegroundColor DarkGray
        Write-Host ""
    }
    exit 0
}

# Filtrar por status
if ($status) {
    $nichos = $nichos | Where-Object { $_.status -eq $status.ToUpper() }
}

# Filtrar por minScore
if ($minScore -gt 0) {
    $nichos = $nichos | Where-Object { $_.fit_score -ge $minScore }
}

# Scoring de match
$resultados = @()

foreach ($nicho in $nichos) {
    $score = 0
    $matches = @()

    # Match por setor
    if ($setor) {
        $setorLower = $setor.ToLower()
        foreach ($s in $nicho.match_setores) {
            if ($s.ToLower() -like "*$setorLower*" -or $setorLower -like "*$s*") {
                $score += 3
                $matches += "setor:$s"
                break
            }
        }
        if ($nicho.setor.ToLower() -like "*$setorLower*") {
            $score += 2
            $matches += "setor_macro:$($nicho.setor)"
        }
    }

    # Match por tags
    if ($tags) {
        $tagList = $tags.ToLower() -split ","
        foreach ($tag in $tagList) {
            $tag = $tag.Trim()
            foreach ($kw in $nicho.match_keywords) {
                if ($kw.ToLower() -like "*$tag*" -or $tag -like "*$kw*") {
                    $score += 2
                    $matches += "kw:$kw"
                    break
                }
            }
        }
    }

    # Sem filtro: incluir todos com score base pelo fit_score
    if (-not $setor -and -not $tags) {
        $score = [int]($nicho.fit_score * 10)
    }

    if ($score -gt 0) {
        $resultados += [PSCustomObject]@{
            id          = $nicho.id
            nome        = $nicho.nome
            status      = $nicho.status
            fit_score   = $nicho.fit_score
            match_score = $score
            matches     = $matches
            setor       = $nicho.setor
            cowork      = $nicho.cowork_densidade
            urgencia    = $nicho.urgencia_regulatoria
            arquivo     = $nicho.arquivo_modelo
        }
    }
}

if ($resultados.Count -eq 0) {
    Write-Host "Nenhum nicho encontrado para os criterios informados." -ForegroundColor Yellow
    Write-Host "Use -listar para ver todos os nichos disponiveis." -ForegroundColor DarkGray
    exit 0
}

# Ordenar por match_score DESC, fit_score DESC
$resultados = @($resultados | Sort-Object @{e="match_score";d=$true}, @{e="fit_score";d=$true})

Write-Host "--- NICHOS ENCONTRADOS: $($resultados.Count) resultado(s) ---" -ForegroundColor Yellow
Write-Host ""

$rank = 1
foreach ($r in $resultados) {
    $statusCor = if ($r.status -eq "MOVER_AGORA") { "Green" } else { "Yellow" }
    $urgenciaCor = if ($r.urgencia -eq "ESTRUTURAL") { "Red" } elseif ($r.urgencia -eq "ALTA") { "Yellow" } else { "White" }

    Write-Host "#$rank  [fit $($r.fit_score)] $($r.nome)" -ForegroundColor $statusCor
    Write-Host "      Status: $($r.status) | Urgencia: $($r.urgencia) | Cowork: $($r.cowork)" -ForegroundColor DarkGray

    if ($r.matches.Count -gt 0) {
        Write-Host "      Match: $($r.matches -join ' | ')" -ForegroundColor Cyan
    }

    if ($detalhado) {
        $modelPath = Join-Path $PSScriptRoot "..\PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\$($r.arquivo)"
        if (Test-Path $modelPath) {
            $model = Get-Content $modelPath -Raw | ConvertFrom-Json
            Write-Host "      Argumento: $($model.roi_vanguard.argumento_numerico)" -ForegroundColor White
        }
    }

    Write-Host "      Arquivo: $($r.arquivo)" -ForegroundColor DarkGray
    Write-Host ""
    $rank++
}

Write-Host "Para modelo completo: cat PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/NICHE_MODELS/[id]_MODEL.json" -ForegroundColor DarkGray
Write-Host "Para todos: .\scripts\match_niche.ps1 -listar" -ForegroundColor DarkGray
