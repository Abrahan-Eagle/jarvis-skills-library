---
name: speckit-lifecycle-router
description: >
  Orquesta workflows Spec Kit lifecycle (bugfix, modify, refactor, hotfix, deprecate) cuando existe .specify/.
  Trigger: bugfix, hotfix, refactor, deprecar feature, modificar feature existente, regresión.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: sdd
  auto_invoke:
    - "Bugfix con Spec Kit"
    - "Hotfix producción"
    - "Refactor con spec"
    - "Deprecar feature"
    - "Modificar feature existente NNN"
  triggers: speckit.bugfix, speckit.hotfix, speckit.refactor, speckit.modify, speckit.deprecate, regression, lifecycle
  related-skills:
    - sdd-router
    - systematic-debugging
    - test-driven-development
    - speckit-plan
    - speckit-tasks
    - speckit-implement
    - zoom-out
    - clean-code-principles
    - git-guardrails-ops
    - verification-before-completion
    - documentar-avances
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# Spec Kit Lifecycle Router

Router para el **75% del trabajo SDD** que no es feature nueva: bugfix, modify, refactor, hotfix, deprecate. Complementa `speckit-specify` (solo features nuevas).

Basado en [MartyBonacci/spec-kit-extensions](https://github.com/MartyBonacci/spec-kit-extensions). Guía JARVIS: [docs/SPEC_KIT_EXTENSIONS.md](../../docs/SPEC_KIT_EXTENSIONS.md).

**Requisito:** repo con `.specify/` (Spec Kit). Si no hay `.specify/`, usar `systematic-debugging` + JARVIS plans.

## Detección extensiones instaladas

```bash
test -d .specify/extensions/workflows && echo LIFECYCLE_EXT
test -f .specify/extensions/enabled.conf && echo ENABLED_CONF
```

| Estado | Comportamiento |
|--------|----------------|
| `workflows/` presente | Usar slash `/speckit.*` del repo + cadena plan → tasks → implement |
| Solo `.specify/` (sin extensions) | Fallback JARVIS en tabla abajo |

## Árbol de decisión

| Escenario | Workflow | Con extensiones (repo producto) | Sin extensiones (fallback JARVIS) |
|-----------|----------|-----------------------------------|-----------------------------------|
| **Feature nueva** | specify | `sdd-router` → `speckit-specify` | igual |
| **Bug no urgente** | bugfix | `/speckit.bugfix` → plan → tasks → implement | `systematic-debugging` + `test-driven-development` + `writing-plans` |
| **Producción caída** | hotfix | `/speckit.hotfix` (OK usuario push) | `systematic-debugging` + `git-guardrails-ops` + TDD mínimo |
| **Cambiar feature existente** | modify | `/speckit.modify <NNN>` | `zoom-out` + impacto manual + `speckit-plan` si hay spec |
| **Calidad sin cambiar behavior** | refactor | `/speckit.refactor` | `clean-code-principles` + TDD (tests green) |
| **Retirar feature** | deprecate | `/speckit.deprecate <NNN>` | `documentar-avances` + plan 3 fases manual |

**No usar `speckit-specify` para bugs** — usar bugfix o hotfix según urgencia.

## Cadena común (con extensiones)

Tras el slash inicial (`bugfix`, `modify`, etc.):

1. Revisar artefacto generado (bug-report, modification-spec, …)
2. `speckit-plan` → `speckit-tasks` → `speckit-analyze` (opc.)
3. `speckit-implement` — **solo con OK usuario**
4. `verification-before-completion`

Bugfix: **regression test antes del fix**. Hotfix: test después es la excepción documentada upstream.

## Gates JARVIS

- `verification-before-completion` antes de "listo"
- Hotfix / merge / push → `git-guardrails-ops` (OK usuario)
- Regresiones → `test-driven-development`
- Cierre módulo → `documentar-avances`, `context-updater`

## Cuándo NO usar esta skill

- Sin `.specify/` → `systematic-debugging` o JARVIS plans
- Pack inversor, docs marketing, cifras
- Repo con solo `openspec/` o `.kittify/` → routers respectivos

## Instalación en producto

Ver [SPEC_KIT_EXTENSIONS.md](../../docs/SPEC_KIT_EXTENSIONS.md). Los comandos Cursor viven en `.cursor/commands/` del **repo producto**, no en `jarvis-skills-library`.
