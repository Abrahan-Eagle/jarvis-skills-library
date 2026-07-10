# Forense jarvis-skills-library — Julio 2026

**Fecha:** 2026-07-10  
**Repo:** `/var/www/html/proyectos/AIPP/jarvis-skills-library`  
**Metodología:** `fan-out-synthesize-ops` + `parallel-judge-ops` (4 jueces) + `verification-before-completion`  
**Corpus:** 106 skills / 11 categorías · `validate-all.sh` baseline: 106 OK, 3 WARN `SKILL-OC.md`

---

## Resumen ejecutivo

| Severidad | Count (validados) | Acción en este ciclo |
|-----------|-------------------|----------------------|
| P1 | 10 | Corregidos o documentados con fix |
| P2 | 18 | Normalización frontmatter + cyber-neo dir + grafo |
| P3 | 12 | Documentados; no aplicados |

**Estado post-fix (objetivo):** `validate-all` 0 errors · catalog/lock/graph regenerados · commit local sin push.

---

## Jueces

| Juez | Dimensión | Hallazgos retenidos |
|------|-----------|---------------------|
| 1 | Seguridad / supply-chain | Pin silencioso en syncs, guard net-exec no cubre scripts, lock sin gate CI |
| 2 | Catálogo / frontmatter | related rotos, SKILLS_GRAPH stale, cyber-neo dir≠name, 18 sin license |
| 3 | Docs / gobernanza | `../docs/` rotos, APPROVAL_GATES / plantillas inexistentes, AGENTS vs AUTO_INVOKE |
| 4 | Consumidores | clawvis sin fan-out/notebooklm; CorralX/Zonix/Glasses OK en 4 skills recientes |

---

## P1 — Rotos (aplicar)

| ID | Hallazgo | Fix |
|----|----------|-----|
| P1-01 | `sdd-router` enlaces `](../docs/…)` | → `../../docs/` |
| P1-02 | `jarvis-skills-maintainer` ~29 enlaces `](../docs/…)` | → `../../docs/` |
| P1-03 | `approval-gate` → `docs/APPROVAL_GATES.md` inexistente | Crear stub mínimo |
| P1-04 | `client-report` → `docs/plantillas/REPORTE_CLIENTE.md` inexistente | Crear plantilla mínima |
| P1-05 | `laravel-specialist` related: `fullstack-guardian`, `test-master`, `devops-engineer`, `security-reviewer` | Remap a skills globales reales |
| P1-06 | Placeholders `product-ui-design` / `product-kyc-ui` en brainstorming/deep-interview/requesting-code-review | Remap a skills globales o quitar |
| P1-07 | Sync scripts: `git checkout "$REF" \|\| true` sin abort | Documentado P1 supply-chain; fix diferido a ciclo scripts (riesgo alto, scope aparte) |
| P1-08 | Guard net-exec no escanea `scripts/` | Documentado; fix diferido |
| P1-09 | clawvis sin `fan-out-synthesize-ops` / `notebooklm-router` | Documentado en § Consumidores; sync producto fuera de este commit library |
| P1-10 | `SKILLS_GRAPH.md` stale (2026-06-18, 124 aristas ausentes) | Regenerar con `skills-graph.py` |

---

## P2 — Inconsistencias (aplicar en library)

| ID | Hallazgo | Fix |
|----|----------|-----|
| P2-01 | 18 skills sin `license` | Añadir `license: UNLICENSED` |
| P2-02 | `laravel-specialist` related CSV | Lista YAML |
| P2-03 | Dir `non-code/cyber-neo` vs name `cyber-neo-cli` | Renombrar dir → `cyber-neo-cli` |
| P2-04 | `AGENTS.md` omite Zonix en sync productos | Añadir fila Zonix |
| P2-05 | `CONVENTIONS.md` omite categoría `sdd` | Añadir `sdd` |
| P2-06 | `README.md` path falso `git/git-guardrails-ops` | Corregir a `ops/` |
| P2-07 | AGENTS auto-invoke vs `catalog/AUTO_INVOKE.md` (code-review / handoff / cerrar sesión) | Alinear filas tras sync-catalog |
| P2-08–P2-12 | Supply-chain: REF=main, npx/uv/brew floating, lock sin CI | Documentados; no cambiar scripts en este ciclo |

---

## P3 — Mejora opcional (no aplicar)

- 30 skills sin `auto_invoke` (coherente si no son auto-invoke).
- 50 sin `allowed-tools` (template no es gate CI).
- WARN `bin/` sin `SKILL-OC.md` (client-report, cyber-neo-cli, publish-safety).
- Fronts sin `security` en manifest (asimetría deliberada stack).
- Zonix/Glasses sin `llm-as-judge-ops` (tienen `parallel-judge-ops`).
- Renombrar docs STITCH_UPSTREAM → STITCH_INTEGRATION (cosmético).
- `ai-media-landing-ops` sin doc de integración dedicada.

---

## Consumidores (snapshot)

| Producto | 4 skills recientes* | Notas |
|----------|---------------------|-------|
| CorralX Back/Front | OK | — |
| ZonixPharma Back/Front | OK | — |
| zonix-glasses Back/Front | OK | — |
| clawvis-openclaw | Falta fan-out + notebooklm (+ jarvis-core/experts) | Remediación en repo clawvis |

\* `fan-out-synthesize-ops`, `notebooklm-router`, `agent-loop-engineering`, `parallel-judge-ops`

---

## Checklist de remediación (este PR/commit)

- [x] Fan-out 4 jueces
- [x] Fix `../docs/` → `../../docs/`
- [x] Stubs APPROVAL_GATES + REPORTE_CLIENTE
- [x] related-skills rotos + license ×18
- [x] Renombrar `non-code/cyber-neo` → `cyber-neo-cli`
- [x] Docs AGENTS/CONVENTIONS/README menores
- [x] `validate-all` + `sync-catalog` + `sync-lock` + `skills-graph`
- [x] Commit local (sin push)

---

## Fuera de scope (siguiente ciclo)

1. Hardening scripts sync/install (abort on pin fail, SHA256 blobs, CI gate lock).
2. Ampliar `validate-skills.sh` a escanear `scripts/*.sh`.
3. Sync manifest clawvis (`fan-out-synthesize-ops`, `notebooklm-router`, overlays jarvis).
4. Normalización masiva legacy frontmatter (code-review-playbook plugin schema).
