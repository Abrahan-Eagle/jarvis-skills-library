# Claude Skills (Rezvani) — integración JARVIS

[alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) (MIT) — 345+ skills, plugins y scripts para Claude Code, Codex, Cursor y otros agentes.

Skills JARVIS: `claude-skills-router` (decisión) + `skill-security-auditor` (sync curado upstream).

## Fuentes oficiales

- Repo: [github.com/alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills)
- Pin JARVIS: tag **`v2.9.0`** (`CLAUDE_SKILLS_REZVANI_REF` en `scripts/sync-claude-skills-skill-security-auditor.sh`)
- Licencia: MIT
- Forense: [docs/CLAUDE_SKILLS_REZVANI_FORENSE_JARVIS.md](CLAUDE_SKILLS_REZVANI_FORENSE_JARVIS.md)

## vs JARVIS canónico

| Necesidad | Usar |
|-----------|------|
| Workflow módulo / precedencia | **`jarvis-core`** (primero) |
| Spec / plan / tasks | `sdd-router` → `speckit-*` |
| TDD / implementación | `test-driven-development` + dominio `{producto}-*` |
| Review pre-merge | `code-review-playbook` |
| Seguridad app / API | `security`, `cyber-neo-router` |
| **Auditar skill antes de instalar** | **`claude-skills-router` → `skill-security-auditor`** |
| Loop autónomo impl→review | `skill-loop-router` + `human-in-the-loop-ops` |
| Revisión adversarial in-flight | `agent-skills-router` → `doubt-driven-development` |
| Skill Rezvani sin curar | Pack externo tras auditoría — ver forense |

## Arquitectura

```
Cursor (~/.cursor/skills vía install.sh)
  ├─ claude-skills-router
  └─ skill-security-auditor (+ scripts Python stdlib)
Runtime: python3 scripts/skill_security_auditor.py <path>
Pack externo opcional: /plugin marketplace add alirezarezvani/claude-skills
```

## Instalación

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install.sh --all
```

### Sync upstream (mantenedores)

```bash
bash scripts/sync-claude-skills-skill-security-auditor.sh
bash scripts/smoke-claude-skills-skill-security-auditor.sh
bash scripts/validate-all.sh
```

### Pack completo externo (opcional)

**No** copiar las 345 skills a `jarvis-skills-library`.

- Claude Code: `/plugin marketplace add alirezarezvani/claude-skills`
- Cursor: skills globales JARVIS; skill puntual del clone solo tras `skill-security-auditor` PASS.

## Uso en Cursor

### Pre-install audit

```bash
python3 skills/ops/skill-security-auditor/scripts/skill_security_auditor.py /path/to/skill/ --strict
bash scripts/validate-skills.sh --check-net-exec /path/to/skill/SKILL.md
```

| Veredicto | Acción |
|-----------|--------|
| PASS | Instalar / sync |
| WARN | Revisión humana |
| FAIL | No instalar |

### Cuándo **no** usar el pack Rezvani

- Flujo módulo JARVIS ya definido → canónico global
- Marketing RRSS CorralX / clawvis → skills dominio en `clawvis-openclaw`
- Lanzamiento Zonix → `zonix-lanzamiento-*` en Backend

## Supply-chain

Antes de copiar cualquier `SKILL.md` del pack:

1. `skill-security-auditor` (--strict recomendado)
2. `validate-skills.sh --check-net-exec`
3. Revisión humana si WARN

Ver sección *AI Skill supply-chain* en skill `security`.

## Matriz overlap (resumen)

Ver tabla completa por dominio en [CLAUDE_SKILLS_REZVANI_FORENSE_JARVIS.md](CLAUDE_SKILLS_REZVANI_FORENSE_JARVIS.md). Solo **`skill-security-auditor`** se sincroniza a la library.

## Cruces

- Loop autónomo `autoresearch-agent` → [LOOP_AI_ECOSYSTEM.md](LOOP_AI_ECOSYSTEM.md)
- Pack Addy → [AGENT_SKILLS_ADDY_INTEGRATION.md](AGENT_SKILLS_ADDY_INTEGRATION.md)
