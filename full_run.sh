#!/usr/bin/env bash
set -euo pipefail

LOG=full_run.log
: > "$LOG"

start_ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
start_s=$(date +%s)

echo "Full run start: $start_ts" | tee -a "$LOG"

# Setup (virtualenv + install) - optionally skip if env exists
if [ ! -d .venv ]; then
  echo "Creating venv and installing dependencies..." | tee -a "$LOG"
  python -m venv .venv 2>&1 | tee -a "$LOG"
  . .venv/bin/activate
  python -m pip install --upgrade pip
  pip install -r requirements.txt 2>&1 | tee -a "$LOG"
else
  echo "Virtual env exists; skipping venv creation" | tee -a "$LOG"
fi

# Run tests
./run_tests.sh 2>&1 | tee -a "$LOG"

end_ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
end_s=$(date +%s)
duration=$((end_s - start_s))

echo "Full run end: $end_ts" | tee -a "$LOG"
echo "Full run duration (s): $duration" | tee -a "$LOG"

echo "Full run complete. Logs in $LOG" | tee -a "$LOG"
