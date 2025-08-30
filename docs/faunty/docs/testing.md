---
sidebar_position: 10
---

# Testing

Run tests and checks locally:

```pwsh
flutter analyze
flutter test
```

There is a sample widget test in `test/widget_test.dart`.

Guidance:

- Keep tests fast and deterministic.
- Mock external services (Firestore, Auth) for unit tests.
- Add at least one widget test for new UI components.
