#!/usr/bin/env python3
"""Patch doubt-driven-development SKILL.md for jarvis-skills-library: frontmatter + JARVIS/Cursor overlay."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEST = ROOT / "skills" / "engineering" / "doubt-driven-development"
UPSTREAM = DEST / "SKILL.md.upstream"
SKILL_MD = DEST / "SKILL.md"
OVERLAY_MARKER = "## JARVIS / Cursor (mandatory)"

JARVIS_OVERLAY = """
## JARVIS / Cursor (mandatory)

- **Router:** `agent-skills-router`. Doc: [docs/AGENT_SKILLS_ADDY_INTEGRATION.md](../../docs/AGENT_SKILLS_ADDY_INTEGRATION.md)
- **Precedencia:** `jarvis-core` > esta skill. Complementa `code-review-playbook` (post-hoc) y TDD RED (doubt para claims conductuales).
- **Step 3 DOUBT (Cursor):** invocar **Task** desde la sesión principal con `readonly: true` y `subagent_type: code-reviewer` (o `generalPurpose`). Pegar el prompt adversarial verbatim. **No** anidar Task desde un subagent — si estás dentro de un subagent, escalar al usuario o sesión principal.
- **Personas upstream `agents/`:** en Cursor usar subagents: `code-reviewer`, `security-reviewer`, `test-runner` según dominio — no cargar `agents/*.md` del pack como globales.
- **Slash `/review`:** no existe en Cursor — usar `code-review-playbook` para review post-hoc.
- `upstream: addyosmani/agent-skills:doubt-driven-development`

### Subagents Cursor (sustituyen agents/ del pack)

| Dominio | subagent_type |
|---------|----------------|
| Código / lógica | `code-reviewer` |
| Seguridad / auth | `security-reviewer` |
| Tests / cobertura | `test-runner` |
| Genérico adversarial | `generalPurpose` (readonly) |

### IRON LAW JARVIS

- No sustituir `speckit-implement`, `session-learner-ops` ni `git-guardrails-ops`.
- Cross-model CLI (Gemini/Codex): **solo** con autorización explícita del usuario por invocación; stdin desde archivo temporal; sandbox read-only cuando exista.
- En contexto no interactivo: anunciar skip cross-model; no invocar CLI externo sin autorización.

"""

FRONTMATTER = """---
name: doubt-driven-development
description: >
  Revisión adversarial in-flight de decisiones no triviales: CLAIM → EXTRACT → DOUBT → RECONCILE → STOP.
  Trigger: doubt-driven, alta stakes, seguridad, irreversible, código unfamiliar, antes de commit crítico.
license: MIT
metadata:
  author: addyosmani (JARVIS patch)
  version: "1.0-jarvis"
  scope: [global]
  category: engineering
  upstream: addyosmani/agent-skills:doubt-driven-development
  auto_invoke:
    - "doubt-driven revisión adversarial"
    - "Alta stakes verificar antes de commit"
    - "Decisión no trivial seguridad producción"
  triggers: doubt-driven, revisión adversarial, CLAIM EXTRACT DOUBT
  related-skills:
    - agent-skills-router
    - jarvis-core
    - code-review-playbook
    - test-driven-development
    - systematic-debugging
    - security
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash, Task]
---

"""

BODY_REPLACEMENTS: list[tuple[str, str]] = [
    (
        "In Claude Code, the role-based reviewers in `agents/` start with isolated context by design and are usable here — see `agents/` for the roster and per-domain match.",
        "In Cursor, use Task with `readonly: true` and `subagent_type: code-reviewer` (or domain table in JARVIS overlay above). Do not use nested Task from inside a subagent.",
    ),
    (
        "**`/review`**. `/review` is a final gate.",
        "**`code-review-playbook`**. Post-hoc PR review is a final gate.",
    ),
    (
        "By PR time it's too late.",
        "By PR time it's too late (use `code-review-playbook` at merge gate).",
    ),
    (
        "- **`code-review-and-quality` / `/review`**: complementary.",
        "- **`code-review-playbook`**: complementary.",
    ),
    (
        "**Repo orchestration rules** (`references/orchestration-patterns.md`): this skill orchestrates from the main session. A persona calling another persona is anti-pattern B — see Loading Constraints above.",
        "**Orchestration (JARVIS):** main session only; subagents do not spawn subagents — see Loading Constraints and JARVIS overlay.",
    ),
]


def strip_frontmatter(text: str) -> str:
    if text.startswith("---"):
        m = re.match(r"^---\s*\n.*?\n---\s*\n", text, re.DOTALL)
        if m:
            return text[m.end():]
    return text


def main() -> None:
    if not UPSTREAM.is_file():
        raise SystemExit(f"Missing upstream: {UPSTREAM}. Run sync-addy-doubt-driven.sh first.")

    body = strip_frontmatter(UPSTREAM.read_text(encoding="utf-8"))
    for old, new in BODY_REPLACEMENTS:
        body = body.replace(old, new)

    if OVERLAY_MARKER not in body:
        body = JARVIS_OVERLAY.strip() + "\n\n" + body.lstrip()

    SKILL_MD.write_text(FRONTMATTER + body, encoding="utf-8")
    print(f"Patched → {SKILL_MD}")


if __name__ == "__main__":
    main()
