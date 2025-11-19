import numpy as np
import pandas as pd
import requests
from flask import Flask
import jinja2
import joblib
import urllib3
import sqlalchemy as sa
from scipy import special
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LinearRegression
import pytest


def test_numpy_pandas_roundtrip():
    data = np.arange(6).reshape(3, 2)
    frame = pd.DataFrame(data, columns=["a", "b"])
    frame["total"] = frame.sum(axis=1)
    grouped = frame.groupby("total").size()
    expected_totals = {1, 5, 9}
    assert set(grouped.index) == expected_totals
    assert grouped.loc[1] == 1


def test_sklearn_pipeline():
    x = np.linspace(0, 10, 20).reshape(-1, 1)
    y = 2 * x.squeeze() + 1
    model = make_pipeline(StandardScaler(with_mean=True), LinearRegression())
    model.fit(x, y)
    prediction = model.predict([[5.0]])[0]
    assert prediction == pytest.approx(11.0, rel=1e-3)


def test_flask_request_stack():
    app = Flask(__name__)

    @app.get("/ping")
    def ping():
        return {"status": "ok"}

    with app.test_client() as client:
        response = client.get("/ping")
        assert response.status_code == 200
        assert response.get_json()["status"] == "ok"



def test_sqlalchemy_roundtrip():
    engine = sa.create_engine("sqlite+pysqlite:///:memory:", future=True)
    metadata = sa.MetaData()
    table = sa.Table(
        "items",
        metadata,
        sa.Column("id", sa.Integer, primary_key=True),
        sa.Column("value", sa.Integer, nullable=False),
    )
    metadata.create_all(engine)
    with engine.begin() as connection:
        connection.execute(sa.insert(table), [{"value": 1}, {"value": 2}])
        total = connection.execute(sa.select(sa.func.sum(table.c.value))).scalar_one()
    assert total == 3


def test_requests_stack_without_network():
    req = requests.Request("GET", "https://example.com", params={"q": "test"})
    prepared = req.prepare()
    assert prepared.url.endswith("q=test")
    parsed = urllib3.util.parse_url(prepared.url)
    assert parsed.scheme == "https"


def test_jinja2_and_scipy_joblib():
    template = jinja2.Template("Hello {{ name }}!")
    rendered = template.render(name="World")
    assert rendered == "Hello World!"

    logits = np.array([0.1, 1.0, 2.0])
    probabilities = special.softmax(logits)
    assert np.isclose(probabilities.sum(), 1.0)

    squared = joblib.Parallel(n_jobs=1)(joblib.delayed(lambda v: v * v)(value) for value in range(3))
    assert squared == [0, 1, 4]
