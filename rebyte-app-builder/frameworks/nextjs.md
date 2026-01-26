# Next.js

**Adapter:** OpenNext

## Install

```bash
npm install -D @opennextjs/aws
```

## Configure

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

Set standalone output in `next.config.ts`:

```typescript
const nextConfig = {
  output: 'standalone',
};

export default nextConfig;
```

## Build

```bash
npx open-next build
```

## Output

```
.open-next/
├── assets/           # Static files → S3
└── server-functions/ # Lambda handler
```
