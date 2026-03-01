"""Contract tests for API v1 health endpoint."""

from fastapi.testclient import TestClient


def test_health_contract_shape(client: TestClient) -> None:
    """The health contract exposes only the expected v1 fields and values."""
    response = client.get("/api/v1/health")

    assert response.status_code == 200
    payload = response.json()

    assert set(payload.keys()) == {"status", "service", "api_version"}
    assert payload["status"] == "ok"
    assert payload["service"] == "social-cleanup-machine"
    assert payload["api_version"] == "v1"
