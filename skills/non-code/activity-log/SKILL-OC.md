---
name: activity-log
description: "Log unificado state/activity-log.jsonl + tasks/ + handoffs/."
---

# activity-log (OpenClaw)

Fuente de verdad operativa. Un evento por línea JSONL.

```bash
activity-log start --agent mkt-content --dossier client-demo --title "Carrusel IG"
activity-log event --task task-xxx --agent mkt-content --kind milestone --note "PNG exportado"
activity-log end --task task-xxx --status done
activity-log tail --dossier client-demo
```

## Skills relacionadas

coordinator, handoff, client-report
