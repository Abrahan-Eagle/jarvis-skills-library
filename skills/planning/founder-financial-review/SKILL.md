---
name: founder-financial-review
description: >
  Revisa un modelo o unas cifras contra 46 criterios. No construye el Excel.
  Trigger: revisar modelo financiero, runway, unit economics, burn.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: planning
  upstream: lool-ventures/founder-skills@70d216778b67b6956cadd79033c219e6bc8b154f
  auto_invoke:
    - "Revisar modelo financiero"
    - "Runway y unit economics del pitch"
  triggers: financial model review, runway, unit economics, burn, EBITDA
  related-skills:
    - founder-skills-router
    - founder-deck-review
    - founder-cap-table-checklist
    - human-in-the-loop-ops
allowed-tools: [Read, Glob, Grep]
---

# Revisión financiera (rúbrica)

Reescritura JARVIS. No abre Excel con scripts upstream ni inventa proyecciones. En Zonix el modelo canónico es `zonix-financial-model`; aquí solo se revisa lo que el usuario trae.

Forense: [docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md](../../../docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md).

Saltar el ítem que no aplica a la etapa, al país o al tipo de negocio.

## 1. Estructura (9)

Supuestos en un sitio; se puede navegar; reales separados de proyección; escenarios base/alto/bajo; cuadra con el deck; tiene fecha; granularidad mensual si la etapa lo pide; cuadra por dentro (ingresos, gasto, balance); se lee en cinco minutos.

## 2. Ingresos y unidad (10)

Ingreso de abajo arriba; churn explícito; precio explícito; expansión si aplica; margen acorde al tipo; CAC cargado; payback; LTV/CAC si ya hay historia; la capacidad de ventas limita el ingreso; las tasas de conversión tienen base.

## 3. Caja (13)

Diez ítems generales o condicionales, y tres solo de Israel.

Generales: la nómina mueve el gasto; hay cargas sociales (en el pin el “pasa” es 25–35 % EE.UU. y 30–45 % UE; **no** usar esas bandas como barra en Venezuela: si el país es VE, marcar aviso o no aplica y no inventar el porcentaje); capital de trabajo si importa; runway calculado; runway suficiente para los hitos; fecha de caja cero; costes en escalón; el gasto crece con el ingreso.

Condicionales, no “siempre Israel”: tipo de cambio solo si hay más de una moneda; caja por entidad si hay varias entidades **o** si opera en Israel.

Solo Israel, no aplica en Venezuela salvo que el usuario diga que opera allá: cargas estatutarias locales, grants con royalty, timing de IVA.

## 4. Métricas (3)

KPI visible; burn multiple; comparación con un benchmark citado, no inventado.

Si el modelo es SaaS, mirar además (sin copiar umbrales como ley de Pharma ni de Venezuela): crecimiento, burn, magic number, payback, margen, NRR, LTV/CAC. En Serie A también GRR, Rule of 40 y ARR por persona. Si el usuario no trae la fuente del umbral, el ítem es “sin fuente”, no un número inventado.

## 5. Puente a la ronda (3)

Dinero, meses, hitos, siguiente ronda; hitos nombrados; dilución apuntada, no calculada aquí (`founder-cap-table-checklist`).

## 6. Sector (6, solo el que toque)

Marketplace de dos lados; coste de inferencia si hay IA; hitos y capex si hay hardware; margen a escala si el precio es por uso; curvas de retención si es consumo; ingreso diferido si existe.

## 7. Vista general (2)

Un auditor entiende el archivo rápido; si hay varios países, CAC y payback por país.

## Escenarios

Pedir base, crecimiento lento y crisis. No elegir la crisis como caso único ni el alto como promesa.

## Salida

Ítems en pasa, falla, aviso o no aplica, y los tres arreglos de más palanca. No es dictamen de contador.
