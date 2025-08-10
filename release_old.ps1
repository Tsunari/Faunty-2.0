# Write-Host "Step 1 of ${steps}: Get Conventional Commit Messages" -ForegroundColor Green
# $lastTag = git describe --tags --abbrev=0
# $commits = git log --pretty=format:"%s" --no-merges $lastTag..HEAD
# $major = $commits | Select-String -Pattern "BREAKING CHANGE"
# $minor = $commits | Select-String -Pattern "^feat:"
# $patch = $commits | Select-String -Pattern "^fix:"

# Write-Host "Step 2 of ${steps}: Determine next version bump" -ForegroundColor Green
# $pubspec = Get-Content "pubspec.yaml"
# $versionLine = $pubspec | Where-Object { $_ -match "^version:" }
# $version = $versionLine -replace "version:\s*", ""
# $versionParts = $version.Split("+",2)[0].Split(".")
# $majorNum = [int]$versionParts[0]
# $minorNum = [int]$versionParts[1]
# $patchNum = [int]$versionParts[2]

# # Always bump the highest priority version: BREAKING CHANGE > feat: > fix:
# if ($major) {
#     $majorNum++
#     $minorNum = 0
#     $patchNum = 0
# } elseif ($minor) {
#     $minorNum++
#     $patchNum = 0
# } elseif ($patch) {
#     $patchNum++
# }
# $newVersion = "$majorNum.$minorNum.$patchNum"
# $newVersionLine = "version: $newVersion+1"

# Write-Host "Step 3 of ${steps}: Update pubspec.yaml" -ForegroundColor Green
# $pubspec = $pubspec | ForEach-Object {
#     if ($_ -match "^version:") { $newVersionLine } else { $_ }
# }
# Set-Content "pubspec.yaml" $pubspec

# Write-Host "Step 4 of ${steps}: Update/Create CHANGELOG.md" -ForegroundColor Green
# $changelogPath = "CHANGELOG.md"
# if (!(Test-Path $changelogPath)) {
#     "# Changelog`n" | Out-File $changelogPath
# }
# $changelog = Get-Content $changelogPath
# $today = Get-Date -Format "yyyy-MM-dd"
# $entry = "## $newVersion ($today)`n"
# if ($major) { $entry += "### Breaking Changes`n" + ($major | ForEach-Object { $_.Line }) + "`n" }
# if ($minor) { $entry += "### Features`n" + ($minor | ForEach-Object { $_.Line }) + "`n" }
# if ($patch) { $entry += "### Fixes`n" + ($patch | ForEach-Object { $_.Line }) + "`n" }
# # Add all commit messages if no conventional type found
# if (-not ($major -or $minor -or $patch)) {
#     $entry += "### Other`n" + ($commits | ForEach-Object { $_ }) + "`n"
# }
# # Prepend under # Changelog
# $changelog = $changelog -join "`n"
# $changelog = $changelog -replace "# Changelog", "# Changelog`n$entry"
# Set-Content $changelogPath $changelog

# Write-Host "Step 5 of ${steps}: Commit changes" -ForegroundColor Green
# $null = git add pubspec.yaml CHANGELOG.md
# $null = git commit -m "chore(release): $newVersion"

# # Start the github workflows with gh cli later

# Write-Host "Release $newVersion complete!"