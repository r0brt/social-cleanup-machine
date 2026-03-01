# 11 Risiken und technische Schulden

## Hauptrisiken
- Instabile LLM-Ausgabeformate
- Unvollständige oder inkonsistente Ebenenresultate
- Zu frühe Service-Extraktion erhöht Komplexität

## Technische Schulden (bewusst)
- Start als Monolith zugunsten schneller Lern- und Lieferfähigkeit
- Service-Aufteilung wird explizit auf später verschoben

## Gegenmassnahmen
- Schema + Validator + Repair-Loop
- ADR-basierte Entscheidungsnachverfolgung
- Iterative Qualitätssicherung mit Testnachweisen
