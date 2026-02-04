---
name: rebyte-app-builder
description: Deploy web apps to Rebyte hosting. You (the agent) create the .rebyte/ directory with proper structure, the CLI validates and deploys. Supports static sites, SSR (Next.js with OpenNext), and API functions.
---

# Rebyte App Builder

Deploy web applications to Rebyte's AWS-based hosting platform.

{{include:non-technical-user.md}}

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

## Rebyte CLI (Pre-bundled)

```bash
# Validate without deploying
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js validate

# Deploy (validates first, then uploads)
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js deploy

# Other commands
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js info
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js logs
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js delete
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
// functions/default.func/index.js
exports.handler = async (event, context) => {
  // event is API Gateway format, NOT Node.js HTTP request
  const { httpMethod, path, headers, body, queryStringParameters } = event;

  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ message: 'Hello!' })
  };
};
```

**CRITICAL:** Lambda handlers receive API Gateway events, NOT Node.js HTTP requests. If you see errors like `req.on is not a function`, your handler expects HTTP format but received Lambda format.

---

## Framework-Specific Instructions

### Static Sites (Vite, Astro, Plain HTML)

```bash
# 1. Build
npm run build

# 2. Create .rebyte/
mkdir -p .rebyte/static
cp -r dist/* .rebyte/static/   # or build/, public/, etc.

# 3. Create config.json
cat > .rebyte/config.json << 'EOF'
{
  "version": 1,
  "routes": [
    { "handle": "filesystem" }
  ]
}
EOF

# 4. Deploy
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js deploy
```

### Next.js SSR (MUST use OpenNext)

**DO NOT** manually copy `.next/standalone/`. It won't work because:
1. The standalone server expects Node.js HTTP, not Lambda events
2. Missing proper request/response transformation

**USE OpenNext:**

```bash
# 1. Install OpenNext
npm install -D @opennextjs/aws

# 2. Build with OpenNext
npx @opennextjs/aws build

# 3. Transform .open-next/ to .rebyte/
mkdir -p .rebyte/static .rebyte/functions/default.func

# Copy static assets
cp -r .open-next/assets/* .rebyte/static/ 2>/dev/null || true
cp -r .open-next/cache/* .rebyte/static/_next/cache/ 2>/dev/null || true

# Copy server function
cp -r .open-next/server-functions/default/* .rebyte/functions/default.func/

# Create routes
cat > .rebyte/config.json << 'EOF'
{
  "version": 1,
  "routes": [
    { "src": "^/_next/static/(.*)$", "headers": { "Cache-Control": "public, max-age=31536000, immutable" } },
    { "handle": "filesystem" },
    { "src": "^/(.*)$", "dest": "/functions/default" }
  ]
}
EOF

# 4. Deploy
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js deploy
```

### Static Site + API Function

```bash
# 1. Build static site
npm run build

# 2. Create structure
mkdir -p .rebyte/static .rebyte/functions/api.func
cp -r dist/* .rebyte/static/

# 3. Create API handler
cat > .rebyte/functions/api.func/index.js << 'EOF'
exports.handler = async (event, context) => {
  const { httpMethod, path, body } = event;

  if (httpMethod === 'POST' && path === '/api/submit') {
    const data = JSON.parse(body || '{}');
    // Process data...
    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ success: true })
    };
  }

  return { statusCode: 404, body: 'Not Found' };
};
EOF

# 4. Create routes
cat > .rebyte/config.json << 'EOF'
{
  "version": 1,
  "routes": [
    { "src": "^/api/(.*)$", "dest": "/functions/api" },
    { "handle": "filesystem" }
  ]
}
EOF

# 5. Deploy
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js deploy
```

---

## CLI Validation

The CLI validates before deployment:

```
Validating .rebyte/...

✓ config.json exists: Found
✓ config.json valid JSON: Valid
✓ Routes defined: 2 routes
✓ Function default: entry file: index.js
✓ Function default: handler export: exports.handler
✓ Function default: smoke test: Passed
✓ Static directory: 47 files

Package Summary
═══════════════

Routes (from config.json):
  [filesystem]
  ^/(.*)$                        → Lambda: default

Functions (Lambda):
  default.func
    Entry:   index.js
    Handler: index.handler
    Runtime: nodejs20.x
    Size:    1.2 MB

Static (CDN):
  47 files, 2.3 MB
    _next/ - 45 files (.js, .css)
    index.html
    favicon.ico
```

### Validation Errors

If validation fails, the CLI tells you exactly what's wrong:

**Missing handler export:**
```
✗ Function default: handler export: "handler" not exported

    index.js does not export "handler"

    Found exports: main, processRequest
    Did you mean one of these?

    The handler must be exported as:
      exports.handler = async (event, context) => { ... }
```

**Wrong handler format (common with Next.js):**
```
✗ Function default: smoke test: Failed

    Handler Error: event.on is not a function

    This handler expects Node.js HTTP IncomingMessage (with .on() method)
    but Lambda provides API Gateway event objects.

    This usually happens when:
    1. Using Next.js standalone output directly (doesn't work)
    2. Missing a proper Lambda adapter

    For Next.js SSR, use OpenNext which creates proper Lambda handlers:
      npx @opennextjs/aws build
```

---

## Common Mistakes

### ❌ DON'T: Copy Next.js standalone directly

```bash
# WRONG - This creates a broken handler
cp -r .next/standalone/* .rebyte/functions/default.func/
```

The standalone server.js expects HTTP streams (`req.on('data')`) which don't exist in Lambda.

### ✅ DO: Use OpenNext for Next.js

```bash
# CORRECT - OpenNext creates proper Lambda handlers
npx @opennextjs/aws build
# Then copy .open-next/ contents to .rebyte/
```

### ❌ DON'T: Guess the handler format

```javascript
// WRONG - Lambda doesn't provide req.on()
exports.handler = async (req, res) => {
  req.on('data', chunk => { ... });
};
```

### ✅ DO: Use Lambda event format

```javascript
// CORRECT - Lambda event is an object, not a stream
exports.handler = async (event, context) => {
  const body = event.body ? JSON.parse(event.body) : {};
  return { statusCode: 200, body: JSON.stringify(result) };
};
```

---

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| `req.on is not a function` | Handler expects HTTP, got Lambda | Use OpenNext for Next.js, or fix handler to use Lambda format |
| `Cannot find module` | Dependencies not bundled | Include node_modules in function directory |
| 500 errors | Check Lambda logs | `rebyte.js logs -m 30` |
| 404 errors | Wrong routes | Check config.json routes match your paths |
| Static not loading | Files not in static/ | Verify `cp` copied to `.rebyte/static/` |

### Checking Logs

```bash
# Recent logs (5 min)
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js logs

# Longer range (30 min)
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js logs -m 30
```

---

## Quick Reference

| Deployment Type | Build Tool | Key Requirement |
|-----------------|------------|-----------------|
| Static (Vite, Astro) | `npm run build` | Copy to `.rebyte/static/` |
| Next.js SSR | OpenNext | `npx @opennextjs/aws build` |
| API Function | Manual | Lambda handler format |
| Nuxt SSR | Nitro | `NITRO_PRESET=aws-lambda npm run build` |
| Remix | Architect | `@remix-run/architect` adapter |

**Remember:** You create `.rebyte/`, the CLI validates and deploys. If validation fails, fix the issues based on the error messages.

---

## Database Options

If your app needs persistent data storage, ask the user which database type they prefer:

| Type | Skill | Best For |
|------|-------|----------|
| **SQL Database** | `sqlite-database` | Relational data, complex queries, joins |
| **Key-Value Database** | `dynamodb-database` | Simple lookups, high-performance NoSQL, flexible schema |

**When to ask:** If the user's requirements include data persistence but don't specify a database type, ask:
- "Do you need a SQL database (for relational data with joins) or a key-value store (for simple, fast lookups)?"

Both options are fully managed and automatically cleaned up when the site is deleted.

---

## AI Gateway (LLM Access)

If your app needs AI/LLM capabilities (chat, text generation, etc.), use the `ai-gateway` skill to provision an API key.

| Feature | Skill | Description |
|---------|-------|-------------|
| **AI Gateway** | `ai-gateway` | OpenAI-compatible API for LLM access (GPT, Claude, Gemini) |

**When to use:** If the user wants to build:
- AI chat applications
- Apps with text generation features
- Anything using Vercel AI SDK, LangChain, or OpenAI SDK

**How it works:**
1. Deploy your app first (using this skill)
2. Provision an AI Gateway key using the `ai-gateway` skill
3. Inject the key into your deployment's environment variables
4. Use standard OpenAI SDK or Vercel AI SDK in your server-side code

**Important:** The AI Gateway key must only be used in server-side code (Lambda functions, API routes). Never expose it in frontend JavaScript.

**Example with Vercel AI SDK:**
```typescript
// app/api/chat/route.ts (server-side)
import { openai } from '@ai-sdk/openai';
import { streamText } from 'ai';

export async function POST(req: Request) {
  const { messages } = await req.json();
  const result = streamText({
    model: openai('gemini-3-flash'), // Uses OPENAI_API_KEY from env
    messages,
  });
  return result.toDataStreamResponse();
}
```

Usage is automatically billed to your organization's credits.
