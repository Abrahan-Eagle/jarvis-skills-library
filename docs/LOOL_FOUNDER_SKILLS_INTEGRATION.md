# Integración lool founder-skills

**Pack:** [lool-ventures/founder-skills](https://github.com/lool-ventures/founder-skills)  
**Licencia upstream:** Apache 2.0 — [LICENSE en el pin](https://github.com/lool-ventures/founder-skills/blob/70d216778b67b6956cadd79033c219e6bc8b154f/LICENSE)  
**Pin:** `70d216778b67b6956cadd79033c219e6bc8b154f`  
**Forense:** [LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md](LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md)  
**Router:** `founder-skills-router`

Las rúbricas de esta library son reescritura JARVIS (UNLICENSED). Nombran los mismos bloques con palabras propias. No se redistribuye el código, los scripts ni el texto largo de los `SKILL.md` upstream.

## Qué sí

| Pedido | Skill |
|--------|-------|
| Revisar el deck (14 slides, etapa, salida, petición) | `founder-deck-review` |
| Método TAM/SAM/SOM y trampas | `founder-market-sizing` |
| Rivales, ejes, fosos | `founder-competitive-positioning` |
| Revisar cifras, runway, unidad | `founder-financial-review` |
| Ensayo de comité, tres voces | `founder-ic-sim` |
| Qué llevar al abogado (SAFE, pool, dilución) | `founder-cap-table-checklist` |

## Qué no

- `npx skills add lool-ventures/founder-skills` (el propio README dice que falla en Cursor).
- Copiar `scripts/`, el visor HTML, la fuente Sora o el CDN.
- Búsqueda web automática de decks o de un fondo.
- Calcular un porcentaje de ownership.
- Cifras de Zonix: siguen en `zonix-startup-context` y `zonix-financial-model`.
- Dictamen legal. Salida de cap table siempre con `[PENDIENTE abogado]`.

## Clone opcional

Solo lectura, fuera del repo:

```bash
git clone --depth 1 https://github.com/lool-ventures/founder-skills.git /tmp/lool-founder-skills
cd /tmp/lool-founder-skills && git rev-parse HEAD
```

Si el SHA no es el pin de arriba, no actualizar las rúbricas sin un forense nuevo.

## Watchlist

Entrada `lool-founder-skills` en [catalog/sdx-toolkit-registry.json](../catalog/sdx-toolkit-registry.json). Sin script de sync.
