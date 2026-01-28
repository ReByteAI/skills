---
name: skill-installer
description: Search and install skills to extend your capabilities. Use this when you encounter a task you cannot complete, when you need specialized capabilities (like PDF parsing, data visualization, or financial analysis), or when the user asks for something beyond your current abilities. Before giving up on a task, search for a relevant skill that might help.
---

# Skill Installer

Search and install skills to extend your capabilities. There are two ways to find and install skills:

| Method | Best For | Searches |
|--------|----------|----------|
| **Vercel CLI** (`npx skills`) | Public/open-source skills | [skills.sh](https://skills.sh) - thousands of community skills |
| **Rebyte API** | Internal/organization skills | Rebyte skill store - includes private org skills |

## When to Use

Use this skill when:
- You need capabilities you don't currently have
- The user asks for something you can't do with your current skills
- You want to find specialized tools for a task

**Decision guide:**
- Need a common/popular skill? → Try **Vercel CLI** first (larger catalog)
- Need organization-specific or internal skills? → Use **Rebyte API**
- Not sure? → Search both

---

## Method 1: Vercel CLI (Recommended for Public Skills)

The Vercel skills CLI searches [skills.sh](https://skills.sh), a directory of thousands of open-source agent skills.

### Search for Skills

```bash
# Interactive search by keyword
npx skills find typescript

# Search for specific capabilities
npx skills find "pdf parsing"
npx skills find "code review"
npx skills find "react best practices"
```

This returns matching skills with install commands like:
```
Install with: npx skills add <owner/repo@skill>

getsentry/sentry-agent-skills@sentry-pr-code-review
└ https://skills.sh/getsentry/sentry-agent-skills/sentry-pr-code-review

vercel-labs/agent-skills@web-design-guidelines
└ https://skills.sh/vercel-labs/agent-skills/web-design-guidelines
```

### Install a Skill

```bash
# Install specific skill globally for all agents
npx skills add getsentry/sentry-agent-skills --skill sentry-pr-code-review -g -y

# Install for specific agent only
npx skills add vercel-labs/agent-skills --skill web-design-guidelines -g -a claude-code -y

# Install all skills from a repo
npx skills add vercel-labs/agent-skills --all -g -y
```

**Flags:**
- `-g, --global` - Install to user directory (recommended)
- `-a, --agent <agent>` - Target specific agent (claude-code, codex, opencode, gemini-cli)
- `-s, --skill <name>` - Install specific skill by name
- `-y, --yes` - Skip confirmation prompts
- `--all` - Install all skills from repo

### List Installed Skills

```bash
npx skills list
npx skills ls -g  # List global skills only
```

### Complete Vercel CLI Workflow

```bash
# 1. Search for what you need
npx skills find "pr review"

# 2. Install the skill you want
npx skills add getsentry/sentry-agent-skills --skill sentry-pr-code-review -g -y

# 3. Verify installation
npx skills list

# 4. Read the skill instructions
cat ~/.claude/skills/sentry-pr-code-review/SKILL.md
```

---

## Method 2: Rebyte API (For Internal/Organization Skills)

Use this method to access skills from the Rebyte skill store, including private organization skills not available on skills.sh.

{{include:auth.md}}

### Search Skills

```bash
curl -X POST "$API_URL/api/data/skills/search" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "create presentations with markdown", "limit": 5}'
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

### Download and Install

**Step 1:** Get the download URL (URLs expire after ~1 hour):

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

For organization skills:
```bash
curl -X POST "$API_URL/api/data/skills/download" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"slug": "my-org-skill", "source": "organization"}'
```

**Step 2:** Install the skill:

```bash
curl -fsSL -o /tmp/skill.zip "$DOWNLOAD_URL"
unzip -q -o /tmp/skill.zip -d ~/.skills/
rm /tmp/skill.zip
```

### Complete Rebyte API Workflow

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

---

## Skill Installation Paths

Skills are installed to different locations depending on the method:

| Method | Installation Path | Visible To |
|--------|-------------------|------------|
| Vercel CLI | `~/.agents/skills/` (canonical) + symlinks | All agents via symlinks |
| Rebyte API | `~/.skills/` | All agents (symlinked) |

Both methods work because agent skill directories are symlinked:
- `~/.claude/skills/` → `~/.skills/`
- `~/.codex/skills/` → `~/.skills/`
- `~/.gemini/skills/` → `~/.skills/`
- `~/.opencode/skills/` (searched directly by OpenCode)

---

## Example Scenarios

### Scenario 1: Need PDF parsing (use Vercel CLI)

```bash
# Search
npx skills find "pdf extract tables"

# Install
npx skills add anthropics/skills --skill pdf -g -y

# Use
cat ~/.claude/skills/pdf/SKILL.md
```

### Scenario 2: Need internal company skill (use Rebyte API)

```bash
# Search organization skills
curl -s -X POST "$API_URL/api/data/skills/search" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "company deployment process"}'

# Install (with source: organization)
# ... follow Rebyte API workflow above
```

### Scenario 3: Not sure where to find skill

```bash
# Try Vercel CLI first (larger public catalog)
npx skills find "financial analysis SEC filings"

# If not found, try Rebyte API
curl -s -X POST "$API_URL/api/data/skills/search" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "financial analysis SEC filings"}'
```

---

## Notes

- **Vercel CLI** requires Node.js (pre-installed in VMs)
- **Rebyte API** requires authentication (`rebyte-auth`)
- Skills installed via either method are immediately available
- Always read the skill's `SKILL.md` after installation to understand how to use it
- Check if a skill is already installed before downloading (`npx skills list` or `ls ~/.skills/`)
