# AGENTS.md — JARVIS Skills Library

> Repositorio **solo skills globales**. No contiene código de producto (CorralX, Zonix, clawvis, etc.).

## Para agentes IA

1. **Leer este archivo** al trabajar en este repo.
2. **Skills de dominio** del producto activo: buscar en el repo del producto (`AGENTS.md` → `.agents/skills/`).
3. **Skills globales** (este repo): instalar con `bash scripts/install.sh` → `~/.cursor/skills/<name>/`.
4. **Onboarding producto:** escribir **`init jarvis`** en Cursor Agent o `bash scripts/init-jarvis.sh` — [docs/PROJECT_ONBOARDING.md](docs/PROJECT_ONBOARDING.md) + skill `project-bootstrap-ops`.

## Cuándo crear skill aquí vs en un producto

| Criterio | Aquí (global) | En producto (`.agents/skills/`) |
|----------|---------------|----------------------------------|
| Útil en cualquier stack/proyecto | Sí | No |
| Nombre con prefijo de producto | No | Sí (`corralx-*`, `zonix-*`) |
| Lógica de negocio exclusiva | No | Sí |
| Proceso JARVIS / git / review / TDD | Sí | No (importar global) |
| Spec-Driven Development (Spec Kit) | Sí (10 `speckit-*`, routers + `speckit-lifecycle-router`) | Dominio en implement |

## Comandos

```bash
bash scripts/validate-all.sh
python3 scripts/sync-catalog.py
python3 scripts/sync-lock.py
bash scripts/install.sh --all
bash scripts/sync-spec-kit-skills.sh   # refresh speckit-* from github/spec-kit
python3 skills/engineering/skill-creator/scripts/init_skill.py <name> --path skills/<categoria>
```

## Catálogo

Índice completo: [catalog/CATALOG.md](catalog/CATALOG.md)

## Spec-Driven Development

Ver [docs/SDD_SPECKIT_INTEGRATION.md](docs/SDD_SPECKIT_INTEGRATION.md), [docs/PROJECT_ONBOARDING.md](docs/PROJECT_ONBOARDING.md), [docs/SPEC_KIT_EXTENSIONS.md](docs/SPEC_KIT_EXTENSIONS.md), [docs/OPEN_DESIGN_INTEGRATION.md](docs/OPEN_DESIGN_INTEGRATION.md), [docs/STITCH_UPSTREAM.md](docs/STITCH_UPSTREAM.md), [docs/STRANGEVERSE_INTEGRATION.md](docs/STRANGEVERSE_INTEGRATION.md), [docs/MIROFISH_UPSTREAM.md](docs/MIROFISH_UPSTREAM.md), [docs/ECC_INTEGRATION.md](docs/ECC_INTEGRATION.md), [docs/CYBER_NEO_INTEGRATION.md](docs/CYBER_NEO_INTEGRATION.md), [docs/KALMAN_ANOMALY_INTEGRATION.md](docs/KALMAN_ANOMALY_INTEGRATION.md), [docs/LEARNING_LOOP_INTEGRATION.md](docs/LEARNING_LOOP_INTEGRATION.md), [docs/SKILL_LOOP_INTEGRATION.md](docs/SKILL_LOOP_INTEGRATION.md), [docs/GENTLE_AI_LOOP_INTEGRATION.md](docs/GENTLE_AI_LOOP_INTEGRATION.md), [docs/GENTLEMAN_ECOSYSTEM_INTEGRATION.md](docs/GENTLEMAN_ECOSYSTEM_INTEGRATION.md), [docs/ENGRAM_INTEGRATION.md](docs/ENGRAM_INTEGRATION.md), [docs/AGENT_SKILLS_ADDY_INTEGRATION.md](docs/AGENT_SKILLS_ADDY_INTEGRATION.md), [docs/CLAUDE_SKILLS_REZVANI_INTEGRATION.md](docs/CLAUDE_SKILLS_REZVANI_INTEGRATION.md), [docs/LOOP_AI_ECOSYSTEM.md](docs/LOOP_AI_ECOSYSTEM.md), [docs/AWESOME_SPEC_KITS.md](docs/AWESOME_SPEC_KITS.md) y skills `sdd-router`, `kitty-router`, `openspec-router`, `speckit-lifecycle-router`, `open-design-router`, `stitch-router`, `ecc-router`, `cyber-neo-router`, `kalman-anomaly-router`, `learning-loop-router`, `skill-loop-router`, `engram-router`, `agent-skills-router`, `claude-skills-router`, `skill-security-auditor`, `human-in-the-loop-ops`, `scenario-router`, `strategic-briefing-ops`.

## Precedencia operativa

Ver skill `jarvis-core` (`skills/core/jarvis-core/SKILL.md`) — cadena JARVIS y Spec Kit por fase.

## Auto-invoke global (referencia)

| Acción | Skill |
|--------|-------|
| **init jarvis** / integrar JARVIS en proyecto | `project-bootstrap-ops` |
| Tarea no trivial | `jarvis-experts` |
| Nueva feature de producto | `sdd-router` / `kitty-router` / `openspec-router` según marcador de repo |
| Nueva feature de producto con Spec Kit | `speckit-specify`, `speckit-plan` |
| Bugfix / hotfix / refactor (`.specify/`) | `speckit-lifecycle-router` |
| Iniciar módulo (sin Spec Kit) | `jarvis-core`, `brainstorming-ops`, `task-pipeline-ops` |
| Planificar | `writing-plans`, `executing-plans` o `speckit-plan` |
| Implementar Spec Kit | `speckit-implement` (solo OK usuario) + dominio producto |
| Tasks → GitHub Issues | `speckit-taskstoissues` (opcional, OK usuario + remote GitHub) |
| Diseñar UI/UX (código en repo) | `ui-router` + dominio + `ui-ux-pro-max` |
| Prototipo web Google Stitch (MCP) | `stitch-router` → `npx skills add` upstream |
| Carrusel, deck, email HTML (standalone) | `open-design-router`, `open-design` |
| Landing con media generativa IA (video hero loop, Nano Banana + Veo/Kling + Claude Design/Code) | `ai-media-landing-ops` |
| Briefing estratégico / estado general | `strategic-briefing-ops` |
| What-if / escenarios / simulación social | `scenario-router`, `scenario-analysis-ops`, `strangeverse` |
| Harness ECC (hooks, instincts, rules) | `ecc-router`, `ecc`, `configure-ecc` |
| Auditoría seguridad profunda (read-only) | `cyber-neo-router`, `cyber-neo`, `cyber-neo-cli` |
| Diseño defensa runtime / spikes / DDoS | `kalman-anomaly-router`, `kalman-anomaly-defense` |
| Scan/wrap-up aprendizajes sesión | `learning-loop-router`, `learning-loop` |
| Diseñar loop de agente (loop vs prompt, conciso/controlado) | `agent-loop-engineering` |
| Verificación adversarial paralela / "día del juicio" | `parallel-judge-ops` |
| Auditoría automática pre-gate (LLM-as-judge, rúbrica + score) | `llm-as-judge-ops` |
| Loop autónomo / gates HITL/HOTL | `human-in-the-loop-ops` (+ `skill-loop-router` si YAML) |
| Decisión no trivial alta stakes (auth, prod, irreversible) | `agent-skills-router`, `doubt-driven-development` (opcional in-flight; complementa review/TDD) |
| Auditar skill externa antes de instalar | `claude-skills-router`, `skill-security-auditor` (+ `validate-skills.sh`) |
| Gobernanza humana irreversible (push, deploy, publicación) | `human-in-the-loop-ops`, `git-guardrails-ops` |
| Debug | `systematic-debugging` |
| Commit | `verification-before-completion`, `work-unit-commits-ops`, `git-commit` |
| PR >400 líneas / stacked PRs | `chained-pr-ops` |
| Crear o preparar PR | `branch-pr-ops` |
| Memoria persistente MCP (Engram) | `engram-router` → `engram-memory-protocol` |
| Triage backlog issues/PRs | `backlog-triage-ops` |
| Docs deben igualar código | `docs-alignment-ops` |
| Docs/PR con baja carga cognitiva (README, RFC, onboarding) | `cognitive-doc-design-ops` |
| Comentarios humanos (PR, issue, review, Slack) | `comment-writer-ops` |
| Push/merge | `git-guardrails-ops` (solo con orden explícita del usuario) |
| Code review | `code-review-playbook` |
| Cerrar sesión | `context-updater`, `session-learner-ops` |

Los productos referencian esta tabla en su `AGENTS.md`; no copiar el contenido de cada `SKILL.md` global al repo del producto.

## Sync producto tras cambio global

Tras commit en **jarvis-skills-library** que afecte skills del manifest de producto:

| Producto | Acción |
|----------|--------|
| clawvis-openclaw | `sync-global-skills-from-library.sh` + `check-global-skills-sync.sh` — [CLAWVIS_INTEGRATION.md](docs/CLAWVIS_INTEGRATION.md) |
| CorralX Backend + Frontend | `./scripts/sync-all-corralx-skills.sh` en cualquier repo — [CORRALX_INTEGRATION.md](docs/CORRALX_INTEGRATION.md) |

Ver también skill `jarvis-skills-maintainer` (secciones clawvis y CorralX).

---

**Última actualización:** Junio 2026
