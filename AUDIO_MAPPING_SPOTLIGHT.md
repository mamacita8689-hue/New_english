# Актуальная карта аудио Spotlight 2 — часть 1

Эталон учебного материала: официальный архив «ФГОС 2021. Аудиоприложение к учебнику. 2 класс. Часть 1».

## My Letters

Стр. 6, дорожка 03:
- A → /æ/ → ant
- B → /b/ → bed
- C → /k/ → cat
- D → /d/ → dog
- E → /e/ → egg
- F → /f/ → flag
- G → /g/ → glass
- H → /h/ → horse

Стр. 8, дорожка 05:
- I → /ɪ/ → ink
- J → /dʒ/ → jug
- K → /k/ → kangaroo
- L → /l/ → lamp
- M → /m/ → mouse
- N → /n/ → nest
- O → /ɒ/ → orange
- P → /p/ → pin
- Q → /kw/ → queen

Стр. 10, дорожка 07:
- R → /r/ → rabbit
- S → /s/ → snake
- T → /t/ → tree
- U → /ʌ/ → umbrella
- V → /v/ → vest
- W → /w/ → window
- X → /ks/ → box
- Y → /j/ → yacht
- Z → /z/ → zip

Названия букв A–Z берутся отдельно из дорожки 14 «Big and Small! F. Ex. 1, p. 16». Название буквы и её звук не смешиваются.

## Letter Blends

### SH — стр. 12
- фонема: /ʃ/ — отдельная локальная phonics-запись;
- слова Spotlight: sheep, fish, ship — локальные фрагменты официального аудио.

### CH — стр. 13
- фонема: /tʃ/ — отдельная локальная phonics-запись;
- слова Spotlight: chick, cheese — локальные фрагменты официального аудио.

### TH — стр. 14
- /θ/: thumb, thimble;
- /ð/: the, this;
- обе фонемы воспроизводятся отдельными локальными phonics-записями;
- все четыре слова TH в текущей версии приложения озвучиваются одним голосом en-GB TTS.

Причина: предыдущие попытки использовать короткие фрагменты дорожки 12 давали неправильные соответствия слов при ручной проверке. Чтобы исключить ложные привязки и старый кэш, локальные TH-word clips больше не используются приложением.

### PH — стр. 15
- фонема: /f/ — отдельная локальная phonics-запись;
- слова Spotlight: photo, dolphin, elephant — локальные фрагменты официального аудио.

## Текущая аудиостратегия приложения

1. `My Letters`: официальные локальные фрагменты Spotlight.
2. Названия букв: официальные локальные фрагменты Spotlight.
3. Изолированные SH/CH/TH/PH: `assets/audio/phonics_reference/`.
4. SH/CH/PH слова: официальные локальные Spotlight-фрагменты с суффиксом `_v5`.
5. TH слова `thumb`, `thimble`, `the`, `this`: en-GB TTS.
6. Если нужного локального слова нет, `LessonAudioService` использует en-GB TTS как резерв.

## Локальная подготовка

```bash
python3 tool/prepare_spotlight_core_audio.py spotlight2_part1.zip
python3 tool/prepare_spotlight_letter_blends.py spotlight2_part1.zip
python3 tool/prepare_phoneme_reference.py
python3 tool/verify_spotlight_audio.py
```

Проверка должна завершиться `Problems: 0` и сообщением `OK`.

Оригинальные аудиофайлы издательства не публикуются в GitHub и хранятся только локально.
