# Kalman research extracts (externo)

Extractos curados de repos académicos **sin sync vendor**. Orienta R&D cuando el MVP (`kalman_1d_anomaly.py`, random walk 1D) no basta. **No sustituye** política agente ni `approval-gate`.

| Repo | Enfoque |
|------|---------|
| [ShlezingerLab/AI_Aided_KFs](https://github.com/ShlezingerLab/AI_Aided_KFs) | Lorenz + KalmanNet / DANSE / APBM |
| [AaltoML/kalman-jax](https://github.com/AaltoML/kalman-jax) (obsoleto) | GP temporal + EKF/UKF en JAX |
| [AaltoML/BayesNewton](https://github.com/AaltoML/BayesNewton/) | Sucesor de kalman-jax para R&D nuevo |

## Extracto ShlezingerLab (AI_Aided_KFs)

Repositorio: [ShlezingerLab/AI_Aided_KFs](https://github.com/ShlezingerLab/AI_Aided_KFs)

Implementación y comparación de **filtros Kalman asistidos por IA** en un **atractor de Lorenz**. Stack: Python (~94 %), MATLAB (~5 %). Subcarpetas: `RTSNet_IL/`, `DANSE_KTH/`, `APBM_NU_CZ/`, `dataset/`, `figs/`.

### Algoritmos

| Algoritmo | Descripción breve | Cuándo leerlo en JARVIS |
|-----------|-------------------|-------------------------|
| **EKF** | Linealización local para no lineal | Modelo de estado no es random walk |
| **PF** (Particle Filter) | Monte Carlo para no linealidad fuerte | EKF insuficiente; evaluar coste |
| **KalmanNet** | DNN aprende ganancia K en tiempo real | R&D: tráfico muy no lineal o multi-señal |
| **DANSE** | Estimación no lineal data-driven | Modelo de negocio difícil de formalizar (conceptual) |
| **APBM** | Física + data-driven | Analogía reglas de negocio + métricas |

### Limitaciones Shlezinger

- Dominio Lorenz ≠ logs API / throttle / WAF.
- Licencia README: **TBD** — no copiar código al library sin verificar.
- PyTorch/MATLAB; sin capa agente ni approval.

## Extracto AaltoML (kalman-jax / BayesNewton)

- [kalman-jax](https://github.com/AaltoML/kalman-jax) está **obsoleto**; para R&D nuevo usar [BayesNewton](https://github.com/AaltoML/BayesNewton/).
- Inferencia aproximada en **GP temporales** (Markov) vía Kalman iterado en JAX (ICML 2020, [arXiv SS-EP](https://arxiv.org/abs/2007.05994); variacional: [arXiv](https://arxiv.org/abs/2007.04731)).
- Licencia **Apache-2.0** — si en futuro se porta un snippet mínimo (ej. modelo periodic), licencia clara (Shlezinger sigue TBD).

### Ideas aplicables (sin vendorizar JAX/notebooks)

| Idea | Uso en defensa runtime |
|------|------------------------|
| **Periodic / quasi-periodic priors** | Tráfico con horario laboral o campañas recurrentes; reduce FP vs random walk |
| **Matern class** | Baseline suave con memoria temporal |
| **Poisson / Cox** | req/s o login failures como **conteos** (intensidad), no solo Gaussian |
| **EKF / UKF / GHKF** | Catálogo filtros no lineales; complementa EKF de Shlezinger con licencia Apache |

**No extraer:** stack `kalmanjax/`, notebooks, VI/STEP/STKS — peso operativo incompatible con script ligero JARVIS.

### Matriz periodic / Poisson vs script 1D

| Señal | Seguir `kalman_1d_anomaly.py` | Considerar idea Aalto |
|-------|-------------------------------|------------------------|
| Spike aislado, baseline plano | Sí | — |
| FP en horas pico legítimas | Revisar Q/R primero | Periodic / quasi-periodic baseline |
| Eventos discretos (logins, 4xx bursts) | Umbral por ventana puede bastar | Poisson / Cox como intensidad |
| R&D con GP temporal completo | No | Clonar BayesNewton fuera del library |

## Matriz de decisión JARVIS (global)

| Escenario | Camino recomendado |
|-----------|-------------------|
| MVP defensa runtime, spikes API, política alert/throttle/block | [`kalman_1d_anomaly.py`](../../scripts/kalman_1d_anomaly.py) + [staged-response-policy.md](staged-response-policy.md) + `approval-gate` |
| Auditoría código OWASP | `cyber-neo-router` |
| Checklist auth/uploads al codificar | `security` |
| R&D: ML gain / Lorenz / KalmanNet | Clonar AI_Aided_KFs fuera del library; licencia TBD |
| R&D: periodic baseline / Poisson / GP temporal | Ideas en este doc; clonar BayesNewton fuera del library |
| Paper Shlezinger en docs públicas | Citation TBD en su README — verificar |

## vs artículo Medium (Bahçeci)

| | Medium (Bahçeci) | Shlezinger | Aalto |
|---|------------------|------------|-------|
| Enfoque | Kalman + agentes para **ciber** operativo | ML + Lorenz | GP temporal + filtros estándar |
| Agente JARVIS | Base de `kalman-anomaly-defense` | Sin agente | Sin agente |
| Código en library | Script 1D + playbook | Solo extractos | Solo extractos |

Bahçeci = **qué hacer** ante anomalía; Shlezinger = **ML gain** no lineal; Aalto = **baselines temporales** (periodic, conteos).

## Uso recomendado

1. MVP siempre con script 1D + staged response.
2. FP por patrón horario → revisar periodic baseline (idea Aalto) antes de KalmanNet.
3. R&D KalmanNet → clone Shlezinger; R&D GP temporal → clone BayesNewton (no kalman-jax).
4. Hallazgos en `docs/active_context.md` del producto, no en skills globales sin OK.
5. Block/WAF en prod: IRON LAW de la skill principal.

## Relación con basics

Predicción/actualización 1D y residual como señal: [kalman-basics.md](kalman-basics.md). EKF, no lineal, ML y periodic: este documento.
