# Slidev Configuration Reference

**CRITICAL: Only use options listed here. Invalid frontmatter causes rendering errors.**

---

## Deck Configuration (First Slide Only)

```yaml
---
# Theme ID or package name
theme: seriph

# Presentation title (used in browser tab)
title: My Presentation

# Title template for browser tab (%s = slide title)
titleTemplate: '%s - Slidev'

# Author for PDF/PPTX exports
author: undefined # or string

# Keywords for exported PDFs (comma-delimited)
keywords: undefined # or string

# Markdown description for info dialog
info: undefined # or string

# Slide aspect ratio
aspectRatio: 16/9

# Canvas width in pixels
canvasWidth: 980

# Force color scheme
colorSchema: auto # or 'light' or 'dark'

# Default background (image URL or color)
background: undefined # or string

# Default CSS class for all slides
class: undefined # or string

# Global slide transition
# Valid: fade, fade-out, slide-left, slide-right, slide-up, slide-down, view-transition
transition: undefined # or string

# Code highlighter
highlighter: shiki # or 'prism'

# Show line numbers in code blocks
lineNumbers: false

# Enable MDC (Markdown Components) syntax
mdc: false

# Enable PDF download in SPA builds
download: false

# Export filename (without extension)
exportFilename: slidev-exported

# Allow text selection in slides
selectable: false

# Enable slide recording
record: dev # or true or false or 'build'

# Enable presenter mode
presenter: true # or false or 'dev' or 'build'

# Prevent screen sleep during presentation
wakeLock: true # or false or 'dev' or 'build'

# Enable right-click context menu
contextMenu: true # or false or 'dev' or 'build'

# Google Fonts configuration
fonts:
  sans: Roboto
  serif: Roboto Slab
  mono: Fira Code

# Drawing/annotation options
drawings:
  enabled: true
  persist: false
  presenterOnly: false
  syncAll: true

# Theme-specific customization
themeConfig:
  primary: '#5d8392'
---
```

---

## Per-Slide Configuration

```yaml
---
# Layout component for this slide
# Valid: default, cover, center, two-cols, two-cols-header, image, image-right, image-left, iframe, iframe-right, iframe-left, quote, fact, end, section, statement, intro
layout: default # 'cover' if first slide

# Additional CSS classes
class: undefined # or string

# Background image URL or color
background: undefined # or string

# Override transition for this slide
transition: undefined # or string

# Custom total click count for animations
clicks: auto # or number

# Custom starting click number
clicksStart: 0

# Completely hide this slide
disabled: false
hide: false # same as disabled

# Hide from table of contents
hideInToc: false

# Override title level (1-5)
level: 1

# Override slide title for <Toc>
title: undefined # or string

# Preload slide before entering
preload: true

# URL route alias for this slide
routeAlias: undefined # or string

# Include content from another markdown file
src: undefined # or string

# Custom zoom scale (useful for dense content)
zoom: 1

# Draggable element positions
dragPos: {} # Record<string, string>
---
```

### Layout-Specific Options

```yaml
# For image layouts (image, image-right, image-left)
---
layout: image-right
image: https://example.com/photo.jpg
backgroundSize: cover # or 'contain'
---

# For two-cols layouts
---
layout: two-cols
layoutClass: gap-16 # UnoCSS class
---

# For iframe layouts
---
layout: iframe
url: https://example.com
---
```

---

## Valid Transitions

```yaml
transition: fade          # Crossfade
transition: fade-out      # Fade out then in
transition: slide-left    # Slide left (recommended)
transition: slide-right   # Slide right
transition: slide-up      # Slide up
transition: slide-down    # Slide down
transition: view-transition # View Transitions API

# Directional (forward | backward)
transition: slide-left | slide-right
```

---

## Common Mistakes (AVOID THESE)

```yaml
# ❌ These options DO NOT EXIST:
animation: fade           # Use 'transition'
animate: true             # Not valid
style: dark               # Use 'colorSchema' or 'class'
highlight: true           # Use 'highlighter: shiki'
code: true                # Not valid
footer: "text"            # Not built-in
header: "text"            # Not built-in
showSlideNumber: true     # Not valid
pageNumber: true          # Not valid
theme: "dark"             # theme is a theme name, not color scheme
```

---

## Minimal Setup

Most presentations only need:

```yaml
# First slide
---
theme: seriph
title: Your Title
transition: slide-left
---

# Content slides (only add when needed)
---
layout: two-cols
---
```

**Rule: When in doubt, omit the option. Slidev has sensible defaults.**
