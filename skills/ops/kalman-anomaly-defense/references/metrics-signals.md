# Metrics and signals

Señales observables para Kalman 1D o multivariado (MVP: una señal primaria).

## API / backend (Laravel)

| Señal | Fuente | Uso |
|-------|--------|-----|
| req/s global | nginx, CloudWatch, Horizon | DDoS volumétrico |
| req/s por IP | access log, middleware | abuse single actor |
| 5xx rate | app logs, APM | degradación o ataque |
| p95 latency | APM | slowloris / overload |
| auth failures/min | login audit | brute force |
| Sanctum token churn | app metrics | token stuffing |

## Marketplace (CorralX)

| Señal | Notas |
|-------|-------|
| chat messages/min por usuario | spam chat |
| order create rate | stock abuse |
| listing create burst | scraper / bot |
| KYC upload rate | abuse uploads |

## Pharma (Zonix)

| Señal | Notas |
|-------|-------|
| Rx upload rate | abuse Rx pipeline |
| prescription validation queue | farmacéutico overload vs ataque |
| checkout attempts | cart abuse |
| cold-chain order spike | anomalía operativa |

## IoT / edge

| Señal | Notas |
|-------|-------|
| sensor reading | Kalman por dispositivo |
| heartbeat gap | offline vs flood |
| outbound bytes | exfil |

## Agregación

- Ventana deslizante alineada con capacidad de respuesta (1m para API, 5m para batch).
- Normalizar por hora del día si hay patrón diario (opcional fase 2).
- Export CSV `timestamp,value` para `kalman_1d_anomaly.py`.
