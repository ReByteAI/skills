# Astro

Astro is a content-focused web framework that ships zero JavaScript by default. Supports multiple UI frameworks (React, Vue, Svelte, Solid).

| Feature | Supported |
|---------|-----------|
| Static | Yes |
| SSR | Planned |
| API Routes | Yes (endpoints) |

## Detection

Config files: `astro.config.mjs`, `astro.config.ts`

---

## Initialize (Empty Directory)

Create a new Astro project:

```bash
npm create astro@latest . -- --template minimal --typescript strict
npm install
```

### With Tailwind CSS

```bash
npx astro add tailwind
```

### With React Components

```bash
npx astro add react
```

### With Vue Components

```bash
npx astro add vue
```

---

## Convert (Existing Project)

Astro projects work out of the box. No configuration required.

```bash
rebyte deploy
```

---

## Static

Astro generates static HTML by default, shipping minimal JavaScript.

### When to Use

- Content-heavy sites (blogs, docs, marketing)
- Sites where SEO matters
- Sites that need fast initial load

### Build Command

```bash
npm run build
```

### Build Output

```
dist/
├── index.html
├── about/
│   └── index.html
├── _astro/
│   ├── [hashed].css
│   └── [hashed].js   # Only if islands used
└── images/
```

### Pages

Create `.astro` files in `src/pages/`:

```astro
---
// src/pages/index.astro
const title = "Home";
---

<html>
  <head>
    <title>{title}</title>
  </head>
  <body>
    <h1>Welcome</h1>
  </body>
</html>
```

### Layouts

```astro
---
// src/layouts/Base.astro
interface Props {
  title: string;
}

const { title } = Astro.props;
---

<html>
  <head>
    <title>{title}</title>
  </head>
  <body>
    <slot />
  </body>
</html>
```

```astro
---
// src/pages/about.astro
import Base from '../layouts/Base.astro';
---

<Base title="About">
  <h1>About Us</h1>
</Base>
```

### Content Collections

Organize content with type safety:

```typescript
// src/content/config.ts
import { defineCollection, z } from 'astro:content';

const blog = defineCollection({
  schema: z.object({
    title: z.string(),
    date: z.date(),
    draft: z.boolean().default(false),
  }),
});

export const collections = { blog };
```

```markdown
---
# src/content/blog/first-post.md
title: "First Post"
date: 2024-01-15
---

This is my first blog post.
```

```astro
---
// src/pages/blog/[slug].astro
import { getCollection } from 'astro:content';

export async function getStaticPaths() {
  const posts = await getCollection('blog');
  return posts.map(post => ({
    params: { slug: post.slug },
    props: { post },
  }));
}

const { post } = Astro.props;
const { Content } = await post.render();
---

<h1>{post.data.title}</h1>
<Content />
```

---

## SSR (Server-Side Rendering)

SSR support for Astro is planned but not yet available on Rebyte.

For now, use static generation. If you need SSR with a similar content-focused approach, consider Next.js or Nuxt.

---

## API Routes (Endpoints)

Astro supports API endpoints for serverless functions.

### Basic Endpoint

```typescript
// src/pages/api/hello.ts
import type { APIRoute } from 'astro';

export const GET: APIRoute = () => {
  return new Response(JSON.stringify({ message: 'Hello' }), {
    headers: { 'Content-Type': 'application/json' },
  });
};
```

### POST Endpoint

```typescript
// src/pages/api/posts.ts
import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ request }) => {
  const body = await request.json();

  // Process the data
  const post = await createPost(body);

  return new Response(JSON.stringify(post), {
    status: 201,
    headers: { 'Content-Type': 'application/json' },
  });
};
```

### Dynamic Endpoints

```typescript
// src/pages/api/users/[id].ts
import type { APIRoute } from 'astro';

export const GET: APIRoute = ({ params }) => {
  const { id } = params;
  const user = getUser(id);

  return new Response(JSON.stringify(user), {
    headers: { 'Content-Type': 'application/json' },
  });
};
```

### Static Endpoints

For static export, endpoints are pre-rendered at build time:

```typescript
// src/pages/api/posts.json.ts
import type { APIRoute } from 'astro';

export const GET: APIRoute = async () => {
  const posts = await getPosts();
  return new Response(JSON.stringify(posts));
};

// Pre-render this endpoint at build time
export const prerender = true;
```

---

## Islands Architecture

Astro's partial hydration allows interactive components in static pages.

### React Island

```astro
---
// src/pages/index.astro
import Counter from '../components/Counter';
---

<h1>Static Content</h1>

<!-- Only this component ships JavaScript -->
<Counter client:load />
```

```tsx
// src/components/Counter.tsx
import { useState } from 'react';

export default function Counter() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
}
```

### Client Directives

| Directive | When it hydrates |
|-----------|-----------------|
| `client:load` | Immediately on page load |
| `client:idle` | When browser is idle |
| `client:visible` | When component is visible |
| `client:media` | When media query matches |
| `client:only` | Client-side only, no SSR |

```astro
<HeavyComponent client:visible />
<MobileMenu client:media="(max-width: 768px)" />
```

---

## Environment Variables

### Build-time Variables

Prefix with `PUBLIC_` for client-side access:

```bash
# .env.production
PUBLIC_API_URL=https://api.example.com
DATABASE_URL=postgres://...
```

### Access in Code

```astro
---
// Server-side (in frontmatter)
const dbUrl = import.meta.env.DATABASE_URL;

// Client-side accessible
const apiUrl = import.meta.env.PUBLIC_API_URL;
---

<script>
  // Client-side script
  const apiUrl = import.meta.env.PUBLIC_API_URL;
</script>
```

---

## Integrations

### Add React

```bash
npx astro add react
```

```astro
---
import ReactComponent from '../components/ReactComponent';
---

<ReactComponent client:load />
```

### Add MDX

```bash
npx astro add mdx
```

Now you can use `.mdx` files with components:

```mdx
---
# src/content/blog/interactive.mdx
title: "Interactive Post"
---

import Chart from '../../components/Chart';

# My Post

<Chart client:visible />
```

---

## Troubleshooting

### Build Fails with "Cannot find module"

**Cause**: Missing dependency.

**Fix**:
```bash
npm install
```

### Components Not Interactive

**Cause**: Missing client directive.

**Fix**: Add a client directive:
```astro
<Counter client:load />
```

### Styles Not Applied

**Cause**: Scoped styles by default.

**Fix**: Use `is:global` for global styles:
```astro
<style is:global>
  body { margin: 0; }
</style>
```

### Content Collection Type Errors

**Cause**: Schema mismatch.

**Fix**: Run type generation:
```bash
npx astro sync
```

### Endpoint Returns 404

**Cause**: File not in `src/pages/` or missing export.

**Fix**: Ensure correct location and named exports:
```typescript
// src/pages/api/hello.ts
export const GET = () => { ... };  // Named export
```

---

## Build Verification

After building:

```bash
ls dist/index.html  # Should exist
ls dist/_astro/     # Should contain CSS/JS bundles
```
