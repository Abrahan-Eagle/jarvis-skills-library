---
name: openspec-router
description: >
  Orquesta flujo OpenSpec (OPSX: propose → apply → archive) cuando existe openspec/.
  Trigger: openspec, opsx, spec-driven brownfield, cambios iterativos sin fases rígidas.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: core
  auto_invoke:
    - "OpenSpec u openspec"
    - "OPSX propose apply archive"
    - "Spec-driven fluido brownfield"
  triggers: openspec, opsx, fission-ai, openspec/changes
  related-skills:
    - sdd-router
    - sdd-x-index
    - jarvis-core
    - verification-before-completion
    - ui-router
    - finishing-a-development-branch
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# OpenSpec Router — OPSX en JARVIS

Router para repos con **OpenSpec** ([Fission-AI/OpenSpec](https://github.com/Fission-AI/OpenSpec)). Complementa Spec Kit y Spec Kitty; no los reemplaza.

Guía: [docs/AWESOME_SPEC_KITS.md](../../docs/AWESOME_SPEC_KITS.md). Índice SD-X: [docs/SDX_ECOSYSTEM.md](../../docs/SDX_ECOSYSTEM.md).

## Detección (repo activo)

```bash
test -d openspec && echo OPENSPEC
test -d .kittify && echo KITTY
test -d .specify && echo SPEC_KIT
```

| Condición | Router |
|-----------|--------|
| Solo `openspec/` | **openspec-router** (esta skill) |
| Solo `.specify/` | `sdd-router` → `speckit-*` |
| Solo `.kittify/` | `kitty-router` |
| Dos o más marcadores SDD | **STOP** — usuario elige canónico; no mezclar flujos |
| Ninguno | `sdd-x-index` o JARVIS plans |

## Cadena OPSX (orden)

1. `npm install -g @fission-ai/openspec@latest` + `openspec init` — **solo en repo producto** (slash commands vía `openspec update`)
2. `/opsx:propose <idea>` → `openspec/changes/<slug>/` (proposal, specs, design, tasks)
3. `/opsx:apply` — implementación (OK usuario)
4. `/opsx:archive` — archivar cambio y actualizar `openspec/specs/`
5. `verification-before-completion` antes de declarar cerrado

Perfil expandido (opcional): `/opsx:new`, `/opsx:continue`, `/opsx:ff`, `/opsx:verify`, `/opsx:bulk-archive`, `/opsx:onboard` — ver docs upstream.

## UI en cambios OpenSpec

Si el cambio incluye pantallas o landing: invocar `ui-router` durante `/opsx:apply` (dominio UI + `ui-ux-pro-max`).

## Gates JARVIS (siempre)

- OK explícito del usuario antes de push/merge
- `verification-before-completion` antes de "listo"
- `git-guardrails-ops` en push/merge
- `finishing-a-development-branch` al cerrar rama de cambio

## Cuándo NO usar OpenSpec

- Repo canónico en `.specify/` (ej. Zonix) sin decisión de migración
- Pack inversor, marketing collateral, cifras
- Bugfix puntual → `systematic-debugging`

## Bootstrap en un producto

```bash
npm install -g @fission-ai/openspec@latest
cd your-project && openspec init
openspec update
```

Requiere Node.js ≥ 20.19. Los slash commands se instalan en el **repo producto**; esta skill global solo orquesta.

## Comparativa rápida

| | OpenSpec | Spec Kit | Spec Kitty |
|---|----------|----------|------------|
| Marcador | `openspec/` | `.specify/`, `specs/` | `.kittify/`, `kitty-specs/` |
| Filosofía | Fluido, brownfield | Fases constitution→implement | Misiones + review/merge |
| Skills JARVIS | `openspec-router` | `speckit-*` | `kitty-router` |
| CLI | `openspec` (npm) | `specify` (pip) | `spec-kitty` (pipx) |
