# ============================================================
# BRIEFING_DIARIO.PS1 -- Briefing matinal do Diretor
# Le estado real dos projetos ativos via WIP_BOARD (P-096: universal)
# Agendado para rodar 7h automaticamente (registrar_briefing_agendado.ps1)
# Telegram: entrega garantida mesmo se e-mail falhar (canal primario)
# Uso manual: .\scripts\briefing_diario.ps1
# P-088: codigo-fonte 100% ASCII -- icones em TEMPLATES\briefing_labels.txt
# ============================================================

# P-096: localizacao universal -- detectar raiz do repo pela presenca de INTELLIGENCE_LEDGER.md
$_bdir = $PSScriptRoot
while ($_bdir -and -not (Test-Path "$_bdir\INTELLIGENCE_LEDGER.md")) {
    $_bparent = Split-Path -Parent $_bdir
    if ($_bparent -eq $_bdir) { break }
    $_bdir = $_bparent
}
$BASE = $_bdir
. "$BASE\scripts\alert_config.ps1"

# P-088: carregar labels do template externo (icones e separadores)
$lbl = @{}
$lblPath = "$BASE\PENTALATERAL_UNIVERSAL\TEMPLATES\briefing_labels.txt"
if (Test-Path $lblPath) {
    Get-Content $lblPath -Encoding UTF8 | Where-Object { $_ -match '^[^#].+=.' } | ForEach-Object {
        $k, $v = $_ -split '=', 2
        $lbl[$k.Trim()] = $v
    }
}
function lbl([string]$k) { if ($lbl.ContainsKey($k)) { $lbl[$k] } else { "[$k]" } }

$hoje      = Get-Date
$dataStr   = $hoje.ToString("yyyy-MM-dd")
$diaSemana = (Get-Culture).DateTimeFormat.GetDayName($hoje.DayOfWeek)
$amanha    = $hoje.AddDays(1).ToString("yyyy-MM-dd")

# $(lbl "SEP_DADOS") Le WIP_BOARD $(lbl "SEP_DADOS")
$wipPath = "$BASE\CLIENTES\WIP_BOARD.json"
$wip     = Get-Content $wipPath -Raw -Encoding UTF8 | ConvertFrom-Json
$projetos = $wip.board.build

# $(lbl "SEP_DADOS") Calendario do Projeto $(lbl "SEP_DADOS")
# Gera bloco visual com datas reais (dd/MM) por bloco de build
function Get-CalendarioProjeto {
    param($proj, $hoje)

    $linhas        = @()
    $deadline      = $proj.deadline
    $inicio        = $proj.build_iniciado_em
    $diasCompletos = @($proj.dias_completos)
    $planoBuild    = $proj.plano_build
    $deliveryDates = $proj.delivery_dates

    if (-not $planoBuild -or -not $inicio) { return "" }

    $nomesDia = @("Dom","Seg","Ter","Qua","Qui","Sex","Sab")

    # Maximo dia build concluido
    $maxDiaConcluido = 0
    foreach ($dc in $diasCompletos) {
        $nums = [regex]::Matches($dc, '\d+') | ForEach-Object { [int]$_.Value }
        foreach ($n in $nums) { if ($n -gt $maxDiaConcluido) { $maxDiaConcluido = $n } }
    }

    # Conta blocos totais/concluidos e maxDiaTotalPlano
    $maxDiaTotalPlano = 0
    $blocostotais     = 0
    $blocosConcluidos = 0
    foreach ($prop in $planoBuild.PSObject.Properties) {
        $nums = [regex]::Matches($prop.Name, '\d+') | ForEach-Object { [int]$_.Value }
        if ($nums.Count -eq 0) { continue }
        $maxB = ($nums | Measure-Object -Maximum).Maximum
        if ($maxB -gt $maxDiaTotalPlano) { $maxDiaTotalPlano = $maxB }
        $blocostotais++
        if ($maxDiaConcluido -ge $maxB) { $blocosConcluidos++ }
    }

    $blocosRestantes = $blocostotais - $blocosConcluidos
    $daysLeft        = ([datetime]$deadline - $hoje).Days
    $diasPorBloco    = if ($blocosRestantes -gt 0) { [Math]::Ceiling($daysLeft / $blocosRestantes) } else { 1 }

    $linhas += "$(lbl "ICONE_CALENDARIO") CALENDARIO DO PROJETO"

    $primeiroAtivo  = $true
    $blocoFuturoIdx = 0

    foreach ($prop in $planoBuild.PSObject.Properties) {
        $chave     = $prop.Name
        $descricao = $prop.Value

        $nums = [regex]::Matches($chave, '\d+') | ForEach-Object { [int]$_.Value }
        if ($nums.Count -eq 0) { continue }
        $minDia = ($nums | Measure-Object -Minimum).Minimum
        $maxDia = ($nums | Measure-Object -Maximum).Maximum

        $diaLabel = if ($minDia -eq $maxDia) {
            ("Dia $minDia").PadRight(9)
        } else {
            ("Dia $minDia-$maxDia").PadRight(9)
        }

        if ($maxDiaConcluido -ge $maxDia) {
            # Bloco concluido -- usa data real de delivery_dates se disponivel
            $dataBloco = $null
            if ($deliveryDates -and $deliveryDates.PSObject.Properties[$chave]) {
                $dataBloco = [datetime]$deliveryDates.PSObject.Properties[$chave].Value
            }
            if (-not $dataBloco) {
                $fracao    = if ($maxDiaTotalPlano -gt 0) { $maxDia / $maxDiaTotalPlano } else { 0.5 }
                $diasUsados = ($hoje - [datetime]$inicio).Days
                $dataBloco = ([datetime]$inicio).AddDays([Math]::Round($fracao * $diasUsados))
            }
            $diaAbrev  = $nomesDia[[int]$dataBloco.DayOfWeek]
            $dataLabel = ("$($dataBloco.ToString('dd/MM')) $diaAbrev").PadRight(10)
            $status    = "$(lbl "ICONE_OK")"
        } elseif ($maxDiaConcluido -ge ($minDia - 1) -and $primeiroAtivo) {
            # Bloco ativo hoje
            $diaAbrev  = $nomesDia[[int]$hoje.DayOfWeek]
            $dataLabel = ("$($hoje.ToString('dd/MM')) $diaAbrev").PadRight(10)
            $status    = "$(lbl "ICONE_ATIVO")"
            $primeiroAtivo  = $false
            $blocoFuturoIdx++
        } else {
            # Bloco futuro -- data estimada
            $estData   = $hoje.AddDays($blocoFuturoIdx * $diasPorBloco)
            $diaAbrev  = $nomesDia[[int]$estData.DayOfWeek]
            $dataLabel = "~$($estData.ToString('dd/MM')) $diaAbrev"
            $status    = "$(lbl "ICONE_FUTURO")"
            $blocoFuturoIdx++
        }

        $desc = if ($descricao.Length -gt 42) { $descricao.Substring(0, 39) + "..." } else { $descricao }
        $linhas += "$status  $diaLabel  $dataLabel  $desc"
    }

    # Linha de saude do cronograma
    $diasCalendarioGastos = [Math]::Max(1, ($hoje - [datetime]$inicio).Days + 1)
    $folga         = $daysLeft - ($maxDiaTotalPlano - $maxDiaConcluido)
    $dl            = [datetime]$deadline
    $deadlineLabel = "$($dl.ToString('dd/MM')) $($nomesDia[[int]$dl.DayOfWeek])"
    $icone = if ($folga -ge 3) { "$(lbl "ICONE_VERDE")" } elseif ($folga -ge 0) { "$(lbl "ICONE_AMARELO")" } else { "$(lbl "ICONE_VERMELHO")" }

    $linhas += "$(lbl "SEP_DADOS")" * 50
    $linhas += "$(lbl "ICONE_DADOS") Dia $maxDiaConcluido/$maxDiaTotalPlano | ${diasCalendarioGastos}d usados | ${daysLeft}d ate $deadlineLabel"
    if ($folga -ge 0) {
        $linhas += "$icone $folga dia(s) de folga real"
    } else {
        $linhas += "$icone ATRASADO -- $([Math]::Abs($folga)) dia(s) de deficit"
    }

    return ($linhas -join "`n")
}

# $(lbl "SEP_DADOS") Monta corpo do e-mail $(lbl "SEP_DADOS")
$linhas = @()
$linhas += "BRIEFING DO DIRETOR -- $dataStr ($diaSemana)"
$linhas += "=" * 60
$linhas += ""

$alertasCriticos = @()
$acoesDia        = @()

# $(lbl "SEP_DADOS") Bloco PENDENTES $(lbl "SEP_DADOS")
$pendentesPath = "$BASE\PENDENTES.md"
if (Test-Path $pendentesPath) {
    $pendentesRaw     = Get-Content $pendentesPath -Encoding UTF8
    $pendentesAbertos = $pendentesRaw | Where-Object { $_ -match '^\s*- \[ \]' }

    if ($pendentesAbertos.Count -gt 0) {
        # Parsear data e calcular atraso de cada pendente
        $parsedPendentes = foreach ($p in $pendentesAbertos) {
            $dataMatch = [regex]::Match($p, '`(\d{4}-\d{2}-\d{2})`')
            $dataPend  = if ($dataMatch.Success) { [datetime]$dataMatch.Groups[1].Value } else { $hoje }
            $atraso    = ($hoje - $dataPend).Days
            $texto     = $p -replace '^\s*- \[ \]\s*`[^`]+`\s*', '' -replace '\*\*([^*]+)\*\*', '$1'
            [PSCustomObject]@{ Atraso = $atraso; Data = $dataPend; Texto = $texto.Trim() }
        }

        # Ordenar: mais antigos primeiro
        $parsedPendentes = $parsedPendentes | Sort-Object Atraso -Descending

        $vencidos = @($parsedPendentes | Where-Object { $_.Atraso -gt 0 })
        $hoje_pendentes = @($parsedPendentes | Where-Object { $_.Atraso -eq 0 })

        $linhas += "$(lbl "SEP_LINHA")"
        $titulo = "$(lbl "ICONE_ALERTA") PENDENTES ($($pendentesAbertos.Count) abertos"
        if ($vencidos.Count -gt 0) { $titulo += " | $($vencidos.Count) EM ATRASO" }
        $linhas += "$titulo)"

        if ($vencidos.Count -gt 0) {
            $linhas += "  $(lbl "ICONE_ALERTA")  EM ATRASO -- deveriam ter sido feitos:"
            foreach ($p in $vencidos) {
                $label = if ($p.Atraso -eq 1) { "1 dia" } else { "$($p.Atraso) dias" }
                $linhas += "  $(lbl "ICONE_VERMELHO") [$label atrasado] $($p.Texto)"
            }
        }

        if ($hoje_pendentes.Count -gt 0) {
            if ($vencidos.Count -gt 0) { $linhas += "  -- adicionados hoje:" }
            foreach ($p in $hoje_pendentes) {
                $linhas += "  - $($p.Texto)"
            }
        }

        $linhas += ""

        # Pendentes vencidos viram alerta critico
        foreach ($p in $vencidos) {
            $alertasCriticos += "PENDENTE $($p.Atraso)d -- $($p.Texto.Substring(0, [Math]::Min(60, $p.Texto.Length)))"
        }
    }
}

foreach ($proj in $projetos) {
    $cliente  = $proj.cliente
    $projId   = $proj.id
    $deadline = $proj.deadline
    $status   = $proj.status
    $proximo  = $proj.proximo_passo

    # Le MEMORIA_EMBAIXADOR se existir
    $memoriaPath = "$BASE\CLIENTES\$($cliente.ToUpper())\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
    $memoriaExiste = Test-Path $memoriaPath
    $ultimoContato = $null
    $diasSemContato = $null
    $temperatura = $null
    $termoStatus = $null

    if ($memoriaExiste) {
        $memoria = Get-Content $memoriaPath -Raw -Encoding UTF8

        # Extrai Ultimo contato
        if ($memoria -match "Ultimo contato[^\n]*(\d{4}-\d{2}-\d{2})") {
            $ultimoContato  = [datetime]$matches[1]
            $diasSemContato = ($hoje - $ultimoContato).Days
        }

        # Extrai temperatura
        if ($memoria -match "Status atual:\s*(VERDE|AMARELO|VERMELHO)") {
            $temperatura = $matches[1]
        }

        # Extrai status do Termo
        if ($memoria -match "Termo[^\n]*(PENDENTE|assinado|ASSINADO)") {
            $termoStatus = $matches[1]
        }
    }

    # Calcula dias ate deadline
    $diasDeadline = $null
    if ($deadline) {
        try {
            $diasDeadline = ([datetime]$deadline - $hoje).Days
        } catch {}
    }

    # $(lbl "SEP_DADOS") Bloco do projeto $(lbl "SEP_DADOS")
    $linhas += "$(lbl "SEP_LINHA")"
    $linhas += "$projId -- $cliente"

    if ($temperatura) {
        $icone = switch ($temperatura) {
            "VERDE"    { "$(lbl "ICONE_VERDE")" }
            "AMARELO"  { "$(lbl "ICONE_AMARELO")" }
            "VERMELHO" { "$(lbl "ICONE_VERMELHO")" }
            default    { "[?]" }
        }
        $linhas += "Temperatura: $icone $temperatura"
    }

    if ($diasSemContato -ne $null) {
        $linhas += "Ultimo contato: $($ultimoContato.ToString('yyyy-MM-dd')) -- $diasSemContato dias atras"
    }

    if ($termoStatus -and $termoStatus -ne "assinado" -and $termoStatus -ne "ASSINADO") {
        $linhas += "$(lbl "ICONE_ALERTA")  Termo: PENDENTE"
        $alertasCriticos += "[$cliente] Termo nao assinado -- P-023 bloqueia entrega"
    }

    if ($diasDeadline -ne $null) {
        $urgencia = if ($diasDeadline -le 2) { "$(lbl "ICONE_VERMELHO")" } elseif ($diasDeadline -le 5) { "$(lbl "ICONE_AMARELO")" } else { "$(lbl "ICONE_VERDE")" }
        $linhas += "Deadline: $deadline ($urgencia $diasDeadline dias)"
    }

    # $(lbl "SEP_DADOS") Calendario do projeto $(lbl "SEP_DADOS")
    $blocoCalendario = Get-CalendarioProjeto -proj $proj -hoje $hoje
    if ($blocoCalendario) {
        $linhas += ""
        $linhas += $blocoCalendario
    }

    $linhas += ""
    $linhas += "STATUS: $status"
    $linhas += ""

    # $(lbl "SEP_DADOS") ACOES do dia $(lbl "SEP_DADOS")
    $linhas += "ACOES DE HOJE:"

    # P-096: demo -- usa campo demo_realizada do WIP_BOARD (generico, sem hardcode de cliente)
    if ($proj.PSObject.Properties["demo_realizada"] -ne $null) {
        $demoData = $null
        if ($proximo -match "DEMO (\d{4}-\d{2}-\d{2})") { $demoData = $matches[1] }
        if (-not $demoData -and -not $proj.demo_realizada) {
            $demoData = $dataStr  # fallback: se demo nao realizada, assume hoje
        }
        if ($demoData -and ($demoData -eq $dataStr -or $demoData -eq $amanha)) {
            $quando = if ($demoData -eq $dataStr) { "HOJE" } else { "AMANHA" }
            $linhas += "  -> $(lbl 'ICONE_VERMELHO') DEMO $cliente $quando ($demoData) -- MOMENTO CRITICO DO PROJETO"
            $linhas += "  -> Leia MEMORIA_EMBAIXADOR (30 seg) antes de sair"
            $linhas += "  -> Roteiro: 3-temas question -> busca -> cliente digita 4a sozinho -> contrato"
            $linhas += "  -> Linha de fechamento: 'O sistema e seu. Isso aqui so formaliza.'"
            $alertasCriticos += "[$cliente] DEMO $quando -- primeira busca dele e o momento de virada"
            $acoesDia += "$cliente`: DEMO $quando -- leia MEMORIA_EMBAIXADOR + roteiro 3-temas"
        }
    }

    # P-096: presencial -- usa campo status do WIP_BOARD (generico, sem hardcode de cliente)
    if (($proj.deadline_anterior -or ($deadline -eq $amanha)) -and $status -match "presencial") {
        $linhas += "  -> PRESENCIAL AMANHA -- Leia MEMORIA_EMBAIXADOR antes de sair"
        $linhas += "  -> Leve WATCHDOG_TEMPLATE preenchido"
        $linhas += "  -> Ao voltar: preencher protocolo de debrief (7 campos) e relatar ao Embaixador"
        $acoesDia += "$cliente`: PRESENCIAL -- leia MEMORIA_EMBAIXADOR e prepare o debrief"
    }

    # Dias sem contato -> reativar
    if ($diasSemContato -ge 2 -and $temperatura -ne "VERMELHO") {
        $linhas += "  -> $diasSemContato dias sem contato -- verificar se respondeu / enviar reativacao"
        $acoesDia += "$cliente`: $diasSemContato dias sem contato -- acao necessaria"
    }
    if ($diasSemContato -ge 4) {
        $alertasCriticos += "[$cliente] $diasSemContato dias sem contato -- risco VERMELHO se nao agir hoje"
    }

    # P-096: relatorio semanal -- usa campo relatorio_semanal do WIP_BOARD (sem hardcode de cliente)
    if ($proj.PSObject.Properties["relatorio_semanal"] -ne $null -and $proj.relatorio_semanal -and
        $hoje.DayOfWeek -eq [System.DayOfWeek]::Sunday) {
        $cliUp = $cliente.ToUpper()
        $linhas += "  -> GATE FORMAL: Relatorio Semanal -- copiar metricas do Supabase e enviar WhatsApp"
        $linhas += "  -> Script: .\scripts\alerta_whatsapp.ps1 -cliente $cliUp -tipo RELATORIO_SEMANAL"
        $alertasCriticos += "[$cliente] DOMINGO -- relatorio semanal obrigatorio (E-3 gate formal)"
    }

    # PROXIMO passo
    if ($proximo) {
        $linhas += ""
        $linhas += "PROXIMO PASSO:"
        $linhas += "  $proximo"
    }

    $linhas += ""
}

# $(lbl "SEP_DADOS") Resumo de alertas criticos $(lbl "SEP_DADOS")
if ($alertasCriticos.Count -gt 0) {
    $linhas += "$(lbl "SEP_LINHA")"
    $linhas += "$(lbl "ICONE_VERMELHO") ALERTAS criticoS -- RESOLVER HOJE"
    foreach ($a in $alertasCriticos) {
        $linhas += "  - $a"
    }
    $linhas += ""
}

# $(lbl "SEP_DADOS") Comandos rapidos $(lbl "SEP_DADOS")
$linhas += "$(lbl "SEP_LINHA")"
$linhas += "COMANDOS rapidos"
$linhas += "  Embaixador Valdece : .\scripts\ir_ao_embaixador.ps1 -cliente VALDECE"
$linhas += "  Embaixador Ingrid  : .\scripts\ir_ao_embaixador.ps1 -cliente INGRID"
$linhas += "  WhatsApp Ingrid B1 : .\scripts\alerta_whatsapp.ps1 -cliente INGRID -tipo B1"
$linhas += "  WhatsApp Ingrid Rel: .\scripts\alerta_whatsapp.ps1 -cliente INGRID -tipo RELATORIO_SEMANAL"
$linhas += ""
$linhas += "-- Pentalateral IAH | Musculo"

$corpo = $linhas -join "`n"

# $(lbl "SEP_DADOS") Funcao: envia texto ao Telegram com split automatico $(lbl "SEP_DADOS")
function Send-Telegram {
    param([string]$Texto)
    $url      = "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage"
    $maxLen   = 4000
    $offset   = 0
    $partes   = 0
    while ($offset -lt $Texto.Length) {
        $parte = $Texto.Substring($offset, [Math]::Min($maxLen, $Texto.Length - $offset))
        try {
            Invoke-RestMethod -Uri $url -Method POST -Body @{
                chat_id = $TELEGRAM_CHAT_ID
                text    = $parte
            } | Out-Null
        } catch {
            Write-Host "$(lbl "ICONE_ALERTA")  Telegram (parte $($partes+1)): $($_.Exception.Message)" -ForegroundColor Yellow
        }
        $offset += $maxLen
        $partes++
        if ($partes -gt 1) { Start-Sleep -Milliseconds 300 }
    }
    return $partes
}

# $(lbl "SEP_DADOS") Envia briefing completo via Telegram $(lbl "SEP_DADOS")
$cabecalhoTelegram = if ($alertasCriticos.Count -gt 0) {
    "$(lbl "ICONE_VERMELHO") BRIEFING $dataStr -- $($alertasCriticos.Count) ALERTA(S) CRITICO(S)`n`n"
} else {
    "$(lbl "ICONE_OK") BRIEFING $dataStr -- Pentalateral IAH -- nenhum alerta`n`n"
}

$partesTelegram = Send-Telegram ($cabecalhoTelegram + $corpo)
Write-Host "$(lbl "ICONE_TELEGRAM") Briefing enviado ao Telegram ($partesTelegram parte(s))" -ForegroundColor Cyan

# $(lbl "SEP_DADOS") Envia e-mail $(lbl "SEP_DADOS")
$assuntoEmail = if ($alertasCriticos.Count -gt 0) {
    "$(lbl "ICONE_VERMELHO") BRIEFING $dataStr -- $($alertasCriticos.Count) ALERTA(S) -- Pentalateral IAH"
} else {
    "BRIEFING $dataStr -- Pentalateral IAH"
}

try {
    $smtp = New-Object Net.Mail.SmtpClient("smtp.gmail.com", 587)
    $smtp.EnableSsl     = $true
    $smtp.Credentials  = New-Object Net.NetworkCredential($ALERT_FROM, $ALERT_SENHA)

    $msg                 = New-Object Net.Mail.MailMessage
    $msg.From            = $ALERT_FROM
    $msg.To.Add($ALERT_TO)
    $msg.Subject         = $assuntoEmail
    $msg.Body            = $corpo
    $msg.BodyEncoding    = [System.Text.Encoding]::UTF8

    $smtp.Send($msg)
    Write-Host "$(lbl "ICONE_EMAIL")  Briefing enviado para $ALERT_TO" -ForegroundColor Green
} catch {
    Write-Host "$(lbl "ICONE_ERRO") ERRO ao enviar e-mail: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   (Briefing ja foi entregue pelo Telegram)" -ForegroundColor Yellow
}
