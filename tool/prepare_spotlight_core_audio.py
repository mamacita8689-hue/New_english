#!/usr/bin/env python3
"""Prepare core Spotlight 2 Part 1 pronunciation clips from a local official ZIP.

The publisher audio itself is never committed. This script is intended to be run
locally against the user's legally obtained official audio archive.

It prepares:
- 26 letter-name clips from "Big and Small! F. Ex. 1, p. 16";
- 26 basic letter-sound clips from the three "My Letters! ... Ex. 1" tracks;
- 26 matching example-word clips from the same tracks.

Requirements: Python 3, ffmpeg, ffprobe.

Usage:
    python tool/prepare_spotlight_core_audio.py /path/to/part1.zip
"""

from __future__ import annotations

import json
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets' / 'audio' / 'spotlight2_part1'
LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
GROUPS = [
    ('03 ', 'ABCDEFGH', ['ant', 'bed', 'cat', 'dog', 'egg', 'flag', 'glass', 'horse']),
    ('05 ', 'IJKLMNOPQ', ['ink', 'jug', 'kangaroo', 'lamp', 'mouse', 'nest', 'orange', 'pin', 'queen']),
    ('07 ', 'RSTUVWXYZ', ['rabbit', 'snake', 'tree', 'umbrella', 'vest', 'window', 'box', 'yacht', 'zip']),
]


def run(cmd: list[str]) -> str:
    return subprocess.check_output(cmd, text=True, stderr=subprocess.STDOUT)


def duration(path: Path) -> float:
    data = json.loads(run([
        'ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 'json', str(path)
    ]))
    return float(data['format']['duration'])


def locate(root: Path, prefix: str) -> Path:
    matches = [p for p in root.rglob('*.mp3') if p.name.startswith(prefix)]
    if len(matches) != 1:
        raise RuntimeError(f'Expected exactly one track starting with {prefix!r}; found {len(matches)}')
    return matches[0]


def speech_chunks(path: Path, noise: str = '-45dB', min_silence: str = '0.35') -> list[tuple[float, float]]:
    total = duration(path)
    proc = subprocess.run([
        'ffmpeg', '-hide_banner', '-i', str(path),
        '-af', f'silencedetect=noise={noise}:d={min_silence}',
        '-f', 'null', '-'
    ], stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True, check=False)

    silences: list[tuple[float, float]] = []
    start: float | None = None
    for line in proc.stderr.splitlines():
        match = re.search(r'silence_(start|end): ([0-9.]+)', line)
        if not match:
            continue
        kind, raw_time = match.groups()
        t = float(raw_time)
        if kind == 'start':
            start = t
        elif start is not None:
            silences.append((start, t))
            start = None
    if start is not None:
        silences.append((start, total))

    chunks: list[tuple[float, float]] = []
    pos = 0.0
    for silence_start, silence_end in silences:
        if silence_start - pos > 0.18:
            chunks.append((pos, silence_start))
        pos = silence_end
    if total - pos > 0.18:
        chunks.append((pos, total))
    return chunks


def cut(source: Path, start: float, end: float, target: Path, pad: float = 0.10) -> tuple[float, float]:
    start = max(0.0, start - pad)
    end = min(duration(source), end + pad)
    subprocess.run([
        'ffmpeg', '-y', '-hide_banner', '-loglevel', 'error',
        '-ss', f'{start:.3f}', '-to', f'{end:.3f}', '-i', str(source),
        '-vn', '-codec:a', 'libmp3lame', '-q:a', '2', str(target)
    ], check=True)
    return start, end


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit('Usage: python tool/prepare_spotlight_core_audio.py <official_part1.zip>')

    archive = Path(sys.argv[1]).expanduser().resolve()
    if not archive.exists():
        raise SystemExit(f'Not found: {archive}')

    OUT.mkdir(parents=True, exist_ok=True)
    for old in OUT.glob('*.mp3'):
        old.unlink()

    manifest: list[dict[str, object]] = []
    with tempfile.TemporaryDirectory(prefix='spotlight2_') as tmp:
        source_root = Path(tmp)
        with zipfile.ZipFile(archive) as zf:
            zf.extractall(source_root)

        # The final 26 isolated speech chunks in this exercise are A-Z letter names.
        source = locate(source_root, '14 ')
        chunks = speech_chunks(source)
        if len(chunks) < 26:
            raise RuntimeError(f'Could not identify 26 letter-name chunks; found {len(chunks)}')
        for letter, (a, b) in zip(LETTERS, chunks[-26:]):
            target = OUT / f'letter_{letter}.mp3'
            start, end = cut(source, a, b, target)
            manifest.append({
                'file': target.name,
                'kind': 'letter_name',
                'value': letter,
                'source_track': source.name,
                'start': round(start, 3),
                'end': round(end, 3),
            })

        # In each My Letters Ex. 1 track, the trailing isolated chunks alternate
        # letter sound -> example word for the letters taught in that section.
        for prefix, letters, words in GROUPS:
            source = locate(source_root, prefix)
            chunks = speech_chunks(source)
            needed = 2 * len(letters)
            sequence = chunks[-needed:]
            if len(sequence) != needed:
                raise RuntimeError(f'{source.name}: expected {needed} usable chunks, got {len(sequence)}')

            for index, (letter, word) in enumerate(zip(letters, words)):
                sound_a, sound_b = sequence[index * 2]
                word_a, word_b = sequence[index * 2 + 1]

                phoneme = OUT / f'phoneme_{letter.lower()}.mp3'
                word_file = OUT / f'word_{word}.mp3'
                ps, pe = cut(source, sound_a, sound_b, phoneme)
                ws, we = cut(source, word_a, word_b, word_file)

                manifest.append({
                    'file': phoneme.name,
                    'kind': 'phoneme',
                    'value': letter,
                    'source_track': source.name,
                    'start': round(ps, 3),
                    'end': round(pe, 3),
                })
                manifest.append({
                    'file': word_file.name,
                    'kind': 'word',
                    'value': word,
                    'source_track': source.name,
                    'start': round(ws, 3),
                    'end': round(we, 3),
                })

    (OUT / 'manifest.local.json').write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2), encoding='utf-8'
    )
    print(f'Prepared {len(manifest)} clips in {OUT}')
    print('These audio files are intentionally ignored by git.')


if __name__ == '__main__':
    main()
