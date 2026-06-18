#!/usr/bin/env python3
"""Patch skill-security-auditor SKILL.md for jarvis-skills-library: frontmatter + JARVIS overlay."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEST = ROOT / "skills" / "ops" / "skill-security-auditor"
UPSTREAM = DEST / "SKILL.md.upstream"
SKILL_MD = DEST / "SKILL.md"
OVERLAY_MARKER = "## JARVIS (mandatory)"

JARVIS_OVERLAY = """
## JARVIS (mandatory)

- **Router:** `claude-skills-router`. Doc: [docs/CLAUDE_SKILLS_REZVANI_INTEGRATION.md](../../docs/CLAUDE_SKILLS_REZVANI_INTEGRATION.md)
- **Precedencia:** `jarvis-core` > esta skill. Complementa `security` (app/API) y `validate-skills.sh` (net-exec en library).
- **CLI local:** `python3 skills/ops/skill-security-auditor/scripts/skill_security_auditor.py <path> [--strict] [--json]`
- **Mantenedor:** tras sync upstream, ejecutar smoke + `validate-all.sh`.
- `upstream: alirezarezvani/claude-skills:skill-security-auditor`

### IRON LAW JARVIS

- **FAIL** del auditor → no instalar la skill en `~/.cursor/skills` ni en `.agents/skills/` de producto.
- Combinar con `bash scripts/validate-skills.sh --check-net-exec` en SKILL.md de destino.
- No sustituir `cyber-neo-router` (auditoría repo read-only OWASP) — este skill audita **paquetes skill**.

"""

FRONTMATTER = """---
name: skill-security-auditor
description: >
  Auditoría de seguridad pre-instalación de agent skills: PASS/WARN/FAIL, prompt injection, supply chain.
  Trigger: auditar skill, is this skill safe, scan skill before install.
license: MIT
metadata:
  author: alirezarezvani (JARVIS patch)
  version: "1.0-jarvis"
  scope: [global]
  category: ops
  upstream: alirezarezvani/claude-skills:skill-security-auditor
  auto_invoke:
    - "Auditar skill antes de instalar"
    - "¿Es segura esta skill?"
    - "skill security check pre-install"
  triggers: skill security audit, audit skill, scan skill, PASS WARN FAIL
  related-skills:
    - claude-skills-router
    - jarvis-core
    - security
    - jarvis-skills-maintainer
    - agent-skills-router
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

"""


def strip_frontmatter(text: str) -> str:
    if text.startswith("---"):
        m = re.match(r"^---\s*\n.*?\n---\s*\n", text, re.DOTALL)
        if m:
            return text[m.end():]
    return text


def main() -> None:
    if not UPSTREAM.is_file():
        raise SystemExit(f"Missing upstream: {UPSTREAM}. Run sync-claude-skills-skill-security-auditor.sh first.")

    body = strip_frontmatter(UPSTREAM.read_text(encoding="utf-8"))

    if OVERLAY_MARKER not in body:
        body = JARVIS_OVERLAY.strip() + "\n\n" + body.lstrip()

    SKILL_MD.write_text(FRONTMATTER + body, encoding="utf-8")
    print(f"Patched → {SKILL_MD}")


if __name__ == "__main__":
    main()
