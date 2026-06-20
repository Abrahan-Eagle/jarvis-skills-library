# AGENTS.md — {Producto}

> Instrucciones para agentes IA en este repo.

## Skills

| Capa | Ubicación |
|------|-----------|
| Globales JARVIS | `~/.cursor/skills/` vía jarvis-skills-library — `bash scripts/install.sh --all` en la máquina |
| Dominio | `.agents/skills/{producto}-*` |

## Panel de expertos

Declarar `> Roles: <rol1> + <rol2>` en tareas no triviales. Ver skill global `jarvis-experts`.

## Precedencia

Aplicar tabla de `jarvis-core` cuando varias skills coincidan.

## Auto-invoke (referencia)

Copiar tabla desde `jarvis-skills-library/AGENTS.md` § Auto-invoke global y añadir filas de dominio local.

| Acción | Skill |
|--------|-------|
| Integrar / diagnosticar JARVIS en este repo | `project-bootstrap-ops` |
| Tarea no trivial | `jarvis-experts` |
| Nueva feature (con `.specify/`) | `sdd-router` → `speckit-specify` |
| Iniciar módulo (sin Spec Kit) | `jarvis-core`, `brainstorming-ops` |
| Commit | `verification-before-completion`, `git-commit` |

## Convenciones del stack

- Framework: {ej. Laravel 10 / Flutter 3.x}
- Tests: `{comando de verificación}`
- Ramas: `{ej. dev / main}`
