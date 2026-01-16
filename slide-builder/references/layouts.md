# Slidev Layouts Reference

## Using Layouts

Specify layout in slide frontmatter:

```markdown
---
layout: center
---

# Centered Content
```

## Built-in Layouts

### default

Standard content layout with left-aligned text.

```markdown
---
layout: default
---

# Title

Regular content goes here.
```

**Best for:** General content slides

---

### center

Centers all content vertically and horizontally.

```markdown
---
layout: center
class: text-center
---

# Centered Title

Centered content
```

**Best for:** Quotes, statements, transitions

---

### cover

Title slide with background support.

```markdown
---
layout: cover
background: https://cover.sli.dev
---

# Presentation Title

Subtitle
```

**Best for:** Opening slides, section covers

---

### intro

Speaker or topic introduction.

```markdown
---
layout: intro
---

# John Doe

<div class="leading-8 opacity-80">
Senior Developer at Company<br>
Open source enthusiast<br>
</div>
```

**Best for:** Speaker introductions

---

### section

Section divider with prominent heading.

```markdown
---
layout: section
---

# Part 2
## Advanced Topics
```

**Best for:** Dividing presentation into parts

---

### two-cols

Two-column layout.

```markdown
---
layout: two-cols
---

# Left Side

Content here

::right::

# Right Side

More content
```

**Best for:** Comparisons, parallel content

---

### two-cols-header

Two columns with a shared header.

```markdown
---
layout: two-cols-header
---

# Comparison

::left::

## Option A
- Feature 1
- Feature 2

::right::

## Option B
- Feature 1
- Feature 2
```

**Best for:** Structured comparisons

---

### image-right

Image on right, content on left.

```markdown
---
layout: image-right
image: https://example.com/image.jpg
---

# Feature Name

Description of the feature.

- Point one
- Point two
```

**Best for:** Feature highlights with visuals

---

### image-left

Image on left, content on right.

```markdown
---
layout: image-left
image: https://example.com/image.jpg
---

# Feature Name

Description here.
```

**Best for:** Alternative feature layout

---

### image

Full-screen background image.

```markdown
---
layout: image
image: https://example.com/image.jpg
---

# Text Over Image
```

**Best for:** Visual impact slides

---

### iframe

Embeds an iframe.

```markdown
---
layout: iframe
url: https://example.com
---
```

**Best for:** Live demos, embedded content

---

### iframe-right

Content on left, iframe on right.

```markdown
---
layout: iframe-right
url: https://example.com
---

# Live Demo

Check out this example.
```

**Best for:** Explaining while showing demo

---

### iframe-left

Iframe on left, content on right.

```markdown
---
layout: iframe-left
url: https://example.com
---

# Description

Explanation here.
```

---

### fact

Large number or fact display.

```markdown
---
layout: fact
---

# 42%
Performance Improvement
```

**Best for:** Statistics, key metrics

---

### statement

Bold statement layout.

```markdown
---
layout: statement
---

# Innovation Requires Courage
```

**Best for:** Key messages, memorable phrases

---

### quote

Quote with attribution.

```markdown
---
layout: quote
---

# "The best way to predict the future is to invent it."

Alan Kay
```

**Best for:** Citations, inspirational quotes

---

### end

Closing slide.

```markdown
---
layout: end
---

# Thank You!

Questions?
```

**Best for:** Final slide

---

## Layout Properties

### Common Properties

| Property | Type | Description |
|----------|------|-------------|
| `class` | string | CSS classes to apply |
| `background` | string | Background image/color |
| `image` | string | Image URL (for image layouts) |
| `url` | string | Iframe URL (for iframe layouts) |

### Example with Properties

```markdown
---
layout: image-right
image: /images/feature.png
class: my-cool-slide
---
```

## Custom CSS Classes

Add custom styling per slide:

```markdown
---
layout: default
class: text-center bg-blue-500
---
```

## Slot Syntax

Some layouts support named slots:

```markdown
---
layout: two-cols
---

Default slot content (left)

::right::

Right slot content
```

### Available Slots by Layout

| Layout | Slots |
|--------|-------|
| `two-cols` | default (left), `::right::` |
| `two-cols-header` | default (header), `::left::`, `::right::` |

## Layout Selection Guide

| Purpose | Recommended Layout |
|---------|-------------------|
| Opening | `cover` |
| Speaker intro | `intro` |
| Section break | `section` |
| Regular content | `default` |
| Side-by-side | `two-cols` |
| Image + text | `image-right` or `image-left` |
| Statistics | `fact` |
| Quote | `quote` |
| Live demo | `iframe` or `iframe-right` |
| Key message | `statement` |
| Closing | `end` |

## Example Presentation Structure

```markdown
---
layout: cover
background: https://cover.sli.dev
---
# Talk Title

---
layout: intro
---
# About Me
...

---
layout: section
---
# Part 1

---
layout: default
---
# Topic 1
...

---
layout: two-cols
---
# Comparison
...

---
layout: fact
---
# 100%
Success Rate

---
layout: quote
---
# "Great quote"
Author

---
layout: end
---
# Thank You!
```
