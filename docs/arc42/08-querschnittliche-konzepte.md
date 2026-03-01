# 08 Querschnittliche Konzepte

## Vertrags- und Datenkonsistenz
- Striktes JSON-Schema als technischer Vertrag
- Formale Validierung je Analyse-Lauf
- Repair-Loop mit begrenzten Versuchen

## Beobachtbarkeit und Nachvollziehbarkeit
- Laufstatus und Fehlergründe werden protokolliert
- Analyseverläufe sind persistent nachvollziehbar

## Sicherheit (MVP-Basis)
- Eingaben validieren
- Keine Secrets in Dokumentation/Code

## Dokumentations-Governance (fortlaufende Aktualisierung)
- Bei Verhaltens- oder Contract-Änderungen werden `docs/PRD.md` und die relevanten arc42-Kapitel im selben Change aktualisiert.
- Bei Architekturentscheidungen ist ein ADR in `docs/adr/` verpflichtend.
- Bei Änderungen an Ablauf, Reihenfolge oder Lieferlogik wird `PLAN.md` aktualisiert.
- Diese Pflegepflicht ist Bestandteil der Definition of Done und wird im Review aktiv geprüft.
