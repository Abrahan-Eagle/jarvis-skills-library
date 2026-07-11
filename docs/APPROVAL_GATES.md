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

## Pre-gate automático (LLM-as-judge)

Antes de `approval-gate request` en publicación/deploy (AG-12 / AG-13):

1. Ejecutar skill **`llm-as-judge-ops`** sobre el artefacto (diff, handoff, checklist de release).
2. Si `score < threshold_pass` o `must_fix` no vacío → **no** llamar `request`; devolver findings al usuario.
3. Si pasa el umbral → `approval-gate request` (HITL humano sigue siendo obligatorio para approve).

Complementa: `parallel-judge-ops` (día del juicio) y `verification-before-completion` (evidencia de stack).

## Nota

Este documento es el canon mínimo en jarvis-skills-library. Flujos de marketing/cliente pueden ampliar el handoff en el repo de producto.
