# Learning Loop — integración JARVIS global

[learning-loop-skill](https://github.com/melodykoh/learning-loop-skill) (MIT v4.1) captura aprendizajes de sesión (scan mid-session + wrap-up con quality gates) antes de perder contexto. Diseñado para Claude Code (`/learning-loop`); en Cursor se invoca por skill.

Skills JARVIS: `learning-loop-router` (decisión) + `learning-loop` (skill sync upstream + patch v2).

Forense: [LEARNING_LOOP_FORENSE_JARVIS.md](LEARNING_LOOP_FORENSE_JARVIS.md) (re-análisis v2 post-`7ca41ef`).

## Fuentes oficiales

- Repo: [github.com/melodykoh/learning-loop-skill](https://github.com/melodykoh/learning-loop-skill)
- Pin JARVIS: `948dc75bc5a771a57366c651c5d442b44cba214d` (main, v4.1.0)
- Patch JARVIS: `4.1-jarvis2` (overlay + IRON LAW + body replacements)
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
| Code fixes documentados | walkthrough + `documentar-avances` (no compound Every) |

## Arquitectura

```
Cursor (~/.cursor/skills vía install.sh)
  ├─ learning-loop-router
  └─ learning-loop (sync skills/ops/learning-loop)
skills/ops/learning-loop/
  ├─ SKILL.md (patched JARVIS/Cursor v2)
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
python3 scripts/patch-learning-loop-skill.py
bash scripts/smoke-learning-loop.sh
bash scripts/audit-learning-loop-body.sh   # opcional, forense
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
5. **IRON LAW:** nunca escribir en destinos Claude Code legacy; ver overlay en SKILL.

### Qué pedir al agente (frases en español)

| Frase | Modo | Router |
|-------|------|--------|
| "learning-loop scan" / "contexto largo, captura señales" | Scan | `learning-loop-router` → scan |
| "wrap up" / "consolidar sesión" / "cerrar sesión con aprendizajes" | Wrap-up | `learning-loop-router` → wrap-up |
| "terminar módulo" / "cierre módulo" | Cierre canónico | **`session-learner-ops`** (no sustituir) |
| "actualizar active_context" | Resumen | `context-updater` |
| "instincts" / "evolve" | ECC | `ecc-router` |

## Flujos producto (CorralX / Zonix)

### CorralX — cierre módulo típico

1. Usuario: "cerrar módulo chat" → `session-learner-ops`.
2. Agente escribe `CorralX-Frontend/docs/active_context.md` + `.agents/plans/walkthrough.md`.
3. Opcional: "wrap up learning-loop" si hubo sesión larga con muchas correcciones.
4. Destinos adicionales del wrap-up: patrones UI en walkthrough, facts en `active_context`, triggers cortos en `AGENTS.md` **solo con OK usuario**.
5. `verification-before-completion` antes de declarar módulo cerrado.

### Zonix Pharma — cierre módulo típico

1. Igual precedencia: `session-learner-ops` → `docs/active_context.md` (Backend o Front según repo activo).
2. Walkthrough en `.agents/plans/` del repo tocado.
3. Wrap-up opcional para sesiones Rx/commerce largas; **no** rutear a Judgment Ledger ni content wedges.
4. Copy regulatorio: validar con `zonix-regulatory-ve` humano si el wrap-up propone claims de salud.

### clawvis-openclaw

Sesiones largas marketing/JMC: scan mid-session; wrap-up → `jarvis-ecosystem` docs o `active_context` del ecosistema; watch-list en `~/.cursor/learning-captures/`.

## Runtime captures

```bash
mkdir -p ~/.cursor/learning-captures
# Scans: ~/.cursor/learning-captures/<session-id>/scan-NNN.md
# Watch-list: ~/.cursor/learning-captures/watch-list.md
```

Override: `export LEARNING_LOOP_HOME=/custom/path`

### Hook post-clear (opcional, Claude Code)

Upstream documenta hook SessionStart en settings Claude Code. En Cursor no se instala por defecto; wrap-up manual si hay captures huérfanas.

## Riesgos (resumen)

Ver detalle en forense § Riesgos operativos:

1. Contradicción overlay vs body — mitigado en patch v2 + IRON LAW.
2. Costo contexto (~156 KB SKILL) — invocar solo scan/wrap-up explícito.
3. Consolidar en main thread — usar Task readonly.
4. Saltar verificación usuario — prohibido.
5. Watch-list sin plan de acción — enlazar a `.agents/plans/`.
6. Duplicado con `active_context` — learner canónico primero.
7. Commits locales sin push — equipo no recibe hasta `git push`.

## Gaps conocidos

Tabla G1–G10 en [LEARNING_LOOP_FORENSE_JARVIS.md](LEARNING_LOOP_FORENSE_JARVIS.md#gaps-detectados-g1g10). Patch v2 cierra G3–G5, G8, G9; G10 (`SKILL-OC.md`) abierto baja prioridad.

Auditoría residual: `bash scripts/audit-learning-loop-body.sh`

## Scripts

| Script | Uso |
|--------|-----|
| `sync-learning-loop-skill.sh` | Sync upstream + patch |
| `patch-learning-loop-skill.py` | Re-aplicar patch v2 |
| `install-learning-loop-upstream.sh` | Clone `~/learning-loop-skill` |
| `smoke-learning-loop.sh` | Smoke patched SKILL (v2) |
| `audit-learning-loop-body.sh` | Conteos forense (no falla) |

## Producto repos

Por defecto **no** modificar `AGENTS.md` de productos automáticamente. Cierre canónico: `session-learner-ops`. Learning-loop es complemento opcional.
