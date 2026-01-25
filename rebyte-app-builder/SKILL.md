---
name: rebyte-app-builder
description: Build and deploy full-stack web applications on Rebyte. Covers project initialization, framework configuration, static/SSR/API deployment. Supports Next.js, Vite, Nuxt, Astro, SvelteKit, Gatsby. Use when user wants to create, build, configure, or deploy a web app.
---

# Rebyte App Builder

Build and deploy full-stack web applications on Rebyte infrastructure.

## CRITICAL: You MUST Deploy (Not Just Show Commands)

**⚠️ DO NOT just show the `rebyte deploy` command - YOU MUST ACTUALLY RUN IT.**

After building, you MUST execute:
```bash
node bin/rebyte.js deploy
```

**⚠️ NEVER make up or guess deployment URLs.** The ONLY valid URL is the one printed by the `rebyte deploy` command output. Wait for the command to complete and copy the actual URL from the output.

**⚠️ DO NOT start a local dev server** (`npm run dev`, `next dev`, etc.) - the user cannot access localhost.

### Required Workflow

1. **Build the app** (framework-specific)
2. **Run `rebyte deploy`** - ACTUALLY EXECUTE IT, don't just show it
3. **Copy the URL from the deploy output** - this is the ONLY valid URL
4. **Share that URL with the user**

---

## Quick Start

This skill includes a bundled CLI (`bin/rebyte.js`). Run with Node.js 20+:

```bash
# In your project directory:
node bin/rebyte.js detect     # Identify framework
node bin/rebyte.js build      # Build the project
node bin/rebyte.js deploy     # Deploy - MUST RUN THIS, don't just show it
```

## Decision Tree

### Step 1: Assess the Directory

```
Is the directory empty?
├── YES → Go to "Initialize New Project"
└── NO  → Go to "Step 2: Detect Framework"
```

### Step 2: Detect Framework

Check for these config files:

| File | Framework | Guide |
|------|-----------|-------|
| `next.config.*` | Next.js | [frameworks/nextjs.md](frameworks/nextjs.md) |
| `vite.config.*` | Vite | [frameworks/vite.md](frameworks/vite.md) |
| `nuxt.config.*` | Nuxt | [frameworks/nuxt.md](frameworks/nuxt.md) |
| `astro.config.*` | Astro | [frameworks/astro.md](frameworks/astro.md) |
| `svelte.config.js` | SvelteKit | [frameworks/sveltekit.md](frameworks/sveltekit.md) |
| `gatsby-config.*` | Gatsby | [frameworks/gatsby.md](frameworks/gatsby.md) |

If no config file found but `package.json` exists, check dependencies to identify the framework.

### Step 3: Follow Framework Guide

Each framework guide covers:
1. **Initialize** - Scaffold new project (if empty directory)
2. **Convert** - Configure existing project for deployment
3. **Static** - Static site generation
4. **SSR** - Server-side rendering (if supported)
5. **API** - API routes / serverless functions
6. **Troubleshooting** - Common errors

### Step 4: Deploy (REQUIRED)

**You MUST run this command** - do not just show it to the user:

```bash
node bin/rebyte.js deploy
```

After the command completes, it will print the deployed URL. Copy that URL and share it with the user. **Never guess or fabricate URLs.**

---

## Initialize New Project

If the directory is empty, ask the user what type of application they want to build:

| Use Case | Recommended Framework |
|----------|----------------------|
| React SPA (no SSR needed) | Vite + React |
| React with SSR/API routes | Next.js |
| Vue SPA | Vite + Vue |
| Vue with SSR/API routes | Nuxt |
| Content-heavy site | Astro |
| Svelte app | SvelteKit |
| Blog/static site | Astro or Gatsby |

Then follow the **Initialize** section in the respective framework guide.

---

## Framework Capabilities

| Framework | Static | SSR | API Routes | Guide |
|-----------|--------|-----|------------|-------|
| Next.js | Yes | Yes | Yes | [nextjs.md](frameworks/nextjs.md) |
| Vite | Yes | No | No | [vite.md](frameworks/vite.md) |
| Nuxt | Yes | Yes | Yes | [nuxt.md](frameworks/nuxt.md) |
| Astro | Yes | Planned | Yes | [astro.md](frameworks/astro.md) |
| SvelteKit | Yes | Planned | Yes | [sveltekit.md](frameworks/sveltekit.md) |
| Gatsby | Yes | No | No | [gatsby.md](frameworks/gatsby.md) |

---

## Deployment Architecture

Two deployment modes are supported:

### Static Mode
- HTML/CSS/JS served from S3 + CloudFront CDN
- Fast, globally distributed
- No server-side code execution

### SSR Mode
- Static assets on S3 + CloudFront CDN
- Dynamic routes via AWS Lambda
- API Gateway for routing
- Lambda@Edge for intelligent request routing
- Supports streaming responses

See [protocol/manifest.md](protocol/manifest.md) for the deployment protocol details.

### AWS Infrastructure

| Component | Purpose |
|-----------|---------|
| **S3** | Static asset storage |
| **CloudFront** | Global CDN with `*.rebyte.pro` wildcard SSL |
| **Lambda@Edge** | Routes static vs dynamic requests |
| **API Gateway** | HTTP API for Lambda functions |
| **Lambda** | Executes SSR functions (Node.js 20.x) |

---

## Multiple Deployments

Each workspace can have multiple deployments using prefixes:

```bash
rebyte deploy                  # Default deployment
rebyte deploy --prefix api     # API service deployment
rebyte deploy --prefix docs    # Documentation site deployment
```

The actual URLs are shown in the `rebyte deploy` output. Always copy the URL from the CLI output to share with the user.

---

## Environment Variables

Two methods for setting environment variables:

1. **Build-time** (`.env.production` file):
   - Used during `npm run build`
   - Baked into static assets
   - Requires re-deploy to change

2. **Runtime** (Deployments API):
   - Stored in database
   - Synced to Lambda functions immediately
   - No re-deploy needed for SSR apps

See [common/environment.md](common/environment.md) for details.

---

## Common References

- [Rebyte CLI Usage](protocol/rebyte-cli.md) - CLI commands and options
- [Deployment Protocol](protocol/manifest.md) - rebyte.json manifest format
- [Build Verification](common/verification.md) - How to verify builds
- [Environment Variables](common/environment.md) - .env handling
