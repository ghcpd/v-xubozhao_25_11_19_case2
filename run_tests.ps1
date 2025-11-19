#!/usr/bin/env pwsh
# Run tests script for Windows PowerShell
# Executes validation tests and generates logs

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Dependency Validation Test Runner" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Create logs directory
$logsDir = "logs"
if (-not (Test-Path $logsDir)) {
    Write-Host "Creating logs directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $logsDir | Out-Null
}

# Generate timestamp for log file
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = "$logsDir\test_run_$timestamp.log"
$reportFile = "$logsDir\test_report_$timestamp.txt"

Write-Host "Log file: $logFile" -ForegroundColor Cyan
Write-Host "Report file: $reportFile" -ForegroundColor Cyan
Write-Host ""

# Check if virtual environment is activated
Write-Host "Checking environment..." -ForegroundColor Yellow
$venvActive = $env:VIRTUAL_ENV
if (-not $venvActive) {
    Write-Host "  Virtual environment not activated!" -ForegroundColor Yellow
    Write-Host "  Attempting to activate..." -ForegroundColor Yellow
    
    $venvPath = "venv"
    if (Test-Path "$venvPath\Scripts\Activate.ps1") {
        & "$venvPath\Scripts\Activate.ps1"
        Write-Host "  Virtual environment activated!" -ForegroundColor Green
    } else {
        Write-Host "  ERROR: Virtual environment not found" -ForegroundColor Red
        Write-Host "  Please run setup.ps1 first" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "  Virtual environment: Active" -ForegroundColor Green
}

Write-Host ""

# Run tests and capture output
Write-Host "Running tests..." -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Run tests with output to both console and log file
$testOutput = & python test_dependencies.py 2>&1
$testExitCode = $LASTEXITCODE

# Save full output to log file
$testOutput | Out-File -FilePath $logFile -Encoding UTF8

# Display output to console
$testOutput | ForEach-Object { Write-Host $_ }

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan

# Generate summary report
Write-Host ""
Write-Host "Generating test report..." -ForegroundColor Yellow

$report = @"
============================================================
DEPENDENCY VALIDATION TEST REPORT
============================================================
Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Python Version: $(python --version 2>&1)
Log File: $logFile
============================================================

TEST RESULTS:
$(if ($testExitCode -eq 0) { "Status: ALL TESTS PASSED ✅" } else { "Status: SOME TESTS FAILED ❌" })
Exit Code: $testExitCode

============================================================
FULL OUTPUT:
============================================================
$testOutput
============================================================

INSTALLED PACKAGES:
============================================================
$(pip list)
============================================================

ENVIRONMENT INFO:
============================================================
Virtual Environment: $env:VIRTUAL_ENV
Python Path: $(python -c "import sys; print(sys.executable)")
Platform: $([System.Environment]::OSVersion.VersionString)
============================================================
"@

$report | Out-File -FilePath $reportFile -Encoding UTF8

Write-Host "Test report saved to: $reportFile" -ForegroundColor Green
Write-Host ""

# Final summary
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Test Execution Complete" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

if ($testExitCode -eq 0) {
    Write-Host "Result: ALL TESTS PASSED ✅" -ForegroundColor Green
    Write-Host ""
    Write-Host "All upgraded dependencies are working correctly!" -ForegroundColor Green
    Write-Host "You can now safely use the upgraded environment." -ForegroundColor Green
} else {
    Write-Host "Result: SOME TESTS FAILED ❌" -ForegroundColor Red
    Write-Host ""
    Write-Host "Some tests failed. Please review:" -ForegroundColor Red
    Write-Host "  - Log file: $logFile" -ForegroundColor Yellow
    Write-Host "  - Report file: $reportFile" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "  - Missing system dependencies" -ForegroundColor White
    Write-Host "  - Network issues during package installation" -ForegroundColor White
    Write-Host "  - Incompatible Python version" -ForegroundColor White
}

Write-Host ""
Write-Host "Files generated:" -ForegroundColor Cyan
Write-Host "  - $logFile" -ForegroundColor White
Write-Host "  - $reportFile" -ForegroundColor White
Write-Host ""

exit $testExitCode
