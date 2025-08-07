# Release script for deploying Flutter web app to Firebase Hosting
flutter clean
flutter pub get
firebase login
firebase deploy --only hosting
