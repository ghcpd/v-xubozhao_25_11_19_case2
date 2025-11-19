import threading
import time
import socket

import pytest


def _start_flask_app(app, host="127.0.0.1", port=5001):
    app.run(host=host, port=port, debug=False, use_reloader=False)


def test_flask_and_requests_basic():
    """Smoke test for Flask app and requests (no external network)."""
    from flask import Flask, jsonify
    import requests

    app = Flask(__name__)

    @app.route("/ping")
    def ping():
        return jsonify({"status": "ok"})

    # Pick a free port
    sock = socket.socket()
    sock.bind(("127.0.0.1", 0))
    host, port = sock.getsockname()
    sock.close()

    # Start Flask in background thread
    server = threading.Thread(target=_start_flask_app, args=(app, host, port), daemon=True)
    server.start()
    time.sleep(0.5)  # give server a moment to start

    resp = requests.get(f"http://{host}:{port}/ping", timeout=5)
    assert resp.status_code == 200
    assert resp.json()["status"] == "ok"


def test_pandas_numpy_dataframe():
    pandas = pytest.importorskip("pandas", reason="pandas not installed for this Python version")
    np = pytest.importorskip("numpy", reason="numpy not installed for this Python version")

    df = pandas.DataFrame({"a": np.arange(5), "b": np.arange(5) * 2})
    assert df.shape == (5, 2)
    assert df["b"].iloc[3] == 6


def test_sklearn_logistic_regression():
    sklearn = pytest.importorskip("sklearn", reason="scikit-learn not installed for this Python version")
    pytest.importorskip("scipy", reason="scipy not installed for this Python version")

    from sklearn.linear_model import LogisticRegression

    X = [[0, 0], [1, 1], [1, 0], [0, 1]]
    y = [0, 1, 1, 0]
    clf = LogisticRegression(max_iter=100)
    clf.fit(X, y)
    preds = clf.predict([[0, 0], [1, 1]])
    assert preds.tolist() == [0, 1]


def test_sqlalchemy_sqlite_roundtrip():
    import sqlalchemy as sa

    engine = sa.create_engine("sqlite+pysqlite:///:memory:", future=True)
    with engine.begin() as conn:
        conn.exec_driver_sql("CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT)")
        conn.exec_driver_sql("INSERT INTO items (name) VALUES ('foo'), ('bar')")
        rows = conn.exec_driver_sql("SELECT name FROM items ORDER BY id").fetchall()
    assert [r[0] for r in rows] == ["foo", "bar"]
