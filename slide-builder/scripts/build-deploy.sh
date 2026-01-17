#!/bin/bash
# Slidev build and deploy script
set -e

PROJECT_DIR="${1:-.}"

echo "=== Slidev Build & Deploy ==="

cd "$PROJECT_DIR"

# Build
echo "Building..."
pnpm build

# Check dist
if [ ! -d "dist" ] || [ ! -f "dist/index.html" ]; then
    echo "ERROR: Build failed, dist/index.html not found"
    exit 1
fi

# Get auth token and relay URL from auth.json
AUTH_JSON="/home/user/.rebyte.ai/auth.json"
AUTH_TOKEN=$(python3 -c "import json; print(json.load(open('$AUTH_JSON'))['sandbox']['token'])")
RELAY_URL=$(python3 -c "import json; print(json.load(open('$AUTH_JSON'))['sandbox']['relay_url'])")

# Get upload URL
echo "Getting upload URL from $RELAY_URL..."
RESPONSE=$(curl -s -X POST "$RELAY_URL/api/data/netlify/get-upload-url" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"id": "slides"}')

DEPLOY_ID=$(echo $RESPONSE | jq -r '.deployId')
UPLOAD_URL=$(echo $RESPONSE | jq -r '.uploadUrl')

if [ "$DEPLOY_ID" = "null" ] || [ -z "$DEPLOY_ID" ]; then
    echo "ERROR: Failed to get upload URL"
    echo "$RESPONSE"
    exit 1
fi

# Create zip (from inside dist)
echo "Creating zip..."
cd dist && zip -r ../site.zip . && cd ..

# Upload
echo "Uploading..."
curl -s -X PUT "$UPLOAD_URL" \
  -H "Content-Type: application/zip" \
  --data-binary @site.zip

# Deploy
echo "Deploying..."
RESULT=$(curl -s -X POST "$RELAY_URL/api/data/netlify/deploy" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"deployId\": \"$DEPLOY_ID\"}")

SITE_URL="https://${DEPLOY_ID}.rebyte.pro"

# Verify
echo "Verifying deployment..."
sleep 2
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL")

if [ "$HTTP_STATUS" != "200" ]; then
    echo "WARNING: Site returned $HTTP_STATUS"
fi

# Cleanup
rm -f site.zip

echo ""
echo "=== Deploy Complete ==="
echo "Preview URL: $SITE_URL"
