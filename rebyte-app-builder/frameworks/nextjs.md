# Next.js

**Adapter:** OpenNext

## Initialize New Project

```bash
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
npm install -D @opennextjs/aws
```

Create `open-next.config.ts`:

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

Update `next.config.ts`:

```typescript
const nextConfig = {
  output: 'standalone',
};

export default nextConfig;
```

Create `scripts/package-deploy.js`:

```javascript
#!/usr/bin/env node
import { cpSync, mkdirSync, rmSync, existsSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const projectRoot = join(__dirname, "..");
const openNextDir = join(projectRoot, ".open-next");
const rebyteDir = join(projectRoot, ".rebyte");

if (existsSync(rebyteDir)) rmSync(rebyteDir, { recursive: true });
mkdirSync(join(rebyteDir, "static"), { recursive: true });
mkdirSync(join(rebyteDir, "function"), { recursive: true });

cpSync(join(openNextDir, "assets"), join(rebyteDir, "static"), { recursive: true });
cpSync(join(openNextDir, "server-functions", "default"), join(rebyteDir, "function"), { recursive: true });

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

## Build

```bash
npm run build
```

## Verify Build

```bash
ls .rebyte/static/_next/static/
ls .rebyte/function/
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

| Error | Fix |
|-------|-----|
| `@opennextjs/aws not found` | `npm install -D @opennextjs/aws` |
| `output: 'standalone' required` | Add to `next.config.js` |
| API returns 404 | File must be `route.ts` not `index.ts` |
