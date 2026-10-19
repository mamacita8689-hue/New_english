#!/usr/bin/env python3
"""Prepare a local Spotlight 2 Part 1 audio archive for mapping into the app.

Usage:
    python tool/import_spotlight_audio.py /path/to/spotlight2_part1.zip

The script does NOT commit or publish publisher audio. It extracts audio locally
into .spotlight_audio_work/ and writes a text inventory so tracks can be mapped
to app asset names such as letter_A.mp3, word_cat.mp3, phoneme_sh.mp3.
"""

from __future__ import annotations

import shutil
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
WORK_DIR = ROOT / '.spotlight_audio_work'
INVENTORY = WORK_DIR / 'inventory.txt'
AUDIO_EXTS = {'.mp3', '.wav', '.m4a', '.aac', '.ogg', '.flac'}


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit('Usage: python tool/import_spotlight_audio.py <archive.zip|folder>')

    source = Path(sys.argv[1]).expanduser().resolve()
    if not source.exists():
        raise SystemExit(f'Not found: {source}')

    if WORK_DIR.exists():
        shutil.rmtree(WORK_DIR)
    WORK_DIR.mkdir(parents=True)

    extracted = WORK_DIR / 'source'
    extracted.mkdir()

    if source.is_dir():
        shutil.copytree(source, extracted, dirs_exist_ok=True)
    elif source.suffix.lower() == '.zip':
        with zipfile.ZipFile(source) as zf:
            zf.extractall(extracted)
    else:
        raise SystemExit('Please provide a ZIP archive or a folder with audio files.')

    files = sorted(
        p for p in extracted.rglob('*')
        if p.is_file() and p.suffix.lower() in AUDIO_EXTS
    )

    lines = [
        'Spotlight 2 Part 1 audio inventory',
        f'Files found: {len(files)}',
        '',
    ]
    for i, path in enumerate(files, 1):
        rel = path.relative_to(extracted)
        size_kb = path.stat().st_size / 1024
        lines.append(f'{i:03d}\t{size_kb:8.1f} KB\t{rel}')

    INVENTORY.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    print(f'Found {len(files)} audio files.')
    print(f'Inventory: {INVENTORY}')
    print('Next: identify the needed tracks/fragments, then copy prepared clips to:')
    print('  assets/audio/spotlight2_part1/')


if __name__ == '__main__':
    main()
