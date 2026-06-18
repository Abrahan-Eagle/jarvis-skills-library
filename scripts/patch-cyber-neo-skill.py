#!/usr/bin/env python3
"""Patch cyber-neo SKILL.md for jarvis-skills-library: frontmatter + JARVIS/Cursor overlay."""

from __future__ import annotations

import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OVERLAY_MARKER = "## JARVIS / Cursor (mandatory)"

JARVIS_OVERLAY = """
## JARVIS / Cursor (mandatory)

- **No slash command:** En Cursor no existe `/cyber-neo`. Invocar skill `cyber-neo` o pedir "auditoría cyber-neo / security audit" del path del proyecto.
- **Subagentes:** Sustituir tool `Agent` por **Task** (`subagent_type: generalPurpose` o `explore`, `readonly: true`). Máximo 5 tareas paralelas para fases SCA/SAST/secrets/config/supply-chain.
- **Read-only:** No modificar el target; solo reporte MD (IRON LAW upstream).
- **Reporte alternativo:** Si el usuario pide, guardar en `{TARGET}/docs/security/cyber-neo-report-{YYYY-MM-DD}.md` en lugar de Desktop.
- **PHP/Laravel:** Sin `lang-php.md` en v0.1; usar recon `composer.json`, patrones genéricos, `cyber-neo lockfiles`, `security` para fixes Laravel.
- **Router:** `cyber-neo-router`. **CLI scripts:** `cyber-neo secrets|lockfiles`. Doc: [docs/CYBER_NEO_INTEGRATION.md](../../docs/CYBER_NEO_INTEGRATION.md)
- `upstream: cyber-neo:cyber-neo`
"""

FRONTMATTER_RE = re.compile(r"^---\s*\n.*?\n---\s*\n", re.DOTALL)

FRONTMATTER = """---
name: cyber-neo
description: >
  Auditoría de seguridad read-only: 11 dominios, OWASP 2025, CWE Top 25, reporte priorizado.
  Trigger: security audit, vulnerability scan, cyber-neo, pentest, auditoría seguridad, OWASP 2025 reporte.
license: MIT
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: ops
  upstream: cyber-neo:cyber-neo
  auto_invoke:
    - "Auditoría seguridad profunda read-only"
    - "Vulnerability scan reporte ejecutivo"
    - "cyber-neo OWASP 2025"
  triggers: security audit, vulnerability scan, cyber-neo, pentest, auditoría seguridad
  related-skills:
    - cyber-neo-router
    - security
    - security-review-ecc
    - jarvis-core
allowed-tools: [Read, Grep, Glob, Bash, Write]
---

"""


def patch_body(body: str) -> str:
    body = body.replace("tool `Agent`", "tool **Task** (Cursor)")
    body = re.sub(r"\bAgent tool\b", "Task tool (Cursor)", body)
    if OVERLAY_MARKER not in body:
        body = JARVIS_OVERLAY.strip() + "\n\n---\n\n" + body
    return body


def main() -> None:
    home = Path(os.environ.get("CYBER_NEO_HOME", ROOT / "skills" / "ops" / "cyber-neo"))
    skill_md = home / "SKILL.md"
    if not skill_md.is_file():
        raise SystemExit(f"SKILL.md not found at {skill_md} — run sync-cyber-neo-skill.sh first")

    raw = skill_md.read_text(encoding="utf-8")
    body = FRONTMATTER_RE.sub("", raw, count=1).strip()
    body = patch_body(body)
    skill_md.write_text(FRONTMATTER + body + "\n", encoding="utf-8")
    print(f"Patched → {skill_md.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
