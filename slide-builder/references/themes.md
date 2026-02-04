# Theme Selection Guide

## When to Choose Theme

Choose theme during **Step 2: Initialize**. Consider:
- Presentation topic and tone
- Target audience
- Formality level

## Available Themes

**Theme Package Naming Convention:**
- **Official themes**: `@slidev/theme-*` (e.g., `@slidev/theme-seriph`)
- **Community themes**: `slidev-theme-*` (e.g., `slidev-theme-dracula`)

The init script handles this automatically. When changing themes manually, use the correct package name format.

**Official Themes** (package: `@slidev/theme-<name>`):
| Theme | Style | Best For |
|-------|-------|----------|
| `seriph` | Elegant serif | Conference talks, keynotes |
| `default` | Clean minimal | Internal meetings, docs |
| `apple-basic` | Apple-inspired | Product demos, launches |
| `shibainu` | Warm friendly | Team updates, casual talks |
| `bricks` | Bold colorful | Creative pitches, workshops |

**Community Themes** (package: `slidev-theme-<name>`):
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

## Auto-Selection Guide

Match topic to theme:

| Topic/Audience | Recommended Theme | Package Type |
|----------------|-------------------|--------------|
| Tech conference, keynote | `seriph` | Official |
| Developer/engineering | `dracula` or `the-unnamed` | Community |
| Startup pitch, investor | `seriph` or `mint` | Official/Community |
| Product launch, demo | `apple-basic` | Official |
| Internal team meeting | `default` | Official |
| Workshop, training | `shibainu` | Official |
| Creative/marketing | `bricks` or `unicorn` | Official/Community |
| Meetup, community talk | `penguin` or `mokkapps` | Community |
| Thesis defense, research | `academic` or `frankfurt` | Community |
| Scientific/physics | `hep` or `neversink` | Community |
| Whiteboard/sketch style | `excali-slide` | Community |

## Selection Flow

1. **User specifies theme** → Use that theme
2. **User doesn't specify** → Agent asks:
   > "What's the presentation context? I'll recommend a theme:
   > - Conference/keynote → `seriph`
   > - Developer audience → `dracula`
   > - Startup pitch → `seriph` or `mint`
   > - Or just use default `seriph`?"
3. **User says "auto" or "你选"** → Agent picks based on content topic

## Changing Theme Later

To change theme after init:
1. Edit `theme:` in slides.md frontmatter (e.g., `theme: dracula`)
2. Update package.json dependency with correct package name:
   - **Official themes**: `"@slidev/theme-<name>": "latest"` (default, seriph, apple-basic, shibainu, bricks)
   - **Community themes**: `"slidev-theme-<name>": "latest"` (all others)
3. Run `pnpm install` (or `npm install`)
4. Rebuild with `pnpm build` and redeploy using the `rebyte-app-builder` skill

Example for switching to `dracula` (community theme):
```json
"dependencies": {
  "@slidev/cli": "^51.0.0",
  "slidev-theme-dracula": "latest"
}
```

Example for switching to `bricks` (official theme):
```json
"dependencies": {
  "@slidev/cli": "^51.0.0",
  "@slidev/theme-bricks": "latest"
}
```
