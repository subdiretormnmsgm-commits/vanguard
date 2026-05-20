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
        "VALDECE_DEMO" {
            $mensagem = @"
VALDECE - DEMO HOJE (2026-05-20)
Momento mais critico do projeto — primeira busca dele.

CHECKLIST PRE-SAIDA:
[ ] Leu MEMORIA_EMBAIXADOR (30 seg)
[ ] Anotou os 3 temas que ele mais usa
[ ] search_cli.py testado (threshold 0.45, top 3)
[ ] Rascunho WhatsApp salvo: "Dr. Valdece, valor unico R$5k. Sem mensalidade."
[ ] Contrato em mao (Contrato_Toga_Digital_Valdece_19052026.pdf)

ROTEIRO (60-90 min):
[0-5 min]  "Valdece, quais 3 temas voce mais pesquisou essa semana?"
[5-25 min] Busca 1,2,3 nos temas que ELE nomeou — SILENCIO total
[25-40 min] Deixar ELE digitar a 4a busca sozinho — momento de virada
[40-55 min] Sovereign Playbook: "resolve em 3 passos sem me ligar"
[55-70 min] Contrato — nao forcar — deixar o entusiasmo fechar
LINHA FECHAMENTO: "O sistema e seu. Isso aqui so formaliza."

SE NAO ENCONTRAR: "Esse entra no proximo ciclo" — redirecionar para outro dos 3 temas.
AO VOLTAR: debrief com Embaixador (7 campos) obrigatorio.
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
        "VALDECE_TESTES" {
            $msgFile = Join-Path $BASE "scripts\msgs\VALDECE_TESTES.txt"
            $mensagem = [System.IO.File]::ReadAllText($msgFile, [System.Text.Encoding]::UTF8)
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
    $json  = $body | ConvertTo-Json -Compress
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $r = Invoke-RestMethod -Uri $url -Method POST -Body $bytes -ContentType "application/json; charset=utf-8"
    if ($r.ok) {
        Write-Host "✅ Alerta enviado ao Diretor via Telegram" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ ERRO Telegram: $($_.Exception.Message)" -ForegroundColor Red
}
