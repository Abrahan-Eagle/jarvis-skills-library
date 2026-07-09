# NotebookLM — integración JARVIS

[NotebookLM CLI & MCP](https://github.com/jacob-bd/notebooklm-mcp-cli) (MIT): acceso programático a Google NotebookLM vía CLI (`nlm`), MCP server (stdio) y AI agent skills.

Skill JARVIS: `notebooklm-router`.

## vs otras capas JARVIS

| Capa | Herramienta | Cuándo |
|------|-------------|--------|
| Pocos PDFs que caben en contexto | Subir al agente | Simple, sin runtime |
| Corpus grande/duradero/reusado | NotebookLM (RAG con citas) | Ahorra contexto, citas |
| Decisiones/bugfixes cross-session | Engram `mem_*` | Búsqueda semántica persistente |
| Especificaciones de producto | Spec Kit `.specify/` | Canon SDD |
| Walkthrough sesión | `active_context.md` | SSOT por repo |

NotebookLM **complementa** — no reemplaza — Engram ni Spec Kit.

## Instalación (opt-in)

```bash
bash scripts/install-notebooklm-runtime.sh
```

El script:

1. `uv tool install notebooklm-mcp-cli` (o `uv tool upgrade` si existe).
2. **Merge idempotente** en `~/.config/cursor/mcp.json` y `~/.cursor/mcp.json`: añade/actualiza solo `notebooklm-mcp`, **preserva** `stitch` y cualquier otro MCP existente.
3. `nlm doctor` verifica binario + auth + MCP config.

Tras install: **Reload Window** en Cursor y `nlm login` si no hay sesión.

### No usar `nlm setup add cursor` a ciegas

El comando upstream **`nlm setup add cursor` reemplaza** el archivo MCP de Cursor con una sola entrada `notebooklm-mcp`. Si ya tienes **Stitch**, Engram u otros MCPs globales, **no lo ejecutes** — usar `bash scripts/install-notebooklm-runtime.sh` (merge) o fusionar manualmente.

Coexistencia con Stitch: ver [STITCH_UPSTREAM.md](STITCH_UPSTREAM.md) y plantilla `CorralX-Frontend/.cursor/mcp.json.proxy.example`.

## Auth (una vez)

```bash
nlm login                 # auto: abre Chrome, log in Google, extrae cookies
nlm login --check         # estado de la sesión
nlm login --profile work  # cuenta dedicada (recomendado: secundaria)
```

Cookies en `~/.notebooklm-mcp-cli`. **Usar cuenta Google secundaria** — no la principal/corporativa si tiene datos sensibles.

## MCP tools (referencia)

| Categoría | Tools |
|-----------|-------|
| Notebooks | `notebook_list`, `notebook_create`, `notebook_query`, `notebook_share_*` |
| Sources | `source_add`, `source_sync_drive` |
| Studio | `studio_create`, `studio_revise`, `download_artifact` |
| Research | `research_start` |
| Batch/Pipeline | `batch`, `pipeline`, `cross_notebook_query` |
| Tags | `tag` add/list/select |
| Setup | `nlm setup add/remove/list` |
| Skills AI | `nlm skill install/update` |
| Diagnóstico | `nlm doctor` |

Ver [MCP_GUIDE.md upstream](https://github.com/jacob-bd/notebooklm-mcp-cli/blob/main/docs/MCP_GUIDE.md).

## Flujo JARVIS recomendado

```
notebooklm-router (¿MCP disponible? ¿corpus grande?)
  → notebook_query con citas
  → desactivar MCP si no se usa (39 tools = contexto)
```

## Aviso de contexto

Este MCP expone **39 tools**. Desactivar en Settings → Tools & MCP cuando no se consulte NotebookLM para no consumir ventana de contexto del agente.

## Qué NO sync desde upstream

- Código de `notebooklm-mcp-cli` (Python) — dominio del upstream, no se vendoriza.
- Skills AI del propio `nlm skill install` — se instalan aparte si se quieren.

## Riesgos

- APIs internas de Google (no documentadas, pueden romper sin aviso).
- Cookies de Google en disco — usar cuenta secundaria.
- 39 tools MCP — gestionar contexto.

## Enlaces

- Repo: https://github.com/jacob-bd/notebooklm-mcp-cli
- PyPI: https://pypi.org/project/notebooklm-mcp-cli/
- MCP guide: https://github.com/jacob-bd/notebooklm-mcp-cli/blob/main/docs/MCP_GUIDE.md
