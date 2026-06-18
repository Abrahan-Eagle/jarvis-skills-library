# skill-loop — integración JARVIS global

[takumiyoshikawa/skill-loop](https://github.com/takumiyoshikawa/skill-loop) (MIT) es un **orquestador CLI** de loops multi-skill: `skill-loop.yml` define pasos (implement → review → rework) y un router LLM elige la siguiente ruta según stdout.

**No es** [learning-loop](LEARNING_LOOP_INTEGRATION.md) (melodykoh) — ese captura aprendizajes de sesión.

Skills JARVIS: `skill-loop-router` + skill `skill-loop` (scaffold YAML).

Forense: [SKILL_LOOP_FORENSE_JARVIS.md](SKILL_LOOP_FORENSE_JARVIS.md).

## Fuentes oficiales

- Repo: [github.com/takumiyoshikawa/skill-loop](https://github.com/takumiyoshikawa/skill-loop)
- Pin JARVIS: `0bea8b08e079c71bc857631e26ada06068e82321` (main)
- MIT

## vs JARVIS canónico

| Necesidad | Usar |
|-----------|------|
| Workflow módulo | `jarvis-core` |
| Spec SDD | `sdd-router` / `speckit-*` |
| Scaffold `skill-loop.yml` | skill `skill-loop` |
| **Ejecutar loop automático** | `skill-loop run` (tras OK usuario) |
| TDD / review / verify en loop | skills JARVIS en `.agents/skills/` del loop |
| Cierre módulo | **`session-learner-ops`** |
| Aprendizajes sesión | `learning-loop-router` (opcional) |

## Arquitectura

```
Cursor (~/.cursor/skills vía install.sh)
  ├─ skill-loop-router
  └─ skill-loop (sync skills/ops/skill-loop)
skills/ops/skill-loop/
  ├─ SKILL.md (patched JARVIS/Cursor)
  ├─ references/ (+ schema.json)
  └─ assets/
Runtime CLI: skill-loop (go install / brew) + tmux
Repo producto: skill-loop.yml + .agents/skills/<step>/SKILL.md
Sesiones: ~/.local/share/skill-loop/<name>/<id>/
```

## Instalación

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install.sh --all
bash scripts/install-skill-loop-runtime.sh   # opcional: CLI + tmux check
```

### Sync upstream (mantenedores)

```bash
bash scripts/sync-skill-loop-skill.sh
bash scripts/smoke-skill-loop.sh
bash scripts/validate-all.sh
```

### Clone upstream (opcional)

```bash
bash scripts/install-skill-loop-upstream.sh
# SKILL_LOOP_UPSTREAM_HOME=~/skill-loop
```

## Uso en Cursor

1. Pedir: "crear skill-loop para feature X" → skill `skill-loop` genera YAML + starter skills.
2. Usuario **aprueba** YAML.
3. `skill-loop run --attach` (o background + `skill-loop sessions show`).
4. Tras `done`: `session-learner-ops` + tests del stack.

### Qué pedir al agente (español)

| Frase | Acción |
|-------|--------|
| "crear skill-loop.yml" / "orquestar loop implementación revisión" | skill `skill-loop` scaffold |
| "ejecutar skill-loop run" | CLI (solo con OK usuario) |
| "terminar módulo" | `session-learner-ops` (no skill-loop) |
| "wrap up learning-loop" | `learning-loop-router` |

### Plantilla JARVIS

Copiar [docs/templates/skill-loop-jarvis-feature.yml.example](templates/skill-loop-jarvis-feature.yml.example) al repo producto como `skill-loop.yml`.

## Flujos producto (CorralX / Zonix)

1. Feature acotada con varias pasadas impl→review.
2. Scaffold con skill `skill-loop`; skills del loop referencian `test-driven-development`, `code-review-playbook`, `verification-before-completion`.
3. `skill-loop run --max-iterations 5 --prompt "..."`.
4. Backend: `php artisan test`; Flutter: `flutter test`.
5. `session-learner-ops` → `docs/active_context.md` + walkthrough.

## Riesgos (resumen)

Ver forense § Riesgos operativos: tmux huérfanas, costo API, no skip-permissions, confusión con learning-loop.

## Scripts

| Script | Uso |
|--------|-----|
| `sync-skill-loop-skill.sh` | Sync + patch |
| `patch-skill-loop-skill.py` | Re-aplicar patch |
| `install-skill-loop-runtime.sh` | `go install` CLI pin |
| `install-skill-loop-upstream.sh` | Clone `~/skill-loop` |
| `smoke-skill-loop.sh` | Smoke patched skill |

## Producto repos

Por defecto **no** modificar `AGENTS.md` de productos. Copiar plantilla YAML solo con OK usuario.
