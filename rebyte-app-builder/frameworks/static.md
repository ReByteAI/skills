# Static Sites

**Type:** Static HTML/CSS/JS (no server-side rendering)

This guide covers static site deployment for:
- Gatsby
- Vite (React, Vue, etc.)
- Create React App
- Plain HTML/CSS/JS

## Gatsby

### Initialize

```bash
npm init gatsby . -- -y
npm install
```

### Build

```bash
npm run build
```

Output: `public/`

### Prepare for Deploy

```bash
mkdir -p .rebyte/static
cp -r public/* .rebyte/static/
cat > .rebyte/config.json << 'EOF'
{
  "version": 1,
  "routes": [
    { "handle": "filesystem" }
  ]
}
EOF
```

## Vite (React/Vue/etc.)

### Initialize

```bash
npm create vite@latest . -- --template react-ts
npm install
```

### Build

```bash
npm run build
```

Output: `dist/`

### Prepare for Deploy

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

## Plain HTML

For plain HTML sites, copy your files directly:

```bash
mkdir -p .rebyte/static
cp -r *.html *.css *.js .rebyte/static/
cp -r assets/ .rebyte/static/ 2>/dev/null || true
cat > .rebyte/config.json << 'EOF'
{
  "version": 1,
  "routes": [
    { "handle": "filesystem" }
  ]
}
EOF
```

### Minimal Structure

```
my-site/
├── index.html
├── style.css
├── script.js
└── assets/
    └── images/
```

## Universal Prepare Script

Create `scripts/prepare-rebyte.js` for any static site:

```javascript
#!/usr/bin/env node
import { cpSync, mkdirSync, rmSync, existsSync, writeFileSync } from 'fs';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const projectRoot = join(__dirname, '..');
const rebyteDir = join(projectRoot, '.rebyte');

// Detect build output directory
const buildDirs = ['dist', 'build', 'public', 'out', '.'];
let sourceDir = null;

for (const dir of buildDirs) {
  const fullPath = join(projectRoot, dir);
  if (existsSync(join(fullPath, 'index.html'))) {
    sourceDir = fullPath;
    break;
  }
}

if (!sourceDir) {
  console.error('Error: No build output found with index.html');
  process.exit(1);
}

if (existsSync(rebyteDir)) rmSync(rebyteDir, { recursive: true });
mkdirSync(join(rebyteDir, 'static'), { recursive: true });

cpSync(sourceDir, join(rebyteDir, 'static'), { recursive: true });

// Create config.json with static routes
const config = {
  version: 1,
  routes: [
    { handle: "filesystem" }
  ]
};
writeFileSync(join(rebyteDir, 'config.json'), JSON.stringify(config, null, 2));

console.log(`Build output from ${sourceDir} ready at .rebyte/`);
```

## Deploy

```bash
node bin/rebyte.js deploy
```

## Verify Build

```bash
ls .rebyte/static/
cat .rebyte/config.json
# static/ must contain: index.html
```

## Expected Deployment Report

```
Mode:      static
Static:    5-100 files (.html, .js, .css, .png, etc.)
Function:  (none)
```

## Common Output Directories

| Framework | Build Command | Output Dir |
|-----------|---------------|------------|
| Gatsby | `gatsby build` | `public/` |
| Vite | `vite build` | `dist/` |
| Create React App | `react-scripts build` | `build/` |
| Parcel | `parcel build` | `dist/` |
| Plain HTML | (none) | `.` |

## Troubleshooting

| Error | Fix |
|-------|-----|
| No `index.html` | Run build command first |
| Missing assets | Check relative paths in HTML |
| 404 on refresh | Add `_redirects` for SPA routing |
| Blank page | Check browser console for JS errors |

### SPA Routing Fix

For single-page apps with client-side routing, create `.rebyte/static/_redirects`:

```
/*    /index.html   200
```

This ensures all routes serve `index.html` and let the JS router handle navigation.
