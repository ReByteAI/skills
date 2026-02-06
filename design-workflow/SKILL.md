---
name: Design Workflow
description: Create logos, graphics, UI mockups, web artifacts, and other visual design work using AI image generation and design intelligence. Use when user wants to design a logo, create brand assets, build UI mockups, generate illustrations, or create interactive visual artifacts. Triggers include "design a logo", "create brand assets", "make a mockup", "design UI", "create illustration", "generate graphic", "build a visual", "design website mockup".
---

# Design Workflow

Create visual design work — logos, brand assets, UI mockups, illustrations, interactive artifacts — by combining AI image generation with design intelligence and web building tools.

## Sub-Skills

- `rebyteai/nano-banana` — AI image generation (text-to-image and image-to-image editing) via Google Gemini. Flash model for fast iteration, Pro model for 4K final output.
- `nextlevelbuilder/ui-ux-pro-max` — Design intelligence: 50+ styles, 97 color palettes, 57 font pairings, 99 UX guidelines. Use for design decisions, style selection, and UI review.
- `anthropics/web-artifacts-builder` — Build interactive visual artifacts (React + Tailwind + shadcn/ui) bundled as single HTML files. For mockups, prototypes, and interactive demos.
- `rebyteai/internet-search` — Research design trends, brand references, competitor visuals, and inspiration.
- `rebyteai/rebyte-app-builder` — Deploy finished designs as live web pages on rebyte.pro.

## Workflow

### Step 1: Understand the Design Brief

Parse what the user wants. Identify:
- **What** — Logo, icon set, illustration, UI mockup, landing page design, brand kit, social media graphics?
- **Style** — Minimalist, bold, playful, corporate, retro, futuristic? If unclear, suggest options using `ui-ux-pro-max` style database.
- **Colors** — Specific palette, or should you recommend one? `ui-ux-pro-max` has 97 palettes to choose from.
- **References** — Any brands, websites, or styles to draw inspiration from?
- **Output format** — Image files, interactive prototype, deployed web page?

If the request is clear, proceed. If not, ask about style and color preferences — these matter most for design work.

### Step 2: Research & Gather Inspiration (if needed)

Use `internet-search` when the user references a brand, competitor, or trend:
- Look up the brand's existing visual identity
- Find competitor designs for comparison
- Research current design trends in the relevant space

Skip this step if the user provides clear specifications or reference images.

### Step 3: Design

Choose your approach based on what's being created:

**Logo / Icon / Illustration / Brand Graphics:**
Use `nano-banana` for AI image generation.

1. Start with the **Flash model** for rapid iteration — generate 3-4 variations
2. Show variations to the user and get feedback
3. Refine the best option with adjusted prompts or image-to-image editing
4. Generate final version with **Pro model** at high resolution (2K or 4K)

Prompt tips for logos:
- Be specific about style: "flat vector logo", "3D metallic emblem", "hand-drawn wordmark"
- Include background preference: "on white background", "transparent-style", "dark background"
- Mention what to avoid: "no text", "simple shapes only", "no gradients"

**UI Mockup / Web Design:**
Use `ui-ux-pro-max` for design decisions, then build with `web-artifacts-builder`.

1. Consult `ui-ux-pro-max` for style, palette, and typography recommendations
2. Build the mockup as an interactive artifact (React + Tailwind + shadcn/ui)
3. This produces a real, clickable prototype — not a static image

**Brand Kit (logo + colors + typography + usage guidelines):**
Combine both approaches:
1. Generate the logo with `nano-banana`
2. Select color palette and font pairings from `ui-ux-pro-max`
3. Build a brand guidelines page with `web-artifacts-builder` showing the logo, colors, typography, and usage rules
4. Deploy with `rebyte-app-builder`

**Social Media Graphics / Marketing Assets:**
Use `nano-banana` with specific aspect ratios:
- Instagram post: 1:1
- Instagram story: 9:16
- Twitter/LinkedIn header: 16:9
- Facebook cover: 21:9

### Step 4: Iterate

Design is iterative. After showing the first version:
- "Make it more minimal" → Simplify with adjusted prompts or image-to-image editing
- "Try different colors" → Regenerate with color-specific prompts, or consult `ui-ux-pro-max` palettes
- "I like option 2 but change the font" → Use image-to-image to refine
- "Make it interactive" → Build with `web-artifacts-builder`

For `nano-banana` iterations, use the **image-to-image** mode — feed the current version back with edit instructions.

### Step 5: Deliver

Based on what was created:

**Image assets (logos, illustrations, graphics):**
- Upload final images to the Artifact Store
- Provide multiple formats if useful (e.g., logo on light background + dark background)
- Note the resolution and recommend upscaling if needed

**Interactive mockups / prototypes:**
- Deploy to rebyte.pro with `rebyte-app-builder`
- Share the live URL

**Brand kits:**
- Deploy the brand guidelines page
- Also upload individual assets (logo files, color swatches) to Artifact Store

## Decision Points

- **"nano-banana or web-artifacts-builder?"** — If the output is a static visual (logo, illustration, graphic), use `nano-banana`. If it's interactive or layout-heavy (UI mockup, prototype, dashboard design), use `web-artifacts-builder`. Brand kits use both.

- **"Flash or Pro model?"** — Use Flash for iterations and exploration (it's fast). Switch to Pro for the final version (it's higher quality, supports 4K).

- **"Should I use ui-ux-pro-max?"** — Yes, whenever design decisions are involved — color selection, typography, style direction, accessibility review. It's the design brain; `nano-banana` is the design hands.

- **"The user wants something nano-banana can't do well"** — AI image generation struggles with precise text in images and exact geometric layouts. For those, build with `web-artifacts-builder` instead (HTML/CSS gives pixel-perfect control).
