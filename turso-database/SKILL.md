---
name: turso-database
description: Provision SQLite databases via Turso for web apps. Use when an app needs a database, persistent storage, or backend data. Triggers include "add a database", "need storage", "store data", "save to database", "SQLite", "Turso".
---

# Turso Database

Provision SQLite databases for your web apps via Turso.

{{include:auth.md}}

## When to Use

Use this skill when your app needs:
- Persistent data storage
- User data, submissions, or records
- Any backend database functionality

## Provision a Database

```bash
curl -X POST "$API_URL/api/data/turso/provision" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}'
```

Response:
```json
{
  "dbId": "ws-abc123",
  "url": "libsql://ws-abc123-rebyte.turso.io",
  "authToken": "eyJ..."
}
```

## Using the Database

### In Netlify Functions (Serverless)

```javascript
// netlify/functions/api.js
import { createClient } from '@libsql/client/web';

const db = createClient({
  url: process.env.TURSO_URL,
  authToken: process.env.TURSO_AUTH_TOKEN,
});

export default async (request) => {
  // Create table (run once)
  await db.execute(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT UNIQUE,
      name TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  // Insert data
  await db.execute({
    sql: 'INSERT INTO users (email, name) VALUES (?, ?)',
    args: ['user@example.com', 'John']
  });

  // Query data
  const result = await db.execute('SELECT * FROM users');
  return Response.json(result.rows);
};

export const config = { path: "/api/*" };
```

### Environment Variables

When deploying to Netlify, include a `.env.production` file in your ZIP with the credentials:

```bash
# 1. Provision database
TURSO=$(curl -s -X POST "$API_URL/api/data/turso/provision" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" -d '{}')

# 2. Create .env.production file
echo "TURSO_URL=$(echo $TURSO | jq -r '.url')" > .env.production
echo "TURSO_AUTH_TOKEN=$(echo $TURSO | jq -r '.authToken')" >> .env.production

# 3. Include in your ZIP and deploy
cp .env.production dist/
cd dist && zip -r ../site.zip . && cd ..
curl -X PUT "$UPLOAD_URL" -H "Content-Type: application/zip" --data-binary @site.zip
curl -X POST "$API_URL/api/data/netlify/deploy" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"deployId\": \"$DEPLOY_ID\"}"
```

The deploy handler automatically:
1. Reads `.env.production` from the ZIP
2. Sets the variables on your Netlify site
3. Removes the file from deployed files (for security)

Your functions access them via `process.env`:

```javascript
const db = createClient({
  url: process.env.TURSO_URL,
  authToken: process.env.TURSO_AUTH_TOKEN,
});
```

**Note:** If your functions don't need environment variables, include an empty `.env.production` file.

## Important Notes

- **One database per workspace** - calling provision again returns the same database
- **Use `@libsql/client/web`** - the `/web` import works in serverless environments (HTTP mode)
- **authToken is secret** - never expose it in client-side code

## API Reference

### Provision Database

```
POST /api/data/turso/provision
```

Creates or returns existing database for the workspace.

### Get Database Info

```
POST /api/data/turso/info
```

Returns database details without creating a new one.
