#!/usr/bin/env python3
"""Patch ECC curated skills for jarvis-skills-library: frontmatter + JARVIS overlay."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OVERLAY_MARKER = "## JARVIS Integration (mandatory)"

# upstream skill dir name -> (dest subdir under skills/ops, jarvis skill name)
CURATED: dict[str, tuple[str, str]] = {
    "continuous-learning-v2": ("continuous-learning-v2", "continuous-learning-v2"),
    "security-review": ("security-review-ecc", "security-review-ecc"),
    "configure-ecc": ("configure-ecc", "configure-ecc"),
}

DESCRIPTIONS: dict[str, str] = {
    "continuous-learning-v2": (
        "ECC instincts: continuous learning v2, evolve clusters into skills. "
        "Use with session-learner-ops at module close. Trigger: instincts, evolve, homunculus."
    ),
    "security-review-ecc": (
        "ECC OWASP security review checklist (complement to security skill). "
        "Trigger: security review ecc, OWASP scan checklist when ECC installed."
    ),
    "configure-ecc": (
        "ECC install wizard and harness configuration for Cursor. "
        "Trigger: configure ecc, install everything claude code."
    ),
}

OVERLAYS: dict[str, str] = {
    "continuous-learning-v2": """
## JARVIS Integration (mandatory)

- **Cierre de módulo canónico:** `session-learner-ops` → `docs/active_context.md` (siempre).
- **Instincts ECC:** opt-in con hooks (`install-ecc-runtime.sh --with-hooks`); usar esta skill para `/evolve` y confidence.
- Router: `ecc-router`. Install: `scripts/install-ecc-runtime.sh`.
- `upstream: ecc:continuous-learning-v2`
""",
    "security-review-ecc": """
## JARVIS Integration (mandatory)

- **Base OWASP:** skill global `security` primero; esta skill es checklist ECC complementaria.
- No reemplaza `security` ni AppSec review en PR (`code-review-playbook`).
- Router: `ecc-router`. `upstream: ecc:security-review`
""",
    "configure-ecc": """
## JARVIS Integration (mandatory)

- Preferir `bash scripts/install-ecc-runtime.sh --project-dir <repo>` (perfil `minimal` default).
- No apilar plugin Claude `ecc@ecc` + `install.sh --profile full`.
- Doc: [docs/ECC_INTEGRATION.md](../../docs/ECC_INTEGRATION.md)
- `upstream: ecc:configure-ecc`
""",
}

FRONTMATTER_RE = re.compile(r"^---\s*\n.*?\n---\s*\n", re.DOTALL)


def build_frontmatter(skill_name: str, upstream: str) -> str:
    desc = DESCRIPTIONS.get(skill_name, f"ECC curated skill ({upstream}).")
    triggers = skill_name.replace("-", " ")
    return f"""---
name: {skill_name}
description: >
  {desc}
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: ops
  upstream: ecc:{upstream}
  auto_invoke:
    - "ECC {upstream}"
  triggers: {triggers}, ecc
  related-skills:
    - ecc-router
    - ecc
    - jarvis-core
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

"""


def patch_skill(upstream_name: str, upstream_md: Path, dest_dir: Path, jarvis_name: str) -> None:
    raw = upstream_md.read_text(encoding="utf-8")
    body = FRONTMATTER_RE.sub("", raw, count=1).strip()
    overlay = OVERLAYS.get(jarvis_name, "")
    if OVERLAY_MARKER not in body and overlay.strip():
        body = body + "\n" + overlay.strip() + "\n"
    dest_dir.mkdir(parents=True, exist_ok=True)
    out = dest_dir / "SKILL.md"
    out.write_text(build_frontmatter(jarvis_name, upstream_name) + body + "\n", encoding="utf-8")
    print(f"Patched → {out.relative_to(ROOT)}")


def main() -> None:
  ecc_home = Path(__import__("os").environ.get("ECC_HOME", str(Path.home() / "ecc")))
  skills_src = ecc_home / "skills"
  if not skills_src.is_dir():
    raise SystemExit(f"ECC skills not found at {skills_src} — run sync-ecc-skills.sh first")

  for upstream_name, (dest_name, jarvis_name) in CURATED.items():
    upstream_md = skills_src / upstream_name / "SKILL.md"
    if not upstream_md.is_file():
      raise SystemExit(f"Missing upstream {upstream_md}")
    patch_skill(upstream_name, upstream_md, ROOT / "skills" / "ops" / dest_name, jarvis_name)

  print("patch-ecc-skills: OK")


if __name__ == "__main__":
  main()
