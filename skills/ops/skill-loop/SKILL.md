---
name: skill-loop
description: >
  Scaffold skill-loop.yml y starter skills para loops impl-review-rework.
  Trigger: skill-loop, orquestar skills, skill-loop.yml, loop implementación revisión.
license: MIT
metadata:
  author: JARVIS Global
  version: "1.0-jarvis1"
  scope: [global]
  category: ops
  upstream: skill-loop:skill-loop
  upstream_version: "main"
  auto_invoke:
    - "Crear skill-loop.yml workflow"
    - "Orquestar loop implementación revisión"
  triggers: skill-loop, skill-loop.yml, agent loop, orquestar skills
  related-skills:
    - skill-loop-router
    - jarvis-core
    - test-driven-development
    - code-review-playbook
    - verification-before-completion
    - session-learner-ops
allowed-tools: [Read, Write, Edit, Grep, Glob, Bash]
---

## JARVIS / Cursor (mandatory)

- **No slash command:** En Cursor no existe `/skill-loop`. Invocar skill `skill-loop` y pedir scaffold YAML o edición de `skill-loop.yml`.
- **Skills directory:** Por defecto JARVIS usa `.agents/skills/` en el repo producto (no `.claude/skills/`).
- **Runtime preferido:** `cursor-cli` (binario `agent` en PATH) en plantillas JARVIS; requiere Cursor CLI instalado.
- **Ejecución CLI:** `skill-loop run` solo **tras OK explícito del usuario** en el YAML generado. Ver `install-skill-loop-runtime.sh`.
- **Router:** `skill-loop-router`. Doc: [docs/SKILL_LOOP_INTEGRATION.md](../../docs/SKILL_LOOP_INTEGRATION.md)
- **vs learning-loop:** skill-loop orquesta pasadas de trabajo; learning-loop captura aprendizajes — no confundir.
- `upstream: skill-loop:skill-loop`

### IRON LAW JARVIS

No ejecutar `skill-loop run` ni cron `schedule` sin aprobación del usuario. No usar `--dangerously-skip-permissions` ni flags equivalentes en YAML JARVIS. Tras `done`, cierre canónico con `session-learner-ops` + `verification-before-completion`.

---

# skill-loop

Use this skill for two cases:

- bootstrap skill-loop into a repository with a GitHub issue workflow
- write, simplify, or migrate `skill-loop.yml`

## Modes

- GitHub bootstrap: read `references/github-init.md`
- YAML authoring or migration: read `references/yaml-authoring.md`, then follow the selected pattern reference only

## Working style

- Keep the generated setup minimal.
- Prefer `tracker.repo` plus a small `skills:` graph.
- Prefer an `issue-check` entrypoint that uses `gh` to choose the next ready issue and complete the minimum setup before planning.
- Treat YAML authoring as pattern selection first, then concrete authoring.
- Reuse templates from `assets/` instead of writing large starter files from scratch.
- Default to `.agents/skills/` for generated starter skills unless the repository already uses another skill directory.

## Expected outputs

- create or update `skill-loop.yml`
- select the right workflow pattern before drafting YAML
- create starter skills only when the selected pattern actually needs them
- explain the execution flow in terms of the chosen pattern

## Validate
- YAML: validate one or more skill-loop YAML files against `schema.json`
- schema:https://raw.githubusercontent.com/takumiyoshikawa/skill-loop/refs/heads/main/schema.json
