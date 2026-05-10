# prospectar.ps1 — Motor de Prospecção Vanguard Tech
# Pipeline completo: captura → mensagem → follow-up → fechamento
#
# Uso:
#   .\scripts\prospectar.ps1              → menu interativo
#   .\scripts\prospectar.ps1 -add         → adicionar prospecto
#   .\scripts\prospectar.ps1 -pipeline    → ver funil completo
#   .\scripts\prospectar.ps1 -scan dom    → abrir scanner + gerar mensagem
#   .\scripts\prospectar.ps1 -followup    → ver quem precisa de follow-up

param(
    [switch]$add,
    [switch]$pipeline,
    [string]$scan = "",
    [switch]$followup,
    [switch]$stats
)

$base    = "C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard"
$dataDir = "$base\data"
$csvPath = "$dataDir\pipeline.csv"
$logPath = "$dataDir\atividade.log"

# ─── Setup ────────────────────────────────────────────────────────────────────
New-Item -ItemType Directory -Path $dataDir -Force | Out-Null

# Cria CSV com cabeçalho se não existir
if (-not (Test-Path $csvPath)) {
    "id,data_add,dominio,nome_contato,whatsapp,nicho,score,receita_perdida,status,data_contato,data_resposta,notas" |
        Out-File $csvPath -Encoding utf8
}

# ─── Helpers ──────────────────────────────────────────────────────────────────
function Log($msg) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm"
    "$ts | $msg" | Out-File $logPath -Encoding utf8 -Append
}

function LoadPipeline() {
    if ((Get-Content $csvPath | Measure-Object -Line).Lines -le 1) { return @() }
    return Import-Csv $csvPath -Encoding utf8
}

function SavePipeline($rows) {
    $rows | Export-Csv $csvPath -Encoding utf8 -NoTypeInformation
}

function NextId() {
    $rows = LoadPipeline
    if ($rows.Count -eq 0) { return 1 }
    return ([int]($rows | Measure-Object -Property id -Maximum).Maximum) + 1
}

function StatusColor($status) {
    switch ($status) {
        "NAO_CONTACTADO"  { return "DarkGray" }
        "CONTACTADO"      { return "Yellow" }
        "RESPONDEU"       { return "Cyan" }
        "REUNIAO"         { return "Blue" }
        "PROPOSTA"        { return "Magenta" }
        "FECHADO"         { return "Green" }
        "PERDIDO"         { return "Red" }
        default            { return "White" }
    }
}

function BannerTop($title) {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkYellow
    Write-Host "  VANGUARD TECH  ·  $title" -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkYellow
    Write-Host ""
}

# ─── Gerador de mensagem personalizada ────────────────────────────────────────
function GerarMensagem($dominio, $nome, $score, $receitaPerdida, $nicho) {
    $scoreNum  = if ($score) { $score } else { "?" }
    $receita   = if ($receitaPerdida -and $receitaPerdida -ne "") { "R$ $receitaPerdida/mês" } else { "valor significativo/mês" }
    $nomeExib  = if ($nome -and $nome -ne "") { $nome } else { "Olá" }

    $msg = @"
$nomeExib,

Analisei o site $dominio com a nossa IA de diagnóstico.

O resultado foi preocupante: o site tem score $scoreNum/10 e está a perder estimados $receita em leads que chegam mas não convertem.

Gerei um relatório gratuito com os 3 principais gargalos e o impacto financeiro de cada um.

São 2 minutos de leitura. Posso enviar?

— Eduardo · Vanguard Tech
"@
    return $msg
}

function GerarFollowUp($dominio, $nome, $diasDesdeContato) {
    $nomeExib = if ($nome) { $nome } else { "Olá" }
    return @"
$nomeExib, tudo bem?

Enviei o relatório do $dominio há $diasDesdeContato dias.
Conseguiu dar uma olhada?

Posso fazer uma demo de 15 minutos ao vivo se preferir ver como funciona.

— Eduardo · Vanguard Tech
"@
}

# ─── FUNÇÃO: Adicionar prospecto ──────────────────────────────────────────────
function AdicionarProspecto() {
    BannerTop "NOVO PROSPECTO"

    $dominio = Read-Host "  Domínio (ex: clinicajoao.com.br)"
    $nome    = Read-Host "  Nome do contacto (deixe em branco se não sabe)"
    $wpp     = Read-Host "  WhatsApp (com DDD, ex: 11987654321)"
    $nicho   = Read-Host "  Nicho (ex: Saúde, Advocacia, Imóveis, Varejo)"
    $score   = Read-Host "  Score do scanner (deixe em branco se ainda não rodou)"
    $receita = Read-Host "  Receita perdida estimada R$ (ex: 12000)"

    $id      = NextId
    $hoje    = Get-Date -Format "yyyy-MM-dd"

    $nova = [PSCustomObject]@{
        id              = $id
        data_add        = $hoje
        dominio         = $dominio
        nome_contato    = $nome
        whatsapp        = $wpp
        nicho           = $nicho
        score           = $score
        receita_perdida = $receita
        status          = "NAO_CONTACTADO"
        data_contato    = ""
        data_resposta   = ""
        notas           = ""
    }

    $rows = LoadPipeline
    $rows += $nova
    SavePipeline $rows

    Write-Host ""
    Write-Host "  ✅ Prospecto #$id adicionado: $dominio" -ForegroundColor Green
    Write-Host ""

    # Gerar mensagem automaticamente
    Write-Host "  ─── MENSAGEM WHATSAPP ────────────────────────────" -ForegroundColor DarkYellow
    $msg = GerarMensagem $dominio $nome $score $receita $nicho
    Write-Host $msg -ForegroundColor White
    Write-Host "  ─────────────────────────────────────────────────" -ForegroundColor DarkYellow

    # Copiar para clipboard
    try { $msg | Set-Clipboard; Write-Host "  📋 Mensagem copiada para o clipboard!" -ForegroundColor Cyan } catch {}

    # Abrir WhatsApp Web se tiver número
    if ($wpp -match "^\d{10,11}$") {
        $url = "https://wa.me/55$wpp"
        Write-Host "  🔗 Abrindo WhatsApp Web..." -ForegroundColor Cyan
        Start-Process $url
    }

    Log "ADD | #$id | $dominio | $nicho | $wpp"

    # Perguntar se já contactou
    $resp = Read-Host "`n  Já enviou a mensagem? (s/n)"
    if ($resp -eq "s") {
        AtualizarStatus $id "CONTACTADO"
        Write-Host "  Status actualizado para CONTACTADO." -ForegroundColor Yellow
    }
}

# ─── FUNÇÃO: Actualizar status ────────────────────────────────────────────────
function AtualizarStatus($id, $novoStatus) {
    $rows = LoadPipeline
    $hoje = Get-Date -Format "yyyy-MM-dd"
    foreach ($r in $rows) {
        if ([int]$r.id -eq [int]$id) {
            $r.status = $novoStatus
            if ($novoStatus -eq "CONTACTADO" -and $r.data_contato -eq "") {
                $r.data_contato = $hoje
            }
            if ($novoStatus -in @("RESPONDEU","REUNIAO","PROPOSTA","FECHADO")) {
                $r.data_resposta = $hoje
            }
        }
    }
    SavePipeline $rows
    Log "STATUS | #$id | $novoStatus"
}

# ─── FUNÇÃO: Ver pipeline ─────────────────────────────────────────────────────
function VerPipeline() {
    BannerTop "PIPELINE DE PROSPECÇÃO"

    $rows = LoadPipeline
    if ($rows.Count -eq 0) {
        Write-Host "  Pipeline vazio. Use -add para adicionar prospectos." -ForegroundColor DarkGray
        return
    }

    # Estatísticas por status
    $statusOrder = @("NAO_CONTACTADO","CONTACTADO","RESPONDEU","REUNIAO","PROPOSTA","FECHADO","PERDIDO")
    $grouped = $rows | Group-Object status

    Write-Host "  FUNIL DE CONVERSÃO" -ForegroundColor Yellow
    Write-Host ""

    $totalFechado = 0
    $mrr = 0

    foreach ($s in $statusOrder) {
        $g = $grouped | Where-Object { $_.Name -eq $s }
        $count = if ($g) { $g.Count } else { 0 }
        $bar   = "█" * [Math]::Min($count * 2, 40)
        $color = StatusColor $s
        Write-Host ("  {0,-18} {1,3}  {2}" -f $s, $count, $bar) -ForegroundColor $color
        if ($s -eq "FECHADO") { $totalFechado = $count; $mrr = $count * 270 }
    }

    Write-Host ""
    Write-Host "  ─────────────────────────────────────────────────" -ForegroundColor DarkYellow
    Write-Host "  Total no pipeline : $($rows.Count) prospectos" -ForegroundColor White
    Write-Host "  Clientes fechados : $totalFechado" -ForegroundColor Green
    Write-Host "  MRR gerado        : R$ $mrr/mês" -ForegroundColor Green

    # Taxa de conversão
    $contactados = ($rows | Where-Object { $_.status -ne "NAO_CONTACTADO" }).Count
    if ($contactados -gt 0) {
        $txResp  = [Math]::Round(($rows | Where-Object { $_.status -in @("RESPONDEU","REUNIAO","PROPOSTA","FECHADO") }).Count / $contactados * 100, 1)
        $txFecho = [Math]::Round($totalFechado / $contactados * 100, 1)
        Write-Host "  Taxa de resposta  : $txResp%" -ForegroundColor Cyan
        Write-Host "  Taxa de fechamento: $txFecho%" -ForegroundColor Cyan
    }

    Write-Host ""
    Write-Host "  ─────────────────────────────────────────────────" -ForegroundColor DarkYellow
    Write-Host "  PROSPECTOS RECENTES (últimos 10)" -ForegroundColor Yellow
    Write-Host ""

    $rows | Select-Object -Last 10 | ForEach-Object {
        $color = StatusColor $_.status
        Write-Host ("  #{0,-4} {1,-30} {2,-14} {3,-8} {4}" -f $_.id, $_.dominio, $_.nicho, $_.score, $_.status) -ForegroundColor $color
    }

    Write-Host ""

    # Menu de acções
    Write-Host "  ACÇÕES:" -ForegroundColor DarkYellow
    Write-Host "  [1] Actualizar status de um prospecto"
    Write-Host "  [2] Ver prospectos a precisar de follow-up"
    Write-Host "  [3] Gerar mensagem para um prospecto"
    Write-Host "  [4] Exportar lista de hoje para WhatsApp"
    Write-Host "  [0] Sair"
    Write-Host ""

    $opcao = Read-Host "  Escolha"
    switch ($opcao) {
        "1" {
            $id = Read-Host "  ID do prospecto"
            Write-Host "  Status: NAO_CONTACTADO / CONTACTADO / RESPONDEU / REUNIAO / PROPOSTA / FECHADO / PERDIDO"
            $novo = Read-Host "  Novo status"
            AtualizarStatus $id $novo.ToUpper()
            Write-Host "  ✅ Actualizado." -ForegroundColor Green
        }
        "2" { VerFollowUp }
        "3" {
            $id  = Read-Host "  ID do prospecto"
            $row = LoadPipeline | Where-Object { $_.id -eq $id }
            if ($row) {
                $msg = GerarMensagem $row.dominio $row.nome_contato $row.score $row.receita_perdida $row.nicho
                Write-Host "`n$msg`n" -ForegroundColor White
                try { $msg | Set-Clipboard; Write-Host "  📋 Copiado!" -ForegroundColor Cyan } catch {}
            }
        }
        "4" { ExportarHoje }
    }
}

# ─── FUNÇÃO: Follow-up ────────────────────────────────────────────────────────
function VerFollowUp() {
    BannerTop "FOLLOW-UP NECESSÁRIO"

    $rows  = LoadPipeline
    $hoje  = Get-Date
    $urgentes = @()

    foreach ($r in $rows) {
        if ($r.status -eq "CONTACTADO" -and $r.data_contato -ne "") {
            $dias = ([datetime]$hoje - [datetime]$r.data_contato).Days
            if ($dias -ge 2) {
                $urgentes += [PSCustomObject]@{ row = $r; dias = $dias }
            }
        }
    }

    if ($urgentes.Count -eq 0) {
        Write-Host "  ✅ Nenhum follow-up pendente." -ForegroundColor Green
        return
    }

    Write-Host "  $($urgentes.Count) prospectos precisam de follow-up:" -ForegroundColor Yellow
    Write-Host ""

    foreach ($u in ($urgentes | Sort-Object dias -Descending)) {
        $r = $u.row
        Write-Host "  #$($r.id) $($r.dominio) — $($u.dias) dias sem resposta" -ForegroundColor Red
        $msg = GerarFollowUp $r.dominio $r.nome_contato $u.dias
        Write-Host $msg -ForegroundColor DarkGray
        Write-Host ""

        $acao = Read-Host "  [s] Copiar e marcar enviado  [p] Marcar como perdido  [Enter] Próximo"
        if ($acao -eq "s") {
            try { $msg | Set-Clipboard } catch {}
            if ($r.whatsapp -match "^\d{10,11}$") { Start-Process "https://wa.me/55$($r.whatsapp)" }
            Log "FOLLOWUP | #$($r.id) | $($r.dominio)"
        } elseif ($acao -eq "p") {
            AtualizarStatus $r.id "PERDIDO"
            Write-Host "  Marcado como PERDIDO." -ForegroundColor Red
        }
    }
}

# ─── FUNÇÃO: Scan + mensagem ──────────────────────────────────────────────────
function ScanProspecto($dominio) {
    BannerTop "SCAN: $dominio"

    # Abrir scanner na landing
    $scanUrl = "http://localhost:8080/?scan=$dominio"
    Write-Host "  Abrindo scanner para $dominio..." -ForegroundColor Cyan
    Start-Process $scanUrl

    Write-Host ""
    Write-Host "  Aguarde o scanner terminar e anote os resultados:" -ForegroundColor Yellow
    $score   = Read-Host "  Score obtido (0-10)"
    $receita = Read-Host "  Receita perdida estimada R$/mês (ex: 15000)"
    $nome    = Read-Host "  Nome do contacto (se encontrou)"
    $wpp     = Read-Host "  WhatsApp"
    $nicho   = Read-Host "  Nicho"

    # Adicionar ao pipeline
    $id   = NextId
    $hoje = Get-Date -Format "yyyy-MM-dd"
    $nova = [PSCustomObject]@{
        id              = $id
        data_add        = $hoje
        dominio         = $dominio
        nome_contato    = $nome
        whatsapp        = $wpp
        nicho           = $nicho
        score           = $score
        receita_perdida = $receita
        status          = "NAO_CONTACTADO"
        data_contato    = ""
        data_resposta   = ""
        notas           = "scanner:$hoje"
    }

    $rows = LoadPipeline
    $rows += $nova
    SavePipeline $rows

    Write-Host ""
    Write-Host "  ✅ #$id adicionado ao pipeline." -ForegroundColor Green

    $msg = GerarMensagem $dominio $nome $score $receita $nicho
    Write-Host ""
    Write-Host "  ─── MENSAGEM ─────────────────────────────────────" -ForegroundColor DarkYellow
    Write-Host $msg -ForegroundColor White
    Write-Host "  ─────────────────────────────────────────────────" -ForegroundColor DarkYellow
    try { $msg | Set-Clipboard; Write-Host "  📋 Copiado para clipboard!" -ForegroundColor Cyan } catch {}

    if ($wpp -match "^\d{10,11}$") { Start-Process "https://wa.me/55$wpp" }
    Log "SCAN | #$id | $dominio | score:$score | receita:$receita"
}

# ─── FUNÇÃO: Exportar mensagens do dia ───────────────────────────────────────
function ExportarHoje() {
    $rows    = LoadPipeline
    $naoEnv  = $rows | Where-Object { $_.status -eq "NAO_CONTACTADO" } | Select-Object -First 20
    $outPath = "$dataDir\mensagens_$(Get-Date -Format 'yyyy-MM-dd').txt"

    $conteudo = ""
    foreach ($r in $naoEnv) {
        $msg = GerarMensagem $r.dominio $r.nome_contato $r.score $r.receita_perdida $r.nicho
        $conteudo += "═══ #$($r.id) · $($r.dominio) · WhatsApp: $($r.whatsapp) ═══`n"
        $conteudo += $msg + "`n`n"
    }

    $conteudo | Out-File $outPath -Encoding utf8
    Write-Host "  ✅ $($naoEnv.Count) mensagens exportadas para $outPath" -ForegroundColor Green
    Start-Process $outPath
    Log "EXPORT | $($naoEnv.Count) mensagens | $outPath"
}

# ─── FUNÇÃO: Stats rápidas ────────────────────────────────────────────────────
function VerStats() {
    BannerTop "MÉTRICAS DO PIPELINE"

    $rows = LoadPipeline
    if ($rows.Count -eq 0) { Write-Host "  Pipeline vazio."; return }

    $total      = $rows.Count
    $contactados = ($rows | Where-Object { $_.status -ne "NAO_CONTACTADO" }).Count
    $responderam = ($rows | Where-Object { $_.status -in @("RESPONDEU","REUNIAO","PROPOSTA","FECHADO") }).Count
    $fechados    = ($rows | Where-Object { $_.status -eq "FECHADO" }).Count
    $mrr         = $fechados * 270

    Write-Host "  Total no pipeline : $total" -ForegroundColor White
    Write-Host "  Contactados       : $contactados" -ForegroundColor Yellow
    Write-Host "  Responderam       : $responderam" -ForegroundColor Cyan
    Write-Host "  Fechados          : $fechados" -ForegroundColor Green
    Write-Host "  MRR actual        : R$ $mrr/mês" -ForegroundColor Green
    Write-Host ""

    if ($contactados -gt 0) {
        $tx = [Math]::Round($responderam / $contactados * 100, 1)
        Write-Host "  Taxa de resposta  : $tx% $(if($tx -ge 15){'✅ acima da meta'}else{'⚠️ abaixo de 15%'})" -ForegroundColor $(if($tx -ge 15){"Green"}else{"Red"})
    }
    if ($responderam -gt 0) {
        $txf = [Math]::Round($fechados / $responderam * 100, 1)
        Write-Host "  Taxa de conversão : $txf% $(if($txf -ge 20){'✅'}else{'⚠️ abaixo de 20%'})" -ForegroundColor $(if($txf -ge 20){"Green"}else{"Red"})
    }

    Write-Host ""
    Write-Host "  META MÊS 1: R$1.350/mês (5 clientes × R$270)" -ForegroundColor DarkYellow
    $falta = [Math]::Max(0, 1350 - $mrr)
    Write-Host "  Faltam: R$ $falta ($(([Math]::Ceiling($falta / 270))) clientes)" -ForegroundColor $(if($falta -eq 0){"Green"}else{"Yellow"})
}

# ─── MENU PRINCIPAL ───────────────────────────────────────────────────────────
function MenuPrincipal() {
    BannerTop "MOTOR DE PROSPECÇÃO"

    Write-Host "  [1] Adicionar novo prospecto" -ForegroundColor White
    Write-Host "  [2] Ver pipeline completo" -ForegroundColor White
    Write-Host "  [3] Follow-up pendentes" -ForegroundColor Yellow
    Write-Host "  [4] Scan de um domínio" -ForegroundColor White
    Write-Host "  [5] Exportar mensagens do dia" -ForegroundColor White
    Write-Host "  [6] Ver métricas" -ForegroundColor Cyan
    Write-Host "  [0] Sair" -ForegroundColor DarkGray
    Write-Host ""

    $op = Read-Host "  Escolha"
    switch ($op) {
        "1" { AdicionarProspecto }
        "2" { VerPipeline }
        "3" { VerFollowUp }
        "4" {
            $d = Read-Host "  Domínio"
            ScanProspecto $d
        }
        "5" { ExportarHoje }
        "6" { VerStats }
        "0" { return }
        default { Write-Host "  Opção inválida." -ForegroundColor Red }
    }
}

# ─── ENTRY POINT ──────────────────────────────────────────────────────────────
if ($add)          { AdicionarProspecto }
elseif ($pipeline) { VerPipeline }
elseif ($scan)     { ScanProspecto $scan }
elseif ($followup) { VerFollowUp }
elseif ($stats)    { VerStats }
else               { MenuPrincipal }
