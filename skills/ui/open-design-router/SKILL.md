---
name: open-design-router
description: >
  Orquesta artefactos visuales standalone via Open Design (carrusel, deck, email, prototipo)
  vs implementacion en codigo (ui-router). Trigger: carrusel RRSS, deck, email marketing, prototipo HTML.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: ui
  auto_invoke:
    - "Carrusel RRSS o post social"
    - "Deck o presentacion visual"
    - "Email marketing HTML"
    - "Prototipo landing sin codigo en repo"
    - "Generar assets visuales marketing"
  triggers: open-design, carrusel, carousel, deck, pptx, email marketing, hyperframe, prototipo html
  related-skills:
    - ui-router
    - ui-ux-pro-max
    - open-design
    - ai-media-landing-ops
    - publish-safety
    - jarvis-core
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# Open Design Router

Router para **artefactos visuales standalone** (HTML, deck, carrusel, email, MP4) via [Open Design](https://github.com/nexu-io/open-design). Complementa `ui-router` (pantallas en Flutter/Blade).

Guía JARVIS: [docs/OPEN_DESIGN_INTEGRATION.md](../../docs/OPEN_DESIGN_INTEGRATION.md).

## Detección runtime

```bash
curl -sf -o /dev/null -w "%{http_code}" http://127.0.0.1:17456/api/health 2>/dev/null || echo 000
command -v od >/dev/null && echo OD_CLI
test -d "${OPEN_DESIGN_HOME:-$HOME/open-design}" && echo OD_HOME
```

| Señal | Interpretación |
|-------|----------------|
| health `200` | Daemon listo → `open-design` bin o MCP |
| `OD_CLI` | CLI upstream instalado → `od mcp install cursor` posible |
| Sin daemon | Fallback: `ui-ux-pro-max` design-system + plan manual; o instalar runtime |

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| Pantalla/componente en app (Flutter, Blade) | `ui-router` → `{producto}-ui-design` | Open Design para producción app |
| Carrusel/post RRSS, deck, email HTML, landing prototipo, wireframe | `open-design` (si daemon up) | HTML suelto sin plan |
| Solo tokens/paleta para código | `ui-ux-pro-max` `--design-system` | OD |
| Spec Kit feature con UI en repo | `sdd-router` → implement; UI → `ui-router` | OD salvo entregable marketing explícito |
| Generación visual marketing | Esta skill → `open-design` | `speckit-specify` |
| Landing con video hero IA + cadena multi-tool (Nano Banana + Veo/Kling + Claude Design/Code) | `ai-media-landing-ops` | Open Design (es un daemon único, no cadena) |

## Recetas OD (skill upstream)

| Intención | `--skill` | Design system típico |
|-----------|-----------|----------------------|
| Carrusel IG/FB | `social-carousel` | `vercel` + brand en `--prompt` |
| Poster editorial | `magazine-poster` | según marca |
| Email marketing | `email-marketing` | — |
| App móvil prototipo | `mobile-app`, `mobile-onboarding` | — |
| Landing SaaS | `saas-landing`, `web-prototype` | — |
| Deck / pitch | `guizang-ppt`, `simple-deck` | — |
| Wireframe rápido | `wireframe-sketch` | — |

Listar skills disponibles: `open-design skills`. Design systems: `open-design design-systems`.

## Flujo recomendado

1. `open-design status` — si falla, ofrecer `bash scripts/install-open-design-runtime.sh` o doc OPEN_DESIGN_INTEGRATION.
2. Incluir contexto de marca (doc producto, tokens) en `--prompt`.
3. `open-design generate --prompt "..." --skill <id> --design-system <id> --agent cursor-agent --out ./out/...`
4. Revisar artefactos en `--out` o UI `http://127.0.0.1:7456`.
5. `verification-before-completion` antes de entregar al usuario.
6. Publicar RRSS → `publish-safety` (OK usuario).

## Gates JARVIS

- Marca del producto en el prompt (no sustituir con design system genérico sin contexto)
- `publish-safety` antes de publicar en redes
- `verification-before-completion` al cerrar entrega
- Licencia Apache-2.0 upstream — atribuir nexu-io al publicar derivados

## Cuándo NO usar Open Design

- Cambios en `lib/` Flutter o Blade del producto
- Solo refactor de tokens ya en código
- Backend/API sin entregable visual

## Instalación runtime

```bash
bash scripts/install-open-design-runtime.sh
# o: curl -fsSL https://open-design.ai/install.sh | sh -s cursor   # jarvis-allow-net-exec
```

OpenClaw gateway: ver integración en clawvis `OPEN_DESIGN_JARVIS.md` (no duplicar aquí).
