# FFmpeg Usage Guide

FFmpeg is a powerful multimedia processing tool. This document covers the core commands used in YouTube Clipper.

## Installation

### macOS
```bash
# Standard version (no subtitle burning support)
brew install ffmpeg

# Full version (recommended, supports subtitle burning)
brew install ffmpeg-full
```

### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install ffmpeg libass-dev
```

### Verify Installation
```bash
# Check version
ffmpeg -version

# Check libass support (required for subtitle burning)
ffmpeg -filters 2>&1 | grep subtitles
```

## Common Commands

### 1. Clip Video

```bash
# Precise clipping (from 30 seconds, duration 60 seconds)
ffmpeg -ss 30 -i input.mp4 -t 60 -c copy output.mp4

# From 01:30:00 to 01:33:15
ffmpeg -ss 01:30:00 -i input.mp4 -to 01:33:15 -c copy output.mp4
```

**Parameters**:
- `-ss`: Start time
- `-i`: Input file
- `-t`: Duration
- `-to`: End time
- `-c copy`: Copy streams directly, no re-encoding (fast and lossless)

### 2. Burn Subtitles

```bash
# Burn SRT subtitles into video
ffmpeg -i input.mp4 \
  -vf "subtitles=subtitle.srt" \
  -c:a copy \
  output.mp4

# Custom subtitle style
ffmpeg -i input.mp4 \
  -vf "subtitles=subtitle.srt:force_style='FontSize=24,MarginV=30'" \
  -c:a copy \
  output.mp4
```

**Notes**:
- Requires libass support
- Path cannot contain spaces (use temp directory to solve)
- Video will be re-encoded (slower than clipping)

### 3. Video Compression

```bash
# Using H.264 compression
ffmpeg -i input.mp4 \
  -c:v libx264 \
  -crf 23 \
  -c:a aac \
  output.mp4
```

**CRF Values**:
- 18: High quality, larger file
- 23: Balanced (recommended)
- 28: Lower quality, smaller file

### 4. Extract Audio

```bash
# Extract as MP3
ffmpeg -i input.mp4 -vn -acodec libmp3lame -q:a 2 output.mp3

# Extract as AAC
ffmpeg -i input.mp4 -vn -c:a copy output.aac
```

### 5. Video Information

```bash
# View detailed video info
ffmpeg -i input.mp4

# View brief info
ffprobe -v error -show_format -show_streams input.mp4
```

## Subtitle Related

### Burning Bilingual Subtitles

```bash
# Bilingual subtitles (each subtitle contains two lines)
ffmpeg -i input.mp4 \
  -vf "subtitles=bilingual.srt:force_style='FontSize=24,MarginV=30'" \
  -c:a copy \
  output.mp4
```

### Adjusting Subtitle Style

Available style options:
- `FontSize`: Font size (recommended 20-28)
- `MarginV`: Vertical margin (recommended 20-40)
- `FontName`: Font name
- `PrimaryColour`: Primary color
- `OutlineColour`: Outline color
- `Bold`: Bold (0 or 1)

Example:
```bash
subtitles=subtitle.srt:force_style='FontSize=28,MarginV=40,Bold=1'
```

## Performance Optimization

### Hardware Acceleration

```bash
# macOS (VideoToolbox)
ffmpeg -hwaccel videotoolbox -i input.mp4 ...

# NVIDIA GPU
ffmpeg -hwaccel cuda -i input.mp4 ...
```

### Multi-threading

```bash
# Use 4 threads
ffmpeg -threads 4 -i input.mp4 ...
```

## Common Issues

### Q: Subtitle burning fails with "No such filter: 'subtitles'"

A: FFmpeg doesn't have libass support. On macOS, install `ffmpeg-full`.

### Q: Path with spaces causes subtitle burning failure

A: Use temp directory, copy files to path without spaces then process.

### Q: Video quality degraded

A: Use `-c copy` to copy streams directly, or lower CRF value (e.g., 18).

### Q: Processing speed slow

A:
- Use hardware acceleration (`-hwaccel`)
- Use `-c copy` when clipping
- Increase thread count (`-threads`)

## Reference Links

- [FFmpeg Official Documentation](https://ffmpeg.org/documentation.html)
- [FFmpeg Wiki](https://trac.ffmpeg.org/wiki)
- [Subtitles Filter Documentation](https://ffmpeg.org/ffmpeg-filters.html#subtitles)
