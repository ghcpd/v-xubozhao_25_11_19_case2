#!/bin/bash
# Run tests script for Linux/macOS
# Executes validation tests and generates logs

set -e  # Exit on error

echo "============================================================"
echo "  Dependency Validation Test Runner"
echo "============================================================"
echo ""

# Create logs directory
LOGS_DIR="logs"
if [ ! -d "$LOGS_DIR" ]; then
    echo "Creating logs directory..."
    mkdir -p "$LOGS_DIR"
fi

# Generate timestamp for log file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$LOGS_DIR/test_run_$TIMESTAMP.log"
REPORT_FILE="$LOGS_DIR/test_report_$TIMESTAMP.txt"

echo "Log file: $LOG_FILE"
echo "Report file: $REPORT_FILE"
echo ""

# Check if virtual environment is activated
echo "Checking environment..."
if [ -z "$VIRTUAL_ENV" ]; then
    echo "  Virtual environment not activated!"
    echo "  Attempting to activate..."
    
    VENV_PATH="venv"
    if [ -f "$VENV_PATH/bin/activate" ]; then
        source "$VENV_PATH/bin/activate"
        echo "  Virtual environment activated!"
    else
        echo "  ERROR: Virtual environment not found"
        echo "  Please run setup.sh first"
        exit 1
    fi
else
    echo "  Virtual environment: Active"
fi
echo ""

# Run tests and capture output
echo "Running tests..."
echo "============================================================"
echo ""

# Run tests with output to both console and log file
set +e  # Don't exit on test failure
python test_dependencies.py 2>&1 | tee "$LOG_FILE"
TEST_EXIT_CODE=$?
set -e

echo ""
echo "============================================================"

# Generate summary report
echo ""
echo "Generating test report..."

cat > "$REPORT_FILE" <<EOF
============================================================
DEPENDENCY VALIDATION TEST REPORT
============================================================
Date: $(date +"%Y-%m-%d %H:%M:%S")
Python Version: $(python --version 2>&1)
Log File: $LOG_FILE
============================================================

TEST RESULTS:
$(if [ $TEST_EXIT_CODE -eq 0 ]; then echo "Status: ALL TESTS PASSED ✅"; else echo "Status: SOME TESTS FAILED ❌"; fi)
Exit Code: $TEST_EXIT_CODE

============================================================
FULL OUTPUT:
============================================================
$(cat "$LOG_FILE")
============================================================

INSTALLED PACKAGES:
============================================================
$(pip list)
============================================================

ENVIRONMENT INFO:
============================================================
Virtual Environment: $VIRTUAL_ENV
Python Path: $(python -c "import sys; print(sys.executable)")
Platform: $(uname -a)
============================================================
EOF

echo "Test report saved to: $REPORT_FILE"
echo ""

# Final summary
echo "============================================================"
echo "  Test Execution Complete"
echo "============================================================"
echo ""

if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "Result: ALL TESTS PASSED ✅"
    echo ""
    echo "All upgraded dependencies are working correctly!"
    echo "You can now safely use the upgraded environment."
else
    echo "Result: SOME TESTS FAILED ❌"
    echo ""
    echo "Some tests failed. Please review:"
    echo "  - Log file: $LOG_FILE"
    echo "  - Report file: $REPORT_FILE"
    echo ""
    echo "Common issues:"
    echo "  - Missing system dependencies"
    echo "  - Network issues during package installation"
    echo "  - Incompatible Python version"
fi

echo ""
echo "Files generated:"
echo "  - $LOG_FILE"
echo "  - $REPORT_FILE"
echo ""

exit $TEST_EXIT_CODE
