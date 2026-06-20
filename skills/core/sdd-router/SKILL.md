---
name: sdd-router
description: >
  Decide entre flujo Spec Kit (speckit-*) y flujo JARVIS (.agents/plans/) según el repo activo.
  Trigger: Nueva feature de producto, spec-driven development, ambigüedad de workflow.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: core
  auto_invoke:
    - "Nueva feature de producto"
    - "Spec-driven development"
    - "Decidir flujo planificación"
  triggers: sdd, spec-kit, speckit, specify, specs
  related-skills:
    - jarvis-core
    - kitty-router
    - openspec-router
    - speckit-lifecycle-router
    - sdd-x-index
    - speckit-specify
    - speckit-plan
    - speckit-clarify
    - speckit-taskstoissues
    - brainstorming-ops
    - writing-plans
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# SDD Router — JARVIS vs Spec Kit

Router de **proceso**, no de dominio. Skills `{producto}-*` siguen en el repo del producto.

Repo **sin** `AGENTS.md` ni marcadores SDD (`.specify/`, `.kittify/`, `openspec/`): invocar `project-bootstrap-ops` ([PROJECT_ONBOARDING.md](../../docs/PROJECT_ONBOARDING.md)) antes de elegir flujo.

## Detección (repo activo)

```bash
test -d .kittify && echo "HAS_SPEC_KITTY"
test -d openspec && echo "HAS_OPENSPEC"
test -d .specify && echo "HAS_SPEC_KIT"
test -d .agents/plans && echo "HAS_JARVIS_PLANS"
test -d specs && echo "HAS_SPECS_DIR"
```

| Condición | Flujo |
|-----------|--------|
| `.kittify/` existe | **`kitty-router`** — no usar `speckit-*` |
| `openspec/` existe (sin otros marcadores SDD) | **`openspec-router`** — no usar `speckit-*` |
| `.specify/` + feature de **producto** (nueva) | **Spec Kit** — `speckit-specify` (tabla abajo) |
| `.specify/` + bugfix / hotfix / refactor / modify / deprecate | **`speckit-lifecycle-router`** |
| Sin marcador SDD o bugfix puntual | **JARVIS** (`brainstorming-ops` → `writing-plans` → `executing-plans`) |
| Dos o más entre `.kittify/`, `openspec/`, `.specify/` | **STOP** — usuario elige canónico |
| Ambos (ej. CorralX `.agents/plans/` + Zonix `specs/`) | SDD para features nuevas; JARVIS para mantenimiento |

## Ciclo de vida (no feature nueva)

Con `.specify/` y trabajo distinto de feature nueva, invocar **`speckit-lifecycle-router`**:

| Tipo | No usar |
|------|---------|
| Bug, regresión | `speckit-specify` |
| Hotfix prod | `speckit-specify` |
| Refactor | `speckit-specify` |
| Modificar feature `NNN` | `speckit-specify` (usar modify) |
| Deprecar feature | `speckit-specify` |

Guía: [docs/SPEC_KIT_EXTENSIONS.md](../docs/SPEC_KIT_EXTENSIONS.md).

## Cadena Spec Kit — feature nueva (orden)

1. `speckit-constitution` — si constitution vacía o desactualizada
2. `speckit-specify` — `specs/.../spec.md`
3. `speckit-clarify` — **antes** de plan si hay ambigüedad
4. `speckit-plan` — `plan.md`
5. `speckit-tasks` — `tasks.md`
6. `speckit-taskstoissues` — **opcional**: issues GitHub (solo con OK usuario + remote GitHub)
7. `speckit-analyze` — coherencia pre-implement
8. `speckit-implement` — **solo con OK explícito del usuario**
9. `speckit-converge` — opcional, brownfield: gaps spec/código → append en `tasks.md`

Opcional en cualquier fase pre-implement: `speckit-checklist`.

| Skill | Uso |
|-------|-----|
| `speckit-taskstoissues` | Tracking en GitHub Issues (alternativa a implement directo) |
| `speckit-converge` | Cerrar gaps tras implement en proyectos brownfield |

## Gates JARVIS (siempre)

- `verification-before-completion` antes de declarar "listo"
- `git-commit` + `structured-commits-ops` al commitear
- `git-guardrails-ops` en push/merge (solo con orden del usuario)

## Cuándo NO usar Spec Kit

- Pack inversor, docs marketing, cifras financieras
- Bugfix puntual sin `.specify/` (usar `systematic-debugging`)
- Repos sin `specify init` y sin necesidad de `specs/`

## Bootstrap Spec Kit en un producto

Ver [docs/SDD_SPECKIT_INTEGRATION.md](../docs/SDD_SPECKIT_INTEGRATION.md).

Repos con Spec Kitty: [docs/SPEC_KITTY_INTEGRATION.md](../docs/SPEC_KITTY_INTEGRATION.md) + `kitty-router`.

Repos con OpenSpec: [docs/AWESOME_SPEC_KITS.md](../docs/AWESOME_SPEC_KITS.md) + `openspec-router`.

## SD-X más amplio

Si la tarea mezcla **desarrollo + diseño + docs** o no está claro qué rama SD-X aplicar, invocar **`sdd-x-index`** primero.

| Durante Spec Kit | Ramificación |
|------------------|--------------|
| `speckit-plan` con pantallas/landing/UI | Anotar en `plan.md`; invocar `ui-router` al implementar |
| `speckit-implement` con tareas UI | `ui-router` + dominio UI + TDD |
| Cierre de feature (AGENTS, walkthrough) | `documentar-avances`, `context-updater` — no Spec Kit |

Ver [docs/SDX_ECOSYSTEM.md](../../docs/SDX_ECOSYSTEM.md).

## Equivalencias

| JARVIS | Spec Kit |
|--------|----------|
| `deep-interview-ops` | `speckit-clarify` |
| `writing-plans` | `speckit-plan` |
| `task-pipeline-ops` + `executing-plans` | `speckit-tasks` + `speckit-implement` |
