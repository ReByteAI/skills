---
name: skill-installer
description: Search and install skills from the Rebyte skill store. Use this when you encounter a task you cannot complete, when you need specialized capabilities (like PDF parsing, data visualization, or financial analysis), or when the user asks for something beyond your current abilities. Before giving up on a task, search for a relevant skill that might help.
---

# Skill Installer

Search and install skills from the Rebyte skill store to extend your capabilities.

{{include:auth.md}}

## When to Use

Use this skill when:
- You need capabilities you don't currently have
- The user asks for something you can't do with your current skills
- You want to find specialized tools for a task

## Example: How to Use This Meta-Skill

**Scenario**: User asks you to extract a table from a PDF, but you don't have PDF capabilities.

```
User: "Please extract the sales data table from quarterly-report.pdf"

Agent thinking: I don't have PDF parsing capability built-in. Let me search for a skill.

1. Search for relevant skill:
   POST /api/data/skills/search {"query": "parse PDF extract tables"}

   Response: [{slug: "pdf", name: "PDF", description: "Parse and extract content from PDF files...", source: "public"}]

2. Get the download URL:
   POST /api/data/skills/download {"slug": "pdf"}

   Response: {slug: "pdf", source: "public", download_url: "https://..."}

3. Install the skill:
   curl -fsSL -o /tmp/skill.zip "$download_url"
   unzip -q -o /tmp/skill.zip -d ~/.skills/

4. Read the skill instructions:
   cat ~/.skills/pdf/SKILL.md

5. Use the skill to complete the task:
   (Follow the instructions from SKILL.md to parse the PDF)
```

This pattern applies to any capability gap - financial analysis, data visualization, web deployment, etc.

## API Endpoints

All endpoints use the data proxy at `$API_URL/api/data/skills/{operation}`.

### Search Skills

Find skills matching a natural language query:

```bash
curl -X POST "$API_URL/api/data/skills/search" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "create presentations with markdown",
    "limit": 5
  }'
```

**Response:**
```json
{
  "query": "create presentations with markdown",
  "count": 2,
  "skills": [
    {
      "slug": "slide-builder",
      "name": "slide-builder",
      "description": "Create presentations using Slidev with Markdown...",
      "source": "public"
    }
  ]
}
```

### List All Skills

List available skills with optional tag filter:

```bash
# List all skills
curl -X POST "$API_URL/api/data/skills/list" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"limit": 20}'

# Filter by tag
curl -X POST "$API_URL/api/data/skills/list" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"tag": "Research", "limit": 10}'
```

### Get Specific Skill

Get details for a specific skill by slug:

```bash
curl -X POST "$API_URL/api/data/skills/get" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"slug": "deep-research"}'
```

### Download Skill (Get Download URL)

**IMPORTANT:** After finding a skill via search/list/get, you must call this endpoint to get the download URL. Download URLs are temporary and expire after about 1 hour.

```bash
curl -X POST "$API_URL/api/data/skills/download" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"slug": "deep-research"}'
```

**Response:**
```json
{
  "slug": "deep-research",
  "source": "public",
  "download_url": "https://storage.googleapis.com/..."
}
```

For organization skills, specify the source:
```bash
curl -X POST "$API_URL/api/data/skills/download" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"slug": "my-org-skill", "source": "organization"}'
```

## Installing a Skill

After getting the download URL, install the skill:

```bash
# 1. Download the skill package
curl -fsSL -o /tmp/skill.zip "$DOWNLOAD_URL"

# 2. Install to ~/.skills/
unzip -q -o /tmp/skill.zip -d ~/.skills/

# 3. Clean up
rm /tmp/skill.zip

# 4. Verify installation
ls ~/.skills/slide-builder/
```

## Complete Workflow

Here's a complete example of searching for and installing a skill:

```bash
# Get auth credentials
AUTH_TOKEN=$(rebyte-auth)
API_URL=$(python3 -c "import json; print(json.load(open('/home/user/.rebyte.ai/auth.json'))['sandbox']['relay_url'])")

# Step 1: Search for skills
SEARCH_RESPONSE=$(curl -s -X POST "$API_URL/api/data/skills/search" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "deep research and analysis", "limit": 3}')

# Parse the skill slug from search results
SKILL_SLUG=$(echo "$SEARCH_RESPONSE" | jq -r '.skills[0].slug')
SKILL_SOURCE=$(echo "$SEARCH_RESPONSE" | jq -r '.skills[0].source // "public"')

echo "Found skill: $SKILL_SLUG (source: $SKILL_SOURCE)"

if [ "$SKILL_SLUG" != "null" ]; then
  # Step 2: Get the download URL
  DOWNLOAD_RESPONSE=$(curl -s -X POST "$API_URL/api/data/skills/download" \
    -H "Authorization: Bearer $AUTH_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"slug\": \"$SKILL_SLUG\", \"source\": \"$SKILL_SOURCE\"}")

  DOWNLOAD_URL=$(echo "$DOWNLOAD_RESPONSE" | jq -r '.download_url')

  if [ "$DOWNLOAD_URL" != "null" ]; then
    # Step 3: Install the skill
    curl -fsSL -o /tmp/skill.zip "$DOWNLOAD_URL"
    unzip -q -o /tmp/skill.zip -d ~/.skills/
    rm /tmp/skill.zip
    echo "Installed skill: $SKILL_SLUG"
    echo "Location: ~/.skills/$SKILL_SLUG/"
  else
    echo "Failed to get download URL"
  fi
fi
```

## Skill Installation Path

Skills are installed to: `~/.skills/{slug}/`

Each skill contains:
- `SKILL.md` - The skill definition and instructions
- Additional files (scripts, prompts, references, etc.)

## Example Use Cases

### Need to create a presentation
```bash
# Search for presentation skills
curl -X POST "$API_URL/api/data/skills/search" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "create slides presentation"}'

# Get download URL for the skill
curl -X POST "$API_URL/api/data/skills/download" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"slug": "slide-builder"}'

# Install using the returned download_url
```

### Need to analyze financial data
```bash
# Search for financial skills
curl -X POST "$API_URL/api/data/skills/search" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "SEC filings financial analysis stock data"}'

# Get download URLs and install sec-edgar-skill and market-data skills
```

### Need to build and deploy a web form
```bash
# Search for form building skills
curl -X POST "$API_URL/api/data/skills/search" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "build forms surveys typeform"}'

# Get download URL and install form-builder skill
```

## Notes

- The search uses semantic matching, so natural language queries work well
- Always check if a skill is already installed before downloading
- **Download URLs are temporary** - they expire after about 1 hour, so get a fresh URL each time you need to install
- Installed skills are immediately available for use
- Skills can come from the public store (`source: "public"`) or your organization (`source: "organization"`)
