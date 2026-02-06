---
name: Podcast Workflow
description: Research a topic and produce a podcast episode with AI-generated voices. Use when user wants to create a podcast, audio episode, narrated discussion, or audio content from a topic or document. Triggers include "create a podcast", "make a podcast episode", "podcast about", "audio episode", "narrated discussion", "turn this into a podcast".
---

# Podcast Workflow

Produce podcast episodes from scratch or from source material. This workflow connects research skills with text-to-speech to go from a topic to a finished audio episode with natural-sounding voices.

## Sub-Skills

- `rebyteai/internet-search` — Quick web search for facts, quotes, and current data to enrich episode content
- `rebyteai/deep-research` — Comprehensive multi-source research for in-depth topic coverage
- `rebyteai/text-to-speech` — Generate audio using OpenAI TTS voices (6 voices, HD quality, multiple formats)

## Workflow

### Step 1: Understand the Episode

Parse what the user wants. Identify:
- **Topic or source** — A topic to research, or a document/article to convert?
- **Format** — Solo narration, two-host discussion, interview style, news roundup?
- **Length** — Short (5 min, ~700 words), medium (10 min, ~1400 words), long (15+ min, ~2100+ words)
- **Tone** — Conversational, educational, debate, storytelling, professional?
- **Audience** — Technical, general, executive?

If the user provides source material (document, article, transcript), use that as the primary content. If they give a topic, research it first.

### Step 2: Research (if needed)

Skip this step if the user provides source material (uploaded document, pasted text, etc.).

**For topic-based episodes:**

Choose research depth based on the episode:

- **News/current events** — Use `internet-search` for 3-5 targeted searches to gather the latest facts, quotes, and developments.
- **Deep topic (history, analysis, explainer)** — Use `deep-research` for comprehensive multi-source coverage with citations.
- **Debate/discussion format** — Research both sides. Use `internet-search` to find arguments for and against, stats supporting each position.

Organize findings into an outline before writing the script:
- Group facts by segment/chapter
- Note compelling quotes and statistics
- Identify the narrative arc (hook → body → conclusion)

### Step 3: Write the Script

Write a complete, natural-sounding script. This is the most critical step — the script quality determines the podcast quality.

**Script rules:**
- Write for the **ear**, not the eye. Use short sentences, contractions, conversational phrasing.
- Avoid jargon unless the audience is technical. Define terms when you use them.
- Include transitions between segments ("Now, let's shift gears to...", "Here's where it gets interesting...")
- Mark speaker changes clearly if multi-voice.

**Format by episode type:**

**Solo narration (one host):**
```
[HOST]
Welcome to the show. Today we're diving into...
(content)
That's it for today. If you found this useful...
```
Recommended voice: `nova` (friendly, natural) or `onyx` (authoritative)

**Two-host discussion:**
```
[HOST A]
So I've been reading about this new trend in...

[HOST B]
Yeah, I saw that too. What surprised me was...

[HOST A]
Right, and the data actually shows...
```
Use two distinct voices, e.g., `nova` + `echo`, or `alloy` + `onyx`

**Interview style:**
```
[INTERVIEWER]
Tell us about your experience with...

[GUEST]
Well, it started when...
```
Use contrasting voices for clarity.

**Structure every episode with:**
1. **Cold open** (optional) — A compelling teaser or quote (10-15 seconds)
2. **Intro** — Welcome, topic intro, what listeners will learn
3. **Body** — Main content in 2-4 segments with transitions
4. **Outro** — Summary, key takeaway, sign-off

### Step 4: Generate Audio

Use `text-to-speech` to produce the audio:

1. **Split script by speaker** — Each speaker's lines become separate TTS calls
2. **Choose voices:**
   | Voice | Style | Best For |
   |-------|-------|----------|
   | `nova` | Female, friendly | Main host, narration |
   | `echo` | Male, warm | Co-host, conversational |
   | `onyx` | Male, deep | Authoritative, professional |
   | `alloy` | Neutral, versatile | General purpose |
   | `fable` | British, expressive | Storytelling |
   | `shimmer` | Female, soft | Calm, reflective content |

3. **Use `tts-1-hd` model** for final output quality
4. **Set speed to 0.9-0.95** for natural podcast pacing
5. **Handle long text** — TTS has a 4096 character limit per call. Split at sentence boundaries into ~3500 character chunks, generate each, then concatenate with ffmpeg:
   ```bash
   ffmpeg -i "concat:chunk1.mp3|chunk2.mp3|chunk3.mp3" -c copy episode.mp3
   ```
6. **For multi-voice episodes** — Generate each speaker's segments separately, then interleave and concatenate in the correct order

### Step 5: Deliver

After generating the audio:

1. Upload the final MP3 to the Artifact Store
2. Provide:
   - The audio file
   - The full script (so the user can review/edit)
   - Episode metadata: title, duration, segment breakdown
   - Sources cited (if research was done)
3. Ask if the user wants:
   - A different voice or pacing
   - Script edits before regenerating
   - Additional segments or a follow-up episode
   - A web player app (can build with `rebyte-app-builder`)

## Decision Points

- **"Research or use provided content?"** — If the user uploads a document or pastes text, use that as the source. If they give a topic, research it. Some prompts need both (e.g., "create a podcast about this article" — read the article AND research background context).

- **"How many voices?"** — Solo narration = 1 voice. Discussion/debate = 2 voices. Interview = 2 voices. Default to solo narration unless the user specifies a format.

- **"How long should it be?"** — If not specified, default to ~10 minutes (~1400 words). News roundups default to 5 minutes. Deep dives default to 15 minutes.

- **"The script is too long for one TTS call"** — Split at sentence boundaries, generate chunks, concatenate. Never cut mid-sentence.

- **"User wants a web player"** — Mention that you can build a simple podcast player web app and deploy to rebyte.pro using `rebyte-app-builder`. Only do this if the user asks for it.
