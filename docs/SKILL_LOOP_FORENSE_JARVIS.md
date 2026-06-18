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
| `patch-skill-loop-skill.py` | Overlay, IRON LAW, references/assets/schema |
| `smoke-skill-loop.sh` | Checks adaptación + validación YAML |
| `audit-skill-loop-body.sh` | Conteos residuales (forense) |
| `install-skill-loop-runtime.sh` | `go install` binario pin + tmux check |
| `install-skill-loop-upstream.sh` | Clone opcional `~/skill-loop` |
| Plantilla + assets JARVIS | `docs/templates/…` + `assets/jarvis-*.tmpl` |
| Registry SDX + cruces | `jarvis-core`, `session-learner-ops`, `learning-loop-router` |

## Qué NO se adoptó

| Elemento | Razón |
|----------|-------|
| Repo Go completo en library | CLI vía `go install` / Homebrew |
| Slash `/skill-loop` en Cursor | Invocar skill `skill-loop` |
| Default `.claude/skills/` | JARVIS → `.agents/skills/` |
| `--dangerously-skip-permissions` en plantillas | AppSec; plantilla JARVIS sin args peligrosos |
| Cron `schedule` por defecto en producto | tmux residente — solo con OK usuario |
| Dashboard React embebido | Runtime del binario |
| Sustituir `jarvis-core` / Spec Kit | Orquestación distinta |

## Hallazgos vs JARVIS global

### Solapamiento — JARVIS canónico

| Área | JARVIS | Decisión |
|------|--------|----------|
| Workflow módulo guiado | `jarvis-core` | JARVIS primero |
| Spec SDD | `sdd-router`, `speckit-*` | JARVIS |
| TDD / verificación | `test-driven-development`, `verification-before-completion` | Skills en loop |
| Review PR | `code-review-playbook` | Manual o skill en loop |
| Cierre módulo + memoria | **`session-learner-ops`** | Tras loop `done` |
| Aprendizajes sesión | `learning-loop` (opcional) | Post-loop complemento |

### Complemento — skill-loop

| Área | skill-loop | JARVIS |
|------|------------|--------|
| Loop automático impl→review→rework | CLI + YAML | — |
| Scaffold `skill-loop.yml` | skill `skill-loop` | — |
| Sesiones tmux background | `skill-loop sessions` | — |
| Human-in-the-loop | `blocked: true` + resume | OK usuario |

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
| Crear/editar `skill-loop.yml` | `skill-loop` | YAML manual sin schema |
| Ejecutar loop | `skill-loop run` (tras OK usuario) | skill-loop skill solo |
| Cierre módulo | `session-learner-ops` | skill-loop |
| Consolidar aprendizajes | `learning-loop` wrap-up (opc.) | skill-loop |
| Spec feature nueva | `speckit-*` | skill-loop |

### Matriz ECC + Cyber Neo + learning-loop

| Necesidad | skill-loop | ECC / Cyber Neo / learning-loop |
|-----------|------------|--------------------------------|
| Loop impl→review→verify | **skill-loop** + CLI | — |
| Instincts / hooks | — | `ecc-router`, `continuous-learning-v2` |
| Auditoría seguridad | — | `cyber-neo-router` |
| Memoria sesión wrap-up | — | `learning-loop-router` |
| Cierre módulo | — | `session-learner-ops` (canónico tras `done`) |

**Combinación recomendada:** `skill-loop run` → `done` → `session-learner-ops` → tests → opcional `learning-loop wrap-up`.

### Matriz precedencia ampliada

```
jarvis-core (plan)
  → skill-loop scaffold YAML (OK usuario)
  → skill-loop run (tmux)
  → session-learner-ops
  → verification-before-completion
  → opcional learning-loop wrap-up
```

## Cobertura por stack JARVIS

| Stack | Uso típico | Runtime | Post-loop |
|-------|------------|---------|-----------|
| CorralX Backend | impl→review→`php artisan test` | `cursor-cli` | learner + tests |
| CorralX Flutter | impl→review→`flutter test` | `cursor-cli` | walkthrough UI |
| Zonix Pharma | Igual + Rx copy review | `cursor-cli` | `zonix-*` en prompts |
| jarvis-skills-library | validate-all loop | `cursor-cli` | commit con OK |
| clawvis-openclaw | Marketing pipelines | `cursor-cli` o `claude` | active_context |

Skills del loop: globales `~/.cursor/skills/` + dominio `.agents/skills/` del repo producto.

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
5. **Skills faltantes** — copiar `assets/jarvis-*.tmpl` a `.agents/skills/`.
6. **Auto-run sin OK** — IRON LAW: usuario aprueba YAML y `run`.
7. **Commits locales sin push** — equipo no recibe hasta `git push`.
8. **Ejemplos upstream codex** — patch v2 alinea patrones JARVIS a `cursor-cli`.

## Patrones adoptados (referencia Cyber Neo / learning-loop)

| Patrón | skill-loop en JARVIS |
|--------|----------------------|
| Router harness | `skill-loop-router` |
| Sync upstream curado | `sync-skill-loop-skill.sh` |
| Patch Cursor v2 | `patch-skill-loop-skill.py` (SKILL + references + assets + schema) |
| Doc integración + forense | `SKILL_LOOP_INTEGRATION.md`, este archivo |
| Smoke + audit | `smoke-skill-loop.sh`, `audit-skill-loop-body.sh` |
| Starter skills JARVIS | `assets/jarvis-implement|review|verify.SKILL.md.tmpl` |

---

## Re-análisis 2026-06-18 (post-integración `cd5762b`)

**Commit integración inicial:** `cd5762b` — router, skill, sync, smoke, plantilla, registry.  
**Re-análisis forense v2:** patch references/assets/schema, starter tmpl JARVIS, audit, cruces learning-loop.  
**Upstream pin:** `0bea8b08` — sin drift conocido al 2026-06-18.

### Gaps detectados (G1–G12)

| ID | Gap | Estado v1 | Remedio v2 |
|----|-----|-----------|------------|
| G1 | `.claude/skills/` | Fixed | Patch SKILL + references |
| G2 | Slash `/skill-loop` | Fixed | Overlay |
| G3 | Binario fuera del repo | Open (by design) | `install-skill-loop-runtime.sh` |
| G4 | tmux requerido | Documentado | Forense + integration |
| G5 | cursor-cli vs IDE | Parcial → **v2** | Patch examples + plantilla |
| G6 | Sin SKILL-OC.md | Open (warn) | Baja prioridad |
| G7 | Confusión learning-loop | Parcial → **v2** | Cruces routers + forense |
| G8 | Flags en plantilla JARVIS | Mitigado | Sin args peligrosos |
| G9 | schema.json skip-permissions | Open → **v2** | Patch descripciones schema |
| G10 | yaml-pattern codex default | Open → **v2** | JARVIS notes + cursor-cli en ejemplos |
| G11 | Sin starter skills tmpl | Open → **v2** | `jarvis-*.tmpl` |
| G12 | learning-loop-router sin cruce | Open → **v2** | Fila skill-loop-router |

### Auditoría residual

Ejecutar: `bash scripts/audit-skill-loop-body.sh`

---

Ver operativa: [SKILL_LOOP_INTEGRATION.md](SKILL_LOOP_INTEGRATION.md).
