# AI Gateway (LLM Access)

If your app needs AI/LLM capabilities (chat, text generation, etc.), use the `ai-gateway` skill to provision an API key.

| Feature | Skill | Description |
|---------|-------|-------------|
| **AI Gateway** | `ai-gateway` | OpenAI-compatible API for LLM access (GPT, Claude, Gemini) |

## When to Use

If the user wants to build:
- AI chat applications
- Apps with text generation features
- Anything using Vercel AI SDK, LangChain, or OpenAI SDK

## How It Works

1. Deploy your app first (using the `rebyte-app-builder` skill)
2. Provision an AI Gateway key using the `ai-gateway` skill
3. Inject the key into your deployment's environment variables
4. Use standard OpenAI SDK or Vercel AI SDK in your server-side code

**Important:** The AI Gateway key must only be used in server-side code (Lambda functions, API routes). Never expose it in frontend JavaScript.

## Example with Vercel AI SDK

```typescript
// app/api/chat/route.ts (server-side)
import { openai } from '@ai-sdk/openai';
import { streamText } from 'ai';

export async function POST(req: Request) {
  const { messages } = await req.json();
  const result = streamText({
    model: openai('gemini-3-flash'), // Uses OPENAI_API_KEY from env
    messages,
  });
  return result.toDataStreamResponse();
}
```

Usage is automatically billed to your organization's credits.
