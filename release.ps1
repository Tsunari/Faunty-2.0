param(
    [switch]$force,
    [switch]$hosting
)

#region Helper Functions
function Write-Section {
    param([string]$Title, [int]$Step, [int]$Total)
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ("Step $($Step) of $($Total): $Title") -ForegroundColor Yellow
    Write-Host "================================" -ForegroundColor Cyan
}

function Write-ErrorAndExit {
    param(
        [string]$Message,
        [scriptblock]$BeforeExit = $null
    )
    Write-Host "[ERROR] $Message" -ForegroundColor Red
    if ($BeforeExit) { & $BeforeExit }
    exit 1
}
#endregion Helper Functions

#region Globals
$ErrorActionPreference = 'Stop'
$startTime = Get-Date
$totalSteps = 7
#endregion Globals

#region Pre-checks
if (-not $force) {
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-ErrorAndExit "There are uncommitted changes in the repository. Please commit or stash them before running the release script." { Write-Host $gitStatus }
    }
}
#endregion Pre-checks

try {
    #region Step 1: Version Increment (Semantic, no build number)
    Write-Section "Semantic Version Increment" 1 $totalSteps
    $pubspecPath = "./pubspec.yaml"
    $pubspec = Get-Content $pubspecPath
    $versionLine = $pubspec | Where-Object { $_ -match "^version:" }
    $currentVersion = $versionLine -replace "version:\s*", ""
    $versionParts = $currentVersion.Split("+",2)[0].Split(".")
    $major = [int]$versionParts[0]
    $minor = [int]$versionParts[1]
    $patch = [int]$versionParts[2]

    $lastTag = git describe --tags --abbrev=0
    $commitObjs = git log --pretty=format:"%h %s" --no-merges $lastTag..HEAD | ForEach-Object {
        $parts = $_.Split(' ',2)
        [PSCustomObject]@{ Hash = $parts[0]; Message = $parts[1] }
    }
    $hasBreaking = $commitObjs | Where-Object { $_.Message -match "BREAKING CHANGE" }
    $hasFeat = $commitObjs | Where-Object { $_.Message -match "^feat:" }
    $hasFix = $commitObjs | Where-Object { $_.Message -match "^fix:" }
    $otherCommits = $commitObjs | Where-Object { -not ($_.Message -match "BREAKING CHANGE" -or $_.Message -match "^feat:" -or $_.Message -match "^fix:") }

    if ($hasBreaking.Count -gt 0) {
        $major++
        $minor = 0
        $patch = 0
        $bumpType = "major"
    } elseif ($hasFeat.Count -gt 0) {
        $minor++
        $patch = 0
        $bumpType = "minor"
    } elseif ($hasFix.Count -gt 0) {
        $patch++
        $bumpType = "patch"
    } else {
        $patch++
        $bumpType = "patch"
    }
    $newVersion = "$major.$minor.$patch"
    $newVersionLine = "version: $newVersion"
    Write-Host "Current version: $currentVersion" -ForegroundColor Green
    Write-Host "New version: $newVersion ($bumpType)" -ForegroundColor Green
    $pubspec = $pubspec | ForEach-Object {
        if ($_ -match "^version:") { $newVersionLine } else { $_ }
    }
    Set-Content $pubspecPath $pubspec
    #endregion Step 1

    #region Step 2: Build APK
    # Write-Section "Build APK" 2 $totalSteps
    # flutter clean
    # flutter pub get
    # flutter build apk
    # if (!(Test-Path "build/app/outputs/flutter-apk/app-release.apk")) {
    #     Write-ErrorAndExit "APK build failed. APK not found."
    # }
    # $apkPath = "build/app/outputs/flutter-apk/app-release.apk"
    # $apkTarget = "Faunty-$newVersion.apk"
    # Copy-Item $apkPath $apkTarget -Force
    # Write-Host "APK built and renamed to $apkTarget" -ForegroundColor Green
    #endregion Step 2

    #region Step 3: Generate Changelog
    Write-Section "Generate Changelog" 3 $totalSteps
    $changelogPath = "CHANGELOG.md"
    if (!(Test-Path $changelogPath)) {
        "# Changelog`n" | Out-File $changelogPath
    }
    $today = Get-Date -Format "yyyy-MM-dd"
    $prevTag = git describe --tags --abbrev=0 HEAD^
    $commitObjs = git log --pretty=format:"%h %s" --no-merges $prevTag...HEAD | ForEach-Object {
        $parts = $_.Split(' ',2)
        [PSCustomObject]@{ Hash = $parts[0]; Message = $parts[1] }
    }
    $hasBreaking = $commitObjs | Where-Object { $_.Message -match "BREAKING CHANGE" }
    $hasFeat = $commitObjs | Where-Object { $_.Message -match "^feat:" }
    $hasFix = $commitObjs | Where-Object { $_.Message -match "^fix:" }
    $otherCommits = $commitObjs | Where-Object { -not ($_.Message -match "BREAKING CHANGE" -or $_.Message -match "^feat:" -or $_.Message -match "^fix:") }

    $entry = "## $newVersion ($today)`n"
    if ($hasBreaking.Count -gt 0) {
        $entry += "### Breaking Changes`n" + ($hasBreaking | ForEach-Object { "- $($_.Message)" }) + "`n"
    }
    if ($hasFeat.Count -gt 0) {
        $entry += "### Features`n" + ($hasFeat | ForEach-Object { "- $($_.Message)" }) + "`n"
    }
    if ($hasFix.Count -gt 0) {
        $entry += "### Fixes`n" + ($hasFix | ForEach-Object { "- $($_.Message)" }) + "`n"
    }
    if ($otherCommits.Count -gt 0) {
        $entry += "### Other`n" + ($otherCommits | ForEach-Object { "- $($_.Message)" }) + "`n"
    }
    # If no grouped commits, add all commit messages under Other
    if ($hasBreaking.Count -eq 0 -and $hasFeat.Count -eq 0 -and $hasFix.Count -eq 0 -and $otherCommits.Count -eq 0) {
        $entry += "### Other`n" + ($commitObjs | ForEach-Object { "- $($_.Message)" }) + "`n"
    }
    $changelog = Get-Content $changelogPath -Raw
        # Prepend the new entry after the # Changelog heading
        $changelogLines = $changelog -split "`n"
        $headingIndex = $changelogLines.IndexOf('# Changelog')
        if ($headingIndex -eq -1) {
            # If heading not found, just prepend
            $newChangelog = "# Changelog`n$entry" + $changelog
        } else {
            $before = $changelogLines[0..$headingIndex]
            $after = $changelogLines[($headingIndex+1)..($changelogLines.Count-1)]
            $newChangelog = ($before -join "`n") + "`n" + $entry + ($after.Count -gt 0 ? ("`n" + ($after -join "`n")) : "")
        }
        Set-Content $changelogPath $newChangelog
        Write-Host "Changelog updated." -ForegroundColor Green
    #endregion Step 3

    #region Step 4: Commit and Push
    Write-Section "Commit and Push" 4 $totalSteps
    git add pubspec.yaml CHANGELOG.md
    git add $apkTarget
    git commit -m "chore(release): $newVersion"
    # git push
    if ($LASTEXITCODE -ne 0) { Write-ErrorAndExit "Git push failed." }
    #endregion Step 4

    #region Step 5: Create GitHub Release
    # Write-Section "Create GitHub Release" 5 $totalSteps
    # $tag = "v$newVersion"
    # $releaseTitle = "Faunty $newVersion"
    # $releaseNotes = $entry
    # Write-Host "Creating GitHub release $tag..." -ForegroundColor Cyan
    # gh release create $tag $apkTarget --title "$releaseTitle" --notes "$releaseNotes"
    # if ($LASTEXITCODE -ne 0) { Write-ErrorAndExit "GitHub release failed." }
    # Write-Host "Release created and APK uploaded." -ForegroundColor Green
    #endregion Step 5

    #region Step 6: Optional Firebase Hosting Deploy
    if ($hosting) {
        Write-Section "Deploy to Firebase Hosting" 6 $totalSteps
        flutter build web
        if (!(Test-Path "build/web")) {
            Write-ErrorAndExit "Web build failed."
        }
        firebase login
        firebase deploy --only hosting
        Write-Host "Web release complete!" -ForegroundColor Green
    }
    #endregion Step 6

    #region Step 7: Final Output
    $endTime = Get-Date
    $duration = $endTime - $startTime
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ("All done! Total time: {0:mm\:ss} (mm:ss)" -f $duration) -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Cyan
    #endregion Step 7
}
catch {
    Write-Host "[FATAL ERROR] $_" -ForegroundColor Red
    exit 1
}

