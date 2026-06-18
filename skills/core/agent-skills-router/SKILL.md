---
name: agent-skills-router
description: >
  Orquesta pack addyosmani/agent-skills vs canónico JARVIS y doubt-driven-development.
  Trigger: doubt-driven, revisión adversarial, alta stakes, pack Addy agent-skills.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: core
  auto_invoke:
    - "doubt-driven revisión adversarial"
    - "Pack Addy agent-skills lifecycle"
    - "Decisión alta stakes antes de commit"
  triggers: doubt-driven, agent-skills, addyosmani, revisión adversarial in-flight
  related-skills:
    - jarvis-core
    - doubt-driven-development
    - code-review-playbook
    - test-driven-development
    - systematic-debugging
    - security
    - sdd-router
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash, Task]
---

# Agent Skills Router (Addy Osmani)

Router para [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (MIT): ciclo DEFINE→SHIP **sin** sustituir `jarvis-core`, `speckit-*` ni skills globales duplicadas.

Guía: [docs/AGENT_SKILLS_ADDY_INTEGRATION.md](../../docs/AGENT_SKILLS_ADDY_INTEGRATION.md).

## IRON LAW

1. **`jarvis-core` precede** — este router no inicia módulos ni commits sin el flujo JARVIS.
2. **No sustituir** `session-learner-ops`, `speckit-implement` (sin OK usuario), ni `git-guardrails-ops`.
3. **Solo una skill curada** en la library: `doubt-driven-development`. Las otras 23 del pack → canónico JARVIS o pack externo opcional.
4. **Supply-chain:** antes de copiar skills del pack a un repo, `skill-security-auditor` + `validate-skills.sh` en origen. Pack Rezvani: `claude-skills-router`.

## Detección runtime

```bash
test -f "${HOME}/.cursor/skills/doubt-driven-development/SKILL.md" && echo DOUBT_DRIVEN_INSTALLED
test -f skills/engineering/doubt-driven-development/SKILL.md && echo DOUBT_DRIVEN_LIBRARY
test -f "${HOME}/.cursor/skills/agent-skills-router/SKILL.md" && echo AGENT_SKILLS_ROUTER_INSTALLED
```

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| Iniciar módulo / planificar | `jarvis-core` → `brainstorming-ops` / `sdd-router` / `kitty-router` | pack Addy `/spec` / `spec-driven-development` |
| Spec / PRD (repo con `.specify/`) | `sdd-router` → `speckit-specify` | `spec-driven-development` Addy |
| Implementar / bugfix | `test-driven-development` + dominio `{producto}-*` | `incremental-implementation` Addy |
| Test fallido / debug | `systematic-debugging` | `debugging-and-error-recovery` Addy |
| Review pre-merge | `code-review-playbook` | `code-review-and-quality` Addy |
| Seguridad / hardening checklist | `security` (+ `security-review-ecc` si harness) | `security-and-hardening` Addy |
| UI en código | `ui-router` → dominio UI | `frontend-ui-engineering` Addy |
| Commit / push | `git-commit` / `git-guardrails-ops` | `git-workflow-and-versioning` Addy |
| **Decisión no trivial alta stakes** (auth, prod, irreversible, código unfamiliar) | **`doubt-driven-development`** (opcional, in-flight) | solo `/review` post-hoc |
| Skill Addy sin equivalente JARVIS y sin curar | Pack externo o [upstream skills/](https://github.com/addyosmani/agent-skills/tree/main/skills) tras auditar | sync masivo a library |

**vs code-review:** `code-review-playbook` es veredicto post-hoc en PR; `doubt-driven-development` es revisión adversarial **en vuelo** antes de que la decisión quede fija.

**vs TDD:** RED de TDD satisface doubt para claims conductuales; doubt-driven cubre invariantes no verificables por tipos (thread-safety, ordering, blast radius).

## Flujo doubt-driven (Cursor)

1. Usuario pide duda adversarial o el agente detecta decisión no trivial (ver skill).
2. Cargar skill `doubt-driven-development`.
3. Ciclo CLAIM → EXTRACT → DOUBT (Task `readonly: true`, subagent `code-reviewer`) → RECONCILE → STOP.
4. **No** anidar Task desde subagent; main session orquesta.
5. Cross-model CLI solo con autorización explícita del usuario (ver skill).

## Pack externo (opcional)

Para skills no curadas (performance, CI/CD, ADRs, observability):

- Claude Code: `/plugin marketplace add addyosmani/agent-skills`
- Cursor: ver [docs/cursor-setup.md](https://github.com/addyosmani/agent-skills/blob/main/docs/cursor-setup.md) — preferir **no** duplicar en `.cursor/rules/` si ya usas `install.sh` global.

**vs `claude-skills-router`:** otro megapack (Rezvani, 345+ skills). Addy = DEFINE→SHIP + doubt; Rezvani = multi-dominio + **`skill-security-auditor`** pre-install. Ambos exigen supply-chain antes de copiar skills de terceros.

## Limitaciones

- Sin slash commands Addy (`/spec`, `/build`, `/review`) en Cursor — usar `speckit-*` y skills JARVIS.
- Personas `agents/` del pack no se instalan globalmente; usar subagents Cursor (`code-reviewer`, `security-reviewer`, etc.).
