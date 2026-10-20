#!/usr/bin/env python3
"""Prepare audited Spotlight 2 Part 1 core pronunciation clips.

Usage:
    python3 tool/prepare_spotlight_core_audio.py /path/to/official_part1.zip

This version intentionally does NOT guess clip order from silence detection.
Every sound/word/letter interval below was checked against the official archive
and the printed Spotlight 2 order:

  My Letters A, p.6  : A-H  -> ant, bed, cat, dog, egg, flag, glass, horse
  My Letters B, p.8  : I-Q  -> ink, jug, kangaroo, lamp, mouse, nest, orange, pin, queen
  My Letters C, p.10 : R-Z  -> rabbit, snake, tree, umbrella, vest, window, box, yacht, zip
  Big and Small p.16 : A-Z letter names

The publisher audio remains local and is never committed.
Requirements: Python 3 and ffmpeg.
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
    'a_h': 'My Letters!/03 My Letters! A. Ex. 1, p. 6.mp3',
    'i_q': 'My Letters!/05 My Letters! B. Ex. 1, p. 8.mp3',
    'r_z': 'My Letters!/07 My Letters! C. Ex. 1, p. 10.mp3',
    'letters': 'Letter Blends!/14 Big and Small! F. Ex. 1, p. 16.mp3',
}

# (letter, phoneme_start, phoneme_end, word, word_start, word_end)
# Speech boundaries were audited against the official files. The short first
# item of each pair is the phoneme; the longer following item is the word.
MY_LETTERS = {
    'a_h': [
        ('A', 21.26, 21.68, 'ant', 24.29, 25.02),
        ('B', 27.57, 27.93, 'bed', 30.21, 30.67),
        ('C', 33.44, 33.85, 'cat', 36.14, 36.80),
        ('D', 39.13, 39.55, 'dog', 42.26, 42.76),
        ('E', 45.53, 45.91, 'egg', 48.25, 48.75),
        ('F', 51.35, 51.77, 'flag', 54.07, 54.72),
        ('G', 57.47, 58.02, 'glass', 60.79, 61.49),
        ('H', 64.12, 64.59, 'horse', 66.79, 67.57),
    ],
    'i_q': [
        ('I', 20.14, 20.58, 'ink', 23.28, 23.94),
        ('J', 26.75, 27.32, 'jug', 29.81, 30.55),
        ('K', 33.62, 34.09, 'kangaroo', 36.55, 37.49),
        ('L', 40.43, 40.92, 'lamp', 43.38, 44.19),
        ('M', 46.93, 47.47, 'mouse', 50.30, 51.11),
        ('N', 53.81, 54.41, 'nest', 56.84, 57.70),
        ('O', 60.57, 60.92, 'orange', 63.73, 64.44),
        ('P', 67.38, 67.79, 'pin', 70.45, 71.04),
        ('Q', 74.08, 74.61, 'queen', 77.23, 78.02),
    ],
    'r_z': [
        ('R', 19.62, 20.28, 'rabbit', 22.48, 23.53),
        ('S', 26.30, 26.92, 'snake', 28.88, 30.27),
        ('T', 32.85, 33.09, 'tree', 35.61, 36.63),
        ('U', 39.49, 39.98, 'umbrella', 42.21, 43.18),
        ('V', 45.69, 46.29, 'vest', 48.43, 49.71),
        ('W', 52.26, 52.89, 'window', 55.18, 56.06),
        ('X', 58.71, 59.66, 'box', 61.84, 62.78),
        ('Y', 65.43, 66.01, 'yacht', 68.32, 69.14),
        ('Z', 71.75, 72.42, 'zip', 74.56, 75.32),
    ],
}

# A-Z isolated letter names from track 14. These are the final 26 utterances.
LETTER_NAMES = [
    ('A', 17.573, 18.124), ('B', 20.114, 20.625),
    ('C', 22.725, 23.414), ('D', 25.562, 26.041),
    ('E', 28.379, 28.856), ('F', 31.196, 31.863),
    ('G', 33.807, 34.380), ('H', 36.464, 37.183),
    ('I', 39.220, 39.810), ('J', 41.948, 42.511),
    ('K', 44.608, 45.237), ('L', 47.577, 48.094),
    ('M', 50.433, 51.005), ('N', 53.600, 54.267),
    ('O', 56.039, 56.548), ('P', 58.505, 59.081),
    ('Q', 61.048, 61.640), ('R', 63.662, 64.327),
    ('S', 66.253, 67.163), ('T', 68.893, 69.419),
    ('U', 71.515, 72.056), ('V', 74.180, 74.786),
    ('W', 76.859, 77.674), ('X', 79.526, 80.421),
    ('Y', 81.989, 82.713), ('Z', 84.400, 85.044),
]


def cut(
    source: Path,
    target: Path,
    start: float,
    end: float,
    pad_before: float = 0.08,
    pad_after: float = 0.14,
) -> tuple[float, float]:
    """Cut accurately with small safe margins and re-encode to MP3."""
    real_start = max(0.0, start - pad_before)
    real_end = end + pad_after
    subprocess.run(
        [
            'ffmpeg', '-hide_banner', '-loglevel', 'error', '-y',
            '-i', str(source),
            '-ss', f'{real_start:.3f}',
            '-t', f'{real_end - real_start:.3f}',
            '-vn', '-codec:a', 'libmp3lame', '-q:a', '2', str(target),
        ],
        check=True,
    )
    return real_start, real_end


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit(
            'Usage: python3 tool/prepare_spotlight_core_audio.py <official_part1.zip>'
        )

    archive = Path(sys.argv[1]).expanduser().resolve()
    if not archive.is_file():
        raise SystemExit(f'Not found: {archive}')
    if shutil.which('ffmpeg') is None:
        raise SystemExit('ffmpeg is required')

    OUT.mkdir(parents=True, exist_ok=True)
    manifest: list[dict[str, object]] = []

    with tempfile.TemporaryDirectory(prefix='spotlight2_core_') as tmp_name:
        tmp = Path(tmp_name)
        with zipfile.ZipFile(archive) as zf:
            for source_name in TRACKS.values():
                try:
                    zf.extract(source_name, tmp)
                except KeyError as exc:
                    raise SystemExit(f'Required track is missing: {source_name}') from exc

        # Verified phoneme + word pairs.
        for track_key, rows in MY_LETTERS.items():
            source_name = TRACKS[track_key]
            source = tmp / source_name
            for letter, pa, pb, word, wa, wb in rows:
                phoneme_target = OUT / f'phoneme_{letter.lower()}.mp3'
                word_target = OUT / f'word_{word}.mp3'

                ps, pe = cut(source, phoneme_target, pa, pb)
                ws, we = cut(source, word_target, wa, wb, pad_after=0.18)

                manifest.append({
                    'file': phoneme_target.name,
                    'kind': 'phoneme',
                    'value': letter,
                    'source': source_name,
                    'clip_start': round(ps, 3),
                    'clip_end': round(pe, 3),
                    'verified': True,
                })
                manifest.append({
                    'file': word_target.name,
                    'kind': 'word',
                    'value': word,
                    'source': source_name,
                    'clip_start': round(ws, 3),
                    'clip_end': round(we, 3),
                    'verified': True,
                })

        # Verified letter names A-Z. Do not confuse these with phonemes above.
        source_name = TRACKS['letters']
        source = tmp / source_name
        for letter, a, b in LETTER_NAMES:
            target = OUT / f'letter_{letter}.mp3'
            start, end = cut(source, target, a, b)
            manifest.append({
                'file': target.name,
                'kind': 'letter_name',
                'value': letter,
                'source': source_name,
                'clip_start': round(start, 3),
                'clip_end': round(end, 3),
                'verified': True,
            })

    # Do not delete unrelated Spotlight files (for example SH/CH/TH/PH words).
    (OUT / 'core_manifest.local.json').write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + '\n',
        encoding='utf-8',
    )
    print(f'Prepared {len(manifest)} audited core clips in {OUT}')
    print('Existing Letter Blends clips were preserved.')


if __name__ == '__main__':
    main()
