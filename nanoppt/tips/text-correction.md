# Text Correction

Fix text errors in generated images using image-to-image.

## Usage

```bash
# 1. Read the image as base64
IMAGE_BASE64=$(base64 -i slide-01.png)

# 2. Call API with correction prompt
RESPONSE=$(curl -s -X POST "https://api.eng0.ai/api/data/images/generate" \
  -H "Content-Type: application/json" \
  -d "{
    \"prompt\": \"Fix the text: change 'Helo' to 'Hello'. Keep everything else unchanged.\",
    \"image\": \"$IMAGE_BASE64\",
    \"imageMimeType\": \"image/png\",
    \"model\": \"pro\",
    \"aspectRatio\": \"16:9\"
  }")

# 3. Save the corrected image
echo "$RESPONSE" | jq -r '.image.base64' | base64 -d > "slide-01-fixed.png"
```

## Prompt Tips

| Tip | Example |
|-----|---------|
| Be specific | "Change 'Helo' to 'Hello'" not "Fix typo" |
| One change at a time | Don't request multiple fixes in one call |
| Preserve context | Add "Keep everything else unchanged" |
| Specify location | "In the title at top center" |

## Notes

- AI text correction has randomness, may need 2-3 attempts
- Always verify the result after each generation
- For complex multi-text fixes, do them one at a time
