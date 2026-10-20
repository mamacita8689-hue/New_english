#!/usr/bin/env python3
"""Prepare verified Spotlight 2 Part 1 Letter Blends word clips locally.

Usage:
    python3 tool/prepare_spotlight_letter_blends.py /path/to/official_part1.zip

Important:
- The official tracks 10, 11 and 13 contain the exercise instruction
  ("Listen and repeat") followed by WORDS. They do not provide a clean,
  isolated SH/CH/PH phoneme recording.
- Track 12 contains the four TH example words.
- Therefore this script creates ONLY verified official word clips. It never
  labels a piece of the instruction as a phoneme.
- Old experimental phoneme_sh/ch/ph files are deleted so the app cannot play
  stale/mislabelled audio.

Verified textbook mapping:
  track 10, p.12: sheep, fish, ship
  track 11, p.13: chick, cheese
  track 12, p.14: thumb, thimble, the, this
  track 13, p.15: photo, dolphin, elephant
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

# Speech intervals were checked against silence boundaries in the official
# archive and against the order printed in Spotlight 2. Padding is added in
# cut() so stops such as the final /p/ in "sheep" are not clipped.
CLIPS = [
    ("word_sheep.mp3", "sh", 19.080, 19.950, "sheep"),
    ("word_fish.mp3", "sh", 22.930, 23.660, "fish"),
    ("word_ship.mp3", "sh", 26.640, 27.300, "ship"),

    ("word_chick.mp3", "ch", 17.280, 17.870, "chick"),
    ("word_cheese.mp3", "ch", 21.530, 22.390, "cheese"),

    ("word_thumb.mp3", "th", 3.320, 3.960, "thumb"),
    ("word_thimble.mp3", "th", 4.300, 5.360, "thimble"),
    ("word_the.mp3", "th", 6.370, 6.990, "the"),
    ("word_this.mp3", "th", 8.490, 9.220, "this"),

    ("word_photo.mp3", "ph", 16.240, 16.880, "photo"),
    ("word_dolphin.mp3", "ph", 20.420, 21.160, "dolphin"),
    ("word_elephant.mp3", "ph", 24.560, 25.390, "elephant"),
]

STALE_EXPERIMENTAL_FILES = (
    "phoneme_sh.mp3",
    "phoneme_ch.mp3",
    "phoneme_ph.mp3",
)


def cut(
    source: Path,
    target: Path,
    start: float,
    end: float,
    pad_before: float = 0.12,
    pad_after: float = 0.30,
) -> tuple[float, float]:
    """Accurately cut and re-encode a word with safe consonant margins."""
    real_start = max(0.0, start - pad_before)
    real_end = end + pad_after
    duration = real_end - real_start
    target.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        [
            "ffmpeg", "-hide_banner", "-loglevel", "error", "-y",
            "-i", str(source),
            "-ss", f"{real_start:.3f}",
            "-t", f"{duration:.3f}",
            "-vn", "-codec:a", "libmp3lame", "-q:a", "2", str(target),
        ],
        check=True,
    )
    return real_start, real_end


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit(
            "Usage: python3 tool/prepare_spotlight_letter_blends.py <official_part1.zip>"
        )

    archive = Path(sys.argv[1]).expanduser().resolve()
    if not archive.is_file():
        raise SystemExit(f"Archive not found: {archive}")
    if shutil.which("ffmpeg") is None:
        raise SystemExit("ffmpeg is required")

    OUT.mkdir(parents=True, exist_ok=True)

    # Never let stale experimental cuts masquerade as isolated phonemes.
    for name in STALE_EXPERIMENTAL_FILES:
        path = OUT / name
        if path.exists():
            path.unlink()
            print(f"removed stale {path.relative_to(ROOT)}")

    manifest = []
    with tempfile.TemporaryDirectory(prefix="spotlight2_") as temp_name:
        temp = Path(temp_name)
        with zipfile.ZipFile(archive) as zf:
            for source_name in TRACKS.values():
                try:
                    zf.extract(source_name, temp)
                except KeyError as exc:
                    raise SystemExit(f"Required track is missing: {source_name}") from exc

        for file_name, track_key, start, end, word in CLIPS:
            source_name = TRACKS[track_key]
            source = temp / source_name
            target = OUT / file_name
            real_start, real_end = cut(source, target, start, end)
            manifest.append({
                "file": file_name,
                "kind": "word",
                "value": word,
                "source": source_name,
                "speech_start": start,
                "speech_end": end,
                "clip_start": round(real_start, 3),
                "clip_end": round(real_end, 3),
                "verified": True,
            })
            print(f"created {target.relative_to(ROOT)} <- {word}")

    (OUT / "letter_blends_manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Prepared {len(CLIPS)} verified official Spotlight word clips.")
    print("No isolated SH/CH/PH phoneme was taken from the instruction audio.")


if __name__ == "__main__":
    main()
