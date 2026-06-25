# auditoria_fuso_n8n.ps1 -- Auditor de deriva de fuso dos workflows n8n agendados
# Origem: P-146 anti-recorrencia -- 2026-06-24.
# Causa-raiz que motivou: bug de fuso (+3h) corrigido no W-11 nao foi propagado a W-10/W-12/W-13.
# O Health Check (W-10) NAO detecta isso: workflow com fuso errado roda com status=success+active = invisivel.
# Este auditor compara a HORA-INTENCAO (BRT, tabela fixa abaixo) contra o startedAt REAL das execucoes.
# Read-only. Nao altera nada. Exit 0 VERDE / 1 AMARELO (deriva detectada).
#
# Uso: .\scripts\auditoria_fuso_n8n.ps1   [-ToleranciaMin 5]

param(
  [int]$ToleranciaMin = 5
)

$ErrorActionPreference = 'Stop'

# --- chave (P-HV1: lida do arquivo gitignored, nunca hardcoded) ---
$chavesPath = Join-Path $PSScriptRoot "..\CHAVES_SISTEMA_VANGUARD.txt"
if (-not (Test-Path $chavesPath)) { Write-Host "[ERRO] CHAVES_SISTEMA_VANGUARD.txt nao encontrado em $chavesPath"; exit 2 }
$line = (Get-Content $chavesPath | Where-Object { $_ -match '^\s*N8N_API_KEY\s*=' })
if (-not $line) { Write-Host "[ERRO] N8N_API_KEY nao encontrada em CHAVES_SISTEMA_VANGUARD.txt"; exit 2 }
$key = ($line -split '=',2)[1].Trim()
$base = "https://vanguard-vanguard-n8n.0ul9nk.easypanel.host/api/v1"
$h = @{ "X-N8N-API-KEY" = $key }

# --- HORA-INTENCAO em BRT (fonte de verdade do auditor; atualizar aqui se um cron mudar de proposito) ---
$intencao = @(
  @{ id="8yvX4MBzdaK5l6IQ"; wf="W-10"; brt="06:30" },
  @{ id="vew2fonxWwiGB9uQ"; wf="W-11"; brt="07:05" },
  @{ id="dfIMwQOS6qh5EEA7"; wf="W-12"; brt="07:10" },
  @{ id="g06fYsG6kxduv7ZA"; wf="W-13"; brt="07:15" }
)

$derivas = @()
Write-Host "AUDITORIA DE FUSO n8n -- tolerancia $ToleranciaMin min" -ForegroundColor Cyan
Write-Host ("-" * 60)

foreach ($t in $intencao) {
  try {
    $ex = Invoke-RestMethod -Uri "$base/executions?workflowId=$($t.id)&limit=10&includeData=false" -Headers $h
  } catch {
    Write-Host ("{0}: [ERRO] sem execucoes acessiveis -- {1}" -f $t.wf, $_.Exception.Message) -ForegroundColor Yellow
    continue
  }
  # pega a execucao mais recente com startedAt (disparo agendado)
  $last = $ex.data | Where-Object { $_.startedAt } | Select-Object -First 1
  if (-not $last) { Write-Host ("{0}: sem execucoes registradas" -f $t.wf) -ForegroundColor DarkGray; continue }

  $dto = [DateTimeOffset]::Parse($last.startedAt)
  $brtReal = $dto.ToOffset([TimeSpan]::FromHours(-3))
  $realHHMM = $brtReal.ToString("HH:mm")

  # diff em minutos entre intencao e real (so hora:min, ignora data)
  $alvo = [datetime]::ParseExact($t.brt, "HH:mm", $null)
  $obs  = [datetime]::ParseExact($realHHMM, "HH:mm", $null)
  # diff circular (modulo 1440) -- evita falso DERIVA em cron proximo da meia-noite (ex: 23:55 vs 00:05)
  $bruto = [math]::Abs(($obs - $alvo).TotalMinutes)
  $diff  = [math]::Min($bruto, 1440 - $bruto)

  if ($diff -le $ToleranciaMin) {
    Write-Host ("{0}: OK    intencao {1} BRT | real {2} BRT (data {3}) | status={4}" -f $t.wf, $t.brt, $realHHMM, $brtReal.ToString("dd/MM"), $last.status) -ForegroundColor Green
  } else {
    Write-Host ("{0}: DERIVA intencao {1} BRT | real {2} BRT | {3} min de desvio | status={4}" -f $t.wf, $t.brt, $realHHMM, [int]$diff, $last.status) -ForegroundColor Red
    $derivas += ("{0}: esperado {1} BRT, disparou {2} BRT ({3} min)" -f $t.wf, $t.brt, $realHHMM, [int]$diff)
  }
}

Write-Host ("-" * 60)
if ($derivas.Count -gt 0) {
  Write-Host "[AMARELO] Deriva de fuso detectada em $($derivas.Count) workflow(s):" -ForegroundColor Yellow
  $derivas | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
  Write-Host "Correcao: ajustar a HORA do cron (rule.interval[0].expression) -- ver scripts de correcao 2026-06-24." -ForegroundColor Yellow
  exit 1
} else {
  Write-Host "[VERDE] Nenhuma deriva de fuso. Todos os agendados disparam na hora-intencao." -ForegroundColor Green
  exit 0
}
