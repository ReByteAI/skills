#!/bin/bash
# List all skills in the organization's private skill store
#
# Usage: list.sh

set -e

# Get auth token (absolute path to avoid PATH issues)
AUTH_TOKEN=$(/home/user/.local/bin/rebyte-auth)

curl -s -X POST "https://api.rebyte.ai/api/data/skills/list-org" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{}" | jq '.skills[] | "\(.slug) - \(.name)"' -r 2>/dev/null || cat
