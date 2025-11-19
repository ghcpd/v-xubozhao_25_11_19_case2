#!/usr/bin/env pwsh
# Setup script for Windows PowerShell
# Automates Python environment and dependency installation

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Dependency Upgrade Setup Script" -ForegroundColor Cyan
Write-Host "  Python 3.10+ Backend Data Processing Project" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Check Python version
Write-Host "[1/5] Checking Python version..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "  Found: $pythonVersion" -ForegroundColor Green
    
    # Extract version number
    if ($pythonVersion -match "Python (\d+)\.(\d+)") {
        $major = [int]$Matches[1]
        $minor = [int]$Matches[2]
        
        if ($major -lt 3 -or ($major -eq 3 -and $minor -lt 10)) {
            Write-Host "  ERROR: Python 3.10+ required. Found: $major.$minor" -ForegroundColor Red
            Write-Host "  Please install Python 3.10 or later from https://www.python.org/" -ForegroundColor Red
            exit 1
        }
        Write-Host "  Version check: PASSED (3.10+)" -ForegroundColor Green
    }
} catch {
    Write-Host "  ERROR: Python not found in PATH" -ForegroundColor Red
    Write-Host "  Please install Python 3.10+ from https://www.python.org/" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Check if virtual environment exists
Write-Host "[2/5] Checking for virtual environment..." -ForegroundColor Yellow
$venvPath = "venv"
if (Test-Path $venvPath) {
    Write-Host "  Virtual environment found at: $venvPath" -ForegroundColor Green
    $createVenv = Read-Host "  Do you want to recreate it? (y/N)"
    if ($createVenv -eq "y" -or $createVenv -eq "Y") {
        Write-Host "  Removing existing virtual environment..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force $venvPath
        Write-Host "  Creating new virtual environment..." -ForegroundColor Yellow
        python -m venv $venvPath
        Write-Host "  Virtual environment created!" -ForegroundColor Green
    } else {
        Write-Host "  Using existing virtual environment" -ForegroundColor Green
    }
} else {
    Write-Host "  Creating virtual environment..." -ForegroundColor Yellow
    python -m venv $venvPath
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ERROR: Failed to create virtual environment" -ForegroundColor Red
        exit 1
    }
    Write-Host "  Virtual environment created!" -ForegroundColor Green
}

Write-Host ""

# Activate virtual environment
Write-Host "[3/5] Activating virtual environment..." -ForegroundColor Yellow
& "$venvPath\Scripts\Activate.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: Failed to activate virtual environment" -ForegroundColor Red
    exit 1
}
Write-Host "  Virtual environment activated!" -ForegroundColor Green

Write-Host ""

# Upgrade pip
Write-Host "[4/5] Upgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip
if ($LASTEXITCODE -ne 0) {
    Write-Host "  WARNING: Failed to upgrade pip (continuing anyway)" -ForegroundColor Yellow
} else {
    Write-Host "  pip upgraded successfully!" -ForegroundColor Green
}

Write-Host ""

# Install dependencies
Write-Host "[5/5] Installing dependencies from requirements.txt..." -ForegroundColor Yellow
Write-Host "  This may take a few minutes..." -ForegroundColor Cyan
pip install -r requirements.txt
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ERROR: Failed to install dependencies" -ForegroundColor Red
    Write-Host "  Check the error messages above for details" -ForegroundColor Red
    exit 1
}
Write-Host "  All dependencies installed successfully!" -ForegroundColor Green

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. The virtual environment is now active" -ForegroundColor White
Write-Host "  2. Run tests with: .\run_tests.ps1" -ForegroundColor White
Write-Host "  3. Or manually: python test_dependencies.py" -ForegroundColor White
Write-Host ""
Write-Host "To activate the environment later, run:" -ForegroundColor Cyan
Write-Host "  .\venv\Scripts\Activate.ps1" -ForegroundColor White
Write-Host ""
