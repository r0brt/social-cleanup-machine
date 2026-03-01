# 05 Bausteinsicht

## Primäre Bausteine (MVP)
- **UI-Modul**: Eingabe, Status, Pipeline-Darstellung, Ergebnisansicht
- **API-Modul**: Request/Response, Orchestrierung; initialer Bootstrap mit versioniertem Health-Endpoint `GET /api/v1/health`
- **Analyse-Modul**: Prompting, LLM-Adapter, Parsing
- **Validierungs-Modul**: JSON-Schema- und Regelprüfung
- **Repair-Modul**: Korrekturschleife bei Vertragsverletzung
- **Persistenz-Modul**: Ablage von Input, Output, Läufen

## Initiale Backend-Komponenten (Increment 1)
- **`backend/api/main.py`**: FastAPI-App-Bootstrap und Router-Registrierung
- **`backend/api/routes/health.py`**: API-v1-Health-Route als technische Betriebsprüfung

## Baustein-Diagramme
- [Container/Bausteine (PlantUML)](../diagrams/c4-container.puml)
- [Komponenten (PlantUML)](../diagrams/c4-komponenten.puml)
