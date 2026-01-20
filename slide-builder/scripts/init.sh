#!/bin/bash
# Initialize a new Slidev presentation project
set -euo pipefail

PROJECT_NAME="${1:-}"
THEME="${2:-seriph}"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: bash scripts/init.sh <project-name> [theme]"
    echo "Example: bash scripts/init.sh my-talk seriph"
    exit 1
fi

# Determine project directory
if [ -d "/code" ]; then
    PROJECT_DIR="/code/$PROJECT_NAME"
else
    PROJECT_DIR="$PWD/$PROJECT_NAME"
fi

echo "=== Slidev Init ==="
echo "Project: $PROJECT_DIR"
echo "Theme: $THEME"

# Theme to package mapping
get_theme_package() {
    case "$1" in
        default)     echo "@slidev/theme-default" ;;
        seriph)      echo "@slidev/theme-seriph" ;;
        apple-basic) echo "@slidev/theme-apple-basic" ;;
        dracula)     echo "slidev-theme-dracula" ;;
        geist)       echo "slidev-theme-geist" ;;
        shibainu)    echo "slidev-theme-shibainu" ;;
        bricks)      echo "slidev-theme-bricks" ;;
        *)           echo "@slidev/theme-$1" ;;
    esac
}

THEME_PACKAGE=$(get_theme_package "$THEME")

# Ensure pnpm is available
if ! command -v pnpm &> /dev/null; then
    echo "Installing pnpm..."
    npm install -g pnpm
fi

# Create or enter project
if [ -d "$PROJECT_DIR" ]; then
    echo "Project exists, entering..."
    cd "$PROJECT_DIR"
else
    mkdir -p "$PROJECT_DIR"
    cd "$PROJECT_DIR"

    # package.json
    cat > package.json << EOF
{
  "name": "slidev-presentation",
  "private": true,
  "scripts": {
    "dev": "slidev --open",
    "build": "slidev build",
    "export": "slidev export",
    "export-pptx": "slidev export --format pptx"
  },
  "dependencies": {
    "@slidev/cli": "^51.0.0",
    "$THEME_PACKAGE": "latest"
  },
  "devDependencies": {
    "playwright-chromium": "^1.40.0"
  }
}
EOF

    # Default slides.md
    cat > slides.md << 'EOF'
---
theme: THEME_PLACEHOLDER
title: My Presentation
background: https://cover.sli.dev
class: text-center
transition: slide-left
---

# Presentation Title

Subtitle or tagline

---

# Agenda

<v-clicks>

- Topic 1
- Topic 2
- Topic 3

</v-clicks>

---

# Topic 1

Key point here

---
layout: two-cols
---

# Comparison

Left side content

::right::

Right side content

---
layout: fact
---

# 100%
Key Metric

---
layout: end
---

# Thank You!

Questions?
EOF

    # Replace theme placeholder
    sed -i.bak "s/THEME_PLACEHOLDER/$THEME/" slides.md && rm -f slides.md.bak

    echo "Installing dependencies..."
    pnpm install
fi

echo ""
echo "=== Done ==="
echo "Location: $PROJECT_DIR"
echo ""
echo "Next: Edit slides.md, then run 'bash scripts/build-deploy.sh'"
