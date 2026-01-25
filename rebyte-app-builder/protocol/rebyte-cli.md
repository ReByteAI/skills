# Rebyte AppBuilder CLI

The Rebyte AppBuilder CLI handles framework detection, building, and deployment. Similar to Vercel CLI but workspace-scoped.

## Installation

This skill includes a bundled CLI at `bin/rebyte.js`. Run it with Node.js:

```bash
# From skill directory
node bin/rebyte.js detect
node bin/rebyte.js build
node bin/rebyte.js deploy

# Or create an alias
alias rebyte="node /path/to/skill/bin/rebyte.js"
```

Requires Node.js 20+.

## Commands

### rebyte detect

Identify the framework and show build configuration.

```bash
rebyte detect

# Output:
#   Framework:    Next.js
#   Mode:         SSR (Server-Side Rendering)
#   Confidence:   high
#   Config:       next.config.js
#   Build cmd:    npx @opennextjs/aws build
#   Output dir:   .open-next/
```

Options:
- `-d, --dir <path>` - Project directory (default: current directory)

### rebyte build

Build the project without deploying.

```bash
rebyte build
```

Options:
- `-d, --dir <path>` - Project directory
- `--skip-install` - Skip `npm install`
- `-v, --verbose` - Show build output

The CLI automatically:
1. Detects the framework
2. Runs `npm install` (unless skipped)
3. Runs the appropriate build command
4. Transforms output for deployment (e.g., OpenNext for Next.js SSR)

### rebyte deploy

Build and deploy the project.

```bash
rebyte deploy
```

Options:
- `-d, --dir <path>` - Project directory
- `--skip-install` - Skip `npm install`
- `--skip-build` - Use existing build output
- `-p, --prefix <name>` - Deployment prefix (for multiple sites per workspace)
- `-v, --verbose` - Show build output
- `--api-url <url>` - API URL (default: from REBYTE_API_URL)
- `--api-token <token>` - API token (default: from REBYTE_API_TOKEN)

Example output:
```
🔍 Detecting framework...
  Detected: Next.js (SSR)

🔨 Building project...
  Running: npm install
  Running: npx @opennextjs/aws build

✅ Build complete!

📦 Packaging...
  Creating rebyte.json manifest
  Zipping static assets and functions

🚀 Deploying...
  Uploading to GCS...
  Triggering deployment...

✅ Deployment successful!

   🌐 URL: https://{deploy-id}.rebyte.pro   ← The CLI outputs your actual URL here
   📦 Deploy ID: {deploy-id}
   📊 Status: deployed

ℹ️  SSR deployment: Static assets on S3/CloudFront, dynamic routes via Lambda.

**IMPORTANT:** The URL shown in the deploy output is your actual live URL. Copy it from the CLI output and share it with the user.
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `REBYTE_API_URL` | API endpoint (default: production) |
| `REBYTE_API_TOKEN` | Authentication token (required) |

In Rebyte VMs, these are automatically set from `~/.rebyte.ai/auth.json`.

## How It Works

```
rebyte deploy
    │
    ├── 1. Detect framework (next.config.js → Next.js)
    │
    ├── 2. Build project
    │   ├── npm install
    │   └── Framework-specific build command
    │
    ├── 3. Transform output (if needed)
    │   └── e.g., OpenNext for Next.js SSR
    │
    ├── 4. Create ZIP package
    │   ├── rebyte.json (manifest)
    │   ├── static/ (assets)
    │   └── functions/ (SSR only)
    │
    ├── 5. Upload to GCS
    │   └── PUT to signed URL
    │
    └── 6. Trigger deployment
        └── POST /api/data/deployments/update
```

## Framework-Specific Build Commands

| Framework | Mode | Build Command |
|-----------|------|---------------|
| Vite | Static | `npm run build` |
| Astro | Static | `npm run build` |
| Gatsby | Static | `npm run build` |
| SvelteKit | Static | `npm run build` |
| Next.js | Static | `npm run build` |
| Next.js | SSR | `npx @opennextjs/aws build` |
| Nuxt | SSR | `NITRO_PRESET=aws-lambda npx nuxt build` |

The CLI selects the appropriate command based on framework detection and project configuration.

## Multiple Deployments per Workspace

Use the `--prefix` flag to deploy multiple sites from the same workspace:

```bash
# Main app (default)
rebyte deploy

# API service
rebyte deploy --prefix api

# Documentation site
rebyte deploy --prefix docs
```

Each prefix creates a separate deployment with its own URL (the actual URLs are shown in the deploy output):
- Default deployment: `https://{deploy-id}.rebyte.pro`
- With `--prefix api`: `https://api-{workspace-suffix}.rebyte.pro`
- With `--prefix docs`: `https://docs-{workspace-suffix}.rebyte.pro`

## Environment Variables in Deployments

Environment variables can be set in two ways:

1. **Build-time**: Create `.env.production` file (used during build)
2. **Runtime**: Use the deployments API to set env vars (synced to Lambda)

For SSR deployments, runtime env vars are immediately synced to all Lambda functions without redeploying.
