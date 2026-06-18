# StrangeVerse — integración JARVIS global

[Motor de simulación multi-agente](https://github.com/Abrahan-Eagle/strangeverse) (fork MiroFish, AGPL-3.0): semilla → grafo GraphRAG → simulación OASIS → reporte → chat con agentes. Backend Flask `:5001`, UI Vue `:3000`.

Skills JARVIS: `scenario-router` (decisión) + `scenario-analysis-ops` (mesa) + `strangeverse` (bin HTTP).

## vs scenario-analysis-ops vs skills dominio

| Necesidad | Usar |
|-----------|------|
| What-if producto en repo (CorralX, Zonix) | `{producto}-scenario-analysis` (ej. `corralx-scenario-analysis`) |
| What-if estratégico sin coste LLM | `scenario-analysis-ops` |
| Opinión pública, narrativa emergente, semilla larga | `scenario-router` → `strangeverse` |
| Feature / bug / implementación | `sdd-router` |

## Arquitectura

```
Cursor / JARVIS
  ├─ scenario-router
  ├─ scenario-analysis-ops (mesa, sin motor)
  ├─ bin strangeverse → HTTP :5001
  └─ UI opcional :3000
StrangeVerse backend (Flask + OASIS + Zep/GraphRAG)
```

## Instalación runtime

### Script JARVIS

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install-strangeverse-runtime.sh
cd "${STRANGEVERSE_HOME:-/var/www/strangeverse}"
npm run dev
```

### Variables `.env` (en STRANGEVERSE_HOME)

| Variable | Descripción |
|----------|-------------|
| `LLM_API_KEY` | API LLM (OpenAI-compatible) |
| `LLM_BASE_URL` | Base URL del proveedor |
| `LLM_MODEL_NAME` | Modelo (ej. qwen-plus) |
| `ZEP_API_KEY` | Zep Cloud (memoria grafo) o `GRAPH_BACKEND=local` |

Ver también `STRANGEVERSE_HOME/docs/CONFIGURACION_LLM_LOCAL.md` para LLM local.

### Coste y pruebas

- Alto consumo de tokens; empezar con `--max-rounds 20` o menos de 40 rondas
- Confirmar con el usuario antes de simulaciones largas

## Flujo Cursor (bin)

```bash
strangeverse status

strangeverse ontology \
  --files ./docs/semilla.md \
  --requirement "Describe el escenario de predicción en lenguaje natural" \
  --name "Piloto JARVIS"

strangeverse build --project proj_xxxx
strangeverse poll-task --task-id task_xxxx

strangeverse sim-create --project proj_xxxx
strangeverse sim-prepare --simulation sim_xxxx
strangeverse poll-prepare --task-id task_xxxx
strangeverse sim-start --simulation sim_xxxx --max-rounds 20

strangeverse report-generate --simulation sim_xxxx
strangeverse poll-report --task-id task_xxxx
strangeverse report-download --report-id rep_xxxx --out ./out/strangeverse/report.md
```

## clawvis / holding

`scenario-analysis-ops` en clawvis es el upstream conceptual; el global generaliza fuentes (AGENTS.md, active_context). En workspace clawvis, leer además GOALS/dossiers.

## Licencia AGPL

- Skills JARVIS: solo llaman API; no incluyen código del fork
- Fork modificado: cumplir AGPL-3.0 si se redistribuye
- Atribuir [StrangeVerse](https://github.com/Abrahan-Eagle/strangeverse) y motor OASIS (CAMEL-AI)

## Relacionado

- [OPEN_DESIGN_INTEGRATION.md](OPEN_DESIGN_INTEGRATION.md) — artefactos visuales marketing
- [UI_UX_PRO_MAX_INTEGRATION.md](UI_UX_PRO_MAX_INTEGRATION.md) — UI en código
