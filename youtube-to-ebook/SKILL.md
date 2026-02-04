---
name: youtube-to-ebook
description: Transform YouTube videos into beautifully formatted EPUB ebooks. Fetches latest videos from channels, extracts transcripts, uses AI to write polished articles, and packages them as an ebook. Triggers include "youtube to ebook", "youtube articles", "video to ebook", "channel to ebook", "youtube newsletter", "convert youtube to book".
---

# YouTube to Ebook

Transform YouTube videos from your favorite channels into well-written magazine-style articles, delivered as an EPUB ebook.

{{include:auth.md}}

## What This Skill Does

1. Fetches latest videos from YouTube channels (filtering out Shorts)
2. Extracts transcripts from those videos
3. Transforms transcripts into polished articles using Claude
4. Packages articles into an EPUB ebook for reading on any device

## Quick Start

Ask: "Create an ebook from the latest videos on @mkbhd and @veritasium"

---

## Workflow

### Phase 1: Setup Working Directory

Create a working directory for the ebook project:

```bash
mkdir -p youtube-ebook-$(date +%Y%m%d)
cd youtube-ebook-$(date +%Y%m%d)
```

Install required Python packages:

```bash
pip install youtube-transcript-api ebooklib requests
```

---

### Phase 2: Fetch Latest Videos from Channels

Use the YouTube data proxy to get channel info and latest videos.

#### Step 2.1: Get Channel Info

For each channel handle, get the uploads playlist ID:

```bash
curl -X POST "$API_URL/api/data/youtube/channel" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"handle": "mkbhd"}'
```

**Response includes:**
- `channelId`: The channel's unique ID
- `name`: Channel display name
- `uploadsPlaylistId`: Playlist ID for all uploads (needed for next step)

#### Step 2.2: Get Latest Videos

Fetch the most recent videos from the uploads playlist:

```bash
curl -X POST "$API_URL/api/data/youtube/playlistItems" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "playlistId": "UU...",
    "maxResults": 10
  }'
```

**Response includes array of videos with:**
- `videoId`: Unique video ID
- `title`: Video title
- `description`: Video description
- `publishedAt`: Publication date
- `url`: Full YouTube URL

#### Step 2.3: Filter Out Shorts

Get video details to check duration:

```bash
curl -X POST "$API_URL/api/data/youtube/videoDetails" \
  -H "Authorization: Bearer $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"videoIds": "video1,video2,video3"}'
```

Filter out videos where `likelyShort` is true or `durationSeconds` < 60.

**Alternative (more accurate):** Check if the `/shorts/` URL resolves:

```python
import requests

def is_youtube_short(video_id):
    """Check if video is a Short by testing /shorts/ URL."""
    shorts_url = f"https://www.youtube.com/shorts/{video_id}"
    try:
        response = requests.head(shorts_url, allow_redirects=True, timeout=5)
        return "/shorts/" in response.url
    except:
        return False
```

---

### Phase 3: Extract Transcripts

Use the `youtube-transcript-api` library (no API key needed):

```python
from youtube_transcript_api import YouTubeTranscriptApi
import time

def get_transcript(video_id):
    """Get transcript for a YouTube video."""
    try:
        ytt_api = YouTubeTranscriptApi()
        transcript_list = ytt_api.fetch(video_id)

        # Combine segments into full text
        full_text = " ".join(segment.text for segment in transcript_list)
        return full_text.strip()
    except Exception as e:
        print(f"Error getting transcript for {video_id}: {e}")
        return None

# Process videos with rate limiting
videos_with_transcripts = []
for video in videos:
    transcript = get_transcript(video["videoId"])
    if transcript:
        video["transcript"] = transcript
        videos_with_transcripts.append(video)
    time.sleep(2)  # Avoid rate limiting
```

**Important Notes:**
- Add 2-second delays between requests to avoid rate limits
- Some videos may not have transcripts (live streams, music, etc.)
- Auto-generated transcripts may have spelling errors for names/terms

---

### Phase 4: Transform Transcripts to Articles

Use Claude to convert raw transcripts into polished articles.

**Prompt template:**

```
You are a skilled editor transforming video transcripts into magazine-quality articles.

Video Title: {title}
Channel: {channel_name}
Video Description: {description}

Transcript:
{transcript}

Instructions:
1. Write a well-structured article (800-1500 words) based on this transcript
2. Use the video title and description to get correct spellings of names and terms
3. Add a compelling introduction that hooks the reader
4. Organize into clear sections with subheadings
5. Preserve the speaker's key insights and examples
6. End with a conclusion that summarizes the main takeaways
7. Use a conversational but professional tone
8. Do NOT include "In this video..." - write as a standalone article

Output the article in markdown format.
```

---

### Phase 5: Create EPUB Ebook

Use `ebooklib` to package articles into an EPUB:

```python
from ebooklib import epub
import markdown
from datetime import datetime

def create_ebook(articles, title="YouTube Articles"):
    """Create EPUB ebook from articles."""
    book = epub.EpubBook()

    # Set metadata
    book.set_identifier(f'youtube-ebook-{datetime.now().strftime("%Y%m%d%H%M%S")}')
    book.set_title(title)
    book.set_language('en')
    book.add_author('Generated by YouTube to Ebook')

    chapters = []

    for i, article in enumerate(articles):
        # Create chapter
        chapter = epub.EpubHtml(
            title=article['title'],
            file_name=f'chapter_{i+1}.xhtml',
            lang='en'
        )

        # Convert markdown to HTML
        html_content = markdown.markdown(article['content'])

        # Add video link at the end
        html_content += f'''
        <hr/>
        <p><small>
            Original video: <a href="{article['url']}">{article['title']}</a><br/>
            Channel: {article['channel']}
        </small></p>
        '''

        chapter.content = f'<h1>{article["title"]}</h1>{html_content}'
        book.add_item(chapter)
        chapters.append(chapter)

    # Create table of contents
    book.toc = [(epub.Section('Articles'), chapters)]

    # Add navigation files
    book.add_item(epub.EpubNcx())
    book.add_item(epub.EpubNav())

    # Define spine
    book.spine = ['nav'] + chapters

    # Add CSS
    style = '''
    body { font-family: Georgia, serif; line-height: 1.6; margin: 2em; }
    h1 { color: #333; border-bottom: 1px solid #ccc; padding-bottom: 0.5em; }
    h2 { color: #555; margin-top: 1.5em; }
    p { margin: 1em 0; }
    blockquote { border-left: 3px solid #ccc; padding-left: 1em; color: #666; }
    '''
    css = epub.EpubItem(
        uid='style',
        file_name='style.css',
        media_type='text/css',
        content=style
    )
    book.add_item(css)

    # Write to file
    filename = f'{title.replace(" ", "_")}_{datetime.now().strftime("%Y%m%d")}.epub'
    epub.write_epub(filename, book)

    return filename
```

---

## Complete Python Script

Here's a complete script that ties everything together:

```python
#!/usr/bin/env python3
"""
YouTube to Ebook - Transform YouTube videos into EPUB ebooks.
"""

import subprocess
import requests
import json
import time
from youtube_transcript_api import YouTubeTranscriptApi
from ebooklib import epub
import markdown
from datetime import datetime
import anthropic

# Configuration
CHANNELS = [
    "mkbhd",
    "veritasium",
    "3blue1brown",
]
MAX_VIDEOS_PER_CHANNEL = 3

# Get auth
AUTH_TOKEN = subprocess.check_output(["/home/user/.local/bin/rebyte-auth"]).decode().strip()
with open('/home/user/.rebyte.ai/auth.json') as f:
    API_URL = json.load(f)['sandbox']['relay_url']

HEADERS = {"Authorization": f"Bearer {AUTH_TOKEN}", "Content-Type": "application/json"}


def get_channel_uploads_playlist(handle):
    """Get the uploads playlist ID for a channel."""
    response = requests.post(
        f"{API_URL}/api/data/youtube/channel",
        headers=HEADERS,
        json={"handle": handle}
    )
    data = response.json()
    if data.get("success"):
        return {
            "name": data["name"],
            "playlistId": data["uploadsPlaylistId"]
        }
    return None


def get_latest_videos(playlist_id, max_results=10):
    """Get latest videos from a playlist."""
    response = requests.post(
        f"{API_URL}/api/data/youtube/playlistItems",
        headers=HEADERS,
        json={"playlistId": playlist_id, "maxResults": max_results}
    )
    return response.json().get("videos", [])


def is_youtube_short(video_id):
    """Check if video is a YouTube Short."""
    try:
        response = requests.head(
            f"https://www.youtube.com/shorts/{video_id}",
            allow_redirects=True,
            timeout=5
        )
        return "/shorts/" in response.url
    except:
        return False


def get_transcript(video_id):
    """Get transcript for a video."""
    try:
        ytt_api = YouTubeTranscriptApi()
        transcript_list = ytt_api.fetch(video_id)
        return " ".join(segment.text for segment in transcript_list)
    except Exception as e:
        print(f"  No transcript: {e}")
        return None


def transform_to_article(video, transcript):
    """Use Claude to transform transcript into article."""
    client = anthropic.Anthropic()

    prompt = f"""You are a skilled editor transforming video transcripts into magazine-quality articles.

Video Title: {video['title']}
Channel: {video['channelTitle']}
Video Description: {video.get('description', '')[:500]}

Transcript:
{transcript[:15000]}  # Limit transcript length

Instructions:
1. Write a well-structured article (800-1500 words)
2. Use the title and description for correct spellings
3. Add a compelling introduction
4. Organize into clear sections with subheadings
5. Preserve key insights and examples
6. End with a conclusion
7. Use conversational but professional tone
8. Write as a standalone article (no "In this video...")

Output in markdown format."""

    response = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=4000,
        messages=[{"role": "user", "content": prompt}]
    )

    return response.content[0].text


def create_ebook(articles, title="YouTube Articles"):
    """Create EPUB from articles."""
    book = epub.EpubBook()
    book.set_identifier(f'yt-ebook-{datetime.now().strftime("%Y%m%d%H%M%S")}')
    book.set_title(title)
    book.set_language('en')

    chapters = []
    for i, article in enumerate(articles):
        chapter = epub.EpubHtml(
            title=article['title'],
            file_name=f'ch{i+1}.xhtml'
        )
        html = markdown.markdown(article['content'])
        html += f'<hr/><p><small>Source: <a href="{article["url"]}">{article["title"]}</a></small></p>'
        chapter.content = f'<h1>{article["title"]}</h1>{html}'
        book.add_item(chapter)
        chapters.append(chapter)

    book.toc = chapters
    book.add_item(epub.EpubNcx())
    book.add_item(epub.EpubNav())
    book.spine = ['nav'] + chapters

    filename = f'{title.replace(" ", "_")}_{datetime.now().strftime("%Y%m%d")}.epub'
    epub.write_epub(filename, book)
    return filename


def main():
    print("YouTube to Ebook Generator")
    print("=" * 50)

    all_videos = []

    # Step 1: Fetch videos from channels
    for handle in CHANNELS:
        print(f"\nProcessing @{handle}...")

        channel = get_channel_uploads_playlist(handle)
        if not channel:
            print(f"  Channel not found")
            continue

        print(f"  Channel: {channel['name']}")

        videos = get_latest_videos(channel['playlistId'], MAX_VIDEOS_PER_CHANNEL * 2)

        # Filter out Shorts
        for video in videos:
            if len(all_videos) >= MAX_VIDEOS_PER_CHANNEL * len(CHANNELS):
                break
            if not is_youtube_short(video['videoId']):
                video['channelName'] = channel['name']
                all_videos.append(video)
                print(f"  + {video['title'][:50]}...")
                if len([v for v in all_videos if v.get('channelName') == channel['name']]) >= MAX_VIDEOS_PER_CHANNEL:
                    break

    print(f"\nFound {len(all_videos)} long-form videos")

    # Step 2: Get transcripts
    print("\nExtracting transcripts...")
    videos_with_transcripts = []
    for video in all_videos:
        print(f"  {video['title'][:40]}...")
        transcript = get_transcript(video['videoId'])
        if transcript:
            video['transcript'] = transcript
            videos_with_transcripts.append(video)
            print(f"    Got {len(transcript.split())} words")
        time.sleep(2)

    print(f"\nGot transcripts for {len(videos_with_transcripts)} videos")

    # Step 3: Transform to articles
    print("\nWriting articles...")
    articles = []
    for video in videos_with_transcripts:
        print(f"  Writing: {video['title'][:40]}...")
        content = transform_to_article(video, video['transcript'])
        articles.append({
            'title': video['title'],
            'content': content,
            'url': video['url'],
            'channel': video['channelTitle']
        })

    # Step 4: Create EPUB
    print("\nCreating EPUB...")
    filename = create_ebook(articles, "YouTube Digest")
    print(f"\nDone! Created: {filename}")
    print(f"Open with: open {filename}")


if __name__ == "__main__":
    main()
```

---

## Customization Options

### Change Writing Style

Modify the prompt in `transform_to_article()`:
- **Academic**: "Write a formal summary suitable for academic reading"
- **Blog post**: "Write a casual, engaging blog post"
- **Technical**: "Write detailed technical documentation"
- **Summary**: "Write a concise 300-word summary"

### Filter by Date

Add date filtering when fetching videos:
```python
from datetime import datetime, timedelta

# Only videos from last 7 days
cutoff = datetime.now() - timedelta(days=7)
recent_videos = [
    v for v in videos
    if datetime.fromisoformat(v['publishedAt'].replace('Z', '+00:00')) > cutoff
]
```

### Add Cover Image

```python
# Add cover to EPUB
with open('cover.jpg', 'rb') as f:
    book.set_cover('cover.jpg', f.read())
```

---

## Troubleshooting

### "No transcript available"

Some videos don't have transcripts:
- Live streams
- Music videos
- Videos with disabled captions

**Solution:** Skip these videos and continue with others.

### Rate limiting on transcripts

**Solution:** The script includes 2-second delays. Increase if needed:
```python
time.sleep(5)  # 5 seconds between requests
```

### Names misspelled in transcripts

Auto-generated transcripts often misspell names.

**Solution:** The video title and description are passed to Claude, which usually contain correct spellings.

### Transcript API syntax errors

The API syntax changed recently.

**Correct usage:**
```python
ytt_api = YouTubeTranscriptApi()
transcript = ytt_api.fetch(video_id)  # Instance method
```

---

## API Reference

### YouTube Data Proxy Endpoints

| Endpoint | Purpose |
|----------|---------|
| `POST /api/data/youtube/channel` | Get channel info by handle |
| `POST /api/data/youtube/playlistItems` | Get videos from playlist |
| `POST /api/data/youtube/videoDetails` | Get video details (duration, stats) |
| `POST /api/data/youtube/search` | Search YouTube |

All endpoints require `Authorization: Bearer $AUTH_TOKEN` header.

---

## Error Handling

All API responses include a `success` field. When `success: false`, the response contains:

| Field | Description |
|-------|-------------|
| `error` | Short error code (e.g., `channel_not_found`) |
| `message` | Human-readable explanation |
| `fix` | Actionable instruction to resolve the issue |
| `example` | Working example (when applicable) |

### Common Error Codes

#### Channel Operation

| Error Code | Cause | Fix |
|------------|-------|-----|
| `missing_handle` | No handle provided | Provide the channel handle parameter |
| `invalid_handle_format` | Handle contains invalid characters | Use only letters, numbers, underscores, dots, hyphens |
| `channel_not_found` | Channel doesn't exist | Verify the handle at youtube.com/@HANDLE |
| `no_uploads_playlist` | Channel has no public videos | Try a different channel |

#### PlaylistItems Operation

| Error Code | Cause | Fix |
|------------|-------|-----|
| `missing_playlist_id` | No playlist ID provided | First call `channel` to get `uploadsPlaylistId` |
| `invalid_max_results` | maxResults out of range | Use value between 1-50 |
| `not_found` | Playlist doesn't exist or is private | Verify the playlist ID |

#### VideoDetails Operation

| Error Code | Cause | Fix |
|------------|-------|-----|
| `missing_video_ids` | No video IDs provided | Get video IDs from `playlistItems` response |
| `no_valid_video_ids` | All IDs are invalid format | Video IDs are typically 11 characters |
| `too_many_video_ids` | More than 50 IDs | Split into batches of 50 |

#### General Errors

| Error Code | Cause | Fix |
|------------|-------|-----|
| `quota_exceeded` | YouTube API daily limit reached | Wait until midnight Pacific Time |
| `rate_limited` | Too many requests | Wait a few seconds, retry |
| `authentication_error` | API key issue | Contact administrator |
| `network_error` | Connection failed | Check network, retry |

### Error Handling Example

```python
def get_channel_safe(handle):
    """Get channel with proper error handling."""
    response = requests.post(
        f"{API_URL}/api/data/youtube/channel",
        headers=HEADERS,
        json={"handle": handle}
    )
    data = response.json()

    if not data.get("success"):
        error = data.get("error", "unknown")
        message = data.get("message", "Unknown error")
        fix = data.get("fix", "")

        if error == "channel_not_found":
            print(f"Channel @{handle} not found. {fix}")
            return None
        elif error == "quota_exceeded":
            print(f"API quota exceeded. {fix}")
            raise Exception("Quota exceeded - try again tomorrow")
        else:
            print(f"Error: {message}")
            print(f"Fix: {fix}")
            return None

    return data
```

---

## Example Output

The generated EPUB contains:
- Table of contents with all articles
- Clean, readable formatting
- Original video links for reference
- Mobile-friendly styling

Perfect for reading on Kindle, Apple Books, or any EPUB reader.
