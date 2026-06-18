#!/usr/bin/env python3
"""Generate catalog/ecc-skills-index.md from ECC upstream (discovery index, not full import)."""

from __future__ import annotations

import json
import urllib.request
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "catalog" / "ecc-skills-index.md"
ECC_REF = __import__("os").environ.get("ECC_REF", "v2.0.0")
API_SKILLS = f"https://api.github.com/repos/affaan-m/ecc/contents/skills?ref={ECC_REF}"
API_AGENTS = f"https://api.github.com/repos/affaan-m/ecc/contents/agents?ref={ECC_REF}"


def fetch_json(url: str) -> list[dict]:
    req = urllib.request.Request(url, headers={"Accept": "application/vnd.github+json"})
    with urllib.request.urlopen(req, timeout=60) as resp:
        return json.load(resp)


def list_skill_dirs(api_url: str) -> list[str]:
    try:
        items = fetch_json(api_url)
    except Exception as exc:
        print(f"Warning: could not fetch {api_url}: {exc}")
        return []
    return sorted(
        x["name"] for x in items if isinstance(x, dict) and x.get("type") == "dir"
    )


def list_agent_files(api_url: str) -> list[str]:
    try:
        items = fetch_json(api_url)
    except Exception as exc:
        print(f"Warning: could not fetch {api_url}: {exc}")
        return []
    names: list[str] = []
    for x in items:
        if not isinstance(x, dict) or x.get("type") != "file":
            continue
        name = x.get("name", "")
        if name.endswith(".md"):
            names.append(name[:-3])
    return sorted(names)


def main() -> None:
    skills = list_skill_dirs(API_SKILLS)
    agents = list_agent_files(API_AGENTS)

    lines = [
        "# ECC upstream index (discovery)",
        "",
        f"Auto-generated from [affaan-m/ecc](https://github.com/affaan-m/ecc) ref `{ECC_REF}`.",
        f"Date: {date.today().isoformat()}.",
        "",
        "Not part of JARVIS global catalog — use `ecc consult` or install runtime in product repo.",
        "",
        "Curated in global: `continuous-learning-v2`, `security-review-ecc`, `configure-ecc`.",
        "",
        f"## Skills upstream ({len(skills)})",
        "",
    ]
    for name in skills:
        lines.append(f"- `{name}` → `skills/{name}/`")
    lines.extend(["", f"## Agents upstream ({len(agents)})", ""])
    for name in agents:
        lines.append(f"- `{name}` → `agents/{name}.md` (install → `.cursor/agents/`)")
    lines.extend(
        [
            "",
            "## Sync",
            "",
            "```bash",
            "bash scripts/sync-ecc-skills.sh",
            "python3 scripts/sync-ecc-manifest.py",
            "```",
            "",
        ]
    )

    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Wrote {OUT.relative_to(ROOT)} ({len(skills)} skills, {len(agents)} agents)")


if __name__ == "__main__":
    main()
