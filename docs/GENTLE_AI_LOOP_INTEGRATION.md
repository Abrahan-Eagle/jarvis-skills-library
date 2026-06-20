# Agent Loop Engineering — integración JARVIS (Gentleman)

Análisis forense del video **"Agent Loop Engineering"** (Gentleman Programming, stream 12 jun 2026) + tres repos de apoyo, y cómo se materializa en skills JARVIS globales.

Skills resultantes: `agent-loop-engineering` (diseño) + `parallel-judge-ops` ("día del juicio").
Mapa de ecosistema: [LOOP_AI_ECOSYSTEM.md](LOOP_AI_ECOSYSTEM.md). Gobernanza: `human-in-the-loop-ops`.

## Fuentes

| Fuente | Tipo | Decisión JARVIS |
|--------|------|-----------------|
| Video "Agent Loop Engineering" (Gentleman) | Charla | **Adoptado** como base de `agent-loop-engineering` + `parallel-judge-ops` |
| [gentle-ai](https://github.com/Gentleman-Programming/gentle-ai) (MIT) | Configurador de ecosistema (Go) | **Referencia de patrón**, sin sync de binario |
| [engram](https://github.com/Gentleman-Programming/engram) (MIT) | Memoria persistente MCP (Go) | **Watchlist**, sin sync |
| [Gentleman.Dots](https://github.com/Gentleman-Programming/Gentleman.Dots) (MIT) | Dotfiles entorno dev | **Fuera de dominio** (entorno, no loops) |

## Tesis del video → principios JARVIS

| Idea del video | Materialización JARVIS |
|----------------|------------------------|
| Loop = estímulo → iteración interna oculta → resultado, iterando sobre sí mismo | Anatomía en `agent-loop-engineering` (acción→observación→evaluación→stop) |
| "No hagas prompts, haz loops" (creador OpenClaw) | Tabla **loop vs prompt** en `agent-loop-engineering` (no todo es loop) |
| `goal mode` (Codex): llega al objetivo pero "consume como un desgraciado" | Loop-until-done **con token budget + max iterations** (`human-in-the-loop-ops`), no goal mode abierto |
| SDD + TDD strict: `sdd-init` guarda stack/reglas → `apply` iterado (test falla→código→triangula→refactor) | Tipo "test-driven loop" → `test-driven-development` + `verification-before-completion`; SDD → `sdd-router`/`speckit-*` |
| Skill "día del juicio": 2 jueces paralelos independientes → orquestador valida → fix → itera | Skill nueva `parallel-judge-ops` (Task `readonly` en paralelo) |
| La IA es probabilística, no determinística; deriva con el tiempo | Principio goal drift + gates en `agent-loop-engineering` / `human-in-the-loop-ops` |
| El poder está en loops **concisos, reducidos y controlados**; no confiar 100 % | Tres principios + anti-patrón "confiar 100 %" en `agent-loop-engineering` |

## gentle-ai (referencia de patrón)

Configurador que "supercharge" agentes con memoria, SDD, skills, routing de modelo por fase y persona. Relevante para nuestras skills:

- **Strict TDD Mode (`/sdd-init`)**: detecta stack y capacidades de test, activa TDD strict. JARVIS ya lo cubre con `test-driven-development` + `sdd-router`/`speckit-*`; el aporte es el patrón "el init guarda reglas del proyecto y el apply las respeta solo".
- **Delegation triggers**: reglas de cuándo delegar (leer 4+ archivos, tocar 2+ archivos no triviales, review antes de commit). Refuerza `jarvis-experts` + `code-review-playbook` + Task subagents.
- **Per-phase model routing**: modelo distinto por fase SDD. En Cursor: parámetro `model` de Task por subagente.

**Decisión:** no se instala el CLI `gentle-ai`. Es referencia conceptual que alimenta `agent-loop-engineering`. Productos que ya usan SDD JARVIS no cambian.

## engram (watchlist — memoria de loop largo)

Memoria persistente agent-agnostic (Go + SQLite + FTS5, MCP stdio). Relevante porque los **loops largos pierden estado en la compactación**:

- `mem_save`/`mem_search`/`mem_context`: persistir decisiones entre vueltas e sesiones.
- `mem_judge`/`mem_compare`: **conflict surfacing** entre memorias — primo conceptual del patrón juez (detectar que dos decisiones se contradicen).

**Solapamiento JARVIS:** `context-updater`, `handoff`, `session-learner-ops` y `docs/active_context.md` ya cubren persistencia de estado sin dependencia externa.

**Decisión:** **watchlist**, sin sync. Si un producto adopta engram, se configura como MCP en ese repo (dominio), no en la library global. `agent-loop-engineering` lo cita como opción para "persistencia de estado entre vueltas".

## Gentleman.Dots (fuera de dominio)

Dotfiles de entorno de desarrollo (Neovim/LazyVim, Fish/Zsh/Nushell, Tmux/Zellij, terminales). No tiene relación con loops de agente; la capa AI se delega a gentle-ai. **Sin acción** en la library.

## Skills creadas

| Skill | Categoría | Rol |
|-------|-----------|-----|
| `agent-loop-engineering` | engineering | Diseño de loops: anatomía, loop vs prompt, conciso/reducido/controlado, tipos → skill |
| `parallel-judge-ops` | ops | Patrón "día del juicio": jueces paralelos → orquestador valida → fix → itera |

## Qué NO se hizo (y por qué)

- **No router nuevo**: se extendió `skill-loop-router` (evitar proliferación de routers).
- **No sync de binarios** (gentle-ai, engram): la library es capa 0 de skills, no instala runtimes de terceros globalmente.
- **No tocar productos** (CorralX, Zonix, clawvis): adopción por repo si aplica.

## Enlaces

- [LOOP_AI_ECOSYSTEM.md](LOOP_AI_ECOSYSTEM.md) — mapa concepto → skill
- [SKILL_LOOP_INTEGRATION.md](SKILL_LOOP_INTEGRATION.md) — loop YAML+CLI (takumiyoshikawa)
- Skills: `skills/engineering/agent-loop-engineering/SKILL.md`, `skills/ops/parallel-judge-ops/SKILL.md`
