# Open Design — integración JARVIS global

[Fábrica visual local-first](https://github.com/nexu-io/open-design): prototipos HTML, carruseles, decks, emails, imágenes, HyperFrames (MP4). **100+ skills** y **150 design systems** (`DESIGN.md`) en el runtime OD — no se sincronizan al global.

Skills JARVIS: `open-design-router` (decisión) + `open-design` (bin HTTP al daemon).

## vs ui-ux-pro-max vs código en repo

| Necesidad | Usar |
|-----------|------|
| Pantalla Flutter / Blade en el producto | `ui-router` → `{producto}-ui-design` |
| Tokens/paleta para implementar en código | `ui-ux-pro-max` `--design-system` |
| Carrusel RRSS, deck, email HTML, prototipo entregable | `open-design-router` → `open-design` |
| Spec Kit feature con UI en `lib/` | `sdd-router` + `ui-router` en implement |

## Arquitectura

```
Cursor / JARVIS
  ├─ skill open-design-router (decisión)
  ├─ bin open-design → HTTP daemon :17456
  ├─ MCP od (opcional: od mcp install cursor)
  └─ motor: cursor-agent | openclaw (clawvis) | BYOK
Open Design UI :7456
```

## Instalación runtime

### Script JARVIS

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install-open-design-runtime.sh
```

Docker si `docker compose` disponible; else modo fuente (Node 24 + pnpm).

### Alternativas upstream

```bash
# Desktop app (sin clone): https://open-design.ai/
curl -fsSL https://open-design.ai/install.sh | sh -s cursor
od mcp install cursor
```

### Variables

| Variable | Default |
|----------|---------|
| `OPEN_DESIGN_HOME` | `$HOME/open-design` |
| `OD_DAEMON_URL` | `http://127.0.0.1:17456` |
| `OD_WEB_URL` | `http://127.0.0.1:7456` |
| `OD_API_TOKEN` | en `$OPEN_DESIGN_HOME/deploy/.env` |

## Flujo Cursor

```bash
open-design status
open-design agents
open-design generate \
  --prompt "Carrusel 3 slides: confianza, trazabilidad, CTA" \
  --skill social-carousel \
  --design-system vercel \
  --agent cursor-agent \
  --out ./out/carousel/
```

Incluir contexto de marca del producto en `--prompt`. Antes de publicar: `publish-safety`.

## OpenClaw

Stack gateway en clawvis: `jarvis-ecosystem/docs/OPEN_DESIGN_JARVIS.md` — agent `openclaw`, MCP registrado en `openclaw.json`. El global canónico es para **Cursor en cualquier proyecto**.

## Licencia

Open Design: Apache-2.0. Atribuir [nexu-io/open-design](https://github.com/nexu-io/open-design) al publicar derivados.

## Relacionado

- [UI_UX_PRO_MAX_INTEGRATION.md](UI_UX_PRO_MAX_INTEGRATION.md)
- [SDX_ECOSYSTEM.md](SDX_ECOSYSTEM.md)
- Skill `open-design-router`
