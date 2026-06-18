---
name: structured-commits-ops
description: >
  Commits con trailers de decisión en proyecto activo. Complementa git-commit.
  Trigger: commit tras cambios de arquitectura UI/estado.
license: UNLICENSED
metadata:
  version: "1.1.0"
  auto_invoke:
    - "Crear commit"
  related-skills: [git-commit, verification-before-completion]
---

# Structured commits ops — proyecto activo

Adaptado desde clawvis-openclaw.

## Scopes sugeridos

`onboarding`, `kyc`, `marketplace`, `chat`, `profiles`, `theme`, `config`, `agents`

## Mismo formato de trailers que Backend

Ver skill homónima en Backend; aplicar a commits Flutter/Dart.

## Checklist

- [ ] `flutter analyze` y `flutter test` según alcance
- [ ] Sin API keys en commit
