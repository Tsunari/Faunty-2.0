# PowerShell script for first release: moves [Unreleased] to 1.0.0 and runs full workflow
# Usage: pwsh ./release_first.ps1

$stepColor = "Green"
function WriteStep($msg) {
    Write-Host $msg -ForegroundColor $stepColor
}

# Step 1: Update CHANGELOG.md [Unreleased] to 1.0.0
WriteStep "Step 1: Update CHANGELOG.md [Unreleased] to 1.0.0"
$changelogPath = "CHANGELOG.md"
$changelog = Get-Content $changelogPath
$today = Get-Date -Format "yyyy-MM-dd"
$changelog = $changelog -replace "## \[Unreleased\]", "## 1.0.0 ($today)"
Set-Content $changelogPath $changelog

# Step 2: Set pubspec.yaml version to 1.0.0+1
WriteStep "Step 2: Set pubspec.yaml version to 1.0.0"
$pubspec = Get-Content "pubspec.yaml"
$pubspec = $pubspec | ForEach-Object {
    if ($_ -match "^version:") { "version: 1.0.0" } else { $_ }
}
Set-Content "pubspec.yaml" $pubspec

# Step 3: Commit changes
WriteStep "Step 3: Commit changes"
$null = git add pubspec.yaml CHANGELOG.md
$null = git commit -m "chore(release): 1.0.0"

# Step 4: Build for android
WriteStep "Step 4: Build for android"
flutter pub get
flutter build apk --release

# Step 5: Create GitHub Release (Android APK)
WriteStep "Step 5: Create GitHub Release (Android APK)"
$apkPath = "build/app/outputs/flutter-apk/app-release.apk"
if (Test-Path $apkPath) {
    gh release create "v1.0.0" $apkPath --title "Release 1.0.0" --notes ($changelog | Select-String "## 1.0.0" -Context 0,50 | ForEach-Object { $_.Line })
}

# Step 6: Deploy web (Firebase)
WriteStep "Step 6: Deploy web (Firebase)"
pwsh ./release.ps1

WriteStep "First release 1.0.0 complete!"
