#!/usr/bin/env python3
"""Gera ícones PNG para o PWA manifest."""

import sys
from pathlib import Path

try:
    from PIL import Image, ImageDraw
except ImportError:
    print("Execute: pip install Pillow"); sys.exit(1)


def make_icon(size: int, output_path: Path):
    img = Image.new("RGBA", (size, size), (10, 10, 10, 255))
    draw = ImageDraw.Draw(img)

    cx, cy = size // 2, size // 2
    s = size * 0.72

    # "V" shape in Cyber Cyan
    pts = [
        (cx, cy - s * 0.42),
        (cx + s * 0.42, cy + s * 0.42),
        (cx + s * 0.18, cy + s * 0.42),
        (cx, cy - s * 0.02),
        (cx - s * 0.18, cy + s * 0.42),
        (cx - s * 0.42, cy + s * 0.42),
    ]
    draw.polygon(pts, fill=(0, 240, 255, 255))

    # Bottom bar
    bar_h = max(4, int(size * 0.06))
    bar_w = int(size * 0.3)
    bar_x = cx - bar_w // 2
    bar_y = int(cy + s * 0.42) + int(size * 0.02)
    draw.rectangle([bar_x, bar_y, bar_x + bar_w, bar_y + bar_h], fill=(0, 240, 255, 255))

    img.save(output_path, "PNG")
    print(f"OK {output_path} ({size}x{size})")


def make_maskable_icon(size: int, output_path: Path):
    """Generate an RGB (no alpha) maskable icon with 10% safe-zone padding.

    The "V" shape is scaled to fit within the central 80% of the canvas so that
    Android adaptive-icon clipping never cuts into the logo.
    """
    # RGB mode — no alpha channel (required for maskable purpose)
    img = Image.new("RGB", (size, size), (10, 10, 10))
    draw = ImageDraw.Draw(img)

    cx, cy = size // 2, size // 2
    # Content fits within 80% of canvas (10% safe-zone on each side)
    safe = size * 0.80
    # Scale the original 0.72-relative "V" shape to fit inside the safe zone
    s = safe * 0.72

    # "V" shape in Cyber Cyan
    pts = [
        (cx, cy - s * 0.42),
        (cx + s * 0.42, cy + s * 0.42),
        (cx + s * 0.18, cy + s * 0.42),
        (cx, cy - s * 0.02),
        (cx - s * 0.18, cy + s * 0.42),
        (cx - s * 0.42, cy + s * 0.42),
    ]
    draw.polygon(pts, fill=(0, 240, 255))

    # Bottom bar
    bar_h = max(4, int(safe * 0.06))
    bar_w = int(safe * 0.3)
    bar_x = cx - bar_w // 2
    bar_y = int(cy + s * 0.42) + int(safe * 0.02)
    draw.rectangle([bar_x, bar_y, bar_x + bar_w, bar_y + bar_h], fill=(0, 240, 255))

    img.save(output_path, "PNG")
    print(f"OK {output_path} ({size}x{size}, maskable/RGB)")


if __name__ == "__main__":
    out = Path(__file__).parent.parent / "assets" / "icons"
    out.mkdir(parents=True, exist_ok=True)

    # Standard icons (RGBA, purpose: any)
    make_icon(192, out / "icon-192.png")
    make_icon(512, out / "icon-512.png")

    # Maskable icons (RGB, no alpha, 10% safe-zone, purpose: maskable)
    make_maskable_icon(192, out / "icon-192-maskable.png")
    make_maskable_icon(512, out / "icon-512-maskable.png")
