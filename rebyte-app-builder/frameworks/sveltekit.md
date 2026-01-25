# SvelteKit

SvelteKit is a Svelte framework for building web applications with file-based routing.

| Feature | Supported |
|---------|-----------|
| Static | Yes (with adapter-static) |
| SSR | Planned |
| API Routes | Yes (+server.ts) |

## Detection

Config file: `svelte.config.js`

---

## Initialize (Empty Directory)

Create a new SvelteKit project:

```bash
npx sv create . --template minimal --types ts
npm install
```

### With Tailwind CSS

```bash
npx sv add tailwindcss
```

---

## Convert (Existing Project)

SvelteKit requires explicit configuration for static deployment.

### Step 1: Install Static Adapter

```bash
npm install -D @sveltejs/adapter-static
```

### Step 2: Configure Adapter

```javascript
// svelte.config.js
import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
  preprocess: vitePreprocess(),
  kit: {
    adapter: adapter()
  }
};

export default config;
```

### Step 3: Enable Prerendering

```typescript
// src/routes/+layout.ts
export const prerender = true;
```

### Step 4: Deploy

```bash
rebyte deploy
```

---

## Static

Static generation pre-renders all pages at build time.

### When to Use

- Marketing sites
- Blogs
- Documentation
- Apps without server-side requirements

### Configuration

```javascript
// svelte.config.js
import adapter from '@sveltejs/adapter-static';

export default {
  kit: {
    adapter: adapter({
      pages: 'build',
      assets: 'build',
      fallback: 'index.html',  // For SPA mode
    })
  }
};
```

### Build Output

```
build/
├── index.html
├── about/
│   └── index.html
├── _app/
│   ├── immutable/
│   └── version.json
└── images/
```

### Prerendering

Enable for all routes:

```typescript
// src/routes/+layout.ts
export const prerender = true;
```

Or per-route:

```typescript
// src/routes/about/+page.ts
export const prerender = true;
```

### Static Data Loading

```typescript
// src/routes/posts/+page.ts
export const prerender = true;

export async function load() {
  const posts = await getPosts();
  return { posts };
}
```

```svelte
<!-- src/routes/posts/+page.svelte -->
<script>
  export let data;
</script>

{#each data.posts as post}
  <article>{post.title}</article>
{/each}
```

---

## SSR (Server-Side Rendering)

SSR support for SvelteKit is planned but not yet available on Rebyte.

For now, use static generation with `adapter-static`. If you need SSR, consider Next.js or Nuxt.

---

## API Routes

SvelteKit supports API endpoints via `+server.ts` files.

### Basic Endpoint

```typescript
// src/routes/api/hello/+server.ts
import { json } from '@sveltejs/kit';

export function GET() {
  return json({ message: 'Hello' });
}
```

### POST Endpoint

```typescript
// src/routes/api/posts/+server.ts
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const POST: RequestHandler = async ({ request }) => {
  const body = await request.json();
  const post = await createPost(body);
  return json(post, { status: 201 });
};
```

### Dynamic Routes

```typescript
// src/routes/api/users/[id]/+server.ts
import { json, error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = async ({ params }) => {
  const user = await getUser(params.id);

  if (!user) {
    throw error(404, 'User not found');
  }

  return json(user);
};
```

### All HTTP Methods

```typescript
// src/routes/api/resource/+server.ts
import { json } from '@sveltejs/kit';

export function GET() { ... }
export function POST() { ... }
export function PUT() { ... }
export function PATCH() { ... }
export function DELETE() { ... }
```

### API with Headers

```typescript
export function GET() {
  return new Response(JSON.stringify({ data: 'value' }), {
    headers: {
      'Content-Type': 'application/json',
      'Cache-Control': 'max-age=3600',
    },
  });
}
```

### Static API Endpoints

For static export, prerender endpoints:

```typescript
// src/routes/api/posts.json/+server.ts
import { json } from '@sveltejs/kit';

export const prerender = true;

export async function GET() {
  const posts = await getPosts();
  return json(posts);
}
```

---

## File-Based Routing

### Route Structure

```
src/routes/
├── +page.svelte           # /
├── about/
│   └── +page.svelte       # /about
├── blog/
│   ├── +page.svelte       # /blog
│   └── [slug]/
│       └── +page.svelte   # /blog/:slug
└── api/
    └── hello/
        └── +server.ts     # /api/hello
```

### Layout

```svelte
<!-- src/routes/+layout.svelte -->
<script>
  import Header from '$lib/components/Header.svelte';
</script>

<Header />
<slot />
```

### Data Loading

```typescript
// src/routes/+page.ts
export async function load({ fetch }) {
  const response = await fetch('/api/posts');
  const posts = await response.json();
  return { posts };
}
```

```svelte
<!-- src/routes/+page.svelte -->
<script>
  export let data;
</script>

<h1>Posts</h1>
{#each data.posts as post}
  <a href="/blog/{post.slug}">{post.title}</a>
{/each}
```

---

## Environment Variables

### Static Variables

Prefix with `PUBLIC_` for client-side access:

```bash
# .env.production
PUBLIC_API_URL=https://api.example.com
DATABASE_URL=postgres://...
```

### Access in Code

```typescript
// Server-side only
import { DATABASE_URL } from '$env/static/private';

// Client-side accessible
import { PUBLIC_API_URL } from '$env/static/public';
```

### Dynamic Variables

```typescript
// Server-side
import { env } from '$env/dynamic/private';
const dbUrl = env.DATABASE_URL;

// Client-side
import { env } from '$env/dynamic/public';
const apiUrl = env.PUBLIC_API_URL;
```

---

## State Management

### Stores

```typescript
// src/lib/stores/counter.ts
import { writable } from 'svelte/store';

export const count = writable(0);
```

```svelte
<script>
  import { count } from '$lib/stores/counter';
</script>

<button on:click={() => $count++}>
  Count: {$count}
</button>
```

### Context

```svelte
<!-- Parent.svelte -->
<script>
  import { setContext } from 'svelte';
  setContext('user', { name: 'John' });
</script>

<!-- Child.svelte -->
<script>
  import { getContext } from 'svelte';
  const user = getContext('user');
</script>
```

---

## Troubleshooting

### "adapter-static requires prerender"

**Cause**: Static adapter needs all routes to be prerenderable.

**Fix**: Add to `src/routes/+layout.ts`:
```typescript
export const prerender = true;
```

### "Cannot use dynamic route with prerender"

**Cause**: Dynamic route without `generateStaticParams`.

**Fix**: Define static paths:
```typescript
// src/routes/blog/[slug]/+page.ts
export async function entries() {
  const posts = await getPosts();
  return posts.map(post => ({ slug: post.slug }));
}
```

### Build Output Empty

**Cause**: Adapter not configured.

**Fix**: Install and configure adapter-static:
```bash
npm install -D @sveltejs/adapter-static
```

### "500: Not found" on Page Load

**Cause**: Missing `+page.svelte` file.

**Fix**: Create the page file:
```
src/routes/about/+page.svelte
```

### API Route Returns HTML

**Cause**: File named `+page.ts` instead of `+server.ts`.

**Fix**: Rename to `+server.ts` for API endpoints.

---

## Build Verification

After building:

```bash
ls build/index.html  # Should exist
ls build/_app/       # Should contain JS bundles
```
