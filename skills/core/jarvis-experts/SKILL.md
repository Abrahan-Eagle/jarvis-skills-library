---
name: jarvis-experts
description: >
  Panel de Expertos JARVIS (agencia de desarrollo virtual). Define roster de roles,
  criterios de activación, combinaciones recomendadas y plantilla de declaración.
  Trigger: Antes de planificar/ejecutar tareas técnicas o decisiones cross-rol.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "2.0"
  scope: [global]
  auto_invoke:
    - "Cualquier tarea no trivial"
    - "Decisión cross-rol"
    - "Definir alcance de un módulo"
  triggers: experto, expertos, agencia, panel, rol, roles, jarvis-experts
  related-skills: jarvis-core
allowed-tools: [Read, Glob, Grep]
---

# Panel de Expertos JARVIS (global)

## Cómo usar

1. **Identifica** 1–3 roles primarios para la tarea.
2. **Declara** al inicio: `> Roles: backend (Laravel) + AppSec`.
3. **Combina** roles secundarios automáticamente cuando la tarea lo exige.
4. **No spam:** no listar el roster entero ni declarar roles en tareas triviales.
5. Tras elegir roles, seguir precedencia en `jarvis-core`.

El roster detallado del **producto activo** está en `AGENTS.md` del repo. Esta skill define el patrón genérico.

## Roster genérico

| Área | Rol | Activar cuando… |
|------|-----|-----------------|
| Dirección | CTO / Tech lead | trade-offs, roadmap, CI/CD |
| Dirección | Arquitecto | diseño sistema, integraciones, escalabilidad |
| Desarrollo | Backend | APIs, servicios, BD, jobs |
| Desarrollo | Frontend / Mobile | UI, estado cliente, navegación |
| Plataforma | DevOps / SRE | deploy, observabilidad, incidentes |
| Calidad | QA / SDET | tests, fixtures, E2E |
| Calidad | AppSec | auth, secretos, OWASP |
| Producto | PM / UX / UX writer | scope, copy, flujos |
| Entrega | Delivery / BA | requisitos, stakeholders |
| Soporte | Technical writer | docs, repro bugs |

## Combinaciones típicas

| Tarea | Combinación |
|-------|-------------|
| Pantalla nueva | frontend + UX writer + a11y |
| Auth / tokens | backend + AppSec |
| Push / realtime | backend + frontend + integraciones |
| Migración BD | backend + DBA |
| Release | DevOps + QA |
| Copy y errores API | UX writer + backend o frontend |

## Especialización por producto

Consultar `AGENTS.md` del repo para dominio (`{producto}-*` skills en `.agents/skills/`).

## Anti-patrones

- Más de 3 roles declarados
- Rol sin justificación (CTO en fix de typo)
- Pedir permiso para activar AppSec en cambio de auth

## Referencias

- `AGENTS.md` del proyecto — roster y reglas locales
- `jarvis-core` — workflow modular
