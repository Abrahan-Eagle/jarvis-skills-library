# Forense Learning Loop vs JARVIS — Resumen

**Fecha:** 2026-06-18  
**Repo analizado:** [melodykoh/learning-loop-skill](https://github.com/melodykoh/learning-loop-skill) (MIT, v4.1.0)  
**Pin JARVIS:** `948dc75bc5a771a57366c651c5d442b44cba214d` (main)  
**Objetivo:** Integrar captura/consolidación de aprendizajes sin sustituir `session-learner-ops` ni el cierre canónico JARVIS.

---

## Qué es Learning Loop

Skill de **dos modos** para no perder señal de sesión antes de compactación o `/clear`:

| Modo | Cuándo | Qué hace |
|------|--------|----------|
| **Scan** | Mid-session, contexto largo | Sub-agente extrae señales crudas → `learning-captures/<session-id>/scan-NNN.md` |
| **Wrap-up** | Fin de sesión | Scan final, quality gates, personas (shadow), verificación usuario, routing a destinos |

Contenido sync: `SKILL.md` monolítico (~156 KB, ~2300 líneas). Runtime usuario: captures, watch-list, graduation-log (no en repo upstream).

## Hallazgos vs JARVIS global

### Solapamiento — JARVIS canónico

| Área | JARVIS | Decisión |
|------|--------|----------|
| Cierre módulo + `active_context` | **`session-learner-ops`** | JARVIS primero |
| Resumen rápido sesión | `context-updater` | JARVIS |
| Traspaso mid-task | `handoff` | JARVIS |
| Workflow módulo | `jarvis-core` | JARVIS |
| Instincts / `/evolve` | `continuous-learning-v2` (ECC) | ECC |

### Complemento — Learning Loop

| Área | Learning Loop | JARVIS / ECC |
|------|---------------|--------------|
| Scan multi-señal con gates | skill `learning-loop` | — |
| Watch-list patrones recurrentes | `~/.cursor/learning-captures/watch-list.md` | — |
| Patrones UI módulo | puede enriquecer `walkthrough.md` | `session-learner-ops` |

### Diferencia clave vs `session-learner-ops`

| | `session-learner-ops` | `learning-loop` |
|---|------------------------|-----------------|
| Alcance | Cierre módulo, patrones concretos | Sesión completa, hipótesis, correcciones, watch-list |
| Gates | Plantilla walkthrough | 5 quality gates + significance + personas |
| Destinos | `active_context`, walkthrough | Múltiples (AGENTS, docs, captures) |
| Sub-agentes | No | Scan + consolidation obligatorios |
| Invocación | Auto cierre módulo | Explícita (skill + scan/wrap up) |

## Gaps post-integración (Cursor / JARVIS)

| ID | Gap upstream | Remedio JARVIS |
|----|--------------|----------------|
| G1 | `~/.claude/learning-captures` | `LEARNING_LOOP_HOME` = `~/.cursor/learning-captures` |
| G2 | `/learning-loop` slash | Skill `learning-loop` + usuario dice scan / wrap up |
| G3 | Destinos `CLAUDE.md`, `MEMORY.md` | Tabla JARVIS: `AGENTS.md`, `active_context`, walkthrough |
| G4 | Judgment Ledger / content wedge | No rutear en repos producto |
| G5 | `/ce:compound` (Every) | walkthrough + `documentar-avances`; nudge sin auto-invoke |
| G6 | Task + Skill (Claude Code) | Cursor **Task** (`readonly: true`); sin `Skill` tool |
| G7 | `~/.claude/projects/*/memory` | Preferir `docs/active_context.md` del repo activo |

## Matriz ECC

| Necesidad | Learning Loop | ECC |
|-----------|---------------|-----|
| Captura sesión estructurada | **learning-loop** | — |
| Instincts homunculus | — | `continuous-learning-v2` |
| Memoria hooks post-edit | — | ECC hooks |

Combinación: instincts ECC en repo producto; learning-loop para wrap-up profundo opcional tras `session-learner-ops`.

## Cobertura por stack JARVIS

| Stack | Learning Loop | No cubre (usar JARVIS) |
|-------|---------------|------------------------|
| Laravel API | Process rules → AGENTS; fixes → walkthrough | Dominio API → `laravel-specialist` |
| Flutter mobile | UI patrones → walkthrough | `flutter-expert`, `zonix-ui-design` |
| Skills library | Skills-level routing al repo skills | `jarvis-core`, validate-all |

## Upstream drift

Pin al día con HEAD `main` al integrar (`948dc75`). Re-sync: `bash scripts/sync-learning-loop-skill.sh`.

---

Ver operativa: [LEARNING_LOOP_INTEGRATION.md](LEARNING_LOOP_INTEGRATION.md).
