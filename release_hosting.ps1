# Faunty 2.0 - Release Script
# Cleans, builds, and deploys the web app to Firebase Hosting (dev or production)

function Show-Selector {
    param (
        [string[]]$Options
    )
    $selected = 0
    while ($true) {
        Clear-Host
        Write-Host "Select deployment target:`n"
        for ($i = 0; $i -lt $Options.Length; $i++) {
            if ($i -eq $selected) {
                Write-Host " > $($Options[$i])" -ForegroundColor Cyan
            } else {
                Write-Host "   $($Options[$i])"
            }
        }
        $key = [System.Console]::ReadKey($true)
        switch ($key.Key) {
            'UpArrow'   { if ($selected -gt 0) { $selected-- } }
            'DownArrow' { if ($selected -lt ($Options.Length - 1)) { $selected++ } }
            'Enter'     { return $Options[$selected] }
        }
    }
}

$envChoice = Show-Selector @('Production', 'Development')

switch ($envChoice) {
    'Production' {
        $hostingTarget = '2faunty'
        $siteName = '2faunty.web.app (Production)'
    }
    'Development' {
        $hostingTarget = 'devfaunty'
        $siteName = 'devfaunty.web.app (Development)'
    }
    default {
        Write-Host "`n❌ Invalid choice. Please run the script again." -ForegroundColor Red
        exit 1
    }
}

Write-Host "🚀 Starting Faunty 2.0 Release..." -ForegroundColor Cyan

# Step 1: Clean previous build artifacts
Write-Host "`n🧹 Cleaning build folder..." -ForegroundColor Yellow
flutter clean

# Step 2: Get dependencies
Write-Host "`n📦 Fetching Flutter packages..." -ForegroundColor Yellow
flutter pub get

# Step 3: Build web app
Write-Host "`n🔨 Building web app..." -ForegroundColor Yellow
flutter build web

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n❌ Build failed. Aborting deployment." -ForegroundColor Red
    exit 1
}

# Step 4: Deploy to Firebase Hosting
Write-Host "`n🚚 Deploying to Firebase Hosting ($siteName)..." -ForegroundColor Yellow
firebase deploy --only hosting:$hostingTarget

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Deployment successful!" -ForegroundColor Green
} else {
    Write-Host "`n❌ Deployment failed." -ForegroundColor Red
    exit 1
}