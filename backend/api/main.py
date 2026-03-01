"""FastAPI application bootstrap for API v1."""

from fastapi import FastAPI

from backend.api.routes.health import router as health_router


def create_app() -> FastAPI:
    """Create and configure the FastAPI application."""
    app = FastAPI(
        title="Social Clean-Up Machine API",
        version="0.1.0",
    )
    app.include_router(health_router)
    return app


app = create_app()
