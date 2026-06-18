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
| TDD / verificación | `test-driven-development`, `verification-before-completion` |
| Git / commits / push | `git-commit`, `git-guardrails-ops` |
| Code review | `code-review-playbook` |
| Seguridad OWASP (checklist) | `security` o `security-review-ecc` si ECC instalado |
| Instincts / evolve / hooks runtime | `ecc-router` → ECC install + `continuous-learning-v2` |
| Rules PHP/TS en `.cursor/` | `install-ecc-runtime.sh` en repo producto |
| Descubrir componente ECC | `ecc consult "<query>"` |

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

Opciones: `--profile minimal` (default, sin hooks-runtime), `--with-hooks`, `--languages "php typescript"` o `dart` para Flutter.

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

| Perfil | Hooks | Uso JARVIS |
|--------|-------|------------|
| `minimal` | No | Recomendado: rules + agents sin runtime intrusivo |
| `core` | Sí (con `--with-hooks`) | Instincts, memory hooks — opt-in explícito |

**No apilar** plugin Claude `ecc@ecc` + `install.sh --profile full` (duplicación).

### CLI

Delega a `$ECC_HOME/scripts/ecc.js` (clone upstream) si existe; fallback `npx ecc-universal`.

```bash
ecc status
ecc consult "laravel security review"
ecc doctor
```

## Sync curado (mantenedor)

```bash
bash scripts/sync-ecc-skills.sh      # 3 skills complementarios
python3 scripts/sync-ecc-manifest.py # índice upstream (no catálogo global)
```

Índice descubrimiento: [catalog/ecc-skills-index.md](catalog/ecc-skills-index.md).

## Licencia

ECC upstream: MIT. Skills curados en este repo: UNLICENSED (overlay JARVIS). Atribuir [affaan-m/ECC](https://github.com/affaan-m/ecc) al redistribuir patrones derivados.

## Relacionado

- [ECC_FORENSE_JARVIS.md](ECC_FORENSE_JARVIS.md)
- [SDX_ECOSYSTEM.md](SDX_ECOSYSTEM.md)
- [jarvis-core](../skills/core/jarvis-core/SKILL.md) — precedencia harness
