# Spec Kit Extensions — ciclo de vida SDD

Complemento de [GitHub Spec Kit](https://github.com/github/spec-kit) para el trabajo **distinto de feature nueva**: bugfix, modify, refactor, hotfix, deprecate.

Upstream: [MartyBonacci/spec-kit-extensions](https://github.com/MartyBonacci/spec-kit-extensions) (MIT). Router JARVIS global: `speckit-lifecycle-router`.

> **Nota:** El autor promociona [SpecSwarm](https://github.com/MartyBonacci/specswarm) para Claude Code. En JARVIS/Cursor usamos este repo + skills globales.

## Qué cubre vs core Spec Kit

| Actividad | Core Spec Kit | Con extensions |
|-----------|---------------|----------------|
| Feature nueva | `speckit-specify` → implement | Igual |
| Bug | Ad-hoc / debugging | `/speckit.bugfix` (regression-first) |
| Cambio en feature existente | Ad-hoc | `/speckit.modify NNN` (impact analysis) |
| Refactor | Ad-hoc | `/speckit.refactor` (métricas) |
| Emergencia prod | Panic | `/speckit.hotfix` (post-mortem) |
| Retirar feature | Ad-hoc | `/speckit.deprecate NNN` (3 fases) |

## Instalación en repo producto

Requisitos: Spec Kit v0.0.18+ (JARVIS pin v0.11.2), `.specify/` existente.

```bash
git clone https://github.com/MartyBonacci/spec-kit-extensions.git /tmp/spec-kit-extensions
cd your-product-repo

# Workflows y templates
cp -r /tmp/spec-kit-extensions/extensions/* .specify/extensions/

# Scripts bash
cp /tmp/spec-kit-extensions/scripts/create-*.sh .specify/scripts/bash/
chmod +x .specify/scripts/bash/create-*.sh

# Comandos Cursor
mkdir -p .cursor/commands
cp /tmp/spec-kit-extensions/commands/*.md .cursor/commands/

# Constitution (quality gates) — revisar merge manual
cat /tmp/spec-kit-extensions/docs/constitution-template.md >> .specify/memory/constitution.md

rm -rf /tmp/spec-kit-extensions
```

Verificar: slash `/speckit.bugfix` (o equivalente en Cursor) y `ls .specify/extensions/workflows/`.

### Habilitar workflows

Editar `.specify/extensions/enabled.conf` — comentar líneas para desactivar (ej. solo `bugfix` + `modify`).

## Flujo con JARVIS

1. Detectar tipo de trabajo → skill `speckit-lifecycle-router`
2. Si extensions instaladas: slash inicial → `speckit-plan` → `speckit-tasks` → `speckit-implement` (OK usuario)
3. Si no: fallback en la skill (TDD, systematic-debugging, etc.)

## Sin instalar extensions

La skill `speckit-lifecycle-router` sigue siendo útil: define fallbacks JARVIS alineados a la filosofía upstream (regression-first, impact analysis, etc.).

## Documentación upstream

- [INSTALLATION.md](https://github.com/MartyBonacci/spec-kit-extensions/blob/main/INSTALLATION.md)
- [EXAMPLES.md](https://github.com/MartyBonacci/spec-kit-extensions/blob/main/EXAMPLES.md)
- [AI-AGENTS.md](https://github.com/MartyBonacci/spec-kit-extensions/blob/main/AI-AGENTS.md) — Cursor, Copilot, etc.

## Relacionado

- [SDD_SPECKIT_INTEGRATION.md](SDD_SPECKIT_INTEGRATION.md) — core `speckit-*`
- [SDX_ECOSYSTEM.md](SDX_ECOSYSTEM.md) — mapa SD-X
