---
name: deep-interview-ops
description: >
  Entrevista socrática antes de tareas ambiguas en proyecto activo. Gate claridad mínima 3.5/5.
  Trigger: UI vaga, flujo KYC/onboarding sin spec, cambios navegación global.
license: UNLICENSED
metadata:
  version: "1.2.0"
  auto_invoke:
    - "Requisitos ambiguos"
  related-skills:
    - brainstorming-ops
    - speckit-clarify
    - jarvis-core
---

# Deep interview ops — proyecto activo

> Con Spec Kit (`.specify/`), preferir `speckit-clarify` para clarificación estructurada de `spec.md`.

Adaptado desde clawvis-openclaw.

## Gate

```
NO EJECUTAR SI CLARIDAD PROMEDIO < 3.5 / 5.0
```

## Secuencia

`deep-interview-ops` → `brainstorming-ops` → ejecución

## 6 dimensiones

| Dimensión | Pregunta guía |
|-----------|---------------|
| Alcance | ¿Qué pantallas/widgets? ¿Web + móvil? |
| Criterio de éxito | ¿Analyze + tests + criterio UX? |
| Restricciones | ¿Tema claro/oscuro? ¿Offline? |
| Dependencias | ¿API lista en backend `dev`? |
| Riesgos | ¿BuildContext async? ¿Permisos cámara? |
| Contexto | ¿Stitch assets? ¿Walkthrough previo? |

## Casos típicos proyecto

- Onboarding + KYC UI
- Chat legibilidad / realtime
- Marketplace filtros y cards
- Mi Perfil / documentos rancho

## Modo startup (6 forcing questions)

Usar cuando el pedido sea idea de producto / wedge / “office hours” (inspirado en gstack `/office-hours`). **Una pregunta a la vez**; incomodidad = profundidad, no sycophancy.

1. **Demand Reality** — ¿Cuál es la evidencia más fuerte de que alguien estaría genuinamente molesto si esto desapareciera mañana?
2. **Status Quo** — ¿Qué hacen hoy los usuarios para resolver esto — aunque sea mal?
3. **Desperate Specificity** — Nombra a la persona concreta que más lo necesita (rol). ¿Qué la asciende? ¿Qué la despide?
4. **Narrowest Wedge** — ¿Cuál es la versión más pequeña por la que alguien pagaría dinero real esta semana?
5. **Observation & Surprise** — ¿Has visto a alguien usarlo **sin** ayudarle? ¿Qué te sorprendió?
6. **Future-Fit** — Si el mundo cambia en 3 años, ¿esto es más esencial o menos?

Routing por etapa: pre-producto → 1–3; con usuarios → 2,4,5; con pago → 4–6; infra interna → 2,4.
