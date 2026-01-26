---
name: rebyte-app-builder
description: Deploy full-stack web apps to Rebyte (Lambda + S3/CloudFront)
triggers:
  - deploy to rebyte
  - rebyte deploy
  - deploy to lambda
  - serverless deploy
  - deploy next.js
  - deploy nuxt
  - deploy sveltekit
  - deploy remix
---

# Rebyte App Builder

## Supported Frameworks

| Framework | Adapter | Guide |
|-----------|---------|-------|
| Next.js | OpenNext | [nextjs.md](frameworks/nextjs.md) |
| Nuxt | Nitro aws-lambda | [nuxt.md](frameworks/nuxt.md) |
| SvelteKit | svelte-kit-sst | [sveltekit.md](frameworks/sveltekit.md) |
| Remix | @remix-run/architect | [remix.md](frameworks/remix.md) |

## Workflow

### 1. Build

Follow the framework guide to configure Lambda adapter, then:

```bash
npm run build
```

### 2. Deploy

```bash
node bin/rebyte.js deploy
```

Output includes the live URL.

### 3. Logs

```bash
node bin/rebyte.js logs
```

### 4. Test

Use Chrome DevTools MCP:

```javascript
mcp__chrome-devtools__navigate_page({ url: "https://your-app.rebyte.pro" })
mcp__chrome-devtools__take_snapshot()

mcp__chrome-devtools__navigate_page({ url: "https://your-app.rebyte.pro/api/data" })
mcp__chrome-devtools__take_snapshot()
```

## CLI Reference

| Command | Description |
|---------|-------------|
| `node bin/rebyte.js deploy` | Deploy to production |
| `node bin/rebyte.js info` | Get deployment URL |
| `node bin/rebyte.js logs` | View Lambda logs |
| `node bin/rebyte.js delete` | Remove deployment |
| `node bin/rebyte.js env set KEY=value` | Set env var |
| `node bin/rebyte.js env list` | List env vars |
