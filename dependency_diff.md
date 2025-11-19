# Dependency Version Diff (Before → After)

| Package        | Before        | After          | Status (Old)                                      | Notes / Rationale |
|----------------|---------------|----------------|--------------------------------------------------|-------------------|
| Flask          | 1.0.2         | 3.0.3          | Outdated; depends on vulnerable Jinja2           | Upgrade fixes security issues via dependency updates; Python 3.10+ support |
| Jinja2         | 2.10          | 3.1.4          | **CVE-2019-10906** (XSS)                         | Upgrade to patched version |
| requests       | 2.19.1        | 2.32.3         | **CVE-2018-18074** (Auth header leak)            | Latest stable, Py3.10 compatible |
| urllib3        | 1.24.1        | 2.2.3          | **CVE-2019-11236**, **CVE-2021-33503**           | Align with requests, patched |
| pandas         | 0.24.2        | 2.2.2          | EOL; no Py3.10 wheels                            | Modern DataFrame API, Py3.10+ (≤3.12). Marked `<3.13` |
| numpy          | 1.15.0        | 1.26.4         | EOL; incompatible with Py3.10+                   | Required by pandas; Py3.10+ (≤3.12). Marked `<3.13` |
| scikit-learn   | 0.20.0        | 1.4.2          | EOL; no Py3.10 wheels                            | Modern ML toolkit; Py3.10+ (≤3.12). Marked `<3.13` |
| **scipy** *(new)* | —             | 1.11.4         | Missing required dependency                       | scikit-learn runtime dependency; Py3.10+ (≤3.12). Marked `<3.13` |
| SQLAlchemy     | 1.2.7         | 2.0.36         | **CVE-2019-9769** (SQL injection via ORDER BY)   | Upgrade to patched series; modern API |

## Compatibility
- Recommended Python: **3.10–3.12** (current ecosystem support). Python **3.13** is not yet supported by pandas/scipy/scikit-learn; markers prevent installation on 3.13+.

## Security Highlights
- **requests**: CVE-2018-18074 (auth header leak on redirect) addressed by upgrading.
- **Jinja2**: CVE-2019-10906 (XSS in `|tojson` filter) fixed in 2.10.1+; 3.1.4 used.
- **urllib3**: CVE-2019-11236 (CRLF injection) & CVE-2021-33503 (chunked head injection) patched in 1.26.5+; 2.2.3 used.
- **SQLAlchemy**: CVE-2019-9769 (SQL injection in `order_by(text(...))`) fixed in 1.3.0b2+; 2.0.x used.

## Notes
- `scipy` is added because `scikit-learn` requires it at runtime.
- If you must run on Python 3.13+, consider waiting for upstream wheels or using pre-releases; adjust markers accordingly.
