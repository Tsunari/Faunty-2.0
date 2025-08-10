# Faunty Flutter Project

<p align="center">
  <img src="assets/Logo.png" alt="Faunty Logo" width="120" />
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.32.8-blue?logo=flutter" alt="Flutter"></a>
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/Firebase-Enabled-yellow?logo=firebase" alt="Firebase"></a>
  <a href="https://github.com/rrousselGit/riverpod"><img src="https://img.shields.io/badge/Riverpod-State%20Management-green?logo=riverpod" alt="Riverpod"></a>
  <a href="https://github.com/slang-i18n/slang"><img src="https://img.shields.io/badge/i18n-Slang-orange" alt="Slang"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-Private-inactive" alt="License"></a>
  <a href="https://img.shields.io/github/last-commit/Tsunari/Faunty-2.0"><img src="https://img.shields.io/github/last-commit/Tsunari/Faunty-2.0?label=Last%20Commit" alt="Last Commit"></a>
  <a href="https://img.shields.io/github/languages/top/Tsunari/Faunty-2.0"><img src="https://img.shields.io/github/languages/top/Tsunari/Faunty-2.0?label=Dart" alt="Top Language"></a>
  <a href="https://img.shields.io/github/issues-pr/Tsunari/Faunty-2.0"><img src="https://img.shields.io/github/issues-pr/Tsunari/Faunty-2.0?label=PRs" alt="Pull Requests"></a>
  <a href="https://img.shields.io/github/stars/Tsunari/Faunty-2.0"><img src="https://img.shields.io/github/stars/Tsunari/Faunty-2.0?label=Stars" alt="Stars"></a>
</p>

Faunty is a modern Flutter app for team and organization management, built for usability, real-time collaboration, and beautiful design.

## 🚀 Features
- **Firebase Integration:** Real-time Firestore database and secure authentication
- **Riverpod State Management:** Scalable, reactive state across the app
- **Internationalization (i18n):** Multi-language support powered by Slang
- **Custom UI Components:** Reusable widgets for a consistent look (`lib/components/`)
- **Modular Architecture:** Each domain (kantin, cleaning, catering, program) is separated for clarity and maintainability

## 🗄️ Firestore Data Structure
- `places/{placeId}/{domain}` — Domains include `kantin`, `cleaning`, `catering`, `program`, etc.
- `user_list/{userUID}` — User-specific data as document fields
- See service implementations in [`lib/firestore/`](lib/firestore/) for details

## 🌍 Localization
- All UI strings use the [`translation()`](lib/tools/translation_helper.dart) helper
- Pass either a context or just the string for translation
- Discover new translation keys with [`lib/tools/extract_t_strings_ast.dart`](lib/tools/extract_t_strings_ast.dart)

## 🐞 Debug Logging
- Use [`lib/helper/logging.dart`](lib/helper/logging.dart) for debug prints and diagnostics

## 🛠️ Developer Workflow
- **Run Locally:**
  ```sh
  flutter run
  ```
- **Build for Web:**
  ```sh
  flutter build web
  ```
- **Deploy to Firebase Hosting:**
  ```sh
  pwsh release.ps1
  ```
- **Analyze & Lint:**
  ```sh
  flutter analyze
  ```
- **Run Tests:**
  ```sh
  flutter test
  ```

## 📁 Key Directories
- `lib/components/` — Custom widgets
- `lib/firestore/` — Firestore service logic
- `lib/pages/` — Feature pages grouped by domain
- `lib/state_management/` — Riverpod providers
- `lib/i18n/` — Translation files
- `test/` — Widget tests

## 📝 Contributing
Pull requests and issues are welcome! Please follow the existing code style and add tests for new features.

## 📄 License
This project is licensed for private use. See the repository for details.

---

For questions or feedback, open an issue or contact the maintainer.
