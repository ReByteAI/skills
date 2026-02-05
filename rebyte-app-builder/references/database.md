# Database Options

If your app needs persistent data storage, ask the user which database type they prefer.

| Type | Skill | Best For |
|------|-------|----------|
| **SQL Database** | `sqlite-database` | Relational data, complex queries, joins |
| **Key-Value Database** | `dynamodb-database` | Simple lookups, high-performance NoSQL, flexible schema |

**When to ask:** If the user's requirements include data persistence but don't specify a database type, ask:
- "Do you need a SQL database (for relational data with joins) or a key-value store (for simple, fast lookups)?"

Both options are fully managed and automatically cleaned up when the site is deleted.
