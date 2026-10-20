#!/usr/bin/env python3
"""Prepare Spotlight 2 Part 1 Letter Blends audio clips locally.

Usage:
    python3 tool/prepare_spotlight_letter_blends.py /path/to/official_part1.zip

The official archive remains local and is never committed. The script extracts
short clips used by the app to assets/audio/spotlight2_part1/.

Mapped from the official Part 1 audio:
  track 10, p.12: SH — sheep, fish, ship
  track 11, p.13: CH — chick, cheese
  track 12, p.14: TH — thumb, thimble, the, this
  track 13, p.15: PH — photo, dolphin, elephant
"""

from __future__ import annotations

import json
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets" / "audio" / "spotlight2_part1"

TRACKS = {
    "sh": "Letter Blends!/10 Letter Blends! D. Ex. 1, p. 12.mp3",
    "ch": "Letter Blends!/11 Letter Blends! D. Ex. 3, p. 13.mp3",
    "th": "Letter Blends!/12 Letter Blends! E. Ex. 1, p. 14.mp3",
    "ph": "Letter Blends!/13 Letter Blends! E. Ex. 3, p. 15.mp3",
}

# start/end in seconds. Boundaries are aligned to the quiet gaps in the
# official tracks, with a small safety margin so final consonants are not cut.
CLIPS = [
    # Track 10: the isolated SH sound is BEFORE the spoken word "repeat".
    ("phoneme_sh.mp3", "sh", 15.30, 15.95, "blend", "SH /ʃ/"),
    ("word_sheep.mp3", "sh", 19.03, 19.96, "word", "sheep"),
    ("word_fish.mp3", "sh", 22.87, 23.61, "word", "fish"),
    ("word_ship.mp3", "sh", 26.58, 27.31, "word", "ship"),

    # Track 11: likewise, CH is immediately before "repeat".
    ("phoneme_ch.mp3", "ch", 13.41, 14.05, "blend", "CH /tʃ/"),
    ("word_chick.mp3", "ch", 17.22, 17.87, "word", "chick"),
    ("word_cheese.mp3", "ch", 21.47, 22.45, "word", "cheese"),

    # Track 12 contains the example words themselves (no separate isolated TH
    # clip), so the lesson uses thumb/this as the official pronunciation model.
    ("word_thumb.mp3", "th", 3.30, 4.02, "word", "thumb"),
    ("word_thimble.mp3", "th", 4.27, 5.42, "word", "thimble"),
    ("word_the.mp3", "th", 6.37, 7.04, "word", "the"),
    ("word_this.mp3", "th", 8.45, 9.24, "word", "this"),

    # Track 13: PH words from the textbook exercise.
    ("word_photo.mp3", "ph", 16.18, 16.94, "word", "photo"),
    ("word_dolphin.mp3", "ph", 20.36, 21.20, "word", "dolphin"),
    ("word_elephant.mp3", "ph", 24.50, 25.43, "word", "elephant"),
]


def cut(source: Path, target: Path, start: float, end: float) -> None:
    """Cut accurately and re-encode so short consonants are not lost."""
    target.parent.mkdir(parents=True, exist_ok=True)
    duration = end - start
    subprocess.run(
        [
            "ffmpeg", "-hide_banner", "-loglevel", "error", "-y",
            "-i", str(source),
            "-ss", f"{start:.3f}",
            "-t", f"{duration:.3f}",
            "-vn", "-codec:a", "libmp3lame", "-q:a", "2", str(target),
        ],
        check=True,
    )


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 tool/prepare_spotlight_letter_blends.py <official_part1.zip>")

    archive = Path(sys.argv[1]).expanduser().resolve()
    if not archive.is_file():
        raise SystemExit(f"Archive not found: {archive}")
    if shutil.which("ffmpeg") is None:
        raise SystemExit("ffmpeg is required")

    OUT.mkdir(parents=True, exist_ok=True)
    manifest = []

    with tempfile.TemporaryDirectory(prefix="spotlight2_") as temp_name:
        temp = Path(temp_name)
        with zipfile.ZipFile(archive) as zf:
            for source_name in TRACKS.values():
                try:
                    zf.extract(source_name, temp)
                except KeyError as exc:
                    raise SystemExit(f"Required track is missing: {source_name}") from exc

        for file_name, track_key, start, end, kind, value in CLIPS:
            source_name = TRACKS[track_key]
            source = temp / source_name
            target = OUT / file_name
            cut(source, target, start, end)
            manifest.append({
                "file": file_name,
                "kind": kind,
                "value": value,
                "source": source_name,
                "start": start,
                "end": end,
            })
            print(f"created {target.relative_to(ROOT)}")

    (OUT / "letter_blends_manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Prepared {len(CLIPS)} official Spotlight Letter Blends clips.")


if __name__ == "__main__":
    main()
