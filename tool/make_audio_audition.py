#!/usr/bin/env python3
from __future__ import annotations

import asyncio
import shutil
import urllib.request
from pathlib import Path

import edge_tts

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "audio_audition"

VOICES = {
    "Sonia": "en-GB-SoniaNeural",
    "Libby": "en-GB-LibbyNeural",
    "Maisie": "en-GB-MaisieNeural",
}

LETTER_NAMES = [
    ("A", "ay"),
    ("H", "aitch"),
    ("R", "are"),
    ("W", "double u"),
    ("Y", "why"),
    ("Z", "zed"),
]

WORDS = [
    "queen",
    "apple",
    "dog",
    "ship",
    "fish",
    "three",
    "this",
    "ring",
    "green",
    "moon",
    "book",
    "road",
    "chair",
    "mother",
    "father",
]

PHONICS_BASE = "https://raw.githubusercontent.com/minormending/learn-letters/main/audio"
PHONICS = [
    ("01_a_short", "a.mp3"),
    ("02_e_short", "e.mp3"),
    ("03_i_short", "i.mp3"),
    ("04_o_short", "o.mp3"),
    ("05_u_short", "u.mp3"),
    ("06_sh", "sh.mp3"),
    ("07_ch", "ch-chair.mp3"),
    ("08_th_thing", "th-thing.mp3"),
    ("09_th_that", "th-that.mp3"),
    ("10_ng", "ng.mp3"),
    ("11_ee", "ee.mp3"),
    ("12_oo_moon", "oo-moon.mp3"),
    ("13_oo_book", "oo-book.mp3"),
    ("14_ai", "ai.mp3"),
    ("15_oa", "oa.mp3"),
]


async def render(text: str, voice: str, target: Path) -> None:
    target.parent.mkdir(parents=True, exist_ok=True)
    communicate = edge_tts.Communicate(text=text, voice=voice, rate="-3%")
    await communicate.save(str(target))


async def main() -> None:
    if OUT.exists():
        shutil.rmtree(OUT)
    OUT.mkdir(parents=True)

    readme = OUT / "README.txt"
    readme.write_text(
        "ТЕСТ ПРОИЗНОШЕНИЯ\n\n"
        "Папки Sonia, Libby, Maisie содержат одинаковые британские слова и названия букв.\n"
        "Слушайте одинаковые номера подряд и выбирайте голос, который звучит наиболее естественно для ребёнка.\n\n"
        "Phonics — отдельные записанные звуки для обучения чтению.\n"
        "Это тестовый набор: сначала выбираем качество и стиль, затем только переносим выбранный вариант в приложение.\n",
        encoding="utf-8",
    )

    for display_name, voice in VOICES.items():
        folder = OUT / display_name
        folder.mkdir(parents=True, exist_ok=True)

        for idx, (letter, spoken) in enumerate(LETTER_NAMES, start=1):
            await render(spoken, voice, folder / f"L{idx:02d}_{letter}.mp3")

        for idx, word in enumerate(WORDS, start=1):
            await render(word, voice, folder / f"W{idx:02d}_{word}.mp3")

    phonics_folder = OUT / "Phonics"
    phonics_folder.mkdir(parents=True, exist_ok=True)
    for logical_name, remote_name in PHONICS:
        url = f"{PHONICS_BASE}/{remote_name}"
        target = phonics_folder / f"{logical_name}.mp3"
        print(f"Downloading {url}")
        urllib.request.urlretrieve(url, target)

    print(f"Created audition pack at {OUT}")


if __name__ == "__main__":
    asyncio.run(main())
