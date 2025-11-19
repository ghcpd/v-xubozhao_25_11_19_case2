#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_BIN="${PYTHON:-python3}"
VENV_DIR="${ROOT_DIR}/.venv"

# Python version guard
"${PYTHON_BIN}" - <<'PYCODE'
import sys, warnings
min_v=(3,10)
max_excl=(3,13)
ver=sys.version_info
if ver < min_v:
  raise SystemExit(f"Python {min_v[0]}.{min_v[1]}+ required, got {sys.version.split()[0]}")
if ver >= max_excl:
  warnings.warn(f"Python {sys.version.split()[0]} is above tested range (<{max_excl[0]}.{max_excl[1]}). Some dependencies may be skipped.")
PYCODE

# Create virtual environment if needed
if [ ! -d "${VENV_DIR}" ]; then
  echo "Creating virtual environment at ${VENV_DIR}"
  "${PYTHON_BIN}" -m venv "${VENV_DIR}"
fi

# Activate
# shellcheck disable=SC1090
source "${VENV_DIR}/bin/activate"

# Upgrade pip and install deps
pip install --upgrade pip
pip install -r "${ROOT_DIR}/requirements.txt"

echo "✅ Environment ready. Activate with: source .venv/bin/activate"
