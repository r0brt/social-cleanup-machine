# ADR-003 — Strikter JSON-Contract mit Repair-Loop

## Kontext
LLM-Ausgaben können formal inkonsistent sein. Für Persistenz, UI-Darstellung und Wiederholbarkeit braucht SCM ein stabiles, maschinenlesbares Ausgabeformat.

## Entscheidung
SCM erzwingt einen **strikten JSON-Contract** inkl. Schema-Validierung. Bei Verstössen wird ein **Repair-Loop** mit begrenzten Versuchen ausgeführt, bevor ein Lauf als `failed` markiert wird.

## Konsequenzen
- Positiv: höhere Zuverlässigkeit und Vergleichbarkeit der Ergebnisse.
- Positiv: reduzierte Fehler in nachgelagerten Schritten (Persistenz/UI).
- Positiv: transparente Fehlersignale und nachvollziehbare Laufzustände.
- Negativ: zusätzlicher Latenz- und Implementierungsaufwand bei fehlerhaften Antworten.
