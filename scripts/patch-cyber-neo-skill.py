#!/usr/bin/env python3
"""Patch cyber-neo SKILL.md for jarvis-skills-library: frontmatter + JARVIS/Cursor overlay."""

from __future__ import annotations

import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OVERLAY_MARKER = "## JARVIS / Cursor (mandatory)"
SKILL_DIR_HINT = "~/.cursor/skills/cyber-neo (after install.sh --all)"

JARVIS_OVERLAY = f"""
## JARVIS / Cursor (mandatory)

- **No slash command:** En Cursor no existe `/cyber-neo`. Invocar skill `cyber-neo` o pedir "auditoría cyber-neo / security audit" con el **path del proyecto en el mensaje del usuario** (no `$ARGUMENTS`).
- **CYBER_NEO_SKILL_DIR:** Directorio del skill instalado, típico `{SKILL_DIR_HINT}`. Usar `Read`/`Glob` en `references/` y scripts con path absoluto a ese directorio (sustituye `${{CLAUDE_SKILL_DIR}}` de Claude Code).
- **Subagentes:** Usar tool **Task** (`subagent_type: generalPurpose` o `explore`, `readonly: true`). Máximo 5 tareas paralelas para fases SCA/SAST/secrets/config/supply-chain.
- **Read-only:** No modificar el target; solo reporte MD (IRON LAW upstream).
- **Reporte alternativo:** Si el usuario pide, guardar en `{{TARGET}}/docs/security/cyber-neo-report-{{YYYY-MM-DD}}.md` en lugar de Desktop.
- **PHP/Laravel SCA:** Si `composer.json` existe y `composer` está en PATH → `cd {{TARGET}} && composer audit --format=json` (read-only). Sin `lang-php.md` en v0.1; fixes con `security` + `laravel-specialist`; ECC `laravel-security` si harness instalado.
- **Flutter/Dart:** Sin referencia upstream; aplicar secretos, CI/CD, patrones SAST genéricos en `lib/`.
- **Router:** `cyber-neo-router`. **CLI:** `cyber-neo-cli/bin/cyber-neo` (`secrets`, `lockfiles`, `status`). Doc: [docs/CYBER_NEO_INTEGRATION.md](../../docs/CYBER_NEO_INTEGRATION.md)
- `upstream: cyber-neo:cyber-neo`
"""

COMPOSER_SCA_BLOCK = """
> 7. If composer.json exists and `composer` is available:
>    `cd {TARGET_DIR} && composer audit --format=json 2>/dev/null`
>    (read-only — does NOT modify vendor or lock files)
>
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
  version: "1.1"
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
    body = body.replace("${CLAUDE_SKILL_DIR}", "CYBER_NEO_SKILL_DIR")
    body = body.replace(
        "If `$ARGUMENTS` contains a path, use it as the target project root",
        "If the user message contains a project path, use it as the target project root",
    )
    body = body.replace(
        "If `$ARGUMENTS` is empty, ask the user:",
        "If no path was given in the user message, ask the user:",
    )
    if "composer audit" not in body and "If cargo-audit is available" in body:
        body = body.replace(
            "If cargo-audit is available and Cargo.lock exists:",
            "If cargo-audit is available and Cargo.lock exists:" + COMPOSER_SCA_BLOCK,
            1,
        )
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
