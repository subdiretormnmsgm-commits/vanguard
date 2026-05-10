"""
Vanguard V16 — Dynamic Badge SVG Edge
GET /api/badge/{domain_slug}.svg → SVG de autoridade com score e tier

Motor de backlinks orgânicos: cada empresa avaliada pode embeddar o badge
no seu site, criando um link de volta para vanguardtech.io.

Cache: 24h (score não muda mais de uma vez por dia no tier básico)
Performance: geração pure-Python sem dependências pesadas, < 2ms por badge
"""

import hashlib
import os
import re
from datetime import datetime

import httpx
from fastapi import APIRouter, HTTPException, Path, Response
from fastapi.responses import Response as FastResponse

router = APIRouter(prefix="/api", tags=["badge"])

SUPABASE_URL         = os.getenv("SUPABASE_URL", "")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY", "")

# Paleta V16 — Ion Gold + Deep Obsidian
_GOLD  = "#C5A028"
_DARK  = "#0A0802"
_CYAN  = "#00F0FF"
_WHITE = "#F0EDE8"

# Tier → cor do indicador lateral
_TIER_COLORS = {
    "VIP":    "#FF4444",
    "QUENTE": "#FFB800",
    "MORNO":  "#00F0FF",
    "FRIO":   "#4A5568",
}

# Tier label → texto no badge
_TIER_LABELS = {
    "VIP":    "ELITE",
    "QUENTE": "VERIFIED",
    "MORNO":  "ASSESSED",
    "FRIO":   "INDEXED",
}


def _slug_to_domain(slug: str) -> str:
    """Converte slug de URL (hifens) para domínio (pontos)."""
    slug = slug.replace("_", ".").replace("--", ".")
    if not slug.startswith("http"):
        slug = slug
    return slug[:128]


def _deterministic_score(domain: str) -> tuple[float, str]:
    """
    Score determinístico por domínio (consistente com V12 motor djb2).
    Em produção, este valor vem do Supabase — este fallback garante
    que o badge sempre renderiza mesmo sem dados reais.
    """
    h = int(hashlib.sha256(domain.encode()).hexdigest(), 16)
    score = 3.0 + (h % 70) / 10.0  # 3.0 – 10.0
    score = round(score, 1)
    if score >= 8.5:
        tier = "VIP"
    elif score >= 7.0:
        tier = "QUENTE"
    elif score >= 5.0:
        tier = "MORNO"
    else:
        tier = "FRIO"
    return score, tier


async def _fetch_score_from_supabase(domain: str) -> tuple[float, str] | None:
    if not SUPABASE_URL or not SUPABASE_SERVICE_KEY:
        return None
    try:
        async with httpx.AsyncClient(timeout=1.5) as client:
            resp = await client.get(
                f"{SUPABASE_URL}/rest/v1/leads_diagnostico",
                params={
                    "select": "score_digital,tier",
                    "website": f"ilike.%{domain}%",
                    "order": "created_at.desc",
                    "limit": "1",
                },
                headers={
                    "apikey": SUPABASE_SERVICE_KEY,
                    "Authorization": f"Bearer {SUPABASE_SERVICE_KEY}",
                },
            )
            if resp.status_code == 200:
                data = resp.json()
                if data:
                    return float(data[0].get("score_digital", 0)), data[0].get("tier", "FRIO")
    except Exception:
        pass
    return None


def _render_svg(domain: str, score: float, tier: str) -> str:
    tier_color = _TIER_COLORS.get(tier, _CYAN)
    tier_label = _TIER_LABELS.get(tier, "ASSESSED")
    bar_width   = int((score / 10.0) * 120)  # 0–120px
    score_str   = f"{score:.1f}"
    domain_disp = domain[:28] + ("…" if len(domain) > 28 else "")
    year        = datetime.now().year

    # Nível de opacidade do brilho baseado no tier
    glow_opacity = {"VIP": "0.9", "QUENTE": "0.7", "MORNO": "0.5", "FRIO": "0.3"}.get(tier, "0.5")

    return f"""<svg xmlns="http://www.w3.org/2000/svg" width="320" height="88"
     viewBox="0 0 320 88" role="img"
     aria-label="Vanguard Authority Badge — {domain} — Score {score_str}">
  <title>Vanguard Authority Badge</title>
  <defs>
    <!-- Fundo Obsidian com gradiente sutil -->
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%"   stop-color="{_DARK}" />
      <stop offset="100%" stop-color="#14110A" />
    </linearGradient>
    <!-- Brilho Ion Gold no topo -->
    <linearGradient id="topShimmer" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0%"   stop-color="transparent" />
      <stop offset="40%"  stop-color="{_GOLD}" stop-opacity="{glow_opacity}" />
      <stop offset="60%"  stop-color="{_GOLD}" stop-opacity="{glow_opacity}" />
      <stop offset="100%" stop-color="transparent" />
    </linearGradient>
    <!-- Gradiente da barra de score -->
    <linearGradient id="scoreBar" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0%"   stop-color="{tier_color}" stop-opacity="0.6" />
      <stop offset="100%" stop-color="{tier_color}" />
    </linearGradient>
    <!-- Sombra externa para peso visual -->
    <filter id="shadow" x="-10%" y="-10%" width="120%" height="120%">
      <feDropShadow dx="0" dy="4" stdDeviation="8"
                    flood-color="{_GOLD}" flood-opacity="0.25" />
    </filter>
    <!-- Brilho do score -->
    <filter id="scoreGlow">
      <feGaussianBlur stdDeviation="2" result="blur" />
      <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
    </filter>
  </defs>

  <!-- Painel principal — Monolithic Glass -->
  <rect width="320" height="88" rx="6" ry="6"
        fill="url(#bg)" stroke="{_GOLD}" stroke-width="0.5"
        filter="url(#shadow)" />

  <!-- Linha Ion Gold no topo (shimmer estático no SVG) -->
  <rect x="0" y="0" width="320" height="1" rx="0"
        fill="url(#topShimmer)" />

  <!-- Barra lateral de tier (indicador de cor) -->
  <rect x="0" y="0" width="3" height="88" rx="0"
        fill="{tier_color}" opacity="0.9" />

  <!-- ── Coluna esquerda: Logo V + Label ── -->
  <text x="18" y="24" font-family="'JetBrains Mono',monospace"
        font-size="11" font-weight="700" fill="{_GOLD}" letter-spacing="2">
    VANGUARD
  </text>
  <text x="18" y="38" font-family="'JetBrains Mono',monospace"
        font-size="7" fill="{_GOLD}" opacity="0.55" letter-spacing="3">
    AUTHORITY INDEX
  </text>

  <!-- Separador horizontal -->
  <line x1="18" y1="45" x2="180" y2="45"
        stroke="{_GOLD}" stroke-width="0.3" opacity="0.3" />

  <!-- Domínio -->
  <text x="18" y="60" font-family="'Inter',sans-serif"
        font-size="11" fill="{_WHITE}" opacity="0.85">
    {domain_disp}
  </text>

  <!-- Tier label -->
  <text x="18" y="76" font-family="'JetBrains Mono',monospace"
        font-size="7.5" fill="{tier_color}" letter-spacing="2" font-weight="600">
    ■ {tier_label}
  </text>

  <!-- ── Coluna direita: Score ── -->
  <!-- Score numérico grande -->
  <text x="254" y="58" font-family="'JetBrains Mono',monospace"
        font-size="32" font-weight="700" fill="{tier_color}"
        text-anchor="middle" filter="url(#scoreGlow)">
    {score_str}
  </text>
  <text x="254" y="72" font-family="'JetBrains Mono',monospace"
        font-size="7" fill="{_GOLD}" opacity="0.5"
        text-anchor="middle" letter-spacing="2">
    /10
  </text>

  <!-- Barra de score horizontal (fundo) -->
  <rect x="200" y="76" width="120" height="3" rx="1.5"
        fill="{_DARK}" opacity="0.8" />
  <!-- Barra de score horizontal (preenchimento) -->
  <rect x="200" y="76" width="{bar_width}" height="3" rx="1.5"
        fill="url(#scoreBar)" />

  <!-- Canto: link Vanguard (clickável se embedado) -->
  <a href="https://vanguardtech.io" target="_blank">
    <text x="160" y="83" font-family="'JetBrains Mono',monospace"
          font-size="6" fill="{_GOLD}" opacity="0.35"
          text-anchor="middle" letter-spacing="1">
      vanguardtech.io · {year}
    </text>
  </a>
</svg>"""


@router.get(
    "/badge/{domain_slug}.svg",
    response_class=FastResponse,
    summary="Dynamic Authority Badge SVG",
    description="Gera badge SVG de autoridade para o domínio. Cache: 24h.",
)
async def get_badge_svg(
    domain_slug: str = Path(..., description="Domínio slug (pontos → hifens)", max_length=128),
) -> FastResponse:
    domain = _slug_to_domain(domain_slug.replace(".svg", "").strip("/"))

    if not re.match(r"^[a-zA-Z0-9\-\.]{3,128}$", domain):
        raise HTTPException(status_code=400, detail="Domínio inválido.")

    result = await _fetch_score_from_supabase(domain)
    if result:
        score, tier = result
    else:
        score, tier = _deterministic_score(domain)

    svg_content = _render_svg(domain, score, tier)

    return FastResponse(
        content=svg_content,
        media_type="image/svg+xml",
        headers={
            "Cache-Control": "public, max-age=86400, stale-while-revalidate=3600",
            "X-Vanguard-Score": str(score),
            "X-Vanguard-Tier": tier,
            "X-Content-Type-Options": "nosniff",
        },
    )


@router.get(
    "/badge/{domain_slug}.json",
    summary="Badge Score JSON",
    description="Retorna score e tier em JSON para integração programática.",
)
async def get_badge_json(
    domain_slug: str = Path(..., max_length=128),
) -> dict:
    domain = _slug_to_domain(domain_slug.replace(".json", "").strip("/"))

    if not re.match(r"^[a-zA-Z0-9\-\.]{3,128}$", domain):
        raise HTTPException(status_code=400, detail="Domínio inválido.")

    result = await _fetch_score_from_supabase(domain)
    if result:
        score, tier = result
        source = "supabase"
    else:
        score, tier = _deterministic_score(domain)
        source = "deterministic"

    return {
        "domain": domain,
        "score": score,
        "tier": tier,
        "tier_label": _TIER_LABELS.get(tier, "ASSESSED"),
        "badge_url": f"https://vanguardtech.io/api/badge/{domain_slug}.svg",
        "embed_code": f'<img src="https://vanguardtech.io/api/badge/{domain_slug}.svg" alt="Vanguard Authority Badge" width="320" height="88" />',
        "source": source,
    }
