# Forense Cyber Neo vs JARVIS — Resumen

**Fecha:** 2026-06-18  
**Repo analizado:** [Hainrixz/cyber-neo](https://github.com/Hainrixz/cyber-neo) (MIT, skill único ~20 archivos, 2 commits en main al pin)  
**Objetivo:** Integrar auditoría Cyber Neo en `jarvis-skills-library` sin sustituir `security` ni duplicar workflow JARVIS.

---

## Qué es Cyber Neo

Agente de auditoría **read-only** para proyectos locales: 11 dominios de seguridad, 5 fases paralelas (subagentes), OWASP 2025 completo, CWE Top 25, CVSS-aligned scoring, reporte MD ejecutivo.

Contenido sync:

- `SKILL.md` — orquestación fases + IRON LAW
- `references/` — patrones (auth, crypto, web, cicd, docker, secrets, owasp, cwe, lang-js, lang-python)
- `scripts/` — `scan_secrets.py`, `check_lockfiles.py`

## Hallazgos vs JARVIS global

### Solapamiento — JARVIS canónico

| Área Cyber Neo | JARVIS global | Decisión |
|----------------|---------------|----------|
| Workflow módulo | `jarvis-core` | JARVIS |
| TDD / verificación | `test-driven-development`, `verification-before-completion` | JARVIS |
| Git | `git-commit`, `git-guardrails-ops` | JARVIS |
| Review PR | `code-review-playbook` | JARVIS |
| Checklist OWASP en desarrollo | `security` | JARVIS (checklist); Cyber Neo = audit profundo |
| Cierre sesión | `session-learner-ops` | JARVIS |

### Complemento — Cyber Neo o ECC

| Área | Cyber Neo | ECC / JARVIS |
|------|-----------|--------------|
| Auditoría 11 dominios + reporte | skill `cyber-neo` | — |
| Checklist corto OWASP | — | `security`, `security-review-ecc` |
| Secretos regex batch | `scan_secrets.py` | `security` gitignore section |
| Harness hooks / instincts | — | `ecc-router`, `continuous-learning-v2` |
| AgentShield / ecc consult | — | `ecc` bin |

### Diferencia clave vs `security-review-ecc`

| | `security` / `security-review-ecc` | `cyber-neo` |
|---|--------------------------------------|-------------|
| Momento | Durante implementación / PR | Auditoría puntual del repo |
| Alcance | Checklist por feature | 11 dominios, supply chain, CI/CD, Docker |
| Output | Guía inline | Reporte MD priorizado |
| Modifica código | Guía fixes | **Nunca** (IRON LAW) |
| Paralelismo | — | 5 subagentes / Task |

## Qué se adoptó en jarvis-skills-library

| Artefacto | Función |
|-----------|---------|
| `cyber-neo-router` | Precedencia audit vs checklist |
| `cyber-neo` (ops) | Skill sync upstream patched |
| `cyber-neo-cli` + bin | Wrapper Python scripts |
| `sync-cyber-neo-skill.sh` | Rsync pin + patch |
| `patch-cyber-neo-skill.py` | Overlay Cursor (Task, no Agent) |
| `install-cyber-neo-upstream.sh` | Clone opcional `~/cyber-neo` |

## Qué NO se adoptó

| Elemento | Razón |
|----------|-------|
| Repo completo (`.claude-plugin`, `CLAUDE.md`) | Solo skill tree necesario |
| Slash `/cyber-neo` | No existe en Cursor |
| Sustituir `security` | Diferente momento y formato |
| Fixes automáticos en audit | IRON LAW upstream + política JARVIS |

## Flujo recomendado post-auditoría

1. **Cyber Neo** → reporte con hallazgos priorizados.
2. **Priorizar** Critical/High con usuario.
3. **`security`** + skill dominio + **`test-driven-development`** → implementar fixes.
4. **`verification-before-completion`** → tests + re-scan opcional (`cyber-neo secrets`).

## Riesgos operativos

1. **Falsos positivos SAST nativo** — revisar con humano antes de fix masivo.
2. **PHP/Laravel v0.1** — sin `lang-php.md`; no confiar solo en patrones JS/Python para Blade/PHP.
3. **Reporte en Desktop** — puede pasar desapercibido; ofrecer `docs/security/` en proyecto.
4. **Confusión con pentest real** — Cyber Neo es análisis estático/config; no pentest black-box en producción.

## Patrones adoptados (referencia ECC)

| Patrón | Cyber Neo en JARVIS |
|--------|---------------------|
| Router harness/audit | `cyber-neo-router` |
| Sync upstream curado | `sync-cyber-neo-skill.sh` (skill completo, no índice masivo) |
| Bin wrapper | `cyber-neo` bin (como `ecc`) |
| Doc integración + forense | `CYBER_NEO_INTEGRATION.md`, este archivo |

---

## Re-análisis 2026-06-18 (post-integración `a8ccbab`)

**Commit integración:** `a8ccbab` — `cyber-neo-router`, `cyber-neo`, `cyber-neo-cli`, sync scripts, docs.  
**Upstream pin:** `9a8998a33534bca16c619f4956dd1935dc404620` — **sin drift** (HEAD main = pin al 2026-06-18).

### Gaps detectados tras integración inicial

| ID | Gap | Impacto | Remedio (library) |
|----|-----|---------|-------------------|
| G1 | `${CLAUDE_SKILL_DIR}` en body del skill | Cursor no resuelve variable Claude Code | `patch-cyber-neo-skill.py` → `CYBER_NEO_SKILL_DIR` |
| G2 | `$ARGUMENTS` para target | Sin slash `/cyber-neo` en Cursor | Patch → path en mensaje del usuario |
| G3 | SCA PHP sin `composer audit` en Fase 2 | Laravel API con SCA débil | Patch overlay + inyección Fase 2 |
| G4 | Bin `cyber-neo` no en PATH | Usuario debe path completo al bin | Doc + `smoke-cyber-neo.sh` |
| G5 | `scan_secrets.py` escanea `.env` local | Hallazgos Critical/High esperados en dev | Doc: `--staged-only`, interpretación humana |
| G6 | Sin `SKILL-OC.md` | Warn OpenClaw en validate | Opcional / baja prioridad |

### Matriz ampliada vs JARVIS / ECC

| Necesidad | Canónico JARVIS | Cyber Neo | ECC (si instalado en repo) |
|-----------|-----------------|-----------|----------------------------|
| Checklist al codificar | `security` | No | `security-review-ecc` |
| Review PR | `code-review-playbook` | No | agent `security-reviewer` |
| Auditoría 11 dominios + reporte | — | **`cyber-neo`** | — |
| Laravel patterns profundos | `laravel-specialist` + `security` | Parcial (genérico SAST) | skill `laravel-security` |
| Scan dependencias (npm) | — | Fase 2 | `security-scan` |
| Secretos rápidos CLI | — | `cyber-neo secrets` | — |
| Harness hooks / consult | — | — | `ecc-router`, `ecc consult` |

**Combinación Laravel API:** `cyber-neo` (reporte) → priorizar Critical/High → `security` + TDD → opcional `ecc consult "laravel security"` o agent `laravel-security` si ECC runtime en el repo.

### Cobertura por stack (JARVIS típico)

| Stack | Cyber Neo cubre | No cubre / débil | Complemento JARVIS |
|-------|-----------------|------------------|-------------------|
| Laravel API (`composer.json`) | Secretos, lockfiles, CI/Docker, auth genérico, `composer audit` (patch) | `lang-php.md`, Blade/Eloquent profundo | `security`, `laravel-specialist`, ECC `laravel-security` |
| Flutter mobile (`pubspec.yaml`) | Secretos, CI, patrones genéricos | Sin `lang-dart.md` | `security`, `flutter-expert` |
| Monorepo API + mobile | Ambos roots o scan por carpeta | Un solo reporte mezclado si path raíz ambiguo | Escanear backend y front por separado |

### Remedios aplicados en re-análisis

| Artefacto | Cambio |
|-----------|--------|
| `patch-cyber-neo-skill.py` | `CYBER_NEO_SKILL_DIR`, `$ARGUMENTS`, composer SCA, Flutter note |
| `smoke-cyber-neo.sh` | Fixture local + checks SKILL patched |
| `CYBER_NEO_INTEGRATION.md` | CLI path, `.env`, `composer audit` |
| `cyber-neo-router` / `ecc-router` | Cruce Laravel + auditoría completa |
