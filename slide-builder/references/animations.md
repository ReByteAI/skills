# Slidev Animations Reference

## Click Animations

### v-clicks Container

Reveal items one by one on each click.

```markdown
<v-clicks>

- First item appears
- Second item appears
- Third item appears

</v-clicks>
```

Works with any elements:

```markdown
<v-clicks>

<div>Block 1</div>
<div>Block 2</div>
<div>Block 3</div>

</v-clicks>
```

### v-clicks with Depth

Control nesting depth with `depth` attribute:

```markdown
<v-clicks depth="2">

- Item 1
  - Nested 1.1
  - Nested 1.2
- Item 2
  - Nested 2.1

</v-clicks>
```

### Individual v-click

Apply to specific elements:

```markdown
<div v-click>Appears on click 1</div>
<div v-click>Appears on click 2</div>
<div v-click>Appears on click 3</div>
```

### Custom Click Order

Specify order with numeric value:

```markdown
<div v-click="3">Third (click 3)</div>
<div v-click="1">First (click 1)</div>
<div v-click="2">Second (click 2)</div>
```

### Click Ranges

Show element only during specific click range:

```markdown
<div v-click="[1, 4]">
  Visible from click 1 to click 4, then hidden
</div>
```

```markdown
<div v-click="[2, null]">
  Appears at click 2, stays visible forever
</div>
```

### Hide on Click

Start visible, hide on click:

```markdown
<div v-click.hide>
  Visible initially, hides on click
</div>

<div v-click.hide="3">
  Hides specifically at click 3
</div>
```

### v-after

Appear with the previous click (same timing):

```markdown
<div v-click>Appears on click 1</div>
<div v-after>Also appears on click 1 (with previous)</div>
<div v-click>Appears on click 2</div>
```

### Clicks in Frontmatter

Set initial click state for a slide:

```markdown
---
clicks: 3
---

# Slide Title

<div v-click="1">Already visible (click >= 1)</div>
<div v-click="2">Already visible (click >= 2)</div>
<div v-click="3">Already visible (click >= 3)</div>
<div v-click="4">Will appear on next click</div>
```

---

## Slide Transitions

### Global Transition

Set default transition in frontmatter:

```yaml
---
transition: slide-left
---
```

### Per-Slide Transition

Override for specific slides:

```markdown
---
transition: fade
---

# This slide fades in
```

### Available Transitions

| Transition | Description |
|------------|-------------|
| `fade` | Simple crossfade |
| `fade-out` | Fade out, then fade in |
| `slide-left` | Slide from right to left |
| `slide-right` | Slide from left to right |
| `slide-up` | Slide from bottom to top |
| `slide-down` | Slide from top to bottom |
| `view-transition` | Native View Transitions API |

### Different Enter/Leave Transitions

```markdown
---
transition: slide-left | slide-right
---
```

Format: `enter | leave`

### Conditional Transitions

```markdown
---
transition: view-transition
transition-forward: slide-left
transition-backward: slide-right
---
```

---

## Magic Move

Animate elements between slides automatically. Elements with same `data-id` animate smoothly.

### Basic Magic Move

```markdown
---
layout: center
---

<div class="text-6xl" data-id="title">Hello</div>

---
layout: center
---

<div class="text-3xl text-red" data-id="title">Hello World!</div>
```

### Code Magic Move

Animate code changes between slides:

````markdown
---

```js {*|1|2}
const greeting = "Hello"
```

---

```js {*}
const greeting = "Hello"
const name = "World"
console.log(`${greeting}, ${name}!`)
```
````

### Magic Move with Multiple Elements

```markdown
---

<div data-id="box1" class="w-20 h-20 bg-blue abs-tl" />
<div data-id="box2" class="w-20 h-20 bg-red abs-tr" />

---

<div data-id="box1" class="w-40 h-40 bg-green abs-br" />
<div data-id="box2" class="w-10 h-10 bg-yellow abs-bl" />
```

---

## Motion (VueUse Motion)

Slidev includes `@vueuse/motion` for advanced animations.

### Basic Motion

```markdown
<div
  v-motion
  :initial="{ opacity: 0, y: 100 }"
  :enter="{ opacity: 1, y: 0 }"
>
  Animated content
</div>
```

### Motion with Click

```markdown
<div
  v-motion
  :initial="{ opacity: 0, x: -100 }"
  :enter="{ opacity: 1, x: 0 }"
  :click-1="{ x: 100 }"
  :click-2="{ x: 0, y: -50 }"
>
  Moves on clicks
</div>
```

### Motion Presets

```markdown
<div v-motion-slide-left>Slides from left</div>
<div v-motion-slide-right>Slides from right</div>
<div v-motion-slide-top>Slides from top</div>
<div v-motion-slide-bottom>Slides from bottom</div>
<div v-motion-fade>Fades in</div>
<div v-motion-pop>Pops in</div>
<div v-motion-roll-left>Rolls from left</div>
<div v-motion-roll-right>Rolls from right</div>
```

### Motion with Delay

```markdown
<div
  v-motion
  :initial="{ opacity: 0 }"
  :enter="{ opacity: 1, transition: { delay: 500 } }"
>
  Appears after 500ms
</div>
```

### Motion with Spring

```markdown
<div
  v-motion
  :initial="{ scale: 0 }"
  :enter="{
    scale: 1,
    transition: {
      type: 'spring',
      stiffness: 200,
      damping: 10
    }
  }"
>
  Bouncy entrance
</div>
```

### Combining Motion with v-click

```markdown
<div
  v-click
  v-motion
  :initial="{ opacity: 0, y: 50 }"
  :enter="{ opacity: 1, y: 0 }"
>
  Appears on click with animation
</div>
```

---

## Code Animations

### Line Highlighting Steps

```markdown
```ts {1|2-3|5|all}
const a = 1        // Step 1
const b = 2        // Step 2
const c = 3        // Step 2
const d = 4
const e = a + b    // Step 3
// Step 4: all highlighted
```
```

### Highlight with Starting Point

```markdown
```ts {*|1|2-3}{startLine:5}
// This is line 5
const x = 1  // Line 6
const y = 2  // Line 7
```
```

### Auto-Animate Code

```markdown
```ts {*}{autoAnimate:true}
// Code changes animate automatically
```
```

---

## Presenter Notes Animations

Include timing hints in notes:

```markdown
# Slide Title

Content here

<!--
[click] Reveal first point
[click] Reveal second point
[pause] Let audience absorb
[click] Reveal conclusion
-->
```

---

## Animation Best Practices

1. **Use sparingly** - Too many animations distract from content
2. **Match purpose** - Animations should reinforce meaning
3. **Keep timing consistent** - Use similar durations throughout
4. **Test on target device** - Some animations lag on older hardware

### When to Use Each

| Animation Type | Use For |
|----------------|---------|
| v-clicks | Progressive reveals, bullet points |
| Transitions | Slide changes, section breaks |
| Magic Move | Showing evolution, code changes |
| Motion | Emphasis, attention direction |
