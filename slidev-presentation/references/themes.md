# Slidev Themes Reference

## Using Themes

### In Frontmatter

```yaml
---
theme: seriph
---
```

### In package.json

```json
{
  "dependencies": {
    "@slidev/theme-seriph": "latest"
  }
}
```

## Official Themes

### default

Clean and minimal theme. Good for general purpose.

```yaml
theme: default
```

**Characteristics:**
- Light background
- Sans-serif fonts
- Minimal styling
- Good for code-heavy presentations

### seriph

Elegant theme with serif fonts. Professional appearance.

```yaml
theme: seriph
```

```json
{
  "dependencies": {
    "@slidev/theme-seriph": "latest"
  }
}
```

**Characteristics:**
- Serif headings (Playfair Display)
- Sans-serif body text
- Elegant, professional look
- Great for conference talks

### apple-basic

Apple-inspired minimalist design.

```yaml
theme: apple-basic
```

```json
{
  "dependencies": {
    "@slidev/theme-apple-basic": "latest"
  }
}
```

**Characteristics:**
- SF Pro-inspired typography
- Clean white backgrounds
- Subtle animations
- Product launch style

## Community Themes

### geist

Vercel-inspired modern design.

```yaml
theme: geist
```

```json
{
  "dependencies": {
    "slidev-theme-geist": "latest"
  }
}
```

**Characteristics:**
- Modern, tech-forward
- Monospace accents
- Dark mode friendly
- Startup/tech company style

### dracula

Dark theme with purple accents.

```yaml
theme: dracula
```

```json
{
  "dependencies": {
    "slidev-theme-dracula": "latest"
  }
}
```

**Characteristics:**
- Dark purple background
- High contrast colors
- Easy on the eyes
- Developer-focused

### shibainu

Warm and friendly theme.

```yaml
theme: shibainu
```

```json
{
  "dependencies": {
    "slidev-theme-shibainu": "latest"
  }
}
```

**Characteristics:**
- Warm color palette
- Rounded elements
- Approachable feel
- Community/workshop style

### bricks

Bold and colorful blocks.

```yaml
theme: bricks
```

```json
{
  "dependencies": {
    "slidev-theme-bricks": "latest"
  }
}
```

**Characteristics:**
- Bold geometric shapes
- Vibrant colors
- Creative presentations
- High visual impact

### penguin

Modern minimalist with gradient accents.

```yaml
theme: penguin
```

```json
{
  "dependencies": {
    "slidev-theme-penguin": "latest"
  }
}
```

**Characteristics:**
- Clean layout
- Gradient color accents
- Modern feel
- Versatile usage

## Theme Selection Guide

| Use Case | Recommended Theme | Why |
|----------|------------------|-----|
| Tech conference | `seriph` | Professional, elegant serif fonts |
| Startup pitch | `geist` | Modern, Vercel-style tech feel |
| Internal team meeting | `default` | Clean, no distractions |
| Workshop/tutorial | `shibainu` | Warm, approachable |
| Creative presentation | `bricks` | Bold, colorful |
| Night/dark environments | `dracula` | Easy on eyes |
| Product launch | `apple-basic` | Apple-inspired minimalism |

## Customizing Themes

### Global CSS Variables

Create `styles/index.css`:

```css
:root {
  --slidev-theme-primary: #4EC5D4;
  --slidev-theme-secondary: #2B90B6;
}
```

### Per-Slide Styling

```markdown
---

# Styled Slide

<style>
h1 {
  color: #4EC5D4;
}
</style>
```

### UnoCSS Utilities

Slidev includes UnoCSS for utility classes:

```markdown
<div class="text-3xl font-bold text-blue-500 mt-4">
  Styled text
</div>
```

## Color Scheme

### Light Mode (Default)

```yaml
---
colorSchema: light
---
```

### Dark Mode

```yaml
---
colorSchema: dark
---
```

### Auto (Follow System)

```yaml
---
colorSchema: auto
---
```

## Background Options

### Solid Color

```yaml
---
background: '#1a1a2e'
---
```

### Image URL

```yaml
---
background: https://images.unsplash.com/photo-xxx
---
```

### Local Image

```yaml
---
background: /images/cover.jpg
---
```

Place image in `public/images/` folder.

### Gradient

```yaml
---
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%)
---
```

## Font Configuration

### In Frontmatter

```yaml
---
fonts:
  sans: Robot
  serif: Robot Slab
  mono: Fira Code
---
```

### Web Fonts

Fonts are auto-loaded from Google Fonts. Custom fonts need manual setup.

## Transition Configuration

### Global Default

```yaml
---
transition: slide-left
---
```

### Per-Slide Override

```markdown
---
transition: fade
---

# This slide fades in
```

### Available Transitions

- `fade` - Simple crossfade
- `fade-out` - Fade out, then fade in
- `slide-left` - Slide from right to left
- `slide-right` - Slide from left to right
- `slide-up` - Slide from bottom to top
- `slide-down` - Slide from top to bottom
- `view-transition` - Native View Transitions API
