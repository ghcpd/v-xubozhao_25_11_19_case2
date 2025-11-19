#!/usr/bin/env pwsh
param(
  [string]$Python = "python"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
$venv = Join-Path $root ".venv"

# Version guard
$pyCode = @'
import sys, warnings
min_v=(3,10)
max_excl=(3,13)
ver=sys.version_info
if ver < min_v:
  raise SystemExit(f"Python {min_v[0]}.{min_v[1]}+ required, got {sys.version.split()[0]}")
if ver >= max_excl:
  warnings.warn(f"Python {sys.version.split()[0]} is above tested range (<{max_excl[0]}.{max_excl[1]}). Some dependencies may be skipped.")
'@
& $Python -c $pyCode

if (-not (Test-Path $venv)) {
  Write-Host "Creating virtual environment at $venv"
  & $Python -m venv $venv
}

$activate = Join-Path $venv "Scripts/Activate.ps1"
. $activate

pip install --upgrade pip
pip install -r (Join-Path $root "requirements.txt")

Write-Host "✅ Environment ready. Activate with: . .venv/Scripts/Activate.ps1"
