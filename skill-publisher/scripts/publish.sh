#!/bin/bash
# Publish a skill package to the organization's private skill store
#
# Usage: publish.sh <slug> <path-to-skill-file>
#
# Example: publish.sh my-skill ./my-skill.skill

set -e

SLUG="$1"
SKILL_FILE="$2"

if [ -z "$SLUG" ] || [ -z "$SKILL_FILE" ]; then
  echo "Usage: publish.sh <slug> <path-to-skill-file>"
  echo "Example: publish.sh my-skill ./my-skill.skill"
  exit 1
fi

if [ ! -f "$SKILL_FILE" ]; then
  echo "Error: Skill file not found: $SKILL_FILE"
  exit 1
fi

# Get auth token
AUTH_TOKEN=$(rebyte-auth)

# Base64 encode the package
PACKAGE_BASE64=$(base64 -w0 "$SKILL_FILE" 2>/dev/null || base64 "$SKILL_FILE" | tr -d '\n')

# Publish
echo "Publishing $SLUG..."
RESPONSE=$(curl -s -X POST "https://api.rebyte.ai/api/data/skills/publish" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"slug\": \"$SLUG\", \"package\": \"$PACKAGE_BASE64\"}")

# Check result
if echo "$RESPONSE" | grep -q '"success":true'; then
  echo "Published successfully!"
  echo "$RESPONSE" | jq -r '.skill | "  Name: \(.name)\n  Slug: \(.slug)\n  URL: \(.download_url)"' 2>/dev/null || echo "$RESPONSE"
else
  echo "Publish failed:"
  echo "$RESPONSE" | jq . 2>/dev/null || echo "$RESPONSE"
  exit 1
fi
