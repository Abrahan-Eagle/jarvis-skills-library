# Engram — integración JARVIS

[Engram](https://github.com/Gentleman-Programming/engram) (MIT): memoria persistente para agentes — binario Go, SQLite+FTS5, MCP stdio, CLI, TUI.

Skills JARVIS: `engram-router` + `engram-memory-protocol`.

Ecosistema Gentleman: [GENTLEMAN_ECOSYSTEM_INTEGRATION.md](GENTLEMAN_ECOSYSTEM_INTEGRATION.md).

## vs memoria JARVIS file-based

| Capa | Herramienta | Cuándo |
|------|-------------|--------|
| Producto | `docs/active_context.md`, `handoff` | SSOT por repo, walkthrough |
| Sesión | `context-updater`, `session-learner-ops` | Cierre módulo JARVIS |
| Aprendizajes | `learning-loop-router` | scan/wrap-up |
| **Cross-session MCP** | **Engram** `mem_*` | Decisiones, bugfixes, patrones searchables; loops largos / compactación |

Engram **complementa** — no reemplaza — la capa file-based.

## Instalación (opt-in)

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install-engram-runtime.sh
```

El script:

1. Instala `engram` (brew tap `gentleman-programming/tap/engram` si falta).
2. Ejecuta `engram setup cursor` (MCP en config Cursor).
3. Verifica con `engram version`.

Tras install: **Reload Window** en Cursor.

Alternativas upstream: [docs/INSTALLATION.md](https://github.com/Gentleman-Programming/engram/blob/main/docs/INSTALLATION.md).

## MCP tools (referencia)

| Categoría | Tools |
|-----------|-------|
| Save & update | `mem_save`, `mem_update`, `mem_delete`, `mem_suggest_topic_key` |
| Search | `mem_search`, `mem_context`, `mem_timeline`, `mem_get_observation` |
| Session | `mem_session_start`, `mem_session_end`, `mem_session_summary` |
| Conflict | `mem_judge`, `mem_compare` |
| Util | `mem_stats`, `mem_doctor`, … |

Ver [DOCS.md](https://github.com/Gentleman-Programming/engram/blob/main/DOCS.md) upstream.

## Flujo JARVIS recomendado

```
engram-router (¿MCP disponible?)
  → engram-memory-protocol (durante trabajo)
  → session-learner-ops + context-updater (cierre file-based)
  → mem_session_summary (cierre MCP)
```

## Qué NO sync desde repo engram

Skills de dominio del producto Engram (Go/TUI): `server-api`, `dashboard-htmx`, `plugin-thin`, `gentleman-bubbletea`, etc. — mantener en upstream.

## Watchlist

- Engram Cloud (opt-in replication)
- `mem_judge` semantic scan (beta)
- Pin de versión: documentar en `skills-lock.json` cuando se fije release JARVIS

## Enlaces

- Repo: https://github.com/Gentleman-Programming/engram
- gentle-ai component: [components.md](https://github.com/Gentleman-Programming/gentle-ai/blob/main/docs/components.md)
