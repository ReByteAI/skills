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

Slidev uses Iconify with UnoCSS. Format: `<prefix-icon-name />`

### Common Icon Sets

```markdown
<!-- Material Design Icons -->
<mdi-account />
<mdi-home />
<mdi-github />
<mdi-check-circle />

<!-- Carbon -->
<carbon-api />
<carbon-code />
<carbon-cloud />

<!-- Logos -->
<logos-vue />
<logos-react />
<logos-typescript-icon />
<logos-nodejs-icon />

<!-- Phosphor -->
<ph-globe />
<ph-code />
<ph-rocket />

<!-- Tabler -->
<tabler-brand-github />
<tabler-settings />

<!-- Heroicons -->
<heroicons-academic-cap />
<heroicons-code-bracket />

<!-- Simple Icons (brands) -->
<simple-icons-github />
<simple-icons-twitter />
```

### Icon Styling

```markdown
<mdi-account class="text-3xl text-blue-500" />

<div class="flex gap-4 text-4xl">
  <logos-vue />
  <logos-react />
  <logos-angular-icon />
</div>
```

### Icon with Text

```markdown
<div class="flex items-center gap-2">
  <mdi-github /> GitHub Repository
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
