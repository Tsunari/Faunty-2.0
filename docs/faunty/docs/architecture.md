---
sidebar_position: 4
---

# Architecture

Faunty follows a modular Flutter architecture. Important folders:

- `lib/` — app source
  - `components/` — reusable widgets (chips, app bars, snackbars)
  - `firestore/` — Firestore services per domain (kantin, cleaning, catering, etc.)
  - `state_management/` — Riverpod providers and streams
  - `models/` — domain models
  - `pages/` — feature pages grouped by domain
  - `tools/` — helpers such as `translation_helper.dart`

Design principles:

- Keep Firestore access in services under `lib/firestore/`.
- Map Firestore streams to Riverpod StreamProviders in `lib/state_management/`.
- Use `components/` widgets for consistent UI.
