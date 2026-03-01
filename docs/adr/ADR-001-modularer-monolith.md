# ADR-001 — Modularer Monolith als Startarchitektur

## Kontext
Für den MVP der Social Clean-Up Machine müssen Funktionen schnell lieferbar und gleichzeitig sauber strukturiert sein. Eine frühe Verteilung in mehrere Services würde Betriebs- und Integrationsaufwand erhöhen.

## Entscheidung
Die Lösung startet als **modularer Monolith** mit klaren internen Modulgrenzen (UI/API, Analyse, Validierung/Repair, Persistenz). Eine spätere Extraktion in Services bleibt explizit möglich.

## Konsequenzen
- Positiv: schnellere Umsetzung, weniger Infrastrukturkomplexität, einfacheres Debugging.
- Positiv: klare Grundlage für testbare Vertrags- und Domänenlogik.
- Negativ: Skalierung und Teamautonomie sind zunächst an ein Deployable gebunden.
- Negativ: spätere Extraktion erfordert disziplinierte Schnittstellenpflege.
