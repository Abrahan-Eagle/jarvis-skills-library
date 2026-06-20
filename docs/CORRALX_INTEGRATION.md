# CorralX — integración con jarvis-skills-library

Mapa de alineación entre la **library global** (canónica) y **CorralX Backend / Frontend** (producto marketplace ganadero).

## Roles

| Repo | Rol | Consumo |
|------|-----|---------|
| [jarvis-skills-library](.) | Fuente canónica capa 0 | `bash scripts/install.sh` → `~/.cursor/skills/` |
| CorralX-Backend | API Laravel | `.agents/skills/` + manifest |
| CorralX-Frontend | App Flutter | `.agents/skills/` + manifest |

Cursor lee `~/.cursor/skills/` **y** `.agents/skills/` del repo abierto. CorralX versiona copias sincronizadas + overlays producto.

## Flujo bidireccional

```text
Skill genérica nueva en CorralX (reutilizable)
  → generalizar en jarvis-skills-library
  → OVERLAY.md en Backend/Frontend si contexto producto
  → sync-global-skills-from-library.sh en cada repo

Skill genérica nueva en library
  → añadir al .global-sync-manifest (Backend y/o Frontend)
  → sync + check en cada repo afectado
  → python3 .agents/skills/sync.sh (tablas AGENTS.md)
```

Tras `git pull` en la library: re-ejecutar sync + check en Backend y Frontend.

## Manifest tiers (`.agents/skills/.global-sync-manifest`)

| Tier | Comportamiento |
|------|----------------|
| `passthrough` | Copia `SKILL.md` canónico desde library |
| `overlay` | Concat library `SKILL.md` + `OVERLAY.md` local → `SKILL.md` destino |

## Skills solo CorralX (no en manifest)

- **Dominio:** `corralx-*` (API, UI, CRO, scenario producto)
- **Backend local:** `e2e-testing-patterns`, `github-actions-templates`, `frontend-design`, `security-requirement-extraction`
- **Frontend local:** `design-md`, `stitch-loop`, `remotion`, `react-components`, `enhance-prompt`, `shadcn-ui`
- **Variante dominio:** `corralx-llm-judge-ops` (Backend) — no sustituye global `llm-as-judge-ops`

## Overlays típicos

| Skill | Backend overlay | Frontend overlay |
|-------|-----------------|------------------|
| `jarvis-core` | Precedencia Laravel, `php artisan test`, migraciones | Precedencia Flutter, `flutter analyze` |
| `brainstorming-ops` | Módulos API, Sanctum | Pantallas, providers, KYC UI |
| `git-guardrails-ops` | Ramas `dev` / `main` CorralX | Igual |

## Scripts CorralX (por repo)

| Script | Uso |
|--------|-----|
| `scripts/sync-global-skills-from-library.sh` | Library → `.agents/skills/` |
| `scripts/check-global-skills-sync.sh` | Verifica manifest + hashes |
| `.agents/skills/sync.sh` | Regenera tablas AGENTS.md |

Doc producto: `MAINTENANCE_SKILLS.md` en cada repo CorralX.

## Qué NO sync

- Skills `corralx-*` (dominio exclusivo)
- Herramientas Stitch/React opcionales en Frontend
- Duplicar `corralx-llm-judge-ops` como global `llm-as-judge-ops`

## Paralelo clawvis

| | CorralX (Cursor) | clawvis-openclaw |
|--|------------------|------------------|
| Destino sync | `.agents/skills/` | `agents/jarvis/skills/` |
| Overlay contexto | Laravel / Flutter marketplace | Holding CEO / Trello |
| Doc | Este archivo | [CLAWVIS_INTEGRATION.md](CLAWVIS_INTEGRATION.md) |
