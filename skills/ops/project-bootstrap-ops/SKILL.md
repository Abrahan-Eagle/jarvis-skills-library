---
name: project-bootstrap-ops
description: >
  Diagnosticar e integrar jarvis-skills-library en proyecto nuevo o legacy: globales en máquina,
  AGENTS.md, manifest sync, marcadores SDD. Trigger: init jarvis, nuevo proyecto JARVIS,
  integrar skills library, repo sin AGENTS.md, adoptar JARVIS en proyecto existente.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.2"
  scope: [global]
  category: ops
  auto_invoke:
    - "init jarvis"
    - "Init JARVIS"
    - "Integrar jarvis-skills-library en proyecto"
    - "Nuevo proyecto JARVIS"
    - "Repo sin AGENTS.md"
    - "Adoptar JARVIS en proyecto existente"
    - "Bootstrap skills en producto"
  triggers: init jarvis, project onboarding, bootstrap jarvis, adopt skills library, greenfield jarvis, legacy jarvis
  related-skills:
    - jarvis-core
    - jarvis-skills-maintainer
    - sdd-router
    - claude-skills-router
    - skill-security-auditor
    - human-in-the-loop-ops
    - fan-out-synthesize-ops
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# Project Bootstrap Ops

Skill global para **diagnosticar** y **guiar** la adopción de jarvis-skills-library en un repo de producto. No sustituye `jarvis-core` en el día a día; se usa al inicio o cuando falta configuración.

Doc canónica: [docs/PROJECT_ONBOARDING.md](../../docs/PROJECT_ONBOARDING.md).

## Comando `init jarvis`

Frase canónica del usuario (chat Agent o terminal):

| Contexto | Acción |
|----------|--------|
| **Cursor Agent** | Escribir `init jarvis` → leer esta skill, ejecutar diagnóstico, emitir informe § Paso 2 |
| **Terminal** (repo producto) | `bash /path/to/jarvis-skills-library/scripts/init-jarvis.sh` |

Opcional: `--min b` o `--min c` (Paso B / Paso C mínimo). Ver [check-project-bootstrap.sh](../../scripts/check-project-bootstrap.sh).

## Cuándo usar

- Proyecto greenfield o legacy **sin** `AGENTS.md` / `.agents/skills/` JARVIS.
- Usuario pide "integrar JARVIS", "instalar skills globales" o "configurar el proyecto para Cursor".
- Tras clonar un repo ajeno con skills de terceros — evaluar convivencia antes de cambios.
- **No** usar en `jarvis-skills-library` (solo capa 0 global; ver `jarvis-skills-maintainer`).

## Reglas

1. **No ejecutar `install.sh` ni modificar `~/.cursor/skills/`** sin orden explícita del usuario (capa máquina).
2. **No borrar** skills ajenas en `.agents/skills/` sin auditoría (`skill-security-auditor`) y OK usuario.
3. **Leer** [PROJECT_ONBOARDING.md](../../docs/PROJECT_ONBOARDING.md) antes de proponer cambios en el repo.
4. Emitir informe estructurado (plantilla abajo) en la primera respuesta útil.
5. Cambios en el repo de producto (crear `AGENTS.md`, manifest, scripts): pedir OK antes de escribir archivos.

## Paso 1 — Detección (repo activo)

Ejecutar desde la raíz del **repo de producto** (no desde jarvis-skills-library):

```bash
# Preferido — script canónico
bash /path/to/jarvis-skills-library/scripts/check-project-bootstrap.sh
# Nivel mínimo requerido (exit 1 si no cumple):
bash /path/to/jarvis-skills-library/scripts/check-project-bootstrap.sh --min b
bash /path/to/jarvis-skills-library/scripts/check-project-bootstrap.sh --min c
```

Checks manuales equivalentes si no hay ruta a la library:

```bash
# Capa 0 — máquina
JC="${HOME}/.cursor/skills/jarvis-core"
if [ -L "$JC" ]; then
  target="$(readlink -f "$JC")"
  echo "GLOBAL_SYMLINK=$target"
  case "$target" in
    *jarvis-skills-library*) echo "GLOBAL_STATE=OK" ;;
    *jarvis-skills*) echo "GLOBAL_STATE=LEGACY" ;;
    *) echo "GLOBAL_STATE=UNKNOWN" ;;
  esac
elif [ -d "$JC" ]; then
  echo "GLOBAL_DIR_NOT_SYMLINK=$JC"
else
  echo "GLOBAL_MISSING=jarvis-core"
fi

# Capa 1 — producto
test -f AGENTS.md && echo HAS_AGENTS || echo MISSING_AGENTS
test -d .agents/skills && echo HAS_LOCAL_SKILLS || echo MISSING_LOCAL_SKILLS
test -f .agents/skills/.global-sync-manifest && echo HAS_MANIFEST || echo NO_MANIFEST
test -f MAINTENANCE_SKILLS.md && echo HAS_MAINTENANCE || echo NO_MAINTENANCE
test -f scripts/sync-global-skills-from-library.sh && echo HAS_SYNC_SCRIPT || echo NO_SYNC_SCRIPT
test -f scripts/check-global-skills-sync.sh && echo HAS_CHECK_SCRIPT || echo NO_CHECK_SCRIPT
test -d .cursor/skills && echo WARN_REPO_GLOBAL_SKILLS

echo "JARVIS_SKILLS_LIBRARY=${JARVIS_SKILLS_LIBRARY:-/var/www/html/proyectos/AIPP/jarvis-skills-library}"

# Marcadores SDD
for d in .kittify openspec .specify .agents/plans specs; do
  if [ -d "$d" ]; then
    label="${d//\//_}"
    echo "HAS_${label}"
  fi
done

# Skill bootstrap (opcional CorralX)
test -f .agents/skills/jarvis-core/OVERLAY.md && echo HAS_JARVIS_CORE_OVERLAY
test -f .agents/skills/SKILL_INDEX.md && echo HAS_SKILL_INDEX

find .agents/skills -maxdepth 3 -name 'SKILL.md' 2>/dev/null | wc -l
```

Interpretación:

| Señal | Nivel bootstrap recomendado |
|-------|----------------------------|
| `GLOBAL_MISSING`, `GLOBAL_DIR_NOT_SYMLINK` o `GLOBAL_STATE=LEGACY` | **Paso A** — [MIGRATION.md](../../docs/MIGRATION.md) + `install.sh --all` |
| `MISSING_AGENTS` o `MISSING_LOCAL_SKILLS` | **Paso B** — plantilla [`AGENTS.minimal.md`](../../docs/templates/AGENTS.minimal.md) |
| `WARN_REPO_GLOBAL_SKILLS` | Advertir: no versionar globales en repo; usar `~/.cursor/skills/` |
| Producto AIPP / equipo / overlays | **Paso C** — manifest [`global-sync-manifest.example`](../../docs/templates/global-sync-manifest.example) + sync + CI |
| `HAS_MANIFEST` + scripts sync | Ejecutar check; `JARVIS_SKILLS_LIBRARY` debe apuntar a library válida |
| `HAS_JARVIS_CORE_OVERLAY` / `HAS_SKILL_INDEX` | Skill Bootstrap CorralX activo — ver [CORRALX_INTEGRATION.md](../../docs/CORRALX_INTEGRATION.md) |

## Paso 2 — Informe (plantilla de respuesta)

```markdown
> Skills: project-bootstrap-ops

## Diagnóstico JARVIS — {nombre-repo}

| Check | Estado |
|-------|--------|
| Globales ~/.cursor/skills/jarvis-core | {OK / LEGACY / MISSING / NOT_SYMLINK} |
| `.cursor/skills/` en repo producto | {NO / WARN_REPO_GLOBAL_SKILLS} |
| `JARVIS_SKILLS_LIBRARY` | {path + LIBRARY_OK / LIBRARY_MISSING} |
| AGENTS.md | {OK / MISSING} |
| .agents/skills/ | {OK / MISSING} ({N} skills) |
| .global-sync-manifest | {OK / NO} |
| Sync scripts | {OK / NO} |
| Flujo SDD | {kitty / openspec / speckit / jarvis-plans / ninguno} |

## Recomendación

- **Paso A (máquina):** {comandos o "ya OK"}
- **Paso B (repo mínimo):** {lista archivos a crear}
- **Paso C (equipo):** {sí/no — motivo}

## Skills ajenas detectadas

{lista o "ninguna"}

## Próximo paso

{una acción concreta; pedir OK antes de escribir archivos}
```

## Paso 3 — Acciones permitidas (con OK usuario)

| Acción | Referencia |
|--------|------------|
| Crear `AGENTS.md` mínimo | [`AGENTS.minimal.md`](../../docs/templates/AGENTS.minimal.md) |
| Crear manifest Paso C | [`global-sync-manifest.example`](../../docs/templates/global-sync-manifest.example) |
| Crear skill `{producto}-*` | `init_skill.py` en `.agents/skills/` |
| Copiar manifest + scripts desde CorralX/clawvis | [CORRALX_INTEGRATION.md](../../docs/CORRALX_INTEGRATION.md) |
| Bootstrap Spec Kit | [SDD_SPECKIT_INTEGRATION.md](../../docs/SDD_SPECKIT_INTEGRATION.md) |
| Auditar skills de terceros | `claude-skills-router` → `skill-security-auditor` |

## Paso 4 — Handoff al flujo normal

Tras bootstrap mínimo:

1. **`jarvis-core`** — workflow diario.
2. **`fan-out-synthesize-ops`** — orquestación por defecto (Map-Reduce agentico) en tareas no triviales.
3. **`sdd-router`** / **`kitty-router`** / **`openspec-router`** — según marcadores detectados.
4. **`jarvis-skills-maintainer`** — solo si el usuario edita la library global.

## Anti-patrones

- Ejecutar `install.sh` sin permiso del usuario.
- Copiar 100+ skills globales al repo en lugar de manifest.
- `specify init` dentro de jarvis-skills-library.
- Declarar "JARVIS integrado" sin `AGENTS.md` y sin globales en máquina verificadas.
