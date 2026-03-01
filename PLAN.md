# Umsetzungsplan (Roadmap) — von PRD zum finalen Produkt

Dieses Dokument beschreibt die Umsetzung **ausgehend von `docs/PRD.md`** bis zum lieferfähigen Produkt.

Leitplanken: **modularer Monolith zuerst**, später optionale Service-/Container-Extraktion; **strikter JSON-Vertrag + Schema-Validierung + Repair-Loop**; Persistenz; UI-Pipeline; `docker-compose`; Tests inkl. dokumentierter Ergebnisse.

Traceability-Prinzip: Jeder Meilenstein referenziert relevante PRD-Punkte (FR/NFR/AC), damit Scope und Abnahme konsistent bleiben.
Python-Kommandos in diesem Plan folgen dem `uv`-Standard aus `AGENTS.md`.

## M0 — CI/CD- und Review-Governance-Baseline
- **Ziel:** Verbindliche Quality Gates und Review-Regeln als GitHub-automatisierte Kontrollen etablieren.
- **Deliverables:** GitHub Actions Workflows (`ci`, `security`, `release`, `rollback`), PR-Template, CODEOWNERS, Dependabot-Konfiguration, Governance-Runbooks.
- **PRD-Bezug:** AC5, NFR5
- **Definition of Done (Tests/Commands):**
  - `.github/workflows/ci-pr.yml` enthält Jobs `backend-lint-type-test`, `frontend-test-build`, `contract-and-migrations`
  - `.github/workflows/docs-governance.yml` erzwingt Doku-Governance-Regeln auf PR-Ebene
  - `.github/workflows/security.yml` enthält Jobs `dependency-scan`, `static-analysis`
  - `.github/workflows/ci-main.yml` enthält Staging-Deploy-Handoff
  - `.github/workflows/release.yml` + `.github/workflows/rollback.yml` unterstützen Release/Rollback-Runbook
- **Doku-Updates (arc42/ADR):**
  - `PLAN.md` aktualisiert (Ablauf-/Lieferlogik)
  - Betriebsdokumentation unter `docs/operations/` ergänzt
- **Out of Scope:** Hosting-spezifische Deploy-Implementierung, Cloud-IaC.

## M1 — Scope-Freeze und Architektur-Start (Monolith)
- **Ziel:** PRD in umsetzbare Architektur- und Backlog-Bausteine überführen.
- **Deliverables:** Umsetzungs-Backlog, Modulgrenzen des Monolithen, API-Skizze (v1), Datenobjektliste.
- **PRD-Bezug:** G1–G4, NG1–NG4
- **Definition of Done (Tests/Commands):**
  - `test -f docs/PRD.md`
  - Architektur-Review durchgeführt (Checkliste mit offenen Punkten = 0 blocker)
- **Doku-Updates (arc42/ADR):**
  - arc42 Kapitel 1–4 aktualisieren (Ziele, Randbedingungen, Kontext, Lösungsstrategie)
  - ADR-001 „Modular Monolith First“
- **Out of Scope:** Implementierung von Features, produktive Infrastruktur.

## M2 — Domain- und JSON-Vertrag festziehen
- **Ziel:** Verbindlichen Analysevertrag für die 6 Ebenen etablieren.
- **Deliverables:** JSON-Schema (versioniert), API-Request/Response-Modelle, Fehlercode-Konzept, Sprachregel im Contract (Input=Output, Unsicherheitsfehler), verbindlicher API-v1-Standard (`/api/v1/...`) in PRD und Contract-Artefakten, synchronisierte Version-Matrix in PRD und arc42.
- **PRD-Bezug:** FR1, FR2, FR3, FR9, AC1, AC2, AC6, AC7, AC8
- **Definition of Done (Tests/Commands):**
  - `uv run pytest -q tests/contracts`
  - `uv run python -m jsonschema -i examples/analysis_valid.json schemas/analysis.schema.json`
  - Vertragstest für Sprachregel vorhanden (Mismatch => failed)
  - API-v1-Endpunkte in PRD und Contract-Doku identisch dokumentiert
  - Version-Matrix in PRD und arc42 konsistent
- **Doku-Updates (arc42/ADR):**
  - arc42 Kapitel 5 (Bausteinsicht) + 8 (Querschnitt: Vertragsvalidierung)
  - ADR-003 „Strict JSON Contract & Schema Validation“
- **Out of Scope:** UI-Implementierung, echte LLM-Integration.

## M3 — Persistenz und Migrationsbasis
- **Ziel:** Nachvollziehbare Speicherung von Eingaben, Analyse-Ergebnissen, Validierungsläufen.
- **Deliverables:** DB-Schema, Migrationen, Repository-Layer, Audit-Felder.
- **PRD-Bezug:** FR5, NFR4, NFR6, AC4, AC6
- **Definition of Done (Tests/Commands):**
  - `uv run alembic upgrade head`
  - `uv run pytest -q tests/persistence`
  - Persistenz enthält Fehlergrundcodes für Sprach-/Schema-Fehler
- **Doku-Updates (arc42/ADR):**
  - arc42 Kapitel 5 (Datenbausteine) + 9 (Architekturentscheidungen)
  - ADR-004 (geplant) „Persistenzmodell inkl. Analyse- und Validation-Run“
- **Out of Scope:** Skalierungs-/Sharding-Konzepte, Reporting-Dashboard.

## M4 — Analyse-Orchestrierung im Monolithen
- **Ziel:** End-to-End-Pfad für Analyse mit orchestrierter Pipeline (ohne Service-Split).
- **Deliverables:** Analyse-Use-Case, LLM-Adapter-Interface, Pipeline-Steuerung, Statusmodell, Sprachdetektion mit dominanter Sprache.
- **PRD-Bezug:** UC2, UC3, UJ1a, FR1, FR4, FR9
- **Definition of Done (Tests/Commands):**
  - `uv run pytest -q tests/application/test_analysis_flow.py`
  - `uv run pytest -q tests/unit`
  - Szenario „gemischter Input + niedrige Sicherheit“ liefert `failed` mit Fehlergrund
  - Dokumentierte, testbare Sprachmetadaten je Lauf: `detected_language`, `language_confidence`, `error_code`
- **Doku-Updates (arc42/ADR):**
  - arc42 Kapitel 6 (Laufzeitsicht: Analyse-Request)
  - ADR-005 (geplant) „Orchestrierter Analysefluss im Monolithen“
- **Out of Scope:** Multi-Provider-Routing, asynchrone verteilte Worker-Topologie.

## M5 — Validator + Repair-Loop
- **Ziel:** Robuste Qualitätssicherung durch Schema-/Regelprüfung und einen Reparaturlauf.
- **Deliverables:** Validator-Regeln, Repair-Strategie, Retry-Limits, Fehlerklassifikation.
- **PRD-Bezug:** UC3, NFR1, NFR2, AC2
- **Definition of Done (Tests/Commands):**
  - `uv run pytest -q tests/validation`
  - `uv run pytest -q tests/repair`
  - Nachweis-Metrik: >=90% schema-valide Läufe ohne Repair in Testdatensatz
  - Repair-Limit: max. 2 Re-Generationen, danach `failed`
  - Sprachdetektions-Fehlerfall (`language_confidence < 0.80`) mit `LANGUAGE_CONFIDENCE_TOO_LOW` ist reproduzierbar validiert und dokumentiert
- **Doku-Updates (arc42/ADR):**
  - arc42 Kapitel 8 (Querschnitt: Fehlerbehandlung, Retries)
  - ADR-006 (geplant) „Single Repair Loop with bounded retries“
- **Out of Scope:** Selbstlernende Auto-Prompt-Optimierung, unbegrenzte Retries.

## M6 — UI-Pipeline (6 Ebenen) + Ergebnisdarstellung
- **Ziel:** Nutzbare Oberfläche für Eingabe, Verarbeitungsstatus und strukturierte Ergebnisanzeige.
- **Deliverables:** Eingabeformular, Pipeline-Visualisierung, Ergebnisansicht, Fehler-/Repair-Hinweise, **verpflichtender JSON-Export** je Lauf.
- **PRD-Bezug:** UC4, FR6, FR7, FR8, AC3
- **Definition of Done (Tests/Commands):**
  - `npm run test -- --run`
  - `npm run build`
  - UI-Test: Export-Download verfügbar und formatkonform
- **Doku-Updates (arc42/ADR):**
  - arc42 Kapitel 5 (UI-Bausteine) + 6 (Laufzeitsicht UI→API)
  - ADR-007 (geplant) „UI als Pipeline-Darstellung der Analyseebenen“
- **Out of Scope:** Vollständige Design-System-Bibliothek, Mehrsprachigkeit über DE/EN hinaus.

## M7 — Integrationshärtung + dokumentierte Testresultate
- **Ziel:** Systemweite Stabilität und überprüfbare Qualitätsnachweise.
- **Deliverables:** Integrations-/E2E-Tests, Testreport (inkl. bekannte Grenzen), Regression-Suite.
- **PRD-Bezug:** NFR5, AC5
- **Definition of Done (Tests/Commands):**
  - `uv run pytest -q tests/integration`
  - `npm run test:e2e`
  - Testresultate in `docs/test-report.md` dokumentiert
  - Coverage-Nachweis: >=80% Unit-Test-Coverage Domain/Application
- **Doku-Updates (arc42/ADR):**
  - arc42 Kapitel 10 (Qualitätsanforderungen, Nachweise)
  - ADR-008 (geplant) „Teststrategie und Quality Gates“
- **Out of Scope:** Lasttests im Produktionsmaßstab, Chaos-Engineering.

## M8 — Deployment mit docker-compose
- **Ziel:** Reproduzierbarer lokaler Betrieb der Gesamtlösung.
- **Deliverables:** `docker-compose.yml`, Containerfiles, `.env.example`, Start-/Stop-Anleitung.
- **PRD-Bezug:** MVP Deliverables (lokaler Betrieb), AC5
- **Definition of Done (Tests/Commands):**
  - `docker compose up --build -d`
  - `docker compose ps`
  - `docker compose down`
- **Doku-Updates (arc42/ADR):**
  - arc42 Kapitel 7 (Verteilungssicht) + 8 (Betriebskonzept)
  - ADR-009 (geplant) „Compose-based deployment baseline“
- **Out of Scope:** Kubernetes-Produktivbetrieb, Cloud-IaC-Automation.

## M9 — Finalisierung, Abnahme und optionale Service-Extraktion planen
- **Ziel:** Abgabefähigkeit herstellen und **nur optional** service-orientierte Extraktion vorbereiten.
- **Deliverables:** Abnahmecheckliste, Release-Tag, Doku-Freeze, optionales Extraktionskonzept (ohne Umsetzung), KI-Reflexionsdokument.
- **PRD-Bezug:** NFR3, AC1–AC8, MVP Deliverables
- **Definition of Done (Tests/Commands):**
  - `uv run pytest -q`
  - `npm run test -- --run`
  - `docker compose up -d && docker compose ps`
  - p95-Nachweis < 5s (bis 1'000 Zeichen, ohne Cold Start)
  - Abnahmeprotokoll vollständig
  - Konsistenz-Gate bestanden: PRD/AGENTS/arc42 verwenden identische Version-Matrix und API-v1-Konvention
- **Doku-Updates (arc42/ADR):**
  - arc42 Kapitel 11 (Risiken/Technical Debt) + 12 (Glossar)
  - ADR-010 (geplant) „Criteria for future service extraction“
- **Out of Scope:** Tatsächliche Zerlegung in mehrere produktive Microservices.

---

## Reihenfolge und Abhängigkeiten (kurz)
M0 -> M1 -> M2 -> M3 -> M4 -> M5 -> M6 -> M7 -> M8 -> M9.
Service-/Container-Extraktion bleibt nachgelagert und optional, wenn M0–M9 stabil erfüllt sind.
