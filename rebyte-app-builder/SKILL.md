---
name: rebyte-app-builder
description: Deploy web apps to Rebyte hosting. You (the agent) create the .rebyte/ directory with proper structure, the CLI validates and deploys. Supports static sites, SSR (Next.js with OpenNext), and API functions.
---

# Rebyte App Builder

Deploy web applications to Rebyte's AWS-based hosting platform.

{{include:non-technical-user.md}}

{{include:skill-dir.md}}

## Architecture: Agent Creates, CLI Deploys

**You (the coding agent)** are responsible for:
- Building the application using framework-specific tools
- Creating the `.rebyte/` directory with correct structure
- Using proper adapters (e.g., OpenNext for Next.js SSR)

**The CLI** is responsible for:
- Validating your `.rebyte/` structure
- Running smoke tests on Lambda handlers
- Providing clear error messages when something is wrong
- Packaging and uploading to Rebyte

## CLI Commands

```bash
node $SKILL_DIR/bin/rebyte.js validate   # Validate without deploying
node $SKILL_DIR/bin/rebyte.js deploy     # Validate + deploy
node $SKILL_DIR/bin/rebyte.js info       # Deployment status
node $SKILL_DIR/bin/rebyte.js logs       # Lambda logs (recent 5 min)
node $SKILL_DIR/bin/rebyte.js logs -m 30 # Lambda logs (30 min)
node $SKILL_DIR/bin/rebyte.js delete     # Delete deployment
```

## .rebyte/ Directory Structure

```
.rebyte/
├── config.json           # REQUIRED: Routes configuration
├── static/               # Static files → S3/CloudFront CDN
│   ├── index.html
│   └── assets/
├── functions/            # OPTIONAL: Lambda functions for SSR/API
│   └── default.func/
│       └── index.js      # Must export: exports.handler
└── .env.production       # OPTIONAL: Environment variables
```

### config.json (Required)

```json
{
  "version": 1,
  "routes": [
    { "handle": "filesystem" },
    { "src": "^/(.*)$", "dest": "/functions/default" }
  ]
}
```

**Route types:**
- `{ "handle": "filesystem" }` - Serve from static/ if file exists
- `{ "src": "^/pattern$", "dest": "/functions/name" }` - Route to Lambda

### Lambda Handler Format

```javascript
exports.handler = async (event, context) => {
  const { httpMethod, path, headers, body, queryStringParameters } = event;
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ message: 'Hello!' })
  };
};
```

**CRITICAL:** Lambda handlers receive API Gateway events, NOT Node.js HTTP requests. If you see `req.on is not a function`, the handler expects HTTP format but received Lambda format.

## Deployment Workflow

### 1. Build the Application

Use framework-specific build tools. See Framework Guide below.

### 2. Create .rebyte/ Directory

Copy build output into `.rebyte/static/` and `.rebyte/functions/` as needed. See the framework reference for exact commands.

### 3. Deploy

```bash
node $SKILL_DIR/bin/rebyte.js deploy
```

### 4. Verify (SSR only)

**SSR deployments need ~90 seconds to propagate.** Do NOT immediately debug errors.

```bash
sleep 90
curl -s -o /dev/null -w '%{http_code}' https://<deploy-id>.rebyte.pro
```

Static-only deploys propagate faster (~30 seconds). See `references/verification.md` for full details.

## Framework Guide

| Framework | Type | Reference |
|-----------|------|-----------|
| **Next.js** | SSR | `frameworks/nextjs.md` — **MUST use OpenNext** |
| **Nuxt** | SSR | `frameworks/nuxt.md` |
| **Remix** | SSR | `frameworks/remix.md` |
| **SvelteKit** | SSR | `frameworks/sveltekit.md` |
| **Vite / React / Vue** | Static | `frameworks/static.md` |
| **Astro** | Static | `frameworks/astro.md` |
| **Plain HTML** | Static | `frameworks/static.md` |
| **Static + API** | Hybrid | `references/api-functions.md` |

## Additional Features

| Feature | Reference | When to Use |
|---------|-----------|-------------|
| **Database** | `references/database.md` | App needs persistent data storage |
| **AI Gateway** | `references/ai-gateway.md` | App needs LLM/AI capabilities |
| **Troubleshooting** | `references/troubleshooting.md` | Deployment errors, common mistakes |
| **Post-Deploy Verification** | `references/verification.md` | SSR deploy returns 500/502/403 |

## Agent Rules

- Deploy automatically after building — don't ask permission
- For Next.js SSR, ALWAYS use OpenNext — never copy `.next/standalone/` directly
- After SSR deploy, ALWAYS wait 90 seconds before verifying the URL
- If validation fails, read the error message — it tells you exactly what's wrong
- Load framework references on-demand — only read what you need
