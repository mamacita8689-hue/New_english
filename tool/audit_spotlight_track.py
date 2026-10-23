#!/usr/bin/env python3
"""Create a manual auditor for one official Spotlight audio track.

The tool never guesses which word is inside a fragment. It only:
1. finds one MP3 inside the official Spotlight ZIP by name fragment;
2. detects pauses with ffmpeg;
3. cuts the track into numbered speech fragments;
4. creates a local HTML page where every fragment can be listened to and labelled;
5. lets the reviewer export the labels as JSON.

Example for the TH page:
    python3 tool/audit_spotlight_track.py \
        "/workspaces/New_english/ФГОС+2021.+Аудиоприложение+к+учебнику.+2+класс.+Часть+1.zip" \
        --match "p. 14"

Then open:
    audio_manual_audit/index.html

Requirements:
- Python 3
- ffmpeg / ffprobe in PATH

Official publisher audio stays local and must not be committed.
"""

from __future__ import annotations

import argparse
import html
import json
import re
import shutil
import subprocess
import tempfile
import zipfile
from dataclasses import dataclass, asdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OUT = ROOT / "audio_manual_audit"


@dataclass
class Fragment:
    number: int
    start: float
    end: float
    duration: float
    file: str
    label: str = ""
    verified: bool = False


def run(cmd: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, check=True, text=True, capture_output=True)


def media_duration(path: Path) -> float:
    result = run([
        "ffprobe", "-v", "error", "-show_entries", "format=duration",
        "-of", "default=noprint_wrappers=1:nokey=1", str(path),
    ])
    return float(result.stdout.strip())


def choose_track(zf: zipfile.ZipFile, match: str) -> str:
    mp3s = [name for name in zf.namelist() if name.lower().endswith(".mp3")]
    matches = [name for name in mp3s if match.lower() in name.lower()]
    if not matches:
        preview = "\n".join(f"  {name}" for name in mp3s[:80])
        raise SystemExit(
            f"No MP3 matched {match!r}. Available MP3 files include:\n{preview}"
        )
    if len(matches) > 1:
        listing = "\n".join(f"  {name}" for name in matches)
        raise SystemExit(
            f"More than one MP3 matched {match!r}. Use a more specific --match value:\n{listing}"
        )
    return matches[0]


def detect_silences(path: Path, noise_db: float, min_silence: float) -> list[tuple[float, float]]:
    proc = subprocess.run(
        [
            "ffmpeg", "-hide_banner", "-i", str(path),
            "-af", f"silencedetect=noise={noise_db}dB:d={min_silence}",
            "-f", "null", "-",
        ],
        text=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
    )
    if proc.returncode not in (0, 1):
        raise SystemExit(proc.stderr)

    starts: list[float] = []
    silences: list[tuple[float, float]] = []
    for line in proc.stderr.splitlines():
        m_start = re.search(r"silence_start:\s*([0-9.]+)", line)
        if m_start:
            starts.append(float(m_start.group(1)))
            continue
        m_end = re.search(r"silence_end:\s*([0-9.]+)", line)
        if m_end and starts:
            silences.append((starts.pop(0), float(m_end.group(1))))
    return silences


def speech_ranges(
    total: float,
    silences: list[tuple[float, float]],
    min_fragment: float,
    pad: float,
) -> list[tuple[float, float]]:
    boundaries: list[tuple[float, float]] = []
    cursor = 0.0
    for silence_start, silence_end in silences:
        if silence_start > cursor:
            boundaries.append((cursor, silence_start))
        cursor = max(cursor, silence_end)
    if cursor < total:
        boundaries.append((cursor, total))

    result: list[tuple[float, float]] = []
    for start, end in boundaries:
        if end - start < min_fragment:
            continue
        result.append((max(0.0, start - pad), min(total, end + pad)))
    return result


def cut(source: Path, target: Path, start: float, end: float) -> None:
    target.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        [
            "ffmpeg", "-hide_banner", "-loglevel", "error", "-y",
            "-i", str(source), "-ss", f"{start:.3f}",
            "-t", f"{end - start:.3f}", "-vn", "-codec:a", "libmp3lame",
            "-q:a", "2", str(target),
        ],
        check=True,
    )


def build_html(track_name: str, fragments: list[Fragment]) -> str:
    rows = []
    for item in fragments:
        rows.append(f"""
        <article class=\"fragment\" data-number=\"{item.number}\">
          <div class=\"head\"><strong>Фрагмент {item.number}</strong><span>{item.start:.2f}–{item.end:.2f} с</span></div>
          <audio controls preload=\"none\" src=\"{html.escape(item.file)}\"></audio>
          <input class=\"label\" type=\"text\" placeholder=\"Что произнесено? Например: thumb / Listen / repeat\">
          <label class=\"verified\"><input type=\"checkbox\"> Проверено вручную</label>
        </article>
        """)

    manifest = json.dumps([asdict(x) for x in fragments], ensure_ascii=False)
    return f"""<!doctype html>
<html lang=\"ru\">
<head>
<meta charset=\"utf-8\">
<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">
<title>Spotlight audio auditor</title>
<style>
body{{font-family:system-ui,sans-serif;max-width:900px;margin:32px auto;padding:0 16px;background:#f5f6f8;color:#202124}}
.fragment{{background:white;border:1px solid #ddd;border-radius:12px;padding:14px;margin:12px 0}}
.head{{display:flex;justify-content:space-between;gap:16px;margin-bottom:8px}}
audio{{width:100%}}
.label{{box-sizing:border-box;width:100%;margin-top:10px;padding:10px;font-size:16px}}
.verified{{display:block;margin-top:10px}}
button{{padding:10px 16px;font-size:16px;cursor:pointer}}
.note{{background:#fff3cd;border-radius:10px;padding:12px}}
</style>
</head>
<body>
<h1>Spotlight: ручная проверка аудио</h1>
<p><b>Дорожка:</b> {html.escape(track_name)}</p>
<p class=\"note\">Не ориентируйтесь на имя файла и порядок слов. Прослушайте каждый фрагмент и подпишите только то, что реально слышно.</p>
<button id=\"save\">Сохранить проверку в JSON</button>
<div id=\"list\">{''.join(rows)}</div>
<script>
const base = {manifest};
document.getElementById('save').addEventListener('click', () => {{
  const result = base.map((item, i) => {{
    const card = document.querySelectorAll('.fragment')[i];
    return {{...item,
      label: card.querySelector('.label').value.trim(),
      verified: card.querySelector('.verified input').checked
    }};
  }});
  const blob = new Blob([JSON.stringify(result, null, 2)], {{type:'application/json'}});
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = 'spotlight_audio_review.json';
  a.click();
  URL.revokeObjectURL(a.href);
}});
</script>
</body>
</html>
"""


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("archive", type=Path, help="Official Spotlight 2 Part 1 ZIP")
    parser.add_argument("--match", default="p. 14", help="Unique substring of track name")
    parser.add_argument("--out", type=Path, default=DEFAULT_OUT)
    parser.add_argument("--noise-db", type=float, default=-38.0)
    parser.add_argument("--min-silence", type=float, default=0.28)
    parser.add_argument("--min-fragment", type=float, default=0.18)
    parser.add_argument("--pad", type=float, default=0.08)
    args = parser.parse_args()

    archive = args.archive.expanduser().resolve()
    if not archive.is_file():
        raise SystemExit(f"Archive not found: {archive}")
    if shutil.which("ffmpeg") is None or shutil.which("ffprobe") is None:
        raise SystemExit("ffmpeg and ffprobe are required")

    out = args.out.expanduser().resolve()
    if out.exists():
        shutil.rmtree(out)
    (out / "fragments").mkdir(parents=True)

    with tempfile.TemporaryDirectory(prefix="spotlight_audit_") as tmp_name:
        tmp = Path(tmp_name)
        with zipfile.ZipFile(archive) as zf:
            track_name = choose_track(zf, args.match)
            zf.extract(track_name, tmp)
        source = tmp / track_name
        total = media_duration(source)
        silences = detect_silences(source, args.noise_db, args.min_silence)
        ranges = speech_ranges(total, silences, args.min_fragment, args.pad)

        fragments: list[Fragment] = []
        for idx, (start, end) in enumerate(ranges, start=1):
            rel = f"fragments/fragment_{idx:03d}.mp3"
            cut(source, out / rel, start, end)
            fragments.append(Fragment(idx, round(start, 3), round(end, 3), round(end-start, 3), rel))

    (out / "manifest.json").write_text(
        json.dumps([asdict(x) for x in fragments], ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    (out / "index.html").write_text(build_html(track_name, fragments), encoding="utf-8")

    print(f"Track: {track_name}")
    print(f"Fragments: {len(fragments)}")
    print(f"Open: {out / 'index.html'}")
    print("Listen to every fragment, label it, tick 'Проверено вручную', then export JSON.")


if __name__ == "__main__":
    main()
