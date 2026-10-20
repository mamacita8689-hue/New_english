#!/usr/bin/env python3
"""Prepare verified Spotlight 2 Part 1 Letter Blends word clips locally.

Usage:
    python3 tool/prepare_spotlight_letter_blends.py /path/to/official_part1.zip

The archive stays local. The mapping below follows the actual official tracks:
  p.12 Ex.1: sheep, fish, ship
  p.13 Ex.3: chick, cheese
  p.14 Ex.1: thumb, thimble
  p.15 Ex.3: photo, dolphin, elephant

Important: the official p.14 audio track does NOT contain isolated recordings
of "the" and "this". Those words are handled separately in the app instead of
being falsely mapped onto "Listen / repeat / thumb / thimble".

Files use a v3 suffix so browsers cannot reuse older incorrectly cut clips.
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

# Verified speech intervals from the official archive. A safe amount of the
# surrounding silence is included so weak consonants such as initial /f/ in
# "fish" and final stop bursts are not clipped.
# (filename, track, speech_start, speech_end, word, pad_before, pad_after)
CLIPS = [
    ('word_sheep_v3.mp3', 'sh', 19.095624, 19.880975, 'sheep', 0.18, 0.16),
    ('word_fish_v3.mp3', 'sh', 22.931361, 23.540907, 'fish', 0.28, 0.18),
    ('word_ship_v3.mp3', 'sh', 26.646916, 27.223039, 'ship', 0.22, 0.18),

    ('word_chick_v3.mp3', 'ch', 17.282336, 17.800635, 'chick', 0.18, 0.18),
    ('word_cheese_v3.mp3', 'ch', 21.533968, 22.363741, 'cheese', 0.18, 0.18),

    # Track 12 structure is:
    # 1.129-2.539 intro, 3.360-3.946 "Listen", 4.329-5.337 "repeat",
    # 6.430-6.977 "thumb", 8.529-9.171 "thimble".
    ('word_thumb_v3.mp3', 'th', 6.430396, 6.977083, 'thumb', 0.20, 0.20),
    ('word_thimble_v3.mp3', 'th', 8.529167, 9.170958, 'thimble', 0.20, 0.20),

    ('word_photo_v3.mp3', 'ph', 16.264717, 16.865918, 'photo', 0.18, 0.18),
    ('word_dolphin_v3.mp3', 'ph', 20.420363, 21.119388, 'dolphin', 0.18, 0.18),
    ('word_elephant_v3.mp3', 'ph', 24.557868, 25.353152, 'elephant', 0.18, 0.18),
]

# Remove every previous experimental version so no stale file can be selected.
OLD_BLEND_FILES = [
    *(f'word_{w}.mp3' for w in [
        'sheep', 'fish', 'ship', 'chick', 'cheese', 'thumb', 'thimble',
        'the', 'this', 'photo', 'dolphin', 'elephant',
    ]),
    *(f'word_{w}_v2.mp3' for w in [
        'sheep', 'fish', 'ship', 'chick', 'cheese', 'thumb', 'thimble',
        'the', 'this', 'photo', 'dolphin', 'elephant',
    ]),
    'phoneme_sh.mp3', 'phoneme_ch.mp3', 'phoneme_ph.mp3',
]


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

        for file_name, track_key, speech_start, speech_end, word, before, after in CLIPS:
            source_name = TRACKS[track_key]
            source = tmp / source_name
            target = OUT / file_name
            start, end = cut(
                source, target, speech_start, speech_end, before, after,
            )
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
    print(f'Prepared {len(CLIPS)} verified Spotlight blend words (v3).')
    print('Voiced TH words "the" and "this" are intentionally not cut from track 12.')


if __name__ == '__main__':
    main()
