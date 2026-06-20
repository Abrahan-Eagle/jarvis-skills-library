---
name: stitch-router
description: >
  Orquesta prototipos y design systems en Google Stitch via MCP y skills upstream
  (generate-design, design-md, stitch-loop, react:components). Trigger: prototipo Stitch,
  DESIGN.md desde Stitch, export React desde Stitch, loop baton next-prompt.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: ui
  auto_invoke:
    - "Prototipo web en Stitch"
    - "Generar pantalla con Stitch MCP"
    - "DESIGN.md desde proyecto Stitch"
    - "Exportar Stitch a React"
    - "Loop stitch-loop next-prompt"
  triggers: stitch, stitch mcp, generate-design, design-md, stitch-loop, react-components stitch
  related-skills:
    - ui-router
    - open-design-router
    - ui-ux-pro-max
    - jarvis-core
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# Stitch Router

Router para **prototipos web en Google Stitch** (MCP + skills upstream). Complementa `ui-router` (Flutter/Blade en repo) y `open-design-router` (artefactos standalone Open Design).

Guía JARVIS: [docs/STITCH_UPSTREAM.md](../../docs/STITCH_UPSTREAM.md).

## Detección runtime

1. **MCP Stitch:** invocar `list_tools` (o revisar MCP en Cursor) — buscar prefijo `stitch:` o `mcp_stitch:`.
2. **Skills upstream instaladas:** existencia en `~/.cursor/skills/<name>/SKILL.md` o `.agents/skills/<name>/SKILL.md` del producto.

| Señal | Interpretación |
|-------|----------------|
| Prefijo MCP `stitch:` | Listo para herramientas Stitch |
| Sin MCP | **STOP** — configurar Stitch MCP ([docs Stitch](https://stitch.withgoogle.com/docs/)) antes de generar |
| Skill upstream ausente | `bash scripts/install-stitch-skills.sh --skill <name> --global` (OK usuario) |

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| Pantalla Flutter / Blade en producto | `ui-router` → `{producto}-ui-design` | Stitch para producción app |
| Prototipo en plataforma Stitch + MCP | Esta skill → skill upstream concreta | Open Design |
| Carrusel/deck/email standalone | `open-design-router` | Stitch salvo proyecto Stitch activo |
| Solo tokens para código | `ui-ux-pro-max` | Stitch |
| CorralX UI diario | `corralx-ui-design` | Stitch/React opcionales |

## Cadena por intención

| Intención | Skill upstream | Notas |
|-----------|----------------|-------|
| Idea vaga → prompt Stitch | `enhance-prompt` | Ver [prompting guide](https://stitch.withgoogle.com/docs/learn/prompting/) |
| Generar/editar pantalla MCP | `generate-design` | Reemplaza V1 `stitch-design` |
| DESIGN.md desde código local | `extract-design-md` o `design-md` | Según origen (código vs proyecto Stitch) |
| Código → diseño Stitch | `code-to-design` | Cadena extract + upload |
| Subir assets / DESIGN.md | `manage-design-system`, `upload-to-stitch` | Proyecto Stitch existente |
| Sitio multi-página autónomo | `stitch-loop` | Requiere `DESIGN.md`, `SITE.md`, `next-prompt.md` |
| Stitch → React | `react:components` | Nombre CLI: `react:components` |
| Video walkthrough | `remotion` | Opcional |
| shadcn/ui | `shadcn-ui` | Stack React |

Instalar selectivo:

```bash
bash scripts/install-stitch-skills.sh --profile design --global
bash scripts/install-stitch-skills.sh --skill stitch-loop --global
```

## Flujo recomendado

1. Confirmar **MCP Stitch** activo (prefijo en tools).
2. Si falta skill upstream → `install-stitch-skills.sh` o `npx skills add google-labs-code/stitch-skills --skill <name> --global`.
3. `Read` la skill upstream concreta antes de llamar MCP.
4. Para loops: `design-md` → `stitch-loop` con baton en `next-prompt.md`.
5. `verification-before-completion` antes de entregar al usuario.

## Gates JARVIS

- Sin MCP → no inventar respuestas Stitch; guiar configuración
- Implementación Flutter/producto → derivar tokens manualmente o vía `ui-router`, no copiar HTML Stitch ciego
- Publicación → `publish-safety` si aplica

## Cuándo NO usar Stitch

- Tareas Flutter rutinarias (CorralX, Zonix mobile)
- Backend/API sin UI
- Artefactos marketing standalone sin proyecto Stitch → `open-design-router`

## Instalación skills upstream

```bash
bash scripts/install-stitch-skills.sh --list
bash scripts/install-stitch-skills.sh --profile all --global
```

No escribe en `jarvis-skills-library` — destino `~/.cursor/skills/` o agente detectado por `npx skills add`.
