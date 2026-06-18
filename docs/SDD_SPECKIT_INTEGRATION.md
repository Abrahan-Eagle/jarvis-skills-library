# Integración Spec Kit + JARVIS

Guía para usar [GitHub Spec Kit](https://github.com/github/spec-kit) v0.11.2 desde la biblioteca global `jarvis-skills-library`.

## Dos flujos de planificación

| Flujo | Artefactos | Skills globales |
|-------|------------|-----------------|
| **Spec-Driven (SDD)** | `.specify/`, `specs/NNN-feature/{spec,plan,tasks}.md` | 10 `speckit-*` + `sdd-router` |
| **JARVIS modular** | `.agents/plans/implementation_plan.md` | `jarvis-core`, `writing-plans`, `task-pipeline-ops` |

El router [`sdd-router`](skills/core/sdd-router/SKILL.md) elige el camino según si existe `.specify/` en el repo activo.

## Bootstrap en un repo de producto

**No** ejecutar en `jarvis-skills-library`. En el repo del producto (Backend, Frontend, monorepo):

```bash
# Requiere uv (https://docs.astral.sh/uv/)
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.11.2

cd /path/to/your-product-repo
specify init . --integration cursor-agent --integration-options="--skills" --force
```

Con la biblioteca global instalada (`bash scripts/install.sh --all`), las skills en `~/.cursor/skills/speckit-*` son suficientes para Cursor.

### Upgrade del CLI

```bash
specify self check          # ver si hay release nuevo
specify self upgrade --dry-run
specify self upgrade        # o specify self upgrade --tag v0.11.2
```

## Comandos → skills → artefactos

| Slash / skill | Artefacto principal |
|---------------|-------------------|
| `speckit-constitution` | `.specify/memory/constitution.md` |
| `speckit-specify` | `specs/<feature>/spec.md` |
| `speckit-clarify` | Actualiza `spec.md` (sección Clarifications) |
| `speckit-plan` | `specs/<feature>/plan.md` |
| `speckit-tasks` | `specs/<feature>/tasks.md` |
| `speckit-taskstoissues` | Issues GitHub (tracking; no sustituye implement) |
| `speckit-analyze` | Reporte in-session (no archivo obligatorio) |
| `speckit-checklist` | `specs/<feature>/checklists/*.md` |
| `speckit-implement` | Código en rutas de `tasks.md` |
| `speckit-converge` | Append fase Convergence en `tasks.md` |

## Orden recomendado

```
constitution → specify → clarify (si hace falta) → plan → tasks
  → [taskstoissues opcional] → analyze → implement [OK usuario] → converge (opcional)
```

`speckit-checklist` en cualquier fase pre-implement.

## Extensions y presets

Spec Kit permite personalizar el flujo sin tocar la biblioteca global:

| Mecanismo | Ubicación | Uso |
|-----------|-----------|-----|
| **Project overrides** | `.specify/templates/overrides/` | Ajustes one-off de templates |
| **Presets** | `.specify/presets/templates/` | Formato org/regulatorio de specs/plans |
| **Extensions** | `.specify/extensions/templates/` | Nuevos comandos y workflows |
| **Runtime hooks** | `.specify/extensions.yml` | `hooks.before_*` / `hooks.after_*` por comando |

Prioridad de templates (de mayor a menor): overrides → presets → extensions → core.

La extensión bundled **`agent-context`** inyecta la sección Spec Kit en el `context_file` del agente (ej. `AGENTS.md` en Cursor) con marcadores `<!-- SPECKIT START -->` / `<!-- SPECKIT END -->`. Desactivar con `specify extension disable agent-context` si no quieres que `specify init` modifique ese archivo.

```bash
specify extension search
specify extension add <name>
specify preset search
specify preset add <name>
```

**Ciclo de vida (bugfix, hotfix, refactor, modify, deprecate):** complemento community [spec-kit-extensions](https://github.com/MartyBonacci/spec-kit-extensions) — extensions en repo producto + skill global `speckit-lifecycle-router` (gates y fallbacks). Install: `bash scripts/install-spec-kit-extensions.sh --target <repo>` o [SPEC_KIT_EXTENSIONS.md](SPEC_KIT_EXTENSIONS.md). No sustituye `speckit-specify` para features nuevas.

## Brownfield (proyectos existentes)

Tras implementar una feature, si el código no coincide con spec/plan:

1. `speckit-converge` — compara artefactos vs código y append tareas en `tasks.md`
2. `speckit-implement` — segunda pasada (con OK usuario)
3. Guía upstream: [evolving specs](https://github.com/github/spec-kit/blob/v0.11.2/docs/guides/evolving-specs.md)

Separar upgrades de tooling (`specify self upgrade`) de cambios de comportamiento en `specs/`.

## JARVIS overlays

Skills críticas incluyen sección `## JARVIS Integration (mandatory)` (re-aplicada por `patch-speckit-frontmatter.py` tras cada sync upstream):

- `speckit-implement` — OK usuario, dominio, TDD, verificación, git gates
- `speckit-plan` — dual-repo paths, skills arquitectura
- `speckit-specify` — constitution, no pack inversor
- `speckit-taskstoissues` — OK usuario, validar remote GitHub

## Cuándo usar qué

| Tarea | Herramienta |
|-------|-------------|
| Nueva feature producto (API + app) | `sdd-router` → `speckit-*` + skills dominio del producto |
| Tracking en GitHub Issues | `speckit-taskstoissues` (opcional, tras tasks) |
| Bugfix / hotfix | `systematic-debugging` + JARVIS |
| Docs inversor / Lanzamiento | Skills dominio — **no** Spec Kit |
| Mantenimiento skills globales | `jarvis-skills-maintainer` |

## Dual-repo (ejemplo Zonix)

- Hub SDD: Backend con `specs/` y `.specify/`
- Front espejo: skills globales + dominio en `.agents/skills/`
- Rutas en `plan.md` / `tasks.md`: prefijos `backend:` / `front:`

## Actualizar skills speckit desde upstream

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/sync-spec-kit-skills.sh   # merge bodies + patch frontmatter + overlays
bash scripts/validate-all.sh
bash scripts/install.sh --all
```

Pin actual: **v0.11.2** (`SPEC_KIT_TAG` en el script). El sync ejecuta `patch-speckit-frontmatter.py` automáticamente al final.

## Skills dominio

Spec Kit **no** reemplaza skills de producto (`corralx-*`, `zonix-*`, etc.). En implementación, invocar siempre las skills de dominio del repo activo junto con `speckit-implement`.

## SD-X y toolkits externos

Filosofía **Spec-Driven X** (Specs → AI → código, diseño, docs, tests): ver [docs/SDX_ECOSYSTEM.md](SDX_ECOSYSTEM.md) y skill `sdd-x-index`.

| Recurso | Uso en JARVIS |
|---------|----------------|
| [GitHub Spec-Kit](https://github.com/github/spec-kit) | SD-Development (este doc) |
| [awesome-spec-kits](https://github.com/acnlabs/awesome-spec-kits) | Catálogo de referencia de speckits externos |
| [MetaSpec](https://mataspec.figma.site/spec-kits) | No usado; distribución vía Cursor skills |

Registro interno: `catalog/sdx-toolkit-registry.json` → `python3 scripts/sync-sdx-registry.py` → `catalog/SDX_TOOLKITS.md`.

Al integrar un nuevo toolkit upstream: actualizar el JSON, sync script si aplica, regenerar SDX_TOOLKITS.md, documentar en SDX_ECOSYSTEM.md.
