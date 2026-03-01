#!/usr/bin/env bash
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI (gh) is required."
  exit 1
fi

if [ -z "${GH_REPO:-}" ]; then
  echo "Set GH_REPO=owner/repo before running."
  exit 1
fi

echo "Applying repository governance to ${GH_REPO}..."

echo "1/3 Configure branch protection for main..."
gh api \
  --method PUT \
  "repos/${GH_REPO}/branches/main/protection" \
  --input - <<'JSON'
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "ci / backend-lint-type-test",
      "ci / frontend-test-build",
      "ci / contract-and-migrations",
      "ci / docs-governance",
      "security / dependency-scan",
      "security / static-analysis"
    ]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "block_creations": false,
  "required_linear_history": false,
  "required_conversation_resolution": true,
  "lock_branch": false,
  "allow_fork_syncing": true
}
JSON

echo "2/3 Configure merge policy..."
gh api \
  --method PATCH \
  "repos/${GH_REPO}" \
  --input - <<'JSON'
{
  "allow_squash_merge": true,
  "allow_merge_commit": false,
  "allow_rebase_merge": false,
  "delete_branch_on_merge": true
}
JSON

echo "3/3 Create environments if missing..."
for env_name in staging production; do
  gh api \
    --method PUT \
    "repos/${GH_REPO}/environments/${env_name}" \
    --input - <<'JSON'
{
  "wait_timer": 0,
  "reviewers": []
}
JSON
done

cat <<'EOF'
Baseline governance has been applied.

Manual follow-up still required:
1. Configure required reviewers for the production environment.
2. Add repository secrets:
   - STAGING_DEPLOY_WEBHOOK_URL
   - PRODUCTION_DEPLOY_WEBHOOK_URL
3. Add path-scoped ruleset for high-risk files requiring 2 approvals.
EOF
