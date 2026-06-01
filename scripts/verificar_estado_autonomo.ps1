# verificar_estado_autonomo.ps1
# P-092 -- Verificacao autonoma do estado entre sessoes
# Musculo verifica o que pode via git+disco. Lista compacta SIM/NAO para o resto.
# NUNCA gerar pergunta aberta "o que aconteceu?" -- isso e falha de design.
#
# Saida:
#   [AUTO-VERDE]        evidencia em git/disco -- Musculo nao precisa perguntar
#   [AUTO-AMARELO]      tarefa do Musculo sem evidencia -- executar agora
#   [DIRETOR-CONFIRMAR] acao externa -- lista numerada SIM/NAO (2 segundos do Diretor)

param([switch]$Silencioso)

$projectDir = if ($PSScriptRoot) { Split-Path -Parent $PSScriptRoot } else { Get-Location }
$hoje       = [datetime]::Today

# ---------------------------------------------------------------------------
# PADROES DE CLASSIFICACAO
# ---------------------------------------------------------------------------

# Indica que a acao primaria e do Diretor/Eduardo (nao ha artefato verificavel)
$PADROES_EXTERNOS = @(
    'Eduardo segue', 'Eduardo ajusta', 'Eduardo roda', 'Eduardo envia',
    'arrastar', 'Arrastar',
    'seguir link', 'link no e-mail', 'revogar token',
    'Claude Projects',
    'WhatsApp', 'Telegram',
    '! supabase login',
    'ajusta e envia',
    'colar mensagem',
    'upload'
)

# Indica que pode haver evidencia em git/disco
$PADROES_INTERNOS = @(
    'Musculo', 'Musculo faz', 'Musculo executa', 'Musculo gera',
    'deploy', 'PASSO7-C', 'Sentinel', 'session_close',
    'supabase', 'edge function', 'script', 'commit',
    'preparar_notebooklm', 'session_close.ps1'
)

function Test-EhExterno([string]$texto) {
    foreach ($pat in $PADROES_EXTERNOS) {
        if ($texto -match [regex]::Escape($pat)) { return $true }
    }
    return $false
}

# ---------------------------------------------------------------------------
# GIT: commits das ultimas 48h (cobre fim de semana ou pausa de sessao)
# ---------------------------------------------------------------------------
function Get-CommitsRecentes {
    try {
        $log = & git -C $projectDir log --oneline --since="48 hours ago" --format="%s %b" 2>$null
        if (-not $log) { $log = @() }
        return @($log)
    } catch { return @() }
}

# ---------------------------------------------------------------------------
# VERIFICACAO DE EVIDENCIA: APENAS via [RESOLVE:] em commits (P-087)
# Evidencia por keywords livres gera falsos positivos — nao usar.
# Auto-verde so quando commit declara explicitamente [RESOLVE: <keyword>]
# ---------------------------------------------------------------------------
function Test-TemEvidencia([string]$titulo, [string[]]$commits) {
    # Extrair keywords do titulo (palavras significativas, > 3 chars)
    $stopwords = @('para', 'este', 'essa', 'antes', 'apos', 'pelo', 'pela', 'mais', 'deve',
                   'quando', 'como', 'onde', 'loop', 'gate', 'prazo', 'data', 'ngrid',
                   'aldece', 'ingrid', 'valdece')
    $keywords  = $titulo -split '\W+' |
                 Where-Object { $_.Length -gt 3 -and $_ -notin $stopwords } |
                 Select-Object -First 8

    # UNICO criterio de VERDE: commit com [RESOLVE: <keyword>] (P-087)
    foreach ($kw in $keywords) {
        foreach ($c in $commits) {
            if ($c -match "\[RESOLVE:.*$kw") { return $true }
        }
    }
    return $false
}

# ---------------------------------------------------------------------------
# ARTEFATOS ESPERADOS: verificar existencia de arquivos canonicos
# ---------------------------------------------------------------------------
function Test-ArtefatoExiste([string]$titulo) {
    # Sentinel Report
    if ($titulo -match 'Sentinel') {
        $path = Join-Path $projectDir "CLIENTES\VALDECE\HISTORICO"
        if (Test-Path $path) {
            $recentes = Get-ChildItem $path -Filter "PASSO7*" -ErrorAction SilentlyContinue |
                        Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-48) }
            return $recentes.Count -gt 0
        }
    }

    # Deploy CLI / Edge Functions
    if ($titulo -match 'Deploy CLI|F-4|F-6|notificar-progresso|relatorio-semanal') {
        # Verificar via git -- se commit recente menciona deploy
        try {
            $log = & git -C $projectDir log --oneline --since="48 hours ago" --format="%s" 2>$null
            foreach ($c in $log) {
                if ($c -match 'deploy|edge|F-4|F-6') { return $true }
            }
        } catch {}
    }

    return $false
}

# ---------------------------------------------------------------------------
# LER E CLASSIFICAR PENDENTES
# ---------------------------------------------------------------------------
function Get-PendentesClassificados {
    $pendPath = Join-Path $projectDir "PENDENTES.md"
    if (-not (Test-Path $pendPath)) { return @() }

    $linhas = Get-Content $pendPath -Encoding UTF8
    $itens  = [System.Collections.ArrayList]@()
    $i      = 0

    while ($i -lt $linhas.Count) {
        $l = $linhas[$i]
        # Ignorar linha template do "COMO USAR" (placeholder com YYYY-MM-DD)
        if ($l -match 'YYYY-MM-DD' -or $l -match 'descri') { $i++; continue }
        if ($l -match '^\s*- \[ \]') {
            $dataMatch = [regex]::Match($l, '`(\d{4}-\d{2}-\d{2})`')
            $dataPend  = if ($dataMatch.Success) {
                try { [datetime]$dataMatch.Groups[1].Value } catch { $hoje }
            } else { $hoje }
            $atraso = ($hoje.Date - $dataPend.Date).Days
            $titulo = $l -replace '^\s*- \[ \]\s*`[^`]+`\s*', '' `
                         -replace '\*\*([^*]+)\*\*', '$1' `
                         -replace '\*', ''

            # Sub-linhas (contexto)
            $contexto = ""
            $j = $i + 1
            $subCount = 0
            while ($j -lt $linhas.Count -and $subCount -lt 4) {
                $next = $linhas[$j]
                if ($next -match '^\s*- \[') { break }
                if ($next -match '^#{1,3} ')  { break }
                if ($next.Trim() -ne '') {
                    $contexto += " " + $next.Trim()
                    $subCount++
                }
                $j++
            }

            $textoTotal = $titulo + " " + $contexto
            $isExterno  = Test-EhExterno $textoTotal

            [void]$itens.Add([PSCustomObject]@{
                Titulo   = $titulo.Trim()
                Data     = $dataPend
                Atraso   = $atraso
                Externo  = $isExterno
                Contexto = $contexto.Trim()
            })
        }
        $i++
    }
    return @($itens)
}

# ---------------------------------------------------------------------------
# MAIN
# ---------------------------------------------------------------------------
$commits = Get-CommitsRecentes
$itens   = Get-PendentesClassificados

$externos = @($itens | Where-Object { $_.Externo })
$internos = @($itens | Where-Object { -not $_.Externo })

# Classificar internos
$verdes   = [System.Collections.ArrayList]@()
$amarelos = [System.Collections.ArrayList]@()

foreach ($item in $internos) {
    $temEv = (Test-TemEvidencia $item.Titulo $commits) -or (Test-ArtefatoExiste $item.Titulo)
    if ($temEv) { [void]$verdes.Add($item)   }
    else        { [void]$amarelos.Add($item) }
}

# ---------------------------------------------------------------------------
# OUTPUT
# ---------------------------------------------------------------------------
$out = [System.Collections.ArrayList]@()
[void]$out.Add("VERIFICACAO AUTONOMA DE ESTADO -- $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
[void]$out.Add("Commits analisados (48h): $($commits.Count) | Itens abertos: $($itens.Count)")
[void]$out.Add("")

if ($verdes.Count -gt 0) {
    [void]$out.Add("[AUTO-VERDE] EVIDENCIA EM GIT/DISCO -- possivelmente concluidos:")
    foreach ($v in $verdes) {
        [void]$out.Add("  [VERDE] $($v.Titulo)")
    }
    [void]$out.Add("  >> Se evidencia for conclusiva, Musculo marca [x] no PENDENTES sem perguntar.")
    [void]$out.Add("")
}

if ($amarelos.Count -gt 0) {
    [void]$out.Add("[AUTO-AMARELO] TAREFA DO MUSCULO -- sem evidencia de execucao:")
    foreach ($a in ($amarelos | Sort-Object Atraso -Descending)) {
        $d = if ($a.Atraso -gt 0) { " [ATRASADO $($a.Atraso)d]" } else { "" }
        [void]$out.Add("  [EXECUTA]$d $($a.Titulo)")
    }
    [void]$out.Add("")
}

if ($externos.Count -gt 0) {
    [void]$out.Add("[DIRETOR-CONFIRMAR] ACOES EXTERNAS -- SIM ou NAO (2 segundos):")
    [void]$out.Add("  Estas acoes nao geram artefato verificavel -- so o Diretor sabe.")
    [void]$out.Add("")
    $n = 1
    $mapa = @{}
    foreach ($e in ($externos | Sort-Object Atraso -Descending)) {
        $d = if ($e.Atraso -gt 0) { " [ATRASADO $($e.Atraso)d]" } else { "" }
        [void]$out.Add("  $n.$d $($e.Titulo)")
        $mapa[$n] = $e.Titulo
        $n++
    }
    [void]$out.Add("")
    [void]$out.Add("  >> Responder: '1-SIM 2-NAO 3-SIM' (numeros acima)")
    [void]$out.Add("  >> Ou: 'TODOS SIM' / 'TODOS NAO'")
    [void]$out.Add("  >> Musculo marca [x] automaticamente nos confirmados SIM")
}

if ($itens.Count -eq 0) {
    [void]$out.Add("  Nenhum pendente aberto detectado. PENDENTES.md limpo.")
}

return $out
