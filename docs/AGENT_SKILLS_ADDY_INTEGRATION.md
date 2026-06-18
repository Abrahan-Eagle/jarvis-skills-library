# Agent Skills (Addy Osmani) — integración JARVIS

[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (MIT) — 24 skills de ingeniería de producción (DEFINE→SHIP) + 4 personas + slash commands para Claude Code.

Skills JARVIS: `agent-skills-router` (decisión) + `doubt-driven-development` (sync curado upstream).

## Fuentes oficiales

- Repo: [github.com/addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- Pin JARVIS: `36c543d93b3f2bc0a3c01904c753121e56c105b1` (`ADDY_AGENT_SKILLS_REF` en `scripts/sync-addy-doubt-driven.sh`)
- Licencia: MIT
- Cursor setup upstream: [docs/cursor-setup.md](https://github.com/addyosmani/agent-skills/blob/main/docs/cursor-setup.md)

## vs JARVIS canónico

| Necesidad | Usar |
|-----------|------|
| Workflow módulo / honestidad / precedencia | **`jarvis-core`** (primero) |
| Spec / plan / tasks (repo `.specify/`) | `sdd-router` → `speckit-*` |
| TDD / implementación | `test-driven-development` + dominio `{producto}-*` |
| Debug / tests rojos | `systematic-debugging` |
| Review pre-merge | `code-review-playbook` |
| Seguridad OWASP / uploads | `security` |
| UI en código | `ui-router` |
| **Revisión adversarial in-flight (alta stakes)** | `agent-skills-router` → **`doubt-driven-development`** |
| Skill Addy sin curar (CI/CD, ADRs, observability) | Pack externo tras auditar — ver abajo |

## Arquitectura

```
Cursor (~/.cursor/skills vía install.sh)
  ├─ agent-skills-router
  └─ doubt-driven-development (sync skills/engineering/)
Runtime: Task subagent readonly (Step 3 DOUBT)
Pack externo opcional: clone/marketplace addyosmani/agent-skills
```

## Instalación

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install.sh --all
```

### Sync upstream (mantenedores)

```bash
bash scripts/sync-addy-doubt-driven.sh
python3 scripts/patch-addy-doubt-driven.py
bash scripts/smoke-addy-doubt-driven.sh
bash scripts/validate-all.sh
```

### Pack completo externo (opcional)

**No** copiar las 24 skills a `jarvis-skills-library` (overlap masivo).

- Claude Code: `/plugin marketplace add addyosmani/agent-skills` → `/plugin install agent-skills@addy-agent-skills`
- Cursor: preferir skills globales JARVIS; si necesitas una skill no curada, copia **solo** ese `SKILL.md` tras `validate-skills.sh` en el clone, o referencia el directorio `skills/` del clone local.

## Uso en Cursor

### Doubt-driven (curado)

| Frase (español) | Acción |
|-----------------|--------|
| "doubt-driven" / "revisión adversarial" | Cargar `doubt-driven-development` |
| "antes de commitear auth, duda adversarial" | Router → doubt cycle |
| "esto es irreversible, verifica con contexto fresco" | CLAIM → EXTRACT → Task DOUBT |
| "cross-model second opinion" | Ofrecer Gemini/Codex CLI (solo con OK usuario) |

### Cuándo **no** usar

- Renombres, formato, cambios de una línea obvios
- Review de PR ya terminado → `code-review-playbook`
- Cierre módulo → `session-learner-ops`

## Matriz overlap (24 skills)

| Skill Addy | JARVIS canónico | Acción JARVIS |
|------------|-----------------|---------------|
| `using-agent-skills` | `jarvis-core` | Referencia externa |
| `interview-me` | `deep-interview-ops` | No sync |
| `idea-refine` | `brainstorming-ops` | No sync |
| `spec-driven-development` | `speckit-specify`, `sdd-router` | No sync |
| `planning-and-task-breakdown` | `speckit-tasks`, `writing-plans` | No sync |
| `incremental-implementation` | `executing-plans`, `jarvis-core` | No sync |
| `test-driven-development` | `test-driven-development` | No sync (homónimo) |
| `context-engineering` | `handoff`, memoria `active_context` | No sync |
| `source-driven-development` | docs lookup / WebFetch | Watchlist |
| **`doubt-driven-development`** | — | **Sync + patch** |
| `frontend-ui-engineering` | `ui-router`, `ui-ux-pro-max` | No sync |
| `api-and-interface-design` | `api-design-principles`, dominio API | No sync |
| `browser-testing-with-devtools` | `webapp-testing`, MCP browser | Referencia |
| `debugging-and-error-recovery` | `systematic-debugging` | No sync |
| `code-review-and-quality` | `code-review-playbook` | No sync |
| `code-simplification` | post-review manual | Watchlist |
| `security-and-hardening` | `security`, `security-review-ecc` | No sync |
| `performance-optimization` | watchlist / dominio | Watchlist |
| `git-workflow-and-versioning` | `git-commit`, `git-guardrails-ops` | No sync |
| `ci-cd-and-automation` | CI repo producto | Watchlist |
| `deprecation-and-migration` | `speckit-lifecycle-router` | Watchlist |
| `documentation-and-adrs` | `documentar-avances`, walkthrough | Watchlist |
| `observability-and-instrumentation` | SRE / dominio | Watchlist |
| `shipping-and-launch` | deploy producto | Watchlist |

## Supply-chain

Antes de copiar cualquier `SKILL.md` del pack a un repo:

```bash
bash scripts/validate-skills.sh --check-net-exec <path-to-SKILL.md>
bash scripts/validate-skills.sh
```

Ver sección *AI Skill supply-chain* en skill `security`.

## Slash commands Addy (no en Cursor)

| Addy | JARVIS equivalente |
|------|-------------------|
| `/spec` | `speckit-specify` o `brainstorming-ops` |
| `/plan` | `speckit-plan` / `writing-plans` |
| `/build` | `speckit-implement` / TDD |
| `/test` | `verification-before-completion` |
| `/review` | `code-review-playbook` |
| `/code-simplify` | watchlist / refactor manual |
| `/ship` | `finishing-a-development-branch` + deploy producto |

## Enlaces

- [agent-skills-router](../skills/core/agent-skills-router/SKILL.md)
- [doubt-driven-development](../skills/engineering/doubt-driven-development/SKILL.md)
- [AWESOME_SPEC_KITS.md](AWESOME_SPEC_KITS.md) — watchlist entry
