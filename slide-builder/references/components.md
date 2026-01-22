# Slidev Components Reference

## Built-in Components

### Arrow

Draw arrows on slides:

```markdown
<Arrow x1="100" y1="200" x2="300" y2="400" />

<Arrow x1="100" y1="200" x2="300" y2="400" color="red" width="3" />
```

Properties:
| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `x1` | number | - | Start X position |
| `y1` | number | - | Start Y position |
| `x2` | number | - | End X position |
| `y2` | number | - | End Y position |
| `color` | string | `currentColor` | Arrow color |
| `width` | number | `2` | Line width |
| `two-way` | boolean | `false` | Two-headed arrow |

### AutoFitText

Automatically resize text to fit container:

```markdown
<AutoFitText :max="200" :min="50" modelValue="Long text here" />
```

### LightOrDark

Conditional content based on theme:

```markdown
<LightOrDark>
  <template #dark>Dark mode content</template>
  <template #light>Light mode content</template>
</LightOrDark>
```

### Link

Navigation links between slides:

```markdown
<Link to="5">Go to slide 5</Link>
<Link to="features">Go to slide with id="features"</Link>
```

### RenderWhen

Conditional rendering based on context:

```markdown
<RenderWhen context="slide">
  Only visible in slide view
</RenderWhen>

<RenderWhen context="presenter">
  Only visible in presenter view
</RenderWhen>

<RenderWhen context="print">
  Only visible when printing
</RenderWhen>
```

Contexts: `slide`, `presenter`, `overview`, `print`, `click-marker`

### SlidevVideo

Video player with Slidev integration:

```markdown
<SlidevVideo v-click autoplay controls>
  <source src="/video.mp4" type="video/mp4" />
</SlidevVideo>
```

Properties:
| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `autoplay` | boolean | `false` | Auto-play when visible |
| `controls` | boolean | `false` | Show video controls |
| `loop` | boolean | `false` | Loop video |
| `muted` | boolean | `false` | Mute audio |
| `timestamp` | string | - | Start time (e.g., "1:30") |

Advanced usage with clicks:

```markdown
<SlidevVideo
  v-click="[2, 5]"
  autoplay
  :at="2"
  :pause-at="5"
>
  <source src="/demo.mp4" type="video/mp4" />
</SlidevVideo>
```

### Toc

Table of contents:

```markdown
<Toc />

<!-- With options -->
<Toc minDepth="1" maxDepth="2" />
```

### Transform

Apply CSS transforms:

```markdown
<Transform :scale="1.5">
  Scaled up content
</Transform>

<Transform :scale="0.8" :rotate="10">
  Scaled and rotated
</Transform>
```

### v-drag (Draggable Elements)

Make elements draggable during presentation. Perfect for interactive demos.

#### Basic Usage with Frontmatter

```markdown
---
dragPos:
  box: 100,100,200,150,0
---

<img v-drag="'box'" src="/image.png" />
```

Position format: `Left, Top, Width, Height, Rotate`

#### Component Syntax

```markdown
---
dragPos:
  demo: 50,200,300,_,0
---

<v-drag pos="demo" class="text-xl bg-blue-100 p-4 rounded">
  Drag me around!
</v-drag>
```

Use `_` for auto height.

#### Inline Position

```markdown
<v-drag pos="100,100,200,150,0">
  Positioned element
</v-drag>
```

#### v-drag-arrow

Draggable arrow pointing:

```markdown
---
dragPos:
  arrow1: 100,100,200,200,0
---

<v-drag-arrow pos="arrow1" color="red" />
```

#### Controls

- **Double-click** to start dragging
- **Arrow keys** to nudge position
- **Shift + drag** to preserve aspect ratio
- **Click outside** to stop dragging

#### When to Use

| Scenario | Example |
|----------|---------|
| Architecture diagrams | Drag boxes to show data flow |
| Before/after | Drag elements to compare |
| Interactive teaching | Let audience rearrange |

### Tweet

Embed tweets:

```markdown
<Tweet id="1423674302035849218" />
```

### YouTube

Embed YouTube videos:

```markdown
<YouTube id="dQw4w9WgXcQ" />

<YouTube id="dQw4w9WgXcQ" width="560" height="315" />
```

---

## Icons (Iconify)

**IMPORTANT: Always use Slidev icons instead of Unicode emoji.**

The project includes `@iconify-json/mdi` (Material Design) and `@iconify-json/logos` (brand logos).

### MDI Icons (General Purpose)

```markdown
<!-- Common actions -->
<mdi-check />              <!-- ✓ checkmark -->
<mdi-close />              <!-- ✗ close -->
<mdi-plus />               <!-- + add -->
<mdi-minus />              <!-- - remove -->
<mdi-arrow-right />        <!-- → arrow -->
<mdi-arrow-left />         <!-- ← arrow -->

<!-- Status -->
<mdi-alert />              <!-- ⚠ warning -->
<mdi-information />        <!-- ℹ info -->
<mdi-check-circle />       <!-- ✓ success -->
<mdi-close-circle />       <!-- ✗ error -->

<!-- Objects -->
<mdi-star />               <!-- ★ star -->
<mdi-heart />              <!-- ♥ heart -->
<mdi-lightbulb />          <!-- 💡 idea -->
<mdi-rocket-launch />      <!-- 🚀 rocket -->
<mdi-clock />              <!-- ⏰ time -->
<mdi-calendar />           <!-- 📅 date -->

<!-- Tech -->
<mdi-github />             <!-- GitHub -->
<mdi-email />              <!-- ✉ email -->
<mdi-cog />                <!-- ⚙ settings -->
<mdi-magnify />            <!-- 🔍 search -->
<mdi-account />            <!-- 👤 user -->
<mdi-chart-line />         <!-- 📈 chart -->
<mdi-file-document />      <!-- 📄 document -->
<mdi-folder />             <!-- 📁 folder -->
<mdi-database />           <!-- database -->
<mdi-server />             <!-- server -->
<mdi-cloud />              <!-- ☁ cloud -->
<mdi-lock />               <!-- 🔒 security -->
<mdi-code-tags />          <!-- </> code -->
```

### Logos (Brand/Tech)

```markdown
<!-- Languages -->
<logos-typescript-icon />
<logos-javascript />
<logos-python />
<logos-go />
<logos-rust />
<logos-java />

<!-- Frameworks -->
<logos-vue />
<logos-react />
<logos-angular-icon />
<logos-svelte-icon />
<logos-nextjs-icon />
<logos-nuxt-icon />

<!-- Tools -->
<logos-nodejs-icon />
<logos-docker-icon />
<logos-kubernetes />
<logos-git-icon />
<logos-github-icon />
<logos-gitlab />

<!-- Cloud -->
<logos-aws />
<logos-google-cloud />
<logos-azure-icon />
<logos-vercel-icon />
<logos-netlify-icon />

<!-- Databases -->
<logos-postgresql />
<logos-mongodb-icon />
<logos-redis />
<logos-mysql-icon />
```

### Icon Styling

```markdown
<!-- Colors -->
<mdi-check class="text-green-500" />
<mdi-close class="text-red-500" />
<mdi-alert class="text-yellow-500" />

<!-- Sizes -->
<mdi-star class="text-xl" />
<mdi-star class="text-2xl" />
<mdi-star class="text-3xl" />
<mdi-star class="text-4xl" />

<!-- Combined -->
<mdi-rocket-launch class="text-3xl text-blue-500" />
```

### Icon with Text

```markdown
<div class="flex items-center gap-2">
  <mdi-github /> GitHub Repository
</div>

<div class="flex items-center gap-2">
  <logos-vue class="text-2xl" /> Built with Vue
</div>
```

### Icon Grid Example

```markdown
<div class="grid grid-cols-4 gap-4 text-4xl">
  <logos-vue />
  <logos-react />
  <logos-angular-icon />
  <logos-svelte-icon />
</div>
```

---

## Custom Vue Components

### Creating Components

Create in `components/` directory:

```vue
<!-- components/Counter.vue -->
<script setup>
import { ref } from 'vue'
const count = ref(0)
</script>

<template>
  <div class="flex gap-2 items-center">
    <button @click="count--">-</button>
    <span>{{ count }}</span>
    <button @click="count++">+</button>
  </div>
</template>
```

Use directly:

```markdown
# Interactive Demo

<Counter />
```

### Props in Components

```vue
<!-- components/ColorBox.vue -->
<script setup>
defineProps({
  color: { type: String, default: 'blue' },
  size: { type: Number, default: 100 }
})
</script>

<template>
  <div
    :style="{
      background: color,
      width: size + 'px',
      height: size + 'px'
    }"
  />
</template>
```

```markdown
<ColorBox color="red" :size="150" />
```

### Global Components

Components in `components/global/` are available everywhere:

```
components/
├── global/
│   └── Logo.vue    # Available in all slides
└── Counter.vue     # Available in slides
```

---

## Code Components

### Shiki Magic Move

Animate code transformations:

````markdown
```ts {*|1-2|3-4|*}
// Initial state
const x = 1

// Final state
const x = 1
const y = 2
```
````

### Monaco Editor

Interactive code editor:

````markdown
```ts {monaco}
// Editable in browser
function greet(name: string) {
  return `Hello, ${name}!`
}
```
````

### Monaco Runner

Execute code:

````markdown
```ts {monaco-run}
function fibonacci(n: number): number {
  if (n <= 1) return n
  return fibonacci(n - 1) + fibonacci(n - 2)
}

console.log(fibonacci(10))
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

### Code Groups

Tabbed code blocks for showing multiple implementations (npm/yarn/pnpm, different languages, etc.)

> Requires `mdc: true` in frontmatter or config.

````markdown
---
mdc: true
---

::code-group

```sh [npm]
npm install @slidev/cli
```

```sh [yarn]
yarn add @slidev/cli
```

```sh [pnpm]
pnpm add @slidev/cli
```

::
````

#### With Custom Icons

````markdown
::code-group

```js [Vue ~logos-vue~]
export default {
  data() { return { count: 0 } }
}
```

```js [React ~logos-react~]
const [count, setCount] = useState(0)
```

::
````

#### When to Use Code Groups

| Scenario | Example |
|----------|---------|
| Package managers | npm / yarn / pnpm / bun |
| Multi-language | Python / JavaScript / Go |
| Framework comparison | Vue / React / Svelte |
| Platform-specific | macOS / Windows / Linux |

---

## KaTeX (Math)

### Inline Math

```markdown
The formula $E = mc^2$ is famous.
```

### Block Math

```markdown
$$
\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
$$
```

### Complex Equations

```markdown
$$
\begin{aligned}
\nabla \times \vec{E} &= -\frac{\partial \vec{B}}{\partial t} \\
\nabla \times \vec{B} &= \mu_0 \vec{J} + \mu_0 \varepsilon_0 \frac{\partial \vec{E}}{\partial t}
\end{aligned}
$$
```

---

## Embedding External Content

### CodePen

```markdown
<iframe
  height="400"
  style="width: 100%;"
  src="https://codepen.io/username/embed/abcdef"
  frameborder="0"
/>
```

### StackBlitz

```markdown
---
layout: iframe-right
url: https://stackblitz.com/edit/example?embed=1
---
```

### Observable

```markdown
<iframe
  width="100%"
  height="500"
  src="https://observablehq.com/embed/@username/notebook"
/>
```

---

## Positioning Components

### Absolute Positioning Classes

```markdown
<div class="abs-tl">Top Left</div>
<div class="abs-tr">Top Right</div>
<div class="abs-bl">Bottom Left</div>
<div class="abs-br">Bottom Right</div>
<div class="abs-t">Top Center</div>
<div class="abs-b">Bottom Center</div>
<div class="abs-l">Left Center</div>
<div class="abs-r">Right Center</div>
```

### With Margin

```markdown
<div class="abs-br m-6 text-sm opacity-50">
  Slide 1 of 20
</div>
```

### Layering

```markdown
<div class="absolute inset-0 flex items-center justify-center z-10">
  Overlay content
</div>
```
