# Astro

**Type:** Static Site Generator (SSG)

## Initialize New Project

```bash
npm create astro@latest . -- --template minimal --typescript strict
npm install
```

## Build

```bash
npm run build
```

This creates output in `dist/`.

## Prepare for Deploy

```bash
mkdir -p .rebyte/static
cp -r dist/* .rebyte/static/
cat > .rebyte/config.json << 'EOF'
{
  "version": 1,
  "routes": [
    { "handle": "filesystem" }
  ]
}
EOF
```

Or create `scripts/prepare-rebyte.js`:

```javascript
#!/usr/bin/env node
import { cpSync, mkdirSync, rmSync, existsSync, writeFileSync } from 'fs';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const projectRoot = join(__dirname, '..');
const distDir = join(projectRoot, 'dist');
const rebyteDir = join(projectRoot, '.rebyte');

if (existsSync(rebyteDir)) rmSync(rebyteDir, { recursive: true });
mkdirSync(join(rebyteDir, 'static'), { recursive: true });

cpSync(distDir, join(rebyteDir, 'static'), { recursive: true });

// Create config.json with static routes
const config = {
  version: 1,
  routes: [
    { handle: "filesystem" }
  ]
};
writeFileSync(join(rebyteDir, 'config.json'), JSON.stringify(config, null, 2));

console.log('Build output ready at .rebyte/');
```

Update `package.json`:

```json
{
  "scripts": {
    "build": "astro build && node scripts/prepare-rebyte.js"
  }
}
```

## Deploy

```bash
node bin/rebyte.js deploy
```

## Verify Build

```bash
ls .rebyte/static/
# Should contain: index.html, _astro/, etc.
```

## Expected Deployment Report

```
Mode:      static
Static:    10-50 files (.html, .js, .css)
Function:  (none)
```

## Key Code Patterns

### Static Page

```astro
---
// src/pages/index.astro
const title = "My Astro Site";
---
<html>
  <head><title>{title}</title></head>
  <body>
    <h1>Welcome to Astro</h1>
  </body>
</html>
```

### Dynamic Route

```astro
---
// src/pages/blog/[slug].astro
export function getStaticPaths() {
  return [
    { params: { slug: 'post-1' } },
    { params: { slug: 'post-2' } },
  ];
}
const { slug } = Astro.params;
---
<h1>Blog: {slug}</h1>
```

## Troubleshooting

| Error | Fix |
|-------|-----|
| `dist/` empty | Run `astro build` first |
| Missing pages | Check `src/pages/` structure |
| 404 on routes | Ensure all routes have `.astro` files |
