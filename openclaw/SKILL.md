---
name: openclaw
description: Set up OpenClaw AI agent on Rebyte. Connect to Telegram, WhatsApp, Discord, Slack. Triggers include "setup claw", "openclaw", "telegram bot", "claim a claw".
---

# OpenClaw Setup on Rebyte

**GitHub:** https://github.com/openclaw/openclaw

OpenClaw connects your AI agent to messaging platforms (Telegram, WhatsApp, Discord, Slack).

**Complete these 3 steps in order. Verify each step before moving to the next.**

---

## Step 1: Get Your Messaging Platform Token

**Ask the user:**

> Which messaging platform do you want to use?
>
> 1. **Telegram** (Recommended - easiest)
> 2. **WhatsApp**
> 3. **Discord**
> 4. **Slack**

### Telegram Setup:
1. Open Telegram, search for **@BotFather**
2. Send `/newbot` and follow prompts
3. Copy the **bot token** (looks like `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

### Verify the Token:
```bash
curl -s "https://api.telegram.org/bot<TOKEN>/getMe" | jq
```
✅ Valid: `{"ok": true, "result": {"id": ..., "first_name": "YourBot"}}`
❌ Invalid: `{"ok": false, "error_code": 401}`

**DO NOT proceed until token is verified.**

---

## Step 2: Get AI Gateway Key

**Use the `ai-gateway` skill to provision an API key.**

The skill will return:
- `apiKey`: starts with `aig_...`
- `baseUrl`: `https://api.rebyte.ai/api/ai`

This is an OpenAI-compatible API. One key gives access to all models: Claude, GPT-4o, Gemini.

**Ask the user which model they prefer:**

> Which AI model do you want your bot to use?
>
> 1. **Claude** (Recommended) → `claude-sonnet-4.5`
> 2. **GPT-4o** → `gpt-4o`
> 3. **Gemini** → `gemini-2.0-flash`

---

## Step 3: Install and Configure OpenClaw

### Install:
```bash
pnpm add -g openclaw@latest
```

### Configure:

Create `~/.openclaw/openclaw.json`:

```bash
mkdir -p ~/.openclaw
cat > ~/.openclaw/openclaw.json << 'EOF'
{
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "open",
      "botToken": "TELEGRAM_BOT_TOKEN",
      "allowFrom": ["*"],
      "streamMode": "partial"
    }
  },
  "gateway": {
    "mode": "local",
    "auth": { "token": "local-token" }
  },
  "agents": {
    "defaults": {
      "model": { "primary": "rebyte/MODEL_ID" }
    }
  },
  "models": {
    "providers": {
      "rebyte": {
        "baseUrl": "https://api.rebyte.ai/api/ai/v1",
        "apiKey": "AI_GATEWAY_KEY",
        "api": "openai-completions",
        "models": [
          { "id": "claude-sonnet-4.5", "name": "Claude" },
          { "id": "gpt-4o", "name": "GPT-4o" },
          { "id": "gemini-2.0-flash", "name": "Gemini" },
          { "id": "minimax-pro", "name": "Minimax" },
          { "id": "moonshot-v1-128k", "name": "Kimi" },
          { "id": "glm-4-plus", "name": "GLM" }
        ]
      }
    }
  }
}
EOF
```

**Replace in the config:**
- `TELEGRAM_BOT_TOKEN` → the verified token from Step 1
- `AI_GATEWAY_KEY` → the key from Step 2
- `MODEL_ID` → the user's chosen model (e.g., `claude-sonnet-4.5`)

### Start:
```bash
openclaw gateway --verbose
```

### Test:
Open Telegram → Search for your bot → Send "Hello!"

Your bot should respond within seconds.

---

## Step 4: Keep Running with systemd

**IMPORTANT:** Running `openclaw gateway` directly will stop when the session ends. To keep it running permanently, install as a systemd service:

```bash
# Create service file
cat > /home/user/openclaw.service << 'EOF'
[Unit]
Description=OpenClaw AI Gateway
After=network.target

[Service]
Type=simple
User=user
WorkingDirectory=/home/user
ExecStart=/home/user/.local/share/pnpm/openclaw gateway
Restart=always
RestartSec=10
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

# Install and start
sudo cp /home/user/openclaw.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable openclaw
sudo systemctl start openclaw
```

Check status:
```bash
sudo systemctl status openclaw
```

View logs:
```bash
journalctl -u openclaw -f
```

---

## Troubleshooting

**Bot not responding:**
```bash
# Check logs
tail -f /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log
```

**Port already in use:**
```bash
pkill -f openclaw
openclaw gateway --verbose
```
