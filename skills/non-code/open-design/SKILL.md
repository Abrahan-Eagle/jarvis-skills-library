---
name: open-design
description: >
  Fábrica visual local via daemon Open Design: generate carrusel, deck, email, prototipos HTML.
  Trigger: open-design generate, artefacto visual, daemon OD.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: non-code
  auto_invoke:
    - "Generar con Open Design"
    - "open-design generate"
  triggers: open-design, OD daemon, design factory
  related-skills:
    - open-design-router
    - ui-router
    - publish-safety
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# open-design — fábrica visual (daemon API)

Puente HTTP al daemon de [Open Design](https://github.com/nexu-io/open-design). Router: `open-design-router`. Doc: [docs/OPEN_DESIGN_INTEGRATION.md](../../docs/OPEN_DESIGN_INTEGRATION.md).

**Bin:** `skills/non-code/open-design/bin/open-design` (symlink en `~/.cursor/skills/open-design/bin/` tras `install.sh`).

## Prerequisitos

1. Runtime OD en marcha (daemon `:17456`, UI `:7456`).
2. `OD_API_TOKEN` en entorno o en `$OPEN_DESIGN_HOME/deploy/.env`.
3. Motor disponible: `open-design agents` con al menos uno `available=True`.

## Comandos

```bash
open-design status
open-design skills
open-design design-systems
open-design agents

open-design generate \
  --prompt "Carrusel 3 slides sobre Zonix Pharma: OTC, receta, entrega" \
  --skill social-carousel \
  --design-system vercel \
  --agent cursor-agent \
  --out ./out/zonix-carousel/

open-design files --project <project-id>
open-design fetch --project <id> --file index.html --out /tmp/preview.html
open-design export-artifacts --project <id> --out ./out/export/
```

## Variables

| Variable | Default | Proposito |
|----------|---------|-----------|
| `OD_DAEMON_URL` | `http://127.0.0.1:17456` | API daemon |
| `OD_WEB_URL` | `http://127.0.0.1:7456` | UI web |
| `OD_API_TOKEN` | `$OPEN_DESIGN_HOME/deploy/.env` | Bearer auth |
| `OPEN_DESIGN_HOME` | `$HOME/open-design` | Clone runtime |
| `JARVIS_OUT_DIR` | `./out/open-design` | Salida por defecto |

## Cursor vs OpenClaw

- **Cursor:** `--agent cursor-agent`
- **OpenClaw:** `--agent openclaw` (stack clawvis; ver `OPEN_DESIGN_JARVIS.md` allí)

## MCP alternativo

Con CLI `od` instalado: `od mcp install cursor` — herramientas MCP en Cursor sin bin HTTP manual.

## Relación con otras skills

- `ui-ux-pro-max`: tokens y patrones para **código** en repo; OD para **artefactos** standalone.
- `publish-safety`: antes de publicar assets generados.

## Instalación runtime

```bash
bash scripts/install-open-design-runtime.sh
```
