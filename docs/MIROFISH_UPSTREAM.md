# MiroFish upstream — referencia JARVIS

[MiroFish](https://github.com/666ghj/MiroFish) es un motor de **swarm intelligence** / predicción multi-agente (Python + Vue, AGPL-3.0, motor OASIS de CAMEL-AI). JARVIS **no incorpora su código**; adopta patrones conceptuales en skills de mesa y opera el runtime vía fork local.

- Demo live: [mirofish.ai](https://mirofish.ai)
- Release de referencia: **V0.1.2** (mar 2026)
- Forense clawvis (abr 2026): `clawvis-openclaw/jarvis-ecosystem/docs/FORENSE_MIROFISH_RESUMEN.md`

## Workflow upstream (5 fases)

1. **Graph building** — semilla → memoria individual/colectiva → GraphRAG
2. **Environment setup** — relaciones, personas, configuración de agentes
3. **Simulation** — simulación dual-plataforma, requisitos de predicción, memoria temporal
4. **Report generation** — ReportAgent + herramientas sobre el mundo simulado
5. **Deep interaction** — chat con agentes del mundo simulado

## Upstream vs runtime JARVIS

| Concepto | Upstream MiroFish | Runtime JARVIS |
|----------|-------------------|----------------|
| Repo | [666ghj/MiroFish](https://github.com/666ghj/MiroFish) | [Abrahan-Eagle/strangeverse](https://github.com/Abrahan-Eagle/strangeverse) (fork) |
| Licencia | AGPL-3.0 | AGPL-3.0 (fork) |
| Uso en skills global | Referencia bibliográfica | API `:5001` vía bin `strangeverse` |
| Instalación | No en jarvis-skills-library | `scripts/install-strangeverse-runtime.sh` |

Operación detallada: [STRANGEVERSE_INTEGRATION.md](STRANGEVERSE_INTEGRATION.md).

## Patrón MiroFish → skill JARVIS

| Patrón | Skill global | Motor |
|--------|--------------|-------|
| Semilla → escenarios → riesgos | `scenario-analysis-ops` | Mesa (sin LLM externo) |
| God-view / briefing consolidado | `strategic-briefing-ops` | Mesa |
| Orquestación what-if vs simulación | `scenario-router` | Router |
| What-if producto en repo | `{producto}-scenario-analysis` | Mesa (dominio) |
| Simulación OASIS + reporte + chat | `strangeverse` | StrangeVerse API |
| Memoria episódica / grafo negocio | `docs/active_context.md`, walkthroughs | Repo producto |
| Chat con agentes simulados | `strangeverse` (post-sim) | StrangeVerse API |

## Cuándo usar cada skill

| Necesidad | Skill | No usar |
|-----------|-------|---------|
| "¿Cómo va todo?" / estado general | `strategic-briefing-ops` | `scenario-analysis-ops` |
| "¿Qué pasa si subimos precio 10%?" | `scenario-analysis-ops` o skill dominio | `strangeverse` |
| Simular opinión pública con semilla larga | `scenario-router` → `strangeverse` | Solo mesa |
| Implementar feature | `sdd-router` | Cualquier scenario skill |

Cadena típica: `strategic-briefing-ops` → (si hay decisión compleja) `scenario-analysis-ops` → (si hace falta dinámica social) `strangeverse`.

## Política AGPL

- **Cero código** MiroFish/StrangeVerse copiado en `jarvis-skills-library`
- Skills globales: patrones conceptuales (escenarios, briefings) — anteriores a MiroFish en literatura de decision-making
- Runtime: usar solo **API HTTP** del fork instalado localmente
- Si redistribuyes el fork modificado: cumplir AGPL-3.0 y atribuir OASIS (CAMEL-AI)

## Relacionado

- [STRANGEVERSE_INTEGRATION.md](STRANGEVERSE_INTEGRATION.md) — install, bin, coste LLM/Zep
- [SDX_ECOSYSTEM.md](SDX_ECOSYSTEM.md) — SD-Research en catálogo SD-X
- Skills: `scenario-router`, `scenario-analysis-ops`, `strategic-briefing-ops`, `strangeverse`
