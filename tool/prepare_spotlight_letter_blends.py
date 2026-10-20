#!/usr/bin/env python3
"""Prepare verified Spotlight 2 Part 1 Letter Blends word clips locally.

Usage:
    python3 tool/prepare_spotlight_letter_blends.py /path/to/official_part1.zip

The official tracks are kept local. This script creates cache-safe v2 word
files using exact silence-to-silence boundaries from the official archive.
No instruction audio ("Listen and repeat") is included.
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

# Exact speech chunks measured between the quiet gaps in the official files.
# Filename suffix _v2 intentionally prevents the browser from reusing old,
# incorrectly cut MP3 files from cache.
CLIPS = [
    ('word_sheep_v2.mp3', 'sh', 19.083946, 19.929410, 'sheep'),
    ('word_fish_v2.mp3', 'sh', 22.931361, 23.614830, 'fish'),
    ('word_ship_v2.mp3', 'sh', 26.639819, 27.252676, 'ship'),

    ('word_chick_v2.mp3', 'ch', 17.281224, 17.838073, 'chick'),
    ('word_cheese_v2.mp3', 'ch', 21.533946, 22.394059, 'cheese'),

    ('word_thumb_v2.mp3', 'th', 3.338646, 3.960375, 'thumb'),
    ('word_thimble_v2.mp3', 'th', 4.298083, 5.358083, 'thimble'),
    ('word_the_v2.mp3', 'th', 6.370833, 6.987000, 'the'),
    ('word_this_v2.mp3', 'th', 8.498729, 9.216250, 'this'),

    ('word_photo_v2.mp3', 'ph', 16.243923, 16.875556, 'photo'),
    ('word_dolphin_v2.mp3', 'ph', 20.420204, 21.155601, 'dolphin'),
    ('word_elephant_v2.mp3', 'ph', 24.557755, 25.391814, 'elephant'),
]

OLD_BLEND_FILES = [
    'word_sheep.mp3', 'word_fish.mp3', 'word_ship.mp3',
    'word_chick.mp3', 'word_cheese.mp3',
    'word_thumb.mp3', 'word_thimble.mp3', 'word_the.mp3', 'word_this.mp3',
    'word_photo.mp3', 'word_dolphin.mp3', 'word_elephant.mp3',
    'phoneme_sh.mp3', 'phoneme_ch.mp3', 'phoneme_ph.mp3',
]


def cut(source: Path, target: Path, start: float, end: float) -> None:
    """Cut exactly one verified utterance and re-encode it."""
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

    # Remove every old blend clip so it cannot be played accidentally.
    for name in OLD_BLEND_FILES:
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

        for file_name, track_key, start, end, word in CLIPS:
            source_name = TRACKS[track_key]
            source = tmp / source_name
            target = OUT / file_name
            cut(source, target, start, end)
            manifest.append({
                'file': file_name,
                'kind': 'word',
                'value': word,
                'source': source_name,
                'clip_start': start,
                'clip_end': end,
                'verified': True,
            })
            print(f'created {target.relative_to(ROOT)} <- {word}')

    (OUT / 'letter_blends_manifest.json').write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + '\n',
        encoding='utf-8',
    )
    print(f'Prepared {len(CLIPS)} cache-safe verified Spotlight blend words.')


if __name__ == '__main__':
    main()
