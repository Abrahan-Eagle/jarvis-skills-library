# Cyber Neo — integración JARVIS global

[Cyber Neo](https://github.com/Hainrixz/cyber-neo) (MIT) es un agente de **auditoría de seguridad read-only**: 11 dominios, OWASP 2025, CWE Top 25, reporte MD priorizado. Diseñado para Claude Code; en Cursor se invoca por skill (no existe `/cyber-neo`).

Skills JARVIS: `cyber-neo-router` (decisión) + `cyber-neo` (skill sync upstream) + `cyber-neo-cli` (bin scripts Python).

Forense detallado: [CYBER_NEO_FORENSE_JARVIS.md](CYBER_NEO_FORENSE_JARVIS.md).

## Fuentes oficiales (solo estas)

- Repo: [github.com/Hainrixz/cyber-neo](https://github.com/Hainrixz/cyber-neo)
- Pin JARVIS: `9a8998a33534bca16c619f4956dd1935dc404620` (main)
- MIT — no copiar mirrors de terceros

## vs JARVIS canónico

| Necesidad | Usar |
|-----------|------|
| Workflow módulo, plan, cierre | `jarvis-core`, `session-learner-ops` |
| TDD / verificación | `test-driven-development`, `verification-before-completion` |
| Git / commits / push | `git-commit`, `git-guardrails-ops` |
| Code review PR | `code-review-playbook` |
| Checklist OWASP al desarrollar | `security` |
| Checklist ECC (harness) | `security-review-ecc` |
| **Auditoría profunda read-only + reporte** | `cyber-neo-router` → skill `cyber-neo` |
| Secretos / lockfiles rápidos | `cyber-neo` bin (`cyber-neo-cli`) |
| Harness ECC (hooks, instincts) | `ecc-router` |

Complementario con ECC: ver nota en [ECC_INTEGRATION.md](ECC_INTEGRATION.md).

## Arquitectura

```
Cursor / JARVIS (~/.cursor/skills vía install.sh)
  ├─ cyber-neo-router
  ├─ cyber-neo (skill audit — sync skills/ops/cyber-neo)
  └─ cyber-neo-cli + bin/cyber-neo → scripts Python
skills/ops/cyber-neo/
  ├─ SKILL.md (patched JARVIS/Cursor)
  ├─ references/ (patrones OWASP, lang-js, lang-python)
  └─ scripts/ (scan_secrets.py, check_lockfiles.py)
CYBER_NEO_HOME opcional (~/cyber-neo) — install-cyber-neo-upstream.sh
```

## Instalación

### Global skills

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install.sh --all
```

Incluye `cyber-neo`, `cyber-neo-router`, `cyber-neo-cli`.

### Sync desde upstream (mantenedores)

```bash
bash scripts/sync-cyber-neo-skill.sh
python3 scripts/patch-cyber-neo-skill.py   # incluido en sync
bash scripts/validate-all.sh
```

### Clone upstream (opcional, diff)

```bash
bash scripts/install-cyber-neo-upstream.sh
# CYBER_NEO_HOME=~/cyber-neo
```

## Uso en Cursor

1. Pedir: "auditoría cyber-neo de `/path/to/project`" o "security audit vulnerability scan".
2. El agente debe cargar skill `cyber-neo` y respetar **IRON LAW read-only**.
3. Subagentes: **Task** con `readonly: true` (no tool `Agent` de Claude Code).
4. Reporte: `~/Desktop/cyber-neo-report-{name}-{date}.md` o `{project}/docs/security/` si el usuario pide.

### CLI (scripts Python)

El bin **no** se instala en PATH global. Usar path completo o symlink local:

```bash
# Desde jarvis-skills-library (desarrollo)
bash skills/non-code/cyber-neo/bin/cyber-neo status
bash skills/non-code/cyber-neo/bin/cyber-neo secrets /path/to/project
bash skills/non-code/cyber-neo/bin/cyber-neo lockfiles /path/to/project

# Tras install.sh --all
~/.cursor/skills/cyber-neo-cli/bin/cyber-neo status
```

Requiere `python3`. Scripts Python viven en `~/.cursor/skills/cyber-neo/scripts/` (skill `cyber-neo`).

**Secretos en `.env` local:** `scan_secrets.py` **no** excluye `.env` por defecto. En desarrollo local es normal ver Critical/High (APP_KEY, API keys). Para pre-commit: `python3 .../scan_secrets.py --staged-only`. Interpretar hallazgos en `.env` como exposición local, no siempre bug de producción.

**Laravel SCA:** con `composer` en PATH, Fase 2 incluye `composer audit --format=json` (read-only) si existe `composer.json`.

## Herramientas opcionales (upstream)

Si están instaladas, el skill las usa; si no, degrada a análisis nativo + scripts Python:

| Herramienta | Uso |
|-------------|-----|
| semgrep | SAST |
| trivy | SCA / containers |
| gitleaks | Secretos |
| npm audit / pip-audit / cargo audit / composer audit | Dependencias |

## Limitaciones

| Tema | Detalle |
|------|---------|
| PHP/Laravel | Sin `lang-php.md` en v0.1; recon `composer.json`, patrones genéricos, SCA composer |
| Flutter/Dart | Sin referencia dedicada; secretos + CI + generic SAST |
| Solo reporta | Fixes en sesión posterior con `security` + TDD |

## Mantenimiento

| Script | Función |
|--------|---------|
| `sync-cyber-neo-skill.sh` | Clone pin + rsync + patch |
| `patch-cyber-neo-skill.py` | Frontmatter JARVIS + overlay Cursor |
| `install-cyber-neo-upstream.sh` | Clone `~/cyber-neo` |
| `smoke-cyber-neo.sh` | Smoke fixture + checks SKILL patched |

## Producto repos

Por defecto **no** modificar `AGENTS.md` ni versionar auditorías en repos de producto. Integración canónica solo en este library + `install.sh --all`.
