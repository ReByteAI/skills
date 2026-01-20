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

   Response: [{slug: "pdf", name: "PDF", description: "Parse and extract content from PDF files..."}]

2. Install the skill:
   curl -fsSL -o /tmp/skill.zip "$download_url"
   unzip -q -o /tmp/skill.zip -d ~/.skills/

3. Read the skill instructions:
   cat ~/.skills/pdf/SKILL.md

4. Use the skill to complete the task:
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
      "download_url": "https://..."
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

## Installing a Skill

After finding a skill, download and install it using the `download_url`:

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

# Search for skills
RESPONSE=$(curl -s -X POST "$API_URL/api/data/skills/search" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "deep research and analysis", "limit": 3}')

# Parse results
echo "$RESPONSE" | jq '.skills[] | {slug, name, description, download_url}'

# Install the first matching skill
DOWNLOAD_URL=$(echo "$RESPONSE" | jq -r '.skills[0].download_url')
SKILL_SLUG=$(echo "$RESPONSE" | jq -r '.skills[0].slug')

if [ "$DOWNLOAD_URL" != "null" ]; then
  curl -fsSL -o /tmp/skill.zip "$DOWNLOAD_URL"
  unzip -q -o /tmp/skill.zip -d ~/.skills/
  rm /tmp/skill.zip
  echo "Installed skill: $SKILL_SLUG"
  echo "Location: ~/.skills/$SKILL_SLUG/"
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
# Install slide-builder skill
```

### Need to analyze financial data
```bash
# Search for financial skills
curl -X POST "$API_URL/api/data/skills/search" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "SEC filings financial analysis stock data"}'
# Install sec-edgar-skill and market-data skills
```

### Need to build and deploy a web form
```bash
# Search for form building skills
curl -X POST "$API_URL/api/data/skills/search" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "build forms surveys typeform"}'
# Install form-builder skill
```

## Notes

- The search uses semantic matching, so natural language queries work well
- Always check if a skill is already installed before downloading
- Installed skills are immediately available for use
