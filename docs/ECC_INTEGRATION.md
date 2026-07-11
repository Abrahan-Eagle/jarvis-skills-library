# ECC (Everything Claude Code) — integración JARVIS global

[ECC](https://github.com/affaan-m/ecc) (MIT) es un sistema de optimización del **harness** del agente: skills, instincts, memoria vía hooks, rules por idioma, agents y CLI `ecc-universal`. Soporta Cursor con `./install.sh --target cursor`.

Skills JARVIS: `ecc-router` (decisión) + `ecc` (bin CLI) + 3 skills curados sync desde upstream.

Forense detallado: [ECC_FORENSE_JARVIS.md](ECC_FORENSE_JARVIS.md).

## Fuentes oficiales (solo estas)

- Repo: [github.com/affaan-m/ECC](https://github.com/affaan-m/ecc)
- npm: [`ecc-universal`](https://www.npmjs.com/package/ecc-universal), [`ecc-agentshield`](https://www.npmjs.com/package/ecc-agentshield)
- Web: [ecc.tools](https://ecc.tools)
- MIT — no copiar mirrors de terceros

## vs JARVIS canónico

| Necesidad | Usar |
|-----------|------|
| Workflow módulo, plan, cierre | `jarvis-core`, `brainstorming-ops`, `session-learner-ops` |
| Arranque de sesión (sin hooks) | `session-startup-ops` |
| Compactación estratégica (sin hooks) | `strategic-compact-ops` → `handoff` |
| Modos research/produce/review | `context-packs-ops` |
| TDD / verificación | `test-driven-development`, `verification-before-completion` |
| Git / commits / push | `git-commit`, `git-guardrails-ops` |
| Code review | `code-review-playbook` |
| Pre-gate publicación/deploy | `llm-as-judge-ops` → `approval-gate` ([APPROVAL_GATES.md](APPROVAL_GATES.md)) |
| Seguridad OWASP (checklist) | `security` o `security-review-ecc` si ECC instalado |
| Instincts / evolve / hooks runtime | `ecc-router` → ECC install + `continuous-learning-v2` (sin hooks: `learning-loop` HITL) |
| Rules PHP/TS en `.cursor/` | `install-ecc-runtime.sh` en repo producto |
| Descubrir componente ECC | `ecc consult "<query>"` |

### Mapa concepto ECC → skill JARVIS (cherry-pick 2026-07)

| Concepto ECC | JARVIS (sin plugin) | Runtime ECC opt-in |
|--------------|---------------------|--------------------|
| session-start/end.js | `session-startup-ops` + `session-learner-ops` | hooks `--with-hooks` |
| strategic-compact | `strategic-compact-ops` | hooks suggest/pre-compact |
| contexts/*.md | `context-packs-ops` | packs en `.cursor/` |
| continuous-learning /learn | `learning-loop` (HITL) | `continuous-learning-v2` + hooks |
| eval / verify | `llm-as-judge-ops` + `verification-before-completion` | eval-harness upstream |
| approval | `approval-gate` + HITL | — |

## Arquitectura

```
Cursor / JARVIS (~/.cursor/skills vía install.sh)
  ├─ ecc-router
  ├─ ecc bin → npx ecc-universal
  └─ skills curados (continuous-learning-v2, security-review-ecc, configure-ecc)
Repo producto (opcional)
  └─ .cursor/ (hooks, agents ecc-*, rules) vía install-ecc-runtime.sh
ECC_HOME clone (~/ecc)
  └─ install.sh oficial upstream
```

## Instalación runtime

### Script JARVIS

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install-ecc-runtime.sh --project-dir /path/to/CorralX-Backend
```

Opciones:

- `--profile minimal` (default) — rules/agents sin hooks-runtime
- `--profile core` — perfil upstream **más amplio**; en ECC upstream `core` ya puede incluir hooks/instincts (no asumir “sin hooks”)
- `--with-hooks` — añade módulo `hooks-runtime` sobre el perfil elegido (típico: `minimal` + `--with-hooks` para instincts opt-in)
- `--languages "php typescript"` o `dart` para Flutter
- `--dry-run` — imprime qué clonaría/instalaría **sin** aplicar `install.sh` al proyecto

### Language packs (ECC v2)

ECC v2 no acepta idiomas legacy junto con `--profile`. El script JARVIS mapea tokens a componentes `--with`:

| Token JARVIS | Componente ECC |
|--------------|----------------|
| `php`, `laravel` | `framework:laravel` |
| `typescript`, `js` | `lang:typescript` |
| `dart`, `flutter` | `framework:laravel` (no hay `lang:dart`; rules Flutter vía install adicional si ECC lo publica) |
| `python` | `lang:python` |

Ejemplo Flutter + Laravel:

```bash
bash scripts/install-ecc-runtime.sh --project-dir /path/to/CorralX-Frontend --languages "dart typescript"
```

CorralX típico (API Laravel): default `php typescript` → `framework:laravel` + `lang:typescript`.

### Perfiles

| Perfil / flag | Hooks | Uso JARVIS |
|---------------|-------|------------|
| `minimal` (default) | No (salvo `--with-hooks`) | Recomendado: rules + agents sin runtime intrusivo |
| `core` | Upstream **ya incluye** más harness (hooks/instincts según versión ECC) | Solo si quieres el pack `core` completo |
| `--with-hooks` | Sí (`--modules hooks-runtime`) | Opt-in explícito; aplica **sobre** el perfil (p. ej. `minimal` + `--with-hooks`) |
| `--dry-run` | N/A | Preview sin mutar el proyecto |

**No apilar** plugin Claude `ecc@ecc` + `install.sh --profile full` (duplicación).

### CLI

Delega a `$ECC_HOME/scripts/ecc.js` (clone upstream) si existe; fallback `npx ecc-universal`.

```bash
ecc status
ecc consult "laravel security review"
ecc doctor
ecc repair
```

## Sync curado (mantenedor)

```bash
bash scripts/sync-ecc-skills.sh      # 3 skills complementarios
python3 scripts/sync-ecc-manifest.py # índice upstream (no catálogo global)
```

Índice descubrimiento: [catalog/ecc-skills-index.md](../catalog/ecc-skills-index.md).

## Licencia

ECC upstream: MIT. Skills curados en este repo: UNLICENSED (overlay JARVIS). Atribuir [affaan-m/ECC](https://github.com/affaan-m/ecc) al redistribuir patrones derivados.

## Relacionado

- [ECC_FORENSE_JARVIS.md](ECC_FORENSE_JARVIS.md)
- [CYBER_NEO_INTEGRATION.md](CYBER_NEO_INTEGRATION.md) — auditoría profunda read-only (complementario; checklist → `security`)
- [SDX_ECOSYSTEM.md](SDX_ECOSYSTEM.md)
- [jarvis-core](../skills/core/jarvis-core/SKILL.md) — precedencia harness
