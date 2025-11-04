# Script to fix INSTALL_FAILED_INSUFFICIENT_STORAGE error
# This script will uninstall old app (if exists) and clean cache

Write-Host "Checking and fixing storage issue..." -ForegroundColor Cyan

# Find Android SDK path
$androidHome = $env:ANDROID_HOME
if (-not $androidHome) {
    $androidHome = "$env:LOCALAPPDATA\Android\Sdk"
}

$adbPath = "$androidHome\platform-tools\adb.exe"

if (-not (Test-Path $adbPath)) {
    Write-Host "Cannot find adb.exe. Please ensure Android SDK is installed." -ForegroundColor Red
    Write-Host "You can try the following:" -ForegroundColor Yellow
    Write-Host "1. Open Android Studio > AVD Manager > Edit emulator > Show Advanced Settings > Increase Internal Storage" -ForegroundColor Yellow
    Write-Host "2. Delete and create new emulator with larger storage" -ForegroundColor Yellow
    Write-Host "3. Uninstall other apps on emulator to free space" -ForegroundColor Yellow
    exit 1
}

# Check connected devices
Write-Host "`nChecking connected devices..." -ForegroundColor Cyan
& $adbPath devices

# Uninstall old app (package name from build.gradle.kts)
$packageName = "com.example.flutter_travels_apps"
Write-Host "`nUninstalling old app (if exists): $packageName" -ForegroundColor Cyan
$result = & $adbPath shell pm uninstall $packageName 2>&1
if ($LASTEXITCODE -eq 0 -or $result -match "Success") {
    Write-Host "Successfully uninstalled old app" -ForegroundColor Green
} else {
    Write-Host "No old app found to uninstall (might be first install)" -ForegroundColor Yellow
}

# Try alternative package names
$alternativePackages = @(
    "com.example.flutter_travel_app",
    "com.example.travel_app",
    "flutter_travels_apps"
)

foreach ($pkg in $alternativePackages) {
    & $adbPath shell pm uninstall $pkg 2>&1 | Out-Null
}

# Clear cache
Write-Host "`nClearing cache..." -ForegroundColor Cyan
& $adbPath shell pm clear $packageName 2>&1 | Out-Null

# Show storage info
Write-Host "`nChecking remaining storage on device..." -ForegroundColor Cyan
& $adbPath shell df /data

Write-Host "`nDone! Now you can try running the app again with:" -ForegroundColor Green
Write-Host "  flutter run" -ForegroundColor Yellow
