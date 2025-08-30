---
sidebar_position: 3
---

# Getting Started

This guide gets you up and running with Faunty locally.

## Prerequisites

- Flutter (stable) installed and on PATH
- Dart SDK (bundled with Flutter)
- Firebase CLI (optional for deploy)

## Install dependencies

Run:

```pwsh
flutter pub get
```

## Run the app

For mobile (connected device/emulator):

```pwsh
flutter run
```

For web (development):

```pwsh
flutter run -d chrome
```

## Notes

- Firestore and Auth are used across the app; set up `google-services.json` / `GoogleService-Info.plist` and `firebase_options.dart` as needed.
- See `release.ps1` and `release-prod.ps1` for web deployment automation.
