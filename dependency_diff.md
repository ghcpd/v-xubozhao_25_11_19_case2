# Dependency Diff Report

This document captures the Before → After dependency changes and rationale.

## Before (old versions from original requirements.txt)

- Flask==1.0.2
- requests==2.19.1
- pandas==0.24.2
- numpy==1.15.0
- scikit-learn==0.20.0
- jinja2==2.10
- urllib3==1.24.1
- SQLAlchemy==1.2.7

## After (upgraded versions)

- Flask==2.2.5  # Flask 1.x is no longer maintained; 2.2.x supports Python 3.10
- requests==2.31.0  # Security and compatibility updates
- pandas==1.5.3  # Compatible with Python 3.10, avoids pandas 2.0 API migrations
- numpy==1.24.4  # Modern numpy supporting Python 3.10
- scikit-learn==1.2.2  # Requires newer numpy, supports Python 3.10
- jinja2==3.1.2  # Security fixes and Flask compatibility
- urllib3==1.26.16  # Fixes CVEs and supports recent Python versions
- SQLAlchemy==1.4.49  # 1.4 is stable long-term support; works with Python 3.10

## Rationale

- Upgrades selected to balance stability and Python 3.10 compatibility.
- Avoids major breaking changes (e.g., pandas 2.x) while addressing security CVEs in urllib3 and requests.

## Next steps

- Run the provided demo test (`run_tests.sh`) to validate imports and a few runtime checks.
- Review any project-specific code for API changes between major versions, particularly for Flask, pandas, and SQLAlchemy.
