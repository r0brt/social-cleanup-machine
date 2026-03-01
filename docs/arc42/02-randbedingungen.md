# 02 Randbedingungen

## Technische Randbedingungen
- Start als modularer Monolith
- Ziel-Stack: Python (FastAPI) mit PostgreSQL
- Keine Architekturkopplung an verteilte Services im MVP

## Versionierte technische Randbedingungen
- Python `3.12.x`
- Node.js `20.x (LTS)`
- PostgreSQL `16.x`
- FastAPI `0.115.x`
- Pydantic `2.8.x`
- SQLAlchemy `2.0.x`
- Alembic `1.13.x`
- React `18.x`
- TypeScript `5.6.x`
- Vite `5.x`

Regel: Versionsänderungen erfolgen nur bewusst und werden synchron in `docs/PRD.md`, `AGENTS.md` und diesem Kapitel gepflegt.

## Organisatorische Randbedingungen
- Dokumentationsstandard: arc42 als Docs-as-Code
- Sprache: Deutsch (de-CH kompatibel)
- PRD bleibt führend für Scope und Akzeptanz

## Qualitäts- und Liefergrenzen
- Fokus auf MVP gemäß PRD
- Keine Vorwegnahme von nicht bestätigten Zusatzfeatures
