---
name: slide-builder
description: Create presentations using Slidev (Markdown-based slides). Triggers include "create presentation", "make slides", "build slides", "slide deck", "tech talk", "conference slides", "pitch deck". Handles the full workflow from content planning to deployment at rebyte.pro.
---

# Slide Builder

Create presentations with Slidev. Deploy to rebyte.pro.

## Two-Phase Methodology

**Content first, polish later.**

### Phase 1: Drafting

Focus on narrative and structure:

- Write speaker notes as you go
- Use simple layouts
- **NO animations** - save for polishing
- Get content approved before styling

### Phase 2: Polishing (after content is complete)

Enhance selectively:

- Add click animations where they aid understanding
- Sync presenter notes with `[click]` markers
- Test each slide before moving to next
- Max 5-6 clicks per slide

**Key principle:** A presentation with good content and no animations beats one with flashy animations and poor content.

## Workflow

1. **Plan content** - Understand the presentation goal, audience, structure, **and tone**
2. **Initialize** - `bash scripts/init.sh <name> [theme]` (see Theme Selection below)
3. **Write slides (Drafting)** - Edit `/code/<name>/slides.md`, focus on content, NO animations
4. **Deploy** - `bash scripts/build-deploy.sh` → returns preview URL
5. **Review & Modify** - User reviews preview, requests changes by slide number
6. **Polish (optional)** - After content is approved, add animations selectively
7. **Export** (optional) - `bash scripts/export.sh pdf|pptx`

## Theme Selection

### When to Choose Theme

Choose theme during **Step 2: Initialize**. Consider:
- Presentation topic and tone
- Target audience
- Formality level

### Available Themes

**Official Themes:**
| Theme | Style | Best For |
|-------|-------|----------|
| `seriph` | Elegant serif | Conference talks, keynotes |
| `default` | Clean minimal | Internal meetings, docs |
| `apple-basic` | Apple-inspired | Product demos, launches |
| `shibainu` | Warm friendly | Team updates, casual talks |
| `bricks` | Bold colorful | Creative pitches, workshops |

**Community Themes (Actively Maintained):**
| Theme | Style | Best For |
|-------|-------|----------|
| `dracula` | Dark purple | Developer talks, tech deep-dives |
| `academic` | Paper-style | Thesis defense, research talks |
| `frankfurt` | Beamer-inspired | Academic conferences |
| `unicorn` | Rainbow/playful | Creative demos, fun topics |
| `penguin` | Personal brand | Personal presentations |
| `eloc` | Writing-focused | Documentation, tutorials |
| `excali-slide` | Excalidraw style | Whiteboard-style talks |
| `mint` | Fresh minimal | Clean presentations |
| `neversink` | Modern academic | Academic presentations |
| `the-unnamed` | VS Code theme | Developer audiences |
| `mokkapps` | Professional | Tech talks, conferences |
| `hep` | Scientific | Physics, science presentations |

### Auto-Selection Guide

Match topic to theme:

| Topic/Audience | Recommended Theme |
|----------------|-------------------|
| Tech conference, keynote | `seriph` (default) |
| Developer/engineering | `dracula` or `the-unnamed` |
| Startup pitch, investor | `seriph` or `mint` |
| Product launch, demo | `apple-basic` |
| Internal team meeting | `default` |
| Workshop, training | `shibainu` |
| Creative/marketing | `bricks` or `unicorn` |
| Meetup, community talk | `penguin` or `mokkapps` |
| Thesis defense, research | `academic` or `frankfurt` |
| Scientific/physics | `hep` or `neversink` |
| Whiteboard/sketch style | `excali-slide` |
| Fast-paced lightning talk | `takahashi` |

### Selection Flow

1. **User specifies theme** → Use that theme
2. **User doesn't specify** → Agent asks:
   > "What's the presentation context? I'll recommend a theme:
   > - Conference/keynote → `seriph`
   > - Developer audience → `dracula`
   > - Startup pitch → `geist`
   > - Or just use default `seriph`?"
3. **User says "auto" or "你选"** → Agent picks based on content topic

### Changing Theme Later

To change theme after init:
1. Edit `theme:` in slides.md frontmatter
2. Update package.json: change theme package
3. Run `pnpm install`
4. Redeploy with `bash scripts/build-deploy.sh`

## Modification Workflow

### After Deployment: Show Slide Index

After deploying, ALWAYS show users a slide index so they can easily reference pages:

```
✅ Deployed: https://abc123.rebyte.pro

📑 Slide Index:
  1. Cover - "Customer Success Story"
  2. Agenda
  3. The Challenge
  4. Our Approach
  5. Implementation
  6. Key Results (metrics)
  7. Before vs After
  8. Testimonial
  9. Next Steps
  10. Thank You

💬 To request changes, quote the page number:
  "Page 3: change title to 'The Problem We Solved'"
  "Page 6: the metric should be 85%, not 75%"
  "Page 4-5: combine into one slide"
```

### Handling User Feedback

When user quotes a page with comments:

**User says:**
```
Page 3: The title should be more impactful, try "The $2M Problem"
Page 6: Add another metric about time savings
Page 8: Remove this slide, testimonial feels weak
```

**Response:**
1. Apply each change to the specified slide
2. Redeploy with `bash scripts/build-deploy.sh`
3. Confirm changes with updated index:

```
✅ Updated 3 slides:
  - Page 3: Title changed to "The $2M Problem"
  - Page 6: Added time savings metric
  - Page 8: Removed (pages renumbered)

🔗 New preview: https://abc123.rebyte.pro

📑 Updated Slide Index:
  1. Cover - "Customer Success Story"
  2. Agenda
  3. The $2M Problem ← updated
  4. Our Approach
  5. Implementation
  6. Key Results ← updated
  7. Before vs After
  8. Next Steps ← was page 9
  9. Thank You ← was page 10

💬 More changes? Just quote the page number.
```

### Locating Slides in Code

Slides are separated by `---` in slides.md:
- Page 1 = content before first `---`
- Page 2 = content after first `---`
- Page N = content after (N-1)th `---`

When editing, count separators to find the right slide.

## Content Guidelines

### Structure

Every presentation needs:
- **Opening** (1-2 slides): Hook + agenda
- **Body** (80% of slides): Main content in logical sections
- **Closing** (1-2 slides): Summary + call-to-action

### Slide Count by Duration

| Duration | Slides | Pace |
|----------|--------|------|
| 5 min | 5-7 | ~1 min/slide |
| 15 min | 12-15 | ~1 min/slide |
| 30 min | 20-25 | ~1.5 min/slide |
| 45 min | 30-35 | ~1.5 min/slide |

### Content Rules

1. **One idea per slide** - If you need "and", split it
2. **6 words per bullet, 6 bullets max** - Slides support speech, not replace it
3. **No walls of text** - If reading takes >10 seconds, trim it
4. **Show, don't tell** - Prefer diagrams, code, images over prose
5. **Use animations sparingly** - Add during polishing phase only, max 5-6 clicks per slide

## Agent Rules

### Core Principles

1. **Ask only when blocked** - Don't over-clarify, assume and proceed
2. **One slide at a time** - Never batch edit multiple slides
3. **Get feedback** - Show progress before continuing
4. **No premature polish** - Complete content before any animations

### Phase-Specific Rules

**During Drafting:**
- Focus on content and flow
- Skip all animations (v-click, v-clicks, v-mark)
- Use only basic layouts
- Write speaker notes for every slide

**During Polishing:**
- Work on one slide at a time
- Test each slide in browser before proceeding
- Validate click alignment with speaker notes
- See `references/animations.md` for Click Alignment system

### Layout Selection

| Content Type | Layout | When |
|--------------|--------|------|
| Title/section | `cover` | Opening, section breaks |
| Regular content | `default` | Most slides |
| Comparison | `two-cols` | A vs B, before/after |
| Feature + visual | `image-right` | Screenshots, diagrams |
| Key metric | `fact` | Statistics, numbers |
| Quote | `quote` | Citations, testimonials |
| Closing | `end` | Final slide |

## Best Practices: Building a Professional Presentation

### Recommended Setup

Always use this frontmatter for professional presentations:

```yaml
---
theme: seriph
title: Your Title
background: https://cover.sli.dev
class: text-center
highlighter: shiki
transition: slide-left
mdc: true
---
```

**Why `seriph` theme**: Elegant serif headings + clean sans-serif body. Professional for any audience.

### Feature Usage Guidelines

| Feature | When to Use | Frequency |
|---------|-------------|-----------|
| `v-clicks` | Bullet points, step-by-step reveals | 30-50% of slides |
| `two-cols` | Comparisons, before/after, pros/cons | 2-3 per presentation |
| `fact` layout | Key metrics, impressive numbers | 1-2 per presentation |
| Mermaid diagrams | Architecture, flows, processes | 1-3 per presentation |
| Code highlighting | Technical demos, code walkthroughs | As needed |
| `image-right` | Features with screenshots | 2-4 per presentation |
| Speaker notes | Every slide | 100% of slides |

### 15-Slide Professional Template

Use this structure for a typical 15-20 minute presentation:

```
Slide 1:  cover      - Title + subtitle + author
Slide 2:  default    - Agenda/outline (with v-clicks)
Slide 3:  center     - Problem statement or hook
Slide 4:  default    - Context/background (with v-clicks)
Slide 5:  image-right - Key concept with visual
Slide 6:  default    - Main point 1 (with v-clicks)
Slide 7:  two-cols   - Comparison or details
Slide 8:  default    - Main point 2 (with v-clicks)
Slide 9:  default    - Code example (with line highlighting)
Slide 10: default    - Main point 3 (with v-clicks)
Slide 11: default    - Mermaid diagram for architecture/flow
Slide 12: fact       - Key metric or result
Slide 13: two-cols   - Before vs After summary
Slide 14: quote      - Testimonial or key takeaway
Slide 15: end        - Thank you + contact/links
```

### Style Consistency Rules

1. **One transition type** - Use `slide-left` globally, don't mix
2. **Consistent v-clicks** - Either use for all bullet lists or none
3. **Same code style** - Pick one language highlighting, use throughout
4. **Color harmony** - Stick to theme colors, avoid custom colors
5. **Icon consistency** - Use one icon set (e.g., `mdi-*` or `carbon-*`)

### Complete Professional Example (15 slides)

```markdown
---
theme: seriph
title: Microservices Migration
background: https://cover.sli.dev
class: text-center
highlighter: shiki
transition: slide-left
mdc: true
---

# Microservices Migration
## From Monolith to Scale

<div class="abs-br m-6 text-sm opacity-50">
  Jane Smith · Tech Lead · 2024
</div>

<!--
Welcome everyone. Today I'll share our journey migrating to microservices.
-->

---

# Agenda

<v-clicks>

- The problem with our monolith
- Migration strategy
- Technical implementation
- Results and lessons learned
- Q&A

</v-clicks>

<!--
We'll cover these 5 main topics in about 15 minutes.
-->

---
layout: center
class: text-center
---

# "Our deployments took 4 hours and failed 30% of the time"

<div class="text-sm opacity-50 mt-4">
  — Engineering Team, January 2023
</div>

<!--
This was the reality we faced. Let me explain how we got here.
-->

---

# The Monolith Problem

<v-clicks>

- **500K lines** of tightly coupled code
- **45-minute** build times
- **4-hour** deployment windows
- **30%** deployment failure rate
- **3 teams** blocked by each other

</v-clicks>

<!--
[click] Half a million lines in one repo
[click] Builds alone took 45 minutes
[click] We could only deploy on weekends
[click] Almost a third of deployments failed
[click] Teams couldn't work independently
-->

---
layout: image-right
image: https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800
---

# Our Architecture (Before)

Single Node.js application:

- All features in one codebase
- Shared database
- No service boundaries
- Horizontal scaling only

<div class="text-sm opacity-50 mt-4">
  Everything deployed together, failed together
</div>

<!--
This is what we were dealing with. A classic monolith.
-->

---

# Migration Strategy

<v-clicks>

- **Strangler Fig Pattern** - Gradually replace, don't rewrite
- **Domain-Driven Design** - Identify bounded contexts
- **API Gateway** - Route traffic during transition
- **Event Sourcing** - Decouple with async messaging

</v-clicks>

<!--
We chose proven patterns rather than a big-bang rewrite.
-->

---
layout: two-cols
layoutClass: gap-8
---

# Bounded Contexts

We identified 6 domains:

<v-clicks>

- User Management
- Order Processing
- Inventory
- Payments
- Notifications
- Analytics

</v-clicks>

::right::

# Team Mapping

<v-clicks>

- Platform Team → User, Gateway
- Commerce Team → Order, Inventory
- Finance Team → Payments
- Growth Team → Notifications, Analytics

</v-clicks>

<!--
Each domain became a service, each team owned specific services.
-->

---

# Service Communication

```mermaid
graph LR
    A[API Gateway] --> B[User Service]
    A --> C[Order Service]
    A --> D[Inventory Service]
    C --> E[Payment Service]
    C --> F[Notification Service]

    subgraph Event Bus
        G[RabbitMQ]
    end

    C -.-> G
    D -.-> G
    E -.-> G
```

<!--
Sync calls via REST, async events via RabbitMQ.
-->

---

# Implementation: API Gateway

```ts {1-3|5-9|11-15|all}
// Kong configuration
const gateway = new KongGateway({
  services: ['user', 'order', 'inventory', 'payment']
})

// Route configuration
gateway.route('/api/users/*', {
  service: 'user-service',
  stripPrefix: true
})

// Rate limiting per service
gateway.plugin('rate-limiting', {
  minute: 1000,
  policy: 'redis'
})
```

<!--
[click] Initialize gateway with our services
[click] Define routing rules
[click] Add rate limiting for protection
[click] Simple but powerful configuration
-->

---

# Database Migration

<v-clicks>

- Each service owns its data
- No shared databases
- Event-driven sync when needed
- Eventual consistency accepted

</v-clicks>

```mermaid {scale: 0.8}
graph TB
    subgraph Before
        A[Monolith] --> B[(Single DB)]
    end

    subgraph After
        C[User Service] --> D[(User DB)]
        E[Order Service] --> F[(Order DB)]
        G[Inventory Service] --> H[(Inventory DB)]
    end
```

<!--
The hardest part was splitting the database. We went with database-per-service.
-->

---
layout: fact
---

# 15 minutes
Average deployment time (was 4 hours)

<!--
This is our biggest win. Let that sink in.
-->

---
layout: two-cols
---

# Before

- 4-hour deployments
- 30% failure rate
- 45-min builds
- Weekend-only releases
- Teams blocked

::right::

# After

- 15-min deployments
- 2% failure rate
- 5-min builds
- 20 deploys/day
- Independent teams

<!--
The transformation was dramatic across every metric.
-->

---

# Key Metrics

<div class="grid grid-cols-3 gap-8 mt-8">
  <div class="text-center">
    <div class="text-5xl font-bold text-blue-500">94%</div>
    <div class="text-sm opacity-75 mt-2">Faster Deployments</div>
  </div>
  <div class="text-center">
    <div class="text-5xl font-bold text-green-500">10x</div>
    <div class="text-sm opacity-75 mt-2">More Deploys/Day</div>
  </div>
  <div class="text-center">
    <div class="text-5xl font-bold text-purple-500">89%</div>
    <div class="text-sm opacity-75 mt-2">Build Time Reduction</div>
  </div>
</div>

<!--
These numbers speak for themselves.
-->

---
layout: quote
---

# "We ship features in days, not months. Teams move independently. It changed everything."

Engineering Director

<!--
This quote from our director summarizes the cultural shift.
-->

---
layout: end
---

# Thank You!

<div class="mt-8">

**Resources**
- Blog: engineering.example.com/microservices
- Code: github.com/example/migration-toolkit

**Contact**
- jane@example.com
- @janesmith

</div>

<!--
Thank you! Happy to take questions.
-->
```

## Slidev Syntax Quick Reference

### Slide Separator

```markdown
---

# Slide 1

Content

---

# Slide 2

More content
```

### Frontmatter (First Slide)

```yaml
---
theme: seriph
title: My Talk
background: https://cover.sli.dev
transition: slide-left
---
```

### Layouts

```markdown
---
layout: two-cols
---

# Left

Content

::right::

# Right

Content
```

### Code with Highlighting

```markdown
```ts {2-3|5}
const a = 1
const b = 2  // highlighted first
const c = 3  // highlighted first
const d = 4
const e = 5  // highlighted second
```
```

### Click Animations

```markdown
<v-clicks>

- Appears first
- Appears second
- Appears third

</v-clicks>
```

### Mermaid Diagrams

```markdown
```mermaid
graph LR
  A[Start] --> B{Decision}
  B -->|Yes| C[Action]
  B -->|No| D[End]
```
```

### Speaker Notes

```markdown
# Slide Title

Content

<!--
Speaker notes here (press P to view)
-->
```

## Available Themes

See [Theme Selection](#theme-selection) for the full list of 23 supported themes.

**Quick reference (most used):**
| Theme | Style | Best For |
|-------|-------|----------|
| `seriph` | Elegant serif | Conference talks (default) |
| `default` | Clean minimal | Internal meetings |
| `dracula` | Dark purple | Developer audiences |
| `academic` | Paper-style | Thesis defense, research |
| `apple-basic` | Apple-inspired | Product demos |
| `mint` | Fresh minimal | Startup pitches |

To change theme: see [Changing Theme Later](#changing-theme-later).

## References

Load as needed based on presentation requirements:

| Topic | File | Contents |
|-------|------|----------|
| Layouts | `references/layouts.md` | All layout options, image layouts, iframe layouts |
| Animations | `references/animations.md` | v-clicks, transitions, Magic Move, motion |
| Components | `references/components.md` | Video, icons, Vue components, math |
| Diagrams | `references/diagrams.md` | Mermaid, PlantUML, all diagram types |
| Styling | `references/styling.md` | UnoCSS, themes, fonts, colors |
| Advanced | `references/advanced.md` | Presenter mode, export, recording, config |

