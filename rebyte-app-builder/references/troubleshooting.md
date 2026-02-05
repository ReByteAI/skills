# Troubleshooting

## Error Reference

| Issue | Cause | Fix |
|-------|-------|-----|
| `req.on is not a function` | Handler expects HTTP, got Lambda | Use OpenNext for Next.js, or fix handler to use Lambda event format |
| `Cannot find module` | Dependencies not bundled | Include `node_modules` in function directory |
| `ERR_REQUIRE_ESM` | `.next/` copied from project instead of OpenNext | Re-copy with `cp -r .../default/.` (NOT `*`), never copy raw `.next/` |
| `ENOENT: required-server-files.json` | Hidden `.next/` dir not copied | Use `cp -r .../default/.` instead of `cp -r .../default/*` |
| 500/502 right after deploy | Propagation delay | Wait 90 seconds, then retry |
| 500 errors (persistent) | Lambda runtime error | Check logs: `node $SKILL_DIR/bin/rebyte.js logs -m 30` |
| 404 errors | Wrong routes in config.json | Check `config.json` routes match your URL paths |
| Static files not loading | Files not in `static/` | Verify `cp` copied files to `.rebyte/static/` |
| Image optimization errors | Lambda can't optimize images | Add `images: { unoptimized: true }` to `next.config.ts` |

## Checking Logs

```bash
# Recent logs (5 min)
node $SKILL_DIR/bin/rebyte.js logs

# Longer range (30 min)
node $SKILL_DIR/bin/rebyte.js logs -m 30
```

## CLI Validation

The CLI validates before deployment. Example output:

```
Validating .rebyte/...

✓ config.json exists: Found
✓ config.json valid JSON: Valid
✓ Routes defined: 2 routes
✓ Function default: entry file: index.js
✓ Function default: handler export: exports.handler
✓ Function default: smoke test: Passed
✓ Static directory: 47 files
```

### Missing Handler Export

```
✗ Function default: handler export: "handler" not exported

    index.js does not export "handler"

    Found exports: main, processRequest
    Did you mean one of these?

    The handler must be exported as:
      exports.handler = async (event, context) => { ... }
```

### Wrong Handler Format (Common with Next.js)

```
✗ Function default: smoke test: Failed

    Handler Error: event.on is not a function

    This handler expects Node.js HTTP IncomingMessage (with .on() method)
    but Lambda provides API Gateway event objects.

    This usually happens when:
    1. Using Next.js standalone output directly (doesn't work)
    2. Missing a proper Lambda adapter

    For Next.js SSR, use OpenNext which creates proper Lambda handlers:
      npx @opennextjs/aws build
```

## Common Mistakes

### DON'T: Copy Next.js standalone directly

```bash
# WRONG - This creates a broken handler
cp -r .next/standalone/* .rebyte/functions/default.func/
```

The standalone `server.js` expects HTTP streams (`req.on('data')`) which don't exist in Lambda.

### DO: Use OpenNext for Next.js

```bash
# CORRECT - OpenNext creates proper Lambda handlers
npx @opennextjs/aws build
# Then copy .open-next/ contents to .rebyte/
```

### DON'T: Use shell glob * for copying OpenNext output

```bash
# WRONG - Misses hidden .next/ directory
cp -r .open-next/server-functions/default/* .rebyte/functions/default.func/
```

### DO: Use /. to copy everything including hidden dirs

```bash
# CORRECT - Copies hidden directories too
cp -r .open-next/server-functions/default/. .rebyte/functions/default.func/
```

### DON'T: Guess the handler format

```javascript
// WRONG - Lambda doesn't provide req.on()
exports.handler = async (req, res) => {
  req.on('data', chunk => { ... });
};
```

### DO: Use Lambda event format

```javascript
// CORRECT - Lambda event is an object, not a stream
exports.handler = async (event, context) => {
  const body = event.body ? JSON.parse(event.body) : {};
  return { statusCode: 200, body: JSON.stringify(result) };
};
```
