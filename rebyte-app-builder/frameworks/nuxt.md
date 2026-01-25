# Nuxt

Nuxt is a Vue framework supporting static generation, server-side rendering, and API routes.

| Feature | Supported |
|---------|-----------|
| Static | Yes |
| SSR | Yes (via Nitro) |
| API Routes | Yes |

## Detection

Config files: `nuxt.config.ts`, `nuxt.config.js`

---

## Initialize (Empty Directory)

Create a new Nuxt project:

```bash
npx nuxi@latest init .
npm install
```

Add Tailwind CSS:

```bash
npm install -D @nuxtjs/tailwindcss
```

```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  modules: ['@nuxtjs/tailwindcss'],
});
```

---

## Convert (Existing Project)

### For Static Export

If the app has no dynamic server features:

```bash
# Build as static
npm run generate
rebyte deploy
```

### For SSR Deployment

For apps with SSR or API routes:

```bash
# Build with Lambda preset (no code changes needed)
NITRO_PRESET=aws-lambda npm run build
rebyte deploy
```

The `NITRO_PRESET` environment variable tells Nitro to output Lambda-compatible code.

---

## Static

Static generation pre-renders all pages at build time.

### When to Use

- Marketing sites
- Blogs
- Documentation
- Apps with no server-side data fetching

### Build Command

```bash
npm run generate
```

### Build Output

```
.output/public/
├── index.html
├── about/
│   └── index.html
├── _nuxt/
│   └── [hashed files]
└── images/
```

### Static Data Fetching

Use `useAsyncData` or `useFetch` - they run at build time for static generation:

```vue
<script setup>
const { data: posts } = await useFetch('/api/posts');
</script>
```

### Limitations

- No server-side rendering on requests
- No API routes (at runtime)
- Data is fetched at build time only

---

## SSR (Server-Side Rendering)

SSR renders pages on each request using Nitro server deployed to AWS Lambda.

### When to Use

- Personalized content
- Real-time data
- Authentication-protected pages
- API routes

### Build Command

```bash
NITRO_PRESET=aws-lambda npm run build
```

### Build Output

```
.output/
├── public/          # Static assets (CDN)
│   ├── _nuxt/
│   └── images/
└── server/          # Server function (Lambda)
    ├── index.mjs
    └── chunks/
```

### How It Works

```
Request → CDN → Lambda (if not static)
                   │
                   └── Nitro server
                   └── Renders Vue app
                   └── Returns HTML
```

### Server Components

Nuxt 3 uses Vue's Composition API with server-side execution:

```vue
<script setup>
// Runs on server during SSR
const { data } = await useFetch('/api/data');
</script>

<template>
  <div>{{ data.title }}</div>
</template>
```

### Hybrid Rendering

Configure per-route rendering:

```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  routeRules: {
    '/': { prerender: true },           // Static
    '/blog/**': { swr: 3600 },          // Cached for 1 hour
    '/dashboard/**': { ssr: true },     // Always SSR
    '/api/**': { cors: true },          // API routes
  },
});
```

---

## API Routes

API routes are serverless functions in the `server/api/` directory.

### Basic API Route

```typescript
// server/api/hello.ts
export default defineEventHandler(() => {
  return { message: 'Hello' };
});
```

Access at `/api/hello`.

### HTTP Methods

```typescript
// server/api/posts.get.ts
export default defineEventHandler(async () => {
  return await getPosts();
});

// server/api/posts.post.ts
export default defineEventHandler(async (event) => {
  const body = await readBody(event);
  return await createPost(body);
});
```

### Dynamic Routes

```typescript
// server/api/users/[id].ts
export default defineEventHandler((event) => {
  const id = getRouterParam(event, 'id');
  return getUser(id);
});
```

### API with Database

```typescript
// server/api/posts/index.get.ts
import { db } from '~/server/utils/db';

export default defineEventHandler(async () => {
  const posts = await db.query('SELECT * FROM posts');
  return posts;
});

// server/api/posts/index.post.ts
export default defineEventHandler(async (event) => {
  const body = await readBody(event);
  const { title, content } = body;

  const post = await db.query(
    'INSERT INTO posts (title, content) VALUES (?, ?)',
    [title, content]
  );

  return post;
});
```

### Server Utilities

Share code across API routes:

```typescript
// server/utils/db.ts
import { createClient } from '@libsql/client';

export const db = createClient({
  url: process.env.DATABASE_URL!,
  authToken: process.env.DATABASE_AUTH_TOKEN,
});
```

---

## Environment Variables

### Runtime Variables

Available on the server:

```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  runtimeConfig: {
    // Server-only
    databaseUrl: process.env.DATABASE_URL,

    // Public (exposed to client)
    public: {
      apiBase: process.env.NUXT_PUBLIC_API_BASE,
    },
  },
});
```

Access in code:

```typescript
// Server-side
const config = useRuntimeConfig();
const dbUrl = config.databaseUrl;

// Client-side
const config = useRuntimeConfig();
const apiBase = config.public.apiBase;
```

### Build-time Variables

```bash
# .env.production
DATABASE_URL=postgres://...
NUXT_PUBLIC_API_BASE=https://api.example.com
```

---

## Troubleshooting

### "Server output not found"

**Cause**: Built without Lambda preset.

**Fix**: Use the environment variable:
```bash
NITRO_PRESET=aws-lambda npm run build
```

### ".output/server/index.mjs not found"

**Cause**: Build failed or wrong preset.

**Fix**: Check build logs and ensure preset is correct:
```bash
NITRO_PRESET=aws-lambda npm run build
```

### API Routes Return 404

**Cause**: Route file not in `server/api/` directory.

**Fix**: Ensure files are in the correct location:
```
server/
└── api/
    └── hello.ts    # Correct
```

### Environment Variables Undefined

**Cause**: Variables not in `runtimeConfig`.

**Fix**: Add to `nuxt.config.ts`:
```typescript
export default defineNuxtConfig({
  runtimeConfig: {
    mySecret: process.env.MY_SECRET,
  },
});
```

### Static Generation Fails

**Cause**: Page uses server-only features.

**Fix**: Use `routeRules` to mark routes as SSR-only:
```typescript
export default defineNuxtConfig({
  routeRules: {
    '/dashboard/**': { ssr: true },
  },
});
```

---

## Build Verification

### Static Export
```bash
ls .output/public/index.html  # Should exist
```

### SSR (Nitro)
```bash
ls .output/public/_nuxt/      # Static assets
ls .output/server/index.mjs   # Server function
```
