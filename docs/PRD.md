# PRD — Social Clean-Up Machine (SCM)

- Version: 0.1
- Owner: Robert Hämmerli
- Date: 2026-02-27

## 1. Kontext & Problem
Öffentliche und organisatorische Diskussionen vermischen oft Beobachtungen, Erklärungen, Emotionen und interpretative Zuschreibungen. Dadurch entstehen Missverständnisse, verkürzte Schlussfolgerungen und Massnahmen, die nicht am Kern eines Problems ansetzen.

SCM adressiert das Bedürfnis, frei formulierte Problemtexte systematisch zu entflechten und argumentative Ebenen transparent zu trennen.

## 2. Vision
SCM ist ein Instrument zur strukturellen Klärung komplexer gesellschaftlicher Problemstellungen. Die Applikation trennt argumentative Ebenen sichtbar voneinander, ohne den Inhalt zu bewerten. Ziel ist Nachvollziehbarkeit und Differenzierung in Analyse, Diskussion und Entscheidungsfindung.

## 3. Ziele (Outcomes)
- **G1 — Strukturierte Entflechtung:** Ein Problemtext wird in sechs Ebenen zerlegt, sodass Vermischungen sichtbar werden.
- **G2 — Reproduzierbarkeit:** Analyse erfolgt in einer geführten, überprüfbaren Verarbeitungskette (nicht als einmalige Chat-Antwort).
- **G3 — Weiterverarbeitbarkeit:** Resultate sind maschinenlesbar (JSON) und persistierbar.
- **G4 — Didaktische Darstellung:** Die Ebenen werden als Filter-/Reinigungsstrecke visuell nachvollziehbar dargestellt.

## 4. Nicht-Ziele (Explizit)
- **NG1:** Keine inhaltliche Bewertung (keine „Wahrheit“, kein Fact-Checking).
- **NG2:** Keine politische Positionierung oder Empfehlung von Massnahmen.
- **NG3:** Kein vollwertiges Diskursanalyse-Forschungstool (z. B. Korpus, Quellenvergleich) im MVP.
- **NG4:** Keine Benutzerverwaltung/Mehrmandantenfähigkeit im MVP.

## 5. Zielgruppen & Stakeholder
- **Primary**
  - Studierende & Lehrpersonen (didaktische Argumentations-/Diskursanalyse)
- **Secondary**
  - Organisationen (strukturiertes Aufarbeiten interner/externer Problemtexte)
  - Fachpersonen KI-gestützte SWE (Demonstrator für kontrollierten KI-Einsatz)
- **Tertiary**
  - Bildungsinstitutionen (Seminar-/Methodentraining)

## 6. User Journeys (MVP)
- **UJ1 — Analyse eines Problemtexts**
  1. Nutzer erfasst Problemtext.
  2. System führt Analysepipeline aus (6 Ebenen).
  3. System validiert Output (Schema + Konsistenz).
  4. System zeigt Resultate als Filterstrecke.
  5. System speichert Input + Resultat.

- **UJ1a — Sprachregel**
  1. Input-Sprache bestimmt Output-Sprache.
  2. Bei gemischter Sprache wird dominante Sprache ermittelt.
  3. Bei zu geringer Erkennungssicherheit wird der Lauf mit verständlicher Fehlermeldung beendet.

- **UJ2 — Wiederfinden**
  1. Nutzer wählt eine frühere Analyse.
  2. System zeigt gespeicherten Input + Resultat.

## 7. Use Cases (MVP)
- **UC1 — Problemtext erfassen**
  - Input: Freitext; Output-Sprache entspricht Input-Sprache.
  - Output: Analyse gestartet.

- **UC2 — Schichtenanalyse durchführen**
  - Output: 6 Ebenen (Symptome, Ursachen, Emotionen, Narrative/Frames, Mythen, Essenz).

- **UC3 — Ergebnis validieren & reparieren**
  - Schema-Validierung (strict).
  - Konsistenzchecks (z. B. alle Ebenen vorhanden, Längenlimits).
  - Repair-Loop: max. 2 Re-Generationen bei Fehler.
  - Sprachdetektion: `detected_language` (ISO-639-1) und `language_confidence` `[0..1]`.
  - Sprachkonsistenzcheck: Ergebnis muss in `detected_language` vorliegen.
  - Bei `language_confidence < 0.80`: Laufstatus `failed` mit Fehlercode `LANGUAGE_CONFIDENCE_TOO_LOW`.

- **UC4 — Ergebnis anzeigen (Filterstrecke)**
  - Pro Ebene: klar abgetrennter Bereich.
  - Progression/Sequenz sichtbar (Pipeline).

- **UC5 — Persistieren & abrufen**
  - Speichern: Input + Resultat + Metadaten (Zeitpunkt, Modell, Prompt-Version).
  - Abrufen: Liste + Detailansicht.

## 8. Functional Requirements (MVP)
- **FR1:** Versionierte API-v1-Endpunkte für Analyse-Läufe:
  - `POST /api/v1/analyses`
  - `GET /api/v1/analyses`
  - `GET /api/v1/analyses/{id}`
  - `POST /api/v1/analyses/{id}/rerun`
- **FR2:** Striktes JSON Output-Format (Contract).
- **FR3:** Schema-Validierung vor Persistenz.
- **FR4:** Repair-Loop bei Contract-Verletzung.
- **FR5:** Speicherung in relationaler DB.
- **FR6:** UI zeigt die 6 Stufen als Pipeline (Filterstrecke).
- **FR7:** Anzeige der Metadaten (Prompt-Version, Modell, Timestamp).
- **FR8:** Export (verpflichtend im MVP): JSON-Download je Lauf.
- **FR9:** Sprachregel umsetzen: Input-Sprache = Output-Sprache inkl. persistierter Sprachmetadaten und reproduzierbarem Fehlerfall bei unsicherer Erkennung.

## 9. Qualitätsanforderungen (SMART, MVP)
- **NFR1 — Contract Compliance:** Mindestens 90% der Analysen bestehen Schema-Validierung ohne Repair-Loop.
- **NFR2 — Robustheit Repair:** Bei Schema-Fehlern wird max. 2x repariert; danach wird der Lauf als `failed` markiert und gespeichert.
- **NFR3 — Performance:** p95 Antwortzeit Analyse (ohne Cold Start) < 5s bei Texten bis 1'000 Zeichen.
- **NFR4 — Nachvollziehbarkeit:** Jeder gespeicherte Lauf enthält Prompt-Version, Modell-ID, Timestamp, Validierungsstatus.
- **NFR5 — Wartbarkeit:** Mindestens 80% Unit-Test-Coverage auf Domain/Application Layer (ohne UI) sowie verpflichtende Integrations- und E2E-Tests für die kritische User-Journey.
- **NFR6 — Sprachdetektion:** Bei gemischten Inputs muss die dominante Sprache mit definierter Sicherheit erkannt werden (`detected_language`, `language_confidence`); bei Sicherheit < 0.80 wird der Lauf als `failed` mit `error_code=LANGUAGE_CONFIDENCE_TOO_LOW` gespeichert.

## 10. Daten & Persistenz (MVP)
Zu speichern:
- Problemtext (raw)
- Analyse-JSON (validiert oder fehlerhaft markiert)
- Validierungsreport (Checks, Fehler)
- Metadaten: `detected_language` (ISO-639-1), `language_confidence` `[0..1]`, Modell, Prompt-Version, Lauf-ID, `created_at`
- Fehlerdaten bei `failed`: `error_code`, `error_reason`

## 11. Technische Baseline-Versionen
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

## 12. Abnahmekriterien (Acceptance)
- **AC1:** 6 Ebenen vorhanden und korrekt benannt.
- **AC2:** JSON ist schema-valide oder als `failed` markiert + Report gespeichert.
- **AC3:** UI zeigt Pipeline mit allen Ebenen.
- **AC4:** Analysen sind in DB persistiert und abrufbar.
- **AC5:** Unit-, Integrations- und E2E-Tests laufen in CI sowie lokal/Container reproduzierbar.
- **AC6:** Output-Sprache entspricht Input-Sprache oder Lauf ist sauber als `failed` markiert (inkl. Fehlergrund).
- **AC7:** API-v1-Endpunkte (`POST /api/v1/analyses`, `GET /api/v1/analyses`, `GET /api/v1/analyses/{id}`, `POST /api/v1/analyses/{id}/rerun`) sind vorhanden und dokumentiert.
- **AC8:** Sprachdetektionsfehler ist reproduzierbar behandelt und persistiert (`detected_language`, `language_confidence`, `error_code`, `error_reason`).

## 13. Risiken & Mitigations (MVP)
- **R1:** LLM liefert falsches Format -> Mitigation: strict schema + repair-loop.
- **R2:** Halluzination bei Ursachen -> Mitigation: Prompting mit neutraler Sprache, keine Faktbehauptungen; Hypothesen-Wording.
- **R3:** Scope Creep (zu viele Features) -> Mitigation: NGs strikt; MVP strikt.
- **R4:** UI wird zu aufwändig -> Mitigation: funktionale Pipeline zuerst, Fancy später.

## 14. MVP Deliverables
- Running App (Frontend + Backend) lokal via Docker Compose
- REST API (v1): `POST /api/v1/analyses`, `GET /api/v1/analyses`, `GET /api/v1/analyses/{id}`, `POST /api/v1/analyses/{id}/rerun`
- Persistenz + Migrationen
- Tests (Unit + Integration + E2E) + dokumentierte Testresultate
- Verbindlicher JSON-Export pro Lauf
- Dokumentation: arc42 + ADRs + KI-Reflexion
