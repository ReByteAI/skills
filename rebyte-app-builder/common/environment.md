# Environment Variables

How to manage environment variables for deployment.

## Overview

Environment variables are used for:
- API endpoints
- Database credentials
- API keys (Stripe, SendGrid, etc.)
- Feature flags

## File Locations

| File | Purpose |
|------|---------|
| `.env` | Local development defaults |
| `.env.local` | Local overrides (gitignored) |
| `.env.development` | Development environment |
| `.env.production` | Production environment (deployed) |

**Important**: `.env.production` is included in the deployment package.

---

## Framework-Specific Prefixes

Each framework has rules about which variables are exposed to the browser:

| Framework | Server-only | Client-side (Browser) |
|-----------|-------------|----------------------|
| Next.js | No prefix | `NEXT_PUBLIC_` |
| Nuxt | Via `runtimeConfig` | `NUXT_PUBLIC_` |
| Vite | N/A | `VITE_` |
| Astro | No prefix | `PUBLIC_` |
| SvelteKit | `$env/static/private` | `PUBLIC_` |
| Gatsby | N/A | `GATSBY_` |

### Security Rule

**Never expose secrets to the browser.** Only use public prefixes for:
- API base URLs
- Public API keys (e.g., Stripe publishable key)
- Feature flags
- Analytics IDs

---

## Examples by Framework

### Next.js

```bash
# .env.production

# Server-only (API routes, Server Components)
DATABASE_URL=postgres://...
STRIPE_SECRET_KEY=sk_live_...

# Client-side accessible
NEXT_PUBLIC_API_URL=https://api.example.com
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_...
```

```typescript
// Server Component or API route
const dbUrl = process.env.DATABASE_URL;

// Client Component
const apiUrl = process.env.NEXT_PUBLIC_API_URL;
```

### Vite

```bash
# .env.production

# All exposed to browser (Vite is client-only)
VITE_API_URL=https://api.example.com
VITE_STRIPE_PUBLISHABLE_KEY=pk_live_...
```

```typescript
const apiUrl = import.meta.env.VITE_API_URL;
```

### Nuxt

```bash
# .env.production
DATABASE_URL=postgres://...
NUXT_PUBLIC_API_BASE=https://api.example.com
```

```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  runtimeConfig: {
    databaseUrl: process.env.DATABASE_URL,
    public: {
      apiBase: process.env.NUXT_PUBLIC_API_BASE,
    },
  },
});
```

```typescript
// In code
const config = useRuntimeConfig();
const dbUrl = config.databaseUrl;        // Server only
const apiBase = config.public.apiBase;   // Client accessible
```

### Astro

```bash
# .env.production
DATABASE_URL=postgres://...
PUBLIC_API_URL=https://api.example.com
```

```astro
---
// Server-side (frontmatter)
const dbUrl = import.meta.env.DATABASE_URL;
---

<script>
  // Client-side
  const apiUrl = import.meta.env.PUBLIC_API_URL;
</script>
```

### SvelteKit

```bash
# .env.production
DATABASE_URL=postgres://...
PUBLIC_API_URL=https://api.example.com
```

```typescript
// Server-side (+page.server.ts, +server.ts)
import { DATABASE_URL } from '$env/static/private';

// Client-side
import { PUBLIC_API_URL } from '$env/static/public';
```

### Gatsby

```bash
# .env.production
GATSBY_API_URL=https://api.example.com
GATSBY_STRIPE_PUBLISHABLE_KEY=pk_live_...
```

```typescript
const apiUrl = process.env.GATSBY_API_URL;
```

---

## Database Credentials

### Turso (SQLite)

```bash
# .env.production
DATABASE_URL=libsql://your-db.turso.io
DATABASE_AUTH_TOKEN=eyJ...
```

### Supabase

```bash
# .env.production
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...  # Server-only!
```

### PostgreSQL

```bash
# .env.production
DATABASE_URL=postgres://user:pass@host:5432/db?sslmode=require
```

---

## Third-Party Services

### Stripe

```bash
# .env.production
STRIPE_SECRET_KEY=sk_live_...              # Server-only
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_...  # Client-side OK
```

### Clerk (Authentication)

```bash
# .env.production
CLERK_SECRET_KEY=sk_live_...               # Server-only
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_live_...
```

### SendGrid / Resend

```bash
# .env.production
SENDGRID_API_KEY=SG...     # Server-only
RESEND_API_KEY=re_...      # Server-only
```

---

## Deployment

### Including .env.production

The `.env.production` file is automatically included in the deployment package when you run:

```bash
rebyte deploy
```

### Verifying Variables

Before deploying, check that variables are set:

```bash
# Check .env.production exists
cat .env.production

# Verify no placeholder values
grep -E "(YOUR_|xxx|placeholder)" .env.production && echo "Warning: Placeholder values found!"
```

---

## Security Best Practices

1. **Never commit secrets to git**
   ```bash
   # .gitignore
   .env
   .env.local
   .env.production
   ```

2. **Use different keys per environment**
   - Development: test/sandbox keys
   - Production: live keys

3. **Rotate secrets regularly**
   - If a secret is exposed, rotate immediately
   - Use short-lived tokens when possible

4. **Validate required variables**
   ```typescript
   // At app startup
   const required = ['DATABASE_URL', 'STRIPE_SECRET_KEY'];
   for (const key of required) {
     if (!process.env[key]) {
       throw new Error(`Missing required env var: ${key}`);
     }
   }
   ```

5. **Don't log secrets**
   ```typescript
   // Bad
   console.log('DB URL:', process.env.DATABASE_URL);

   // Good
   console.log('DB URL:', process.env.DATABASE_URL?.slice(0, 20) + '...');
   ```

---

## Troubleshooting

### Variable is Undefined

**Cause**: Missing prefix or not in `.env.production`.

**Fix**:
1. Check the variable has the correct prefix for your framework
2. Verify it's in `.env.production`
3. Restart the build/dev server

### Variable Exposed to Browser

**Cause**: Used public prefix for a secret.

**Fix**: Remove the public prefix and access only on server-side.

### Different Value in Production

**Cause**: `.env.production` overrides `.env`.

**Fix**: This is expected. Update `.env.production` with the correct value.

### Build Fails with "Missing env var"

**Cause**: Required variable not set.

**Fix**: Add the variable to `.env.production`:
```bash
echo "VARIABLE_NAME=value" >> .env.production
```
