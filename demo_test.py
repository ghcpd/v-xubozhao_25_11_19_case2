"""Demo test to verify upgraded libraries import and basic functionality."""
import sys
import importlib
import traceback

packages = [
    ("flask", "Flask"),
    ("requests", "utils"),
    ("pandas", "DataFrame"),
    ("numpy", "array"),
    ("sklearn", "__version__"),
    ("jinja2", "Template"),
    ("urllib3", "__version__"),
    ("sqlalchemy", "create_engine"),
]

results = []

print("Python:", sys.version)
for pkg, symbol in packages:
    try:
        mod = importlib.import_module(pkg)
        # Basic smoke checks
        ok = hasattr(mod, symbol) or (getattr(mod, symbol, None) is not None)
        results.append((pkg, True, f"Found {symbol}"))
    except Exception as e:
        results.append((pkg, False, str(e)))

# Additional function tests
try:
    import numpy as np
    arr = np.array([1,2,3])
    print("numpy OK, sum:", arr.sum())
except Exception as e:
    print("numpy test failed:", e)

try:
    import pandas as pd
    df = pd.DataFrame({"a":[1,2], "b":[3,4]})
    print("pandas OK, shape:", df.shape)
except Exception as e:
    print("pandas test failed:", e)

try:
    from sklearn.linear_model import LogisticRegression
    print("sklearn OK, LogisticRegression available")
except Exception as e:
    print("sklearn test failed:", e)

try:
    from jinja2 import Template
    tmpl = Template("Hello {{ name }}")
    print(tmpl.render(name="Test"))
except Exception as e:
    print("jinja2 test failed:", e)

try:
    from sqlalchemy import create_engine, text
    engine = create_engine("sqlite:///:memory:")
    with engine.connect() as conn:
        conn.execute(text("SELECT 1"))
    print("sqlalchemy OK - in-memory DB")
except Exception as e:
    print("sqlalchemy test failed:", e)

# Print results summary

def main():
    print('\nSummary:')
    for pkg, ok, msg in results:
        print(f" - {pkg}: {'OK' if ok else 'FAILED'} - {msg}")

    if any(not ok for _, ok, _ in results):
        print('\nSome tests failed; check logs above')
        return 2
    else:
        print('\nAll basic import checks passed')
        return 0

if __name__ == "__main__":
    status = main()
    sys.exit(status)
