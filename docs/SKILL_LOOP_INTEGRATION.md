# skill-loop — integración JARVIS global

[takumiyoshikawa/skill-loop](https://github.com/takumiyoshikawa/skill-loop) (MIT) es un **orquestador CLI** de loops multi-skill: `skill-loop.yml` define pasos (implement → review → rework) y un router LLM elige la siguiente ruta según stdout.

**No es** [learning-loop](LEARNING_LOOP_INTEGRATION.md) (melodykoh) — ese captura aprendizajes de sesión.

Skills JARVIS: `skill-loop-router` + skill `skill-loop` (scaffold YAML).

Forense: [SKILL_LOOP_FORENSE_JARVIS.md](SKILL_LOOP_FORENSE_JARVIS.md).

## Fuentes oficiales

- Repo: [github.com/takumiyoshikawa/skill-loop](https://github.com/takumiyoshikawa/skill-loop)
- Pin JARVIS: `0bea8b08e079c71bc857631e26ada06068e82321` (main)
- MIT
- Patch JARVIS: metadata `1.0-jarvis2`

## skill-loop vs learning-loop

| | skill-loop | learning-loop |
|---|------------|-----------------|
| **Problema** | Varias pasadas de trabajo (impl → review → rework) hasta criterio | No perder aprendizajes antes de compactar/cerrar chat |
| **Artefacto** | `skill-loop.yml` + CLI `skill-loop run` | Scan/wrap-up → `learning-captures/` |
| **Router JARVIS** | `skill-loop-router` | `learning-loop-router` |
| **Cuándo** | Feature acotada con iteración automática (tras OK usuario) | Contexto largo, fin sesión, señales extra post-módulo |
| **Cierre canónico** | Tras `done`: **`session-learner-ops`** | No sustituye `session-learner-ops` |

## vs JARVIS canónico

| Necesidad | Usar |
|-----------|------|
| Workflow módulo | `jarvis-core` |
| Spec SDD | `sdd-router` / `speckit-*` |
| Scaffold `skill-loop.yml` | skill `skill-loop` |
| **Ejecutar loop automático** | `skill-loop run` (tras OK usuario) |
| TDD / review / verify en loop | skills JARVIS en `.agents/skills/` del loop + globales en `~/.cursor/skills/` |
| Cierre módulo | **`session-learner-ops`** |
| Aprendizajes sesión | `learning-loop-router` (opcional) |

## Flujo combinado (post-loop)

```
jarvis-core (módulo)
  → skill-loop scaffold + OK usuario
  → skill-loop run (CLI)
  → estado done
  → session-learner-ops + verification-before-completion
  → opcional: learning-loop wrap-up (señales extra)
```

## Arquitectura

```
Cursor (~/.cursor/skills vía install.sh)
  ├─ skill-loop-router
  └─ skill-loop (sync skills/ops/skill-loop)
skills/ops/skill-loop/
  ├─ SKILL.md (patched JARVIS/Cursor 1.0-jarvis2)
  ├─ references/ (+ schema.json local)
  └─ assets/
      ├─ jarvis-implement|review|verify.SKILL.md.tmpl  (JARVIS-only)
      └─ skill-loop.jarvis.yml.tmpl
Runtime CLI: skill-loop (go install / brew) + tmux
Repo producto: skill-loop.yml + .agents/skills/<step>/SKILL.md
Sesiones: ~/.local/share/skill-loop/<name>/<id>/
```

## Starter skills JARVIS

Copiar desde `skills/ops/skill-loop/assets/` al repo producto:

| Template | Destino producto | Invoca |
|----------|------------------|--------|
| `jarvis-implement.SKILL.md.tmpl` | `.agents/skills/implement/SKILL.md` | `test-driven-development` + skill dominio |
| `jarvis-review.SKILL.md.tmpl` | `.agents/skills/review/SKILL.md` | `code-review-playbook` |
| `jarvis-verify.SKILL.md.tmpl` | `.agents/skills/verify/SKILL.md` | tests stack + `verification-before-completion` |
| `skill-loop.jarvis.yml.tmpl` | `skill-loop.yml` (base) | — |

Plantilla documentada: [docs/templates/skill-loop-jarvis-feature.yml.example](templates/skill-loop-jarvis-feature.yml.example).

## Gaps conocidos (v2)

Ver forense § **Re-análisis post-cd5762b** y tabla G1–G12. Resumen:

| Estado | Gaps |
|--------|------|
| Fixed v2 | G1 paths, G5 cursor-cli ejemplos, G9 schema args, G10 yaml-pattern, G11 starter tmpl, G12 router cruce |
| Open (by design) | G3 binario fuera del repo, G6 SKILL-OC.md |
| Documentado | G4 tmux, G7/G8 IRON LAW |

Auditoría: `bash scripts/audit-skill-loop-body.sh`.

## Instalación

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install.sh --all
bash scripts/install-skill-loop-runtime.sh   # opcional: CLI + tmux check
```

### Sync upstream (mantenedores)

```bash
bash scripts/sync-skill-loop-skill.sh
python3 scripts/patch-skill-loop-skill.py
bash scripts/smoke-skill-loop.sh
bash scripts/audit-skill-loop-body.sh
bash scripts/validate-all.sh
```

### Clone upstream (opcional)

```bash
bash scripts/install-skill-loop-upstream.sh
# SKILL_LOOP_UPSTREAM_HOME=~/skill-loop
```

## Uso en Cursor

1. Pedir: "crear skill-loop para feature X" → skill `skill-loop` genera YAML + starter skills.
2. Copiar `jarvis-*.tmpl` → `.agents/skills/<step>/SKILL.md`.
3. Usuario **aprueba** YAML.
4. `skill-loop run --attach` (o background + `skill-loop sessions show`).
5. Tras `done`: `session-learner-ops` + tests del stack; opcional `learning-loop` wrap-up.

### Qué pedir al agente (español)

| Frase | Acción |
|-------|--------|
| "crear skill-loop.yml" / "orquestar loop implementación revisión" | skill `skill-loop` scaffold |
| "ejecutar skill-loop run" | CLI (solo con OK usuario) |
| "terminar módulo" | `session-learner-ops` (no skill-loop) |
| "wrap up learning-loop" | `learning-loop-router` |

### Plantilla JARVIS

Copiar [docs/templates/skill-loop-jarvis-feature.yml.example](templates/skill-loop-jarvis-feature.yml.example) al repo producto como `skill-loop.yml`. Schema local: `skills/ops/skill-loop/references/schema.json`.

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
| `sync-skill-loop-skill.sh` | Sync + preserve JARVIS assets + patch |
| `patch-skill-loop-skill.py` | Re-aplicar patch v2 (references, assets, schema) |
| `install-skill-loop-runtime.sh` | `go install` CLI pin |
| `install-skill-loop-upstream.sh` | Clone `~/skill-loop` |
| `smoke-skill-loop.sh` | Smoke patched skill (jarvis2) |
| `audit-skill-loop-body.sh` | Conteos residuales forense |

## Producto repos

Por defecto **no** modificar `AGENTS.md` de productos. Copiar plantilla YAML solo con OK usuario.
