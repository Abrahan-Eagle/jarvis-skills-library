# AI-Aided Kalman Filters — referencia de investigación (ShlezingerLab)

Repositorio externo: [ShlezingerLab/AI_Aided_KFs](https://github.com/ShlezingerLab/AI_Aided_KFs)

**No es upstream de JARVIS.** No hay sync vendor. Este documento orienta cuándo consultar el repo y qué **no** copiar a `jarvis-skills-library`.

## Qué es el repo

Implementación y comparación de **filtros Kalman asistidos por IA** aplicados a mediciones de un **atractor de Lorenz** (estimación de estado en sistema dinámico no lineal). Colaboración académica (Ben-Gurion, ETH, KTH, UWB, Northeastern). Stack: Python (~94 %), MATLAB (~5 %). Subcarpetas: `RTSNet_IL/`, `DANSE_KTH/`, `APBM_NU_CZ/`, `dataset/`, `figs/`.

## Algoritmos incluidos

| Algoritmo | Descripción breve | Cuándo leerlo en JARVIS |
|-----------|-------------------|-------------------------|
| **EKF** (Extended Kalman Filter) | Linealización local para sistemas no lineales | Modelo de estado no es random walk; necesitas intuición EKF antes de custom middleware |
| **PF** (Particle Filter) | Monte Carlo para no linealidad fuerte | Baseline lineal/EKF insuficiente; evaluar coste computacional |
| **KalmanNet** | DNN aprende ganancia K en tiempo real; baja complejidad declarada | R&D: tráfico muy no lineal o multi-señal; FP/FN persistentes con `kalman_1d_anomaly.py` |
| **DANSE** | Estimación de estado no lineal data-driven | Explorar si el “modelo” de negocio es difícil de formalizar (solo conceptual) |
| **APBM** | Modelo físico + data-driven | Analogía: reglas de negocio + métricas observadas (CorralX/Zonix) — no implementación directa |

## Matriz de decisión JARVIS

| Escenario | Camino recomendado |
|-----------|-------------------|
| MVP defensa runtime, spikes API, política alert/throttle/block | [`kalman_1d_anomaly.py`](../../scripts/kalman_1d_anomaly.py) + [staged-response-policy.md](staged-response-policy.md) + `approval-gate` |
| Auditoría código OWASP | `cyber-neo-router` |
| Checklist auth/uploads al codificar | `security` |
| R&D explícito: multi-variable, no lineal, aprender K con ML | Clonar AI_Aided_KFs **fuera** del library; estudiar KalmanNet/DANSE; **no** vendorizar sin licencia clara |
| Paper/citation del repo | README indica citation **TBD** — verificar antes de citar en docs públicas |

## vs artículo Medium (Bahçeci)

| | Medium (Bahçeci) | AI_Aided_KFs (ShlezingerLab) |
|---|------------------|------------------------------|
| Enfoque | Kalman + **agentes IA** para **ciberataques** operativos | Kalman + **ML** para **estimación de estado** en Lorenz |
| Agente JARVIS | Base de `kalman-anomaly-defense` (política escalonada) | Sin capa agente ni approval |
| Código en library | Script 1D + playbook | Solo este reference |

Ambos complementan: Bahçeci = **qué hacer** ante anomalía; Shlezinger = **cómo mejorar el estimador** si el lineal 1D no alcanza.

## Limitaciones (por qué no vendorizar)

1. **Dominio:** Lorenz ≠ logs API, req/s, Laravel throttle, WAF.
2. **Licencia:** README marca **License: TBD** — riesgo legal al copiar código al library.
3. **Dependencias:** PyTorch/MATLAB por subcarpeta; rompe patrón script ligero JARVIS.
4. **Sin operaciones:** no hay política runtime, block IP, ni `approval-gate`.
5. **Mantenimiento:** sin releases; paper citation TBD; alto costo de sync.

## Uso recomendado

1. Leer README y `figs/` para intuición de benchmarks.
2. Si el equipo abre ticket R&D KalmanNet: `git clone` en workspace de investigación (no en `jarvis-skills-library`).
3. Documentar hallazgos en `docs/active_context.md` del producto, no en skills globales sin OK.
4. Cualquier block/WAF en prod sigue IRON LAW de la skill principal.

## Estructura del repo (navegación)

| Carpeta | Contenido |
|---------|-----------|
| `dataset/` | Observaciones y ground truth Lorenz (no datos ciber) |
| `figs/` | Resultados de simulación |
| `RTSNet_IL/` | Implementación RTSNet |
| `DANSE_KTH/` | Implementación DANSE |
| `APBM_NU_CZ/` | Implementación APBM |

Seguir instrucciones y requirements en cada subcarpeta al clonar.

## Relación con basics

Para predicción/actualización 1D y residual como señal de anomalía, ver [kalman-basics.md](kalman-basics.md). Para EKF, sistemas no lineales y vía ML, volver a este documento.
