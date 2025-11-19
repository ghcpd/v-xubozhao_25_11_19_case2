# Backend Data Processing Project - Dependency Upgrade

This project demonstrates a complete dependency audit and upgrade process for an old Python backend data processing project.

## 📋 Overview

All dependencies have been audited and upgraded from outdated, insecure versions to the latest stable releases compatible with Python 3.10+.

## 🔒 Security Impact

**CRITICAL**: The old dependencies contained 15+ known CVEs spanning 6-7 years. Immediate upgrade recommended.

### Key Changes
- **Flask**: 1.0.2 → 3.0.3 (XSS, RCE vulnerabilities fixed)
- **requests**: 2.19.1 → 2.32.3 (SSL bypass fixed)
- **pandas**: 0.24.2 → 2.2.3 (incompatible with Python 3.10+)
- **numpy**: 1.15.0 → 1.26.4 (buffer overflow fixed)
- **scikit-learn**: 0.20.0 → 1.5.2 (major version upgrade)
- **jinja2**: 2.10 → 3.1.4 (sandbox escape fixed)
- **urllib3**: 1.24.1 → 2.2.3 (CRLF injection fixed)
- **SQLAlchemy**: 1.2.7 → 2.0.35 (SQL injection fixed)

## 📁 Project Structure

```
.
├── requirements.txt          # Updated dependencies (Python 3.10+)
├── requirements.txt.old      # Original dependencies (backup)
├── dependency_diff.md        # Detailed before/after comparison
├── test_dependencies.py      # Comprehensive validation tests
├── setup.ps1                 # Setup script (Windows PowerShell)
├── setup.sh                  # Setup script (Linux/macOS)
├── run_tests.ps1            # Test runner (Windows PowerShell)
├── run_tests.sh             # Test runner (Linux/macOS)
├── logs/                    # Test logs and reports (generated)
└── README.md                # This file
```

## 🚀 Quick Start

### Windows (PowerShell)

```powershell
# 1. Setup environment
.\setup.ps1

# 2. Run tests
.\run_tests.ps1
```

### Linux/macOS

```bash
# 1. Make scripts executable
chmod +x setup.sh run_tests.sh

# 2. Setup environment
./setup.sh

# 3. Run tests
./run_tests.sh
```

### Manual Setup

```bash
# Create virtual environment
python -m venv venv

# Activate (Windows)
.\venv\Scripts\Activate.ps1

# Activate (Linux/macOS)
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run tests
python test_dependencies.py
```

## ✅ Requirements Met

- ✅ **Test data generated** - Uses provided requirements.txt
- ✅ **Reproducible environment** - Virtual environment with pinned versions
- ✅ **Automated test environment** - One-command validation via scripts
- ✅ **Test code** - Comprehensive import and functionality tests
- ✅ **Setup script** - Automated installation (setup.ps1/sh)
- ✅ **Run test script** - Execute tests with logs (run_tests.ps1/sh)

## 📊 Expected Output

### Updated Files
- `requirements.txt` - Safe, upgraded versions
- `dependency_diff.md` - Detailed version comparison with CVE info
- `test_dependencies.py` - Validation test suite

### Generated Files
- `logs/test_run_YYYYMMDD_HHMMSS.log` - Console output
- `logs/test_report_YYYYMMDD_HHMMSS.txt` - Detailed test report

## 🧪 Test Coverage

The test suite validates:

1. **Flask** - App creation, routing, JSON responses
2. **requests** - Session management, adapters, URL utilities
3. **pandas** - DataFrame operations, new concat API, groupby
4. **numpy** - Array operations, linear algebra, new random API
5. **scikit-learn** - Model training, preprocessing, predictions
6. **jinja2** - Template rendering, autoescape security, filters
7. **urllib3** - Pool management, retries, URL parsing
8. **SQLAlchemy** - ORM, new 2.0 query API, CRUD operations

## 📖 Documentation

See `dependency_diff.md` for:
- Detailed vulnerability descriptions
- Breaking changes for each package
- Migration recommendations
- Complete CVE list

## ⚠️ Breaking Changes

Major API changes in:
- **pandas**: `df.append()` → `pd.concat()`
- **SQLAlchemy**: Query API → `select()` statements
- **numpy**: Random API → `np.random.default_rng()`

Review your application code for deprecated APIs before deploying.

## 🔍 System Requirements

- **Python**: 3.10 or higher
- **pip**: Latest version (auto-upgraded by setup scripts)
- **Virtual environment**: Recommended (auto-created by setup scripts)

## 📝 Logs

All test runs generate timestamped logs in the `logs/` directory:
- Full console output
- Package versions
- Environment information
- Test results summary

## 🎯 Success Criteria

Tests pass when all packages:
1. Import successfully
2. Execute basic functionality
3. Use updated APIs correctly
4. Demonstrate security improvements

## 🐛 Troubleshooting

### Tests Fail
- Check Python version (`python --version`)
- Verify virtual environment is active
- Review log files in `logs/` directory
- Ensure all system dependencies are installed

### Import Errors
- Run `pip list` to verify installations
- Check for conflicting packages
- Try recreating virtual environment

### Permission Errors (Linux/macOS)
```bash
chmod +x setup.sh run_tests.sh
```

## 📚 Additional Resources

- [Dependency Diff Report](./dependency_diff.md) - Complete upgrade analysis
- [Python CVE Database](https://cve.mitre.org/)
- [Flask Migration Guide](https://flask.palletsprojects.com/en/3.0.x/changes/)
- [SQLAlchemy 2.0 Migration](https://docs.sqlalchemy.org/en/20/changelog/migration_20.html)

## 📄 License

This is a demonstration project for dependency auditing and upgrade practices.

## 👥 Contributing

This project serves as a template for dependency upgrades. Feel free to adapt the scripts and procedures for your own projects.

---

**Status**: ✅ Ready for testing  
**Last Updated**: 2025-11-19  
**Python Version**: 3.10+
