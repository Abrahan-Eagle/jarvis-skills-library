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

## MCP Setup (Cursor y agentes)

Documentación oficial:

- [MCP setup](https://stitch.withgoogle.com/docs/mcp/setup/?pli=1) — endpoint, credenciales, prereqs
- [MCP guide](https://stitch.withgoogle.com/docs/mcp/guide/?pli=1) — flujos operativos (proyectos, pantallas, generación)
- [MCP reference](https://stitch.withgoogle.com/docs/mcp/reference/?pli=1) — catálogo de tools MCP

### Endpoint remoto (recomendado si el cliente soporta headers)

| Campo | Valor |
|-------|-------|
| URL | `https://stitch.googleapis.com/mcp` |
| Header auth | `X-Goog-Api-Key: <tu API key Stitch>` |
| Transport | Streamable HTTP (MCP remoto) |

Ejemplo **local** (gitignored — no commitear la key):

```json
{
  "mcpServers": {
    "stitch": {
      "url": "https://stitch.googleapis.com/mcp",
      "headers": {
        "X-Goog-Api-Key": "REPLACE_WITH_STITCH_API_KEY"
      }
    }
  }
}
```

**Seguridad:** nunca versionar API keys. Rotar si se exponen en chat, issues o commits. Preferir config local gitignored.

### Cursor: config recomendada (proxy stdio)

En Cursor, la config remota `url` + `headers` suele mostrar **punto verde** pero **"No tools, prompts, or resources"** — Cursor descarta silenciosamente el `tools/list` de Stitch (~287 KB). Ver [foro Cursor](https://forum.cursor.com/t/mcp-server-connected-green-dot-and-tools-discovered-in-logs-but-0-tools-in-ui-and-agent/160620).

**Recomendado en Cursor:** proxy stdio `@_davideast/stitch-mcp` (plantilla [`.cursor/mcp.json.proxy.example`](file:///var/www/html/proyectos/AIPP-RENNY/DESARROLLO/CorralX/WorksPagesCorralX/CorralX-Frontend/.cursor/mcp.json.proxy.example) en CorralX-Frontend):

```json
{
  "mcpServers": {
    "stitch": {
      "command": "npx",
      "args": ["-y", "@_davideast/stitch-mcp@latest", "proxy"],
      "env": {
        "STITCH_API_KEY": "REPLACE_WITH_STITCH_API_KEY"
      }
    }
  }
}
```

Diagnóstico terminal (antes de reiniciar Cursor):

```bash
STITCH_API_KEY=REPLACE_WITH_STITCH_API_KEY npx -y @_davideast/stitch-mcp@latest doctor
```

Debe reportar healthy / 200. Luego copiar plantilla → `.cursor/mcp.json` local (gitignored).

**Alternativa secundaria:** endpoint remoto (puede fallar en Cursor con 0 tools):

```json
{
  "mcpServers": {
    "stitch": {
      "url": "https://stitch.googleapis.com/mcp",
      "headers": {
        "X-Goog-Api-Key": "REPLACE_WITH_STITCH_API_KEY"
      }
    }
  }
}
```

Ver también `.cursor/mcp.json.remote.example` en CorralX-Frontend.

### Checklist de verificación en Cursor

**Criterio real:** MCP funciona cuando en **Settings → Tools & MCPs** aparecen tools bajo `stitch` (`list_projects`, `get_screen`, …). Punto verde solo = conectado al endpoint, **no** suficiente.

1. Copiar `mcp.json.proxy.example` → `.cursor/mcp.json`; sustituir placeholder por key **rotada**.
2. `npx @_davideast/stitch-mcp doctor` → healthy.
3. Reiniciar Cursor / toggle OFF→ON en `stitch`.
4. **Settings → Tools & MCPs:** deben listarse tools (no "No tools, prompts, or resources").
5. Chat Agent: invocar `list_projects` con `filter: "view=owned"` → JSON con proyectos reales.
6. Si OK → skill upstream (`design-md`, `stitch::generate-design`, etc.).

Acciones si sigue en 0 tools: Output → MCP (logs), probar OAuth/proxy ADC en [MCP setup](https://stitch.withgoogle.com/docs/mcp/setup/?pli=1).

### Checklist genérico (otros agentes)

1. Reiniciar agente / MCP tras cambiar config.
2. `list_tools` → prefijo `stitch:` o `mcp_stitch:` visible.
3. Llamar `[prefix]:list_projects` con `filter: "view=owned"` — debe devolver proyectos, no error auth.
4. Si OK → invocar skill upstream concreta (`design-md`, `stitch::generate-design`, etc.).

### Fallback si API key remota falla o Cursor muestra 0 tools

1. Migrar a **proxy stdio** `@_davideast/stitch-mcp` (primera opción en Cursor) — ver sección anterior.
2. Revisar [MCP setup](https://stitch.withgoogle.com/docs/mcp/setup/?pli=1) — ruta OAuth / Application Default Credentials.
3. Alternativa: `@keeponfirst/kof-stitch-mcp` con `gcloud auth application-default login`.
4. **STOP** — no inventar pantallas Stitch sin MCP funcional (tools visibles + `list_projects` OK).

## DESIGN.md (formato semántico)

- Overview oficial: [design-md/overview](https://stitch.withgoogle.com/docs/design-md/overview/?pli=1)
- `DESIGN.md` = “source of truth” semántico para prompts Stitch (atmósfera, paleta, geometría, tipografía).

| Origen | Skill upstream (CLI) | Carpeta local típica (producto) |
|--------|----------------------|----------------------------------|
| Proyecto Stitch existente | `design-md` | `.agents/skills/design-md/` |
| Código frontend (React, Vue, CSS…) | `stitch::extract-design-md` | `.agents/skills/stitch-extract-design-md/` |
| Estándares premium anti-genérico | `taste-design` (opcional) | — |

Cadena loop: `design-md` o extract → `stitch-loop` con `next-prompt.md`.

## SDK vs MCP

- Tutorial SDK: [sdk/tutorial](https://stitch.withgoogle.com/docs/sdk/tutorial/?pli=1) — REST/programático además de MCP.
- **MCP:** interacción agente ↔ Stitch (`list_projects`, `get_screen`, generación).
- **SDK/scripts:** uploads grandes, base64, batch — p.ej. `upload_to_stitch.py` en skill `stitch::upload-to-stitch` cuando MCP trunca payloads.

Usar script upstream cuando la skill lo indique; no duplicar lógica en JARVIS.

## Instalación (oficial)

```bash
# Listar skills disponibles
npx skills add google-labs-code/stitch-skills --list

# Una skill (global → ~/.cursor/skills/) — nombres CLI reales con --list
npx skills add google-labs-code/stitch-skills --skill "stitch::generate-design" --global
npx skills add google-labs-code/stitch-skills --skill design-md --global

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

| Skill CLI (`npx skills add --skill`) | Carpeta local típica | Uso |
|--------------------------------------|----------------------|-----|
| `stitch::generate-design` | `stitch-generate-design/` | Pantallas desde texto/imagen; edición y variantes vía MCP |
| `stitch::extract-design-md` | `stitch-extract-design-md/` | `DESIGN.md` desde código frontend |
| `stitch::extract-static-html` | `stitch-extract-static-html/` | HTML estático autocontenido desde app local |
| `stitch::code-to-design` | `stitch-code-to-design/` | Cadena: extract HTML → design system → upload Stitch |
| `stitch::manage-design-system` | `stitch-manage-design-system/` | Subir/aplicar `DESIGN.md` y temas en Stitch |
| `stitch::upload-to-stitch` | `stitch-upload-to-stitch/` | Subir assets locales (HTML, imágenes) al proyecto |

### Build (stitch-build plugin)

| Skill CLI | Carpeta local | Uso |
|-----------|---------------|-----|
| `react:components` | `react-components/` | Stitch → componentes React/Vite |
| `stitch::react-native` | — (opcional) | Stitch HTML → React Native |
| `remotion` | `remotion/` | Walkthrough video desde pantallas Stitch |
| `shadcn-ui` | `shadcn-ui/` | Integración shadcn/ui |

### Utilidades (stitch-utilities plugin)

| Skill CLI | Carpeta local | Uso |
|-----------|---------------|-----|
| `design-md` | `design-md/` | `DESIGN.md` desde proyecto Stitch existente |
| `enhance-prompt` | `enhance-prompt/` | Ideas vagas → prompts Stitch optimizados |
| `stitch-loop` | `stitch-loop/` | Loop autónomo baton (`next-prompt.md` → generar → siguiente) |
| `taste-design` | — (opcional) | `DESIGN.md` premium anti-genérico |

### Mapeo V1 → V2 (repos producto con copias antiguas)

| Copia local V1 (ej. CorralX Frontend) | Sustituto upstream V2 |
|---------------------------------------|------------------------|
| `stitch-design` (eliminado) | `stitch::generate-design` + `stitch::manage-design-system` |
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

1. `stitch-router` — verificar MCP ([setup](https://stitch.withgoogle.com/docs/mcp/setup/?pli=1))
2. `enhance-prompt` o `design-md` (contexto)
3. `stitch::generate-design` / `stitch-loop` (generación)
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
