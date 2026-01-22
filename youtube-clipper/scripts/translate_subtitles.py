#!/usr/bin/env python3
"""
Translate subtitles
Batch translation optimization: translate 20 subtitles at once, saving 95% API calls
"""

import sys
import json
from pathlib import Path
from typing import List, Dict

from utils import seconds_to_time


def translate_subtitles_batch(
    subtitles: List[Dict],
    batch_size: int = 20,
    target_lang: str = "Chinese"
) -> List[Dict]:
    """
    Batch translate subtitles

    Note: This function should be called within Claude Code Skill environment
    Claude will automatically handle translation logic

    Args:
        subtitles: Subtitle list (each item contains {start, end, text})
        batch_size: Number of subtitles to translate per batch
        target_lang: Target language

    Returns:
        List[Dict]: Translated subtitle list, each item contains {start, end, text, translation}
    """
    print(f"\nStarting subtitle translation...")
    print(f"   Total count: {len(subtitles)}")
    print(f"   Batch size: {batch_size}")
    print(f"   Target language: {target_lang}")

    # Prepare batch translation data
    batches = []
    for i in range(0, len(subtitles), batch_size):
        batch = subtitles[i:i + batch_size]
        batches.append(batch)

    print(f"   Split into {len(batches)} batches")

    # Output text to translate (for Claude to process)
    print("\n" + "="*60)
    print("Subtitles to translate (JSON format):")
    print("="*60)
    print(json.dumps(subtitles, indent=2, ensure_ascii=False))

    print("\n" + "="*60)
    print("Translation requirements:")
    print("="*60)
    print(f"""
Please translate the above subtitles to {target_lang}.

Translation requirements:
1. Maintain technical term accuracy
2. Conversational expression (suitable for short videos)
3. Concise and fluent (avoid verbosity)
4. Preserve original meaning, do not add or remove content

Output format (JSON):
[
  {{"start": 0.0, "end": 3.5, "text": "original", "translation": "translated"}},
  {{"start": 3.5, "end": 7.2, "text": "original", "translation": "translated"}},
  ...
]

Please translate in batches of {batch_size}.
""")

    # Note: Actual translation is done by Claude when Skill executes
    # This script only prepares data and provides interface
    # Return placeholder data
    translated_subtitles = []
    for sub in subtitles:
        translated_subtitles.append({
            'start': sub['start'],
            'end': sub['end'],
            'text': sub['text'],
            'translation': '[pending translation]'  # Claude will replace at runtime
        })

    return translated_subtitles


def create_bilingual_subtitles(
    subtitles: List[Dict],
    output_path: str,
    english_first: bool = True
) -> str:
    """
    Create bilingual subtitle file (SRT format)

    Args:
        subtitles: Subtitle list (contains text and translation)
        output_path: Output file path
        english_first: English on top (True) or target language on top (False)

    Returns:
        str: Output file path
    """
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    print(f"\nGenerating bilingual subtitle file...")
    print(f"   Output: {output_path}")
    print(f"   Order: {'English on top, translation below' if english_first else 'Translation on top, English below'}")

    with open(output_path, 'w', encoding='utf-8') as f:
        for i, sub in enumerate(subtitles, 1):
            # SRT sequence number
            f.write(f"{i}\n")

            # SRT timestamp
            start_time = seconds_to_time(sub['start'], include_hours=True, use_comma=True)
            end_time = seconds_to_time(sub['end'], include_hours=True, use_comma=True)
            f.write(f"{start_time} --> {end_time}\n")

            # Bilingual text
            english = sub['text']
            translation = sub.get('translation', '[not translated]')

            if english_first:
                f.write(f"{english}\n{translation}\n")
            else:
                f.write(f"{translation}\n{english}\n")

            # Blank line separator
            f.write("\n")

    print(f"Bilingual subtitles saved: {output_path}")
    return str(output_path)


def load_subtitles_from_srt(srt_path: str) -> List[Dict]:
    """
    Load subtitles from SRT file

    Args:
        srt_path: SRT file path

    Returns:
        List[Dict]: Subtitle list
    """
    try:
        import pysrt
    except ImportError:
        print("Error: pysrt not installed")
        print("Please install: pip install pysrt")
        sys.exit(1)

    srt_path = Path(srt_path)
    if not srt_path.exists():
        raise FileNotFoundError(f"SRT file not found: {srt_path}")

    print(f"Loading SRT subtitles: {srt_path.name}")

    subs = pysrt.open(srt_path)
    subtitles = []

    for sub in subs:
        # Convert time to seconds
        start = sub.start.hours * 3600 + sub.start.minutes * 60 + sub.start.seconds + sub.start.milliseconds / 1000
        end = sub.end.hours * 3600 + sub.end.minutes * 60 + sub.end.seconds + sub.end.milliseconds / 1000

        subtitles.append({
            'start': start,
            'end': end,
            'text': sub.text.replace('\n', ' ')  # Merge multi-line
        })

    print(f"   Found {len(subtitles)} subtitles")
    return subtitles


def main():
    """Command line entry point"""
    if len(sys.argv) < 2:
        print("Usage: python translate_subtitles.py <subtitle_file> [output_file] [batch_size]")
        print("\nArguments:")
        print("  subtitle_file - Subtitle file path (SRT format)")
        print("  output_file   - Output file path (optional, default: <original_name>_bilingual.srt)")
        print("  batch_size    - Number of subtitles per batch (optional, default 20)")
        print("\nExample:")
        print("  python translate_subtitles.py subtitle.srt")
        print("  python translate_subtitles.py subtitle.srt bilingual.srt")
        print("  python translate_subtitles.py subtitle.srt bilingual.srt 30")
        print("\nNote:")
        print("  When running in Claude Code Skill, Claude will automatically handle translation")
        print("  When running standalone, outputs data for manual processing")
        sys.exit(1)

    subtitle_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    batch_size = int(sys.argv[3]) if len(sys.argv) > 3 else 20

    try:
        # Load subtitles
        subtitles = load_subtitles_from_srt(subtitle_file)

        if not subtitles:
            print("No valid subtitles found")
            sys.exit(1)

        # Translate subtitles (prepare data)
        translated = translate_subtitles_batch(subtitles, batch_size)

        # Set output path
        if output_file is None:
            subtitle_path = Path(subtitle_file)
            output_file = subtitle_path.parent / f"{subtitle_path.stem}_bilingual.srt"

        # Create bilingual subtitles
        # Note: In actual use, Claude will complete translation first, then call this function
        print("\nNote: This script should be run in Claude Code Skill")
        print("   Claude will automatically handle translation logic")
        print("   Currently only outputting data for translation")

    except Exception as e:
        print(f"\nError: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
