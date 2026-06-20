---
name: skill-loop-router
description: >
  Orquesta skill-loop (YAML loops impl-review) vs jarvis-core, speckit, learning-loop.
  Trigger: skill-loop, skill-loop.yml, loop implementación, orquestar skills automático.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: core
  auto_invoke:
    - "skill-loop workflow"
    - "Orquestar loop implementación revisión"
    - "Crear skill-loop.yml"
  triggers: skill-loop, skill-loop.yml, agent loop, orquestar skills
  related-skills:
    - jarvis-core
    - skill-loop
    - agent-loop-engineering
    - parallel-judge-ops
    - test-driven-development
    - code-review-playbook
    - verification-before-completion
    - session-learner-ops
    - learning-loop-router
    - human-in-the-loop-ops
    - sdd-router
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# Skill Loop Router

Router para [takumiyoshikawa/skill-loop](https://github.com/takumiyoshikawa/skill-loop) (MIT): orquestador **CLI** de loops multi-skill (`skill-loop.yml` + `skill-loop run`).

**No es** `learning-loop` (melodykoh) — ese captura aprendizajes de sesión.

Guía: [docs/SKILL_LOOP_INTEGRATION.md](../../docs/SKILL_LOOP_INTEGRATION.md). Forense: [docs/SKILL_LOOP_FORENSE_JARVIS.md](../../docs/SKILL_LOOP_FORENSE_JARVIS.md). Gates humanos en loops autónomos: `human-in-the-loop-ops` ([docs/LOOP_AI_ECOSYSTEM.md](../../docs/LOOP_AI_ECOSYSTEM.md) — *Taxonomía de threads* y *Patrones de workflow dinámico*). En Claude Code nativo, fan-out / tournament / generate-and-filter equivalen a **dynamic workflows**; en Cursor usar Task + este router.

## Detección runtime

```bash
command -v skill-loop && skill-loop --help >/dev/null 2>&1 && echo SKILL_LOOP_CLI
test -f skills/ops/skill-loop/SKILL.md && echo SKILL_LOOP_LIBRARY
test -d "${HOME}/.cursor/skills/skill-loop" && echo SKILL_LOOP_INSTALLED
```

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| Diseñar / entender un loop (loop vs prompt, anatomía, tipos) | **`agent-loop-engineering`** | scaffold YAML directo sin diseño |
| Workflow módulo guiado | `jarvis-core` | skill-loop como sustituto |
| Spec SDD nueva feature | `sdd-router` / `speckit-*` | skill-loop |
| Scaffold / editar `skill-loop.yml` | skill `skill-loop` | YAML manual sin schema |
| Ejecutar loop automático | `skill-loop run` (OK usuario) | solo skill sin CLI |
| Verificación adversarial paralela / "día del juicio" | **`parallel-judge-ops`** | juez único (sesgo) |
| Review PR puntual | `code-review-playbook` | loop completo |
| Cierre módulo + memoria | **`session-learner-ops`** | skill-loop |
| Aprendizajes post-sesión | `learning-loop-router` (opc.) | skill-loop |

## Flujo recomendado (Cursor)

1. Usuario pide loop → definir HITL/HOTL + terminación con `human-in-the-loop-ops`.
2. Skill `skill-loop` scaffolda YAML + starter skills en `.agents/skills/`.
3. Usuario **aprueba** YAML → `bash scripts/install-skill-loop-runtime.sh` si falta CLI.
4. `skill-loop run --attach` (o background + `sessions show`).
5. Al `done`: `session-learner-ops` + tests + `verification-before-completion`.
6. Opcional: `learning-loop` wrap-up.

## Plantilla JARVIS

Ver [docs/templates/skill-loop-jarvis-feature.yml.example](../../docs/templates/skill-loop-jarvis-feature.yml.example).

## Limitaciones

- Requiere `tmux` y binario `skill-loop` para ejecución.
- `cursor-cli` requiere Cursor CLI (`agent`) en PATH.
- No auto-run sin OK usuario (IRON LAW en skill `skill-loop`).
