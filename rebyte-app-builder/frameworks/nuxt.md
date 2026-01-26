# Nuxt

**Adapter:** Nitro `aws-lambda` preset (built-in)

## Configure

Add to `nuxt.config.ts`:

```typescript
export default defineNuxtConfig({
  nitro: {
    preset: 'aws-lambda'
  }
});
```

## Build

```bash
npm run build
```

## Output

```
.output/
├── public/  # Static files → S3
└── server/  # Lambda handler (index.mjs)
```
