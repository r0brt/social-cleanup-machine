# 06 Laufzeitsicht

## Szenario 0 — Health-Check (Increment 1)
1. Client ruft `GET /api/v1/health` auf.
2. API-Modul beantwortet den Request ohne Analyse-/Persistenzlogik.
3. Response bestätigt Verfügbarkeit und API-Version (`ok`, `v1`).

## Szenario A — Erfolgsfall
1. UI sendet Text an Backend.
2. Analyse-Modul ruft LLM über Adapter auf.
3. Validator prüft JSON-Vertrag.
4. Ergebnis wird gespeichert und an UI ausgeliefert.

## Szenario B — Repair-Loop
1. Validator erkennt Fehler.
2. Repair-Modul erzeugt korrigierten Lauf.
3. Erneute Validierung.
4. Persistenz mit Status (`valid`, `repaired`, `failed`).

## Sequenzdiagramm
- [Laufzeit-Sequenz (PlantUML)](../diagrams/laufzeit-sequenz.puml)
