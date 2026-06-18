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

## SD-X (toolkits registrados)

Al integrar un toolkit SD-X (Spec Kit, ui-ux-pro-max, futuros):

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
- [docs/SDX_ECOSYSTEM.md](../docs/SDX_ECOSYSTEM.md)
