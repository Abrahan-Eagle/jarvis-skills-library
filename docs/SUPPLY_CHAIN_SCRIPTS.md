# Supply-chain notes — jarvis-skills-library scripts

**Fecha:** 2026-07-10  
**Relacionado:** [FORENSE_LIBRARY_2026-07.md](FORENSE_LIBRARY_2026-07.md) P1-07 / P1-08 / P2-08–P2-12

## Pins

| Script family | Default pin | Helper |
|---------------|-------------|--------|
| `sync-cyber-neo-skill.sh` / `install-cyber-neo-upstream.sh` | SHA | `scripts/lib/git-pin.sh` |
| `sync-learning-loop-skill.sh` / `install-learning-loop-upstream.sh` | SHA | idem |
| `sync-skill-loop-skill.sh` / `install-skill-loop-upstream.sh` | SHA | idem |
| `sync-addy-doubt-driven.sh` | SHA | idem |
| `sync-claude-skills-skill-security-auditor.sh` | tag `v2.9.0` | idem |
| `sync-ecc-skills.sh` | tag `v2.0.0` (raw.githubusercontent) | curl pin |
| `install-open-design-runtime.sh` | **floats `main`** — WARN + pin via `OPEN_DESIGN_REF` | — |
| `install-strangeverse-runtime.sh` | **floats `main`** — WARN + pin via `STRANGEVERSE_REF` | — |
| `install-spec-kit-extensions.sh` | **floats `main`** — WARN + pin via `SPEC_KIT_EXT_REF` | — |

`jarvis_git_checkout_pin` **aborta** si fetch/checkout del pin falla (ya no `|| true`).

## Net-exec guard

`validate-skills.sh` escanea:

1. Todos los `skills/**/SKILL.md`
2. Todos los `scripts/**/*.{sh,py}`

Patrones bloqueados sin comentario `jarvis-allow-net-exec`:

- `curl|wget … | bash|sh`
- `bash <(curl|wget …)`

## CI lock gate

Workflow [`.github/workflows/validate-skills.yml`](../.github/workflows/validate-skills.yml):

- `validate-skills.sh` + `validate-yaml.py`
- Regenera `skills-lock.json` y falla si hay diff (lock stale)
