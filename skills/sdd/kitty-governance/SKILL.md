---
name: kitty-governance
description: >
  Governance Spec Kitty: spec-kitty dispatch, Op records y cierre de invocación. Solo si .kittify/ existe.
  Trigger: dispatch standalone, governance context, Op record spec-kitty.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: sdd
  auto_invoke:
    - "spec-kitty dispatch"
    - "Governance standalone fuera de misión"
  triggers: spec-kitty dispatch, governance op, profile-invocation
  related-skills:
    - kitty-router
    - jarvis-core
    - verification-before-completion
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# Kitty Governance — dispatch y Ops

Patrón de **governance standalone** de Spec Kitty. Solo aplicar si el repo tiene `.kittify/` (ver `kitty-router`).

Referencia upstream: [spec-kitty-standalone](https://github.com/Priivacy-ai/spec-kitty/blob/main/.cursor/commands/spec-kitty-standalone.md). El skill canónico completo se instala en el repo con `spec-kitty init`.

## Cuándo usar dispatch vs misión

| Situación | Flujo |
|-----------|--------|
| Feature con misión activa | `kitty-router` → slash `/spec-kitty.*` + `spec-kitty next` |
| Tarea gobernada **sin** misión (hotfix auditado, spike, ops) | `spec-kitty dispatch` + esta skill |

## Flujo dispatch (obligatorio)

1. Abrir Op con contexto de governance:

```bash
spec-kitty dispatch "<descripción clara del trabajo>"
```

2. Leer `governance_context_text` de la respuesta e **inyectarlo como contexto vinculante** antes de actuar.

3. Ejecutar el trabajo (dominio + TDD + gates JARVIS).

4. **Cerrar el Op** (nunca dejar huérfanos):

```bash
spec-kitty profile-invocation complete \
  --invocation-id <id> \
  --outcome done   # o failed | abandoned
```

- Trabajo fallido → `failed`
- Abortado → `abandoned`
- Diagnóstico: `spec-kitty doctor ops`

## Gates JARVIS

- `dispatch` solo **abre** el Op; no sustituye OK usuario para merge/push destructivo
- `verification-before-completion` antes de cerrar con `outcome done`
- No usar dispatch para evitar review/accept en misiones que lo requieren

## Documentación

[docs/SPEC_KITTY_INTEGRATION.md](../../docs/SPEC_KITTY_INTEGRATION.md)
