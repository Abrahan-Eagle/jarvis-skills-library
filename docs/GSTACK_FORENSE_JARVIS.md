# Forense gstack vs JARVIS — Resumen

**Fecha:** 2026-09-07  
**Repo analizado:** [garrytan/gstack](https://github.com/garrytan/gstack) (MIT)  
**Pin analizado:** `0530392821c277b95e5cd65aa9d9fda4248718b2` (`VERSION` **1.81.0.0**, 2026-09-06)  
**Objetivo:** Extraer ideas accionables para mejorar skills JARVIS **sin** vendorizar el pack ni romper gobernanza (`git-guardrails-ops`, HITL).

Guía operativa: [GSTACK_INTEGRATION.md](GSTACK_INTEGRATION.md) · Router: `gstack-router`.

---

## Qué es gstack

Setup de Claude Code de Garry Tan (YC): skills + bins + hooks que simulan un **equipo virtual** (CEO, Designer, Eng Manager, Release, Docs, QA) sobre un sprint fijo:

**Think → Plan → Build → Review → Test → Ship → Reflect**

Cada skill deja un artefacto que consume la siguiente (`/office-hours` → design doc → `/plan-ceo-review` → … → `/qa` → `/review` → `/ship` → `/retro`).

| Métrica (pin) | Valor |
|---------------|-------|
| Stars / forks | ~132k / ~19.8k |
| Releases/tags GitHub | **0 / 0** (versionado por `VERSION` + `CHANGELOG.md`) |
| Bus factor | ~1 (autor principal domina commits) |
| `SKILL.md` | ~61 ficheros / ~2.47 MB (53 skills usuario + wrappers/fixtures) |
| Preámbulo común | ~33 KB (~8k tokens) **repetido** por skill tier-2+ |
| Runtime | Bun, Playwright/Aside, hooks Claude Code `settings.json` |
| Cursor host | Existe; frontmatter reducido → **hooks careful/freeze no se exportan** |

El título “23 tools” es legado; el árbol tiene muchas más skills/slash commands.

---

## Hallazgos vs JARVIS global

### Solapamiento — JARVIS canónico (no sync SKILL.md)

| Área gstack | Skill gstack típica | JARVIS global | Decisión |
|-------------|---------------------|---------------|----------|
| Workflow / precedencia | router raíz, CLAUDE.md routing | `jarvis-core`, `task-pipeline-ops` | JARVIS |
| Spec / plan | `/spec`, plan-* | `sdd-router`, `speckit-*`, `writing-plans` | JARVIS |
| Review | `/review` + specialists | `code-review-playbook`, `parallel-judge-ops` | JARVIS + cherry-pick |
| Debug | `/investigate` | `systematic-debugging` | JARVIS + cherry-pick |
| Verificación / ship | `/ship` | `verification-before-completion`, `branch-pr-ops`, `git-guardrails-ops` | JARVIS (**nunca** `/ship` non-interactive) |
| HITL | AUQ / plan-tune | `human-in-the-loop-ops`, `approval-gate` | JARVIS (plan-tune auto-decide = **NA**) |
| Seguridad AppSec | `/cso` | `cyber-neo-router`, `cyber-neo`, Strix | JARVIS + cherry-pick supply-chain skills |
| Memoria / cierre | `/learn`, context-*, `/retro` | `handoff`, `session-learner-ops`, `learning-loop`, `strategic-briefing-ops`, Engram | JARVIS + cherry-pick métricas |
| QA browser | `/qa`, `/browse` | `webapp-testing` | JARVIS + metodología WTF |
| UI/design | design-* | `ui-router`, `ui-ux-pro-max`, `open-design-router` | JARVIS |

### Complemento — ideas curadas (cherry-pick en skills existentes)

| Idea gstack | Dónde en JARVIS |
|-------------|-----------------|
| Evidence fresca atada al working tree + Completion Status | `verification-before-completion` |
| 3-strike debug + scope lock | `systematic-debugging` |
| Confianza + cita `file:line` + AUTO-FIX/ASK + LLM trust boundary | `code-review-playbook`, `parallel-judge-ops` |
| WTF-likelihood / cap fixes / report-only | `webapp-testing` |
| One-way doors; User Challenge nunca auto | `human-in-the-loop-ops` |
| 6 forcing questions (office-hours) | `deep-interview-ops` |
| Scope modes EXPANSION/HOLD/REDUCTION | `jarvis-experts` |
| Skill Supply Chain + gate confianza | `cyber-neo`, `skill-security-auditor` |
| Métricas git + anti-fabricación | `strategic-briefing-ops` |
| Mapa Diataxis | `docs-alignment-ops` |
| Careful como hook Cursor | `git-guardrails-ops` + skill `create-hook` |
| Handoff de la rama actual | `session-startup-ops` |
| Readiness pre-merge (reporte) | `finishing-a-development-branch` |
| Read-first `path:line` / dedupe issues | `speckit-clarify`, `speckit-taskstoissues` |

### Solo runtime gstack (no adoptar)

- Browser daemon propio (`$B`), Aside, cookie decryption, sidebar agent, ngrok/`pair-agent`
- `/ship` y `/land-and-deploy` non-interactive (push/merge automáticos)
- Auto-update `SessionStart` / team mode `required`
- Telemetría Supabase / GBrain
- `/plan-tune` auto-decidir preguntas
- Preámbulo ~33 KB por skill; suite iOS; `design-shotgun` pago

---

## Arquitectura (resumen evidencia)

```mermaid
flowchart LR
  OH["/office-hours"] --> SPEC["/spec"]
  SPEC --> PCEO["/plan-ceo-review"]
  PCEO --> PENG["/plan-eng-review"]
  PENG --> AUTO["/autoplan"]
  AUTO --> IMPL["impl + /investigate"]
  IMPL --> QA["/qa"]
  QA --> REV["/review"]
  REV --> SHIP["/ship"]
  SHIP --> LAND["/land-and-deploy"]
  LAND --> DOC["/document-release"]
  DOC --> RETRO["/retro"]
```

**Hooks Claude Code** (registrados por `./setup` en `~/.claude/settings.json`): `SessionStart` → auto-update (team); `PreToolUse` Bash/Edit → careful/freeze; `AskUserQuestion` → plan-tune; `Stop` → timeline (+ verify-gate opt-in).

**Cursor:** `hosts/cursor` reduce frontmatter a name+description → **sin enforcement** careful/freeze.

**Supply-chain (auditor JARVIS + triage manual):**

| Hallazgo | Severidad | Nota |
|----------|-----------|------|
| `sudo -n` apt/dnf/pacman en `setup` (fuentes emoji) | Medio | Verdadero positivo |
| Deps runtime fuera de lockfile (bun, Chromium, ONNX ~112 MB HF, gbrain) | Alto | Superficie no reproducible |
| Auto `git pull --ff-only` sin firma/pin (team mode) | Alto | Issue #2378: upgrade a HEAD |
| Cookies Keychain/libsecret | Crítico (opt-in) | No adoptar |
| pair-agent ngrok | Crítico (opt-in, fail-closed default) | No adoptar |
| Telemetría default off; README subdeclara campos | Medio | Opt-out / no sync |
| Falsos positivos auditor (regex en hooks/tests) | — | 46 PASS / 1 WARN / 6 FAIL brutos |

---

## Conflictos de gobernanza (citas cruzadas)

| ID | gstack | JARVIS | Acción |
|----|--------|--------|--------|
| G1 | `/ship`: non-interactive, incluye untracked, push | `jarvis-core` / `git-guardrails-ops`: nunca push sin orden | **Prohibir `/ship`**; cadena verification → commits → branch-pr → guardrails |
| G2 | plan-tune puede auto-decidir AUQ | `human-in-the-loop-ops`: irreversible = gate humano | **NA** auto-decide; adoptar solo “one-way door overrides never-ask” |
| G3 | autoplan “bias toward action / don’t block” | brainstorming / HITL bloquean hasta OK | **NA** autoplan; User Challenge → HITL |
| G4 | SessionStart auto-update | sync JARVIS explícito + pin | **NA** auto-update |
| G5 | sesión spawned sin AskUserQuestion | HITL / no nested personas ciegas | Documentar; no portar |

**Coincidencias:** iron law root-cause (`/investigate` ≡ `systematic-debugging`); no completion without evidence (`/ship` step 16 ≡ `verification-before-completion`); never force-push default.

---

## Qué se adoptó en jarvis-skills-library

| Artefacto | Función |
|-----------|---------|
| `gstack-router` | Precedencia pack vs canónico JARVIS |
| `docs/GSTACK_FORENSE_JARVIS.md` | Este informe |
| `docs/GSTACK_INTEGRATION.md` | Guía operativa + mapa slash → JARVIS |
| Cherry-picks en skills listadas arriba | Ideas sin copiar SKILL.md upstream |
| Fila Auto-invoke + párrafo `jarvis-core` + watchlist AWESOME | Cableado |

## Qué NO se adoptó

| Elemento | Razón |
|----------|-------|
| Sync masivo / `sync-gstack-*.sh` | Preámbulo Claude-acoplado + colisiones de nombre |
| Browser/cookies/pair-agent/Aside | Superficie seguridad + macOS-céntrico; Cursor ya tiene browser MCP |
| `/ship`, `/land-and-deploy`, `/autoplan`, `/plan-tune` | Contradicen gobernanza JARVIS |
| Telemetría / GBrain / team auto-upgrade | Memoria JARVIS = active_context / Engram / NotebookLM |
| iOS suite | Fuera de alcance global |

## Riesgos operativos

1. **Falsa sensación de careful/freeze en Cursor** si se instala el pack externo.  
2. **Doble régimen de gates** si alguien ejecuta `/ship` gstack junto a `git-guardrails-ops`.  
3. **Coste de contexto** si se instalan las 53 skills always-on (~1–6k tokens descriptions + cuerpos enormes). Preferir `--prefix` o no instalar.  
4. **Bus factor 1 + 0 releases** → pin SHA obligatorio si se usa algo upstream.

## Nota legal

gstack upstream **MIT** (Copyright Garry Tan). Ideas curadas en skills JARVIS: overlay **UNLICENSED**; no se copia texto sustancial de SKILL.md upstream. Atribución: este doc + `GSTACK_INTEGRATION.md`.

---

## Apéndice A — Matriz 53 skills gstack × JARVIS

Leyenda decisión: **JC** = JARVIS canónico (no adoptar) · **CP** = cherry-pick ya aplicado · **RO** = router-only (documentar; no sync) · **NA** = no adoptar.

| # | gstack | Equivalente JARVIS | Decisión |
|---|--------|--------------------|----------|
| 1 | office-hours | `deep-interview-ops`, `brainstorming-ops` | CP |
| 2 | spec | `speckit-specify`, `speckit-clarify`, `speckit-taskstoissues` | CP (read-first + dedupe) |
| 3 | plan-ceo-review | `jarvis-experts`, `speckit-clarify` | CP (scope modes) |
| 4 | plan-eng-review | `speckit-plan`, `writing-plans` | JC |
| 5 | plan-design-review | `ui-router`, `ui-ux-pro-max` | JC |
| 6 | plan-devex-review | `cognitive-doc-design-ops` | RO |
| 7 | autoplan | `fan-out-synthesize-ops`, `parallel-judge-ops`, HITL | RO; auto-approve **NA** |
| 8 | review | `code-review-playbook`, `parallel-judge-ops` | CP |
| 9 | investigate | `systematic-debugging` | CP (3-strike + scope lock) |
| 10 | qa | `webapp-testing` | CP (WTF-likelihood) |
| 11 | qa-only | `webapp-testing` (report-only) | CP |
| 12 | design-review | `ui-router`, `ui-ux-pro-max` | RO |
| 13 | design-consultation | `ui-ux-pro-max` | JC |
| 14 | design-html | `open-design`, `ui-ux-pro-max` | JC |
| 15 | design-shotgun | `open-design` | RO / NA (pago) |
| 16 | devex-review | `cognitive-doc-design-ops` | RO |
| 17 | ship | `verification-before-completion` → `work-unit-commits-ops` → `branch-pr-ops` | CP evidencia; **NA** non-interactive |
| 18 | land-and-deploy | `finishing-a-development-branch`, `git-guardrails-ops` | CP readiness; **NA** merge auto |
| 19 | setup-deploy | — | RO |
| 20 | canary | `kalman-anomaly-defense` (diseño) | RO |
| 21 | benchmark | — | RO |
| 22 | benchmark-models | `llm-as-judge-ops` | NA |
| 23 | careful | `git-guardrails-ops` + Cursor `create-hook` | CP |
| 24 | freeze / unfreeze | — (prosa + hook opcional) | RO |
| 25 | guard | careful+freeze | RO |
| 26 | cso | `cyber-neo-router` → `cyber-neo` | CP (Skill Supply Chain) |
| 27 | retro | `strategic-briefing-ops`, `session-learner-ops` | CP (métricas git) |
| 28 | health | — | RO |
| 29 | learn | `learning-loop`, `session-learner-ops` | JC |
| 30 | context-save | `handoff`, `context-updater` | JC |
| 31 | context-restore | `session-startup-ops`, `handoff` | CP (rama actual) |
| 32 | plan-tune | `human-in-the-loop-ops` | NA auto-decide; CP one-way doors |
| 33 | document-release | `docs-alignment-ops`, `documentar-avances` | CP (Diátaxis) |
| 34 | document-generate | `cognitive-doc-design-ops` | JC |
| 35 | diagram | `open-design` | RO |
| 36 | make-pdf | `open-design` | RO |
| 37 | browse | `webapp-testing`, browser MCP | RO / **NA** daemon |
| 38 | scrape | browser MCP | RO |
| 39 | skillify | `skill-creator` | NA |
| 40 | setup-browser-cookies | — | **NA** |
| 41 | open-gstack-browser | — | **NA** |
| 42 | pair-agent | — | **NA** |
| 43 | codex | `doubt-driven-development`, `parallel-judge-ops` | CP (juez cross-provider) |
| 44 | landing-report | `backlog-triage-ops` | NA |
| 45 | setup-gbrain | `engram-router` | JC |
| 46 | sync-gbrain | `engram-memory-protocol` | JC |
| 47 | gstack-upgrade | `jarvis-skills-maintainer` | JC; auto-upgrade **NA** |
| 48–51 | ios-qa / ios-fix / ios-design-review / ios-sync / ios-clean | `flutter-expert`, `mobile-developer` | NA (stack iOS) |
| 52 | gstack (router raíz) | `jarvis-core`, `gstack-router` | JC |
| 53 | openclaw wrappers | `approval-gate`, `activity-log`, `publish-safety` | JC |

Wrappers/fixtures extra en el árbol (~61 `SKILL.md`): no skills de usuario; ignorar.

## Apéndice B — Auditor JARVIS (`skill_security_auditor.py`)

Ejecutado sobre clon `/tmp` (pin `0530392`); scratch borrado. Script: `skills/ops/skill-security-auditor/scripts/skill_security_auditor.py`.

| Veredicto bruto | Conteo |
|-----------------|--------|
| PASS | 46 skills |
| WARN | 1 (`gstack-upgrade` — `python3 -c` realpath en migración; benigno) |
| FAIL | 6 (`browse`, `make-pdf`, `ios-qa`, `careful`, `cso`, `pair-agent`) |

Casi todos los FAIL/WARN son **falsos positivos** de regex sobre tests, hooks defensivos y listas de patrones a detectar.

**Verdaderos positivos (superficie, no malware):**

1. `sudo -n apt-get/dnf/pacman` en `setup` (fuentes emoji) — Medio.
2. Dependencias runtime fuera de lockfile: bun, Chromium/Playwright, modelo ONNX ~112 MB HuggingFace, gbrain — Alto (reproducibilidad).
3. `child_process` extensivo en `browse/` — esperado en un CLI de browser; argv-array, revisar si se instala.

`validate-skills.sh --check-net-exec` sobre 212 ficheros: `net_exec_flags=0`. `curl|sh` aparece en comentarios/docs, no como invocación del pack (el hook careful deja pasar `curl|sh` a propósito).

## Apéndice C — No verificado

- No se ejecutó `./setup`, `bun install`, hooks ni el daemon browse (solo lectura de código).
- No se auditaron edge functions Supabase de telemetría ni el hash del modelo ONNX.
- Descifrado de cookies en Windows (DPAPI): no inspeccionado (grep de internals bloqueado).
- `gstack-context-bill --exact` no se corrió (envía contenido a Anthropic).
- Tests upstream (`bun test`, ~8660 declarados en CHANGELOG 1.78) no ejecutados.
- Cuerpos de issues “security” (#1324, #1136, #1080, #2378…): solo títulos.
- Comportamiento runtime de `./setup --host cursor` (strip de `hooks:`): inferido de `hosts/define-host.ts`, no probado.
