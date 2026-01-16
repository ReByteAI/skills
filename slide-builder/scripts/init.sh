#!/bin/bash
# Slidev project initialization script
set -e

# Always work in /code directory
cd /code

PROJECT_DIR="${1:-slidev-project}"
THEME="${2:-seriph}"  # Default to seriph theme

echo "=== Slidev Project Init ==="
echo "Project: /code/$PROJECT_DIR"
echo "Theme: $THEME"

# Theme package name mapping
get_theme_package() {
    case "$1" in
        default)    echo "@slidev/theme-default" ;;
        seriph)     echo "@slidev/theme-seriph" ;;
        apple-basic) echo "@slidev/theme-apple-basic" ;;
        bricks)     echo "slidev-theme-bricks" ;;
        shibainu)   echo "slidev-theme-shibainu" ;;
        geist)      echo "slidev-theme-geist" ;;
        dracula)    echo "slidev-theme-dracula" ;;
        penguin)    echo "slidev-theme-penguin" ;;
        purplin)    echo "slidev-theme-purplin" ;;
        *)          echo "@slidev/theme-$1" ;;
    esac
}

THEME_PACKAGE=$(get_theme_package "$THEME")

# Check pnpm
if ! command -v pnpm &> /dev/null; then
    echo "Installing pnpm..."
    npm install -g pnpm
fi

# Create project directory
if [ -d "$PROJECT_DIR" ]; then
    echo "Project directory $PROJECT_DIR exists, entering..."
    cd "$PROJECT_DIR"
else
    echo "Creating project: $PROJECT_DIR"
    mkdir -p "$PROJECT_DIR"
    cd "$PROJECT_DIR"

    # Initialize package.json
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

    # Create default slides.md
    cat > slides.md << EOF
---
theme: $THEME
title: My Presentation
background: https://cover.sli.dev
class: text-center
highlighter: shiki
transition: slide-left
mdc: true
---

# Welcome to Slidev

Press Space to start

---

# What is Slidev?

Slidev is a slides maker designed for developers

<v-clicks>

- **Markdown-based** - focus on content
- **Themable** - use any theme you like
- **Developer Friendly** - code highlighting, live coding
- **Interactive** - embed Vue components
- **Recording** - built-in recording and camera view

</v-clicks>

---
layout: two-cols
---

# Left Side

- Point 1
- Point 2
- Point 3

::right::

# Right Side

\`\`\`ts
console.log('Hello!')
\`\`\`

---
layout: center
class: text-center
---

# Learn More

[Documentation](https://sli.dev) · [GitHub](https://github.com/slidevjs/slidev)
EOF

    echo "Installing dependencies..."
    pnpm install
fi

echo ""
echo "=== Init Complete ==="
echo "Project: $(pwd)"
echo "Theme: $THEME ($THEME_PACKAGE)"
echo ""
echo "Available themes:"
echo "  seriph      - Elegant & Professional (recommended)"
echo "  default     - Clean & Minimal"
echo "  apple-basic - Apple style"
echo "  dracula     - Dark purple"
echo "  geist       - Modern tech"
echo "  shibainu    - Warm & Friendly"
echo "  bricks      - Colorful geometric"
echo ""
echo "To change theme: edit slides.md frontmatter 'theme: xxx'"
echo "                 and add the package to package.json"
echo ""
echo "Next steps:"
echo "  pnpm dev    # Local preview"
echo "  pnpm build  # Build for production"
