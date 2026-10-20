#!/usr/bin/env python3
"""Download clean isolated UK phonics reference sounds used by blend lessons.

These files are separate from the official Spotlight word recordings. Spotlight
remains the source for the lesson vocabulary; these short files are used only
for the top "Послушать звук" button where an isolated phoneme is required.

Usage:
    python3 tool/prepare_phoneme_reference.py
"""

from __future__ import annotations

import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets' / 'audio' / 'phonics_reference'
BASE = 'https://raw.githubusercontent.com/minormending/learn-letters/main/audio'

FILES = {
    'phoneme_sh.mp3': 'sh.mp3',          # /ʃ/
    'phoneme_ch.mp3': 'ch-chair.mp3',    # /tʃ/
    'phoneme_th_thing.mp3': 'th-thing.mp3',  # /θ/
    'phoneme_th_that.mp3': 'th-that.mp3',    # /ð/
    'phoneme_f.mp3': 'f.mp3',            # /f/ for PH
}


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    for target_name, source_name in FILES.items():
        url = f'{BASE}/{source_name}'
        target = OUT / target_name
        print(f'download {url} -> {target.relative_to(ROOT)}')
        urllib.request.urlretrieve(url, target)
    print(f'Prepared {len(FILES)} isolated phoneme reference files.')


if __name__ == '__main__':
    main()
