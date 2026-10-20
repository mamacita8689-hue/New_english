#!/usr/bin/env python3
"""Verify that all locally prepared Spotlight 2 Part 1 audio files exist.

Run after:
  python3 tool/prepare_spotlight_core_audio.py spotlight2_part1.zip
  python3 tool/prepare_spotlight_letter_blends.py spotlight2_part1.zip

This does not judge pronunciation automatically; it verifies the audited mapping
set, file presence, non-trivial duration and absence of known stale/mislabelled
experimental SH/CH/PH phoneme cuts.
"""

from __future__ import annotations

import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
AUDIO = ROOT / 'assets' / 'audio' / 'spotlight2_part1'
LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
CORE_WORDS = [
    'ant', 'bed', 'cat', 'dog', 'egg', 'flag', 'glass', 'horse',
    'ink', 'jug', 'kangaroo', 'lamp', 'mouse', 'nest', 'orange', 'pin', 'queen',
    'rabbit', 'snake', 'tree', 'umbrella', 'vest', 'window', 'box', 'yacht', 'zip',
]
BLEND_WORDS = [
    'sheep', 'fish', 'ship', 'chick', 'cheese',
    'thumb', 'thimble', 'the', 'this',
    'photo', 'dolphin', 'elephant',
]
STALE = ['phoneme_sh.mp3', 'phoneme_ch.mp3', 'phoneme_ph.mp3']


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
    required = []
    required += [AUDIO / f'letter_{letter}.mp3' for letter in LETTERS]
    required += [AUDIO / f'phoneme_{letter.lower()}.mp3' for letter in LETTERS]
    required += [AUDIO / f'word_{word}.mp3' for word in CORE_WORDS]
    required += [AUDIO / f'word_{word}.mp3' for word in BLEND_WORDS]

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
        if seconds < 0.20:
            problems.append(
                f'TOO SHORT: {path.relative_to(ROOT)} ({seconds:.3f}s)'
            )

    for name in STALE:
        path = AUDIO / name
        if path.exists():
            problems.append(
                f'STALE/MISLABELLED: {path.relative_to(ROOT)} — delete/regenerate blends'
            )

    print(f'Expected audited files: {len(required)}')
    print(f'Problems: {len(problems)}')
    if problems:
        for problem in problems:
            print(problem)
        raise SystemExit(1)

    print('OK: Spotlight audio file set is complete and stale SH/CH/PH cuts are absent.')


if __name__ == '__main__':
    main()
