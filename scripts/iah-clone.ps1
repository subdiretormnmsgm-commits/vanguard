# ═══════════════════════════════════════════════════════════════════════════
# VANGUARD V19 — IAH FACTORY CLI
# Clona uma instância Vanguard completa para um nicho/franquia em minutos
# Uso: .\scripts\iah-clone.ps1 -Nicho "clinicas" -TenantNome "Rede Clínicas ABC" -Email "admin@clinicasabc.com.br"
# ═══════════════════════════════════════════════════════════════════════════

param(
    [Parameter(Mandatory=$true)]
    [string]$Nicho,

    [Parameter(Mandatory=$true)]
    [string]$TenantNome,

    [Parameter(Mandatory=$true)]
    [string]$Email,

    [string]$TenantSlug = "",
    [string]$Dominio    = "",
    [string]$CorPrimaria = "#C5A028"  # Ion Gold por defeito
)

$base = Split-Path $PSScriptRoot -Parent

# ── Gerar slug a partir do nome ────────────────────────────────────────────
if (-not $TenantSlug) {
    $TenantSlug = $TenantNome.ToLower() `
        -replace '[áàâãä]','a' -replace '[éèêë]','e' `
        -replace '[íìîï]','i'  -replace '[óòôõö]','o' `
        -replace '[úùûü]','u'  -replace '[ç]','c' `
        -replace '[^a-z0-9]','-' -replace '-+','-' -replace '^-|-$',''
}

$TenantId = $TenantSlug + "-" + (Get-Random -Minimum 1000 -Maximum 9999)

Write-Host ""
Write-Host "======================================================" -ForegroundColor Yellow
Write-Host "  VANGUARD IAH FACTORY — Clonar Instância" -ForegroundColor Yellow
Write-Host "======================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Nicho:       $Nicho"
Write-Host "  Tenant:      $TenantNome"
Write-Host "  Slug:        $TenantSlug"
Write-Host "  Tenant ID:   $TenantId"
Write-Host "  Email:       $Email"
Write-Host "  Cor:         $CorPrimaria"
Write-Host ""

# ── PASSO 1: Gerar brand-config.js para o tenant ──────────────────────────
Write-Host "[1/5] Gerando brand-config para $TenantNome..." -ForegroundColor Cyan

$nichoTaglines = @{
    "clinicas"      = "Inteligência de Mercado para Clínicas"
    "imobiliario"   = "Inteligência de Mercado Imobiliário"
    "educacao"      = "Inteligência para Redes de Ensino"
    "franquias"     = "Inteligência para Redes de Franquias"
    "financeiro"    = "Inteligência Financeira Preditiva"
}
$tagline = if ($nichoTaglines[$Nicho]) { $nichoTaglines[$Nicho] } else { "Inteligência de Mercado B2B" }

$brandConfig = @"
/* brand-config — $TenantNome — gerado por IAH Factory V19 */
/* tenant_id: $TenantId | nicho: $Nicho */
(function() {
  'use strict';

  var cfg = {
    name:      "$TenantNome",
    slug:      "$TenantSlug",
    tenantId:  "$TenantId",
    nicho:     "$Nicho",
    tagline:   "$tagline",
    email:     "$Email",
    dominio:   "$Dominio",

    cores: {
      primaria:   "$CorPrimaria",
      obsidian:   "#0A0802",
      texto:      "#E6E4DC",
      destaque:   "#F0C84A",
    },

    /* Intent Graph: unidades desta rede */
    matrizDashboard: true,
    unidades: [],  /* populate via Supabase: tenants where parent_id = '$TenantId' */
  };

  /* Aplica CSS variables */
  if (typeof document !== 'undefined') {
    var r = document.documentElement.style;
    r.setProperty('--gold',       cfg.cores.primaria);
    r.setProperty('--obsidian',   cfg.cores.obsidian);
    r.setProperty('--c-primary',  cfg.cores.primaria);
  }

  /* Aplica textos */
  if (typeof document !== 'undefined') {
    document.addEventListener('DOMContentLoaded', function() {
      document.querySelectorAll('.brand-name').forEach(function(el) {
        el.textContent = cfg.name;
      });
      document.querySelectorAll('.brand-tagline').forEach(function(el) {
        el.textContent = cfg.tagline;
      });
      var titleEl = document.querySelector('.brand-name-title');
      if (titleEl) titleEl.textContent = cfg.name + ' — Inteligência de Mercado';
    });
  }

  window.__VG_TENANT = cfg;
})();
"@

$brandPath = "$base\tenants\$TenantSlug\brand-config.js"
New-Item -ItemType Directory -Path "$base\tenants\$TenantSlug" -Force | Out-Null
$brandConfig | Out-File -FilePath $brandPath -Encoding utf8
Write-Host "  OK — tenants/$TenantSlug/brand-config.js" -ForegroundColor Green

# ── PASSO 2: Provisionar tenant no Supabase ────────────────────────────────
Write-Host ""
Write-Host "[2/5] Provisionando tenant no Supabase..." -ForegroundColor Cyan

$supabaseUrl  = $env:SUPABASE_URL
$supabaseAnon = $env:SUPABASE_ANON_KEY

if (-not $supabaseUrl -or -not $supabaseAnon) {
    Write-Host "  AVISO: SUPABASE_URL ou SUPABASE_ANON_KEY não definidos no ambiente." -ForegroundColor Yellow
    Write-Host "         Definir e re-executar para provisionar automaticamente." -ForegroundColor Yellow
    Write-Host "         Tenant ID reservado: $TenantId" -ForegroundColor Yellow
} else {
    $payload = @{
        id         = $TenantId
        nome       = $TenantNome
        slug       = $TenantSlug
        nicho      = $Nicho
        email      = $Email
        dominio    = $Dominio
        cor_primaria = $CorPrimaria
        plano      = "iah_starter"
        status     = "active"
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod `
            -Uri "$supabaseUrl/rest/v1/tenants" `
            -Method POST `
            -Headers @{
                "apikey"        = $supabaseAnon
                "Authorization" = "Bearer $supabaseAnon"
                "Content-Type"  = "application/json"
                "Prefer"        = "return=minimal"
            } `
            -Body $payload
        Write-Host "  OK — Tenant $TenantId criado no Supabase" -ForegroundColor Green
    } catch {
        Write-Host "  ERRO ao criar tenant: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "  Tenant ID gerado: $TenantId (criar manualmente se necessário)" -ForegroundColor Yellow
    }
}

# ── PASSO 3: Gerar instruções CNAME ───────────────────────────────────────
Write-Host ""
Write-Host "[3/5] Gerando instruções de DNS..." -ForegroundColor Cyan

$cnameInstructions = @"
# ── INSTRUÇÕES DNS PARA $TenantNome ─────────────────────────────────
#
# Adicionar no painel DNS do cliente ($Dominio):
#
#   TIPO    NOME            VALOR
#   CNAME   vgpx            pixel.vanguard.tech
#   CNAME   @  (ou www)    federation.vanguard.tech   ← SSL for SaaS
#
# Após configurar, activar Custom Hostname no Cloudflare:
#   wrangler kv:key put --binding=TENANTS_KV "$Dominio" ``
#     '{\"tenant_id\":\"$TenantId\",\"origin_hostname\":\"origin.$Dominio\"}'
#
# O Cloudflare emite certificado SSL automaticamente (±5 min).
# ────────────────────────────────────────────────────────────────────
"@

$cnameInstructions | Write-Host -ForegroundColor Gray
$cnamePath = "$base\tenants\$TenantSlug\dns-instructions.txt"
$cnameInstructions | Out-File -FilePath $cnamePath -Encoding utf8
Write-Host "  OK — tenants/$TenantSlug/dns-instructions.txt" -ForegroundColor Green

# ── PASSO 4: Gerar README da instância ────────────────────────────────────
Write-Host ""
Write-Host "[4/5] Gerando README da instância..." -ForegroundColor Cyan

$readme = @"
# $TenantNome — Instância IAH Vanguard

**Tenant ID:** $TenantId
**Nicho:** $Nicho
**Email admin:** $Email
**Data de criação:** $(Get-Date -Format "yyyy-MM-dd")

## Ficheiros desta instância

- `brand-config.js` — configuração de marca (carregar no index.html)
- `dns-instructions.txt` — registos DNS a configurar no domínio do cliente

## Activação

1. Subir `brand-config.js` para o servidor do tenant (ou injectar via IAH Factory)
2. Configurar DNS conforme `dns-instructions.txt`
3. Verificar Custom Hostname no Cloudflare Dashboard
4. Intent Graph disponível em: https://vanguard.tech/dashboard?tenant=$TenantId

## Intent Graph — Matriz

Este tenant tem `matrizDashboard: true`.
Para adicionar unidades filhas:
```sql
UPDATE tenants SET parent_id = '$TenantId' WHERE id = '<unidade_id>';
```
"@

$readme | Out-File -FilePath "$base\tenants\$TenantSlug\README.md" -Encoding utf8
Write-Host "  OK — tenants/$TenantSlug/README.md" -ForegroundColor Green

# ── PASSO 5: Commit ────────────────────────────────────────────────────────
Write-Host ""
Write-Host "[5/5] Commitando nova instância..." -ForegroundColor Cyan

Set-Location $base
git add "tenants/$TenantSlug/" 2>&1 | Out-Null
git commit -m "feat(iah): Nova instancia $TenantSlug ($Nicho) — IAH Factory V19" 2>&1 | Out-Null
$hash = git rev-parse --short HEAD
Write-Host "  OK — commit $hash" -ForegroundColor Green

# ── Resumo ─────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "======================================================" -ForegroundColor Green
Write-Host "  IAH FACTORY — $TenantNome CLONADO" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Tenant ID:  $TenantId"
Write-Host "  Pasta:      tenants/$TenantSlug/"
Write-Host ""
Write-Host "  PRÓXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host "  1. Configurar DNS: tenants/$TenantSlug/dns-instructions.txt"
Write-Host "  2. Activar Custom Hostname no Cloudflare Dashboard"
Write-Host "  3. Enviar brand-config.js para o cliente instalar"
Write-Host "  4. Intent Graph: https://vanguard.tech/dashboard?tenant=$TenantId"
Write-Host ""
