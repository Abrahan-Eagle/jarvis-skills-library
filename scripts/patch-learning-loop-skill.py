#!/usr/bin/env python3
"""Patch learning-loop SKILL.md for jarvis-skills-library: frontmatter + JARVIS/Cursor overlay + body v2."""

from __future__ import annotations

import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OVERLAY_MARKER = "## JARVIS / Cursor (mandatory)"
IRON_LAW_MARKER = "### IRON LAW JARVIS"
LEARNING_HOME = "~/.cursor/learning-captures"

JARVIS_OVERLAY = f"""
## JARVIS / Cursor (mandatory)

- **No slash command:** En Cursor no existe `/learning-loop`. Invocar skill `learning-loop` y que el usuario indique **scan** o **wrap up** (o contexto: "contexto largo", "cerrar sesión", "consolidar").
- **LEARNING_LOOP_HOME:** `{LEARNING_HOME}` (override: `$LEARNING_LOOP_HOME`). Sustituye la ruta runtime de Claude Code del upstream.
- **Sub-agentes:** Cursor **Task** (`subagent_type: generalPurpose`, `readonly: true`). STOP rules upstream (scan/consolidation en main thread = error). No tool `Skill` de Claude Code.
- **Router:** `learning-loop-router`. Doc: [docs/LEARNING_LOOP_INTEGRATION.md](../../docs/LEARNING_LOOP_INTEGRATION.md)
- **Cierre módulo canónico:** Siempre `session-learner-ops` → `docs/active_context.md` primero; learning-loop wrap-up es **complemento opcional**, no sustituto.
- `upstream: learning-loop-skill:learning-loop`

### Destinos JARVIS (sustituyen destinos Claude Code en repos producto)

| Tipo upstream | Destino JARVIS |
|---------------|----------------|
| Process behavioral (global) | `~/.cursor/skills/` o reglas globales — **solo con OK usuario** |
| Process behavioral (proyecto) | `AGENTS.md` / `.cursorrules` (trigger corto; protocolo en `docs/` o `.agents/`) |
| Process operational | `docs/` playbooks o sección AGENTS |
| Facts / sesión | `docs/active_context.md` (`context-updater` / `session-learner-ops`) |
| Cierre módulo / patrones UI | `.agents/plans/walkthrough.md` |
| Code-level fix | walkthrough + `documentar-avances` — **no** compound Every |
| Watch-list / graduation | `{LEARNING_HOME}/watch-list.md`, `graduation-log.md` |
| Content wedge / personal context | **No rutear** en repos producto JARVIS |
| Skills-level | `jarvis-skills-library` si la sesión tocó skills |
| Auto-memory Claude | `docs/active_context.md` del repo activo |

Referencias a content wedge positioning → N/A repos producto JARVIS.

### IRON LAW JARVIS

En repos producto JARVIS, **nunca** escribir en archivos legacy `CLAUDE.md` de Claude Code, `MEMORY.md` global, content ledger personal ni invocar compound Every. Usar la tabla **Destinos JARVIS** arriba. Si el body upstream menciona destinos Claude Code, interpretar el equivalente JARVIS (`AGENTS.md`, `.cursorrules`, `docs/active_context.md`, walkthrough).
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
  version: "4.1-jarvis2"
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

# Order matters: specific patterns before broad CLAUDE.md
BODY_REPLACEMENTS: list[tuple[str, str]] = [
    ("root CLAUDE.md", "AGENTS.md global (~/.cursor/skills o jarvis-skills-library)"),
    ("Root CLAUDE.md", "AGENTS.md global (~/.cursor/skills o jarvis-skills-library)"),
    ("project CLAUDE.md", "AGENTS.md / `.cursorrules` del repo activo"),
    ("Project CLAUDE.md", "AGENTS.md / `.cursorrules` del repo activo"),
    ("~/.claude/reference/", "docs/ del repo o `.agents/`"),
    ("~/.claude/settings.json", "Cursor hooks opcional (no instalado por defecto)"),
    ("positioning/content_wedges_v2.md", "[JARVIS: N/A producto]"),
    ("PERSONAL_CONTEXT.md", "[JARVIS: no rutear]"),
    ("Judgment Ledger", "[JARVIS: no rutear — nota en active_context si aplica]"),
    ("/ce:compound", "documentar-avances + walkthrough"),
    ("MEMORY.md", "docs/active_context.md"),
    ("CLAUDE.md", "AGENTS.md / `.cursorrules`"),
    ("~/.claude/learning-captures", LEARNING_HOME),
    ("$HOME/.claude/learning-captures", LEARNING_HOME.replace("~", "$HOME")),
]


def strip_overlay(body: str) -> str:
    """Remove existing JARVIS overlay block if present."""
    if OVERLAY_MARKER not in body:
        return body
    start = body.index(OVERLAY_MARKER)
    # Overlay ends at --- before upstream title or at # learning-loop
    rest = body[start:]
    for sep in ("\n---\n\n# learning-loop", "\n---\n\n# Learning"):
        if sep in rest:
            end = start + rest.index(sep) + len("\n---\n\n")
            return body[:start] + body[end:]
    return body


def patch_body(body: str) -> str:
    body = strip_overlay(body).lstrip()

    # Split: overlay untouched; replacements only on upstream body
    overlay = JARVIS_OVERLAY.strip() + "\n\n---\n\n"
    upstream = body

    for old, new in BODY_REPLACEMENTS:
        upstream = upstream.replace(old, new)

    upstream = re.sub(r"\bTask agent\b", "Task subagent (Cursor)", upstream)
    upstream = upstream.replace("tool `Agent`", "tool **Task** (Cursor)")
    upstream = re.sub(r"\bAgent tool\b", "Task tool (Cursor)", upstream)

    if "for f in ~/.claude/projects/*/memory/*.md; do" in upstream:
        upstream = upstream.replace(
            "for f in ~/.claude/projects/*/memory/*.md; do",
            "for f in docs/active_context.md .agents/plans/walkthrough.md; do",
            1,
        )

    return overlay + upstream


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
