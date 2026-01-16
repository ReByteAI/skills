#!/bin/bash
# Slidev export script
set -e

FORMAT="${1:-pdf}"
OUTPUT="${2:-presentation}"
PROJECT_DIR="${3:-.}"

echo "=== Slidev Export ==="

cd "$PROJECT_DIR"

# Ensure playwright is installed
if [ ! -d "node_modules/playwright-chromium" ]; then
    echo "Installing playwright-chromium..."
    pnpm add -D playwright-chromium
    npx playwright install chromium
fi

case "$FORMAT" in
    pdf)
        echo "Exporting to PDF..."
        npx slidev export --output "${OUTPUT}.pdf"
        echo "Output: ${OUTPUT}.pdf"
        ;;
    pptx)
        echo "Exporting to PPTX (image-based)..."
        npx slidev export --format pptx --output "${OUTPUT}.pptx"
        echo "Output: ${OUTPUT}.pptx"
        ;;
    png)
        echo "Exporting to PNG..."
        npx slidev export --format png --output "${OUTPUT}"
        echo "Output: ${OUTPUT}/ directory"
        ;;
    *)
        echo "Supported formats: pdf, pptx, png"
        exit 1
        ;;
esac

echo ""
echo "=== Export Complete ==="
