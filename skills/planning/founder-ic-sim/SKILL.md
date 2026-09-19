---
name: founder-ic-sim
description: >
  Ensayo de comité de inversión: tres voces y 28 dimensiones. No contacta fondos.
  Trigger: simular IC, qué diría un inversor, comité de inversión.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: planning
  upstream: lool-ventures/founder-skills@70d216778b67b6956cadd79033c219e6bc8b154f
  auto_invoke:
    - "Simular comité de inversión"
    - "Qué objetaría un inversor al deck"
  triggers: ic sim, investment committee, comité de inversión
  related-skills:
    - founder-skills-router
    - founder-deck-review
    - founder-market-sizing
    - founder-financial-review
    - human-in-the-loop-ops
allowed-tools: [Read, Glob, Grep]
---

# Ensayo de comité

Reescritura JARVIS. No investiga un fondo real ni su portafolio salvo orden explícita del usuario. No inventar la tesis de un fondo.

Forense: [docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md](../../../docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md).

## Tres voces (no se copian entre sí)

- Visión: mercado y momento.
- Operación: ejecución y canal.
- Números: unidad, caja, calidad del ingreso.

Cada una escribe su objeción antes de leer a las otras.

## 28 dimensiones (4 por bloque)

Equipo: encaje fundador-problema, habilidades que se complementan, velocidad de entrega, si aceptan feedback.

Mercado: credibilidad del tamaño, momento, trayectoria, barreras de entrada.

Producto: diferencia real, prueba de tracción, dificultad de copiar, si al usuario le importa.

Modelo: economía por unidad, poder de precio, si escala sin el mismo coste, margen acorde al tipo.

Finanzas: eficiencia del capital, meses hasta el hito, camino a la siguiente ronda, si el ingreso se repite o es un pico.

Riesgo: un solo punto de fallo, regulación, respuesta del incumbente, concentración de clientes.

Encaje con el fondo: tesis, conflicto de portafolio, etapa, qué aporta el fondo además del dinero. En modo genérico no se nombra un fondo. Si el usuario nombra uno, marcar “no verificado” y no scrapear.

## Estados

Convicción alta, media, preocupación, dealbreaker, no aplica, a confirmar (dato ausente, no debilidad). Un dealbreaker obliga a rechazo duro. Si todo es no aplica, el veredicto es más diligencia, no invertir.

## Veredictos

Invertir, más diligencia, rechazar, rechazo duro.

## Salida

Debate corto de las tres voces, tabla de 28, veredicto, y las tres preparaciones antes de una reunión real. No es una oferta ni un correo. No enviar nada.
