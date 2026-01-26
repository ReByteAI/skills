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
  - deploy astro
  - deploy gatsby
  - deploy static site
  - deploy html
---

# Rebyte App Builder

## SSR Frameworks (Lambda + S3)

| Framework | Adapter | Guide |
|-----------|---------|-------|
| Next.js | OpenNext | [nextjs.md](frameworks/nextjs.md) |
| Nuxt | Nitro aws-lambda | [nuxt.md](frameworks/nuxt.md) |
| SvelteKit | svelte-kit-sst | [sveltekit.md](frameworks/sveltekit.md) |
| Remix | @remix-run/architect | [remix.md](frameworks/remix.md) |

## Static Frameworks (S3 only)

| Framework | Guide |
|-----------|-------|
| Astro | [astro.md](frameworks/astro.md) |
| Gatsby | [gatsby.md](frameworks/gatsby.md) |
| Static HTML | [static-html.md](frameworks/static-html.md) |

## Workflow

### 1. Build

Follow the framework guide, then:

```bash
npm run build
```

(Skip for static HTML - no build needed)

### 2. Deploy

```bash
node bin/rebyte.js deploy
```

Output includes the live URL.

### 3. Logs (SSR only)

```bash
node bin/rebyte.js logs
```

### 4. Test

Use Chrome DevTools MCP:

```javascript
mcp__chrome-devtools__navigate_page({ url: "https://your-app.rebyte.pro" })
mcp__chrome-devtools__take_snapshot()
```

## CLI Reference

| Command | Description |
|---------|-------------|
| `node bin/rebyte.js deploy` | Deploy to production |
| `node bin/rebyte.js info` | Get deployment URL |
| `node bin/rebyte.js logs` | View Lambda logs (SSR only) |
| `node bin/rebyte.js delete` | Remove deployment |
| `node bin/rebyte.js env set KEY=value` | Set env var |
| `node bin/rebyte.js env list` | List env vars |
