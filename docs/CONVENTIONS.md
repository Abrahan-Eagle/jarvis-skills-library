# Convenciones de skills globales

Basado en CorralX `MAINTENANCE_SKILLS.md` y clawvis `SKILLS_CONVENCIONES.md`.

## Anatomía

```
skills/<categoria>/<skill-name>/
├── SKILL.md          # obligatorio
├── SKILL-OC.md       # opcional — OpenClaw compacto
├── bin/              # opcional — CLI ejecutables
├── scripts/          # opcional — Python/bash auxiliares
├── references/       # opcional — docs bajo demanda
└── assets/           # opcional — plantillas, iconos
```

## Frontmatter YAML (obligatorio)

```yaml
---
name: nombre-del-skill          # kebab-case, único en catálogo global
description: >
  Qué hace en 1–2 líneas.
  Trigger: Cuándo debe activarse automáticamente.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]               # o rutas si aplica
  category: ops                 # core | ops | engineering | git | review | planning | backend | mobile | ui | non-code
  auto_invoke:
    - "Frase para tabla auto-invoke"
  triggers: keyword1, keyword2
  related-skills: [jarvis-core, git-commit]
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task]
---
```

## Nomenclatura

| Patrón | Uso |
|--------|-----|
| `jarvis-*` | Orquestación JARVIS (`jarvis-core`, `jarvis-experts`) |
| `*-ops` | Proceso operativo (`brainstorming-ops`, `git-guardrails-ops`) |
| Sin prefijo producto | Genéricas (TDD, debugging, git) |
| **No** `corralx-*` / `zonix-*` aquí | Van al repo del producto |

## Dual-file (SKILL.md + SKILL-OC.md)

| Archivo | Audiencia |
|---------|-----------|
| `SKILL.md` | Cursor, Claude Code — completo |
| `SKILL-OC.md` | OpenClaw — token-efficient |

OpenClaw prefiere `SKILL-OC.md` si existe.

### Cuándo crear `SKILL-OC.md`

| Situación | SKILL-OC |
|-----------|----------|
| Skill en `non-code/` con `bin/` (CLI, gates, reportes) | **Recomendado** — `validate-skills.sh` emite WARN si falta |
| Skill solo documentación / proceso sin bin | Opcional |
| Skills de ingeniería, git, review | No obligatorio — usar solo `SKILL.md` |

Objetivo: versión ~200 líneas con comandos esenciales y sin ejemplos extensos. Mantener `name` alineado con `SKILL.md`.

## Modos de ejecución (opcional)

Skills con CLI pueden soportar `--mode`:

| Modo | Comportamiento |
|------|----------------|
| `quick` | Resumen mínimo |
| `standard` | Por defecto |
| `deep` | Auditoría completa |

## Bins (`bin/`)

- `chmod +x` obligatorio.
- Responder a `help` o `--help`.
- `validate-skills.sh` avisa o falla según categoría.

## Checklist nueva skill

1. `init_skill.py` o copiar `templates/SKILL.template.md`.
2. Completar `name`, `description`, `metadata.category`.
3. `bash scripts/validate-all.sh`
4. `python3 scripts/sync-catalog.py` y `python3 scripts/sync-lock.py`
5. `bash scripts/install.sh` o `bash scripts/install.sh --all`
6. Si el producto debe auto-invocar: añadir fila en su `AGENTS.md` (nombre solamente).
