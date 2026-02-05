# Static Site + API Function

Deploy a static frontend with serverless API endpoints.

## Structure

```
.rebyte/
├── config.json
├── static/              # Frontend (Vite, React, etc.)
│   ├── index.html
│   └── assets/
└── functions/
    └── api.func/        # API Lambda handler
        └── index.js
```

## Setup

### 1. Build Static Site

```bash
npm run build
```

### 2. Create .rebyte/ Structure

```bash
mkdir -p .rebyte/static .rebyte/functions/api.func
cp -r dist/* .rebyte/static/
```

### 3. Create API Handler

```javascript
// .rebyte/functions/api.func/index.js
exports.handler = async (event, context) => {
  const { httpMethod, path, body } = event;

  if (httpMethod === 'POST' && path === '/api/submit') {
    const data = JSON.parse(body || '{}');
    // Process data...
    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ success: true })
    };
  }

  return { statusCode: 404, body: 'Not Found' };
};
```

### 4. Create config.json

```json
{
  "version": 1,
  "routes": [
    { "src": "^/api/(.*)$", "dest": "/functions/api" },
    { "handle": "filesystem" }
  ]
}
```

**Route order matters:** API routes must come before `filesystem` so `/api/*` requests are routed to Lambda instead of looking for static files.

### 5. Deploy

```bash
node $SKILL_DIR/bin/rebyte.js deploy
```

## Multiple API Functions

You can create multiple Lambda functions for different API paths:

```
.rebyte/
├── config.json
├── static/
└── functions/
    ├── api.func/          # /api/* routes
    │   └── index.js
    └── webhooks.func/     # /webhooks/* routes
        └── index.js
```

```json
{
  "version": 1,
  "routes": [
    { "src": "^/api/(.*)$", "dest": "/functions/api" },
    { "src": "^/webhooks/(.*)$", "dest": "/functions/webhooks" },
    { "handle": "filesystem" }
  ]
}
```
