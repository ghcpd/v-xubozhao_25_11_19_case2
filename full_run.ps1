$Log = "full_run_ps.log"
"" > $Log

$Start = Get-Date -Format o
Write-Output "Full run start: $Start" | Tee-Object -FilePath $Log -Append

if (-not (Test-Path -Path .venv)) {
    Write-Output "Creating venv and installing dependencies..." | Tee-Object -FilePath $Log -Append
    python -m venv .venv
    .\.venv\Scripts\Activate.ps1
    python -m pip install --upgrade pip
    pip install -r requirements.txt | Tee-Object -FilePath $Log -Append
} else {
    Write-Output "Virtual env exists; skipping creation" | Tee-Object -FilePath $Log -Append
}

# Run tests (uses run_tests.sh for consistency)
Write-Output "Running tests..." | Tee-Object -FilePath $Log -Append
./run_tests.sh 2>&1 | Tee-Object -FilePath $Log -Append

$End = Get-Date -Format o
$Duration = (Get-Date) - (Get-Date $Start)
Write-Output "Full run end: $End" | Tee-Object -FilePath $Log -Append
Write-Output "Full run duration (s): $($Duration.TotalSeconds)" | Tee-Object -FilePath $Log -Append

Write-Output "Completed. See $Log" | Tee-Object -FilePath $Log -Append
