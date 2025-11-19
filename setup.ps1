# PowerShell setup script for Windows
Write-Host "Creating virtual environment .venv..."
python -m venv .venv
Write-Host "Activating virtual environment"
.\.venv\Scripts\Activate.ps1
Write-Host "Upgrading pip and installing requirements"
python -m pip install --upgrade pip
pip install -r requirements.txt
Write-Host "Setup complete. Use '.\\.venv\\Scripts\\Activate.ps1' to activate the environment."