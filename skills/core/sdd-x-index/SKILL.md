---
name: sdd-x-index
description: >
  Mapa Spec-Driven X (SD-X): elige skills JARVIS por tipo de artefacto (dev, diseño, docs, test, validate).
  Trigger: spec-driven, SD-X, qué skill usar, diseño + spec, documentación post-feature.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.1"
  scope: [global]
  category: core
  auto_invoke:
    - "Spec-driven development ambiguo"
    - "Combinar spec con UI o docs"
    - "Qué toolkit SD-X usar"
  triggers: sdx, sd-x, spec-driven x, speckit, awesome-spec-kits, openspec
  related-skills:
    - sdd-router
    - kitty-router
    - openspec-router
    - ui-router
    - jarvis-core
    - jarvis-skills-maintainer
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# SD-X Index — Spec-Driven X en JARVIS

Índice de **qué skill invocar** según el tipo de salida (filosofía SD-X: Specs → AI → X). Alineado con [awesome-spec-kits](https://github.com/acnlabs/awesome-spec-kits); JARVIS usa **Cursor skills** + `install.sh`, no MetaSpec CLI.

Guía completa: [docs/SDX_ECOSYSTEM.md](../../docs/SDX_ECOSYSTEM.md). Catálogo externo: [docs/AWESOME_SPEC_KITS.md](../../docs/AWESOME_SPEC_KITS.md). Registro: [catalog/sdx-toolkit-registry.json](../../catalog/sdx-toolkit-registry.json).

## Mapa SD-X → skills

| SD-X | Cuándo | Skills / artefactos |
|------|--------|---------------------|
| **SD-Development** (`.specify/`) | Feature producto con GitHub Spec Kit | `sdd-router` → `speckit-*` + dominio `{producto}-*` |
| **SD-Development** (`.kittify/`) | Misiones Spec Kitty, work packages | `kitty-router` → CLI + `kitty-governance` |
| **SD-Development** (`openspec/`) | Cambios fluidos, brownfield | `openspec-router` → OPSX propose/apply/archive |
| **SD-Design** | Pantallas, landing, UI | `ui-router` → dominio UI → `ui-ux-pro-max` |
| **SD-Documentation** | Cierre módulo, AGENTS, walkthrough | `documentar-avances`, `context-updater` |
| **SD-Test** | Implementación y cierre | `test-driven-development`, `verification-before-completion` |
| **SD-Validate** | Pre-implement, gates | `speckit-analyze`, `speckit-checklist` |
| **SD-Config** | Extensions, presets | `.specify/extensions.yml`, Spec Kitty `.kittify/` |
| **SD-API** | Diseño REST/GraphQL sin speckit dedicado | `api-design-principles` + dominio `{producto}-api-patterns` |
| **SD-Protocol** | Protocolos, estándares wire | Sin speckit JARVIS global — evaluar speckit externo o dominio |
| **SDM** (marketing ops) | Campañas, workflows marketing | Watchlist `marketing-spec-kit` — ver [AWESOME_SPEC_KITS.md](../../docs/AWESOME_SPEC_KITS.md) |

## Decisión rápida

```bash
test -d .kittify && echo "HAS_SPEC_KITTY"
test -d openspec && echo "HAS_OPENSPEC"
test -d .specify && echo "HAS_SPEC_KIT"
test -d specs && echo "HAS_SPECS"
test -d kitty-specs && echo "HAS_KITTY_SPECS"
```

| Situación | Router primero |
|-----------|----------------|
| Repo con `.kittify/` | `kitty-router` |
| Repo con `openspec/` | `openspec-router` |
| Nueva feature (`.specify/`) | `sdd-router` |
| 2+ marcadores SDD | **STOP** — usuario elige canónico |
| Solo UI/landing | `ui-router` |
| Pack inversor / Lanzamiento | Dominio docs — **no** SD-X dev |
| No sabes qué rama SD-X | **Esta skill** |

## Toolkits integrados en JARVIS

| Toolkit | SD-X | Sync / install |
|---------|------|----------------|
| [GitHub Spec Kit](https://github.com/github/spec-kit) v0.11.2 | Development, Validate | `scripts/sync-spec-kit-skills.sh` |
| [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) v2.5.0 | Design | `scripts/sync-ui-ux-pro-max.sh` |
| [Spec Kitty](https://github.com/Priivacy-ai/spec-kitty) v3.2.1 | Development, Validate, Config | `pipx` + `spec-kitty init` en producto |

## Comparativa SD-Development (4 enfoques)

| | Spec Kit | Spec Kitty | OpenSpec | MetaSpec |
|---|----------|------------|----------|----------|
| Marcador | `.specify/`, `specs/` | `.kittify/`, `kitty-specs/` | `openspec/` | N/A (framework) |
| Filosofía | Fases constitution→implement | Misiones + review/merge | Fluido, brownfield | Generar speckits Python |
| JARVIS | `speckit-*` | `kitty-router` | `openspec-router` | Referencia only |
| Estado | Integrado | Integrado | Router + watchlist | Referencia |

No mezclar marcadores en el mismo repo sin decisión explícita.

## awesome-spec-kits watchlist

Fuente upstream: `speckits.json` en [acnlabs/awesome-spec-kits](https://github.com/acnlabs/awesome-spec-kits). Detalle: [AWESOME_SPEC_KITS.md](../../docs/AWESOME_SPEC_KITS.md).

| Speckit | Estado JARVIS |
|---------|----------------|
| specify-cli (GitHub Spec Kit) | Integrado |
| openspec | Router `openspec-router` |
| marketing-spec-kit | Watchlist (clawvis marketing) |
| mcp-speckit | Watchlist (MCP / OpenClaw) |
| meta-spec | Referencia (no distribución JARVIS) |

Lista generada: `catalog/SDX_TOOLKITS.md` (desde `sync-sdx-registry.py`).

## Cuándo NO usar este índice

- Bugfix puntual → `systematic-debugging`
- Solo commit/git → `git-commit`, `git-guardrails-ops`
- Mantenimiento skills globales → `jarvis-skills-maintainer`
