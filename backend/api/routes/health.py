"""Health check route for API v1."""

from typing import Literal

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(prefix="/api/v1", tags=["health"])


class HealthResponse(BaseModel):
    """Response contract for the health endpoint."""

    status: Literal["ok"]
    service: str
    api_version: Literal["v1"]


@router.get("/health", response_model=HealthResponse)
def get_health() -> HealthResponse:
    """Return service liveness for API v1."""
    return HealthResponse(
        status="ok",
        service="social-cleanup-machine",
        api_version="v1",
    )
