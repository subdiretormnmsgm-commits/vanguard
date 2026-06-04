# ping_supabase_universal.ps1
# Mantém TODOS os projetos Supabase da Vanguard ativos -- previne pausa por inatividade
# Task Scheduler: a cada 5 dias as 09:00 (registrar_ping_universal.ps1)

$PROJETOS = @(
    @{
        nome  = 'Ingrid (sedes-ingrid-2026)'
        url   = 'https://yjqvjhezwhepwomukudt.supabase.co'
        anon  = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlqcXZqaGV6d2hlcHdvbXVrdWR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3NjExNzksImV4cCI6MjA5NTMzNzE3OX0.Mb6KxtJ3iECl_3ApWUl6zozxa93pJatLwNOZ7zAdhx4'
        table = 'questoes_quadrix'
    },
    @{
        nome  = 'Valdece -- valdece-juridico (conta Valdece)'
        url   = 'https://hqqxzecftkvtrlpkhvnc.supabase.co'
        anon  = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxcXh6ZWNmdGt2dHJscGtodm5jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxMzg5NjYsImV4cCI6MjA5NDcxNDk2Nn0.AFWbk2oi7zKDu7Q922CqS-cc-pG_VJNYMqqH2BeouxA'
        table = 'documents'
    },
    @{
        nome  = 'Valdece -- toga-digital-valdece (conta Vanguard)'
        url   = 'https://uslkhnselzmbbnupmfsp.supabase.co'
        anon  = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVzbGtobnNlbHptYmJudXBtZnNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkzNTc4NjAsImV4cCI6MjA5NDkzMzg2MH0.BPW5htJk7xZJe6sFr_yrIORSu4OCMhbqQ3BdNLYELQ0'
        table = 'documents'
    },
    @{
        nome  = 'Vanguard (infra principal)'
        url   = 'https://ehyaecxqijgyuuiorzcj.supabase.co'
        anon  = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVoeWFlY3hxaWpneXV1aW9yemNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgyODMzNTAsImV4cCI6MjA5Mzg1OTM1MH0.xZfcEe2Av5Fn9BKEkNRIi5CQkPD6C6ADSNzMfh3DGPo'
        table = 'documents'
    }
)

$LOG  = "$PSScriptRoot\ping_universal.log"
$DATA = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

$TELEGRAM_TOKEN = $env:TELEGRAM_TOKEN
$TELEGRAM_CHAT  = $env:TELEGRAM_CHAT_ID

function Send-Telegram($msg) {
    if (-not $TELEGRAM_TOKEN) { return }
    try {
        $url  = 'https://api.telegram.org/bot' + $TELEGRAM_TOKEN + '/sendMessage'
        $body = '{"chat_id":"' + $TELEGRAM_CHAT + '","text":"' + $msg + '"}'
        Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType 'application/json' | Out-Null
    } catch {}
}

$falhas = @()

foreach ($proj in $PROJETOS) {
    if ($proj.anon -like 'SUBSTITUIR*') {
        Add-Content -Path $LOG -Value ('[' + $DATA + '] SKIP -- ' + $proj.nome + ' -- anon key pendente')
        Write-Host ('[SKIP] ' + $proj.nome + ' -- anon key pendente')
        continue
    }

    try {
        $headers = @{
            'apikey'        = $proj.anon
            'Authorization' = 'Bearer ' + $proj.anon
        }
        $uri = $proj.url + '/rest/v1/' + $proj.table + '?select=id&limit=1'

        # Qualquer resposta HTTP (200, 401, 404) = projeto ativo
        # Apenas falha de conexao/timeout = projeto pausado
        try {
            $res   = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -TimeoutSec 15 -ErrorAction Stop
            $count = ($res | Measure-Object).Count
            $linha = '[' + $DATA + '] VERDE -- ' + $proj.nome + ' -- ' + $count + ' registro(s)'
        } catch [System.Net.WebException] {
            $status = [int]$_.Exception.Response.StatusCode
            if ($status -ge 400) {
                # HTTP error = servidor respondeu = projeto ativo
                $linha = '[' + $DATA + '] VERDE -- ' + $proj.nome + ' -- HTTP ' + $status + ' (projeto ativo)'
            } else {
                throw
            }
        }
        Add-Content -Path $LOG -Value $linha
        Write-Host $linha
    } catch {
        $err   = $_.Exception.Message
        $linha = '[' + $DATA + '] VERMELHO -- ' + $proj.nome + ' -- FALHA CONEXAO: ' + $err
        Add-Content -Path $LOG -Value $linha
        Write-Host $linha
        $falhas += $proj.nome
    }
}

if ($falhas.Count -gt 0) {
    $lista = $falhas -join ', '
    $msg   = 'ALERTA VANGUARD -- Supabase pausado ou inacessivel: ' + $lista + '. Data: ' + $DATA + '. Acesse supabase.com e retome os projetos.'
    Send-Telegram $msg
    Write-Host ('[ALERTA] Telegram enviado -- ' + $lista)
    exit 1
}

Write-Host ('[OK] Todos os projetos ativos -- ' + $DATA)
