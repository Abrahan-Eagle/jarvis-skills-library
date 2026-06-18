#!/usr/bin/env python3
"""Validación PyYAML de todas las skills (tolerante a frontmatter de terceros)."""

from __future__ import annotations

import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
SKILLS_ROOT = ROOT / "skills"
FRONTMATTER_RE = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)
NAME_PATTERN = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")


def load_frontmatter(skill_md: Path) -> dict | None:
    text = skill_md.read_text(encoding="utf-8")
    m = FRONTMATTER_RE.match(text)
    if not m:
        return None
    try:
        data = yaml.safe_load(m.group(1))
    except yaml.YAMLError as e:
        raise ValueError(f"Invalid YAML: {e}") from e
    if not isinstance(data, dict):
        raise ValueError("Frontmatter must be a YAML mapping")
    return data


def validate_skill_dir(skill_dir: Path) -> tuple[str | None, str | None]:
    skill_md = skill_dir / "SKILL.md"
    if not skill_md.exists():
        return None, "SKILL.md not found"

    try:
        fm = load_frontmatter(skill_md)
    except ValueError as e:
        return None, str(e)

    if fm is None:
        return None, "No frontmatter block"

    name = fm.get("name")
    if not name or not isinstance(name, str):
        return None, "Missing or invalid 'name'"
    name = name.strip()
    if not NAME_PATTERN.match(name):
        return None, f"Name '{name}' must be kebab-case"
    if len(name) > 64:
        return None, f"Name too long ({len(name)} chars, max 64)"

    desc = fm.get("description")
    if not desc or not isinstance(desc, str):
        return None, "Missing or invalid 'description'"
    desc = desc.strip()
    if not desc:
        return None, "Empty description"
    if len(desc) > 1024:
        return None, f"Description too long ({len(desc)} chars, max 1024)"
    if "<" in desc or ">" in desc:
        return None, "Description cannot contain angle brackets"

    return name, None


def main() -> int:
    errors: list[str] = []
    seen: dict[str, str] = {}

    skill_dirs = sorted(
        {p.parent for p in SKILLS_ROOT.rglob("SKILL.md")},
        key=lambda p: str(p),
    )

    for skill_dir in skill_dirs:
        rel = skill_dir.relative_to(SKILLS_ROOT).as_posix()
        name, err = validate_skill_dir(skill_dir)
        if err:
            errors.append(f"{rel}: {err}")
            continue
        if name in seen:
            errors.append(f"{rel}: duplicate name '{name}' (also in {seen[name]})")
        else:
            seen[name] = rel

    if errors:
        for e in errors:
            print(f"FAIL: {e}")
        print(f"\nvalidate-yaml: {len(errors)} error(s)")
        return 1

    print(f"validate-yaml: {len(seen)} skills OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
