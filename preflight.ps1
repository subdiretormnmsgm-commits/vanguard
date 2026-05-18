# QUADRILATERAL IAH — Pre-Flight Check
# Uso: .\preflight.ps1
# Uso: .\preflight.ps1 -Projeto valdece

param(
    [string]$Projeto = "vanguard"
)

Set-Location "$PSScriptRoot\quadrilateral"
python scripts\session_open.py --projeto $Projeto
Set-Location $PSScriptRoot
