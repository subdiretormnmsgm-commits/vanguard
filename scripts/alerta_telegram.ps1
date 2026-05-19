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
            $mensagem = @"
INGRID - Silencio ativo (2+ dias)
P-023 ativo - gate bloqueado

COPIE E ENVIE NO WHATSAPP:
---
Ingrid, tô por aqui. Como tá o estudo?
---
"@
        }
        "INGRID_TERMO" {
            $mensagem = @"
INGRID - Termo pendente
Nenhuma acao ate assinar. Gate bloqueado.

COPIE E ENVIE NO WHATSAPP:
---
Ingrid! Tô quase liberando seu acesso — só falta sua assinatura no termo que te mandei. Assim que confirmar, já te mando o link.
---
"@
        }
        "INGRID_RELATORIO" {
            $mensagem = @"
INGRID - Relatorio semanal (gate formal E-3)
Abrir Supabase, copiar metricas, enviar.

COPIE E ENVIE NO WHATSAPP:
---
Ingrid, semana encerrada! Me conta: quantas questões você respondeu essa semana? Quero atualizar seu relatório de progresso.
---
"@
        }
        "INGRID_GATE_DIA8" {
            $mensagem = @"
INGRID - Gate Dia 8 - URL ATIVA
App publicado. Link direto para a Ingrid.

COPIE E ENVIE NO TELEGRAM/WHATSAPP:
---
Ingrid! Finalizei sua ferramenta de estudos 🎯

Ela já está no ar, você acessa de qualquer lugar pelo celular:
https://subdiretormnmsgm-commits.github.io/vanguard/

Na primeira vez que abrir vai aparecer um termo rápido pra confirmar — é só aceitar e já começa.

Me manda mensagem depois que testar? Quero saber como foi! 😊
---
Apos testar: acionar Embaixador -> iniciar.ps1 [E] -> Secao B (Debrief)
"@
        }
        "VALDECE_PRESENCIAL" {
            $mensagem = @"
VALDECE - Presencial hoje
1. Leia MEMORIA_EMBAIXADOR antes de sair
2. Leve WATCHDOG preenchido
3. Ao voltar: debrief 7 campos no Embaixador

COPIE E ENVIE NO WHATSAPP (confirmacao):
---
Dr. Valdece, só confirmando nosso encontro de hoje. Estarei aí no horário combinado. Qualquer coisa me chama!
---
"@
        }
        "VALDECE_POS_PRESENCIAL" {
            $mensagem = @"
VALDECE - Pos-presencial
Acionar Embaixador com debrief agora.

COPIE E ENVIE NO WHATSAPP:
---
Dr. Valdece, foi ótimo hoje! O sistema tá no ar na sua máquina. Qualquer dúvida que surgir, é só me chamar aqui.
---
"@
        }
        "VALDECE_SILENCIO" {
            $mensagem = @"
VALDECE - Silencio ativo
Verificar estado do sistema + reativar.

COPIE E ENVIE NO WHATSAPP:
---
Dr. Valdece, tudo bem? Passando para saber como esta sendo a experiencia com o sistema.
---
"@
        }
        "BRIEFING" {
            $mensagem = "Bom dia, Diretor. Briefing completo no e-mail. Abra e execute as acoes do dia."
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
