#!/usr/bin/env python3
"""Generate catalog/SDX_TOOLKITS.md from catalog/sdx-toolkit-registry.json."""

from __future__ import annotations

import json
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REGISTRY = ROOT / "catalog" / "sdx-toolkit-registry.json"
OUT = ROOT / "catalog" / "SDX_TOOLKITS.md"


def main() -> None:
    data = json.loads(REGISTRY.read_text(encoding="utf-8"))
    lines = [
        "# SD-X Toolkits (JARVIS)",
        "",
        f"> Generado por `scripts/sync-sdx-registry.py` — {date.today().isoformat()}",
        "",
        "Fuente: [`sdx-toolkit-registry.json`](sdx-toolkit-registry.json). Guía: [docs/SDX_ECOSYSTEM.md](../docs/SDX_ECOSYSTEM.md).",
        "",
        "## Integrados",
        "",
        "| ID | Nombre | SD-X | Pin | Skills JARVIS | Sync |",
        "|----|--------|------|-----|---------------|------|",
    ]
    for t in data.get("toolkits", []):
        jarvis = t.get("jarvis", {})
        skills = ", ".join(jarvis.get("skills", []))
        sdx = ", ".join(t.get("sdx", []))
        lines.append(
            f"| {t['id']} | {t['name']} | {sdx} | {t.get('pin', '')} | {skills} | `{jarvis.get('sync', '')}` |"
        )
    refs = data.get("references", [])
    if refs:
        lines.extend(["", "## Referencias externas", "", "| Nombre | URL | Nota |", "|--------|-----|------|"])
        for r in refs:
            lines.append(f"| {r['name']} | {r['url']} | {r.get('note', '')} |")
    lines.append("")
    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUT}")


if __name__ == "__main__":
    main()
