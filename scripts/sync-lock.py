#!/usr/bin/env python3
"""Regenera skills-lock.json con provenance y hash de SKILL.md."""

from __future__ import annotations

import hashlib
import json
import re
from datetime import date
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
SKILLS_ROOT = ROOT / "skills"
LOCK_FILE = ROOT / "skills-lock.json"
FRONTMATTER_RE = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)


def file_hash(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def parse_upstream(value: str) -> tuple[str, str]:
    if value.startswith("github/spec-kit:"):
        return "github/spec-kit", "github"
    if value.startswith("nextlevelbuilder/"):
        return value.split(":")[0], "github"
    if ":" in value:
        org, rest = value.split(":", 1)
        if org in ("superpowers", "obra"):
            return "obra/superpowers", "github"
        if "/" in org:
            return org, "github"
        return f"{org}/{rest.split(':')[0]}", "github"
    if "/" in value:
        return value, "github"
    return value, "local"


def infer_source(fm: dict) -> tuple[str, str]:
    meta = fm.get("metadata") or {}
    if isinstance(meta, dict):
        upstream = meta.get("upstream")
        if upstream and isinstance(upstream, str):
            return parse_upstream(upstream)
        src = meta.get("source")
        if src and isinstance(src, str):
            if src == "community":
                return "community", "community"
            return src, meta.get("sourceType", "github")
    top_source = fm.get("source")
    if top_source and isinstance(top_source, str):
        if top_source == "community":
            return "community", "community"
        return top_source, "github"
    author = meta.get("author") if isinstance(meta, dict) else None
    if author == "JARVIS Global":
        return "jarvis-skills-library", "local"
    return "jarvis-skills-library", "local"


def main() -> None:
    skills: dict[str, dict] = {}

    for skill_md in sorted(SKILLS_ROOT.rglob("SKILL.md")):
        text = skill_md.read_text(encoding="utf-8")
        m = FRONTMATTER_RE.match(text)
        if not m:
            continue
        try:
            fm = yaml.safe_load(m.group(1))
        except yaml.YAMLError:
            continue
        if not isinstance(fm, dict):
            continue
        name = fm.get("name")
        if not name or not isinstance(name, str):
            continue
        source, source_type = infer_source(fm)
        rel_path = skill_md.relative_to(ROOT).as_posix()
        entry: dict = {
            "source": source,
            "sourceType": source_type,
            "computedHash": file_hash(skill_md),
            "path": rel_path,
        }
        meta = fm.get("metadata")
        if isinstance(meta, dict) and meta.get("upstream"):
            entry["upstream"] = meta["upstream"]
        skills[name.strip()] = entry

    lock = {
        "version": 1,
        "generated": date.today().isoformat(),
        "skills": skills,
    }
    LOCK_FILE.write_text(json.dumps(lock, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"Wrote {LOCK_FILE} ({len(skills)} skills)")


if __name__ == "__main__":
    main()
