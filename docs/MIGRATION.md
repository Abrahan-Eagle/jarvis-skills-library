# Migración a jarvis-skills-library

Guía para apuntar Cursor (y otros IDEs) al repositorio canónico de skills globales.

## Antes y después

| Estado | `~/.cursor/skills/jarvis-core` apunta a |
|--------|----------------------------------------|
| Legacy | `~/jarvis-skills/skills/core/jarvis-core` |
| Canónico | `/var/www/html/proyectos/AIPP/jarvis-skills-library/skills/core/jarvis-core` |

Los repos de producto (CorralX, Zonix, clawvis) **no cambian**: siguen usando `.agents/skills/` para dominio y referencian skills globales por **nombre** en `AGENTS.md`.

## Pasos

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library

# 1. Validar
bash scripts/validate-all.sh

# 2. Regenerar catálogo y lock
python3 scripts/sync-catalog.py
python3 scripts/sync-lock.py

# 3. Instalar symlinks (Cursor + Claude Code)
bash scripts/install.sh --all

# 4. Verificar
readlink -f ~/.cursor/skills/jarvis-core
# Debe terminar en: .../jarvis-skills-library/skills/core/jarvis-core
```

## Qué hacer con `~/jarvis-skills`

Opciones (elige una):

1. **Archivar:** renombrar a `~/jarvis-skills.bak` tras verificar `install.sh`.
2. **Symlink al repo:** `ln -sfn /var/www/html/proyectos/AIPP/jarvis-skills-library ~/jarvis-skills`
3. **Eliminar** solo si `install.sh` ya enlazó todo y no hay otros scripts que lean `~/jarvis-skills` directamente.

## Flujo de mantenimiento

```bash
# Editar skill en skills/<categoria>/<nombre>/SKILL.md
bash scripts/validate-all.sh
python3 scripts/sync-catalog.py
python3 scripts/sync-lock.py
bash scripts/install.sh --all   # solo si cambió nombre o nueva skill
```

## Hook pre-commit (opcional)

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
git config core.hooksPath .githooks
```

Valida y regenera catálogo/lock antes de cada commit en **este repo solamente**.

## No migrar skills de dominio

Skills `corralx-*`, `zonix-*`, marketing de clawvis, etc. permanecen en sus repos. Este proyecto es solo **capa 0 global**.
