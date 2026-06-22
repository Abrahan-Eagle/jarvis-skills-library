# Zonix Pharma — integración con jarvis-skills-library

Mapa de alineación entre la **library global** y **ZonixPharma Backend / Front** (marketplace farmacéutico VE).

## Repos

| Repo | Ruta (ejemplo) | Rol |
|------|----------------|-----|
| [jarvis-skills-library](../) | `/var/www/html/proyectos/AIPP/jarvis-skills-library` | Capa 0 canónica |
| ZonixPharma-Backend | `ZonixPharma-Backend/` | Laravel API, skills `zonix-*` canon, Spec Kit hub |
| ZonixPharma-Front | `ZonixPharma-Front/` | Flutter espejo |

Canon workspace: `ZonixPharma-Backend/docs/ZONIX_WORKSPACE.md`.

## Onboarding

```bash
bash scripts/install.sh --all                    # Capa 0 — desde raíz jarvis-skills-library
bash scripts/init-jarvis.sh --min c              # verifica Paso A+B+C por repo abierto
```

En cada repo Zonix tras pull en library:

```bash
./scripts/sync-global-skills-from-library.sh
./scripts/check-global-skills-sync.sh
python3 .agents/skills/sync.sh
```

**Onboarding máquina (rutas absolutas, desde cualquier cwd):**

```bash
bash /var/www/html/proyectos/AIPP/jarvis-skills-library/scripts/install.sh --all
```

## Manifest tiers

| Tier | Comportamiento |
|------|----------------|
| `passthrough` | Copia `SKILL.md` canónico |
| `overlay` | Library + `OVERLAY.md` local |

## Skills solo Zonix (no en manifest)

- **Dominio:** `zonix-*` (~27 Backend, ~18 Front stubs)
- **Backend local:** `documentar-avances`, `ui-ux-pro-max` (ZONIX.md capa 5)
- **Front local:** Stitch/React, `playwright-skill`, etc.
- **Spec Kit:** core global `~/.cursor/skills/speckit-*` (`install.sh --all`); complementa `zonix-*`

## Diferencias vs CorralX

| Tema | CorralX | Zonix |
|------|---------|-------|
| Spec Kit | No `.specify/` | **Activo** — `sdd-router` + `speckit-*` |
| Panel routing | Solo `jarvis-experts` | `jarvis-experts` + `zonix-jarvis-subagents-map` |
| Lanzamiento/inversor | N/A | `zonix-lanzamiento-docs` (no Spec Kit) |
| ui-ux-pro-max manifest | Solo Front | Front overlay; Backend opcional local |

## Overlays típicos

| Skill | Backend | Front |
|-------|---------|-------|
| `jarvis-core` | Spec Kit + `zonix-api-patterns` | `ui-router` → `zonix-ui-design` |
| `ui-ux-pro-max` | N/A (local ZONIX.md) | `OVERLAY.md` → BRAND + `zonix-ui-design` |
| `git-guardrails-ops` | Ramas `dev` / `main` Zonix | Igual |

Doc producto: `ZonixPharma-Backend/docs/ZONIX_JARVIS_INTEGRATION.md`.
