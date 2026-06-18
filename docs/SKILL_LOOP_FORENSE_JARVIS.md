# Forense skill-loop vs JARVIS — Resumen

**Fecha:** 2026-06-18  
**Repo analizado:** [takumiyoshikawa/skill-loop](https://github.com/takumiyoshikawa/skill-loop) (MIT, Go CLI + skill scaffolding)  
**Pin JARVIS:** `0bea8b08e079c71bc857631e26ada06068e82321` (main)  
**Objetivo:** Orquestar loops impl→review→verify sin sustituir `jarvis-core` ni confundir con `learning-loop`.

---

## Qué es skill-loop

Orquestador **agentic** para CLIs de coding agents:

1. Lee `skill-loop.yml` (skills, rutas, criterios router).
2. Ejecuta cada skill vía agent CLI (`claude`, `codex`, **`cursor-cli`**, `opencode`) en tmux.
3. Router LLM evalúa stdout y elige siguiente skill, `done`, o `blocked`.
4. Repite hasta `done: true` o `max_iterations`.

Skill upstream: scaffolding YAML, patrones (loop, scheduled, GitHub issues), validación contra `schema.json`.

**No es** [learning-loop](LEARNING_LOOP_FORENSE_JARVIS.md) (melodykoh): ese captura aprendizajes de sesión; skill-loop **ejecuta** pasadas multi-skill.

## Qué se adoptó en jarvis-skills-library

| Artefacto | Función |
|-----------|---------|
| `skill-loop-router` | Precedencia vs jarvis-core, learning-loop, speckit |
| `skill-loop` (ops) | Skill sync upstream + patch JARVIS/Cursor |
| `sync-skill-loop-skill.sh` | Clone pin + rsync skill tree + schema |
| `patch-skill-loop-skill.py` | Overlay, IRON LAW, replacements paths |
| `smoke-skill-loop.sh` | Checks adaptación + validación YAML opcional |
| `install-skill-loop-runtime.sh` | `go install` binario pin + tmux check |
| `install-skill-loop-upstream.sh` | Clone opcional `~/skill-loop` |
| Plantilla | `docs/templates/skill-loop-jarvis-feature.yml.example` |
| Registry SDX + cruces | `jarvis-core`, `session-learner-ops` |

## Qué NO se adoptó

| Elemento | Razón |
|----------|-------|
| Repo Go completo en library | CLI vía `go install` / Homebrew |
| Slash `/skill-loop` en Cursor | Invocar skill `skill-loop` |
| Default `.claude/skills/` | JARVIS → `.agents/skills/` |
| `--dangerously-skip-permissions` en plantillas | AppSec; plantilla JARVIS sin flags peligrosos |
| Cron `schedule` por defecto en producto | tmux residente — solo con OK usuario |
| Dashboard React embebido | Runtime del binario |
| Sustituir `jarvis-core` / Spec Kit | Orquestación distinta |

## Hallazgos vs JARVIS global

### Solapamiento — JARVIS canónico

| Área | JARVIS | Decisión |
|------|--------|----------|
| Workflow módulo guiado | `jarvis-core` | JARVIS primero |
| Spec SDD | `sdd-router`, `speckit-*` | JARVIS |
| TDD / verificación | `test-driven-development`, `verification-before-completion` | Skills en loop, no sustitutos |
| Review PR | `code-review-playbook` | Manual o skill en loop |
| Cierre módulo + memoria | **`session-learner-ops`** | Tras loop `done` |
| Aprendizajes sesión | `learning-loop` (opcional) | Post-loop complemento |

### Complemento — skill-loop

| Área | skill-loop | JARVIS |
|------|------------|--------|
| Loop automático impl→review→rework | CLI + YAML | — |
| Scaffold `skill-loop.yml` | skill `skill-loop` | — |
| Sesiones tmux background | `skill-loop sessions` | — |
| Human-in-the-loop | `blocked: true` + resume | Alineado con OK usuario |

### Diferencia vs learning-loop

| | skill-loop | learning-loop |
|---|------------|----------------|
| Output | Código revisado / workflow terminado | Memoria, watch-list, destinos docs |
| Ejecución | Binario Go + tmux | Task readonly en Cursor |
| Cuándo | Feature con varias pasadas automáticas | Fin sesión / contexto largo |
| Tamaño | Skill pequeño + YAML repo | Skill ~156 KB |

### Matriz — cuándo usar cada skill

| Pedido | Skill | No usar |
|--------|-------|---------|
| Planificar módulo | `jarvis-core` | skill-loop |
| Crear/editar `skill-loop.yml` | `skill-loop` | manual YAML sin schema |
| Ejecutar loop | `skill-loop run` (tras OK usuario) | skill-loop skill solo |
| Cierre módulo | `session-learner-ops` | skill-loop |
| Consolidar aprendizajes | `learning-loop` wrap-up (opc.) | skill-loop |
| Spec feature nueva | `speckit-*` | skill-loop |

## Cobertura por stack JARVIS

| Stack | Uso típico | Runtime | Post-loop |
|-------|------------|---------|-----------|
| CorralX Backend | impl→review→`php artisan test` | `cursor-cli` | learner + tests |
| CorralX Flutter | impl→review→`flutter test` | `cursor-cli` | walkthrough UI |
| Zonix Pharma | Igual + Rx copy review | `cursor-cli` | `zonix-*` skills en prompts |
| jarvis-skills-library | Sync skills / validate-all loop | `cursor-cli` | commit local con OK |
| clawvis-openclaw | Marketing pipeline loops | `cursor-cli` o `claude` | active_context |

Skills del loop deben existir en `.agents/skills/` del repo + globales en `~/.cursor/skills/`.

## Flujo recomendado post-loop

1. Usuario aprueba `skill-loop.yml` → `skill-loop run` (o `--attach`).
2. Loop termina (`done`) o pausa (`blocked` → `sessions resume`).
3. **`session-learner-ops`** → `docs/active_context.md` + walkthrough.
4. **`verification-before-completion`** → tests del stack.
5. Opcional: `learning-loop wrap up`.

## Riesgos operativos

1. **Sesiones tmux huérfanas** — `skill-loop sessions ls/stop/prune`.
2. **Costo API** — `max_iterations` bajo (plantilla JARVIS: 5).
3. **Permisos peligrosos** — no `--dangerously-skip-permissions` en automatización.
4. **Confusión learning-loop** — nombres distintos en routers y docs.
5. **Skills faltantes** — loop invoca nombres que no existen en `.agents/skills/`.
6. **Auto-run sin OK** — IRON LAW: usuario aprueba YAML y `run`.
7. **Commits locales sin push** — equipo no recibe hasta `git push`.

## Gaps detectados (G1–G8)

| ID | Gap | Estado | Remedio |
|----|-----|--------|---------|
| G1 | Default `.claude/skills/` | Fixed | Patch → `.agents/skills/` |
| G2 | Slash `/skill-loop` | Fixed | Overlay invocación por skill |
| G3 | Binario no en repo | Open (by design) | `install-skill-loop-runtime.sh` |
| G4 | tmux requerido | Documentado | Forense + integration |
| G5 | cursor-cli vs Cursor IDE | Parcial | Plantilla `runtime: cursor-cli` |
| G6 | Sin SKILL-OC.md | Open (warn) | Baja prioridad |
| G7 | Confusión learning-loop | Documentado | Routers + forense |
| G8 | Flags peligrosos upstream examples | Mitigado | Plantilla JARVIS sin args peligrosos |

---

Ver operativa: [SKILL_LOOP_INTEGRATION.md](SKILL_LOOP_INTEGRATION.md).
