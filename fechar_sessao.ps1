# PENTALATERAL IAH — Ritual de Fechamento
# Uso: .\fechar_sessao.ps1
# Uso: .\fechar_sessao.ps1 -Sessao "V25-valdece" -Projeto valdece

param(
    [string]$Sessao = "",
    [string]$Projeto = "vanguard"
)

Set-Location "$PSScriptRoot\pentalateral"
if ($Sessao) {
    python scripts\session_close.py --sessao $Sessao --projeto $Projeto
} else {
    python scripts\session_close.py --projeto $Projeto
}
Set-Location $PSScriptRoot
