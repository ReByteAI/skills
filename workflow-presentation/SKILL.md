---
name: Presentation Workflow
description: Research a topic and build a professional presentation with Slidev. Use when user wants to create slides backed by real data, conference talks, pitch decks, or any presentation that needs research first. Triggers include "research and create presentation", "build a slide deck about", "create a pitch deck", "make a presentation on", "conference talk about".
---

# Presentation Workflow

Build presentations backed by real, researched content. This workflow connects research skills with the slide builder to go from a user's topic to a finished, deployed Slidev presentation.

## Sub-Skills

- `rebyteai/internet-search` — Quick web search for facts, statistics, and supporting data
- `rebyteai/deep-research` — Comprehensive multi-source research with citations when the topic requires depth
- `rebyteai/slide-builder` — Create the presentation using Slidev (Markdown-based slides), deploy to rebyte.pro
- `rebyteai/text-to-speech` — Generate voiceover audio for slides (optional, only when user requests narration)

## Workflow

### Step 1: Understand the Presentation

Before doing anything, clarify:
- **Topic & goal** — What should the audience learn, feel, or do after watching?
- **Audience** — Technical level, context, expectations
- **Slide count** — Rough number (default to 8-12 if not specified)
- **Theme & style** — Ask the user what visual style they prefer:

  > "What theme would you like? Some options:
  > - **Conference/keynote** → `seriph` (elegant serif)
  > - **Developer audience** → `dracula` (dark purple)
  > - **Product launch** → `apple-basic` (Apple-inspired)
  > - **Academic/research** → `academic` (paper-style)
  > - **Creative/fun** → `unicorn` (rainbow/playful)
  > - Or I can auto-pick based on your topic."

- **Voiceover** — Mention that voiceover narration is available: "Would you like me to generate voiceover audio for each slide? I can create natural-sounding narration using text-to-speech."

If the user's request is already detailed enough, skip the questions and proceed.

### Step 2: Research the Topic

Choose your research strategy based on what the presentation needs:

**Factual content (stats, quotes, current data):**
Use `internet-search`. Run targeted searches to gather supporting data — statistics, market figures, quotes, recent developments. Example: "global AI market size 2025", "top SaaS metrics benchmarks".

**Deep subject matter (comprehensive coverage, multiple perspectives):**
Use `deep-research`. This handles multi-source synthesis, cross-referencing, and citation tracking. Example: for a presentation on "Future of Remote Work", deep-research would gather trends, company policies, productivity studies, and expert opinions.

**No research needed:**
If the user provides all the content (e.g., "here are my bullet points, make them into slides"), skip research entirely and go straight to building.

Organize research findings into a structured outline before building slides:
- Group facts by slide/section
- Note which data points need citations
- Identify gaps where you need additional searches

### Step 3: Build the Presentation

Use `slide-builder` to create the Slidev presentation:

1. **Initialize** with the chosen theme (or `seriph` as default)
2. **Structure the deck:**
   - Opening (1-2 slides): Hook + agenda
   - Body (80%): Main content in logical sections
   - Closing (1-2 slides): Summary + call-to-action
3. **Write slides** following Slidev best practices:
   - One idea per slide
   - 6 words per bullet, 6 bullets max
   - Prefer diagrams, code blocks, and visuals over walls of text
   - Use appropriate layouts: `cover` for titles, `two-cols` for comparisons, `image-right` for features, `fact` for key metrics
4. **Add Slidev features** where they enhance the presentation:
   - **Mermaid diagrams** for architecture, flowcharts, timelines
   - **Code blocks with highlighting** for technical content
   - **Click animations** (`v-click`) to reveal content progressively
   - **Speaker notes** below each slide (use `<!-- ... -->` comments)
5. **Deploy** — Build and deploy automatically to rebyte.pro using `rebyte-app-builder`
6. **Verify** — Use `browser-automation` to screenshot each slide and confirm rendering

### Step 4: Add Voiceover (Optional)

Only if the user requested narration:

1. Write a natural voiceover script for each slide (conversational, not just reading bullets)
2. Use `text-to-speech` to generate audio for each slide
3. Upload audio files as artifacts
4. Let the user know the audio files are available and can be synced with the slides

### Step 5: Present Results

After building the presentation:

1. Share the deployed URL (live on rebyte.pro)
2. Explain what's in it:
   - Number of slides and structure
   - Theme used and why
   - Key data sources cited
   - Any Slidev features used (diagrams, animations, etc.)
3. Mention available exports: "I can also export this as PDF, PowerPoint, or PNG images if you need a downloadable version."
4. Ask for feedback: specific slide edits, reordering, adding/removing content

### Step 6: Iterate

When the user requests changes:
- Edit specific slides in `slides.md`
- Rebuild and redeploy
- Screenshot the updated slides to confirm

## Decision Points

- **"Should I research or just build?"** — If the user provides all content (bullet points, outline, data), skip research. If they give a topic and expect you to fill in the substance, research first.

- **"internet-search or deep-research?"** — If you need a few supporting stats or quotes, use `internet-search`. If the entire presentation content needs to be built from research (competitor analysis, market report, trend analysis), use `deep-research`.

- **"Which theme?"** — Always ask unless the user specified one or the context makes it obvious (e.g., "thesis defense" → `academic`, "startup pitch" → `seriph`).

- **"Should I add voiceover?"** — Mention it's available during Step 1. Only generate if the user opts in. Don't generate voiceover by default.

- **"The user wants a downloadable file"** — After deploying the live version, use Slidev's export commands (PDF, PPTX, PNG) and upload to the Artifact Store.
