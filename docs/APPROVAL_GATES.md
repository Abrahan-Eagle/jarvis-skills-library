# Approval Gates (AG)

**Skill:** `approval-gate`  
**Estado:** stub mínimo (forense 2026-07 — doc referenciada desde skill non-code).

## Propósito

Enforcement técnico de gates de aprobación antes de publicar o ejecutar acciones irreversibles (AG-12 / AG-03 / AG-13).

## CLI

```bash
approval-gate check --handoff state/handoffs/handoff-xxx.json
approval-gate request --handoff payload.json --ag AG-12 --task task-xxx
approval-gate approve --id esc-20260602-abc1
```

## Semántica

| Gate | Uso típico |
|------|------------|
| AG-12 | Publicación / deploy |
| AG-03 | Cambio de alcance / presupuesto |
| AG-13 | Acción irreversible (merge main, rotación secretos) |

Escalaciones: `state/escalations/`.  
Complementa: `publish-safety`, `human-in-the-loop-ops`, `git-guardrails-ops`.

## Nota

Este documento es el canon mínimo en jarvis-skills-library. Flujos de marketing/cliente pueden ampliar el handoff en el repo de producto.
