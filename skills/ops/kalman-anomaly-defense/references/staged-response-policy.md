# Staged response policy

Política escalonada: el **filtro** emite confianza; el **agente** ejecuta acción. Bahçeci (Medium 2025): notify → soft → hard.

## Tiers

| Tier | Confianza | Acciones típicas | Approval JARVIS |
|------|-----------|------------------|-----------------|
| `low` | residual moderado, corta duración | structured log, dashboard tick, email/Slack opcional | no |
| `medium` | residual alto o persistencia media | rate limit, throttle API, challenge, captcha | OK usuario en prod recomendado |
| `high` | residual muy alto + sostenido | block IP, WAF deny, firewall rule | **`approval-gate` obligatorio** |

## Reducir falsos positivos

- Ventana mínima (ej. 3–5 muestras consecutivas en tier medium+).
- Allowlist: IPs internas, health checks, monitores.
- Cooldown tras acción medium (no escalar a high en 60s).
- Correlación release/deploy (CI webhook → suprimir alertas 10 min).
- Human-in-the-loop para primera activación de tier high en prod.

## Laravel (CorralX / Zonix)

```php
// RouteServiceProvider / bootstrap — ejemplo conceptual
RateLimiter::for('api', function (Request $request) {
    return Limit::perMinute(60)->by($request->user()?->id ?: $request->ip());
});

// Middleware throttle en routes/api.php
Route::middleware(['throttle:api'])->group(function () { ... });
```

Dynamic throttle: middleware custom que lee score de servicio interno (no hardcode block sin policy).

## nginx

```nginx
# limit_req_zone + limit_req — documentar en runbook, no aplicar sin OK
limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
```

## Edge (Cloudflare, etc.)

Documentar regla propuesta en markdown; aplicar vía panel/API solo con OK usuario.

## Plantilla

Copiar [assets/response-policy.template.yaml](../assets/response-policy.template.yaml) al repo producto (`docs/security/` o `config/`).
