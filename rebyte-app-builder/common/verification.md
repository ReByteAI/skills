# Build Verification

After building a project, verify the output before deploying.

## Quick Reference

| Framework | Mode | Check These Files |
|-----------|------|-------------------|
| Vite | Static | `dist/index.html` |
| Astro | Static | `dist/index.html` |
| Gatsby | Static | `public/index.html` |
| SvelteKit | Static | `build/index.html` |
| Next.js | Static | `out/index.html` |
| Next.js | SSR | `.open-next/assets/`, `.open-next/server-functions/default/index.mjs` |
| Nuxt | Static | `.output/public/index.html` |
| Nuxt | SSR | `.output/public/`, `.output/server/index.mjs` |

---

## Static Sites

For static sites, verify:

1. **Index file exists**
   ```bash
   ls <output-dir>/index.html
   ```

2. **Assets are bundled**
   ```bash
   ls <output-dir>/assets/  # or _next/, _nuxt/, _app/, _astro/
   ```

3. **No build errors in output**
   Check for error messages in build logs.

### Example: Vite

```bash
# After npm run build
ls dist/index.html         # Main HTML
ls dist/assets/            # JS/CSS bundles
cat dist/index.html        # Check for script/link tags
```

### Example: Next.js Static Export

```bash
# After npm run build (with output: 'export')
ls out/index.html          # Main HTML
ls out/_next/static/       # Static assets
```

---

## SSR Sites

For SSR sites, verify both static assets and server functions.

### Next.js with OpenNext

```bash
# After npx @opennextjs/aws build

# Static assets
ls .open-next/assets/                              # Assets directory
ls .open-next/assets/_next/static/                 # Next.js static files

# Server function
ls .open-next/server-functions/default/            # Function directory
ls .open-next/server-functions/default/index.mjs   # Entry point
ls .open-next/server-functions/default/node_modules/  # Dependencies
```

### Nuxt with Nitro

```bash
# After NITRO_PRESET=aws-lambda npm run build

# Static assets
ls .output/public/                    # Public directory
ls .output/public/_nuxt/              # Nuxt assets

# Server function
ls .output/server/                    # Server directory
ls .output/server/index.mjs           # Entry point
```

---

## Common Issues

### Missing index.html

**Cause**: Build failed or output directory is wrong.

**Check**:
1. Build command completed without errors
2. Framework config specifies correct output directory
3. No `output: 'standalone'` without OpenNext (for Next.js)

### Empty Assets Directory

**Cause**: No CSS/JS to bundle, or build didn't complete.

**Check**:
1. Source files import CSS
2. Build logs for errors
3. Framework plugins are configured

### Missing Server Function (SSR)

**Cause**: Built for wrong target or missing SSR config.

**Check**:
1. Next.js: OpenNext installed, `open-next.config.ts` exists
2. Nuxt: `NITRO_PRESET=aws-lambda` was set

### Large Bundle Size Warning

**Cause**: Unoptimized imports or large dependencies.

**Fix**:
1. Use dynamic imports: `const X = dynamic(() => import('./X'))`
2. Check for duplicate dependencies
3. Use tree-shaking compatible imports

---

## Verification Script

Run this to check common issues:

```bash
#!/bin/bash
# verify-build.sh

# Detect framework and check output
if [ -f "next.config.js" ] || [ -f "next.config.ts" ]; then
    if [ -d ".open-next" ]; then
        echo "Next.js SSR (OpenNext)"
        [ -f ".open-next/server-functions/default/index.mjs" ] && echo "✓ Server function" || echo "✗ Server function missing"
        [ -d ".open-next/assets/_next/static" ] && echo "✓ Static assets" || echo "✗ Static assets missing"
    elif [ -d "out" ]; then
        echo "Next.js Static Export"
        [ -f "out/index.html" ] && echo "✓ index.html" || echo "✗ index.html missing"
    else
        echo "✗ No build output found"
    fi

elif [ -f "nuxt.config.ts" ] || [ -f "nuxt.config.js" ]; then
    echo "Nuxt"
    [ -f ".output/server/index.mjs" ] && echo "✓ Server function" || echo "⚠ No server function (static only)"
    [ -d ".output/public/_nuxt" ] && echo "✓ Static assets" || echo "✗ Static assets missing"

elif [ -f "vite.config.ts" ] || [ -f "vite.config.js" ]; then
    echo "Vite"
    [ -f "dist/index.html" ] && echo "✓ index.html" || echo "✗ index.html missing"
    [ -d "dist/assets" ] && echo "✓ Assets bundled" || echo "✗ Assets missing"

elif [ -f "astro.config.mjs" ] || [ -f "astro.config.ts" ]; then
    echo "Astro"
    [ -f "dist/index.html" ] && echo "✓ index.html" || echo "✗ index.html missing"

elif [ -f "svelte.config.js" ]; then
    echo "SvelteKit"
    [ -f "build/index.html" ] && echo "✓ index.html" || echo "✗ index.html missing"

elif [ -f "gatsby-config.js" ] || [ -f "gatsby-config.ts" ]; then
    echo "Gatsby"
    [ -f "public/index.html" ] && echo "✓ index.html" || echo "✗ index.html missing"

else
    echo "Unknown framework"
fi
```

---

## Pre-Deployment Checklist

Before running `rebyte deploy`:

- [ ] Build completed without errors
- [ ] Output directory exists and contains expected files
- [ ] index.html (or server function) is present
- [ ] Assets are bundled (JS/CSS files exist)
- [ ] Environment variables are in `.env.production`
- [ ] No sensitive data in client-side code
