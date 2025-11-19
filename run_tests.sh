#!/usr/bin/env sh
set -e

# Ensure venv exists
if [ ! -d ".venv" ]; then
  echo "Virtualenv not found. Run setup.sh first."
  exit 1
fi

. .venv/bin/activate
mkdir -p logs
python demo_test.py | tee logs/test_output.log

echo "Tests completed. See logs/test_output.log for output."