---
name: rebyte-app-builder
description: Build and deploy web applications on Rebyte. Use when user wants to deploy a web app.
---

# Rebyte App Builder

Deploy web applications to Rebyte infrastructure (like Vercel).

## The Flow

1. **You have code** - An existing project or new one
2. **Make it compatible** - Follow the framework guide if needed
3. **Deploy** - Run `node bin/rebyte.js deploy`
4. **Get the URL** - The CLI prints the live URL

## CLI Commands

Run `node bin/rebyte.js --help` for full usage.

| Command | What it does |
|---------|--------------|
| `deploy` | Build and deploy |
| `info` | Get deployment status and URL |
| `delete` | Remove deployment |
| `env` | Manage environment variables |

## Framework Guides

Each framework may need specific configuration. Read the guide before deploying:

| Framework | Guide |
|-----------|-------|
| Next.js | [frameworks/nextjs.md](frameworks/nextjs.md) |
| Vite | [frameworks/vite.md](frameworks/vite.md) |
| Nuxt | [frameworks/nuxt.md](frameworks/nuxt.md) |
| Astro | [frameworks/astro.md](frameworks/astro.md) |
| SvelteKit | [frameworks/sveltekit.md](frameworks/sveltekit.md) |
| Gatsby | [frameworks/gatsby.md](frameworks/gatsby.md) |

## Critical Rules

- **RUN the command** - Don't just show `rebyte deploy`, actually execute it
- **Use real URLs only** - The URL comes from CLI output, never make one up
- **No dev servers** - User can't access localhost
