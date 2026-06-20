# UI UX Pro Max + JARVIS

Integración de [ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) en la biblioteca global.

Orquestación: skill **`ui-router`** (precedencia producto → dominio → BM25 → responsive).

## Qué hace

- **Design System Generator** (`--design-system`): producto + estilo + colores + tipografía + anti-patterns
- **Dominios BM25**: product, style, color, landing, typography, ux, chart, google-fonts, web (app-interface)
- **Stacks**: Flutter, React, Next.js, Vue, Tailwind, shadcn, SwiftUI, Jetpack Compose, etc.

## Sync upstream

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/sync-ui-ux-pro-max.sh   # UI_UX_TAG=v2.5.0, stacks from v2.3.0 + react-native v2.5
bash scripts/validate-all.sh
bash scripts/install.sh --all
```

Pin: **v2.5.0** contenido + **stacks v2.3.0** (upstream v2.5 solo publica `react-native` stack CSV).

## Uso en Cursor

Invocar **`ui-router`** primero en tareas UI no triviales; luego:

```bash
export UI_UX_SKILL_ROOT="${UI_UX_SKILL_ROOT:-$HOME/.cursor/skills/ui-ux-pro-max}"

# Design system en markdown (planes, PRs, specs)
python3 "$UI_UX_SKILL_ROOT/scripts/search.py" "pharmacy healthcare trust" \
  --design-system -p "My App" -f markdown

python3 "$UI_UX_SKILL_ROOT/scripts/search.py" "minimal dark" --domain style
python3 "$UI_UX_SKILL_ROOT/scripts/search.py" "forms navigation" --stack flutter
python3 "$UI_UX_SKILL_ROOT/scripts/search.py" "sans serif professional" --domain google-fonts
```

## Precedencia con productos JARVIS

| Producto | Skill dominio (tokens) | Overlay opcional |
|----------|------------------------|------------------|
| Zonix Pharma | `zonix-ui-design`, `zonix-web-design`, BRAND doc | `ZonixPharma-Front/.cursor/skills/ui-ux-pro-max/ZONIX.md` |
| CorralX | `corralx-ui-design` | `CORRALX.md` desde template |

**ui-ux-pro-max** no sustituye paleta/tipografía de marca; aporta layout, a11y, patrones y checklist pre-entrega.

Cadena completa: ver `skills/core/ui-router/SKILL.md`.

## Overlay sin duplicar `data/`

Template: [`skills/ui/ui-ux-pro-max/overlays/OVERLAY.template.md`](skills/ui/ui-ux-pro-max/overlays/OVERLAY.template.md).

En el repo producto:

1. Instalar skill global: `bash scripts/install.sh --all` (desde jarvis-skills-library).
2. Copiar solo el overlay como `ZONIX.md` / `CORRALX.md` bajo `.cursor/skills/ui-ux-pro-max/`.
3. **No** copiar `SKILL.md`, `scripts/` ni `data/` al producto.

## Persistencia (opcional)

```bash
python3 "$UI_UX_SKILL_ROOT/scripts/search.py" "<query>" \
  --design-system --persist -p "Project" --page "dashboard" -f markdown
```

Crea `design-system/MASTER.md` y overrides por página en el repo activo.

## Cuándo usar Open Design (no ui-ux-pro-max)

Para **entregables visuales standalone** (carrusel RRSS, deck PPTX, email HTML, prototipo sin tocar `lib/`), usar `open-design-router` → skill `open-design` — ver [OPEN_DESIGN_INTEGRATION.md](OPEN_DESIGN_INTEGRATION.md).

## Landings con media generativa IA (no ui-ux-pro-max)

Para **landings con video hero generado por IA** (cadena Claude → Nano Banana 2 → Veo/Kling → Claude Design → Claude Code), usar skill **`ai-media-landing-ops`** — metodología multi-tool con checkpoints humanos. No sustituye `ui-ux-pro-max` para tokens/patrones al implementar UI en código; complementa el draft HTML antes de portar vía `ui-router`.

`ui-ux-pro-max` sigue siendo la herramienta para **tokens, patrones y checklist** al implementar UI en código (Flutter, Blade).

## Validación

```bash
bash scripts/validate-ui-ux-pro-max.sh
# o
bash scripts/validate-all.sh
```
