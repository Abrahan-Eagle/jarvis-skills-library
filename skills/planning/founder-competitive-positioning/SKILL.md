---
name: founder-competitive-positioning
description: >
  Mapa de rivales, ejes y seis fosos. Trigger: competencia, cómo ganamos,
  posicionamiento, moat.
license: UNLICENSED
metadata:
  author: JARVIS Global
  version: "1.0"
  scope: [global]
  category: planning
  upstream: lool-ventures/founder-skills@70d216778b67b6956cadd79033c219e6bc8b154f
  auto_invoke:
    - "Análisis de competencia del pitch"
    - "Cómo ganamos frente a rivales"
  triggers: competitive positioning, competencia, moat, estrategia para ganar
  related-skills:
    - founder-skills-router
    - founder-deck-review
    - scenario-analysis-ops
allowed-tools: [Read, Glob, Grep]
---

# Posicionamiento competitivo

Reescritura JARVIS. No abre la web ni carga gráficos de un CDN. Si el usuario pide buscar rivales, decirlo y esperar OK.

Forense: [docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md](../../../docs/LOOL_FOUNDER_SKILLS_FORENSE_JARVIS.md).

## Qué armar

Cinco a siete nombres en cuatro cajones: directo, adyacente, emergente, y “no hacer nada” (el status quo). Un eje que no halague a la startup. Seis fosos, cada uno fuerte, medio, débil, ausente o no aplica, y si mejora o empeora.

Fosos: red de usuarios, datos, coste de cambiar, barrera regulatoria, estructura de coste, marca.

## 25 checks

Cobertura (5): al menos cinco; mezcla de tipos; alguien emergente; el status quo; ningún incumbente obvio omitido.

Ejes (5): el par de ejes importa al cliente; no son vanidad; la posición tiene evidencia; hay diferencia en al menos un eje; se explica por qué ese eje vale dinero.

Foso (4): los seis evaluados; evidencia mínima; trayectoria; un foso “propio” solo si se justifica.

Evidencia (4): profundidad por rival; mayoría con fuente; separado lo investigado de lo estimado; precios solo si hay fuente. Sin fuente, marcar estimado. Si el usuario aporta movimientos recientes de un rival, etiquetarlos como producto, precio, financiación, contratación, marketing o contenido, cada uno con fuente o marcado como estimado; no buscarlos en la web.

Narrativa (4): el claim de diferencia aguanta un contraejemplo; se puede decir en una slide; coincide con el deck si lo hay; hay plan de cómo el foso crece (slide 07).

Errores (3): no decir “no tenemos competencia”; no elegir ejes para quedar solos arriba a la derecha; no una tabla de features con ticks.

## Salida

Lista de rivales, ejes, fosos y los checks en pasa/falla/aviso. What-if de precio o de un incumbente que copie: `scenario-analysis-ops`, no esta skill.
