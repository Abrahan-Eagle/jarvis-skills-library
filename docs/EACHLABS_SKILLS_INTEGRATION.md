# eachlabs/skills (each::sense) — integración JARVIS

[eachlabs/skills](https://github.com/eachlabs/skills) (MIT) — 102 skills para agentes (Claude Code, Cursor, Copilot) que envuelven la API **each::sense** de each::labs: imagen, video, audio, música y diseño gráfico generativo. Todas requieren `EACHLABS_API_KEY` (servicio remoto, saldo de pago).

Skills JARVIS: `eachlabs-router` (decisión) + `brochure-design-generation` (sync curado upstream, overlay tríptico).

## Fuentes oficiales

- Repo: [github.com/eachlabs/skills](https://github.com/eachlabs/skills)
- Pin JARVIS: commit **`dbd25b764305f84e5b9df3e095d5e444e6ee94e5`** (2026-04-21; upstream sin tags) — `EACHLABS_SKILLS_REF` en `scripts/sync-eachlabs-brochure-design-generation.sh`
- Licencia: MIT (declarada en `package.json`; sin archivo `LICENSE` en raíz al pin)
- API: `POST https://eachsense-agent.core.eachlabs.run/v1/chat/completions` (`model: eachsense/beta`, SSE, `mode: max|eco`, `session_id`). Referencia de eventos: `skills/non-code/brochure-design-generation/references/SSE-EVENTS.md`
- Cuenta / saldo: [eachlabs.ai](https://eachlabs.ai)

## vs JARVIS canónico

| Necesidad | Usar |
|-----------|------|
| Workflow módulo / precedencia | **`jarvis-core`** (primero) |
| **Tríptico, díptico, folleto, brochure impreso con IA** | **`eachlabs-router` → `brochure-design-generation`** |
| Tríptico sin API key | `open-design-router` → `open-design` (`magazine-poster`) o HTML print manual |
| Carrusel RRSS, deck, email HTML, prototipo | `open-design-router` → `open-design` |
| Landing con video hero IA | `ai-media-landing-ops` |
| Pantalla / componente en app | `ui-router` → `{producto}-ui-design` |
| Tokens / paleta para código | `ui-ux-pro-max` |
| Flyer, poster, infografía, menú (pack) | Pack externo eachlabs tras `skill-security-auditor` |
| Auditar skill eachlabs antes de instalar | `claude-skills-router` → `skill-security-auditor` |

## Arquitectura

```
Cursor (~/.cursor/skills vía install.sh)
  ├─ eachlabs-router               (decisión, detección key, gate de gasto)
  └─ brochure-design-generation    (SKILL.md upstream + overlay JARVIS 6 paneles)
        └─ curl → eachsense-agent.core.eachlabs.run  (X-API-Key: $EACHLABS_API_KEY)
Fallback sin key: open-design-router → open-design (daemon :17456) | HTML/CSS print
Pack externo opcional: npx skills add eachlabs/skills@<skill>   (solo tras auditoría PASS)
```

## Instalación

```bash
cd /var/www/html/proyectos/AIPP/jarvis-skills-library
bash scripts/install.sh --all
export EACHLABS_API_KEY="..."   # solo en entorno; nunca en repo
```

### Sync upstream (mantenedores)

```bash
bash scripts/sync-eachlabs-brochure-design-generation.sh   # audita --strict antes de copiar
bash scripts/smoke-eachlabs-brochure-design-generation.sh
bash scripts/validate-all.sh
```

El sync aborta si el upstream no da **PASS** en `skill-security-auditor --strict`, falla `validate-skills.sh --check-net-exec` o contiene una API key literal.

### Pack completo externo (opcional)

**No** copiar las 102 skills a `jarvis-skills-library`.

- Cursor / Claude Code: `npx skills add eachlabs/skills@<skill> -g` — solo tras `skill-security-auditor` PASS y OK del usuario.
- Nunca instalar `nsfw-*`.

## Uso en Cursor

### Detección

```bash
test -n "${EACHLABS_API_KEY:-}" && echo EACHLABS_KEY_SET || echo EACHLABS_KEY_MISSING
```

### Flujo tríptico (ejemplo Zonix Pharma)

1. `jarvis-core` → `> Roles: diseño gráfico + marca`; brief: formato, público, secciones por panel, CTA.
2. Cargar `zonix-brand-ops` (paleta `#1E2A5A / #0F4C5C / #56C7B8`, Plus Jakarta Sans, tono tech-pharma; sin claims Eats) y `zonix-regulatory-ve` para copy salud.
3. Confirmar con el usuario modo `eco` (borrador) y 1 iteración → OK gasto.
4. `brochure-design-generation` → plantilla 6 paneles del overlay:

```bash
curl -X POST https://eachsense-agent.core.eachlabs.run/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $EACHLABS_API_KEY" \
  -H "Accept: text/event-stream" \
  -d '{
    "messages": [{"role": "user", "content": "Create a tri-fold brochure (11x8.5in landscape, 6 panels, roll fold) for Zonix Pharma — marketplace farmacéutico para farmacias de Valencia, Venezuela. Brand: navy #1E2A5A, teal #0F4C5C, mint #56C7B8, light #F5F7FA; Plus Jakarta Sans; tono tech-pharma sobrio. Audience: dueños de farmacia. Panel 1: logo Z + PHARMA, título, imagen gancho. Panel 2: por qué unirse, 3 beneficios. Panel 3: cómo funciona (OTC + Rx con farmacéutico colegiado). Panel 4: panel de farmacia, pedidos, entrega. Panel 5: testimonio placeholder + sello MPPS placeholder. Panel 6: CTA, WhatsApp, QR placeholder, aviso legal. Print specs: 3mm bleed, 5mm safe zone, body 9-12pt, 300 DPI."}],
    "model": "eachsense/beta",
    "stream": true,
    "mode": "eco",
    "session_id": "zonix-triptico-farmacias-001"
  }'
```

5. Guardar en `./out/eachlabs/zonix-triptico-farmacias/`; checklist del overlay (secuencia, CTA único, ≥ 9 pt, nada sobre pliegues, marca).
6. `verification-before-completion`; antes de imprenta → `publish-safety`.

### Cuándo **no** usar eachlabs

- UI del producto en `lib/` Flutter o Blade → `ui-router`.
- Carrusel / deck / email → Open Design (sin coste, local).
- Cifras o claims de inversor en el folleto → solo desde `zonix-startup-context` / pack Lanzamiento.
- Sin `EACHLABS_API_KEY` → fallback; no simular la generación.

## Supply-chain

Antes de copiar o instalar cualquier `SKILL.md` del pack:

1. `python3 skills/ops/skill-security-auditor/scripts/skill_security_auditor.py https://github.com/eachlabs/skills --skill <skill> --strict`
2. `bash scripts/validate-skills.sh --check-net-exec <SKILL.md>`
3. Verificar que no haya `X-API-Key` literal (solo `$EACHLABS_API_KEY`)
4. Revisión humana si WARN

Resultado al pin para `brochure-design-generation`: **PASS** strict (0 critical, 0 high; 0 scripts, 2 markdown), net-exec 0.

## Forense breve del pack (102 skills al pin)

| Grupo | Skills (ejemplos) | Disposición JARVIS |
|-------|-------------------|--------------------|
| **Curada** | `brochure-design-generation` | Sync a library (`skills/non-code/`) con overlay tríptico |
| Diseño impreso / marketing | `flyer-design-generation`, `poster-design-generation`, `infographic-generation`, `menu-design-generation`, `business-card-generation`, `certificate-generation`, `invoice-generation`, `resume-design-generation`, `packaging-design-generation`, `presentation-generation`, `qr-code-generation` | Pack externo tras auditoría; router → `eachlabs-router` |
| RRSS / ads | `social-carousel-generation`, `instagram-content-generation`, `linkedin-content-generation`, `pinterest-pin-generation`, `meta-ad-creative-generation`, `google-ad-creative-generation`, `email-banner-generation`, `app-store-screenshot-generation` | Preferir `open-design-router` (local, sin coste); eachlabs solo si se exige render IA |
| Imagen core | `eachlabs-image-generation`, `eachlabs-image-edit`, `image-upscaling`, `background-removal`, `object-removal`, `image-outpainting`, `style-transfer`, `logo-generation`, `product-photo-generation` | Pack externo; `ai-media-landing-ops` para assets de landing |
| Video / audio | `eachlabs-video-generation`, `image-to-video`, `bytedance-seedance-2-0`, `subtitle-generation`, `eachlabs-music`, `eachlabs-voice-audio`, `audio-visualization` | Pack externo; hero video → `ai-media-landing-ops` (Veo/Kling ya cubiertos) |
| Persona / avatar | `ai-avatar-generation`, `ai-headshot-generation`, `ai-influencer-generation`, `age-transformation`, `face-morphing`, `hair-color-changer`, `eye-color-changer`, `pet-portrait-generation` | Sin caso JARVIS actual; pack externo bajo demanda |
| Excluidas | `nsfw-content-generation`, `nsfw-image-generation`, `nsfw-video-generation`, `eachlabs-face-swap` (deepfake) | **No instalar** en ningún entorno JARVIS |
| Infra del pack | `each-sense` (doc API), `eachlabs-workflows`, `bin/cli.js` (npm) | Referencia; no sincronizar |

## Cruces

- Fábrica local sin coste → [OPEN_DESIGN_INTEGRATION.md](OPEN_DESIGN_INTEGRATION.md)
- Landing con media IA → skill `ai-media-landing-ops`
- Auditoría pre-install → [CLAUDE_SKILLS_REZVANI_INTEGRATION.md](CLAUDE_SKILLS_REZVANI_INTEGRATION.md)
- Registry SD-X → [../catalog/SDX_TOOLKITS.md](../catalog/SDX_TOOLKITS.md) (id `eachlabs-skills`)
