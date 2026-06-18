---
name: approval-gate
description: "Enforcement AG-12/03/13 — bloqueo si approval.status != approved."
---

# approval-gate (OpenClaw)

Exit 0 solo si `approval.status == approved`. Usado por `mkt-publish --publish`.

```bash
approval-gate check --handoff payload.json
approval-gate request --handoff payload.json --ag AG-12 --task task-xxx
approval-gate approve --id esc-xxx
```

Escalaciones: `state/escalations/`

## Skills relacionadas

mkt-publish, publish-safety, creative-qa
