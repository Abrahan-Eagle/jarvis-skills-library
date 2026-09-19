---
name: founder-deck-review
description: >
  Revisa un pitch contra 35 criterios en 7 bloques, por etapa. Trigger: revisar deck,
  ¿está listo para inversores?, slides del pitch, plan de salida, la petición.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: planning
  upstream: lool-ventures/founder-skills@70d216778b67b6956cadd79033c219e6bc8b154f
  auto_invoke:
    - "Revisar pitch deck"
    - "¿El deck está listo para inversores?"
  triggers: deck review, pitch deck, slides, la petición, plan de salida
  related-skills:
    - founder-skills-router
    - founder-market-sizing
    - founder-competitive-positioning
    - founder-financial-review
    - founder-ic-sim
    - founder-cap-table-checklist
    - human-in-the-loop-ops
allowed-tools: [Read, Glob, Grep]
---

# Revisión de pitch (rúbrica)

Reescritura JARVIS de la rúbrica de deck review de lool ventures. No ejecuta sus scripts. Forense: [docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md](../../../docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md).

## Qué pedir

Texto, markdown o descripción de las slides. Etapa: pre-seed, seed o Serie A. Si no la dicen, preguntar antes de puntuar.

## Cómo puntuar

Cada ítem: pasa, falla, aviso o no aplica. Al final: sólido, aceptable, hay que rehacer, o revisión mayor. No enviar el deck. Parar en `human-in-the-loop-ops`.

## 1. Narrativa (5)

- El propósito cabe en una frase concreta.
- El título de cada slide es una conclusión, no un tema.
- El arco es problema, solución, prueba, petición.
- La mejor prueba aparece pronto, no al final.
- El deck se entiende sin narrador.

## 2. Contenido (8)

Estos ocho no son las 14 diapositivas. El mapa está más abajo.

- Problema con cifra y urgencia, no un “estaría bien”.
- Solución como antes/después, no lista de features. El producto (slide 04) se mira aquí: no hay ítem propio.
- “Por qué ahora” con un catalizador real.
- Mercado de abajo arriba. Si hay TAM, cruzar con `founder-market-sizing`. No inventar el número.
- Competencia honesta. Si falta, `founder-competitive-positioning`.
- Modelo: quién paga, margen, qué no se descuenta.
- Salida al mercado: a quién, por qué canal, y una prueba temprana.
- Equipo: encaje con el problema, no solo cargos.

## 3. Etapa (5)

- Orden de slides acorde a la etapa.
- Tracción que esa etapa ya debería tener.
- Finanzas con la profundidad de esa etapa (`founder-financial-review`).
- La petición ata dinero a hitos y a la ronda siguiente.
- El monto no es un número redondo sin uso.

## 4. Lectura (5)

- Una idea por slide.
- Poco texto, letra grande.
- Núcleo de 10–12 slides: pasa. 7–9 o 13–18: aviso. 6 o menos, o 19 o más: falla. Un deck de 14 es aviso, no pasa. Se revisa igual; no se recorta a la fuerza.
- Diseño consistente.
- Legible en el móvil.

## 5. Errores (5)

- Sin propósito vago.
- Sin problema que no duele.
- Sin hype sin prueba.
- Sin features por encima del resultado.
- Sin esquivar la competencia.

## 6. Si el producto es de IA (4; si no, no aplica)

- Retención medida después del mes de prueba.
- Coste de servir y margen.
- Defensa que no sea “usamos un modelo”.
- Controles de riesgo.

## 7. Diligencia (3)

- Las cifras del deck no se contradicen.
- Hay material de respaldo o se dice qué falta.
- Contacto visible.

## Mapa de las 14 diapositivas

| # | Slide | Dónde se puntúa |
|---|-------|-----------------|
| 01 | Título | Narrativa: el propósito cabe en una frase. No es un ítem de contenido. |
| 02 | Problema | Contenido: cifra y urgencia. |
| 03 | Solución | Contenido: antes/después, no lista de features. |
| 04 | Producto | No tiene ítem propio. Se mira dentro de la solución (el flujo). |
| 05 | Mercado | Contenido de abajo arriba + `founder-market-sizing`. |
| 06 | Competencia | Contenido honesto + `founder-competitive-positioning`. |
| 07 | Estrategia para ganar | No está en los 35. La cubre el foso de `founder-competitive-positioning`. |
| 08 | Modelo | Contenido: quién paga y margen. |
| 09 | Finanzas | Etapa: profundidad acorde + `founder-financial-review`. |
| 10 | Tracción | Etapa, no el bloque de contenido. |
| 11 | GTM | Contenido: canal con prueba. |
| 12 | Equipo | Contenido: encaje, no solo cargos. |
| 13 | Plan de salida | **No está en los 35.** Preguntar compradores creíbles, horizonte y por qué pagarían. Sin respuesta: aviso, no pasa. No inventar nombres, múltiplos ni ROI. |
| 14 | La petición | Etapa: el monto ata hitos y no es un número redondo. Dilución: `founder-cap-table-checklist`. |

## Qué no hacer

No maquetar el deck (`open-design` es otra skill). No mandar el archivo. No copiar el texto upstream.
