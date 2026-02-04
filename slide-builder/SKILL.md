---
name: slide-builder
description: Create presentations using Slidev (Markdown-based slides). Triggers include "create presentation", "make slides", "build slides", "slide deck", "tech talk", "conference slides", "pitch deck". Handles the full workflow from content planning to deployment at rebyte.pro.
---

# Slide Builder

Create Markdown presentations with Slidev. Deploy to rebyte.pro.

**Directory structure:**
- `SKILL_DIR`: The directory containing this SKILL.md (scripts, references, etc.)
- Working directory: `/code/` (where presentation projects are created)

## Workflow

### 1. Plan (Intention Collection)

Understand the presentation before writing:
- **Goal**: What should the audience learn or do?
- **Audience**: Technical level, context, expectations
- **Structure**: How many slides? What sections?
- **Tone**: Formal, casual, technical, inspirational?

If any of these are unclear, ask the user. This step is optional if the user's request is already detailed.

### 2. Pick a Theme

Initialize the project with a theme:

```bash
bash $SKILL_DIR/scripts/init.sh <name> [theme]
```

This creates `/code/<name>/` with the Slidev project.

**Theme selection**: See `references/themes.md` for the full list. Default is `seriph` (elegant serif, good for most use cases).

Quick picks:
- Conference/keynote → `seriph`
- Developer audience → `dracula`
- Product launch → `apple-basic`
- Academic → `academic`

### 3. Write Slides

Edit `/code/<name>/slides.md`. Focus on content first:

- One idea per slide
- Write speaker notes as you go
- Use simple layouts initially
- **Save animations for later** - get content approved first

**Content rules:**
- 6 words per bullet, 6 bullets max
- No walls of text
- Prefer diagrams/code/images over prose

**Structure:**
- Opening (1-2 slides): Hook + agenda
- Body (80%): Main content in logical sections
- Closing (1-2 slides): Summary + call-to-action

### 4. Preview

Export slides as PNG thumbnails for user review:

```bash
cd /code/<name> && pnpm exec slidev export --format png --output ./preview
```

This creates `./preview/001.png`, `002.png`, etc. Show these images to the user.

### 5. Iterate

User reviews the preview thumbnails and provides feedback:
- "Page 3: change the title"
- "Add more detail to page 5"
- "Remove page 7"

Edit the specified slides (slides separated by `---`, Page N = after (N-1)th separator), then re-export previews. Repeat until user approves.

### 6. Deploy

Once user is happy with the preview:

```bash
cd /code/<name> && pnpm build
```

Then **invoke the `rebyte-app-builder` skill** to deploy the `dist/` folder.

### 7. Polish (Optional)

After deployment, enhance selectively if requested:
- Add click animations where they aid understanding
- Sync presenter notes with `[click]` markers
- Max 5-6 clicks per slide

## Agent Rules

- Ask only when blocked - don't over-clarify
- One slide at a time - never batch edit
- Prefer MDI icons over emoji (see `references/icons.md`)
- Never invent frontmatter options (see `references/core-frontmatter.md`)

## Core References

| File | Description |
|------|-------------|
| `core-syntax.md` | Basic Slidev syntax |
| `core-frontmatter.md` | Global config options |
| `core-headmatter.md` | Per-slide frontmatter |
| `core-layouts.md` | Built-in layouts |
| `core-animations.md` | Click animations (v-click) |
| `core-components.md` | Built-in components |
| `core-cli.md` | CLI commands |
| `core-exporting.md` | Export to PDF/PPTX |
| `core-hosting.md` | Hosting options |
| `core-global-context.md` | Global Vue context |

## Code & Editor

| File | Description |
|------|-------------|
| `code-line-highlighting.md` | Highlight code lines |
| `code-line-numbers.md` | Show line numbers |
| `code-magic-move.md` | Animate code changes |
| `code-groups.md` | Tabbed code groups |
| `code-import-snippet.md` | Import code from files |
| `code-max-height.md` | Scrollable code blocks |
| `code-twoslash.md` | TypeScript annotations |
| `editor-monaco.md` | Monaco editor in slides |
| `editor-monaco-run.md` | Run code in slides |
| `editor-monaco-write.md` | Editable code blocks |
| `editor-side.md` | Side editor panel |

## Diagrams & Math

| File | Description |
|------|-------------|
| `diagram-mermaid.md` | Mermaid diagrams |
| `diagram-plantuml.md` | PlantUML diagrams |
| `diagram-latex.md` | LaTeX math formulas |

## Layout & Styling

| File | Description |
|------|-------------|
| `layout-slots.md` | Named slots in layouts |
| `layout-canvas-size.md` | Custom canvas size |
| `layout-transform.md` | Scale/transform content |
| `layout-zoom.md` | Zoom into content |
| `layout-draggable.md` | Draggable elements |
| `layout-global-layers.md` | Global layers |
| `style-scoped.md` | Scoped CSS per slide |
| `style-direction.md` | RTL text direction |
| `style-icons.md` | Using icons |

## Animation & Interaction

| File | Description |
|------|-------------|
| `animation-click-marker.md` | Click markers |
| `animation-drawing.md` | Drawing animations |
| `animation-rough-marker.md` | Hand-drawn markers |
| `api-slide-hooks.md` | Slide lifecycle hooks |

## Syntax Extensions

| File | Description |
|------|-------------|
| `syntax-mdc.md` | MDC syntax support |
| `syntax-block-frontmatter.md` | Block frontmatter |
| `syntax-frontmatter-merging.md` | Frontmatter inheritance |
| `syntax-importing-slides.md` | Import external slides |

## Presenter & Recording

| File | Description |
|------|-------------|
| `presenter-timer.md` | Presentation timer |
| `presenter-recording.md` | Record presentations |
| `presenter-remote.md` | Remote control |
| `presenter-notes-ruby.md` | Ruby annotations in notes |

## Build & Export

| File | Description |
|------|-------------|
| `build-pdf.md` | Export to PDF |
| `build-og-image.md` | OG images for sharing |
| `build-seo-meta.md` | SEO meta tags |
| `build-remote-assets.md` | Remote asset handling |
| `tool-eject-theme.md` | Eject theme for customization |

## Our Extensions

| File | Description |
|------|-------------|
| `themes.md` | Theme selection guide (17 themes) |
| `icons.md` | When to use icons vs emoji |
| `example-professional.md` | Complete 15-slide example |

## Common Layouts

| Content Type | Layout | When |
|--------------|--------|------|
| Title/section | `cover` | Opening, section breaks |
| Regular content | `default` | Most slides |
| Comparison | `two-cols` | A vs B, before/after |
| Feature + visual | `image-right` | Screenshots, diagrams |
| Key metric | `fact` | Statistics, numbers |
| Quote | `quote` | Citations, testimonials |
| Closing | `end` | Final slide |

## Troubleshooting

### Overflow Issues

Slidev does NOT auto-fit content. If text/tables/code are getting clipped, see `references/overflow.md` for:
- How to run the overflow checker
- Fix strategies (split slides, use `<Transform :scale="0.8">`)

## Resources

- [Slidev Docs](https://sli.dev)
- [Icon Browser](https://icones.js.org/)
