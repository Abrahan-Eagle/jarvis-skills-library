---
name: jarvis-skills-maintainer
description: >
  Mantenimiento de jarvis-skills-library: crear, validar, catalogar, lockear e instalar skills globales.
  Trigger: Trabajar en jarvis-skills-library, crear skill global, validar catálogo, instalar en Cursor/Claude.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: core
  auto_invoke:
    - "Mantener biblioteca de skills globales"
    - "Crear skill global"
  triggers: jarvis-skills, skill library, install skills, sync-catalog
  related-skills:
    - jarvis-core
    - skill-creator
    - verification-before-completion
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# JARVIS Skills Maintainer

Procedimiento para este repositorio (`jarvis-skills-library`). No usar para skills de dominio en productos.

## Crear skill nueva

```bash
python3 skills/engineering/skill-creator/scripts/init_skill.py <nombre> --path skills/<categoria>
# Editar skills/<categoria>/<nombre>/SKILL.md
```

Categorías: `core`, `sdd`, `ops`, `engineering`, `git`, `review`, `planning`, `backend`, `mobile`, `ui`, `non-code`.

## Actualizar Spec Kit (speckit-*)

```bash
bash scripts/sync-spec-kit-skills.sh   # pin SPEC_KIT_TAG=v0.11.2; merge upstream + overlays
bash scripts/validate-all.sh
```

`sync-spec-kit-skills.sh` ejecuta `patch-speckit-frontmatter.py` al final (frontmatter JARVIS, H1, sección `JARVIS Integration` en skills críticas).

Ver [docs/SDD_SPECKIT_INTEGRATION.md](../docs/SDD_SPECKIT_INTEGRATION.md).

## Actualizar UI UX Pro Max

```bash
bash scripts/sync-ui-ux-pro-max.sh   # pin UI_UX_TAG=v2.5.0
bash scripts/validate-all.sh
```

Ver [docs/UI_UX_PRO_MAX_INTEGRATION.md](../docs/UI_UX_PRO_MAX_INTEGRATION.md).

## Spec Kitty (complemento Spec Kit)

No sincronizar comandos kitty al global — `spec-kitty init --ai cursor` los instala en el repo producto.

1. Skills globales: `kitty-router`, `kitty-governance` (ya en `skills/core/` y `skills/sdd/`)
2. Entrada en `catalog/sdx-toolkit-registry.json` + `python3 scripts/sync-sdx-registry.py`
3. Documentar en [docs/SPEC_KITTY_INTEGRATION.md](../docs/SPEC_KITTY_INTEGRATION.md) y [docs/SDX_ECOSYSTEM.md](../docs/SDX_ECOSYSTEM.md)

Zonix y otros productos con `.specify/` **no migrar** sin decisión explícita.

## Spec Kit Extensions (lifecycle)

Workflows community bugfix/modify/refactor/hotfix/deprecate — skill `speckit-lifecycle-router` (v1.1: quality gates, bash fallback, fases JARVIS).

Install en repo producto:

```bash
bash scripts/install-spec-kit-extensions.sh --target /path/to/product-repo
```

Manual: [docs/SPEC_KIT_EXTENSIONS.md](../docs/SPEC_KIT_EXTENSIONS.md). Entrada en `watchlist` de `sdx-toolkit-registry.json`.

## Open Design (artefactos agentic)

Fábrica visual [nexu-io/open-design](https://github.com/nexu-io/open-design) — skills `open-design-router` + `open-design` (bin HTTP).

```bash
bash scripts/install-open-design-runtime.sh
```

Doc: [docs/OPEN_DESIGN_INTEGRATION.md](../docs/OPEN_DESIGN_INTEGRATION.md). Watchlist `sdx-toolkit-registry.json`. OpenClaw: stack en clawvis (no duplicar).

## StrangeVerse (simulación multi-agente)

Fork [Abrahan-Eagle/strangeverse](https://github.com/Abrahan-Eagle/strangeverse) — skills `scenario-router` + `strategic-briefing-ops` + `scenario-analysis-ops` + `strangeverse` (bin HTTP).

```bash
bash scripts/install-strangeverse-runtime.sh
```

Doc: [docs/STRANGEVERSE_INTEGRATION.md](../docs/STRANGEVERSE_INTEGRATION.md). Upstream: [docs/MIROFISH_UPSTREAM.md](../docs/MIROFISH_UPSTREAM.md). Watchlist `sdx-toolkit-registry.json`. AGPL: solo API; no copiar código del fork al global.

## MiroFish upstream (referencia)

Upstream [666ghj/MiroFish](https://github.com/666ghj/MiroFish) (AGPL-3.0, pin V0.1.2) — patrones en `strategic-briefing-ops` y `scenario-analysis-ops`; runtime operativo = StrangeVerse. Doc: [docs/MIROFISH_UPSTREAM.md](../docs/MIROFISH_UPSTREAM.md). Entrada watchlist en `sdx-toolkit-registry.json`.

## ECC (harness Cursor)

[affaan-m/ecc](https://github.com/affaan-m/ecc) (MIT) — skills `ecc-router` + `ecc` (bin CLI) + curated: `continuous-learning-v2`, `security-review-ecc`, `configure-ecc`.

```bash
bash scripts/install-ecc-runtime.sh --project-dir /path/to/product-repo
bash scripts/sync-ecc-skills.sh
python3 scripts/sync-ecc-manifest.py
```

Doc: [docs/ECC_INTEGRATION.md](../docs/ECC_INTEGRATION.md), forense [docs/ECC_FORENSE_JARVIS.md](../docs/ECC_FORENSE_JARVIS.md). Índice upstream: `catalog/ecc-skills-index.md`. Perfil `minimal` default (sin hooks).

## Cyber Neo (auditoría seguridad)

[Hainrixz/cyber-neo](https://github.com/Hainrixz/cyber-neo) (MIT) — skills `cyber-neo-router` + `cyber-neo` (ops sync) + `cyber-neo-cli` (bin).

```bash
bash scripts/sync-cyber-neo-skill.sh
bash scripts/install-cyber-neo-upstream.sh   # opcional ~/cyber-neo
```

Doc: [docs/CYBER_NEO_INTEGRATION.md](../docs/CYBER_NEO_INTEGRATION.md), forense [docs/CYBER_NEO_FORENSE_JARVIS.md](../docs/CYBER_NEO_FORENSE_JARVIS.md). Pin: `9a8998a33534bca16c619f4956dd1935dc404620`.

## Agent Skills (Addy Osmani)

[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (MIT) — router + sync curado de `doubt-driven-development` solamente (23 skills restantes → canónico JARVIS o pack externo).

```bash
bash scripts/sync-addy-doubt-driven.sh   # pin 36c543d…; encadena patch
bash scripts/smoke-addy-doubt-driven.sh
```

Doc: [docs/AGENT_SKILLS_ADDY_INTEGRATION.md](../docs/AGENT_SKILLS_ADDY_INTEGRATION.md), forense [docs/AGENT_SKILLS_ADDY_FORENSE_JARVIS.md](../docs/AGENT_SKILLS_ADDY_FORENSE_JARVIS.md). Entrada en `sdx-toolkit-registry.json`.

## Claude Skills (Alireza Rezvani)

[alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) (MIT v2.9.0) — router + sync curado de `skill-security-auditor` solamente (344 skills restantes → canónico JARVIS o pack externo).

```bash
bash scripts/sync-claude-skills-skill-security-auditor.sh   # pin v2.9.0; encadena patch
bash scripts/smoke-claude-skills-skill-security-auditor.sh
```

Doc: [docs/CLAUDE_SKILLS_REZVANI_INTEGRATION.md](../docs/CLAUDE_SKILLS_REZVANI_INTEGRATION.md), forense [docs/CLAUDE_SKILLS_REZVANI_FORENSE_JARVIS.md](../docs/CLAUDE_SKILLS_REZVANI_FORENSE_JARVIS.md). Entrada `claude-skills-rezvani` en `sdx-toolkit-registry.json`.

## Loop AI (gobernanza HITL — skill local)

Marco de ingeniería de ciclos y gobernanza humana — skill **`human-in-the-loop-ops`** (sin vendor sync). Mapa ecosistema: [docs/LOOP_AI_ECOSYSTEM.md](../docs/LOOP_AI_ECOSYSTEM.md) (taxonomía threads + ref [claudefa.st](https://claudefa.st/blog/guide/mechanics/autonomous-agent-loops), sin sync). Watchlist registry: `ralph-loop`, `claude-skills-rezvani` (autoresearch overlap `skill-loop`; solo auditor curado). Descartados: mrkai77-loop (macOS), Loop AI Labs (vendor), Perplexity Alexa (voz).

## OpenSpec (watchlist awesome-spec-kits)

No sincronizar slash commands al global — `openspec init` los instala en el repo producto.

1. Skill global: `openspec-router` en `skills/core/`
2. Entrada en `watchlist` de `catalog/sdx-toolkit-registry.json`
3. Documentar en [docs/AWESOME_SPEC_KITS.md](../docs/AWESOME_SPEC_KITS.md)

## SD-X (toolkits registrados)

Al integrar un toolkit SD-X (Spec Kit, ui-ux-pro-max, watchlist awesome-spec-kits):

1. Editar `catalog/sdx-toolkit-registry.json`
2. `python3 scripts/sync-sdx-registry.py` → `catalog/SDX_TOOLKITS.md`
3. Documentar en [docs/SDX_ECOSYSTEM.md](../docs/SDX_ECOSYSTEM.md)

Ver skill `sdd-x-index` para mapa SD-X → skills JARVIS.

Si es `non-code/` con `bin/`, añadir `SKILL-OC.md` compacto.

## Pipeline de verificación

```bash
bash scripts/validate-all.sh
python3 scripts/sync-catalog.py
python3 scripts/sync-lock.py
python3 scripts/skills-graph.py   # opcional
```

## Instalar en IDE

```bash
bash scripts/install.sh --all     # ~/.cursor/skills + ~/.claude/skills
bash scripts/install.sh --dry-run # preview
```

## Archivos generados (no editar manualmente)

- `catalog/CATALOG.md`
- `catalog/AUTO_INVOKE.md`
- `catalog/SKILLS_GRAPH.md`
- `catalog/SDX_TOOLKITS.md` (desde `sync-sdx-registry.py`)
- `skills-lock.json`

## Reglas

1. No crear `corralx-*` / `zonix-*` aquí — van al repo del producto.
2. No duplicar `SKILL.md` en repos de producto; referenciar por nombre en `AGENTS.md`.
3. Invocar `verification-before-completion` antes de declarar el mantenimiento cerrado.

## Referencias

- [docs/CONVENTIONS.md](../docs/CONVENTIONS.md)
- [docs/MIGRATION.md](../docs/MIGRATION.md)
- [docs/SDD_SPECKIT_INTEGRATION.md](../docs/SDD_SPECKIT_INTEGRATION.md)
- [docs/SPEC_KITTY_INTEGRATION.md](../docs/SPEC_KITTY_INTEGRATION.md)
- [docs/SPEC_KIT_EXTENSIONS.md](../docs/SPEC_KIT_EXTENSIONS.md)
- [docs/OPEN_DESIGN_INTEGRATION.md](../docs/OPEN_DESIGN_INTEGRATION.md)
- [docs/AWESOME_SPEC_KITS.md](../docs/AWESOME_SPEC_KITS.md)
- [docs/AGENT_SKILLS_ADDY_INTEGRATION.md](../docs/AGENT_SKILLS_ADDY_INTEGRATION.md)
- [docs/SDX_ECOSYSTEM.md](../docs/SDX_ECOSYSTEM.md)
