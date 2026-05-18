# ============================================================
# ALERTA_WHATSAPP.PS1 — Mensagem WhatsApp calibrada + clipboard
# Gera mensagem certa para o cliente certo, copia para clipboard
# e abre o WhatsApp Web na conversa. Eduardo cola e envia.
#
# Uso: .\scripts\alerta_whatsapp.ps1 -cliente INGRID -tipo B1
#      .\scripts\alerta_whatsapp.ps1 -mensagem "Texto livre"
#
# SETUP (opcional — adicionar números em alert_config.ps1):
#   $CONTATOS = @{ INGRID = "5561999999999"; VALDECE = "5561888888888" }
#   Formato: código país (55) + DDD + número, sem + ou espaços
# ============================================================

param(
    [string]$cliente  = "",
    [string]$tipo     = "",
    [string]$mensagem = ""
)

$BASE = Split-Path -Parent $PSScriptRoot
. "$BASE\scripts\alert_config.ps1"

# ── Mensagens pré-calibradas ───────────────────────────────
if ($mensagem -eq "" -and $cliente -ne "" -and $tipo -ne "") {

    switch ("$($cliente.ToUpper())_$($tipo.ToUpper())") {

        "INGRID_B1" {
            $mensagem = "Ingrid! To quase liberando seu acesso - so falta sua assinatura no termo que te mandei. Assim que confirmar, ja te mando o link. 🚀"
        }
        "INGRID_REATIVACAO" {
            $mensagem = "Ingrid, to por aqui. Como ta o estudo?"
        }
        "INGRID_RELATORIO_SEMANAL" {
            $mensagem = "Ingrid, semana encerrada! Me conta: quantas questoes voce respondeu essa semana? Quero atualizar seu relatorio de progresso 📊"
        }
        "INGRID_GATE_DIA8" {
            $mensagem = "Ingrid! Sua ferramenta ta pronta para o teste. Quando voce tiver 15 minutinhos, me fala que te mando o link de acesso 🎯"
        }
        "INGRID_ALERTA_SILENCIO" {
            $mensagem = "Ingrid, tudo bem? To por aqui se precisar de algo 🙂"
        }
        "VALDECE_CONFIRMACAO_PRESENCIAL" {
            $mensagem = "Dr. Valdece, so confirmando nosso encontro de amanha. Estarei ai no horario combinado. Qualquer coisa me chama!"
        }
        "VALDECE_POS_PRESENCIAL" {
            $mensagem = "Dr. Valdece, foi otimo hoje! O sistema ta no ar na sua maquina. Qualquer duvida que surgir, e so me chamar aqui 🏛️"
        }
        "VALDECE_REATIVACAO" {
            $mensagem = "Dr. Valdece, tudo bem? Passando para saber como esta sendo a experiencia com o sistema."
        }
        default {
            Write-Host "❌ Tipo '$tipo' não reconhecido para cliente '$cliente'." -ForegroundColor Red
            Write-Host ""
            Write-Host "Tipos disponíveis:" -ForegroundColor Yellow
            Write-Host "  INGRID  : B1 | REATIVACAO | RELATORIO_SEMANAL | GATE_DIA8 | ALERTA_SILENCIO" -ForegroundColor Gray
            Write-Host "  VALDECE : CONFIRMACAO_PRESENCIAL | POS_PRESENCIAL | REATIVACAO" -ForegroundColor Gray
            exit 1
        }
    }
}

if ($mensagem -eq "") {
    Write-Host "❌ Forneça -mensagem 'texto' ou -cliente NOME -tipo TIPO" -ForegroundColor Red
    exit 1
}

# ── Exibe a mensagem ───────────────────────────────────────
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  MENSAGEM — $($cliente.ToUpper()) · $($tipo.ToUpper())" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "  $mensagem" -ForegroundColor White
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

# ── Copia para clipboard ───────────────────────────────────
$mensagem | Set-Clipboard
Write-Host ""
Write-Host "📋 Mensagem copiada para o clipboard (Ctrl+V pronto)" -ForegroundColor Green

# ── Abre WhatsApp Web ──────────────────────────────────────
$numero = $null
if ($cliente -ne "" -and (Get-Variable -Name "CONTATOS" -ErrorAction SilentlyContinue)) {
    $numero = $CONTATOS[$cliente.ToUpper()]
}

$mensagemEncoded = [System.Uri]::EscapeDataString($mensagem)

if ($numero) {
    $url = "https://web.whatsapp.com/send?phone=$numero&text=$mensagemEncoded"
    Write-Host "🌐 Abrindo WhatsApp Web na conversa de $cliente..." -ForegroundColor Cyan
} else {
    $url = "https://web.whatsapp.com"
    Write-Host "🌐 Abrindo WhatsApp Web — selecione o contato e cole (Ctrl+V)" -ForegroundColor Cyan
}

Start-Process $url

Write-Host ""
Write-Host "✅ Pronto. Cole a mensagem (Ctrl+V) e envie." -ForegroundColor Green
Write-Host ""
