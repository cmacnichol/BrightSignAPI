[CmdletBinding()]
param(
    [switch]$TestOnly
)

$ErrorActionPreference = 'Stop'
$moduleName = "BrightSignAPI"
$srcPath = Join-Path $PSScriptRoot "src"
$modulePath = Join-Path $srcPath $moduleName
$manifestPath = Join-Path $modulePath "$moduleName.psd1"

Write-Host "==> Building $moduleName <==" -ForegroundColor Cyan

# 1. Run Tests
Write-Host "`nRunning Pester Tests..." -ForegroundColor Yellow
if (Get-Module -ListAvailable Pester) {
    $pesterParams = @{
        Path = Join-Path $PSScriptRoot "tests"
        PassThru = $true
    }
    $testResults = Invoke-Pester @pesterParams
    if ($testResults.FailedCount -gt 0) {
        Write-Error "Tests failed! Build aborted."
        exit 1
    }
} else {
    Write-Warning "Pester module not found. Skipping tests."
}

if ($TestOnly) {
    Write-Host "`nTest complete. Exiting." -ForegroundColor Green
    exit 0
}

# 2. Publish (Usually done by CI)
Write-Host "`nTo publish this module, use GitHub Actions or run Publish-Module manually." -ForegroundColor Yellow
Write-Host "Build finished successfully." -ForegroundColor Green
