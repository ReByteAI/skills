# OpenClaw Configuration Examples

## Table of Contents

1. [Minimal Telegram Setup](#minimal-telegram-setup)
2. [Minimal WhatsApp Setup](#minimal-whatsapp-setup)
3. [Full Telegram with Rebyte AI Gateway](#full-telegram-with-rebyte-ai-gateway)
4. [Full WhatsApp with Rebyte AI Gateway](#full-whatsapp-with-rebyte-ai-gateway)
5. [Multiple Channels](#multiple-channels)
6. [Custom OpenAI-Compatible Provider](#custom-openai-compatible-provider)
7. [Anthropic-Compatible Provider](#anthropic-compatible-provider)
8. [Local LLM (Ollama)](#local-llm-ollama)

---

## Minimal Telegram Setup

Bare minimum to get a Telegram bot running (requires separate AI provider setup):

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "open",
      "botToken": "YOUR_BOT_TOKEN_FROM_BOTFATHER",
      "allowFrom": ["*"]
    }
  },
  "gateway": {
    "mode": "local",
    "auth": {
      "token": "local-dev-token"
    }
  }
}
```

---

## Minimal WhatsApp Setup

Bare minimum to get WhatsApp working (requires separate AI provider setup):

**Prerequisites:**
- WhatsApp Business Account
- Meta Developer App with WhatsApp API enabled
- Access token and Phone Number ID from Meta Developer Portal

```json
{
  "channels": {
    "whatsapp": {
      "enabled": true,
      "dmPolicy": "open",
      "accessToken": "YOUR_WHATSAPP_ACCESS_TOKEN",
      "phoneNumberId": "YOUR_PHONE_NUMBER_ID",
      "verifyToken": "YOUR_WEBHOOK_VERIFY_TOKEN",
      "allowFrom": ["*"]
    }
  },
  "gateway": {
    "mode": "local",
    "auth": {
      "token": "local-dev-token"
    }
  }
}
```

---

## Full Telegram with Rebyte AI Gateway

Complete production-ready config using Rebyte AI Gateway:

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "open",
      "botToken": "${TELEGRAM_BOT_TOKEN}",
      "allowFrom": ["*"],
      "groupPolicy": "allowlist",
      "streamMode": "partial"
    }
  },
  "gateway": {
    "mode": "local",
    "auth": {
      "token": "${GATEWAY_AUTH_TOKEN}"
    }
  },
  "agents": {
    "defaults": {
      "maxConcurrent": 4,
      "subagents": {
        "maxConcurrent": 8
      },
      "model": {
        "primary": "rebyte/claude-sonnet-4.5"
      }
    }
  },
  "models": {
    "providers": {
      "rebyte": {
        "baseUrl": "https://api.rebyte.ai/api/ai/v1",
        "apiKey": "${AI_GATEWAY_API_KEY}",
        "api": "openai-completions",
        "models": [
          { "id": "claude-sonnet-4.5", "name": "Claude Sonnet 4.5" },
          { "id": "claude-opus-4.5", "name": "Claude Opus 4.5" },
          { "id": "gpt-4o", "name": "GPT-4o" },
          { "id": "gemini-3-flash", "name": "Gemini 3 Flash" }
        ]
      }
    }
  },
  "messages": {
    "ackReactionScope": "group-mentions"
  }
}
```

Run with:
```bash
TELEGRAM_BOT_TOKEN="xxx" \
GATEWAY_AUTH_TOKEN="local-token" \
AI_GATEWAY_API_KEY="aig_xxx" \
node /code/openclaw/dist/entry.js gateway --verbose
```

---

## Full WhatsApp with Rebyte AI Gateway

Complete production-ready config for WhatsApp using Rebyte AI Gateway:

```json
{
  "channels": {
    "whatsapp": {
      "enabled": true,
      "dmPolicy": "open",
      "accessToken": "${WHATSAPP_ACCESS_TOKEN}",
      "phoneNumberId": "${WHATSAPP_PHONE_NUMBER_ID}",
      "verifyToken": "${WHATSAPP_VERIFY_TOKEN}",
      "allowFrom": ["*"]
    }
  },
  "gateway": {
    "mode": "local",
    "auth": {
      "token": "${GATEWAY_AUTH_TOKEN}"
    }
  },
  "agents": {
    "defaults": {
      "maxConcurrent": 4,
      "subagents": {
        "maxConcurrent": 8
      },
      "model": {
        "primary": "rebyte/claude-sonnet-4.5"
      }
    }
  },
  "models": {
    "providers": {
      "rebyte": {
        "baseUrl": "https://api.rebyte.ai/api/ai/v1",
        "apiKey": "${AI_GATEWAY_API_KEY}",
        "api": "openai-completions",
        "models": [
          { "id": "claude-sonnet-4.5", "name": "Claude Sonnet 4.5" },
          { "id": "claude-opus-4.5", "name": "Claude Opus 4.5" },
          { "id": "gpt-4o", "name": "GPT-4o" },
          { "id": "gemini-3-flash", "name": "Gemini 3 Flash" }
        ]
      }
    }
  }
}
```

Run with:
```bash
WHATSAPP_ACCESS_TOKEN="xxx" \
WHATSAPP_PHONE_NUMBER_ID="xxx" \
WHATSAPP_VERIFY_TOKEN="your-verify-token" \
GATEWAY_AUTH_TOKEN="local-token" \
AI_GATEWAY_API_KEY="aig_xxx" \
node /code/openclaw/dist/entry.js gateway --verbose
```

---

## Multiple Channels

Telegram + Discord + Slack:

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "open",
      "botToken": "${TELEGRAM_BOT_TOKEN}",
      "allowFrom": ["*"]
    },
    "discord": {
      "enabled": true,
      "botToken": "${DISCORD_BOT_TOKEN}",
      "dmPolicy": "open"
    },
    "slack": {
      "enabled": true,
      "botToken": "${SLACK_BOT_TOKEN}",
      "appToken": "${SLACK_APP_TOKEN}"
    }
  },
  "gateway": {
    "mode": "local",
    "auth": {
      "token": "local-token"
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "rebyte/claude-sonnet-4.5"
      }
    }
  },
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
  }
}
```

---

## Custom OpenAI-Compatible Provider

For any OpenAI-compatible API (LiteLLM, vLLM, local proxies, etc.):

```json
{
  "models": {
    "providers": {
      "my-openai-proxy": {
        "baseUrl": "https://my-proxy.example.com/v1",
        "apiKey": "${MY_PROXY_API_KEY}",
        "api": "openai-completions",
        "models": [
          { "id": "gpt-4o", "name": "GPT-4o" },
          { "id": "claude-3-sonnet", "name": "Claude 3 Sonnet" }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "my-openai-proxy/gpt-4o"
      }
    }
  }
}
```

---

## Anthropic-Compatible Provider

For Anthropic API or compatible proxies:

```json
{
  "models": {
    "providers": {
      "anthropic-proxy": {
        "baseUrl": "https://api.anthropic.com",
        "apiKey": "${ANTHROPIC_API_KEY}",
        "api": "anthropic-messages",
        "models": [
          { "id": "claude-sonnet-4-5-20250514", "name": "Claude Sonnet 4.5" }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic-proxy/claude-sonnet-4-5-20250514"
      }
    }
  }
}
```

---

## Local LLM (Ollama)

Using Ollama running locally:

```json
{
  "models": {
    "providers": {
      "ollama": {
        "baseUrl": "http://127.0.0.1:11434/v1",
        "apiKey": "ollama",
        "api": "openai-completions",
        "models": [
          { "id": "llama3.3", "name": "Llama 3.3" },
          { "id": "qwen2.5", "name": "Qwen 2.5" }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "ollama/llama3.3"
      }
    }
  }
}
```

Start Ollama first:
```bash
ollama serve
ollama pull llama3.3
```

---

## Environment Variable Reference

| Variable | Description |
|----------|-------------|
| `TELEGRAM_BOT_TOKEN` | Token from @BotFather |
| `WHATSAPP_ACCESS_TOKEN` | WhatsApp Business API access token from Meta |
| `WHATSAPP_PHONE_NUMBER_ID` | WhatsApp phone number ID from Meta |
| `WHATSAPP_VERIFY_TOKEN` | Webhook verification token (you create this) |
| `DISCORD_BOT_TOKEN` | Discord bot token |
| `SLACK_BOT_TOKEN` | Slack bot OAuth token |
| `SLACK_APP_TOKEN` | Slack app-level token |
| `AI_GATEWAY_API_KEY` | Rebyte AI Gateway key (`aig_xxx`) |
| `GATEWAY_AUTH_TOKEN` | Local gateway auth token (any string) |
| `ANTHROPIC_API_KEY` | Direct Anthropic API key |
| `OPENAI_API_KEY` | Direct OpenAI API key |
