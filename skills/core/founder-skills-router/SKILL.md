---
name: founder-skills-router
description: >
  Orquesta shawnpang y las rúbricas lool (deck, mercado, competencia, finanzas,
  comité, cap table) vs canónico JARVIS. Trigger: founder skills, pitch deck,
  TAM, IC, SAFE, data room.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.2"
  scope: [global]
  category: core
  auto_invoke:
    - "Pack shawnpang founder-skills (pitch, data room, outreach, PRD) vs canónico JARVIS/producto"
    - "pitch deck / data room / fundraising email"
    - "Construir deck, one-pager o slide de petición para inversores"
    - "founder skills o startup-founder-skills"
    - "Pack lool founder-skills (deck, mercado, IC, cap table) vs rúbricas JARVIS"
  triggers: shawnpang, lool, founder skills, pitch deck, data room, fundraising email, cold outreach, PRD, market research, TAM, IC, SAFE, cap table, SOC2, startup-context
  related-skills:
    - jarvis-core
    - sdd-router
    - brainstorming-ops
    - deep-interview-ops
    - strategic-briefing-ops
    - scenario-analysis-ops
    - code-review-playbook
    - cyber-neo-router
    - architecture-patterns
    - ui-router
    - human-in-the-loop-ops
    - skill-security-auditor
    - gstack-router
    - founder-pitch-deck-builder
    - founder-deck-review
    - founder-market-sizing
    - founder-competitive-positioning
    - founder-financial-review
    - founder-ic-sim
    - founder-cap-table-checklist
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

# Founder Skills Router

Dos packs, un router. No sustituye `jarvis-core`, `speckit-*`, ni las skills `zonix-*` del repo de producto.

| Pack | Licencia | Pin | Qué se trajo |
|------|----------|-----|--------------|
| [shawnpang/startup-founder-skills](https://github.com/shawnpang/startup-founder-skills) | MIT | `4ad31b43eef3ae3755cc57ec7e435dab4699ab44` | Solo este router. Guía: [SHAWNPANG_FOUNDER_SKILLS_INTEGRATION.md](../../../docs/SHAWNPANG_FOUNDER_SKILLS_INTEGRATION.md). Forense: [SHAWNPANG_FOUNDER_SKILLS_FORENSE_JARVIS.md](../../../docs/SHAWNPANG_FOUNDER_SKILLS_FORENSE_JARVIS.md). |
| [lool-ventures/founder-skills](https://github.com/lool-ventures/founder-skills) | Apache 2.0 | `70d216778b67b6956cadd79033c219e6bc8b154f` | Seis rúbricas en `skills/planning/`. Guía: [LOOL_FOUNDER_SKILLS_INTEGRATION.md](../../../docs/LOOL_FOUNDER_SKILLS_INTEGRATION.md). Forense: [LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md](../../../docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md). |

## IRON LAW

1. **`jarvis-core` precede** — este router no redacta pitch, contratos ni emails a inversores por su cuenta.
2. **No copiar packs enteros.** Shawnpang no se vende. Lool no se instala: no hay scripts, visor HTML ni `npx skills add`. Las seis rúbricas ya están reescritas; no hay `sync-lool-*.sh`.
3. **No crear `startup-context` global.** En Zonix el canon es `zonix-startup-context`. Cifras solo desde ese pack; no inventar TAM, burn ni Ask.
4. **No dictamen legal.** Privacidad, ToS, contratos y SOC 2 → skill de producto + `[PENDIENTE abogado]` + `human-in-the-loop-ops`.
5. **No scraping ni outreach automático** (`review-mining`, digest, monitoring, cold email, InMail). No enviar nada a un inversor o cliente sin orden explícita.
6. **Supply-chain:** si se clona el pin en `/tmp`, `skill-security-auditor` antes de leer una skill suelta. Sesgo US (YC, Delaware, 409A) no es default VE → `zonix-empresa-ve`.

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| Construir deck / one-pager / slide de petición | Método: `founder-pitch-deck-builder` (formato, 11 slides, petición, uso de fondos). Cifras: skill de producto (`zonix-startup-context`, `zonix-fundraising-narrative`). Render: `open-design-router` | `pitch-deck` shawnpang; inventar tracción, cap o MOIC |
| Revisar pitch, data room, email inversor | Rúbrica: `founder-deck-review`. Cifras y copy de producto: `zonix-fundraising-narrative`, `zonix-investor-materials` | Skill global `pitch-deck` y el plugin lool |
| Exit (slide 13) o petición (slide 14) | `founder-deck-review` + `founder-cap-table-checklist` | Inventar acquirers, ROI o un % de dilución |
| PRD / feature | `sdd-router` → `speckit-specify` | `prd-writing` |
| Cortar MVP | `brainstorming-ops` (MoSCoW: citar, no hay sección nueva) | Segundo PRD |
| Entrevistas | `deep-interview-ops` (JTBD: citar; modo startup ya existe) | Duplicar forcing questions |
| Priorizar roadmap de outcomes | `strategic-briefing-ops` (RICE: citar) | Sustituir `speckit-plan` |
| TAM / SAM / SOM | `founder-market-sizing` (método). Cifras Zonix: `zonix-startup-context` | Inventar el TAM o buscar en la web sin OK |
| Competencia / cómo ganamos | `founder-competitive-positioning` | Visor 3D, CDN, “no tenemos competencia” |
| Revisar modelo / runway | `founder-financial-review`. Modelo Zonix: `zonix-financial-model` | Un Excel nuevo o los scripts lool |
| Ensayo de comité | `founder-ic-sim` | Investigar un fondo real o simular Sequoia sin orden |
| SAFE / cap table / dilución | `founder-cap-table-checklist` + `zonix-empresa-ve` | Calculadora de ownership |
| Arquitectura / review / AppSec | `architecture-patterns`, `code-review-playbook`, `cyber-neo-router` | `security-review` con semgrep |
| Landing / deck visual | `ui-router`, `open-design-router` | `landing-page` upstream |
| Ventas farmacia / outreach | `zonix-b2b-sales` (anti-spam es Fase 2) | `cold-outreach`, `sourcing-outreach` |
| Legal | `legal-alternativo-content`, `zonix-legal-contracts-ve` | Borrador como dictamen |
| Aceleradora US | — | `accelerator-application` |

## Nunca

- Instalar `npx skills add shawnpang/startup-founder-skills` dentro de esta library.
- Minar reviews, vigilar competidores o armar digest de Product Hunt como tarea del agente.
- Generar MSA, NDA, privacidad o términos sin gate de abogado.
- Persistir CSV de leads o candidatos (PII) en logs o skills.
- Publicar o enviar el deck. Parar y pedir OK (`human-in-the-loop-ops`).

## vs otros routers

| Router | Pack | Rol |
|--------|------|-----|
| `gstack-router` | Garry Tan | Sprint de ingeniería; no pitch |
| `claude-skills-router` | Rezvani | Auditoría de skills antes de instalar |
| `sdd-router` | Spec Kit | PRD canónico |
| **`founder-skills-router`** | Shawn Pang + lool + builder JARVIS | Shawnpang solo routing; lool son las seis rúbricas; `founder-pitch-deck-builder` construye (autor ≠ juez) |

## Limitaciones

- No porta los ~50 `SKILL.md` de shawnpang ni el `startup-context` upstream.
- No porta scripts, subagentes ni el visor de lool. Pin `70d21677`.
- Fase 2 (filtro de 7 puntos, anti-spam) vive en el repo Zonix, no aquí.
- Marcos MoSCoW, JTBD y RICE están nombrados arriba y **no** editados en las skills canónicas.
