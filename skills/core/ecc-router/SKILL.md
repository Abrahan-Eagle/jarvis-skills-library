---
name: ecc-router
description: >
  Orquesta harness ECC (hooks, instincts, rules idioma, ecc consult) vs workflow JARVIS canónico.
  Trigger: ecc, everything claude code, instincts, evolve, hooks cursor, rules php typescript.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: core
  auto_invoke:
    - "Instalar o configurar ECC en proyecto"
    - "Instincts evolve hooks Cursor"
    - "Rules idioma PHP TypeScript en .cursor"
    - "Descubrir skill o agent ECC"
    - "ecc consult doctor repair"
  triggers: ecc, everything claude code, instincts, evolve, hooks.json, ecc-universal, harness
  related-skills:
    - jarvis-core
    - ecc
    - session-learner-ops
    - security
    - continuous-learning-v2
    - security-review-ecc
    - configure-ecc
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# ECC Router

Router para [Everything Claude Code](https://github.com/affaan-m/ecc) (MIT): harness (hooks, rules, agents `ecc-*`, instincts) **sin** sustituir `jarvis-core`.

Guía JARVIS: [docs/ECC_INTEGRATION.md](../../docs/ECC_INTEGRATION.md). Forense: [docs/ECC_FORENSE_JARVIS.md](../../docs/ECC_FORENSE_JARVIS.md).

## Detección runtime

```bash
test -f .cursor/hooks.json && grep -q ecc .cursor/hooks.json 2>/dev/null && echo ECC_HOOKS
test -d .cursor/agents && ls .cursor/agents/ecc-*.md 2>/dev/null | head -1
command -v npx >/dev/null && npx ecc-universal --version 2>/dev/null
test -d "${ECC_HOME:-$HOME/ecc}" && echo ECC_HOME
```

| Señal | Interpretación |
|-------|----------------|
| `ECC_HOOKS` | Instincts/memory hooks activos → `continuous-learning-v2` |
| agents `ecc-*` | ECC install en repo producto |
| `ecc-universal` | CLI → `ecc consult` / doctor |
| Sin señales | Instalar con `install-ecc-runtime.sh` o skill `configure-ecc` |

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| Iniciar/planificar/cerrar módulo | `jarvis-core` | ECC planning commands |
| TDD / tests antes de "listo" | `test-driven-development`, `verification-before-completion` | `tdd-workflow` ECC |
| Commits / push / merge | `git-commit`, `git-guardrails-ops` | ECC git skills |
| Code review PR | `code-review-playbook` | `ecc-code-reviewer` salvo complemento |
| OWASP / seguridad app | `security` o `security-review-ecc` si ECC instalado | — |
| Cierre módulo + memoria | `session-learner-ops` → `docs/active_context.md` | Solo ECC memory hooks |
| Instincts, `/evolve`, homunculus | `continuous-learning-v2` (+ hooks opt-in) | — |
| Rules PHP/TS en `.cursor/` | `install-ecc-runtime.sh` en repo producto | Copiar rules al global |
| Descubrir componente ECC | `ecc consult "<query>"` | Buscar 268 skills manualmente |
| Wizard install ECC | `configure-ecc` o `install-ecc-runtime.sh` | Plugin + full profile duplicado |
| Spec Kit / feature producto | `sdd-router`, `speckit-*` | ECC domain skills por defecto |
| AgentShield scan configs | `ecc doctor` / npm `ecc-agentshield` | — |

## Flujo recomendado

1. `ecc status` — ver hooks, agents, CLI.
2. Si falta runtime en repo: `bash scripts/install-ecc-runtime.sh --project-dir <repo>` (perfil `minimal` default).
3. Instincts solo si usuario pide hooks: `--with-hooks`.
4. Índice upstream (sin vendorizar): `catalog/ecc-skills-index.md`.

## Gates JARVIS

- Perfil `minimal` por defecto (sin hooks intrusivos).
- No apilar plugin Claude `ecc@ecc` + `install.sh --profile full`.
- Solo fuentes oficiales: [affaan-m/ecc](https://github.com/affaan-m/ecc), [ecc.tools](https://ecc.tools).

## Cuándo NO usar ECC

- Workflow modular estándar → `jarvis-core`
- Skills de dominio producto ya en `.agents/skills/` del repo
- Vendorizar 268 skills al global `jarvis-skills-library`
