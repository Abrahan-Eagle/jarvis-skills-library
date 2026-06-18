---
name: jarvis-core
description: >
  Protocolo base del sistema JARVIS para cualquier proyecto. Define honestidad, foco de negocio y flujo de trabajo modular.
  Trigger: Al iniciar un nuevo feature, planificar desarrollo, terminar un módulo, o modificar el sistema en sí.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "2.0"
  scope: [global]
  auto_invoke:
    - "Iniciar módulo"
    - "Planificar desarrollo"
    - "Terminar módulo"
  triggers: jarvis, workflow, módulo, feature, plan, core
  related-skills:
    - jarvis-experts
    - sdd-router
    - kitty-router
    - openspec-router
    - sdd-x-index
    - ui-router
    - speckit-specify
    - speckit-plan
    - speckit-taskstoissues
    - code-review-playbook
    - git-commit
    - brainstorming-ops
    - task-pipeline-ops
    - verification-before-completion
    - session-learner-ops
    - writing-plans
    - executing-plans
    - using-git-worktrees
    - finishing-a-development-branch
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task]
---

# JARVIS Core System (global)

Skill global en `jarvis-skills-library` → `~/.cursor/skills/`. Skills de **dominio** del producto (`{producto}-*`) viven en `.agents/skills/` del repo activo.

Si el repo tiene `.kittify/`, ver `kitty-router` ([docs/SPEC_KITTY_INTEGRATION.md](../../docs/SPEC_KITTY_INTEGRATION.md)) — **no** `speckit-*`.

Si el repo tiene `openspec/` (sin otros marcadores SDD), ver `openspec-router` ([docs/AWESOME_SPEC_KITS.md](../../docs/AWESOME_SPEC_KITS.md)) — **no** `speckit-*`.

Si el repo tiene `.specify/` (sin `.kittify/` ni `openspec/`), ver `sdd-router` y cadena `speckit-*` ([docs/SDD_SPECKIT_INTEGRATION.md](../../docs/SDD_SPECKIT_INTEGRATION.md)).

Para UI/UX, ver `ui-router` ([docs/UI_UX_PRO_MAX_INTEGRATION.md](../../docs/UI_UX_PRO_MAX_INTEGRATION.md)).

Para SD-X (dev + diseño + docs + validate), ver `sdd-x-index` ([docs/SDX_ECOSYSTEM.md](../../docs/SDX_ECOSYSTEM.md)).

## Protocolo de calidad

| Skill | Cuándo |
|-------|--------|
| `deep-interview-ops` | Requisitos vagos (claridad ≥ 3.5/5) |
| `brainstorming-ops` | Antes de planificar/codificar módulo |
| `task-pipeline-ops` | Tareas >3 pasos |
| `verification-before-completion` | **Obligatorio** antes de "listo" |
| `structured-commits-ops` | Commits con decisiones de arquitectura |
| `session-learner-ops` | Cierre módulo → `docs/active_context.md` |
| `writing-plans` / `executing-plans` | Plan en `.agents/plans/` |
| `using-git-worktrees` | Worktrees aislados |
| `requesting-code-review` / `receiving-code-review` | Review pre-merge |
| `finishing-a-development-branch` | Cierre con tests del stack |

## Precedencia de skills

Cuando `AGENTS.md` lista varias skills para la misma acción, aplicar esta secuencia:

| Fase | Cadena |
|------|--------|
| Cualquier tarea no trivial | `jarvis-experts` → (resto según fase) |
| Nueva feature de producto (con `.kittify/`) | `kitty-router` → charter/specify/plan/tasks (Cursor) → `spec-kitty next` → review/accept/merge (OK usuario) |
| Nueva feature de producto (con `openspec/`) | `openspec-router` → `/opsx:propose` → `/opsx:apply` (OK usuario) → `/opsx:archive` |
| Nueva feature de producto (con `.specify/`) | `sdd-router` → `speckit-constitution` → `speckit-specify` → `speckit-clarify` (opc.) → `speckit-plan` → `speckit-tasks` → `speckit-taskstoissues` (opc.) → `speckit-analyze` → `speckit-implement` (OK usuario) → `speckit-converge` (opc.) |
| Requisitos ambiguos | `deep-interview-ops` → `brainstorming-ops` (sin Spec Kit) o `speckit-clarify` (con Spec Kit) |
| Iniciar módulo (sin `.specify/`) | `jarvis-core` → `brainstorming-ops` → `writing-plans` → `task-pipeline-ops` |
| Planificar desarrollo (sin `.specify/`) | `brainstorming-ops` → `writing-plans` → `executing-plans` |
| Implementar feature / bugfix | `test-driven-development` + skill dominio `{producto}-*` del repo |
| Bug o test fallido | `systematic-debugging` |
| Terminar módulo | `verification-before-completion` → `session-learner-ops` → `finishing-a-development-branch` |
| Crear commit | `verification-before-completion` → `git-commit` → `structured-commits-ops` |
| Push / merge | `git-guardrails-ops` (solo con orden explícita del usuario) |
| Code review | `code-review-playbook` (+ opcional requesting/receiving) |
| UI/UX, landing, a11y, layout | `ui-router` → skill dominio `{producto}-ui-design` / `zonix-web-design` → `ui-ux-pro-max` → `responsive-design` (opc.) |
| SD-X ambiguo / multi-arte (dev+UI+docs) | `sdd-x-index` → `sdd-router` o `ui-router` según tabla SD-X |

## Directivas principales

1. **Honestidad:** Si cometes un error o una petición no es óptima, dilo.
2. **Proactividad:** Mejoras de negocio, UX o arquitectura aplicables al flujo en curso.
3. **Memoria:** Consultar `AGENTS.md` y `docs/active_context.md` del proyecto.
4. **Panel de expertos:** Declarar `> Roles: <rol1> + <rol2>` en tareas no triviales. Ver `jarvis-experts`.

## Flujo modular obligatorio

### 0. Panel de expertos

Identificar roles y declarar en una línea antes de planificar.

### 1. Planificación

- No escribir código inmediatamente.
- Con `.kittify/`: seguir `kitty-router` y artefactos en `kitty-specs/`.
- Con `openspec/`: seguir `openspec-router` y artefactos en `openspec/changes/`.
- Con `.specify/`: seguir `sdd-router` y artefactos en `specs/`.
- Sin ninguno: crear `.agents/plans/implementation_plan.md` con propuesta y riesgos.
- Pedir validación al usuario.

### 2. Desarrollo

- Respetar convenciones del repo (ver `AGENTS.md`).
- Usar configuración central del proyecto (no URLs hardcodeadas).

### 3. Loop de feedback

- Preguntar si el usuario quiere revisar antes de cerrar.
- Iterar hasta luz verde.

### 4. Testing

- Ejecutar comandos de verificación del stack (ver `verification-before-completion`).
- Invocar `verification-before-completion` con evidencia fresca.

### 5. Documentación

- Preguntar si actualizar `AGENTS.md`, README, skills locales de dominio.
- Generar `.agents/plans/walkthrough.md` si cierra módulo.

### 6. Commit

- Solicitar autorización expresa. Nunca push/merge sin orden del usuario.
