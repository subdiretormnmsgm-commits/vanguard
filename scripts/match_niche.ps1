# match_niche.ps1 — Cruza prospect com NICHE_INDEX para identificar nicho mais provavel
# Uso: .\scripts\match_niche.ps1 -Keywords "ANVISA,industria,recall" -Setor "alimentos"
# Uso: .\scripts\match_niche.ps1 -Descricao "empresa de contabilidade preocupada com ECD"

param(
    [string]$Keywords = "",
    [string]$Setor = "",
    [string]$Descricao = "",
    [switch]$SomenteAtivos,
    [int]$Top = 5
)

$indexPath = "PENTALATERAL_UNIVERSAL\INTELLIGENCE_HUB\NICHE_INDEX.json"
if (-not (Test-Path $indexPath)) {
    Write-Error "NICHE_INDEX.json nao encontrado em $indexPath"
    exit 1
}

$index = Get-Content $indexPath -Raw -Encoding UTF8 | ConvertFrom-Json

# Extrair termos de busca
$termsBusca = @()
if ($Keywords) { $termsBusca += $Keywords -split "," | ForEach-Object { $_.Trim().ToLower() } }
if ($Setor) { $termsBusca += $Setor.ToLower() }
if ($Descricao) { $termsBusca += $Descricao.ToLower() -split " " | Where-Object { $_.Length -gt 3 } }

if ($termsBusca.Count -eq 0) {
    Write-Host "Uso: .\scripts\match_niche.ps1 -Keywords 'ECD,contador,SPED' [-Setor 'contabilidade'] [-SomenteAtivos]"
    exit 0
}

Write-Host ""
Write-Host "=== MATCH NICHE — VANGUARD IAH ==="
Write-Host "Termos buscados: $($termsBusca -join ', ')"
Write-Host ""

$resultados = @()

foreach ($nicho in $index.nichos) {
    if ($SomenteAtivos -and $nicho.status -ne "MOVER_AGORA") { continue }
    
    $score = 0
    $matches = @()
    
    # Match em keywords
    foreach ($kw in $nicho.match_keywords) {
        foreach ($termo in $termsBusca) {
            if ($kw.ToLower().Contains($termo) -or $termo.Contains($kw.ToLower())) {
                $score += 3
                $matches += "keyword:$kw"
            }
        }
    }
    
    # Match em setores
    foreach ($s in $nicho.match_setores) {
        foreach ($termo in $termsBusca) {
            if ($s.ToLower().Contains($termo) -or $termo.Contains($s.ToLower())) {
                $score += 2
                $matches += "setor:$s"
            }
        }
    }
    
    # Match em nome/subsetor
    foreach ($termo in $termsBusca) {
        if ($nicho.nome.ToLower().Contains($termo)) {
            $score += 1
            $matches += "nome"
        }
        if ($nicho.subsetor.ToLower().Contains($termo)) {
            $score += 1
            $matches += "subsetor"
        }
    }
    
    if ($score -gt 0) {
        $resultados += [PSCustomObject]@{
            Score = $score
            ID = $nicho.id
            Nome = $nicho.nome
            Status = $nicho.status
            FitScore = $nicho.fit_score
            Urgencia = $nicho.urgencia_regulatoria
            Matches = ($matches | Select-Object -Unique) -join " | "
            ArquivoModelo = $nicho.arquivo_modelo
        }
    }
}

$resultados = $resultados | Sort-Object -Property Score -Descending | Select-Object -First $Top

if ($resultados.Count -eq 0) {
    Write-Host "Nenhum nicho encontrado para os termos buscados."
    Write-Host "Sugestao: ampliar os termos ou verificar NICHE_INDEX.json"
    exit 0
}

Write-Host "TOP $($resultados.Count) NICHOS IDENTIFICADOS:"
Write-Host ""

$rank = 1
foreach ($r in $resultados) {
    $statusIcon = if ($r.Status -eq "MOVER_AGORA") { "[MOVER_AGORA]" } else { "[MONITORAR]" }
    $urgIcon = if ($r.Urgencia -eq "CRITICA") { "!! " } elseif ($r.Urgencia -eq "ALTA") { "!  " } else { "   " }
    Write-Host "$urgIcon #$rank — $($r.Nome)"
    Write-Host "     Status: $statusIcon | Fit: $($r.FitScore) | Urgencia: $($r.Urgencia)"
    Write-Host "     Match: $($r.Matches)"
    Write-Host "     Modelo: $($r.ArquivoModelo)"
    Write-Host ""
    $rank++
}

Write-Host "=== FIM DO MATCH ==="
