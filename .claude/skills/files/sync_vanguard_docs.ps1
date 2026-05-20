# sync_vanguard_docs.ps1
# Vanguard Doc Sync — Script do Músculo
# Versão: 1.0 | 2026-05-19
# Baseado em: P-033 — Sync universal → projetos é obrigatório e imediato
#
# USO:
#   .\scripts\sync_vanguard_docs.ps1                         # sync completo (padrão)
#   .\scripts\sync_vanguard_docs.ps1 -cliente VALDECE        # só um projeto
#   .\scripts\sync_vanguard_docs.ps1 -modo verificar         # só inventário, sem alterar
#   .\scripts\sync_vanguard_docs.ps1 -verbose                # mostra cada arquivo
#   .\scripts\sync_vanguard_docs.ps1 -promover "FILE.md" -destino "UNIVERSAL\BASE\"
#   .\scripts\sync_vanguard_docs.ps1 -deletar "CLIENTES\PROJ\FONTES\FILE.md"

param(
    [string]$cliente = "",
    [ValidateSet("completo", "verificar")]
    [string]$modo = "completo",
    [switch]$verbose,
    [string]$promover = "",
    [string]$destino = "",
    [string]$deletar = ""
)

# ─────────────────────────────────────────────
# CONFIGURAÇÃO — ajustar se a estrutura mudar
# ─────────────────────────────────────────────

$RAIZ = (Get-Item -Path ".").FullName   # detecta a raiz onde o script é chamado
$UNIVERSAL_BASE = Join-Path $RAIZ "QUADRILATERAL_UNIVERSAL\NOTEBOOKLM_BASE"
$CLIENTES_DIR   = Join-Path $RAIZ "CLIENTES"
$DATA_HOJE      = Get-Date -Format "yyyyMMdd"
$RELATORIO_PATH = Join-Path $RAIZ "SYNC_REPORT_$DATA_HOJE.md"

# ─────────────────────────────────────────────
# FUNÇÕES AUXILIARES
# ─────────────────────────────────────────────

function Get-FileHash256 {
    param([string]$path)
    if (Test-Path $path) {
        return (Get-FileHash -Path $path -Algorithm SHA256).Hash
    }
    return $null
}

function Write-Log {
    param([string]$msg, [string]$cor = "White")
    Write-Host $msg -ForegroundColor $cor
}

function Write-Relatorio {
    param([string]$linha)
    Add-Content -Path $RELATORIO_PATH -Value $linha -Encoding UTF8
}

# ─────────────────────────────────────────────
# AÇÃO ESPECIAL: PROMOVER ÓRFÃO PARA UNIVERSAL
# ─────────────────────────────────────────────

if ($promover -ne "") {
    if ($destino -eq "") {
        Write-Log "ERRO: -destino é obrigatório ao usar -promover." "Red"
        exit 1
    }
    $destino_completo = Join-Path $RAIZ $destino
    if (-not (Test-Path $destino_completo)) {
        New-Item -ItemType Directory -Path $destino_completo -Force | Out-Null
    }
    Copy-Item -Path $promover -Destination $destino_completo -Force
    Write-Log "✅ PROMOVIDO: $promover → $destino_completo" "Green"
    exit 0
}

# ─────────────────────────────────────────────
# AÇÃO ESPECIAL: DELETAR ÓRFÃO (após veredito do Diretor)
# ─────────────────────────────────────────────

if ($deletar -ne "") {
    $alvo = Join-Path $RAIZ $deletar
    if (Test-Path $alvo) {
        Remove-Item -Path $alvo -Force
        Write-Log "🗑️  DELETADO: $alvo" "Yellow"
    } else {
        Write-Log "⚠️  Arquivo não encontrado: $alvo" "Yellow"
    }
    exit 0
}

# ─────────────────────────────────────────────
# VALIDAÇÃO INICIAL
# ─────────────────────────────────────────────

if (-not (Test-Path $UNIVERSAL_BASE)) {
    Write-Log "" 
    Write-Log "❌ BLOQUEIO: Pasta QUADRILATERAL_UNIVERSAL\NOTEBOOKLM_BASE\ não encontrada." "Red"
    Write-Log "   Caminho esperado: $UNIVERSAL_BASE" "Red"
    Write-Log "   Execute este script na raiz do projeto Vanguard." "Red"
    exit 1
}

if (-not (Test-Path $CLIENTES_DIR)) {
    Write-Log ""
    Write-Log "❌ BLOQUEIO: Pasta CLIENTES\ não encontrada." "Red"
    Write-Log "   Caminho esperado: $CLIENTES_DIR" "Red"
    exit 1
}

# ─────────────────────────────────────────────
# INICIALIZAR RELATÓRIO
# ─────────────────────────────────────────────

# Sobrescreve relatório do dia se já existir
if (Test-Path $RELATORIO_PATH) { Remove-Item $RELATORIO_PATH }

Write-Relatorio "# VANGUARD DOC SYNC — RELATÓRIO $DATA_HOJE"
Write-Relatorio "> Gerado automaticamente por sync_vanguard_docs.ps1"
Write-Relatorio "> Princípio: P-033 — Sync universal → projetos é obrigatório e imediato"
Write-Relatorio ""
Write-Relatorio "---"
Write-Relatorio ""

# ─────────────────────────────────────────────
# DETECTAR PROJETOS ATIVOS
# ─────────────────────────────────────────────

$projetos = @()

if ($cliente -ne "") {
    $proj_path = Join-Path $CLIENTES_DIR $cliente
    if (Test-Path $proj_path) {
        $projetos = @($proj_path)
    } else {
        Write-Log "❌ Projeto '$cliente' não encontrado em CLIENTES\." "Red"
        exit 1
    }
} else {
    $projetos = Get-ChildItem -Path $CLIENTES_DIR -Directory | ForEach-Object { $_.FullName }
}

Write-Log ""
Write-Log "══════════════════════════════════════════════════" "Cyan"
Write-Log "  VANGUARD DOC SYNC — $DATA_HOJE" "Cyan"
Write-Log "══════════════════════════════════════════════════" "Cyan"
Write-Log "  Modo: $modo" "Cyan"
Write-Log "  Projetos: $($projetos.Count)" "Cyan"
Write-Log "  Fonte universal: $UNIVERSAL_BASE" "Cyan"
Write-Log "══════════════════════════════════════════════════" "Cyan"
Write-Log ""

# ─────────────────────────────────────────────
# RODADA 1 — INVENTÁRIO
# ─────────────────────────────────────────────

Write-Log "▶ RODADA 1 — INVENTÁRIO" "Yellow"
Write-Relatorio "## RODADA 1 — INVENTÁRIO"
Write-Relatorio ""

$arquivos_universais = Get-ChildItem -Path $UNIVERSAL_BASE -File | Where-Object { $_.Extension -eq ".md" }
$total_universal = $arquivos_universais.Count

Write-Log "  Arquivos universais encontrados: $total_universal" "White"
Write-Relatorio "Arquivos em QUADRILATERAL_UNIVERSAL\NOTEBOOKLM_BASE\: $total_universal"
Write-Relatorio ""

# Estrutura para guardar o inventário
$inventario = @{}   # chave: "PROJETO|ARQUIVO" → status

$contadores = @{
    SYNC        = 0
    DESATUAL    = 0
    AUSENTE     = 0
    ORFAO       = 0
}

foreach ($proj_path in $projetos) {
    $proj_nome = Split-Path $proj_path -Leaf
    $fontes_dir = Join-Path $proj_path "NOTEBOOKLM_FONTES"

    Write-Log ""
    Write-Log "  Projeto: $proj_nome" "White"
    Write-Relatorio "### Projeto: $proj_nome"
    Write-Relatorio ""

    if (-not (Test-Path $fontes_dir)) {
        Write-Log "    ⚠️  NOTEBOOKLM_FONTES\ não existe — será criada na Rodada 2" "Yellow"
        Write-Relatorio "⚠️  NOTEBOOKLM_FONTES\ não existe — será criada na Rodada 2"
        Write-Relatorio ""
        # Todos os arquivos universais serão AUSENTE
        foreach ($arq in $arquivos_universais) {
            $inventario["$proj_nome|$($arq.Name)"] = "AUSENTE"
            $contadores.AUSENTE++
            if ($verbose) { Write-Log "    ❌ AUSENTE: $($arq.Name)" "DarkGray" }
        }
        continue
    }

    # Verificar arquivos universais vs. cópias no projeto
    foreach ($arq in $arquivos_universais) {
        $copia_path = Join-Path $fontes_dir $arq.Name
        $hash_universal = Get-FileHash256 -path $arq.FullName

        if (-not (Test-Path $copia_path)) {
            $inventario["$proj_nome|$($arq.Name)"] = "AUSENTE"
            $contadores.AUSENTE++
            if ($verbose) { Write-Log "    ❌ AUSENTE: $($arq.Name)" "DarkGray" }
            Write-Relatorio "- ❌ AUSENTE: $($arq.Name)"
        } else {
            $hash_copia = Get-FileHash256 -path $copia_path
            if ($hash_universal -eq $hash_copia) {
                $inventario["$proj_nome|$($arq.Name)"] = "SYNC"
                $contadores.SYNC++
                if ($verbose) { Write-Log "    ✅ SYNC:    $($arq.Name)" "DarkGray" }
            } else {
                $inventario["$proj_nome|$($arq.Name)"] = "DESATUALIZADO"
                $contadores.DESATUAL++
                if ($verbose) { Write-Log "    ⚠️  DESATUAL: $($arq.Name)" "DarkGray" }
                Write-Relatorio "- ⚠️  DESATUALIZADO: $($arq.Name)"
            }
        }
    }

    # Verificar arquivos no projeto que não existem na universal (ÓRFÃO)
    if (Test-Path $fontes_dir) {
        $arquivos_projeto = Get-ChildItem -Path $fontes_dir -File | Where-Object { $_.Extension -eq ".md" }
        foreach ($arq_proj in $arquivos_projeto) {
            $existe_na_universal = $arquivos_universais | Where-Object { $_.Name -eq $arq_proj.Name }
            if (-not $existe_na_universal) {
                $inventario["$proj_nome|ORFAO|$($arq_proj.Name)"] = "ORFAO"
                $contadores.ORFAO++
                Write-Log "    🔴 ÓRFÃO:  $($arq_proj.Name)" "Red"
                Write-Relatorio "- 🔴 ÓRFÃO: $($arq_proj.Name) (sem correspondente na universal)"
            }
        }
    }

    Write-Relatorio ""
}

# Resumo do inventário
Write-Log ""
Write-Log "  RESUMO RODADA 1:" "Yellow"
Write-Log "  ✅ SYNC:          $($contadores.SYNC)" "Green"
Write-Log "  ⚠️  DESATUALIZADO: $($contadores.DESATUAL)" "Yellow"
Write-Log "  ❌ AUSENTE:        $($contadores.AUSENTE)" "Red"
Write-Log "  🔴 ÓRFÃO:          $($contadores.ORFAO)" "Red"

Write-Relatorio "### Resumo Rodada 1"
Write-Relatorio "- ✅ SYNC: $($contadores.SYNC)"
Write-Relatorio "- ⚠️  DESATUALIZADO: $($contadores.DESATUAL)"
Write-Relatorio "- ❌ AUSENTE: $($contadores.AUSENTE)"
Write-Relatorio "- 🔴 ÓRFÃO: $($contadores.ORFAO)"
Write-Relatorio ""
Write-Relatorio "---"
Write-Relatorio ""

# Se modo verificar: parar aqui
if ($modo -eq "verificar") {
    Write-Log ""
    Write-Log "  Modo 'verificar' — Rodadas 2 e 3 não executadas." "Cyan"
    Write-Log "  Relatório salvo em: $RELATORIO_PATH" "Cyan"
    Write-Log ""
    exit 0
}

# ─────────────────────────────────────────────
# RODADA 2 — SINCRONIZAÇÃO
# ─────────────────────────────────────────────

Write-Log ""
Write-Log "▶ RODADA 2 — SINCRONIZAÇÃO" "Yellow"
Write-Relatorio "## RODADA 2 — SINCRONIZAÇÃO"
Write-Relatorio ""

$sincronizados = 0
$bloqueios = @()

foreach ($proj_path in $projetos) {
    $proj_nome = Split-Path $proj_path -Leaf
    $fontes_dir = Join-Path $proj_path "NOTEBOOKLM_FONTES"

    # Criar pasta se não existir
    if (-not (Test-Path $fontes_dir)) {
        New-Item -ItemType Directory -Path $fontes_dir -Force | Out-Null
        Write-Log "  📁 Pasta criada: $fontes_dir" "Cyan"
        Write-Relatorio "- 📁 Pasta NOTEBOOKLM_FONTES\ criada para $proj_nome"
    }

    foreach ($arq in $arquivos_universais) {
        $status_key = "$proj_nome|$($arq.Name)"
        $status = $inventario[$status_key]

        if ($status -eq "DESATUALIZADO" -or $status -eq "AUSENTE") {
            try {
                $destino_arq = Join-Path $fontes_dir $arq.Name
                Copy-Item -Path $arq.FullName -Destination $destino_arq -Force
                $sincronizados++
                Write-Log "  ✅ SYNC: $proj_nome\$($arq.Name)" "Green"
                Write-Relatorio "- ✅ $proj_nome\$($arq.Name) → sincronizado"
            } catch {
                $bloqueios += "$proj_nome\$($arq.Name): $($_.Exception.Message)"
                Write-Log "  ❌ FALHA: $proj_nome\$($arq.Name)" "Red"
                Write-Relatorio "- ❌ FALHA: $proj_nome\$($arq.Name) — $($_.Exception.Message)"
            }
        }
    }
}

Write-Log ""
Write-Log "  Sincronizados nesta rodada: $sincronizados" "Green"
if ($bloqueios.Count -gt 0) {
    Write-Log "  Bloqueios: $($bloqueios.Count)" "Red"
}

Write-Relatorio ""
Write-Relatorio "Sincronizados: $sincronizados | Bloqueios: $($bloqueios.Count)"
Write-Relatorio ""
Write-Relatorio "---"
Write-Relatorio ""

# ─────────────────────────────────────────────
# RODADA 3 — VERIFICAÇÃO DE INTEGRIDADE
# ─────────────────────────────────────────────

Write-Log ""
Write-Log "▶ RODADA 3 — VERIFICAÇÃO DE INTEGRIDADE" "Yellow"
Write-Relatorio "## RODADA 3 — VERIFICAÇÃO DE INTEGRIDADE"
Write-Relatorio ""

$verificados = 0
$falhas_r3 = 0

foreach ($proj_path in $projetos) {
    $proj_nome = Split-Path $proj_path -Leaf
    $fontes_dir = Join-Path $proj_path "NOTEBOOKLM_FONTES"

    foreach ($arq in $arquivos_universais) {
        $copia_path = Join-Path $fontes_dir $arq.Name

        if (Test-Path $copia_path) {
            $hash_u = Get-FileHash256 -path $arq.FullName
            $hash_c = Get-FileHash256 -path $copia_path

            if ($hash_u -eq $hash_c) {
                $verificados++
                if ($verbose) { Write-Log "  ✅ OK: $proj_nome\$($arq.Name)" "DarkGray" }
            } else {
                $falhas_r3++
                Write-Log "  🔁 DIVERGÊNCIA DETECTADA — re-sincronizando: $proj_nome\$($arq.Name)" "Red"
                Copy-Item -Path $arq.FullName -Destination $copia_path -Force
                Write-Relatorio "- 🔁 RE-SINCRONIZADO: $proj_nome\$($arq.Name) (divergência pós-Rodada 2)"
            }
        }
    }
}

Write-Log ""
Write-Log "  Verificados: $verificados | Re-sincronizados: $falhas_r3" "White"
Write-Relatorio ""
Write-Relatorio "Verificados: $verificados | Re-sincronizados nesta rodada: $falhas_r3"
Write-Relatorio ""
Write-Relatorio "---"
Write-Relatorio ""

# ─────────────────────────────────────────────
# RELATÓRIO FINAL — STATUS E DECISÕES PENDENTES
# ─────────────────────────────────────────────

# Calcular integridade final
$integridade = "VERDE"
if ($contadores.ORFAO -gt 0) { $integridade = "AMARELO" }
if ($bloqueios.Count -gt 0 -or $falhas_r3 -gt 0) { $integridade = "VERMELHO" }

Write-Relatorio "## STATUS FINAL"
Write-Relatorio ""
Write-Relatorio "| Métrica | Valor |"
Write-Relatorio "|---|---|"
Write-Relatorio "| Arquivos universais | $total_universal |"
Write-Relatorio "| Projetos processados | $($projetos.Count) |"
Write-Relatorio "| Sincronizados nesta rodada | $sincronizados |"
Write-Relatorio "| Re-sincronizados (Rodada 3) | $falhas_r3 |"
Write-Relatorio "| Órfãos aguardando veredito | $($contadores.ORFAO) |"
Write-Relatorio "| Bloqueios não resolvidos | $($bloqueios.Count) |"
Write-Relatorio "| **INTEGRIDADE** | **$integridade** |"
Write-Relatorio ""

# Decisões pendentes — órfãos
if ($contadores.ORFAO -gt 0) {
    Write-Relatorio "## DECISÕES PENDENTES PARA O DIRETOR"
    Write-Relatorio ""
    foreach ($key in $inventario.Keys | Where-Object { $inventario[$_] -eq "ORFAO" }) {
        $partes = $key -split "\|ORFAO\|"
        $proj_orfao = $partes[0]
        $arq_orfao  = $partes[1]
        Write-Relatorio "🔴 ``CLIENTES\$proj_orfao\NOTEBOOKLM_FONTES\$arq_orfao``"
        Write-Relatorio "   Não tem correspondente em QUADRILATERAL_UNIVERSAL\NOTEBOOKLM_BASE\"
        Write-Relatorio "   Ação: **deletar** | **promover para universal**"
        Write-Relatorio "   Comando para promover:"
        Write-Relatorio "   \`\`\`powershell"
        Write-Relatorio "   .\scripts\sync_vanguard_docs.ps1 -promover ``"CLIENTES\$proj_orfao\NOTEBOOKLM_FONTES\$arq_orfao``" -destino ``"QUADRILATERAL_UNIVERSAL\NOTEBOOKLM_BASE\"``""
        Write-Relatorio "   \`\`\`"
        Write-Relatorio ""
    }
}

# Bloqueios técnicos
if ($bloqueios.Count -gt 0) {
    Write-Relatorio "## BLOQUEIOS TÉCNICOS NÃO RESOLVIDOS"
    Write-Relatorio ""
    foreach ($b in $bloqueios) {
        Write-Relatorio "- ❌ $b"
    }
    Write-Relatorio ""
}

Write-Relatorio "---"
Write-Relatorio "*Gerado por sync_vanguard_docs.ps1 · Pentalateral IAH · P-033*"

# ─────────────────────────────────────────────
# OUTPUT FINAL NO TERMINAL
# ─────────────────────────────────────────────

Write-Log ""
Write-Log "══════════════════════════════════════════════════" "Cyan"
Write-Log "  SYNC CONCLUÍDO — $DATA_HOJE" "Cyan"
Write-Log "══════════════════════════════════════════════════" "Cyan"

$cor_integridade = switch ($integridade) {
    "VERDE"    { "Green" }
    "AMARELO"  { "Yellow" }
    "VERMELHO" { "Red" }
}

Write-Log "  INTEGRIDADE: $integridade" $cor_integridade
Write-Log ""
Write-Log "  ✅ Sync:      $sincronizados arquivos" "Green"
if ($contadores.ORFAO -gt 0) {
    Write-Log "  🔴 Órfãos:   $($contadores.ORFAO) arquivo(s) — veredito do Diretor necessário" "Red"
}
if ($bloqueios.Count -gt 0) {
    Write-Log "  ❌ Bloqueios: $($bloqueios.Count) — ver relatório" "Red"
}
Write-Log ""
Write-Log "  Relatório: $RELATORIO_PATH" "Cyan"
Write-Log "══════════════════════════════════════════════════" "Cyan"
Write-Log ""
