# ============================================================
# ALERTA_TELEGRAM.PS1 — Envia alerta para o Diretor via Telegram
# Canal de alertas automáticos do Quadrilateral IAH
#
# Uso: .\scripts\alerta_telegram.ps1 -mensagem "Texto aqui"
#      .\scripts\alerta_telegram.ps1 -cliente INGRID -tipo SILENCIO
# ============================================================

param(
    [string]$mensagem = "",
    [string]$cliente  = "",
    [string]$tipo     = ""
)

$BASE = Split-Path -Parent $PSScriptRoot
. "$BASE\scripts\alert_config.ps1"

# ── Alertas pré-definidos ──────────────────────────────────
if ($mensagem -eq "" -and $cliente -ne "" -and $tipo -ne "") {

    $hoje = Get-Date -Format "dd/MM"

    switch ("$($cliente.ToUpper())_$($tipo.ToUpper())") {

        "INGRID_SILENCIO" {
            $mensagem = "🟡 INGRID — Silêncio ativo`nDias sem contato: 2+`nAção: enviar reativação`n`n.\scripts\alerta_whatsapp.ps1 -cliente INGRID -tipo REATIVACAO"
        }
        "INGRID_TERMO" {
            $mensagem = "🟡 INGRID — Termo pendente`nP-023 ativo — gate bloqueado`nAção: enviar B1 agora`n`n.\scripts\alerta_whatsapp.ps1 -cliente INGRID -tipo B1"
        }
        "INGRID_RELATORIO" {
            $mensagem = "📊 INGRID — Relatório semanal`nGate formal E-3 — obrigatório hoje`nAção: copiar métricas Supabase + enviar WhatsApp`n`n.\scripts\alerta_whatsapp.ps1 -cliente INGRID -tipo RELATORIO_SEMANAL"
        }
        "VALDECE_PRESENCIAL" {
            $mensagem = "🏛️ VALDECE — Presencial hoje`nAntes de sair: leia MEMORIA_EMBAIXADOR`nAo voltar: preencher debrief (7 campos)`n`n.\scripts\ir_ao_embaixador.ps1 -cliente VALDECE"
        }
        "VALDECE_SILENCIO" {
            $mensagem = "🟡 VALDECE — Silêncio ativo`nAção: verificar estado do sistema + reativar`n`n.\scripts\alerta_whatsapp.ps1 -cliente VALDECE -tipo REATIVACAO"
        }
        "BRIEFING" {
            $mensagem = "☀️ BOM DIA, DIRETOR`nSeu briefing completo está no e-mail.`nAbra e execute as ações do dia."
        }
        default {
            Write-Host "❌ Tipo '$tipo' não reconhecido para '$cliente'." -ForegroundColor Red
            exit 1
        }
    }
}

if ($mensagem -eq "") {
    Write-Host "❌ Forneça -mensagem 'texto' ou -cliente + -tipo" -ForegroundColor Red
    exit 1
}

# ── Envia via Telegram Bot API ─────────────────────────────
$url  = "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage"
$body = @{
    chat_id = $TELEGRAM_CHAT_ID
    text    = $mensagem
}

try {
    $r = Invoke-RestMethod -Uri $url -Method POST -Body $body
    if ($r.ok) {
        Write-Host "✅ Alerta enviado ao Diretor via Telegram" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ ERRO Telegram: $($_.Exception.Message)" -ForegroundColor Red
}
