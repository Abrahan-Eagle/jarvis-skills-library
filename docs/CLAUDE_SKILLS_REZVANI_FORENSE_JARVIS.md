# Forense Claude Skills (Rezvani) vs JARVIS — Resumen

**Fecha:** 2026-06-18  
**Repo analizado:** [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) (MIT, 345+ skills, v2.9.0)  
**Pin JARVIS:** tag `v2.9.0` → commit `0d78fd835a0136988f4df2fe75d1e6295b4ef4d7` (skill-security-auditor sync)  
**Objetivo:** Integrar valor único sin vendorizar el megapack ni conflictuar con `jarvis-core`.

---

## Qué es el pack

Biblioteca masiva multi-dominio: engineering (core + POWERFUL), product, marketing (46), compliance, C-level (66), research-ops, productivity. Incluye 579 scripts Python stdlib, personas, orchestration protocol y conversión multi-tool (`convert.sh`).

## Hallazgos vs JARVIS global

### Gap real — sync curado

| Skill upstream | Gap JARVIS | Acción |
|----------------|------------|--------|
| **`skill-security-auditor`** | `validate-skills.sh` (net-exec) + checklist `security` — sin auditor estático PASS/WARN/FAIL con CLI | **Sync + patch** → `skills/ops/skill-security-auditor/` |

### Overlap — canónico JARVIS (no sync)

| Dominio Rezvani | Ejemplos | JARVIS canónico |
|-----------------|----------|-----------------|
| Engineering core | senior-architect, QA, DevOps | `laravel-specialist`, dominio `{producto}-*`, CI repo |
| Engineering POWERFUL | pr-review-expert, ci-cd-pipeline-builder, git-worktree-manager | `code-review-playbook`, `using-git-worktrees`, CI producto |
| Matt Pocock en pack | grill-me, grill-with-docs, handoff | `doubt-driven-development`, `handoff` |
| Product | code-to-prd, landing-page-generator | `speckit-specify`, `ui-router`, dominio UI |
| TDD / debug | (varios) | `test-driven-development`, `systematic-debugging` |
| Security app | security-auditor (app) | `security`, `cyber-neo-router` |

### Watchlist — overlap parcial

| Item | Notas | JARVIS |
|------|-------|--------|
| **`autoresearch-agent`** | Plugin `/ar:loop`, evaluadores, `results.tsv`, un cambio por iteración | `skill-loop-router` + `human-in-the-loop-ops` + TDD; no portable a Cursor sin slash Claude Code |
| `self-improving-agent` | Auto-memory curation | `learning-loop-router`, `continuous-learning-v2` |
| `playwright-pro` | E2E toolkit | Zonix skills locales; `webapp-testing` global |
| `ralph-loop` (externo) | Docker dev loop | Ver [LOOP_AI_ECOSYSTEM.md](LOOP_AI_ECOSYSTEM.md) |

### Dominio producto — no global library

| Dominio | Skills (aprox.) | Destino recomendado |
|---------|-----------------|---------------------|
| Marketing pods | 46 (SEO, AEO, CRO, content…) | `clawvis-openclaw` marketing skills |
| C-level advisory | 66 (CEO/CTO/CFO/…) | `jarvis-experts`, `zonix-lanzamiento-roles` |
| Regulatory / QM | ra-qm-team, compliance-os | Zonix regulatorio, clawvis compliance |
| Finance / commercial | SaaS metrics, deal desk | `zonix-financial-model`, lanzamiento docs |
| Research academic | litreview, grants, patent | Watchlist; no dev diario |

### Descartado

| Item | Por qué |
|------|---------|
| `scripts/convert.sh` → 345 `.mdc` en producto | Ruido masivo; usar skills globales JARVIS |
| Personas `agents/personas/*` globales | Usar subagents Cursor + `jarvis-experts` |
| OpenClaw install script remoto | Supply-chain risk sin auditoría previa |

## autoresearch-agent vs skill-loop

| Aspecto | autoresearch-agent (Rezvani) | JARVIS |
|---------|------------------------------|--------|
| Runtime | Claude Code `/ar:*` | Cursor: `skill-loop run` + OK usuario |
| Señal éxito | Evaluador custom + KEEP/DISCARD | Tests, lint, `verification-before-completion` |
| Gobernanza | Cron interval usuario | `human-in-the-loop-ops` |
| Persistencia | `results.tsv`, git branch | handoff, `active_context`, walkthrough |

**Decisión:** documentar en [LOOP_AI_ECOSYSTEM.md](LOOP_AI_ECOSYSTEM.md); no sync del plugin.

## Entregables JARVIS

| Artefacto | Ruta |
|-----------|------|
| Router | `skills/core/claude-skills-router/SKILL.md` |
| Skill curada | `skills/ops/skill-security-auditor/` |
| Integración | `docs/CLAUDE_SKILLS_REZVANI_INTEGRATION.md` |
| Registry | `catalog/sdx-toolkit-registry.json` → `claude-skills-rezvani` |

## Criterio “no vendorizar 345”

El 90%+ del pack duplica workflows ya gobernados por `jarvis-core` + `speckit-*` + skills dominio. Mantener **un** skill meta (`skill-security-auditor`) permite auditar cualquier skill del pack (o de la comunidad) antes de instalar, sin inflar `~/.cursor/skills` ni duplicar mantenimiento.
