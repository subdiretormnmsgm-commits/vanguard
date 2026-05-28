# ============================================================
# MIGRATE_PROGRESSO_SUPABASE.PS1
# Migra as respostas de Ingrid do projeto antigo para o novo
# Origem: ehyaecxqijgyuuiorzcj (Vanguard)
# Destino: yjqvjhezwhepwomukudt (Ingrid -- soberania P-013)
# Estrategia: remapeamento de questao_id por enunciado (1os 300 chars)
# Executar ANTES de deploy_ingrid_ghpages.ps1
# ============================================================

$OLD_URL = "https://ehyaecxqijgyuuiorzcj.supabase.co"
$NEW_URL = "https://yjqvjhezwhepwomukudt.supabase.co"
$OLD_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVoeWFlY3hxaWpneXV1aW9yemNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgyODMzNTAsImV4cCI6MjA5Mzg1OTM1MH0.xZfcEe2Av5Fn9BKEkNRIi5CQkPD6C6ADSNzMfh3DGPo"
$NEW_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlqcXZqaGV6d2hlcHdvbXVrdWR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3NjExNzksImV4cCI6MjA5NTMzNzE3OX0.Mb6KxtJ3iECl_3ApWUl6zozxa93pJatLwNOZ7zAdhx4"
$USER_ID = "00000000-0000-0000-0000-000000000001"
$PAGE    = 1000

function Supa-Get {
    param([string]$BaseUrl, [string]$Key, [string]$Path)
    $h = @{ apikey = $Key; Authorization = "Bearer $Key"; Accept = "application/json" }
    return (Invoke-RestMethod -Uri ($BaseUrl + $Path) -Headers $h -Method GET)
}

function Supa-Post {
    param([string]$BaseUrl, [string]$Key, [string]$Path, [string]$Body)
    $h = @{ apikey = $Key; Authorization = "Bearer $Key"; "Content-Type" = "application/json"; Prefer = "return=minimal" }
    return (Invoke-RestMethod -Uri ($BaseUrl + $Path) -Headers $h -Method POST -Body $Body)
}

Write-Host ""
Write-Host "=== MIGRACAO PROGRESSO_USUARIO --- Ingrid ===" -ForegroundColor Cyan

# 1. Carregar mapa de questoes do projeto NOVO (enunciado[:300] -> id)
Write-Host "[1/4] Carregando questoes do projeto NOVO..." -ForegroundColor Yellow
$newQuestoes = @{}
$offset = 0
do {
    $path = "/rest/v1/questoes_quadrix?concurso_id=eq.sedes_df_2026" +
            "&select=id,enunciado&limit=$PAGE&offset=$offset"
    $batch = Supa-Get $NEW_URL $NEW_KEY $path
    foreach ($q in $batch) {
        $chave = $q.enunciado.Substring(0, [Math]::Min(300, $q.enunciado.Length)).Trim()
        $newQuestoes[$chave] = $q.id
    }
    $offset += $PAGE
} while ($batch.Count -eq $PAGE)
Write-Host "  Questoes novas carregadas: $($newQuestoes.Count)" -ForegroundColor Green

# 2. Buscar progresso do projeto ANTIGO
Write-Host "[2/4] Buscando respostas do projeto ANTIGO..." -ForegroundColor Yellow
$path = "/rest/v1/progresso_usuario?user_id=eq.$USER_ID" +
        "&select=*&limit=$PAGE"
$progresso = Supa-Get $OLD_URL $OLD_KEY $path
Write-Host "  Respostas encontradas: $($progresso.Count)" -ForegroundColor Green

# 3. Remapear e inserir no projeto NOVO
Write-Host "[3/4] Remapeando e inserindo no projeto NOVO..." -ForegroundColor Yellow
$ok = 0; $skip = 0; $falha = 0
$erros = [System.Collections.ArrayList]@()

foreach ($row in $progresso) {
    $qPath = "/rest/v1/questoes_quadrix?id=eq.$($row.questao_id)" +
             "&select=enunciado&limit=1"
    $questaoAntiga = Supa-Get $OLD_URL $OLD_KEY $qPath

    if (-not $questaoAntiga -or $questaoAntiga.Count -eq 0) {
        $skip++
        [void]$erros.Add("questao_id ausente no antigo: $($row.questao_id)")
        continue
    }

    $chave = $questaoAntiga[0].enunciado.Substring(0, [Math]::Min(300, $questaoAntiga[0].enunciado.Length)).Trim()
    $novoId = $newQuestoes[$chave]

    if (-not $novoId) {
        $skip++
        $preview = $chave.Substring(0, [Math]::Min(60, $chave.Length))
        [void]$erros.Add("Sem match no novo: $preview")
        continue
    }

    $obj = [ordered]@{
        user_id               = $USER_ID
        questao_id            = $novoId
        respondida_em         = $row.respondida_em
        resposta_usuario      = $row.resposta_usuario
        correta               = $row.correta
        disciplina_id         = $row.disciplina_id
        tempo_resposta_ms     = $row.tempo_resposta_ms
        distrator_escolhido   = $row.distrator_escolhido
        nivel_tutor_disparado = $row.nivel_tutor_disparado
        acerto_provavel_chute = $row.acerto_provavel_chute
        proxima_revisao_em    = $row.proxima_revisao_em
        intervalo_sm2_dias    = $row.intervalo_sm2_dias
    }

    # Remover nulls
    $clean = [ordered]@{}
    foreach ($k in $obj.Keys) {
        if ($null -ne $obj[$k]) { $clean[$k] = $obj[$k] }
    }

    try {
        $bodyJson = $clean | ConvertTo-Json -Depth 3 -Compress
        Supa-Post $NEW_URL $NEW_KEY "/rest/v1/progresso_usuario" $bodyJson | Out-Null
        $ok++
    } catch {
        $falha++
        [void]$erros.Add("INSERT falhou para questao_id_novo: $novoId -- $($_.Exception.Message)")
    }
}

# 4. Resultado
Write-Host ""
Write-Host "[4/4] RESULTADO DA MIGRACAO" -ForegroundColor Cyan
Write-Host "  OK (inseridos):   $ok" -ForegroundColor Green
Write-Host "  Sem match (skip): $skip" -ForegroundColor Yellow
Write-Host "  Falha (erro):     $falha" -ForegroundColor Red

if ($erros.Count -gt 0) {
    Write-Host ""
    Write-Host "ERROS:" -ForegroundColor Red
    foreach ($e in $erros) { Write-Host "  - $e" -ForegroundColor DarkRed }
}

# Total final
$totalPath = "/rest/v1/rpc/get_total_respostas_ingrid"
$totalBody = '{"p_user_id":"00000000-0000-0000-0000-000000000001"}'
$totalNovo = Supa-Post $NEW_URL $NEW_KEY $totalPath $totalBody
Write-Host ""
Write-Host "Total no projeto NOVO apos migracao: $totalNovo" -ForegroundColor Cyan
Write-Host "=== FIM ===" -ForegroundColor Cyan
