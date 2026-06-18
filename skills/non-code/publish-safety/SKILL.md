---
name: publish-safety
description: "Capa de seguridad para publicacion RRSS: rate-limit, dedup, karma-tiers, circuit breaker."
metadata:
  version: "1.0.0"
---

# publish-safety

Inspirado en [MiloAgent](https://github.com/SoCloseSociety/MiloAgent). Bloqueo tecnico antes de `--publish`.

```bash
publish-safety check --account client-demo-ig --channel instagram --caption-file captions.txt --karma 55
publish-safety record --account client-demo-ig --channel instagram --status ok --caption-file captions.txt
publish-safety jitter   # delay aleatorio 30-180s
```

## Skills relacionadas

- mkt-publish
- approval-gate
- editorial-calendar
