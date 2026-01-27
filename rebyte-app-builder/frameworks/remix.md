# Remix

**Adapter:** @remix-run/architect + esbuild

## Initialize New Project

```bash
npx create-remix@latest . --template remix-run/remix/templates/remix
npm install @remix-run/architect
npm install -D esbuild
```

Update `vite.config.ts`:

```typescript
import { vitePlugin as remix } from "@remix-run/dev";
import { defineConfig } from "vite";

export default defineConfig({
  plugins: [remix({ serverBuildFile: "index.js" })],
  build: { target: "node20" },
});
```

Create `scripts/bundle-lambda.js`:

```javascript
#!/usr/bin/env node
import { build } from 'esbuild';
import { cpSync, mkdirSync, rmSync, existsSync, writeFileSync } from 'fs';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const projectRoot = join(__dirname, '..');
const serverDir = join(projectRoot, 'build', 'server');
const clientDir = join(projectRoot, 'build', 'client');
const rebyteDir = join(projectRoot, '.rebyte');

if (existsSync(rebyteDir)) rmSync(rebyteDir, { recursive: true });
mkdirSync(join(rebyteDir, 'static'), { recursive: true });
mkdirSync(join(rebyteDir, 'function'), { recursive: true });

cpSync(clientDir, join(rebyteDir, 'static'), { recursive: true });

const entry = join(rebyteDir, 'function', '_entry.js');
writeFileSync(entry, `
import { createRequestHandler } from '@remix-run/architect';
import * as build from '${join(serverDir, 'index.js').replace(/\\/g, '/')}';
export const handler = createRequestHandler({ build, mode: 'production' });
`);

await build({
  entryPoints: [entry],
  bundle: true,
  platform: 'node',
  target: 'node20',
  format: 'esm',
  outfile: join(rebyteDir, 'function', 'index.mjs'),
  external: ['@aws-sdk/*'],
  banner: {
    js: `import { createRequire } from 'module';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
const require = createRequire(import.meta.url);
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);`
  }
});

rmSync(entry);

console.log("Build output ready at .rebyte/");
```

Update `package.json`:

```json
{
  "scripts": {
    "build": "remix vite:build && node scripts/bundle-lambda.js"
  }
}
```

## Build

```bash
npm run build
```

## Verify Build

```bash
ls .rebyte/static/
ls .rebyte/function/index.mjs
```

## Key Code Patterns

### SSR Page

```tsx
// app/routes/ssr.tsx
import { useLoaderData } from "@remix-run/react";

export function loader() {
  return { serverTime: Date.now() };
}

export default function SSRPage() {
  const data = useLoaderData<typeof loader>();
  return <p data-testid="ssr-servertime">{data.serverTime}</p>;
}
```

### API Route

```tsx
// app/routes/api.data.tsx
import { json } from "@remix-run/node";

export function loader() {
  return json({
    timestamp: new Date().toISOString(),
    serverTime: Date.now()
  });
}
```

## Troubleshooting

| Error | Fix |
|-------|-----|
| `@remix-run/architect not found` | `npm install @remix-run/architect` |
| `build/server not found` | Run `remix vite:build` first |
| API returns 404 | Check route naming: `api.data.tsx` → `/api/data` |
