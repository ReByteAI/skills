---
name: sqlite-database
description: Provision cloud SQLite databases for web apps. Use when an app needs a database, persistent storage, or backend data. Triggers include "add a database", "need storage", "store data", "save to database", "SQLite", "database".
---

# SQLite Database

Provision cloud SQLite databases for your web apps.

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

Use the HTTP API with pure `fetch` - no npm packages needed:

```javascript
// functions/api.js (CommonJS format for Netlify Functions)

// Get these from the provision response (convert libsql:// to https://)
const DB_URL = 'https://ws-abc123-rebyte.turso.io';
const DB_TOKEN = 'eyJ...';

/**
 * Execute SQL query via HTTP API
 * @param {string} sql - SQL statement
 * @param {any[]} args - Query arguments (optional)
 * @returns {Promise<{columns: string[], rows: any[][]}>}
 */
async function query(sql, args = []) {
  const response = await fetch(`${DB_URL}/v2/pipeline`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${DB_TOKEN}`,
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
    throw new Error(`Query failed: ${error}`);
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

// IMPORTANT: Use CommonJS format (exports.handler) for Netlify Functions
exports.handler = async function(event) {
  // Create table (runs on first request)
  await query(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT UNIQUE,
      name TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  if (event.httpMethod === 'POST') {
    const body = JSON.parse(event.body);
    await query('INSERT INTO users (email, name) VALUES (?, ?)', [body.email, body.name]);
    return {
      statusCode: 201,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ success: true })
    };
  }

  // GET - return all users
  const { columns, rows } = await query('SELECT * FROM users');
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(rows)
  };
};
```

### URL Format

The provision response returns `libsql://` URL. Convert it to `https://` for the HTTP API:
- `libsql://ws-abc123-rebyte.turso.io` → `https://ws-abc123-rebyte.turso.io`

## Important Notes

- **Use CommonJS format** - Netlify Functions require `exports.handler`, NOT `export default`
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
