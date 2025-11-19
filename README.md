# Dependency Upgrade Audit & Test

This workspace contains an audited and updated `requirements.txt`, a minimal demo test, and setup scripts to validate the environment.

Steps:

1. Setup (POSIX):
   - sh ./setup.sh
2. Run tests (POSIX):
   - sh ./run_tests.sh

On Windows PowerShell:

1. Setup: .\setup.ps1
2. Run tests: .\run_tests.ps1

Output is logged to `logs/test_output.log`.

See `dependency_diff.md` for details on version upgrades and reasoning.