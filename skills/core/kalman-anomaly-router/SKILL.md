---
name: kalman-anomaly-router
description: >
  Orquesta detección runtime Kalman + respuesta escalonada vs cyber-neo audit y security checklist.
  Trigger: kalman anomaly, DDoS detection design, traffic spike policy, runtime defense, IoT anomaly.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: core
  auto_invoke:
    - "Diseñar detección anomalías tráfico"
    - "Política rate limit ante spikes"
    - "Kalman filter defensa runtime"
  triggers: kalman, anomaly detection, ddos spike, traffic anomaly, runtime defense, iot anomaly
  related-skills:
    - jarvis-core
    - kalman-anomaly-defense
    - security
    - approval-gate
    - cyber-neo-router
    - verification-before-completion
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash, Task]
---

# Kalman Anomaly Router

Router para skill JARVIS-original `kalman-anomaly-defense`: **detección runtime** con filtro Kalman (predicción + actualización) y **respuesta escalonada** del agente. Inspiración: [Mehmet Bahçeci — Kalman Filter + AI Agents](https://medium.com/@bahceci.mehmet/kalman-filter-ai-agents-a-smarter-way-to-detect-cyber-attacks-586ce34085ff).

**No sustituye** `jarvis-core`, `cyber-neo` (audit estático) ni `security` (checklist al codificar).

Guía: [docs/KALMAN_ANOMALY_INTEGRATION.md](../../docs/KALMAN_ANOMALY_INTEGRATION.md).

## Detección runtime

```bash
test -d "${HOME}/.cursor/skills/kalman-anomaly-defense" && echo KALMAN_DEFENSE_INSTALLED
test -f skills/ops/kalman-anomaly-defense/SKILL.md && echo KALMAN_DEFENSE_LIBRARY
python3 --version 2>/dev/null
```

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| Iniciar/planificar/cerrar módulo | `jarvis-core` | kalman solo |
| Auditoría código read-only OWASP | `cyber-neo-router` → `cyber-neo` | kalman |
| Checklist auth/uploads/API al codificar | `security` | kalman |
| Checklist ECC (harness) | `security-review-ecc` | — |
| **Diseñar monitoreo / detección runtime / política ante spikes** | skill **`kalman-anomaly-defense`** | cyber-neo |
| **Prototipo score en serie temporal** | `scripts/kalman_1d_anomaly.py` | — |
| Block IP / WAF / firewall en prod | `approval-gate` + OK usuario | auto-block |
| Fixes tras hallazgos audit | `security` + `test-driven-development` | solo kalman |
| Cierre módulo defensa | `verification-before-completion` → `session-learner-ops` | — |

## Flujo recomendado (Cursor)

1. Definir señales ([metrics-signals.md](../../skills/ops/kalman-anomaly-defense/references/metrics-signals.md)).
2. Prototipo: `python3 skills/ops/kalman-anomaly-defense/scripts/kalman_1d_anomaly.py -f <csv>`.
3. Copiar `assets/response-policy.template.yaml` al repo producto.
4. Implementar throttle/middleware con TDD.
5. Tier high → `approval-gate` antes de block/WAF.
6. Verificar con spike sintético + baseline normal.

## Limitaciones

- Script 1D MVP; multivariado requiere diseño custom.
- No despliega SIEM ni daemon; guía diseño + prototipo.
- Sin slash `/kalman` en Cursor — invocar skill explícitamente.

## vs learning-loop / skill-loop

- `skill-loop`: iterar código de política (impl→review) con OK usuario.
- `learning-loop`: capturar FP y ajustes de umbral post-sesión.
