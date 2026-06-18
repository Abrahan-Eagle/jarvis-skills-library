#!/usr/bin/env python3
"""Patch ui-ux-pro-max for jarvis-skills-library: frontmatter, stacks, paths, JARVIS overlay."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILL_DIR = ROOT / "skills" / "ui" / "ui-ux-pro-max"
SKILL_MD = SKILL_DIR / "SKILL.md"
UPSTREAM_MD = SKILL_DIR / "SKILL.upstream.md"
CORE_PY = SKILL_DIR / "scripts" / "core.py"

UI_UX_VERSION = "2.5.0"
UI_UX_TAG = f"v{UI_UX_VERSION}"
OVERLAY_MARKER = "## JARVIS Integration (mandatory)"

DESCRIPTION = (
    "UI/UX design intelligence: design system generator, 67+ styles, palettes, typography, "
    "UX guidelines, charts, google-fonts domain, stacks Flutter/React/Next/Vue/Tailwind/shadcn. "
    "Trigger: design UI, landing, dashboard, review UX, a11y, color palette, layout."
)

STACK_CONFIG_BLOCK = '''
STACK_CONFIG = {
    "html-tailwind": {"file": "stacks/html-tailwind.csv"},
    "react": {"file": "stacks/react.csv"},
    "nextjs": {"file": "stacks/nextjs.csv"},
    "astro": {"file": "stacks/astro.csv"},
    "vue": {"file": "stacks/vue.csv"},
    "nuxtjs": {"file": "stacks/nuxtjs.csv"},
    "nuxt-ui": {"file": "stacks/nuxt-ui.csv"},
    "svelte": {"file": "stacks/svelte.csv"},
    "swiftui": {"file": "stacks/swiftui.csv"},
    "react-native": {"file": "stacks/react-native.csv"},
    "flutter": {"file": "stacks/flutter.csv"},
    "shadcn": {"file": "stacks/shadcn.csv"},
    "jetpack-compose": {"file": "stacks/jetpack-compose.csv"}
}
'''

JARVIS_OVERLAY = """
## JARVIS Integration (mandatory)

Para la cadena completa de precedencia, invocar **`ui-router`** primero.

### Precedencia de marca (producto activo)

1. Brand canon del producto (`docs/BRAND_*.md`, `corralx-ui-design`, `zonix-ui-design`, `zonix-web-design`)
2. `zonix-design-enforcer` / `responsive-design` (layout, WCAG, 8pt grid)
3. **Esta skill** — patrones UX, anti-patterns, design system generator (no override tokens de marca)
4. `frontend-design` — solo si no hay skill de dominio UI

**Regla:** Paletas y fuentes del CSV son *ideas*; implementar con tokens del producto (`AppColors`, tema M3, `zonix.css`).

### Overlay por producto (opcional en repo)

Si existe `ui-ux-pro-max/OVERLAY.md` o `ZONIX.md` / `CORRALX.md` junto a la skill del producto, leerlo antes del design system.

### Script path (global install)

```bash
export UI_UX_SKILL_ROOT="${UI_UX_SKILL_ROOT:-$HOME/.cursor/skills/ui-ux-pro-max}"
python3 "$UI_UX_SKILL_ROOT/scripts/search.py" "<query>" --design-system -p "Project"
```

Desde `jarvis-skills-library`: `skills/ui/ui-ux-pro-max/scripts/search.py`.

### Stacks JARVIS

Upstream v2.5.0 solo incluye `react-native` en stacks; esta biblioteca **restaura 13 stacks** (Flutter, Tailwind, shadcn, etc.) vía `patch-ui-ux-pro-max.py` tras sync.
"""

FRONTMATTER_RE = re.compile(r"^---\s*\n.*?\n---\s*\n", re.DOTALL)


def build_frontmatter() -> str:
    return f"""---
name: ui-ux-pro-max
description: >
  {DESCRIPTION}
license: MIT
metadata:
  author: nextlevelbuilder
  version: "{UI_UX_VERSION}+jarvis-stacks"
  upstream: nextlevelbuilder/ui-ux-pro-max-skill:v{UI_UX_VERSION}
  category: ui
  auto_invoke:
    - "Diseñar UI o UX"
    - "Revisar accesibilidad o layout"
    - "Landing page o dashboard"
    - "Paleta de colores o tipografía"
  related-skills:
    - ui-router
    - responsive-design
    - jarvis-core
---

"""


def restore_stack_config() -> None:
    text = CORE_PY.read_text(encoding="utf-8")
    new_text, n = re.subn(
        r"STACK_CONFIG = \{.*?\n\}",
        STACK_CONFIG_BLOCK.strip(),
        text,
        count=1,
        flags=re.DOTALL,
    )
    if n != 1:
        raise SystemExit("Could not patch STACK_CONFIG in core.py")
    CORE_PY.write_text(new_text, encoding="utf-8")
    print("Restored full STACK_CONFIG in core.py")


def fix_script_paths(body: str) -> str:
    replacement = 'python3 "${UI_UX_SKILL_ROOT:-$HOME/.cursor/skills/ui-ux-pro-max}/scripts/'
    body = body.replace("python3 skills/ui-ux-pro-max/scripts/", replacement)
    # Add env export once after first heading if missing
    if "UI_UX_SKILL_ROOT" not in body.split("## Prerequisites")[0]:
        inject = (
            "\n\n### Skill root (JARVIS)\n\n"
            "```bash\n"
            "export UI_UX_SKILL_ROOT=\"${UI_UX_SKILL_ROOT:-$HOME/.cursor/skills/ui-ux-pro-max}\"\n"
            "```\n"
        )
        body = body.replace("# UI/UX Pro Max", "# UI/UX Pro Max" + inject, 1)
    return body


def strip_overlay(body: str) -> str:
    idx = body.find(OVERLAY_MARKER)
    if idx == -1:
        return body.rstrip() + "\n"
    return body[:idx].rstrip() + "\n"


def patch_skill_md() -> None:
    if not UPSTREAM_MD.exists():
        raise SystemExit(f"Missing {UPSTREAM_MD} — run sync-ui-ux-pro-max.sh first")
    up = UPSTREAM_MD.read_text(encoding="utf-8")
    m = FRONTMATTER_RE.match(up)
    body = up[m.end():].lstrip("\n") if m else up
    body = fix_script_paths(body)
    body = strip_overlay(body) + "\n\n" + JARVIS_OVERLAY.lstrip("\n")
    SKILL_MD.write_text(build_frontmatter() + body, encoding="utf-8")
    UPSTREAM_MD.unlink()
    print("Patched SKILL.md")


def main() -> None:
    restore_stack_config()
    patch_skill_md()


if __name__ == "__main__":
    main()
