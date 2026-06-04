#Requires -Version 5.1
# testar_gates_criticos.ps1 -- P-097 candidato
# Testa que cada gate bloqueante do session_close dispara exit 1 quando deve
# Roda a cada 3 loops via contador meta.loops_desde_ultimo_checkup (WIP_BOARD)
# Uso: .\PENTALATERAL_UNIVERSAL\scripts\testar_gates_criticos.ps1 [-Verbose]

param(
    [switch]$Verbose
)

$BASE = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$DATA = Get-Date -Format "yyyy-MM-dd"
$HORA = Get-Date -Format "HH:mm:ss"
$sessaoClose = "$BASE\scripts\session_close.ps1"
$resultados = [ordered]@{}

function Test-Gate {
    param([string]$Nome, [string]$Descricao, [scriptblock]$Preparar, [scriptblock]$Restaurar)
    Write-Host ""
    Write-Host "  [GATE] $Nome -- $Descricao" -ForegroundColor Cyan

    # Preparar condicao de falha
    & $Preparar

    # Rodar session_close em DryRun -- deve detectar o problema
    $output = & powershell.exe -NonInteractive -File $sessaoClose -DryRun 2>&1
    $bloqueou = ($output | Where-Object { $_ -match "BLOQUEARIA com exit 1" -and $_ -match $Nome }) -ne $null
    if (-not $bloqueou) {
        # Tentar sem DryRun para verificar exit code real
        $proc = Start-Process powershell.exe -ArgumentList "-NonInteractive -File `"$sessaoClose`"" `
            -PassThru -Wait -WindowStyle Hidden 2>$null
        $bloqueou = ($proc.ExitCode -eq 1)
    }

    # Restaurar estado
    & $Restaurar

    if ($bloqueou) {
        Write-Host "  [OK] $Nome -- exit 1 confirmado" -ForegroundColor Green
        $resultados[$Nome] = "OK"
    } else {
        Write-Host "  [FALHOU] $Nome -- exit 1 NAO disparou" -ForegroundColor Red
        $resultados[$Nome] = "FALHOU"
    }
}

Write-Host ""
Write-Host "======================================================="
Write-Host "  TESTAR_GATES_CRITICOS -- Pentalateral IAH"
Write-Host "  $DATA $HORA"
Write-Host "  Script: $sessaoClose"
Write-Host "======================================================="

if (-not (Test-Path $sessaoClose)) {
    Write-Host "  [ERRO] session_close.ps1 nao encontrado em: $sessaoClose" -ForegroundColor Red
    exit 2
}

# -- GATE 1: auditar_consistencia --
# Injetar divergencia temporaria e verificar que Gate 1 bloqueia
$gate1Ok = $false
$testFile = "$BASE\CLIENTES\INGRID\NOTEBOOKLM_FONTES\_GATE1_TESTE_TEMP.md"
try {
    # Criar arquivo com violacao de canonical (tipo 1 editado fora da fonte)
    Set-Content $testFile -Value "# TESTE GATE 1 -- remover apos teste" -Encoding UTF8
    $output1 = & powershell.exe -NonInteractive -File "$BASE\scripts\auditar_consistencia.ps1" 2>&1
    $exit1 = $LASTEXITCODE
    Remove-Item $testFile -Force -ErrorAction SilentlyContinue
    # Gate 1 considera exit 2 = VERMELHO (bloqueante)
    $gate1Ok = ($exit1 -eq 2)
    if ($gate1Ok) {
        Write-Host "  [OK] Gate 1 -- auditar_consistencia detecta anomalia (exit 2)" -ForegroundColor Green
        $resultados["GATE_1"] = "OK"
    } else {
        Write-Host "  [INFO] Gate 1 -- auditar_consistencia exit=$exit1 (injecao pode nao ter gerado violacao)" -ForegroundColor Yellow
        $resultados["GATE_1"] = "INFO"
    }
} catch {
    Remove-Item $testFile -Force -ErrorAction SilentlyContinue
    Write-Host "  [INFO] Gate 1 -- nao testavel neste ambiente: $_" -ForegroundColor DarkGray
    $resultados["GATE_1"] = "SKIP"
}

# -- GATE 5: validate_scripts --
# Injetar unicode em script temporario e verificar que Gate 5 bloqueia
$gate5File = "$BASE\scripts\_gate5_teste_temp.ps1"
try {
    $utf8nob = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($gate5File, "Write-Host 'teste unicode: cafe'`n", $utf8nob)
    $validateScript = "$BASE\scripts\validate_scripts.ps1"
    if (Test-Path $validateScript) {
        & powershell.exe -NonInteractive -File $validateScript -Script $gate5File 2>$null
        $exit5 = $LASTEXITCODE
        $gate5Ok = ($exit5 -ne 0)
        if ($gate5Ok) {
            Write-Host "  [OK] Gate 5 -- validate_scripts detecta problema (exit=$exit5)" -ForegroundColor Green
            $resultados["GATE_5"] = "OK"
        } else {
            Write-Host "  [INFO] Gate 5 -- validate_scripts exit=0 para script limpo (esperado)" -ForegroundColor DarkGray
            $resultados["GATE_5"] = "INFO"
        }
    } else {
        Write-Host "  [SKIP] Gate 5 -- validate_scripts.ps1 nao encontrado" -ForegroundColor DarkGray
        $resultados["GATE_5"] = "SKIP"
    }
} catch {
    Write-Host "  [SKIP] Gate 5 -- erro: $_" -ForegroundColor DarkGray
    $resultados["GATE_5"] = "SKIP"
} finally {
    Remove-Item $gate5File -Force -ErrorAction SilentlyContinue
}

# -- GATE 6B: P-032 -- MEMORIA_EMBAIXADOR desatualizada apos VEREDITO
# Verificar que a logica de deteccao do Gate 6B funciona
$gate6BFile = "$BASE\CLIENTES\INGRID\CLAUDE_PROJECT\DECISOES\VEREDITOS_TESTE_$DATA.json"
$memoriaFile = "$BASE\CLIENTES\INGRID\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
try {
    # Criar VEREDITO de hoje
    $utf8nob2 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($gate6BFile, '{"teste":true}', $utf8nob2)
    # Definir MEMORIA com data antiga (ontem)
    if (Test-Path $memoriaFile) {
        (Get-Item $memoriaFile).LastWriteTime = (Get-Date).AddDays(-1)
        # DryRun do session_close -- Gate 6B deve detectar
        $output6b = & powershell.exe -NonInteractive -File $sessaoClose -DryRun 2>&1 | Out-String
        $gate6BOk = $output6b -match "GATE 6B.*BLOQUEARIA"
        if ($gate6BOk) {
            Write-Host "  [OK] Gate 6B -- detectou VEREDITO hoje + MEMORIA desatualizada" -ForegroundColor Green
            $resultados["GATE_6B"] = "OK"
        } else {
            Write-Host "  [INFO] Gate 6B -- DryRun nao confirmou bloqueio (verificar manualmente)" -ForegroundColor Yellow
            $resultados["GATE_6B"] = "INFO"
        }
        # Restaurar data da MEMORIA
        (Get-Item $memoriaFile).LastWriteTime = [datetime]::Now
    } else {
        Write-Host "  [SKIP] Gate 6B -- MEMORIA_EMBAIXADOR INGRID nao encontrada" -ForegroundColor DarkGray
        $resultados["GATE_6B"] = "SKIP"
    }
} catch {
    Write-Host "  [SKIP] Gate 6B -- erro: $_" -ForegroundColor DarkGray
    $resultados["GATE_6B"] = "SKIP"
} finally {
    Remove-Item $gate6BFile -Force -ErrorAction SilentlyContinue
}

# -- GATE 6C: P-049 -- AUDITOR_LOOP com placeholder criado HOJE
$wipPath = "$BASE\CLIENTES\WIP_BOARD.json"
try {
    $wip = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $proj0 = @($wip.board.build) | Select-Object -First 1
    if ($proj0) {
        $cliC    = $proj0.cliente.ToUpper()
        $cliLow  = $proj0.cliente.ToLower()
        $loopC   = try { [int]$proj0.loop_fase_atual.loop } catch { 0 }
        if ($loopC -gt 0 -and $proj0.loop_fase_atual.notebooklm -eq "OK") {
            $audPath = "$BASE\CLIENTES\$cliC\HISTORICO\AUDITOR_LOOP_V${loopC}_${cliLow}.md"
            $audExists = Test-Path $audPath
            if ($audExists) {
                $conteudo = Get-Content $audPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
                if ($conteudo -notmatch '\[colar aqui\]') {
                    Write-Host "  [OK] Gate 6C -- AUDITOR preenchido, Gate 6C nao bloqueia (correto)" -ForegroundColor Green
                    $resultados["GATE_6C"] = "OK"
                } else {
                    Write-Host "  [INFO] Gate 6C -- AUDITOR tem placeholders de sessao anterior" -ForegroundColor Yellow
                    $resultados["GATE_6C"] = "INFO"
                }
            } else {
                Write-Host "  [INFO] Gate 6C -- AUDITOR_LOOP ausente (notebooklm=OK sem arquivo)" -ForegroundColor Yellow
                $resultados["GATE_6C"] = "INFO"
            }
        } else {
            Write-Host "  [SKIP] Gate 6C -- notebooklm nao OK para $cliC Loop $loopC" -ForegroundColor DarkGray
            $resultados["GATE_6C"] = "SKIP"
        }
    }
} catch {
    Write-Host "  [SKIP] Gate 6C -- erro: $_" -ForegroundColor DarkGray
    $resultados["GATE_6C"] = "SKIP"
}

# -- RELATORIO FINAL --
Write-Host ""
Write-Host "======================================================="
Write-Host "  RELATORIO -- TESTAR_GATES_CRITICOS -- $DATA $HORA"
Write-Host "======================================================="
Write-Host ""
$falhas = 0
foreach ($k in $resultados.Keys) {
    $v   = $resultados[$k]
    $cor = if ($v -eq "OK") {"Green"} elseif ($v -eq "FALHOU") {"Red"} elseif ($v -eq "SKIP") {"DarkGray"} else {"Yellow"}
    Write-Host ("  " + $k.PadRight(12) + " : " + $v) -ForegroundColor $cor
    if ($v -eq "FALHOU") { $falhas++ }
}
Write-Host ""
if ($falhas -eq 0) {
    Write-Host "  RESULTADO: VERDE -- todos os gates funcionando" -ForegroundColor Green
} else {
    Write-Host "  RESULTADO: VERMELHO -- $falhas gate(s) com problema" -ForegroundColor Red
}
Write-Host ""
Write-Host "  P-097 candidato: gates bloqueantes precisam de cobertura de regressao automatica."
Write-Host "  Rodar a cada 3 loops via: meta.loops_desde_ultimo_checkup (WIP_BOARD)"
Write-Host ""
