# Forense ECC vs JARVIS — Resumen

**Fecha:** 2026-06-18  
**Repo analizado:** [affaan-m/ECC](https://github.com/affaan-m/ecc) (MIT, ~268 skills, 66 agents, hooks Cursor)  
**Objetivo:** Integrar ECC en `jarvis-skills-library` sin duplicar el catálogo completo ni romper precedencia JARVIS.

---

## Qué es ECC

Harness-native operator system: skills como superficie principal, instincts (continuous-learning-v2), hooks (sessionStart, beforeShellExecution, …), rules por idioma (`rules/common`, `rules/php`, …), agents prefijados `ecc-*`, CLI `ecc-universal` (`consult`, `install`, `doctor`, `repair`).

Flujo instincts (con hooks): observación sesión → instincts con confidence → `/evolve` agrupa en skills/commands.

## Hallazgos vs JARVIS global (75 skills)

### Solapamiento — JARVIS canónico

| Área ECC | Skill/agent ECC típico | JARVIS global | Decisión |
|----------|------------------------|---------------|----------|
| Workflow | planning, multi-* | `jarvis-core`, `task-pipeline-ops` | JARVIS |
| TDD | `tdd-workflow` | `test-driven-development` | JARVIS |
| Git | varios | `git-commit`, `git-guardrails-ops` | JARVIS |
| Review | `code-reviewer` agent | `code-review-playbook` | JARVIS |
| Plan | writing/plan skills | `writing-plans`, `executing-plans` | JARVIS |
| Cierre sesión | memory hooks | `session-learner-ops`, `context-updater`, `handoff` | JARVIS para cierre módulo |
| SDD producto | `search-first` | `sdd-router`, `speckit-*` | JARVIS |

### Complemento — ECC o sync curado

| Área | ECC | JARVIS |
|------|-----|--------|
| Instincts + evolve | `continuous-learning-v2`, homunculus | — (sync curado + opcional hooks) |
| OWASP checklist dedicado | `security-review` | `security` (sync como `security-review-ecc`) |
| Wizard install ECC | `configure-ecc` | `install-ecc-runtime.sh` + skill sync |
| Rules idioma en proyecto | `rules/php`, `rules/typescript` | install en repo, no global |
| AgentShield scan | `ecc-agentshield` | documentado, no vendorizado |
| `ecc consult` discovery | CLI | `ecc` bin wrapper |

### Solo runtime ECC (no en global)

- 265+ skills de dominio (ML, PM2, Laravel packs, …) — índice en `catalog/ecc-skills-index.md`
- 66 agents `ecc-*` en `.cursor/agents/` tras install
- Hooks en `.cursor/hooks.json` (opt-in)

## Qué se adoptó en jarvis-skills-library

| Artefacto | Función |
|-----------|---------|
| `ecc-router` | Precedencia harness vs JARVIS |
| `ecc` bin | Wrapper `ecc-universal` |
| `continuous-learning-v2` | Sync curado + overlay session-learner |
| `security-review-ecc` | Sync curado (nombre distinto de `security`) |
| `configure-ecc` | Sync curado wizard |
| `install-ecc-runtime.sh` | Install oficial `--target cursor` |
| `sync-ecc-manifest.py` | Índice upstream sin inflar CATALOG.md |

## Qué NO se adoptó

| Elemento | Razón |
|----------|-------|
| 268 skills en global | Mantenimiento + colisiones de nombre |
| `tdd-workflow`, `code-reviewer` sync | Duplica skills JARVIS |
| Hooks por defecto | Intrusiones; perfil `minimal` default |
| GitHub App ECC Tools | Billing externo; solo enlace en doc |
| Vendorizar agents/hooks en global | Instalan en `.cursor/` del repo producto |

## Riesgos operativos

1. **Duplicación:** ECC install en `.cursor/skills/` del repo + `~/.cursor/skills` JARVIS — Cursor mergea; evitar nombres idénticos en sync curado.
2. **Hooks globales:** `--with-hooks` modifica comportamiento de todas las sesiones en ese proyecto.
3. **Plugin + full install:** README ECC advierte duplicación; documentado en ECC_INTEGRATION.md.

## Patrones adoptados (referencia)

| Patrón ECC | Dónde en JARVIS |
|------------|-----------------|
| Router harness | `ecc-router` |
| Install script externo | `install-ecc-runtime.sh` (como Open Design / StrangeVerse) |
| Sync curado upstream | `sync-ecc-skills.sh` + `patch-ecc-skills.py` |
| Índice sin vendorizar | `catalog/ecc-skills-index.md` |

## Nota legal

ECC upstream MIT. Skills curados: overlay JARVIS UNLICENSED; contenido body desde upstream con atribución en `upstream: ecc:*`.
