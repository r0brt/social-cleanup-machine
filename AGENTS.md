# AGENTS.md

## 1. Purpose & Scope
This document defines mandatory engineering governance rules for all coding agents (including Codex) working in this repository.

- Scope: repository-wide, unless a deeper `AGENTS.md` adds stricter local specialization.
- Goal: consistent, senior-level engineering quality with reproducible outcomes.
- Enforcement model: review-time policy enforcement plus CI-based policy enforcement.

## 2. Engineering Principles
1. Correctness over speed.
2. Small, reviewable changes over large risky batches.
3. No hidden side effects outside agreed scope.
4. Explicit assumptions, explicit tradeoffs, explicit risks.
5. Reproducibility is mandatory (commands, tests, documentation updates).
6. Prefer simple architecture that can evolve safely.

## 3. Tech Baseline
### 3.1 Product and Architecture Baseline
- Architecture default: **modular monolith first**.
- Service/container extraction: optional and only when justified and documented.
- Non-negotiable product core:
  - strict JSON contract
  - schema validation
  - bounded repair loop
  - persistence
  - pipeline UI

### 3.2 Stack Baseline
- Backend: Python + FastAPI
- Persistence: SQLAlchemy + Alembic + PostgreSQL
- Frontend: React + Vite + TypeScript

### 3.3 Stack Version Policy (Mandatory)
Use explicit, pinned major/minor targets to ensure reproducibility across local dev, CI, and deployment.

- Python runtime: **3.12.x**
- Node.js runtime: **20.x (LTS)**
- PostgreSQL: **16.x**
- FastAPI: **0.115.x**
- Pydantic: **2.8.x**
- SQLAlchemy: **2.0.x**
- Alembic: **1.13.x**
- React: **18.x**
- TypeScript: **5.6.x**
- Vite: **5.x**

Versioning rules:
1. Runtime/tool major versions must not change implicitly.
2. Dependency updates must be done intentionally and documented in PR notes.
3. Lockfiles are required and treated as source-of-truth for reproducible builds.
4. The version matrix must be mirrored consistently in `docs/PRD.md` and `docs/arc42/02-randbedingungen.md`.

### 3.4 Package Management & Tooling
- Python package/tool runner default: **uv**
- Poetry is **not** used as primary workflow in this repository.
- All Python commands documented in PRD/PLAN/CI must use `uv run ...` (exception: `uv sync`).

Mandatory Python command set:
- `uv sync`
- `uv run ruff check .`
- `uv run pytest -q`
- `uv run mypy .` (if configured in this repository)

Mandatory frontend command set:
- `npm run test -- --run`
- `npm run build`

## 4. Python Standards (PEP8/PEP257/types)
1. PEP8 is mandatory for style and structure.
2. PEP257 is mandatory for docstrings on public modules/classes/functions.
3. Strong typing is mandatory on public interfaces.
4. Prefer explicit domain types over loosely typed dictionaries.
5. Keep strict layer boundaries:
   - `api` (transport)
   - `application` (use cases)
   - `domain` (business rules)
   - `infrastructure` (db/llm/external adapters)
6. No business logic in routers/controllers.
7. Use structured logging and explicit error taxonomy.

## 5. API & Contract Standards
1. Contract-first behavior is mandatory.
2. Versioned endpoint style (`/api/v1/...`) is the required standard for all new and changed endpoints.
3. Unified error shape is required across endpoints.
4. Input language = output language is a functional rule.
5. No silent contract degradation.

## 6. LLM/AI Reliability Guardrails
1. Provider access must be behind an adapter interface.
2. LLM output must follow strict JSON contract.
3. Schema validation is required before persistence.
4. Repair loop must be bounded and deterministic on failure.
5. Persist run traceability fields at minimum:
   - `prompt_version`
   - `model`
   - `validation_status`
   - `run_status`
   - `error_reason`
6. No silent fallback heuristics.

## 7. Persistence & Migration Standards
1. SQLAlchemy 2 style required.
2. Alembic migration required for every schema change.
3. Explicit transaction boundaries are mandatory.
4. Use database constraints in addition to application validation.
5. Persist audit/traceability fields for lifecycle visibility.

## 8. Frontend Standards
1. TypeScript strict mode is the target baseline.
2. Explicit UI states are mandatory:
   - loading
   - error
   - empty
   - success
3. API error handling must be visible and typed.
4. Contract violations must be surfaced clearly in UI.
5. Keep presentation logic separated from API/client logic.

## 9. Testing Policy & Quality Gates
1. Minimum testing pyramid:
   - Unit tests (domain/application)
   - Integration tests (API + DB + validation/repair)
   - E2E tests (critical user journey)
2. Unit, Integration, and E2E tests are mandatory as MVP/release quality gates.
3. Contract tests are required once schema artifacts exist.
4. Every change must include test evidence or an explicit documented risk note.
5. If tests are skipped/blocked, document:
   - what was not executed
   - why
   - impact/risk

## 10. Security & Privacy
1. No secrets in repository files.
2. Validate all external inputs at boundaries.
3. Do not log sensitive payloads.
4. Use safe defaults and explicit failure paths.
5. Maintain dependency hygiene and patch discipline.

## 11. Repo Workflow & Review Rules
1. Use Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`).
2. Keep PRs small and reviewable.
3. Do not mix unrelated refactor/feature/doc changes in one opaque change.
4. Every PR/change summary must include:
   - scope
   - design rationale
   - tests run
   - docs updated
   - residual risks

### 11.1 Branch Strategy (Mandatory)
- Branching model: trunk-based development with short-lived branches.
- `main` is the trunk and must remain releasable at all times.
- All implementation work must start from a branch off current `main`.
- Branch naming conventions:
  - `feat/<ticket>-<slug>`
  - `fix/<ticket>-<slug>`
  - `chore/<slug>`
  - `docs/<slug>`
  - `refactor/<slug>`
  - `test/<slug>`
  - `hotfix/<slug>` (only for emergency fixes)
- Branch lifetime target: under 2 days. Rebase or sync frequently from `main`.

### 11.2 main Branch Protection (Mandatory)
- Direct pushes to `main` are forbidden.
- Force-pushes to `main` are forbidden.
- All changes to `main` must go through pull requests.
- `main` protection baseline:
  - require pull request before merging
  - minimum 1 approving review
  - dismiss stale approvals when new commits are pushed
  - require Code Owners review
  - require conversation resolution before merge
  - require status checks to pass
  - require branch up-to-date with `main` before merge
  - require linear history
  - disallow force pushes and deletions
  - include administrators: disabled by default (Balanced profile)

### 11.3 Merge Policy
- Merge method for `main`: squash merge only.
- PR title must follow Conventional Commits.
- Required PR template sections must be completed.
- Keep each PR small, reviewable, and scoped to one coherent change.
- Auto-delete merged branches should be enabled in repository settings.

### 11.4 Exception Path
- Emergency changes must use `hotfix/<slug>` branches.
- Emergency changes still require a PR to `main`; direct commits remain forbidden.
- Expedited review is allowed for hotfix PRs, but approval and required checks are still mandatory.
- Every emergency merge requires postmortem follow-up documenting cause, impact, and preventive action.

## 12. Documentation Policy (PRD/PLAN/arc42/ADR triggers)
Documentation is part of the deliverable, never optional.

### 12.1 Mandatory Triggers
- Behavior/contract changes -> update `docs/PRD.md` + arc42 (+ ADR if architectural)
- Architecture decision changes -> ADR required in `docs/adr/`
- Delivery sequencing changes -> update `PLAN.md`
- Keep arc42 documentation in German

### 12.2 Source-of-Truth Artifacts
- Product requirements: `docs/PRD.md`
- Delivery roadmap: `PLAN.md`
- Architecture documentation: `docs/arc42/`
- Architecture decisions: `docs/adr/`

## 13. Definition of Done
A task/change is done only if all are true:
1. Scope is fully implemented without hidden side effects.
2. Relevant tests have been executed successfully.
3. Test evidence is documented.
4. Required docs were updated (PRD/PLAN/arc42/ADR) when triggered.
5. Security/privacy constraints are respected.
6. Residual risks are explicitly listed.
7. Work is reproducible via clear commands.

## 14. Explicit Non-Goals
1. No unrequested feature expansion.
2. No silent scope change.
3. No unnecessary tech migration.
4. No distributed service split without documented need + ADR.
5. No quality shortcuts for short-term speed.

## 15. Governance Interface
- No product APIs/interfaces/types are introduced or changed by this document.
- This file defines repository governance/process policy only.
