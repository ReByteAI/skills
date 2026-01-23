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
  "authToken": "eyJ...",
  "instructions": "... detailed usage instructions ..."
}
```

**IMPORTANT:** The response includes detailed `instructions` on how to use the database. Always read and follow those instructions.

## Using the Database

Use Turso's HTTP API with pure `fetch` - no npm packages needed:

```javascript
// netlify/functions/api.js

// Get these from the provision response (convert libsql:// to https://)
const TURSO_URL = 'https://ws-abc123-rebyte.turso.io';
const TURSO_TOKEN = 'eyJ...';

/**
 * Execute SQL query via Turso HTTP API
 * @param {string} sql - SQL statement
 * @param {any[]} args - Query arguments (optional)
 * @returns {Promise<{columns: string[], rows: any[][]}>}
 */
async function query(sql, args = []) {
  const response = await fetch(`${TURSO_URL}/v2/pipeline`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${TURSO_TOKEN}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      requests: [
        {
          type: 'execute',
          stmt: {
            sql,
            args: args.map(a => ({ type: 'text', value: String(a) }))
          }
        },
        { type: 'close' }
      ]
    })
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Turso query failed: ${error}`);
  }

  const result = await response.json();
  const execResult = result.results[0];

  if (execResult.type === 'error') {
    throw new Error(`SQL error: ${execResult.error.message}`);
  }

  return {
    columns: execResult.response.result.cols.map(c => c.name),
    rows: execResult.response.result.rows.map(r => r.map(cell => cell.value))
  };
}

// Create table
await query(`
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE,
    name TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )
`);

// Insert with parameters
await query('INSERT INTO users (email, name) VALUES (?, ?)', ['user@example.com', 'John']);

// Query data
const { columns, rows } = await query('SELECT * FROM users');
console.log(columns); // ['id', 'email', 'name', 'created_at']
console.log(rows);    // [[1, 'user@example.com', 'John', '2024-01-01 12:00:00']]

export async function handler(event) {
  const result = await query('SELECT * FROM users');
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(result.rows)
  };
}
```

### URL Format

The provision response returns `libsql://` URL. Convert it to `https://` for the HTTP API:
- `libsql://ws-abc123-rebyte.turso.io` → `https://ws-abc123-rebyte.turso.io`

## Important Notes

- **One database per workspace** - calling provision again returns the same database
- **Read the instructions** - the provision response includes detailed usage instructions
- **Use https:// URL** - convert the libsql:// URL to https:// for the HTTP API
- **authToken is secret** - never expose it in client-side code
- **No npm packages needed** - the `query()` function uses pure `fetch`

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
