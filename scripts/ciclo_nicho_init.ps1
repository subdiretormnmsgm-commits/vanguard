# ciclo_nicho_init.ps1
# Inicializa um ciclo de nicho novo com CICLO_GATE.md + documento consolidado.
# Reduz overhead de 6 documentos separados para 1 documento consolidado.
# Cria o gate de encerramento com critérios declarados antes de começar.
#
# Uso: .\scripts\ciclo_nicho_init.ps1 -nicho Contabilidade
# Uso: .\scripts\ciclo_nicho_init.ps1 -nicho Psicologia -subNicho "recem-formado" -bloqueador BUILD

param(
    [Parameter(Mandatory=$true)]
    [string]$nicho,

    [Parameter(Mandatory=$false)]
    [string]$subNicho = "",

    [Parameter(Mandatory=$false)]
    [ValidateSet("BUILD","CAPTACAO","CAPTACAO_MASSIVA")]
    [string]$bloqueador = "CAPTACAO"
)

$data = Get-Date -Format "yyyy-MM-dd"
$pasta = "QUADRILATERAL_UNIVERSAL\PERFIS_NICHO"

# ---- CICLO_GATE.md --------------------------------------------------------
$gatePath = "$pasta\CICLO_GATE_$nicho.md"
$gateConteudo = @"
# CICLO_GATE — $nicho — V1
> Pentalateral IAH · Aberto em: $data
> Criado por: ciclo_nicho_init.ps1

---

## CONFIGURACAO DO CICLO

| Campo | Valor |
|---|---|
| Nicho | $nicho |
| Sub-nicho alvo | $subNicho |
| Aberto em | $data |
| Bloqueador da proxima fase | $bloqueador |
| Maximo de rounds | 3 |
| Maximo de documentos | 4 |
| Status | **ABERTO** |

---

## DOCUMENTOS PREVISTOS (maximo 4)

- [ ] PESQUISA_BRUTA_$nicho.md — Estrategista (Gemini)
- [ ] PERFIL_${nicho}.md — Embaixador (Claude Projects) [trade-secret, gitignored]
- [ ] CICLO_${nicho}_V1.md — consolidado Musculo
- [ ] SINTESE_FINAL_${nicho}_V1.md — Musculo (P-037)

---

## CRITERIO DE ENCERRAMENTO (todos obrigatorios para STATUS: FECHADO)

- [ ] TAM declarado com fonte numerica ou faixa estimada — BLOQUEANTE
- [ ] PESQUISA_BRUTA passou no gate F-2 (pesquisa_bruta_gate.ps1) — BLOQUEANTE
- [ ] Perfil com minimo 3 hipoteses H declaradas — BLOQUEANTE
- [ ] Auditoria passou no check anti-Lost-in-the-Middle (auditor_divergencia_check.ps1) — BLOQUEANTE
- [ ] Sintese Final aprovada pelo Diretor — BLOQUEANTE
- [ ] Todas as perguntas BLOQUEIA_$bloqueador respondidas ou reclassificadas — BLOQUEANTE
- [ ] Perguntas INFORMATIVO registradas no LEDGER — NAO BLOQUEANTE

---

## PERGUNTAS ABERTAS DO CICLO

> Registrar ao longo do ciclo. Uma por linha.
> Formato: [BLOQUEIA_BUILD] / [BLOQUEIA_CAPTACAO] / [INFORMATIVO] — pergunta

_Nenhuma registrada ainda._

---

## ROUNDS DE DELIBERACAO (maximo 3)

| Round | Participantes | Data | Status |
|---|---|---|---|
| 1 | Estrategista entrega PESQUISA_BRUTA | — | pendente |
| 2 | Embaixador entrega Perfil + Musculo delibera + Auditor audita | — | pendente |
| 3 | Musculo consolida Sintese Final | — | pendente |

---

## REGRA DE OVERFLOW

Se algum round gerar mais perguntas abertas que respostas:
- Perguntas BLOQUEIA_BUILD ou BLOQUEIA_CAPTACAO => entram no Round seguinte como prioridade
- Perguntas INFORMATIVO => registradas no LEDGER, nao bloqueiam encerramento
- Apos o Round 3, ciclo encerra mesmo com INFORMATIVOS em aberto

---

## STATUS: ABERTO

---

*Criado por ciclo_nicho_init.ps1 · Pentalateral IAH · $data*
"@

$gateConteudo | Out-File -FilePath $gatePath -Encoding utf8

# ---- CICLO consolidado ----------------------------------------------------
$cicloPath = "$pasta\CICLO_${nicho}_V1.md"
$cicloConteudo = @"
# CICLO_${nicho}_V1 — Documento Consolidado
> Pentalateral IAH · Aberto em: $data
> Um documento. Quatro secoes. O Diretor le aqui.
> Documentos completos referenciados nas secoes — nao navegar separadamente.

---

## SECAO 1 — PESQUISA (Estrategista)
> Status: PENDENTE · Gate F-2: PENDENTE

Execute ao receber: .\scripts\pesquisa_bruta_gate.ps1 -nicho $nicho

**Fragmentacao detectada:** —
**TAM:** —
**Calendário de provas:** —
**Faixa de preco dos concorrentes:** —
**Dor principal verbalizada:** —
**Sub-nichos identificados:** —

**Arquivo completo:** PESQUISA_BRUTA_$nicho.md

---

## SECAO 2 — PERFIL v1 (Embaixador)
> Status: PENDENTE — aguarda SECAO 1 aprovada pelo gate F-2

**Maturidade:** —%
**Sub-nicho foco:** —
**Hipoteses declaradas:** —
**Tom do produto:** —

**Arquivo completo:** PERFIL_$nicho.md [trade-secret — gitignored]

---

## SECAO 3 — DELIBERACOES E AUDITORIA (Musculo + Auditor)
> Status: PENDENTE

Execute ao receber auditoria:
.\scripts\auditor_divergencia_check.ps1 -passo5 PASSO5_$nicho.md -auditoria AUDITORIA_$nicho.md

### Divergencias detectadas pelo Musculo
_A preencher apos Perfil v1 recebido._

### Resultado gate anti-Lost-in-the-Middle
**Status:** PENDENTE

### Veredictos do Auditor [N-1 a N-5]
_A preencher apos PASSO5 executado._

---

## SECAO 4 — SINTESE FINAL (Musculo — P-037)
> Status: PENDENTE

### ENTRA AGORA
_A preencher._

### V2
_A preencher._

### DESCARTADO
_A preencher._

### ALERTAS ABERTOS

Execute para verificar: .\scripts\perguntas_abertas_gate.ps1 -nicho $nicho

| Classificacao | Pergunta | Responsavel | Prazo |
|---|---|---|---|
| — | — | — | — |

---

## STATUS DO CICLO: ABERTO

Bloqueador da proxima fase: **$bloqueador**
Gate de encerramento: CICLO_GATE_$nicho.md

Para fechar: todos os criterios de encerramento marcados + Diretor aprova Sintese Final.

---

*Criado por ciclo_nicho_init.ps1 · Pentalateral IAH · $data*
"@

$cicloConteudo | Out-File -FilePath $cicloPath -Encoding utf8

# ---- Output ---------------------------------------------------------------
Write-Host ""
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host "   CICLO_NICHO_INIT  |  Pentalateral IAH" -ForegroundColor Cyan
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Nicho    : $nicho" -ForegroundColor White
if ($subNicho) {
Write-Host "   Sub-nicho: $subNicho" -ForegroundColor White
}
Write-Host "   Bloqueador da proxima fase: $bloqueador" -ForegroundColor White
Write-Host ""
Write-Host "   Arquivos criados:" -ForegroundColor Green
Write-Host "     $gatePath" -ForegroundColor Gray
Write-Host "     $cicloPath" -ForegroundColor Gray
Write-Host ""
Write-Host "  ----------------------------------------------------------------" -ForegroundColor Cyan
Write-Host "   FLUXO DO CICLO:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   ROUND 1 — Estrategista" -ForegroundColor White
Write-Host "     1. Disparar COMANDO_ESTRATEGISTA_$nicho ao Gemini" -ForegroundColor Gray
Write-Host "     2. Receber PESQUISA_BRUTA_$nicho.md" -ForegroundColor Gray
Write-Host "     3. .\scripts\pesquisa_bruta_gate.ps1 -nicho $nicho" -ForegroundColor Cyan
Write-Host "        -> Se REPROVADA: pedir COMANDO V2 ao Gemini" -ForegroundColor Red
Write-Host "        -> Se APROVADA: avanca para Round 2" -ForegroundColor Green
Write-Host ""
Write-Host "   ROUND 2 — Embaixador + Auditor" -ForegroundColor White
Write-Host "     4. Embaixador constroi Perfil" -ForegroundColor Gray
Write-Host "     5. Musculo delibera + Auditor audita via PASSO5" -ForegroundColor Gray
Write-Host "     6. .\scripts\auditor_divergencia_check.ps1 -passo5 PASSO5_$nicho.md -auditoria AUDITORIA_$nicho.md" -ForegroundColor Cyan
Write-Host "        -> Se PARCIAL: submeter PASSO5_V2 com DIVs nao endereçadas" -ForegroundColor Yellow
Write-Host ""
Write-Host "   ROUND 3 — Sintese Final" -ForegroundColor White
Write-Host "     7. Musculo consolida Sintese Final" -ForegroundColor Gray
Write-Host "     8. .\scripts\perguntas_abertas_gate.ps1 -nicho $nicho" -ForegroundColor Cyan
Write-Host "     9. Diretor aprova -> ciclo FECHADO" -ForegroundColor Gray
Write-Host ""
Write-Host "  ================================================================" -ForegroundColor Cyan
Write-Host ""
