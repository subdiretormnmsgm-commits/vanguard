# ============================================================
# ALERTA_WHATSAPP.PS1 — Envia mensagem WhatsApp via CallMeBot
# Uso: .\scripts\alerta_whatsapp.ps1 -cliente INGRID -tipo B1
#      .\scripts\alerta_whatsapp.ps1 -mensagem "Texto livre aqui"
#
# SETUP ÚNICO (fazer uma vez):
#   1. Adicionar "+34 644 38 55 19" como contato "CallMeBot" no WhatsApp
#   2. Enviar a mensagem: I allow callmebot to send me messages
#   3. Aguardar resposta com o apikey
#   4. Adicionar o apikey em scripts\alert_config.ps1: $WHATSAPP_APIKEY = "xxxxxx"
#   5. Adicionar o número em scripts\alert_config.ps1: $WHATSAPP_NUMERO = "5561999999999"
#      (código do país + DDD + número, sem + ou espaços)
# ============================================================

param(
    [string]$cliente  = "",
    [string]$tipo     = "",
    [string]$mensagem = ""
)

$BASE = Split-Path -Parent $PSScriptRoot
. "$BASE\scripts\alert_config.ps1"

# ── Valida configuração ────────────────────────────────────
if (-not $WHATSAPP_APIKEY -or $WHATSAPP_APIKEY -eq "SEU_APIKEY_AQUI") {
    Write-Host "⚠️  WHATSAPP_APIKEY não configurado." -ForegroundColor Yellow
    Write-Host "   Siga o setup em scripts\alerta_whatsapp.ps1 (linhas 8-14)" -ForegroundColor Yellow
    exit 1
}
if (-not $WHATSAPP_NUMERO -or $WHATSAPP_NUMERO -eq "SEU_NUMERO_AQUI") {
    Write-Host "⚠️  WHATSAPP_NUMERO não configurado em alert_config.ps1" -ForegroundColor Yellow
    exit 1
}

# ── Mensagens pré-definidas por cliente e tipo ─────────────
if ($mensagem -eq "" -and $cliente -ne "" -and $tipo -ne "") {

    $hoje = Get-Date -Format "yyyy-MM-dd"

    # Lê MEMORIA_EMBAIXADOR para dados reais
    $memoriaPath = "$BASE\CLIENTES\$($cliente.ToUpper())\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"

    switch ("$($cliente.ToUpper())_$($tipo.ToUpper())") {

        "INGRID_B1" {
            $mensagem = "Ingrid! To quase liberando seu acesso - so falta sua assinatura no termo que te mandei. Assim que confirmar, ja te mando o link. 🚀"
        }

        "INGRID_REATIVACAO" {
            $mensagem = "Ingrid, to por aqui. Como ta o estudo?"
        }

        "INGRID_RELATORIO_SEMANAL" {
            # Tenta extrair métricas reais do Supabase (simplificado — Eduardo preenche se necessário)
            $mensagem = "Ingrid, semana encerrada! Me conta: quantas questoes voce respondeu essa semana? Quero atualizar seu relatorio de progresso 📊"
        }

        "INGRID_GATE_DIA8" {
            $mensagem = "Ingrid! Sua ferramenta ta pronta para o teste. Quando voce tiver 15 minutinhos, me fala que te mando o link de acesso. Vamos ver voce em acao! 🎯"
        }

        "INGRID_ALERTA_SILENCIO" {
            $mensagem = "Ingrid, tudo bem? To por aqui se precisar de algo 🙂"
        }

        "VALDECE_CONFIRMACAO_PRESENCIAL" {
            $mensagem = "Dr. Valdece, so confirmando nosso encontro de amanha. Estarei ai as [HORA]. Qualquer coisa me chama!"
        }

        "VALDECE_POS_PRESENCIAL" {
            $mensagem = "Dr. Valdece, foi otimo hoje! O sistema ta no ar na sua maquina. Qualquer duvida que surgir, e so me chamar aqui. Bom trabalho! 🏛️"
        }

        default {
            Write-Host "❌ Tipo '$tipo' não reconhecido para cliente '$cliente'." -ForegroundColor Red
            Write-Host "   Tipos disponíveis: B1, REATIVACAO, RELATORIO_SEMANAL, GATE_DIA8, ALERTA_SILENCIO" -ForegroundColor Yellow
            exit 1
        }
    }
}

# ── Valida mensagem ────────────────────────────────────────
if ($mensagem -eq "") {
    Write-Host "❌ Forneça -mensagem 'texto' ou -cliente + -tipo" -ForegroundColor Red
    Write-Host "   Exemplo: .\scripts\alerta_whatsapp.ps1 -cliente INGRID -tipo B1" -ForegroundColor Yellow
    exit 1
}

# ── Exibe prévia antes de enviar ──────────────────────────
Write-Host ""
Write-Host "📱 MENSAGEM WHATSAPP — PRÉVIA" -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────" -ForegroundColor Gray
Write-Host $mensagem -ForegroundColor White
Write-Host "─────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""

# Copia para clipboard automaticamente
$mensagem | Set-Clipboard
Write-Host "📋 Mensagem copiada para o clipboard" -ForegroundColor Green
Write-Host ""

$confirmar = Read-Host "Enviar via WhatsApp? (S/N)"
if ($confirmar -ne "S" -and $confirmar -ne "s") {
    Write-Host "⏸  Envio cancelado. Mensagem ainda está no clipboard." -ForegroundColor Yellow
    exit 0
}

# ── Envia via CallMeBot ────────────────────────────────────
$mensagemEncoded = [System.Web.HttpUtility]::UrlEncode($mensagem)
$url = "https://api.callmebot.com/whatsapp.php?phone=$WHATSAPP_NUMERO&text=$mensagemEncoded&apikey=$WHATSAPP_APIKEY"

try {
    Add-Type -AssemblyName System.Web
    $response = Invoke-WebRequest -Uri $url -Method GET -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Mensagem enviada via WhatsApp para $WHATSAPP_NUMERO" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Resposta inesperada: $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ ERRO ao enviar WhatsApp: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Mensagem está no clipboard — cole manualmente se necessário." -ForegroundColor Yellow
}
