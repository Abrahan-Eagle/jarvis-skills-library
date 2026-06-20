# Gentleman ecosystem — integración JARVIS

Mapa forense de [gentle-ai](https://github.com/Gentleman-Programming/gentle-ai), [engram](https://github.com/Gentleman-Programming/engram) y [Gentleman.Dots](https://github.com/Gentleman-Programming/Gentleman.Dots) vs skills globales JARVIS.

Loops / Agent Loop Engineering: [GENTLE_AI_LOOP_INTEGRATION.md](GENTLE_AI_LOOP_INTEGRATION.md).  
Engram MCP: [ENGRAM_INTEGRATION.md](ENGRAM_INTEGRATION.md).

## Skills JARVIS adoptadas (curadas)

| Upstream | Skill JARVIS | Categoría |
|----------|--------------|-----------|
| `judgment-day` (gentle-ai) | `parallel-judge-ops` | ops |
| Video Agent Loop Engineering | `agent-loop-engineering` | engineering |
| `chained-pr` | `chained-pr-ops` | git |
| `work-unit-commits` | `work-unit-commits-ops` | git |
| `branch-pr` (gentle-ai + engram) | `branch-pr-ops` | git |
| `memory-protocol` (engram) | `engram-memory-protocol` | ops |
| `backlog-triage` (engram) | `backlog-triage-ops` | ops |
| `docs-alignment` (engram) | `docs-alignment-ops` | ops |

Router: `engram-router` (memoria MCP opt-in).

## Mapeo SDD gentle-ai → speckit JARVIS (no sync)

| gentle-ai | JARVIS |
|-----------|--------|
| `sdd-init` | `speckit-constitution` + análisis stack en plan / `jarvis-core` |
| `sdd-explore` | `speckit-clarify`, exploración Task |
| `sdd-propose` | `brainstorming-ops`, `writing-plans` |
| `sdd-spec` | `speckit-specify` |
| `sdd-design` | `speckit-plan` |
| `sdd-tasks` | `speckit-tasks` |
| `sdd-apply` | `speckit-implement` + `test-driven-development` |
| `sdd-verify` | `verification-before-completion`, `speckit-analyze` |
| `sdd-archive` | cierre módulo + `session-learner-ops` |
| `sdd-onboard` | `jarvis-core` + `sdd-router` doc |

## Qué NO sync (watchlist / dominio)

| Fuente | Decisión |
|--------|----------|
| Binario `gentle-ai` CLI | Configurador harness — referencia, no skill global |
| Binario `engram` | Runtime MCP — `install-engram-runtime.sh` + router |
| [Gentleman-Skills](https://github.com/Gentleman-Programming/Gentleman-Skills) | Framework skills (React, Angular…) — dominio producto o sync futuro |
| Gentleman.Dots skills | Installer/dotfiles — fuera de alcance |
| engram Go/TUI skills (`server-api`, `dashboard-htmx`, …) | Dominio repo engram |
| `skill-creator` | Ya en JARVIS engineering |
| `pr-review-deep` | `code-review-playbook` + `parallel-judge-ops` |

## Flujo Git/PR recomendado JARVIS

```
jarvis-core
  → work-unit-commits-ops (+ test-driven-development)
  → git-commit / structured-commits-ops
  → si diff >400 líneas: chained-pr-ops
  → branch-pr-ops (+ gh)
  → code-review-playbook / parallel-judge-ops
  → git-guardrails-ops (push solo OK usuario)
```

## Licencia upstream

Skills adaptadas desde Gentleman (Apache-2.0): atribución `upstream:` en frontmatter + overlay JARVIS en cabecera del `SKILL.md`.
