# 06 Laufzeitsicht

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
