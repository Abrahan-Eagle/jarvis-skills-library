# Overlay UI — {PRODUCTO}

> Copiar este archivo al repo del producto como `ZONIX.md`, `CORRALX.md` u `OVERLAY.md`
> bajo `.cursor/skills/ui-ux-pro-max/` (skill global vía `install.sh --all`).
> **No** copiar `data/`, `scripts/` ni `SKILL.md` completos.

## Producto

- **Nombre:** {Nombre en UI}
- **Vertical:** {Pharma / Marketplace ganadero / SaaS / …}
- **Stack UI:** {Flutter / Blade+CSS / Next.js / …}

## Fuente canónica de tokens (obligatorio leer primero)

| Recurso | Ruta |
|---------|------|
| Brand doc | `{docs/BRAND_*.md}` |
| Tokens código | `{lib/features/utils/app_colors.dart}` o `{lib/config/corral_x_theme.dart}` |
| Skill dominio | `{zonix-ui-design / corralx-ui-design}` |

## Skills dominio (precedencia sobre ui-ux-pro-max)

1. `{producto}-ui-design` — tokens, componentes, M3/HIG
2. `{zonix-web-design}` — solo landing/web Blade/CSS
3. `ui-router` — cadena completa antes de diseñar

## Queries BM25 sugeridas (ui-ux-pro-max)

```bash
export UI_UX_SKILL_ROOT="${UI_UX_SKILL_ROOT:-$HOME/.cursor/skills/ui-ux-pro-max}"

# Design system (usar tokens del producto al implementar)
python3 "$UI_UX_SKILL_ROOT/scripts/search.py" "{rubro + tono}" \
  --design-system -p "{Producto}" -f markdown

# Stack
python3 "$UI_UX_SKILL_ROOT/scripts/search.py" "{navigation forms cards}" --stack {flutter|nextjs|html-tailwind}
```

## Anti-patterns del rubro

- {Ej: no mezclar copy/claims de otro vertical del ecosistema}
- {Ej: no usar `Colors.*` / hex sueltos fuera de AppColors}
- {Ej: claims médicos sin copy regulatorio}

## No override (explícito)

- **ui-ux-pro-max** no sustituye paleta, tipografía ni wordmark de este producto.
- CSV de colores/fuentes del design system son *referencia*; implementar con tokens canónicos.
- Si hay conflicto: gana brand doc + skill dominio.
