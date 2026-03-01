# ADR-002 — LLM-Anbindung über Adapter

## Kontext
Die Analysefunktion hängt von einem externen LLM ab. Direkte Provider-Kopplung im Kerncode erschwert Austausch, Tests und Fehlersimulation.

## Entscheidung
Die LLM-Kommunikation wird über ein **Adapter-Interface** gekapselt. Der Anwendungsfluss arbeitet gegen das Interface, nicht gegen eine konkrete Provider-Implementierung.

## Konsequenzen
- Positiv: austauschbare Provider-Implementierungen ohne Kernumbau.
- Positiv: bessere Testbarkeit durch Mock/Fake-Adapter.
- Positiv: klare Trennung zwischen Domänenlogik und externer API.
- Negativ: zusätzlicher Abstraktionslayer erhöht initialen Implementierungsaufwand.
