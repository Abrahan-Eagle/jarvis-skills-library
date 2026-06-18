---
name: learning-loop-router
description: >
  Orquesta learning-loop (scan/wrap-up) vs session-learner-ops, handoff y ECC continuous-learning.
  Trigger: learning-loop, wrap up sesión, scan contexto, consolidar aprendizajes.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: core
  auto_invoke:
    - "learning-loop scan wrap up"
    - "Consolidar aprendizajes antes de cerrar"
    - "Contexto largo capturar señales"
  triggers: learning-loop, wrap up, consolidar sesión, scan mid-session
  related-skills:
    - jarvis-core
    - learning-loop
    - session-learner-ops
    - context-updater
    - handoff
    - continuous-learning-v2
    - ecc-router
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash, Task]
---

# Learning Loop Router

Router para [learning-loop-skill](https://github.com/melodykoh/learning-loop-skill) (MIT v4.1): captura estructurada de aprendizajes **sin** sustituir cierre canónico JARVIS.

Guía: [docs/LEARNING_LOOP_INTEGRATION.md](../../docs/LEARNING_LOOP_INTEGRATION.md). Forense: [docs/LEARNING_LOOP_FORENSE_JARVIS.md](../../docs/LEARNING_LOOP_FORENSE_JARVIS.md).

## Detección runtime

```bash
test -d "${HOME}/.cursor/skills/learning-loop" && echo LEARNING_LOOP_INSTALLED
test -f skills/ops/learning-loop/SKILL.md && echo LEARNING_LOOP_LIBRARY
test -d "${HOME}/.cursor/learning-captures" && echo LEARNING_CAPTURES_EXIST
```

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| Cierre módulo | `jarvis-core` → **`session-learner-ops`** | learning-loop como sustituto |
| Actualizar `active_context` rápido | `context-updater` | wrap-up completo |
| Traspaso mid-task incompleto | `handoff` | wrap-up |
| Contexto largo / antes de compactar | `learning-loop` **scan** (Task readonly) | scan en main thread |
| Fin sesión / consolidar aprendizajes | `learning-loop` **wrap-up** → verificar usuario → rutear | escribir sin OK |
| Instincts ECC / `/evolve` | `ecc-router` → `continuous-learning-v2` | learning-loop |
| Cierre módulo + señales extra | `session-learner-ops` luego opcional wrap-up | solo learning-loop |

## Flujo recomendado (Cursor)

1. Usuario invoca skill `learning-loop` con modo **scan** o **wrap up** en el mensaje.
2. **Scan:** Task subagent con SCANNER_PROMPT → escribe en `~/.cursor/learning-captures/<session-id>/`.
3. **Wrap-up:** Task para consolidation + personas; presentar verificación zoned; **esperar OK** antes de escribir destinos.
4. Destinos JARVIS: ver overlay en skill `learning-loop` (AGENTS, `active_context`, walkthrough — no Judgment Ledger en producto).
5. Tras cierre módulo formal: `session-learner-ops` ya actualizó `active_context`; wrap-up puede añadir detalle.

## Limitaciones

- Sin `/learning-loop` slash en Cursor — invocación explícita por skill.
- `/ce:compound` no integrado; code fixes → walkthrough + `documentar-avances`.
- Judgment Ledger / content wedge: flujo personal upstream — no en repos producto JARVIS.
