#!/usr/bin/env python3
"""Patch learning-loop SKILL.md for jarvis-skills-library: frontmatter + JARVIS/Cursor overlay."""

from __future__ import annotations

import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OVERLAY_MARKER = "## JARVIS / Cursor (mandatory)"
LEARNING_HOME = "~/.cursor/learning-captures"

JARVIS_OVERLAY = f"""
## JARVIS / Cursor (mandatory)

- **No slash command:** En Cursor no existe `/learning-loop`. Invocar skill `learning-loop` y que el usuario indique **scan** o **wrap up** (o contexto: "contexto largo", "cerrar sesión", "consolidar").
- **LEARNING_LOOP_HOME:** `{LEARNING_HOME}` (override: `$LEARNING_LOOP_HOME`). Sustituye la ruta runtime de Claude Code del upstream.
- **Sub-agentes:** Cursor **Task** (`subagent_type: generalPurpose`, `readonly: true`). STOP rules upstream (scan/consolidation en main thread = error). No tool `Skill` de Claude Code.
- **Router:** `learning-loop-router`. Doc: [docs/LEARNING_LOOP_INTEGRATION.md](../../docs/LEARNING_LOOP_INTEGRATION.md)
- **Cierre módulo canónico:** Siempre `session-learner-ops` → `docs/active_context.md` primero; learning-loop wrap-up es **complemento opcional**, no sustituto.
- `upstream: learning-loop-skill:learning-loop`

### Destinos JARVIS (sustituyen CLAUDE.md / MEMORY.md en repos producto)

| Tipo upstream | Destino JARVIS |
|---------------|----------------|
| Process behavioral (global) | `~/.cursor/skills/` o reglas globales — **solo con OK usuario** |
| Process behavioral (proyecto) | `AGENTS.md` / `.cursorrules` (trigger corto; protocolo en `docs/` o `.agents/`) |
| Process operational | `docs/` playbooks o sección AGENTS |
| Facts / sesión | `docs/active_context.md` (`context-updater` / `session-learner-ops`) |
| Cierre módulo / patrones UI | `.agents/plans/walkthrough.md` |
| Code-level fix | walkthrough + `documentar-avances` — **no** `/ce:compound` |
| Watch-list / graduation | `{LEARNING_HOME}/watch-list.md`, `graduation-log.md` |
| Judgment Ledger / PERSONAL_CONTEXT / content wedge | **No rutear** en repos producto JARVIS |
| Skills-level | `jarvis-skills-library` si la sesión tocó skills |
| Auto-memory Claude (`MEMORY.md`) | `docs/active_context.md` del repo activo |

Referencias a `positioning/content_wedges_v2.md` → N/A repos producto JARVIS.
"""

FRONTMATTER_RE = re.compile(r"^---\s*\n.*?\n---\s*\n", re.DOTALL)

FRONTMATTER = """---
name: learning-loop
description: >
  Scan mid-session y wrap-up con quality gates: captura aprendizajes antes de perder contexto.
  Trigger: learning-loop scan, wrap up, consolidar sesión, contexto largo antes de cerrar.
license: MIT
metadata:
  author: JARVIS Global
  version: "4.1-jarvis1"
  scope: [global]
  category: ops
  upstream: learning-loop-skill:learning-loop
  upstream_version: "4.1.0"
  auto_invoke:
    - "learning-loop scan wrap up"
    - "Consolidar aprendizajes de sesión"
    - "Contexto largo capturar señales"
  triggers: learning-loop, wrap up, consolidar sesión, scan mid-session
  related-skills:
    - learning-loop-router
    - session-learner-ops
    - context-updater
    - handoff
    - jarvis-core
    - documentar-avances
allowed-tools: [Read, Write, Edit, Grep, Glob, Bash, Task]
---

"""


def patch_body(body: str) -> str:
    body = body.replace("~/.claude/learning-captures", LEARNING_HOME)
    body = body.replace("$HOME/.claude/learning-captures", LEARNING_HOME.replace("~", "$HOME"))
    body = re.sub(r"\bTask agent\b", "Task subagent (Cursor)", body)
    body = re.sub(r"\bSPAWN\b.*Task agent", "SPAWN Task subagent (Cursor)", body, count=1)
    body = body.replace("tool `Agent`", "tool **Task** (Cursor)")
    body = re.sub(r"\bAgent tool\b", "Task tool (Cursor)", body)
    # Auto-memory path: prefer repo active_context
    body = body.replace(
        "for f in ~/.claude/projects/*/memory/*.md; do",
        "for f in docs/active_context.md .agents/plans/walkthrough.md; do",
        1,
    )
    if OVERLAY_MARKER not in body:
        body = JARVIS_OVERLAY.strip() + "\n\n---\n\n" + body
    return body


def main() -> None:
    home = Path(os.environ.get("LEARNING_LOOP_HOME", ROOT / "skills" / "ops" / "learning-loop"))
    skill_md = home / "SKILL.md"
    if not skill_md.is_file():
        raise SystemExit(f"SKILL.md not found at {skill_md} — run sync-learning-loop-skill.sh first")

    raw = skill_md.read_text(encoding="utf-8")
    body = FRONTMATTER_RE.sub("", raw, count=1).strip()
    body = patch_body(body)
    skill_md.write_text(FRONTMATTER + body + "\n", encoding="utf-8")
    print(f"Patched → {skill_md.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
