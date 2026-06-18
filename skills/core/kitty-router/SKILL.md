---
name: kitty-router
description: >
  Orquesta flujo Spec Kitty (misiones, work packages, review/accept/merge) cuando existe .kittify/.
  Trigger: spec-kitty, kitty-specs, misiones SDD, kanban, worktrees paralelos.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: core
  auto_invoke:
    - "Spec Kitty o spec-kitty"
    - "Misión spec-driven con review y merge"
    - "Work packages o kanban SDD"
  triggers: spec-kitty, kittify, kitty-specs, mission, worktree kanban
  related-skills:
    - sdd-router
    - sdd-x-index
    - kitty-governance
    - using-git-worktrees
    - jarvis-core
    - finishing-a-development-branch
    - ui-router
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# Kitty Router — Spec Kitty en JARVIS

Router para repos con **Spec Kitty** ([Priivacy-ai/spec-kitty](https://github.com/Priivacy-ai/spec-kitty)). Complementa (no reemplaza) GitHub Spec Kit.

Guía: [docs/SPEC_KITTY_INTEGRATION.md](../../docs/SPEC_KITTY_INTEGRATION.md).

## Detección (repo activo)

```bash
test -d .kittify && echo KITTY
test -d kitty-specs && echo KITTY_SPECS
test -d .specify && echo SPEC_KIT
```

| Condición | Router |
|-----------|--------|
| Solo `.kittify/` (o `kitty-specs/`) | **kitty-router** (esta skill) |
| Solo `.specify/` | `sdd-router` → `speckit-*` — **no** Spec Kitty |
| Ambos `.kittify/` y `.specify/` | **STOP** — preguntar al usuario cuál es canónico; no mezclar misiones |
| Ninguno | `sdd-x-index` o JARVIS plans (`writing-plans`) |

## Cadena Spec Kitty (orden)

1. `spec-kitty verify-setup`
2. Slash en Cursor (instalados por `spec-kitty init --ai cursor`):
   - `/spec-kitty.charter`
   - `/spec-kitty.specify` → `/spec-kitty.plan` → `/spec-kitty.tasks`
3. Runtime: `spec-kitty next --agent cursor --mission <slug>`
4. Gates humanos: `/spec-kitty.review` → `/spec-kitty.accept` → `/spec-kitty.merge` (OK usuario para push)
5. Cierre: `/spec-kitty-mission-review`; opcional `spec-kitty retrospect summary`
6. Trabajo aislado fuera de misión: `kitty-governance` (`spec-kitty dispatch`)

## Paralelismo y worktrees

- Spec Kitty usa `.worktrees/` por defecto para work packages.
- Invocar `using-git-worktrees` al crear ramas/worktrees paralelos.
- Dashboard opcional: `spec-kitty dashboard`

## UI en misiones Kitty

Si la misión incluye pantallas o landing: invocar `ui-router` durante implementación (dominio UI + `ui-ux-pro-max`), igual que con Spec Kit.

## Gates JARVIS (siempre)

- OK explícito del usuario antes de `merge` / push
- `verification-before-completion` antes de declarar misión cerrada
- `git-guardrails-ops` en push/merge
- `finishing-a-development-branch` + limpiar worktrees al cerrar

## Cuándo NO usar Spec Kitty

- Repo ya canónico en `.specify/` (ej. Zonix Pharma) sin decisión de migración
- Pack inversor, docs marketing, cifras
- Bugfix puntual → `systematic-debugging`
- One-off edits sin Git workflow

## Bootstrap en un producto

```bash
pipx install spec-kitty-cli
spec-kitty init . --ai cursor
spec-kitty verify-setup
```

Los slash commands y skills locales se instalan en el **repo producto**; esta skill global solo orquesta.

## vs GitHub Spec Kit

| | Spec Kitty | Spec Kit (JARVIS) |
|---|------------|-------------------|
| Marcador | `.kittify/` | `.specify/` |
| Artefactos | `kitty-specs/` | `specs/` |
| Runtime | `next → review → accept → merge` | `speckit-implement` |
| Skills globales | `kitty-router` | `speckit-*` |
