# PowerShell setup script
Set-StrictMode -Version Latest

python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip setuptools wheel

Get-Content requirements.txt | ForEach-Object {
    $_ = $_.Trim()
    if (-not $_ -or $_.StartsWith('#')) { return }
    Write-Host "Installing: $_"
    try {
        pip install $_ -q -q
    } catch {
        Write-Warning "Failed to install $_; continuing."
    }
}

Write-Host 'Setup complete. To run tests: .\run_tests.ps1'