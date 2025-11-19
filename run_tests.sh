#!/usr/bin/env bash
set -euo pipefail

LOG=tests.log
: > "$LOG"

start_ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
start_s=$(date +%s)

echo "Test run start: $start_ts" | tee -a "$LOG"

echo "Running demo tests..." | tee -a "$LOG"
set +e
python demo_test.py 2>&1 | tee -a "$LOG"
rc=${PIPESTATUS[0]}
set -e

end_ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
end_s=$(date +%s)
duration=$((end_s - start_s))

echo "Test run end: $end_ts" | tee -a "$LOG"
echo "Duration (s): $duration" | tee -a "$LOG"

if [ $rc -ne 0 ]; then
  echo "Demo test exit code: $rc" | tee -a "$LOG"
  exit $rc
fi

echo "Test run end: $end_ts" | tee -a "$LOG"
echo "Duration (s): $duration" | tee -a "$LOG"

echo "Tests finished. Logs written to $LOG"
