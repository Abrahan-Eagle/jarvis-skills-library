#!/usr/bin/env python3
"""Generate catalog/SDX_TOOLKITS.md from catalog/sdx-toolkit-registry.json."""

from __future__ import annotations

import json
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REGISTRY = ROOT / "catalog" / "sdx-toolkit-registry.json"
OUT = ROOT / "catalog" / "SDX_TOOLKITS.md"


def _jarvis_cell(jarvis: dict) -> str:
    parts = []
    if jarvis.get("skills"):
        parts.append(", ".join(jarvis["skills"]))
    if jarvis.get("sync"):
        parts.append(f"sync: `{jarvis['sync']}`")
    if jarvis.get("install"):
        parts.append(f"install: `{jarvis['install']}`")
    return " · ".join(parts) if parts else ""


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
        sync = jarvis.get("sync", jarvis.get("install", ""))
        lines.append(
            f"| {t['id']} | {t['name']} | {sdx} | {t.get('pin', '')} | {skills} | `{sync}` |"
        )

    watchlist = data.get("watchlist", [])
    if watchlist:
        lines.extend(
            [
                "",
                "## Watchlist (awesome-spec-kits)",
                "",
                "Ver [docs/AWESOME_SPEC_KITS.md](../docs/AWESOME_SPEC_KITS.md).",
                "",
                "| ID | Nombre | SD-X | Pin | JARVIS | Nota |",
                "|----|--------|------|-----|--------|------|",
            ]
        )
        for w in watchlist:
            sdx = ", ".join(w.get("sdx", []))
            jarvis = w.get("jarvis", {})
            jarvis_col = _jarvis_cell(jarvis)
            note = w.get("note", jarvis.get("install", ""))
            lines.append(
                f"| {w['id']} | {w.get('name', w['id'])} | {sdx} | {w.get('pin', '')} | {jarvis_col} | {note} |"
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
