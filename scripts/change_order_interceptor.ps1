#Requires -Version 5.1
# change_order_interceptor.ps1 -- N-5 Ingrid: intercepta pedidos fora de escopo
# Uso: .\scripts\change_order_interceptor.ps1 -cliente INGRID -pedido "descricao do pedido"
# O que faz:
#   1. Loga o pedido em CLIENTES/[CLIENTE]/HISTORICO/CHANGE_ORDERS.md
#   2. Carrega contrato do cliente para identificar clausula aplicavel
#   3. Envia alerta Telegram ao Diretor com clausula + risco
#   4. Prepara prompt pronto para o Auditor (NotebookLM) analisar

param(
    [Parameter(Mandatory=$true)]
    [string]$cliente,
    [Parameter(Mandatory=$true)]
    [string]$pedido,
    [string]$severidade = "MEDIA"
)

$BASE = Split-Path -Parent $PSScriptRoot
$DATA = Get-Date -Format "yyyy-MM-dd HH:mm"
$DATA_CURTA = Get-Date -Format "yyyy-MM-dd"

. "$BASE\scripts\send_telegram_helper.ps1"

# Paths
$HISTORICO = "$BASE\CLIENTES\$cliente\HISTORICO"
$LOG_FILE  = "$HISTORICO\CHANGE_ORDERS.md"
$CONTRATO  = "$BASE\CLIENTES\$cliente\CLAUDE_PROJECT\CONTRATO_CLAUSULAS.md"
$MEMORIA   = "$BASE\CLIENTES\$cliente\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  CHANGE-ORDER INTERCEPTOR -- $cliente" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Pedido: $pedido"
Write-Host "  Severidade declarada: $severidade"
Write-Host ""

# --- 1. Criar log se nao existe ---
if (-not (Test-Path $HISTORICO)) { New-Item -ItemType Directory -Path $HISTORICO -Force | Out-Null }

if (-not (Test-Path $LOG_FILE)) {
    $header = @"
# CHANGE_ORDERS -- $cliente
> Registro de pedidos fora de escopo contratual.
> Cada entrada: data + pedido + clausula + risco + decisao do Diretor.

---

"@
    Set-Content -Path $LOG_FILE -Value $header -Encoding UTF8
}

# Gerar ID unico
$existentes = (Select-String -Path $LOG_FILE -Pattern "^## CO-" -ErrorAction SilentlyContinue | Measure-Object).Count
$CO_ID = "CO-{0:D3}" -f ($existentes + 1)

# --- 2. Carregar clausulas do contrato (se existir) ---
$clausulas_texto = ""
if (Test-Path $CONTRATO) {
    $clausulas_texto = Get-Content $CONTRATO -Raw -Encoding UTF8
} else {
    $clausulas_texto = "CONTRATO_CLAUSULAS.md nao encontrado em CLAUDE_PROJECT. Criar o arquivo com as clausulas relevantes."
}

# --- 3. Preparar entrada no log ---
$entrada = @"

## $CO_ID -- $DATA_CURTA
**Cliente:** $cliente
**Pedido:** $pedido
**Severidade:** $severidade
**Status:** AGUARDANDO VEREDITO DO DIRETOR
**Clausula verificada:** [preencher apos analise do Auditor]
**Risco identificado:** [preencher apos analise do Auditor]
**Decisao do Diretor:** [PENDENTE]
**Data da decisao:** —

"@

Add-Content -Path $LOG_FILE -Value $entrada -Encoding UTF8
Write-Host "  [OK] $CO_ID registrado em CHANGE_ORDERS.md" -ForegroundColor Green

# --- 4. Alerta Telegram ---
$msg_telegram = @"
CHANGE-ORDER INTERCEPTOR -- $cliente

ID: $CO_ID
Pedido fora de escopo detectado:
"$pedido"

Severidade: $severidade
Data: $DATA

ACAO IMEDIATA:
Antes de responder ao cliente, decida:
A) ACEITAR -- negociar valor adicional
B) RECUSAR -- explicar que e V2/proximo loop
C) AUDITAR -- enviar ao NotebookLM para analise contratual

Para analise contratual: rode o prompt abaixo no NotebookLM do $cliente.
"@

$enviado = Send-Telegram $msg_telegram
if ($enviado -gt 0) {
    Write-Host "  [OK] Alerta enviado ao Telegram do Diretor" -ForegroundColor Green
} else {
    Write-Host "  [WARN] Falha no Telegram -- verificar credenciais" -ForegroundColor Yellow
}

# --- 5. Gerar prompt pronto para o Auditor ---
$prompt_auditor = @"
# CONSULTA CHANGE-ORDER: $CO_ID -- $cliente

## Pedido do cliente
"$pedido"

## O que preciso que voce analise
1. CLAUSULA APLICAVEL: Qual clausula do contrato cobre (ou exclui) este pedido?
2. RISCO CONTRATUAL: Executar sem aditivo gera qual risco? (Trabalho pro bono? Expectativa sem base legal?)
3. RECOMENDACAO: Aceitar / Recusar / Negociar aditivo -- com argumento pronto para o Diretor usar com o cliente
4. TEXTO SUGERIDO: Uma frase que o Diretor pode dizer ao cliente agora, enquanto delibera

Formato da resposta:
CLAUSULA: [numero e texto exato]
RISCO: [descricao objetiva]
RECOMENDACAO: [ACEITAR / RECUSAR / NEGOCIAR]
ARGUMENTO: [frase pronta para o Diretor]
"@

$PROMPT_FILE = "$HISTORICO\PROMPT_AUDITOR_${CO_ID}.md"
Set-Content -Path $PROMPT_FILE -Value $prompt_auditor -Encoding UTF8
Write-Host "  [OK] Prompt para Auditor salvo em: HISTORICO\PROMPT_AUDITOR_${CO_ID}.md" -ForegroundColor Green

# --- 6. Output final ---
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  CHANGE-ORDER $CO_ID REGISTRADO" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  PROXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host "  1. Telegram enviado -- Diretor recebeu alerta no celular" -ForegroundColor White
Write-Host "  2. Abrir NotebookLM [$cliente] e colar o prompt:" -ForegroundColor White
Write-Host "     $PROMPT_FILE" -ForegroundColor Gray
Write-Host "  3. Responder ao Auditor: 'D_$CO_ID : A/B/C'" -ForegroundColor White
Write-Host "  4. Musculo atualiza CHANGE_ORDERS.md com a decisao" -ForegroundColor White
Write-Host ""
