# skill_parser_gate.ps1
# Valida Skill gerada pelo Auditor (NotebookLM) contra os 4 blocos obrigatorios
# Previne Deficiencia 2 do Auditor: Alucinacao Estrutural e Yes-Man (P-007)
# Uso: .\scripts\skill_parser_gate.ps1 -skill "caminho\para\SKILL.md"
# Retorna exit 0 (aprovado) ou exit 2 (rejeitado)

param(
    [Parameter(Mandatory=$false)]
    [string]$skill = ""
)

[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$BASE = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "================================================"
Write-Host "  skill_parser_gate -- Auditor Quality Gate"
Write-Host "================================================"

# Se nenhum arquivo passado, listar Skills disponíveis
if ([string]::IsNullOrWhiteSpace($skill)) {
    $skills = Get-ChildItem "$BASE\.claude\skills" -Filter "SKILL*.md" -ErrorAction SilentlyContinue
    if ($skills.Count -eq 0) {
        Write-Host "Nenhuma Skill encontrada em .claude\skills\"
        Write-Host "Uso: .\scripts\skill_parser_gate.ps1 -skill 'caminho\SKILL.md'"
        exit 1
    }
    Write-Host "Skills disponiveis:"
    $skills | ForEach-Object { Write-Host "  $_" }
    Write-Host ""
    Write-Host "Uso: .\scripts\skill_parser_gate.ps1 -skill 'caminho\SKILL.md'"
    exit 0
}

if (-not (Test-Path $skill)) {
    Write-Host "ERRO: arquivo nao encontrado: $skill"
    exit 1
}

$conteudo = Get-Content $skill -Encoding UTF8 -Raw -ErrorAction SilentlyContinue
if ([string]::IsNullOrWhiteSpace($conteudo)) {
    Write-Host "ERRO: arquivo vazio ou ilegivel"
    exit 1
}

# Normalizar acentos via .NET Unicode FormD (robusto, sem problemas de encoding PS 5.1)
$normalized = $conteudo.Normalize([System.Text.NormalizationForm]::FormD)
$sb = [System.Text.StringBuilder]::new()
foreach ($c in $normalized.ToCharArray()) {
    if ([System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($c) -ne `
        [System.Globalization.UnicodeCategory]::NonSpacingMark) {
        [void]$sb.Append($c)
    }
}
$conteudoNorm = $sb.ToString().ToUpper()

Write-Host "Arquivo : $skill"
Write-Host "Tamanho : $($conteudo.Length) chars"
Write-Host ""

$erros   = [System.Collections.Generic.List[string]]::new()
$avisos  = [System.Collections.Generic.List[string]]::new()
$aprovado = $true

# DETECCAO AUTOMATICA: se for arquivo PASSO5, validar checklist P-143 em vez dos 4 blocos
$nomeArquivo = [System.IO.Path]::GetFileName($skill).ToUpper()
if ($nomeArquivo -match "PASSO5") {
    Write-Host "Modo PASSO5 detectado -- validando [CHECKLIST DO MUSCULO] (P-143)" -ForegroundColor Cyan
    Write-Host ""
    if ($conteudoNorm -notmatch "CHECKLIST DO MUSCULO") {
        Write-Host "RESULTADO: REJEITADO -- P-143 VIOLADO" -ForegroundColor Red
        Write-Host "  [CHECKLIST DO MUSCULO -- BLOQUEANTE] ausente no arquivo PASSO5." -ForegroundColor Red
        Write-Host "  Regenerar PASSO5 a partir do template atualizado (v2.5+)." -ForegroundColor Red
        Write-Host ""
        Write-Host "  Template: PENTALATERAL_UNIVERSAL\OPERACAO\PASSO5_NOTEBOOKLM_TEMPLATE.md" -ForegroundColor Yellow
        exit 1
    } else {
        Write-Host "RESULTADO: APROVADO -- [CHECKLIST DO MUSCULO] presente" -ForegroundColor Green
        Write-Host "  PASSO5 validado -- pronto para enviar ao Auditor." -ForegroundColor Green
        exit 0
    }
}

# VALIDACAO 1: Os 4 blocos obrigatorios (modo SKILL)
$blocos = @(
    @{ padrao = "AUDITORIA.*COER|COERENCIA"; nome = "[AUDITORIA DE COERENCIA]" },
    @{ padrao = "CONEXAO.*HIST|HISTORICA";   nome = "[CONEXAO HISTORICA]" },
    @{ padrao = "PADRAO.*SUCESSO|PADRAO.*FALHA|SUCESSO.*VALIDADO"; nome = "[PADRAO DE SUCESSO/FALHA]" },
    @{ padrao = "PERSPECTIVA.*SOCIO|SOCIO.*CONSULTOR|VISAO.*SOCIO"; nome = "[PERSPECTIVA DO SOCIO]" }
)

foreach ($bloco in $blocos) {
    if ($conteudoNorm -notmatch $bloco.padrao) {
        $erros.Add("Bloco ausente: $($bloco.nome)")
        $aprovado = $false
    }
}

# VALIDACAO 2: Referencias a dados reais de projeto
$referenciais = @("Valdece","V\d{1,2}","R\$\s*[\d\.]+","STF","STJ","Supabase","pgvector","corpus","LEDGER","P-\d{3}")
$refEncontradas = ($referenciais | Where-Object { $conteudo -match $_ }).Count

if ($refEncontradas -lt 2) {
    $erros.Add("Dados reais insuficientes: apenas $refEncontradas referencia(s) a projetos/valores concretos (minimo 2)")
    $aprovado = $false
}

# VALIDACAO 3: Placeholders de template nao preenchidos
if ($conteudo -match "\[A PREENCHER\]|\[INSERIR\]|\[XXX\]|\[EXEMPLO\]|\[COLOCAR AQUI\]") {
    $erros.Add("Template nao preenchido: encontrado placeholder generico")
    $aprovado = $false
}

# VALIDACAO 4: Tamanho minimo
if ($conteudo.Length -lt 800) {
    $avisos.Add("Skill muito curta ($($conteudo.Length) chars) -- risco de alucinacao estrutural")
}

# VALIDACAO 5: Ideias proprias do Auditor (nao apenas eco do Gemini)
if ($conteudo -notmatch "IDEIA|DISRUPTIV|PERSPECTIVA PROPRIA|AUDITOR SUGERE|RECOMENDO|PROPONHO") {
    $avisos.Add("Skill sem contribuicao propria do Auditor -- possivel comportamento Yes-Man")
}

# OUTPUT FINAL
Write-Host ""
if ($aprovado) {
    Write-Host "RESULTADO: APROVADO"
    Write-Host "  A Skill passou em todos os criterios obrigatorios."
} else {
    Write-Host "RESULTADO: REJEITADO -- O AUDITOR ALUCINOU"
    Write-Host ""
    Write-Host "  Retorne ao NotebookLM e aplique o Gatilho de Calibracao:"
    Write-Host "  'Auditor, sua Skill foi rejeitada pelo Musculo."
    Write-Host "   Reprocesse exigindo: dados reais de projeto, os 4 blocos"
    Write-Host "   obrigatorios preenchidos, e sua perspectiva critica propria.'"
}

if ($erros.Count -gt 0) {
    Write-Host ""
    Write-Host "ERROS ($($erros.Count) -- bloqueiam o build):"
    $erros | ForEach-Object { Write-Host "  [X] $_" }
}

if ($avisos.Count -gt 0) {
    Write-Host ""
    Write-Host "AVISOS ($($avisos.Count) -- revisar antes de usar):"
    $avisos | ForEach-Object { Write-Host "  [!] $_" }
}

# P-067: GATE AUTOMATICO DO EMBAIXADOR - skill aprovada nao libera o Musculo diretamente
if ($aprovado) {
    # Detectar cliente pelo nome do arquivo (ex: ingrid-v5.md -> INGRID)
    $skillNome = [System.IO.Path]::GetFileNameWithoutExtension($skill)
    $clienteDetectado = ""
    if ($skillNome -match "^([a-zA-Z]+)-v\d+") {
        $clienteDetectado = $matches[1].ToUpper()
    }

    # DECISAO SOBERANA: flag suprime P-067 (Embaixador ja reagiu offline na sessao atual)
    $soberanaP067 = $false
    if ($clienteDetectado -ne "") {
        $soberanaPath = Join-Path $BASE "CLIENTES\$clienteDetectado\CLAUDE_PROJECT\SOBERANA_P067.flag"
        if (Test-Path $soberanaPath) {
            $soberanaAge = (Get-Date) - (Get-Item $soberanaPath).LastWriteTime
            if ($soberanaAge.TotalHours -lt 48) {
                Write-Host ""
                Write-Host "  [P-067] DECISAO SOBERANA ativa -- Embaixador ja reagiu offline." -ForegroundColor DarkYellow
                Write-Host "  Musculo liberado para sintese P-037." -ForegroundColor DarkYellow
                $soberanaP067 = $true
                # FIX C8: registrar bypass em PENDENTES.md com formato P-069
                $dtP067   = Get-Date -Format "dd-MM-yyyy"
                $dsP067   = (Get-Date).ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("pt-BR"))
                $pendP067 = "$BASE\PENDENTES.md"
                $entrP067 = "- [SOBERANA ($dtP067 $dsP067)] $clienteDetectado -- P-067 suprimida -- verificar se Embaixador reagiu"
                if (Test-Path $pendP067) {
                    $exP067 = Get-Content $pendP067 -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
                    if (-not ($exP067 -match ("SOBERANA.*" + $dtP067 + ".*" + $clienteDetectado))) {
                        Add-Content $pendP067 "`n$entrP067" -Encoding UTF8
                        Write-Host "  [P-069] PENDENTES.md -- registro SOBERANA P-067 adicionado" -ForegroundColor DarkYellow
                    }
                }
            }
        }
    }

    if (-not $soberanaP067) {
    Write-Host ""
    Write-Host "================================================"
    Write-Host "  PROXIMO PASSO BLOQUEANTE -- P-067"
    Write-Host "================================================"
    Write-Host ""
    Write-Host "  MUSCULO BLOQUEADO ate o Embaixador reagir."
    Write-Host ""
    Write-Host "  ORDEM INVIOLAVEL DO CICLO:"
    Write-Host "    [OK] Gemini  -> DIRETRIZ"
    Write-Host "    [OK] NotebookLM -> Skill aprovada"
    Write-Host "    [ ] Embaixador -> SECAO D  <-- AGORA"
    Write-Host "    [ ] Musculo -> sintese P-037"
    Write-Host ""
    Write-Host "  ACAO OBRIGATORIA:"

    if ($clienteDetectado -ne "") {
        Write-Host "    Atualizar [N-1 a N-5] no PASSO7_EMBAIXADOR.md SECAO D"
        Write-Host "    Depois rodar:"
        Write-Host ""
        Write-Host "    .\scripts\ir_ao_embaixador.ps1 -cliente $clienteDetectado"
        Write-Host ""

        # Verificar se sessao e interativa antes de usar Read-Host
        $isInteractive = [Environment]::UserInteractive -and $Host.Name -ne "Default Host"
        if ($isInteractive) {
            try {
                $resposta = Read-Host "  Rodar ir_ao_embaixador.ps1 -cliente $clienteDetectado agora? (S/N)"
                if ($resposta -match "^[Ss]") {
                    Write-Host ""
                    Write-Host "  Ativando Embaixador para $clienteDetectado ..."
                    & "$BASE\scripts\ir_ao_embaixador.ps1" -cliente $clienteDetectado
                }
            } catch {
                # Modo nao-interativo — mostrar instrucao
            }
        }
        Write-Host ""
        Write-Host "  Colar SECAO D no Claude Projects antes de"
        Write-Host "  trazer qualquer output ao Musculo."
    } else {
        Write-Host "    .\scripts\ir_ao_embaixador.ps1 -cliente [NOME_DO_CLIENTE]"
        Write-Host "    Colar SECAO D no Claude Projects."
        Write-Host "    So depois trazer output do Embaixador ao Musculo."
    }
    Write-Host ""
    Write-Host "================================================"
    } # closes if (-not $soberanaP067)
}

# E-1 V28: Gate de Coerencia Semantica (apos aprovacao estrutural)
if ($aprovado -and (-not $soberanaP067)) {
    Write-Host ""
    Write-Host "================================================"
    Write-Host "  E-1 V28 -- Gate de Coerencia Semantica"
    Write-Host "================================================"
    $gateScript = Join-Path $BASE "scripts\gate_coerencia.ps1"
    if (Test-Path $gateScript) {
        & $gateScript -documento $skill -proximo_passo "Musculo executar deliberacao P-037 e sintese do loop"
        if ($LASTEXITCODE -eq 1) {
            Write-Host ""
            Write-Host "  [E-1] Skill aprovada estruturalmente mas rejeitada semanticamente." -ForegroundColor Yellow
            Write-Host "  Musculo deve revisar lacunas antes de iniciar P-037." -ForegroundColor Yellow
        } elseif ($LASTEXITCODE -eq 0) {
            Write-Host "  [E-1] Coerencia semantica: OK" -ForegroundColor Green
        }
    } else {
        Write-Host "  [E-1] gate_coerencia.ps1 nao encontrado -- instalar V28 primeiro." -ForegroundColor DarkYellow
    }
}

exit $(if ($aprovado) { 0 } else { 2 })
