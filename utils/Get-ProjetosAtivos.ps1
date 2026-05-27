# utils/Get-ProjetosAtivos.ps1
# Retorna todos os projetos ativos a partir do WIP_BOARD (dinamico)
# Substitui projetos_ativos hardcoded no DEPENDENCY_MAP (DEPRECATED)
# Uso: . utils\Get-ProjetosAtivos.ps1; $projetos = Get-ProjetosAtivos -WipPath "CLIENTES\WIP_BOARD.json"

function Get-ProjetosAtivos {
    param(
        [string]$WipPath = "CLIENTES\WIP_BOARD.json",
        [string[]]$Colunas = @("build", "check", "retainer")
    )

    if (-not (Test-Path $WipPath)) {
        Write-Warning "[Get-ProjetosAtivos] WIP_BOARD.json nao encontrado: $WipPath"
        return @()
    }

    try {
        $wip    = Get-Content $WipPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $ativos = [System.Collections.Generic.List[string]]::new()

        foreach ($col in $Colunas) {
            $projs = @($wip.board.$col)
            foreach ($p in $projs) {
                if ($p -and $p.cliente) {
                    $nome = $p.cliente.ToUpper()
                    if (-not $ativos.Contains($nome)) {
                        $ativos.Add($nome)
                    }
                }
            }
        }

        if ($ativos.Count -eq 0) {
            # Fallback: ler pastas CLIENTES/ diretamente
            Write-Warning "[Get-ProjetosAtivos] WIP_BOARD sem projetos nas colunas '$($Colunas -join ',')' -- fallback para pastas"
            $clDir = Split-Path $WipPath -Parent
            Get-ChildItem $clDir -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -ne "." } |
                ForEach-Object { $ativos.Add($_.Name.ToUpper()) }
        }

        return @($ativos)
    } catch {
        Write-Warning "[Get-ProjetosAtivos] Erro ao ler WIP_BOARD: $_"
        return @()
    }
}
