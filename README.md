# JARVIS Skills Library

Biblioteca **global** de skills para agentes de IA (Cursor, Claude Code, OpenClaw, etc.).  
Skills de **dominio** (CorralX, Zonix, clawvis, …) siguen en cada repo en `.agents/skills/` — este proyecto no los sustituye.

## Qué es esto

| Capa | Ubicación | Ejemplo |
|------|-----------|---------|
| **Global (este repo)** | `skills/<categoría>/<nombre>/` → `~/.cursor/skills/<nombre>/` | `jarvis-core`, `git-commit`, `systematic-debugging` |
| **Dominio (por proyecto)** | `<repo>/.agents/skills/` | `corralx-marketplace-ui`, `zonix-api-patterns` |

## Instalación rápida

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install.sh
```

Por defecto instala en `~/.cursor/skills/` (symlinks). Opciones:

```bash
bash scripts/install.sh --target ~/.cursor/skills
bash scripts/install.sh --target ~/.claude/skills
bash scripts/install.sh --all
bash scripts/install.sh --dry-run
```

## Crear una skill nueva

```bash
python3 skills/engineering/skill-creator/scripts/init_skill.py mi-skill --path skills/ops
# Editar skills/ops/mi-skill/SKILL.md
bash scripts/validate-all.sh
bash scripts/sync-catalog.sh
bash scripts/sync-lock.py
bash scripts/install.sh --all
```

Plantilla manual: `templates/SKILL.template.md`

## Validación y catálogo

```bash
bash scripts/validate-all.sh       # shell + PyYAML (recomendado)
bash scripts/validate-skills.sh    # solo shell linter
python3 scripts/validate-yaml.py   # solo PyYAML
python3 scripts/sync-catalog.py    # CATALOG.md + AUTO_INVOKE.md
python3 scripts/sync-lock.py       # skills-lock.json
python3 scripts/skills-graph.py    # SKILLS_GRAPH.md (mermaid)
bash scripts/sync-spec-kit-skills.sh # refresh speckit-* desde github/spec-kit
```

## Spec-Driven Development (Spec Kit)

10 skills core `speckit-*` en `skills/sdd/` (paridad con [github/spec-kit](https://github.com/github/spec-kit) v0.11.2) + routers `sdd-router`, `sdd-x-index`, `kitty-router`, `openspec-router`, `speckit-lifecycle-router`. Guía Spec Kit: [docs/SDD_SPECKIT_INTEGRATION.md](docs/SDD_SPECKIT_INTEGRATION.md). Lifecycle: [docs/SPEC_KIT_EXTENSIONS.md](docs/SPEC_KIT_EXTENSIONS.md). Spec Kitty: [docs/SPEC_KITTY_INTEGRATION.md](docs/SPEC_KITTY_INTEGRATION.md). awesome-spec-kits: [docs/AWESOME_SPEC_KITS.md](docs/AWESOME_SPEC_KITS.md).

## Spec Kit Extensions (lifecycle)

Bugfix, modify, refactor, hotfix, deprecate — skill `speckit-lifecycle-router`; install upstream en repo producto. Ver [docs/SPEC_KIT_EXTENSIONS.md](docs/SPEC_KIT_EXTENSIONS.md).

## Spec Kitty

Complemento SD-Development con runtime gobernado (`.kittify/`, `kitty-specs/`). Skills globales: `kitty-router`, `kitty-governance`. Instalación CLI en repo producto: `pipx install spec-kitty-cli` → `spec-kitty init . --ai cursor`. No reemplaza `speckit-*` ni migra repos con `.specify/` sin decisión explícita.

## OpenSpec (watchlist)

Flujo fluido brownfield (`openspec/`). Skill global: `openspec-router`. Install en producto: `npm i -g @fission-ai/openspec` → `openspec init`. Ver [docs/AWESOME_SPEC_KITS.md](docs/AWESOME_SPEC_KITS.md).

## Spec-Driven X (SD-X)

Mapa dev + diseño + docs + validate: [docs/SDX_ECOSYSTEM.md](docs/SDX_ECOSYSTEM.md). Toolkits: [catalog/SDX_TOOLKITS.md](catalog/SDX_TOOLKITS.md).

## UI UX Pro Max

Skill `ui-ux-pro-max` en `skills/ui/` — design system generator + BM25 ([upstream v2.5.0](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)). Guía: [docs/UI_UX_PRO_MAX_INTEGRATION.md](docs/UI_UX_PRO_MAX_INTEGRATION.md). Sync: `bash scripts/sync-ui-ux-pro-max.sh`.

## Open Design (artefactos agentic)

Carrusel RRSS, deck, email HTML, prototipos standalone — skills `open-design-router` + `open-design` (bin). Runtime: [nexu-io/open-design](https://github.com/nexu-io/open-design). Guía: [docs/OPEN_DESIGN_INTEGRATION.md](docs/OPEN_DESIGN_INTEGRATION.md). Install: `bash scripts/install-open-design-runtime.sh`.

## StrangeVerse (what-if y simulación)

Escenarios estratégicos y simulación multi-agente — skills `strategic-briefing-ops` + `scenario-router` + `scenario-analysis-ops` + `strangeverse` (bin). Upstream: [666ghj/MiroFish](https://github.com/666ghj/MiroFish) · Runtime: [Abrahan-Eagle/strangeverse](https://github.com/Abrahan-Eagle/strangeverse). Guías: [docs/MIROFISH_UPSTREAM.md](docs/MIROFISH_UPSTREAM.md), [docs/STRANGEVERSE_INTEGRATION.md](docs/STRANGEVERSE_INTEGRATION.md). Install: `bash scripts/install-strangeverse-runtime.sh`.

### ECC (harness Cursor)

Hooks, instincts, rules idioma, `ecc consult` — skills `ecc-router` + `ecc` (bin) + curated ops (`continuous-learning-v2`, `security-review-ecc`, `configure-ecc`). Upstream: [affaan-m/ecc](https://github.com/affaan-m/ecc) (MIT). Guía: [docs/ECC_INTEGRATION.md](docs/ECC_INTEGRATION.md). Install en repo producto: `bash scripts/install-ecc-runtime.sh --project-dir <repo>`. Sync curado: `bash scripts/sync-ecc-skills.sh`.

### Cyber Neo (auditoría seguridad)

Auditoría read-only 11 dominios, OWASP 2025, reporte MD — skills `cyber-neo-router` + `cyber-neo` + `cyber-neo-cli` (bin). Upstream: [Hainrixz/cyber-neo](https://github.com/Hainrixz/cyber-neo) (MIT). Guía: [docs/CYBER_NEO_INTEGRATION.md](docs/CYBER_NEO_INTEGRATION.md). Sync: `bash scripts/sync-cyber-neo-skill.sh`. CLI: `cyber-neo status|secrets|lockfiles`.

### Kalman Anomaly Defense (runtime)

Detección runtime con filtro Kalman + respuesta escalonada del agente — skills `kalman-anomaly-router` + `kalman-anomaly-defense`. Inspiración: [Medium — Mehmet Bahçeci](https://medium.com/@bahceci.mehmet/kalman-filter-ai-agents-a-smarter-way-to-detect-cyber-attacks-586ce34085ff). Guía: [docs/KALMAN_ANOMALY_INTEGRATION.md](docs/KALMAN_ANOMALY_INTEGRATION.md). Prototipo: `python3 skills/ops/kalman-anomaly-defense/scripts/kalman_1d_anomaly.py`. Complemento de Cyber Neo, no sustituto.

### Learning Loop (memoria sesión)

Scan mid-session + wrap-up con quality gates — skills `learning-loop-router` + `learning-loop`. Upstream: [melodykoh/learning-loop-skill](https://github.com/melodykoh/learning-loop-skill) (MIT v4.1). Guía: [docs/LEARNING_LOOP_INTEGRATION.md](docs/LEARNING_LOOP_INTEGRATION.md). Sync: `bash scripts/sync-learning-loop-skill.sh`. Complemento de `session-learner-ops`, no sustituto.

### skill-loop (orquestación multi-skill)

Loops automáticos impl→review→verify vía `skill-loop.yml` + CLI — skills `skill-loop-router` + `skill-loop`. Upstream: [takumiyoshikawa/skill-loop](https://github.com/takumiyoshikawa/skill-loop) (MIT). Guía: [docs/SKILL_LOOP_INTEGRATION.md](docs/SKILL_LOOP_INTEGRATION.md). Sync: `bash scripts/sync-skill-loop-skill.sh`. CLI: `bash scripts/install-skill-loop-runtime.sh`. No sustituye `jarvis-core` ni `learning-loop`.

### Agent Skills (Addy Osmani)

Revisión adversarial in-flight y router vs pack engineering — skills `agent-skills-router` + `doubt-driven-development`. Upstream: [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (MIT). Guía: [docs/AGENT_SKILLS_ADDY_INTEGRATION.md](docs/AGENT_SKILLS_ADDY_INTEGRATION.md). Sync: `bash scripts/sync-addy-doubt-driven.sh`. No sustituye `jarvis-core` ni `speckit-*`.

### Claude Skills (Alireza Rezvani)

Auditoría pre-install y router vs megapack 345 skills — skills `claude-skills-router` + `skill-security-auditor`. Upstream: [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) (MIT v2.9.0). Guía: [docs/CLAUDE_SKILLS_REZVANI_INTEGRATION.md](docs/CLAUDE_SKILLS_REZVANI_INTEGRATION.md). Sync: `bash scripts/sync-claude-skills-skill-security-auditor.sh`. No vendorizar el pack completo.

### Loop AI (gobernanza HITL)

Espectro HITL/HOTL/automation-bounded, umbrales de confianza y condiciones de terminación en bucles agénticos — skill `human-in-the-loop-ops`. Guía ecosistema: [docs/LOOP_AI_ECOSYSTEM.md](docs/LOOP_AI_ECOSYSTEM.md) (taxonomía threads P/C/F/B/L + ref [claudefa.st](https://claudefa.st/blog/guide/mechanics/autonomous-agent-loops)). Complementa `skill-loop-router`, `learning-loop-router` y `git-guardrails-ops`. Watchlist: `ralph-loop`, `claude-skills-rezvani` (autoresearch; solo auditor curado).

## Migración desde ~/jarvis-skills

Ver [docs/MIGRATION.md](docs/MIGRATION.md).

## Git hooks (opcional)

```bash
git config core.hooksPath .githooks
```

## Estructura

```
jarvis-skills-library/
├── AGENTS.md              # Guía para agentes IA
├── README.md              # Este archivo
├── catalog/CATALOG.md     # Índice auto-generado
├── docs/
│   ├── ARCHITECTURE.md    # Capas global vs dominio
│   ├── CONVENTIONS.md     # Formato YAML, dual-file, modos
│   ├── SDD_SPECKIT_INTEGRATION.md
│   └── SDX_ECOSYSTEM.md
├── scripts/
│   ├── install.sh         # Symlinks a IDE (--all para Cursor+Claude)
│   ├── validate-all.sh    # Validación completa
│   ├── validate-skills.sh
│   ├── validate-yaml.py
│   ├── sync-catalog.py
│   ├── sync-lock.py
│   ├── skills-graph.py
│   └── sync-spec-kit-skills.sh
├── skills-lock.json       # Provenance + hashes (generado)
├── skills/
│   ├── core/              # jarvis-core, sdd-router, sdd-x-index, ui-router, jarvis-skills-maintainer
│   ├── sdd/               # speckit-* (Spec Kit core)
│   ├── ops/               # context-updater, handoff, brainstorming-ops
│   ├── engineering/       # TDD, debugging, clean-code
│   ├── git/               # git-commit, git-guardrails-ops
│   ├── review/            # code-review-playbook
│   ├── planning/          # writing-plans, zoom-out
│   ├── backend/           # laravel-specialist, security
│   ├── mobile/            # flutter-expert
│   ├── ui/                # ui-ux-pro-max
│   └── non-code/          # approval-gate, client-report (OpenClaw-friendly)
└── templates/
    └── SKILL.template.md
```

## Relación con `~/jarvis-skills`

Este repo es la **fuente canónica** versionada bajo `proyectos/AIPP/`.  
Si tenías skills en `~/jarvis-skills`, puedes:

1. Usar solo este repo + `install.sh`, o
2. Sustituir `~/jarvis-skills` con un clone de este directorio.

## Referencias de diseño

- CorralX: `MAINTENANCE_SKILLS.md` (capas 0/1/2, sync en dominio)
- clawvis-openclaw: `SKILLS_CONVENCIONES.md` (SKILL-OC.md, validate-skills, modos)

---

**Mantenimiento:** editar skills aquí → validar → `install.sh` → los proyectos leen `~/.cursor/skills` sin tocar sus repos.
