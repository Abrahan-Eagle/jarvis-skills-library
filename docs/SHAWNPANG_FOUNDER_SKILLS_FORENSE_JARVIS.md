# Forense startup-founder-skills vs JARVIS — Resumen

**Fecha:** 2026-09-19  
**Repo analizado:** [shawnpang/startup-founder-skills](https://github.com/shawnpang/startup-founder-skills) (MIT)  
**Pin analizado:** `4ad31b43eef3ae3755cc57ec7e435dab4699ab44` (2026-03-16, “Rename frontmatter field trigger → description…”)  
**Objetivo:** Decidir qué entra en jarvis-skills-library **sin** vendorizar el pack ni crear `startup-context` global.

Guía operativa: [SHAWNPANG_FOUNDER_SKILLS_INTEGRATION.md](SHAWNPANG_FOUNDER_SKILLS_INTEGRATION.md) · Router: `founder-skills-router`.

---

## Qué es el pack

Playbook de Shawn Pang para founders técnicos solo o en equipo de 2–3: fundraising, sales, producto, recruiting, ingeniería, legal, ops y growth. Cada tarea es un `SKILL.md`. Todas leen primero `startup-context`. Inspirado en Marketing Skills (Corey Haines); varias skills están **adaptadas** de otros autores (atribución en el README upstream, no en cada archivo).

| Métrica (pin) | Valor |
|---------------|-------|
| Stars / forks (snapshot README, 2026-09-19) | ~330 / ~41 |
| Commits | 23 |
| `SKILL.md` | ~50 (una por carpeta; sin `references/` ni scripts) |
| Runtime | Markdown. Sin bins, hooks ni telemetría |
| Contexto compartido | `reads: [startup-context]` en el resto del pack |
| Licencia | MIT — no se copia texto sustancial a esta library |

El catálogo global JARVIS (**111** skills al 2026-09-07, más este router) **no** tenía `pitch-deck`, `startup-context`, `data-room` ni `cold-outreach`.

---

## Hallazgos vs JARVIS

### Solapamiento por categoría (no sync SKILL.md)

Leyenda: **JC** = canónico JARVIS · **ZP** = skill de producto Zonix (no vive aquí) · **RO** = solo este router · **NA** = no adoptar.

| Área upstream | Skills típicas | Dónde vive | Decisión |
|---------------|----------------|------------|----------|
| Contexto founder | `startup-context` | `zonix-startup-context` | ZP. **NA** global (lógica de negocio) |
| Fundraising | `pitch-deck`, `investor-research`, `data-room`, `fundraising-email` | `zonix-fundraising-narrative`, `zonix-inversionistas-crm`, `zonix-investor-materials` | ZP. RO |
| Aceleradoras US | `accelerator-application` (YC, Techstars, a16z) | — | **NA** |
| Sales / BD | `cold-outreach`, `sales-script`, `lead-scoring`, `partnership-outreach`, `proposal-generation` | `zonix-b2b-sales`; legal en `legal-alternativo-content` / `zonix-legal-contracts-ve` | **NA** global (spam, PII, pseudo-legal). Cherry-pick Fase 2 solo en producto |
| Producto | `prd-writing`, `mvp-scoping`, `roadmap-planning`, `user-research-synthesis` | `sdd-router` → `speckit-*`; marcos citados abajo | JC. **NA** duplicar PRD |
| Mercado | `market-research`, `competitive-analysis` | Cifras: `zonix-startup-context`. What-if: `scenario-analysis-ops` | **NA** skill global de sizing |
| Intel web | `review-mining`, `daily-product-digest`, `competitor-monitoring` | — | **NA** (ver seguridad) |
| Recruiting | `job-description`, `interview-kit`, `sourcing-outreach`, `employer-brand` | — | **NA** global (PII / hiring) |
| Ingeniería | `architecture-design`, `code-review`, `security-review`, `cicd-setup`, `tech-stack-eval` | `architecture-patterns`, `code-review-playbook`, `cyber-neo-router`, `jarvis-experts` | JC |
| Legal | `privacy-policy`, `terms-of-service`, `contract-review`, `soc2-prep` | Producto + HITL abogado. AppSec: `cyber-neo` (no es GRC) | **NA** global |
| Ops / CS / marketing | `process-docs`, `board-update`, `onboarding-flow`, `churn-analysis`, `landing-page`, `seo-technical`, `email-marketing`, `social-content` | `cognitive-doc-design-ops`, `ui-router`, `open-design`, `publish-safety`, skills `zonix-*` / `corralx-*` | JC o producto. **NA** nuevas globales |

### Ideas curadas (citadas en el router; no inyectadas en esta fase)

No se editan `brainstorming-ops`, `deep-interview-ops` ni `strategic-briefing-ops`: están en manifests de producto y el uso aún no está demostrado.

| Marco upstream | A qué apunta el router | Cuándo promoverlo |
|----------------|------------------------|-------------------|
| MoSCoW + hipótesis MVP | `brainstorming-ops` antes de `speckit-specify` | Si un módulo lo usa de verdad |
| JTBD + quotes | `deep-interview-ops` (ya tiene modo startup / 6 forcing questions) | No duplicar esa sección |
| RICE + Now/Next/Later | `strategic-briefing-ops` | Briefing founder, no sustituye `speckit-plan` |
| Filtro 7 puntos + tiers | `zonix-inversionistas-crm` | **Fase 2** producto |
| Matriz 14 slides, Exit, Ask | `zonix-fundraising-narrative`, `zonix-investor-materials` | **Fase 2** producto |
| Anti-spam / self-critique de outreach | `zonix-b2b-sales` | **Fase 2** producto |

### Solo upstream (no adoptar)

- Carpeta `skills/founder/` o los ~50 `SKILL.md`.
- `startup-context` global (rompe “sin lógica de negocio” de `AGENTS.md`).
- Cold outreach, sourcing LinkedIn, scoring de CSV con nombres, generación de MSA/NDA.
- Scraping de reviews, digest de Product Hunt/HN, monitoring de competidores.
- Consejo legal o cifras (TAM, proyecciones, Ask) fuera del pack Lanzamiento.

---

## Matriz 14 diapositivas

Infografía “EL PITCH DECK DE 14 DIAPOSITIVAS”. El `pitch-deck` upstream es un marco de **10–12** (heading “The 10-12 Slide Framework”), con otro orden. Evidencia: filas de esa tabla, no texto copiado.

| # | Slide | Upstream | JARVIS hoy | Acción en esta fase |
|---|-------|----------|------------|---------------------|
| 01 | Título | Cubierto (`Title / Hook`) | `zonix-startup-context`, `zonix-fundraising-narrative` | Router |
| 02 | Problema | Cubierto (`Problem`) | `zonix-startup-context`, `zonix-lean-canvas` | Router |
| 03 | Solución | Cubierto (`Solution`) | `zonix-startup-context` | Router |
| 04 | Producto | Cubierto (`Demo / Product`) | UI/marca de producto, no skill global | Router |
| 05 | Tamaño del mercado (TAM/SAM/SOM) | Cubierto (`Market Size`; skill `market-research`) | Cifras solo en `zonix-startup-context` | Router. No regenerar números |
| 06 | Competencia | Cubierto (`Competition`; skill `competitive-analysis`) | `zonix-lean-canvas`, `scenario-analysis-ops` | Router |
| 07 | Estrategia para ganar | Parcial (trozos en competencia + GTM; no hay slide propio) | `zonix-launch-piloto` | Fase 2 Zonix |
| 08 | Modelo de negocio | Cubierto (`Business Model`) | `zonix-lean-canvas`, `zonix-financial-model` | Router |
| 09 | Finanzas | Parcial (`Financials / Ask` fusiona proyecciones y petición) | `zonix-financial-model` | Router. No inventar EBITDA/burn |
| 10 | Tracción | Cubierto (`Traction`) | `zonix-launch-piloto` | Router |
| 11 | Estrategia de salida al mercado (GTM) | Cubierto (`Go-to-Market`) | `zonix-b2b-sales`, `zonix-launch-piloto` | Router |
| 12 | Equipo | Cubierto (`Team`) | `zonix-lanzamiento-roles` (parcial) | Router |
| 13 | Plan de salida | **Ausente** (`Closing / Vision` no es acquirers/IPO/ROI) | No cubierta | Fase 2: sección Exit en narrativa + materiales inversor, con HITL |
| 14 | La petición | Parcial (ask dentro de Financials) | `zonix-fundraising-narrative` (Q&A SAFE, parcial) | Fase 2: uso de fondos, sin cifras nuevas |

---

## Seguridad (heurística sobre SKILL.md; sin clone en este cambio)

| Hallazgo | Veredicto | Nota |
|----------|-----------|------|
| Seis skills de fundraising | PASS | Sin curl/wget, jailbreak ni scripts |
| `review-mining` | FAIL | Pide minar decenas de reviews en G2, Trustpilot, stores, Reddit |
| `daily-product-digest`, `competitor-monitoring` | WARN | Browse/fetch a sitios terceros y alertas |
| `security-review` | WARN operativo | Pide SAST (`semgrep` y similares). Enrutar a `cyber-neo-router` (read-only) |
| `accelerator-application` | PASS de markdown | URLs de programas US; no usar como verdad ni instalar el pack por eso |
| Resto | PASS de malware | Riesgo es operacional (spam, PII, pseudo-legal), no troyanos |

Si alguien clona el pin en `/tmp`, pasar `skill-security-auditor` antes de enlazar cualquier archivo. Nunca instalar bajo `skills/` de esta library ni bajo `.agents/skills/` de producto.

---

## Reconciliación de analistas (2026-09-19)

Cuatro lecturas en paralelo y un juez. Se descartó ruido:

- **Fundraising:** correcto no vendorizar; Zonix ya destiló el núcleo. Exit y filtro de inversores quedan en Fase 2, no en skills globales nuevas.
- **Sales / recruiting:** correcto rechazar cold outreach, sourcing y propuestas como globales. Rechazadas también `hiring-interview-ops` e `inbound-lead-routing-ops`: no son transversales a cualquier proyecto Laravel/Flutter.
- **Producto:** correcto SKIP de `prd-writing` (Spec Kit gana) y de las tres de browsing. MoSCoW, JTBD y RICE **no** se inyectan en skills existentes en esta fase.
- **Ingeniería / legal / marketing:** correcto el router único y no la categoría `founder/`. Rechazados como globales: `soc2-prep`, `tech-stack-eval`, `cicd-setup`, `seo-technical`, `email-marketing`, `board-update`. `github-actions-templates` no es gap de este pack (no está en el catálogo global; la promoción ya es otro tema). `deep-interview-ops` ya tiene modo startup; JTBD no añade sección nueva.

---

## Qué se adoptó en jarvis-skills-library

| Artefacto | Función |
|-----------|---------|
| `founder-skills-router` | Precedencia pack vs canónico JARVIS o skill de producto |
| `docs/SHAWNPANG_FOUNDER_SKILLS_FORENSE_JARVIS.md` | Este informe |
| `docs/SHAWNPANG_FOUNDER_SKILLS_INTEGRATION.md` | Guía operativa |
| Watchlist `shawnpang-founder-skills` | Pin SHA; sin script de sync |

## Qué NO se adoptó

| Elemento | Razón |
|----------|-------|
| Sync / copia de ~50 SKILL.md | Overlap, sesgo US, supply chain multi-autor |
| `startup-context` global | Lógica de negocio; canon en `zonix-startup-context` |
| Cherry-picks en skills globales existentes | Churn de manifests sin uso demostrado |
| Legal, SOC 2, SEO, email lifecycle, hiring, lead scoring | Dominio producto o no transversal |

## Riesgos

1. **MIT + atribución.** Autores citados por el README upstream: Shawn Pang, Corey Haines, Alireza Rezvani, Pawel Huryn, Jeff Allan, Brian Wagner, Athina AI, Daniel Agrici, Daniel Mendes, Manoj Bajaj. Esta library no copia sus textos; el router solo nombra el origen.
2. **Pin.** Reevaluar solo con SHA nuevo, no con `main` flotante.
3. **Sesgo US.** Delaware, 409A, QSBS, YC no aplican a Venezuela por defecto. Remitir a `zonix-empresa-ve` y `zonix-regulatory-ve`.
4. **No abogado ni contador.** Salidas legales o financieras con `[PENDIENTE abogado]` y `human-in-the-loop-ops`.
5. **No cifras inventadas.** TAM, proyecciones y Ask solo desde `zonix-startup-context` y `docs/Lanzamiento` del producto.
6. **HITL.** Ningún email a inversor, outreach o envío de deck sin orden explícita (`approval-gate`, `publish-safety`, `git-guardrails-ops` no aplican al deck, sí el gate humano).

## Nota legal

Upstream **MIT**. Skills JARVIS de este cambio: overlay **UNLICENSED**. No se vendoriza `LICENSE` ni cuerpos de `SKILL.md` ajenos.
