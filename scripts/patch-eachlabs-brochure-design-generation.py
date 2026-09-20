#!/usr/bin/env python3
"""Patch brochure-design-generation SKILL.md for jarvis-skills-library: frontmatter + JARVIS overlay (tríptico)."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEST = ROOT / "skills" / "non-code" / "brochure-design-generation"
UPSTREAM = DEST / "SKILL.md.upstream"
SKILL_MD = DEST / "SKILL.md"
OVERLAY_MARKER = "## JARVIS (mandatory)"

JARVIS_OVERLAY = """
## JARVIS (mandatory)

- **Router:** `eachlabs-router`. Doc: [docs/EACHLABS_SKILLS_INTEGRATION.md](../../../docs/EACHLABS_SKILLS_INTEGRATION.md)
- **Precedencia:** `jarvis-core` > `eachlabs-router` > esta skill. Complementa `open-design-router` (fábrica local sin coste) y `ui-ux-pro-max` (tokens para código).
- **Servicio remoto de pago:** cada `curl` a `eachsense-agent.core.eachlabs.run` consume saldo each::labs. HTTP 422 = saldo insuficiente.
- **Mantenedor:** tras sync upstream, ejecutar `scripts/smoke-eachlabs-brochure-design-generation.sh` + `validate-all.sh`.
- `upstream: eachlabs/skills:brochure-design-generation` (pin SHA en `scripts/sync-eachlabs-brochure-design-generation.sh`)

### IRON LAW JARVIS

- **Gasto con OK humano:** antes de la primera llamada preguntar modo (`eco` borrador / `max` final) y número de iteraciones; no encadenar llamadas sin confirmación (`human-in-the-loop-ops`).
- **`EACHLABS_API_KEY` solo en entorno.** Nunca escribir la clave en repo, `.env` versionado, prompt ni logs. Si falta → fallback (abajo), no inventar generación.
- **Marca del producto en el prompt:** paleta, tipografía y tono desde `zonix-brand-ops` / `zonix-web-design` (Zonix Pharma) o `corralx-ui-design` (CorralX). Copy salud VE → `zonix-regulatory-ve`.
- **Salida en `./out/eachlabs/<slug>/`** (no en `lib/` ni `docs/` del producto sin OK).
- **Cierre:** `verification-before-completion`; antes de imprenta o RRSS → `publish-safety`.

### Tríptico informativo — plantilla JARVIS (6 paneles, plegado envolvente)

Un tríptico es **un solo mensaje** en secuencia (enganchar → interesar → detallar → accionar), no seis páginas sueltas. Orden de lectura y función de cada panel:

| Panel | Cara | Función | Contenido típico |
|-------|------|---------|------------------|
| 1 | Exterior — portada | Enganchar | Logo, título, imagen gancho, slogan |
| 2 | Interior — solapa | Interesar | Introducción, "por qué te importa", 2–3 beneficios |
| 3 | Interior — central | Detallar | Contenido principal: subtítulos, listas cortas, iconos |
| 4 | Interior — derecho | Detallar | Segundo bloque: cómo funciona / servicios / precios |
| 5 | Exterior — cierre | Reforzar | Resumen, testimonio, sello o certificación |
| 6 | Exterior — contraportada | Accionar | CTA, contacto, dirección, QR, redes, aviso legal |

Plantilla de prompt (rellenar y pasar en `messages[0].content`):

```
Create a tri-fold brochure (11x8.5in landscape, 6 panels, roll fold) for [PRODUCTO] — [PROPÓSITO].
Brand: [PALETA HEX], [TIPOGRAFÍA], [TONO]. Audience: [PÚBLICO].
Panel 1 (front cover): [logo + título + imagen gancho + slogan].
Panel 2 (inside flap): [intro + 2-3 beneficios].
Panel 3 (inside center): [bloque principal].
Panel 4 (inside right): [segundo bloque].
Panel 5 (back flap): [resumen / testimonio / sello].
Panel 6 (back cover): [CTA + contacto + QR placeholder + aviso legal].
Print specs: 3mm bleed, 5mm safe zone from folds, body text 9-12pt, 300 DPI, CMYK-friendly colors.
```

Checklist antes de aprobar: secuencia narrativa coherente · un solo CTA primario · texto legible ≥ 9 pt · nada crítico sobre los pliegues · marca correcta (sin assets de otro producto) · aviso legal/regulatorio si aplica.

### Fallback sin `EACHLABS_API_KEY`

1. `open-design-router` → `open-design generate --skill magazine-poster` (o `simple-deck` adaptado a 6 paneles) si el daemon OD está arriba.
2. HTML/CSS print manual: `@page { size: 11in 8.5in; margin: 0 }`, grid 3 columnas por cara, guías de plegado ocultas en `@media print`; tokens de `ui-ux-pro-max --design-system`.
3. Documentar en la entrega que el artefacto es borrador HTML, no render IA.

"""

FRONTMATTER = """---
name: brochure-design-generation
description: >
  Tríptico, díptico, folleto o brochure impreso con IA each::sense (eachlabs, API de pago): formatos
  tri-fold/bi-fold/Z/gate, best practices de imprenta y plantilla JARVIS de 6 paneles.
  Trigger: tríptico informativo, díptico, folleto, brochure, tri-fold, críptico informativo (typo frecuente).
license: MIT
metadata:
  author: eachlabs (JARVIS patch)
  version: "2.0-jarvis"
  scope: [global]
  category: non-code
  upstream: eachlabs/skills:brochure-design-generation
  auto_invoke:
    - "Tríptico / díptico / folleto / brochure impreso"
    - "Generar brochure con each::sense"
  triggers: tríptico, triptico, críptico informativo, díptico, folleto, brochure, tri-fold, bi-fold, each::sense, eachlabs
  related-skills:
    - eachlabs-router
    - jarvis-core
    - open-design-router
    - open-design
    - ui-ux-pro-max
    - publish-safety
    - verification-before-completion
    - human-in-the-loop-ops
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

"""


def strip_frontmatter(text: str) -> str:
    if text.startswith("---"):
        m = re.match(r"^---\s*\n.*?\n---\s*\n", text, re.DOTALL)
        if m:
            return text[m.end():]
    return text


def main() -> None:
    if not UPSTREAM.is_file():
        raise SystemExit(
            f"Missing upstream: {UPSTREAM}. Run sync-eachlabs-brochure-design-generation.sh first."
        )

    body = strip_frontmatter(UPSTREAM.read_text(encoding="utf-8"))

    if re.search(r"X-API-Key:\s*[^$\s]", body):
        raise SystemExit("Refusing to patch: upstream body contains a literal X-API-Key value.")

    if OVERLAY_MARKER not in body:
        body = JARVIS_OVERLAY.strip() + "\n\n" + body.lstrip()

    SKILL_MD.write_text(FRONTMATTER + body, encoding="utf-8")
    print(f"Patched → {SKILL_MD}")


if __name__ == "__main__":
    main()
