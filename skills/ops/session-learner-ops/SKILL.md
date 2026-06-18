---
name: session-learner-ops
description: >
  Tras cerrar módulo UI: patrones en docs/active_context.md y walkthrough.
  Trigger: Terminar módulo Frontend.
license: UNLICENSED
metadata:
  version: "1.1.0"
  auto_invoke:
    - "Terminar módulo"
  related-skills: [jarvis-core, verification-before-completion]
---

# Session learner ops — proyecto activo

Adaptado desde clawvis-openclaw.

## Destinos

- `docs/active_context.md` — memoria viva
- `.agents/plans/walkthrough.md` — cierre módulo

## Ejemplos de buenos patrones

- "Chat AppBar: `onSurface` en dark mode, no `onPrimary`"
- "Tabs Mi Perfil: filled primary en modo claro"

## Anti-patrones

- "Mejorar UX" sin detalle
- Duplicar lo ya en `{producto}-ui-design`

Mismo proceso y plantilla que Backend.
