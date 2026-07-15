"""API integration tests."""

from ganga_aqua.services.auth import hash_api_key


def test_health(api_client):
    resp = api_client.get("/health")
    assert resp.status_code == 200
    assert resp.json()["status"] == "ok"


def test_stations(api_client):
    resp = api_client.get("/api/v1/stations")
    assert resp.status_code == 200
    data = resp.json()
    assert len(data) >= 5
    assert "name" in data[0]


def test_latest_readings(api_client):
    resp = api_client.get("/api/v1/readings/latest")
    assert resp.status_code == 200
    data = resp.json()
    assert len(data) >= 1
    assert "dissolved_oxygen_mg_l" in data[0]


def test_deficiency(api_client):
    resp = api_client.get("/api/v1/deficiency")
    assert resp.status_code == 200
    assert isinstance(resp.json(), list)


def test_unauthorized():
    from fastapi.testclient import TestClient

    from ganga_aqua.api.app import create_app

    client = TestClient(create_app())
    resp = client.get("/api/v1/stations")
    assert resp.status_code == 401


def test_hash_api_key_deterministic():
    h1 = hash_api_key("same-key")
    h2 = hash_api_key("same-key")
    assert h1 == h2
    assert h1 != hash_api_key("other-key")
