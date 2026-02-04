#!/bin/bash
# Delete a skill from the organization's private skill store
#
# Usage: delete.sh <skill-id>

set -e

SKILL_ID="$1"

if [ -z "$SKILL_ID" ]; then
  echo "Usage: delete.sh <skill-id>"
  exit 1
fi

# Get auth token (absolute path to avoid PATH issues)
AUTH_TOKEN=$(/home/user/.local/bin/rebyte-auth)

echo "Deleting skill $SKILL_ID..."
curl -s -X POST "https://api.rebyte.ai/api/data/skills/delete-org" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"id\": \"$SKILL_ID\"}" | jq . 2>/dev/null || cat
