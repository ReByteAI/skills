---
name: web-app-deploy
description: Deploy static sites to Netlify. Sites deploy to *.rebyte.pro with automatic SSL. Use when user asks to "deploy", "publish", "host", or make their app "live". Triggers include "deploy my app", "make it live", "publish site", "host my app", "deploy website", "put it online".
---

# Web App Deploy

Deploy static files to Netlify at `*.rebyte.pro` with automatic SSL.

{{include:auth.md}}

## What This Skill Does

- Deploys static files (HTML, CSS, JS, assets) to Netlify
- Provides a URL at `https://<id>.rebyte.pro`
- Supports serverless functions via `netlify/functions/`
- Auto-creates or updates existing deployments

**This skill does NOT build your project.** Build it first using the framework's standard commands, then deploy the output.

---

## Quick Reference

| Framework | Build Output | SPA Redirects? |
|-----------|--------------|----------------|
| React/Vue/Svelte | `dist/` or `build/` | Yes |
| Astro | `dist/` | No |
| Next.js (static) | `out/` | No |
| Slidev | `dist/` | No |
| Vanilla HTML | `.` (current dir) | No |

**SPA Redirects:** Single-page apps need a `_redirects` file in the build output:
```
/*    /index.html   200
```

---

## How to Deploy

### Step 1: Get Upload URL

```bash
curl -X POST "$API_URL/api/data/netlify/get-upload-url" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}'
```

Response:
```json
{
  "deployId": "app-x7k2",
  "uploadUrl": "https://storage.googleapis.com/...",
  "isExisting": false
}
```

### Step 2: Create ZIP

**CRITICAL:** `index.html` must be at the ZIP root, not in a subdirectory.

```bash
# From build output directory
cd dist && zip -r ../site.zip . && cd ..

# For a single HTML file
zip site.zip index.html

# Verify structure (index.html should show at root)
unzip -l site.zip
```

### Step 3: Upload ZIP

```bash
curl -X PUT "$UPLOAD_URL" \
  -H "Content-Type: application/zip" \
  --data-binary @site.zip
```

### Step 4: Deploy

```bash
curl -X POST "$API_URL/api/data/netlify/deploy" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"deployId": "app-x7k2"}'
```

Response:
```json
{
  "deployId": "app-x7k2",
  "url": "https://app-x7k2.rebyte.pro",
  "status": "deployed"
}
```

**Site is live!** SSL activates within 1-2 minutes.

---

## Deploying a Single HTML File

For simple projects (forms, landing pages):

```bash
# 1. Get upload URL
RESPONSE=$(curl -s -X POST "$API_URL/api/data/netlify/get-upload-url" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}')
DEPLOY_ID=$(echo $RESPONSE | jq -r '.deployId')
UPLOAD_URL=$(echo $RESPONSE | jq -r '.uploadUrl')

# 2. ZIP the single file
zip site.zip index.html

# 3. Upload
curl -X PUT "$UPLOAD_URL" \
  -H "Content-Type: application/zip" \
  --data-binary @site.zip

# 4. Deploy
curl -s -X POST "$API_URL/api/data/netlify/deploy" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"deployId\": \"$DEPLOY_ID\"}"

echo "Deployed: https://${DEPLOY_ID}.rebyte.pro"
```

---

## Adding Serverless Functions

Create backend API endpoints with Netlify Functions.

### Directory Structure

**IMPORTANT:** The ZIP must have `index.html` at the root, with `functions/` alongside it.

```
your-site.zip (contents)
├── index.html              # At root (required)
├── assets/                 # Static assets
├── functions/              # Serverless functions
│   └── hello.js            # Each .js file = one function
└── netlify.toml            # Optional configuration
```

### Example Function

**IMPORTANT:** Use CommonJS `exports.handler` format (most reliable with the API).

**functions/hello.js:**
```javascript
exports.handler = async function(event, context) {
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      message: 'Hello from Netlify Function!',
      timestamp: new Date().toISOString()
    }),
  };
};
```

### Multiple Functions Example

**functions/users.js:**
```javascript
exports.handler = async function(event, context) {
  if (event.httpMethod === 'GET') {
    return {
      statusCode: 200,
      body: JSON.stringify({ users: ['Alice', 'Bob'] }),
    };
  }
  return { statusCode: 405, body: 'Method Not Allowed' };
};
```

### Optional Configuration

**netlify.toml** (only needed for custom paths or redirects):
```toml
[functions]
  directory = "functions"

# Optional: Pretty URLs for functions
[[redirects]]
  from = "/api/hello"
  to = "/.netlify/functions/hello"
  status = 200
```

### Deploy with Functions

**Step 1: Build your frontend** (e.g., `npm run build` → outputs to `dist/`)

**Step 2: Create ZIP from INSIDE the build output:**
```bash
# Copy functions into the build output
cp -r functions dist/

# Copy netlify.toml if you have one
cp netlify.toml dist/ 2>/dev/null || true

# Create ZIP from inside dist/
cd dist && zip -r ../site.zip . && cd ..

# Verify: index.html and functions/ should be at root
unzip -l site.zip
```

**Step 3: Upload and deploy as usual**

Functions are accessible at: `https://your-site.rebyte.pro/.netlify/functions/hello`

Or with redirects: `https://your-site.rebyte.pro/api/hello`

---

## API Reference

### Get Upload URL

```
POST /api/data/netlify/get-upload-url
```

Returns `deployId` (stable per workspace) and signed `uploadUrl`.

### Deploy

```
POST /api/data/netlify/deploy
Body: {"deployId": "..."}
```

Auto-detects create vs update.

### Check Status

```
POST /api/data/netlify/status
Body: {"deployId": "..."}
```

### Delete Site

```
POST /api/data/netlify/delete
Body: {"deployId": "..."}
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Page Not Found" | Ensure `index.html` is at ZIP root, not in subdirectory |
| 404 on route refresh (SPA) | Add `_redirects` file: `/*    /index.html   200` |
| Assets not loading | Use relative paths (`./assets/` not `/assets/`) |
| Functions not working | Use `exports.handler` format, put in `functions/` or `netlify/functions/` directory |
| Function returns HTML 404 | Function file may have syntax error; use CommonJS format |

---

## Limits

| Resource | Limit |
|----------|-------|
| ZIP size | 100MB |
| Upload URL expiry | 1 hour |
| Function execution | 10 seconds |
| Function memory | 1024 MB |
