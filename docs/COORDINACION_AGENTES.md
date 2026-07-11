# Coordinación entre agentes (activity-log)

**Skill:** `activity-log`  
**Bin:** `skills/non-code/activity-log/bin/activity-log`  
**Estado:** stub mínimo (contrato operativo — ECC cherry-pick 2026-07).

## Propósito

Fuente de verdad maquinal de actividad entre agentes: inicio/fin de tarea, eventos, handoffs. Complementa vistas humanas (Trello/Notion) y memoria de sesión (`active_context`, Engram).

## Flujo mínimo

```bash
bin=skills/non-code/activity-log/bin/activity-log
TASK=$($bin start --agent <id> --title "…" --ref <ref> | jq -r .task_id)
$bin event --agent <id> --task "$TASK" --kind progress --note "…"
$bin end --task "$TASK"
$bin tail --n 20
$bin tasks --status open
```

## Estado en disco

| Artefacto | Ubicación |
|-----------|-----------|
| Log JSONL | `state/activity-log.jsonl` (o `$JARVIS_STATE_DIR`) |
| Tasks | `state/tasks/<task-id>.json` |
| Handoffs | vía skill `handoff` + eventos en el log |

## Relacionado

- `approval-gate` — puede registrar actividad al request/approve
- `handoff` — traspaso de sesión compactado
- `human-in-the-loop-ops` — gates humanos antes de irreversibles
- `session-startup-ops` — al retomar, revisar tareas abiertas si aplica
