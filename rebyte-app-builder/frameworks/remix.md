# Remix

**Adapter:** @remix-run/architect + esbuild

## Install

```bash
npm install @remix-run/architect
npm install -D esbuild
```

## Configure

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
const deployDir = join(projectRoot, 'deploy');

if (existsSync(deployDir)) rmSync(deployDir, { recursive: true });
mkdirSync(join(deployDir, 'static'), { recursive: true });
mkdirSync(join(deployDir, 'function'), { recursive: true });

cpSync(clientDir, join(deployDir, 'static'), { recursive: true });

const entry = join(deployDir, 'function', '_entry.js');
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
  outfile: join(deployDir, 'function', 'index.mjs'),
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

## Output

```
deploy/
├── static/   # Static files → S3
└── function/ # Lambda handler (index.mjs)
```
