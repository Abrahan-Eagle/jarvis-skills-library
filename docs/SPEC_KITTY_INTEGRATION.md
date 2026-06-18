# Spec Kitty + JARVIS

Integración complementaria de [Spec Kitty](https://github.com/Priivacy-ai/spec-kitty) v3.2.1 en la biblioteca global. **No** reemplaza GitHub Spec Kit (`speckit-*`, `.specify/`).

## Qué es Spec Kitty

CLI open-source para spec-driven development con **estado en el repo**:

```
spec → plan → tasks → next → review → accept → merge
```

Incluye work packages, git worktrees (`.worktrees/`), kanban (`spec-kitty dashboard`), governance (`spec-kitty dispatch`), y slash commands para Cursor tras `init`.

## Instalación (repo producto)

```bash
pipx install spec-kitty-cli
cd /path/to/your-repo
spec-kitty init . --ai cursor
spec-kitty verify-setup
```

Los comandos `/spec-kitty.*` y skills locales se instalan **en el proyecto**, no en `jarvis-skills-library`.

## Skills globales JARVIS

| Skill | Uso |
|-------|-----|
| `kitty-router` | Repo con `.kittify/` — cadena misión |
| `kitty-governance` | `spec-kitty dispatch` + cerrar Ops |
| `using-git-worktrees` | Alineado con `.worktrees/` de Kitty |
| `sdd-router` | Solo si `.specify/` (Spec Kit) |

## Spec Kitty vs GitHub Spec Kit

| | Spec Kitty | GitHub Spec Kit |
|---|------------|-----------------|
| Marcador | `.kittify/` | `.specify/` |
| Specs | `kitty-specs/` | `specs/` |
| Skills globales | `kitty-router` | `speckit-*` + `sdd-router` |
| Implementación | `next` + review/accept/merge | `speckit-implement` |
| Worktrees / kanban | Integrado | Manual |
| Distribución Cursor | `spec-kitty init` en repo | Skills en `~/.cursor/skills` |

**Zonix Pharma** usa Spec Kit — no migrar sin decisión explícita.

**No mezclar** `.kittify/` y `.specify/` en el mismo repo sin elegir un canónico.

## Flujo típico (Cursor)

```
/spec-kitty.charter
/spec-kitty.specify Build feature X.
/spec-kitty.plan
/spec-kitty.tasks
```

Luego:

```bash
spec-kitty next --agent cursor --mission <slug>
```

Review y merge:

```
/spec-kitty.review
/spec-kitty.accept
/spec-kitty.merge --push   # solo con OK usuario
```

Cierre: `/spec-kitty-mission-review`, opcional `spec-kitty retrospect summary`.

## UI en misiones

Igual que Spec Kit: invocar `ui-router` + dominio UI + `ui-ux-pro-max` cuando hay pantallas.

## SD-X

Registro: [catalog/sdx-toolkit-registry.json](catalog/sdx-toolkit-registry.json). Mapa: [docs/SDX_ECOSYSTEM.md](SDX_ECOSYSTEM.md).

## Referencias

- [Documentación Spec Kitty](https://priivacy-ai.github.io/spec-kitty/)
- [GitHub Spec Kit + JARVIS](SDD_SPECKIT_INTEGRATION.md)
- [SD-X ecosystem](SDX_ECOSYSTEM.md)
