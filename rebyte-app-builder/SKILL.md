---
name: rebyte-app-builder
description: Use when user says "rebyte deploy" or asks to deploy to Rebyte. Full Vercel-compatible hosting platform on AWS. Supports static sites (Vite, Astro, Gatsby), SSR frameworks (Next.js, Nuxt, SvelteKit, Remix), and API functions (serverless endpoints). Uses Vercel Build Output API format.
---

# Rebyte App Builder

Complete development lifecycle for deploying and testing full-stack applications on Rebyte.

## About Rebyte Hosting

Rebyte is a **Vercel-compatible hosting platform** built on AWS infrastructure. It implements the Vercel Build Output API, so any framework that works with Vercel works with Rebyte.

### Infrastructure

| Component | AWS Service | Purpose |
|-----------|-------------|---------|
| Static Assets | S3 + CloudFront | Global CDN with edge caching |
| Server Functions | Lambda | SSR, API routes, serverless functions |
| Routing | Lambda@Edge | Dynamic routing via config.json |
| SSL | ACM | Automatic HTTPS for *.rebyte.pro |

### Deployment Types

| Type | Use Case | Example |
|------|----------|---------|
| **Static** | Pure frontend, no server | Vite, Astro, Gatsby, plain HTML |
| **API** | Static + serverless functions | Landing page + Stripe webhooks |
| **SSR** | Full server-side rendering | Next.js, Nuxt, SvelteKit, Remix |

### How It Works

```
Your App → npm run build → .rebyte/ → rebyte deploy → https://myapp-xyz.rebyte.pro
                              │
                              ├── config.json   → Lambda@Edge (routing)
                              ├── static/       → S3 + CloudFront (CDN)
                              └── functions/    → AWS Lambda (API/SSR)
```

## Supported Frameworks

### SSR Frameworks (Full Server Rendering)

| Framework | Adapter | Output |
|-----------|---------|--------|
| **Next.js** | OpenNext | `.open-next/` |
| **Nuxt** | Nitro aws-lambda preset | `.output/` |
| **SvelteKit** | svelte-kit-sst | `.svelte-kit/svelte-kit-sst/` |
| **Remix** | @remix-run/architect | `build/` |

### Static Frameworks (CDN Only)

| Framework | Build Command | Output |
|-----------|---------------|--------|
| **Vite** (React, Vue, Svelte) | `npm run build` | `dist/` |
| **Astro** | `npm run build` | `dist/` |
| **Gatsby** | `npm run build` | `public/` |
| **Create React App** | `npm run build` | `build/` |
| **Plain HTML** | (none) | `.` |

### API Functions (Serverless)

Any static site can add API functions:

```
.rebyte/
├── config.json          # Routes /api/* to Lambda
├── static/              # Your static site
└── functions/
    └── api.func/        # Serverless function
        └── index.js     # exports { handler }
```

Use cases: Stripe webhooks, form handlers, database APIs, authentication endpoints.

## Build Output Format

All frameworks must produce `.rebyte/` directory:

```
.rebyte/
├── config.json       # REQUIRED → Routes configuration
├── static/           # REQUIRED → S3/CloudFront
│   ├── index.html
│   ├── assets/
│   └── ...
├── functions/        # OPTIONAL → Lambda functions (SSR/API)
│   └── default.func/
│       ├── .vc-config.json  # { "runtime": "nodejs20.x", "handler": "index.handler" }
│       └── index.js
└── .env.production   # OPTIONAL → environment variables
```

### config.json (Required)

```json
{
  "version": 1,
  "routes": [
    { "src": "^/api/(.*)$", "dest": "/functions/default" },
    { "handle": "filesystem" },
    { "src": "^/(.*)$", "dest": "/functions/default" }
  ]
}
```

Route types:
- `{ "handle": "filesystem" }` - Serve from static/ if file exists
- `{ "src": "^/pattern$", "dest": "/functions/name" }` - Route to Lambda

### Static Sites

For static sites, only `.rebyte/static/` is needed:

```bash
mkdir -p .rebyte/static
cp -r dist/* .rebyte/static/   # or build/, public/, etc.
```

### SSR Sites

For SSR, include both static assets and Lambda function:

```bash
mkdir -p .rebyte/static .rebyte/function
cp -r build/client/* .rebyte/static/
cp -r build/server/* .rebyte/function/
```

## Deploy Workflow

### 1. Build

```bash
npm run build
```

### 2. Verify Build

```bash
ls -la .rebyte/
ls -la .rebyte/static/
ls -la .rebyte/function/  # SSR only
```

### 3. Deploy

```bash
node bin/rebyte.js deploy
```

**CRITICAL:** Actually run this command. The deployment URL is ONLY available from the output.

### Expected Output

```
📦 Scanning .rebyte/ directory...
   Static files: 47
   Function: yes
   Package size: 2.3 MB

🔗 Getting upload URL...
   Deploy ID: myapp-abc123

⬆️  Uploading package...
   Upload complete

🚀 Deploying...

Deployed to https://*.rebyte.pro

Deployment Report:
──────────────────
Mode:      ssr
URL:       https://*.rebyte.pro
Deploy ID: myapp-abc123
Status:    deployed

Static Assets:
  Files:      47
  Total size: 2.3 MB
  Types:      .js (12), .html (3), .css (5), .png (27)

Function:
  Handler:    index.handler
  Runtime:    nodejs20.x
  Memory:     1024 MB
  Timeout:    30s
  Size:       1.2 MB
  Config:     from config.json

Environment:
  Variables:  0
```

### 4. Verify Deployment Report

| Check | What to look for |
|-------|------------------|
| Mode | `ssr` for SSR frameworks, `static` for static sites |
| Static files | Should have reasonable count (not 0) |
| Function | Should exist for SSR frameworks |

## CLI Commands

| Command | Description |
|---------|-------------|
| `node bin/rebyte.js deploy` | Package and deploy `.rebyte/` |
| `node bin/rebyte.js info` | Get deployment status and URL |
| `node bin/rebyte.js logs` | Get Lambda function logs (SSR/API only) |
| `node bin/rebyte.js logs -m 60` | Get logs from last 60 minutes (max: 480) |
| `node bin/rebyte.js delete` | Remove deployment |

## Browser Testing

After deployment, use Chrome DevTools MCP to verify:

| Check | How | Expected |
|-------|-----|----------|
| Homepage | Navigate to `/` | HTTP 200, HTML content |
| Static assets | Check network | CSS/JS loaded |
| API route | Navigate to `/api/data` | JSON response |
| SSR page | Navigate to `/ssr` | Server-rendered content |
| SSR dynamic | Reload `/ssr` | Content changes |

## Environment Variables

Set via `.rebyte/.env.production`:

```bash
echo "DATABASE_URL=postgres://..." >> .rebyte/.env.production
echo "API_KEY=secret123" >> .rebyte/.env.production
```

Redeploy after changes:

```bash
node bin/rebyte.js deploy
```

## Troubleshooting

| Issue | Check | Fix |
|-------|-------|-----|
| No `.rebyte/` | Build script | Add package step to build |
| 0 static files | Copy command | Verify source directory |
| Deploy fails | CLI output | Check error message |
| 500 errors | `node bin/rebyte.js logs` | Check Lambda logs for stack trace |
| 404 errors | Routes | Check file naming |
| API not working | `node bin/rebyte.js logs -m 30` | Check request/response logs |

### Debugging with Logs

For SSR and API deployments, use `rebyte logs` to inspect Lambda function errors:

```bash
# Check recent errors (last 5 minutes)
node bin/rebyte.js logs

# Check longer time range (last hour)
node bin/rebyte.js logs -m 60

# Check specific deployment
node bin/rebyte.js logs -p mysite -m 30
```

**What logs show:**
- Lambda function invocations
- Request/response details
- Stack traces for uncaught exceptions
- Console.log output from your server code

**Note:** Logs are only available for SSR/API deployments (not static sites).
