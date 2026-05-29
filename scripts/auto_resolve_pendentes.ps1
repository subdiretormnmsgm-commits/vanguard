#Requires -Version 5.1
# auto_resolve_pendentes.ps1 - P-087: Acoplamento commit -> PENDENTES.md
# Chamado pelo .git/hooks/post-commit quando mensagem contem [RESOLVE: ...]
# Guard anti-loop: o hook bash verifica [AUTO-RESOLVE] antes de chamar este script.
# NUNCA chamar manualmente -- apenas via hook.

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$raiz  = Split-Path -Parent $PSScriptRoot
Push-Location $raiz

try {
    # Le mensagem do ultimo commit -- join necessario: git retorna array de linhas no PS5.1
    $commitLines = git log -1 --pretty=%B 2>$null
    $commitMsg   = if ($commitLines -is [array]) { $commitLines -join ' ' } else { [string]$commitLines }
    if (-not $commitMsg.Trim()) { exit 0 }

    # Extrai keywords do [RESOLVE: ...]
    if ($commitMsg -notmatch '\[RESOLVE:\s*([^\]]+)\]') { exit 0 }
    $keywords = $Matches[1] -split ',' |
                ForEach-Object { $_.Trim() } |
                Where-Object { $_ -ne '' }
    if ($keywords.Count -eq 0) { exit 0 }

    $pendPath = Join-Path $raiz 'PENDENTES.md'
    if (-not (Test-Path $pendPath)) {
        Write-Host "[AUTO-RESOLVE] PENDENTES.md nao encontrado -- abortando"
        exit 0
    }

    # Le linhas preservando encoding original
    $content  = Get-Content $pendPath -Encoding UTF8
    $modified = $false
    $resolved = [System.Collections.ArrayList]@()

    foreach ($kw in $keywords) {
        $kwEsc = [regex]::Escape($kw)
        for ($i = 0; $i -lt $content.Count; $i++) {
            $line = $content[$i]
            if ($line -match '^\s*-\s*\[\s*\]' -and $line -match $kwEsc) {
                $content[$i] = $line -replace '^\s*-\s*\[\s*\]', '- [x]'
                [void]$resolved.Add($kw)
                $modified = $true
                break
            }
        }
    }

    if (-not $modified) {
        Write-Host "[AUTO-RESOLVE] Nenhum item aberto encontrado para: $($keywords -join ', ')"
        exit 0
    }

    # Escreve PENDENTES.md sem BOM (consistente com o restante do projeto)
    [System.IO.File]::WriteAllLines($pendPath, $content, [System.Text.UTF8Encoding]::new($false))
    Write-Host "[AUTO-RESOLVE] PENDENTES.md atualizado: $($resolved -join ', ') -> [x]"

    # Commit separado (nao amend) -- evita reescrita de historico e loop infinito
    # O hook bash detecta [AUTO-RESOLVE] e nao reprocessa este commit
    $kwList = $resolved -join ', '
    git add 'PENDENTES.md' 2>$null
    git commit -m "chore(pendentes): [AUTO-RESOLVE] $kwList" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[AUTO-RESOLVE] Commit criado com marcacao de: $kwList"
    } else {
        Write-Host "[AUTO-RESOLVE] AVISO: git commit falhou -- PENDENTES.md modificado em disco mas nao commitado"
    }

} finally {
    Pop-Location
}

exit 0
