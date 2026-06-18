# Kalman filter — basics (JARVIS)

Fuente conceptual: Mehmet Bahçeci, [Kalman Filter + AI Agents](https://medium.com/@bahceci.mehmet/kalman-filter-ai-agents-a-smarter-way-to-detect-cyber-attacks-586ce34085ff) (Oct 2025); Rudolf Kalman; [Wikipedia — Kalman filter](https://en.wikipedia.org/wiki/Kalman_filter).

## Intuición (bola roja + humo)

Observas un objeto con ruido (humo, sensor imperfecto). El cerebro **predice** donde debería estar; los ojos **miden** con error. El filtro combina ambas estimaciones para decir: *el estado más probable está aquí* — mejor que confiar solo en una fuente.

## Dos fases

| Fase | Qué hace |
|------|----------|
| **Predicción** | Extrapola estado futuro desde el anterior (modelo + incertidumbre que crece) |
| **Actualización** | Incorpora nueva medición; reduce incertidumbre si la medición es confiable |

## Variables (1D simplificado)

| Símbolo | Nombre | Rol en defensa |
|---------|--------|----------------|
| x̂ | Estado estimado | Nivel “normal” de tráfico/latencia |
| P | Covarianza estimación | Incertidumbre del baseline |
| F | Transición | Cómo evoluciona el estado (random walk: F=1) |
| Q | Ruido proceso | Qué tan rápido puede cambiar lo “normal” |
| z | Medición | req/s, error rate observado |
| H | Matriz medición | Relación medición ↔ estado (1D: H=1) |
| R | Ruido medición | Ruido del sensor/log agregado |

## Predicción (conceptual)

- x̂ₖ⁻ = F x̂ₖ₋₁ (+ control si existe)
- Pₖ⁻ = F Pₖ₋₁ Fᵀ + Q

## Actualización (conceptual)

- Innovación: y = z − H x̂⁻
- Ganancia Kalman K combina predicción y medición
- x̂ₖ = x̂⁻ + K y
- Pₖ = (I − K H) P⁻

## Anomalía

**Residual** (innovación) grande y sostenido → medición incompatible con modelo → posible ataque o evento legítimo (release, campaña). El agente JARVIS decide acción; el filtro solo emite señal/score.

## Cuándo usar Kalman vs umbral fijo

| Situación | Preferir |
|-----------|----------|
| Ruido alto, baseline lento | Kalman o EWMA + Kalman |
| Spike claro y señal estable | Umbral + ventana puede bastar en MVP |
| Multi-señal correlada | Filtro vectorial (fuera de MVP script 1D) |

Script JARVIS: `scripts/kalman_1d_anomaly.py` — random walk 1D, sin dependencias obligatorias.
