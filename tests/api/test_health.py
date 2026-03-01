"""Tests for the API v1 health endpoint."""

from fastapi.testclient import TestClient


def test_health_endpoint_returns_service_status(client: TestClient) -> None:
    """The health endpoint returns a stable v1 contract."""
    response = client.get("/api/v1/health")

    assert response.status_code == 200
    assert response.json() == {
        "status": "ok",
        "service": "social-cleanup-machine",
        "api_version": "v1",
    }
