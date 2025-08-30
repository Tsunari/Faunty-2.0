---
sidebar_position: 5
---

# State Management

Faunty uses Riverpod for state. Common patterns:

- Use `StreamProvider` for Firestore streams.
- Prefer `ref.watch` in UI widgets and `ref.read` for one-off actions.

Example provider (pattern):

```dart
// lib/state_management/user_provider.dart
// ...existing code...
```

See `lib/state_management/` for concrete providers and naming conventions.
