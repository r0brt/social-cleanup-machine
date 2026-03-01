# 03 Kontext und Abgrenzung

## Fachlicher Kontext
Primärer Akteur ist die Nutzerperson, die einen Problemtext eingibt und eine strukturierte Sechs-Ebenen-Analyse erhält.

## Technischer Kontext
- Frontend sendet Analyse-Anfrage an Backend
- Backend orchestriert LLM-Aufruf, Validierung und Repair-Loop
- Ergebnisse werden persistent gespeichert

## Kontextdiagramme
- [Kontextdiagramm (PlantUML)](../diagrams/c4-kontext.puml)

## Abgrenzung
Nicht Teil des MVP sind automatisierte Faktenprüfung, Multi-Tenant-Betrieb und produktiver Microservice-Betrieb.
