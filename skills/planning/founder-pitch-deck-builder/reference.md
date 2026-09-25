# founder-pitch-deck-builder — referencia

Material de apoyo de [SKILL.md](SKILL.md). Plantillas y checklist para construir; las fuentes al final llevan fecha porque los benchmarks de decks cambian cada año.

## A. Checklist slide a slide (deck frío)

| # | Slide | Debe tener | No debe tener | Título-conclusión (ejemplo genérico) |
|---|---|---|---|---|
| 1 | Título | Nombre, una frase de qué hace y para quién, un screenshot real, nombre del founder, compromiso previo si existe | Agenda, "confidencial", frase de misión abstracta | "Pedidos regulados validados y entregados en 2 horas para comercios de barrio" |
| 2 | Problema | Una cifra con fuente, una escena concreta de la persona atascada, por qué lo actual falla | Tendencia de mercado como problema, 3 problemas a la vez | "El 40 % de los pedidos se cancela porque nadie valida el paso obligatorio" |
| 3 | Solución | Antes/después en una línea cada uno, la idea eureka | Lista de features, arquitectura | "El profesional responsable valida en la app antes de que el pedido se cobre" |
| 4 | Por qué ahora | Un catalizador con fecha: regulación, infraestructura, cambio de comportamiento | "La IA lo cambia todo" sin fecha | "Desde 2025 el pago móvil cubre el 80 % del retail: el cobro ya no es la barrera" |
| 5 | Mercado | Bottom-up: # clientes alcanzables × ticket anual; cuña inicial y expansión | TAM top-down de informe, población × precio, SOM desconectado de la proyección | "1.200 comercios en la cuña × USD 2.400/año = USD 2,9M de cuña" |
| 6 | Producto | Un flujo, 1–3 screenshots reales, estado (vivo / beta / en tiendas) | Tour de features, mockups presentados como producto | "El sistema existe: N roles, N endpoints, apps Android e iOS" |
| 7 | Tracción | Números con fecha; pilotos, LOIs, waitlist si es pre-seed; tasa de crecimiento si hay | Logos no firmados, "en conversaciones con", vanity metrics | "3 comercios piloto firmados para el arranque del trimestre" |
| 8 | Competencia | 3+ alternativas (directas e indirectas, incluido "no hacer nada") y por qué se estancan; diferencia estructural | Matriz de checks donde ganamos en todo, "no hay competencia" | "Los marketplaces generalistas no pueden vender el producto regulado: el validador no está en el flujo" |
| 9 | Modelo | Quién paga, cuánto, cada cuánto, margen bruto, qué no se descuenta | Tres modelos a la vez, precios sin prueba | "Take rate 12 % sobre el pedido; margen bruto 70 % tras el reparto" |
| 10 | Equipo | 2–3 personas con la línea que conecta al problema; qué han construido; dedicación | Cargos sin relación, 8 asesores, fotos de stock | "El CTO construyó el sistema completo; el CEO operó el sector 8 años" |
| 11 | Petición | Monto, instrumento, runway, 4–6 partidas con % y USD atadas a hito, qué desbloquea | Rango vago, "acelerar crecimiento", valoración a VC frío, MOIC con fecha | "USD X en SAFE post-money para publicar, operar 12 meses y llegar a N clientes" |

Los ejemplos son ilustrativos del formato; las cifras reales salen del canon del producto.

## B. Plantilla one-pager para ángel

Una página A4. Orden fijo; cada bloque, 1–3 líneas o una tabla corta.

```text
[Marca] · Ronda pre-seed · fecha

1. Qué es                 Una frase. Para quién. Estado del producto (vivo / en tiendas).
2. Problema y prueba      Una cifra con fuente + una escena.
3. Lo construido          Inventario medible (roles, endpoints, pantallas, tests) y
                          costo de reposición si ayuda a dimensionar el activo.
4. Modelo                 Quién paga, take rate / precio, margen.
5. La petición            Monto · instrumento · cap · equivalente en % si convierte al cap ·
                          qué pasa si la siguiente ronda es mayor.
6. Uso de fondos          3 bloques con %, USD e hito con fecha. Runway en meses.
7. Retorno (anexo)        Escenarios base / alto con supuestos [SUPUESTO]. Sin fecha de salida.
8. Equipo                 2–3 líneas. Dedicación.
9. Contacto               Nombre, email, teléfono de la empresa. Enlace a data room si existe.
```

Render: HTML con tokens de marca → Chrome headless `--print-to-pdf` (A4, sin header/footer) → verificar 1 página con `pdfinfo` y texto con `pdftotext`. Mismo pipeline que cualquier hoja de una página del pack.

## C. Plantilla uso de fondos

| Partida | % | USD | Hito que compra | Fecha |
|---|---|---|---|---|
| Producto / ingeniería | | | p. ej. "app en tiendas, backlog cerrado" | M4 |
| Operación comercial | | | p. ej. "N clientes activos" | M6 |
| Marketing / adquisición | | | p. ej. "N pedidos/mes" | M9 |
| Equipo clave | | | p. ej. "segundo dev con acceso y contexto" | M2 |
| Legal / cumplimiento | | | p. ej. "constitución, contratos marco" | M1 |
| Reserva | 10–15 % | | contingencia | — |
| **Total** | **100 %** | **= monto de la ronda** | **Métrica que hace fundable la siguiente ronda** | **Runway: N meses** |

Cuatro a seis filas. Cada fila con hito; una fila sin hito es gasto, no plan.

## D. Petición: variantes por instrumento

| Instrumento | Qué escribir | Qué no |
|---|---|---|
| SAFE post-money con cap | "USD X en SAFE post-money, cap USD Y. Si convierte al cap: ~Z %." | Llamar al cap "valoración"; prometer el % |
| SAFE + MFN | Lo anterior + "cláusula MFN" nombrada, no explicada en la slide | Explicar MFN en la slide (va al anexo o a la reunión) |
| Nota convertible | Monto, descuento, cap, interés, vencimiento | Omitir vencimiento |
| Equity directo | Monto, % ofrecido, pre-money implícito | Ofrecer % sin nombrar la valoración que implica |

Dilución, pool y antidilución: `founder-cap-table-checklist` y `[PENDIENTE abogado]`.

## E. Benchmarks con fuente (verificar al usar; cambian cada año)

| Dato | Valor | Fuente y fecha |
|---|---|---|
| Tiempo de lectura pre-seed | 3:21 (exitosos) vs 3:30 (no exitosos); guía 2026: 4:10 | DocSend, *Pre-Seed Round Defined* y guía pre-seed actualizada feb 2026 |
| Tiempo de lectura seed | 3:44; 58 % completan | DocSend, guía seed actualizada mar 2026 |
| Producto vivo en pre-seed | 35 % de los financiados vs 9 % de los no financiados | DocSend, informe pre-seed |
| Atención por slide 2024 | Equipo +30 % (pre-seed) / +40 % (seed); Mercado −19 %; Competencia −48 % | DocSend / Dropbox, informe dic 2024 |
| Slides deck frío | 10–12; data room 18–24 | Round Funded, 1.200 decks, 2026 |
| Completion por longitud | ~10 slides: 32 % vs 22 % media; cae tras 18 | Storydoc (citado por Hummingdeck 2026) |
| Rango más común | 9–16 páginas (49 % de los decks) | Papermark 2024 |
| Orden Sequoia | Propósito, problema, solución, por qué ahora, mercado, competencia, producto, modelo, equipo, finanzas, visión | Sequoia, *Writing a Business Plan* |
| Orden YC | 10 slides: propósito, problema, solución, por qué ahora, mercado, competencia, producto, modelo, equipo, petición | YC (vía Deckmetric) |
| Regla 10/20/30 | 10 slides, 20 min, fuente ≥ 30 pt | Guy Kawasaki |
| Slide de petición | Monto + instrumento + runway 18–24 m + partidas con hitos + siguiente ronda; cap ≠ valoración | StartupCFO 2026; Waveup 2026; StartupFundraising |
| Términos en el deck | VC frío: sin valoración. Ángeles (Alliance of Angels): exigen instrumento y términos; AoA desaconseja SAFE | Waveup 2026; Alliance of Angels *Model Pitch Deck* |
| Pre-seed US típico | 500k–1,5M en SAFE post-money, cap 5–10M | ValueAdd VC 2026 — **no es benchmark para VE / LatAm** |
| LatAm | Deck consigue la reunión; 1–3 min de lectura; validación local antes de expansión; país por país; revenue inicial >10k/mes antes de expandir | Magma Partners (guía LatAm); Magical VC / Ecosistema Startup 2026 |
| Demo day | 3 min, 8–10 slides, entendimiento sobre detalle | Platanus Ventures (formato demo day) |

## F. Qué mirar en un deck ajeno antes de copiarlo

Si el usuario trae un deck de referencia (de un inversor, de otra startup), pasarlo primero por `founder-deck-review` y anotar qué señala sobre **quien lo envió**: instrumento que espera, métricas que valora, formato que lee. El deck ajeno enseña el molde del receptor; no se copia su contenido ni sus errores.
