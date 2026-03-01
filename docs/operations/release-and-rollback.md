# Release and Rollback Runbook

## Release Flow

Production releases are managed by `.github/workflows/release.yml`.

### Option A: Tag-driven release

1. Create and push a semantic version tag:
   - `git tag vX.Y.Z`
   - `git push origin vX.Y.Z`
2. GitHub Actions creates/updates release notes.
3. Deployment job waits for `production` environment approval.
4. After approval, deployment webhook is triggered.

### Option B: Manual release dispatch

1. Run:
   - `gh workflow run release.yml -f tag=vX.Y.Z -f target_ref=main -f dry_run=false`
2. Validate generated release notes and deployment outcome.

## Rollback Flow (One Command)

Rollback is managed by `.github/workflows/rollback.yml`.

1. Execute rollback:
   - `gh workflow run rollback.yml -f target_tag=vX.Y.Z`
2. Approve `production` environment gate if configured.
3. Verify service health and key user journeys.
4. Open postmortem issue if rollback was incident-driven.

## Post-Deployment Verification Checklist

1. Health checks green.
2. Critical API endpoint smoke checks pass.
3. UI critical flow is operational.
4. No new high-severity alerts.

## Incident Documentation

Use `.github/ISSUE_TEMPLATE/postmortem.yml` for:

1. Emergency hotfixes.
2. Failed production releases.
3. Rollbacks caused by regressions.
