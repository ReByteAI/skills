# Next.js

Next.js is a React framework supporting static generation, server-side rendering, and API routes.

> **⚠️ IMPORTANT:** After building, you MUST run `node bin/rebyte.js deploy`. Do NOT just show the command - actually execute it. The deployment URL is ONLY available from the command output. Never make up or guess URLs.

| Feature | Supported |
|---------|-----------|
| Static | Yes |
| SSR | Yes (via OpenNext) |
| API Routes | Yes |

## Detection

Config files: `next.config.js`, `next.config.ts`, `next.config.mjs`

---

## Initialize (Empty Directory)

Create a new Next.js project:

```bash
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
```

This creates:
- App Router (`src/app/`)
- TypeScript
- Tailwind CSS
- ESLint

For SSR deployment, add OpenNext configuration (see [Convert](#convert-existing-project) section).

---

## Convert (Existing Project)

### For Static Export

If the app has no dynamic features (no API routes, no SSR):

1. Update `next.config.js`:

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
};

module.exports = nextConfig;
```

2. Build and deploy (MUST run this command):

```bash
node bin/rebyte.js deploy
```

The URL will be shown in the output - copy it and share with the user.

### For SSR Deployment

If the app uses SSR, API routes, or dynamic features:

1. Install OpenNext:

```bash
npm install -D @opennextjs/aws
```

2. Create `open-next.config.ts` in the project root:

```typescript
import type { OpenNextConfig } from "@opennextjs/aws/types/open-next.js";

const config: OpenNextConfig = {
  default: {
    override: {
      wrapper: "aws-lambda-streaming",
      converter: "aws-apigw-v2",
    },
  },
};

export default config;
```

3. Ensure `next.config.js` has standalone output:

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',  // Required for Lambda
};

module.exports = nextConfig;
```

4. Deploy (MUST run this command):

```bash
node bin/rebyte.js deploy
```

The URL will be shown in the output - copy it and share with the user.

---

## Static

Static export generates HTML files at build time.

### When to Use

- Marketing sites
- Blogs
- Documentation
- Apps with no server-side data fetching

### Configuration

```javascript
// next.config.js
const nextConfig = {
  output: 'export',
};
```

### Build Output

```
out/
├── index.html
├── about.html
├── _next/
│   └── static/
└── images/
```

### Limitations

- No API routes
- No `getServerSideProps`
- No incremental static regeneration (ISR)
- No middleware
- No image optimization (use external service)

### Static Data Fetching

Use `generateStaticParams` for dynamic routes:

```typescript
// src/app/posts/[slug]/page.tsx
export async function generateStaticParams() {
  const posts = await getPosts();
  return posts.map((post) => ({ slug: post.slug }));
}

export default function PostPage({ params }: { params: { slug: string } }) {
  // ...
}
```

---

## SSR (Server-Side Rendering)

SSR renders pages on each request. Rebyte uses OpenNext to deploy Next.js SSR on AWS Lambda.

### When to Use

- Personalized content
- Real-time data
- Authentication-protected pages
- API routes

### How It Works

```
Request → CDN → Lambda (if not cached)
                   │
                   └── Renders page
                   └── Returns HTML
```

Static assets (`/_next/static/*`) are served directly from CDN.

### Server Components

App Router uses React Server Components by default:

```typescript
// src/app/dashboard/page.tsx
// This is a Server Component (default)
export default async function DashboardPage() {
  const data = await fetchData(); // Runs on server
  return <div>{data.title}</div>;
}
```

### Client Components

Add `"use client"` for client-side interactivity:

```typescript
"use client";

import { useState } from "react";

export default function Counter() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
}
```

### Server Actions

Server Actions run on the server and can be called from client components:

```typescript
// src/app/actions.ts
"use server";

export async function createPost(formData: FormData) {
  const title = formData.get("title");
  // Save to database
  return { success: true };
}
```

```typescript
// src/app/new-post/page.tsx
"use client";

import { createPost } from "../actions";

export default function NewPostPage() {
  return (
    <form action={createPost}>
      <input name="title" />
      <button type="submit">Create</button>
    </form>
  );
}
```

---

## API Routes

API routes are serverless functions that handle HTTP requests.

### App Router API Routes

Create `route.ts` files in `src/app/api/`:

```typescript
// src/app/api/hello/route.ts
import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({ message: "Hello" });
}

export async function POST(request: Request) {
  const body = await request.json();
  return NextResponse.json({ received: body });
}
```

### Dynamic API Routes

```typescript
// src/app/api/users/[id]/route.ts
import { NextResponse } from "next/server";

export async function GET(
  request: Request,
  { params }: { params: { id: string } }
) {
  const user = await getUser(params.id);
  return NextResponse.json(user);
}
```

### Route Handlers

Supported HTTP methods: `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, `HEAD`, `OPTIONS`

### API Route with Database

```typescript
// src/app/api/posts/route.ts
import { NextResponse } from "next/server";
import { db } from "@/lib/db";

export async function GET() {
  const posts = await db.query("SELECT * FROM posts");
  return NextResponse.json(posts);
}

export async function POST(request: Request) {
  const { title, content } = await request.json();
  const post = await db.query(
    "INSERT INTO posts (title, content) VALUES (?, ?)",
    [title, content]
  );
  return NextResponse.json(post, { status: 201 });
}
```

---

## Environment Variables

### Build-time Variables

Prefix with `NEXT_PUBLIC_` for client-side access:

```bash
# .env.production
NEXT_PUBLIC_API_URL=https://api.example.com
DATABASE_URL=postgres://...
```

### Server-only Variables

Variables without `NEXT_PUBLIC_` prefix are only available on the server:

```typescript
// This only works in Server Components or API routes
const dbUrl = process.env.DATABASE_URL;
```

### Deployment

Include `.env.production` in the project root. The CLI will include it in the deployment package.

---

## Troubleshooting

### "Module not found: @opennextjs/aws"

**Cause**: OpenNext not installed.

**Fix**:
```bash
npm install -D @opennextjs/aws
```

### "output: 'standalone' is required"

**Cause**: SSR deployment needs standalone output.

**Fix**: Add to `next.config.js`:
```javascript
const nextConfig = {
  output: 'standalone',
};
```

### "open-next.config.ts not found"

**Cause**: OpenNext config missing.

**Fix**: Create `open-next.config.ts` in project root (see [Convert](#convert-existing-project) section).

### Build Fails with "Failed to collect page data"

**Cause**: Page tries to access browser APIs during SSR.

**Fix**: Use dynamic imports or check for window:
```typescript
"use client";
import dynamic from "next/dynamic";

const Chart = dynamic(() => import("./Chart"), { ssr: false });
```

### API Routes Return 404

**Cause**: Route file not named correctly.

**Fix**: Ensure the file is named `route.ts` (not `index.ts` or `api.ts`).

### Static Export Fails

**Cause**: Using SSR features with `output: 'export'`.

**Fix**: Remove `getServerSideProps` or API routes, or switch to SSR deployment.

---

## Build Verification

After building, verify the output:

### Static Export
```bash
ls out/index.html  # Should exist
```

### SSR (OpenNext)
```bash
ls .open-next/assets/_next/static/  # Static assets
ls .open-next/server-functions/default/index.mjs  # Server function
```
