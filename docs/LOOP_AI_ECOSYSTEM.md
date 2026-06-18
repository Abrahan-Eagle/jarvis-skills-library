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
| Spec / pin antes del loop (alcance + criterios) | `speckit-specify`, `writing-plans`, `jarvis-core` |
| Stop hook que bloquea hasta tests green | `create-hook` (Cursor IDE) + `human-in-the-loop-ops` |
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
| **L** (larga duración, overnight) | Tests automatizados + stop hook | `skill-loop` + `human-in-the-loop-ops` + `create-hook`; ver watchlist [ralph-loop](https://github.com/PageAI-Pro/ralph-loop) |
| **Z** (cero humano, producto autónomo) | Feature flags + observabilidad | **Fuera de alcance** JARVIS global — dominio producto + gates estrictos |

Regla del artículo: a mayor autonomía y duración del thread, la verificación debe ser **más automatizada** (TDD, stop hooks, screenshots con `webapp-testing` para UI).

## Economía del loop

Orden de magnitud citado en el artículo: ~**$10/h** por agente (Sonnet) vs ~**$100/h** humano; varios agentes en paralelo multiplican horas-agente, no horas humanas.

El cuello de botella no es el costo por token sino **cuánto trabajo verificable puedes definir** (spec con criterios de aceptación, tests antes de implementar, stop hooks que bloquean hasta green). JARVIS: `test-driven-development`, `verification-before-completion`, `human-in-the-loop-ops` (max iterations + escalamiento).

## Patrones de workflow dinámico (Claude Code oficial)

Referencia canónica Anthropic: [A harness for every task: dynamic workflows in Claude Code](https://claude.com/blog/a-harness-for-every-task-dynamic-workflows-in-claude-code) (jun 2026). Claude Code puede generar harness multi-agente on-the-fly (`ultracode`, workflows JS, `/loop`, `/goal`, `/deep-research`). **No** es repo instalable — es **feature nativa de Claude Code**.

**Nota de plataforma (Cursor / JARVIS):** `ultracode`, dynamic workflows, `/loop` y `/goal` no existen en Cursor. Aproximación JARVIS: Task subagents + `using-git-worktrees` + `skill-loop` + `loop-operator` + `human-in-the-loop-ops`. Para investigación profunda tipo `/deep-research`, combinar Task fan-out + `doubt-driven-development` + `verification-before-completion`.

| Patrón (Anthropic) | Descripción breve | Skill / herramienta JARVIS |
|--------------------|-------------------|----------------------------|
| **Classify-and-act** | Clasificar tarea y rutear comportamiento o modelo | Task clasificador + `jarvis-core` / `sdd-router` |
| **Fan-out-and-synthesize** | Dividir en pasos, agentes en paralelo, barrera de síntesis | Task paralelo + `loop-operator`; merge en orquestador |
| **Adversarial verification** | Verificador separado contra rúbrica | `doubt-driven-development`, `code-review-playbook` |
| **Generate-and-filter** | Generar ideas y filtrar por rúbrica / dedupe | `doubt-driven-development`, brainstorm + criterios en plan |
| **Tournament** | N agentes compiten; judge pairwise elige ganador | Task multi-perspectiva; ver `orchestration-patterns.upstream.md` en `doubt-driven-development` |
| **Loop-until-done** | Iterar hasta condición de stop (no N fijo) | `skill-loop` + `human-in-the-loop-ops` (max iterations + stop explícito) |

Usar estos patrones solo en tareas **complejas y de alto valor** — consumen más tokens que el harness por defecto.

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

Entradas en `catalog/sdx-toolkit-registry.json` (watchlist): `ralph-loop`, `claude-skills-rezvani`. Referencias solo-doc (sin registry): `claude-fast` (claudefa.st), Claude Code dynamic workflows (artículo Anthropic abajo).

## Modos de fallo → mitigación JARVIS

### Naming oficial (Anthropic — dynamic workflows)

| Modo de fallo | Mitigación JARVIS |
|--------------|-------------------|
| **Agentic laziness** (declara done con trabajo parcial) | Criterios de éxito medibles; loop-until-done con stop condition; `verification-before-completion` |
| **Self-preferential bias** (prefiere sus propios hallazgos al verificar) | `doubt-driven-development` con verificador **separado** (Task distinto); `code-review-playbook` |
| **Goal drift** (pérdida de objetivo tras compaction / muchas vueltas) | Spec/pin en plan; `handoff` + checkpoints; `human-in-the-loop-ops` max iterations + escalamiento |

### Threads y orquestación (claudefa.st + práctica)

| Modo de fallo | Mitigación JARVIS |
|--------------|-------------------|
| Thread termina demasiado pronto | Más tests; criterios de completitud objetivos; screenshots UI (`webapp-testing`) |
| L-thread gira sin fin | Max iterations + abort en `human-in-the-loop-ops`; stop hook (`create-hook`) |
| P-threads conflictos en mismos archivos | `using-git-worktrees`; aislar por feature/archivo |
| B-thread pierde coherencia | Mejor spec; checkpoints; orquestador verifica sub-agentes (`loop-operator`) |
| Verificación pasa pero trabajo incorrecto | Mejor acceptance criteria; review humano; `doubt-driven-development` en alta stakes |

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

- [Anthropic — Dynamic workflows in Claude Code](https://claude.com/blog/a-harness-for-every-task-dynamic-workflows-in-claude-code) (referencia oficial, feature nativa CC — sin sync)
- [claudefa.st — Autonomous Agent Loops](https://claudefa.st/blog/guide/mechanics/autonomous-agent-loops) (referencia conceptual, sin sync)
- [SKILL_LOOP_INTEGRATION.md](SKILL_LOOP_INTEGRATION.md)
- [LEARNING_LOOP_INTEGRATION.md](LEARNING_LOOP_INTEGRATION.md)
- [AGENT_SKILLS_ADDY_INTEGRATION.md](AGENT_SKILLS_ADDY_INTEGRATION.md)
- [CLAUDE_SKILLS_REZVANI_INTEGRATION.md](CLAUDE_SKILLS_REZVANI_INTEGRATION.md)
- [SDX_ECOSYSTEM.md](SDX_ECOSYSTEM.md)
