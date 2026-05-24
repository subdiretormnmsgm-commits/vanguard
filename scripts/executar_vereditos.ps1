#Requires -Version 5.1
# executar_vereditos.ps1 — Lê VEREDITOS JSON e executa ações automáticas do Músculo
# Uso: .\scripts\executar_vereditos.ps1 -projeto INGRID
#      .\scripts\executar_vereditos.ps1 -projeto VALDECE -data 2026-05-24

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("INGRID","VALDECE")]
    [string]$projeto,

    [string]$data = ""
)

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

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
    Write-Host "Usando arquivo: $($files[0].Name)"
} else {
    $vreditosFile = "$decisoesDir\VEREDITOS_${projeto}_${data}.json"
    if (-not (Test-Path $vreditosFile)) {
        Write-Error "Arquivo não encontrado: $vreditosFile"
        exit 1
    }
}

# --- 2. Ler JSON ---
try {
    $vrd = Get-Content $vreditosFile -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Error "JSON inválido: $_"
    exit 1
}

$dataStr = $vrd.data_decisoes
$projetoLabel = $vrd.projeto_label
$memoriaPath = "CLIENTES\$projeto\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR.md"
$ledgerPath  = "INTELLIGENCE_LEDGER.md"
$logDir      = "CLIENTES\$projeto\HISTORICO"

Write-Host ""
Write-Host "==================================================="
Write-Host " EXECUTANDO VEREDITOS — $projetoLabel · Loop $($vrd.loop)"
Write-Host "==================================================="
Write-Host ""

$acoesFinal = @()

$hypercareAtivo = if ($vrd.hypercare_ativo) { $vrd.hypercare_ativo } else { $false }

foreach ($vrd_item in $vrd.vereditos) {
    $titulo = $vrd_item.titulo
    $valor  = $vrd_item.valor_selecionado
    $label  = $vrd_item.label_selecionado
    $texto  = $vrd_item.texto_final
    $acoes  = $vrd_item.acoes
    $requerUso = if ($vrd_item.requer_uso_confirmado) { $vrd_item.requer_uso_confirmado } else { $false }
    $artefatoEditavel = if ($vrd_item.artefato_editavel) { $vrd_item.artefato_editavel } else { $false }

    Write-Host "[$($vrd_item.id)] $titulo"
    Write-Host "     Veredito: $label"

    # D2: Verificar requer_uso_confirmado
    if ($requerUso -and ($label -match "plantar_hoje|agora|imediato")) {
        Write-Host "     [AVISO D2] requer_uso_confirmado: true — uso ativo do cliente nao confirmado." -ForegroundColor Yellow
        Write-Host "               Esta decisao foi executada antes da confirmacao de uso. Registrar risco." -ForegroundColor Yellow
        $acoesFinal += "[$($vrd_item.id)] AVISO: requer_uso_confirmado ativado — verificar confirmacao de uso"
    }

    # D1 gate: artefato_editavel em Hypercare — log para rastreabilidade
    if ($artefatoEditavel -and $hypercareAtivo) {
        Write-Host "     [GATE D1] Hypercare ativo — artefato editavel executado apos revisao do Diretor." -ForegroundColor Cyan
    }

    foreach ($acao in $acoes) {
        switch ($acao) {

            "log_apenas" {
                Write-Host "     → Registrado (sem execução automática)"
            }

            "copiar_clipboard" {
                if ($texto) {
                    Set-Clipboard -Value $texto
                    Write-Host "     → CLIPBOARD: texto copiado (pronto para colar no WhatsApp)"
                    $acoesFinal += "[$($vrd_item.id)] Mensagem copiada para clipboard"
                }
            }

            "log_contato" {
                $dataHoje = Get-Date -Format "yyyy-MM-dd"
                $novaLinha = "| $dataHoje | WhatsApp | Veredito: $label ($titulo) | VEREDITOS_${projeto}_${dataStr}.json |"
                if (Test-Path $memoriaPath) {
                    $conteudo = Get-Content $memoriaPath -Raw -Encoding UTF8
                    # Insere após a linha do cabeçalho da tabela CONTATOS REGISTRADOS
                    if ($conteudo -match '\|\s*Data\s*\|\s*Canal\s*\|') {
                        $linhas = $conteudo -split "`n"
                        $insertIdx = -1
                        for ($i = 0; $i -lt $linhas.Count; $i++) {
                            if ($linhas[$i] -match '\|\s*---') {
                                # Encontrar a linha de separador depois do cabeçalho de contatos
                                if ($i -gt 0 -and $linhas[$i-1] -match 'Canal') {
                                    $insertIdx = $i + 1
                                    break
                                }
                            }
                        }
                        if ($insertIdx -ge 0) {
                            $novo = ($linhas[0..($insertIdx-1)] + $novaLinha + $linhas[$insertIdx..($linhas.Count-1)]) -join "`n"
                            $novo | Out-File $memoriaPath -Encoding utf8NoBOM -NoNewline
                            Write-Host "     → MEMORIA_EMBAIXADOR: contato registrado em $dataHoje"
                            $acoesFinal += "[$($vrd_item.id)] Contato registrado na MEMORIA_EMBAIXADOR"
                        } else {
                            Write-Host "     → MEMORIA_EMBAIXADOR: tabela CONTATOS não encontrada — registro manual necessário"
                            Write-Host "       Linha a inserir: $novaLinha"
                        }
                    } else {
                        Write-Host "     → MEMORIA_EMBAIXADOR: estrutura não encontrada — registro manual"
                    }
                } else {
                    Write-Host "     → MEMORIA_EMBAIXADOR não encontrada em: $memoriaPath"
                }
            }

            "inscrever_ledger" {
                if ($texto) {
                    # Encontrar próximo número P-NNN
                    if (Test-Path $ledgerPath) {
                        $ledger = Get-Content $ledgerPath -Raw -Encoding UTF8
                        $matches = [regex]::Matches($ledger, 'P-(\d{3})')
                        if ($matches.Count -gt 0) {
                            $ultimo = ($matches | ForEach-Object { [int]$_.Groups[1].Value } | Measure-Object -Maximum).Maximum
                            $proximo = $ultimo + 1
                        } else {
                            $proximo = 57
                        }
                        $pNum = "P-{0:D3}" -f $proximo
                        $dataHoje = Get-Date -Format "yyyy-MM-dd"
                        $entradaLedger = @"

---

## $pNum — PRINCÍPIO EXTRAÍDO DE PROJETO CLIENTE ($dataHoje)
**Origem:** $projetoLabel · Loop $($vrd.loop) · Embaixador
**Veredito:** $label

> $texto

**Aplicação:** Usar como filtro em decisões de produto e retenção em projetos EdTech/SaaS.
"@
                        Add-Content -Path $ledgerPath -Value $entradaLedger -Encoding UTF8
                        Write-Host "     → LEDGER: inscrito como $pNum"
                        $acoesFinal += "[$($vrd_item.id)] Princípio inscrito no LEDGER como $pNum"
                    } else {
                        Write-Host "     → LEDGER não encontrado em: $ledgerPath"
                    }
                }
            }

            "criar_nota_regerar_pdf" {
                $nota = "[ ] REGERAR PDF do Termo de $projetoLabel — data correta: 18/05/2026 (PDF atual: 30/05/2026)"
                Write-Host "     → PENDENTE registrado: $nota"
                # Inserir em PENDENTES.md se existir
                if (Test-Path "PENDENTES.md") {
                    Add-Content -Path "PENDENTES.md" -Value "`n$nota" -Encoding UTF8
                    Write-Host "     → PENDENTES.md atualizado"
                }
                $acoesFinal += "[$($vrd_item.id)] Nota criada: regerar PDF com data correta"
            }

            default {
                Write-Host "     → Ação '$acao' não mapeada — execução manual necessária"
            }
        }
    }
    Write-Host ""
}

# --- 3. Arquivar LOG ---
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Force $logDir | Out-Null }
$logPath = "$logDir\LOG_VEREDITOS_${projeto}_$(Get-Date -Format 'yyyyMMdd_HHmm').txt"
$logContent = @"
LOG DE EXECUÇÃO — VEREDITOS
Projeto  : $projetoLabel
Data     : $dataStr
Executado: $(Get-Date -Format 'yyyy-MM-dd HH:mm')

VEREDITOS PROCESSADOS:
$($vrd.vereditos | ForEach-Object { "[$($_.id)] $($_.titulo): $($_.label_selecionado)" } | Out-String)

AÇÕES EXECUTADAS:
$($acoesFinal | Out-String)
"@
$logContent | Out-File $logPath -Encoding utf8NoBOM
Write-Host "Log arquivado em: $logPath"

# --- 3.5. Gerar VEREDITOS_RESUMO.md para memória do Embaixador ---
$resumoDir = "CLIENTES\$projeto\CLAUDE_PROJECT"
if (-not (Test-Path $resumoDir)) { New-Item -ItemType Directory -Force $resumoDir | Out-Null }
$resumoPath = "$resumoDir\VEREDITOS_RESUMO_${projeto}_${dataStr}.md"
$decisoesBloco = ($vrd.vereditos | ForEach-Object {
    $it = $_
    $textoLinha = if ($it.texto_final) { "`n**Texto registrado:**`n> $($it.texto_final)" } else { "" }
    "### [$($it.id)] $($it.titulo)`n**Veredito:** $($it.label_selecionado)`n**Ações:** $($it.acoes -join ', ')$textoLinha"
}) -join "`n`n"
$acoesBloco = if ($acoesFinal.Count -gt 0) { ($acoesFinal | ForEach-Object { "- $_" }) -join "`n" } else { "- Nenhuma ação automática executada." }
$resumoContent = @"
# VEREDITOS CONFIRMADOS — $projetoLabel · Loop $($vrd.loop)
**Data:** $dataStr · **Executado:** $(Get-Date -Format 'yyyy-MM-dd HH:mm')

> Gerado automaticamente pelo Músculo. Carregar como Knowledge Document no Claude Project.
> Garante rastreabilidade de decisões entre sessões do Embaixador.

## Decisões e Vereditos

$decisoesBloco

## Ações Executadas

$acoesBloco

---
*executar_vereditos.ps1 · Pentalateral IAH*
"@
$resumoContent | Out-File $resumoPath -Encoding utf8NoBOM
Write-Host "VEREDITOS_RESUMO: $($resumoPath.Split('\')[-1])" -ForegroundColor Green
Write-Host "  → Carregar como Knowledge Document no Claude Project na proxima ativacao" -ForegroundColor DarkGray

# D3 — Gerar versao filtrada para cliente (resumo_para_cliente: true)
$decisoesCliente = $vrd.vereditos | Where-Object { $_.resumo_para_cliente -eq $true }
if ($decisoesCliente -and $decisoesCliente.Count -gt 0) {
    $resumoClientePath = "$resumoDir\VEREDITOS_RESUMO_${projeto}_${dataStr}_CLIENTE.md"
    $blocoCliente = ($decisoesCliente | ForEach-Object {
        $it = $_
        "### $($it.titulo)`n**Resultado:** $($it.label_selecionado)"
    }) -join "`n`n"
    $resumoClienteContent = @"
# RELATÓRIO DE CICLO — $projetoLabel
**Período:** $dataStr

> Relatório gerado automaticamente pelo sistema. Mostrável ao cliente como Sentinel Report parcial.

## O que foi decidido neste ciclo

$blocoCliente

---
*Vanguard Tech · Pentalateral IAH*
"@
    $resumoClienteContent | Out-File $resumoClientePath -Encoding utf8NoBOM
    Write-Host "VEREDITOS_RESUMO_CLIENTE: $($resumoClientePath.Split('\')[-1])" -ForegroundColor Green
    Write-Host "  → Sentinel Report parcial — mostravel ao cliente diretamente" -ForegroundColor DarkGray
} else {
    Write-Host "  (Nenhuma decisao marcada como resumo_para_cliente: true neste ciclo)" -ForegroundColor DarkGray
}

# --- 4. Resumo final ---
Write-Host ""
Write-Host "==================================================="
Write-Host " CICLO COMPLETO — $projetoLabel"
Write-Host "==================================================="
Write-Host ""
Write-Host "Ações executadas:"
$acoesFinal | ForEach-Object { Write-Host "  · $_" }
Write-Host ""

# Lembrar o Músculo de atualizar MEMORIA_EMBAIXADOR via P-032
Write-Host "PRÓXIMOS PASSOS MANUAIS:"
Write-Host "  · Revisar MEMORIA_EMBAIXADOR.md — confirmar que P-032 está aplicado"
Write-Host "  · Se LEDGER atualizado → sync: .\scripts\session_close.ps1 -SyncOnly"
Write-Host "  · Se mensagem copiada → colar no WhatsApp para $projetoLabel"
Write-Host ""
Write-Host "Painel fechado. Ciclo completo."
