---
name: cyber-neo-cli
description: >
  CLI wrapper cyber-neo: status, secrets scan, lockfile check. Scripts Python upstream Cyber Neo.
  Trigger: cyber-neo secrets, cyber-neo lockfiles, escaneo secretos rápido.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: non-code
  auto_invoke:
    - "cyber-neo secrets escaneo rápido"
    - "cyber-neo lockfiles supply chain"
    - "Verificar instalación cyber-neo"
  triggers: cyber-neo secrets, cyber-neo lockfiles, cyber-neo status
  related-skills:
    - cyber-neo-router
    - cyber-neo
    - jarvis-core
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# cyber-neo — CLI (wrapper)

Wrapper bash a scripts Python de [Cyber Neo](https://github.com/Hainrixz/cyber-neo). Router: `cyber-neo-router`. Doc: [docs/CYBER_NEO_INTEGRATION.md](../../docs/CYBER_NEO_INTEGRATION.md).

**Bin:** `skills/non-code/cyber-neo/bin/cyber-neo`

## Comandos

```bash
cyber-neo status
cyber-neo secrets /path/to/project
cyber-neo lockfiles /path/to/project
```

## Prerrequisitos

- `python3`
- Skill `cyber-neo` instalado: `bash scripts/install.sh --all`

## Precedencia

- Auditoría completa 11 dominios → skill `cyber-neo` (no solo CLI)
- Checklist desarrollo → `security`
- Router → `cyber-neo-router`

## Variables

| Variable | Default |
|----------|---------|
| `CYBER_NEO_HOME` | `~/.cursor/skills/cyber-neo` o library `skills/ops/cyber-neo` |
