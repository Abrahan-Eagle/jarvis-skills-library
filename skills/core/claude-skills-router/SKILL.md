---
name: claude-skills-router
description: >
  Orquesta pack alirezarezvani/claude-skills vs canónico JARVIS y skill-security-auditor.
  Trigger: auditar skill antes de instalar, pack Rezvani, ¿es segura esta skill?
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: core
  auto_invoke:
    - "Auditar skill antes de instalar"
    - "Pack Rezvani claude-skills"
    - "¿Es segura esta skill?"
    - "skill security audit pre-install"
  triggers: claude-skills, rezvani, skill-security-auditor, audit skill, pre-install
  related-skills:
    - jarvis-core
    - skill-security-auditor
    - security
    - agent-skills-router
    - skill-loop-router
    - human-in-the-loop-ops
    - jarvis-skills-maintainer
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash, Task]
---

# Claude Skills Router (Alireza Rezvani)

Router para [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) (MIT, 345+ skills): **sin** sustituir `jarvis-core`, `speckit-*` ni vendorizar el pack completo.

Guía: [docs/CLAUDE_SKILLS_REZVANI_INTEGRATION.md](../../docs/CLAUDE_SKILLS_REZVANI_INTEGRATION.md).

## IRON LAW

1. **`jarvis-core` precede** — este router no inicia módulos ni commits sin el flujo JARVIS.
2. **No sustituir** `session-learner-ops`, `speckit-implement` (sin OK usuario), ni `git-guardrails-ops`.
3. **Solo una skill curada** en la library: `skill-security-auditor`. Las otras 344 → canónico JARVIS, dominio producto o pack externo opcional.
4. **Supply-chain:** antes de copiar cualquier skill del pack, `skill-security-auditor` + `validate-skills.sh` en origen.

## Detección runtime

```bash
test -f "${HOME}/.cursor/skills/skill-security-auditor/SKILL.md" && echo SKILL_SECURITY_AUDITOR_INSTALLED
test -f skills/ops/skill-security-auditor/SKILL.md && echo SKILL_SECURITY_AUDITOR_LIBRARY
test -f "${HOME}/.cursor/skills/claude-skills-router/SKILL.md" && echo CLAUDE_SKILLS_ROUTER_INSTALLED
```

## Árbol de decisión

| Pedido | Ruta | No usar |
|--------|------|---------|
| Iniciar módulo / planificar | `jarvis-core` → `sdd-router` / `kitty-router` | skills product del pack sin auditar |
| Spec / PRD | `sdd-router` → `speckit-*` | `code-to-prd` Rezvani |
| Implementar / bugfix | `test-driven-development` + dominio `{producto}-*` | `karpathy-coder` genérico |
| Test fallido / debug | `systematic-debugging` | skills debug del pack |
| Review pre-merge | `code-review-playbook` | `pr-review-expert` Rezvani |
| Seguridad app / OWASP | `security` (+ `cyber-neo-router` si auditoría profunda) | `security-auditor` pack sin contexto JARVIS |
| **Auditar skill antes de instalar** | **`skill-security-auditor`** (+ `validate-skills.sh`) | instalar sin PASS |
| UI en código | `ui-router` → dominio UI | `marketing-skill` pods |
| Loop autónomo impl→review | `skill-loop-router` + `human-in-the-loop-ops` | `autoresearch-agent` (`/ar:loop`, Claude Code) |
| Revisión adversarial in-flight | `agent-skills-router` → `doubt-driven-development` | `grill-me` Rezvani |
| Traspaso sesión | `handoff` JARVIS | `handoff` Matt Pocock del pack |
| Marketing / compliance / C-level | Dominio repo (`clawvis-*`, `zonix-*`) | sync masivo a global library |
| Skill Rezvani sin equivalente | Pack externo tras auditoría | copiar 345 skills a library |

**vs `agent-skills-router`:** Addy = ciclo DEFINE→SHIP + doubt in-flight; Rezvani = megapack multi-dominio; **ambos** exigen supply-chain antes de instalar skills de terceros.

**vs `security`:** `security` = hardening aplicación/API; `skill-security-auditor` = meta-auditoría de **SKILL.md y scripts** de agent skills.

## Flujo pre-install (Cursor)

1. Usuario pide instalar skill externa o el mantenedor sincroniza upstream.
2. Cargar skill `skill-security-auditor`.
3. Ejecutar CLI:

```bash
python3 skills/ops/skill-security-auditor/scripts/skill_security_auditor.py /path/to/skill/ --strict
bash scripts/validate-skills.sh --check-net-exec /path/to/skill/SKILL.md
```

4. **PASS** → proceder con sync/install; **WARN** → revisión humana; **FAIL** → no instalar.
5. Loops autónomos del pack (`autoresearch-agent`) → no en Cursor sin adaptación; usar `skill-loop` + gates `human-in-the-loop-ops`.

## Pack externo (opcional)

- Claude Code: `/plugin marketplace add alirezarezvani/claude-skills`
- Cursor: preferir skills globales JARVIS (`install.sh --all`); skill puntual del clone solo tras auditoría.

## Limitaciones

- Sin 345 skills en `~/.cursor/skills` desde esta library.
- `autoresearch-agent` usa slash `/ar:*` — no portable a Cursor sin plugin Claude Code.
- `scripts/convert.sh` masivo a `.mdc` → repos producto bajo demanda, no catálogo global.
