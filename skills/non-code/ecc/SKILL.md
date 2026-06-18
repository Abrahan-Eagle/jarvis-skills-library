---
name: ecc
description: >
  CLI wrapper para ecc-universal: status, consult, doctor, repair. Harness Everything Claude Code en Cursor.
  Trigger: ecc consult, ecc doctor, descubrir skill ECC, verificar hooks agents.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: non-code
  auto_invoke:
    - "ecc consult descubrir componente ECC"
    - "Verificar estado ECC hooks agents"
    - "ecc doctor repair harness"
  triggers: ecc consult, ecc-universal, ecc doctor, ecc repair
  related-skills:
    - ecc-router
    - configure-ecc
    - jarvis-core
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# ecc — CLI harness (wrapper)

Wrapper bash a [`ecc-universal`](https://www.npmjs.com/package/ecc-universal). Router: `ecc-router`. Doc: [docs/ECC_INTEGRATION.md](../../docs/ECC_INTEGRATION.md).

**Bin:** `skills/non-code/ecc/bin/ecc` — usa `node $ECC_HOME/scripts/ecc.js` si el clone existe.

## Comandos

```bash
ecc status
ecc consult "laravel security review"
ecc doctor
ecc repair
```

## Prerrequisitos

- `npx` o `npm install -g ecc-universal`
- Runtime ECC en repo producto (opcional): `bash scripts/install-ecc-runtime.sh --project-dir <repo>`

## Precedencia

- Workflow módulo → `jarvis-core` (no sustituir por ECC commands)
- Descubrimiento harness → este bin + `catalog/ecc-skills-index.md`

## Variables

| Variable | Default |
|----------|---------|
| `ECC_HOME` | `$HOME/ecc` |
| `ECC_TARGET` | `cursor` |
