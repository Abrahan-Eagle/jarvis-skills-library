# AI Media Landing Ops — integración JARVIS

Skill: [`skills/ui/ai-media-landing-ops`](../skills/ui/ai-media-landing-ops/SKILL.md)  
Walkthrough: [`references/neonfall-walkthrough.md`](../skills/ui/ai-media-landing-ops/references/neonfall-walkthrough.md)

Orquesta una **cadena multi-tool** (research → imagen → video loop → hero HTML → código) para landings premium con media generativa. No sustituye `ui-router` (código en repo) ni `open-design-router` (daemon único).

## vs otras skills UI

| Necesidad | Usar |
|-----------|------|
| Pantalla Flutter / Blade en el producto | `ui-router` → `{producto}-ui-design` |
| Tokens/paleta para implementar en código | `ui-ux-pro-max` |
| Carrusel, deck, email HTML (daemon OD) | `open-design-router` → `open-design` |
| Prototipo Google Stitch (MCP) | `stitch-router` |
| Landing con **video hero loop** + Nano Banana / Veo / Claude Design | **`ai-media-landing-ops`** |

## Pipeline (resumen)

1. Brief (1 intento por recurso)
2. Claude: research + plan
3. Nano Banana 2: key visual
4. Checkpoint humano
5. Veo 3 / Kling: video loop
6. Claude Design: hero HTML
7. Imágenes internas
8. Claude Code / agente: resto del sitio

Checkpoints humanos obligatorios (HITL): ver `human-in-the-loop-ops`.

## Productos

| Producto | Notas |
|----------|-------|
| Zonix Pharma | Complementa `zonix-ai-landing-pipeline` / `zonix-web-design` (Blade + zonix.css) |
| CorralX | Landing marketing web (no Flutter diario) |
| clawvis / RRSS | Preferir `open-design` + `publish-safety` si el entregable es artefacto standalone |

## Instalación

Skill global vía `bash scripts/install.sh --all` (o skill individual). No requiere runtime aparte; las herramientas (Nano Banana, Veo, Claude Design) son externas al repo.

## Verificación

- Leer `SKILL.md` + walkthrough NEONFALL antes de ejecutar el pipeline.
- No publicar assets sin `publish-safety` / aprobación humana cuando el destino sea RRSS o producción.
