---
name: strangeverse
description: >
  Simulacion multi-agente StrangeVerse via API Flask: semilla, grafo, OASIS, reporte de prediccion.
  Trigger: strangeverse, simulacion multi-agente, opinion publica, prediccion con documentos.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: non-code
  auto_invoke:
    - "Ejecutar simulacion StrangeVerse"
    - "Prediccion multi-agente con semilla PDF"
  triggers: strangeverse, mirofish, oasis simulation, opinion publica simulada
  related-skills:
    - scenario-router
    - scenario-analysis-ops
    - verification-before-completion
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# strangeverse — simulación multi-agente (API)

Puente HTTP al backend de [StrangeVerse](https://github.com/Abrahan-Eagle/strangeverse) (fork MiroFish, AGPL-3.0). Router: `scenario-router`. Doc: [docs/STRANGEVERSE_INTEGRATION.md](../../docs/STRANGEVERSE_INTEGRATION.md).

**Bin:** `skills/non-code/strangeverse/bin/strangeverse` (symlink tras `install.sh`).

## Prerrequisitos

1. Backend en marcha (`npm run dev` o Docker) — API `:5001`, UI Vue `:3000`
2. `.env` con `LLM_API_KEY`, `LLM_BASE_URL`, `LLM_MODEL_NAME`, `ZEP_API_KEY` (o `GRAPH_BACKEND=local` según fork)
3. **Coste:** alto consumo LLM; pruebas con `--max-rounds` ≤ 40

## Flujo end-to-end

```bash
strangeverse status

# 1. Semilla + ontología
strangeverse ontology \
  --files ./docs/semilla.md \
  --requirement "Predice evolución de opinión pública si..." \
  --name "Análisis piloto"

# Anotar project_id de la respuesta (proj_xxxx)

# 2. Grafo
strangeverse build --project proj_xxxx
strangeverse poll-task --task-id task_xxxx

# 3. Simulación
strangeverse sim-create --project proj_xxxx
strangeverse sim-prepare --simulation sim_xxxx
strangeverse poll-prepare --task-id task_xxxx
strangeverse sim-start --simulation sim_xxxx --max-rounds 20

# 4. Reporte (tras simulación en UI o cuando termine el runner)
strangeverse report-generate --simulation sim_xxxx
strangeverse poll-report --task-id task_xxxx
strangeverse report-download --report-id rep_xxxx --out ./out/strangeverse/report.md
```

Alternativa: usar UI en `http://127.0.0.1:3000` para pasos largos y bin solo para status/download.

## Variables

| Variable | Default | Proposito |
|----------|---------|-----------|
| `STRANGEVERSE_API_URL` | `http://127.0.0.1:5001` | API Flask |
| `STRANGEVERSE_HOME` | `/var/www/strangeverse` | Clone del fork |
| `JARVIS_OUT_DIR` | `./out/strangeverse` | Reportes exportados |

## vs scenario-analysis-ops

| Necesidad | Skill |
|-----------|-------|
| Mesa rápida, sin LLM/Zep | `scenario-analysis-ops` |
| Dinámica social, miles de agentes, reporte OASIS | `strangeverse` (este) |
| Decisión producto en CorralX/Zonix | `{producto}-scenario-analysis` |

## AGPL

Usar **solo API** del fork; no copiar código Vue/Python al global. Si redistribuyes el fork modificado, cumple AGPL-3.0.

## Instalación runtime

```bash
bash scripts/install-strangeverse-runtime.sh
```

LLM local: ver `STRANGEVERSE_HOME/docs/CONFIGURACION_LLM_LOCAL.md`.

## Cierre

`verification-before-completion` antes de entregar reporte al usuario; citar que es simulación, no predicción garantizada.
