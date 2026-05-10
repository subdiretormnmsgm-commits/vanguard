# atualizar_notebooklm.ps1 — Sincroniza a pasta NotebookLM com os docs mais recentes
# Uso: .\scripts\atualizar_notebooklm.ps1
# Copia sempre as versoes mais atuais de todos os documentos chave

$base = "C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard"
$dest = "$base\NotebookLM"

New-Item -ItemType Directory -Path $dest -Force | Out-Null

Write-Host "Atualizando NotebookLM/..."
Write-Host ""

$arquivos = @(
    # Camada 1 — Identidade e Metodologia
    @{src="INTELIGENCIA_ARTIFICIAL_HUMANA.md";  prefix="01"},
    @{src="SOP_VANGUARD_MASTER.md";             prefix="02"},
    @{src="VANGUARD_BUSINESS_RULES.md";         prefix="03"},
    @{src="O Protocolo Quadrilateral.txt";       prefix="04"},
    @{src="REPOSITORIO_ESTRUTURA.md";           prefix="05"},
    @{src="EMPRESA_VANGUARD.md";                prefix="06"},
    @{src="PROTOCOLO_INTERATIVO.md";            prefix="06b"},

    # Camada 2 — Estado atual
    @{src="MEMORIA_V16.md";                     prefix="07"},
    @{src="relatorio_evolutivo_v16.md";         prefix="08"},
    @{src="HANDOFF_V16_PARA_GEMINI.md";         prefix="09"},
    @{src="TODO_FUTURE.md";                     prefix="10"},
    @{src="VANGUARD_INNOVATION_AUDIT.md";       prefix="11"},
    @{src="MASTER_PLAN.md";                     prefix="12"},
    @{src="VANGUARD_OPERATIONAL_COSTS.md";      prefix="13"},
    @{src="PLANO_DE_ACAO_SEMANA1.md";           prefix="14"},
    @{src="VANGUARD_KNOWLEDGE_GRAPH.md";        prefix="15"},
    @{src="VANGUARD_PERFORMANCE_LEDGER.md";     prefix="16"},

    # Camada 3 — DIRETRIZ Gemini
    @{src="DIRETRIZ_GEMINI.txt";                prefix="17"},
    @{src="DIRETRIZ GEMINI V16.txt";            prefix="18"},
    @{src="DIRETRIZ GEMINI V15.txt";            prefix="19"},
    @{src="DIRETRIZ GEMINI V14.txt";            prefix="20"},
    @{src="DIRETRIZ GEMINI V13.txt";            prefix="21"},
    @{src="DIRETRIZ GEMINI V12.txt";            prefix="22"},

    # Camada 4 — Relatorios evolutivos
    @{src="relatorio_evolutivo_v16.md";         prefix="23"},
    @{src="relatorio_evolutivo_v15.md";         prefix="24"},
    @{src="relatorio_evolutivo_v14.md";         prefix="25"},
    @{src="relatorio_evolutivo_v13.md";         prefix="26"},
    @{src="relatorio_evolutivo_v12.md";         prefix="27"},
    @{src="relatorio_evolutivo_v11.md";         prefix="28"},

    # Camada 5 — Memorias tecnicas recentes
    @{src="memorias\MEMORIA_15_INVASION.md";    prefix="29"},
    @{src="memorias\MEMORIA_14_OPTIMIZATION.md";prefix="30"},
    @{src="memorias\MEMORIA_13_DOMINATION.md";  prefix="31"},
    @{src="memorias\MEMORIA_12_IGNITION_COCKPIT.md";prefix="32"},
    @{src="memorias\MEMORIA_11_LAUNCH.md";      prefix="33"}
)

$ok  = 0
$err = 0

foreach ($item in $arquivos) {
    $src = "$base\$($item.src)"
    if (Test-Path $src) {
        $nome = Split-Path $item.src -Leaf
        Copy-Item $src -Destination "$dest\$($item.prefix)_$nome" -Force
        Write-Host "  ✅ $($item.prefix) — $nome"
        $ok++
    } else {
        Write-Host "  ⚪ nao encontrado: $($item.src)"
        $err++
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "  $ok arquivos atualizados · $err nao encontrados"
Write-Host "  Pasta: NotebookLM\ ($((Get-ChildItem $dest).Count) arquivos total)"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
