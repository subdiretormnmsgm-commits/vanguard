#Requires -Version 5.1
# skill_gate.ps1 -- P-180: gate mecanico de invocacao de skill por ETAPA do processo.
# Origem: FALHA-PROCESSO-2026-06-16 -- skill nao invocada nos gatilhos do processo (6 ocorrencias).
#   Causa: o Musculo invocava skill por memoria/decisao, nao por gatilho mecanico (DEF-M-6).
#
# Fonte de verdade: scripts/skill_gatilhos_map.json (etapa -> skill obrigatoria + gatilhos).
#
# MODOS:
#   -Listar             Tabela completa ETAPA -> SKILL (consumido pelo session_start na abertura).
#   -Etapa <nome>       Skill obrigatoria de uma etapa (match parcial no nome da etapa).
#   -Detectar "<texto>" Casa o texto contra os gatilhos e diz qual skill invocar AGORA.
#                       Uso tipico: passar a frase do Diretor para descobrir a etapa.
#
# exit 0 sempre (informativo -- nunca bloqueia, so declara o que e obrigatorio).

param(
    [switch]$Listar,
    [string]$Etapa = "",
    [string]$Detectar = ""
)

$BASE    = Split-Path -Parent $PSScriptRoot
$mapPath = Join-Path $PSScriptRoot "skill_gatilhos_map.json"

if (-not (Test-Path $mapPath)) {
    Write-Output "[ERRO] skill_gatilhos_map.json ausente em scripts/. Mapa de skills por etapa nao encontrado."
    exit 0
}

try {
    $map = Get-Content $mapPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Output "[ERRO] skill_gatilhos_map.json invalido: $($_.Exception.Message)"
    exit 0
}

$etapas = @($map.etapas)

function Format-Etapa($e) {
    $linhas = @()
    $dep = if ($e.dependencia) { "  (dep: $($e.dependencia))" } else { "" }
    # skills da etapa: skill_obrigatoria (unica) + skills_obrigatorias (lista)
    $skills = @()
    if ("$($e.skill_obrigatoria)".Trim() -ne "") { $skills += "$($e.skill_obrigatoria)".Trim() }
    if ($e.skills_obrigatorias) {
        foreach ($s in @($e.skills_obrigatorias)) { if ("$s".Trim() -ne "") { $skills += "$s".Trim() } }
    }
    $linhas += "  [$($e.etapa)]"
    $linhas += "     SKILL(S) OBRIGATORIA(S): $(($skills) -join ' + ')$dep"
    if ($e.nota_extra) { $linhas += "     NOTA: $($e.nota_extra)" }
    $linhas += "     ACAO: $($e.acao)"
    $linhas += "     SE PULAR: $($e.falha_se_pular)"
    $linhas += "     GATILHOS: $((@($e.gatilhos)) -join ' | ')"
    return $linhas -join "`n"
}

# ----------------------------------------------------------------------------
# -Detectar: casa texto contra gatilhos
# ----------------------------------------------------------------------------
if ($Detectar -ne "") {
    $txt = $Detectar.ToLower()
    $casaram = @()
    foreach ($e in $etapas) {
        foreach ($g in @($e.gatilhos)) {
            if ($txt -like "*$($g.ToLower())*") { $casaram += $e; break }
        }
    }
    if ($casaram.Count -eq 0) {
        Write-Output "[skill_gate] Nenhum gatilho de etapa casou com o texto. Nenhuma skill obrigatoria detectada."
        exit 0
    }
    Write-Output "SKILL OBRIGATORIA DETECTADA (P-180) -- invocar ANTES de qualquer acao:"
    Write-Output ""
    foreach ($e in $casaram) { Write-Output (Format-Etapa $e); Write-Output "" }
    exit 0
}

# ----------------------------------------------------------------------------
# -Etapa: skill de uma etapa especifica
# ----------------------------------------------------------------------------
if ($Etapa -ne "") {
    $alvo = $etapas | Where-Object { $_.etapa -like "*$Etapa*" }
    if (-not $alvo) {
        Write-Output "[skill_gate] Etapa '$Etapa' nao encontrada. Etapas: $((@($etapas | ForEach-Object { $_.etapa })) -join ', ')"
        exit 0
    }
    foreach ($e in @($alvo)) { Write-Output (Format-Etapa $e); Write-Output "" }
    exit 0
}

# ----------------------------------------------------------------------------
# -Listar (default): tabela completa
# ----------------------------------------------------------------------------
Write-Output "REGRA P-180: skill por GATILHO MECANICO, nunca por memoria. 1% de chance de aplicar = invocar."
Write-Output "Consulte por etapa: .\scripts\skill_gate.ps1 -Etapa PASSO5"
Write-Output 'Detecte pela frase:  .\scripts\skill_gate.ps1 -Detectar "vamos ao notebooklm"'
Write-Output ""
foreach ($e in $etapas) {
    Write-Output (Format-Etapa $e)
    Write-Output ""
}
exit 0
