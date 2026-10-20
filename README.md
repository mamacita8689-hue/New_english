# New English

Flutter-приложение для занятий по учебнику **«Английский в фокусе / Spotlight 2»**, 2 класс, часть 1.

Основная цель — помочь ребёнку тренировать буквы, звуки, буквосочетания и первые навыки чтения с аудио, максимально привязанным к Spotlight 2.

## Что уже есть

- алфавит A–Z;
- звуки букв;
- слова-примеры из разделов `My Letters`;
- отдельные уроки `SH`, `CH`, два варианта `TH` и `PH`;
- кнопки воспроизведения отдельных фонем;
- слова из Spotlight для SH / CH / PH;
- мини-тесты;
- тренировка распознавания звука и буквосочетания;
- упражнение на складывание слова по звукам.

## Аудио

Текущая стратегия:

- `My Letters` и названия букв — локальные фрагменты официального аудиоприложения Spotlight 2;
- фонемы `SH /ʃ/`, `CH /tʃ/`, `TH /θ/`, `TH /ð/`, `PH /f/` — отдельные локальные phonics-записи;
- слова `sheep`, `fish`, `ship`, `chick`, `cheese`, `photo`, `dolphin`, `elephant` — локальные фрагменты официального Spotlight;
- слова `thumb`, `thimble`, `the`, `this` — один британский `en-GB` TTS-голос;
- официальный ZIP не хранится в публичном репозитории.

Подробности: `AUDIO_MAPPING_SPOTLIGHT.md` и `AUDIO_SOURCES.md`.

## Подготовка локального аудио

Положи официальный архив части 1 в корень проекта под именем:

```text
spotlight2_part1.zip
```

Затем:

```bash
python3 tool/prepare_spotlight_core_audio.py spotlight2_part1.zip
python3 tool/prepare_spotlight_letter_blends.py spotlight2_part1.zip
python3 tool/prepare_phoneme_reference.py
python3 tool/verify_spotlight_audio.py
```

Проверка должна закончиться без ошибок и показать `Problems: 0`.

## Запуск в Codespaces

```bash
flutter clean
flutter pub get
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 3000
```

После изменения аудиофайлов в браузере полезно выполнить жёсткое обновление:

```text
Ctrl + Shift + R
```

## Важно

Оригинальные аудиофайлы издательства не публикуются в GitHub. Они используются только локально при подготовке приложения.
