---
name: finishing-a-development-branch
description: >
  Cerrar feature Flutter: analyze + test, opciones merge/PR.
  Trigger: Terminar módulo.
license: UNLICENSED
metadata:
  version: "1.1.0"
  upstream: superpowers:finishing-a-development-branch
  auto_invoke:
    - "Terminar módulo"
---

# Finishing a development branch — proyecto activo

## Verificar

```bash
flutter analyze
flutter test
```

## Opciones

Igual que Backend (merge `dev`, PR, keep, discard). **Sin push** sin permiso.

## Documentación

`walkthrough.md` + `active_context.md`

## Readiness pre-merge (reporte, no merge automático)

Antes de ofrecer merge/PR, emitir tabla:

| Check | Estado |
|-------|--------|
| Tests/analyze frescos | OK / STALE / MISSING |
| Review | OK / STALE (N commits desde review) / MISSING |
| Docs alineadas | OK / GAP |
| Diff size | líneas / archivos |

Esto es **reporte**. Merge/push solo con orden explícita (`git-guardrails-ops`).
