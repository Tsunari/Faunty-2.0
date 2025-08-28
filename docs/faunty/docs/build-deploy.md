---
sidebar_position: 9
---

# Build & Deploy

Quick commands:

```pwsh
flutter pub get
flutter analyze
flutter test
flutter build web
pwsh release.ps1
```

Notes:

- `release.ps1` and `release-prod.ps1` are provided for automated web releases to Firebase Hosting.
- Ensure `firebase.json` and `firebase` CLI auth are configured before running release scripts.
- For web debugging, `flutter run -d chrome` runs a dev server.
