# PowerShell script for automated version bump, changelog, build, and release
# Usage: pwsh ./update_release.ps1

param(
    [switch]$hosting
)

$steps = 10

if ($hosting) {
    Write-Host "Hosting flag detected. Running only steps 8-10 (web release)." -ForegroundColor Yellow
    Write-Host "Running flutter clean before web build..." -ForegroundColor Green
    flutter clean
    Write-Host "Step 8 of ${steps}: Get Flutter dependencies and Build the web app" -ForegroundColor Green
    flutter pub get
    flutter build web
    if (!(Test-Path "build/web")) {
        Write-Host "Error: build/web directory does not exist. Build failed." -ForegroundColor Red
        exit 1
    }
    Write-Host "Step 9 of ${steps}: Login to Firebase" -ForegroundColor Green
    firebase login
    Write-Host "Step 10 of ${steps}: Deploy to Firebase Hosting" -ForegroundColor Green
    firebase deploy --only hosting
    Write-Host "Web release complete!" -ForegroundColor Green
    exit 0
}

$steps = 11

Write-Host "Step 1 of ${steps}: Get Conventional Commit Messages" -ForegroundColor Green
$lastTag = git describe --tags --abbrev=0
$commits = git log --pretty=format:"%s" --no-merges $lastTag..HEAD
$major = $commits | Select-String -Pattern "BREAKING CHANGE"
$minor = $commits | Select-String -Pattern "^feat:"
$patch = $commits | Select-String -Pattern "^fix:"

Write-Host "Step 2 of ${steps}: Determine next version bump" -ForegroundColor Green
$pubspec = Get-Content "pubspec.yaml"
$versionLine = $pubspec | Where-Object { $_ -match "^version:" }
$version = $versionLine -replace "version:\s*", ""
$versionParts = $version.Split("+",2)[0].Split(".")
$majorNum = [int]$versionParts[0]
$minorNum = [int]$versionParts[1]
$patchNum = [int]$versionParts[2]

if ($major) {
    $majorNum++
    $minorNum = 0
    $patchNum = 0
} elseif ($minor) {
    $minorNum++
    $patchNum = 0
} elseif ($patch) {
    $patchNum++
}
$newVersion = "$majorNum.$minorNum.$patchNum"
$newVersionLine = "version: $newVersion+1"

Write-Host "Step 3 of ${steps}: Update pubspec.yaml" -ForegroundColor Green
$pubspec = $pubspec | ForEach-Object {
    if ($_ -match "^version:") { $newVersionLine } else { $_ }
}
Set-Content "pubspec.yaml" $pubspec

Write-Host "Step 4 of ${steps}: Update/Create CHANGELOG.md" -ForegroundColor Green
$changelogPath = "CHANGELOG.md"
if (!(Test-Path $changelogPath)) {
    "# Changelog`n" | Out-File $changelogPath
}
$changelog = Get-Content $changelogPath
$today = Get-Date -Format "yyyy-MM-dd"
$entry = "## $newVersion ($today)`n"
if ($major) { $entry += "### Breaking Changes`n" + ($major | ForEach-Object { $_.Line }) + "`n" }
if ($minor) { $entry += "### Features`n" + ($minor | ForEach-Object { $_.Line }) + "`n" }
if ($patch) { $entry += "### Fixes`n" + ($patch | ForEach-Object { $_.Line }) + "`n" }
$changelog = @($entry) + $changelog
Set-Content $changelogPath $changelog

Write-Host "Step 5 of ${steps}: Commit changes" -ForegroundColor Green
$null = git add pubspec.yaml CHANGELOG.md
$null = git commit -m "chore(release): $newVersion"

Write-Host "Step 6 of ${steps}: Build for android" -ForegroundColor Green
flutter pub get
flutter build apk --release

Write-Host "Step 7 of ${steps}: Create GitHub Release (Android APK)" -ForegroundColor Green
$apkPath = "build/app/outputs/flutter-apk/app-release.apk"
if (Test-Path $apkPath) {
    gh release create "v$newVersion" $apkPath --title "Release $newVersion" --notes ($entry)
}

Write-Host "Step 8 of ${steps}: Build the Flutter web app" -ForegroundColor Green
flutter build web

if (!(Test-Path "build/web")) {
    Write-Host "Error: build/web directory does not exist. Build failed." -ForegroundColor Red
    exit 1
}

Write-Host "Step 9 of ${steps}: Login to Firebase" -ForegroundColor Green
firebase login

Write-Host "Step 10 of ${steps}: Deploy to Firebase Hosting" -ForegroundColor Green
firebase deploy --only hosting

Write-Host "Release $newVersion complete!"
