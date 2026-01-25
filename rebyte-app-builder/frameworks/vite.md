# Vite

Vite is a fast build tool for modern web applications. Supports React, Vue, Svelte, and vanilla JavaScript.

| Feature | Supported |
|---------|-----------|
| Static | Yes |
| SSR | No |
| API Routes | No |

## Detection

Config files: `vite.config.ts`, `vite.config.js`

Check the Vite config for the framework plugin:
- `@vitejs/plugin-react` → React
- `@vitejs/plugin-vue` → Vue
- `@sveltejs/vite-plugin-svelte` → Svelte

---

## Initialize (Empty Directory)

### React

```bash
npm create vite@latest . -- --template react-ts
npm install
```

### Vue

```bash
npm create vite@latest . -- --template vue-ts
npm install
```

### Svelte

```bash
npm create vite@latest . -- --template svelte-ts
npm install
```

### With Tailwind CSS

After scaffolding, add Tailwind:

```bash
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

Update `tailwind.config.js`:

```javascript
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx,vue,svelte}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
```

Add to your CSS:

```css
/* src/index.css */
@tailwind base;
@tailwind components;
@tailwind utilities;
```

---

## Convert (Existing Project)

Vite projects work out of the box. No configuration required.

1. Ensure `vite.config.ts` exists
2. Deploy:

```bash
rebyte deploy
```

### Optional: Configure Base Path

If deploying to a subpath, set the base:

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  base: '/',  // or '/subpath/' if needed
});
```

---

## Static

Vite generates static files that can be served from any CDN.

### Build Output

```
dist/
├── index.html
├── assets/
│   ├── index-abc123.js
│   ├── index-def456.css
│   └── logo-ghi789.svg
└── favicon.ico
```

### SPA Routing

For single-page apps with client-side routing (React Router, Vue Router):

The deployment automatically configures fallback to `index.html` for all routes.

### Multi-Page Apps

Vite supports multi-page apps:

```
project/
├── index.html
├── about.html
└── src/
    ├── main.ts
    └── about.ts
```

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import { resolve } from 'path';

export default defineConfig({
  build: {
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html'),
        about: resolve(__dirname, 'about.html'),
      },
    },
  },
});
```

---

## SSR

Vite does not support SSR deployment on Rebyte. For SSR, use:
- **React**: Next.js
- **Vue**: Nuxt
- **Svelte**: SvelteKit

---

## API Routes

Vite does not support API routes. For backend functionality:

1. **Use a separate API**: Deploy your API separately and call it from the frontend
2. **Switch to a full-stack framework**: Next.js, Nuxt, or SvelteKit

### Calling External APIs

```typescript
// src/api/client.ts
const API_URL = import.meta.env.VITE_API_URL;

export async function fetchPosts() {
  const response = await fetch(`${API_URL}/posts`);
  return response.json();
}
```

```bash
# .env.production
VITE_API_URL=https://api.example.com
```

---

## Environment Variables

### Client-side Variables

Prefix with `VITE_` to expose to the browser:

```bash
# .env.production
VITE_API_URL=https://api.example.com
VITE_APP_TITLE=My App
```

Access in code:

```typescript
const apiUrl = import.meta.env.VITE_API_URL;
const title = import.meta.env.VITE_APP_TITLE;
```

### Build-time Variables

```typescript
// vite.config.ts
export default defineConfig({
  define: {
    __APP_VERSION__: JSON.stringify(process.env.npm_package_version),
  },
});
```

---

## React-Specific

### React Router

```bash
npm install react-router-dom
```

```tsx
// src/main.tsx
import { BrowserRouter } from 'react-router-dom';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <BrowserRouter>
    <App />
  </BrowserRouter>
);
```

```tsx
// src/App.tsx
import { Routes, Route } from 'react-router-dom';

function App() {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/about" element={<About />} />
    </Routes>
  );
}
```

### State Management

For global state, use Zustand:

```bash
npm install zustand
```

```typescript
// src/store/useStore.ts
import { create } from 'zustand';

interface Store {
  count: number;
  increment: () => void;
}

export const useStore = create<Store>((set) => ({
  count: 0,
  increment: () => set((state) => ({ count: state.count + 1 })),
}));
```

---

## Vue-Specific

### Vue Router

```bash
npm install vue-router
```

```typescript
// src/router/index.ts
import { createRouter, createWebHistory } from 'vue-router';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: () => import('../views/Home.vue') },
    { path: '/about', component: () => import('../views/About.vue') },
  ],
});

export default router;
```

### Pinia (State Management)

```bash
npm install pinia
```

```typescript
// src/stores/counter.ts
import { defineStore } from 'pinia';

export const useCounterStore = defineStore('counter', {
  state: () => ({ count: 0 }),
  actions: {
    increment() {
      this.count++;
    },
  },
});
```

---

## Svelte-Specific

For complex Svelte apps with routing, consider SvelteKit instead.

### Simple Routing

```bash
npm install svelte-spa-router
```

```svelte
<!-- src/App.svelte -->
<script>
  import Router from 'svelte-spa-router';
  import Home from './routes/Home.svelte';
  import About from './routes/About.svelte';

  const routes = {
    '/': Home,
    '/about': About,
  };
</script>

<Router {routes} />
```

---

## Troubleshooting

### Build Fails with "Cannot find module"

**Cause**: Missing dependency or incorrect import path.

**Fix**:
```bash
npm install
```

Check import paths for typos.

### Assets Not Loading

**Cause**: Incorrect base path.

**Fix**: Ensure `base` in `vite.config.ts` is set correctly:
```typescript
export default defineConfig({
  base: '/',
});
```

### Environment Variables Undefined

**Cause**: Variable not prefixed with `VITE_`.

**Fix**: Rename variable:
```bash
# Wrong
API_URL=https://...

# Correct
VITE_API_URL=https://...
```

### 404 on Page Refresh (SPA)

**Cause**: Server doesn't handle client-side routing.

**Fix**: This is automatically handled by the deployment. If testing locally, use:
```bash
npm run preview
```

---

## Build Verification

After building:

```bash
ls dist/index.html  # Should exist
ls dist/assets/     # Should contain JS/CSS bundles
```
