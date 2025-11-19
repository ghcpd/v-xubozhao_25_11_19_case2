# Dependency Version Diff

This report captures the dependency upgrades performed on November 19, 2025 to ensure Python 3.10+ compatibility, resolve known security issues, and align with actively maintained releases.

| Package | Previous Version | Updated Version | Key Benefits |
|---------|------------------|-----------------|--------------|
| Flask | 1.0.2 | 3.0.3 | Restores security fixes (CVE-2019-1010083), adds async support, and maintains Python 3.10 compatibility. |
| requests | 2.19.1 | 2.32.3 | Fixes multiple SSL and redirect handling bugs, adds Python 3.11 wheels, depends on modern urllib3. |
| pandas | 0.24.2 | 2.2.2 | Provides vectorized fixes, modern parquet backends, and Python 3.10 wheels; drops Python 2 code paths. |
| numpy | 1.15.0 | 1.26.4 | Eliminates memory-safety CVEs, adds SIMD optimizations, and is the minimum supported by pandas/scikit-learn. |
| scikit-learn | 0.20.0 | 1.5.1 | Replaces unsupported build, adds refreshed estimators and Python 3.10 wheels; requires modern numpy/scipy. |
| scipy | — | 1.13.1 | New runtime dependency for scikit-learn providing optimized BLAS/LAPACK routines with Python 3.10 wheels. |
| joblib | — | 1.4.2 | Ensures deterministic parallelism for scikit-learn and resolves joblib <1.2 race condition. |
| Jinja2 | 2.10 | 3.1.4 | Patches template sandbox escapes (CVE-2019-10906) and aligns with Flask 3.x. |
| urllib3 | 1.24.1 | 2.2.3 | Fixes request smuggling (CVE-2020-26137) and provides TLS 1.3 support. |
| SQLAlchemy | 1.2.7 | 2.0.32 | Gains SQL Injection hardening (CVE-2019-7164) and modern 2.0 API with greenlet fixes. |
| pytest | — | 8.2.1 | Adds modern test runner for validation on Python 3.10+ environments. |

## Compatibility Notes

- Python 3.10+ is now fully supported across numeric, web, and database layers.
- Transitive dependencies automatically align with the listed versions and modern packaging standards (PEP 517 wheels).
- NumPy/Scipy/Scikit-learn versions are mutually compatible per the official release matrices (NumPy ≥1.23 and SciPy ≥1.8).

## Follow-up Recommendations

- Rebuild any vendored C extensions against the new NumPy/SciPy ABI.
- Review application code for SQLAlchemy 2.0 API adaptations (session handling and select syntax).
- Consider pinning `python-dateutil` and `pytz` if pandas integrations require deterministic behavior.
