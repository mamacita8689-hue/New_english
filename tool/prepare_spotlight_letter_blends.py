#!/usr/bin/env python3
"""Prepare Spotlight 2 Part 1 Letter Blends word clips locally.

Usage:
    python3 tool/prepare_spotlight_letter_blends.py /path/to/official_part1.zip

The archive stays local. This version uses the actual order of the official
recordings and keeps generous silence margins so quiet initial consonants are
not clipped.

Official mapping used by the app:
  p.12 Ex.1: sheep, fish, ship
  p.13 Ex.3: chick, cheese
  p.14 Ex.1: thumb, thimble, the, this
  p.15 Ex.3: photo, dolphin, elephant

Files use a v4 suffix so the browser cannot reuse older incorrect audio.
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
OUT = ROOT / 'assets' / 'audio' / 'spotlight2_part1'

TRACKS = {
    'sh': 'Letter Blends!/10 Letter Blends! D. Ex. 1, p. 12.mp3',
    'ch': 'Letter Blends!/11 Letter Blends! D. Ex. 3, p. 13.mp3',
    'th': 'Letter Blends!/12 Letter Blends! E. Ex. 1, p. 14.mp3',
    'ph': 'Letter Blends!/13 Letter Blends! E. Ex. 3, p. 15.mp3',
}

# (filename, track, speech_start, speech_end, word, pad_before, pad_after)
# Extra pre-roll is intentional for weak fricatives such as /f/ and /θ/.
CLIPS = [
    ('word_sheep_v4.mp3', 'sh', 19.095624, 19.880975, 'sheep', 0.35, 0.35),
    ('word_fish_v4.mp3', 'sh', 22.931361, 23.540907, 'fish', 0.65, 0.35),
    ('word_ship_v4.mp3', 'sh', 26.646916, 27.223039, 'ship', 0.40, 0.35),

    ('word_chick_v4.mp3', 'ch', 17.281224, 17.838073, 'chick', 0.35, 0.35),
    ('word_cheese_v4.mp3', 'ch', 21.533946, 22.394059, 'cheese', 0.35, 0.35),

    # Track 12: one instruction phrase followed by the four textbook words.
    ('word_thumb_v4.mp3', 'th', 3.360167, 3.945812, 'thumb', 0.35, 0.30),
    ('word_thimble_v4.mp3', 'th', 4.329292, 5.336646, 'thimble', 0.25, 0.35),
    ('word_the_v4.mp3', 'th', 6.430396, 6.977083, 'the', 0.35, 0.40),
    ('word_this_v4.mp3', 'th', 8.529167, 9.170958, 'this', 0.35, 0.35),

    ('word_photo_v4.mp3', 'ph', 16.243923, 16.875556, 'photo', 0.40, 0.35),
    ('word_dolphin_v4.mp3', 'ph', 20.420204, 21.155601, 'dolphin', 0.35, 0.35),
    ('word_elephant_v4.mp3', 'ph', 24.557755, 25.391814, 'elephant', 0.35, 0.35),
]

BLEND_WORDS = [
    'sheep', 'fish', 'ship', 'chick', 'cheese',
    'thumb', 'thimble', 'the', 'this',
    'photo', 'dolphin', 'elephant',
]


def old_names() -> list[str]:
    names: list[str] = []
    for word in BLEND_WORDS:
        names.append(f'word_{word}.mp3')
        names.append(f'word_{word}_v2.mp3')
        names.append(f'word_{word}_v3.mp3')
    names += ['phoneme_sh.mp3', 'phoneme_ch.mp3', 'phoneme_ph.mp3']
    return names


def cut(
    source: Path,
    target: Path,
    speech_start: float,
    speech_end: float,
    pad_before: float,
    pad_after: float,
) -> tuple[float, float]:
    start = max(0.0, speech_start - pad_before)
    end = speech_end + pad_after
    target.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        [
            'ffmpeg', '-hide_banner', '-loglevel', 'error', '-y',
            '-i', str(source),
            '-ss', f'{start:.6f}',
            '-t', f'{end - start:.6f}',
            '-vn', '-codec:a', 'libmp3lame', '-q:a', '2', str(target),
        ],
        check=True,
    )
    return start, end


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit(
            'Usage: python3 tool/prepare_spotlight_letter_blends.py <official_part1.zip>'
        )

    archive = Path(sys.argv[1]).expanduser().resolve()
    if not archive.is_file():
        raise SystemExit(f'Archive not found: {archive}')
    if shutil.which('ffmpeg') is None:
        raise SystemExit('ffmpeg is required')

    OUT.mkdir(parents=True, exist_ok=True)

    for name in old_names():
        path = OUT / name
        if path.exists():
            path.unlink()
            print(f'removed old {path.relative_to(ROOT)}')

    manifest = []
    with tempfile.TemporaryDirectory(prefix='spotlight2_blends_') as tmp_name:
        tmp = Path(tmp_name)
        with zipfile.ZipFile(archive) as zf:
            for source_name in TRACKS.values():
                try:
                    zf.extract(source_name, tmp)
                except KeyError as exc:
                    raise SystemExit(f'Required track is missing: {source_name}') from exc

        for file_name, track_key, speech_start, speech_end, word, before, after in CLIPS:
            source_name = TRACKS[track_key]
            source = tmp / source_name
            target = OUT / file_name
            start, end = cut(source, target, speech_start, speech_end, before, after)
            manifest.append({
                'file': file_name,
                'kind': 'word',
                'value': word,
                'source': source_name,
                'speech_start': speech_start,
                'speech_end': speech_end,
                'clip_start': round(start, 6),
                'clip_end': round(end, 6),
                'verified': True,
            })
            print(f'created {target.relative_to(ROOT)} <- {word}')

    (OUT / 'letter_blends_manifest.json').write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + '\n',
        encoding='utf-8',
    )
    print(f'Prepared {len(CLIPS)} cache-safe Spotlight blend words (v4).')


if __name__ == '__main__':
    main()
