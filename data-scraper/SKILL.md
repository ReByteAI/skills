---
name: data-scraper
description: Scrape websites and extract structured data from the internet using Apify actors. Use when you need to extract data from websites, crawl pages, scrape YouTube, TikTok, social media, or any web content. Triggers include "scrape website", "web scraping", "crawl site", "extract data", "scrape pages", "scrape youtube", "scrape tiktok", "data scraper".
---

# Data Scraper

Scrape websites and extract structured data using [Apify](https://apify.com) actors.

This skill uses an **Apify proxy** — it accepts the same request/response format as the Apify API, but authentication is handled via your VM's sandbox token. You do **NOT** have an Apify API key and **CANNOT** call `api.apify.com` directly. All requests MUST go through the data proxy.

{{include:auth.md}}

## IMPORTANT: Always Save Results to File

**NEVER print scrape results to stdout.** Scrape results can be very large (transcripts, video lists, page content) and will be truncated in your context window. Always save results to a file under `/code/` and then read only what you need.

```bash
# WRONG - output goes to stdout and gets truncated
curl -s -X POST "$API_URL/api/data/apify/run-actor" ...

# CORRECT - save to file, then inspect selectively
curl -s -X POST "$API_URL/api/data/apify/run-actor" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{...}' > /code/scrape-results.json

echo "Saved $(wc -c < /code/scrape-results.json) bytes to /code/scrape-results.json"

# Then read only what you need
cat /code/scrape-results.json | python3 -c "import sys,json; d=json.load(sys.stdin); print('Items:', d.get('itemCount',0))"
```

## How It Works

Apify has thousands of pre-built scrapers ("actors") for virtually any website or data source. The data proxy handles Apify authentication on your behalf.

**Your workflow for any scraping task:**

1. **Pick an Apify actor** for your use case
2. **Fetch the actor's docs** via the proxy to learn the exact input format
3. **Run the actor** via the proxy, saving results to `/code/`

All three steps use the same `$API_URL` and `$AUTH_TOKEN` — no other credentials needed.

## Step 1: Pick an Actor

### Recommended Actors

| Use Case | Actor ID |
|----------|----------|
| **YouTube videos/channels/search** | `streamers/youtube-scraper` |
| **TikTok videos/hashtags/users** | `clockworks/tiktok-scraper` |
| **General web scraping (JS pages)** | `apify/web-scraper` |
| **General web scraping (static)** | `apify/cheerio-scraper` |
| **Extract text/markdown from sites** | `apify/website-content-crawler` |

You can also list all available actors:

```bash
curl -s -X POST "$API_URL/api/data/apify/list-actors" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}'
```

## Step 2: Fetch the Actor's Input Schema and README

**CRITICAL:** Before calling any actor, you MUST fetch its documentation to understand the exact input format. Each actor has completely different fields.

```bash
curl -s -X POST "$API_URL/api/data/apify/get-actor-docs" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"actorId": "streamers/youtube-scraper"}' > /code/actor-docs.json

# Read the input schema
cat /code/actor-docs.json | python3 -c "
import sys, json
d = json.load(sys.stdin)
schema = d.get('inputSchema', {})
print('=== INPUT FIELDS ===')
for name, prop in schema.get('properties', {}).items():
    req = '(required)' if name in schema.get('required', []) else '(optional)'
    print(f'  {name}: {prop.get(\"type\",\"?\")} {req} - {prop.get(\"title\",\"\")}')
"
```

Read the `inputSchema` carefully — it contains every field name, type, description, default value, and allowed enum values. Use the `readme` field for additional context and examples.

## Step 3: Run the Actor (Save to File)

Once you know the actor ID and its input format (from `get-actor-docs`), run it and **save to a file**:

```bash
curl -s -X POST "$API_URL/api/data/apify/run-actor" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "actorId": "owner/actor-name",
    "input": {
      ... fields from the input schema ...
    }
  }' > /code/scrape-results.json

echo "Saved $(wc -c < /code/scrape-results.json) bytes"

# Check if successful
cat /code/scrape-results.json | python3 -c "import sys,json; d=json.load(sys.stdin); print('Success:', d.get('success'), '| Items:', d.get('itemCount',0))"
```

## Full Example: Scrape YouTube Videos

```bash
# Step 1: We already know the actor ID: streamers/youtube-scraper

# Step 2: Fetch the actor's docs to learn the input format
curl -s -X POST "$API_URL/api/data/apify/get-actor-docs" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"actorId": "streamers/youtube-scraper"}' > /code/actor-docs.json

cat /code/actor-docs.json | python3 -c "
import sys, json
d = json.load(sys.stdin)
for name, prop in d.get('inputSchema',{}).get('properties',{}).items():
    print(f'  {name}: {prop.get(\"type\",\"?\")} - {prop.get(\"title\",\"\")}')
"

# Step 3: Run the actor and save results to file
curl -s -X POST "$API_URL/api/data/apify/run-actor" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "actorId": "streamers/youtube-scraper",
    "input": {
      "searchQueries": ["machine learning tutorial"],
      "maxResults": 10,
      "maxResultsShorts": 0,
      "maxResultStreams": 0
    }
  }' > /code/youtube-results.json

echo "Saved $(wc -c < /code/youtube-results.json) bytes"
cat /code/youtube-results.json | python3 -c "import sys,json; d=json.load(sys.stdin); print('Success:', d.get('success'), '| Items:', d.get('itemCount',0))"
```

## Limits

- **Timeout:** 5 minutes per actor run (sync mode)
- **Only whitelisted actors can be used** — if you get an `actor_not_allowed` error, check the available actors with `list-actors`

## Error Handling

If the actor is not allowed:
```json
{
  "success": false,
  "error": "actor_not_allowed",
  "message": "Actor 'some/actor' is not allowed.",
  "allowedActors": [...]
}
```

If the run times out:
```json
{
  "success": false,
  "error": "timeout",
  "message": "Actor run exceeded the 5-minute sync timeout."
}
```
