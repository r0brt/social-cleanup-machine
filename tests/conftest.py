"""Pytest fixtures for API tests."""

from collections.abc import Iterator

import pytest
from fastapi.testclient import TestClient

from backend.api.main import create_app


@pytest.fixture()
def client() -> Iterator[TestClient]:
    """Provide a test client bound to the FastAPI app."""
    with TestClient(create_app()) as test_client:
        yield test_client
