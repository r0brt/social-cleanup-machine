# GitHub Governance Baseline (CI/CD + PR/Review)

This document defines GitHub repository settings that complement version-controlled automation in `.github/workflows/`.

## 1. Branch Protection / Ruleset for `main`

Configure `main` with the following required controls:

1. Require pull request before merge.
2. Require branches to be up to date before merging.
3. Require status checks to pass before merging.
4. Do not allow force pushes.
5. Do not allow deletions.
6. Dismiss stale pull request approvals when new commits are pushed.
7. Require review from Code Owners.
8. Require at least 1 approving review for normal changes.
9. Require at least 2 approvals for high-risk paths via an additional path-scoped ruleset.
10. Restrict direct pushes to administrators only for emergency procedures.

Required status checks (exact names):

- `ci / backend-lint-type-test`
- `ci / frontend-test-build`
- `ci / contract-and-migrations`
- `ci / docs-governance`
- `security / dependency-scan`
- `security / static-analysis`

## 2. Merge and Commit Policy

1. Default merge strategy: Squash merge.
2. PR title must follow Conventional Commits:
   - `feat:`
   - `fix:`
   - `docs:`
   - `refactor:`
   - `test:`
   - `chore:`
3. PRs larger than 400 changed non-lockfile lines require explicit risk acknowledgment in the PR body.

## 3. Environments

Configure GitHub Environments:

1. `staging`
   - No manual approvals.
   - Triggered automatically by `.github/workflows/ci-main.yml`.
2. `production`
   - Require manual approver(s).
   - Optionally configure deployment windows.
   - Used by `.github/workflows/release.yml` and `.github/workflows/rollback.yml`.

## 4. Required Repository Secrets

Add these repository secrets to enable real deployment:

1. `STAGING_DEPLOY_WEBHOOK_URL`
2. `PRODUCTION_DEPLOY_WEBHOOK_URL`

If a secret is not set, workflows perform explicit simulation (or fail for rollback).

## 5. Security Controls in GitHub Settings

Enable the following repository/org features:

1. Secret scanning.
2. Push protection for secrets.
3. Dependabot alerts and security updates.
4. Private vulnerability reporting (if repo visibility and policy require it).

## 6. Operational Notes

1. Keep check names stable; if a workflow job name changes, update branch protection in the same PR.
2. For emergency bypass merges, open a postmortem issue using `.github/ISSUE_TEMPLATE/postmortem.yml`.
3. Rollback path is one command via workflow dispatch:
   - `gh workflow run rollback.yml -f target_tag=vX.Y.Z`
4. Baseline settings can be applied with:
   - `GH_REPO=owner/repo ./scripts/github/apply-governance.sh`
