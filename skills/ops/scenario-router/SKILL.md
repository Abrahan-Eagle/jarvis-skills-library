---
name: scenario-router
description: >
  Orquesta analisis what-if (scenario-analysis-ops, skills dominio) vs simulacion multi-agente StrangeVerse.
  Trigger: what-if, escenarios, simular opinion publica, strangeverse, mirofish, prediccion multi-agente.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: ops
  auto_invoke:
    - "Que pasa si escenario estrategico"
    - "Simular opinion publica o reaccion mercado"
    - "Prediccion multi-agente con semilla documentos"
    - "Analisis what-if sin implementar feature"
  triggers: what-if, escenarios, strangeverse, mirofish, simulacion multi-agente, opinion publica
  related-skills:
    - strategic-briefing-ops
    - scenario-analysis-ops
    - strangeverse
    - deep-interview-ops
    - brainstorming-ops
    - jarvis-core
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# Scenario Router

Router para **decisiones estrategicas y what-if**: analisis en mesa (sin motor) vs **simulacion multi-agente** via [StrangeVerse](https://github.com/Abrahan-Eagle/strangeverse). Complementa `sdd-router` (features de producto) y `open-design-router` (artefactos visuales).

Guías JARVIS: [docs/STRANGEVERSE_INTEGRATION.md](../../docs/STRANGEVERSE_INTEGRATION.md), [docs/MIROFISH_UPSTREAM.md](../../docs/MIROFISH_UPSTREAM.md).

## Detección runtime

```bash
curl -sf -o /dev/null -w "%{http_code}" http://127.0.0.1:5001/health 2>/dev/null || echo 000
test -d "${STRANGEVERSE_HOME:-/var/www/strangeverse}" && echo SV_HOME
command -v strangeverse >/dev/null && echo SV_CLI
```

| Señal | Interpretación |
|-------|----------------|
| health `200` | Backend listo → `strangeverse` bin |
| `SV_HOME` | Repo/runtime en disco |
| Sin API | Fallback `scenario-analysis-ops` + ofrecer `install-strangeverse-runtime.sh` |

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| **Estado general** / god-view / "cómo va todo" | `strategic-briefing-ops` | `scenario-analysis-ops` solo |
| What-if **producto** en repo activo (pricing, rollout, priorización) | `{producto}-scenario-analysis` si existe (ej. `corralx-scenario-analysis`) | StrangeVerse |
| What-if estratégico **sin** dinámica social / sin coste LLM | `scenario-analysis-ops` | StrangeVerse |
| Simular **opinión pública**, narrativa, muchos actores | `strangeverse` (runtime up) | Solo brainstorming |
| Semilla = PDFs/markdown + "predice X" en lenguaje natural | `strangeverse` | `scenario-analysis-ops` solo |
| Bug, feature, implementación | `sdd-router` o skill dominio | Cualquier scenario skill |
| Semilla vaga | `deep-interview-ops` → router | Análisis directo |

## Cadena por escenario

```
strategic-briefing-ops (estado general / god-view)
        ↓ (decisiones complejas)
scenario-analysis-ops

deep-interview-ops (semilla vaga)
        ↓
scenario-router (este skill)
        ↓
├─ strategic-briefing-ops        (vista consolidada)
├─ {producto}-scenario-analysis  (decisión producto en repo)
├─ scenario-analysis-ops         (mesa, sin motor)
└─ strangeverse                  (simulación OASIS + reporte)
        ↓
brainstorming-ops → task-pipeline / sdd-router (ejecutar decisión)
```

## Gates JARVIS

- **Coste:** StrangeVerse consume `LLM_API_KEY` + `ZEP_API_KEY`; pruebas con &lt;40 rondas
- **AGPL:** usar solo API del fork; no copiar código StrangeVerse/MiroFish al global
- `verification-before-completion` antes de entregar informe final
- Escalar a StrangeVerse solo si el usuario acepta coste/tiempo o lo pidió explícito

## Cuándo NO usar StrangeVerse

- Decisión de producto acotada al código del repo (usar skill dominio)
- Sin documentos semilla ni necesidad de dinámica social
- Runtime caído y el usuario no quiere instalar ahora

## Instalación runtime

```bash
bash scripts/install-strangeverse-runtime.sh
# UI: http://127.0.0.1:3000  API: http://127.0.0.1:5001
```
