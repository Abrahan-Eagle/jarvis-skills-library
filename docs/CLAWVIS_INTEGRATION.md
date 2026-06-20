# clawvis-openclaw — integración con jarvis-skills-library

Mapa de alineación entre la **library global** (canónica, Cursor) y **clawvis-openclaw** (runtime OpenClaw + dominio holding).

## Roles

| Repo | Rol | Consumo |
|------|-----|---------|
| [jarvis-skills-library](.) | Fuente canónica capa 0 | `bash scripts/install.sh` → `~/.cursor/skills/` |
| [clawvis-openclaw](https://github.com/Abrahan-Eagle/clawvis-openclaw) | OpenClaw + holding | Copias en `jarvis-ecosystem/agents/jarvis/skills/` |

OpenClaw **no** lee `~/.cursor/skills/`; clawvis mantiene copias físicas sincronizadas desde la library.

## Flujo bidireccional

```text
Skill genérica nueva en clawvis
  → generalizar en jarvis-skills-library
  → OVERLAY.md en clawvis (si holding/AG gates)
  → sync-global-skills-from-library.sh

Skill genérica nueva en library (Gentleman, etc.)
  → añadir al .global-sync-manifest en clawvis
  → sync-global-skills-from-library.sh
  → check-global-skills-sync.sh
```

Tras `git pull` en la library: re-ejecutar sync + check en clawvis.

## Manifest tiers (`agents/jarvis/skills/.global-sync-manifest`)

| Tier | Comportamiento |
|------|----------------|
| `passthrough` | Copia `SKILL.md` canónico desde library |
| `overlay` | Concat library `SKILL.md` + clawvis `OVERLAY.md` → `SKILL.md` destino |

Skills **solo clawvis** (no en manifest): `carousel-ops`, `proposal-ops`, wrappers CLI, marketing×40, `last30days-openclaw`, etc.

## Skills promovidas clawvis → library

| clawvis | library | Notas |
|---------|---------|-------|
| `llm-as-judge-ops` | `llm-as-judge-ops` | Base global; overlay clawvis = rúbricas marketing + AG gates |
| `scenario-analysis-ops` | `scenario-analysis-ops` | `upstream: clawvis`; overlay = Trello/dossiers |
| `strategic-briefing-ops` | `strategic-briefing-ops` | overlay = GOALS holding |
| `brainstorming-ops`, `deep-interview-ops`, … | adaptadas | overlay = contexto CEO/holding |

## Scripts clawvis

| Script | Uso |
|--------|-----|
| `scripts/sync-global-skills-from-library.sh` | Library → `agents/jarvis/skills/` |
| `scripts/check-global-skills-sync.sh` | Verifica manifest + hashes passthrough + OVERLAY presentes |
| `scripts/sync-jarvis-skills-from-repo.sh` | Repo clawvis → runtime OpenClaw del host |

Doc runtime: clawvis `docs/COHERENCIA_RUNTIME_REPO.md`.

## Qué NO sync

- Marketing profundo (`agents/marketing/skills/` — 40 skills)
- Infra MK37 (`planner`, `task-queue`, `memory-store` en `skills/global/`)
- Binarios third-party (`trello`, `slack`, `canva`, …)
