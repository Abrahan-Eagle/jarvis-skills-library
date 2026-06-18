# Spec Kit Extensions — ciclo de vida SDD

Complemento de [GitHub Spec Kit](https://github.com/github/spec-kit) para el trabajo **distinto de feature nueva**: bugfix, modify, refactor, hotfix, deprecate.

Upstream: [MartyBonacci/spec-kit-extensions](https://github.com/MartyBonacci/spec-kit-extensions) (MIT). Router JARVIS global: `speckit-lifecycle-router` (enforcement de quality gates en Cursor).

> **Nota:** El autor promociona [SpecSwarm](https://github.com/MartyBonacci/specswarm) para Claude Code. En JARVIS/Cursor usamos este repo + skill global `speckit-lifecycle-router` (no duplicar `.cursorrules` entero de AI-AGENTS).

## Qué cubre vs core Spec Kit

| Actividad | Core Spec Kit | Con extensions |
|-----------|---------------|----------------|
| Feature nueva | `speckit-specify` → implement | Igual |
| Bug | Ad-hoc / debugging | `/speckit.bugfix` (regression-first) |
| Cambio en feature existente | Ad-hoc | `/speckit.modify NNN` (impact analysis) |
| Refactor | Ad-hoc | `/speckit.refactor` (métricas) |
| Emergencia prod | Panic | `/speckit.hotfix` (post-mortem) |
| Retirar feature | Ad-hoc | `/speckit.deprecate NNN` (3 fases) |

## Cheat sheet (test strategy)

| Workflow | Comando | Quality gate | Tests |
|----------|---------|--------------|-------|
| Feature | `/speckit.specify` | Spec completa | TDD (test before code) |
| Bugfix | `/speckit.bugfix` | Regresión antes del fix | Test **before** fix |
| Modify | `/speckit.modify NNN` | Impact analysis primero | Actualizar tests afectados |
| Refactor | `/speckit.refactor` | Tests green cada paso | Tests **unchanged** |
| Hotfix | `/speckit.hotfix` | Post-mortem ≤48h | Test **after** fix (excepción) |
| Deprecate | `/speckit.deprecate NNN` | 3 fases sunset | Quitar tests al final |

## Instalación en repo producto

Requisitos: Spec Kit v0.0.18+ (JARVIS pin v0.11.2), `.specify/` existente.

### Script JARVIS (recomendado)

Desde `jarvis-skills-library`:

```bash
bash scripts/install-spec-kit-extensions.sh --target /path/to/product-repo
```

Copia: `extensions/` → `.specify/extensions/`, `create-*.sh` → `.specify/scripts/bash/`, `commands/*.md` → `.cursor/commands/`, append constitution si falta Section VI.

### Manual

```bash
git clone https://github.com/MartyBonacci/spec-kit-extensions.git /tmp/spec-kit-extensions
cd your-product-repo

cp -r /tmp/spec-kit-extensions/extensions/* .specify/extensions/
cp /tmp/spec-kit-extensions/scripts/create-*.sh .specify/scripts/bash/
chmod +x .specify/scripts/bash/create-*.sh
mkdir -p .cursor/commands
cp /tmp/spec-kit-extensions/commands/*.md .cursor/commands/

# Constitution Section VI — revisar merge manual (no overwrite)
cat /tmp/spec-kit-extensions/docs/constitution-template.md >> .specify/memory/constitution.md

rm -rf /tmp/spec-kit-extensions
```

Verificar:

```bash
test -d .specify/extensions/workflows && ls .specify/extensions/workflows/
.specify/scripts/bash/create-bugfix.sh --help
```

### Habilitar workflows

Editar `.specify/extensions/enabled.conf` — comentar líneas para desactivar (ej. solo `bugfix` + `modify`). Si un workflow está desactivado, `speckit-lifecycle-router` usa fallback JARVIS equivalente.

## Cursor

1. Tras install: comandos en `.cursor/commands/speckit.*.md` (slash `/speckit.bugfix`, etc.)
2. Skill global `speckit-lifecycle-router` aplica quality gates aunque el slash no esté instalado (vía bash `create-*.sh`)
3. No hace falta pegar el bloque completo de AI-AGENTS en `.cursorrules` si usas la skill global en sesiones JARVIS

## Constitution Section VI

Las extensiones definen quality gates por workflow en `docs/constitution-template.md` (Section VI: Workflow Selection and Quality Gates). Al instalar:

- Revisar `.specify/memory/constitution.md` tras append
- Dedupe si ya tenías gates similares
- El agente debe leer Section VI antes de implementar lifecycle workflows

## Flujo con JARVIS

1. Detectar tipo de trabajo → `speckit-lifecycle-router`
2. Con extensions: slash o bash → artefactos → `speckit-plan` → `speckit-tasks` → `speckit-implement` (OK usuario)
3. Sin extensions: mismos gates vía fallback (TDD, systematic-debugging, etc.)

## Troubleshooting

| Problema | Solución |
|----------|----------|
| Slash no encontrado | Instalar `.cursor/commands/` o usar bash `create-*.sh` |
| Permission denied en scripts | `chmod +x .specify/scripts/bash/create-*.sh` |
| Feature NNN no encontrada (`modify`) | `ls specs/ \| grep ^NNN` — usar número correcto |
| Workflow desactivado | Revisar `enabled.conf` o fallback JARVIS |
| Constitution duplicada | Editar manualmente Section VI en constitution.md |

## Sin instalar extensions

La skill `speckit-lifecycle-router` sigue siendo útil: define fallbacks JARVIS alineados a upstream (regression-first, impact analysis, 3-phase deprecate).

## Documentación upstream

- [INSTALLATION.md](https://github.com/MartyBonacci/spec-kit-extensions/blob/main/INSTALLATION.md)
- [EXAMPLES.md](https://github.com/MartyBonacci/spec-kit-extensions/blob/main/EXAMPLES.md)
- [AI-AGENTS.md](https://github.com/MartyBonacci/spec-kit-extensions/blob/main/AI-AGENTS.md) — Cursor, Copilot, etc.

## Relacionado

- [SDD_SPECKIT_INTEGRATION.md](SDD_SPECKIT_INTEGRATION.md) — core `speckit-*`
- [SDX_ECOSYSTEM.md](SDX_ECOSYSTEM.md) — mapa SD-X
