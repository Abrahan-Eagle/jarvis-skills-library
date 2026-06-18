# Kalman Anomaly Defense — integración JARVIS global

Skill JARVIS-original para **detección runtime** con filtro Kalman y **respuesta escalonada** del agente IA. Inspiración conceptual: Mehmet Bahçeci, [Kalman Filter + AI Agents: A Smarter Way to Detect Cyber Attacks](https://medium.com/@bahceci.mehmet/kalman-filter-ai-agents-a-smarter-way-to-detect-cyber-attacks-586ce34085ff) (Medium, Oct 2025). **No hay upstream sync** — contenido curado en `jarvis-skills-library`.

Skills JARVIS: `kalman-anomaly-router` (decisión) + `kalman-anomaly-defense` (playbook + script).

## Qué resuelve

| Fase | Kalman | Agente JARVIS |
|------|--------|---------------|
| Predicción | Estado esperado bajo ruido | — |
| Actualización | Residual / score de anomalía | — |
| Acción | — | alert → throttle → block (con approval) |

## vs JARVIS canónico

| Necesidad | Usar |
|-----------|------|
| Workflow módulo | `jarvis-core` |
| Auditoría código read-only OWASP | `cyber-neo-router` |
| Checklist al implementar auth/uploads | `security` |
| **Diseño defensa runtime / spikes / DDoS policy** | **`kalman-anomaly-router` → `kalman-anomaly-defense`** |
| Prototipo score en CSV/logs | `scripts/kalman_1d_anomaly.py` |
| Block / WAF / firewall prod | `approval-gate` + OK usuario |
| Harness ECC (hooks, instincts) | `ecc-router` — no sustituye detección runtime |
| TDD / verificación | `test-driven-development`, `verification-before-completion` |
| Cierre módulo | `session-learner-ops` |

Complemento de Cyber Neo: ver nota en [CYBER_NEO_INTEGRATION.md](CYBER_NEO_INTEGRATION.md).

## Arquitectura

```
Cursor (~/.cursor/skills vía install.sh)
  ├─ kalman-anomaly-router
  └─ kalman-anomaly-defense
skills/ops/kalman-anomaly-defense/
  ├─ SKILL.md
  ├─ references/ (kalman-basics, cyber-use-cases, staged-response, metrics, ecosystem)
  ├─ scripts/kalman_1d_anomaly.py
  ├─ scripts/fixtures/sample_traffic.csv
  └─ assets/response-policy.template.yaml
```

## Instalación

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install.sh --all
```

## Uso en Cursor

1. Pedir: "diseñar detección DDoS con Kalman" o "política rate limit ante spikes".
2. Invocar skill `kalman-anomaly-defense` (no existe slash `/kalman`).
3. Prototipo:

```bash
python3 skills/ops/kalman-anomaly-defense/scripts/kalman_1d_anomaly.py \
  --file skills/ops/kalman-anomaly-defense/scripts/fixtures/sample_traffic.csv \
  --threshold 3.0
```

4. Copiar `assets/response-policy.template.yaml` al repo producto.
5. Implementar middleware/throttle con TDD.
6. Tier high → `approval-gate` antes de block.

### Qué pedir al agente (español)

| Frase | Acción |
|-------|--------|
| "detección anomalías tráfico" / "Kalman DDoS" | `kalman-anomaly-defense` |
| "auditoría seguridad código" | `cyber-neo-router` |
| "checklist auth uploads" | `security` |
| "bloquear IP en prod" | `approval-gate` + OK usuario |

## Flujos producto (CorralX / Zonix)

1. Métricas: req/s API, 5xx, auth failures (ver `references/metrics-signals.md`).
2. Prototipo Kalman 1D con logs exportados a CSV.
3. Política escalonada en `docs/security/response-policy.yaml`.
4. Laravel: `RateLimiter`, `throttle` middleware.
5. Tests con spike sintético + `php artisan test` / `flutter test` si toca cliente.
6. `session-learner-ops` al cerrar módulo.

Por defecto **no** modificar `AGENTS.md` de productos sin OK usuario.

## IRON LAW

Sin block/WAF/firewall/deploy en producción sin OK explícito. Hard actions vía `approval-gate`.

## Scripts

| Script | Uso |
|--------|-----|
| `skills/ops/kalman-anomaly-defense/scripts/kalman_1d_anomaly.py` | Prototipo 1D |
| `scripts/smoke-kalman-anomaly.sh` | Smoke library |

## Atribución

- Mehmet Bahçeci — Kalman Filter + AI Agents (Medium, Oct 2025)
- Rudolf Kalman — filtro de estado
- JARVIS overlay — política, approval-gate, integración ecosistema
