#!/usr/bin/env bash
set -euo pipefail

if [ ! -d ".venv" ]; then
  echo "Virtual environment missing. Run ./setup.sh first." >&2
  exit 1
fi

# shellcheck disable=SC1091
if [[ "$OSTYPE" == msys* || "$OSTYPE" == win32* ]]; then
  source .venv/Scripts/activate
else
  source .venv/bin/activate
fi

pytest --maxfail=1 --disable-warnings -q "$@"
