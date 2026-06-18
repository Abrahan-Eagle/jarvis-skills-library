# SD-X Ecosystem — JARVIS

Filosofía **Spec-Driven X (SD-X)**: las especificaciones son la fuente de verdad que guía la IA para generar código, diseño, documentación, tests y validación. Inspirado por el índice [awesome-spec-kits](https://github.com/acnlabs/awesome-spec-kits) y el toolkit principal [GitHub Spec-Kit](https://github.com/github/spec-kit).

JARVIS **no** usa MetaSpec CLI para distribuir skills; usa `jarvis-skills-library` + `bash scripts/install.sh --all` → `~/.cursor/skills/`.

## Mapa SD-X → skills

| SD-X | Skills JARVIS | Router |
|------|---------------|--------|
| Development (`.specify/`) | `speckit-*`, dominio `{producto}-*` | `sdd-router` |
| Development (`.kittify/`) | Spec Kitty CLI, `kitty-governance` | `kitty-router` |
| Development (`openspec/`) | OpenSpec OPSX | `openspec-router` |
| Maintenance (`.specify/`) | bugfix, hotfix, refactor, modify, deprecate | `speckit-lifecycle-router` |
| Design | `ui-ux-pro-max`, dominio UI, `open-design-router` | `ui-router` |
| Research / what-if | `scenario-router`, `strategic-briefing-ops`, `scenario-analysis-ops`, `strangeverse` | `scenario-router` |
| API (sin speckit dedicado) | `api-design-principles` | — |
| Documentation | `documentar-avances`, `context-updater` | — (no Spec Kit) |
| Test | `test-driven-development`, `verification-before-completion` | — |
| Validate | `speckit-analyze`, `speckit-checklist` | `sdd-x-index` |
| Config | `.specify/extensions.yml`, `specify extension` | [SDD doc](SDD_SPECKIT_INTEGRATION.md) |

Índice operativo: skill [`sdd-x-index`](skills/core/sdd-x-index/SKILL.md).

## Toolkits registrados

Ver [`catalog/SDX_TOOLKITS.md`](catalog/SDX_TOOLKITS.md) (generado desde `catalog/sdx-toolkit-registry.json`).

| Toolkit | Pin | Sync |
|---------|-----|------|
| GitHub Spec Kit | v0.11.2 | `bash scripts/sync-spec-kit-skills.sh` |
| UI UX Pro Max | v2.5.0 | `bash scripts/sync-ui-ux-pro-max.sh` |
| Open Design (watchlist) | 0.10.0 | `bash scripts/install-open-design-runtime.sh` |
| StrangeVerse (watchlist) | main | `bash scripts/install-strangeverse-runtime.sh` |
| MiroFish upstream (watchlist) | V0.1.2 | Referencia AGPL — [MIROFISH_UPSTREAM.md](MIROFISH_UPSTREAM.md); runtime = StrangeVerse |
| Spec Kitty | v3.2.1 | `pipx install spec-kitty-cli` + `spec-kitty init` en repo producto |
| OpenSpec (watchlist) | 0.16.0 | `npm i -g @fission-ai/openspec` + `openspec init` en repo producto |

Watchlist completa: [AWESOME_SPEC_KITS.md](AWESOME_SPEC_KITS.md) + sección Watchlist en `SDX_TOOLKITS.md`.

Regenerar tabla:

```bash
python3 scripts/sync-sdx-registry.py
```

## Feature producto con UI (flujo combinado)

```
speckit-specify → speckit-clarify (opc.)
  → speckit-plan (+ nota ui-router si hay pantallas)
  → speckit-tasks → speckit-analyze
  → speckit-implement (OK usuario; tareas UI → ui-router)
  → verification-before-completion
  → documentar-avances / context-updater (cierre)
```

Flujo alternativo con **Spec Kitty** (`.kittify/`): ver [SPEC_KITTY_INTEGRATION.md](SPEC_KITTY_INTEGRATION.md) — `kitty-router`, no `speckit-*`.

Flujo alternativo con **OpenSpec** (`openspec/`): ver [AWESOME_SPEC_KITS.md](AWESOME_SPEC_KITS.md) — `openspec-router`, OPSX propose/apply/archive.

## Qué NO es Spec Kit / SD-Development

- Pack inversor, `docs/Lanzamiento/`, cifras financieras
- Marketing collateral sin feature de producto
- Skills dominio: `zonix-lanzamiento-docs`, etc.

Usar skills de dominio del producto, no `speckit-*`.

## Documentación relacionada

- [SPEC_KIT_EXTENSIONS.md](SPEC_KIT_EXTENSIONS.md) — bugfix, hotfix, refactor, modify, deprecate
- [SPEC_KITTY_INTEGRATION.md](SPEC_KITTY_INTEGRATION.md) — misiones, worktrees, review/merge
- [UI_UX_PRO_MAX_INTEGRATION.md](UI_UX_PRO_MAX_INTEGRATION.md) — design system, overlays
- [OPEN_DESIGN_INTEGRATION.md](OPEN_DESIGN_INTEGRATION.md) — carrusel, deck, email HTML (Open Design)
- [STRANGEVERSE_INTEGRATION.md](STRANGEVERSE_INTEGRATION.md) — what-if y simulación multi-agente
- [AWESOME_SPEC_KITS.md](AWESOME_SPEC_KITS.md) — índice acnlabs + watchlist + OpenSpec
- [awesome-spec-kits](https://github.com/acnlabs/awesome-spec-kits) — catálogo upstream
- [MetaSpec](https://mataspec.figma.site/spec-kits) — framework opcional (no usado por JARVIS hoy)

## SD-X y toolkits externos (SDD)

GitHub Spec-Kit es el speckit canónico para **SD-Development** en productos JARVIS. Otros speckits listados en awesome-spec-kits pueden complementar dominios específicos en el futuro; al integrar uno nuevo:

1. Añadir entrada en `catalog/sdx-toolkit-registry.json`
2. Script sync si aplica
3. `python3 scripts/sync-sdx-registry.py`
4. Documentar en esta guía y en `jarvis-skills-maintainer`
