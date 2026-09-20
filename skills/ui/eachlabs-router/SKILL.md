---
name: eachlabs-router
description: >
  Orquesta pack eachlabs/skills (each::sense, API de pago) vs canónico JARVIS: tríptico, folleto,
  brochure, flyer o poster impreso con IA. Trigger: tríptico informativo, díptico, folleto, brochure,
  flyer impreso, pack eachlabs, each::sense.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: ui
  auto_invoke:
    - "Tríptico / díptico / folleto / brochure impreso"
    - "Flyer o poster con IA each::sense"
    - "Pack eachlabs skills"
  triggers: tríptico, triptico, críptico informativo, díptico, folleto, brochure, tri-fold, flyer, eachlabs, each::sense, EACHLABS_API_KEY
  related-skills:
    - jarvis-core
    - brochure-design-generation
    - open-design-router
    - open-design
    - ui-router
    - ui-ux-pro-max
    - ai-media-landing-ops
    - skill-security-auditor
    - claude-skills-router
    - publish-safety
    - human-in-the-loop-ops
    - jarvis-skills-maintainer
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash, Task]
---

# eachlabs Router (each::sense)

Router para [eachlabs/skills](https://github.com/eachlabs/skills) (MIT, 102 skills): wrappers finos de la API **each::sense** (`eachsense-agent.core.eachlabs.run`, `X-API-Key: $EACHLABS_API_KEY`, saldo de pago). **Sin** vendorizar el pack completo.

Guía: [docs/EACHLABS_SKILLS_INTEGRATION.md](../../../docs/EACHLABS_SKILLS_INTEGRATION.md).

## IRON LAW

1. **`jarvis-core` precede** — este router no inicia módulos ni commits sin el flujo JARVIS.
2. **Solo una skill curada** en la library: `brochure-design-generation`. Las otras 101 → pack externo (`npx skills add eachlabs/skills@<skill>`) solo tras `skill-security-auditor` PASS; nunca `nsfw-*`.
3. **Gasto con OK humano:** cada llamada a each::sense consume saldo. Antes de generar, confirmar con el usuario modo `max` (final) o `eco` (borrador) y número de iteraciones (`human-in-the-loop-ops`).
4. **`EACHLABS_API_KEY` solo en entorno** — nunca en `SKILL.md`, repo, `.env` versionado ni logs.
5. **Marca del producto en el prompt** (`zonix-brand-ops`, `corralx-ui-design`, `zonix-web-design`) — no aceptar paleta genérica del modelo.
6. **Salida ≠ publicación:** `verification-before-completion` al cerrar; `publish-safety` antes de imprimir o publicar.

## Detección runtime

```bash
test -n "${EACHLABS_API_KEY:-}" && echo EACHLABS_KEY_SET || echo EACHLABS_KEY_MISSING
test -f "${HOME}/.cursor/skills/brochure-design-generation/SKILL.md" && echo BROCHURE_INSTALLED
test -f skills/non-code/brochure-design-generation/SKILL.md && echo BROCHURE_LIBRARY
curl -sf -o /dev/null -w "%{http_code}" http://127.0.0.1:17456/api/health 2>/dev/null || echo OD_DOWN
```

| Señal | Interpretación |
|-------|----------------|
| `EACHLABS_KEY_SET` + `BROCHURE_INSTALLED` | Ruta each::sense disponible → pedir OK de gasto |
| `EACHLABS_KEY_MISSING` | Fallback: `open-design-router` (`magazine-poster`) o HTML/CSS print con `ui-ux-pro-max` |
| health OD `200` | Fallback local sin coste disponible |

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| **Tríptico / díptico / folleto / brochure impreso con IA** | **`brochure-design-generation`** (key + OK gasto) | `open-design` como sustituto si se exige imagen final IA |
| Tríptico sin API key | `open-design-router` → `open-design --skill magazine-poster` o HTML print manual | each::sense sin key |
| Flyer, poster, infografía, menú, invoice | Pack externo eachlabs (`flyer-design-generation`, `poster-design-generation`, `infographic-generation`) tras auditoría | copiar a la library |
| Carrusel RRSS, deck, email HTML | `open-design-router` → `open-design` | `social-carousel-generation` eachlabs (duplica OD) |
| Landing con video hero IA | `ai-media-landing-ops` | `eachlabs-video-generation` como cadena completa |
| Pantalla / componente en app (Flutter, Blade) | `ui-router` → `{producto}-ui-design` | eachlabs para UI de producto |
| Solo tokens / paleta para código | `ui-ux-pro-max --design-system` | eachlabs |
| Auditar skill eachlabs antes de instalar | `claude-skills-router` → `skill-security-auditor` | instalar sin PASS |

**vs `open-design-router`:** OD = fábrica local (HTML, sin coste, daemon); eachlabs = imagen final generada por IA remota (coste, sin daemon). Un tríptico entregable a imprenta suele ser eachlabs (imagen 300 DPI) o HTML print (OD) según presupuesto.

## Flujo recomendado

1. `jarvis-core` → declarar `> Roles: diseño gráfico + marca`.
2. Detección runtime (arriba). Sin key → fallback y avisar.
3. Recoger brief: formato (tri-fold, bi-fold, Z, gate), público, marca, secciones por panel, CTA, medidas de impresión.
4. Confirmar modo (`eco` borrador / `max` final) y presupuesto de iteraciones con el usuario.
5. Cargar `brochure-design-generation` → plantilla tríptico 6 paneles del overlay JARVIS → `curl` each::sense con `session_id` estable.
6. Guardar salida en `./out/eachlabs/<slug>/`; revisar sangrado 3 mm, zona segura 5 mm, 9–12 pt, 300 DPI.
7. `verification-before-completion`; si va a imprenta o RRSS → `publish-safety`.

## Flujo pre-install (otra skill del pack)

```bash
python3 skills/ops/skill-security-auditor/scripts/skill_security_auditor.py \
  https://github.com/eachlabs/skills --skill flyer-design-generation --strict
bash scripts/validate-skills.sh --check-net-exec /path/to/SKILL.md
npx skills add eachlabs/skills@flyer-design-generation -g   # solo con PASS y OK usuario
```

## Limitaciones

- each::sense es servicio remoto de pago (HTTP 422 = saldo insuficiente); sin key no hay generación.
- Sin `bin/` JARVIS: la skill curada usa `curl` directo documentado en `SKILL.md`.
- Upstream sin tags: pin por SHA en `scripts/sync-eachlabs-brochure-design-generation.sh`.
