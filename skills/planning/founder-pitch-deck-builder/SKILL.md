---
name: founder-pitch-deck-builder
description: >
  Construye un pitch deck pre-seed/seed o un one-pager para ángeles: formato por audiencia,
  orden de 11 slides, slide de petición con SAFE/cap traducido a %, uso de fondos atado a hitos,
  anti-patrones y pipeline hasta PDF. No revisa (eso es founder-deck-review) ni inventa cifras.
  Trigger: armar deck, one-pager inversor, slide de la petición, uso de fondos, deck para ángel.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: planning
  auto_invoke:
    - "Construir pitch deck o presentación para inversores"
    - "One-pager para ángel o inversor"
    - "Slide de petición / uso de fondos / la ronda"
    - "Traducir SAFE con cap al lenguaje de un ángel"
  triggers: pitch deck, armar deck, one-pager, la petición, the ask, uso de fondos, use of funds, deck ángel, deck pre-seed, demo day
  related-skills:
    - founder-skills-router
    - founder-deck-review
    - founder-market-sizing
    - founder-competitive-positioning
    - founder-financial-review
    - founder-cap-table-checklist
    - cognitive-doc-design-ops
    - open-design-router
    - human-in-the-loop-ops
allowed-tools: [Read, Glob, Grep, Write, Bash]
---

# Pitch deck builder (pre-seed / seed)

Construye el deck. La rúbrica que lo juzga es `founder-deck-review`: autor y juez separados, igual que `writing-plans` vs `code-review-playbook`. Detalle slide a slide, plantillas y fuentes: [reference.md](reference.md).

Regla de oro (DocSend 2024–2026): el inversor mira el deck **3–4 minutos** y decide si toma la reunión. El deck no cierra la ronda; consigue la reunión. Todo lo que no ayude a eso, va al data room.

## 1. Qué pedir antes de escribir

| Dato | Por qué |
|---|---|
| Etapa (pre-seed / seed) | Cambia el peso: pre-seed = equipo + problema + producto vivo; seed = tracción |
| Audiencia | VC frío, ángel individual, demo day, aliado estratégico. Cambia formato y si van términos |
| Instrumento | SAFE post-money con cap, nota, equity directo. Cambia la slide de petición |
| Fuente canónica de cifras del producto | p. ej. `zonix-startup-context` en Zonix. **No inventar** TAM, ask, cap, burn ni tracción |
| Tracción real | Usuarios pagos, pilotos firmados, LOIs, waitlist. Solo lo verificable |

Si falta la fuente de cifras, parar: sin canon no hay deck.

## 2. Un formato por pedido

| Formato | Slides | Uso |
|---|---|---|
| **Deck frío** | 10–12 | Se envía sin narrador. Es el tráiler |
| **Deck data room** | 18–24 | Después de la primera llamada. Es la película |
| **One-pager ángel** | 1 página | WhatsApp / email a ángel; incluye términos y equivalente en % |
| **Demo day** | 8–10, 3 min | Entendimiento sobre profundidad |

No mezclar: un deck frío de 17 slides con finanzas mes a mes es la película enviada a quien pidió el tráiler.

## 3. Orden canónico (deck frío, 11 slides)

Síntesis Round Funded (1.200 decks, 2026) + Sequoia + YC + DocSend. **Cada título es una conclusión, no un tema.** Una idea por slide.

| # | Slide | Pregunta que responde | Regla |
|---|---|---|---|
| 1 | Título + una frase + screenshot | ¿Qué es esto? | Si la frase desaparece, la empresa desaparece. Sin agenda |
| 2 | Problema | ¿Qué está roto y quién lo sufre? | Una cifra + una escena real. 1–2 slides máx. |
| 3 | Solución | ¿Qué haces distinto? | Antes/después. No lista de features |
| 4 | Por qué ahora | ¿Por qué hoy y no en 2020? | Catalizador datado: regulación, infraestructura, comportamiento |
| 5 | Mercado | ¿La cuña se gana y el premio importa? | Bottom-up: clientes × ticket. Nunca población × precio. `founder-market-sizing` |
| 6 | Producto | ¿Existe? | Screenshot real > mockup. 35 % de los pre-seed financiados tenían producto vivo |
| 7 | Tracción | ¿Alguien lo quiere? | Números con fecha. Pilotos, LOIs y waitlist valen en pre-seed. Logos no firmados, no |
| 8 | Competencia | ¿Por qué las alternativas se estancan? | Estructural (datos, distribución, modelo), no matriz de features. Mínimo 3 nombres. `founder-competitive-positioning` |
| 9 | Modelo | ¿Cómo entra un dólar? | Quién paga, cuánto, cada cuánto, margen bruto |
| 10 | Equipo | ¿Por qué ustedes ganan este mercado? | Founder-market fit: vivieron el problema, operaron el sector o tienen distribución. Atención a esta slide subió 30 % en 2024 |
| 11 | Petición + uso de fondos | ¿Cuánto, en qué términos, para llegar a qué? | Ver §4 |

Slide 12 opcional: visión a 5 años o contacto. Nunca cerrar con "Gracias".

## 4. La slide de petición (la que más falla)

Cinco elementos, ninguno más:

1. **Monto y ronda**: "Levantamos USD X, pre-seed". Sin rangos vagos.
2. **Instrumento**: "SAFE post-money con cap USD Y" o "ronda con precio a pre-money Z". Decisión, no duda.
3. **Runway**: 18–24 meses; cubre los hitos más 6 meses de siguiente levantamiento.
4. **Uso de fondos**: 4–6 partidas con **% y USD atadas a un hito con fecha**. "60 % producto" describe gasto; "60 % producto: dos devs para publicar la app en tiendas en M4" describe progreso.
5. **Qué desbloquea**: la métrica que hace fundable la siguiente ronda.

Reglas:

- **Cap ≠ valoración.** El cap es un techo de conversión. Decir "valemos el cap" regala la negociación.
- **A VC frío**: monto e instrumento; valoración en la reunión. **A ángel o one-pager**: términos explícitos, porque el ángel evalúa el precio antes de responder.
- **Traducción al ángel que piensa en "cheque → %"**: mostrar el SAFE y su equivalente ("si convierte al cap, ~15 %; si la siguiente ronda es mayor, tu % baja y tu valor sube"). Escenarios de dilución vía `founder-cap-table-checklist`; no calcular ownership como promesa.
- **Retorno (MOIC, múltiplo)**: solo en anexo, con supuestos etiquetados `[SUPUESTO]`, y **sin fecha de liquidez prometida**. "5× en 22 meses" en la slide principal es la señal más débil que puede enviar un founder.
- Si hay compromiso previo real ("USD 50k comprometidos de [ángel]"), va en la slide 1: es la señal más fuerte del deck.

## 5. Anti-patrones (vistos en decks reales)

| Anti-patrón | Por qué hunde el deck |
|---|---|
| SOM de 28M y proyección de 1,9M ARR | El inversor resta y concluye que el modelo no lo hizo quien escribió el mercado |
| TAM = población × precio | Cuenta gente que no compra. Se cae en 5 min de Google |
| Usuarios ×10 en 10 meses sin canal | Palo de hockey sin GTM = deseo, no plan |
| Break-even con USD 155 de utilidad | Es empate; presentarlo como hito debilita todo lo demás |
| Monto distinto en dos slides (261k vs 90k) | Falla de diligencia: ¿cuál es la verdad? |
| "No tenemos competencia" | Señal de pase inmediato |
| "Usamos varios modelos de IA" como foso | No es defensa; es proveedor. Producto IA: retención post-prueba, costo de servir, control de riesgo |
| Logos de aliados no firmados | Golpe a la credibilidad cuando llaman al logo |
| Erratas en títulos | Si no cuidaron el deck, ¿cuidarán el dinero? |

## 6. Proceso

```text
Brief (§1) → Storyboard: 11 títulos-conclusión antes de cualquier cuerpo
  → Redacción por slide (reference.md checklist)
  → Autochequeo con founder-deck-review (35 criterios) → corregir
  → Render: open-design-router (deck) o HTML→PDF Chrome headless (one-pager)
  → Gate human-in-the-loop-ops: el usuario aprueba; el agente NO envía
```

Storyboard primero: si los 11 títulos leídos en secuencia no cuentan la historia, ningún cuerpo la salvará.

## 7. Gates (no negociable)

- Cifras **solo** desde la fuente canónica del producto. Etiquetar `FACT` (medido), `[BENCHMARK]` (fuente externa citada), `[SUPUESTO]` (estimación).
- No inventar tracción, LOIs, logos, TAM, múltiplos ni fechas de salida.
- No enviar el deck ni el one-pager. Parar en `human-in-the-loop-ops`.
- No dictamen legal sobre SAFE, cap table o jurisdicción: `[PENDIENTE abogado]` + skill de producto.
- No maquetar aquí: `open-design-router` / `ui-router`.

## 8. LatAm

- Validación local antes de expansión; plan país por país. "Global desde el día 1" filtra hacia fondos grandes que no invierten pre-seed.
- Deck en el idioma del inversor. Ángel local: presentación cálida > envío frío.
- Caps y montos de referencia US (SAFE 5–10M, rondas 500k–1,5M) **no** son benchmark para Venezuela ni para la mayoría de LatAm; usar el canon del producto.
- Regulación del sector (salud, fintech) es "por qué ahora" y foso a la vez: nombrarla con fecha.
- Sesgo YC/Delaware no es default; forma societaria y KYC del inversor → skill de producto (p. ej. `zonix-empresa-ve`).

## No hacer

Revisar (es `founder-deck-review`). Calcular ownership (es `founder-cap-table-checklist`). Construir el modelo financiero (es la skill de producto; aquí se cita). Copiar texto de guías upstream.
