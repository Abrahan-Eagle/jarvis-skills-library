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
| Auditoría skill pre-install | `claude-skills-router` → `skill-security-auditor` |
| Defensa runtime spikes | `kalman-anomaly-router` |

## Patrones de bucle

### Test-driven loop

Señal de éxito empírica (tests, lint, build). JARVIS: TDD + verificación antes de cerrar. No requiere skill-loop si el humano orquesta cada paso.

### Judge-evaluate-iterate

Sub-agente evaluador con rúbrica. JARVIS: `doubt-driven-development` (adversarial in-flight) + `code-review-playbook` (post-hoc). Añadir gate HITL si el judge no es binario.

### Event-driven loops

Automatizaciones (cron, webhooks, CI). JARVIS: scripts en repo producto + `human-in-the-loop-ops` para definir qué puede correr sin humano.

## Taxonomía de threads → verificación

Referencia conceptual (thread-based engineering + Ralph loops): [claudefa.st — Autonomous Agent Loops](https://claudefa.st/blog/guide/mechanics/autonomous-agent-loops). Vocabulario útil; **no** es repo instalable — overlap con skills JARVIS abajo.

| Tipo thread | Verificación típica | Skill / herramienta JARVIS |
|-------------|---------------------|----------------------------|
| **Base** (un hilo, una tarea) | Revisión manual | `jarvis-core`, review humano |
| **P** (paralelo, features aisladas) | Consenso / aislamiento por worktree | `using-git-worktrees`, `loop-operator`, Task |
| **C** (encadenado por fases) | Validación tras cada fase | `executing-plans`, `verification-before-completion` por fase |
| **F** (fusion / múltiples opiniones) | Comparar salidas, elegir mejor | `doubt-driven-development`, multi-perspectiva (Task) |
| **B** (orquestación sub-agentes) | Orquestador verifica workers | Task + `loop-operator`, `handoff` |
| **L** (larga duración, overnight) | Tests automatizados + stop hook | `skill-loop` + `human-in-the-loop-ops` + `create-hook` |
| **Z** (cero humano, producto autónomo) | Feature flags + observabilidad | **Fuera de alcance** JARVIS global — dominio producto + gates estrictos |

Regla del artículo: a mayor autonomía y duración del thread, la verificación debe ser **más automatizada** (TDD, stop hooks, screenshots con `webapp-testing` para UI).

## Economía del loop

Orden de magnitud citado en el artículo: ~**$10/h** por agente (Sonnet) vs ~**$100/h** humano; varios agentes en paralelo multiplican horas-agente, no horas humanas.

El cuello de botella no es el costo por token sino **cuánto trabajo verificable puedes definir** (spec con criterios de aceptación, tests antes de implementar, stop hooks que bloquean hasta green). JARVIS: `test-driven-development`, `verification-before-completion`, `human-in-the-loop-ops` (max iterations + escalamiento).

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
| [autoresearch-agent](https://github.com/alirezarezvani/claude-skills/tree/main/engineering/autoresearch-agent) | Plugin `/ar:loop`, cron, un cambio por iteración | Overlap `skill-loop` + `human-in-the-loop-ops`; Claude Code slash — ver [CLAUDE_SKILLS_REZVANI_FORENSE_JARVIS.md](CLAUDE_SKILLS_REZVANI_FORENSE_JARVIS.md) |
| [claude-skills](https://github.com/alirezarezvani/claude-skills) (megapack) | 345+ skills multi-dominio | Router + solo `skill-security-auditor` curado — [CLAUDE_SKILLS_REZVANI_INTEGRATION.md](CLAUDE_SKILLS_REZVANI_INTEGRATION.md) |
| [claude-fast](https://claudefa.st/blog/guide/mechanics/autonomous-agent-loops) (claudefa.st) | Blog comercial — threads, Ralph loops, verification stack | **Referencia sin sync** — overlap `skill-loop` + `human-in-the-loop-ops` + TDD |
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

- [claudefa.st — Autonomous Agent Loops](https://claudefa.st/blog/guide/mechanics/autonomous-agent-loops) (referencia conceptual, sin sync)
- [SKILL_LOOP_INTEGRATION.md](SKILL_LOOP_INTEGRATION.md)
- [LEARNING_LOOP_INTEGRATION.md](LEARNING_LOOP_INTEGRATION.md)
- [AGENT_SKILLS_ADDY_INTEGRATION.md](AGENT_SKILLS_ADDY_INTEGRATION.md)
- [CLAUDE_SKILLS_REZVANI_INTEGRATION.md](CLAUDE_SKILLS_REZVANI_INTEGRATION.md)
- [SDX_ECOSYSTEM.md](SDX_ECOSYSTEM.md)
