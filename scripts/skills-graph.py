#!/usr/bin/env python3
"""Genera catalog/SKILLS_GRAPH.md (mermaid) desde related-skills en frontmatter."""

from __future__ import annotations

import re
from datetime import date
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
SKILLS_ROOT = ROOT / "skills"
OUTPUT = ROOT / "catalog" / "SKILLS_GRAPH.md"
FRONTMATTER_RE = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)


def load_fm(path: Path) -> dict | None:
    text = path.read_text(encoding="utf-8")
    m = FRONTMATTER_RE.match(text)
    if not m:
        return None
    try:
        data = yaml.safe_load(m.group(1))
    except yaml.YAMLError:
        return None
    return data if isinstance(data, dict) else None


def safe_id(name: str) -> str:
    return re.sub(r"[^a-zA-Z0-9_]", "_", name)


def main() -> None:
    known: set[str] = set()
    edges: list[tuple[str, str]] = []

    for skill_md in sorted(SKILLS_ROOT.rglob("SKILL.md")):
        fm = load_fm(skill_md)
        if not fm:
            continue
        name = fm.get("name")
        if not isinstance(name, str):
            continue
        name = name.strip()
        known.add(name)

        meta = fm.get("metadata") or {}
        related = []
        if isinstance(meta, dict):
            rel = meta.get("related-skills") or meta.get("related_skills") or []
            if isinstance(rel, str):
                related = [rel]
            elif isinstance(rel, list):
                related = rel
        for r in related:
            if isinstance(r, str) and r.strip():
                target = r.strip()
                edges.append((name, target))

    lines = [
        "# Grafo de skills relacionadas",
        "",
        f"> Generado por `scripts/skills-graph.py` — {date.today().isoformat()}",
        "",
        "```mermaid",
        "flowchart LR",
    ]

    for src, dst in sorted(set(edges)):
        if dst not in known:
            continue
        lines.append(f"  {safe_id(src)}[\"{src}\"] --> {safe_id(dst)}[\"{dst}\"]")

    lines.extend(["```", "", f"Nodos conocidos: {len(known)}. Aristas (solo a skills en catálogo): {len([e for e in set(edges) if e[1] in known])}.", ""])

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUTPUT}")


if __name__ == "__main__":
    main()
