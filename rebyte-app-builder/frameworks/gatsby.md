# Gatsby

Gatsby is a React-based static site generator optimized for performance.

| Feature | Supported |
|---------|-----------|
| Static | Yes |
| SSR | No |
| API Routes | No |

## Detection

Config files: `gatsby-config.js`, `gatsby-config.ts`

---

## Initialize (Empty Directory)

Create a new Gatsby project:

```bash
npm init gatsby . -- -y -ts
npm install
```

### With Tailwind CSS

```bash
npm install -D tailwindcss postcss autoprefixer gatsby-plugin-postcss
npx tailwindcss init -p
```

```javascript
// gatsby-config.ts
const config: GatsbyConfig = {
  plugins: ['gatsby-plugin-postcss'],
};
```

```javascript
// tailwind.config.js
module.exports = {
  content: [
    './src/pages/**/*.{js,jsx,ts,tsx}',
    './src/components/**/*.{js,jsx,ts,tsx}',
  ],
  theme: { extend: {} },
  plugins: [],
};
```

```css
/* src/styles/global.css */
@tailwind base;
@tailwind components;
@tailwind utilities;
```

```typescript
// gatsby-browser.ts
import './src/styles/global.css';
```

---

## Convert (Existing Project)

Gatsby projects work out of the box. No configuration required.

```bash
rebyte deploy
```

---

## Static

Gatsby generates static HTML at build time with React hydration.

### When to Use

- Blogs
- Marketing sites
- Documentation
- Image-heavy sites

### Build Command

```bash
npm run build
```

### Build Output

```
public/
├── index.html
├── about/
│   └── index.html
├── page-data/
├── static/
└── [hashed-assets]/
```

---

## Pages

### File-Based Routing

```
src/pages/
├── index.tsx          # /
├── about.tsx          # /about
└── blog/
    └── [slug].tsx     # /blog/:slug (dynamic)
```

### Basic Page

```tsx
// src/pages/index.tsx
import * as React from 'react';
import type { HeadFC } from 'gatsby';

export default function IndexPage() {
  return (
    <main>
      <h1>Welcome</h1>
    </main>
  );
}

export const Head: HeadFC = () => <title>Home</title>;
```

### Dynamic Pages

Create pages programmatically in `gatsby-node.ts`:

```typescript
// gatsby-node.ts
import type { GatsbyNode } from 'gatsby';
import path from 'path';

export const createPages: GatsbyNode['createPages'] = async ({
  graphql,
  actions,
}) => {
  const { createPage } = actions;

  const result = await graphql<{ allPost: { nodes: Array<{ slug: string }> } }>(`
    query {
      allPost {
        nodes {
          slug
        }
      }
    }
  `);

  result.data?.allPost.nodes.forEach((post) => {
    createPage({
      path: `/blog/${post.slug}`,
      component: path.resolve('./src/templates/post.tsx'),
      context: { slug: post.slug },
    });
  });
};
```

---

## Data Fetching

### GraphQL at Build Time

```tsx
// src/pages/index.tsx
import { graphql, PageProps } from 'gatsby';

type DataProps = {
  site: {
    siteMetadata: {
      title: string;
    };
  };
};

export default function IndexPage({ data }: PageProps<DataProps>) {
  return <h1>{data.site.siteMetadata.title}</h1>;
}

export const query = graphql`
  query {
    site {
      siteMetadata {
        title
      }
    }
  }
`;
```

### Static Query in Components

```tsx
// src/components/Header.tsx
import { useStaticQuery, graphql } from 'gatsby';

export function Header() {
  const data = useStaticQuery(graphql`
    query {
      site {
        siteMetadata {
          title
        }
      }
    }
  `);

  return <header>{data.site.siteMetadata.title}</header>;
}
```

### Source Plugins

#### Filesystem Source

```bash
npm install gatsby-source-filesystem
```

```javascript
// gatsby-config.ts
{
  resolve: 'gatsby-source-filesystem',
  options: {
    name: 'posts',
    path: `${__dirname}/content/posts`,
  },
}
```

#### MDX Content

```bash
npm install gatsby-plugin-mdx @mdx-js/react
```

```javascript
// gatsby-config.ts
{
  resolve: 'gatsby-plugin-mdx',
  options: {
    extensions: ['.md', '.mdx'],
  },
}
```

---

## SSR

Gatsby does not support SSR deployment on Rebyte. For SSR with React, use Next.js.

---

## API Routes

Gatsby does not support API routes on Rebyte. For backend functionality:

1. **Use a separate API**: Deploy your API separately
2. **Switch to Next.js**: For integrated API routes

### Client-Side API Calls

```tsx
import { useState, useEffect } from 'react';

export default function Dashboard() {
  const [data, setData] = useState(null);

  useEffect(() => {
    fetch(process.env.GATSBY_API_URL + '/data')
      .then(res => res.json())
      .then(setData);
  }, []);

  return <div>{data?.message}</div>;
}
```

---

## Environment Variables

### Build-time Variables

Prefix with `GATSBY_` for client-side access:

```bash
# .env.production
GATSBY_API_URL=https://api.example.com
DATABASE_URL=postgres://...
```

### Access in Code

```tsx
// Client-side accessible
const apiUrl = process.env.GATSBY_API_URL;

// Build-time only (gatsby-node.ts, gatsby-config.ts)
const dbUrl = process.env.DATABASE_URL;
```

---

## Image Optimization

Gatsby has built-in image optimization:

```bash
npm install gatsby-plugin-image gatsby-plugin-sharp gatsby-transformer-sharp
```

```javascript
// gatsby-config.ts
plugins: [
  'gatsby-plugin-image',
  'gatsby-plugin-sharp',
  'gatsby-transformer-sharp',
]
```

### Static Images

```tsx
import { StaticImage } from 'gatsby-plugin-image';

export function Hero() {
  return (
    <StaticImage
      src="../images/hero.jpg"
      alt="Hero"
      placeholder="blurred"
      layout="fullWidth"
    />
  );
}
```

### Dynamic Images

```tsx
import { GatsbyImage, getImage } from 'gatsby-plugin-image';

export function PostImage({ image }) {
  const img = getImage(image);
  return <GatsbyImage image={img} alt="" />;
}
```

---

## Plugins

### Common Plugins

```javascript
// gatsby-config.ts
plugins: [
  'gatsby-plugin-postcss',           // Tailwind/PostCSS
  'gatsby-plugin-image',             // Image optimization
  'gatsby-plugin-sitemap',           // Sitemap generation
  'gatsby-plugin-robots-txt',        // robots.txt
  {
    resolve: 'gatsby-plugin-manifest',
    options: {
      name: 'My Site',
      short_name: 'Site',
      start_url: '/',
      icon: 'src/images/icon.png',
    },
  },
]
```

### Adding a Plugin

1. Install: `npm install gatsby-plugin-x`
2. Add to `gatsby-config.ts` plugins array
3. Restart dev server

---

## Troubleshooting

### Build Fails with GraphQL Error

**Cause**: Query syntax error or missing data.

**Fix**: Test query in GraphiQL (`localhost:8000/___graphql`) during development.

### Images Not Loading

**Cause**: Missing image plugins.

**Fix**:
```bash
npm install gatsby-plugin-image gatsby-plugin-sharp gatsby-transformer-sharp
```

### "Cannot find module" Error

**Cause**: Missing dependency or cache issue.

**Fix**:
```bash
npm install
gatsby clean
npm run build
```

### Environment Variables Undefined

**Cause**: Variable not prefixed with `GATSBY_`.

**Fix**: Rename variable:
```bash
# Wrong
API_URL=https://...

# Correct
GATSBY_API_URL=https://...
```

### Slow Builds

**Cause**: Large number of images or pages.

**Fix**: Use incremental builds or reduce image quality:
```javascript
// gatsby-config.ts
{
  resolve: 'gatsby-plugin-sharp',
  options: {
    defaults: {
      quality: 70,
    },
  },
}
```

---

## Build Verification

After building:

```bash
ls public/index.html  # Should exist
ls public/page-data/  # Should contain page data
```
