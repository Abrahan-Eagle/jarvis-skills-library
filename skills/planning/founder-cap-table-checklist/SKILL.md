---
name: founder-cap-table-checklist
description: >
  Lista de qué revisar en SAFE, notas y dilución antes de firmar. No calcula
  el porcentaje. Trigger: cap table, SAFE, dilución, term sheet.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: planning
  upstream: lool-ventures/founder-skills@70d216778b67b6956cadd79033c219e6bc8b154f
  auto_invoke:
    - "Revisar SAFE o cap table"
    - "Qué dilución preguntar al abogado"
  triggers: cap table, SAFE, dilución, term sheet, convertible
  related-skills:
    - founder-skills-router
    - founder-deck-review
    - founder-financial-review
    - human-in-the-loop-ops
allowed-tools: [Read, Glob, Grep]
---

# Cap table (solo checklist)

Reescritura JARVIS. **No calcula** porcentajes, conversiones ni antidilución. El pack upstream sí lo hace (SAFE, Delaware, flip Israel); ese motor no está aquí.

Forense: [docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md](../../../docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md).

Toda salida lleva `[PENDIENTE abogado]`. En Venezuela la forma societaria la mira `zonix-empresa-ve` en el repo de producto, no esta skill.

## Qué reunir antes de firmar

- Lista de titulares y de instrumentos (no solo “tenemos un SAFE”).
- Tipo de cada instrumento: SAFE con tope, descuento, ambos, MFN, o nota convertible. No asumir el SAFE de YC.
- Pool de opciones: tamaño hoy y si la ronda lo amplía antes o después del precio.
- Antidilución si hay ronda con precio: media ponderada amplia, estrecha, o full ratchet. Nombrar cuál está escrito; no simular el resultado.
- Warrants y clases de voto distintas.
- Documentos: term sheet, estatutos, plan de opciones. Export de Carta u hoja de cálculo solo como inventario, no como verdad.
- Flip de jurisdicción (Israel, Delaware u otra): no es el caso VE por defecto. Si aparece, parar y derivar al abogado.

## Preguntas, no respuestas numéricas

- ¿El tope y el descuento están en el mismo papel?
- ¿El pool entra en la dilución del fundador?
- ¿La petición del deck (slide 14) nombra estos instrumentos o solo un monto?
- ¿Qué documento falta para que un abogado cierre?

## Prohibido

Dar un “te quedas con X %”. Inventar un pre-money. Tratar esta lista como dictamen. Guardar el PDF del SAFE en el repo de skills.
