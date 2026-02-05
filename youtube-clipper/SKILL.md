---
name: youtube-clipper
description: AI-powered YouTube video clipper. Download videos and subtitles, AI analyzes content to generate fine-grained chapters (2-5 minutes each), user selects segments for clipping, translates subtitles to bilingual format, burns subtitles into video, and generates summaries. Use when user needs to clip YouTube videos, create short video segments, or make bilingual subtitle versions.
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - AskUserQuestion
model: claude-sonnet-4-5-20250514
---

# YouTube Video Smart Clipper

> **Installation**: If you're installing this skill from GitHub, please refer to [README.md](README.md#installation) for installation instructions.

## Workflow

You will execute the YouTube video clipping task in the following 6 phases:

### Phase 1: Environment Check

**Goal**: Ensure all required tools and dependencies are installed

1. Check if yt-dlp is available
   ```bash
   yt-dlp --version
   ```

2. Check FFmpeg version and libass support
   ```bash
   # Check for ffmpeg-full first (macOS)
   /opt/homebrew/opt/ffmpeg-full/bin/ffmpeg -version

   # Check standard FFmpeg
   ffmpeg -version

   # Verify libass support (required for subtitle burning)
   ffmpeg -filters 2>&1 | grep subtitles
   ```

3. Check Python dependencies
   ```bash
   python3 -c "import yt_dlp; print('yt-dlp available')"
   python3 -c "import pysrt; print('pysrt available')"
   ```

**If environment check fails**:
- yt-dlp not installed: Suggest `brew install yt-dlp` or `pip install yt-dlp`
- FFmpeg without libass: Suggest installing ffmpeg-full
  ```bash
  brew install ffmpeg-full  # macOS
  ```
- Python dependencies missing: Suggest `pip install pysrt python-dotenv`

**Note**:
- Standard Homebrew FFmpeg does not include libass, cannot burn subtitles
- ffmpeg-full path: `/opt/homebrew/opt/ffmpeg-full/bin/ffmpeg` (Apple Silicon)
- Must pass environment check before continuing

---

### Phase 2: Download Video

**Goal**: Download YouTube video and English subtitles

1. Ask user for YouTube URL

2. Call download_video.py script
   ```bash
   cd ~/.claude/skills/youtube-clipper
   python3 scripts/download_video.py <youtube_url>
   ```

3. The script will:
   - Download video (up to 1080p, mp4 format)
   - Download English subtitles (VTT format, auto-generated as fallback)
   - Output file paths and video information

4. Show user:
   - Video title
   - Video duration
   - File size
   - Download path

**Output**:
- Video file: `<id>.mp4` (uses video ID for naming to avoid special character issues)
- Subtitle file: `<id>.en.vtt`

---

### Phase 3: Chapter Analysis (Core Differentiating Feature)

**Goal**: Use Claude AI to analyze subtitle content and generate fine-grained chapters (2-5 minute intervals)

1. Call analyze_subtitles.py to parse VTT subtitles
   ```bash
   python3 scripts/analyze_subtitles.py <subtitle_path>
   ```

2. The script will output structured subtitle data:
   - Complete subtitle text (with timestamps)
   - Total duration
   - Subtitle count

3. **You need to perform AI analysis** (this is the most critical step):
   - Read the complete subtitle content
   - Understand content semantics and topic transition points
   - Identify natural topic switching positions
   - Generate chapters at 2-5 minute granularity (avoid 30-minute coarse splitting)

4. For each chapter, generate:
   - **Title**: Concise topic summary (10-20 words)
   - **Time Range**: Start and end time (format: MM:SS or HH:MM:SS)
   - **Core Summary**: 1-2 sentences explaining what this segment covers (50-100 words)
   - **Keywords**: 3-5 core concept words

5. **Chapter generation principles**:
   - Granularity: Each chapter should be 2-5 minutes (avoid too short or too long)
   - Completeness: Ensure all video content is covered, no gaps
   - Meaningful: Each chapter is a relatively independent topic
   - Natural splits: Split at topic transition points, not mechanically by time

6. Show chapter list to user:
   ```
   Analysis complete, generated X chapters:

   1. [00:00 - 03:15] AGI is Not a Point in Time, It's an Exponential Curve
      Core: AI model capabilities double every 4-12 months, engineers use Claude for coding
      Keywords: AGI, exponential growth, Claude Code

   2. [03:15 - 06:30] China's Gap in AI Development
      Core: Chip ban constrains China, DeepSeek benchmark optimization doesn't reflect true capability
      Keywords: China, chip ban, DeepSeek

   ... (all chapters)

   All content covered, no gaps
   ```

---

### Phase 4: User Selection

**Goal**: Let user select chapters to clip and processing options

1. Use AskUserQuestion tool to let user select chapters
   - Provide chapter numbers for selection
   - Support multi-select (can select multiple chapters)

2. Ask about processing options:
   - Generate bilingual subtitles? (English + Chinese)
   - Burn subtitles into video? (hardcoded subtitles)
   - Generate summary content?

3. Confirm user selection and show processing plan

---

### Phase 5: Clipping Processing (Core Execution Phase)

**Goal**: Execute multiple processing tasks in parallel

For each user-selected chapter, execute the following steps:

#### 5.1 Clip Video Segment
```bash
python3 scripts/clip_video.py <video_path> <start_time> <end_time> <output_path>
```
- Use FFmpeg for precise clipping
- Maintain original video quality
- Output: `<chapter_title>_clip.mp4`

#### 5.2 Extract Subtitle Segment
- Filter subtitles from the complete file for this time range
- Adjust timestamps (subtract start time, begin from 00:00:00)
- Convert to SRT format
- Output: `<chapter_title>_original.srt`

#### 5.3 Translate Subtitles (if user selected)
```bash
python3 scripts/translate_subtitles.py <subtitle_path>
```
- **Batch translation optimization**: Translate 20 subtitle lines at once (saves 95% API calls)
- Translation strategy:
  - Maintain technical term accuracy
  - Conversational expression (suitable for short videos)
  - Concise and fluent (avoid verbosity)
- Output: `<chapter_title>_translated.srt`

#### 5.4 Generate Bilingual Subtitle File (if user selected)
- Merge English and Chinese subtitles
- Format: SRT bilingual (each subtitle contains English and Chinese)
- Style: English on top, Chinese below
- Output: `<chapter_title>_bilingual.srt`

#### 5.5 Burn Subtitles into Video (if user selected)
```bash
python3 scripts/burn_subtitles.py <video_path> <subtitle_path> <output_path>
```
- Use ffmpeg-full (libass support)
- **Use temporary directory to solve path space issues** (critical!)
- Subtitle style:
  - Font size: 24
  - Bottom margin: 30
  - Color: White text + black outline
- Output: `<chapter_title>_with_subtitles.mp4`

#### 5.6 Generate Summary Content (if user selected)
```bash
python3 scripts/generate_summary.py <chapter_info>
```
- Based on chapter title, summary, and keywords
- Generate social media-friendly content
- Includes: Title, core points, suitable platforms (Twitter, LinkedIn, etc.)
- Output: `<chapter_title>_summary.md`

**Progress display**:
```
Starting processing chapter 1/3: AGI is Not a Point in Time, It's an Exponential Curve

1/6 Clipping video segment... Done
2/6 Extracting subtitle segment... Done
3/6 Translating subtitles... [=====>    ] 50% (26/52)
4/6 Generating bilingual subtitle file... Done
5/6 Burning subtitles into video... Done
6/6 Generating summary content... Done

Chapter 1 processing complete
```

---

### Phase 6: Output Results

**Goal**: Organize output files and present to user

1. Create output directory
   ```
   ./youtube-clips/<datetime>/
   ```
   Output directory is under the current working directory

2. Organize file structure:
   ```
   <chapter_title>/
   ├── <chapter_title>_clip.mp4              # Original clip (no subtitles)
   ├── <chapter_title>_with_subtitles.mp4    # Burned subtitle version
   ├── <chapter_title>_bilingual.srt         # Bilingual subtitle file
   └── <chapter_title>_summary.md            # Summary content
   ```

3. Upload the video clips and subtitle files to the Artifact Store so the user can access them.

4. Show user:
   - File list (with file sizes)
   - Quick preview command

   ```
   Processing complete!

   Output directory: ./youtube-clips/20260121_143022/

   File list:
     AGI_Exponential_Curve_bilingual_subtitles.mp4 (14 MB)
     AGI_Exponential_Curve_bilingual.srt (2.3 KB)
     AGI_Exponential_Curve_summary.md (3.2 KB)

   Quick preview:
   open ./youtube-clips/20260121_143022/AGI_Exponential_Curve_bilingual_subtitles.mp4
   ```

4. Ask if user wants to continue clipping other chapters
   - If yes, return to Phase 4 (user selection)
   - If no, end Skill

---

## Key Technical Points

### 1. FFmpeg Path Space Issue
**Problem**: FFmpeg subtitles filter cannot correctly parse paths containing spaces

**Solution**: burn_subtitles.py uses temporary directory
- Create temporary directory without spaces
- Copy files to temporary directory
- Execute FFmpeg
- Move output file back to target location

### 2. Batch Translation Optimization
**Problem**: Translating one by one produces many API calls

**Solution**: Translate 20 subtitle lines at once
- Saves 95% API calls
- Improves translation speed
- Maintains translation consistency

### 3. Chapter Analysis Granularity
**Goal**: Generate chapters at 2-5 minute granularity, avoid 30-minute coarse splitting

**Method**:
- Understand subtitle semantics, identify topic transitions
- Find natural topic switching points
- Ensure each chapter has complete discussion
- Avoid mechanical time-based splitting

### 4. FFmpeg vs ffmpeg-full
**Difference**:
- Standard FFmpeg: No libass support, cannot burn subtitles
- ffmpeg-full: Includes libass, supports subtitle burning

**Path**:
- Standard: `/opt/homebrew/bin/ffmpeg`
- ffmpeg-full: `/opt/homebrew/opt/ffmpeg-full/bin/ffmpeg` (Apple Silicon)

---

## Error Handling

### Environment Issues
- Missing tools -> Provide installation commands
- FFmpeg without libass -> Guide to install ffmpeg-full
- Python dependencies missing -> Suggest pip install

### Download Issues
- Invalid URL -> Prompt to check URL format
- Subtitles missing -> Try auto-generated subtitles
- Network error -> Prompt to retry

### Processing Issues
- FFmpeg execution failed -> Show detailed error message
- Translation failed -> Retry mechanism (up to 3 times)
- Insufficient disk space -> Prompt to free up space

---

## Output File Naming Convention

- Video segment: `<chapter_title>_clip.mp4`
- Subtitle file: `<chapter_title>_bilingual.srt`
- Burned version: `<chapter_title>_with_subtitles.mp4`
- Summary content: `<chapter_title>_summary.md`

**Filename handling**:
- Remove special characters (`/`, `\`, `:`, `*`, `?`, `"`, `<`, `>`, `|`)
- Replace spaces with underscores
- Limit length (maximum 100 characters)

---

## User Experience Points

1. **Progress visibility**: Show progress and status for each step
2. **Error-friendly**: Clear error messages and solutions
3. **Controllability**: User selects chapters to clip and processing options
4. **High quality**: Meaningful chapter analysis, accurate and fluent translation
5. **Completeness**: Provide both original and processed versions

---

## Start Execution

When user triggers this Skill:
1. Immediately start Phase 1 (environment check)
2. Execute 6 phases in sequence
3. Automatically proceed to next phase after each phase completes
4. Provide clear solutions when encountering problems
5. Show complete output results at the end

Remember: The core value of this Skill is **AI fine-grained chapter analysis** and **seamless technical processing**, allowing users to quickly extract high-quality short video segments from long videos.
