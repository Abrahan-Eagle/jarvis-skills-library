# Learning Loop — integración JARVIS global

[learning-loop-skill](https://github.com/melodykoh/learning-loop-skill) (MIT v4.1) captura aprendizajes de sesión (scan mid-session + wrap-up con quality gates) antes de perder contexto. Diseñado para Claude Code (`/learning-loop`); en Cursor se invoca por skill.

Skills JARVIS: `learning-loop-router` (decisión) + `learning-loop` (skill sync upstream).

Forense: [LEARNING_LOOP_FORENSE_JARVIS.md](LEARNING_LOOP_FORENSE_JARVIS.md).

## Fuentes oficiales

- Repo: [github.com/melodykoh/learning-loop-skill](https://github.com/melodykoh/learning-loop-skill)
- Pin JARVIS: `948dc75bc5a771a57366c651c5d442b44cba214d` (main, v4.1.0)
- MIT

## vs JARVIS canónico

| Necesidad | Usar |
|-----------|------|
| Cierre módulo + `active_context` | **`session-learner-ops`** (primero) |
| Resumen rápido sesión | `context-updater` |
| Traspaso mid-task | `handoff` |
| Workflow módulo | `jarvis-core` |
| **Scan / wrap-up profundo** | `learning-loop-router` → skill `learning-loop` |
| Instincts ECC | `ecc-router` → `continuous-learning-v2` |
| Code fixes documentados | walkthrough + `documentar-avances` (no `/ce:compound`) |

## Arquitectura

```
Cursor (~/.cursor/skills vía install.sh)
  ├─ learning-loop-router
  └─ learning-loop (sync skills/ops/learning-loop)
skills/ops/learning-loop/
  ├─ SKILL.md (patched JARVIS/Cursor)
  └─ references/SESSION_LOG.upstream.md (humanos)
Runtime: ~/.cursor/learning-captures/ (watch-list, scans, graduation-log)
```

## Instalación

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install.sh --all
```

### Sync upstream (mantenedores)

```bash
bash scripts/sync-learning-loop-skill.sh
bash scripts/smoke-learning-loop.sh
bash scripts/validate-all.sh
```

### Clone upstream (opcional)

```bash
bash scripts/install-learning-loop-upstream.sh
# LEARNING_LOOP_UPSTREAM_HOME=~/learning-loop-skill
```

## Uso en Cursor

1. Pedir: "learning-loop **scan**" (contexto largo) o "**wrap up**" (fin sesión).
2. El agente carga skill `learning-loop`; **scan/consolidation en Task** (`readonly: true`), no en main thread.
3. Wrap-up: presentar verificación al usuario; **nada se escribe sin OK**.
4. Destinos JARVIS: `docs/active_context.md`, `.agents/plans/walkthrough.md`, `AGENTS.md` (triggers cortos), watch-list en `~/.cursor/learning-captures/`.

### Runtime captures

```bash
mkdir -p ~/.cursor/learning-captures
# Scans: ~/.cursor/learning-captures/<session-id>/scan-NNN.md
# Watch-list: ~/.cursor/learning-captures/watch-list.md
```

Override: `export LEARNING_LOOP_HOME=/custom/path`

### Hook post-clear (opcional, Claude Code)

Upstream documenta hook SessionStart en `~/.claude/settings.json`. En Cursor no se instala por defecto; si hay captures huérfanas, el usuario puede pedir wrap-up manual.

## Scripts

| Script | Uso |
|--------|-----|
| `sync-learning-loop-skill.sh` | Sync + patch SKILL |
| `patch-learning-loop-skill.py` | Re-aplicar patch |
| `install-learning-loop-upstream.sh` | Clone `~/learning-loop-skill` |
| `smoke-learning-loop.sh` | Smoke patched SKILL |

## Producto repos

Por defecto **no** modificar `AGENTS.md` de productos automáticamente. Cierre canónico: `session-learner-ops`. Learning-loop es complemento opcional.
