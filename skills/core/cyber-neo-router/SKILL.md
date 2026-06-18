---
name: cyber-neo-router
description: >
  Orquesta auditoría Cyber Neo (11 dominios, OWASP 2025, reporte read-only) vs security checklist JARVIS.
  Trigger: security audit, vulnerability scan, cyber-neo, pentest, auditoría seguridad, OWASP 2025 reporte.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: core
  auto_invoke:
    - "Auditoría seguridad profunda read-only"
    - "Vulnerability scan con reporte"
    - "cyber-neo pentest OWASP 2025"
    - "Escaneo secretos SCA SAST"
  triggers: security audit, vulnerability scan, cyber-neo, pentest, auditoría seguridad, owasp 2025
  related-skills:
    - jarvis-core
    - cyber-neo
    - cyber-neo-cli
    - security
    - security-review-ecc
    - ecc-router
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# Cyber Neo Router

Router para [Cyber Neo](https://github.com/Hainrixz/cyber-neo) (MIT): auditoría de seguridad **read-only** (11 dominios, OWASP 2025, CWE Top 25, reporte MD) **sin** sustituir `jarvis-core` ni checklist `security`.

Guía JARVIS: [docs/CYBER_NEO_INTEGRATION.md](../../docs/CYBER_NEO_INTEGRATION.md). Forense: [docs/CYBER_NEO_FORENSE_JARVIS.md](../../docs/CYBER_NEO_FORENSE_JARVIS.md).

## Detección runtime

```bash
test -d "${HOME}/.cursor/skills/cyber-neo" && echo CYBER_NEO_INSTALLED
test -f skills/ops/cyber-neo/SKILL.md && echo CYBER_NEO_LIBRARY
command -v cyber-neo >/dev/null 2>&1 && echo CYBER_NEO_CLI
python3 --version 2>/dev/null
```

| Señal | Interpretación |
|-------|----------------|
| `CYBER_NEO_INSTALLED` | Skill en `~/.cursor/skills` vía `install.sh --all` |
| `CYBER_NEO_LIBRARY` | Skill en jarvis-skills-library |
| `CYBER_NEO_CLI` | Wrapper `cyber-neo` (secrets / lockfiles) |

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| Iniciar/planificar/cerrar módulo | `jarvis-core` | cyber-neo |
| TDD / tests antes de "listo" | `test-driven-development`, `verification-before-completion` | — |
| Commits / push / merge | `git-commit`, `git-guardrails-ops` | — |
| Code review PR | `code-review-playbook` | cyber-neo como sustituto |
| Checklist OWASP al implementar auth/uploads/API | `security` | — |
| Checklist ECC corto (harness instalado) | `security-review-ecc` | — |
| **Auditoría profunda read-only + reporte ejecutivo** | skill `cyber-neo` | modificar código en el audit |
| Secretos rápidos (solo regex) | `cyber-neo secrets <path>` | — |
| Supply chain lockfiles | `cyber-neo lockfiles <path>` | — |
| Harness ECC (hooks, instincts) | `ecc-router` | cyber-neo |
| Fixes tras auditoría | `security` + `test-driven-development` | solo reportar sin fix |

## Flujo recomendado (Cursor)

1. Resolver `TARGET_DIR` (path absoluto del proyecto).
2. Invocar skill `cyber-neo` con ese path (no existe `/cyber-neo` en Cursor).
3. Fase 1 recon sincrónica (detectar stack, `composer.json`, CI, Docker).
4. Fases paralelas con **Task** (`readonly: true`, hasta 5): SCA, SAST, secrets, config/IaC, supply chain.
5. Opcional previo: `cyber-neo secrets "$TARGET_DIR"` y `cyber-neo lockfiles "$TARGET_DIR"`.
6. Reporte: `~/Desktop/cyber-neo-report-{name}-{date}.md` o `{TARGET}/docs/security/` si el usuario pide.
7. Remediación: nueva sesión con `security` + TDD — **no** en la misma pasada de audit.

## Limitaciones conocidas

- PHP/Laravel: sin `lang-php.md` en v0.1 upstream; recon + patrones genéricos + composer SCA.
- Herramientas opcionales (semgrep, trivy, gitleaks) degradan a análisis nativo si no están instaladas.

## Cuándo NO usar Cyber Neo

- Checklist pre-merge durante desarrollo → `security`
- Review de PR → `code-review-playbook`
- Workflow modular estándar → `jarvis-core`
