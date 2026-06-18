# JARVIS ecosystem cross-links

## vs cyber-neo

| | cyber-neo | kalman-anomaly-defense |
|---|-----------|------------------------|
| Momento | desarrollo / audit puntual | runtime / diseño defensa |
| Output | reporte MD read-only | política + prototipo score |
| Modifica código | no (audit) | sí (middleware, config) con TDD |

Flujo recomendado: `cyber-neo` audit → fixes con `security` → diseño runtime con esta skill.

## vs security

`security` = checklist al implementar auth/uploads/API. Esta skill = **cómo reaccionar** cuando las métricas se disparan.

## approval-gate

Tier `high` (block, WAF, firewall deploy) → invocar `approval-gate` y esperar OK usuario antes de ejecutar.

## skill-loop

Iterar política (implement → review → verify) con `skill-loop-router` si el equipo quiere pasadas automáticas en código de defensa — solo con OK usuario para `skill-loop run`.

## learning-loop

Capturar falsos positivos y ajustes de umbral en wrap-up de sesión — no sustituye `session-learner-ops`.

## verification-before-completion

Obligatorio antes de declarar módulo de defensa listo: tests con spike sintético + sin regresión en tráfico normal.

## ecc-router

Harness hooks para recordar políticas de throttle en PRs — complemento, no detección runtime.
