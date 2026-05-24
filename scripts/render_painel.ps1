#Requires -Version 5.1
# render_painel.ps1 — Lê DECISOES JSON do Embaixador e gera Painel HTML interativo
# Uso: .\scripts\render_painel.ps1 -projeto INGRID
#      .\scripts\render_painel.ps1 -projeto VALDECE -data 2026-05-24

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("INGRID","VALDECE")]
    [string]$projeto,

    [string]$data = ""
)

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$decisoesDir = "CLIENTES\$projeto\CLAUDE_PROJECT\DECISOES"
$templatePath = "scripts\painel_template.html"

# --- 1. Localizar arquivo DECISOES ---
if ($data -eq "") {
    $files = Get-ChildItem "$decisoesDir\DECISOES_*.json" -ErrorAction SilentlyContinue |
             Sort-Object LastWriteTime -Descending
    if (-not $files) {
        Write-Error "Nenhum arquivo DECISOES_*.json encontrado em: $decisoesDir"
        Write-Host "O Embaixador deve gerar o arquivo DECISOES e Eduardo salvar nessa pasta."
        exit 1
    }
    $decisoesFile = $files[0].FullName
    Write-Host "Usando arquivo mais recente: $($files[0].Name)"
} else {
    $decisoesFile = "$decisoesDir\DECISOES_${projeto}_${data}.json"
    if (-not (Test-Path $decisoesFile)) {
        Write-Error "Arquivo não encontrado: $decisoesFile"
        exit 1
    }
}

# --- 2. Ler e validar JSON ---
try {
    $decisoesRaw = Get-Content $decisoesFile -Raw -Encoding UTF8
    $decisoesObj = $decisoesRaw | ConvertFrom-Json
} catch {
    Write-Error "JSON inválido em $decisoesFile`: $_"
    exit 1
}

$dataStr   = $decisoesObj.data
$projetoLabel = $decisoesObj.projeto_label
$loop      = $decisoesObj.loop
$nDecisoes = $decisoesObj.decisoes.Count

Write-Host ""
Write-Host "Projeto : $projetoLabel"
Write-Host "Data    : $dataStr"
Write-Host "Loop    : $loop"
Write-Host "Decisões: $nDecisoes"
Write-Host ""

# --- 3. Ler template HTML ---
if (-not (Test-Path $templatePath)) {
    Write-Error "Template não encontrado: $templatePath"
    Write-Host "Certifique-se de que scripts\painel_template.html existe no repositório."
    exit 1
}

$templateHtml = Get-Content $templatePath -Raw -Encoding UTF8

# --- 4. Substituir placeholder com os dados JSON ---
$decisoesJsonEscaped = $decisoesRaw  # JSON puro — JS vai parsear diretamente

$html = $templateHtml `
    -replace '__DECISOES_DATA__', $decisoesJsonEscaped `
    -replace '__PROJETO_LABEL__', $projetoLabel `
    -replace '__DATA__',          $dataStr

# --- 5. Escrever arquivo HTML ---
$painelPath = "$decisoesDir\PAINEL_${projeto}_${dataStr}.html"
$html | Out-File -FilePath $painelPath -Encoding utf8NoBOM
Write-Host "Painel gerado: $painelPath"

# --- 6. Abrir no browser ---
Start-Process $painelPath
Write-Host ""
Write-Host "Painel aberto no browser."
Write-Host ""
Write-Host "PRÓXIMOS PASSOS:"
Write-Host "  1. Marque todos os vereditos no painel"
Write-Host "  2. Clique em 'Confirmar vereditos'"
Write-Host "  3. Salve o arquivo VEREDITOS_${projeto}_${dataStr}.json em:"
Write-Host "     CLIENTES\$projeto\CLAUDE_PROJECT\DECISOES\"
Write-Host "  4. Rode: .\scripts\executar_vereditos.ps1 -projeto $projeto"
