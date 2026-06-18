#!/usr/bin/env python3
"""Patch skill-loop SKILL.md for jarvis-skills-library: frontmatter + JARVIS/Cursor overlay v2."""

from __future__ import annotations

import json
import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OVERLAY_MARKER = "## JARVIS / Cursor (mandatory)"
SCHEMA_REMOTE = "https://raw.githubusercontent.com/takumiyoshikawa/skill-loop/refs/heads/main/schema.json"
SCHEMA_LOCAL_COMMENT = "references/schema.json (pinned copy in jarvis-skills-library)"

JARVIS_OVERLAY = """
## JARVIS / Cursor (mandatory)

- **No slash command:** En Cursor no existe `/skill-loop`. Invocar skill `skill-loop` y pedir scaffold YAML o edición de `skill-loop.yml`.
- **Skills directory:** Repo producto → `.agents/skills/` para steps del loop; skills globales JARVIS → `~/.cursor/skills/` (`bash scripts/install.sh --all`).
- **Runtime preferido:** `cursor-cli` (binario `agent` en PATH) en plantillas JARVIS; requiere Cursor CLI instalado.
- **Ejecución CLI:** `skill-loop run` solo **tras OK explícito del usuario** en el YAML generado. Ver `install-skill-loop-runtime.sh`.
- **Starter skills JARVIS:** Copiar `assets/jarvis-implement|review|verify.SKILL.md.tmpl` → `.agents/skills/<step>/SKILL.md`.
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
  version: "1.0-jarvis2"
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
    - learning-loop-router
allowed-tools: [Read, Write, Edit, Grep, Glob, Bash]
---

"""

BODY_REPLACEMENTS: list[tuple[str, str]] = [
    (".claude/skills/", ".agents/skills/"),
    (".claude/skills", ".agents/skills"),
    (SCHEMA_REMOTE, SCHEMA_LOCAL_COMMENT),
    ("https://raw.githubusercontent.com/takumiyoshikawa/skill-loop/main/schema.json", SCHEMA_LOCAL_COMMENT),
    ("/skill-loop`", "skill `skill-loop`"),
    ("run `/skill-loop`", "invoke skill `skill-loop`"),
    (
        "Open your coding agent in the project and run:",
        "Open your coding agent in the project and invoke skill `skill-loop`:",
    ),
]

# JARVIS preference in pattern docs (after generic replacements)
PATTERN_REPLACEMENTS: list[tuple[str, str]] = [
    (
        "runtime: codex\n  model: gpt-5.4",
        "runtime: cursor-cli\n  model: gpt-5  # JARVIS default; codex/claude optional with OK usuario",
    ),
    (
        "runtime: codex\n  model: gpt-5.4",
        "runtime: cursor-cli\n  model: gpt-5  # JARVIS default",
    ),
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


def patch_text_file(path: Path) -> None:
    if not path.is_file():
        return
    text = path.read_text(encoding="utf-8")
    for old, new in BODY_REPLACEMENTS:
        text = text.replace(old, new)
    for old, new in PATTERN_REPLACEMENTS:
        text = text.replace(old, new)
    path.write_text(text, encoding="utf-8")


def patch_schema(schema_path: Path) -> None:
    if not schema_path.is_file():
        return
    data = json.loads(schema_path.read_text(encoding="utf-8"))
    agent_props = data.get("$defs", {}).get("Agent", {}).get("properties", {})
    if not agent_props:
        agent_props = data.get("definitions", {}).get("agent", {}).get("properties", {})
    if "runtime" in agent_props:
        agent_props["runtime"]["description"] = (
            "Agent CLI runtime (claude, codex, cursor-cli, opencode). "
            "JARVIS default: cursor-cli. Defaults to claude upstream if omitted."
        )
    if "args" in agent_props:
        agent_props["args"]["description"] = (
            "Optional CLI args. JARVIS: do not use --dangerously-skip-permissions or equivalent."
        )
    schema_path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")


def patch_tree(skill_home: Path) -> None:
    ref_dir = skill_home / "references"
    assets_dir = skill_home / "assets"
    for ref_file in ref_dir.glob("*.md"):
        patch_text_file(ref_file)
    for asset_file in assets_dir.glob("*"):
        if asset_file.suffix in {".tmpl", ".md"} or asset_file.name.endswith(".tmpl"):
            patch_text_file(asset_file)


def patch_body(body: str) -> str:
    body = strip_overlay(body).lstrip()
    overlay = JARVIS_OVERLAY.strip() + "\n\n---\n\n"

    for old, new in BODY_REPLACEMENTS:
        body = body.replace(old, new)

    # Replace Validate section schema line if present
    body = re.sub(
        r"- schema:https://raw\.githubusercontent\.com/takumiyoshikawa/skill-loop[^\n]*",
        "- schema: use `references/schema.json` in this skill tree; validate with `skill-loop validate` if CLI installed",
        body,
    )

    validate_note = (
        "\n- JARVIS starter tmpl: `assets/jarvis-implement|review|verify.SKILL.md.tmpl`, "
        "`assets/skill-loop.jarvis.yml.tmpl`"
    )
    if "jarvis-implement" not in body and "## Validate" in body:
        body = body.replace("## Validate", "## Validate" + validate_note, 1)

    return overlay + body


def main() -> None:
    home = Path(os.environ.get("SKILL_LOOP_HOME", ROOT / "skills" / "ops" / "skill-loop"))
    skill_md = home / "SKILL.md"
    if not skill_md.is_file():
        raise SystemExit(f"SKILL.md not found at {skill_md} — run sync-skill-loop-skill.sh first")

    patch_tree(home)
    patch_schema(home / "references" / "schema.json")

    raw = skill_md.read_text(encoding="utf-8")
    body = FRONTMATTER_RE.sub("", raw, count=1).strip()
    body = patch_body(body)
    skill_md.write_text(FRONTMATTER + body + "\n", encoding="utf-8")
    print(f"Patched → {skill_md.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
