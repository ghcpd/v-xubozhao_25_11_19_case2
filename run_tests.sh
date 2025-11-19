#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${ROOT_DIR}/.venv"
PYTHON_BIN="${PYTHON:-python3}"
LOG_DIR="${ROOT_DIR}/logs"
mkdir -p "${LOG_DIR}"

# Ensure venv exists
if [ ! -d "${VENV_DIR}" ]; then
  echo "Virtualenv not found. Run ./setup.sh first." >&2
  exit 1
fi

# Activate
# shellcheck disable=SC1090
source "${VENV_DIR}/bin/activate"

# Version guard (align with setup)
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

# Run pytest smoke suite
pytest -q --disable-warnings --maxfail=1 | tee "${LOG_DIR}/test_run.log"
