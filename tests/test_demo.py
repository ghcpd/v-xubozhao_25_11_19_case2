def test_basic_imports_and_numpy_sum():
    import importlib
    np = importlib.import_module('numpy')
    pd = importlib.import_module('pandas')
    requests = importlib.import_module('requests')
    flask = importlib.import_module('flask')

    assert hasattr(np, 'array')
    assert pd.DataFrame({'a':[1]}).shape == (1,1)
    assert hasattr(requests, 'get')
    assert hasattr(flask, 'Flask')

    arr = np.array([1,2,3])
    assert int(arr.sum()) == 6
