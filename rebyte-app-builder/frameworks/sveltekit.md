# SvelteKit

**Adapter:** svelte-kit-sst + esbuild

## Initialize New Project

```bash
npx sv create . --template minimal --types ts --no-add-ons --no-install
npm install
npm install -D svelte-kit-sst esbuild
```

Update `svelte.config.js`:

```javascript
import adapter from 'svelte-kit-sst';

/** @type {import('@sveltejs/kit').Config} */
const config = {
  kit: {
    adapter: adapter()
  }
};

export default config;
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
const sstOutput = join(projectRoot, '.svelte-kit', 'svelte-kit-sst');
const rebyteDir = join(projectRoot, '.rebyte');
const funcDir = join(rebyteDir, 'functions', 'default.func');

if (existsSync(rebyteDir)) rmSync(rebyteDir, { recursive: true });
mkdirSync(join(rebyteDir, 'static'), { recursive: true });
mkdirSync(funcDir, { recursive: true });

// Copy static assets
cpSync(join(sstOutput, 'client'), join(rebyteDir, 'static'), { recursive: true });

// Bundle Lambda handler
await build({
  entryPoints: [join(sstOutput, 'server', 'lambda-handler', 'index.js')],
  bundle: true,
  platform: 'node',
  target: 'node20',
  format: 'esm',
  outfile: join(funcDir, 'index.mjs'),
  banner: {
    js: `import { createRequire } from 'module';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
const require = createRequire(import.meta.url);
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);`
  }
});

// Create config.json with routes
const config = {
  version: 1,
  routes: [
    { handle: "filesystem" },
    { src: "^/(.*)$", dest: "/functions/default" }
  ]
};
writeFileSync(join(rebyteDir, 'config.json'), JSON.stringify(config, null, 2));

console.log("Build output ready at .rebyte/");
```

Update `package.json`:

```json
{
  "scripts": {
    "build": "vite build && node scripts/bundle-lambda.js"
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
ls .rebyte/functions/default.func/index.mjs
cat .rebyte/config.json
```

## Key Code Patterns

### SSR Page

```typescript
// src/routes/ssr/+page.server.ts
export function load() {
  return { serverTime: Date.now() };
}
```

```svelte
<!-- src/routes/ssr/+page.svelte -->
<script>
  export let data;
</script>
<p data-testid="ssr-servertime">{data.serverTime}</p>
```

### API Route

```typescript
// src/routes/api/data/+server.ts
import { json } from '@sveltejs/kit';

export function GET() {
  return json({
    timestamp: new Date().toISOString(),
    serverTime: Date.now()
  });
}
```

## Troubleshooting

| Error | Fix |
|-------|-----|
| `svelte-kit-sst not found` | `npm install -D svelte-kit-sst` |
| `lambda-handler not found` | Check adapter in `svelte.config.js` |
| API returns 404 | File must be `+server.ts` |
