---
name: ai-gateway
description: Add AI/LLM capabilities to deployed applications. Provision an API key for your deployment to access OpenAI-compatible endpoints (GPT, Claude, Gemini) with usage billed to your organization.
---

# AI Gateway for Deployed Applications

Provision an AI Gateway API key for your deployed application to access LLM APIs (OpenAI, Anthropic, Google) through an OpenAI-compatible interface.

## When to Use This Skill

Use this skill when:
- Building an AI chat application
- Adding AI-powered features to a web app
- Need LLM access from a serverless function
- Want to use Vercel AI SDK, LangChain, or OpenAI SDK in deployed code

## Prerequisites

**You must deploy your app first** using the `rebyte-app-builder` skill before provisioning an AI Gateway key. The key is tied to a specific deployment.

## Quick Start

### Step 1: Provision the API Key

After deploying your app:

```bash
# Provision AI Gateway key (uses default deployment for workspace)
curl -X POST "$API_URL/api/data/aigateway/provision" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json"
```

Response:
```json
{
  "deployId": "myapp-f33ad2defb",
  "apiKey": "aig_myapp-f33ad2defb_a1b2c3d4e5f6...",
  "baseUrl": "https://api.rebyte.ai/api/ai",
  "isNew": true
}
```

### Step 2: Inject Key into Deployment Environment

```bash
curl -X POST "$API_URL/api/data/deployments/update-env" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "deployId": "myapp-f33ad2defb",
    "environment": {
      "OPENAI_API_KEY": "aig_myapp-f33ad2defb_a1b2c3d4e5f6...",
      "OPENAI_BASE_URL": "https://api.rebyte.ai/api/ai/v1"
    }
  }'
```

### Step 3: Redeploy to Apply Environment

```bash
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js deploy
```

---

## Using the AI Gateway in Your Code

### With Vercel AI SDK

```typescript
// app/api/chat/route.ts
import { openai } from '@ai-sdk/openai';
import { streamText } from 'ai';

export async function POST(req: Request) {
  const { messages } = await req.json();

  // Uses OPENAI_API_KEY and OPENAI_BASE_URL from environment
  const result = streamText({
    model: openai('gemini-3-flash'), // or gpt-4o, claude-sonnet-4.5
    messages,
  });

  return result.toDataStreamResponse();
}
```

### With OpenAI SDK

```javascript
// functions/chat.func/index.js
const OpenAI = require('openai');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
  baseURL: process.env.OPENAI_BASE_URL,
});

exports.handler = async (event) => {
  const { messages } = JSON.parse(event.body || '{}');

  const response = await openai.chat.completions.create({
    model: 'gemini-3-flash',
    messages,
  });

  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(response.choices[0].message),
  };
};
```

### With Raw Fetch

```javascript
// functions/api.func/index.js
exports.handler = async (event) => {
  const { messages } = JSON.parse(event.body || '{}');

  const response = await fetch(`${process.env.OPENAI_BASE_URL}/chat/completions`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'gemini-3-flash',
      messages,
      stream: false,
    }),
  });

  const data = await response.json();

  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data.choices[0].message),
  };
};
```

---

## Available Models

| Model | Provider | Best For |
|-------|----------|----------|
| `gemini-3-flash` | Google | Fast responses, cost-effective |
| `gemini-3-pro` | Google | Complex reasoning |
| `gpt-4o` | OpenAI | General purpose, vision |
| `gpt-5.2-codex` | OpenAI | Code generation |
| `claude-sonnet-4.5` | Anthropic | Long context, analysis |
| `claude-opus-4.5` | Anthropic | Most capable |

---

## API Endpoints

The AI Gateway provides OpenAI-compatible endpoints:

| Endpoint | Description |
|----------|-------------|
| `POST /v1/chat/completions` | Chat completions (streaming and non-streaming) |
| `POST /v1/responses` | Responses API (for Codex models) |
| `GET /v1/models` | List available models |

Base URL: `https://api.rebyte.ai/api/ai`

---

## API Operations

### Provision Key

```bash
# Create or get existing key
curl -X POST "$API_URL/api/data/aigateway/provision" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"deployId": "myapp-f33ad2defb"}'  # Optional, uses default if omitted
```

### Get Key Info

```bash
# Check if key exists (doesn't create new one)
curl -X POST "$API_URL/api/data/aigateway/info" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json"
```

### Revoke Key

```bash
# Revoke key (call provision to generate new one)
curl -X POST "$API_URL/api/data/aigateway/revoke" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json"
```

---

## Security: Server-Side Only

**CRITICAL:** The AI Gateway key must ONLY be used in server-side code.

### ✅ DO: Use in Lambda/Server Functions

```javascript
// functions/api.func/index.js - SERVER-SIDE, SAFE
exports.handler = async (event) => {
  const response = await fetch(`${process.env.OPENAI_BASE_URL}/chat/completions`, {
    headers: { 'Authorization': `Bearer ${process.env.OPENAI_API_KEY}` },
    // ...
  });
};
```

### ❌ DON'T: Expose in Frontend Code

```javascript
// src/App.tsx - CLIENT-SIDE, DANGEROUS
const response = await fetch('https://api.rebyte.ai/api/ai/v1/chat/completions', {
  headers: { 'Authorization': 'Bearer aig_...' }  // KEY EXPOSED!
});
```

**Why:** Frontend code is visible to users. Anyone can copy the key from browser DevTools.

**Note:** The AI Gateway does NOT allow cross-origin requests (no CORS), so frontend calls will fail anyway. This is intentional security.

---

## Billing

- Usage is automatically tracked and billed to your organization's credits
- View usage in the Rebyte dashboard under Billing
- Each API call is logged with model, tokens, and cost

---

## Complete Example: AI Chat App

### 1. Create the App

```bash
# Create Next.js app with AI
npx create-next-app@latest my-ai-chat --typescript --tailwind
cd my-ai-chat

# Install dependencies
npm install ai @ai-sdk/openai
npm install -D @opennextjs/aws
```

### 2. Create API Route

```typescript
// app/api/chat/route.ts
import { openai } from '@ai-sdk/openai';
import { streamText } from 'ai';

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = streamText({
    model: openai('gemini-3-flash'),
    messages,
  });

  return result.toDataStreamResponse();
}
```

### 3. Create Chat UI

```typescript
// app/page.tsx
'use client';
import { useChat } from 'ai/react';

export default function Chat() {
  const { messages, input, handleInputChange, handleSubmit } = useChat();

  return (
    <div className="flex flex-col h-screen p-4">
      <div className="flex-1 overflow-auto">
        {messages.map(m => (
          <div key={m.id} className="mb-4">
            <strong>{m.role}:</strong> {m.content}
          </div>
        ))}
      </div>
      <form onSubmit={handleSubmit} className="flex gap-2">
        <input
          value={input}
          onChange={handleInputChange}
          className="flex-1 border p-2 rounded"
          placeholder="Say something..."
        />
        <button type="submit" className="bg-blue-500 text-white px-4 rounded">
          Send
        </button>
      </form>
    </div>
  );
}
```

### 4. Build and Deploy

```bash
# Build with OpenNext
npx @opennextjs/aws build

# Create .rebyte/ directory
mkdir -p .rebyte/static .rebyte/functions/default.func
cp -r .open-next/assets/* .rebyte/static/
cp -r .open-next/server-functions/default/* .rebyte/functions/default.func/

cat > .rebyte/config.json << 'EOF'
{
  "version": 1,
  "routes": [
    { "handle": "filesystem" },
    { "src": "^/(.*)$", "dest": "/functions/default" }
  ]
}
EOF

# Deploy
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js deploy
```

### 5. Provision AI Gateway

```bash
# Get the deployed deployId from deploy output, then:
curl -X POST "$API_URL/api/data/aigateway/provision" \
  -H "Authorization: Bearer $AUTH_TOKEN"

# Inject keys into environment
curl -X POST "$API_URL/api/data/deployments/update-env" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "deployId": "<your-deploy-id>",
    "environment": {
      "OPENAI_API_KEY": "<your-aig-key>",
      "OPENAI_BASE_URL": "https://api.rebyte.ai/api/ai/v1"
    }
  }'

# Redeploy to apply env vars
node /home/user/.skills/rebyteai-rebyte-app-builder/bin/rebyte.js deploy
```

Your AI chat app is now live at `https://<deploy-id>.rebyte.pro`!

---

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| "No deployment found" | App not deployed yet | Deploy with rebyte-app-builder first |
| "Invalid API key" | Key revoked or wrong | Run `aigateway/provision` again |
| CORS error in browser | Calling from frontend | Move API call to server function |
| 401 Unauthorized | Missing/wrong env var | Check OPENAI_API_KEY is set |
| "Model not found" | Invalid model name | Check available models list |
