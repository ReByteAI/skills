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

### CRITICAL: Functions Must Be Self-Contained

This API deploys directly to Netlify **without a build step**. This means:

1. **Use CommonJS** - `exports.handler` and `require()`, NOT `export`/`import`
2. **Bundle all dependencies** - npm packages must be bundled into a single file using esbuild
3. **No node_modules** - Including `node_modules/` in ZIP won't work

### Simple Function (No Dependencies)

For functions without npm dependencies, just use CommonJS:

**functions/hello.js:**
```javascript
exports.handler = async function(event, context) {
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      message: 'Hello!',
      path: event.path,
      method: event.httpMethod
    }),
  };
};
```

### Function With NPM Dependencies (MUST Bundle)

If your function uses npm packages, you **MUST bundle with esbuild** first:

**Step 1: Write your function (can use ES modules in source)**

**src/functions/api.js:**
```javascript
import { createClient } from '@libsql/client';

const db = createClient({
  url: process.env.TURSO_URL,
  authToken: process.env.TURSO_AUTH_TOKEN,
});

export async function handler(event, context) {
  const users = await db.execute('SELECT * FROM users');
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(users.rows),
  };
}
```

**Step 2: Bundle with esbuild**

```bash
# Install esbuild
npm install -D esbuild

# Bundle each function into a self-contained CommonJS file
npx esbuild src/functions/api.js \
  --bundle \
  --platform=node \
  --target=node18 \
  --format=cjs \
  --outfile=functions/api.js

# Verify it's self-contained (no require of external packages)
head -20 functions/api.js
```

**Step 3: Create ZIP and deploy**

```bash
cd dist && zip -r ../site.zip . && cd ..
```

The bundled `functions/api.js` now contains all dependencies inline - no `node_modules` needed.

### Complete Example: Todo App with Database

```bash
# 1. Install dependencies
npm install @libsql/client
npm install -D esbuild

# 2. Create source function
cat > src/functions/todos.js << 'EOF'
import { createClient } from '@libsql/client';

const db = createClient({
  url: process.env.TURSO_URL,
  authToken: process.env.TURSO_AUTH_TOKEN,
});

export async function handler(event) {
  await db.execute(`
    CREATE TABLE IF NOT EXISTS todos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      completed INTEGER DEFAULT 0
    )
  `);

  if (event.httpMethod === 'GET') {
    const result = await db.execute('SELECT * FROM todos');
    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(result.rows),
    };
  }

  if (event.httpMethod === 'POST') {
    const { title } = JSON.parse(event.body);
    await db.execute({ sql: 'INSERT INTO todos (title) VALUES (?)', args: [title] });
    return { statusCode: 201, body: 'Created' };
  }

  return { statusCode: 405, body: 'Method Not Allowed' };
}
EOF

# 3. Bundle with esbuild
mkdir -p functions
npx esbuild src/functions/todos.js \
  --bundle \
  --platform=node \
  --target=node18 \
  --format=cjs \
  --outfile=functions/todos.js

# 4. Create .env.production with database credentials
cat > .env.production << EOF
TURSO_URL=$TURSO_URL
TURSO_AUTH_TOKEN=$TURSO_AUTH_TOKEN
EOF

# 5. Build frontend and create ZIP (include .env.production)
npm run build
cp -r functions dist/
cp .env.production dist/
cd dist && zip -r ../site.zip . && cd ..

# 6. Deploy
curl -X PUT "$UPLOAD_URL" -H "Content-Type: application/zip" --data-binary @site.zip
curl -X POST "$API_URL/api/data/netlify/deploy" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"deployId\": \"$DEPLOY_ID\"}"
```

The `.env.production` file is automatically read, environment variables are set on Netlify, and the file is removed from the deployed files for security.

### Directory Structure

```
your-site.zip (contents)
├── index.html              # At root (required)
├── assets/                 # Static assets
├── functions/              # Bundled serverless functions
│   └── todos.js            # Self-contained (all deps bundled)
├── .env.production         # REQUIRED: environment variables
└── _redirects              # Optional: SPA redirects
```

### What esbuild Does

```
BEFORE (won't work - has external dependency):
  const { createClient } = require('@libsql/client');

AFTER (works - dependency code is inlined):
  // ... 1000s of lines of bundled @libsql/client code ...
  var createClient = function() { ... };

  exports.handler = async function(event) {
    const db = createClient({ ... });
    ...
  };
```

### Optional: Add to package.json

```json
{
  "scripts": {
    "build:functions": "esbuild src/functions/*.js --bundle --platform=node --target=node18 --format=cjs --outdir=functions",
    "build": "npm run build:functions && vite build"
  }
}
```

---

## Environment Variables (.env.production)

**REQUIRED:** If your ZIP contains serverless functions, you MUST include a `.env.production` file at the ZIP root.

### File Format

```
# .env.production
DATABASE_URL=libsql://ws-abc123-rebyte.turso.io
DATABASE_TOKEN=eyJ...
API_KEY=sk-...
```

### How It Works

1. Include `.env.production` in your ZIP (at the root, alongside index.html)
2. Deploy handler reads and parses the file
3. Variables are set on the Netlify site automatically
4. The `.env.production` file is NOT included in the deployed files (for security)
5. Functions access variables via `process.env.DATABASE_URL`, etc.

### Example ZIP Structure

```
your-site.zip
├── index.html
├── assets/
├── functions/
│   └── api.js
└── .env.production    # REQUIRED when functions/ exists
```

### With Turso Database

```bash
# 1. Provision database
TURSO=$(curl -s -X POST "$API_URL/api/data/turso/provision" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" -d '{}')

# 2. Create .env.production with the credentials
echo "TURSO_URL=$(echo $TURSO | jq -r '.url')" > .env.production
echo "TURSO_AUTH_TOKEN=$(echo $TURSO | jq -r '.authToken')" >> .env.production

# 3. Include in ZIP and deploy
cd dist && zip -r ../site.zip . ../.env.production && cd ..
```

**Note:** If your functions don't need environment variables, include an empty `.env.production` file.

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

Auto-detects create vs update. Environment variables are read from `.env.production` file in the ZIP.

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
| "Unexpected token 'export'" | You're using ES modules - bundle with esbuild first |
| "uses ES module syntax" error | Bundle with esbuild: `npx esbuild src/fn.js --bundle --platform=node --format=cjs --outfile=functions/fn.js` |
| "Cannot find module 'xyz'" | You need to bundle dependencies - use esbuild to create self-contained function |
| Function 502 error | Check Netlify function logs; likely missing dependency - bundle with esbuild |

---

## Limits

| Resource | Limit |
|----------|-------|
| ZIP size | 100MB |
| Upload URL expiry | 1 hour |
| Function execution | 10 seconds |
| Function memory | 1024 MB |
