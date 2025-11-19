import sys
import importlib

print("Starting demo tests for upgraded dependencies")

# Packages to check
packages = [
    ('flask', 'Flask'),
    ('requests', 'requests'),
    ('pandas', 'pandas'),
    ('numpy', 'numpy'),
    ('sklearn', 'sklearn'),
    ('jinja2', 'jinja2'),
    ('urllib3', 'urllib3'),
    ('sqlalchemy', 'sqlalchemy'),
]

imported = {}

for pkg_name, module in packages:
    try:
        mod = importlib.import_module(pkg_name)
        ver = getattr(mod, '__version__', 'n/a')
        print(f"Imported {pkg_name} {ver}")
        imported[pkg_name] = True
    except Exception as e:
        print(f"Warning: Failed to import {pkg_name}: {e}")
        imported[pkg_name] = False

# Minimal functional checks with graceful degradation
# 1) Flask: create app
if imported.get('flask'):
    try:
        from flask import Flask
        app = Flask(__name__)
        with app.test_request_context('/'):
            assert app is not None
        print('Flask OK')
    except Exception as e:
        print('Flask functional test failed:', e)

# 2) Jinja2
if imported.get('jinja2'):
    try:
        from jinja2 import Template
        template = Template('Hello {{name}}')
        rendered = template.render(name='Test')
        assert 'Hello Test' in rendered
        print('Jinja2 OK')
    except Exception as e:
        print('Jinja2 functional test failed:', e)

# 3) Requests - we won't hit the network; just check utils
if imported.get('requests'):
    try:
        import requests
        headers = requests.utils.default_headers()
        print('Requests OK: Default headers length', len(headers))
    except Exception as e:
        print('Requests functional test failed:', e)

# 4) Numpy & Pandas
if imported.get('numpy'):
    try:
        import numpy as np
        arr = np.array([1, 2, 3])
        assert arr.sum() == 6
        print('NumPy OK')
    except Exception as e:
        print('NumPy functional test failed:', e)
else:
    print('NumPy not installed; skipping tests for NumPy/pandas')

if imported.get('pandas'):
    try:
        import pandas as pd
        df = pd.DataFrame({'a': [1,2], 'b': [3,4]})
        assert df['a'].sum() == 3
        print('Pandas OK')
    except Exception as e:
        print('Pandas functional test failed:', e)

# 5) scikit-learn - fit a tiny model
if imported.get('sklearn'):
    try:
        from sklearn.linear_model import LogisticRegression
        from sklearn.datasets import load_iris
        X, y = load_iris(return_X_y=True)
        model = LogisticRegression(max_iter=200)
        model.fit(X, y)
        preds = model.predict(X[:5])
        assert len(preds) == 5
        print('scikit-learn OK')
    except Exception as e:
        print('scikit-learn functional test failed:', e)

# 6) SQLAlchemy - in-memory operation
if imported.get('sqlalchemy'):
    try:
        from sqlalchemy import create_engine, MetaData, Table, Column, Integer
        engine = create_engine('sqlite:///:memory:')
        meta = MetaData()
        users = Table('users', meta,
                    Column('id', Integer, primary_key=True))
        meta.create_all(engine)
        print('SQLAlchemy OK')
    except Exception as e:
        print('SQLAlchemy functional test failed:', e)

print('Demo tests completed - some modules may have been skipped if they failed to install or import')
