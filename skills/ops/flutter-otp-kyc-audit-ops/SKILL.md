---
name: flutter-otp-kyc-audit-ops
description: >
  Auditoría especializada de onboarding seguro Flutter: registro, login, OTP,
  sesión, KYC e identidad. Multiagente (A/B/C) + juez con security override
  (un hallazgo de auth/OTP/KYC no se descarta por disenso) + loop de hasta 5 ciclos.
  Trigger: auditar onboarding OTP KYC, bypass KYC, Flutter auth/session/PII.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: ops
  auto_invoke:
    - "Auditoría Flutter OTP+KYC / onboarding seguro"
    - "Auditar onboarding OTP KYC"
    - "KYC bypass / OTP security audit Flutter"
  triggers: OTP, KYC, onboarding seguro, Flutter auth, session bypass, IDOR, PII, identity verification
  related-skills:
    - jarvis-core
    - fan-out-synthesize-ops
    - parallel-judge-ops
    - agent-loop-engineering
    - human-in-the-loop-ops
    - verification-before-completion
    - doubt-driven-development
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash, Task]
---

## JARVIS / Cursor (mandatory)

- **Precedencia:** `jarvis-core` > esta skill > `fan-out-synthesize-ops` > `parallel-judge-ops` (fase AUDIT/JUDGE). Overlay de producto (p. ej. CorralX) **precede** sobre defaults de stack.
- **No es** un auditor Flutter genérico de UI/perf: el foco es OTP + auth + sesión + KYC + PII. Agentes B/C siguen cubriendo Flutter/Dart, pero **seguridad manda**.
- **Workers = Task `generalPurpose`** readonly desde la sesión principal. **No** usar `security-review` (prompt fijo Bugbot). **No anidar Task.**
- **FIX de código:** un solo writer **después** de HITL. En repos con reglas “preguntar antes de editar”, no aplicar P0/P1 sin OK del usuario.
- Doc loop: `agent-loop-engineering` + `human-in-the-loop-ops`. Verify post-fix: `verification-before-completion`.

# Flutter OTP + KYC Security Audit

## Misión

Auditar (y solo entonces planificar correcciones) un flujo Flutter de registro / login / OTP / sesión / onboarding / KYC. El cliente **no** es autoridad de confianza.

Éxito: el flujo funciona, los estados son coherentes, el backend (o IdP) autoriza, no hay bypass demostrable, PII está protegida, reintentos son seguros, y los cambios —si los hay— están validados.

## Principio fundamental

El Flutter client es `UNTRUSTED`. Puede mostrar estados, iniciar operaciones y enviar datos. **No** determina OTP verificado, sesión autenticada, KYC aprobado ni acceso a recursos protegidos.

```text
UI protection ≠ authorization
local state ≠ server-side truth
successful API response ≠ secure workflow
2/3 agents agree ≠ vulnerability is false
code compiles ≠ system is secure
```

## Modelo de confianza

| Componente | Default | Notas |
|------------|---------|--------|
| Flutter client | `UNTRUSTED` | Incluye Provider/Bloc/GetX/Riverpod |
| Local storage | `UNTRUSTED` / user-controlled | SharedPreferences, Hive, SecureStorage, archivos |
| Backend / IdP | `TRUSTED` **solo si el código lo justifica** | No asumir |
| KYC provider | `EXTERNAL` | Validar firma, replay, idempotencia, mapping |

**No asumir** Firebase, Auth0, Persona, Veriff, Sumsub, Onfido, Jumio ni OTP propio hasta comprobarlo en el código.

## Prioridad

```text
AUTHENTICATION > AUTHORIZATION > OTP > SESSION > KYC > PII / IDENTITY
> DATA INTEGRITY > CRASHES > PERFORMANCE > ARCHITECTURE > CLEAN CODE
```

Un hallazgo de seguridad puede ser **P0 aunque solo un agente lo identifique**.

## Security override (prioridad sobre consenso)

Si **cualquier** agente reporta un hallazgo en:

`AUTH | AUTHORIZATION | OTP | SESSION | KYC | IDENTITY | PII | IDOR | TOKEN | SECRET | ACCESS_CONTROL | STATE_BYPASS`

el juez **debe investigarlo**. Prohibido descartar con “solo un agente lo vio” o “la navegación lo impide”.

Clasificar: `CONFIRMED | PROBABLE | SUSPICIOUS | FALSE POSITIVE`.

Si es demostrablemente explotable → `P0`.

Ejemplo: Agent A dice KYC bypass; Agent B dice que un `if (!kycApproved) showKycScreen()` lo bloquea. El juez **acepta** el finding de seguridad: eso es UI, no autorización.

Esta regla también aplica cuando esta skill se usa como Verify de `parallel-judge-ops`.

## References (cargar bajo demanda)

Resolver carpeta: `references/` junto a este `SKILL.md` si existe; si el sync de producto solo copió `SKILL.md`, leer desde `jarvis-skills-library/skills/ops/flutter-otp-kyc-audit-ops/references/`.

Estos archivos de `references/` no existen en la library; usar la estructura descrita inline en cada sección.

| Archivo | Cuándo |
|---------|--------|
| `finding-template.md` | Cada hallazgo de agente A/B/C |
| `checklists.md` | Fases OTP, auth, KYC, PII, estados imposibles |
| `agent-prompts.md` | Antes de lanzar Task A/B/C |
| `report-template.md` | Informe final |

## Loop

```text
DISCOVER → AUDIT (A∥B∥C) → CORRELATE → JUDGE (+ override)
  → PLAN (cambio mínimo) → HITL si FIX → FIX (1 writer)
  → FORMAT → ANALYZE → TEST → SECURITY TEST → REGRESSION → RE-AUDIT
```

`MAX_FULL_CYCLES = 5`. Tras 5 ciclos con P0/P1 residuales: `STATUS = BLOCKED` (qué, causa, intentos, archivos, tests, acción humana).

### Stop

Parar cuando: **no P0 security**, **no P0 functional**, **no P1 CONFIRMED**, **no regresiones**, analysis pasa, tests relevantes pasan.

P2/P3 pueden quedar pendientes. Orden de fix: P0 SECURITY → P0 FUNCTIONAL → P1 SECURITY → P1 FUNCTIONAL → P2 → P3.

## Fase 0 — DISCOVER (antes de editar)

Inspeccionar (no asumir): `pubspec.yaml`, `analysis_options.yaml`, `lib/`, `test/`, `integration_test/`, `android/`, `ios/`, `.env*`, `firebase*`, clientes API, storage, navegación, guards.

Identificar stack real de Auth / OTP / KYC.

Mapa:

```text
USER → FLUTTER → AUTH/OTP → BACKEND → KYC SERVICE → BACKEND → USER STATE → AUTHORIZED APP
```

Anotar endpoints, tokens, IDs (`userId`, `kycId`, `documentId`, `verificationId`, `sessionId`), callbacks/webhooks, persistencia, providers, navigation guards.

**Máquina de estados:** reconstruirla **desde el código** (no desde el ejemplo). Incluir fallos: OTP_EXPIRED/FAILED/LOCKED, KYC_REJECTED/EXPIRED/RETRY, SESSION_EXPIRED, USER_BLOCKED.

Buscar transiciones imposibles (OTP no verificado → KYC approved; flag local → ACCESS_GRANTED). Usar el checklist/estructura de informe descritos en esta skill.

## Fase 1–3 — AUDIT (fan-out)

Lanzar **en un mismo mensaje** tres Task readonly, contextos aislados, prompts adversarial. Plantillas: `agent-prompts.md`.

| Agente | Foco | `model` |
|--------|------|---------|
| A Security / auth / KYC | OTP, sesión, KYC, IDOR, PII, secrets, bypass | `cursor-grok-4.6-xhigh` |
| B Flutter / state / perf | lifecycle, async races, navigation, persistence, UX | `cursor-grok-4.5-high` |
| C Dart / architecture | SOLID, duplicación, testing, error handling | `composer-2.5` |

`subagent_type: generalPurpose`. Cada finding usa `finding-template.md`.

Agent A tiene autoridad para **elevar** posibles P0; no para cerrar el juicio.

## Juez (sesión principal)

Entradas: código + (si existen) logs + API + state machine + A + B + C + tests.

No aceptar consenso a ciegas. Buscar contradicciones. Aplicar **security override**.

Severidad:

- **P0** — bypass OTP/KYC/auth/authz, IDOR confirmado, PII grave, secretos, crash de flujo crítico.
- **P1** — race OTP, sesión incorrecta, estado KYC inconsistente, retry inseguro, leak, fallo de integración.
- **P2** — arquitectura, tests, deuda, perf moderada.
- **P3** — naming, micro-optimizaciones.

## PLAN + FIX (cambio mínimo)

Antes de editar: leer archivo completo, callers, API, tests, estados, impacto.

Aplicar **el menor cambio** que cierre la causa raíz. No refactor masivo mientras se corrige un P0.

Cada paso de ejecución documenta: STEP, FINDINGS, ROOT CAUSE, FILES, CHANGE, SECURITY IMPACT, REGRESSION RISK, TEST, VALIDATION, ROLLBACK.

Tras cada fix: `dart format` / `flutter analyze` / `flutter test` (y backend si el overlay lo exige). Reintentar el **mismo bypass**. Una vulnerabilidad no está cerrada solo porque cambió el código.

## Honestidad (evidencia)

Nunca afirmar:

- `"tested successfully"` si no se ejecutó el comando.
- `"API is secure"` si no se inspeccionó el backend/API.
- `"KYC cannot be bypassed"` si solo se inspeccionó Flutter.

Usar: `VERIFIED | NOT_VERIFIED | INFERRED | BLOCKED`.

No registrar ni reproducir secretos/PII completos.

## Informe final

Usar el checklist/estructura de informe descritos en esta skill. Resultado: `PASS | PASS_WITH_WARNINGS | BLOCKED | FAILED`.

Resumen por dominio (OTP, AUTH, SESSION, KYC, AUTHORIZATION, PII, STATE MACHINE): `PASS | WARN | FAIL | NOT_VERIFIED`.

## Principios absolutos

```text
SECURITY > STYLE
EVIDENCE > OPINION
SERVER TRUTH > CLIENT STATE
ROOT CAUSE > SYMPTOM
AUTHORIZATION > UI
TESTED FIX > ASSUMED FIX
MINIMAL CHANGE > MASS REFACTOR
REGRESSION PREVENTION > SPEED
```

---

## Overlay CorralX Backend

Producto: Laravel API marketplace ganadero. **Este overlay precede** sobre defaults genéricos (Persona/Veriff/OTP generado en API propia).

### HITL (no negociable aquí)

DISCOVER / AUDIT / JUDGE pueden ser readonly autónomos. **FIX de código exige OK del usuario**. No auto-implementar P0.

### Stack real (no inventar)

| Capa | Hecho en código |
|------|-----------------|
| Auth | Sanctum. Teléfono: Firebase Phone Auth → `POST /api/auth/phone/verify` body `{ phone, id_token }` (kreait `verifyIdToken`). Throttle `10,1`. |
| OTP | SMS lo emite **Firebase**, no Laravel. No hay YCloud/WhatsApp OTP. |
| KYC | API propia bajo `auth:sanctum` + `throttle:30,1`. Gemini extracción opt-in (`documents.gemini_extraction.enabled` / extract-document-data). |
| Storage KYC | Disco `local` privado. JSON no expone URLs públicas de storage. |
| Liveness | `POST /api/kyc/liveness/challenge`, `/steps`, `/upload-liveness-selfies`. Flag `KYC_LIVENESS_CHALLENGE_REQUIRED` (off = bypass legacy). **No** es PAD certificado. |
| Proveedor KYC externo | Ninguno. No auditar webhooks Persona/Veriff; sí idempotencia, IDOR y mapping usuario↔challenge. |

### Endpoints a auditar (IDOR / authz)

Usuario autenticado (`routes/api.php` prefix `kyc`):

- `GET /api/kyc/status`
- `POST /api/kyc/start` (consent versionado)
- `POST /api/kyc/upload-document|upload-selfie|upload-selfie-with-doc`
- `POST /api/kyc/liveness/challenge` (throttle 10,1)
- `POST /api/kyc/liveness/steps` (throttle 20,1)
- `POST /api/kyc/upload-liveness-selfies`
- `POST /api/kyc/extract-document-data` (throttle 20,1)

Admin (`/api/kyc/{profile}` approve/reject): verificar que **no** es usable por un buyer con otro `profile` id (IDOR).

Documentos legales (`GET /api/documents/{id}/file`) son flujo **aparte** de KYC; la selfie KYC **no** se copia a `profile_images` público.

### Qué debe demostrar el juez

- El cliente no puede marcar KYC `verified` vía flag local.
- Challenge/liveness IDs pertenecen al usuario autenticado.
- `id_token` de Firebase no se acepta sin Sanctum + verificación kreait.
- Rate limit / lockout en phone verify y liveness.
- PII (CI, selfie) no en logs ni URLs públicas.

Skills de dominio **después** de esta: `corralx-kyc-system`, `corralx-api-patterns`. Verify: `php artisan test --filter=Kyc` / `PhoneVerification`.
