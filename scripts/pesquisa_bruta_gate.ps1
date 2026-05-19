# pesquisa_bruta_gate.ps1
# F-2 — Valida completude de PESQUISA_BRUTA antes do Embaixador construir o Perfil
# 7 campos obrigatórios. 4 bloqueantes (TAM, Calendário, Preço, Dor verbalizada).
# Se qualquer campo bloqueante ausente → pesquisa rejeitada + REJEICAO_PESQUISA gerado
#
# Uso: .\scripts\pesquisa_bruta_gate.ps1 -nicho Medicina
# Uso: .\scripts\pesquisa_bruta_gate.ps1 -nicho Contabilidade -arquivo "caminho/custom.md"

param(
    [Parameter(Mandatory=$true)]
    [string]$nicho,

    [Parameter(Mandatory=$false)]
    [string]$arquivo = ""
)

if (-not $arquivo) {
    $arquivo = "QUADRILATERAL_UNIVERSAL\PERFIS_NICHO\PESQUISA_BRUTA_$nicho.md"
}

if (-not (Test-Path $arquivo)) {
    Write-Host "`nERRO: Arquivo nao encontrado: $arquivo" -ForegroundColor Red
    Write-Host "Gere a PESQUISA_BRUTA pelo Gemini antes de rodar este gate.`n" -ForegroundColor Yellow
    exit 1
}

$conteudo = Get-Content $arquivo -Raw -Encoding UTF8

$campos = @(
    @{
        id = 1
        nome = "TAM (Tamanho de Mercado)"
        critico = $true
        padroes = @(
            "TAM", "tamanho.*mercado", "mercado.*estimad",
            "\d[\d\.,]*(\.?\d+)?\s*(mil|milh|bilh|profissionais|candidatos|médicos|contadores|psicólogos)",
            "total.*profissional", "profissional.*total", "universo.*\d"
        )
    },
    @{
        id = 2
        nome = "Calendario de provas / ciclo de compra"
        critico = $true
        padroes = @(
            "calendário", "calendar", "prova.*data", "data.*prova",
            "inscrição.*abre", "abre.*inscriç", "período.*inscriç",
            "janela.*temporal", "ciclo.*compra", "quando.*prova", "edição.*\d{4}"
        )
    },
    @{
        id = 3
        nome = "Faixa de preco dos concorrentes"
        critico = $true
        padroes = @(
            "R\$\s*\d+", "preço", "mensalidade", "ticket médio",
            "assinatura.*valor", "cobr.*mensal", "plano.*R\$",
            "pricing", "\d{2,3}[\.,]\d{2}"
        )
    },
    @{
        id = 4
        nome = "Dor principal verbalizada (citacao)"
        critico = $true
        padroes = @(
            "verbatim", "citação", "citaç",
            '"[^"]{15,}"',
            "fórum", "grupo.*telegram", "grupo.*whatsapp",
            "relatam", "reclamam", "disseram", "segundo.*profissionais"
        )
    },
    @{
        id = 5
        nome = "Sub-segmentacao detectada"
        critico = $false
        padroes = @(
            "sub-nicho", "sub.nicho", "segmento", "fragmentaç",
            "perfis.*distintos", "tipos.*cliente", "variaç", "sub-mercado"
        )
    },
    @{
        id = 6
        nome = "Canal de aquisicao dominante"
        critico = $false
        padroes = @(
            "canal.*aquisição", "telegram", "linkedin", "instagram",
            "youtube", "sindicato", "congresso", "onde.*encontr", "comunidade"
        )
    },
    @{
        id = 7
        nome = "Janela de vulnerabilidade"
        critico = $false
        padroes = @(
            "janela.*vulnerabilidade", "pico.*demanda", "período.*alta",
            "momento.*dor", "antes da prova", "véspera", "urgência", "meses.*antes"
        )
    }
)

$reprovados = @()
$aprovados = @()
$avisos = @()

Write-Host ""
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host "   PESQUISA_BRUTA_GATE  |  F-2  |  Vanguard IAH" -ForegroundColor Cyan
Write-Host "   Nicho  : $nicho" -ForegroundColor White
Write-Host "   Arquivo: $arquivo" -ForegroundColor Gray
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host ""

foreach ($campo in $campos) {
    $encontrado = $false
    foreach ($padrao in $campo.padroes) {
        if ($conteudo -match $padrao) {
            $encontrado = $true
            break
        }
    }

    $criticoLabel = if ($campo.critico) { "[BLOQUEANTE]" } else { "[opcional]  " }

    if ($encontrado) {
        $aprovados += $campo
        Write-Host ("   [{0}] {1}  {2,-42}  OK" -f $campo.id, $criticoLabel, $campo.nome) -ForegroundColor Green
    } elseif ($campo.critico) {
        $reprovados += $campo
        Write-Host ("   [{0}] {1}  {2,-42}  AUSENTE" -f $campo.id, $criticoLabel, $campo.nome) -ForegroundColor Red
    } else {
        $avisos += $campo
        Write-Host ("   [{0}] {1}  {2,-42}  ausente" -f $campo.id, $criticoLabel, $campo.nome) -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "  ================================================================" -ForegroundColor Cyan

if ($reprovados.Count -eq 0) {
    Write-Host ""
    Write-Host "   RESULTADO:  APROVADA" -ForegroundColor Green
    Write-Host "   Embaixador pode construir o Perfil de $nicho." -ForegroundColor Green
    Write-Host ""
    if ($avisos.Count -gt 0) {
        Write-Host "   Campos opcionais ausentes (nao bloqueiam):" -ForegroundColor Yellow
        foreach ($a in $avisos) {
            Write-Host ("     Campo {0}: {1}" -f $a.id, $a.nome) -ForegroundColor Yellow
        }
    }
    Write-Host ""
    exit 0
}
else {
    Write-Host ""
    Write-Host "   RESULTADO:  REJEITADA  ($($reprovados.Count) campo(s) bloqueante(s) ausente(s))" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Campos bloqueantes em falta:" -ForegroundColor Red
    foreach ($r in $reprovados) {
        Write-Host ("     Campo {0}: {1}" -f $r.id, $r.nome) -ForegroundColor Red
    }
    Write-Host ""

    # Gerar arquivo de rejeicao
    $rejeicaoPath = "QUADRILATERAL_UNIVERSAL\PERFIS_NICHO\REJEICAO_PESQUISA_$nicho.md"
    $dataHoje = Get-Date -Format "yyyy-MM-dd"
    $camposFaltantes = ($reprovados | ForEach-Object { "- Campo $($_.id): $($_.nome)" }) -join "`n"

    $conteudoRejeicao = @"
# REJEICAO DE PESQUISA BRUTA — $nicho
> Gate F-2 ativado por pesquisa_bruta_gate.ps1 · $dataHoje
> Status: REJEITADA — Embaixador NAO pode construir o Perfil

## Campos bloqueantes ausentes

$camposFaltantes

## Acao obrigatoria

Emitir **COMANDO_ESTRATEGISTA_${nicho}_V2.md** ao Gemini, focado especificamente
nos campos em falta acima. O Embaixador NAO constroi Perfil ate nova pesquisa
passar neste gate.

## Proximos passos

1. Musculo prepara COMANDO_ESTRATEGISTA_${nicho}_V2.md com os campos em falta como objetivo principal
2. Diretor dispara ao Gemini
3. Ao receber pesquisa v2: re-executar .\scripts\pesquisa_bruta_gate.ps1 -nicho $nicho
"@

    $conteudoRejeicao | Out-File -FilePath $rejeicaoPath -Encoding utf8
    Write-Host "   Arquivo de rejeicao gerado: $rejeicaoPath" -ForegroundColor Yellow
    Write-Host "   Acao: pedir COMANDO_ESTRATEGISTA_${nicho}_V2.md ao Musculo." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
