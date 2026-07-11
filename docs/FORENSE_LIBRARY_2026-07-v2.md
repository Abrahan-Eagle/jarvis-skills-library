# Forense jarvis-skills-library — Julio 2026 v2

**Fecha:** 2026-07-10  
**Repo:** `/var/www/html/proyectos/AIPP/jarvis-skills-library`  
**Metodología:** plan integral A–E · `fan-out-synthesize-ops` + `parallel-judge-ops` (4 jueces) + sync consumidores  
**Corpus:** 106 skills / 11 categorías  
**Predecesor:** [FORENSE_LIBRARY_2026-07.md](FORENSE_LIBRARY_2026-07.md) (commit `7ab2981`)

---

## Resumen ejecutivo

| Fase | Resultado |
|------|-----------|
| 0 Baseline | `validate-all` 0 errors; catalog/lock/graph regenerados |
| 1 Supply-chain | Helper `scripts/lib/git-pin.sh`; sync/install abortan si pin falla; `validate-skills.sh` escanea `scripts/`; CI `.github/workflows/validate-skills.yml`; doc [SUPPLY_CHAIN_SCRIPTS.md](SUPPLY_CHAIN_SCRIPTS.md) |
| 1 P3 | `SKILL-OC.md` ×3 (client-report, publish-safety, cyber-neo-cli) → **0 WARN**; [AI_MEDIA_LANDING_INTEGRATION.md](AI_MEDIA_LANDING_INTEGRATION.md); frontmatter `code-review-playbook` normalizado |
| 2 Contenido | 4 jueces → matriz mantener/fusionar/podar (HITL antes de podar) |
| 3 Gaps | Propuestas P1: `laravel-prod-migration-ops`, `release-deploy-ops` (no creadas — YAGNI/HITL) |
| 4 Consumidores | 6 repos CorralX/Zonix/Glasses **OK** tras sync; clawvis manifest + overlays + sync **OK** (19 skills) |
| 5 Verify | Ver § Verificación |

---

## Fixes aplicados (este ciclo)

### Supply-chain

- `scripts/lib/git-pin.sh` — `jarvis_git_checkout_pin` (abort on fail; WARN si `main`/`master`)
- Sync/install endurecidos: cyber-neo, learning-loop, skill-loop, addy, claude-skills, install-*-upstream
- WARN floating ref en open-design / strangeverse / spec-kit-extensions
- `validate-skills.sh`: escaneo net-exec en `scripts/**/*.{sh,py}` (excluye `smoke-*` y fixtures); archivos sin frontmatter se escanean enteros
- Allowlist docs: `install-open-design-runtime.sh`, `install-notebooklm-runtime.sh`
- CI: `.github/workflows/validate-skills.yml` (linter + lock freshness)
- Doc: `docs/SUPPLY_CHAIN_SCRIPTS.md`

### P3 / docs / frontmatter

- `SKILL-OC.md` en client-report, publish-safety, cyber-neo-cli
- `docs/AI_MEDIA_LANDING_INTEGRATION.md`
- `code-review-playbook`: schema CONVENTIONS (sin hooks Claude plugin)
- `configure-ecc`: clone `affaan-m/ecc` (antes `everything-claude-code`)
- `GENTLE_AI_LOOP_INTEGRATION.md`: Engram **adoptado** (ya no watchlist)
- `sync-catalog.py`: orden de precedencia jarvis-core en filas multi-skill de AUTO_INVOKE

### Consumidores

| Producto | Antes | Después |
|----------|-------|---------|
| CorralX Back/Front | drift `code-review-playbook` | check **OK** |
| ZonixPharma Back/Front | drift playbook | check **OK** |
| zonix-glasses Back/Front | 8–16 drifts | check **OK** |
| clawvis | sin fan-out / notebooklm / jarvis-core|experts | manifest + overlays + sync **OK** (19) |

---

## Jueces (síntesis — real vs ruido)

### Juez 1 Redundancia

| Acción | Severidad | Estado |
|--------|-----------|--------|
| Canónico `code-review-playbook`; archivar/fusionar `github-code-review` + `code-review-excellence`; absorber stubs requesting/receiving | P0 | **Hecho 2026-07-10** — cuerpos en `archive/skills/review/`; stubs deprecated + requesting/receiving reescritos |
| Podar/rellenar stubs `clean-architecture`, `flutter-expert`, `mobile-developer`; fusionar `software-architecture` | P1 | **Propuesta HITL** |
| Routers `*-router` | — | **No tocar** (gates por marcador) |
| Playwright cluster en library | — | Solo `webapp-testing`; resto es cross-repo |

### Juez 2 Obsolescencia

| ID | Fix |
|----|-----|
| P1-ECC configure-ecc URL | **Aplicado** |
| P1-GCR github-code-review URLs/Claude Flow | Propuesta HITL (podar o sanear) |
| P1-AL / P1-CR / P1-AG cluster OpenClaw paths `skills/global/` | Documentado; remediación gradual |
| P2-ENG Engram watchlist doc | **Aplicado** |
| P2-CLAW manifest corto | **Aplicado** (fan-out, notebooklm, jarvis overlays) |

### Juez 3 Calidad

Patrones: ~57% muestra sin `metadata.category`; validador solo exige name/description.  
**Aplicado:** playbook + SKILL-OC.  
**Pendiente HITL:** endurecer `validate-skills.sh` (WARN→FAIL gradual); lote frontmatter ops/core; reescribir stubs non-code.

### Juez 4 Precedencia

| Acción | Antes | Después (sync-catalog) |
|--------|-------|------------------------|
| Cualquier tarea no trivial | fan-out, experts | **experts → fan-out** |
| Crear commit | git-commit primero | **verify → git-commit → structured** (falta `work-unit` en frontmatter) |
| Terminar módulo | finishing primero | **verify → session-learner → finishing** (+ jarvis-core residual) |
| Iniciar módulo | brainstorming primero | **jarvis-core → brainstorming → task-pipeline** (falta `writing-plans` en frontmatter) |

---

## Gaps — skills nuevas propuestas (NO creadas)

| Skill | Prio | Notas |
|-------|------|-------|
| `laravel-prod-migration-ops` | P1 | Checklist migrate prod; dolor CorralX/Zonix documentado |
| `release-deploy-ops` | P1 | Runbook release + rollback + HITL |
| `sre-observability-ops` | P2 | Solo si hay Sentry/uptime real |
| `flutter-integration-testing-ops` | P3 | Extender `finishing-a-development-branch` primero |
| Promover `github-actions-templates` | P2 | Ya existe local en backends — promoción, no skill nueva |

Crear solo con OK explícito del usuario (YAGNI).

---

## Decisiones pendientes (HITL)

1. ¿Podar/archivar `github-code-review` y `code-review-excellence` a favor de `code-review-playbook`?
2. ¿Crear `laravel-prod-migration-ops` y/o `release-deploy-ops`?
3. ¿Endurecer CI frontmatter (category, Trigger, allowed-tools) a FAIL?
4. ¿Commit local de library + commits en productos/clawvis por el sync? (**sin push** hasta orden)

---

## Verificación

```text
validate-skills: checked=106 bins=8 scripts_scanned=43 net_exec_flags=0 errors=0 warnings=0
validate-all.sh: exit 0 (todos los smokes OK, 2026-07-10)
check-global-skills-sync: 6/6 productos OK + clawvis OK (19 skills)
```

---

## Cierre ciclo ECC cherry-pick + remediación (2026-07-11)

Plan ejecutado en `jarvis-skills-library` (rama `main`, commits locales; **sin push** salvo orden).

| Fase | Estado |
|------|--------|
| 0 Links + validador + `.gitignore` + CLv2 overlay/heading | **Hecho** — `scripts/validate-markdown-links.py` en `validate-all` + CI |
| 1 AUTO_INVOKE (excluir deprecated; compact→strategic-compact; writing-plans/work-unit) | **Hecho** |
| 2 Wiring jarvis-core / session-startup / handoff / judge→approval-gate / context-updater | **Hecho** |
| 3 Learning-loop seeds + HITL session-learner + configure-ecc | **Hecho** |
| 4 Onboarding trío ECC (PROJECT_ONBOARDING, AGENTS.minimal, manifest example, bootstrap) | **Hecho** |
| 5 Supply-chain re-pin (ecc/open-design/strangeverse) + docs pins + `ecc consult "$*"` | **Hecho** |
| 6 `bash scripts/validate-all.sh` | **OK** (exit 0, 2026-07-11) |

**YAGNI confirmado (no hecho):** vendorizar skills/agents ECC, hooks por defecto, eval-harness, update-codemaps, statusline, mcp-configs, enforcement judge en bin `approval-gate`, skills `laravel-prod-migration-ops` / `release-deploy-ops`.

Cierra pendiente forense § Fuera de scope ítem 4 (auto_invoke writing-plans / work-unit-commits-ops).

---

## Fuera de scope / siguiente ciclo

1. Poda/fusión skills review + stubs arquitectura/móvil (tras HITL).
2. Lote frontmatter CONVENTIONS + validate WARN→FAIL.
3. Remediación paths `skills/global/` en bins OpenClaw (activity-log, approval-gate, client-report).
4. ~~Añadir `work-unit-commits-ops` / `writing-plans` a auto_invoke~~ — **cerrado 2026-07-11**.
5. Commits + push solo con orden del usuario.
