---
name: approval-gate
description: "Enforcement tecnico de approval gates AG-12/AG-03/AG-13 antes de publicar."
license: UNLICENSED
metadata:
  version: "1.0.0"
---

# approval-gate

Bloqueo real (exit code) si `approval.status != approved`. Usado por `mkt-publish`.

```bash
approval-gate check --handoff state/handoffs/handoff-xxx.json
approval-gate request --handoff payload.json --ag AG-12 --task task-xxx
approval-gate approve --id esc-20260602-abc1
```

Escalaciones en `state/escalations/`. Ver [docs/APPROVAL_GATES.md](../../../docs/APPROVAL_GATES.md).

**Pre-gate:** antes de `request` en AG-12/AG-13, correr `llm-as-judge-ops` (score bajo → no solicitar gate). Detalle en la sección *Pre-gate automático* del doc.

## Skills relacionadas

- publish-safety
- activity-log
- llm-as-judge-ops
- human-in-the-loop-ops
- git-guardrails-ops
- parallel-judge-ops
