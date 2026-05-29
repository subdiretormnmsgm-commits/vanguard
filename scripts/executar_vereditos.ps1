#Requires -Version 5.1
# executar_vereditos.ps1 - Le VEREDITOS JSON e executa acoes automaticas do Musculo
# Uso: .\scripts\executar_vereditos.ps1 -projeto INGRID
#      .\scripts\executar_vereditos.ps1 -projeto VALDECE -data 2026-05-24

param(
    [Parameter(Mandatory=$true)]
    [string]$projeto,

    [string]$data = ""
)

$raiz = Split-Path -Parent $PSScriptRoot
Set-Location $raiz

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

$decisoesDir = "CLIENTES\$projeto\CLAUDE_PROJECT\DECISOES"

# --- 1. Localizar arquivo VEREDITOS ---
if ($data -eq "") {
    $files = Get-ChildItem "$decisoesDir\VEREDITOS_*.json" -ErrorAction SilentlyContinue |
             Sort-Object LastWriteTime -Descending
    if (-not $files) {
        Write-Error "Nenhum arquivo VEREDITOS_*.json encontrado em: $decisoesDir"
        Write-Host "Abra o Painel (render_painel.ps1), confirme os vereditos e salve o JSON na pasta."
        exit 1
    }
    $vreditosFile = $files[0].FullName
    Write-Host ("Usando arquivo: " + $files[0].Name)
} else {
    $vreditosFile = "$decisoesDir\VEREDITOS_${projeto}_${data}.json"
    if (-not (Test-Path $vreditosFile)) {
        Write-Error ("Arquivo nao encontrado: " + $vreditosFile)
        exit 1
    }
}

# --- 2. Ler JSON ---
try {
    $vrd = Get-Content $vreditosFile -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Error ("JSON invalido: " + $_)
    exit 1
}

$dataStr      = $vrd.data_decisoes
$projetoLabel = $vrd.projeto_label
$memoriaPath  = "CLIENTES\$projeto\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
$ledgerPath   = "INTELLIGENCE_LEDGER.md"
$logDir       = "CLIENTES\$projeto\HISTORICO"

Write-Host ""
Write-Host "==================================================="
Write-Host (" EXECUTANDO VEREDITOS - " + $projetoLabel + " . Loop " + $vrd.loop)
Write-Host "==================================================="
Write-Host ""

$acoesFinal = @()

$hypercareAtivo = if ($vrd.hypercare_ativo) { $vrd.hypercare_ativo } else { $false }

foreach ($vrd_item in $vrd.vereditos) {
    $titulo           = $vrd_item.titulo
    $valor            = $vrd_item.valor_selecionado
    $label            = $vrd_item.label_selecionado
    $texto            = $vrd_item.texto_final
    $acoes            = $vrd_item.acoes
    $requerUso        = if ($vrd_item.requer_uso_confirmado) { $vrd_item.requer_uso_confirmado } else { $false }
    $artefatoEditavel = if ($vrd_item.artefato_editavel)     { $vrd_item.artefato_editavel }     else { $false }

    Write-Host ("[" + $vrd_item.id + "] " + $titulo)
    Write-Host ("     Veredito: " + $label)

    if ($requerUso -and ($label -match "plantar_hoje|agora|imediato")) {
        Write-Host "     [AVISO D2] requer_uso_confirmado: true - uso ativo do cliente nao confirmado." -ForegroundColor Yellow
        Write-Host "               Esta decisao foi executada antes da confirmacao de uso. Registrar risco." -ForegroundColor Yellow
        $acoesFinal += ("[" + $vrd_item.id + "] AVISO: requer_uso_confirmado ativado - verificar confirmacao de uso")
    }

    if ($artefatoEditavel -and $hypercareAtivo) {
        Write-Host "     [GATE D1] Hypercare ativo - artefato editavel executado apos revisao do Diretor." -ForegroundColor Cyan
    }

    foreach ($acao in $acoes) {
        switch ($acao) {

            "log_apenas" {
                Write-Host "     -> Registrado (sem execucao automatica)"
            }

            "copiar_clipboard" {
                if ($texto) {
                    Set-Clipboard -Value $texto
                    Write-Host "     -> CLIPBOARD: texto copiado (pronto para colar no WhatsApp)"
                    $acoesFinal += ("[" + $vrd_item.id + "] Mensagem copiada para clipboard")
                }
            }

            "log_contato" {
                $dataHoje = Get-Date -Format "yyyy-MM-dd"
                $novaLinha = ("| " + $dataHoje + " | WhatsApp | Veredito: " + $label + " (" + $titulo + ") | VEREDITOS_" + $projeto + "_" + $dataStr + ".json |")
                if (Test-Path $memoriaPath) {
                    $conteudo = Get-Content $memoriaPath -Raw -Encoding UTF8
                    if ($conteudo -match '\|\s*Data\s*\|\s*Canal\s*\|') {
                        $linhas = $conteudo -split "`n"
                        $insertIdx = -1
                        for ($i = 0; $i -lt $linhas.Count; $i++) {
                            if ($linhas[$i] -match '\|\s*---') {
                                if ($i -gt 0 -and $linhas[$i-1] -match 'Canal') {
                                    $insertIdx = $i + 1
                                    break
                                }
                            }
                        }
                        if ($insertIdx -ge 0) {
                            $novo = ($linhas[0..($insertIdx-1)] + $novaLinha + $linhas[$insertIdx..($linhas.Count-1)]) -join "`n"
                            [System.IO.File]::WriteAllText((Resolve-Path $memoriaPath).Path, $novo, $utf8NoBom)
                            Write-Host ("     -> MEMORIA_EMBAIXADOR: contato registrado em " + $dataHoje)
                            $acoesFinal += ("[" + $vrd_item.id + "] Contato registrado na MEMORIA_EMBAIXADOR")
                        } else {
                            Write-Host "     -> MEMORIA_EMBAIXADOR: tabela CONTATOS nao encontrada - registro manual necessario"
                            Write-Host ("       Linha a inserir: " + $novaLinha)
                        }
                    } else {
                        Write-Host "     -> MEMORIA_EMBAIXADOR: estrutura nao encontrada - registro manual"
                    }
                } else {
                    Write-Host ("     -> MEMORIA_EMBAIXADOR nao encontrada em: " + $memoriaPath)
                }
            }

            "inscrever_ledger" {
                if ($texto) {
                    if (Test-Path $ledgerPath) {
                        $ledger  = Get-Content $ledgerPath -Raw -Encoding UTF8
                        $pMatches = [regex]::Matches($ledger, 'P-(\d{3})')
                        if ($pMatches.Count -gt 0) {
                            $ultimo  = ($pMatches | ForEach-Object { [int]$_.Groups[1].Value } | Measure-Object -Maximum).Maximum
                            $proximo = $ultimo + 1
                        } else {
                            $proximo = 57
                        }
                        $proximoInt = [int]($proximo.ToString() -replace '[^0-9]', '')
                        $pNum = "P-{0:D3}" -f $proximoInt
                        $dataHoje = Get-Date -Format "yyyy-MM-dd"
                        $entradaLedger = ("`n---`n`n## " + $pNum + " - PRINCIPIO EXTRAIDO DE PROJETO CLIENTE (" + $dataHoje + ")`n" +
                            "**Origem:** " + $projetoLabel + " . Loop " + $vrd.loop + " . Embaixador`n" +
                            "**Veredito:** " + $label + "`n`n> " + $texto + "`n`n" +
                            "**Aplicacao:** Usar como filtro em decisoes de produto e retencao em projetos EdTech/SaaS.")
                        Add-Content -Path $ledgerPath -Value $entradaLedger -Encoding UTF8
                        Write-Host ("     -> LEDGER: inscrito como " + $pNum)
                        $acoesFinal += ("[" + $vrd_item.id + "] Principio inscrito no LEDGER como " + $pNum)
                    } else {
                        Write-Host ("     -> LEDGER nao encontrado em: " + $ledgerPath)
                    }
                }
            }

            "criar_nota_regerar_pdf" {
                $nota = ("[ ] REGERAR PDF do Termo de " + $projetoLabel + " - data correta: 18/05/2026 (PDF atual: 30/05/2026)")
                Write-Host ("     -> PENDENTE registrado: " + $nota)
                if (Test-Path "PENDENTES.md") {
                    Add-Content -Path "PENDENTES.md" -Value ("`n" + $nota) -Encoding UTF8
                    Write-Host "     -> PENDENTES.md atualizado"
                }
                $acoesFinal += ("[" + $vrd_item.id + "] Nota criada: regerar PDF com data correta")
            }

            default {
                Write-Host ("     -> Acao '" + $acao + "' nao mapeada - execucao manual necessaria")
            }
        }
    }
    Write-Host ""
}

# P-032 -- TRIGGER: atualizar MEMORIA_EMBAIXADOR apos execucao de vereditos (ENTREGAVEL 11)
Write-Host ""
Write-Host "=================================================="
Write-Host "  P-032 -- MEMORIA_EMBAIXADOR"                       -ForegroundColor Cyan
Write-Host "=================================================="
Write-Host "  Deliberacao executada para: $projeto"
Write-Host "  Campos que provavelmente mudaram:"
Write-Host "    . Estado atual do loop"
Write-Host "    . Gates aprovados/pendentes"
Write-Host "    . Hipoteses confirmadas/refutadas"
Write-Host "    . Proxima acao recomendada"
Write-Host ""
Write-Host "  Musculo: atualizar CLIENTES\$projeto\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md" -ForegroundColor Yellow
Write-Host "  antes de declarar sessao encerrada."                -ForegroundColor Yellow
Write-Host "=================================================="

$dtP032 = Get-Date -Format "dd-MM-yyyy"
$dsP032 = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
$pendP032 = Join-Path $raiz "PENDENTES.md"
if (Test-Path $pendP032) {
    $exP032 = Get-Content $pendP032 -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if ($null -eq $exP032) { $exP032 = "" }
    if (-not ($exP032 -match ("P-032.*" + [regex]::Escape($projeto) + ".*" + [regex]::Escape($dtP032)))) {
        Add-Content $pendP032 "`n- [P-032 ($dtP032 $dsP032)] $projeto -- Atualizar MEMORIA_EMBAIXADOR apos deliberacao" -Encoding UTF8
        Write-Host "  [PENDENTES] P-032 registrado automaticamente." -ForegroundColor Green
    }
}

# --- 3. Arquivar LOG ---
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Force $logDir | Out-Null }
$logPath = Join-Path $raiz ($logDir + "\LOG_VEREDITOS_" + $projeto + "_" + (Get-Date -Format 'yyyyMMdd_HHmm') + ".txt")
$veredList = ($vrd.vereditos | ForEach-Object { "[" + $_.id + "] " + $_.titulo + ": " + $_.label_selecionado }) -join "`n"
$acoesList = $acoesFinal -join "`n"
$logContent = ("LOG DE EXECUCAO - VEREDITOS`n" +
    "Projeto  : " + $projetoLabel + "`n" +
    "Data     : " + $dataStr + "`n" +
    "Executado: " + (Get-Date -Format 'yyyy-MM-dd HH:mm') + "`n`n" +
    "VEREDITOS PROCESSADOS:`n" + $veredList + "`n`n" +
    "ACOES EXECUTADAS:`n" + $acoesList)
[System.IO.File]::WriteAllText($logPath, $logContent, $utf8NoBom)
Write-Host ("Log arquivado em: " + $logPath)

# --- 3.5. Gerar VEREDITOS_RESUMO.md para memoria do Embaixador ---
$resumoDir  = "CLIENTES\$projeto\CLAUDE_PROJECT"
$resumoPath = Join-Path $raiz ($resumoDir + "\VEREDITOS_RESUMO_" + $projeto + "_" + $dataStr + ".md")
$decisoesBloco = ($vrd.vereditos | ForEach-Object {
    $it = $_
    $textoLinha = if ($it.texto_final) { ("`n**Texto registrado:**`n> " + $it.texto_final) } else { "" }
    ("### [" + $it.id + "] " + $it.titulo + "`n**Veredito:** " + $it.label_selecionado + "`n**Acoes:** " + ($it.acoes -join ', ') + $textoLinha)
}) -join "`n`n"
$acoesBloco = if ($acoesFinal.Count -gt 0) { ($acoesFinal | ForEach-Object { "- " + $_ }) -join "`n" } else { "- Nenhuma acao automatica executada." }
$resumoContent = ("# VEREDITOS CONFIRMADOS - " + $projetoLabel + " . Loop " + $vrd.loop + "`n" +
    "**Data:** " + $dataStr + " . **Executado:** " + (Get-Date -Format 'yyyy-MM-dd HH:mm') + "`n`n" +
    "> Gerado automaticamente pelo Musculo. Carregar como Knowledge Document no Claude Project.`n" +
    "> Garante rastreabilidade de decisoes entre sessoes do Embaixador.`n`n" +
    "## Decisoes e Vereditos`n`n" + $decisoesBloco + "`n`n" +
    "## Acoes Executadas`n`n" + $acoesBloco + "`n`n---`n" +
    "*executar_vereditos.ps1 . Pentalateral IAH*")
[System.IO.File]::WriteAllText($resumoPath, $resumoContent, $utf8NoBom)
Write-Host ("VEREDITOS_RESUMO: VEREDITOS_RESUMO_" + $projeto + "_" + $dataStr + ".md") -ForegroundColor Green
Write-Host "  -> Carregar como Knowledge Document no Claude Project na proxima ativacao" -ForegroundColor DarkGray

# D3 - Gerar versao filtrada para cliente (resumo_para_cliente: true)
$decisoesCliente = $vrd.vereditos | Where-Object { $_.resumo_para_cliente -eq $true }
if ($decisoesCliente -and @($decisoesCliente).Count -gt 0) {
    $resumoClientePath = Join-Path $raiz ($resumoDir + "\VEREDITOS_RESUMO_" + $projeto + "_" + $dataStr + "_CLIENTE.md")
    $blocoCliente = ($decisoesCliente | ForEach-Object {
        $it = $_
        ("### " + $it.titulo + "`n**Resultado:** " + $it.label_selecionado)
    }) -join "`n`n"
    $resumoClienteContent = ("# RELATORIO DE CICLO - " + $projetoLabel + "`n" +
        "**Periodo:** " + $dataStr + "`n`n" +
        "> Relatorio gerado automaticamente pelo sistema. Mostravel ao cliente como Sentinel Report parcial.`n`n" +
        "## O que foi decidido neste ciclo`n`n" + $blocoCliente + "`n`n---`n" +
        "*Vanguard Tech . Pentalateral IAH*")
    [System.IO.File]::WriteAllText($resumoClientePath, $resumoClienteContent, $utf8NoBom)
    Write-Host ("VEREDITOS_RESUMO_CLIENTE: VEREDITOS_RESUMO_" + $projeto + "_" + $dataStr + "_CLIENTE.md") -ForegroundColor Green
    Write-Host "  -> Sentinel Report parcial - mostravel ao cliente diretamente" -ForegroundColor DarkGray
} else {
    Write-Host "  (Nenhuma decisao marcada como resumo_para_cliente: true neste ciclo)" -ForegroundColor DarkGray
}

# --- 4. Resumo final ---
Write-Host ""
Write-Host "==================================================="
Write-Host (" CICLO COMPLETO - " + $projetoLabel)
Write-Host "==================================================="
Write-Host ""
Write-Host "Acoes executadas:"
$acoesFinal | ForEach-Object { Write-Host ("  . " + $_) }
Write-Host ""
Write-Host "PROXIMOS PASSOS MANUAIS:"
Write-Host "  . Revisar MEMORIA_EMBAIXADOR.md - confirmar que P-032 esta aplicado"
Write-Host "  . Se LEDGER atualizado -> sync: .\scripts\session_close.ps1 -SyncOnly"
Write-Host "  . Se mensagem copiada -> colar no WhatsApp para $projetoLabel"
Write-Host ""
Write-Host "Painel fechado. Ciclo completo."
