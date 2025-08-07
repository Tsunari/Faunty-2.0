# Release script for deploying Flutter web app to Firebase Hosting
$steps = 5

Write-Host "Step 1 of ${steps}: Clean previous build artifacts" -ForegroundColor Green
flutter clean

Write-Host "Step 2 of ${steps}: Get Flutter dependencies" -ForegroundColor Green
flutter pub get

Write-Host "Step 3 of ${steps}: Build the Flutter web app" -ForegroundColor Green
flutter build web

if (!(Test-Path "build/web")) {
	Write-Host "Error: build/web directory does not exist. Build failed." -ForegroundColor Red
	exit 1
}

Write-Host "Step 4 of ${steps}: Login to Firebase" -ForegroundColor Green
firebase login

Write-Host "Step 5 of ${steps}: Deploy to Firebase Hosting" -ForegroundColor Green
firebase deploy --only hosting
