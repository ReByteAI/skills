---
name: rebyte-app-builder
description: Full development lifecycle for web apps on Rebyte. Handles build, deploy, logs, and testing for SSR frameworks (Next.js, Nuxt, SvelteKit, Remix) and static sites (Astro, Gatsby, HTML).
---

# Rebyte App Builder

Complete development lifecycle for deploying and testing web applications on Rebyte.

## About Rebyte Hosting

Rebyte is a serverless hosting platform similar to Vercel or Netlify. It supports:

- **Static sites** → Deployed to S3 + CloudFront CDN
- **SSR apps** → Static assets on CDN + Lambda for server rendering

Unlike Vercel (which auto-detects frameworks), Rebyte uses a **fixed directory structure** similar to Netlify's approach. You build your app, place output in `.rebyte/`, and deploy.

### How It Works

```
Your App → npm run build → .rebyte/ → rebyte deploy → Live URL
                              │
                              ├── static/     → CDN (S3 + CloudFront)
                              └── function/   → AWS Lambda (SSR only)
```

## Supported Frameworks

### SSR Frameworks (Static + Lambda)

| Framework | Adapter | Guide |
|-----------|---------|-------|
| Next.js | OpenNext | [frameworks/nextjs.md](frameworks/nextjs.md) |
| Nuxt | Nitro aws-lambda | [frameworks/nuxt.md](frameworks/nuxt.md) |
| SvelteKit | svelte-kit-sst | [frameworks/sveltekit.md](frameworks/sveltekit.md) |
| Remix | @remix-run/architect | [frameworks/remix.md](frameworks/remix.md) |

### Static Frameworks (CDN only)

| Framework | Output Dir | Guide |
|-----------|------------|-------|
| Astro | `dist/` | [frameworks/astro.md](frameworks/astro.md) |
| Gatsby | `public/` | [frameworks/static.md](frameworks/static.md) |
| Vite/React | `dist/` | [frameworks/static.md](frameworks/static.md) |
| Plain HTML | `.` | [frameworks/static.md](frameworks/static.md) |

## Build Output Format

All frameworks must produce `.rebyte/` directory:

```
.rebyte/
├── static/           # REQUIRED → S3/CloudFront
│   ├── index.html
│   ├── assets/
│   └── ...
├── function/         # OPTIONAL → AWS Lambda (SSR only)
│   ├── config.json   # { "handler": "index.handler" }
│   └── index.mjs     # exports { handler }
└── .env.production   # OPTIONAL → environment variables
```

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

Deployed to https://myapp-abc123.rebyte.pro

Deployment Report:
──────────────────
Mode:      ssr
URL:       https://myapp-abc123.rebyte.pro
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
| 500 errors | Browser console | Check server code |
| 404 errors | Routes | Check file naming |
