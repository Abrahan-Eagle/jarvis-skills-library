# NEONFALL — ejemplo trabajado del pipeline

Caso real de referencia para `ai-media-landing-ops`: landing de un videojuego cyberpunk ficticio (NEONFALL) construida encadenando Claude + Nano Banana 2 + Veo 3 + Claude Design + Claude Code.

**Fuente:** Juan Pablo Rosso · Nexum AI (nexumai.online). Prompts destilados como plantillas reutilizables. Reemplazar el contenido temático (cyberpunk, paleta, copy) por el del proyecto propio.

## Paso 1 — Brief inicial (a Claude)

Claves del primer mensaje (cambian cómo responde el modelo):

- Declarar **un solo intento** por recurso (plan free).
- Declarar el **output final** esperado (hero con video loop, personaje a la derecha, texto a la izquierda).
- Pedir **calidad, no velocidad** ("tomate el tiempo necesario").
- Adjuntar imágenes de referencia (proporciones, estilo del avatar).
- Listar el **proceso completo** para que Claude planifique hacia atrás: imágenes → video → hero (Claude Design) → resto (Claude Code).

Plantilla de apertura (copiar y adaptar):

```
Necesito crear una landing page premium para [PRODUCTO/MARCA].

Restricción crítica: tengo UN SOLO intento por recurso generativo (imagen, video).
No busco velocidad — busco calidad. Tomate el tiempo necesario para investigar
best practices y generar prompts a prueba de errores.

Output final deseado:
- Hero con video en loop de fondo ([PERSONAJE/ESCENA] en el [TERCIO del frame])
- Tipografía y CTAs en el negative space ([LADO opuesto al sujeto])
- [N] secciones internas con imágenes IA consistentes
- HTML autocontenido del hero (Claude Design) → resto del sitio (Claude Code)

Referencias adjuntas: [describir imágenes de estilo/proporción que adjuntas]

Proceso que quiero que planifiques paso a paso:
1. Research + decisión de herramientas (Nano Banana 2 imagen, Veo 3/Kling video, etc.)
2. Prompt imagen key visual (negative space para tipografía)
3. Validar imagen antes de gastar el intento de video
4. Prompt video loop (start=end frame si Kling; timestamp-prompting si Veo 3)
5. Prompt Claude Design (hero HTML con dual-video crossfade)
6. Prompts imágenes internas (mismo ADN visual)
7. Prompt Claude Code (handoff preservando design tokens)

Empezá por el research y las decisiones críticas antes de escribir los prompts.
```

## Paso 2 — Research + decisiones (Claude)

Claude investiga best practices y fija decisiones críticas antes de gastar intentos:

- **Imagen:** Nano Banana 2 (consistencia de personaje, 16:9 4K nativo, entiende negative space).
- **Video:** Kling 3.0 si se puede (start+end frame = loop perfecto); si no, Veo 3 con técnicas de loop.
- **Loop:** misma imagen como start y end frame (Kling). Solo 1 generación de imagen + 1 de video.

## Paso 3 — Prompt imagen key visual (Nano Banana 2)

Config: modelo Nano Banana 2, aspect ratio 16:9, resolución 4K.

Plantilla (anotada con [PLACEHOLDERS]):

```
Cinematic [THEME] key visual in widescreen 16:9 composition. The character is
positioned on the RIGHT third of the frame; the LEFT two-thirds are deliberately
empty negative space reserved for typography overlay.

Subject: [DESCRIPCIÓN DETALLADA DEL PERSONAJE: pose, vestuario, props, pelo, build].
Viewed from [ÁNGULO]. Holding [PROP] in the right hand.

Background: [GRADIENTE/ATMÓSFERA]. Distant [ESCENARIO] silhouette along the bottom
right edge. Floating particles drifting upward. [GRID/HOLOGRAMA opcional].

Composition: cinematic wide shot, full-body framing, eye level slightly low.
Character occupies approximately the right 35 percent of the frame. The left 65
percent is clean atmospheric haze with no objects, no text, no clutter.

Lighting: [RIM LIGHT lado], [BACKLIGHT color], dramatic chiaroscuro, high contrast.

Style: [ESTILO, ej. anime-meets-cyberpunk hybrid], premium AAA videogame hero key art.

Mood: [3-4 adjetivos].

Constraints: No text. No logos. No watermarks. No UI elements. Do not center the
character. Keep the left side completely clean. No additional characters.
```

Por qué funciona: especifica "right third / left two-thirds negative space" (el modelo lo lee literal), repite "no center / left clean" en Constraints (tiende a centrar), define lente/ángulo/encuadre/altura (reduce varianza).

## Paso 4 — Checkpoint: validar imagen

Antes de gastar el único intento de video, validar contra los criterios definidos:

- Personaje en el tercio correcto.
- Lado opuesto respirable (humo/chispas = atmósfera, no clutter).
- Pose estable (peso distribuido, props horizontales estáticos) → buena para loop.

## Paso 5 — Prompt video loop

### Opción Kling 3.0 (preferida)
Config: Start Frame = imagen; End Frame = **la misma imagen** (subirla dos veces); 15 s; hereda 16:9.

```
Subtle ambient motion only. [PELO] gently sways from a soft directional breeze.
[ROPA] ripples slightly. Suspended particles drift slowly upward. The character
breathes softly. [PROP estático: do not animate]. The camera stays completely
static — no pan, no zoom, no dolly. The final frame matches the first frame
exactly. Seamless loop.
```

Prompt corto a propósito; movimiento mínimo = más fácil de loopear, menos artefactos.

### Opción Veo 3 (sin end frame) — timestamp prompting
Config: image-to-video, 8 s, 16:9, audio off.

```
A static locked-off wide cinematic shot, camera at slightly low eye level
positioned in front of and to the left of the character (that's where the camera is).
The camera does not move at any point — no pan, no zoom, no tilt, no dolly.

Subject: [DESCRIPCIÓN, idéntica a la imagen].

[00:00–00:01] Character perfectly still in the exact pose of the reference image.
[00:01–00:03] [MOVIMIENTO ÚNICO de una sola parte, ej. levanta el arma en arco].
[00:03–00:05] Holds steady. Subtle ambient motion only.
[00:05–00:07] Slowly reverses the motion back to the starting position.
[00:07–00:08] Returns to the exact identical pose, framing and composition of
[00:00–00:01]. The final frame matches the first frame frame-for-frame. Seamless loop.

Style: [ESTILO].
Negative: camera movement, zoom, pan, tilt, dolly, head turn, body rotation,
additional characters, text, logos, watermark.
```

Por qué funciona: los timestamps fuerzan bloques discretos y el "return to start"; solo se mueve una parte; `(that's where the camera is)` es un trigger documentado de adherencia en Veo 3.

**Plan B:** sin start/end frame el loop no cierra 100%. Crossfade de 0.3–0.5 s en post (Kapwing) o dual-video en el HTML.

## Paso 6 — Prompt hero (Claude Design)

Pedir un **único HTML autocontenido** (Tailwind CDN, Google Fonts CDN, vanilla JS inline, mobile-first, cero build) que luego se pueda llevar a Claude Code.

Plantilla (copiar y adaptar; adjuntar imagen key visual + video loop):

```
Creá un único archivo HTML autocontenido para el HERO de [PRODUCTO].
Sin build step: Tailwind CDN, Google Fonts CDN, vanilla JS inline, mobile-first.

Assets (ya generados, colocar en /assets/):
- /assets/hero-loop.mp4 — video loop del hero
- [opcional: imagen de referencia del personaje para contexto visual]

Layout por capas (z-index de abajo a arriba):
1. Video de fondo a pantalla completa (dual-video crossfade — ver abajo)
2. Gradient overlay [COLORES de marca] para legibilidad del texto
3. Vignette sutil en bordes
4. Contenido: logo + nav arriba; headline + subtítulo + 2 CTAs a la [IZQUIERDA/DERECHA]
   (negative space — el personaje queda en el video al otro tercio)

Dual-video crossfade (obligatorio si el loop no cierra perfecto):
- Dos <video> superpuestos con autoplay muted loop playsinline
- Mismo src="/assets/hero-loop.mp4"
- JS inline que intercambia opacidad ~0.7s antes del final del clip
  (usar el patrón de requestAnimationFrame de ai-media-landing-ops SKILL.md §4)

Design tokens en :root:
- --color-primary: [HEX]; --color-accent: [HEX]; --color-bg: [HEX]
- --font-display: '[FUENTE display]', sans-serif
- --font-body: '[FUENTE body]', sans-serif
- Tipografía con clamp() para headline (ej. clamp(2.5rem, 5vw, 4.5rem))

Copy placeholder (modificable):
- Logo: [NOMBRE]
- Nav: [Link1] | [Link2] | [Link3]
- Headline: [TITULAR principal]
- Subtítulo: [1-2 líneas de valor]
- CTA primario: [TEXTO] | CTA secundario: [TEXTO]

Microinteracciones:
- Glitch sutil en headline al cargar (1 ciclo, no molesto)
- Fade-in escalonado de nav → headline → CTAs (200ms stagger)

Restricciones:
- Solo el hero (no secciones internas)
- Sin <form>, sin localStorage/sessionStorage
- SVG inline para iconos (sin librerías de iconos)
- Sin Lorem ipsum — copy real placeholder
- Responsive: mobile stack vertical, desktop split [NAV/TEXTO | VIDEO]
```

Por qué funciona: HTML autocontenido = handoff limpio a Claude Code; dual-video oculta el corte del loop; tokens en `:root` evitan duplicación en el paso 8.

## Paso 7 — Imágenes internas (Nano Banana 2)

Dos imágenes con contraste pero mismo ADN visual:

- **Épica/amplia** (ej. vista aérea de la ciudad) con horizonte en el tercio superior → negative space para titular. Sin personajes ("la protagonista es el escenario").
- **Íntima/atmosférica** (ej. callejón) con perspectiva de un punto y tercio inferior limpio para texto.

Misma paleta y estética que el hero para que el sitio se sienta de una sola familia.

## Paso 8 — Prompt final (Claude Code, handoff)

Tras importar el proyecto de Claude Design a Claude Code, pegar un prompt quirúrgico como este:

```
Contexto: ya existe un hero HTML autocontenido con design tokens en :root,
dual-video crossfade y copy placeholder. NO reescribas el hero — extendé el sitio.

Assets (mover/renombrar si hace falta):
- /assets/hero-loop.mp4
- /assets/section-epic.webp — imagen amplia/épica
- /assets/section-intimate.webp — imagen íntima/atmosférica

Objetivo: añadir [N] secciones debajo del hero + nav con smooth scroll anclado.

Orden narrativo sugerido:
1. [SECCIÓN 1 — ej. "The World"] — fondo oscuro, imagen épica, titular + párrafo
2. [SECCIÓN 2 — ej. "Gameplay"] — grid de [N] features con iconos SVG inline
3. [SECCIÓN 3 — ej. "Story"] — imagen íntima, quote o lore block
4. [SECCIÓN 4 — ej. "CTA final"] — gradiente marca, botón primario

Reglas globales (no negociables):
- Reutilizar EXACTAMENTE los design tokens y fuentes del hero (:root) — no duplicar
- Mobile-first; breakpoints sm/md/lg/xl
- Sin dependencias nuevas (mantener Tailwind CDN + vanilla JS)
- Sin <form>, sin localStorage/sessionStorage
- loading="lazy" en imágenes below-the-fold
- Scroll reveal con IntersectionObserver (fade-up, threshold 0.15)
- Nav sticky con backdrop-blur al hacer scroll

Por sección: especificar layout, background, copy exacto, grids y hover states.

Checklist final antes de entregar:
- [ ] IDs de sección (#world, #gameplay, …) y nav anclada funcional
- [ ] Nav sticky con blur
- [ ] Imágenes optimizadas y rutas correctas
- [ ] Tokens del hero reutilizados (grep --color-primary en un solo :root)
- [ ] Consola sin errores
- [ ] Responsive verificado en 375px, 768px, 1280px

Modificá los archivos existentes; no crees archivos innecesarios.
Al terminar, listame qué archivos tocaste y qué quedó pendiente.
```

Por qué funciona: contexto explícito del hero existente evita reescritura; reglas globales bloquean deriva de tokens; checklist fuerza verificación antes de entregar.

## Lección central

> La clave NO está en las herramientas — está en el orden y en la disciplina del prompting. Cada prompt minimiza la varianza del modelo, ancla decisiones críticas (composición, loop) y deja que el humano valide en checkpoints en lugar de delegar todo de una sola vez.
