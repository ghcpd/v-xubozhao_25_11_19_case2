#!/bin/bash
# Setup script for Linux/macOS
# Automates Python environment and dependency installation

set -e  # Exit on error

echo "============================================================"
echo "  Dependency Upgrade Setup Script"
echo "  Python 3.10+ Backend Data Processing Project"
echo "============================================================"
echo ""

# Check Python version
echo "[1/5] Checking Python version..."
if ! command -v python3 &> /dev/null; then
    echo "  ERROR: python3 not found in PATH"
    echo "  Please install Python 3.10+ from https://www.python.org/"
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "  Found: Python $PYTHON_VERSION"

# Extract major and minor version
PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

if [ "$PYTHON_MAJOR" -lt 3 ] || [ "$PYTHON_MAJOR" -eq 3 -a "$PYTHON_MINOR" -lt 10 ]; then
    echo "  ERROR: Python 3.10+ required. Found: $PYTHON_MAJOR.$PYTHON_MINOR"
    echo "  Please install Python 3.10 or later from https://www.python.org/"
    exit 1
fi
echo "  Version check: PASSED (3.10+)"
echo ""

# Check if virtual environment exists
echo "[2/5] Checking for virtual environment..."
VENV_PATH="venv"
if [ -d "$VENV_PATH" ]; then
    echo "  Virtual environment found at: $VENV_PATH"
    read -p "  Do you want to recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "  Removing existing virtual environment..."
        rm -rf "$VENV_PATH"
        echo "  Creating new virtual environment..."
        python3 -m venv "$VENV_PATH"
        echo "  Virtual environment created!"
    else
        echo "  Using existing virtual environment"
    fi
else
    echo "  Creating virtual environment..."
    python3 -m venv "$VENV_PATH"
    echo "  Virtual environment created!"
fi
echo ""

# Activate virtual environment
echo "[3/5] Activating virtual environment..."
source "$VENV_PATH/bin/activate"
echo "  Virtual environment activated!"
echo ""

# Upgrade pip
echo "[4/5] Upgrading pip..."
python -m pip install --upgrade pip
echo "  pip upgraded successfully!"
echo ""

# Install dependencies
echo "[5/5] Installing dependencies from requirements.txt..."
echo "  This may take a few minutes..."
pip install -r requirements.txt
echo "  All dependencies installed successfully!"
echo ""

echo "============================================================"
echo "  Setup Complete!"
echo "============================================================"
echo ""
echo "Next steps:"
echo "  1. The virtual environment is now active"
echo "  2. Run tests with: ./run_tests.sh"
echo "  3. Or manually: python test_dependencies.py"
echo ""
echo "To activate the environment later, run:"
echo "  source venv/bin/activate"
echo ""
