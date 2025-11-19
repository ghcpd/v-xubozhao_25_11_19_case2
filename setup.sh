#!/usr/bin/env bash
set -euo pipefail

PYTHON_BIN="${PYTHON_BIN:-python}"
if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  PYTHON_BIN=python3
fi

if [ ! -d ".venv" ]; then
  "$PYTHON_BIN" -m venv .venv
fi

# shellcheck disable=SC1091
if [[ "$OSTYPE" == msys* || "$OSTYPE" == win32* ]]; then
  source .venv/Scripts/activate
else
  source .venv/bin/activate
fi

pip install --upgrade pip
pip install --require-virtualenv -r requirements.txt
