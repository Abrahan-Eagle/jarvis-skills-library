# Forense lool founder-skills vs JARVIS

**Fecha:** 2026-09-19  
**Repo:** [lool-ventures/founder-skills](https://github.com/lool-ventures/founder-skills) (Apache 2.0)  
**Pin:** `70d216778b67b6956cadd79033c219e6bc8b154f` (2026-09-19, re-record deck-review lanes)  
**Clone de lectura:** `/tmp/lool-founder-skills` (no está en este repo)  
**Objetivo:** Traer las rúbricas que faltaban tras el router de shawnpang, sin el plugin ni los scripts.

Guía: [LOOL_FOUNDER_SKILLS_INTEGRATION.md](LOOL_FOUNDER_SKILLS_INTEGRATION.md). Router: `founder-skills-router`.

Este pack **no** es [shawnpang/startup-founder-skills](https://github.com/shawnpang/startup-founder-skills). Son seis coaches con motor Python, subagentes y hook. El README upstream dice que `npx skills add` no arranca en Cursor: los scripts se resuelven desde la raíz del plugin.

## Qué hay en el pin

| Pieza | Ruta upstream | Líneas SKILL.md | Motor |
|-------|---------------|-----------------|-------|
| Market sizing | `founder-skills/skills/market-sizing` | 1285 | scripts + 22 trampas |
| Deck review | `founder-skills/skills/deck-review` | 1449 | scripts + 35 criterios |
| IC sim | `founder-skills/skills/ic-sim` | 1248 | 3 arquetipos + 28 dimensiones |
| Financial model review | `founder-skills/skills/financial-model-review` | 992 | scripts + 46 criterios |
| Competitive positioning | `founder-skills/skills/competitive-positioning` | 1397 | scripts + 25 checks + 6 moats |
| Cap table | `founder-skills/skills/cap-table` | 1241 | calculadora SAFE/Delaware/Israel |

Scripts compartidos en `founder-skills/scripts/` (rutas del plugin, artefactos HTML, coaching). No se vendorizan.

## Seguridad

`skill-security-auditor` solo sobre la carpeta `deck-review`: **WARN**, 0 critical, 3 HIGH. Los tres son `os.remove` de temporales en `setup_run.py` y `_artifact_writer.py`. Las otras cinco skills no se auditaron carpeta por carpeta: no se importan. No entran a esta library porque no copiamos scripts.

Otros riesgos del README, no adoptados:

- Market sizing, IC sim y competitive positioning buscan en la web. Una búsqueda puede filtrar un deck no anunciado.
- El visor 3D de competencia carga una librería desde un CDN.
- Cap table calcula dilución y cita derecho israelí y Delaware. No es consejo para Venezuela.

## Rúbricas leídas (no copiadas)

### Market sizing — 22 trampas

Estructura, alcance del TAM, realismo del SOM, calidad del dato, método, entendimiento del mercado, presentación. Dos vías: de arriba abajo y de abajo arriba. Deben cuadrar entre sí. Sensibilidad si cambia el número de clientes. Skill JARVIS: `founder-market-sizing`.

### Deck review — 35 criterios, 7 categorías

Narrativa (5), contenido de slide (8), ajuste a la etapa (5), diseño (5), errores típicos (5), empresa de IA (4, solo si aplica), diligencia (3). Calificación por etapa: pre-seed, seed, Series A. Skill JARVIS: `founder-deck-review`.

Corrección 2026-09-19: `slide_count_appropriate` pasa con 10–12 slides de núcleo, aviso con 7–9 o 13–18, falla con 6 o menos o 19 o más. Un deck de 14 es aviso, no pasa. Los 8 de contenido no son las 14 diapositivas (ver mapa).

### IC sim — 28 dimensiones

Equipo, mercado, producto, modelo, finanzas, riesgo, encaje con el fondo (4 cada uno). Estados: convicción alta, media, preocupación, dealbreaker, no aplica, a confirmar. Tres voces que no se copian: visión, operación, números. Veredictos: invertir, más diligencia, rechazar, rechazo duro. Skill JARVIS: `founder-ic-sim`.

### Financial model review — 46 criterios, 7 categorías

Estructura (9), ingresos y unit economics (10), caja y runway (13), métricas (3), puente a la ronda (3), sector (6, se saltan los que no aplican), vista general (2). Skill JARVIS: `founder-financial-review`.

De los 13 de caja, solo tres son Israel: cargas estatutarias, grants, timing de IVA. El tipo de cambio es multi-moneda. La caja por entidad es Israel o varias entidades. El “pasa” de cargas del pin (25–35 % EE.UU., 30–45 % UE) no es barra en Venezuela.

No hay una lista de 11 métricas en el pin. Hay 3 ítems de checklist (KPI, burn multiple, benchmark citado) y una tabla SaaS aparte (crecimiento, burn, magic number, payback, margen, NRR, LTV/CAC; en Serie A también GRR, Rule of 40, ARR por persona). Esos umbrales no se copian como ley Pharma ni VE. Sin fuente en el material del usuario, el ítem es “sin fuente”.

### Competitive positioning — 25 checks + 6 fosos

Cobertura (5), ejes (5), foso (4), evidencia (4), narrativa (4), errores (3). Fosos: red, datos, cambio de proveedor, regulación, coste, marca. Skill JARVIS: `founder-competitive-positioning`.

### Cap table — dominios, sin fórmulas

SAFE, notas convertibles, pool de opciones, antidilución, warrants, doble clase, flip Israel–Delaware, benchmarks de fundador. El paquete de handoff al abogado es la parte útil. Skill JARVIS: `founder-cap-table-checklist` (lista, no calculadora).

## Matriz 14 diapositivas

| # | Slide | En los 35 | Skill JARVIS |
|---|-------|-----------|--------------|
| 01 | Título | Narrativa (propósito), no contenido | `founder-deck-review` |
| 02 | Problema | Contenido | `founder-deck-review` |
| 03 | Solución | Contenido | `founder-deck-review` |
| 04 | Producto | No tiene ítem propio; se mira en la solución | `founder-deck-review` |
| 05 | TAM/SAM/SOM | Contenido de abajo arriba; cifras no se inventan | `founder-market-sizing` |
| 06 | Competencia | Contenido | `founder-competitive-positioning` |
| 07 | Estrategia para ganar | No está en los 35; la cubre el foso | `founder-competitive-positioning` |
| 08 | Modelo | Contenido | `founder-deck-review` + `founder-financial-review` |
| 09 | Finanzas | Etapa | `founder-financial-review` |
| 10 | Tracción | Etapa, no el bloque de contenido | `founder-deck-review` |
| 11 | GTM | Contenido | `founder-deck-review` |
| 12 | Equipo | Contenido | `founder-deck-review` + `founder-ic-sim` |
| 13 | Plan de salida | **No está en los 35.** Preguntar; sin respuesta, aviso. No inventar compradores | `founder-deck-review` + `founder-ic-sim` (riesgo) |
| 14 | La petición | Etapa: hitos y monto realista | `founder-deck-review` + `founder-cap-table-checklist` |

El ensayo de comité (`founder-ic-sim`) no es una diapositiva. Se corre antes de enviar el deck.

## Qué se adoptó

Seis skills en `skills/planning/`, solo markdown. Router actualizado. Watchlist `lool-founder-skills`.

## Qué no se adoptó

Plugin Cowork, `npx skills add`, scripts, HTML, CDN, fuentes Sora, subagentes, búsqueda web automática, matemática de dilución, ítems fiscales de Israel como norma VE.

## Nota legal

Upstream Apache 2.0 (lool ventures). Estas skills son reescritura JARVIS (UNLICENSED): nombran los mismos bloques con palabras propias. No se redistribuye el código ni el `LICENSE` completo. Pin y URL en la guía de integración.
