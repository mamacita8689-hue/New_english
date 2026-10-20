#!/usr/bin/env python3
"""Audit local pronunciation files used by the current app.

Run after:
  python3 tool/prepare_spotlight_core_audio.py spotlight2_part1.zip
  python3 tool/prepare_spotlight_letter_blends.py spotlight2_part1.zip
  python3 tool/prepare_phoneme_reference.py

Current strategy:
- My Letters: official Spotlight local clips;
- SH/CH/PH words: official Spotlight v5 local clips;
- SH/CH/TH/PH isolated phonemes: local phonics_reference files;
- thumb, thimble, the, this: en-GB TTS, so no local TH word files are required.
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
BLEND_WORDS_V5 = [
    'sheep', 'fish', 'ship', 'chick', 'cheese',
    'photo', 'dolphin', 'elephant',
]
TH_WORDS_TTS = ['thumb', 'thimble', 'the', 'this']
PHONEME_REFERENCE = [
    'phoneme_sh.mp3', 'phoneme_ch.mp3',
    'phoneme_th_thing.mp3', 'phoneme_th_that.mp3', 'phoneme_f.mp3',
]


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
    required += [SPOTLIGHT / f'word_{word}_v5.mp3' for word in BLEND_WORDS_V5]
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
        if seconds > 3.0:
            problems.append(f'SUSPICIOUSLY LONG: {path.relative_to(ROOT)} ({seconds:.3f}s)')

    # No TH word button should be backed by an old local Spotlight cut anymore.
    for word in TH_WORDS_TTS:
        candidates = [SPOTLIGHT / f'word_{word}.mp3']
        candidates += [SPOTLIGHT / f'word_{word}_{version}.mp3' for version in ('v2', 'v3', 'v4', 'v5')]
        for path in candidates:
            if path.exists():
                problems.append(f'STALE TH FILE: {path.relative_to(ROOT)}')

    # Old blend versions must also be gone for the file-backed words.
    for word in BLEND_WORDS_V5:
        for version in (None, 'v2', 'v3', 'v4'):
            suffix = '' if version is None else f'_{version}'
            path = SPOTLIGHT / f'word_{word}{suffix}.mp3'
            if path.exists():
                problems.append(f'STALE BLEND FILE: {path.relative_to(ROOT)}')

    for name in ('phoneme_sh.mp3', 'phoneme_ch.mp3', 'phoneme_ph.mp3'):
        path = SPOTLIGHT / name
        if path.exists():
            problems.append(f'STALE SPOTLIGHT PHONEME: {path.relative_to(ROOT)}')

    print(f'Expected local audio files: {len(required)}')
    print(f'Problems: {len(problems)}')
    if problems:
        for problem in problems:
            print(problem)
        raise SystemExit(1)

    print('OK: local audio files match the current application strategy.')
    print('NOTE: TH words use en-GB TTS and intentionally have no local Spotlight word clips.')


if __name__ == '__main__':
    main()
