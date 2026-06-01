# marcar_confirmados.ps1
# P-092 -- Processa resposta SIM/NAO do Diretor e marca [x] no PENDENTES.md
# Uso: .\marcar_confirmados.ps1 -Resposta "1-SIM 2-NAO 3-SIM"
#      .\marcar_confirmados.ps1 -Resposta "TODOS SIM"
#      .\marcar_confirmados.ps1 -Resposta "TODOS NAO"
#
# Requer que verificar_estado_autonomo.ps1 tenha rodado antes (lista numerada de externos)

param(
    [Parameter(Mandatory)]
    [string]$Resposta
)

$projectDir = Split-Path -Parent $PSScriptRoot

# ---------------------------------------------------------------------------
# REPRODUCED EXTERNAL DETECTION (mesmo criterio do verificar_estado_autonomo)
# ---------------------------------------------------------------------------
$PADROES_EXTERNOS = @(
    'Eduardo segue', 'Eduardo ajusta', 'Eduardo roda', 'Eduardo envia',
    'arrastar', 'Arrastar',
    'seguir link', 'link no e-mail', 'revogar token',
    'Claude Projects',
    'WhatsApp', 'Telegram',
    '! supabase login',
    'ajusta e envia',
    'colar mensagem',
    'upload'
)

function Test-EhExterno([string]$texto) {
    foreach ($pat in $PADROES_EXTERNOS) {
        if ($texto -match [regex]::Escape($pat)) { return $true }
    }
    return $false
}

# Ler externos na ordem (mesma logica do verificar_estado_autonomo)
$pendPath = Join-Path $projectDir "PENDENTES.md"
if (-not (Test-Path $pendPath)) {
    Write-Host "ERRO: PENDENTES.md nao encontrado em $pendPath"
    exit 1
}

$linhas = Get-Content $pendPath -Encoding UTF8

$hoje  = [datetime]::Today
$externasOrdenadas = [System.Collections.ArrayList]@()

$i = 0
while ($i -lt $linhas.Count) {
    $l = $linhas[$i]
    if ($l -match 'YYYY-MM-DD' -or $l -match 'descri') { $i++; continue }
    if ($l -match '^\s*- \[ \]') {
        $dataMatch = [regex]::Match($l, '`(\d{4}-\d{2}-\d{2})`')
        $dataPend  = if ($dataMatch.Success) {
            try { [datetime]$dataMatch.Groups[1].Value } catch { $hoje }
        } else { $hoje }
        $atraso = ($hoje.Date - $dataPend.Date).Days

        $titulo = $l -replace '^\s*- \[ \]\s*`[^`]+`\s*', '' `
                     -replace '\*\*([^*]+)\*\*', '$1' `
                     -replace '\*', ''

        $contexto = ""
        $j = $i + 1
        $subCount = 0
        while ($j -lt $linhas.Count -and $subCount -lt 4) {
            $next = $linhas[$j]
            if ($next -match '^\s*- \[') { break }
            if ($next -match '^#{1,3} ')  { break }
            if ($next.Trim() -ne '') { $contexto += " " + $next.Trim(); $subCount++ }
            $j++
        }

        if (Test-EhExterno ($titulo + " " + $contexto)) {
            [void]$externasOrdenadas.Add([PSCustomObject]@{
                Titulo = $titulo.Trim()
                Atraso = $atraso
                Linha  = $l
            })
        }
    }
    $i++
}

# Ordenar igual ao script de verificacao (por atraso descending)
$externasOrdenadas = @($externasOrdenadas | Sort-Object Atraso -Descending)

if ($externasOrdenadas.Count -eq 0) {
    Write-Host "Nenhuma acao externa encontrada no PENDENTES.md."
    exit 0
}

# ---------------------------------------------------------------------------
# PARSEAR RESPOSTA
# ---------------------------------------------------------------------------
$respostas = @{}

if ($Resposta -match '^TODOS SIM$') {
    for ($k = 1; $k -le $externasOrdenadas.Count; $k++) { $respostas[$k] = $true }
}
elseif ($Resposta -match '^TODOS NAO$') {
    for ($k = 1; $k -le $externasOrdenadas.Count; $k++) { $respostas[$k] = $false }
}
else {
    # Formato: "1-SIM 2-NAO 3-SIM" ou "1-SIM, 2-NAO"
    $tokens = $Resposta -split '[\s,;]+'
    foreach ($token in $tokens) {
        if ($token -match '^(\d+)-(SIM|NAO|S|N)$') {
            $num = [int]$matches[1]
            $val = $matches[2] -match '^S'
            $respostas[$num] = [bool]$val
        }
    }
}

# ---------------------------------------------------------------------------
# MARCAR [x] NO PENDENTES.md PARA CONFIRMADOS SIM
# ---------------------------------------------------------------------------
$linhasAtuais = Get-Content $pendPath -Encoding UTF8
$modificados  = 0

foreach ($num in ($respostas.Keys | Sort-Object)) {
    if (-not $respostas[$num]) { continue }  # NAO -- nao marcar
    $idx = $num - 1
    if ($idx -ge $externasOrdenadas.Count) { continue }

    $linhaAlvo = $externasOrdenadas[$idx].Linha
    $tituloAlvo = $externasOrdenadas[$idx].Titulo

    # Encontrar e substituir no arquivo
    for ($k = 0; $k -lt $linhasAtuais.Count; $k++) {
        if ($linhasAtuais[$k] -eq $linhaAlvo) {
            $linhasAtuais[$k] = $linhasAtuais[$k] -replace '^\s*- \[ \]', '- [x]'
            # Adicionar sufixo de data de confirmacao
            if ($linhasAtuais[$k] -notmatch '\[CONF:') {
                $linhasAtuais[$k] = $linhasAtuais[$k] + " [CONF: $(Get-Date -Format 'dd/MM HH:mm') -- Diretor confirmou]"
            }
            $modificados++
            Write-Host "  [x] $tituloAlvo"
            break
        }
    }
}

if ($modificados -gt 0) {
    $linhasAtuais | Set-Content $pendPath -Encoding UTF8
    Write-Host ""
    Write-Host "PENDENTES.md atualizado -- $modificados item(ns) marcado(s) [x]"
    Write-Host "Musculo atualiza WIP_BOARD e documentos dependentes agora."
} else {
    Write-Host "Nenhum item marcado (todos NAO ou numeros invalidos)."
}
