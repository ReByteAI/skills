# Next.js SSR

**Adapter:** OpenNext (`@opennextjs/aws`)

**DO NOT** manually copy `.next/standalone/`. It won't work because the standalone server expects Node.js HTTP streams, not Lambda events.

## Initialize New Project

```bash
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
npm install -D @opennextjs/aws
```

### Required: next.config.ts

```typescript
const nextConfig = {
  output: 'standalone',
  images: {
    unoptimized: true, // REQUIRED: Lambda doesn't support on-demand image optimization
  },
};

export default nextConfig;
```

Both `output: 'standalone'` and `images.unoptimized` are required. Without `standalone`, OpenNext cannot build. Without `unoptimized`, image requests will fail at runtime.

### Required: open-next.config.ts

```typescript
import type { OpenNextConfig } from "@opennextjs/aws/types/open-next.js";

const config: OpenNextConfig = {
  default: {
    override: {
      wrapper: "aws-lambda",
      converter: "aws-apigw-v2",
    },
  },
};

export default config;
```

## Build

```bash
npx @opennextjs/aws build
```

This creates `.open-next/` with:
- `assets/` — Static files (HTML, CSS, JS)
- `server-functions/default/` — Lambda handler + bundled server code
- `cache/` — Pre-rendered page cache

## Prepare .rebyte/ Directory

### Option A: Package Script (Recommended)

Create `scripts/package-deploy.js`:

```javascript
#!/usr/bin/env node
import { cpSync, mkdirSync, rmSync, existsSync, writeFileSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const projectRoot = join(__dirname, "..");
const openNextDir = join(projectRoot, ".open-next");
const rebyteDir = join(projectRoot, ".rebyte");

if (existsSync(rebyteDir)) rmSync(rebyteDir, { recursive: true });
mkdirSync(join(rebyteDir, "static"), { recursive: true });
mkdirSync(join(rebyteDir, "functions", "default.func"), { recursive: true });

// Copy static assets
cpSync(join(openNextDir, "assets"), join(rebyteDir, "static"), { recursive: true });

// Copy server function (cpSync correctly copies hidden directories like .next/)
cpSync(join(openNextDir, "server-functions", "default"), join(rebyteDir, "functions", "default.func"), { recursive: true });

// Create config.json with routes
const config = {
  version: 1,
  routes: [
    { src: "^/_next/static/(.*)$", headers: { "Cache-Control": "public, max-age=31536000, immutable" } },
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
    "build": "npx @opennextjs/aws build && node scripts/package-deploy.js"
  }
}
```

### Option B: Shell Commands

```bash
mkdir -p .rebyte/static .rebyte/functions/default.func

# Copy static assets
cp -r .open-next/assets/* .rebyte/static/ 2>/dev/null || true

# Copy server function — MUST use /. to include hidden directories (.next/)
cp -r .open-next/server-functions/default/. .rebyte/functions/default.func/

# Create routes
cat > .rebyte/config.json << 'EOF'
{
  "version": 1,
  "routes": [
    { "src": "^/_next/static/(.*)$", "headers": { "Cache-Control": "public, max-age=31536000, immutable" } },
    { "handle": "filesystem" },
    { "src": "^/(.*)$", "dest": "/functions/default" }
  ]
}
EOF
```

**CRITICAL — You MUST use `cp -r .../default/.` (with `/.`) instead of `cp -r .../default/*`.**

Shell glob `*` does NOT match hidden directories. The OpenNext build puts a `.next/` directory inside `server-functions/default/` containing:
- `required-server-files.json` (server will crash without this)
- `package.json` with `"type": "commonjs"` (required for correct module resolution)
- Pre-built server files

If you use `*`, the Lambda will crash with `ENOENT: required-server-files.json` or `ERR_REQUIRE_ESM` errors.

**CRITICAL — Do NOT manually copy `.next/` from the project build directory.** If the smoke test fails with missing `.next/` files, fix the `cp` command — do NOT copy from the project's raw `.next/` directory. The project's `.next/package.json` has `"type": "module"` while OpenNext's packaged `.next/package.json` has `"type": "commonjs"`. Copying the wrong one causes `ERR_REQUIRE_ESM` at runtime.

## Deploy

```bash
node $SKILL_DIR/bin/rebyte.js deploy
```

## Post-Deploy Verification

SSR deployments need ~90 seconds for full propagation (Lambda@Edge config cache + CloudFront invalidation).

```bash
echo "Waiting 90 seconds for deployment to propagate..."
sleep 90

# Verify
curl -s -o /dev/null -w '%{http_code}' https://<deploy-id>.rebyte.pro
# Should return 200

# Only if non-200 after waiting:
node $SKILL_DIR/bin/rebyte.js logs
```

**Do NOT debug 500/502/403 errors that appear immediately after deploy — these are propagation delays, not bugs.** Only investigate if errors persist after 2 minutes.

## Verify Build

```bash
ls .rebyte/static/_next/static/
ls .rebyte/functions/default.func/
ls .rebyte/functions/default.func/.next/   # MUST exist (hidden directory)
cat .rebyte/config.json
```

## Key Code Patterns

### SSR Page

```typescript
// src/app/ssr/page.tsx
export const dynamic = 'force-dynamic';

export default function SSRPage() {
  return <p data-testid="ssr-servertime">{Date.now()}</p>;
}
```

### API Route

```typescript
// src/app/api/data/route.ts
import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({
    timestamp: new Date().toISOString(),
    serverTime: Date.now()
  });
}
```

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `@opennextjs/aws not found` | Not installed | `npm install -D @opennextjs/aws` |
| `output: 'standalone' required` | Missing config | Add `output: 'standalone'` to `next.config.ts` |
| `ENOENT: required-server-files.json` | Hidden `.next/` dir not copied | Use `cp -r .../default/.` instead of `cp -r .../default/*` |
| `ERR_REQUIRE_ESM` | Wrong `.next/` copied | Re-copy with `/.`, never copy raw project `.next/` |
| `req.on is not a function` | Standalone server, not OpenNext | Use `npx @opennextjs/aws build`, not raw `.next/standalone/` |
| API returns 404 | Wrong file convention | File must be `route.ts` not `index.ts` |
| 500/502 right after deploy | Propagation delay | Wait 90 seconds, then retry |
| Image optimization errors | Missing config | Add `images: { unoptimized: true }` to next.config |
