# Stitch upstream — referencia JARVIS

[Google Stitch](https://stitch.withgoogle.com/) es una plataforma de diseño con IA. Las **Agent Skills** oficiales viven en [google-labs-code/stitch-skills](https://github.com/google-labs-code/stitch-skills) y requieren el **Stitch MCP Server** configurado en el agente (Cursor, Claude Code, Antigravity, etc.).

- Get started: [stitch.withgoogle.com/docs/skills/get-started](https://stitch.withgoogle.com/docs/skills/get-started/)
- Prompting: [stitch.withgoogle.com/docs/learn/prompting](https://stitch.withgoogle.com/docs/learn/prompting/)

JARVIS **no vendoriza** el repo upstream en `jarvis-skills-library`. Orquestación: skill **`stitch-router`** + script `scripts/install-stitch-skills.sh`.

## Upstream vs JARVIS

| Concepto | Upstream | JARVIS global |
|----------|----------|---------------|
| Repo skills | `google-labs-code/stitch-skills` | Doc + router + install helper |
| Instalación | `npx skills add` / `npx plugins add` | `bash scripts/install-stitch-skills.sh` |
| Runtime | Stitch MCP + cuenta Stitch | No en library |
| Skills en catálogo | 13+ skills MCP-coupled | Solo `stitch-router` |

## Prerrequisitos

| Requisito | Versión / nota |
|-----------|----------------|
| Node.js | 18+ |
| npm / npx | 7+ |
| Agente | Cursor, Claude Code, Antigravity, Gemini CLI |
| **Stitch MCP Server** | Configurado en Cursor Settings → MCP |
| Cuenta Stitch | Proyecto en [stitch.withgoogle.com](https://stitch.withgoogle.com/) |

Sin MCP activo, las skills upstream **no funcionan** — el router debe STOP y guiar configuración MCP antes de continuar.

## Instalación (oficial)

```bash
# Listar skills disponibles
npx skills add google-labs-code/stitch-skills --list

# Una skill (global → ~/.cursor/skills/)
npx skills add google-labs-code/stitch-skills --skill generate-design --global

# Todas (global)
npx skills add google-labs-code/stitch-skills --all --global

# Plugins (Codex / suite completa)
npx plugins add google-labs-code/stitch-skills --scope workspace --target cursor
```

Wrapper JARVIS:

```bash
bash scripts/install-stitch-skills.sh --list
bash scripts/install-stitch-skills.sh --profile design --global
bash scripts/install-stitch-skills.sh --skill stitch-loop --global
```

## Skills V2 (may 2026)

El skill monolítico **`stitch-design` fue eliminado** y se dividió en workflows especializados.

### Diseño (stitch-design plugin)

| Skill V2 | Uso |
|----------|-----|
| `generate-design` | Pantallas desde texto/imagen; edición y variantes vía MCP |
| `extract-design-md` | `DESIGN.md` desde código frontend (React, Vue, Svelte, CSS) |
| `extract-static-html` | HTML estático autocontenido desde app local |
| `code-to-design` | Cadena: extract HTML → design system → upload Stitch |
| `manage-design-system` | Subir/aplicar `DESIGN.md` y temas en Stitch |
| `upload-to-stitch` | Subir assets locales (HTML, imágenes) al proyecto |

### Build (stitch-build plugin)

| Skill | Uso |
|-------|-----|
| `react:components` | Stitch → componentes React/Vite |
| `remotion` | Walkthrough video desde pantallas Stitch |
| `shadcn-ui` | Integración shadcn/ui |

### Utilidades (stitch-utilities plugin)

| Skill | Uso |
|-------|-----|
| `design-md` | `DESIGN.md` desde proyecto Stitch existente |
| `enhance-prompt` | Ideas vagas → prompts Stitch optimizados |
| `stitch-loop` | Loop autónomo baton (`next-prompt.md` → generar → siguiente) |

### Mapeo V1 → V2 (repos producto con copias antiguas)

| Copia local V1 (ej. CorralX Frontend) | Sustituto upstream V2 |
|---------------------------------------|------------------------|
| `stitch-design` (eliminado) | `generate-design` + `manage-design-system` |
| `design-md` | Sigue existiendo; refresh con `npx skills add` |
| `enhance-prompt` | Sigue existiendo |
| `stitch-loop` | Sigue existiendo |
| `react-components` | `react:components` (nombre CLI) |
| `remotion`, `shadcn-ui` | Igual nombre |

**Refresh recomendado** en producto (no manifest global):

```bash
cd CorralX-Frontend   # o repo con .agents/skills/ locales
npx skills add google-labs-code/stitch-skills --skill design-md
npx skills add google-labs-code/stitch-skills --skill stitch-loop
# Repetir por skill necesaria; o --all en ~/.cursor/skills/
```

## Cuándo usar Stitch vs JARVIS

| Necesidad | Usar | No usar |
|-----------|------|---------|
| Pantalla Flutter/Blade en repo producto | `ui-router` → `{producto}-ui-design` | Stitch MCP |
| Prototipo web **en plataforma Stitch** + MCP | `stitch-router` → skills upstream | `ui-ux-pro-max` solo |
| Carrusel, deck, email HTML standalone | `open-design-router` → Open Design | Stitch salvo proyecto ya en Stitch |
| Tokens BM25 para implementar en código | `ui-ux-pro-max` | Stitch |
| CorralX marketplace UI diario | `corralx-ui-design` + `ui-router` | Stitch/React opcionales |

Cadena típica Stitch:

1. `stitch-router` — verificar MCP
2. `enhance-prompt` o `design-md` (contexto)
3. `generate-design` / `stitch-loop` (generación)
4. `react:components` (export código web, opcional)

## CorralX

- Frontend documenta Stitch/React como **capa 5/6 opcional** — no en manifest sync.
- Prototipos onboarding/KYC pueden alinearse visualmente con Stitch; implementación Flutter usa `corralx-ui-design`.
- Ver [CORRALX_INTEGRATION.md](CORRALX_INTEGRATION.md).

## Política JARVIS

- **Cero vendor** de `stitch-skills` en este repo
- No añadir skills Stitch al `.global-sync-manifest` CorralX
- Mantener `stitch-router` alineado con README upstream tras releases V2+

## Relacionado

- Skill: `stitch-router` (`skills/ui/stitch-router/SKILL.md`)
- [OPEN_DESIGN_INTEGRATION.md](OPEN_DESIGN_INTEGRATION.md) — artefactos standalone alternativos
- [UI_UX_PRO_MAX_INTEGRATION.md](UI_UX_PRO_MAX_INTEGRATION.md) — tokens en código
- `ui-router` — precedencia UI en producto
