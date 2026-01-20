# Slidev Layouts Reference

## Using Layouts

Specify layout in slide frontmatter:

```markdown
---
layout: center
class: text-center
---

# Content
```

---

## Built-in Layouts

### default

Standard content layout with left-aligned text.

```markdown
---
layout: default
---

# Title

Regular content with bullet points:
- Point 1
- Point 2
```

### center

Centers all content vertically and horizontally.

```markdown
---
layout: center
class: text-center
---

# Centered Title

This content is centered
```

### cover

Title slide with full background support. Use for opening slides.

```markdown
---
layout: cover
background: https://cover.sli.dev
class: text-center
---

# Presentation Title
## Subtitle

Author Name
```

Background options:
```yaml
background: https://example.com/image.jpg    # URL
background: /images/local.jpg                # Local (in public/)
background: '#1a1a2e'                        # Solid color
background: linear-gradient(45deg, #f00, #00f)  # Gradient
```

### intro

Speaker or topic introduction with side-by-side layout.

```markdown
---
layout: intro
class: pl-20
---

# John Doe

<div class="leading-8 opacity-80">
Senior Developer at Company<br>
Open source contributor<br>
twitter.com/johndoe
</div>

<div class="my-10 grid grid-cols-[40px_1fr] w-min gap-y-4">
  <ri-github-line class="opacity-50"/>
  <div><a href="https://github.com/johndoe" target="_blank">johndoe</a></div>
  <ri-twitter-line class="opacity-50"/>
  <div><a href="https://twitter.com/johndoe" target="_blank">johndoe</a></div>
</div>
```

### section

Section divider with prominent heading.

```markdown
---
layout: section
---

# Part 2
## Advanced Topics
```

### statement

Bold statement layout for key messages.

```markdown
---
layout: statement
---

# Code is poetry
```

### quote

Quote with attribution styling.

```markdown
---
layout: quote
---

# "The best way to predict the future is to invent it."

Alan Kay
```

### fact

Large number or metric display.

```markdown
---
layout: fact
---

# 42%
Performance Improvement

<div class="text-sm opacity-50 mt-4">
Measured over 30 days in production
</div>
```

### end

Closing slide.

```markdown
---
layout: end
---

# Thank You!

Slides: example.com/slides
GitHub: github.com/example
```

---

## Two-Column Layouts

### two-cols

Equal two-column layout.

```markdown
---
layout: two-cols
layoutClass: gap-16
---

# Left Column

- Point A
- Point B
- Point C

::right::

# Right Column

- Point 1
- Point 2
- Point 3
```

### two-cols-header

Two columns with shared header.

```markdown
---
layout: two-cols-header
---

# Comparison: Before vs After

::left::

## Before

- Slow performance
- Manual process
- Error prone

::right::

## After

- 10x faster
- Automated
- Reliable
```

---

## Image Layouts

### image

Full-screen background image with optional text overlay.

```markdown
---
layout: image
image: https://example.com/photo.jpg
class: text-center
---

# Text Over Image

<div class="abs-br m-6 text-xl">
Photo credit: Unsplash
</div>
```

### image-right

Image on right, content on left (60/40 split).

```markdown
---
layout: image-right
image: https://example.com/screenshot.png
---

# Feature Name

Description of the feature with key points:

- Benefit one
- Benefit two
- Benefit three

```typescript
const demo = "code here"
```
```

### image-left

Image on left, content on right.

```markdown
---
layout: image-left
image: https://example.com/diagram.png
---

# Architecture

The system consists of:

1. Frontend (React)
2. Backend (Node.js)
3. Database (PostgreSQL)
```

---

## Iframe Layouts

### iframe

Full-screen embedded iframe.

```markdown
---
layout: iframe
url: https://sli.dev
---
```

### iframe-right

Iframe on right, content on left.

```markdown
---
layout: iframe-right
url: https://stackblitz.com/edit/example
---

# Live Demo

Try editing the code on the right.

Key points:
- Real-time preview
- Full IDE features
- Shareable
```

### iframe-left

Iframe on left, content on right.

```markdown
---
layout: iframe-left
url: https://example.com
---

# Description

Explanation of the embedded content.
```

---

## Layout Properties

### Common Properties

| Property | Type | Description |
|----------|------|-------------|
| `class` | string | CSS/UnoCSS classes |
| `layoutClass` | string | Classes for layout container |
| `background` | string | Background image/color |
| `image` | string | Image URL (image layouts) |
| `url` | string | Iframe URL (iframe layouts) |

### Example with Multiple Properties

```markdown
---
layout: image-right
image: /images/feature.png
class: my-slide
layoutClass: gap-8
---
```

---

## Custom Layouts

Create custom layouts in `layouts/` directory:

```vue
<!-- layouts/my-layout.vue -->
<template>
  <div class="slidev-layout my-layout">
    <slot />
  </div>
</template>

<style>
.my-layout {
  display: flex;
  flex-direction: column;
  padding: 2rem;
}
</style>
```

Use it:

```markdown
---
layout: my-layout
---

# Custom Layout Content
```

---

## Layout Selection Guide

| Purpose | Layout | When to Use |
|---------|--------|-------------|
| Opening | `cover` | First slide, section starts |
| Speaker bio | `intro` | About me slides |
| Section break | `section` | Dividing presentation parts |
| Regular content | `default` | Most slides |
| Emphasize message | `center` | Quotes, transitions |
| Side-by-side | `two-cols` | Comparisons, pros/cons |
| Feature + visual | `image-right` | Screenshots, demos |
| Statistics | `fact` | Key metrics, numbers |
| Citations | `quote` | Quotes from others |
| Key statement | `statement` | Important messages |
| Live demo | `iframe-right` | Interactive examples |
| Closing | `end` | Final slide |
