#!/usr/bin/env python3
"""Prepare verified Spotlight 2 Part 1 Letter Blends word clips locally.

Usage:
    python3 tool/prepare_spotlight_letter_blends.py /path/to/official_part1.zip

Verified source mapping:
  p.12 Ex.1: sheep, fish, ship
  p.13 Ex.3: chick, cheese
  p.14 Ex.1 AUDIO: thumb, thimble
  p.15 Ex.3: photo, dolphin, elephant

Important for p.14: the official exercise audio contains the instruction
"Listen and repeat" and then the TWO recorded words thumb and thimble.
The Teacher's Book instructs the teacher to pronounce "the" and "this"
after the recording, so those two words must not be cut from track 12.

Files use a v5 suffix so a browser cannot reuse any older incorrect clip.
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
# Generous silence margins protect weak initial/final consonants.
CLIPS = [
    ('word_sheep_v5.mp3', 'sh', 19.095624, 19.880975, 'sheep', 0.35, 0.35),
    ('word_fish_v5.mp3', 'sh', 22.931361, 23.540907, 'fish', 0.65, 0.35),
    ('word_ship_v5.mp3', 'sh', 26.646916, 27.223039, 'ship', 0.40, 0.35),

    ('word_chick_v5.mp3', 'ch', 17.281224, 17.838073, 'chick', 0.35, 0.35),
    ('word_cheese_v5.mp3', 'ch', 21.533946, 22.394059, 'cheese', 0.35, 0.35),

    # Track 12 chunks after the instruction:
    # ~6.43 s = thumb, ~8.53 s = thimble.
    ('word_thumb_v5.mp3', 'th', 6.430396, 6.977083, 'thumb', 0.35, 0.35),
    ('word_thimble_v5.mp3', 'th', 8.529167, 9.170958, 'thimble', 0.35, 0.35),

    ('word_photo_v5.mp3', 'ph', 16.243923, 16.875556, 'photo', 0.40, 0.35),
    ('word_dolphin_v5.mp3', 'ph', 20.420204, 21.155601, 'dolphin', 0.35, 0.35),
    ('word_elephant_v5.mp3', 'ph', 24.557755, 25.391814, 'elephant', 0.35, 0.35),
]

OFFICIAL_BLEND_WORDS = [
    'sheep', 'fish', 'ship', 'chick', 'cheese',
    'thumb', 'thimble', 'photo', 'dolphin', 'elephant',
]
ALL_HISTORICAL_BLEND_WORDS = OFFICIAL_BLEND_WORDS + ['the', 'this']


def old_names() -> list[str]:
    names: list[str] = []
    for word in ALL_HISTORICAL_BLEND_WORDS:
        names.append(f'word_{word}.mp3')
        for version in ('v2', 'v3', 'v4'):
            names.append(f'word_{word}_{version}.mp3')
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
    print(f'Prepared {len(CLIPS)} verified official Spotlight blend words (v5).')
    print('the/this are intentionally NOT extracted from track 12.')


if __name__ == '__main__':
    main()
