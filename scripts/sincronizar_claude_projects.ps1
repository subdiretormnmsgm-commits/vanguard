# sincronizar_claude_projects.ps1 -- Gate 9B do session_close
# Lista arquivos a fazer upload no Claude Projects por projeto ativo
# Chamado automaticamente pelo session_close.ps1
# P-032: MEMORIA_EMBAIXADOR deve ser atualizada apos deliberacao
# Uso: .\scripts\sincronizar_claude_projects.ps1 -projetos @("INGRID","VALDECE")

param([string[]]$projetos = @())

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE   = Split-Path -Parent $PSScriptRoot
$agora  = [datetime]::Now
$DATA   = Get-Date -Format "dd-MM-yyyy"
$DS     = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))

# Se nao recebeu projetos, ler do WIP_BOARD
if ($projetos.Count -eq 0) {
    $wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
    if (Test-Path $wipPath) {
        try {
            $board = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
            $projetos = @($board.board.build | ForEach-Object { $_.cliente.ToUpper() })
        } catch {}
    }
}

if ($projetos.Count -eq 0) {
    Write-Host "  [SYNC-CP] Nenhum projeto ativo -- ignorando." -ForegroundColor DarkGray
    exit 0
}

Write-Host ""
Write-Host "  [SYNC-CP] Verificando Claude Projects..." -ForegroundColor Cyan

$uploadsNecessarios = [System.Collections.ArrayList]@()

foreach ($proj in $projetos) {

    # 1. MEMORIA_EMBAIXADOR.md -- atualizada nesta sessao?
    $memoriaPath = Join-Path $BASE "CLIENTES\$proj\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
    if (Test-Path $memoriaPath) {
        $modificado = (Get-Item $memoriaPath).LastWriteTime
        $minutos    = ($agora - $modificado).TotalMinutes
        if ($minutos -le 120) {
            [void]$uploadsNecessarios.Add([PSCustomObject]@{
                Projeto    = $proj
                Arquivo    = "MEMORIA_EMBAIXADOR.md"
                Caminho    = $memoriaPath
                Prioridade = "CRITICO"
                Motivo     = "Atualizada nesta sessao -- P-032 ativo"
            })
        } else {
            Write-Host "  [SYNC-CP] $proj MEMORIA_EMBAIXADOR -- sem alteracao." -ForegroundColor DarkGray
        }
    }

    # 2. INTELLIGENCE_LEDGER.md -- hash igual ao do Claude Project?
    $ledgerRaiz    = Join-Path $BASE "INTELLIGENCE_LEDGER.md"
    $ledgerProjeto = Join-Path $BASE "CLIENTES\$proj\CLAUDE_PROJECT\06_INTELLIGENCE_LEDGER.md"
    if ((Test-Path $ledgerRaiz) -and (Test-Path $ledgerProjeto)) {
        try {
            $hashRaiz    = (Get-FileHash $ledgerRaiz    -Algorithm SHA256).Hash
            $hashProjeto = (Get-FileHash $ledgerProjeto -Algorithm SHA256).Hash
            if ($hashRaiz -ne $hashProjeto) {
                [void]$uploadsNecessarios.Add([PSCustomObject]@{
                    Projeto    = $proj
                    Arquivo    = "06_INTELLIGENCE_LEDGER.md"
                    Caminho    = $ledgerProjeto
                    Prioridade = "ALTO"
                    Motivo     = "LEDGER desatualizado no Claude Project (sincronizar e re-upload)"
                })
            } else {
                Write-Host "  [SYNC-CP] $proj LEDGER -- hash identico." -ForegroundColor DarkGray
            }
        } catch {}
    }

    # 3. WIP_BOARD.json -- modificado nesta sessao?
    $wipPath = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
    if (Test-Path $wipPath) {
        $wipModificado = (Get-Item $wipPath).LastWriteTime
        $minWip = ($agora - $wipModificado).TotalMinutes
        if ($minWip -le 120) {
            [void]$uploadsNecessarios.Add([PSCustomObject]@{
                Projeto    = $proj
                Arquivo    = "WIP_BOARD.json"
                Caminho    = $wipPath
                Prioridade = "MEDIO"
                Motivo     = "WIP_BOARD atualizado nesta sessao"
            })
        }
    }
}

# Exibir resultado
if ($uploadsNecessarios.Count -gt 0) {
    $criticos = @($uploadsNecessarios | Where-Object { $_.Prioridade -eq "CRITICO" })
    $altos    = @($uploadsNecessarios | Where-Object { $_.Prioridade -eq "ALTO"    })
    $medios   = @($uploadsNecessarios | Where-Object { $_.Prioridade -eq "MEDIO"   })

    Write-Host ""
    Write-Host "  +----------------------------------------------------+" -ForegroundColor Yellow
    Write-Host "    UPLOADS NECESSARIOS NO CLAUDE PROJECTS"               -ForegroundColor Yellow
    Write-Host "    Eduardo -- arrastar estes arquivos:"                   -ForegroundColor Yellow
    Write-Host "  +----------------------------------------------------+" -ForegroundColor Yellow

    if ($criticos.Count -gt 0) {
        Write-Host ""
        Write-Host "    [CRITICO] obrigatorio esta sessao:" -ForegroundColor Red
        foreach ($u in $criticos) {
            Write-Host "      $($u.Projeto): $($u.Arquivo)"
            Write-Host "      Caminho: $($u.Caminho)"
            Write-Host "      Motivo : $($u.Motivo)"
        }
    }
    if ($altos.Count -gt 0) {
        Write-Host ""
        Write-Host "    [ALTO] recomendado esta sessao:" -ForegroundColor Yellow
        foreach ($u in $altos) {
            Write-Host "      $($u.Projeto): $($u.Arquivo)"
            Write-Host "      Motivo : $($u.Motivo)"
        }
    }
    if ($medios.Count -gt 0) {
        Write-Host ""
        Write-Host "    [MEDIO] pode aguardar proxima sessao:" -ForegroundColor Cyan
        foreach ($u in $medios) {
            Write-Host "      $($u.Projeto): $($u.Arquivo)"
        }
    }

    Write-Host ""
    Write-Host "  +----------------------------------------------------+" -ForegroundColor Yellow

    # Registrar CRITICOS em PENDENTES.md
    $pendPath = Join-Path $BASE "PENDENTES.md"
    if (Test-Path $pendPath) {
        $pendContent = Get-Content $pendPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        foreach ($u in $criticos) {
            $entrada = "- [CLAUDE_PROJECTS ($DATA $DS)] $($u.Projeto) -- upload: $($u.Arquivo)"
            $pattern = "CLAUDE_PROJECTS.*$($u.Projeto)"
            if (-not ($pendContent -match $pattern)) {
                Add-Content $pendPath "`n$entrada" -Encoding UTF8
            }
        }
    }

    # Marcar flag no WIP_BOARD.json
    $wipPath2 = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
    if (Test-Path $wipPath2) {
        try {
            $wip2 = Get-Content $wipPath2 -Raw -Encoding UTF8 | ConvertFrom-Json
            if ($wip2.meta) {
                $wip2.meta | Add-Member -NotePropertyName "claude_projects_pendente" `
                    -NotePropertyValue $true -Force
                $wip2 | ConvertTo-Json -Depth 15 | Set-Content $wipPath2 -Encoding UTF8
            }
        } catch {}
    }

} else {
    Write-Host "  [SYNC-CP] Claude Projects sincronizado -- nenhum upload necessario." -ForegroundColor Green

    # Limpar flag
    $wipPath2 = Join-Path $BASE "CLIENTES\WIP_BOARD.json"
    if (Test-Path $wipPath2) {
        try {
            $wip2 = Get-Content $wipPath2 -Raw -Encoding UTF8 | ConvertFrom-Json
            if ($wip2.meta -and ($null -ne $wip2.meta.claude_projects_pendente)) {
                $wip2.meta.claude_projects_pendente = $false
                $wip2 | ConvertTo-Json -Depth 15 | Set-Content $wipPath2 -Encoding UTF8
            }
        } catch {}
    }
}
