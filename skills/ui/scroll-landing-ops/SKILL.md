---
name: scroll-landing-ops
description: "Proceso para landings con scroll narrativo: brief, design.md, hero por capas y verificación visual. Usar cuando pidan landing con scroll narrativo, hero dimensional, película continua, capítulos de revista o un solo mundo."
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: ui
  auto_invoke:
    - "Landing con scroll narrativo o hero por capas"
    - "Película continua, capítulos o un solo mundo al scrollear"
  triggers: scroll narrativo, hero por capas, película continua, scrollytelling, scroll landing
  related-skills:
    - ai-media-landing-ops
    - frontend-design
    - ui-ux-pro-max
    - webapp-testing
    - human-in-the-loop-ops
    - verification-before-completion
allowed-tools: [Read, Edit, Write, Glob, Grep]
---

# Scroll landing ops

Proceso para landings que se leen como un relato al scrollear: un brief cerrado, un `design.md` antes de código, un hero en capas y verificación visual. El valor está en el **orden y los gates**, no en un motor de animación.

## Cuándo usar y cuándo no

Usar cuando el pedido sea una landing con **scroll narrativo**, hero dimensional por capas, sensación de **película continua**, **capítulos** tipo revista o **un solo mundo** que se recorre al bajar.

No sustituye:

- `ai-media-landing-ops` — pipeline de media generativa (imagen, video loop, handoff de assets). Si hace falta generar media, esa skill va primero; esta skill gobierna el relato al scrollear.
- `frontend-design` — UI genérica (componentes, páginas, layouts sin relato de scroll).
- `ui-ux-pro-max` — tokens, paleta y heurísticas; se consulta para sistema visual, no para el arco narrativo.

No usar si el trabajo es solo un formulario, un dashboard de producto, un prototipo Stitch o un artefacto standalone (carrusel, deck, email). En esos casos, otra skill de UI.

## Brief antes de assets

Sin brief cerrado, no hay assets ni código. Completar, con el usuario, estos bloques:

1. **Dolor** — qué problema vive la persona antes de llegar.
2. **Persona** — a quién le hablamos (un visitante concreto, no “todo el mundo”).
3. **Promesa** — qué cambia si se queda y actúa.
4. **Qué debe creer** — la única convicción que la página tiene que dejar instalada.
5. **Viaje de secciones y sentimiento** — orden de capítulos y la emoción de cada uno (calma, urgencia, asombro, confianza).
6. **Un momento memorable** — un solo beat que se recuerde al cerrar la pestaña.
7. **Un gesto de firma** — un solo movimiento o transición característica (parallax de recorte, pin de escena, revelado de producto, cambio día/noche). No acumular gestos.

El brief decide paleta, copy y capas. Inventar el brief para “avanzar” está prohibido.

## Gramática de página

Elegir **una** gramática para toda la landing. No mezclar las tres:

| Gramática | Cómo se siente | Cuándo |
|-----------|----------------|--------|
| **Película continua** | Un plano que no corta: el scroll empuja la misma escena. | Un producto, un lugar, un arco sin títulos de capítulo. |
| **Capítulos** | Revista: cada bloque tiene entrada, tesis y salida. | Historia por actos, ofertas o pruebas distintas. |
| **Un solo mundo** | El visitante recorre un espacio (habitación, paisaje, showroom). | Marca táctil; el producto vive en el entorno. |

Definir **al menos cuatro comportamientos de sección** (ej. pin + revelado, desplazamiento de capas, sticky copy sobre imagen, corte a detalle, ciclo día/noche, desmontaje del producto). **Nunca** el mismo comportamiento dos veces seguidas: el ritmo se lee en el contraste, no en la repetición.

Cada sección responde a una pregunta del brief. Si una sección no cambia creencia ni sentimiento, sobra.

## Hero en capas

El hero no es una foto con texto encima. Se construye en capas, de atrás hacia adelante:

1. **Fondo** — escena **sin** el objeto protagonista (habitación, paisaje, set).
2. **Recorte** — el objeto o personaje en PNG transparente, con borde limpio.
3. **Primer plano** — elemento que pasa por delante (marco, planta, polvo, tipografía anclada).
4. **Atmósfera** — luz, niebla, grano o partículas; no sustituye a las capas anteriores.

Ciclo **día/noche**: fotos **distintas** (o pares de recorte + fondo) para cada momento. Un filtro CSS sobre una sola imagen no cuenta como ciclo.

El producto **se funde con la escena**: comparte luz, perspectiva y paleta. No flotar un packshot recortado sobre un fondo genérico.

## design.md primero

Antes de HTML/CSS/JS, escribir `design.md` en el proyecto de la landing. El archivo es el contrato visual. Incluye:

- **Hex con rol** — cada color tiene trabajo (fondo, superficie, texto, acento, aviso). Nada de hex sueltos.
- **Máximo dos familias tipográficas** — una para display, una para cuerpo. Si una basta, una.
- **Reglas duras** — lo que no se puede romper (márgenes, contraste, un CTA primario, sin autoplay con sonido, respetar `prefers-reduced-motion`).
- **Móvil** — qué se simplifica a 390 px: menos capas, copy más corto, gesto de firma reducido, no depender del hover.
- **Lista de assets** — por cada archivo: nombre, JPG o PNG transparente, orientación (horizontal/vertical/cuadrado) y **sección** donde vive.

Referencias visuales de **otros medios** (cine, fotografía, impresión, packaging), no de otras webs. No copiar layouts ajenos.

No inventar **precios ni cifras**. Si el usuario no las da, el copy no las finge.

El usuario deja las imágenes reales en `assets/`. La skill no genera el motor de scroll ni sustituye archivos que el usuario no entregó.

## Gate humano

Ver `human-in-the-loop-ops`. Esperar **OK explícito del usuario** y **imágenes reales** en `assets/` antes de implementar.

Hasta ese OK: brief + `design.md` + lista de huecos (qué foto falta, qué copy no está). Nada de “mientras tanto te armo el HTML”.

Fuera de alcance de esta skill: hosting, dominio y pagos. No montar checkout, pasarela ni deploy.

Tras el OK, implementar el relato (capas, gramática, secciones). La UI genérica que no sea scroll narrativo sigue `frontend-design`. Tokens y contraste: `ui-ux-pro-max`.

## Verificación visual

Antes de mostrar la landing, verificar de verdad con `webapp-testing` (Playwright). No basta un render estático.

Capturar **varias posiciones de scroll** (arriba, mitad, momento memorable, pie), en **escritorio** y a **390 px**, y con **`prefers-reduced-motion`**. Corregir lo que falle (solapes, capas que se adelantan, copy ilegible, motion que no se apaga) **antes** de enseñar.

Cerrar con `verification-before-completion`: informar **solo lo verificado** (viewports, posiciones, motion reducida). No afirmar que “el scroll se siente bien” si no se recorrió.

Basado en scroll-craft (MIT, Nate Herk, modificaciones de Luciano Mattica). Solo el proceso.
