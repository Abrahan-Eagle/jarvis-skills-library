---
name: stitch-router
description: >
  Orquesta prototipos y design systems en Google Stitch via MCP y skills upstream
  (stitch::generate-design, design-md, stitch-loop, react:components). Trigger: prototipo Stitch,
  DESIGN.md desde Stitch, export React desde Stitch, loop baton next-prompt.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.2"
  scope: [global]
  category: ui
  auto_invoke:
    - "Prototipo web en Stitch"
    - "Generar pantalla con Stitch MCP"
    - "DESIGN.md desde proyecto Stitch"
    - "Exportar Stitch a React"
    - "Loop stitch-loop next-prompt"
  triggers: stitch, stitch mcp, stitch::generate-design, design-md, stitch-loop, react-components stitch
  related-skills:
    - ui-router
    - open-design-router
    - ai-media-landing-ops
    - ui-ux-pro-max
    - jarvis-core
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# Stitch Router

Router para **prototipos web en Google Stitch** (MCP + skills upstream). Complementa `ui-router` (Flutter/Blade en repo) y `open-design-router` (artefactos standalone Open Design).

Guía JARVIS: [docs/STITCH_UPSTREAM.md](../../docs/STITCH_UPSTREAM.md).

Docs oficiales MCP: [setup](https://stitch.withgoogle.com/docs/mcp/setup/?pli=1) · [guide](https://stitch.withgoogle.com/docs/mcp/guide/?pli=1) · [reference](https://stitch.withgoogle.com/docs/mcp/reference/?pli=1)

## Gate MCP (obligatorio)

Antes de generar o leer pantallas Stitch:

1. **Config Cursor (recomendada):** `@_davideast/stitch-mcp proxy` vía `.cursor/mcp.json` — plantilla `mcp.json.proxy.example` en CorralX-Frontend. Ver [STITCH_UPSTREAM.md](../../docs/STITCH_UPSTREAM.md).
2. **Diagnóstico:** `STITCH_API_KEY=... npx -y @_davideast/stitch-mcp@latest doctor` → healthy.
3. **Reiniciar** Cursor / MCP tras cambiar credenciales.
4. **Settings → Tools & MCPs:** deben aparecer tools (`list_projects`, `get_screen`, …). **Punto verde + "No tools" = NO operativo** ([foro Cursor](https://forum.cursor.com/t/mcp-server-connected-green-dot-and-tools-discovered-in-logs-but-0-tools-in-ui-and-agent/160620)).
5. **Smoke test:** `[prefix]:list_projects` con `filter: "view=owned"` — respuesta con proyectos, **sin** error auth.

| Resultado | Acción |
|-----------|--------|
| Tools visibles + `list_projects` OK | Continuar → skill upstream |
| Punto verde pero 0 tools | Migrar a proxy `@_davideast/stitch-mcp`; no usar solo `url` remoto |
| Sin prefijo MCP | **STOP** — guiar [MCP setup](https://stitch.withgoogle.com/docs/mcp/setup/?pli=1) |
| Error auth / “API keys not supported” | **STOP** — rotar key; proxy stdio u OAuth ADC |
| Skill upstream ausente | `bash scripts/install-stitch-skills.sh --skill <name> --global` (OK usuario) |

## Detección runtime

1. **MCP Stitch:** gate arriba.
2. **Skills upstream:** `~/.cursor/skills/<dir>/SKILL.md` o `.agents/skills/<dir>/SKILL.md` (nombres CLI ≠ nombre carpeta para `stitch::*`).

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| Pantalla Flutter / Blade en producto | `ui-router` → `{producto}-ui-design` | Stitch para producción app |
| Prototipo en plataforma Stitch + MCP | Esta skill → skill upstream concreta | Open Design |
| Carrusel/deck/email standalone | `open-design-router` | Stitch salvo proyecto Stitch activo |
| Solo tokens para código | `ui-ux-pro-max` | Stitch |
| CorralX UI diario | `corralx-ui-design` | Stitch/React opcionales |
| Landing con video hero IA (Nano Banana + Veo/Kling + Claude Design/Code) | `ai-media-landing-ops` | Stitch (usa Claude Design + media gen, no Stitch) |

## Cadena por intención

| Intención | Skill CLI | Carpeta local típica | Notas |
|-----------|-----------|----------------------|-------|
| Idea vaga → prompt Stitch | `enhance-prompt` | `enhance-prompt/` | [Prompting guide](https://stitch.withgoogle.com/docs/learn/prompting/) |
| Generar/editar pantalla MCP | `stitch::generate-design` | `stitch-generate-design/` | Reemplaza V1 `stitch-design` |
| DESIGN.md desde proyecto Stitch | `design-md` | `design-md/` | [DESIGN.md overview](https://stitch.withgoogle.com/docs/design-md/overview/?pli=1) |
| DESIGN.md desde código local | `stitch::extract-design-md` | `stitch-extract-design-md/` | React, Vue, CSS, etc. |
| Código → diseño Stitch | `stitch::code-to-design` | `stitch-code-to-design/` | Cadena extract + upload |
| Subir assets / DESIGN.md | `stitch::manage-design-system`, `stitch::upload-to-stitch` | `stitch-manage-design-system/`, `stitch-upload-to-stitch/` | Script SDK si MCP trunca base64 |
| Sitio multi-página autónomo | `stitch-loop` | `stitch-loop/` | `DESIGN.md`, `SITE.md`, `next-prompt.md` |
| Stitch → React | `react:components` | `react-components/` | |
| Stitch → React Native | `stitch::react-native` | — | Opcional |
| Video walkthrough | `remotion` | `remotion/` | Opcional |
| shadcn/ui | `shadcn-ui` | `shadcn-ui/` | Stack React |
| DESIGN.md premium | `taste-design` | — | Opcional |

Instalar selectivo:

```bash
bash scripts/install-stitch-skills.sh --profile design --global
bash scripts/install-stitch-skills.sh --skill stitch-loop --global
```

## Flujo recomendado

1. Ejecutar **Gate MCP** (smoke `list_projects`).
2. Si falta skill → `install-stitch-skills.sh` o `npx skills add google-labs-code/stitch-skills --skill "<CLI>"`.
3. `Read` la skill upstream concreta antes de llamar MCP.
4. Loops: `design-md` → `stitch-loop` con baton en `next-prompt.md`.
5. `verification-before-completion` antes de entregar al usuario.

## Gates JARVIS

- Sin MCP funcional → no inventar respuestas Stitch; guiar setup + rotación de keys
- Auth fallida → proxy/OAuth según [MCP setup](https://stitch.withgoogle.com/docs/mcp/setup/?pli=1)
- Implementación Flutter/producto → `ui-router`; no copiar HTML Stitch ciego
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

No escribe en `jarvis-skills-library` — destino `~/.cursor/skills/` o `.agents/skills/` según `--global` / `--local`.
