# Forense Learning Loop vs JARVIS — Resumen

**Fecha:** 2026-06-18  
**Repo analizado:** [melodykoh/learning-loop-skill](https://github.com/melodykoh/learning-loop-skill) (MIT, v4.1.0)  
**Pin JARVIS:** `948dc75bc5a771a57366c651c5d442b44cba214d` (main)  
**Objetivo:** Captura/consolidación de aprendizajes de sesión sin sustituir `session-learner-ops` ni el cierre canónico JARVIS.

**vs skill-loop:** learning-loop no orquesta loops impl→review; para eso usar `skill-loop-router` + skill `skill-loop`. Ver [SKILL_LOOP_FORENSE_JARVIS.md](SKILL_LOOP_FORENSE_JARVIS.md).

---

## Qué es Learning Loop

Skill de **dos modos** para no perder señal antes de compactación o cierre de chat:

| Modo | Cuándo | Qué hace |
|------|--------|----------|
| **Scan** | Mid-session, contexto largo | Sub-agente → señales crudas en `learning-captures/<session-id>/scan-NNN.md` |
| **Wrap-up** | Fin de sesión | Scan final, quality gates (5 + significance), personas shadow, verificación usuario, routing |

Upstream v4.1 (2026-06-12): W7.w STOP gates en consolidación (no saltar sub-agent ni persona panel bajo presión de cierre).

Contenido sync: `SKILL.md` monolítico (~156 KB, ~2348 líneas). Runtime: watch-list, graduation-log, persona eval logs (usuario, no en repo upstream).

## Qué se adoptó en jarvis-skills-library

| Artefacto | Función |
|-----------|---------|
| `learning-loop-router` | Precedencia vs `session-learner-ops`, `handoff`, ECC |
| `learning-loop` (ops) | Skill sync upstream + patch JARVIS/Cursor |
| `sync-learning-loop-skill.sh` | Clone pin + rsync SKILL + SESSION_LOG ref |
| `patch-learning-loop-skill.py` | Overlay, IRON LAW, replacements body, frontmatter |
| `smoke-learning-loop.sh` | Checks adaptación Cursor |
| `audit-learning-loop-body.sh` | Conteos residuales (forense) |
| `install-learning-loop-upstream.sh` | Clone opcional `~/learning-loop-skill` |
| Registry SDX + cruces | `jarvis-core`, `session-learner-ops`, `ecc-router` |

## Qué NO se adoptó

| Elemento | Razón |
|----------|-------|
| `CLAUDE.md` dev del skill upstream | Solo SKILL.md necesario |
| Hook SessionStart post-`/clear` | Claude Code; opcional en Cursor, no instalado por defecto |
| Judgment Ledger / content wedge en producto | Flujo personal autor; N/A repos JARVIS |
| `/ce:compound` (Every plugin) | No en library; → walkthrough + `documentar-avances` |
| Fork SKILL en múltiples `references/` | Riesgo drift; patch body en v2 |
| Sustituir `session-learner-ops` | Cierre canónico distinto y más ligero |

## Hallazgos vs JARVIS global

### Solapamiento — JARVIS canónico

| Área | JARVIS | Decisión |
|------|--------|----------|
| Cierre módulo + `active_context` | **`session-learner-ops`** | JARVIS primero |
| Resumen rápido al cerrar | `context-updater` | JARVIS |
| Traspaso mid-task incompleto | `handoff` | JARVIS |
| Workflow módulo | `jarvis-core` | JARVIS |
| Changelog AGENTS | `documentar-avances` | JARVIS |
| Instincts / `/evolve` | `continuous-learning-v2` (ECC) | ECC |
| Auditoría seguridad | `cyber-neo-router` | No learning-loop |

### Complemento — Learning Loop

| Área | Learning Loop | JARVIS / ECC |
|------|---------------|--------------|
| Scan multi-señal + gates | skill `learning-loop` | — |
| Watch-list patrones recurrentes | `~/.cursor/learning-captures/watch-list.md` | — |
| Patrones UI módulo | enriquece `walkthrough.md` | `session-learner-ops` |

### Diferencia clave vs `session-learner-ops`

| | `session-learner-ops` | `learning-loop` |
|---|------------------------|-----------------|
| Alcance | Cierre módulo, patrones concretos | Sesión completa, hipótesis, correcciones, watch-list |
| Gates | Plantilla walkthrough | 5 quality gates + significance + personas |
| Destinos | `active_context`, walkthrough | AGENTS, docs, captures, watch-list |
| Sub-agentes | No | Scan + consolidation (Task readonly) |
| Invocación | Auto cierre módulo | Explícita (skill + scan/wrap up) |
| Tamaño skill | Pequeño | ~156 KB (costo contexto) |

### Matriz ampliada — cuándo usar cada skill

| Pedido usuario | Skill | No usar |
|----------------|-------|---------|
| Terminar módulo | `session-learner-ops` | learning-loop como sustituto |
| Actualizar active_context rápido | `context-updater` | wrap-up completo |
| Traspaso a otro chat | `handoff` | wrap-up |
| Contexto largo / antes de compactar | `learning-loop` scan | scan en main thread |
| Consolidar aprendizajes sesión | `learning-loop` wrap-up | escribir sin OK usuario |
| Instincts ECC | `continuous-learning-v2` | learning-loop |
| Cierre módulo + señales extra | `session-learner-ops` → opcional wrap-up | solo wrap-up |

### Matriz ECC + Cyber Neo

| Necesidad | Learning Loop | ECC / Cyber Neo |
|-----------|---------------|-----------------|
| Captura sesión estructurada | **learning-loop** | — |
| Instincts / homunculus | — | `continuous-learning-v2` |
| Memoria hooks post-edit | — | ECC hooks |
| Auditoría seguridad | — | `cyber-neo-router` |

**Combinación:** instincts ECC en repo producto; learning-loop wrap-up opcional tras `session-learner-ops`; Cyber Neo independiente (reporte seguridad).

## Cobertura por stack JARVIS

| Stack | Learning Loop cubre | Destinos típicos | Complemento JARVIS |
|-------|---------------------|------------------|-------------------|
| CorralX Laravel API | Process rules, fixes, facts sesión | `AGENTS.md`, `active_context`, walkthrough | `laravel-specialist`, `session-learner-ops` |
| CorralX Flutter | Patrones UI, overflow, tema | walkthrough, `active_context` | `corralx-ui-design`, `flutter-expert` |
| Zonix Pharma API+Flutter | Igual CorralX + Rx/regulatorio copy | `docs/`, walkthrough | `zonix-*` dominio |
| jarvis-skills-library | Skills-level, patch/sync learnings | skill repo, validate-all | `jarvis-core` |
| clawvis-openclaw | Ops/marketing sesión larga | `active_context`, captures | `session-learner-ops` adaptado |

## Flujo recomendado post-wrap-up

1. **Cierre módulo:** `session-learner-ops` → `docs/active_context.md` + `.agents/plans/walkthrough.md`.
2. **Opcional:** usuario pide `learning-loop wrap up` → scan/consolidate en Task.
3. **Verificación:** usuario confirma conclusiones (zoned verification upstream).
4. **Routing:** destinos JARVIS (tabla overlay); **nunca** Judgment Ledger en producto.
5. **Siguiente sesión:** leer `active_context.md`; watch-list si clusters activos.

## Riesgos operativos

1. **Overlay vs body upstream** — sin patch v2, Step 5 puede rutear a `CLAUDE.md` (G8). Remedio: patch body + IRON LAW JARVIS.
2. **Costo contexto** — ~156 KB SKILL; invocar solo con scan/wrap-up explícito.
3. **Sub-agent STOP** — consolidar en main thread al “cerrar rápido”; usar Task `readonly: true`.
4. **Saltar verificación usuario** — upstream exige OK; no auto-persistir.
5. **Watch-list sin acción** — clusters maduros → plan en `.agents/plans/` o issue.
6. **Duplicado `active_context`** — learner canónico; loop enriquece sin contradecir.
7. **Paths `~/.claude/reference`** — huérfanos en Cursor; patch → `docs/` / `.agents/`.
8. **Distribución** — commits locales hasta `git push`.

## Patrones adoptados (referencia Cyber Neo)

| Patrón | Learning Loop en JARVIS |
|--------|-------------------------|
| Router harness/memoria | `learning-loop-router` |
| Sync upstream curado | `sync-learning-loop-skill.sh` |
| Patch Cursor | `patch-learning-loop-skill.py` v2 |
| Doc integración + forense | `LEARNING_LOOP_INTEGRATION.md`, este archivo |
| Smoke en validate-all | `smoke-learning-loop.sh` |

---

## Re-análisis 2026-06-18 (post-integración `7ca41ef`)

**Commit integración inicial:** `7ca41ef` — router, skill, sync, smoke, registry.  
**Re-análisis forense v2:** patch body + forense ampliado (este documento).  
**Upstream pin:** `948dc75` — sin drift conocido al 2026-06-18.

### Gaps detectados (G1–G10)

| ID | Gap | Estado v1 | Remedio v2 |
|----|-----|-----------|------------|
| G1 | `~/.claude/learning-captures` | Fixed | Reemplazo global → `~/.cursor/learning-captures` |
| G2 | `/learning-loop` slash | Fixed | Overlay + invocación por skill |
| G3 | Destinos CLAUDE/MEMORY | Parcial | Replacements body + IRON LAW |
| G4 | Judgment Ledger en producto | Overlay | Replace → `[JARVIS: no rutear]` |
| G5 | `/ce:compound` | Parcial | Replace → `documentar-avances + walkthrough` |
| G6 | Task vs Skill tool | Fixed | Frontmatter `allowed-tools` sin Skill |
| G7 | `~/.claude/projects/*/memory` | Parcial | Loop `active_context` + walkthrough |
| G8 | ~124 refs CLAUDE-centric en body | Open → **v2 patch** | Replacements globales |
| G9 | Personas leen root CLAUDE.md | Open → **v2 patch** | Pass AGENTS.md en replacements |
| G10 | Sin `SKILL-OC.md` | Open (warn) | Baja prioridad OpenClaw |

### Auditoría body (post-patch v2)

Ejecutar: `bash scripts/audit-learning-loop-body.sh` — reporta conteos residuales para forense.

---

Ver operativa: [LEARNING_LOOP_INTEGRATION.md](LEARNING_LOOP_INTEGRATION.md).
