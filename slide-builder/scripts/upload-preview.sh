#!/bin/bash
# Upload slide preview PNGs to artifact storage
#
# Usage: upload-preview.sh <preview_dir>
# Example: upload-preview.sh ./preview
#
# This script uploads all PNG files from the preview directory
# to the artifact storage for the current task.
#
# Environment variables (set by rebyte runtime):
#   WORKSPACE_ID - Current workspace ID
#   TASK_ID - Current task ID
#   API_URL - Relay API URL
#   AUTH_TOKEN - Authentication token

set -e

PREVIEW_DIR="${1:-./ preview}"

if [ ! -d "$PREVIEW_DIR" ]; then
  echo "Error: Preview directory not found: $PREVIEW_DIR"
  exit 1
fi

# Check required environment variables
if [ -z "$WORKSPACE_ID" ] || [ -z "$TASK_ID" ]; then
  echo "Error: WORKSPACE_ID and TASK_ID must be set"
  exit 1
fi

if [ -z "$API_URL" ]; then
  API_URL="https://api.rebyte.ai"
fi

if [ -z "$AUTH_TOKEN" ]; then
  AUTH_TOKEN=$(/home/user/.local/bin/rebyte-auth 2>/dev/null || echo "")
fi

# Build curl command with all PNG files
CURL_ARGS="-X PUT"
CURL_ARGS="$CURL_ARGS -H \"Authorization: Bearer $AUTH_TOKEN\""

# Add each PNG file
FILE_COUNT=0
for f in "$PREVIEW_DIR"/*.png; do
  if [ -f "$f" ]; then
    CURL_ARGS="$CURL_ARGS -F \"files=@$f\""
    FILE_COUNT=$((FILE_COUNT + 1))
  fi
done

if [ $FILE_COUNT -eq 0 ]; then
  echo "Error: No PNG files found in $PREVIEW_DIR"
  exit 1
fi

# Upload
echo "Uploading $FILE_COUNT preview images..."
eval curl $CURL_ARGS "$API_URL/api/artifacts/$WORKSPACE_ID/$TASK_ID/slide-preview"

echo ""
echo "Preview uploaded successfully"
