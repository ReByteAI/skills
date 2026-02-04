# OpenClaw Troubleshooting Guide

## Table of Contents

1. [Gateway Startup Errors](#gateway-startup-errors)
2. [Configuration Errors](#configuration-errors)
3. [AI Provider Errors](#ai-provider-errors)
4. [Channel-Specific Errors](#channel-specific-errors)

---

## Gateway Startup Errors

### "gateway already running (pid XXXX); lock timeout after 5000ms"

**Cause**: Another gateway process is already running on port 18789.

**Fix**:
```bash
# Find and kill the existing process
lsof -i :18789
kill <PID>

# Or force kill all openclaw processes
pkill -f "openclaw" && pkill -f "entry.js"
```

### "Port 18789 is already in use"

**Cause**: Gateway or another service occupies the port.

**Fix**:
```bash
lsof -i :18789
kill <PID>
```

### "systemctl --user unavailable: Failed to connect to user scope bus"

**Cause**: Running in a container/VM without systemd user session (no `$DBUS_SESSION_BUS_ADDRESS`).

**Fix**: Use manual process management instead of `gateway stop`:
```bash
pkill -f "node.*entry.js"
```

---

## Configuration Errors

### "gateway.mode not set"

**Cause**: Missing `mode` field in gateway config.

**Fix**: Add to `~/.openclaw/openclaw.json`:
```json
{
  "gateway": {
    "mode": "local"
  }
}
```

### "gateway.auth.token required"

**Cause**: Local mode requires an auth token.

**Fix**: Add auth token:
```json
{
  "gateway": {
    "mode": "local",
    "auth": {
      "token": "any-random-string-for-local-dev"
    }
  }
}
```

### Schema validation error for "gateway.auth.mode"

**Cause**: Explicitly setting `"mode": "token"` in auth section causes validation error.

**Fix**: Remove the explicit `mode` field from auth - it defaults correctly:
```json
{
  "gateway": {
    "mode": "local",
    "auth": {
      "token": "your-token"
    }
  }
}
```

NOT this:
```json
{
  "gateway": {
    "auth": {
      "mode": "token",  // REMOVE THIS LINE
      "token": "your-token"
    }
  }
}
```

---

## AI Provider Errors

### "No API key found for provider anthropic"

**Cause**: No AI provider configured, or API key not set.

**Fix**: Configure a provider in `models.providers` and set the API key environment variable:
```bash
AI_GATEWAY_API_KEY="aig_xxx" node dist/entry.js gateway --verbose
```

### "Unknown model: vercel-ai-gateway/claude-sonnet-4.5"

**Cause**: Wrong model reference format for Vercel AI Gateway.

**Fix**: Use the correct format with vendor prefix:
```
vercel-ai-gateway/anthropic/claude-sonnet-4.5
```

NOT:
```
vercel-ai-gateway/claude-sonnet-4.5
```

### "HTTP 401 authentication_error: Error verifying OIDC token"

**Cause**: Using `vercel-ai-gateway/` prefix which requires Vercel OIDC authentication.

**This is NOT the same as Rebyte AI Gateway.**

**Fix**: If using Rebyte AI Gateway (OpenAI-compatible), configure a custom provider instead:

```json
{
  "models": {
    "providers": {
      "rebyte": {
        "baseUrl": "https://api.rebyte.ai/api/ai/v1",
        "apiKey": "${AI_GATEWAY_API_KEY}",
        "api": "openai-completions",
        "models": [
          { "id": "claude-sonnet-4.5", "name": "Claude Sonnet 4.5" }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": { "primary": "rebyte/claude-sonnet-4.5" }
    }
  }
}
```

**Key difference**:
- **Vercel AI Gateway**: Requires OIDC tokens, tied to Vercel deployments, model format `vercel-ai-gateway/vendor/model`
- **Rebyte AI Gateway**: OpenAI-compatible API, uses simple API key, configure as custom provider

### "Model not found" or "Invalid model"

**Cause**: Model ID doesn't match what the provider supports.

**Fix**: Check available models for your provider. For Rebyte AI Gateway:
- `claude-sonnet-4.5`
- `claude-opus-4.5`
- `gpt-4o`
- `gemini-3-flash`
- `gemini-3-pro`

---

## Channel-Specific Errors

### Telegram: Bot not responding

**Checklist**:
1. Verify bot token is correct (get from @BotFather)
2. Check `enabled: true` in telegram config
3. Check `dmPolicy: "open"` for DM access
4. Look for errors in logs: `tail -f /tmp/openclaw/openclaw-*.log`

### Telegram: "allowFrom" not working

**Cause**: Misconfigured allowlist.

**Fix**: Use `["*"]` to allow all, or specific user IDs:
```json
{
  "channels": {
    "telegram": {
      "allowFrom": ["*"],
      "groupPolicy": "allowlist"
    }
  }
}
```

---

## Diagnostic Commands

```bash
# Check if gateway is running
ps aux | grep -E "node.*entry|openclaw" | grep -v grep

# Check port usage
lsof -i :18789

# View recent logs
tail -100 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log

# Run doctor to fix common issues
node /code/openclaw/dist/entry.js doctor --fix
```
