---
name: nanoppt
description: NanoPPT - Generate stylized presentation images using Nano Banana AI. Article → ASCII framework → AI-generated slides.
---

# NanoPPT

Generate stylized presentation images using Nano Banana (Google Gemini) image generation.

---

## Workflow

```
Article → ASCII Framework → Select Style → Generate Images → Use in PPT
```

---

## Step 1: Article to ASCII Framework

Read the article, extract core information, and create ASCII layout for each slide.

See `tips/article-to-ascii-ppt.md` for detailed methodology.

---

## Step 2: Generate Images

### Text-to-Image (New slides)

```bash
RESPONSE=$(curl -s -X POST "https://api.eng0.ai/api/data/images/generate" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Doraemon style, presentation slide, title: Hello World",
    "model": "pro",
    "aspectRatio": "16:9",
    "imageSize": "2K"
  }')

echo "$RESPONSE" | jq -r '.image.base64' | base64 -d > "slide-01.png"
```

### Image-to-Image (Edit/Enhance existing)

```bash
# Read local image as base64
IMAGE_BASE64=$(base64 -i slide-01.png)

RESPONSE=$(curl -s -X POST "https://api.eng0.ai/api/data/images/generate" \
  -H "Content-Type: application/json" \
  -d "{
    \"prompt\": \"Fix the text: change 'Helo' to 'Hello'\",
    \"image\": \"$IMAGE_BASE64\",
    \"imageMimeType\": \"image/png\",
    \"model\": \"pro\",
    \"aspectRatio\": \"16:9\"
  }")

echo "$RESPONSE" | jq -r '.image.base64' | base64 -d > "slide-01-fixed.png"
```

---

## API Reference

**Endpoint:** `POST https://api.eng0.ai/api/data/images/generate`

| Parameter | Required | Description |
|-----------|----------|-------------|
| `prompt` | Yes | Text description or editing instructions |
| `image` | No | Base64-encoded source image (for image-to-image) |
| `imageMimeType` | No | `image/png`, `image/jpeg`, or `image/webp` (default: `image/png`) |
| `model` | No | `flash` (fast) or `pro` (high quality, default) |
| `aspectRatio` | No | `1:1`, `16:9`, `9:16`, `4:3`, `3:4`, `21:9`, etc. |
| `imageSize` | No | `1K`, `2K`, `4K` (pro model only) |

**Response:**
```json
{
  "image": {
    "base64": "iVBORw0KGgo...",
    "mimeType": "image/png",
    "dataUrl": "data:image/png;base64,..."
  },
  "description": "AI generated description"
}
```

---

## Style Examples

See `examples/` directory for 18+ style samples:
- **Anime:** Doraemon, Naruto, Ghibli, One Piece
- **Trendy:** Cyberpunk, Vaporwave, Pixel Art
- **Artistic:** Ink Wash, Van Gogh, Art Deco

See `tips/ppt-image-generation.md` for prompt keywords per style.

---

## Tips

| Topic | File |
|-------|------|
| Article to ASCII methodology | `tips/article-to-ascii-ppt.md` |
| Style prompt keywords | `tips/ppt-image-generation.md` |
| Text correction | `tips/text-correction.md` |
| 4K upscale | `tips/4k-upscale.md` |
