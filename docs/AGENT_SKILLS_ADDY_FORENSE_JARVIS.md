# Forense Agent Skills (Addy Osmani) vs JARVIS — Resumen

**Fecha:** 2026-06-18  
**Repo analizado:** [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (MIT, 24 skills + 4 personas + slash commands)  
**Pin JARVIS:** `36c543d93b3f2bc0a3c01904c753121e56c105b1`  
**Objetivo:** Integrar valor único sin vendorizar el pack completo ni conflictuar con `jarvis-core` / `speckit-*`.

---

## Qué es el pack

Ciclo DEFINE→SHIP (spec, plan, build, test, review, ship) con skills opinionadas (Google eng practices), anti-racionalización tables y verification gates. Diseñado para Claude Code (`/spec`, `/build`, marketplace plugin) y portable a Cursor copiando `SKILL.md`.

## Hallazgos vs JARVIS global

### Solapamiento — JARVIS canónico (no sync)

| Skill Addy | JARVIS global |
|------------|---------------|
| `using-agent-skills` | `jarvis-core` |
| `interview-me` | `deep-interview-ops` |
| `idea-refine` | `brainstorming-ops` |
| `spec-driven-development` | `speckit-specify`, `sdd-router` |
| `planning-and-task-breakdown` | `speckit-tasks`, `writing-plans` |
| `incremental-implementation` | `executing-plans`, `jarvis-core` |
| `test-driven-development` | homónimo JARVIS |
| `debugging-and-error-recovery` | `systematic-debugging` |
| `code-review-and-quality` | `code-review-playbook` |
| `security-and-hardening` | `security`, `security-review-ecc` |
| `git-workflow-and-versioning` | `git-commit`, `git-guardrails-ops` |
| `frontend-ui-engineering` | `ui-router`, `ui-ux-pro-max` |

### Gap real — adoptado

| Skill Addy | Decisión JARVIS |
|------------|-----------------|
| **`doubt-driven-development`** | Sync + patch Cursor (`Task` readonly, subagents) |

Revisión adversarial **in-flight** (CLAIM→EXTRACT→DOUBT→RECONCILE→STOP), distinta de review post-merge.

### Watchlist (doc only)

`code-simplification`, `source-driven-development`, `performance-optimization`, CI/CD, ADRs, observability, shipping — referencia en [AGENT_SKILLS_ADDY_INTEGRATION.md](AGENT_SKILLS_ADDY_INTEGRATION.md) o pack externo tras auditar.

## Supply-chain

- Fuente reputada (MIT); **no** implica auditar menos: `validate-skills.sh` en cualquier copia local.
- Guard `check_net_exec` en library cubre `SKILL.md` del pack curado.
- No instalar las 24 skills en masa: overlap + precedencia con `jarvis-core`.

## Qué se adoptó en jarvis-skills-library

| Artefacto | Función |
|-----------|---------|
| `agent-skills-router` | Precedencia pack vs canónico vs doubt-driven |
| `doubt-driven-development` | Skill sync upstream + overlay JARVIS |
| `sync-addy-doubt-driven.sh` | Fetch pin + patch + cleanup tmp |
| `patch-addy-doubt-driven.py` | Frontmatter, Cursor Task, IRON LAW |
| `smoke-addy-doubt-driven.sh` | Overlay + net-exec smoke |
| `docs/AGENT_SKILLS_ADDY_INTEGRATION.md` | Guía operativa |
| Entrada `sdx-toolkit-registry.json` | SD-Validate toolkit |

## Qué NO se adoptó (correcto)

- Slash commands `/spec`, `/build`, `/review` en Cursor (→ `speckit-*`, `code-review-playbook`)
- Personas `agents/` como globales (→ subagents Cursor bajo demanda)
- Sync de las 23 skills restantes

## Cruces operativos

| Momento | Skill |
|---------|-------|
| In-flight alta stakes | `doubt-driven-development` |
| Review pre-merge | `code-review-playbook` |
| RED conductual | `test-driven-development` |
| Auditoría repo OWASP | `cyber-neo-router` |
| Instalar skill externa | `security` supply-chain + `validate-skills.sh` |

Guía: [AGENT_SKILLS_ADDY_INTEGRATION.md](AGENT_SKILLS_ADDY_INTEGRATION.md)
