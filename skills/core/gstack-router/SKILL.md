---
name: gstack-router
description: >
  Orquesta pack garrytan/gstack vs canónico JARVIS. Trigger: gstack, Garry Tan,
  /office-hours, /plan-ceo-review, /ship, /qa, /careful, /freeze, /autoplan.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.1"
  scope: [global]
  category: core
  auto_invoke:
    - "Pack gstack / Garry Tan"
    - "/office-hours /ship /qa /careful"
    - "autoplan o freeze de alcance gstack"
  triggers: gstack, garry tan, office-hours, plan-ceo-review, ship, qa-only, careful, freeze, autoplan
  related-skills:
    - jarvis-core
    - deep-interview-ops
    - jarvis-experts
    - code-review-playbook
    - verification-before-completion
    - webapp-testing
    - systematic-debugging
    - parallel-judge-ops
    - git-guardrails-ops
    - human-in-the-loop-ops
    - agent-skills-router
    - cyber-neo-router
    - docs-alignment-ops
    - session-startup-ops
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash, Task]
---

# gstack Router (Garry Tan)

Router para [garrytan/gstack](https://github.com/garrytan/gstack) (MIT): equipo virtual Think→Ship→Reflect **sin** sustituir `jarvis-core`, `speckit-*`, ni gobernanza de push/merge.

Guía: [docs/GSTACK_INTEGRATION.md](../../../docs/GSTACK_INTEGRATION.md) · Forense: [docs/GSTACK_FORENSE_JARVIS.md](../../../docs/GSTACK_FORENSE_JARVIS.md).

Pin de referencia: `0530392821c277b95e5cd65aa9d9fda4248718b2` (v1.81.0.0).

## IRON LAW

1. **`jarvis-core` precede** — este router no inicia módulos ni commits sin el flujo JARVIS.
2. **Nunca ejecutar `/ship` ni `/land-and-deploy` de gstack** — contradicen `git-guardrails-ops` (push/merge solo con orden explícita).
3. **Nunca `/autoplan` ni `/plan-tune` auto-decide** — erosión HITL; usar fan-out + jueces + `human-in-the-loop-ops`.
4. **No sync masivo** de SKILL.md gstack a esta library (preámbulo Claude-acoplado, colisiones de nombre, coste de contexto).
5. **Supply-chain:** antes de `./setup` local, `skill-security-auditor` + pin SHA; telemetría off; team_mode false; no auto_upgrade.

## Detección runtime

```bash
test -d "${HOME}/.claude/skills/gstack" && echo GSTACK_CLAUDE
test -d "${HOME}/.cursor/skills/gstack" && echo GSTACK_CURSOR
ls "${HOME}/.cursor/skills"/gstack-* 2>/dev/null | head -3
test -f skills/core/gstack-router/SKILL.md && echo GSTACK_ROUTER_LIBRARY
```

Si el pack está instalado en Cursor: **advertir** que hooks `careful`/`freeze` **no se exportan** (frontmatter reducido a name+description). Enforcement real → skill Cursor `create-hook` + `git-guardrails-ops`.

## Árbol de decisión

| Pedido | Ruta JARVIS | No usar |
|--------|-------------|---------|
| Office hours / premisa / wedge | `deep-interview-ops` → `brainstorming-ops` → `jarvis-experts` | Copiar office-hours SKILL.md |
| Plan CEO / scope challenge | `jarvis-experts` (modos EXPANSION/SELECTIVE/HOLD/REDUCTION) → `speckit-clarify` | `/plan-ceo-review` como fuente de verdad |
| Plan eng / design / DX | `speckit-plan` / `writing-plans` / `ui-router` / `cognitive-doc-design-ops` | — |
| Pipeline multi-perspectiva | `fan-out-synthesize-ops` + `parallel-judge-ops` + HITL final | **`/autoplan`**, **`/plan-tune`** |
| Review | `code-review-playbook` (+ `parallel-judge-ops`, `doubt-driven-development`) | Sustituir playbook por `/review` gstack |
| Investigate / debug | `systematic-debugging` (3-strike + scope lock) | Fixes sin root cause |
| QA / browse | `webapp-testing` (WTF-likelihood, report-only) | Daemon gstack browse, cookies, pair-agent, Aside |
| CSO / seguridad | `cyber-neo-router` → `cyber-neo` | Telemetría / GBrain |
| **Ship / land / deploy** | `verification-before-completion` → `work-unit-commits-ops` → `git-commit` → `branch-pr-ops`; push solo `git-guardrails-ops` con orden | **`/ship`**, **`/land-and-deploy`** |
| Document release | `docs-alignment-ops` | — |
| Retro / learn / context | `strategic-briefing-ops`, `session-learner-ops`, `handoff`, `learning-loop`, Engram | — |
| Careful / freeze / guard | Declarar scope; `git-guardrails-ops`; ofrecer `create-hook` | Confiar en hooks gstack bajo Cursor |
| Pack instalado: office-hours, qa-only, cso, retro, diagram, make-pdf | Permitido **solo** en máquina personal tras auditoría | En `.agents/skills/` de producto |
| Cookies / pair-agent / open-gstack-browser / gstack-upgrade auto | — | **Prohibido** |

## Cadena “ship” JARVIS (reemplazo de `/ship`)

1. `verification-before-completion` — evidencia **fresca** sobre el working tree actual (untracked incluido); estados DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT.
2. `work-unit-commits-ops` + `git-commit` — commits reviewable; no incluir secretos.
3. `branch-pr-ops` — PR; no push a main.
4. **Stop** — pedir orden explícita del usuario antes de cualquier `git push` / merge (`git-guardrails-ops`, `human-in-the-loop-ops`).

## vs otros routers

| Router | Pack | Rol |
|--------|------|-----|
| `agent-skills-router` | Addy Osmani | DEFINE→SHIP + doubt-driven curado |
| `claude-skills-router` | Rezvani | Megapack + `skill-security-auditor` |
| `ecc-router` | ECC | Harness hooks/instincts |
| `cyber-neo-router` | Cyber Neo | Auditoría seguridad read-only |
| **`gstack-router`** | Garry Tan gstack | Sprint opinionado; **solo routing + ideas curadas** |

## Limitaciones

- Sin portar preámbulo gstack (~33 KB) ni bins Bun.
- Sin telemetría Supabase ni auto-update SessionStart.
- Ideas curadas viven en las skills canónicas (verification, review, webapp-testing, etc.), no en SKILL.md clonados.
