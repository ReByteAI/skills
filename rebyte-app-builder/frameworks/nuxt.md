# Nuxt

**Adapter:** Nitro with `aws-lambda` preset (built-in)

## Initialize New Project

```bash
npx nuxi init . --packageManager npm
npm install
```

Update `nuxt.config.ts`:

```typescript
export default defineNuxtConfig({
  compatibilityDate: '2024-10-24',
  nitro: {
    preset: 'aws-lambda'
  }
});
```

Create `scripts/package-deploy.js`:

```javascript
#!/usr/bin/env node
import { cpSync, mkdirSync, rmSync, existsSync, writeFileSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const projectRoot = join(__dirname, "..");
const outputDir = join(projectRoot, ".output");
const rebyteDir = join(projectRoot, ".rebyte");

if (existsSync(rebyteDir)) rmSync(rebyteDir, { recursive: true });
mkdirSync(join(rebyteDir, "static"), { recursive: true });
mkdirSync(join(rebyteDir, "functions", "default.func"), { recursive: true });

// Copy static assets
cpSync(join(outputDir, "public"), join(rebyteDir, "static"), { recursive: true });

// Copy server function
cpSync(join(outputDir, "server"), join(rebyteDir, "functions", "default.func"), { recursive: true });

// Create wrapper for ESM handler
writeFileSync(join(rebyteDir, "functions", "default.func", "index.js"), `export { handler } from './index.mjs';`);

// Create config.json with routes
const config = {
  version: 1,
  routes: [
    { handle: "filesystem" },
    { src: "^/(.*)$", dest: "/functions/default" }
  ]
};
writeFileSync(join(rebyteDir, "config.json"), JSON.stringify(config, null, 2));

console.log("Build output ready at .rebyte/");
```

Update `package.json`:

```json
{
  "scripts": {
    "build": "nuxt build && node scripts/package-deploy.js"
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
ls .rebyte/functions/default.func/
cat .rebyte/config.json
```

## Key Code Patterns

### SSR Page

```vue
<!-- pages/ssr.vue -->
<template>
  <p data-testid="ssr-servertime">{{ serverTime }}</p>
</template>

<script setup>
const serverTime = useState('serverTime', () => Date.now());
</script>
```

### API Route

```typescript
// server/api/data.ts
export default defineEventHandler(() => {
  return {
    timestamp: new Date().toISOString(),
    serverTime: Date.now()
  };
});
```

## Troubleshooting

| Error | Fix |
|-------|-----|
| Missing Lambda output | Add `nitro.preset: 'aws-lambda'` |
| API returns HTML | File must be in `server/api/` |
