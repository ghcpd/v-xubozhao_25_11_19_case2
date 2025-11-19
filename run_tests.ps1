# PowerShell run tests
Set-StrictMode -Version Latest

if (-not (Test-Path -Path '.venv')) {
    Write-Error 'Virtualenv not found. Run setup.ps1 first.'
    exit 1
}

.\.venv\Scripts\Activate.ps1
if (-not (Test-Path -Path 'logs')) { New-Item -ItemType Directory -Path logs | Out-Null }
python demo_test.py | Tee-Object -FilePath logs\test_output.log
Write-Host 'Tests completed. See logs/test_output.log for output.'