#!/usr/bin/env python3
"""Patch skill-loop SKILL.md for jarvis-skills-library: frontmatter + JARVIS/Cursor overlay."""

from __future__ import annotations

import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OVERLAY_MARKER = "## JARVIS / Cursor (mandatory)"
IRON_LAW_MARKER = "### IRON LAW JARVIS"

JARVIS_OVERLAY = """
## JARVIS / Cursor (mandatory)

- **No slash command:** En Cursor no existe `/skill-loop`. Invocar skill `skill-loop` y pedir scaffold YAML o edición de `skill-loop.yml`.
- **Skills directory:** Por defecto JARVIS usa `.agents/skills/` en el repo producto (no `.claude/skills/`).
- **Runtime preferido:** `cursor-cli` (binario `agent` en PATH) en plantillas JARVIS; requiere Cursor CLI instalado.
- **Ejecución CLI:** `skill-loop run` solo **tras OK explícito del usuario** en el YAML generado. Ver `install-skill-loop-runtime.sh`.
- **Router:** `skill-loop-router`. Doc: [docs/SKILL_LOOP_INTEGRATION.md](../../docs/SKILL_LOOP_INTEGRATION.md)
- **vs learning-loop:** skill-loop orquesta pasadas de trabajo; learning-loop captura aprendizajes — no confundir.
- `upstream: skill-loop:skill-loop`

### IRON LAW JARVIS

No ejecutar `skill-loop run` ni cron `schedule` sin aprobación del usuario. No usar `--dangerously-skip-permissions` ni flags equivalentes en YAML JARVIS. Tras `done`, cierre canónico con `session-learner-ops` + `verification-before-completion`.
"""

FRONTMATTER_RE = re.compile(r"^---\s*\n.*?\n---\s*\n", re.DOTALL)

FRONTMATTER = """---
name: skill-loop
description: >
  Scaffold skill-loop.yml y starter skills para loops impl-review-rework.
  Trigger: skill-loop, orquestar skills, skill-loop.yml, loop implementación revisión.
license: MIT
metadata:
  author: JARVIS Global
  version: "1.0-jarvis1"
  scope: [global]
  category: ops
  upstream: skill-loop:skill-loop
  upstream_version: "main"
  auto_invoke:
    - "Crear skill-loop.yml workflow"
    - "Orquestar loop implementación revisión"
  triggers: skill-loop, skill-loop.yml, agent loop, orquestar skills
  related-skills:
    - skill-loop-router
    - jarvis-core
    - test-driven-development
    - code-review-playbook
    - verification-before-completion
    - session-learner-ops
allowed-tools: [Read, Write, Edit, Grep, Glob, Bash]
---

"""

BODY_REPLACEMENTS: list[tuple[str, str]] = [
    (".claude/skills/", ".agents/skills/"),
    (".claude/skills", ".agents/skills"),
    ("/skill-loop`", "skill `skill-loop`"),
    ("run `/skill-loop`", "invoke skill `skill-loop`"),
    ("Open your coding agent in the project and run:", "Open your coding agent in the project and invoke skill `skill-loop`:"),
]


def strip_overlay(body: str) -> str:
    if OVERLAY_MARKER not in body:
        return body
    start = body.index(OVERLAY_MARKER)
    rest = body[start:]
    for sep in ("\n---\n\n# skill-loop", "\n---\n\n# Skill-loop", "\n# skill-loop"):
        if sep in rest:
            end = start + rest.index(sep)
            if sep.startswith("\n---"):
                end += len("\n---\n\n")
            return body[:start] + body[end:]
    return body


def patch_body(body: str) -> str:
    body = strip_overlay(body).lstrip()
    overlay = JARVIS_OVERLAY.strip() + "\n\n---\n\n"

    for old, new in BODY_REPLACEMENTS:
        body = body.replace(old, new)

    # Patch references if present on disk
    ref_dir = Path(os.environ.get("SKILL_LOOP_HOME", ROOT / "skills" / "ops" / "skill-loop")) / "references"
    if ref_dir.is_dir():
        for ref_file in ref_dir.glob("*.md"):
            text = ref_file.read_text(encoding="utf-8")
            for old, new in BODY_REPLACEMENTS:
                text = text.replace(old, new)
            ref_file.write_text(text, encoding="utf-8")

    return overlay + body


def main() -> None:
    home = Path(os.environ.get("SKILL_LOOP_HOME", ROOT / "skills" / "ops" / "skill-loop"))
    skill_md = home / "SKILL.md"
    if not skill_md.is_file():
        raise SystemExit(f"SKILL.md not found at {skill_md} — run sync-skill-loop-skill.sh first")

    raw = skill_md.read_text(encoding="utf-8")
    body = FRONTMATTER_RE.sub("", raw, count=1).strip()
    body = patch_body(body)
    skill_md.write_text(FRONTMATTER + body + "\n", encoding="utf-8")
    print(f"Patched → {skill_md.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
