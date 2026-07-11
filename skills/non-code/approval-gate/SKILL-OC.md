---
name: approval-gate
description: >
  Enforcement AG-12/03/13 — bloqueo si approval.status != approved.
  Pre-gate: llm-as-judge-ops → approval-gate request solo si score ≥ threshold.
  Trigger: approval gate, AG-12, publicar con gate.
license: UNLICENSED
metadata:
  version: "1.0.0"
  related-skills:
    - llm-as-judge-ops
    - publish-safety
    - activity-log
    - human-in-the-loop-ops
    - git-guardrails-ops
    - parallel-judge-ops
---

# approval-gate (OpenClaw)

Exit 0 solo si `approval.status == approved`. Usado por `mkt-publish --publish`.

```bash
approval-gate check --handoff payload.json
approval-gate request --handoff payload.json --ag AG-12 --task task-xxx
approval-gate approve --id esc-xxx
```

Escalaciones: `state/escalations/`. Ver [docs/APPROVAL_GATES.md](../../../docs/APPROVAL_GATES.md).

## Pre-gate (cadena canónica)

1. Correr **`llm-as-judge-ops`** (rúbrica + JSON `score` / `must_fix`).
2. Solo si `score ≥ threshold_pass` y `must_fix` vacío → `approval-gate request`.
3. Si no pasa → no solicitar gate; corregir o escalar humano.

Detalle en la sección *Pre-gate automático* de `docs/APPROVAL_GATES.md`.
El bin no fuerza el juez (cherry-pick ligero); la cadena es protocolo de skills.

## Skills relacionadas

- `llm-as-judge-ops` — juez pre-gate
- `publish-safety`
- `activity-log`
- `human-in-the-loop-ops`
- `git-guardrails-ops`
- `parallel-judge-ops`
