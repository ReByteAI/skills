# Slidev Configuration Reference

**CRITICAL: Only use options listed in this file. Do NOT invent or guess frontmatter options.**

Invalid frontmatter options will cause slide rendering errors.

---

## Deck Configuration (First Slide Only)

The first slide's frontmatter configures the entire presentation.

### Essential Options

```yaml
---
theme: seriph                    # Theme name (required for non-default)
title: My Presentation           # Deck title
transition: slide-left           # Global transition
---
```

### All Valid Deck Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `theme` | string | `"default"` | Theme ID or package name |
| `title` | string | `"Slidev"` | Presentation title |
| `titleTemplate` | string | `"%s - Slidev"` | Title template (`%s` = slide title) |
| `author` | string | - | Author for PDF/PPTX exports |
| `keywords` | string | - | Comma-delimited keywords for PDF |
| `info` | string | - | Markdown description |

### Display Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `aspectRatio` | string | `"16/9"` | Slide aspect ratio |
| `canvasWidth` | number | `980` | Canvas width in pixels |
| `colorSchema` | string | `"auto"` | `"auto"`, `"light"`, or `"dark"` |
| `background` | string | - | Default background (image URL or color) |
| `class` | string | - | Default CSS class for slides |
| `transition` | string | - | Global slide transition |
| `highlighter` | string | `"shiki"` | Code highlighter (`"shiki"` or `"prism"`) |
| `lineNumbers` | boolean | `false` | Show line numbers in code blocks |

### Feature Toggles

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `download` | boolean | `false` | Enable PDF download in SPA |
| `exportFilename` | string | `"slidev-exported"` | Export filename |
| `selectable` | boolean | `false` | Allow text selection |
| `record` | boolean/string | `"dev"` | Enable recording |
| `presenter` | boolean/string | `true` | Enable presenter mode |
| `drawings` | object | - | Drawing configuration |
| `wakeLock` | boolean/string | `true` | Prevent screen sleep |
| `contextMenu` | boolean/string | `true` | Enable right-click menu |
| `mdc` | boolean | `false` | Enable MDC (Markdown Components) syntax |

### Font Configuration

```yaml
---
fonts:
  sans: Robot
  serif: Robot Slab
  mono: Fira Code
---
```

### Drawings Configuration

```yaml
---
drawings:
  enabled: true
  persist: false
  presenterOnly: false
  syncAll: true
---
```

### Theme Configuration

```yaml
---
themeConfig:
  primary: '#5d8392'
---
```

---

## Per-Slide Configuration

Each slide can have its own frontmatter.

### All Valid Slide Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `layout` | string | `"default"` | Slide layout |
| `class` | string | - | Additional CSS classes |
| `transition` | string | - | Override transition for this slide |
| `background` | string | - | Background image URL or color |
| `clicks` | number | auto | Total click count for slide |
| `clicksStart` | number | `0` | Starting click number |
| `disabled` | boolean | `false` | Hide slide completely |
| `hide` | boolean | `false` | Same as `disabled` |
| `hideInToc` | boolean | `false` | Hide from table of contents |
| `level` | number | - | Override title level (1-5) |
| `title` | string | - | Override slide title |
| `preload` | boolean | `true` | Preload slide before entering |
| `zoom` | number | `1` | Zoom scale (e.g., `0.8` for dense content) |
| `dragPos` | object | - | Draggable element positions |

### Layout-Specific Options

Some layouts accept additional options:

**`image-right` / `image-left` / `image`:**
```yaml
---
layout: image-right
image: https://example.com/image.png
backgroundSize: contain    # or 'cover'
---
```

**`two-cols` / `two-cols-header`:**
```yaml
---
layout: two-cols
layoutClass: gap-16       # UnoCSS class for gap
---
```

**`iframe` / `iframe-right` / `iframe-left`:**
```yaml
---
layout: iframe
url: https://example.com
---
```

**`quote`:**
```yaml
---
layout: quote
---
```

**`fact`:**
```yaml
---
layout: fact
---
```

---

## Valid Transitions

**Only use these transition values:**

| Transition | Description |
|------------|-------------|
| `fade` | Crossfade |
| `fade-out` | Fade out then fade in |
| `slide-left` | Slide left (recommended) |
| `slide-right` | Slide right |
| `slide-up` | Slide up |
| `slide-down` | Slide down |
| `view-transition` | View Transitions API |

### Transition Syntax

```yaml
# Global (first slide)
---
transition: slide-left
---

# Per-slide override
---
transition: fade
---

# Directional (forward | backward)
---
transition: slide-left | slide-right
---
```

---

## Common Mistakes to Avoid

### ❌ Invalid Options (Will Cause Errors)

```yaml
# These options DO NOT EXIST - never use them:
---
animation: fade           # ❌ Use 'transition' instead
animate: true             # ❌ Not a valid option
style: dark               # ❌ Use 'colorSchema' or 'class'
highlight: true           # ❌ Use 'highlighter: shiki'
code: true                # ❌ Not a valid option
footer: "text"            # ❌ Not built-in (use HTML in slides)
header: "text"            # ❌ Not built-in (use HTML in slides)
showSlideNumber: true     # ❌ Not a valid option
pageNumber: true          # ❌ Not a valid option
---
```

### ✅ Correct Usage

```yaml
# First slide (deck config)
---
theme: seriph
title: My Talk
transition: slide-left
highlighter: shiki
mdc: true
---

# Content slide
---
layout: two-cols
class: text-center
---

# Image slide
---
layout: image-right
image: https://example.com/photo.jpg
---
```

---

## Minimal Recommended Setup

For most presentations, use this first slide frontmatter:

```yaml
---
theme: seriph
title: Your Title
background: https://cover.sli.dev
class: text-center
transition: slide-left
mdc: true
---
```

Then for content slides, only add frontmatter when needed:

```yaml
---
layout: two-cols
---
```

**Rule: If in doubt, omit the option.** Slidev has sensible defaults.
