#!/usr/bin/env python3
"""Audit local pronunciation files used by the app.

Run after:
  python3 tool/prepare_spotlight_core_audio.py spotlight2_part1.zip
  python3 tool/prepare_spotlight_letter_blends.py spotlight2_part1.zip
  python3 tool/prepare_phoneme_reference.py

The voiced-TH words "the" and "this" are intentionally excluded from the
official Spotlight clip list because the p.14 track does not contain separate
recordings of those words; the app falls back to en-GB TTS for them.
"""

from __future__ import annotations

import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SPOTLIGHT = ROOT / 'assets' / 'audio' / 'spotlight2_part1'
PHONICS = ROOT / 'assets' / 'audio' / 'phonics_reference'
LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
CORE_WORDS = [
    'ant', 'bed', 'cat', 'dog', 'egg', 'flag', 'glass', 'horse',
    'ink', 'jug', 'kangaroo', 'lamp', 'mouse', 'nest', 'orange', 'pin', 'queen',
    'rabbit', 'snake', 'tree', 'umbrella', 'vest', 'window', 'box', 'yacht', 'zip',
]
BLEND_WORDS_V3 = [
    'sheep', 'fish', 'ship', 'chick', 'cheese',
    'thumb', 'thimble', 'photo', 'dolphin', 'elephant',
]
PHONEME_REFERENCE = [
    'phoneme_sh.mp3', 'phoneme_ch.mp3',
    'phoneme_th_thing.mp3', 'phoneme_th_that.mp3', 'phoneme_f.mp3',
]

STALE = []
for word in [
    'sheep', 'fish', 'ship', 'chick', 'cheese', 'thumb', 'thimble',
    'the', 'this', 'photo', 'dolphin', 'elephant',
]:
    STALE += [f'word_{word}.mp3', f'word_{word}_v2.mp3']
STALE += ['phoneme_sh.mp3', 'phoneme_ch.mp3', 'phoneme_ph.mp3']


def duration(path: Path) -> float:
    raw = subprocess.check_output(
        [
            'ffprobe', '-v', 'error', '-show_entries', 'format=duration',
            '-of', 'json', str(path),
        ],
        text=True,
    )
    return float(json.loads(raw)['format']['duration'])


def main() -> None:
    required: list[Path] = []
    required += [SPOTLIGHT / f'letter_{letter}.mp3' for letter in LETTERS]
    required += [SPOTLIGHT / f'phoneme_{letter.lower()}.mp3' for letter in LETTERS]
    required += [SPOTLIGHT / f'word_{word}.mp3' for word in CORE_WORDS]
    required += [SPOTLIGHT / f'word_{word}_v3.mp3' for word in BLEND_WORDS_V3]
    required += [PHONICS / name for name in PHONEME_REFERENCE]

    problems: list[str] = []
    for path in required:
        if not path.is_file():
            problems.append(f'MISSING: {path.relative_to(ROOT)}')
            continue
        try:
            seconds = duration(path)
        except Exception as exc:
            problems.append(f'BROKEN: {path.relative_to(ROOT)} ({exc})')
            continue
        if seconds < 0.15:
            problems.append(f'TOO SHORT: {path.relative_to(ROOT)} ({seconds:.3f}s)')
        if seconds > 2.0:
            problems.append(f'SUSPICIOUSLY LONG: {path.relative_to(ROOT)} ({seconds:.3f}s)')

    for name in STALE:
        path = SPOTLIGHT / name
        if path.exists():
            problems.append(f'STALE: {path.relative_to(ROOT)}')

    print(f'Expected current audio files: {len(required)}')
    print(f'Problems: {len(problems)}')
    if problems:
        for problem in problems:
            print(problem)
        raise SystemExit(1)

    print('OK: all current local audio files are present and readable.')
    print('OK: no old v1/v2 Letter Blends clips remain.')
    print('NOTE: the/this use en-GB TTS because the official p.14 track has no separate clips for them.')


if __name__ == '__main__':
    main()
