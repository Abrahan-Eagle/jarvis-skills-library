---
name: founder-market-sizing
description: >
  Método TAM/SAM/SOM y 22 trampas. No inventa cifras. Trigger: tamaño de mercado,
  TAM SAM SOM, validar el mercado del deck.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: planning
  upstream: lool-ventures/founder-skills@70d216778b67b6956cadd79033c219e6bc8b154f
  auto_invoke:
    - "Tamaño de mercado TAM SAM SOM"
    - "Validar el mercado del pitch"
  triggers: market sizing, TAM, SAM, SOM, tamaño de mercado
  related-skills:
    - founder-skills-router
    - founder-deck-review
    - human-in-the-loop-ops
allowed-tools: [Read, Glob, Grep]
---

# Tamaño de mercado (método)

Reescritura JARVIS. No busca en la web salvo que el usuario lo pida. En un repo Zonix las cifras canónicas viven en `zonix-startup-context`; esta skill no las regenera.

Forense: [docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md](../../../docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md).

## Qué pedir

Producto, cliente, geografía, precio, y las cifras que ya existan. Si no hay cifras, el informe lista huecos. No rellena con un TAM inventado.

## Dos vías

- Arriba abajo: partir de una fuente sectorial y filtrar hasta el segmento.
- Abajo arriba: clientes alcanzables por precio anual.
- Las dos deben acercarse. Si no, decir cuál manda y por qué.
- SOM tiene que caber en el plan de ventas, no en un porcentaje bonito.

## 22 trampas

Estructura (2): TAM mayor que SAM mayor que SOM; las tres palabras usadas con su definición.

Alcance (2): el TAM es el del producto, no el de toda la industria; los segmentos de la fuente coinciden con el cliente real.

SOM (3): la cuota se puede defender; el canal la sostiene; no contradice las proyecciones.

Dato (6): fuente reciente; fuente identificable; más de una fuente si el número es grande; cifra sin fuente marcada como no validada; no redondear una fuente para que cuadre; supuestos separados de hechos.

Método (3): las dos vías, o explicar por qué solo una; reconciliación; crecimiento del mercado, no solo una foto.

Mercado (3): segmentos nombrados; competencia reconocida; camino si el SAM crece después.

Presentación (3): supuestos a la vista; fórmula visible; fuente al lado del número.

## Sensibilidad

Si el usuario cambia clientes o precio, mostrar el rango. No elegir el extremo optimista como caso base.

## Salida

Tabla TAM/SAM/SOM con fuente o “falta fuente”, lista de trampas en pasa/falla, y qué slide 05 del deck habría que corregir (`founder-deck-review`).
