# gstack (Garry Tan) — integración JARVIS

[garrytan/gstack](https://github.com/garrytan/gstack) (MIT) — setup Claude Code: skills + browser/QA + hooks que simulan un equipo (CEO, Design, EM, Release, Docs, QA) en sprint Think→Ship→Reflect.

En JARVIS: **`gstack-router`** (decisión) + **cherry-picks** en skills canónicas. **No** hay sync masivo de `SKILL.md` upstream.

Forense: [GSTACK_FORENSE_JARVIS.md](GSTACK_FORENSE_JARVIS.md).

## Fuentes oficiales

- Repo: [github.com/garrytan/gstack](https://github.com/garrytan/gstack)
- Pin JARVIS (forense): `0530392821c277b95e5cd65aa9d9fda4248718b2` (`VERSION` 1.81.0.0)
- Licencia: MIT
- Instalador: `./setup` (Bun, Playwright/Aside, hooks en `~/.claude/settings.json`)

## vs JARVIS canónico

| Necesidad | Usar |
|-----------|------|
| Workflow / honestidad / precedencia | **`jarvis-core`** (primero) |
| Office hours / premisa / wedge | `deep-interview-ops` (+ modo startup) → `brainstorming-ops` |
| Plan CEO / modos de scope | `jarvis-experts` → `speckit-clarify` / `sdd-router` |
| Plan eng / tasks | `speckit-plan`, `writing-plans`, `fan-out-synthesize-ops` |
| Autoplan multi-perspectiva | `fan-out-synthesize-ops` + `parallel-judge-ops` + HITL (**no** `/autoplan` gstack) |
| Review | `code-review-playbook` (+ `parallel-judge-ops`) |
| Debug | `systematic-debugging` |
| QA browser / regresión | `webapp-testing` (WTF-likelihood) |
| CSO / AppSec | `cyber-neo-router` → `cyber-neo` |
| Verificación / “ship” | `verification-before-completion` → `work-unit-commits-ops` → `git-commit` → `branch-pr-ops` |
| Push / merge / deploy | **`git-guardrails-ops`** + orden explícita (+ `human-in-the-loop-ops`) |
| Careful / freeze | `git-guardrails-ops` + Cursor `create-hook` (gstack en Cursor **no** enforza hooks) |
| Retro / briefing | `strategic-briefing-ops`, `session-learner-ops`, `learning-loop` |
| Docs release | `docs-alignment-ops`, `documentar-avances` |
| Browse / scrape | Browser MCP del host / `webapp-testing` — **no** daemon gstack |
| Pack gstack instalado o pedido slash | **`gstack-router`** |

## Arquitectura JARVIS

```
Cursor (~/.cursor/skills vía install.sh)
  └─ gstack-router  →  cadena canónica JARVIS
Opcional (máquina personal, nunca .agents/skills de producto):
  ~/.claude/skills/gstack  o  ~/.cursor/skills/gstack-*  (./setup --host cursor --prefix)
```

## Instalación

### Library (recomendado)

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install.sh --all
```

### Pack externo (opcional, personal)

**No** copiar las 53+ skills a esta library (overlap + preámbulo Claude + colisiones `/review` `/ship` `/qa`).

```bash
git clone --depth 1 https://github.com/garrytan/gstack.git /tmp/gstack
cd /tmp/gstack
git checkout 0530392821c277b95e5cd65aa9d9fda4248718b2   # pin; no floating main
# Auditar antes:
python3 /var/www/html/proyectos/AIPP/jarvis-skills-library/skills/ops/skill-security-auditor/scripts/skill_security_auditor.py /tmp/gstack/office-hours
# Cursor (sin team mode, sin auto-upgrade, telemetría off):
./setup --host cursor --prefix
# Configurar: telemetry=off, team_mode=false, auto_upgrade=false
```

**Prohibido en producto:** team mode `required`, hooks `SessionStart` auto-pull, instalar bajo `.agents/skills/` del repo de producto.

## Mapa slash gstack → JARVIS

| Slash / pedido gstack | Cadena JARVIS | ¿Upstream gstack? |
|----------------------|---------------|-------------------|
| `/office-hours` | `deep-interview-ops` → `brainstorming-ops` → `jarvis-experts` | Permitido si instalado |
| `/plan-ceo-review` | `jarvis-experts` (scope modes) → `speckit-clarify` | Preferir JARVIS |
| `/plan-eng-review` | `speckit-plan` / `writing-plans` | Preferir JARVIS |
| `/plan-design-review` | `ui-router` → `ui-ux-pro-max` | Preferir JARVIS |
| `/autoplan` | `fan-out-synthesize-ops` + `parallel-judge-ops` + HITL | **Prohibido** tal cual |
| `/plan-tune` | — | **Prohibido** (auto-decide) |
| `/review` | `code-review-playbook` (+ `parallel-judge-ops`) | Preferir JARVIS |
| `/investigate` | `systematic-debugging` | Preferir JARVIS |
| `/qa` / `/qa-only` | `webapp-testing` | `qa-only` report-only OK si instalado |
| `/cso` | `cyber-neo-router` → `cyber-neo` | Permitido read-only si instalado |
| `/ship` | verification → work-unit commits → branch-pr; push solo con orden | **Prohibido** |
| `/land-and-deploy` | `git-guardrails-ops` + HITL | **Prohibido** |
| `/document-release` | `docs-alignment-ops` | Preferir JARVIS |
| `/retro` | `strategic-briefing-ops` / `session-learner-ops` | Permitido si instalado |
| `/learn` / context-save/restore | `context-updater`, `handoff`, `learning-loop`, Engram | Preferir JARVIS |
| `/browse` `/scrape` `/pair-agent` | MCP browser / `webapp-testing` | **Prohibido** cookies/pair/daemon |
| `/careful` `/freeze` `/guard` | `git-guardrails-ops` + `create-hook` | Solo prosa en Cursor vía gstack |
| `/codex` | `doubt-driven-development` / juez cross-model | Opcional |
| `/benchmark` `/health` `/canary` | briefing / dominio producto | Router-only |
| iOS / GBrain / design-shotgun | — | Fuera de alcance |

## Supply-chain

Antes de cualquier clone/setup local:

1. `skill-security-auditor` sobre skills/scripts que se vayan a enlazar.
2. `bash scripts/validate-skills.sh` / flags net-exec del repo JARVIS si aplica.
3. Pin SHA; **no** confiar en `main` flotante ni en auto-upgrade SessionStart.
4. Revisar: `sudo` en setup, telemetría, cookie import, ngrok.

## Uso en Cursor

| Frase | Acción |
|-------|--------|
| "gstack" / "garry tan" / "/office-hours" / "/ship" / "be careful" | Cargar **`gstack-router`** |
| "ship it" | Cadena JARVIS de verificación+PR; **preguntar** antes de push |
| "freeze este módulo" | Declarar scope + no editar fuera; ofrecer hook Cursor |

### Cuándo no usar el pack externo

- Producto compartido / CI de equipo
- Cualquier flujo que implique push/merge automático
- Necesidad de careful/freeze **mecánico** en Cursor (usar `create-hook`, no gstack)

## Watchlist

Revisar trimestral el pin SHA y CHANGELOG (Aside driver, telemetría, hooks). Entrada en [AWESOME_SPEC_KITS.md](AWESOME_SPEC_KITS.md).
