# Slidev Styling Reference

## UnoCSS (Built-in)

Slidev includes UnoCSS with Tailwind-compatible utilities.

### Text

```markdown
<div class="text-sm">Small text</div>
<div class="text-base">Base text</div>
<div class="text-lg">Large text</div>
<div class="text-xl">Extra large</div>
<div class="text-2xl">2XL text</div>
<div class="text-3xl">3XL text</div>
<div class="text-4xl">4XL text</div>
<div class="text-5xl">5XL text</div>
<div class="text-6xl">6XL text</div>

<div class="font-thin">Thin</div>
<div class="font-light">Light</div>
<div class="font-normal">Normal</div>
<div class="font-medium">Medium</div>
<div class="font-semibold">Semibold</div>
<div class="font-bold">Bold</div>

<div class="italic">Italic text</div>
<div class="underline">Underlined</div>
<div class="line-through">Strikethrough</div>
```

### Colors

```markdown
<div class="text-red-500">Red text</div>
<div class="text-blue-500">Blue text</div>
<div class="text-green-500">Green text</div>
<div class="text-yellow-500">Yellow text</div>
<div class="text-purple-500">Purple text</div>
<div class="text-gray-500">Gray text</div>

<div class="bg-red-500">Red background</div>
<div class="bg-blue-100">Light blue background</div>
<div class="bg-gradient-to-r from-blue-500 to-purple-500">Gradient</div>

<div class="text-white/50">50% opacity white</div>
<div class="opacity-50">50% opacity</div>
```

Color scale: 50, 100, 200, 300, 400, 500, 600, 700, 800, 900

### Spacing

```markdown
<!-- Margin -->
<div class="m-4">Margin all sides</div>
<div class="mx-4">Margin horizontal</div>
<div class="my-4">Margin vertical</div>
<div class="mt-4">Margin top</div>
<div class="mb-4">Margin bottom</div>
<div class="ml-4">Margin left</div>
<div class="mr-4">Margin right</div>

<!-- Padding -->
<div class="p-4">Padding all sides</div>
<div class="px-4">Padding horizontal</div>
<div class="py-4">Padding vertical</div>
<div class="pt-4">Padding top</div>

<!-- Spacing scale -->
<!-- 0, 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 20, 24, 32... -->
<!-- 1 = 0.25rem, 4 = 1rem -->
```

### Flexbox

```markdown
<div class="flex">Flex container</div>
<div class="flex items-center">Vertically centered</div>
<div class="flex justify-center">Horizontally centered</div>
<div class="flex items-center justify-center">Centered both</div>
<div class="flex gap-4">Gap between items</div>
<div class="flex flex-col">Column direction</div>
<div class="flex flex-wrap">Wrap items</div>
```

### Grid

```markdown
<div class="grid grid-cols-2 gap-4">Two columns</div>
<div class="grid grid-cols-3 gap-4">Three columns</div>
<div class="grid grid-cols-4 gap-4">Four columns</div>

<!-- Custom columns -->
<div class="grid grid-cols-[1fr_2fr] gap-4">1:2 ratio</div>
<div class="grid grid-cols-[200px_1fr] gap-4">Fixed + flexible</div>
```

### Width & Height

```markdown
<div class="w-full">Full width</div>
<div class="w-1/2">Half width</div>
<div class="w-1/3">Third width</div>
<div class="w-3/4">Three quarters</div>
<div class="w-64">Fixed width (16rem)</div>

<div class="h-full">Full height</div>
<div class="h-screen">Viewport height</div>
<div class="h-64">Fixed height</div>

<div class="min-h-screen">Min viewport height</div>
<div class="max-w-xl">Max width XL</div>
```

### Borders & Rounded

```markdown
<div class="border">1px border</div>
<div class="border-2">2px border</div>
<div class="border-4">4px border</div>
<div class="border-red-500">Colored border</div>
<div class="border-t-2">Top border only</div>

<div class="rounded">Small radius</div>
<div class="rounded-md">Medium radius</div>
<div class="rounded-lg">Large radius</div>
<div class="rounded-xl">XL radius</div>
<div class="rounded-full">Fully rounded</div>
```

### Shadows

```markdown
<div class="shadow">Small shadow</div>
<div class="shadow-md">Medium shadow</div>
<div class="shadow-lg">Large shadow</div>
<div class="shadow-xl">XL shadow</div>
<div class="shadow-2xl">2XL shadow</div>
```

### Position

```markdown
<div class="relative">Relative position</div>
<div class="absolute">Absolute position</div>
<div class="fixed">Fixed position</div>
<div class="sticky top-0">Sticky top</div>

<div class="absolute top-0 left-0">Top left corner</div>
<div class="absolute inset-0">Fill container</div>
<div class="absolute inset-x-0 bottom-0">Bottom bar</div>
```

---

## Per-Slide CSS

### Style Tag

```markdown
# Slide Title

Content here

<style>
h1 {
  color: #4EC5D4;
  font-size: 3rem;
}
.custom-class {
  background: linear-gradient(45deg, #f00, #00f);
}
</style>
```

### Scoped Styles

Styles in `<style>` are automatically scoped to the slide.

### Global Styles

Use `:global()` for global styles:

```markdown
<style>
:global(.slidev-layout) {
  background: #1a1a2e;
}
</style>
```

---

## Global Stylesheets

### styles/index.css

Create `styles/index.css` for global styles:

```css
/* styles/index.css */
:root {
  --slidev-theme-primary: #4EC5D4;
  --slidev-theme-secondary: #2B90B6;
}

.slidev-layout {
  font-family: 'Inter', sans-serif;
}

h1 {
  font-weight: 700;
}

code {
  font-family: 'Fira Code', monospace;
}
```

---

## Themes

### Theme Configuration

```yaml
---
theme: seriph
---
```

### Available Themes

| Theme | Package | Style |
|-------|---------|-------|
| default | @slidev/theme-default | Clean minimal |
| seriph | @slidev/theme-seriph | Elegant serif |
| apple-basic | @slidev/theme-apple-basic | Apple style |
| shibainu | @slidev/theme-shibainu | Warm friendly |
| bricks | @slidev/theme-bricks | Bold colorful |
| dracula | slidev-theme-dracula | Dark purple |

### Installing Themes

Add to package.json:

```json
{
  "dependencies": {
    "slidev-theme-dracula": "latest"
  }
}
```

### Color Scheme

```yaml
---
colorSchema: light
---

# Or
---
colorSchema: dark
---

# Or follow system
---
colorSchema: auto
---
```

---

## Fonts

### Font Configuration

```yaml
---
fonts:
  sans: 'Inter'
  serif: 'Playfair Display'
  mono: 'Fira Code'
  weights: '200,400,600,700'
---
```

### Web Fonts

Fonts are auto-loaded from Google Fonts:

```yaml
---
fonts:
  sans: 'Roboto'
  serif: 'Merriweather'
  mono: 'JetBrains Mono'
---
```

### Local Fonts

```css
/* styles/index.css */
@font-face {
  font-family: 'CustomFont';
  src: url('/fonts/custom.woff2') format('woff2');
}

.slidev-layout {
  font-family: 'CustomFont', sans-serif;
}
```

Place fonts in `public/fonts/`.

---

## Backgrounds

### In Frontmatter

```yaml
---
background: https://images.unsplash.com/photo-xxx
---

---
background: /images/local.jpg
---

---
background: '#1a1a2e'
---

---
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%)
---
```

### Background Options

```yaml
---
background: https://example.com/image.jpg
backgroundSize: cover
backgroundPosition: center
---
```

### Using Unsplash

```yaml
---
layout: cover
background: https://cover.sli.dev
---
```

`cover.sli.dev` serves random Unsplash images optimized for slides.

---

## Dark Mode

### Toggle in Presentation

Press `D` to toggle dark mode during presentation.

### Force Dark/Light

```yaml
---
colorSchema: dark
---
```

### Dark Mode Styles

```css
html.dark .slidev-layout {
  background: #1a1a2e;
}

html.dark h1 {
  color: #fff;
}
```

---

## Responsive Utilities

```markdown
<div class="hidden sm:block">Visible on small+</div>
<div class="hidden md:block">Visible on medium+</div>
<div class="hidden lg:block">Visible on large+</div>
<div class="block sm:hidden">Visible only on xs</div>
```

---

## Common Patterns

### Card

```markdown
<div class="bg-white rounded-lg shadow-lg p-6">
  <h3 class="text-xl font-bold">Card Title</h3>
  <p class="text-gray-600 mt-2">Card content here</p>
</div>
```

### Badge

```markdown
<span class="px-2 py-1 bg-blue-100 text-blue-800 rounded-full text-sm">
  Badge
</span>
```

### Feature Grid

```markdown
<div class="grid grid-cols-3 gap-6 mt-8">
  <div class="text-center">
    <div class="text-4xl mb-2">🚀</div>
    <h4 class="font-bold">Fast</h4>
    <p class="text-sm opacity-75">Lightning quick</p>
  </div>
  <div class="text-center">
    <div class="text-4xl mb-2">🔒</div>
    <h4 class="font-bold">Secure</h4>
    <p class="text-sm opacity-75">Enterprise ready</p>
  </div>
  <div class="text-center">
    <div class="text-4xl mb-2">✨</div>
    <h4 class="font-bold">Simple</h4>
    <p class="text-sm opacity-75">Easy to use</p>
  </div>
</div>
```
