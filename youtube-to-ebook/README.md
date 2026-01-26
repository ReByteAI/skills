# YouTube to Ebook

Transform YouTube videos from your favorite channels into beautifully formatted EPUB ebooks.

## Features

- Fetches latest videos from YouTube channels (automatically filters out Shorts)
- Extracts transcripts from videos
- Uses Claude AI to transform transcripts into polished magazine-style articles
- Generates EPUB ebooks readable on any device

## Requirements

- Python 3.8+
- `youtube-transcript-api` - For transcript extraction (no API key needed)
- `ebooklib` - For EPUB creation
- `anthropic` - For article generation (API key provided by environment)

## Installation

This skill uses Rebyte's data proxy for YouTube Data API access - no API keys needed.

```bash
pip install youtube-transcript-api ebooklib markdown requests anthropic
```

## Usage

Ask Claude: "Create an ebook from the latest videos on @mkbhd and @veritasium"

Or run the script directly after customizing the `CHANNELS` list.

## How It Works

1. **Channel Discovery**: Uses Rebyte's YouTube data proxy to get channel uploads
2. **Video Filtering**: Automatically filters out YouTube Shorts
3. **Transcript Extraction**: Uses `youtube-transcript-api` (works without API key)
4. **Article Generation**: Claude transforms transcripts into polished articles
5. **EPUB Creation**: Packages articles into a professional ebook

## Credits

Inspired by [zarazhangrui/youtube-to-ebook](https://github.com/zarazhangrui/youtube-to-ebook).
