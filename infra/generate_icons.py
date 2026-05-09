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
    print(f"✅ {output_path} ({size}×{size})")


if __name__ == "__main__":
    out = Path(__file__).parent.parent / "assets" / "icons"
    out.mkdir(parents=True, exist_ok=True)
    make_icon(192, out / "icon-192.png")
    make_icon(512, out / "icon-512.png")
