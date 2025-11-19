#!/usr/bin/env bash
set -euo pipefail

echo "Creating and activating virtual env (venv) in .venv..."
python -m venv .venv
# shellcheck disable=SC1091
. .venv/bin/activate

echo "Upgrading pip and installing requirements..."
python -m pip install --upgrade pip
pip install -r requirements.txt

echo "Setup complete. Use '. .venv/bin/activate' to activate the environment."