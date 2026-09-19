# Startup Founder Skills (Shawn Pang) — integración JARVIS

[shawnpang/startup-founder-skills](https://github.com/shawnpang/startup-founder-skills) (MIT) — ~50 skills markdown para founders (pitch, ventas, PRD, legal, growth). Todas leen `startup-context`.

En JARVIS: **`founder-skills-router`**. **No** hay sync de `SKILL.md` upstream ni categoría `skills/founder/`.

Forense: [SHAWNPANG_FOUNDER_SKILLS_FORENSE_JARVIS.md](SHAWNPANG_FOUNDER_SKILLS_FORENSE_JARVIS.md).

## Fuentes oficiales

- Repo: [github.com/shawnpang/startup-founder-skills](https://github.com/shawnpang/startup-founder-skills)
- Pin JARVIS (forense): `4ad31b43eef3ae3755cc57ec7e435dab4699ab44` (2026-03-16)
- Licencia: MIT
- Instalador upstream: `npx skills add shawnpang/startup-founder-skills` — **no** usarlo contra esta library

## vs JARVIS canónico

| Necesidad | Usar |
|-----------|------|
| Workflow / honestidad / precedencia | **`jarvis-core`** (primero) |
| Contexto de la startup (stage, mercado, cifras) | Skill de **producto** `zonix-startup-context`. **No** crear `startup-context` global |
| Pitch, email inversor, data room | `zonix-fundraising-narrative`, `zonix-investor-materials`, `zonix-inversionistas-crm` |
| PRD / spec de producto | `sdd-router` → `speckit-specify` (no `prd-writing`) |
| Alcance MVP antes de spec | `brainstorming-ops` (MoSCoW se cita; no está inyectado) |
| Entrevista / JTBD | `deep-interview-ops` |
| Priorizar outcomes | `strategic-briefing-ops` (RICE se cita; el plan técnico sigue en Spec Kit) |
| TAM / proyecciones | Solo pack del producto. Prohibido inventar cifras |
| Arquitectura / review / AppSec | `architecture-patterns`, `code-review-playbook`, `cyber-neo-router` |
| Landing / deck visual | `ui-router`, `open-design-router` |
| Legal / contratos | Producto `legal-alternativo-content` + `[PENDIENTE abogado]` + `human-in-the-loop-ops` |
| Pedido “instala las founder skills” / pitch deck / data room | **`founder-skills-router`** |

## Arquitectura JARVIS

```
Cursor (~/.cursor/skills vía install.sh)
  └─ founder-skills-router  →  canónico JARVIS o skill zonix-* del repo activo
Prohibido:
  skills/founder/          (esta library)
  .agents/skills/ del pack (repos producto)
Opcional y solo en máquina personal, tras auditor:
  clon del pin en /tmp  (nunca dentro del repo)
```

## Instalación

### Library (recomendado)

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install.sh --all
```

Eso instala el **router**, no las 50 skills.

### Pack externo (opcional, personal)

**No** copiar el pack a `skills/` ni a `.agents/skills/`.

```bash
git clone --depth 1 https://github.com/shawnpang/startup-founder-skills.git /tmp/startup-founder-skills
cd /tmp/startup-founder-skills
git checkout 4ad31b43eef3ae3755cc57ec7e435dab4699ab44
python3 /var/www/html/proyectos/AIPP/jarvis-skills-library/skills/ops/skill-security-auditor/scripts/skill_security_auditor.py /tmp/startup-founder-skills/skills/pitch-deck
```

Conocido en el pin: `review-mining` es FAIL de scraping; `daily-product-digest` y `competitor-monitoring` son WARN. No enlazarlas.

## Mapa pedido → JARVIS

| Pedido / skill upstream | Cadena | ¿Copiar upstream? |
|-------------------------|--------|-------------------|
| Pitch deck, data room, email inversor | Skills `zonix-*` de fundraising del repo activo | No |
| Aceleradora YC / Techstars | — | **Prohibido** como default VE |
| PRD | `speckit-specify` | No |
| TAM / SAM / SOM | `zonix-startup-context` (cifras existentes) | No |
| Cold email / InMail / sourcing | — | **Prohibido** como skill global |
| Propuesta / contrato / ToS / privacidad | `legal-alternativo-content` + HITL | No |
| Code review / arquitectura / seguridad app | Playbook, `architecture-patterns`, `cyber-neo-router` | No |
| Landing / SEO / email marketing | `ui-router`, `zonix-web-design` | No |
| SOC 2 | No confundir con `cyber-neo` | No en esta library |

## Fase 2 (repos producto, no esta library)

Solo con orden explícita. Sin cifras nuevas y con `[PENDIENTE abogado]` donde haya equity o contrato.

| Cambio | Archivo destino (ZonixPharma-Backend) |
|--------|----------------------------------------|
| Sección Exit (acquirers, horizonte, ROI cualitativo) y petición (uso de fondos) alineadas a las slides 13 y 14 | `.agents/skills/zonix-fundraising-narrative/SKILL.md` |
| Mismo Exit en checklist de materiales, sin regenerar el data room US (409A/QSBS) | `.agents/skills/zonix-investor-materials/SKILL.md` |
| Filtro de 7 puntos y tiers, adaptado a VE (no Crunchbase como verdad) | `.agents/skills/zonix-inversionistas-crm/SKILL.md` |
| Reglas anti-spam del outreach (no la secuencia masiva) | `.agents/skills/zonix-b2b-sales/SKILL.md` |

## Marcos que el router nombra y esta fase no edita

| Marco | Skill canónica | Estado |
|-------|----------------|--------|
| MoSCoW | `brainstorming-ops` | Citado, no inyectado |
| JTBD | `deep-interview-ops` | Citado; el modo startup ya existe |
| RICE / Now-Next-Later | `strategic-briefing-ops` | Citado, no inyectado |

## Supply-chain

1. `skill-security-auditor` sobre el clon en `/tmp` si se va a leer una skill suelta.
2. Pin SHA. No `npx skills add` contra el árbol de esta library.
3. Atribución multi-autor: el README upstream lista a Pang, Haines, Rezvani, Huryn, Allan, Wagner, Athina, Agrici, Mendes y Bajaj. No copiar sus `SKILL.md`.

## Uso en Cursor

| Frase | Acción |
|-------|--------|
| "shawnpang" / "founder skills" / "pitch deck" / "data room" / "cold outreach" | Cargar **`founder-skills-router`** |
| "escribe el deck" en un repo Zonix | Router → skills `zonix-*`; no instalar el pack |
| "manda el email al inversor" | Parar. HITL. No enviar |

### Cuándo no usar el pack externo

- Cualquier repo de producto compartido
- Scraping de reviews o monitoring automático
- Borradores legales tratados como dictamen
- Generar TAM o Ask sin citar el pack Lanzamiento

## Watchlist

Entrada `shawnpang-founder-skills` en [catalog/sdx-toolkit-registry.json](../catalog/sdx-toolkit-registry.json). Sin `sync-*.sh`.
