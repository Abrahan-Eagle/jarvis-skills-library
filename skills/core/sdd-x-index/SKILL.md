---
name: sdd-x-index
description: >
  Mapa Spec-Driven X (SD-X): elige skills JARVIS por tipo de artefacto (dev, diseño, docs, test, validate).
  Trigger: spec-driven, SD-X, qué skill usar, diseño + spec, documentación post-feature.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: core
  auto_invoke:
    - "Spec-driven development ambiguo"
    - "Combinar spec con UI o docs"
    - "Qué toolkit SD-X usar"
  triggers: sdx, sd-x, spec-driven x, speckit, awesome-spec-kits
  related-skills:
    - sdd-router
    - kitty-router
    - ui-router
    - jarvis-core
    - jarvis-skills-maintainer
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# SD-X Index — Spec-Driven X en JARVIS

Índice de **qué skill invocar** según el tipo de salida (filosofía SD-X: Specs → AI → X). Inspirado en [awesome-spec-kits](https://github.com/acnlabs/awesome-spec-kits); JARVIS usa **Cursor skills** + `install.sh`, no MetaSpec CLI.

Guía completa: [docs/SDX_ECOSYSTEM.md](../../docs/SDX_ECOSYSTEM.md). Registro toolkits: [catalog/sdx-toolkit-registry.json](../../catalog/sdx-toolkit-registry.json).

## Mapa SD-X → skills

| SD-X | Cuándo | Skills / artefactos |
|------|--------|---------------------|
| **SD-Development** (`.specify/`) | Feature producto con GitHub Spec Kit | `sdd-router` → `speckit-*` + dominio `{producto}-*` |
| **SD-Development** (`.kittify/`) | Misiones Spec Kitty, work packages | `kitty-router` → CLI + `kitty-governance` (dispatch) |
| **SD-Design** | Pantallas, landing, UI en spec/plan/implement | `ui-router` → `{producto}-ui-design` / `zonix-web-design` → `ui-ux-pro-max` |
| **SD-Documentation** | Cierre módulo, AGENTS, walkthrough | `documentar-avances`, `context-updater` — **no** Spec Kit |
| **SD-Test** | Implementación y cierre | `test-driven-development`, `verification-before-completion` |
| **SD-Validate** | Pre-implement, gates de calidad | `speckit-analyze`, `speckit-checklist` |
| **SD-Config** | Extensions, presets, hooks | `.specify/extensions.yml`, `specify extension` — ver [SDD doc](../../docs/SDD_SPECKIT_INTEGRATION.md) |

## Decisión rápida

```bash
test -d .kittify && echo "HAS_SPEC_KITTY"
test -d .specify && echo "HAS_SPEC_KIT"
test -d specs && echo "HAS_SPECS"
test -d kitty-specs && echo "HAS_KITTY_SPECS"
# UI en la tarea → ui-router además del router SD-Development
```

| Situación | Router primero |
|-----------|----------------|
| Repo con `.kittify/` | `kitty-router` (no `speckit-*`) |
| Nueva feature API + app (`.specify/`) | `sdd-router` |
| Ambos `.kittify/` y `.specify/` | **STOP** — usuario elige canónico |
| Solo UI/landing sin spec nueva | `ui-router` |
| Pack inversor / Lanzamiento / cifras | Dominio docs (`zonix-lanzamiento-docs`, etc.) — **no** SD-X dev |
| No sabes qué rama SD-X | **Esta skill** → tabla arriba → router específico |

## Feature con Spec Kit + UI

1. `speckit-specify` / `speckit-plan` — incluir requisitos UX en `spec.md` / `plan.md`
2. En `speckit-plan`: anotar invocación de `ui-router` si hay pantallas
3. `speckit-implement`: tareas UI → `ui-router` + dominio + TDD
4. Pre-entrega visual: checklist `ui-ux-pro-max` (prioridad 1–10)

## Toolkits integrados en JARVIS

| Toolkit | SD-X | Sync |
|---------|------|------|
| [GitHub Spec Kit](https://github.com/github/spec-kit) v0.11.2 | Development, Validate | `scripts/sync-spec-kit-skills.sh` |
| [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) v2.5.0 | Design | `scripts/sync-ui-ux-pro-max.sh` |
| [Spec Kitty](https://github.com/Priivacy-ai/spec-kitty) v3.2.1 | Development, Validate, Config | `pipx install spec-kitty-cli` + `spec-kitty init` en repo |

## Spec Kit vs Spec Kitty (breve)

| | GitHub Spec Kit | Spec Kitty |
|---|-----------------|------------|
| Marcador | `.specify/`, `specs/` | `.kittify/`, `kitty-specs/` |
| Flujo JARVIS | `speckit-*` skills | `kitty-router` + CLI `next/review/merge` |
| Paralelismo | Manual / `using-git-worktrees` | `.worktrees/` + work packages |
| Instalación global | `sync-spec-kit-skills.sh` | Router + docs; comandos vía `init` en producto |

No mezclar ambos en el mismo repo sin decisión explícita. Ver [SPEC_KITTY_INTEGRATION.md](../../docs/SPEC_KITTY_INTEGRATION.md).

Lista generada: `catalog/SDX_TOOLKITS.md` (desde `sync-sdx-registry.py`).

## MetaSpec / awesome-spec-kits

- **awesome-spec-kits**: catálogo de referencia de speckits externos; el registro upstream está vacío hoy.
- **MetaSpec** (`pip install meta-spec`): solo si en futuro se publica un speckit Python propio; no es el mecanismo de distribución de esta biblioteca.

## Cuándo NO usar este índice

- Bugfix puntual → `systematic-debugging`
- Solo commit/git → `git-commit`, `git-guardrails-ops`
- Mantenimiento de skills globales → `jarvis-skills-maintainer`
