# Cyber use cases — Kalman + agente

Basado en Bahçeci (Medium 2025) + adaptación JARVIS.

## DDoS / port / server traffic

| Señal | Detección | Respuesta agente (escalonada) |
|-------|-----------|--------------------------------|
| req/s por IP o global | Spike vs predicción Kalman | low: log; medium: throttle; high: block + approval |
| Conexiones simultáneas | Misma lógica en puerto/servicio | rate limit nginx / API gateway |
| SYN flood proxy | bytes/s o conn/s anómalo | edge rule (documentar, OK usuario) |

## Anomalía en tráfico de red

| Señal | Notas |
|-------|-------|
| Paquetes/s | IoT y edge; baseline por dispositivo |
| Patrones de flujo | Cambio brusco en distribución horaria |
| Error rate 5xx | Correlacionar con deploy vs ataque |

## IoT comprometido

| Señal | Notas |
|-------|-------|
| Telemetría sensor | Lecturas fuera de rango suave vs spike |
| Heartbeat interval | Dispositivo que reporta demasiado o poco |
| Payload size | Exfiltración → bytes/outbound anómalo |

## Separación detección / acción

1. **Pipeline métricas** → agregación ventana
2. **Kalman (o proxy)** → residual / score / tier confidence
3. **Agente JARVIS** → política en `response-policy.template.yaml`
4. **Humano** → confirmación antes de hard actions en prod

## No cubierto aquí

- Firma de malware en payload → SAST/`cyber-neo`
- Vulnerabilidad en dependencias → `composer audit`, cyber-neo SCA
- Threat intel feeds → documentar integración externa fuera de esta skill
