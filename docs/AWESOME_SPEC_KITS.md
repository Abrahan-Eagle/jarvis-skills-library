# Awesome Spec Kits — referencia JARVIS

Índice curado [acnlabs/awesome-spec-kits](https://github.com/acnlabs/awesome-spec-kits): filosofía **Spec-Driven X (SD-X)** — **Specs → AI → X** (código, diseño, docs, tests, configs, protocolos).

JARVIS **no** usa `metaspec install` para skills globales; distribuye vía `jarvis-skills-library` + `bash scripts/install.sh --all`.

Mapa operativo: skill `sdd-x-index`. Ecosistema: [SDX_ECOSYSTEM.md](SDX_ECOSYSTEM.md).

## speckits.json → estado JARVIS

Fuente upstream (5 entradas; el README del índice puede estar desactualizado):

| Speckit | Repo | sd_type | Pin (upstream) | Estado JARVIS |
|---------|------|---------|----------------|---------------|
| specify-cli | [github/spec-kit](https://github.com/github/spec-kit) | sdd | 0.0.22 | **Integrado** — `speckit-*`, `sdd-router` |
| openspec | [Fission-AI/OpenSpec](https://github.com/Fission-AI/OpenSpec) | sdd | 0.16.0 | **Router** — `openspec-router`; `openspec init` en producto |
| meta-spec | [ACNet-AI/MetaSpec](https://github.com/ACNet-AI/MetaSpec) | sds, sdd | 0.9.7 | **Referencia** — framework Python; no sync global |
| marketing-spec-kit | [ACNet-AI/marketing-spec-kit](https://github.com/ACNet-AI/marketing-spec-kit) | sdm | 0.4.0 | **Watchlist** — evaluar para clawvis marketing |
| mcp-speckit | [ACNet-AI/mcp-spec-kit](https://github.com/ACNet-AI/mcp-spec-kit) | sdd | 0.1.0 | **Watchlist** — evaluar para MCP / OpenClaw |

## agent-skills (Addy Osmani) — engineering lifecycle

| Pack | Repo | Tipo | Pin | Estado JARVIS |
|------|------|------|-----|---------------|
| agent-skills | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | engineering workflow | `36c543d` | **Router** — `agent-skills-router`; sync curado `doubt-driven-development`; resto → canónico JARVIS o pack externo |

Guía: [AGENT_SKILLS_ADDY_INTEGRATION.md](AGENT_SKILLS_ADDY_INTEGRATION.md). No reemplaza Spec Kit ni `jarvis-core`.

## Cómo elegir toolkit SD-Development

| Criterio | Spec Kit | Spec Kitty | OpenSpec |
|----------|----------|------------|----------|
| Repo ya tiene | `.specify/` | `.kittify/` | `openspec/` |
| Mejor para | Features nuevas con fases claras | Misiones paralelas + gates merge | Brownfield, iteración fluida |
| Zonix Pharma hoy | Sí (canónico) | No (sin migración) | No (sin init) |

## Integrar un speckit futuro

1. Evaluar overlap con routers existentes (no duplicar `speckit-*` sin necesidad)
2. Si requiere detección de repo: skill `*-router` en `skills/core/`
3. Entrada en `catalog/sdx-toolkit-registry.json` (integrado o `watchlist`)
4. `python3 scripts/sync-sdx-registry.py`
5. Documentar aquí y en `jarvis-skills-maintainer`
6. `bash scripts/validate-all.sh` + `install.sh --all`

## OpenSpec (resumen)

- Install producto: `npm install -g @fission-ai/openspec@latest` → `openspec init` → `openspec update`
- Flujo Cursor: `/opsx:propose` → `/opsx:apply` → `/opsx:archive`
- Router JARVIS: `openspec-router` (sin copiar comandos upstream al global)

## Enlaces

- [awesome-spec-kits](https://github.com/acnlabs/awesome-spec-kits)
- [GitHub Spec-Kit](https://github.com/github/spec-kit)
- [OpenSpec docs](https://github.com/Fission-AI/OpenSpec/tree/main/docs)
- [MetaSpec](https://github.com/ACNet-AI/MetaSpec)
