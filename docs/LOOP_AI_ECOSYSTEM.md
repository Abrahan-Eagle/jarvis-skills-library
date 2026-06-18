# Loop AI — ecosistema y mapa JARVIS

Marco conceptual de **ingeniería de ciclos** (percepción → razonamiento → acción → observación) y cómo JARVIS lo cubre con skills globales existentes + `human-in-the-loop-ops` para gobernanza humana.

Skill de gobernanza: [`human-in-the-loop-ops`](skills/ops/human-in-the-loop-ops/SKILL.md).

## Mapa concepto → skill JARVIS

| Concepto Loop AI | Skill / herramienta JARVIS |
|----------------|----------------------------|
| Bucle agéntico impl→review→verify | `skill-loop-router` → `skill-loop` + CLI |
| Captura aprendizajes / anti-amnesia sesión | `learning-loop-router` → `learning-loop` |
| Operar loops autónomos (subagent) | `loop-operator` (Cursor subagent) |
| Test-driven loop (señal binaria) | `test-driven-development` + `verification-before-completion` |
| Judge-evaluate-iterate (rúbrica) | `doubt-driven-development`, `code-review-playbook` |
| Plan + ejecución incremental | `writing-plans`, `executing-plans`, `jarvis-core` |
| Sub-agentes / contexto aislado | Task `readonly`, `handoff` |
| Memoria entre sesiones | `context-updater`, `session-learner-ops`, `docs/active_context.md` |
| Worktrees / aislamiento | `using-git-worktrees` |
| MCP / conectores externos | MCP en Cursor; dominio en repos producto |
| **HITL / HOTL / automation-bounded** | **`human-in-the-loop-ops`** |
| Umbrales de confianza / escalamiento | `human-in-the-loop-ops` |
| Push/merge gate | `git-guardrails-ops` |
| Publicación con approval | `approval-gate` (OpenClaw) |
| Auditoría seguridad repo | `cyber-neo-router` |
| Defensa runtime spikes | `kalman-anomaly-router` |

## Patrones de bucle

### Test-driven loop

Señal de éxito empírica (tests, lint, build). JARVIS: TDD + verificación antes de cerrar. No requiere skill-loop si el humano orquesta cada paso.

### Judge-evaluate-iterate

Sub-agente evaluador con rúbrica. JARVIS: `doubt-driven-development` (adversarial in-flight) + `code-review-playbook` (post-hoc). Añadir gate HITL si el judge no es binario.

### Event-driven loops

Automatizaciones (cron, webhooks, CI). JARVIS: scripts en repo producto + `human-in-the-loop-ops` para definir qué puede correr sin humano.

## Primitivas (referencia)

| Primitiva | JARVIS |
|-----------|--------|
| Automatizaciones disparadoras | CI producto, OpenClaw automations (clawvis) |
| Worktrees aislados | `using-git-worktrees` |
| Skills de dominio | `.agents/skills/{producto}-*` |
| Persistencia estado | handoff, `active_context`, walkthrough |
| Orquestación sub-agentes | Task, `loop-operator` |

## Watchlist (sin sync en library)

| Repo / skill externa | Notas | Decisión |
|---------------------|-------|----------|
| [ralph-loop](https://github.com/PageAI-Pro/ralph-loop) (PageAI-Pro) | Dev loop largo en Docker sandbox, tareas priorizadas | Overlap `skill-loop` + TDD; evaluar si hace falta CLI dedicado |
| explainx/loop ([alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills)) | Cron autoresearch, un cambio por iteración | Overlap skill-loop + cron; riesgo supply-chain — auditar antes de instalar |
| mrkai77-loop | Gestor ventanas macOS (Swift), no skill de dev IA | **Fuera de dominio** |
| Loop AI Labs / Loop Q | Vendor SLM empresarial on-prem | **Fuera de dominio** (producto corporativo, no skill global) |
| Perplexity Alexa Skill | Voz + búsqueda | **Fuera de dominio** (integración consumidor) |

Entradas en `catalog/sdx-toolkit-registry.json` (watchlist).

## Riesgos documentados

- **Comprehension debt:** automatizar iteraciones sin review humano → deuda de comprensión del equipo.
- **Cognitive surrender:** aceptar salidas del modelo sin escrutinio → mitigar con review + doubt-driven + verification.

Ver skill `human-in-the-loop-ops`.

## Flujo recomendado (loop autónomo JARVIS)

```
jarvis-core (alcance + plan)
  → human-in-the-loop-ops (definir HITL/HOTL + termination)
  → skill-loop-router → scaffold YAML + OK usuario
  → skill-loop run
  → verification-before-completion
  → session-learner-ops
  → git-guardrails-ops (push solo con orden explícita)
```

## Enlaces

- [SKILL_LOOP_INTEGRATION.md](SKILL_LOOP_INTEGRATION.md)
- [LEARNING_LOOP_INTEGRATION.md](LEARNING_LOOP_INTEGRATION.md)
- [AGENT_SKILLS_ADDY_INTEGRATION.md](AGENT_SKILLS_ADDY_INTEGRATION.md)
- [SDX_ECOSYSTEM.md](SDX_ECOSYSTEM.md)
