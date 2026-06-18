#!/usr/bin/env python3
"""Patch speckit skill frontmatter and JARVIS overlays for jarvis-skills-library."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / "skills" / "sdd"

OVERLAY_MARKER = "## JARVIS Integration (mandatory)"

DESCRIPTIONS = {
    "speckit-constitution": (
        "Crea o actualiza la constitution del proyecto (.specify/memory/constitution.md). "
        "Trigger: Iniciar SDD, /speckit-constitution, principios de gobierno."
    ),
    "speckit-specify": (
        "Define qué construir (requisitos y user stories) antes del stack técnico. "
        "Trigger: Nueva feature de producto, /speckit-specify, spec-driven development."
    ),
    "speckit-clarify": (
        "Clarifica requisitos ambiguos en spec.md antes de planificar. "
        "Trigger: Antes de speckit-plan, spec incompleto, /speckit-clarify."
    ),
    "speckit-plan": (
        "Genera plan técnico (plan.md) con stack y arquitectura elegida. "
        "Trigger: Tras spec aprobado, /speckit-plan."
    ),
    "speckit-tasks": (
        "Descompone plan.md en tasks.md accionables con dependencias. "
        "Trigger: Tras speckit-plan, /speckit-tasks."
    ),
    "speckit-analyze": (
        "Análisis de coherencia cross-artifact entre spec, plan y tasks. "
        "Trigger: Tras speckit-tasks, antes de implement, /speckit-analyze."
    ),
    "speckit-implement": (
        "Ejecuta tasks.md según el plan. Solo con OK explícito del usuario. "
        "Trigger: /speckit-implement tras analyze."
    ),
    "speckit-checklist": (
        "Genera checklists de calidad para validar requisitos (unit tests for English). "
        "Trigger: Validar spec o plan, /speckit-checklist."
    ),
    "speckit-converge": (
        "Compara código con spec/plan/tasks y añade tareas de remediación a tasks.md. "
        "Trigger: Tras speckit-implement, gaps brownfield, /speckit-converge."
    ),
    "speckit-taskstoissues": (
        "Convierte tasks.md en issues GitHub para tracking. Solo con OK usuario y remote GitHub. "
        "Trigger: /speckit-taskstoissues tras speckit-tasks."
    ),
}

AUTO_INVOKE = {
    "speckit-constitution": ["Establecer principios SDD en proyecto"],
    "speckit-specify": ["Nueva feature de producto con Spec Kit"],
    "speckit-clarify": ["Requisitos ambiguos antes de plan SDD"],
    "speckit-plan": ["Plan técnico Spec Kit"],
    "speckit-tasks": ["Descomponer plan Spec Kit en tareas"],
    "speckit-analyze": ["Análisis coherencia Spec Kit pre-implement"],
    "speckit-implement": ["Implementar feature Spec Kit con OK usuario"],
    "speckit-checklist": ["Checklist calidad spec/plan Spec Kit"],
    "speckit-converge": ["Cerrar gaps post-implement Spec Kit"],
    "speckit-taskstoissues": ["Convertir tasks Spec Kit a issues GitHub"],
}

TEMPLATE_MAP = {
    "speckit-constitution": "constitution.md",
    "speckit-specify": "specify.md",
    "speckit-clarify": "clarify.md",
    "speckit-plan": "plan.md",
    "speckit-tasks": "tasks.md",
    "speckit-analyze": "analyze.md",
    "speckit-implement": "implement.md",
    "speckit-checklist": "checklist.md",
    "speckit-converge": "converge.md",
    "speckit-taskstoissues": "taskstoissues.md",
}

JARVIS_OVERLAYS: dict[str, str] = {
    "speckit-plan": """
## JARVIS Integration (mandatory)

- For dual-repo products, use path prefixes in `plan.md` (e.g. `backend:`, `front:`) per product convention.
- Invoke domain architecture skills from the active repo (`corralx-*`, `zonix-*`, etc.) alongside this skill.
- Do not plan investor packs, marketing-only docs, or financial figures under Spec Kit.
- If `plan.md` includes screens, landing, or UI work: note invocation of `ui-router` and domain UI skills in the plan; see [docs/SDX_ECOSYSTEM.md](../../docs/SDX_ECOSYSTEM.md).
""",
    "speckit-implement": """
## JARVIS Integration (mandatory)

- **STOP** before any code change unless the user gave **explicit OK** to implement (not implied by prior planning).
- Invoke **domain skills** from the active product repo (`AGENTS.md`, `.agents/skills/{producto}-*`).
- UI tasks: invoke `ui-router` + domain UI skills + `test-driven-development`; pre-delivery visual check via `ui-ux-pro-max` checklist.
- Follow `test-driven-development` for code tasks when the repo uses TDD.
- On completion: `verification-before-completion` (tests, analyze, checklist gates).
- Commits: `git-commit` + `structured-commits-ops`. Push/merge: `git-guardrails-ops` (only with user order).
""",
    "speckit-specify": """
## JARVIS Integration (mandatory)

- Treat `.specify/memory/constitution.md` as governing constraints for all requirements.
- Product features only — **do not** use Spec Kit for investor packs, marketing collateral, or financial docs.
- If requirements are ambiguous, run `speckit-clarify` before `speckit-plan`.
""",
    "speckit-taskstoissues": """
## JARVIS Integration (mandatory)

- **STOP** unless the user explicitly requested GitHub issue tracking for this feature.
- Verify `git remote` is a GitHub URL before creating any issue; never create issues in the wrong repo.
- Without GitHub MCP: offer `gh issue create` per task or a numbered list for manual creation.
- Does **not** replace `speckit-implement`; alternative execution path via issues after `speckit-tasks`.
""",
    "speckit-analyze": """
## JARVIS Integration (mandatory)

- Run **before** `speckit-implement`; do not skip when tasks touch multiple repos or security-sensitive areas.
- Resolve CRITICAL/HIGH findings in-session or loop back to `speckit-clarify` / `speckit-plan` before implement.
- SD-Validate: cross-check spec/plan/tasks coherence **and** checklist gates (`speckit-checklist`); see `sdd-x-index`.
- Does not replace `verification-before-completion` (that gate applies after code exists).
""",
    "speckit-clarify": """
## JARVIS Integration (mandatory)

- Cap clarifying questions (max 5 per round); prefer structured options over open-ended lists.
- Without `.specify/`, use `deep-interview-ops` instead of this skill.
- Record answers in `spec.md` Clarifications section — do not proceed to plan with unresolved MUST items.
""",
    "speckit-converge": """
## JARVIS Integration (mandatory)

- Append-only on `tasks.md`; never rewrite spec/plan without user approval.
- A second `speckit-implement` pass after convergence requires **explicit OK** from the user.
- Invoke domain skills from the active repo for remediation tasks (same as implement).
""",
    "speckit-tasks": """
## JARVIS Integration (mandatory)

- Dual-repo: prefix file paths in tasks (`backend:`, `front:`) per product convention.
- If plan mandates TDD, order test tasks before implementation tasks in each phase.
- Tasks must be verifiable — each task should state how to confirm completion (test, API call, UI check).
""",
}

FRONTMATTER_RE = re.compile(r"^---\s*\n.*?\n---\s*\n", re.DOTALL)
H1_RE = re.compile(r"^#\s+", re.MULTILINE)


def build_frontmatter(name: str) -> str:
    desc = DESCRIPTIONS[name]
    tpl = TEMPLATE_MAP[name]
    invokes = AUTO_INVOKE.get(name, [])
    invoke_block = "\n".join(f"    - \"{i}\"" for i in invokes)
    return f"""---
name: {name}
description: >
  {desc}
license: MIT
compatibility: Requires .specify/ directory (run specify init in product repo)
metadata:
  author: github-spec-kit
  version: "0.11.2"
  upstream: github/spec-kit:templates/commands/{tpl}
  category: sdd
  auto_invoke:
{invoke_block}
---

"""


def ensure_h1(name: str, body: str) -> str:
    """Add # speckit-{cmd} H1 if body starts with ## without a prior H1."""
    stripped = body.lstrip("\n")
    if stripped.startswith("# "):
        return body
    if stripped.startswith("## "):
        return f"# {name}\n\n{stripped}"
    return f"# {name}\n\n{body}"


def strip_overlay(body: str) -> str:
    """Remove existing JARVIS overlay section before re-appending."""
    idx = body.find(OVERLAY_MARKER)
    if idx == -1:
        return body.rstrip() + "\n"
    return body[:idx].rstrip() + "\n"


def apply_overlay(name: str, body: str) -> str:
    overlay = JARVIS_OVERLAYS.get(name)
    if not overlay:
        return body
    body = strip_overlay(body)
    return body.rstrip() + "\n\n" + overlay.lstrip("\n")


def patch_skill(skill_dir: Path) -> None:
    name = skill_dir.name
    skill_md = skill_dir / "SKILL.md"
    if not skill_md.exists():
        return
    if name not in DESCRIPTIONS:
        print(f"SKIP {name}: not in DESCRIPTIONS")
        return
    body = skill_md.read_text(encoding="utf-8")
    m = FRONTMATTER_RE.match(body)
    if not m:
        print(f"SKIP {name}: no frontmatter")
        return
    rest = body[m.end():].lstrip("\n")
    rest = ensure_h1(name, rest)
    rest = apply_overlay(name, rest)
    skill_md.write_text(build_frontmatter(name) + rest, encoding="utf-8")
    print(f"Patched {name}")


def main() -> None:
    for d in sorted(ROOT.iterdir()):
        if d.is_dir():
            patch_skill(d)


if __name__ == "__main__":
    main()
