# Slidev Advanced Features Reference

## Frontmatter Configuration

### Full Options

```yaml
---
# Theme & Appearance
theme: seriph
colorSchema: auto
background: https://cover.sli.dev
class: text-center

# Metadata
title: Presentation Title
titleTemplate: '%s - Slidev'
info: |
  ## Presentation Info
  Author: Your Name
  Date: 2024

# Code
highlighter: shiki
lineNumbers: true
monaco: true

# Features
drawings:
  enabled: true
  persist: false
  presenterOnly: false
  syncAll: true
mdc: true
transition: slide-left
record: true

# Fonts
fonts:
  sans: Inter
  serif: Playfair Display
  mono: Fira Code
  weights: '200,400,600,700'

# Export
download: true
exportFilename: presentation
export:
  format: pdf
  timeout: 30000
  dark: false

# Layout
aspectRatio: '16/9'
canvasWidth: 980
selectable: true
---
```

---

## Presenter Mode

### Accessing Presenter Mode

- Press `P` during presentation
- Or navigate to `/presenter` route

### Features

- Current slide preview
- Next slide preview
- Speaker notes
- Timer
- Drawing tools
- Slide navigation

### Speaker Notes

```markdown
# Slide Title

Content here

<!--
Speaker notes appear in presenter mode only.

Key points to mention:
- Point A
- Point B

[click] Reveal first item
[click] Reveal second item
-->
```

### Timer Commands in Notes

```markdown
<!--
[click] - Next click
[pause] - Pause for effect
1:30 - Timestamp marker
-->
```

---

## Drawing Mode

### Enabling

```yaml
---
drawings:
  enabled: true
  persist: true
  presenterOnly: false
  syncAll: true
---
```

### Using Drawings

- Press `D` to toggle drawing mode
- Draw with mouse/pen
- Colors and tools in toolbar
- `persist: true` saves drawings

### Options

| Option | Description |
|--------|-------------|
| `enabled` | Enable drawing feature |
| `persist` | Save drawings between sessions |
| `presenterOnly` | Only presenter can draw |
| `syncAll` | Sync drawings to all clients |

---

## Global Layers

Persistent Vue components across all slides. Perfect for headers, footers, page numbers, and watermarks.

### Layer Files

Create in project root:

| File | Purpose | Scope |
|------|---------|-------|
| `global-top.vue` | Top layer (above content) | All slides |
| `global-bottom.vue` | Bottom layer (below content) | All slides |
| `custom-nav-controls.vue` | Custom navigation buttons | All slides |
| `slide-top.vue` | Top of each slide | Per slide |
| `slide-bottom.vue` | Bottom of each slide | Per slide |

### Z-Index Order (top to bottom)

1. NavControls
2. Global Top
3. Slide Top
4. **Slide Content**
5. Slide Bottom
6. Global Bottom

### Example: Page Footer

```vue
<!-- global-bottom.vue -->
<template>
  <footer class="absolute bottom-4 left-4 right-4 flex justify-between text-sm opacity-50">
    <span>Company Name</span>
    <span>{{ $nav.currentPage }} / {{ $nav.total }}</span>
  </footer>
</template>
```

### Conditional Display

Hide on specific layouts:

```vue
<!-- global-bottom.vue -->
<template>
  <footer
    v-if="$nav.currentLayout !== 'cover' && $nav.currentLayout !== 'end'"
    class="absolute bottom-4 right-4 text-sm opacity-50"
  >
    Slide {{ $nav.currentPage }}
  </footer>
</template>
```

### Custom Navigation

```vue
<!-- custom-nav-controls.vue -->
<template>
  <div class="abs-br m-4 flex gap-2">
    <button @click="$nav.prev" class="icon-btn">
      <carbon-chevron-left />
    </button>
    <button @click="$nav.next" class="icon-btn">
      <carbon-chevron-right />
    </button>
  </div>
</template>
```

### Available Context Variables

```vue
<script setup>
// Available in global layer components
const { $nav, $slidev } = useSlideContext()

$nav.currentPage     // Current slide number
$nav.total           // Total slides
$nav.currentLayout   // Current layout name
$nav.clicks          // Current click count
</script>
```

### When to Use Global Layers

| Use Case | Layer |
|----------|-------|
| Company logo | `global-top.vue` |
| Page numbers | `global-bottom.vue` |
| Progress bar | `global-bottom.vue` |
| Custom navigation | `custom-nav-controls.vue` |
| Watermark | `global-bottom.vue` |

---

## Recording

### Enabling Recording

```yaml
---
record: true
---
```

Or use CLI:
```bash
slidev --record
```

### Recording Features

- Webcam overlay
- Screen recording
- Export to video

### Recording Controls

Press recording button in toolbar or use keyboard shortcuts.

---

## Export Options

### PDF Export

```bash
# Basic PDF
slidev export

# With options
slidev export --output slides.pdf
slidev export --dark
slidev export --timeout 60000
```

### PPTX Export

```bash
slidev export --format pptx
```

Note: PPTX exports slides as images, not editable.

### PNG Export

```bash
slidev export --format png --output ./slides
```

Creates one PNG per slide.

### Export Frontmatter

```yaml
---
download: true
exportFilename: my-presentation
export:
  format: pdf
  timeout: 30000
  dark: false
  withClicks: false
  withToc: false
---
```

### Export with Clicks

```bash
slidev export --with-clicks
```

Creates separate page for each click state.

---

## Code Features

### Shiki Highlighter

Default highlighter with many themes:

```yaml
---
highlighter: shiki
---
```

### Prism Alternative

```yaml
---
highlighter: prism
---
```

### Line Numbers

```yaml
---
lineNumbers: true
---
```

Or per block:

````markdown
```ts {lines:true}
const a = 1
const b = 2
```
````

### Monaco Editor

Interactive code editor:

````markdown
```ts {monaco}
// Editable code
function hello() {
  console.log("Hello!")
}
```
````

### Monaco Runner

Execute TypeScript/JavaScript:

````markdown
```ts {monaco-run}
const result = [1, 2, 3].map(x => x * 2)
console.log(result)
```
````

### Monaco Diff

Show code differences:

````markdown
```ts {monaco-diff}
const original = "hello"
~~~
const modified = "hello world"
```
````

### Twoslash Integration

TypeScript hover information:

````markdown
```ts twoslash
const greeting = "Hello"
//    ^?
```
````

---

## Multi-Entry Files

### Splitting Slides

Reference external markdown files:

```markdown
---
src: ./pages/intro.md
---

---
src: ./pages/content.md
---

---
src: ./pages/conclusion.md
---
```

### File Structure

```
slides.md          # Main entry
pages/
├── intro.md       # Introduction slides
├── content.md     # Main content
└── conclusion.md  # Conclusion
```

Each file can have its own frontmatter.

---

## Navigation

### Slide IDs

```markdown
---
id: my-slide
---

# Slide with ID

<Link to="my-slide">Back to this slide</Link>
```

### Slide Routing

- `/1` - First slide
- `/2` - Second slide
- `/#my-slide` - Slide by ID

### Hidden Slides

```markdown
---
hide: true
---

# This slide is hidden

Only visible in edit mode, skipped in presentation.
```

### Disabled Slides

```markdown
---
disabled: true
---

# Disabled slide

Completely excluded from build.
```

---

## Aspect Ratio

### Configuration

```yaml
---
aspectRatio: '16/9'
canvasWidth: 980
---
```

Common ratios:
- `16/9` - Widescreen (default)
- `4/3` - Traditional
- `1/1` - Square

### Custom Size

```yaml
---
canvasWidth: 1200
aspectRatio: '16/10'
---
```

---

## Remote Control

### Enabling

Access from other devices:

```bash
slidev --remote
```

### QR Code

Shows QR code for mobile access.

### Broadcast Mode

Sync slides across all connected clients.

---

## Configuration Files

### vite.config.ts

```typescript
import { defineConfig } from 'vite'

export default defineConfig({
  slidev: {
    vue: {
      // Vue options
    },
  },
})
```

### setup/main.ts

Global setup code:

```typescript
// setup/main.ts
import { defineAppSetup } from '@slidev/types'

export default defineAppSetup(({ app, router }) => {
  // Vue app configuration
  app.use(MyPlugin)
})
```

### setup/shiki.ts

Custom Shiki configuration:

```typescript
// setup/shiki.ts
import { defineShikiSetup } from '@slidev/types'

export default defineShikiSetup(() => {
  return {
    themes: {
      dark: 'github-dark',
      light: 'github-light',
    },
  }
})
```

---

## CLI Commands

### Development

```bash
slidev                    # Start dev server
slidev --open             # Open browser
slidev --port 3030        # Custom port
slidev --remote           # Enable remote access
slidev slides.md          # Specific file
```

### Build

```bash
slidev build              # Build for production
slidev build --base /path # Custom base path
slidev build --out dist   # Output directory
```

### Export

```bash
slidev export             # Export PDF
slidev export --dark      # Dark mode
slidev export --format pptx
slidev export --with-clicks
slidev export --timeout 60000
```

---

## Keyboard Shortcuts

### Presentation Mode

| Key | Action |
|-----|--------|
| `Space` / `→` / `↓` | Next |
| `←` / `↑` | Previous |
| `End` | Last slide |
| `Home` | First slide |
| `P` | Presenter mode |
| `O` | Slides overview |
| `D` | Toggle dark mode |
| `F` | Fullscreen |
| `G` | Go to slide |
| `Esc` | Exit mode |

### Drawing Mode

| Key | Action |
|-----|--------|
| `D` | Toggle drawing |
| `C` | Clear drawings |

### Editor

| Key | Action |
|-----|--------|
| `E` | Toggle editor |

---

## Global Context

### useSlideContext

Access slide data in Vue components:

```vue
<script setup>
import { useSlideContext } from '@slidev/client'

const { $slidev } = useSlideContext()
// $slidev.nav - navigation
// $slidev.configs - configurations
</script>
```

### Navigation API

```typescript
$slidev.nav.currentPage        // Current slide number
$slidev.nav.total              // Total slides
$slidev.nav.next()             // Go to next
$slidev.nav.prev()             // Go to previous
$slidev.nav.go(5)              // Go to slide 5
$slidev.nav.clicks             // Current click count
$slidev.nav.totalClicks        // Total clicks on slide
```

---

## Plugins & Addons

### Using Addons

```yaml
---
addons:
  - slidev-addon-python-runner
---
```

### Common Addons

- `slidev-addon-python-runner` - Run Python code
- `slidev-addon-citations` - Academic citations
- `slidev-addon-excalidraw` - Excalidraw drawings

Install via npm:

```bash
pnpm add slidev-addon-python-runner
```
