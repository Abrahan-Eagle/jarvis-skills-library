# SD-X Toolkits (JARVIS)

> Generado por `scripts/sync-sdx-registry.py` — 2026-06-18

Fuente: [`sdx-toolkit-registry.json`](sdx-toolkit-registry.json). Guía: [docs/SDX_ECOSYSTEM.md](../docs/SDX_ECOSYSTEM.md).

## Integrados

| ID | Nombre | SD-X | Pin | Skills JARVIS | Sync |
|----|--------|------|-----|---------------|------|
| github-spec-kit | GitHub Spec Kit | SD-Development, SD-Validate | v0.11.2 | speckit-*, sdd-router, sdd-x-index, speckit-lifecycle-router | `scripts/sync-spec-kit-skills.sh` |
| ui-ux-pro-max | UI UX Pro Max | SD-Design | v2.5.0 | ui-ux-pro-max, ui-router | `scripts/sync-ui-ux-pro-max.sh` |
| spec-kitty | Spec Kitty | SD-Development, SD-Validate, SD-Config | v3.2.1 | kitty-router, kitty-governance, using-git-worktrees | `pipx install spec-kitty-cli; spec-kitty init --ai cursor (en repo producto)` |

## Watchlist (awesome-spec-kits)

Ver [docs/AWESOME_SPEC_KITS.md](../docs/AWESOME_SPEC_KITS.md).

| ID | Nombre | SD-X | Pin | JARVIS | Nota |
|----|--------|------|-----|--------|------|
| spec-kit-extensions | Spec Kit Extensions (MartyBonacci) | SD-Development, SD-Maintenance | main | speckit-lifecycle-router · install: `scripts/install-spec-kit-extensions.sh --target <repo-producto>` | scripts/install-spec-kit-extensions.sh --target <repo-producto> |
| openspec | OpenSpec | SD-Development | 0.16.0 | openspec-router · install: `npm i -g @fission-ai/openspec; openspec init (en repo producto)` | npm i -g @fission-ai/openspec; openspec init (en repo producto) |
| open-design | Open Design (nexu-io) | SD-Design | 0.10.0 | open-design-router, open-design · install: `scripts/install-open-design-runtime.sh` | scripts/install-open-design-runtime.sh |
| strangeverse | StrangeVerse (Abrahan-Eagle) | SD-Research | main | scenario-router, strategic-briefing-ops, scenario-analysis-ops, strangeverse · install: `scripts/install-strangeverse-runtime.sh` | scripts/install-strangeverse-runtime.sh |
| mirofish | MiroFish (666ghj) | SD-Research | V0.1.2 | scenario-router, strategic-briefing-ops, scenario-analysis-ops, strangeverse | Referencia upstream AGPL; patrones en skills mesa; runtime operativo = strangeverse |
| ecc | Everything Claude Code (affaan-m) | SD-Config | v2.0.0 | ecc-router, ecc, continuous-learning-v2, security-review-ecc, configure-ecc · sync: `scripts/sync-ecc-skills.sh` · install: `scripts/install-ecc-runtime.sh` | scripts/install-ecc-runtime.sh |
| cyber-neo | Cyber Neo (Hainrixz) | SD-Validate | 9a8998a33534bca16c619f4956dd1935dc404620 | cyber-neo-router, cyber-neo, cyber-neo-cli · sync: `scripts/sync-cyber-neo-skill.sh` |  |
| learning-loop | Learning Loop (melodykoh) | SD-Maintenance | 948dc75bc5a771a57366c651c5d442b44cba214d | learning-loop-router, learning-loop · sync: `scripts/sync-learning-loop-skill.sh` |  |
| marketing-spec-kit | Marketing Spec Kit | SDM | 0.4.0 |  | SDM; evaluar para clawvis marketing |
| mcp-speckit | MCP Spec Kit | SD-Development | 0.1.0 |  | MCP lifecycle; evaluar para OpenClaw |
| meta-spec | MetaSpec | SD-Development, SD-Design | 0.9.7 |  | Framework Python; no distribución JARVIS |

## Referencias externas

| Nombre | URL | Nota |
|--------|-----|------|
| awesome-spec-kits | https://github.com/acnlabs/awesome-spec-kits | Catálogo SD-X; ver docs/AWESOME_SPEC_KITS.md |
| MetaSpec site | https://mataspec.figma.site/spec-kits | Documentación MetaSpec |
