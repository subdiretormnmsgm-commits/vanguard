# pncp_inabilitados_df.ps1
# BUILD 5 - Vanguard Pentalateral IAH - Loop 33
# Varredura de empresas inabilitadas no PNCP - Distrito Federal
# API publica: https://pncp.gov.br/api/pncp/swagger-ui/index.html
# Output: banco de leads (CNPJ + motivo + edital + data) em PENDING_REVIEW

param(
    [int]$DiasRetroativos  = 30,
    [string]$UF            = "DF",
    [string]$OutputDir     = "$PSScriptRoot\..\CLIENTES\VANGUARD\PENDING_REVIEW",
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$baseUrl = "https://pncp.gov.br/api/pncp/v1"

$dataFim   = Get-Date -Format "yyyyMMdd"
$dataIni   = (Get-Date).AddDays(-$DiasRetroativos) | Get-Date -Format "yyyyMMdd"

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  BUILD 5 - PNCP Inabilitados $UF - Varredura de Leads" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  Periodo: $dataIni ate $dataFim" -ForegroundColor White
Write-Host "  UF: $UF" -ForegroundColor White
Write-Host ""

# -------------------------------------------------------
# ETAPA 1 - Buscar atas de sessao encerradas no DF
# Endpoint: /atas-sessao (retorna atas com resultado)
# -------------------------------------------------------
Write-Host "[1/4] Buscando atas de sessao encerradas em $UF..." -ForegroundColor Yellow

$leads = @()
$pagina = 1
$tamPagina = 50
$totalProcessado = 0

do {
    $url = "$baseUrl/atas-sessao?dataInicial=$dataIni&dataFinal=$dataFim&uf=$UF&pagina=$pagina&tamanhoPagina=$tamPagina"

    try {
        $resp = Invoke-RestMethod -Uri $url -Method Get -Headers @{ "Accept" = "application/json" } -TimeoutSec 30
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404) { break }
        Write-Warning "Erro na pagina $pagina : $_"
        break
    }

    if ($null -eq $resp -or $null -eq $resp.data -or $resp.data.Count -eq 0) { break }

    foreach ($ata in $resp.data) {
        $totalProcessado++

        # Iterar participantes da ata
        if ($null -eq $ata.participantes) { continue }

        foreach ($part in $ata.participantes) {
            $situacao = $part.situacaoParticipante ?? $part.situacao ?? ""
            $motivo   = $part.motivoDesclassificacao ?? $part.motivoInabilitacao ?? $part.descricaoSituacao ?? ""

            # Filtrar apenas inabilitados/desclassificados
            $isInabilitado = $situacao -match "INABILIT|DESCLASSIFIC|IMPEDID|EXCLUIDO" -or
                             $motivo   -match "inabilit|desclassific|certidao|vencida|irregular|atestado|ausente"

            if (-not $isInabilitado) { continue }

            $leads += [PSCustomObject]@{
                Data            = ($ata.dataRealizacaoSessao ?? $ata.dataSessao ?? "") -replace "T.*",""
                CNPJ            = ($part.cnpj ?? $part.cpfCnpj ?? "N/D") -replace "\D",""
                RazaoSocial     = $part.razaoSocial ?? $part.nomeParticipante ?? "N/D"
                Situacao        = $situacao
                Motivo          = $motivo -replace "`n"," " -replace "`r",""
                NumeroEdital    = $ata.numeroEdital ?? $ata.numero ?? "N/D"
                OrgaoNome       = $ata.orgaoEntidade?.razaoSocial ?? $ata.orgaoNome ?? "N/D"
                ObjContratacao  = ($ata.objetoCompra ?? $ata.objeto ?? "N/D") -replace "`n"," "
                ValorEstimado   = $ata.valorTotalEstimado ?? $ata.valor ?? 0
                LinkAtaOriginal = "https://pncp.gov.br/app/editais/$($ata.codigoPncp ?? '')"
            }
        }
    }

    if ($Verbose) { Write-Host "  Pagina $pagina processada ($totalProcessado atas)" -ForegroundColor DarkGray }
    $pagina++

} while ($resp.data.Count -eq $tamPagina)

Write-Host "  $totalProcessado atas processadas. $($leads.Count) inabilitacoes encontradas." -ForegroundColor Green

# -------------------------------------------------------
# ETAPA 2 - Buscar contratos/editais encerrados como fallback
# Caso endpoint /atas-sessao nao retorne resultado
# -------------------------------------------------------
if ($leads.Count -eq 0) {
    Write-Host ""
    Write-Host "[2/4] Fallback: buscando editais encerrados em $UF..." -ForegroundColor Yellow

    $pagina = 1
    do {
        $url = "$baseUrl/contratacoes/publicacoes?dataInicial=$dataIni&dataFinal=$dataFim&uf=$UF&pagina=$pagina&tamanhoPagina=$tamPagina"

        try {
            $resp = Invoke-RestMethod -Uri $url -Method Get -Headers @{ "Accept" = "application/json" } -TimeoutSec 30
        } catch {
            if ($_.Exception.Response.StatusCode -eq 404) { break }
            Write-Warning "Fallback erro pagina $pagina : $_"
            break
        }

        if ($null -eq $resp -or $null -eq $resp.data -or $resp.data.Count -eq 0) { break }

        foreach ($ed in $resp.data) {
            if ($ed.situacaoCompraId -ne 8) { continue }  # 8 = encerrado

            $leads += [PSCustomObject]@{
                Data            = ($ed.dataPublicacaoPncp ?? "") -replace "T.*",""
                CNPJ            = "VER_ATAS"
                RazaoSocial     = "VER_ATAS_PNCP"
                Situacao        = "EDITAL_ENCERRADO"
                Motivo          = "Verificar ata no link"
                NumeroEdital    = $ed.numeroPncp ?? "N/D"
                OrgaoNome       = $ed.orgaoEntidade?.razaoSocial ?? "N/D"
                ObjContratacao  = ($ed.objetoCompra ?? "N/D") -replace "`n"," "
                ValorEstimado   = $ed.valorTotalEstimado ?? 0
                LinkAtaOriginal = "https://pncp.gov.br/app/editais/$($ed.numeroPncp ?? '')"
            }
        }

        $pagina++
    } while ($resp.data.Count -eq $tamPagina)

    Write-Host "  $($leads.Count) editais encerrados encontrados para analise manual." -ForegroundColor Green
}

# -------------------------------------------------------
# ETAPA 3 - Filtrar e classificar por prioridade comercial
# -------------------------------------------------------
Write-Host ""
Write-Host "[3/4] Classificando leads por prioridade..." -ForegroundColor Yellow

$leadsComCNPJ = $leads | Where-Object { $_.CNPJ -ne "VER_ATAS" -and $_.CNPJ.Length -ge 11 }

# Classificar por motivo de inabilitacao (prioridade para certidao/atestado)
foreach ($lead in $leadsComCNPJ) {
    $prioridade = "MEDIA"
    if ($lead.Motivo -match "certidao|vencida|irregular|fiscal|FGTS|previdencia") {
        $prioridade = "ALTA"   # Certidao vencida = dor exata que a Vanguard resolve
    } elseif ($lead.Motivo -match "atestado|tecnico|capacidade|qualificacao") {
        $prioridade = "ALTA"   # Atestado tecnico = segunda maior causa
    } elseif ($lead.Motivo -match "documento|ausente|faltante|incompleto") {
        $prioridade = "MEDIA"
    }
    $lead | Add-Member -NotePropertyName Prioridade -NotePropertyValue $prioridade -Force
}

$leadsAlta  = $leadsComCNPJ | Where-Object { $_.Prioridade -eq "ALTA"  } | Sort-Object Data -Descending
$leadsMedia = $leadsComCNPJ | Where-Object { $_.Prioridade -eq "MEDIA" } | Sort-Object Data -Descending

Write-Host "  ALTA prioridade : $($leadsAlta.Count)" -ForegroundColor Red
Write-Host "  MEDIA prioridade: $($leadsMedia.Count)" -ForegroundColor Yellow

# -------------------------------------------------------
# ETAPA 4 - Gerar arquivo de output em PENDING_REVIEW
# -------------------------------------------------------
Write-Host ""
Write-Host "[4/4] Gerando banco de leads em PENDING_REVIEW..." -ForegroundColor Yellow

$dataHoje = Get-Date -Format "yyyy-MM-dd"
$outputFile = "$OutputDir\BUILD5_LEADS_PNCP_$($dataHoje -replace '-','')_$UF.md"

if (-not (Test-Path $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null }

$sb = [System.Text.StringBuilder]::new()
$null = $sb.AppendLine("# BUILD 5 - BANCO DE LEADS PNCP - $UF")
$null = $sb.AppendLine("> Gerado por: pncp_inabilitados_df.ps1 - Loop 33 - $dataHoje")
$null = $sb.AppendLine("> Periodo: $dataIni a $dataFim | UF: $UF | Total leads: $($leads.Count)")
$null = $sb.AppendLine("> Status: PENDING_REVIEW - aguarda veredito Musculo")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("---")
$null = $sb.AppendLine("")

if ($leadsAlta.Count -gt 0) {
    $null = $sb.AppendLine("## PRIORIDADE ALTA - Certidao / Atestado ($($leadsAlta.Count) leads)")
    $null = $sb.AppendLine("> Usar script WhatsApp G-3 diretamente. Motivo documentado = argumento de abertura.")
    $null = $sb.AppendLine("")
    $null = $sb.AppendLine("| Data | CNPJ | Empresa | Motivo | Edital | Orgao | Valor Est. | Link |")
    $null = $sb.AppendLine("|---|---|---|---|---|---|---|---|")
    foreach ($l in $leadsAlta) {
        $cnpjFmt = if ($l.CNPJ.Length -eq 14) { "$($l.CNPJ.Substring(0,2)).$($l.CNPJ.Substring(2,3)).$($l.CNPJ.Substring(5,3))/$($l.CNPJ.Substring(8,4))-$($l.CNPJ.Substring(12,2))" } else { $l.CNPJ }
        $valor = if ($l.ValorEstimado -gt 0) { "R$ {0:N0}" -f [double]$l.ValorEstimado } else { "N/D" }
        $null = $sb.AppendLine("| $($l.Data) | $cnpjFmt | $($l.RazaoSocial -replace '\|','-') | $($l.Motivo.Substring(0,[Math]::Min(80,$l.Motivo.Length)) -replace '\|','-') | $($l.NumeroEdital) | $($l.OrgaoNome -replace '\|','-') | $valor | [Ver]($($l.LinkAtaOriginal)) |")
    }
    $null = $sb.AppendLine("")
}

if ($leadsMedia.Count -gt 0) {
    $null = $sb.AppendLine("## PRIORIDADE MEDIA ($($leadsMedia.Count) leads)")
    $null = $sb.AppendLine("")
    $null = $sb.AppendLine("| Data | CNPJ | Empresa | Motivo | Edital | Link |")
    $null = $sb.AppendLine("|---|---|---|---|---|---|")
    foreach ($l in $leadsMedia | Select-Object -First 20) {
        $cnpjFmt = if ($l.CNPJ.Length -eq 14) { "$($l.CNPJ.Substring(0,2)).$($l.CNPJ.Substring(2,3)).$($l.CNPJ.Substring(5,3))/$($l.CNPJ.Substring(8,4))-$($l.CNPJ.Substring(12,2))" } else { $l.CNPJ }
        $null = $sb.AppendLine("| $($l.Data) | $cnpjFmt | $($l.RazaoSocial -replace '\|','-') | $($l.Motivo.Substring(0,[Math]::Min(60,$l.Motivo.Length)) -replace '\|','-') | $($l.NumeroEdital) | [Ver]($($l.LinkAtaOriginal)) |")
    }
    $null = $sb.AppendLine("")
}

$null = $sb.AppendLine("---")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("## COMO USAR (G-3 Pitch Reverso)")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("1. Escolher lead ALTA prioridade")
$null = $sb.AppendLine("2. Buscar decisor no LinkedIn pelo CNPJ")
$null = $sb.AppendLine("3. Enviar script WhatsApp G-3 com referencia ao edital especifico:")
$null = $sb.AppendLine("   > 'Ola [Nome], vi que [Empresa] participou do edital [Numero] recentemente...")
$null = $sb.AppendLine("   > A Vanguard faz revisao preventiva de habilitacao antes do envio...")
$null = $sb.AppendLine("   > Quanto custou a ultima proposta que nao avancou?'")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("4. Meta: 1 empresa por dia nos proximos 5 dias uteis")
$null = $sb.AppendLine("")
$null = $sb.AppendLine("*Gerado por BUILD 5 - pncp_inabilitados_df.ps1 - Vanguard IAH - Loop 33*")

$sb.ToString() | Set-Content -Path $outputFile -Encoding UTF8

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  BUILD 5 CONCLUIDO" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  Output: $outputFile" -ForegroundColor White
Write-Host "  Leads ALTA : $($leadsAlta.Count)" -ForegroundColor Red
Write-Host "  Leads MEDIA: $($leadsMedia.Count)" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Proximo passo: rodar" -ForegroundColor White
Write-Host "  .\scripts\pncp_inabilitados_df.ps1" -ForegroundColor Cyan
Write-Host "  para gerar o banco de leads do dia" -ForegroundColor White
Write-Host ""
