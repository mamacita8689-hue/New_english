#!/usr/bin/env python3
"""Generate all audio that is bundled into the APK.

Words and letter names are rendered once with a consistent British neural voice.
Phonics recordings are downloaded once during the build and then packaged as assets.
The installed Android app does not need the network for pronunciation.
"""

from __future__ import annotations

import asyncio
import os
import re
import time
import urllib.error
import urllib.request
from pathlib import Path

import edge_tts

ROOT = Path(__file__).resolve().parents[1]
AUDIO_DIR = ROOT / "assets" / "audio"
DATA_DIR = ROOT / "lib" / "data"
VOICE = os.environ.get("OFFLINE_TTS_VOICE", "en-GB-SoniaNeural")

PHONICS_REMOTE_BASE = (
    "https://raw.githubusercontent.com/minormending/learn-letters/main/audio"
)

# Local logical name -> real filename in the phonics source repository.
# The source intentionally has no k.mp3, q.mp3 or x.mp3. In the app:
#   K uses the same /k/ recording as C;
#   Q is built from /k/ + /w/;
#   X is built from /k/ + /s/.
PHONEMES = {
    "a": "a.mp3",
    "b": "b.mp3",
    "c": "c.mp3",
    "d": "d.mp3",
    "e": "e.mp3",
    "f": "f.mp3",
    "g": "g.mp3",
    "h": "h.mp3",
    "i": "i.mp3",
    "j": "j.mp3",
    "l": "l.mp3",
    "m": "m.mp3",
    "n": "n.mp3",
    "o": "o.mp3",
    "p": "p.mp3",
    "r": "r.mp3",
    "s": "s.mp3",
    "t": "t.mp3",
    "u": "u.mp3",
    "v": "v.mp3",
    "w": "w.mp3",
    "y": "y.mp3",
    "z": "z.mp3",
    "sh": "sh.mp3",
    "ch": "ch-chair.mp3",
    "th_thing": "th-thing.mp3",
    "th_that": "th-that.mp3",
    "ng": "ng.mp3",
    "ee": "ee.mp3",
    "oo_moon": "oo-moon.mp3",
    "oo_book": "oo-book.mp3",
    "ai": "ai.mp3",
    "oa": "oa.mp3",
}

LETTER_NAMES = {
    "A": "ay",
    "B": "bee",
    "C": "see",
    "D": "dee",
    "E": "ee",
    "F": "ef",
    "G": "gee",
    "H": "aitch",
    "I": "eye",
    "J": "jay",
    "K": "kay",
    "L": "el",
    "M": "em",
    "N": "en",
    "O": "oh",
    "P": "pee",
    "Q": "cue",
    "R": "are",
    "S": "ess",
    "T": "tee",
    "U": "you",
    "V": "vee",
    "W": "double u",
    "X": "ex",
    "Y": "why",
    "Z": "zed",
}


def safe_name(text: str) -> str:
    text = text.strip().lower()
    return re.sub(r"[^a-z0-9]+", "_", text).strip("_")


def collect_words() -> list[str]:
    words: set[str] = set()
    for path in DATA_DIR.glob("*.dart"):
        text = path.read_text(encoding="utf-8")
        words.update(re.findall(r"\bword:\s*'([^']+)'", text))
        words.update(re.findall(r"\bexample:\s*'([^']+)'", text))
    return sorted(words)


def download_with_retries(url: str, target: Path, attempts: int = 3) -> None:
    last_error: Exception | None = None
    for attempt in range(1, attempts + 1):
        try:
            urllib.request.urlretrieve(url, target)
            return
        except (urllib.error.URLError, urllib.error.HTTPError) as exc:
            last_error = exc
            if attempt < attempts:
                time.sleep(attempt * 2)
    raise RuntimeError(f"Failed to download {url}") from last_error


def download_phonemes() -> None:
    AUDIO_DIR.mkdir(parents=True, exist_ok=True)
    for logical_name, remote_name in PHONEMES.items():
        target = AUDIO_DIR / f"phoneme_{logical_name}.mp3"
        url = f"{PHONICS_REMOTE_BASE}/{remote_name}"
        print(f"phoneme {logical_name}: {url}")
        download_with_retries(url, target)


async def render(text: str, target: Path, rate: str) -> None:
    print(f"tts {target.name}: {text!r} [{VOICE}]")
    communicate = edge_tts.Communicate(text=text, voice=VOICE, rate=rate)
    await communicate.save(str(target))


async def render_tts_assets() -> None:
    AUDIO_DIR.mkdir(parents=True, exist_ok=True)

    for letter, spoken in LETTER_NAMES.items():
        await render(spoken, AUDIO_DIR / f"letter_{letter}.mp3", rate="-5%")

    for word in collect_words():
        name = safe_name(word)
        if not name:
            continue
        await render(word, AUDIO_DIR / f"word_{name}.mp3", rate="-3%")


def main() -> None:
    print(f"Generating offline audio with voice: {VOICE}")
    download_phonemes()
    asyncio.run(render_tts_assets())
    files = list(AUDIO_DIR.glob("*.mp3"))
    print(f"Generated {len(files)} MP3 files in {AUDIO_DIR}")


if __name__ == "__main__":
    main()
