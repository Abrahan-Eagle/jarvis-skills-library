#!/usr/bin/env python3
"""Regenera catalog/CATALOG.md y catalog/AUTO_INVOKE.md."""

from __future__ import annotations

import re
from collections import defaultdict
from datetime import date
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
SKILLS_ROOT = ROOT / "skills"
CATALOG = ROOT / "catalog" / "CATALOG.md"
AUTO_INVOKE = ROOT / "catalog" / "AUTO_INVOKE.md"
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


def category_from_path(path: Path) -> str:
    try:
        rel = path.parent.relative_to(SKILLS_ROOT)
        return rel.parts[0] if rel.parts else "uncategorized"
    except ValueError:
        return "uncategorized"


def short_desc(fm: dict) -> str:
    desc = fm.get("description", "")
    if not isinstance(desc, str):
        return ""
    desc = " ".join(desc.split())
    if "Trigger:" in desc:
        desc = desc.split("Trigger:")[0].strip()
    return desc


def main() -> None:
    entries: list[tuple[str, str, str, str]] = []
    auto_map: dict[str, list[str]] = defaultdict(list)

    for skill_md in sorted(SKILLS_ROOT.rglob("SKILL.md")):
        fm = load_fm(skill_md)
        if not fm:
            continue
        name = fm.get("name") or skill_md.parent.name
        if not isinstance(name, str):
            continue
        name = name.strip()
        category = category_from_path(skill_md)
        desc = short_desc(fm)
        rel = skill_md.relative_to(ROOT).as_posix()
        entries.append((category, name, desc, rel))

        meta = fm.get("metadata") or {}
        if isinstance(meta, dict):
            invokes = meta.get("auto_invoke") or []
            if isinstance(invokes, str):
                invokes = [invokes]
            for action in invokes:
                if isinstance(action, str) and action.strip():
                    auto_map[action.strip()].append(name)

    entries.sort(key=lambda x: (x[0], x[1]))

    # Counts by category
    counts: dict[str, int] = defaultdict(int)
    for cat, _, _, _ in entries:
        counts[cat] += 1

    lines = [
        "# Catálogo de skills globales",
        "",
        f"> Generado por `scripts/sync-catalog.py` — {date.today().isoformat()}",
        "",
        f"Total: **{len(entries)}** skills",
        "",
        "## Resumen por categoría",
        "",
        "| Categoría | Cantidad |",
        "|-----------|----------|",
    ]
    for cat in sorted(counts.keys()):
        lines.append(f"| `{cat}` | {counts[cat]} |")
    lines.append("")

    current_cat = None
    for category, name, desc, rel in entries:
        if category != current_cat:
            if current_cat is not None:
                lines.append("")
            current_cat = category
            lines.append(f"## {category}")
            lines.append("")
            lines.append("| Skill | Descripción | Ruta |")
            lines.append("|-------|-------------|------|")
        short = desc[:120] + ("…" if len(desc) > 120 else "")
        lines.append(f"| `{name}` | {short} | [{rel}]({rel}) |")

    lines.append("")

    CATALOG.parent.mkdir(parents=True, exist_ok=True)
    CATALOG.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")

    auto_lines = [
        "# Auto-invoke global",
        "",
        f"> Generado por `scripts/sync-catalog.py` — {date.today().isoformat()}",
        "",
        "| Acción | Skill(s) |",
        "|--------|----------|",
    ]
    for action in sorted(auto_map.keys()):
        skills = ", ".join(f"`{s}`" for s in sorted(set(auto_map[action])))
        auto_lines.append(f"| {action} | {skills} |")
    auto_lines.append("")

    AUTO_INVOKE.write_text("\n".join(auto_lines).rstrip() + "\n", encoding="utf-8")
    print(f"Wrote {CATALOG} and {AUTO_INVOKE} ({len(entries)} skills)")


if __name__ == "__main__":
    main()
