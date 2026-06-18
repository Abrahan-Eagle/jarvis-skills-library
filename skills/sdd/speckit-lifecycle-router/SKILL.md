---
name: speckit-lifecycle-router
description: >
  Orquesta workflows Spec Kit lifecycle (bugfix, modify, refactor, hotfix, deprecate) cuando existe .specify/.
  Trigger: bugfix, hotfix, refactor, deprecar feature, modificar feature existente, regresión.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.1"
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
| `workflows/` presente | Slash `/speckit.*` o bash `create-*.sh` + cadena plan → tasks → implement |
| Solo `.specify/` (sin extensions) | Fallback JARVIS (mismos quality gates) |

### `enabled.conf`

Si existe `.specify/extensions/enabled.conf`, verificar que el workflow solicitado está activo (línea sin `#`):

```bash
grep -E '^[[:space:]]*bugfix' .specify/extensions/enabled.conf 2>/dev/null || echo DISABLED
```

Si el workflow está desactivado: avisar al usuario y usar el **fallback JARVIS** equivalente de la tabla abajo (no bloquear el trabajo).

## Árbol de decisión

| Escenario | Workflow | Con extensiones (repo producto) | Sin extensiones (fallback JARVIS) |
|-----------|----------|-----------------------------------|-----------------------------------|
| **Feature nueva** | specify | `sdd-router` → `speckit-specify` | igual |
| **Bug no urgente** | bugfix | `/speckit.bugfix` → plan → tasks → implement | Ver fases fallback bugfix abajo |
| **Producción caída** | hotfix | `/speckit.hotfix` (OK usuario push) | Ver fases fallback hotfix abajo |
| **Cambiar feature existente** | modify | `/speckit.modify <NNN>` | `zoom-out` + impacto manual + `speckit-plan` si hay spec |
| **Calidad sin cambiar behavior** | refactor | `/speckit.refactor` | Ver fases fallback refactor abajo |
| **Retirar feature** | deprecate | `/speckit.deprecate <NNN>` | Ver fases fallback deprecate abajo |

**No usar `speckit-specify` para bugs** — usar bugfix o hotfix según urgencia.

## Quality gates por workflow (obligatorios)

Alineados a upstream cheat sheet y constitution **Section VI** (`.specify/memory/constitution.md`).

| Workflow | Quality gate | Estrategia de tests | Artefactos / branch |
|----------|--------------|---------------------|---------------------|
| **bugfix** | Regresión **antes** del fix | Test before fix | `bugfix/NNN-*`, `specs/bugfix-NNN-*/bug-report.md` |
| **modify** | Revisar `impact-analysis.md` **antes** de código | Actualizar tests afectados | `NNN-mod-MMM-*`, `modification-spec.md`, `impact-analysis.md` |
| **refactor** | Tests green tras **cada** incremento | Tests unchanged | `refactor/NNN-*`, `baseline-metrics.md` |
| **hotfix** | Post-mortem ≤48h; test **después** (única excepción) | Test after fix | `hotfix/NNN-*` |
| **deprecate** | Sunset 3 fases: Warnings → Disabled → Removed | Quitar tests en fase final | `specs/.../deprecate-*` |

## Orden de lectura de artefactos

Antes de implementar, leer en este orden:

1. Spec principal (`bug-report.md`, `modification-spec.md`, `refactor-spec.md`, etc.)
2. `impact-analysis.md` — si existe (modify obligatorio)
3. `tasks.md` — fases y dependencias de ejecución
4. `.specify/memory/constitution.md` — Section VI (workflow quality gates)
5. Spec padre en `specs/NNN-*` — modify y deprecate

## Invocación (con extensiones)

### Slash Cursor (si `.cursor/commands/speckit.*.md` instalados)

```
/speckit.bugfix "descripción del bug"
/speckit.modify 014 "cambio descriptivo"
/speckit.refactor "mejora descriptiva"
/speckit.hotfix "incidente producción"
/speckit.deprecate 014 "razón del sunset"
```

Ejecutar el script **una sola vez** por workflow; usar JSON/output del terminal para rutas absolutas.

### Bash universal (sin slash o cualquier agente)

Desde la raíz del repo producto:

```bash
.specify/scripts/bash/create-bugfix.sh "descripción"
.specify/scripts/bash/create-modification.sh NNN "descripción"
.specify/scripts/bash/create-refactor.sh "descripción"
.specify/scripts/bash/create-hotfix.sh "incidente"
.specify/scripts/bash/create-deprecate.sh NNN "razón"
```

Luego pedir implementación siguiendo los archivos generados y los quality gates de esta skill.

## Cadena común (con extensiones)

Tras crear el workflow (slash o bash):

1. Completar investigación en el artefacto inicial (root cause, impacto, métricas baseline)
2. `speckit-plan` → `speckit-tasks` → `speckit-analyze` (opc.)
3. `speckit-implement` — **solo con OK usuario**
4. `verification-before-completion`

## Fases fallback JARVIS (sin extensions)

Mismos gates que upstream; documentar en plan si hace falta.

### Bugfix

1. **Reproduce** — `systematic-debugging` hasta reproducir consistentemente
2. **Failing test** — `test-driven-development`: test de regresión que falla
3. **Fix** — cambio mínimo que pasa el test
4. **Verify** — suite completa + `verification-before-completion`

Skills: `systematic-debugging` + `test-driven-development` + `writing-plans` (opc.).

### Hotfix

1. **Mitigar** — fix mínimo en rama hotfix; `git-guardrails-ops` para push/merge
2. **Test after fix** — excepción documentada; test de humo/regresión tras el fix
3. **Post-mortem** — documentar en ≤48h (`documentar-avances` o artefacto en repo)
4. **Backport** — bugfix formal si el root cause persiste en `dev`

### Refactor

1. **Baseline** — métricas actuales (complejidad, duplicación, líneas)
2. **Incremental** — un cambio pequeño → tests → commit
3. **Repeat** — hasta objetivo; tests green tras cada paso
4. **Compare** — métricas finales vs baseline

Skills: `clean-code-principles` + `test-driven-development`.

### Deprecate (3 fases)

1. **Warnings** — avisos UI/docs; telemetría de uso
2. **Disabled** — feature off por defecto; escape hatch temporal
3. **Removed** — código y tests eliminados; changelog

Skills: `documentar-avances` + plan escrito; OK usuario en cada fase.

## Recuperación (workflow equivocado)

No bloquear. Crear el workflow correcto, copiar notas relevantes al nuevo artefacto y continuar. Eliminar ramas/artefactos huérfanos solo con OK usuario.

## Gates JARVIS (siempre)

- `verification-before-completion` antes de "listo"
- Hotfix / merge / push → `git-guardrails-ops` (OK usuario)
- Regresiones → `test-driven-development`
- Cierre módulo → `documentar-avances`, `context-updater`

## Cuándo NO usar esta skill

- Sin `.specify/` → `systematic-debugging` o JARVIS plans
- Pack inversor, docs marketing, cifras
- Repo con solo `openspec/` o `.kittify/` → routers respectivos

## Instalación en producto

Ver [SPEC_KIT_EXTENSIONS.md](../../docs/SPEC_KIT_EXTENSIONS.md). Script: `scripts/install-spec-kit-extensions.sh --target <repo>`. Comandos Cursor en `.cursor/commands/` del **repo producto**, no en `jarvis-skills-library`.
