#!/bin/bash
# Build and deploy Slidev presentation to rebyte.pro
set -euo pipefail

echo "=== Slidev Build & Deploy ==="

# Verify we're in a slidev project
if [ ! -f "slides.md" ]; then
    echo "ERROR: slides.md not found. Run from project directory."
    exit 1
fi

if [ ! -f "package.json" ]; then
    echo "ERROR: package.json not found. Run 'bash scripts/init.sh' first."
    exit 1
fi

# Check for required tools
if ! command -v jq &> /dev/null; then
    echo "ERROR: jq is required but not installed."
    exit 1
fi

# Build
echo "Building..."
pnpm build

if [ ! -f "dist/index.html" ]; then
    echo "ERROR: Build failed - dist/index.html not found"
    exit 1
fi

# Get auth credentials
AUTH_JSON="/home/user/.rebyte.ai/auth.json"
if [ ! -f "$AUTH_JSON" ]; then
    echo "ERROR: Auth file not found at $AUTH_JSON"
    exit 1
fi

AUTH_TOKEN=$(jq -r '.sandbox.token' "$AUTH_JSON")
RELAY_URL=$(jq -r '.sandbox.relay_url' "$AUTH_JSON")

if [ -z "$AUTH_TOKEN" ] || [ "$AUTH_TOKEN" = "null" ]; then
    echo "ERROR: Could not read auth token from $AUTH_JSON"
    exit 1
fi

if [ -z "$RELAY_URL" ] || [ "$RELAY_URL" = "null" ]; then
    echo "ERROR: Could not read relay URL from $AUTH_JSON"
    exit 1
fi

# Get upload URL
echo "Getting upload URL..."
RESPONSE=$(curl -sf -X POST "$RELAY_URL/api/data/netlify/get-upload-url" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"id": "slides"}') || {
    echo "ERROR: Failed to get upload URL from relay"
    exit 1
}

DEPLOY_ID=$(echo "$RESPONSE" | jq -r '.deployId')
UPLOAD_URL=$(echo "$RESPONSE" | jq -r '.uploadUrl')

if [ -z "$DEPLOY_ID" ] || [ "$DEPLOY_ID" = "null" ]; then
    echo "ERROR: Invalid response from relay"
    echo "$RESPONSE"
    exit 1
fi

# Create zip
echo "Creating zip..."
(cd dist && zip -rq ../site.zip .)

# Upload
echo "Uploading..."
curl -sf -X PUT "$UPLOAD_URL" \
  -H "Content-Type: application/zip" \
  --data-binary @site.zip || {
    echo "ERROR: Upload failed"
    rm -f site.zip
    exit 1
}

# Deploy
echo "Deploying..."
curl -sf -X POST "$RELAY_URL/api/data/netlify/deploy" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"deployId\": \"$DEPLOY_ID\"}" > /dev/null || {
    echo "ERROR: Deploy failed"
    rm -f site.zip
    exit 1
}

SITE_URL="https://${DEPLOY_ID}.rebyte.pro"

# Verify
echo "Verifying..."
sleep 2
HTTP_STATUS=$(curl -so /dev/null -w "%{http_code}" "$SITE_URL" || echo "000")

if [ "$HTTP_STATUS" != "200" ]; then
    echo "WARNING: Site returned HTTP $HTTP_STATUS (may still be propagating)"
fi

# Cleanup
rm -f site.zip

echo ""
echo "=== Deploy Complete ==="
echo "URL: $SITE_URL"
