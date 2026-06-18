---
name: kalman-anomaly-defense
description: >
  Diseña detección runtime con Kalman (predicción + actualización) y respuesta escalonada del agente.
  Trigger: kalman filter, anomaly detection, DDoS spike, rate limit policy, traffic anomaly, IoT anomaly.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: ops
  inspiration: "Mehmet Bahçeci — Kalman Filter + AI Agents (Medium, Oct 2025)"
  auto_invoke:
    - "Detección anomalías tráfico o DDoS"
    - "Política rate limit ante spikes"
    - "Kalman filter seguridad runtime"
    - "Monitoreo adaptativo con respuesta escalonada"
  triggers: kalman, anomaly detection, ddos, traffic spike, rate limit policy, iot anomaly, runtime defense
  related-skills:
    - kalman-anomaly-router
    - jarvis-core
    - security
    - approval-gate
    - cyber-neo-router
    - verification-before-completion
    - test-driven-development
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task]
---

# Kalman Anomaly Defense

Skill JARVIS-original para **detección runtime** bajo ruido y **respuesta escalonada** del agente. Inspiración: [Kalman Filter + AI Agents (Mehmet Bahçeci, Medium)](https://medium.com/@bahceci.mehmet/kalman-filter-ai-agents-a-smarter-way-to-detect-cyber-attacks-586ce34085ff).

**No sustituye** auditoría estática (`cyber-neo`) ni checklist al codificar (`security`). Complementa: filtro → señal; agente → política.

Guía: [docs/KALMAN_ANOMALY_INTEGRATION.md](../../docs/KALMAN_ANOMALY_INTEGRATION.md). Router: `kalman-anomaly-router`.

## IRON LAW JARVIS

- **No** ejecutar block IP, reglas WAF/firewall ni deploy de defensa en producción sin **OK explícito del usuario**.
- Acciones **high** (block, ban, firewall) → `approval-gate` antes de aplicar.
- Prototipo con `scripts/kalman_1d_anomaly.py` es **read-only** sobre datos de ejemplo; no tocar prod logs sin permiso.

## Cuándo usar

- Diseñar monitoreo de API/tráfico con spikes (DDoS, brute force, scrapers).
- Definir política: alerta → throttle → block con umbrales de confianza.
- Prototipar score de anomalía en serie temporal (req/s, errores, latencia).
- IoT o métricas ruidosas donde baseline simple falla.

## Cuándo NO usar

- Auditoría OWASP read-only del código → `cyber-neo-router`
- Implementar auth/uploads sin checklist → `security`
- Pentest o SAST → `cyber-neo`

## Procedimiento (6 fases)

### 1. Definir señales

Listar métricas observables y frecuencia. Ver [references/metrics-signals.md](references/metrics-signals.md).

| Pregunta | Entregable |
|----------|------------|
| ¿Qué medimos? | req/s, 5xx rate, p95, bytes/s, login failures |
| ¿Granularidad? | ventana 1s / 1m / 5m |
| ¿Baseline legítimo? | horario, campañas, releases |

### 2. Modelo Kalman (baseline)

Fases **predicción** y **actualización** — ver [references/kalman-basics.md](references/kalman-basics.md).

- 1D suficiente para MVP: una señal (ej. req/s).
- Estado x̂: nivel esperado; P: incertidumbre; Q: ruido proceso; R: ruido medición.
- **Vía avanzada ML** (KalmanNet, EKF, no lineal fuerte): ver [references/ai-aided-kfs-research.md](references/ai-aided-kfs-research.md) — **no MVP**; repo externo, sin vendor.

Prototipo CLI:

```bash
python3 skills/ops/kalman-anomaly-defense/scripts/kalman_1d_anomaly.py \
  --file fixtures/sample_traffic.csv --threshold 3.0
```

### 3. Umbral y confianza

| Nivel | Criterio típico | Uso |
|-------|-----------------|-----|
| low | residual < 2σ | log only |
| medium | 2σ–4σ | throttle / alert |
| high | > 4σ sostenido | escalación + approval |

Documentar σ o score en política del proyecto.

### 4. Política escalonada

Ver [references/staged-response-policy.md](references/staged-response-policy.md) y [assets/response-policy.template.yaml](assets/response-policy.template.yaml).

| Confianza | Acción agente | Approval |
|-----------|---------------|----------|
| low | notificar admin / log structured | no |
| medium | rate limit, captcha, soft throttle | preferir OK usuario en prod |
| high | block IP, WAF rule, firewall | **approval-gate** obligatorio |

Human-in-the-loop en prod: staged responses + ventana de confirmación.

### 5. Implementación stack

| Stack | Patrón |
|-------|--------|
| Laravel | `throttle`, `RateLimiter`, middleware custom, Horizon metrics |
| nginx | `limit_req`, geo block (con cautela) |
| Edge | Cloudflare rate rules (documentar, no auto-apply sin OK) |
| Flutter/API | client backoff; server-side throttle en API |

Casos ciber: [references/cyber-use-cases.md](references/cyber-use-cases.md).

### 6. Verificación

1. `test-driven-development` — tests con tráfico normal + spike sintético.
2. Medir falsos positivos (releases, marketing spikes).
3. `verification-before-completion` antes de cerrar módulo.
4. Opcional: `learning-loop` wrap-up si hubo FP recurrentes.

Ecosistema JARVIS: [references/jarvis-ecosystem.md](references/jarvis-ecosystem.md).

## Referencias (cargar bajo demanda)

| Archivo | Contenido |
|---------|-----------|
| [kalman-basics.md](references/kalman-basics.md) | Predicción/actualización, variables |
| [cyber-use-cases.md](references/cyber-use-cases.md) | DDoS, red, IoT |
| [staged-response-policy.md](references/staged-response-policy.md) | low/medium/high + Laravel/nginx |
| [metrics-signals.md](references/metrics-signals.md) | Señales por contexto producto |
| [jarvis-ecosystem.md](references/jarvis-ecosystem.md) | cyber-neo, skill-loop, approval-gate |
| [ai-aided-kfs-research.md](references/ai-aided-kfs-research.md) | R&D extracts (Shlezinger + Aalto/BayesNewton) |

## Anti-patrones

- Auto-block en producción sin política ni approval.
- Usar solo umbral fijo sin modelo (miss slow attacks; muchos FP en ruido).
- Sustituir `cyber-neo` con esta skill.
- Kalman en código de producto sin tests de regresión en baseline.
